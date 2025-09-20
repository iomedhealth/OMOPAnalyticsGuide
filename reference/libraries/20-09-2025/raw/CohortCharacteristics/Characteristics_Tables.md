# Page: Characteristics Tables

# Characteristics Tables

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [NEWS.md](NEWS.md)
- [R/table.R](R/table.R)
- [R/tableCharacteristics.R](R/tableCharacteristics.R)

</details>



This document covers the table generation functionality for cohort characteristics analysis in the CohortCharacteristics package. The `tableCharacteristics` function formats `summarised_result` objects from characteristics analysis into interactive and static tables using various table rendering engines. This represents the final step in the three-tier analysis pattern (summarise→plot→table).

For information about generating the underlying characteristics data, see [Summarizing Characteristics](#3.1.1). For visualization options, see [Plotting Characteristics](#3.1.2).

## Main Function Overview

The `tableCharacteristics` function serves as the primary interface for converting characteristics analysis results into formatted tables. It accepts `summarised_result` objects and produces tables using different rendering engines.

```mermaid
flowchart TD
    subgraph "Input"
        RESULT["summarised_result object<br/>from summariseCharacteristics"]
    end
    
    subgraph "tableCharacteristics Function"
        VALIDATE["Input Validation<br/>omopgenerics::validateResultArgument"]
        DELEGATE["Delegate to tableCohortCharacteristics<br/>with resultType = 'summarise_characteristics'"]
    end
    
    subgraph "Configuration Parameters"
        TYPE["type: gt, flextable, reactable, DT"]
        HEADER["header: column grouping"]
        GROUP["groupColumn: row grouping"]
        HIDE["hide: columns to exclude"]
        OPTIONS[".options: engine-specific settings"]
    end
    
    subgraph "Output"
        TABLE["Formatted Table Object<br/>gt, flextable, reactable, or DT"]
    end
    
    RESULT --> VALIDATE
    VALIDATE --> DELEGATE
    TYPE --> DELEGATE
    HEADER --> DELEGATE
    GROUP --> DELEGATE
    HIDE --> DELEGATE
    OPTIONS --> DELEGATE
    DELEGATE --> TABLE
```

**Table Generation Architecture**

Sources: [R/tableCharacteristics.R:41-68]()

The function signature includes several key parameters for table customization:

| Parameter | Purpose | Default Value |
|-----------|---------|---------------|
| `result` | Input summarised_result object | Required |
| `type` | Table rendering engine | `"gt"` |
| `header` | Columns for table headers | `c("cdm_name", "cohort_name")` |
| `groupColumn` | Columns for row grouping | `character()` |
| `hide` | Columns to hide from display | `c(additionalColumns(result), settingsColumns(result))` |
| `.options` | Engine-specific formatting options | `list()` |

Sources: [R/tableCharacteristics.R:41-46]()

## Table Customization Options

The function provides extensive customization through its parameters and integration with the `visOmopResults` ecosystem.

### Estimate Name Formatting

The function applies standardized formatting patterns for different types of estimates:

```mermaid
flowchart LR
    subgraph "Estimate Transformations"
        COUNT["count + percentage<br/>→ 'N (%)'"]
        MEDIAN["median + quartiles<br/>→ 'Median [Q25 - Q75]'"]
        MEAN["mean + sd<br/>→ 'Mean (SD)'"]
        RANGE["min + max<br/>→ 'Range'"]
        SIMPLE["count only<br/>→ 'N'"]
    end
    
    subgraph "Format Templates"
        TEMPLATE1["'<count> (<percentage>%)'"]
        TEMPLATE2["'<median> [<q25> - <q75>]'"]
        TEMPLATE3["'<mean> (<sd>)'"]
        TEMPLATE4["'<min> to <max>'"]
        TEMPLATE5["'<count>'"]
    end
    
    COUNT --> TEMPLATE1
    MEDIAN --> TEMPLATE2
    MEAN --> TEMPLATE3
    RANGE --> TEMPLATE4
    SIMPLE --> TEMPLATE5
```

**Estimate Name Mapping and Templates**

Sources: [R/tableCharacteristics.R:58-64]()

### Column Management

The function automatically handles column visibility and organization:

- **Hidden by default**: Additional columns and settings columns via `additionalColumns(result)` and `settingsColumns(result)`
- **Renamed columns**: CDM name column gets user-friendly labeling
- **Filtered estimates**: Density plot data (`density_x`, `density_y`) is excluded from tables

Sources: [R/tableCharacteristics.R:45](), [R/tableCharacteristics.R:54-57]()

## Internal Implementation

The `tableCharacteristics` function delegates to the internal `tableCohortCharacteristics` function, which provides the core table generation logic shared across different analysis types.

```mermaid
flowchart TD
    subgraph "tableCohortCharacteristics Internal Process"
        VALIDATE["Result Validation<br/>omopgenerics::validateResultArgument"]
        FILTER["Filter by Result Type<br/>result_type == 'summarise_characteristics'"]
        VERSION["Version Check<br/>checkVersion(result)"]
        SETTINGS["Extract Settings<br/>omopgenerics::settings(result)"]
        MODIFY["Apply Result Modifications<br/>modifyResults function"]
        JOIN["Join Settings Data<br/>dplyr::left_join"]
        CELL["Handle Min Cell Count<br/>Replace '-' with '<minCellCount'"]
        FORMAT["Format with visOmopResults<br/>visOmopResults::visTable"]
    end
    
    subgraph "External Dependencies"
        VIS["visOmopResults::visTable"]
        OMOP["omopgenerics validation"]
    end
    
    VALIDATE --> FILTER
    FILTER --> VERSION
    VERSION --> SETTINGS
    SETTINGS --> MODIFY
    MODIFY --> JOIN
    JOIN --> CELL
    CELL --> FORMAT
    FORMAT --> VIS
    VALIDATE --> OMOP
```

**Internal Table Generation Process**

Sources: [R/table.R:60-125]()

### Settings Integration

The function integrates settings metadata from the analysis into the table structure:

- Extracts relevant settings columns excluding internal metadata (`result_id`, `result_type`, `package_name`, etc.)
- Joins settings data with result data for complete context
- Filters to only include settings for results present in the data

Sources: [R/table.R:86-107]()

### Cell Count Handling

The implementation includes special handling for minimum cell count suppression:

- Detects count estimates with suppressed values (marked as `"-"`)
- Replaces with formatted minimum cell count indicators (`"<5"`, etc.)
- Maintains data privacy requirements for small counts

Sources: [R/table.R:109-113]()

## Column Management Utilities

The package provides utility functions to help users understand available table customization options.

### Available Table Columns

The `availableTableColumns` function identifies columns that can be used in table configuration:

```mermaid
flowchart LR
    subgraph "Column Categories"
        CDM["cdm_name"]
        GROUP["Group Columns<br/>omopgenerics::groupColumns"]
        STRATA["Strata Columns<br/>omopgenerics::strataColumns"]
        ADDITIONAL["Additional Columns<br/>omopgenerics::additionalColumns"]
        SETTINGS["Settings Columns<br/>omopgenerics::settingsColumns"]
    end
    
    subgraph "Usage Context"
        HEADER["header parameter"]
        GROUPCOL["groupColumn parameter"]
        HIDE["hide parameter"]
    end
    
    CDM --> HEADER
    GROUP --> HEADER
    STRATA --> HEADER
    ADDITIONAL --> HIDE
    SETTINGS --> HIDE
    GROUP --> GROUPCOL
    STRATA --> GROUPCOL
```

**Available Column Categories for Table Configuration**

Sources: [R/table.R:48-58]()

This differs from `availablePlotColumns` which additionally includes estimate names since plots can facet or color by estimate types.

Sources: [R/table.R:18-29]()

## Integration with Visualization Ecosystem

The table generation system integrates tightly with the broader OMOP visualization ecosystem, particularly `visOmopResults`.

### Table Engine Support

The function supports multiple table rendering engines through the `type` parameter:

| Engine | Package | Use Case |
|--------|---------|----------|
| `"gt"` | gt | Publication-quality static tables |
| `"flextable"` | flextable | Office document integration |
| `"reactable"` | reactable | Interactive web tables |
| `"DT"` | DT | Interactive data tables |

### Error Handling

The implementation includes robust error handling for edge cases:

- **No matching results**: Returns empty table when no results match the specified `result_type`
- **Missing dependencies**: Checks for `visOmopResults` installation before proceeding
- **Invalid inputs**: Validates result objects using `omopgenerics` standards

Sources: [R/table.R:71-82](), [R/table.R:126-129]()

The table generation system provides a comprehensive and flexible interface for creating formatted presentations of cohort characteristics analysis results, with strong integration into the OMOP Common Data Model ecosystem and support for multiple output formats.