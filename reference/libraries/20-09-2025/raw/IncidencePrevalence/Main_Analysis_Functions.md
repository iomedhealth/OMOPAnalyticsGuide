# Page: Main Analysis Functions

# Main Analysis Functions

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [.gitignore](.gitignore)
- [R/dateUtilities.R](R/dateUtilities.R)
- [_pkgdown.yml](_pkgdown.yml)
- [man/estimatePeriodPrevalence.Rd](man/estimatePeriodPrevalence.Rd)
- [man/estimatePointPrevalence.Rd](man/estimatePointPrevalence.Rd)

</details>



This document provides detailed reference documentation for the core analysis functions in the IncidencePrevalence package. These functions form the primary user interface for conducting epidemiological analyses and include cohort generation, incidence rate estimation, and prevalence calculation functions.

For visualization and table generation functions, see [Visualization and Table Functions](#9.2). For utility and helper functions, see [Utility and Helper Functions](#9.3). For conceptual background on incidence vs prevalence, see [Incidence vs Prevalence](#3.3).

## Core Function Categories

The main analysis functions are organized into three primary categories:

### Function Category Overview

```mermaid
graph TD
    subgraph "Cohort Generation"
        A["generateDenominatorCohortSet()"]
        B["generateTargetDenominatorCohortSet()"]
    end
    
    subgraph "Incidence Analysis"
        C["estimateIncidence()"]
    end
    
    subgraph "Prevalence Analysis"
        D["estimatePointPrevalence()"]
        E["estimatePeriodPrevalence()"]
    end
    
    subgraph "Input Requirements"
        F["CDM Reference Object"]
        G["Outcome Cohort Tables"]
    end
    
    subgraph "Output Results"
        H["summarised_result Objects"]
        I["Attrition Information"]
        J["Confidence Intervals"]
    end
    
    F --> A
    F --> B
    F --> C
    F --> D
    F --> E
    
    A --> C
    A --> D
    A --> E
    B --> C
    
    G --> C
    G --> D
    G --> E
    
    C --> H
    C --> I
    C --> J
    D --> H
    D --> I
    D --> J
    E --> H
    E --> I
    E --> J
```

Sources: [_pkgdown.yml:6-30](), [man/estimatePointPrevalence.Rd:1-72](), [man/estimatePeriodPrevalence.Rd:1-88]()

## Cohort Generation Functions

### generateDenominatorCohortSet

The `generateDenominatorCohortSet()` function creates denominator populations for epidemiological analysis. It defines the population at risk by applying inclusion criteria such as age ranges, prior observation requirements, and study period restrictions.

**Key Parameters:**
- `cdm`: CDM reference object
- `name`: Name for the denominator cohort table
- `cohortDateRange`: Date range for the study period
- `ageGroup`: Age stratification groups
- `sex`: Sex stratification ("Both", "Male", "Female")
- `daysPriorObservation`: Required prior observation period
- `requirementInteractions`: Whether to create cohorts for all combinations of requirements

### generateTargetDenominatorCohortSet

The `generateTargetDenominatorCohortSet()` function creates denominator cohorts specifically for target cohort analysis, incorporating time-at-risk windows and washout periods for incidence calculations.

**Key Parameters:**
- `cdm`: CDM reference object
- `targetCohortTable`: Name of target cohort table
- `targetCohortId`: Specific target cohort IDs to analyze
- `washoutWindow`: Washout period before target cohort entry
- `followUpDays`: Maximum follow-up time

### Cohort Generation Data Flow

```mermaid
flowchart TD
    subgraph "Input Data"
        A["CDM.person"]
        B["CDM.observation_period"]
        C["Target Cohort Table"]
    end
    
    subgraph "generateDenominatorCohortSet"
        D["Apply ageGroup filters"]
        E["Apply sex filters"]
        F["Apply daysPriorObservation"]
        G["Apply cohortDateRange"]
        H["Create requirement combinations"]
    end
    
    subgraph "generateTargetDenominatorCohortSet"
        I["Load target cohorts"]
        J["Apply washoutWindow"]
        K["Calculate followUpDays"]
        L["Generate time-at-risk periods"]
    end
    
    subgraph "Output Tables"
        M["denominator_cohort_set"]
        N["target_denominator_cohort_set"]
        O["Attrition tracking"]
    end
    
    A --> D
    B --> D
    A --> E
    D --> E
    E --> F
    F --> G
    G --> H
    H --> M
    
    C --> I
    I --> J
    J --> K
    K --> L
    L --> N
    
    M --> O
    N --> O
```

Sources: [_pkgdown.yml:7-9]()

## Incidence Analysis Functions

### estimateIncidence

The `estimateIncidence()` function calculates incidence rates by measuring the occurrence of new events over person-time at risk. It supports various configuration options for washout periods, repeated events, and censoring strategies.

**Core Parameters:**
- `cdm`: CDM reference object
- `denominatorTable`: Name of denominator cohort table
- `outcomeTable`: Name of outcome cohort table
- `denominatorCohortId`: Specific denominator cohorts to analyze
- `outcomeCohortId`: Specific outcome cohorts to analyze
- `washoutWindow`: Washout period for incident cases
- `repeatedEvents`: Whether to count multiple events per person
- `censorOnOutcome`: Whether to censor follow-up after first outcome
- `censorOnDeath`: Whether to censor on death
- `interval`: Time intervals for rate calculation
- `completeDatabaseIntervals`: Only include complete database intervals
- `strata`: Variables for stratified analysis

**Return Value:**
Returns a `summarised_result` object containing incidence rates, confidence intervals, person-time calculations, and attrition information.

### Incidence Calculation Logic

```mermaid
flowchart TD
    subgraph "Input Processing"
        A["denominatorTable"]
        B["outcomeTable"]
        C["washoutWindow parameter"]
        D["repeatedEvents parameter"]
    end
    
    subgraph "Core Logic: getIncidence"
        E["Filter for incident cases"]
        F["Apply washout period"]
        G["Calculate person-time at risk"]
        H["Count outcome events"]
        I["Handle repeated events logic"]
        J["Apply censoring rules"]
    end
    
    subgraph "Statistical Processing"
        K["Calculate incidence rates"]
        L["Compute confidence intervals"]
        M["Generate interval-specific results"]
        N["Apply stratification"]
    end
    
    subgraph "Output Generation"
        O["Format as summarised_result"]
        P["Include attrition details"]
        Q["Add population counts"]
    end
    
    A --> E
    B --> E
    C --> F
    D --> I
    E --> F
    F --> G
    G --> H
    H --> I
    I --> J
    
    J --> K
    K --> L
    L --> M
    M --> N
    
    N --> O
    O --> P
    P --> Q
```

Sources: [_pkgdown.yml:10-12]()

## Prevalence Analysis Functions

### estimatePointPrevalence

The `estimatePointPrevalence()` function estimates the proportion of a population with a condition at specific time points. It calculates prevalence at the start, middle, or end of specified intervals.

**Key Parameters:**
- `cdm`: CDM reference object
- `denominatorTable`: Name of denominator cohort table
- `outcomeTable`: Name of outcome cohort table
- `denominatorCohortId`: Specific denominator cohorts to analyze
- `outcomeCohortId`: Specific outcome cohorts to analyze
- `interval`: Time intervals ("weeks", "months", "quarters", "years")
- `timePoint`: Point in interval ("start", "middle", "end")
- `strata`: Variables for stratified analysis
- `includeOverallStrata`: Include overall results with strata

### estimatePeriodPrevalence

The `estimatePeriodPrevalence()` function estimates the proportion of a population with a condition during specified time periods. It measures prevalence over entire intervals rather than at single time points.

**Key Parameters:**
- `cdm`: CDM reference object
- `denominatorTable`: Name of denominator cohort table
- `outcomeTable`: Name of outcome cohort table
- `denominatorCohortId`: Specific denominator cohorts to analyze
- `outcomeCohortId`: Specific outcome cohorts to analyze
- `interval`: Time intervals ("weeks", "months", "quarters", "years", "overall")
- `completeDatabaseIntervals`: Only include complete database intervals
- `fullContribution`: Require full interval presence for inclusion
- `level`: Analysis level ("person" or "record")
- `strata`: Variables for stratified analysis
- `includeOverallStrata`: Include overall results with strata

### Prevalence Function Comparison

| Parameter | `estimatePointPrevalence` | `estimatePeriodPrevalence` |
|-----------|---------------------------|----------------------------|
| `timePoint` | Required - specifies point in interval | Not applicable |
| `completeDatabaseIntervals` | Not applicable | Optional - filters intervals |
| `fullContribution` | Not applicable | Optional - requires full presence |
| `level` | Not applicable | Optional - person vs record level |
| `interval` options | weeks, months, quarters, years | weeks, months, quarters, years, overall |

Sources: [man/estimatePointPrevalence.Rd:1-72](), [man/estimatePeriodPrevalence.Rd:1-88]()

### Prevalence Calculation Logic

```mermaid
flowchart TD
    subgraph "Input Validation"
        A["Validate denominatorTable"]
        B["Validate outcomeTable"]
        C["Validate interval parameters"]
        D["Validate cohort IDs"]
    end
    
    subgraph "Core Logic: getPrevalence"
        E["Generate time intervals"]
        F["Identify denominator population"]
        G["Identify outcome cases"]
        H["Apply timePoint logic (point)"]
        I["Apply fullContribution logic (period)"]
        J["Calculate prevalence proportions"]
    end
    
    subgraph "Statistical Processing"
        K["Compute confidence intervals"]
        L["Apply stratification"]
        M["Handle completeDatabaseIntervals"]
        N["Process level parameter (record/person)"]
    end
    
    subgraph "Result Formatting"
        O["Format as summarised_result"]
        P["Include population counts"]
        Q["Add attrition information"]
        R["Include interval metadata"]
    end
    
    A --> E
    B --> E
    C --> E
    D --> E
    
    E --> F
    F --> G
    G --> H
    G --> I
    H --> J
    I --> J
    
    J --> K
    K --> L
    L --> M
    M --> N
    
    N --> O
    O --> P
    P --> Q
    Q --> R
```

Sources: [man/estimatePointPrevalence.Rd:6-19](), [man/estimatePeriodPrevalence.Rd:6-19]()

## Function Integration Patterns

### Common Input Validation

All main analysis functions share common input validation patterns through the validation system:

```mermaid
graph TD
    subgraph "Common Validation Steps"
        A["validateCdm()"]
        B["validateCohortTable()"]
        C["validateCohortIds()"]
        D["validateInterval()"]
        E["validateStrata()"]
    end
    
    subgraph "Function-Specific Validation"
        F["validateWashoutWindow() (incidence)"]
        G["validateTimePoint() (point prevalence)"]
        H["validateFullContribution() (period prevalence)"]
        I["validateRepeatedEvents() (incidence)"]
    end
    
    subgraph "Analysis Functions"
        J["estimateIncidence()"]
        K["estimatePointPrevalence()"]
        L["estimatePeriodPrevalence()"]
    end
    
    A --> J
    A --> K
    A --> L
    B --> J
    B --> K
    B --> L
    C --> J
    C --> K
    C --> L
    D --> J
    D --> K
    D --> L
    E --> J
    E --> K
    E --> L
    
    F --> J
    G --> K
    H --> L
    I --> J
```

### Standardized Output Format

All functions return `summarised_result` objects with consistent structure:

| Column | Description | Present in All Functions |
|--------|-------------|-------------------------|
| `result_id` | Unique identifier for each result | Yes |
| `cdm_name` | Name of the CDM database | Yes |
| `group_name` | Grouping variable names | Yes |
| `group_level` | Grouping variable values | Yes |
| `strata_name` | Stratification variable names | Yes |
| `strata_level` | Stratification variable values | Yes |
| `variable_name` | Measure name (incidence_100000_pys, prevalence, etc.) | Yes |
| `variable_level` | Measure category | Yes |
| `estimate_name` | Statistic name (count, rate, confidence intervals) | Yes |
| `estimate_type` | Data type of estimate | Yes |
| `estimate_value` | Calculated value | Yes |
| `additional_name` | Metadata field names | Yes |
| `additional_level` | Metadata field values | Yes |

Sources: [_pkgdown.yml:6-30](), [R/dateUtilities.R:16-45]()