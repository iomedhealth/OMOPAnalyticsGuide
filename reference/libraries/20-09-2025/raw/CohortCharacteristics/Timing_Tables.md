# Page: Timing Tables

# Timing Tables

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [MD5](MD5)
- [NEWS.md](NEWS.md)
- [R/table.R](R/table.R)

</details>



This page documents the table generation functionality for cohort timing analysis in the CohortCharacteristics package. The `tableCohortTiming` function formats timing analysis results from [summariseCohortTiming](#3.4.1) into structured, presentation-ready tables using standardized table formats supported by the visOmopResults package.

For timing analysis summarization, see [Timing Summarization](#3.4.1). For timing visualization, see [Timing Visualization](#3.4.2). For general table infrastructure shared across all analysis types, see [Utilities and Helper Functions](#4).

## Function Architecture and Workflow Integration

The timing table functionality follows the package's standard three-tier analysis pattern, serving as the final presentation layer for timing analysis results.

```mermaid
flowchart TD
    subgraph "Timing Analysis Workflow"
        INPUT[/"Cohort Tables"/]
        SUMMARISE["summariseCohortTiming()"]
        RESULT[("summarised_result object")]
        PLOT["plotCohortTiming()"]
        TABLE["tableCohortTiming()"]
    end
    
    subgraph "Table Output Formats"
        GT["gt table"]
        FLEX["flextable"]
        REACT["reactable"]
        DT["DT table"]
        HTML["HTML output"]
    end
    
    INPUT --> SUMMARISE
    SUMMARISE --> RESULT
    RESULT --> PLOT
    RESULT --> TABLE
    TABLE --> GT
    TABLE --> FLEX
    TABLE --> REACT
    TABLE --> DT
    TABLE --> HTML
```

*Sources: [R/tableCohortTiming.R:1-50](), [R/table.R:60-125]()*

## Core Table Generation Function

The `tableCohortTiming` function serves as the primary interface for generating formatted tables from timing analysis results.

```mermaid
graph TD
    subgraph "tableCohortTiming Function"
        INPUT_RESULT["summarised_result input"]
        VALIDATE["omopgenerics::validateResultArgument()"]
        FILTER["Filter result_type = 'cohort_timing'"]
        GENERAL_TABLE["tableCohortCharacteristics()"]
        VIS_TABLE["visOmopResults::visTable()"]
        OUTPUT["Formatted table output"]
    end
    
    subgraph "Configuration Parameters"
        HEADER["header argument"]
        GROUP_COL["groupColumn argument"]
        HIDE["hide argument"]
        RENAME["rename argument"]
        TYPE["type argument"]
        OPTIONS[".options argument"]
    end
    
    INPUT_RESULT --> VALIDATE
    VALIDATE --> FILTER
    FILTER --> GENERAL_TABLE
    GENERAL_TABLE --> VIS_TABLE
    VIS_TABLE --> OUTPUT
    
    HEADER --> VIS_TABLE
    GROUP_COL --> VIS_TABLE
    HIDE --> VIS_TABLE
    RENAME --> VIS_TABLE
    TYPE --> VIS_TABLE
    OPTIONS --> VIS_TABLE
```

*Sources: [R/tableCohortTiming.R:1-50](), [R/table.R:60-125]()*

## Table Infrastructure Integration

The timing table functionality leverages the shared table infrastructure defined in the general table module, ensuring consistency across all analysis types.

```mermaid
graph TB
    subgraph "Shared Table Infrastructure"
        AVAILABLE_COLS["availableTableColumns()"]
        TABLE_CHARS["tableCohortCharacteristics()"]
        EMPTY_TABLE["emptyTable()"]
        VALIDATE_RESULT["omopgenerics::validateResultArgument()"]
    end
    
    subgraph "Timing-Specific Implementation"
        TABLE_TIMING["tableCohortTiming()"]
        TIMING_PARAMS["Timing-specific parameters"]
        TIMING_FILTER["result_type = 'cohort_timing'"]
    end
    
    subgraph "visOmopResults Integration"
        VIS_TABLE["visOmopResults::visTable()"]
        VIS_OPTIONS["Table type options"]
        VIS_FORMATTING["Formatting controls"]
    end
    
    TABLE_TIMING --> AVAILABLE_COLS
    TABLE_TIMING --> TABLE_CHARS
    TABLE_TIMING --> VALIDATE_RESULT
    TABLE_TIMING --> TIMING_FILTER
    TABLE_CHARS --> VIS_TABLE
    TIMING_PARAMS --> VIS_TABLE
    VIS_OPTIONS --> VIS_TABLE
    VIS_FORMATTING --> VIS_TABLE
```

*Sources: [R/table.R:48-58](), [R/table.R:60-125](), [R/tableCohortTiming.R:1-50]()*

## Table Column Management

The timing tables support comprehensive column management through the shared infrastructure, allowing users to control which columns are displayed, grouped, or hidden.

| Function | Purpose | Available Columns |
|----------|---------|-------------------|
| `availableTableColumns()` | Lists available columns for table customization | cdm_name, group columns, strata columns, additional columns, settings columns |
| `header` parameter | Controls table header organization | Any available table column |
| `groupColumn` parameter | Defines column grouping structure | Any available table column |
| `hide` parameter | Specifies columns to exclude from display | Any available table column plus estimate_type |

```mermaid
flowchart LR
    subgraph "Column Sources"
        CDM_NAME["cdm_name"]
        GROUP_COLS["omopgenerics::groupColumns()"]
        STRATA_COLS["omopgenerics::strataColumns()"]
        ADDITIONAL_COLS["omopgenerics::additionalColumns()"]
        SETTINGS_COLS["omopgenerics::settingsColumns()"]
    end
    
    subgraph "Column Management"
        AVAILABLE["availableTableColumns()"]
        HEADER_CONFIG["header parameter"]
        GROUP_CONFIG["groupColumn parameter"]
        HIDE_CONFIG["hide parameter"]
    end
    
    CDM_NAME --> AVAILABLE
    GROUP_COLS --> AVAILABLE
    STRATA_COLS --> AVAILABLE
    ADDITIONAL_COLS --> AVAILABLE
    SETTINGS_COLS --> AVAILABLE
    
    AVAILABLE --> HEADER_CONFIG
    AVAILABLE --> GROUP_CONFIG
    AVAILABLE --> HIDE_CONFIG
```

*Sources: [R/table.R:48-58](), [R/table.R:23-28]()*

## Result Processing and Cell Count Handling

The timing table function implements standardized result processing, including special handling for cell count suppression in accordance with privacy requirements.

```mermaid
graph TD
    subgraph "Result Processing Pipeline"
        FILTER_SETTINGS["omopgenerics::filterSettings()"]
        CHECK_VERSION["checkVersion()"]
        MODIFY_RESULTS["modifyResults function"]
        SETTINGS_JOIN["dplyr::left_join() with settings"]
        CELL_COUNT_LOGIC["Cell count suppression logic"]
        SPLIT_ALL["omopgenerics::splitAll()"]
    end
    
    subgraph "Cell Count Handling"
        COUNT_DETECT["stringr::str_detect() for count estimates"]
        DASH_CHECK["estimate_value == '-'"]
        MIN_CELL_REPLACEMENT["Replace with '<min_cell_count'"]
    end
    
    FILTER_SETTINGS --> CHECK_VERSION
    CHECK_VERSION --> MODIFY_RESULTS
    MODIFY_RESULTS --> SETTINGS_JOIN
    SETTINGS_JOIN --> CELL_COUNT_LOGIC
    CELL_COUNT_LOGIC --> COUNT_DETECT
    COUNT_DETECT --> DASH_CHECK
    DASH_CHECK --> MIN_CELL_REPLACEMENT
    MIN_CELL_REPLACEMENT --> SPLIT_ALL
```

*Sources: [R/table.R:77-115](), [R/table.R:109-113]()*

## Table Type Support and Output Formats

The timing table functionality supports multiple output formats through the visOmopResults integration, providing flexibility for different reporting contexts.

| Table Type | Description | Use Case |
|------------|-------------|----------|
| `"gt"` | gt package tables | High-quality HTML output, publication-ready formatting |
| `"flextable"` | flextable package tables | Word document integration, office workflows |
| `"reactable"` | reactable package tables | Interactive HTML tables with sorting/filtering |
| `"DT"` | DT package tables | Interactive datatables with search functionality |

```mermaid
graph LR
    subgraph "Table Generation Flow"
        TIMING_RESULT["Timing analysis results"]
        TABLE_FUNCTION["tableCohortTiming()"]
        VIS_TABLE["visOmopResults::visTable()"]
    end
    
    subgraph "Output Types"
        GT_OUTPUT["gt table object"]
        FLEX_OUTPUT["flextable object"]
        REACT_OUTPUT["reactable widget"]
        DT_OUTPUT["DT datatable"]
    end
    
    TIMING_RESULT --> TABLE_FUNCTION
    TABLE_FUNCTION --> VIS_TABLE
    VIS_TABLE --> GT_OUTPUT
    VIS_TABLE --> FLEX_OUTPUT
    VIS_TABLE --> REACT_OUTPUT
    VIS_TABLE --> DT_OUTPUT
```

*Sources: [R/table.R:116-124](), [tests/testthat/test-tableCohortTiming.R:1-50]()*