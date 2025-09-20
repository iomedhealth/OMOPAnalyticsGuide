# Page: Data Transformation

# Data Transformation

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/tidy.R](R/tidy.R)
- [tests/testthat/test-tidy.R](tests/testthat/test-tidy.R)

</details>



## Purpose and Scope

The data transformation system provides utilities for converting `summarised_result` objects into different tabular formats optimized for analysis and visualization. The primary function `tidySummarisedResult` serves as a comprehensive data reshaping tool that can split complex column structures, pivot estimates, and add metadata columns to create analysis-ready data frames.

This system focuses specifically on data structure transformation rather than visual formatting. For table formatting and styling, see [Formatting Pipeline](#2.2). For input validation of transformation parameters, see [Input Validation System](#4.2).

## Core Transformation Function

The main transformation function `tidySummarisedResult` accepts a `summarised_result` object and applies a series of configurable transformations to restructure the data:

```mermaid
graph TD
    INPUT["summarised_result input"]
    VALIDATE["Input Validation"]
    
    subgraph "Column Splitting Phase"
        SPLIT_GROUP["splitGroup()"]
        SPLIT_STRATA["splitStrata()"] 
        SPLIT_ADDITIONAL["splitAdditional()"]
    end
    
    subgraph "Data Enhancement Phase"
        ADD_SETTINGS["addSettings()"]
        PIVOT_ESTIMATES["pivotEstimates()"]
        RELOCATE["Column Reordering"]
    end
    
    OUTPUT["tibble output"]
    
    INPUT --> VALIDATE
    VALIDATE --> SPLIT_GROUP
    SPLIT_GROUP --> SPLIT_STRATA
    SPLIT_STRATA --> SPLIT_ADDITIONAL
    SPLIT_ADDITIONAL --> ADD_SETTINGS
    ADD_SETTINGS --> PIVOT_ESTIMATES
    PIVOT_ESTIMATES --> RELOCATE
    RELOCATE --> OUTPUT
```

*Data Transformation Pipeline Flow*

The function signature and core parameters are defined in [R/tidy.R:38-44]():

- `result`: Input `summarised_result` object
- `splitGroup`: Boolean controlling group column splitting
- `splitStrata`: Boolean controlling strata column splitting  
- `splitAdditional`: Boolean controlling additional column splitting
- `settingsColumn`: Specifies which settings to add as columns
- `pivotEstimatesBy`: Controls estimate pivoting strategy
- `nameStyle`: Defines naming convention for pivoted columns

**Sources:** [R/tidy.R:17-66]()

## Transformation Phases

### Phase 1: Column Splitting

The splitting phase decomposes complex nested column structures into separate columns for easier analysis. Each splitting operation is conditional based on function parameters:

```mermaid
flowchart LR
    subgraph "Input Structure"
        GROUP_NAME["group_name"]
        GROUP_LEVEL["group_level"] 
        STRATA_NAME["strata_name"]
        STRATA_LEVEL["strata_level"]
        ADDITIONAL_NAME["additional_name"]
        ADDITIONAL_LEVEL["additional_level"]
    end
    
    subgraph "Splitting Functions"
        SPLIT_G["splitGroup()"]
        SPLIT_S["splitStrata()"]
        SPLIT_A["splitAdditional()"]
    end
    
    subgraph "Output Structure"
        COHORT_NAME["cohort_name"]
        AGE_GROUP["age_group"]
        SEX["sex"]
        INDIVIDUAL_COLS["Individual columns per split"]
    end
    
    GROUP_NAME --> SPLIT_G
    GROUP_LEVEL --> SPLIT_G
    STRATA_NAME --> SPLIT_S
    STRATA_LEVEL --> SPLIT_S
    ADDITIONAL_NAME --> SPLIT_A
    ADDITIONAL_LEVEL --> SPLIT_A
    
    SPLIT_G --> COHORT_NAME
    SPLIT_S --> AGE_GROUP
    SPLIT_S --> SEX
    SPLIT_A --> INDIVIDUAL_COLS
```

*Column Splitting Operations*

The splitting logic is executed conditionally in [R/tidy.R:54-57]():

```
if (isTRUE(splitGroup)) result <- result |> splitGroup()
if (isTRUE(splitStrata)) result <- result |> splitStrata()
if (isTRUE(splitAdditional)) result <- result |> splitAdditional()
```

**Sources:** [R/tidy.R:54-57](), [tests/testthat/test-tidy.R:12-16]()

### Phase 2: Data Enhancement

The enhancement phase adds metadata and reshapes estimate columns:

```mermaid
graph LR
    subgraph "Settings Integration"
        SETTINGS_COL["settingsColumn parameter"]
        ADD_SET["addSettings()"]
        RESULT_TYPE["result_type"]
        PACKAGE_NAME["package_name"] 
        PACKAGE_VERSION["package_version"]
    end
    
    subgraph "Estimate Pivoting"
        PIVOT_BY["pivotEstimatesBy parameter"]
        PIVOT_EST["pivotEstimates()"]
        NAME_STYLE["nameStyle parameter"]
        ESTIMATE_COLS["count, mean, sd, percentage columns"]
    end
    
    subgraph "Final Structure"
        RELOCATE["dplyr::relocate()"]
        TIBBLE_OUT["Final tibble output"]
    end
    
    SETTINGS_COL --> ADD_SET
    ADD_SET --> RESULT_TYPE
    ADD_SET --> PACKAGE_NAME
    ADD_SET --> PACKAGE_VERSION
    
    PIVOT_BY --> PIVOT_EST
    NAME_STYLE --> PIVOT_EST
    PIVOT_EST --> ESTIMATE_COLS
    
    RESULT_TYPE --> RELOCATE
    PACKAGE_NAME --> RELOCATE
    PACKAGE_VERSION --> RELOCATE
    ESTIMATE_COLS --> RELOCATE
    RELOCATE --> TIBBLE_OUT
```

*Data Enhancement Operations*

**Sources:** [R/tidy.R:60-63](), [tests/testthat/test-tidy.R:6-10]()

## Function Parameters and Configuration

### Splitting Control Parameters

| Parameter | Type | Default | Purpose |
|-----------|------|---------|---------|
| `splitGroup` | logical | `TRUE` | Split group name-level pairs into separate columns |
| `splitStrata` | logical | `TRUE` | Split strata name-level pairs into separate columns |
| `splitAdditional` | logical | `TRUE` | Split additional name-level pairs into separate columns |

### Data Enhancement Parameters

| Parameter | Type | Default | Purpose |
|-----------|------|---------|---------|
| `settingsColumn` | character | `settingsColumns(result)` | Settings columns to add to output |
| `pivotEstimatesBy` | character | `"estimate_name"` | Columns to pivot estimates by |
| `nameStyle` | character | `NULL` | Glue-style naming pattern for pivoted columns |

**Sources:** [R/tidy.R:38-44]()

### Pivoting Strategies

The `pivotEstimatesBy` parameter supports multiple pivoting approaches:

1. **By estimate name**: `pivotEstimatesBy = "estimate_name"` creates columns like `count`, `mean`, `sd`
2. **By variable and estimate**: `pivotEstimatesBy = c("variable_name", "estimate_name")` creates columns like `count_number subjects`, `mean_age`
3. **Custom naming**: Using `nameStyle = "{estimate_name}_{variable_name}"` creates columns like `count_Medications`, `percentage_Medications`

**Sources:** [tests/testthat/test-tidy.R:17-32]()

## Data Type Preservation

The transformation system preserves appropriate data types during the reshaping process:

```mermaid
graph TD
    subgraph "Input Types"
        EST_TYPE["estimate_type column"]
        EST_VALUE["estimate_value column (character)"]
    end
    
    subgraph "Type Conversion"
        INTEGER_CHECK["integer type check"]
        NUMERIC_CHECK["numeric type check"] 
        DATE_CHECK["date type check"]
    end
    
    subgraph "Output Types"
        INT_COL["integer columns"]
        NUM_COL["numeric columns"]
        DATE_COL["Date columns"]
    end
    
    EST_TYPE --> INTEGER_CHECK
    EST_TYPE --> NUMERIC_CHECK
    EST_TYPE --> DATE_CHECK
    EST_VALUE --> INTEGER_CHECK
    EST_VALUE --> NUMERIC_CHECK
    EST_VALUE --> DATE_CHECK
    
    INTEGER_CHECK --> INT_COL
    NUMERIC_CHECK --> NUM_COL
    DATE_CHECK --> DATE_COL
```

*Data Type Preservation During Transformation*

**Sources:** [tests/testthat/test-tidy.R:8-10](), [tests/testthat/test-tidy.R:30-32](), [tests/testthat/test-tidy.R:98]()

## Integration with Visualization Pipeline

The transformation system serves as a crucial bridge between raw OMOP results and visualization components:

```mermaid
graph TB
    subgraph "Input Layer"
        SUMMARISED_RESULT["summarised_result objects"]
    end
    
    subgraph "Transformation Layer"
        TIDY_FUNCTION["tidySummarisedResult()"]
        SPLIT_FUNCS["splitGroup(), splitStrata(), splitAdditional()"]
        ADD_SETTINGS["addSettings()"]
        PIVOT_EST["pivotEstimates()"]
    end
    
    subgraph "Output Consumers"
        VIS_TABLE["visOmopTable()"]
        PLOT_FUNCS["barPlot(), scatterPlot(), boxPlot()"]
        CUSTOM_ANALYSIS["Custom Analysis Workflows"]
    end
    
    SUMMARISED_RESULT --> TIDY_FUNCTION
    TIDY_FUNCTION --> SPLIT_FUNCS
    SPLIT_FUNCS --> ADD_SETTINGS
    ADD_SETTINGS --> PIVOT_EST
    
    PIVOT_EST --> VIS_TABLE
    PIVOT_EST --> PLOT_FUNCS
    PIVOT_EST --> CUSTOM_ANALYSIS
```

*Integration with Visualization Components*

**Sources:** [R/tidy.R:17-66](), [tests/testthat/test-tidy.R:1-43]()