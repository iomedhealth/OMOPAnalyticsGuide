# Page: Data Preparation with addCohortSurvival

# Data Preparation with addCohortSurvival

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [NAMESPACE](NAMESPACE)
- [R/addCohortSurvival.R](R/addCohortSurvival.R)
- [man/addCohortSurvival.Rd](man/addCohortSurvival.Rd)
- [tests/testthat/test-addCohortSurvival.R](tests/testthat/test-addCohortSurvival.R)
- [vignettes/a02_Competing_risk_survival.Rmd](vignettes/a02_Competing_risk_survival.Rmd)

</details>



## Purpose and Scope

The `addCohortSurvival` function transforms OMOP CDM cohort tables into survival analysis-ready datasets by calculating time-to-event and censoring status for each cohort record. This function serves as the foundational data preparation step that precedes survival analysis estimation. For information about performing survival analysis using the prepared data, see [Single Event Survival Estimation](#2.1) and [Competing Risk Survival Estimation](#2.2).

The function enriches cohort tables with standardized survival analysis columns (`time`, `status`, `days_to_exit`) that can be consumed by downstream survival estimation functions or external survival analysis packages.

## Function Overview and Data Flow

The `addCohortSurvival` function implements a comprehensive time-to-event calculation pipeline that handles multiple censoring scenarios and outcome linkage patterns.

### Core Data Transformation Process

```mermaid
flowchart TD
    A["Input Cohort Table<br/>cohort_definition_id, subject_id<br/>cohort_start_date, cohort_end_date"] --> B["addFutureObservation<br/>Calculate days_to_exit"]
    
    B --> C{"Outcome Washout<br/>outcomeWashout == 0?"}
    
    C -->|Yes| D["addCohortIntersectDays<br/>Get days_to_event from index"]
    C -->|No| E["addCohortIntersectFlag<br/>Check washout period<br/>+ addCohortIntersectDays"]
    
    D --> F["Apply Censoring Rules"]
    E --> F
    
    F --> G["Cohort Exit<br/>censorOnCohortExit"]
    F --> H["Date Censoring<br/>censorOnDate"]
    F --> I["Follow-up Limit<br/>followUpDays"]
    
    G --> J["Calculate Final time & status"]
    H --> J
    I --> J
    
    J --> K["Apply Washout Exclusions<br/>Set NA for washout events"]
    
    K --> L["Output Cohort Table<br/>+ days_to_exit, time, status"]
    
    style A fill:#e3f2fd
    style L fill:#e8f5e8
    style F fill:#fff3e0
```

**Data Transformation Process**: The function systematically processes cohort data through observation period calculation, outcome linkage, censoring application, and final survival variable generation.

Sources: [R/addCohortSurvival.R:51-219](), [R/addCohortSurvival.R:82-86](), [R/addCohortSurvival.R:179-185]()

### PatientProfiles Integration

```mermaid
flowchart LR
    A["Input Cohort"] --> B["PatientProfiles::<br/>addFutureObservation"]
    B --> C["PatientProfiles::<br/>addCohortIntersectFlag"]
    C --> D["PatientProfiles::<br/>addCohortIntersectDays"]
    D --> E["CohortSurvival<br/>time/status calculation"]
    E --> F["Enhanced Cohort<br/>with survival variables"]
    
    subgraph "PatientProfiles Functions"
        B
        C
        D
    end
    
    subgraph "CohortSurvival Processing"
        E
    end
    
    style B fill:#f3e5f5
    style C fill:#f3e5f5
    style D fill:#f3e5f5
    style E fill:#ff9800
```

**PatientProfiles Integration**: The function leverages PatientProfiles package functions for core OMOP CDM data operations, then applies CohortSurvival-specific survival analysis transformations.

Sources: [R/addCohortSurvival.R:82-86](), [R/addCohortSurvival.R:92-118]()

## Core Parameters and Configuration

### Essential Parameters

| Parameter | Type | Default | Purpose |
|-----------|------|---------|---------|
| `x` | cohort_table | required | Target cohort table to enhance |
| `cdm` | cdm_reference | required | CDM database connection |
| `outcomeCohortTable` | character | required | Name of outcome cohort table |
| `outcomeCohortId` | numeric | 1 | Specific outcome cohort ID |
| `outcomeDateVariable` | character | "cohort_start_date" | Date column to use for outcome |

### Censoring and Follow-up Controls

| Parameter | Type | Default | Purpose |
|-----------|------|---------|---------|
| `censorOnCohortExit` | logical | FALSE | Censor at cohort_end_date |
| `censorOnDate` | Date | NULL | Censor at specific calendar date |
| `followUpDays` | numeric | Inf | Maximum follow-up duration |
| `outcomeWashout` | numeric | Inf | Washout period before cohort_start_date |

Sources: [man/addCohortSurvival.Rd:6-18](), [R/addCohortSurvival.R:51-60]()

## Censoring Mechanisms

The function implements multiple censoring strategies that can be applied simultaneously, with the earliest censoring event taking precedence.

### Censoring Priority Hierarchy

```mermaid
flowchart TD
    A["Person enters cohort<br/>cohort_start_date"] --> B{"Event occurs?"}
    
    B -->|Yes| C["Calculate days_to_event"]
    B -->|No| D["Apply censoring rules"]
    
    D --> E["1. End of observation period<br/>days_to_exit"]
    D --> F["2. Cohort exit date<br/>censorOnCohortExit=TRUE"]
    D --> G["3. Calendar date<br/>censorOnDate"]
    D --> H["4. Follow-up limit<br/>followUpDays"]
    
    E --> I["Select earliest<br/>censoring time"]
    F --> I
    G --> I
    H --> I
    
    C --> J["status = 1<br/>time = days_to_event"]
    I --> K["status = 0<br/>time = censoring_time"]
    
    J --> L["Final survival variables"]
    K --> L
    
    style A fill:#e3f2fd
    style J fill:#4caf50
    style K fill:#ff9800
    style L fill:#e8f5e8
```

**Censoring Hierarchy**: Multiple censoring mechanisms operate in parallel, with the earliest event determining the final time and status values.

Sources: [R/addCohortSurvival.R:120-127](), [R/addCohortSurvival.R:128-142](), [R/addCohortSurvival.R:144-160]()

### Washout Period Handling

```mermaid
flowchart LR
    A["Outcome in washout period<br/>before cohort_start_date"] --> B["event_in_washout = 1"]
    B --> C["Set time = NA<br/>Set status = NA"]
    C --> D["Record excluded<br/>from analysis"]
    
    E["No washout event"] --> F["Normal processing"]
    F --> G["Calculate time/status"]
    
    style A fill:#ffebee
    style C fill:#ffebee
    style D fill:#ffebee
    style G fill:#e8f5e8
```

**Washout Exclusion**: Records with outcome events during the washout period are retained in the dataset but marked with NA values to exclude them from survival analysis.

Sources: [R/addCohortSurvival.R:188-200](), [R/addCohortSurvival.R:101-118]()

## Output Format and Variables

### Added Columns

The function adds three key columns to the input cohort table:

| Column | Type | Description | Values |
|--------|------|-------------|---------|
| `days_to_exit` | numeric | Days from cohort_start_date to end of observation/censoring | Positive integer or Inf |
| `time` | numeric | Days to event (if status=1) or censoring (if status=0) | Positive integer or NA |
| `status` | integer | Event indicator | 1 = event occurred, 0 = censored, NA = excluded |

### Column Overwriting Behavior

```mermaid
flowchart TD
    A["Input cohort table"] --> B{"Columns time, status,<br/>days_to_exit exist?"}
    
    B -->|Yes| C["Drop existing columns<br/>dplyr::select(!dplyr::any_of(...))"]
    B -->|No| D["Proceed with calculation"]
    
    C --> D
    D --> E["Calculate new survival variables"]
    E --> F["Output enhanced table"]
    
    style C fill:#fff3e0
    style F fill:#e8f5e8
```

**Column Management**: Existing survival-related columns are automatically removed before recalculation, allowing the function to be re-run on previously processed tables.

Sources: [R/addCohortSurvival.R:75-79](), [tests/testthat/test-addCohortSurvival.R:683-768]()

## Common Usage Patterns

### Basic Event Analysis

```r
# Simple time-to-death analysis
cdm$target_cohort <- cdm$target_cohort %>%
  addCohortSurvival(
    cdm = cdm,
    outcomeCohortTable = "death_cohort",
    outcomeCohortId = 1
  )
```

### Competing Risk Preparation

```r
# Prepare for competing risk analysis
cdm$drug_cohort <- cdm$drug_cohort %>%
  addCohortSurvival(
    cdm = cdm,
    outcomeCohortTable = "primary_outcome",
    outcomeCohortId = 1
  ) %>%
  addCohortSurvival(
    cdm = cdm,
    outcomeCohortTable = "competing_outcome", 
    outcomeCohortId = 1,
    name = "drug_cohort_prepared"
  )
```

### Limited Follow-up Analysis

```r
# 30-day outcome analysis with cohort exit censoring
cdm$exposure_cohort <- cdm$exposure_cohort %>%
  addCohortSurvival(
    cdm = cdm,
    outcomeCohortTable = "adverse_event",
    followUpDays = 30,
    censorOnCohortExit = TRUE
  )
```

Sources: [tests/testthat/test-addCohortSurvival.R:63-68](), [tests/testthat/test-addCohortSurvival.R:450-466](), [vignettes/a02_Competing_risk_survival.Rmd:154-159]()

### Multiple Records Per Person Handling

The function correctly processes cohort tables with multiple records per person, calculating survival variables independently for each cohort entry:

```mermaid
flowchart TD
    A["Person 1: Entry 1<br/>2010-01-01"] --> B["Event: 2012-01-10<br/>status=1, time=739"]
    C["Person 1: Entry 2<br/>2015-01-01"] --> D["Event before entry<br/>status=NA, time=NA"]
    
    E["Person 2: Entry 1<br/>2010-01-01"] --> F["Event: 2017-01-10<br/>status=1, time=2566"]
    G["Person 2: Entry 2<br/>2016-01-01"] --> H["Event: 2017-01-10<br/>status=1, time=374"]
    
    style B fill:#4caf50
    style D fill:#ffebee
    style F fill:#4caf50
    style H fill:#4caf50
```

**Multiple Records**: Each cohort entry is processed independently, with events linked to the appropriate time windows relative to each entry's cohort_start_date.

Sources: [tests/testthat/test-addCohortSurvival.R:770-878]()