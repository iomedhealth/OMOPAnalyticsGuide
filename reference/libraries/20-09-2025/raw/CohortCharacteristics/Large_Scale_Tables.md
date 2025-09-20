# Page: Large Scale Tables

# Large Scale Tables

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/tableLargeScaleCharacteristics.R](R/tableLargeScaleCharacteristics.R)
- [inst/doc/summarise_large_scale_characteristics.html](inst/doc/summarise_large_scale_characteristics.html)

</details>



This page covers the table generation functions for large-scale characteristics analysis, specifically the formatting and visualization of concept-level analysis results. For information about generating large-scale characteristics data, see [Large Scale Summarization](#3.5.1). For plotting large-scale data, see [Large Scale Visualization](#3.5.2).

## Overview

The large-scale tables module provides two specialized functions for creating formatted tables from `summarise_large_scale_characteristics` results: `tableTopLargeScaleCharacteristics()` for displaying top concepts and `tableLargeScaleCharacteristics()` for comprehensive comparison analysis.

## Table Generation Workflow

```mermaid
flowchart TD
    LSC_RESULT["summarise_large_scale_characteristics result"] 
    VALIDATE["omopgenerics::validateResultArgument()"]
    FILTER["omopgenerics::filterSettings()"]
    
    LSC_RESULT --> VALIDATE
    VALIDATE --> FILTER
    
    FILTER --> TOP_TABLE["tableTopLargeScaleCharacteristics()"]
    FILTER --> COMP_TABLE["tableLargeScaleCharacteristics()"]
    
    TOP_TABLE --> TOP_PROCESS["Group & Slice Top N"]
    TOP_PROCESS --> TOP_FORMAT["Format Estimates"]
    TOP_FORMAT --> VIS_TABLE["visOmopResults::visTable()"]
    
    COMP_TABLE --> COMP_PROCESS["Pivot & Compare"]
    COMP_PROCESS --> SMD_CALC["Calculate SMD"]
    SMD_CALC --> OUTPUT_FORMAT["DT/reactable Output"]
    
    VIS_TABLE --> GT_OUTPUT["gt table"]
    OUTPUT_FORMAT --> INTERACTIVE_OUTPUT["Interactive table"]
```

Sources: [R/tableLargeScaleCharacteristics.R:54-128](), [R/tableLargeScaleCharacteristics.R:178-250]()

## Function Architecture

```mermaid
graph TB
    subgraph "Table Functions"
        TOP_FUNC["tableTopLargeScaleCharacteristics()"]
        COMP_FUNC["tableLargeScaleCharacteristics()"]
        SMD_FUNC["qSmd()"]
    end
    
    subgraph "Input Processing"
        RESULT_VALID["result validation"]
        TOP_CONCEPTS["topConcepts parameter"]
        COMPARE_BY["compareBy parameter"]
        SMD_REF["smdReference parameter"]
    end
    
    subgraph "Data Transformation"
        GROUP_SLICE["dplyr::group_by() + slice_head()"]
        PIVOT_WIDE["tidyr::pivot_wider()"]
        FORMAT_EST["sprintf() formatting"]
        SMD_CALC["SMD calculation"]
    end
    
    subgraph "Output Renderers"
        VIS_OMOP["visOmopResults::visTable()"]
        GT_FMT["gt::fmt_markdown()"]
        DT_TABLE["DT::datatable()"]
        REACTABLE["reactable::reactable()"]
    end
    
    TOP_FUNC --> RESULT_VALID
    TOP_FUNC --> TOP_CONCEPTS
    COMP_FUNC --> COMPARE_BY
    COMP_FUNC --> SMD_REF
    
    RESULT_VALID --> GROUP_SLICE
    RESULT_VALID --> PIVOT_WIDE
    
    GROUP_SLICE --> FORMAT_EST
    PIVOT_WIDE --> SMD_CALC
    
    FORMAT_EST --> VIS_OMOP
    SMD_CALC --> DT_TABLE
    SMD_CALC --> REACTABLE
    
    VIS_OMOP --> GT_FMT
    SMD_FUNC --> SMD_CALC
```

Sources: [R/tableLargeScaleCharacteristics.R:54-64](), [R/tableLargeScaleCharacteristics.R:178-197](), [R/tableLargeScaleCharacteristics.R:251-257]()

## Top Concepts Table Function

The `tableTopLargeScaleCharacteristics()` function creates formatted tables showing the highest-ranking concepts within each grouping combination.

### Core Processing Logic

| Step | Operation | Code Location |
|------|-----------|---------------|
| Input Validation | `omopgenerics::validateResultArgument()` | [R/tableLargeScaleCharacteristics.R:60-61]() |
| Result Filtering | `filterSettings(result_type == "summarise_large_scale_characteristics")` | [R/tableLargeScaleCharacteristics.R:61]() |
| Concept Selection | `group_by() + arrange(desc(percentage)) + slice_head(n = topConcepts)` | [R/tableLargeScaleCharacteristics.R:67-74]() |
| Estimate Formatting | `sprintf()` with conditional source concept inclusion | [R/tableLargeScaleCharacteristics.R:82-102]() |
| Table Generation | `visOmopResults::visTable()` | [R/tableLargeScaleCharacteristics.R:120-121]() |

### Source Concept Handling

The function dynamically adjusts formatting based on source concept availability:

```
# With source concepts (lines 82-91):
"Standard: %s (%s); Source: %s (%s); %i (%.1f%%)"

# Without source concepts (lines 93-101): 
"%s (%s); %i (%.1f%%)"
```

Sources: [R/tableLargeScaleCharacteristics.R:79-102]()

## Comparative Analysis Table Function

The `tableLargeScaleCharacteristics()` function provides comprehensive comparison capabilities with interactive table outputs.

### Comparison Dimensions

The `compareBy` parameter supports comparison across:

- `"cdm_name"` - Database comparison
- `"cohort_name"` - Cohort comparison  
- Strata columns - Stratification comparison
- `"variable_level"` - Window comparison
- `"type"` - Analysis type comparison

Sources: [R/tableLargeScaleCharacteristics.R:189-190]()

### SMD Calculation

The `qSmd()` helper function calculates Standardized Mean Differences with edge case handling:

```mermaid
flowchart TD
    INPUT["ref, comp percentages"]
    CHECK1["ref == 0 & comp == 0"]
    CHECK2["ref == 100 & comp == 100"] 
    CALC["(comp - ref) / sqrt((comp*(100-comp) + ref*(100-ref)) / 2)"]
    
    INPUT --> CHECK1
    CHECK1 -->|TRUE| ZERO1["return 0"]
    CHECK1 -->|FALSE| CHECK2
    CHECK2 -->|TRUE| ZERO2["return 0"]
    CHECK2 -->|FALSE| CALC
    CALC --> ROUND["round(result, 4)"]
```

Sources: [R/tableLargeScaleCharacteristics.R:251-257]()

### Data Pivoting and Column Management

The function performs sophisticated data reshaping:

1. **Pivoting**: Uses `tidyr::pivot_wider()` to create comparison columns [R/tableLargeScaleCharacteristics.R:213-218]()
2. **Column Selection**: Dynamically selects relevant columns based on data availability [R/tableLargeScaleCharacteristics.R:221-226]()
3. **SMD Integration**: Adds SMD columns when reference is specified [R/tableLargeScaleCharacteristics.R:228-241]()

## Output Format Integration

### Static Table Formats

- **gt**: Primary format for `tableTopLargeScaleCharacteristics()` with markdown support
- **visOmopResults**: Standardized OMOP table formatting with header management

### Interactive Table Formats  

- **DT**: DataTables integration via `DT::datatable()`
- **reactable**: Modern React-based tables via `reactable::reactable()`

```mermaid
graph LR
    RESULT["Large Scale Result"]
    
    subgraph "Static Tables"
        TOP_FUNC["tableTopLargeScaleCharacteristics()"]
        VIS_OMOP["visOmopResults::visTable()"]
        GT["gt table"]
    end
    
    subgraph "Interactive Tables"
        COMP_FUNC["tableLargeScaleCharacteristics()"]
        DT["DT::datatable()"]
        REACTABLE["reactable::reactable()"]
    end
    
    RESULT --> TOP_FUNC
    RESULT --> COMP_FUNC
    
    TOP_FUNC --> VIS_OMOP
    VIS_OMOP --> GT
    
    COMP_FUNC --> DT
    COMP_FUNC --> REACTABLE
```

Sources: [R/tableLargeScaleCharacteristics.R:120-127](), [R/tableLargeScaleCharacteristics.R:243-247]()