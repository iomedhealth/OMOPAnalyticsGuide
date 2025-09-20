# Page: Incidence Analysis

# Incidence Analysis

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/estimateIncidence.R](R/estimateIncidence.R)
- [tests/testthat/test-estimateIncidence.R](tests/testthat/test-estimateIncidence.R)

</details>



This document covers the incidence rate estimation functionality provided by the `estimateIncidence()` function and its supporting components. Incidence analysis calculates the rate of new events occurring in a population over specified time intervals, accounting for varying observation periods and washout criteria.

For information about the underlying cohort generation that feeds into incidence analysis, see [Cohort Generation](#4). For prevalence analysis instead of incidence, see [Prevalence Analysis](#6). For visualization of incidence results, see [Visualization and Reporting](#7).

## Main Analysis Function

The primary entry point for incidence analysis is `estimateIncidence()`, which orchestrates the entire calculation process from cohort processing through result formatting.

### Function Overview

```mermaid
graph TD
    EstInc["estimateIncidence()"] --> CheckInput["checkInputEstimateIncidence()"]
    EstInc --> GetSpecs["getIncAnalysisSpecs()"]
    EstInc --> GetInc["getIncidence()"]
    EstInc --> CalcCI["incRateCiExact()"]
    
    CheckInput --> ValidateCDM["Validate CDM reference"]
    CheckInput --> ValidateCohorts["Validate cohort tables"]
    CheckInput --> ValidateParams["Validate parameters"]
    
    GetSpecs --> ExpandGrid["Expand parameter combinations"]
    GetSpecs --> CreateAnalysisID["Create analysis_id for each spec"]
    
    GetInc --> ProcessOutcomes["Process outcome events"]
    GetInc --> ApplyWashout["Apply washout periods"]
    GetInc --> CalcPersonTime["Calculate person-time"]
    GetInc --> CountEvents["Count events by interval"]
    
    CalcCI --> ChiSquare["Chi-square confidence intervals"]
    CalcCI --> Scale100k["Scale to 100,000 person-years"]
```

**Sources:** [R/estimateIncidence.R:78-502](), [tests/testthat/test-estimateIncidence.R:1-3044]()

### Key Parameters

The `estimateIncidence()` function accepts several critical parameters that control the analysis behavior:

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `denominatorTable` | character | Cohort table containing denominator populations | required |
| `outcomeTable` | character | Cohort table containing outcome events | required |
| `interval` | character | Time intervals: "weeks", "months", "quarters", "years", "overall" | "years" |
| `outcomeWashout` | numeric | Days between outcome end and return to risk | `Inf` |
| `repeatedEvents` | logical | Allow multiple events per person | `FALSE` |
| `completeDatabaseIntervals` | logical | Require complete interval coverage | `TRUE` |

**Sources:** [R/estimateIncidence.R:78-90]()

## Data Processing Pipeline

The incidence calculation follows a systematic data transformation pipeline using temporary tables with specific naming conventions.

### Table Processing Flow

```mermaid
graph LR
    OutcomeTable["outcomeTable"] --> IncTable1["{tablePrefix}_inc_1<br/>Filter outcomes + join denominators"]
    IncTable1 --> IncTable2["{tablePrefix}_inc_2<br/>Most recent pre-cohort events<br/>+ events during follow-up"]
    IncTable2 --> IncTable3["{tablePrefix}_inc_3<br/>Index events by person/cohort"]
    IncTable3 --> IncTable4["{tablePrefix}_inc_4<br/>Join with previous event end dates"]
    IncTable4 --> GetIncidence["getIncidence()"]
    GetIncidence --> Results["Formatted Results"]
    
    DenominatorTable["denominatorTable"] --> IncTable1
```

**Sources:** [R/estimateIncidence.R:156-259]()

### Outcome Event Processing

The system processes outcome events through several transformation stages:

1. **Initial Join** - Links outcome events to denominator cohorts by `subject_id`
2. **Pre-cohort Events** - Identifies most recent events before cohort entry (for washout)
3. **During-cohort Events** - Captures events occurring during follow-up period
4. **Event Indexing** - Orders events chronologically per person/outcome combination
5. **Washout Preparation** - Joins event end dates for washout calculations

**Sources:** [R/estimateIncidence.R:156-259]()

## Analysis Specifications

The system generates analysis specifications by expanding all parameter combinations into individual analysis runs.

### Specification Generation

```mermaid
graph TD
    Params["Input Parameters"] --> ExpandGrid["tidyr::expand_grid()"]
    ExpandGrid --> Specs["Analysis Specifications"]
    
    Params --> OutcomeCohortId["outcomeCohortId"]
    Params --> DenomCohortId["denominatorCohortId"] 
    Params --> CompleteDBI["completeDatabaseIntervals"]
    Params --> OutcomeWash["outcomeWashout"]
    Params --> RepeatEvents["repeatedEvents"]
    
    Specs --> AnalysisId["analysis_id assignment"]
    AnalysisId --> IntervalFlags["weeks/months/quarters/years/overall flags"]
```

**Sources:** [R/estimateIncidence.R:519-563]()

Each analysis specification contains:
- Unique `analysis_id`
- Outcome and denominator cohort IDs
- Boolean flags for each interval type
- Washout and repeated events settings
- Database interval completion requirements

## Core Calculation Engine

The `getIncidence()` function performs the actual incidence rate calculations for each analysis specification.

### Calculation Process

```mermaid
graph TD
    GetInc["getIncidence()"] --> PrepData["Prepare analysis cohorts"]
    PrepData --> ApplyWash["Apply outcome washout"]
    ApplyWash --> CalcPersonTime["Calculate person-time at risk"]
    CalcPersonTime --> CountOutcomes["Count outcome events"]
    CountOutcomes --> GroupByInterval["Group by time intervals"]
    GroupByInterval --> CalcRates["Calculate incidence rates"]
    CalcRates --> FormatResults["Format analysis results"]
    
    ApplyWash --> CheckPrevEvents["Check previous events"]
    CheckPrevEvents --> ExcludeWashout["Exclude washout periods"]
    
    CalcPersonTime --> ObservationPeriods["Use observation_period"]
    CalcPersonTime --> CohortPeriods["Use cohort_start/end"]
    
    CountOutcomes --> FirstEventOnly["First event only (repeatedEvents=FALSE)"]
    CountOutcomes --> AllEvents["All events (repeatedEvents=TRUE)"]
```

**Sources:** [R/estimateIncidence.R:275-295]()

### Washout Period Logic

The washout mechanism prevents counting events that occur too soon after previous events:

- **Infinite washout (`Inf`)**: No time contributed after any event
- **Finite washout (days)**: Return to risk after specified days post-event
- **Zero washout (`0`)**: Immediate return to risk after event end

**Sources:** [tests/testthat/test-estimateIncidence.R:597-759]()

## Time Interval Processing

The system supports multiple time interval calculations with calendar-based boundaries.

### Interval Types

```mermaid
graph LR
    Intervals["Time Intervals"] --> Weeks["ISO weeks"]
    Intervals --> Months["Calendar months"]
    Intervals --> Quarters["Calendar quarters"] 
    Intervals --> Years["Calendar years"]
    Intervals --> Overall["Overall study period"]
    
    CompleteDBI["completeDatabaseIntervals"] --> FullPeriods["Require complete interval coverage"]
    CompleteDBI --> PartialPeriods["Allow partial interval coverage"]
```

**Sources:** [R/estimateIncidence.R:40-47](), [tests/testthat/test-estimateIncidence.R:502-595]()

### Complete Database Intervals

When `completeDatabaseIntervals = TRUE`, the system only includes intervals where the denominator cohort spans the entire calendar period (e.g., full calendar year for yearly intervals).

**Sources:** [tests/testthat/test-estimateIncidence.R:1819-1976]()

## Confidence Interval Calculation

Incidence rates include exact confidence intervals based on the Poisson distribution.

### CI Calculation Method

```mermaid
graph TD
    EventCount["outcome_count"] --> ChiSquare["Chi-square distribution"]
    PersonYears["person_years"] --> ChiSquare
    ChiSquare --> LowerCI["95% CI Lower"]
    ChiSquare --> UpperCI["95% CI Upper"]
    
    LowerCI --> Scale1["Scale to 100,000 PY"]
    UpperCI --> Scale2["Scale to 100,000 PY"]
    
    Scale1 --> Round1["Round to 3 decimals"]
    Scale2 --> Round2["Round to 3 decimals"]
```

The exact formula uses chi-square quantiles:
- Lower CI: `qchisq(0.025, df=2*events) / (2*person_years) * 100000`
- Upper CI: `qchisq(0.975, df=2*(events+1)) / (2*person_years) * 100000`

**Sources:** [R/estimateIncidence.R:506-516]()

## Result Structure

The function returns a `summarised_result` object containing incidence estimates, analysis settings, and attrition information.

### Result Components

```mermaid
graph TD
    Results["summarised_result"] --> IncidenceData["Incidence estimates"]
    Results --> Settings["Analysis settings"]
    Results --> Attrition["Attrition information"]
    
    IncidenceData --> DenomCount["denominator_count"]
    IncidenceData --> OutcomeCount["outcome_count"] 
    IncidenceData --> PersonDays["person_days"]
    IncidenceData --> PersonYears["person_years"]
    IncidenceData --> IncRate["incidence_100000_pys"]
    IncidenceData --> CILower["incidence_100000_pys_95CI_lower"]
    IncidenceData --> CIUpper["incidence_100000_pys_95CI_upper"]
    
    Settings --> ResultType["result_type: 'incidence'"]
    Settings --> AnalysisParams["Analysis parameters"]
    Settings --> CohortSettings["Denominator cohort settings"]
    
    Attrition --> AttritionType["result_type: 'incidence_attrition'"]
    Attrition --> ExclusionReasons["Exclusion reasons and counts"]
```

**Sources:** [R/estimateIncidence.R:419-494]()

### Estimate Names

Each result row contains one of these estimate types:
- `denominator_count`: Number of people in denominator
- `outcome_count`: Number of outcome events
- `person_days`: Total person-days at risk
- `person_years`: Total person-years at risk  
- `incidence_100000_pys`: Incidence rate per 100,000 person-years
- `incidence_100000_pys_95CI_lower`: Lower 95% confidence bound
- `incidence_100000_pys_95CI_upper`: Upper 95% confidence bound

**Sources:** [R/estimateIncidence.R:437-445]()

## Error Handling and Validation

The system includes comprehensive input validation to ensure data quality and parameter consistency.

### Validation Checks

```mermaid
graph TD
    Validation["Input Validation"] --> CDMCheck["CDM reference validation"]
    Validation --> TableCheck["Cohort table existence"]
    Validation --> ParamCheck["Parameter type validation"]
    Validation --> CohortCheck["Cohort ID validation"]
    
    CDMCheck --> CDMRef["Check CDM reference object"]
    TableCheck --> DenomExists["denominatorTable exists"]
    TableCheck --> OutcomeExists["outcomeTable exists"]
    ParamCheck --> IntervalValid["interval values valid"]
    ParamCheck --> WashoutValid["outcomeWashout numeric"]
    CohortCheck --> IDsExist["Cohort IDs exist in tables"]
    CohortCheck --> NoOverlap["Denominator ≠ outcome cohorts"]
```

**Sources:** [R/estimateIncidence.R:102-153](), [tests/testthat/test-estimateIncidence.R:2431-2514]()

The validation prevents common errors such as:
- Using the same cohort as both denominator and outcome
- Specifying non-existent cohort IDs
- Invalid interval specifications
- Missing required tables in CDM