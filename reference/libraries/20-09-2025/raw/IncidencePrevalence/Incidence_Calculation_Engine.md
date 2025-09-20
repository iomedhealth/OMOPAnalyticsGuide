# Page: Incidence Calculation Engine

# Incidence Calculation Engine

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/getIncidence.R](R/getIncidence.R)
- [tests/testthat/test-estimateIncidence.R](tests/testthat/test-estimateIncidence.R)

</details>



This document covers the core calculation engine that powers incidence rate estimation in the IncidencePrevalence package. The `getIncidence` function serves as the computational heart that processes denominator cohorts, applies washout criteria, handles time intervals, and calculates incidence rates with confidence intervals.

For information about the user-facing incidence estimation functions, see [Estimating Incidence Rates](#5.1). For configuration parameters and their effects, see [Parameters and Configuration](#5.3).

## Core Calculation Workflow

The incidence calculation engine follows a systematic data processing pipeline that transforms cohort data into incidence rate estimates:

```mermaid
flowchart TD
    subgraph "Input Processing"
        A[getIncidence] --> B["denominatorTable filtering"]
        B --> C["outcomeTable joining"] 
        C --> D["censorTable processing"]
    end
    
    subgraph "Population Preparation"
        D --> E["studyPopNoOutcome"]
        D --> F["studyPopOutcome"]
        F --> G["washout application"]
        G --> H["repeated events handling"]
    end
    
    subgraph "Time Interval Generation"
        H --> I["getStudyDays"]
        I --> J["weeks/months/quarters/years/overall"]
    end
    
    subgraph "Rate Calculation"
        J --> K["period filtering"]
        K --> L["person-time calculation"]
        L --> M["outcome counting"]
        M --> N["getStratifiedIncidenceResult"]
    end
    
    subgraph "Output Assembly"
        N --> O["incidence rate computation"]
        O --> P["confidence interval calculation"]
        P --> Q["result formatting"]
    end
```

Sources: [R/getIncidence.R:17-443]()

## Data Processing Pipeline

The calculation engine processes data through several distinct phases, each handling specific aspects of the incidence calculation:

### Population Assembly and Filtering

The engine begins by assembling the study population from the denominator cohort and joining outcome events:

```mermaid
flowchart LR
    subgraph "Denominator Processing"
        A["cdm[[denominatorTable]]"] --> B["filter cohort_definition_id"]
        B --> C["studyPopStart"]
    end
    
    subgraph "Outcome Integration"
        C --> D["left_join outcomeTable"]
        E["cdm[[outcomeTable]]"] --> D
        D --> F["studyPop with outcomes"]
    end
    
    subgraph "Censoring Application"
        F --> G["left_join censorTable"]
        H["cdm[[censorTable]]"] --> G
        G --> I["updated cohort_end_date"]
    end
```

Sources: [R/getIncidence.R:43-102]()

The population is split into two groups for differential processing:
- `studyPopNoOutcome`: Participants without outcome events [R/getIncidence.R:104-106]()
- `studyPopOutcome`: Participants with outcome events requiring special handling [R/getIncidence.R:111-117]()

### Washout Period Application

The washout logic varies depending on configuration and outcome history:

```mermaid
flowchart TD
    A["studyPopOutcome"] --> B{"outcomeWashout == NULL?"}
    
    B -->|Yes| C["Exclude anyone with outcome_prev_end_date"]
    B -->|No| D["Apply washout period"]
    
    D --> E["Add outcomeWashout + 1 days to outcome_prev_end_date"]
    E --> F["Update cohort_start_date"]
    
    F --> G{"repeatedEvents == FALSE?"}
    G -->|Yes| H["Limit to first event per person"]
    G -->|No| I["Allow multiple events"]
    
    C --> J["Filter valid date ranges"]
    H --> J
    I --> J
```

Sources: [R/getIncidence.R:126-186]()

The washout implementation uses `CDMConnector::dateadd` for database-agnostic date arithmetic [R/getIncidence.R:142-145]().

## Time Interval Processing

The engine supports multiple time interval types through the `getStudyDays` function, which generates calendar-aligned periods:

| Interval Type | Description | Alignment |
|--------------|-------------|-----------|
| `weeks` | Weekly intervals | Monday-Sunday |
| `months` | Monthly intervals | 1st to last day of month |
| `quarters` | Quarterly intervals | Q1 (Jan-Mar), Q2 (Apr-Jun), etc. |
| `years` | Annual intervals | January 1st to December 31st |
| `overall` | Single period | Study start to end |

Sources: [R/getIncidence.R:246-286]()

### Complete Database Intervals

The `completeDatabaseIntervals` parameter controls whether partial periods are included:

```mermaid
flowchart LR
    A["Study Population Dates"] --> B["getStudyDays"]
    B --> C{"completeDatabaseIntervals?"}
    
    C -->|TRUE| D["Only complete calendar periods"]
    C -->|FALSE| E["Include partial periods"]
    
    D --> F["Filter population to complete intervals"]
    E --> G["Include all observation time"]
```

Sources: [R/getIncidence.R:251-276](), [R/getIncidence.R:310-324]()

## Person-Time and Outcome Calculation

For each time interval, the engine calculates person-time contribution and counts outcomes:

### Individual Time Contribution

Each person's contribution to a specific time period is calculated using interval overlap logic:

```mermaid
flowchart TD
    A["For each person in period"] --> B["Calculate tStart"]
    B --> C["max(cohort_start_date, period_start)"]
    
    A --> D["Calculate tEnd"] 
    D --> E["min(cohort_end_date, period_end)"]
    
    C --> F["workingDays = tEnd - tStart + 1"]
    E --> F
    
    F --> G["Check outcome_start_date in period"]
    G --> H["Count as outcome if within [tStart, tEnd]"]
```

Sources: [R/getIncidence.R:344-371]()

### Aggregation Logic

Results are aggregated using standard epidemiological measures:

```mermaid
flowchart LR
    A["Individual person-days"] --> B["sum(workingDays)"]
    C["Individual outcomes"] --> D["sum(!is.na(outcome_start_date))"]
    E["Unique subjects"] --> F["n_distinct(subject_id)"]
    
    B --> G["person_years = person_days / 365.25"]
    D --> H["outcome_count"]
    F --> I["denominator_count"]
    
    G --> J["incidence_100000_pys = (outcome_count / person_years) * 100000"]
    H --> J
```

Sources: [R/getIncidence.R:375-415]()

## Stratification Support

The engine supports stratified analyses through the `getStratifiedIncidenceResult` function:

```mermaid
flowchart TD
    A["workingPop"] --> B["group_by strata variables"]
    B --> C["Calculate metrics per stratum"]
    
    C --> D["denominator_count per group"]
    C --> E["person_days per group"] 
    C --> F["outcome_count per group"]
    
    D --> G["omopgenerics::uniteStrata"]
    E --> G
    F --> G
    
    G --> H["Formatted stratified results"]
```

Sources: [R/getIncidence.R:446-463]()

The stratification process maintains the same calculation logic while grouping by specified variables and using `omopgenerics::uniteStrata` for consistent formatting.

## Attrition Tracking

Throughout the calculation process, the engine tracks population attrition using `recordAttrition`:

| Reason ID | Description | Location |
|-----------|-------------|----------|
| 11 | Starting analysis population | [R/getIncidence.R:54-59]() |
| 12 | Apply washout criteria | [R/getIncidence.R:219-225]() |
| 13-14 | Complete database interval filtering | [R/getIncidence.R:300-324]() |

This provides transparency into how the population is filtered and enables quality assurance.

## Output Structure

The `getIncidence` function returns a structured list containing:

```mermaid
flowchart LR
    A["getIncidence result"] --> B["ir: incidence rates"]
    A --> C["analysis_settings: parameters"]
    A --> D["attrition: population filtering"]
    
    B --> E["denominator_count, person_days, outcome_count"]
    B --> F["person_years, incidence_100000_pys"]
    B --> G["incidence_start_date, incidence_end_date"]
    
    C --> H["analysis_outcome_washout"]
    C --> I["analysis_repeated_events"] 
    C --> J["analysis_complete_database_intervals"]
    C --> K["analysis_censor_cohort_name"]
```

Sources: [R/getIncidence.R:423-442]()

The results structure enables downstream functions to apply confidence intervals, format output tables, and generate visualizations while preserving all analysis metadata.

Sources: [R/getIncidence.R:17-443](), [tests/testthat/test-estimateIncidence.R:1-3070]()