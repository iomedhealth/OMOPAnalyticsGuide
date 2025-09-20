# Page: Utilities and Helper Functions

# Utilities and Helper Functions

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [NAMESPACE](NAMESPACE)
- [NEWS.md](NEWS.md)
- [R/table.R](R/table.R)

</details>



This document covers the supporting infrastructure functions in CohortCharacteristics that facilitate analysis workflows, data management, and development tasks. These utilities provide column introspection, mock data generation, benchmarking capabilities, and result object manipulation functions that support the main analysis functions.

For core analysis workflows using the summarise→plot→table pattern, see [Core Analysis Workflow](#2). For specific analysis domain implementations, see [Analysis Domains](#3).

## Overview

The CohortCharacteristics package provides several categories of utility functions that support the main analysis pipeline:

```mermaid
flowchart TD
    subgraph "Main Analysis Pipeline"
        SUMMARISE["summarise* functions"]
        PLOT["plot* functions"] 
        TABLE["table* functions"]
    end
    
    subgraph "Column Management Utilities"
        APC["availablePlotColumns()"]
        ATC["availableTableColumns()"]
    end
    
    subgraph "Mock Data & Benchmarking"
        MOCK["mockCohortCharacteristics()"]
        BENCH["benchmarkCohortCharacteristics()"]
        DISC["mockDisconnect()"]
    end
    
    subgraph "Result Object Utilities"
        SETTINGS["settings()"]
        BIND["bind()"]
        SUPPRESS["suppress()"]
        TIDY["tidy()"]
        EXPORT["exportSummarisedResult()"]
        IMPORT["importSummarisedResult()"]
    end
    
    subgraph "Internal Helpers"
        TABLE_HELPER["tableCohortCharacteristics()"]
        EMPTY["emptyTable()"]
        VERSION["checkVersion()"]
    end
    
    SUMMARISE --> PLOT
    SUMMARISE --> TABLE
    
    APC --> PLOT
    ATC --> TABLE
    
    MOCK --> SUMMARISE
    BENCH --> SUMMARISE
    
    SETTINGS --> TABLE
    BIND --> TABLE
    SUPPRESS --> TABLE
    TIDY --> TABLE
    
    TABLE_HELPER --> TABLE
    EMPTY --> TABLE
    VERSION --> TABLE
```

**Sources:** [NAMESPACE:1-57](), [R/table.R:1-130]()

## Column Management Functions

The package provides introspection functions to identify available columns for customizing plots and tables:

| Function | Purpose | Returns | Usage Context |
|----------|---------|---------|---------------|
| `availablePlotColumns()` | Lists columns available for plot faceting and coloring | Character vector | Used with `facet` and `colour` arguments in plot functions |
| `availableTableColumns()` | Lists columns available for table grouping and headers | Character vector | Used with `header`, `groupColumn`, and `hide` arguments in table functions |

```mermaid
flowchart LR
    subgraph "Result Object Structure"
        RESULT["summarised_result object"]
        CDM["cdm_name"]
        GROUP["groupColumns()"]
        STRATA["strataColumns()"]
        ADDITIONAL["additionalColumns()"]
        SETTINGS_COL["settingsColumns()"]
        ESTIMATES["estimate_name values"]
    end
    
    subgraph "Column Introspection"
        APC["availablePlotColumns()"]
        ATC["availableTableColumns()"]
    end
    
    subgraph "Plot Functions"
        PLOT_FACET["facet argument"]
        PLOT_COLOUR["colour argument"]
    end
    
    subgraph "Table Functions"
        TABLE_HEADER["header argument"]
        TABLE_GROUP["groupColumn argument"]
        TABLE_HIDE["hide argument"]
    end
    
    RESULT --> APC
    RESULT --> ATC
    
    CDM --> APC
    GROUP --> APC
    STRATA --> APC
    ADDITIONAL --> APC
    SETTINGS_COL --> APC
    ESTIMATES --> APC
    
    CDM --> ATC
    GROUP --> ATC
    STRATA --> ATC
    ADDITIONAL --> ATC
    SETTINGS_COL --> ATC
    
    APC --> PLOT_FACET
    APC --> PLOT_COLOUR
    
    ATC --> TABLE_HEADER
    ATC --> TABLE_GROUP
    ATC --> TABLE_HIDE
```

The `availablePlotColumns()` function includes `estimate_name` values for plot coloring, while `availableTableColumns()` excludes them since estimates are handled differently in table formatting.

**Sources:** [R/table.R:18-29](), [R/table.R:48-58]()

## Mock Data and Benchmarking Utilities

Development and testing utilities provide standardized datasets and performance measurement:

```mermaid
flowchart TD
    subgraph "Development Workflow"
        DEV["Package Development"]
        TEST["Testing"]
        BENCH["Performance Analysis"]
    end
    
    subgraph "Mock Data Functions"
        MOCK["mockCohortCharacteristics()"]
        DISC["mockDisconnect()"]
    end
    
    subgraph "Generated Resources"
        CDM["Mock CDM object"]
        COHORTS["Sample cohort tables"]
        CONCEPTS["Test concept sets"]
    end
    
    subgraph "Benchmarking"
        BENCH_FUNC["benchmarkCohortCharacteristics()"]
        METRICS["Performance metrics"]
        TIMING["Execution timing"]
    end
    
    DEV --> MOCK
    TEST --> MOCK
    BENCH --> BENCH_FUNC
    
    MOCK --> CDM
    MOCK --> COHORTS
    MOCK --> CONCEPTS
    
    CDM --> DISC
    
    BENCH_FUNC --> METRICS
    BENCH_FUNC --> TIMING
```

The `mockCohortCharacteristics()` function creates a complete OMOP CDM environment with sample cohorts for development and testing. The `mockDisconnect()` function properly closes database connections created by mock functions. The `benchmarkCohortCharacteristics()` function measures performance across different analysis scenarios.

**Sources:** [NAMESPACE:6](), [NAMESPACE:11-12](), [NAMESPACE:40](), [NEWS.md:8](), [NEWS.md:38]()

## Result Object Utilities

CohortCharacteristics re-exports several utility functions from `omopgenerics` for working with `summarised_result` objects:

| Function | Purpose | Package Source |
|----------|---------|----------------|
| `settings()` | Extract analysis settings from result objects | omopgenerics |
| `bind()` | Combine multiple result objects | omopgenerics |
| `suppress()` | Apply cell count suppression rules | omopgenerics |
| `tidy()` | Convert result objects to tidy format | omopgenerics |
| `exportSummarisedResult()` | Export results to file formats | omopgenerics |
| `importSummarisedResult()` | Import results from files | omopgenerics |
| `groupColumns()` | Extract group column names | omopgenerics |
| `strataColumns()` | Extract strata column names | omopgenerics |
| `additionalColumns()` | Extract additional column names | omopgenerics |
| `settingsColumns()` | Extract settings column names | omopgenerics |

```mermaid
flowchart LR
    subgraph "omopgenerics Package"
        OMOP_SETTINGS["settings()"]
        OMOP_BIND["bind()"]
        OMOP_SUPPRESS["suppress()"]
        OMOP_TIDY["tidy()"]
        OMOP_EXPORT["exportSummarisedResult()"]
        OMOP_IMPORT["importSummarisedResult()"]
        OMOP_GROUP["groupColumns()"]
        OMOP_STRATA["strataColumns()"]
        OMOP_ADDITIONAL["additionalColumns()"]
        OMOP_SETTINGS_COL["settingsColumns()"]
    end
    
    subgraph "CohortCharacteristics Re-exports"
        CC_SETTINGS["settings()"]
        CC_BIND["bind()"]
        CC_SUPPRESS["suppress()"]
        CC_TIDY["tidy()"]
        CC_EXPORT["exportSummarisedResult()"]
        CC_IMPORT["importSummarisedResult()"]
        CC_GROUP["groupColumns()"]
        CC_STRATA["strataColumns()"]
        CC_ADDITIONAL["additionalColumns()"]
        CC_SETTINGS_COL["settingsColumns()"]
    end
    
    subgraph "User Interface"
        USER["CohortCharacteristics::function()"]
    end
    
    OMOP_SETTINGS --> CC_SETTINGS
    OMOP_BIND --> CC_BIND
    OMOP_SUPPRESS --> CC_SUPPRESS
    OMOP_TIDY --> CC_TIDY
    OMOP_EXPORT --> CC_EXPORT
    OMOP_IMPORT --> CC_IMPORT
    OMOP_GROUP --> CC_GROUP
    OMOP_STRATA --> CC_STRATA
    OMOP_ADDITIONAL --> CC_ADDITIONAL
    OMOP_SETTINGS_COL --> CC_SETTINGS_COL
    
    CC_SETTINGS --> USER
    CC_BIND --> USER
    CC_SUPPRESS --> USER
    CC_TIDY --> USER
    CC_EXPORT --> USER
    CC_IMPORT --> USER
    CC_GROUP --> USER
    CC_STRATA --> USER
    CC_ADDITIONAL --> USER
    CC_SETTINGS_COL --> USER
```

These re-exports provide a unified interface for result manipulation without requiring users to load `omopgenerics` directly.

**Sources:** [NAMESPACE:43-52](), [NAMESPACE:3](), [NAMESPACE:7-10](), [NAMESPACE:20-22](), [NAMESPACE:30](), [NAMESPACE:39]()

## Internal Helper Functions

Several internal functions support the package's table generation and validation processes:

```mermaid
flowchart TD
    subgraph "Public Table Functions"
        TABLE_CHAR["tableCharacteristics()"]
        TABLE_ATTR["tableCohortAttrition()"]
        TABLE_OVER["tableCohortOverlap()"]
        TABLE_TIME["tableCohortTiming()"]
        TABLE_LSC["tableLargeScaleCharacteristics()"]
    end
    
    subgraph "Internal Helper Functions"
        TABLE_HELPER["tableCohortCharacteristics()"]
        EMPTY["emptyTable()"]
        CHECK_VERSION["checkVersion()"]
    end
    
    subgraph "Processing Steps"
        VALIDATE["Input validation"]
        FILTER["Result filtering"]
        FORMAT["Format processing"]
        OUTPUT["Table generation"]
    end
    
    TABLE_CHAR --> TABLE_HELPER
    TABLE_ATTR --> TABLE_HELPER
    TABLE_OVER --> TABLE_HELPER
    TABLE_TIME --> TABLE_HELPER
    TABLE_LSC --> TABLE_HELPER
    
    TABLE_HELPER --> VALIDATE
    TABLE_HELPER --> FILTER
    TABLE_HELPER --> FORMAT
    TABLE_HELPER --> OUTPUT
    
    TABLE_HELPER --> CHECK_VERSION
    FILTER --> EMPTY
```

The `tableCohortCharacteristics()` function [R/table.R:60-125]() provides the common implementation for all table functions, handling result validation, filtering, settings integration, and cell count suppression. The `emptyTable()` function [R/table.R:126-129]() generates empty table outputs when no matching results are found. The `checkVersion()` function ensures compatibility between package versions.

**Sources:** [R/table.R:60-129](), [NEWS.md:35]()