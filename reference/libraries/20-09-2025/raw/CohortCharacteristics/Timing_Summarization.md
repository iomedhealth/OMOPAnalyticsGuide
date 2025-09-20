# Page: Timing Summarization

# Timing Summarization

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/summariseCohortTiming.R](R/summariseCohortTiming.R)
- [inst/doc/summarise_cohort_timing.html](inst/doc/summarise_cohort_timing.html)

</details>



This document details the `summariseCohortTiming` function and its implementation for analyzing temporal relationships between cohort entries. The function calculates time intervals between different cohort entries for the same subjects, providing summary statistics for time-to-event analysis.

For visualization of timing analysis results, see [Timing Visualization](#3.4.2). For formatted table outputs of timing data, see [Timing Tables](#3.4.3).

## Function Overview

The `summariseCohortTiming` function analyzes the temporal relationships between cohort entries by calculating the number of days between entry dates across different cohorts for the same subjects.

```mermaid
graph TD
    subgraph "Input Processing"
        input["cohort table"]
        params["cohortId, strata, restrictToFirstEntry, estimates"]
        validation["omopgenerics validation"]
    end
    
    subgraph "Core Calculation"
        filter["PatientProfiles::filterCohortId"]
        first_entry["Optional: First entry filtering"]
        self_join["Self inner_join on subject_id"]
        date_diff["CDMConnector::datediff calculation"]
        collect["dplyr::collect"]
    end
    
    subgraph "Summarization"
        summarise["PatientProfiles::summariseResult"]
        combinations["getCombinations for all pairs"]
        settings["Add result settings"]
    end
    
    subgraph "Output"
        result["summarised_result object"]
    end
    
    input --> validation
    params --> validation
    validation --> filter
    filter --> first_entry
    first_entry --> self_join
    self_join --> date_diff
    date_diff --> collect
    collect --> summarise
    summarise --> combinations
    combinations --> settings
    settings --> result
```

Sources: [R/summariseCohortTiming.R:45-177]()

## Key Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `cohort` | cohort_table | Input cohort table containing subjects and entry dates |
| `cohortId` | numeric/NULL | Specific cohort IDs to analyze (NULL for all) |
| `strata` | list | Stratification variables for subgroup analysis |
| `restrictToFirstEntry` | logical | Whether to use only first entry per subject per cohort |
| `estimates` | character | Summary statistics to calculate (min, q25, median, q75, max, density) |

Sources: [R/summariseCohortTiming.R:45-50]()

## Implementation Architecture

The function follows a systematic approach to calculate inter-cohort timing:

```mermaid
flowchart LR
    subgraph "Data Preparation"
        A["cohort table"] --> B["filterCohortId"]
        B --> C["addCohortName"]
        C --> D["Optional: First entry filter"]
    end
    
    subgraph "Timing Calculation"
        D --> E["Self-join by subject_id"]
        E --> F["Filter different cohorts"]
        F --> G["datediff calculation"]
        G --> H["days_between_cohort_entries"]
    end
    
    subgraph "Result Generation"
        H --> I["PatientProfiles::summariseResult"]
        I --> J["getCombinations"]
        J --> K["newSummarisedResult"]
    end
    
    subgraph "Helper Functions"
        L["getCohortComp"]
        M["getStratas"]
        N["getCombinations"]
    end
    
    J --> L
    J --> M
    K --> N
```

Sources: [R/summariseCohortTiming.R:72-117](), [R/summariseCohortTiming.R:179-220]()

## Core Calculation Logic

The timing calculation uses a self-join approach where the cohort table is joined with itself to create all possible cohort pair combinations for each subject:

1. **Reference cohort**: Original cohort entries with suffix `_reference`
2. **Comparator cohort**: Same cohort table with suffix `_comparator`
3. **Date difference**: Calculated using `CDMConnector::datediff` with day interval
4. **Filtering**: Excludes same-cohort comparisons (`cohort_name_reference != cohort_name_comparator`)

The key calculation generates `days_between_cohort_entries` as:
```r
days_between_cohort_entries = as.integer(CDMConnector::datediff(
  "cohort_start_date",
  "cohort_start_date_comparator", 
  interval = "day"
))
```

Sources: [R/summariseCohortTiming.R:85-117]()

## First Entry Restriction

When `restrictToFirstEntry = TRUE`, the function filters to only the earliest entry per subject per cohort:

```mermaid
graph LR
    A["All cohort entries"] --> B["group_by(subject_id, cohort_definition_id)"]
    B --> C["filter(cohort_start_date == min(cohort_start_date))"]
    C --> D["ungroup()"]
    D --> E["First entries only"]
```

This ensures timing calculations reflect time between first exposures rather than all possible entry combinations.

Sources: [R/summariseCohortTiming.R:76-81]()

## Helper Functions

### getCohortComp

Generates all valid cohort comparison pairs, excluding self-comparisons:

```mermaid
graph TD
    A["cohortNames vector"] --> B["tidyr::expand_grid"]
    B --> C["cohort_name_reference × cohort_name_comparator"]
    C --> D["filter(reference != comparator)"]
    D --> E["omopgenerics::uniteGroup"]
    E --> F["Combined group names"]
```

Sources: [R/summariseCohortTiming.R:179-187]()

### getStratas

Extracts unique strata combinations from the data:

```mermaid
graph LR
    A["strata list"] --> B["purrr::map over strata"]
    B --> C["select + distinct for each"]
    C --> D["omopgenerics::uniteStrata"]
    D --> E["bind_rows with overall"]
    E --> F["Complete strata combinations"]
```

Sources: [R/summariseCohortTiming.R:188-200]()

### getCombinations

Creates the full combination matrix for result completeness by expanding all combinations of groups, strata, and estimate types.

Sources: [R/summariseCohortTiming.R:201-220]()

## Output Structure

The function returns a `summarised_result` object with:

| Component | Description |
|-----------|-------------|
| `result_type` | "summarise_cohort_timing" |
| `group_name` | "cohort_name_reference &&& cohort_name_comparator" |
| `variable_name` | "days_between_cohort_entries", "number records", "number subjects" |
| `estimate_name` | Statistics specified in `estimates` parameter |
| `estimate_value` | Calculated timing statistics |

The settings include `restrict_to_first_entry` to track the analysis configuration.

Sources: [R/summariseCohortTiming.R:167-174]()

## Density Estimation

When "density" is included in estimates, the function automatically expands this to "density_x" and "density_y" components for plotting density curves of timing distributions.

Sources: [R/summariseCohortTiming.R:140-142]()