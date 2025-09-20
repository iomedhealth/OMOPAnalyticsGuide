# Page: Overlap Tables

# Overlap Tables

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [MD5](MD5)
- [NEWS.md](NEWS.md)
- [R/table.R](R/table.R)

</details>



This document covers the table generation functionality for cohort overlap analysis, specifically the `tableCohortOverlap` function and related table formatting capabilities. This function converts summarized cohort overlap results into formatted, interactive tables suitable for reporting and publication.

For information about generating the underlying overlap data, see [Overlap Summarization](#3.3.1). For creating visualizations of overlap data, see [Overlap Visualization](#3.3.2).

## Purpose and Scope

The overlap tables system transforms `summarised_result` objects from `summariseCohortOverlap` into formatted tables using the `visOmopResults` framework. The system provides flexible formatting options, supports multiple output formats, and maintains consistency with OMOP CDM reporting standards.

## Table Generation Workflow

The overlap table generation follows the standardized three-tier analysis pattern used throughout CohortCharacteristics:

```mermaid
flowchart LR
    subgraph "Input Layer"
        SR["summarised_result<br/>from summariseCohortOverlap"]
        SETTINGS["Settings Metadata<br/>overlap parameters"]
    end
    
    subgraph "Processing Layer"
        TCO["tableCohortOverlap<br/>Main Interface Function"]
        TCC["tableCohortCharacteristics<br/>Core Table Engine"]
        FILTER["Result Filtering<br/>by result_type"]
        FORMAT["Value Formatting<br/>Cell Count Handling"]
    end
    
    subgraph "Output Layer"  
        VIS["visOmopResults::visTable<br/>Table Rendering Engine"]
        GT["gt tables"]
        FLEX["flextable tables"]
        DT["DT datatables"]
        REACT["reactable tables"]
    end
    
    SR --> TCO
    SETTINGS --> TCO
    TCO --> TCC
    TCC --> FILTER
    FILTER --> FORMAT
    FORMAT --> VIS
    VIS --> GT
    VIS --> FLEX
    VIS --> DT
    VIS --> REACT
```

Sources: [R/table.R:60-125](), [R/tableCohortOverlap.R]()

## Core Table Infrastructure

The overlap table system leverages shared infrastructure through the `tableCohortCharacteristics` function, which provides consistent behavior across all CohortCharacteristics table functions:

```mermaid
graph TB
    subgraph "Table Function Hierarchy"
        TCO["tableCohortOverlap<br/>Public Interface"]
        TCC["tableCohortCharacteristics<br/>Shared Infrastructure"]
        VT["visOmopResults::visTable<br/>Rendering Engine"]
    end
    
    subgraph "Column Management"
        ATC["availableTableColumns<br/>Column Discovery"]
        COLS["Standard Columns<br/>cdm_name, group, strata, additional, settings"]
    end
    
    subgraph "Data Processing Pipeline"
        VALIDATE["omopgenerics::validateResultArgument<br/>Input Validation"]
        FILTER["filterSettings<br/>result_type filtering"]
        JOIN["Settings Join<br/>Metadata Integration"]
        TRANSFORM["Value Transformation<br/>Cell Count Formatting"]
    end
    
    TCO --> TCC
    TCC --> VT
    ATC --> COLS
    COLS --> TCC
    
    TCC --> VALIDATE
    VALIDATE --> FILTER  
    FILTER --> JOIN
    JOIN --> TRANSFORM
    TRANSFORM --> VT
```

Sources: [R/table.R:48-58](), [R/table.R:60-125]()

## Table Formatting Features

### Column Management System

The system provides comprehensive column management through `availableTableColumns`:

| Column Type | Description | Example Values |
|-------------|-------------|----------------|
| `cdm_name` | Database identifier | "eunomia", "synpuf" |
| Group Columns | Cohort identifiers | "cohort_name_reference", "cohort_name_comparator" |
| Strata Columns | Stratification variables | "age_group", "sex" |
| Additional Columns | Variable names | "variable_name", "variable_level" |
| Settings Columns | Analysis parameters | "overlap_by", "counts" |

Sources: [R/table.R:31-58]()

### Cell Count Protection

The table system implements automatic cell count suppression for privacy protection:

```mermaid
flowchart TD
    subgraph "Cell Count Processing"
        INPUT["estimate_value from result"]
        CHECK["Check if estimate_name contains 'count'"]
        SUPPRESS["Replace '-' with '<min_cell_count'"]
        OUTPUT["Protected cell value"]
    end
    
    INPUT --> CHECK
    CHECK -->|"contains 'count'"| SUPPRESS
    CHECK -->|"other estimates"| OUTPUT
    SUPPRESS --> OUTPUT
```

Sources: [R/table.R:109-113]()

## Function Interface

### Parameters and Customization

The `tableCohortOverlap` function provides extensive customization options:

| Parameter | Purpose | Integration Point |
|-----------|---------|-------------------|
| `result` | Input summarised_result | `omopgenerics::validateResultArgument` |
| `estimateName` | Column selection for estimates | `visOmopResults::visTable` |
| `header` | Column headers and grouping | `visOmopResults::visTable` |
| `groupColumn` | Row grouping specification | `visOmopResults::visTable` |
| `hide` | Column visibility control | `visOmopResults::visTable` |
| `rename` | Column renaming mappings | `visOmopResults::visTable` |
| `type` | Output format selection | `visOmopResults::visTable` |

Sources: [R/table.R:60-125]()

### Settings Integration

The system automatically integrates analysis settings from the summarization phase:

```mermaid
graph LR
    subgraph "Settings Flow"
        SS["summariseCohortOverlap<br/>settings"]
        FILTER["Settings Filtering<br/>by result_id"]
        JOIN["Left Join<br/>with main result"]
        TABLE["Final Table<br/>with metadata"]
    end
    
    SS --> FILTER
    FILTER --> JOIN  
    JOIN --> TABLE
```

Sources: [R/table.R:86-108]()

## Output Format Support

The overlap table system supports multiple output formats through `visOmopResults`:

| Format | Use Case | Interactive Features |
|--------|----------|---------------------|
| `gt` | Static reports, publications | Advanced styling, footnotes |
| `flextable` | Word documents, presentations | Office integration |
| `DT` | Web applications | Filtering, sorting, pagination |
| `reactable` | Modern web interfaces | Custom renderers, theming |

Sources: [R/table.R:116-124]()

## Error Handling and Validation

The system implements comprehensive error handling:

```mermaid
flowchart TD
    subgraph "Validation Pipeline"
        INPUT["Function Input"]
        VALIDATE["omopgenerics::validateResultArgument"]
        FILTER["filterSettings by result_type"] 
        CHECK["Check if results exist"]
        WARNING["cli::cli_warn for empty results"]
        EMPTY["Return emptyTable"]
        PROCESS["Continue processing"]
    end
    
    INPUT --> VALIDATE
    VALIDATE --> FILTER
    FILTER --> CHECK
    CHECK -->|"nrow = 0"| WARNING
    WARNING --> EMPTY
    CHECK -->|"nrow > 0"| PROCESS
```

Sources: [R/table.R:74-82](), [R/table.R:126-129]()

## Integration Points

### Version Compatibility

The table system includes version checking to ensure compatibility:

Sources: [R/table.R:84]()

### visOmopResults Integration

The system leverages `visOmopResults` for standardized table generation, ensuring consistency across the OMOP ecosystem:

Sources: [R/table.R:71](), [R/table.R:116-124]()