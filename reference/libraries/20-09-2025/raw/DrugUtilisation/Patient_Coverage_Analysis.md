# Page: Patient Coverage Analysis

# Patient Coverage Analysis

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/summariseProportionOfPatientsCovered.R](R/summariseProportionOfPatientsCovered.R)
- [man/summariseProportionOfPatientsCovered.Rd](man/summariseProportionOfPatientsCovered.Rd)
- [tests/testthat/test-summariseProportionOfPatientsCovered.R](tests/testthat/test-summariseProportionOfPatientsCovered.R)

</details>



This document covers the patient coverage analysis functionality in DrugUtilisation, specifically the "proportion of patients covered" (PPC) method for assessing treatment persistence and adherence patterns over time.

The PPC method calculates the proportion of patients still in observation who remain in their cohort on any given day following their first cohort entry. This provides insights into treatment persistence, discontinuation patterns, and adherence over specified follow-up periods.

For information about other treatment analysis methods, see [Treatment Analysis](#6.2) and [Drug Restart Analysis](#6.3).

## Overview and Purpose

Patient coverage analysis addresses the fundamental question: "What proportion of patients continue their treatment over time?" This is accomplished through the `summariseProportionOfPatientsCovered()` function, which implements a longitudinal analysis tracking patient cohort membership day-by-day.

The analysis produces time-series data showing how treatment coverage changes over the follow-up period, accounting for patients leaving observation and treatment discontinuation events.

```mermaid
graph TD
    Input["cohort_table"] --> PPC["summariseProportionOfPatientsCovered()"]
    PPC --> Timeline["Daily Time Points"]
    Timeline --> Denominator["Patients Still in Observation"]
    Timeline --> Numerator["Patients Still in Cohort"]
    Denominator --> Calculation["PPC = Numerator / Denominator"]
    Numerator --> Calculation
    Calculation --> CI["Confidence Intervals"]
    Calculation --> Output["summarised_result"]
    CI --> Output
```

**Primary Function Analysis**
```mermaid
graph LR
    subgraph "Input Processing"
        A["cohort_table"] --> B["validateCohort()"]
        C["cohortId"] --> D["validateCohortIdArgument()"]
        E["strata"] --> F["validateStrata()"]
        G["followUpDays"] --> H["assertNumeric()"]
    end
    
    subgraph "Main Processing"
        I["getPPC()"] --> J["addFutureObservationQuery()"]
        J --> K["Daily Coverage Calculation"]
        K --> L["getOverallCounts()"]
        K --> M["getStratifiedCounts()"]
    end
    
    subgraph "Output Generation"
        N["calculatePPC()"] --> O["Confidence Intervals"]
        O --> P["summarised_result"]
    end
    
    B --> I
    D --> I
    F --> I
    H --> I
    L --> N
    M --> N
```

Sources: [R/summariseProportionOfPatientsCovered.R:46-143](), [tests/testthat/test-summariseProportionOfPatientsCovered.R:1-91]()

## Core Function Architecture

The patient coverage analysis system is built around the main exported function `summariseProportionOfPatientsCovered()` with several supporting internal functions that handle different aspects of the calculation.

### Main Function Structure

| Component | Function | Purpose |
|-----------|----------|---------|
| Entry Point | `summariseProportionOfPatientsCovered()` | Main exported function, validates inputs and orchestrates analysis |
| Cohort Processing | `getPPC()` | Processes individual cohorts and manages day-by-day calculations |
| Overall Metrics | `getOverallCounts()`, `getOverallStartingCount()` | Calculates non-stratified coverage metrics |
| Stratified Metrics | `getStratifiedCounts()`, `getStratifiedStartingCount()` | Calculates stratified coverage metrics |
| Statistical Calculations | `calculatePPC()` | Computes PPC percentages with confidence intervals |

### Function Call Flow

```mermaid
graph TD
    Start["summariseProportionOfPatientsCovered()"] --> Validate["Input Validation"]
    Validate --> MaxDays["Calculate Follow-up Period"]
    MaxDays --> Loop["For Each Cohort ID"]
    Loop --> GetPPC["getPPC(cohort, cohortId, strata, days)"]
    
    subgraph "getPPC Processing"
        GetPPC --> Collect["Collect Cohort to Memory"]
        Collect --> ObsEnd["addFutureObservationQuery()"]
        ObsEnd --> TimeLoop["For Each Day 0 to followUpDays"]
        TimeLoop --> Overall["getOverallCounts()"]
        TimeLoop --> Strata["getStratifiedCounts()"]
        Overall --> NextDay["Next Day"]
        Strata --> NextDay
        NextDay --> TimeLoop
    end
    
    GetPPC --> Combine["Combine Results"]
    Combine --> Calculate["calculatePPC()"]
    Calculate --> Format["Format as summarised_result"]
    Format --> Return["Return Result"]
```

Sources: [R/summariseProportionOfPatientsCovered.R:46-143](), [R/summariseProportionOfPatientsCovered.R:145-230]()

## Input Parameters and Validation

The function accepts several key parameters that control the analysis scope and methodology:

### Parameter Specifications

| Parameter | Type | Description | Validation |
|-----------|------|-------------|------------|
| `cohort` | `cohort_table` | Source cohort data | `validateCohort()` |
| `cohortId` | `integer` or `NULL` | Specific cohort(s) to analyze | `validateCohortIdArgument()` |
| `strata` | `list` | Stratification variables | `validateStrata()` |
| `followUpDays` | `integer` or `NULL` | Follow-up duration | `assertNumeric(min=1, length=1)` |

### Follow-up Period Determination

When `followUpDays` is `NULL`, the function automatically calculates the maximum follow-up period based on cohort data:

```mermaid
graph LR
    Input["followUpDays = NULL"] --> Calculate["Calculate Max Days"]
    Calculate --> Group["Group by cohort_definition_id, subject_id"]
    Group --> Sum["Sum days_in_cohort per patient"]
    Sum --> Max["Max days per cohort"]
    Max --> Apply["Apply to Analysis"]
    
    Input2["followUpDays = integer"] --> Direct["Use Specified Value"]
    Direct --> Apply
```

The calculation involves computing `datediff()` between cohort start and end dates for each patient, summing multiple cohort episodes per patient, and taking the maximum across all patients in each cohort.

Sources: [R/summariseProportionOfPatientsCovered.R:73-92](), [tests/testthat/test-summariseProportionOfPatientsCovered.R:38-48]()

## Daily Coverage Calculation Process

The core analysis performs day-by-day calculations to track patient coverage over the follow-up period. This process is implemented in the `getPPC()` function and its supporting calculation functions.

### Data Preparation

Before daily calculations begin, the function:

1. **Collects cohort data**: Brings relevant cohort records into memory using `dplyr::collect()`
2. **Adds observation periods**: Uses `PatientProfiles::addFutureObservationQuery()` to determine when patients leave observation
3. **Calculates reference dates**: Determines each patient's first cohort entry date as the reference point

### Daily Calculation Logic

For each day from 0 to `followUpDays`, the analysis determines:

```mermaid
graph TD
    Day["Day i"] --> WorkingDate["working_date = min_cohort_start_date + i"]
    WorkingDate --> InCohort["in_cohort: cohort_start_date <= working_date <= cohort_end_date"]
    WorkingDate --> InObs["in_observation: observation_end_date >= working_date"]
    
    InCohort --> Numerator["Outcome Count: Distinct patients in cohort"]
    InObs --> Denominator["Denominator Count: Distinct patients in observation"]
    
    Numerator --> PPC["PPC = Outcome / Denominator"]
    Denominator --> PPC
```

### Stratification Handling

When stratification variables are provided, the analysis calculates separate metrics for each stratum combination:

| Calculation Type | Function | Purpose |
|-----------------|----------|---------|
| Overall (Day 0) | `getOverallStartingCount()` | Baseline patient counts |
| Stratified (Day 0) | `getStratifiedStartingCount()` | Baseline counts by strata |
| Overall (Day i) | `getOverallCounts()` | Daily counts overall |
| Stratified (Day i) | `getStratifiedCounts()` | Daily counts by strata |

Sources: [R/summariseProportionOfPatientsCovered.R:145-230](), [R/summariseProportionOfPatientsCovered.R:192-217](), [tests/testthat/test-summariseProportionOfPatientsCovered.R:276-496]()

## Statistical Calculations and Confidence Intervals

The PPC calculation includes statistical measures to provide confidence intervals around the proportion estimates. This is handled by the `calculatePPC()` function.

### Confidence Interval Method

The function uses the Wilson score interval method for calculating confidence intervals around proportions:

```mermaid
graph LR
    Inputs["num, den, alpha"] --> Proportion["p = num / den"]
    Proportion --> Wilson["Wilson Score Interval"]
    Wilson --> Components["z-score, adjustment terms"]
    Components --> Bounds["Upper and Lower Bounds"]
    Bounds --> Constraints["Constrain to [0,1]"]
    Constraints --> Format["Format as Percentages"]
```

The implementation applies several mathematical transformations:
- Calculate base proportion `p = num / den`
- Apply z-score for specified alpha level (default 0.05 for 95% CI)
- Use Wilson method adjustments for small sample robustness
- Constrain bounds to valid [0,1] range
- Format as percentages with two decimal places

### Output Estimates

Each time point produces multiple estimate types:

| Estimate Name | Type | Description |
|---------------|------|-------------|
| `outcome_count` | integer | Number of patients in cohort |
| `denominator_count` | integer | Number of patients in observation |
| `ppc` | percentage | Proportion of patients covered |
| `ppc_lower` | percentage | Lower confidence bound |
| `ppc_upper` | percentage | Upper confidence bound |

Sources: [R/summariseProportionOfPatientsCovered.R:314-326](), [R/summariseProportionOfPatientsCovered.R:111-125]()

## Usage Patterns and Examples

The function supports various analysis scenarios through its flexible parameter system. The test suite demonstrates key usage patterns.

### Basic Single Cohort Analysis

The simplest usage involves analyzing a single cohort over a specified follow-up period:

```r
result <- cohort |>
  summariseProportionOfPatientsCovered(followUpDays = 365)
```

This produces daily PPC values from day 0 to day 365, showing how treatment coverage changes over one year.

### Multiple Cohort Entries

The function handles patients with multiple cohort entries (treatment episodes) correctly:

```mermaid
graph TD
    Patient["Patient 1"] --> Episode1["Episode 1: Days 1-5"]
    Patient --> Gap["Gap: Days 6-9"]
    Patient --> Episode2["Episode 2: Days 10-15"]
    
    Day6["Day 6"] --> NotCovered["Not in Cohort"]
    Day10["Day 10"] --> Covered["Back in Cohort"]
    Day12["Day 12"] --> StillCovered["Still in Cohort"]
```

### Stratified Analysis

Stratification allows analysis by patient subgroups:

| Strata Configuration | Result |
|---------------------|--------|
| `strata = list()` | Overall analysis only |
| `strata = list("age_group")` | Separate PPC by age group |
| `strata = list(c("age_group", "sex"))` | Combined age and sex strata |
| `strata = list("age_group", "sex", c("age_group", "sex"))` | Multiple stratification levels |

### Automatic Follow-up Period

When `followUpDays = NULL`, the function calculates follow-up based on data:

```mermaid
graph LR
    AutoCalc["followUpDays = NULL"] --> PatientMax["Max days per patient"]
    PatientMax --> CohortMax["Max across cohort"]
    CohortMax --> Result["Optimal follow-up period"]
    
    Manual["followUpDays = 365"] --> Fixed["Fixed 365-day period"]
```

Sources: [tests/testthat/test-summariseProportionOfPatientsCovered.R:1-91](), [tests/testthat/test-summariseProportionOfPatientsCovered.R:93-167](), [tests/testthat/test-summariseProportionOfPatientsCovered.R:169-274]()

## Output Structure and Integration

The function returns a `summarised_result` object following the standardized result format used throughout the DrugUtilisation package. This ensures compatibility with downstream table and plotting functions.

### Result Structure

```mermaid
graph LR
    subgraph "Result Columns"
        A["result_id"] --> B["cdm_name"]
        B --> C["group_name = cohort_name"]
        C --> D["group_level = cohort_X"]
        D --> E["strata_name"]
        E --> F["strata_level"]
        F --> G["variable_name = overall"]
        G --> H["variable_level = overall"]
        H --> I["estimate_name"]
        I --> J["estimate_value"]
        J --> K["estimate_type"]
        K --> L["additional_name = time"]
        L --> M["additional_level = day"]
    end
```

### Analysis Settings

The result includes metadata in the settings attribute:

| Setting | Value |
|---------|-------|
| `result_type` | "summarise_proportion_of_patients_covered" |
| `package_name` | "DrugUtilisation" |
| `package_version` | Current package version |
| `cohort_table_name` | Source table name |

### Integration with Visualization

The standardized output enables direct use with visualization functions:

```mermaid
graph LR
    PPC["summariseProportionOfPatientsCovered()"] --> Result["summarised_result"]
    Result --> Plot["plotDrugUtilisation()"]
    Result --> Table["tableDrugUtilisation()"]
    Result --> Suppress["suppress()"]
    Plot --> Visual["Time Series Plots"]
    Table --> Formatted["Formatted Tables"]
    Suppress --> Protected["Privacy-Protected Results"]
```

Sources: [R/summariseProportionOfPatientsCovered.R:127-142](), [R/summariseProportionOfPatientsCovered.R:61-67](), [tests/testthat/test-summariseProportionOfPatientsCovered.R:584-602]()

## Error Handling and Edge Cases

The function includes comprehensive error handling and validation to ensure robust operation across different data scenarios.

### Input Validation Errors

| Condition | Error Message |
|-----------|---------------|
| Invalid `followUpDays` | Must be single number above zero |
| Invalid `cohortId` | Cohort ID not in settings |
| Missing strata columns | Strata variable must exist |
| Invalid cohort | Must be cohort_table object |

### Data Quality Handling

```mermaid
graph TD
    EmptyTable["Empty Cohort Table"] --> Warning["cli_warn: No records found"]
    Warning --> EmptyResult["Return emptySummarisedResult()"]
    
    EmptyAfterFilter["No Records After Filtering"] --> Inform["cli_inform: No results found"]
    Inform --> EmptyResult
    
    ValidData["Valid Data"] --> Process["Continue Processing"]
```

### Special Cases

The function handles several edge cases gracefully:

1. **Empty cohorts**: Returns empty result with appropriate warning
2. **Single-day exposures**: Correctly handles patients with same start/end dates  
3. **Observation period boundaries**: Respects observation_period_end_date limits
4. **Multiple cohort definitions**: Processes each cohort separately
5. **Missing strata combinations**: Returns empty results for non-existent combinations

### Suppression Integration

The result supports the standard `suppress()` function for privacy protection:

```r
ppc_suppressed <- result |> suppress(minCellCount = 5)
```

Sources: [tests/testthat/test-summariseProportionOfPatientsCovered.R:498-549](), [R/summariseProportionOfPatientsCovered.R:68-71](), [R/summariseProportionOfPatientsCovered.R:102-108]()