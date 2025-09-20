# Page: Attrition Tables

# Attrition Tables

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [MD5](MD5)
- [NEWS.md](NEWS.md)
- [R/table.R](R/table.R)

</details>



This document covers the creation of structured tabular reports for cohort attrition analysis using the `tableCohortAttrition` function. Attrition tables provide formatted summaries of subject flow through cohort definitions, displaying exclusion steps and remaining counts in a structured, readable format.

For information about generating attrition summaries, see [Attrition Summarization](#3.2.1). For creating visual flow diagrams of attrition, see [Attrition Visualization](#3.2.2).

## Table Generation Workflow

The attrition table generation follows the standard three-tier analysis pattern, taking summarized attrition results and formatting them into publication-ready tables.

```mermaid
flowchart LR
    subgraph "Input"
        SUMMARY["summarised_result<br/>from summariseCohortAttrition"]
        SETTINGS["Table Settings<br/>header, groupColumn, hide"]
    end
    
    subgraph "Processing"
        VALIDATE["omopgenerics::validateResultArgument<br/>Input Validation"]
        FILTER["omopgenerics::filterSettings<br/>result_type filtering"]
        MODIFY["modifyResults Function<br/>Custom Processing"]
        FORMAT["tableCohortCharacteristics<br/>Core Formatting Logic"]
    end
    
    subgraph "Output Engines"
        VIS["visOmopResults::visTable<br/>Table Rendering"]
        GT["gt Tables"]
        FLEX["flextable Tables"]
        REACT["reactable Tables"]
        DT["DT Tables"]
    end
    
    subgraph "Output"
        TABLE["Formatted Attrition Table"]
    end
    
    SUMMARY --> VALIDATE
    SETTINGS --> VALIDATE
    VALIDATE --> FILTER
    FILTER --> MODIFY
    MODIFY --> FORMAT
    FORMAT --> VIS
    VIS --> GT
    VIS --> FLEX
    VIS --> REACT
    VIS --> DT
    GT --> TABLE
    FLEX --> TABLE
    REACT --> TABLE
    DT --> TABLE
```

Sources: [R/table.R:60-125](), [R/tableCohortAttrition.R]()

## Function Architecture

The `tableCohortAttrition` function integrates with the package's standardized table generation infrastructure, processing attrition-specific summarised results into formatted tables.

```mermaid
flowchart TB
    subgraph "tableCohortAttrition"
        MAIN["tableCohortAttrition()"]
        PARAMS["Parameters<br/>header, groupColumn, hide<br/>rename, type, estimateName"]
    end
    
    subgraph "Core Table Infrastructure"
        HELPER["tableCohortCharacteristics()<br/>Shared table logic"]
        FILTER["result_type == 'cohort_attrition'<br/>Filtering"]
        VERSION["checkVersion()<br/>Compatibility validation"]
    end
    
    subgraph "Settings Processing" 
        SETTINGS["omopgenerics::settings()<br/>Extract metadata"]
        SETCOLS["setColumns calculation<br/>Dynamic column detection"]
        JOIN["dplyr::left_join<br/>Merge settings with results"]
    end
    
    subgraph "Value Processing"
        CELLCOUNT["min_cell_count handling<br/>Replace '-' with '<threshold'"]
        SPLIT["omopgenerics::splitAll()<br/>Expand grouped columns"]
        ESTIMATES["estimate_name filtering<br/>Select relevant estimates"]
    end
    
    subgraph "Visualization Layer"
        VISTABLE["visOmopResults::visTable()<br/>Final rendering"]
        OPTIONS[".options parameter<br/>Render-specific settings"]
    end
    
    MAIN --> HELPER
    PARAMS --> HELPER
    HELPER --> FILTER
    FILTER --> VERSION
    VERSION --> SETTINGS
    SETTINGS --> SETCOLS
    SETCOLS --> JOIN
    JOIN --> CELLCOUNT
    CELLCOUNT --> SPLIT
    SPLIT --> ESTIMATES
    ESTIMATES --> VISTABLE
    OPTIONS --> VISTABLE
```

Sources: [R/table.R:70-125](), [R/tableCohortAttrition.R]()

## Input Requirements

Attrition tables require summarised results with specific characteristics:

| Requirement | Description | Code Reference |
|-------------|-------------|----------------|
| **Result Type** | Must have `result_type == "cohort_attrition"` | [R/table.R:78]() |
| **Estimate Names** | Contains attrition-specific estimates (number_records, number_subjects) | [R/summariseCohortAttrition.R]() |
| **Settings** | Valid settings metadata from summarization | [R/table.R:86]() |
| **Structure** | Valid `summarised_result` object | [R/table.R:74]() |

```mermaid
flowchart LR
    subgraph "Required Input Structure"
        RESULT["summarised_result object"]
        TYPE["result_type: 'cohort_attrition'"]
        EST["estimate_name:<br/>number_records<br/>number_subjects<br/>excluded_records<br/>excluded_subjects"]
        STRATA["strata columns:<br/>reason, reason_id"]
        GROUPS["group columns:<br/>cohort_name"]
    end
    
    subgraph "Validation Process"
        CHECK["omopgenerics::validateResultArgument"]
        FILTER["filterSettings by result_type"]
        WARN["Empty result warning"]
    end
    
    RESULT --> CHECK
    TYPE --> FILTER
    EST --> FILTER
    STRATA --> FILTER
    GROUPS --> FILTER
    CHECK --> FILTER
    FILTER --> WARN
```

Sources: [R/table.R:74-82]()

## Table Formatting Options

The function provides extensive customization options for table appearance and structure:

### Core Parameters

| Parameter | Type | Purpose | Default |
|-----------|------|---------|---------|
| `header` | character | Column headers structure | Automatic |
| `groupColumn` | character | Grouping column specification | None |
| `hide` | character | Columns to hide from display | "estimate_type" |
| `rename` | named list | Column name mappings | None |
| `type` | character | Output table type | "gt" |

### Advanced Options

```mermaid
flowchart TD
    subgraph "Table Customization"
        ESTIMATENAME["estimateName<br/>Select specific estimates"]
        MODIFYRESULTS["modifyResults<br/>Custom processing function"]
        OPTIONS[".options<br/>Renderer-specific settings"]
    end
    
    subgraph "Processing Pipeline"
        SETTINGS["Settings Integration"]
        CELLCOUNT["Cell Count Masking"]
        SPLIT["Column Expansion"]
    end
    
    subgraph "Output Control"
        HEADER["Header Configuration"]
        GROUP["Grouping Structure"]
        HIDE["Column Visibility"]
        RENAME["Column Renaming"]
    end
    
    ESTIMATENAME --> SETTINGS
    MODIFYRESULTS --> SETTINGS
    OPTIONS --> SETTINGS
    SETTINGS --> CELLCOUNT
    CELLCOUNT --> SPLIT
    SPLIT --> HEADER
    SPLIT --> GROUP
    SPLIT --> HIDE
    SPLIT --> RENAME
```

Sources: [R/table.R:60-69](), [R/table.R:116-124]()

## Cell Count Privacy Protection

The function implements automatic privacy protection for small cell counts:

```mermaid
flowchart LR
    subgraph "Cell Count Processing"
        INPUT["estimate_value input"]
        DETECT["stringr::str_detect<br/>count estimates"]
        CHECK["value == '-'<br/>suppressed check"]
        REPLACE["paste0('<', min_cell_count)<br/>threshold display"]
        OUTPUT["Protected estimate_value"]
    end
    
    INPUT --> DETECT
    DETECT --> CHECK
    CHECK --> REPLACE
    REPLACE --> OUTPUT
```

Sources: [R/table.R:109-113]()

## Available Column Management

The function integrates with the package's column management system to provide dynamic column options:

| Function | Purpose | Returns |
|----------|---------|---------|
| `availableTableColumns()` | Lists available columns for table functions | Character vector |
| `availablePlotColumns()` | Lists available columns for plot functions | Character vector |

```mermaid
flowchart TB
    subgraph "Column Discovery"
        RESULT["summarised_result"]
        VALIDATE["omopgenerics::validateResultArgument"]
    end
    
    subgraph "Column Categories"
        CDM["cdm_name"]
        GROUP["omopgenerics::groupColumns"]
        STRATA["omopgenerics::strataColumns"] 
        ADDITIONAL["omopgenerics::additionalColumns"]
        SETTINGS["omopgenerics::settingsColumns"]
        ESTIMATES["unique estimate_names<br/>(plot only)"]
    end
    
    subgraph "Usage"
        TABLE["availableTableColumns<br/>header, groupColumn, hide"]
        PLOT["availablePlotColumns<br/>facet, colour arguments"]
    end
    
    RESULT --> VALIDATE
    VALIDATE --> CDM
    VALIDATE --> GROUP  
    VALIDATE --> STRATA
    VALIDATE --> ADDITIONAL
    VALIDATE --> SETTINGS
    VALIDATE --> ESTIMATES
    CDM --> TABLE
    GROUP --> TABLE
    STRATA --> TABLE
    ADDITIONAL --> TABLE
    SETTINGS --> TABLE
    CDM --> PLOT
    GROUP --> PLOT
    STRATA --> PLOT
    ADDITIONAL --> PLOT
    SETTINGS --> PLOT
    ESTIMATES --> PLOT
```

Sources: [R/table.R:18-58]()

## Integration with visOmopResults

The final table rendering leverages the `visOmopResults` package for standardized OMOP result visualization:

```mermaid
flowchart LR
    subgraph "visOmopResults Integration"
        VISTABLE["visOmopResults::visTable"]
        ESTIMATENAME["estimateName parameter"]
        HEADER["header configuration"]
        RENAME["rename mappings"]
        TYPE["type specification"]
        HIDE["hide columns"]
        GROUP["groupColumn settings"]
        OPTIONS[".options renderer settings"]
    end
    
    subgraph "Output Formats"
        GT["gt tables"]
        FLEXTABLE["flextable tables"]
        REACTABLE["reactable tables"]
        DT["DT tables"]
        HTML["HTML output"]
    end
    
    VISTABLE --> GT
    VISTABLE --> FLEXTABLE
    VISTABLE --> REACTABLE
    VISTABLE --> DT
    ESTIMATENAME --> VISTABLE
    HEADER --> VISTABLE
    RENAME --> VISTABLE
    TYPE --> VISTABLE
    HIDE --> VISTABLE
    GROUP --> VISTABLE
    OPTIONS --> VISTABLE
    GT --> HTML
    FLEXTABLE --> HTML
    REACTABLE --> HTML
    DT --> HTML
```

Sources: [R/table.R:116-124]()

## Error Handling and Edge Cases

The function includes robust error handling for common edge cases:

### Empty Results

When no attrition results match the specified criteria, the function returns an appropriate empty table:

```mermaid
flowchart TD
    FILTER["filterSettings result_type check"]
    COUNT["nrow(result) == 0"]
    WARN["cli::cli_warn message"]
    EMPTY["emptyTable(type)"]
    
    FILTER --> COUNT
    COUNT -->|"No results"| WARN
    WARN --> EMPTY
    COUNT -->|"Results found"| CONTINUE["Continue processing"]
```

Sources: [R/table.R:79-82](), [R/table.R:126-129]()

### Version Compatibility

The function includes version checking to ensure compatibility between different package versions:

Sources: [R/table.R:84]()