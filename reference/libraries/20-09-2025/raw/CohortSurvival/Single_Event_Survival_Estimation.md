# Page: Single Event Survival Estimation

# Single Event Survival Estimation

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/estimateSurvival.R](R/estimateSurvival.R)
- [man/estimateCompetingRiskSurvival.Rd](man/estimateCompetingRiskSurvival.Rd)
- [man/estimateSingleEventSurvival.Rd](man/estimateSingleEventSurvival.Rd)
- [tests/testthat/test-estimateSurvival.R](tests/testthat/test-estimateSurvival.R)

</details>



This document covers the `estimateSingleEventSurvival` function, which performs time-to-event analysis for cohorts in the OMOP Common Data Model using Kaplan-Meier estimation. This function handles scenarios where only one outcome event type is of interest, without competing risks. For competing risk analysis with multiple outcome types, see [Competing Risk Survival Estimation](#2.2). For data preparation requirements, see [Data Preparation with addCohortSurvival](#2.3).

## Function Overview

The `estimateSingleEventSurvival` function serves as the primary interface for single-event survival analysis in the CohortSurvival package. It processes OMOP CDM cohort tables to estimate survival probabilities and related statistics over time.

```mermaid
graph TD
    A["estimateSingleEventSurvival()"] --> B["Parameter Validation"]
    B --> C["getCohortId()"]
    C --> D["Empty Cohort Checks"]
    D --> E["Cross-Product Generation"]
    E --> F["estimateSurvival()"]
    F --> G["addCohortSurvival()"]
    G --> H["singleEventSurvival()"]
    H --> I["Result Processing"]
    I --> J["newSummarisedResult()"]
    
    subgraph "Input Cohorts"
        K["targetCohortTable"]
        L["outcomeCohortTable"]
    end
    
    subgraph "Output"
        M["summarised_result object"]
    end
    
    K --> A
    L --> A
    J --> M
```

**Function Data Flow Architecture**

Sources: [R/estimateSurvival.R:65-372](), [tests/testthat/test-estimateSurvival.R:7-83]()

## Parameter Configuration

The function accepts extensive configuration options to control survival analysis behavior:

| Parameter Category | Parameters | Purpose |
|-------------------|------------|---------|
| **Data Sources** | `cdm`, `targetCohortTable`, `outcomeCohortTable` | Define input cohort tables |
| **Cohort Selection** | `targetCohortId`, `outcomeCohortId` | Specify which cohorts to analyze |
| **Outcome Definition** | `outcomeDateVariable`, `outcomeWashout` | Configure outcome event identification |
| **Censoring** | `censorOnCohortExit`, `censorOnDate`, `followUpDays` | Control follow-up termination |
| **Analysis Options** | `strata`, `eventGap`, `estimateGap` | Define stratification and time intervals |
| **Statistical Parameters** | `restrictedMeanFollowUp`, `minimumSurvivalDays` | Set calculation constraints |

```mermaid
graph LR
    subgraph "Required Parameters"
        A["cdm"]
        B["targetCohortTable"]
        C["outcomeCohortTable"]
    end
    
    subgraph "Cohort Selection"
        D["targetCohortId = NULL"]
        E["outcomeCohortId = NULL"]
    end
    
    subgraph "Censoring Configuration"
        F["censorOnCohortExit = FALSE"]
        G["censorOnDate = NULL"]
        H["followUpDays = Inf"]
    end
    
    subgraph "Time Intervals"
        I["eventGap = 30"]
        J["estimateGap = 1"]
    end
    
    A --> K["estimateSingleEventSurvival()"]
    B --> K
    C --> K
    D --> K
    E --> K
    F --> K
    G --> K
    H --> K
    I --> K
    J --> K
```

**Parameter Structure and Defaults**

Sources: [R/estimateSurvival.R:65-79](), [man/estimateSingleEventSurvival.Rd:7-23]()

## Data Processing Pipeline

The function implements a multi-stage data processing pipeline that transforms raw OMOP CDM cohort data into survival analysis inputs:

```mermaid
flowchart TD
    A["Input Validation"] --> B["validateInputSurvival()"]
    B --> C["Cohort ID Resolution"]
    C --> D["getCohortId()"]
    D --> E["Empty Cohort Detection"]
    E --> F["Target-Outcome Combinations"]
    F --> G["addCohortSurvival()"]
    G --> H["Time/Status Calculation"]
    H --> I["Minimum Survival Filter"]
    I --> J["Data Collection"]
    J --> K["singleEventSurvival()"]
    
    subgraph "Data Preparation"
        G
        H
        I
    end
    
    subgraph "Statistical Analysis"
        K --> L["survfit()"]
        L --> M["Kaplan-Meier Estimation"]
    end
    
    subgraph "Result Processing"
        N["addCohortDetails()"]
        O["Result Standardization"]
        P["Attribute Attachment"]
    end
    
    M --> N
    N --> O
    O --> P
```

**Internal Data Processing Flow**

The pipeline handles multiple target-outcome combinations through a cross-product approach:

```mermaid
graph TB
    A["targetCohortId"] --> D["expand.grid()"]
    B["outcomeCohortId"] --> D
    D --> E["purrr::pmap()"]
    E --> F["Individual Analysis"]
    F --> G["Result Aggregation"]
    
    subgraph "Per Combination Processing"
        H["estimateSurvival()"] --> I["addCohortSurvival()"]
        I --> J["Statistical Fitting"]
        J --> K["Result Extraction"]
    end
    
    F --> H
    K --> G
```

**Cross-Product Analysis Pattern**

Sources: [R/estimateSurvival.R:115-162](), [R/estimateSurvival.R:800-807]()

## Statistical Computation

The core statistical analysis employs the `survival` package for Kaplan-Meier estimation:

```mermaid
flowchart TD
    A["survData"] --> B["singleEventSurvival()"]
    B --> C["survival::survfit()"]
    C --> D["Survival Object"]
    D --> E["Time Point Extraction"]
    E --> F["Confidence Intervals"]
    F --> G["Summary Statistics"]
    
    subgraph "Survival Formula"
        H["Surv(outcome_time, outcome_status) ~ 1"]
        I["+ strata variables"]
    end
    
    subgraph "Extracted Metrics"
        J["Survival Probability"]
        K["95% Confidence Intervals"]
        L["Numbers at Risk"]
        M["Events/Censoring Counts"]
        N["Median Survival"]
        O["Restricted Mean Survival"]
    end
    
    C --> H
    H --> I
    D --> J
    D --> K
    D --> L
    D --> M
    G --> N
    G --> O
```

**Statistical Estimation Architecture**

The function supports stratified analysis through the `strata` parameter:

| Strata Configuration | Example | Usage Pattern |
|---------------------|---------|---------------|
| Single Variable | `list(c("age_group"))` | Age-based stratification |
| Multiple Variables | `list(c("age_group", "sex"))` | Combined stratification |
| Multiple Strata | `list(c("age"), c("sex"), c("age", "sex"))` | Separate and combined analyses |

Sources: [R/estimateSurvival.R:1061-1077](), [tests/testthat/test-estimateSurvival.R:96-103]()

## Output Structure

The function returns a `summarised_result` object containing survival estimates, events data, summary statistics, and attrition information:

```mermaid
graph TD
    A["summarised_result"] --> B["Survival Estimates"]
    A --> C["Events Attribute"]
    A --> D["Summary Attribute"]
    A --> E["Attrition Attribute"]
    
    subgraph "Survival Estimates"
        F["survival_probability"]
        G["cumulative_failure_probability"]
        H["95% Confidence Intervals"]
        I["Time Points"]
    end
    
    subgraph "Events Data"
        J["n_risk_count"]
        K["n_events_count"]
        L["n_censor_count"]
        M["Time Intervals"]
    end
    
    subgraph "Summary Statistics"
        N["median_survival"]
        O["restricted_mean_survival"]
        P["Quantiles"]
    end
    
    B --> F
    B --> G
    B --> H
    B --> I
    C --> J
    C --> K
    C --> L
    C --> M
    D --> N
    D --> O
    D --> P
```

**Result Object Structure**

The standardized output follows the `omopgenerics` framework with specific result types:

| Result Type | Variable Names | Estimate Names |
|-------------|---------------|----------------|
| `survival_probability` | `outcome` | `estimate`, `estimate_95CI_lower`, `estimate_95CI_upper` |
| `survival_events` | `outcome` | `n_risk_count`, `n_events_count`, `n_censor_count` |
| `survival_summary` | `outcome` | `median_survival`, `restricted_mean_survival` |
| `survival_attrition` | Various | `number_records`, `number_subjects` |

Sources: [R/estimateSurvival.R:881-912](), [R/estimateSurvival.R:914-944]()

## Usage Examples

### Basic Single Event Analysis

```r
cdm <- mockMGUS2cdm()
surv <- estimateSingleEventSurvival(
  cdm = cdm,
  targetCohortTable = "mgus_diagnosis",
  targetCohortId = 1,
  outcomeCohortTable = "death_cohort",
  outcomeCohortId = 1,
  eventGap = 7
)
```

### Stratified Analysis

```r
surv_stratified <- estimateSingleEventSurvival(
  cdm = cdm,
  targetCohortTable = "mgus_diagnosis",
  targetCohortId = 1,
  outcomeCohortTable = "death_cohort",
  outcomeCohortId = 1,
  strata = list(
    "age_group" = c("age"),
    "sex" = c("sex"),
    "age_and_sex" = c("age", "sex")
  )
)
```

### Multiple Cohort Analysis

```r
# Automatically analyzes all combinations
surv_multiple <- estimateSingleEventSurvival(
  cdm = cdm,
  targetCohortTable = "exposure_cohort",
  outcomeCohortTable = "outcome_cohort"
  # targetCohortId and outcomeCohortId default to all available
)
```

**Function Usage Patterns**

Sources: [tests/testthat/test-estimateSurvival.R:7-15](), [tests/testthat/test-estimateSurvival.R:85-103](), [man/estimateSingleEventSurvival.Rd:76-86]()

## Integration Points

The function integrates with other CohortSurvival components through standardized interfaces:

```mermaid
graph LR
    A["estimateSingleEventSurvival()"] --> B["asSurvivalResult()"]
    B --> C["plotSurvival()"]
    B --> D["tableSurvival()"]
    B --> E["riskTable()"]
    
    A --> F["exportSummarisedResult()"]
    F --> G["CSV Files"]
    G --> H["importSummarisedResult()"]
    
    subgraph "Input Dependencies"
        I["addCohortSurvival()"]
        J["validateInputSurvival()"]
        K["getCohortId()"]
    end
    
    I --> A
    J --> A
    K --> A
```

**Package Integration Architecture**

The function produces `omopgenerics`-compliant outputs that integrate seamlessly with the broader OMOP ecosystem and downstream visualization/analysis tools.

Sources: [R/estimateSurvival.R:313-314](), [tests/testthat/test-estimateSurvival.R:15]()