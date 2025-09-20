# Page: Column Management Functions

# Column Management Functions

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [NAMESPACE](NAMESPACE)
- [NEWS.md](NEWS.md)
- [R/table.R](R/table.R)

</details>



This document covers the utility functions for managing and discovering available columns in CohortCharacteristics result objects. These functions help users identify which columns can be used in plot and table configurations, providing programmatic access to column metadata for visualization and reporting workflows.

For information about the core analysis functions that generate the results these utilities operate on, see [Core Analysis Workflow](#2). For mock data generation and benchmarking utilities, see [Mock Data and Benchmarking](#4.2).

## Purpose and Scope

Column management functions serve as discovery utilities that expose the available columns in `summarised_result` objects for use in plotting and table generation. They provide standardized access to different column categories including group columns, strata columns, additional columns, settings columns, and estimate names.

## Column Management Architecture

The column management system provides two primary discovery functions that expose different subsets of available columns based on their intended use:

```mermaid
graph TB
    subgraph "Input"
        RESULT["summarised_result object"]
    end
    
    subgraph "Column Discovery Functions"
        PLOT["availablePlotColumns()"]
        TABLE["availableTableColumns()"]
    end
    
    subgraph "Column Sources"
        CDM["cdm_name"]
        GROUP["groupColumns()"]
        STRATA["strataColumns()"]
        ADDITIONAL["additionalColumns()"]
        SETTINGS["settingsColumns()"]
        ESTIMATES["estimate_name values"]
    end
    
    subgraph "Usage Context"
        PLOT_ARGS["Plot Arguments<br/>facet, colour"]
        TABLE_ARGS["Table Arguments<br/>header, groupColumn, hide"]
    end
    
    RESULT --> PLOT
    RESULT --> TABLE
    
    CDM --> PLOT
    GROUP --> PLOT
    STRATA --> PLOT
    ADDITIONAL --> PLOT
    SETTINGS --> PLOT
    ESTIMATES --> PLOT
    
    CDM --> TABLE
    GROUP --> TABLE
    STRATA --> TABLE
    ADDITIONAL --> TABLE
    SETTINGS --> TABLE
    
    PLOT --> PLOT_ARGS
    TABLE --> TABLE_ARGS
```

Sources: [R/table.R:18-58](), [NAMESPACE:3-5]()

## Available Columns Functions

### availablePlotColumns Function

The `availablePlotColumns()` function returns all columns available for use in plot configuration arguments such as `facet` and `colour`:

```mermaid
flowchart TD
    INPUT["summarised_result"]
    VALIDATE["omopgenerics::validateResultArgument()"]
    
    subgraph "Column Collection"
        CDM_NAME["cdm_name"]
        GROUP_COLS["omopgenerics::groupColumns()"]
        STRATA_COLS["omopgenerics::strataColumns()"]
        ADDITIONAL_COLS["omopgenerics::additionalColumns()"]
        SETTINGS_COLS["omopgenerics::settingsColumns()"]
        ESTIMATE_NAMES["unique(result$estimate_name)"]
    end
    
    OUTPUT["Character vector of available columns"]
    
    INPUT --> VALIDATE
    VALIDATE --> CDM_NAME
    VALIDATE --> GROUP_COLS
    VALIDATE --> STRATA_COLS
    VALIDATE --> ADDITIONAL_COLS
    VALIDATE --> SETTINGS_COLS
    VALIDATE --> ESTIMATE_NAMES
    
    CDM_NAME --> OUTPUT
    GROUP_COLS --> OUTPUT
    STRATA_COLS --> OUTPUT
    ADDITIONAL_COLS --> OUTPUT
    SETTINGS_COLS --> OUTPUT
    ESTIMATE_NAMES --> OUTPUT
```

The function combines six different column sources to provide comprehensive column availability for plotting functions.

Sources: [R/table.R:18-29]()

### availableTableColumns Function

The `availableTableColumns()` function returns columns available for table configuration arguments such as `header`, `groupColumn`, and `hide`:

```mermaid
flowchart TD
    INPUT["summarised_result"]
    VALIDATE["omopgenerics::validateResultArgument()"]
    
    subgraph "Column Collection"
        CDM_NAME["cdm_name"]
        GROUP_COLS["omopgenerics::groupColumns()"]
        STRATA_COLS["omopgenerics::strataColumns()"]
        ADDITIONAL_COLS["omopgenerics::additionalColumns()"]
        SETTINGS_COLS["omopgenerics::settingsColumns()"]
    end
    
    OUTPUT["Character vector of available columns"]
    
    INPUT --> VALIDATE
    VALIDATE --> CDM_NAME
    VALIDATE --> GROUP_COLS
    VALIDATE --> STRATA_COLS
    VALIDATE --> ADDITIONAL_COLS
    VALIDATE --> SETTINGS_COLS
    
    CDM_NAME --> OUTPUT
    GROUP_COLS --> OUTPUT
    STRATA_COLS --> OUTPUT
    ADDITIONAL_COLS --> OUTPUT
    SETTINGS_COLS --> OUTPUT
```

Note that `availableTableColumns()` excludes `estimate_name` values, as these are typically not used for table structuring but rather for data presentation.

Sources: [R/table.R:48-58]()

## Column Type Categories

The column management system organizes columns into distinct categories based on their role in the analysis workflow:

| Column Type | Source Function | Description | Available in Plots | Available in Tables |
|-------------|-----------------|-------------|-------------------|-------------------|
| CDM Name | Static | Database/CDM identifier | ✓ | ✓ |
| Group Columns | `omopgenerics::groupColumns()` | Cohort and analysis groupings | ✓ | ✓ |
| Strata Columns | `omopgenerics::strataColumns()` | Stratification variables | ✓ | ✓ |
| Additional Columns | `omopgenerics::additionalColumns()` | Custom metadata columns | ✓ | ✓ |
| Settings Columns | `omopgenerics::settingsColumns()` | Analysis configuration parameters | ✓ | ✓ |
| Estimate Names | `result$estimate_name` | Statistical estimate identifiers | ✓ | ✗ |

Sources: [R/table.R:23-28](), [R/table.R:53-57]()

## Integration with omopgenerics

The column management functions delegate to `omopgenerics` package functions for accessing standardized column categories:

```mermaid
graph TB
    subgraph "CohortCharacteristics"
        AVAIL_PLOT["availablePlotColumns()"]
        AVAIL_TABLE["availableTableColumns()"]
    end
    
    subgraph "omopgenerics Column Functions"
        GROUP_FN["groupColumns()"]
        STRATA_FN["strataColumns()"]
        ADDITIONAL_FN["additionalColumns()"]
        SETTINGS_FN["settingsColumns()"]
        VALIDATE_FN["validateResultArgument()"]
    end
    
    subgraph "Result Object Structure"
        RESULT_OBJ["summarised_result"]
        METADATA["Column metadata"]
        ESTIMATE_DATA["Estimate values"]
    end
    
    AVAIL_PLOT --> VALIDATE_FN
    AVAIL_TABLE --> VALIDATE_FN
    AVAIL_PLOT --> GROUP_FN
    AVAIL_PLOT --> STRATA_FN
    AVAIL_PLOT --> ADDITIONAL_FN
    AVAIL_PLOT --> SETTINGS_FN
    AVAIL_TABLE --> GROUP_FN
    AVAIL_TABLE --> STRATA_FN
    AVAIL_TABLE --> ADDITIONAL_FN
    AVAIL_TABLE --> SETTINGS_FN
    
    GROUP_FN --> RESULT_OBJ
    STRATA_FN --> RESULT_OBJ
    ADDITIONAL_FN --> RESULT_OBJ
    SETTINGS_FN --> RESULT_OBJ
    VALIDATE_FN --> RESULT_OBJ
    
    RESULT_OBJ --> METADATA
    RESULT_OBJ --> ESTIMATE_DATA
```

This design ensures consistency with the broader OMOP ecosystem and provides standardized access to result object metadata.

Sources: [R/table.R:20](), [R/table.R:24-27](), [R/table.R:50](), [R/table.R:54-57](), [NAMESPACE:43-50]()

## Usage Patterns

The column management functions are typically used in interactive workflows to discover available options before configuring plots or tables:

1. **Interactive Discovery**: Users call these functions to see what columns are available for customization
2. **Programmatic Configuration**: Functions can be used to build dynamic plot and table configurations
3. **Validation**: The functions provide a way to validate that requested columns exist before attempting to use them

The functions serve as the bridge between the complex internal structure of `summarised_result` objects and user-friendly column selection for visualization and reporting functions.

Sources: [R/table.R:9-17](), [R/table.R:39-47]()