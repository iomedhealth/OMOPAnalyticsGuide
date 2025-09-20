# Page: Cohort Diagnostics

# Cohort Diagnostics

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/cohortDiagnostics.R](R/cohortDiagnostics.R)
- [man/cohortDiagnostics.Rd](man/cohortDiagnostics.Rd)
- [tests/testthat/test-cohortDiagnostics.R](tests/testthat/test-cohortDiagnostics.R)
- [tests/testthat/test-phenotypeDiagnostics.R](tests/testthat/test-phenotypeDiagnostics.R)

</details>



This page documents the cohort-level diagnostic functionality within PhenotypeR's core diagnostic engine. The cohort diagnostics module performs comprehensive analysis of cohort composition, characteristics, and quality, providing essential insights for phenotype validation and research-readiness assessment.

For database-level analysis and population incidence/prevalence calculations, see [Database and Population Diagnostics](#2.4). For codelist-specific diagnostics, see [Codelist Diagnostics](#2.3).

## Purpose and Scope

The `cohortDiagnostics()` function serves as the primary entry point for cohort-level analysis within the PhenotypeR diagnostic framework. It performs multi-dimensional analysis of cohort composition including demographics, clinical characteristics, temporal patterns, and survival outcomes. The module automatically adapts its analysis strategy based on cohort count and implements sampling strategies for computational efficiency.

**Sources:** [R/cohortDiagnostics.R:1-48]()

## Core Diagnostic Workflow

The cohort diagnostics system follows a structured analysis pipeline that progresses from basic cohort metrics to complex multi-cohort comparisons:

```mermaid
flowchart TD
    A["cohortDiagnostics()"] --> B["Initial Validation"]
    B --> C["Basic Cohort Metrics"]
    C --> D["Cohort Sampling"]
    D --> E{"Multiple Cohorts?"}
    
    E -->|Yes| F["Multi-Cohort Analysis"]
    E -->|No| G["Single Cohort Path"]
    
    F --> H["Cohort Overlap Analysis"]
    F --> I["Cohort Timing Analysis"]
    
    G --> J["Matched Cohort Creation"]
    H --> J
    I --> J
    
    J --> K["Demographics & Characteristics"]
    K --> L["Age Density Calculation"]
    L --> M["Large Scale Characteristics"]
    M --> N{"Survival Enabled?"}
    
    N -->|Yes| O["Survival Analysis"]
    N -->|No| P["Results Assembly"]
    O --> P
    
    P --> Q["summarised_result"]
    
    style A fill:#e1f5fe,stroke:#01579b,stroke-width:3px
    style E fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
    style N fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
```

**Sources:** [R/cohortDiagnostics.R:31-204]()

## Analysis Components

The cohort diagnostics module performs several distinct types of analysis, each targeting different aspects of cohort composition and quality:

### Basic Cohort Metrics

| Analysis Type | Function Call | Description |
|---------------|---------------|-------------|
| Cohort Attrition | `CohortCharacteristics::summariseCohortAttrition()` | Tracks cohort construction steps and exclusions |
| Cohort Count | `CohortCharacteristics::summariseCohortCount()` | Provides basic cohort size metrics |

**Sources:** [R/cohortDiagnostics.R:48-54]()

### Multi-Cohort Analysis

For scenarios with multiple cohorts, additional comparative analyses are performed:

```mermaid
graph TB
    A["Multiple Cohorts Detected"] --> B["summariseCohortOverlap()"]
    A --> C["summariseCohortTiming()"]
    
    B --> D["Overlap Metrics"]
    C --> E["Temporal Relationships"]
    
    D --> F["Cohort Intersection Counts"]
    D --> G["Overlap Percentages"]
    
    E --> H["Time-to-Event Analysis"]
    E --> I["Sequence Analysis"]
    
    style A fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
```

**Sources:** [R/cohortDiagnostics.R:75-84]()

### Demographics and Characteristics

The system performs comprehensive demographic analysis with stratification:

```mermaid
flowchart LR
    A["addDemographics()"] --> B["Age Groups"]
    A --> C["Sex Distribution"]
    A --> D["Prior Observation"]
    
    B --> E["0-17, 18-64, 65+"]
    
    F["summariseCharacteristics()"] --> G["Age Group Strata"]
    F --> H["Sex Strata"]
    F --> I["Visit Count Analysis"]
    
    I --> J["Prior Year Visits"]
    
    style A fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    style F fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
```

**Sources:** [R/cohortDiagnostics.R:96-116]()

### Large Scale Characteristics

The module performs comprehensive clinical event analysis across multiple time windows:

| Time Window | Description | OMOP Tables |
|-------------|-------------|-------------|
| `c(-Inf, -366)` | More than 1 year prior | condition_occurrence, visit_occurrence, measurement, procedure_occurrence, observation, drug_exposure |
| `c(-365, -31)` | 1 year to 1 month prior | Same as above |
| `c(-30, -1)` | 30 days prior | Same as above |
| `c(0, 0)` | Index date | Same as above |
| `c(1, 30)` | 30 days after | Same as above |
| `c(31, 365)` | 1 month to 1 year after | Same as above |
| `c(366, Inf)` | More than 1 year after | Same as above |

**Sources:** [R/cohortDiagnostics.R:131-163]()

## Sampling Strategies

The cohort diagnostics system implements intelligent sampling to manage computational complexity while preserving analytical validity:

### Cohort Sampling

The `cohortSample` parameter controls the maximum number of individuals included in detailed analysis:

```mermaid
graph TD
    A["Check Cohort Sizes"] --> B{"Size > cohortSample?"}
    B -->|No| C["Use Full Cohort"]
    B -->|Yes| D["Sample to cohortSample"]
    
    D --> E["sampleCohorts()"]
    C --> F["copyCohorts()"]
    E --> F
    
    F --> G["Sampled Cohort Table"]
    
    style B fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
```

**Sources:** [R/cohortDiagnostics.R:56-73]()

### Matched Cohort Generation

For comparative analysis, the system creates age and sex-matched control cohorts:

```mermaid
flowchart TD
    A["createMatchedCohorts()"] --> B["For Each Cohort ID"]
    B --> C["subsetCohorts()"]
    C --> D{"matchedSample != NULL?"}
    
    D -->|Yes| E["sampleCohorts()"]
    D -->|No| F["Use Full Cohort"]
    
    E --> G["matchCohorts()"]
    F --> G
    
    G --> H["Age/Sex Matched Cohort"]
    H --> I["bind() with Main Cohort"]
    
    style D fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
```

**Sources:** [R/cohortDiagnostics.R:206-238]()

## Survival Analysis Integration

When the `survival` parameter is enabled, the system performs comprehensive survival analysis:

```mermaid
graph TB
    A["survival = TRUE"] --> B{"Death Table Exists?"}
    B -->|No| C["Skip Survival Analysis"]
    B -->|Yes| D{"Death Table Empty?"}
    
    D -->|Yes| E["Warning + Skip"]
    D -->|No| F["deathCohort()"]
    
    F --> G["estimateSingleEventSurvival()"]
    G --> H["Survival Results"]
    
    style B fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
    style D fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
```

**Sources:** [R/cohortDiagnostics.R:165-186]()

## Integration with Diagnostic Framework

The cohort diagnostics module integrates seamlessly with the broader PhenotypeR diagnostic ecosystem:

```mermaid
graph TB
    A["phenotypeDiagnostics()"] --> B["cohortDiagnostics()"]
    
    B --> C["CohortCharacteristics Package"]
    B --> D["CohortConstructor Package"]
    B --> E["PatientProfiles Package"]
    B --> F["CohortSurvival Package"]
    
    C --> G["Attrition, Count, Overlap, Timing"]
    D --> H["Sampling, Matching, Subsetting"]
    E --> I["Demographics, Characteristics"]
    F --> J["Survival Analysis"]
    
    G --> K["summarised_result"]
    H --> K
    I --> K
    J --> K
    
    K --> L["shinyDiagnostics()"]
    
    style B fill:#e1f5fe,stroke:#01579b,stroke-width:3px
    style K fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
```

**Sources:** [R/cohortDiagnostics.R:31-204](), [tests/testthat/test-phenotypeDiagnostics.R:42-58]()

## Input Validation and Error Handling

The system performs comprehensive input validation through the `checksCohortDiagnostics()` function:

| Parameter | Validation | Error Condition |
|-----------|------------|-----------------|
| `survival` | `assertLogical()` | Non-boolean value |
| `cohortSample` | `assertNumeric()` | Non-integer, negative, or multiple values |
| `matchedSample` | `assertNumeric()` | Non-integer, negative, or multiple values |
| CohortSurvival dependency | `check_installed()` | Missing package when survival=TRUE |

**Sources:** [R/cohortDiagnostics.R:240-247]()

## Result Structure

The function returns a `summarised_result` object with standardized metadata:

```mermaid
graph LR
    A["summarised_result"] --> B["Settings Metadata"]
    
    B --> C["phenotyper_version"]
    B --> D["diagnostic = 'cohortDiagnostics'"]
    B --> E["cohort_sample"]
    B --> F["matched_sample"]
    
    A --> G["Result Data"]
    G --> H["Multiple result_type values"]
    
    style A fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
```

**Sources:** [R/cohortDiagnostics.R:193-202]()