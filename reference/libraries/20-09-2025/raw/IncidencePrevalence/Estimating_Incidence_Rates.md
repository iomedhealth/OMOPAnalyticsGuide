# Page: Estimating Incidence Rates

# Estimating Incidence Rates

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/estimateIncidence.R](R/estimateIncidence.R)
- [vignettes/a05_Calculating_incidence.Rmd](vignettes/a05_Calculating_incidence.Rmd)

</details>



This page covers the practical usage of the `estimateIncidence()` function for calculating population incidence rates in epidemiological studies. It focuses on the high-level API, input requirements, output interpretation, and common usage patterns. For detailed technical implementation of the calculation engine, see [Incidence Calculation Engine](#5.2). For comprehensive parameter configuration details, see [Parameters and Configuration](#5.3). For conceptual background on incidence versus prevalence measures, see [Incidence vs Prevalence](#3.3).

## Function Overview

The `estimateIncidence()` function is the primary interface for calculating incidence rates from OMOP CDM data. It takes denominator and outcome cohorts and produces standardized incidence rate estimates with confidence intervals, supporting various temporal intervals, washout periods, and stratification options.

### Core Workflow

```mermaid
flowchart TD
    subgraph "Input Data"
        CDM["CDM Reference Object"]
        DENOM["Denominator Cohort Table"]
        OUTCOME["Outcome Cohort Table"]
        CENSOR["Censor Cohort Table<br/>(Optional)"]
    end
    
    subgraph "estimateIncidence Function"
        VALIDATE["checkInputEstimateIncidence()<br/>Input Validation"]
        PREP["Data Preparation<br/>Join Cohorts"]
        SPECS["getIncAnalysisSpecs()<br/>Analysis Specifications"]
        CALC["getIncidence()<br/>Core Calculation Engine"]
        CI["incRateCiExact()<br/>Confidence Intervals"]
        FORMAT["Format Results<br/>SummarisedResult"]
    end
    
    subgraph "Output"
        RESULT["SummarisedResult Object<br/>Incidence Estimates"]
        ATTRITION["Attrition Information"]
        SETTINGS["Analysis Settings"]
    end
    
    CDM --> VALIDATE
    DENOM --> VALIDATE
    OUTCOME --> VALIDATE
    CENSOR --> VALIDATE
    
    VALIDATE --> PREP
    PREP --> SPECS
    SPECS --> CALC
    CALC --> CI
    CI --> FORMAT
    
    FORMAT --> RESULT
    FORMAT --> ATTRITION
    FORMAT --> SETTINGS
```

Sources: [R/estimateIncidence.R:78-502](), [R/estimateIncidence.R:102-107](), [R/estimateIncidence.R:261-266](), [R/estimateIncidence.R:275-295](), [R/estimateIncidence.R:374-379](), [R/estimateIncidence.R:481-494]()

## Data Flow and Processing

```mermaid
graph TB
    subgraph "Input Validation"
        A["checkInputEstimateIncidence()"]
        B["checkStrata()"]
        C["checkInputEstimateAdditional()"]
    end
    
    subgraph "Cohort Processing"
        D["Filter Outcome Cohorts<br/>tablePrefix_inc_1"]
        E["Join with Denominator<br/>Inner Join on subject_id"]
        F["Historical Outcomes<br/>tablePrefix_inc_2"]
        G["Index Events<br/>tablePrefix_inc_3"]
        H["Washout Processing<br/>tablePrefix_inc_4"]
    end
    
    subgraph "Analysis Execution"
        I["Generate Analysis Specs<br/>Cross Product of Parameters"]
        J["Execute getIncidence()<br/>For Each Specification"]
        K["Calculate Confidence Intervals<br/>Exact Method"]
    end
    
    subgraph "Result Assembly"
        L["Combine Results<br/>Bind Analysis Outputs"]
        M["Add Settings Metadata<br/>Analysis Parameters"]
        N["Format Attrition<br/>Population Flow"]
        O["newSummarisedResult<br/>Standard OMOP Format"]
    end
    
    A --> D
    B --> D
    C --> D
    
    D --> E
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
```

Sources: [R/estimateIncidence.R:102-153](), [R/estimateIncidence.R:156-260](), [R/estimateIncidence.R:261-322](), [R/estimateIncidence.R:324-494]()

## Basic Usage Pattern

The simplest incidence calculation requires only a CDM reference, denominator table, and outcome table:

```r
inc <- estimateIncidence(
  cdm = cdm,
  denominatorTable = "denominator", 
  outcomeTable = "outcome"
)
```

This will calculate yearly incidence rates with default settings (infinite washout, no repeated events).

Sources: [vignettes/a05_Calculating_incidence.Rmd:105-112](), [R/estimateIncidence.R:78-90]()

## Input Requirements

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `cdm` | CDM Reference | OMOP CDM database connection |
| `denominatorTable` | String | Name of denominator cohort table in CDM |
| `outcomeTable` | String | Name of outcome cohort table in CDM |

### Optional Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `censorTable` | `NULL` | Cohort table for censoring events |
| `denominatorCohortId` | `NULL` | Specific denominator cohorts (all if NULL) |
| `outcomeCohortId` | `NULL` | Specific outcome cohorts (all if NULL) |
| `interval` | `"years"` | Time intervals: "weeks", "months", "quarters", "years", "overall" |
| `outcomeWashout` | `Inf` | Days between outcome end and risk contribution restart |
| `repeatedEvents` | `FALSE` | Allow multiple events per person |
| `strata` | `list()` | Variables for stratified analysis |

Sources: [R/estimateIncidence.R:78-90](), [R/estimateIncidence.R:19-61]()

## Output Structure

The function returns a `summarised_result` object containing:

### Main Results
- **Incidence rates**: Per 100,000 person-years with 95% confidence intervals
- **Counts**: Denominator population, outcome events
- **Time**: Person-days and person-years contributed
- **Intervals**: Temporal breakdown by specified intervals

### Metadata
- **Settings**: Analysis parameters and cohort definitions
- **Attrition**: Population flow and exclusions
- **Stratification**: Results by specified strata

```mermaid
graph LR
    subgraph "SummarisedResult Structure"
        A["estimate_name:<br/>denominator_count<br/>outcome_count<br/>person_days<br/>person_years<br/>incidence_100000_pys<br/>incidence_100000_pys_95CI_lower<br/>incidence_100000_pys_95CI_upper"]
        
        B["variable_name:<br/>Denominator<br/>Outcome"]
        
        C["group_name:<br/>denominator_cohort_name<br/>outcome_cohort_name"]
        
        D["additional_name:<br/>incidence_start_date<br/>incidence_end_date<br/>analysis_interval"]
    end
    
    subgraph "Settings Table"
        E["result_type: incidence<br/>package_name: IncidencePrevalence<br/>analysis_outcome_washout<br/>analysis_repeated_events<br/>analysis_complete_database_intervals"]
    end
```

Sources: [R/estimateIncidence.R:419-458](), [R/estimateIncidence.R:461-479](), [R/estimateIncidence.R:481-494]()

## Confidence Interval Calculation

The function uses exact confidence intervals based on the chi-square distribution:

```r
incRateCiExact <- function(ev, pt) {
  # Lower CI: qchisq(0.025, df = 2*events) / 2 / person_time * 100000
  # Upper CI: qchisq(0.975, df = 2*(events+1)) / 2 / person_time * 100000
}
```

Sources: [R/estimateIncidence.R:506-516](), [R/estimateIncidence.R:374-379]()

## Parameter Specification Process

```mermaid
flowchart TD
    subgraph "Parameter Processing"
        A["Input Parameters<br/>outcomeWashout, repeatedEvents<br/>interval, denominatorCohortId"]
        B["getIncAnalysisSpecs()<br/>Generate Cross Product"]
        C["Analysis Specifications<br/>One Row Per Analysis"]
    end
    
    subgraph "Analysis Loop"
        D["For Each Specification"]
        E["Call getIncidence()<br/>Core Calculation"]
        F["Collect Results<br/>IR + Settings + Attrition"]
    end
    
    subgraph "Result Combination"
        G["Bind All Results<br/>purrr::list_flatten"]
        H["Add Metadata<br/>Cohort Names & Settings"]
        I["Format Output<br/>SummarisedResult"]
    end
    
    A --> B
    B --> C
    C --> D
    D --> E
    E --> F
    F --> G
    G --> H
    H --> I
```

Sources: [R/estimateIncidence.R:261-266](), [R/estimateIncidence.R:519-563](), [R/estimateIncidence.R:270-322](), [R/estimateIncidence.R:324-346]()

## Common Usage Examples

### Multiple Time Intervals
```r
inc <- estimateIncidence(
  cdm = cdm,
  denominatorTable = "denominator",
  outcomeTable = "outcome", 
  interval = c("years", "quarters", "overall")
)
```

### With Washout and Repeated Events
```r
inc <- estimateIncidence(
  cdm = cdm,
  denominatorTable = "denominator",
  outcomeTable = "outcome",
  outcomeWashout = 180,
  repeatedEvents = TRUE
)
```

### Stratified Analysis
```r
inc <- estimateIncidence(
  cdm = cdm,
  denominatorTable = "denominator", 
  outcomeTable = "outcome",
  strata = list("age_group", "sex", c("age_group", "sex"))
)
```

### With Censoring
```r
inc <- estimateIncidence(
  cdm = cdm,
  denominatorTable = "denominator",
  outcomeTable = "outcome", 
  censorTable = "censor",
  censorCohortId = 1
)
```

Sources: [vignettes/a05_Calculating_incidence.Rmd:104-300]()

## Temporary Table Management

The function creates several temporary tables during processing with a random prefix to avoid conflicts:

- `{tablePrefix}_inc_1`: Outcome cohorts joined with denominator
- `{tablePrefix}_inc_2`: Historical and concurrent outcomes  
- `{tablePrefix}_inc_3`: Indexed events by person and outcome
- `{tablePrefix}_inc_4`: Events with previous outcome end dates

All temporary tables are automatically dropped after processing.

Sources: [R/estimateIncidence.R:93-95](), [R/estimateIncidence.R:156-260](), [R/estimateIncidence.R:381-388]()