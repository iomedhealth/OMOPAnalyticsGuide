# Page: Overlap Visualization

# Overlap Visualization

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/plotCohortOverlap.R](R/plotCohortOverlap.R)
- [inst/doc/summarise_cohort_overlap.html](inst/doc/summarise_cohort_overlap.html)

</details>



This document covers the visualization capabilities for cohort overlap analysis in the CohortCharacteristics package. The overlap visualization system transforms summarized cohort overlap results into interactive bar chart representations showing the distribution of subjects across different overlap categories.

For information about generating the underlying overlap data, see [Overlap Summarization](#3.3.1). For details about tabular overlap reporting, see [Overlap Tables](#3.3.3).

## Overview

The overlap visualization system centers around the `plotCohortOverlap` function, which creates bar chart visualizations from `summarise_cohort_overlap` result objects. The system leverages the `visOmopResults` package to generate standardized plots that show the percentage distribution of subjects across three overlap categories.

**Function Architecture**

```mermaid
graph TB
    subgraph "Input"
        ResultObj["summarised_result object<br/>result_type: summarise_cohort_overlap"]
    end
    
    subgraph "plotCohortOverlap Function"
        Validate["omopgenerics::validateResultArgument()"]
        Filter["Filter by result_type"]
        UniqueCombs["getUniqueCombinationsSr()<br/>(if uniqueCombinations=TRUE)"]
        Transform["Data transformation<br/>Factor ordering"]
        Plot["visOmopResults::barPlot()"]
    end
    
    subgraph "Output"
        GGPlot["ggplot object<br/>Horizontal bar chart"]
    end
    
    ResultObj --> Validate
    Validate --> Filter
    Filter --> UniqueCombs
    UniqueCombs --> Transform
    Transform --> Plot
    Plot --> GGPlot
```

Sources: [R/plotCohortOverlap.R:41-119]()

## Data Flow and Processing

The visualization system processes standardized result objects through several transformation stages before generating the final plot.

**Data Processing Pipeline**

```mermaid
flowchart TD
    subgraph "Input Validation"
        ValidateResult["validateResultArgument()"]
        CheckType["filterSettings()<br/>result_type == 'summarise_cohort_overlap'"]
        CheckVersion["checkVersion()"]
    end
    
    subgraph "Data Preparation"
        UniqueCombos["getUniqueCombinationsSr()<br/>(optional)"]
        GetColumns["notUniqueColumns()"]
        TidyData["omopgenerics::tidy()"]
    end
    
    subgraph "Factor Configuration"
        FactorLevels["Set variable_name factor levels:<br/>- Only in reference cohort<br/>- In both cohorts<br/>- Only in comparator cohort"]
    end
    
    subgraph "Plot Generation"
        BarPlot["visOmopResults::barPlot()"]
        Customization["ggplot2 customizations:<br/>- coord_flip()<br/>- theme_bw()<br/>- legend positioning"]
    end
    
    ValidateResult --> CheckType
    CheckType --> CheckVersion
    CheckVersion --> UniqueCombos
    UniqueCombos --> GetColumns
    GetColumns --> TidyData
    TidyData --> FactorLevels
    FactorLevels --> BarPlot
    BarPlot --> Customization
```

Sources: [R/plotCohortOverlap.R:52-118]()

## Function Parameters

The `plotCohortOverlap` function accepts several parameters for customizing the visualization output:

| Parameter | Type | Description |
|-----------|------|-------------|
| `result` | `summarised_result` | Input result object with overlap data |
| `uniqueCombinations` | `logical` | Whether to show unique cohort combinations only |
| `facet` | `character` | Variables for plot faceting (default: cdm_name, cohort_name_reference) |
| `colour` | `character` | Variable for color grouping (default: variable_name) |
| `.options` | `deprecated` | Legacy parameter, no longer used |

**Parameter Processing Logic**

```mermaid
graph TD
    subgraph "Parameter Validation"
        ValidateResult["result validation<br/>omopgenerics::validateResultArgument()"]
        ValidateLogical["uniqueCombinations validation<br/>omopgenerics::assertLogical()"]
        DeprecationWarn["Deprecation warning for .options"]
    end
    
    subgraph "Column Determination"
        NotUnique["notUniqueColumns(result)"]
        XColumn["Determine x-axis variable<br/>Exclude colour and facet variables"]
        GroupColumn["Set group variable<br/>Use notUnique columns"]
    end
    
    subgraph "Special Cases"
        SingleGroup["Handle single group case<br/>cohort_name_reference vs cohort_name_comparator"]
        EmptyX["Generate unique ID if x is empty<br/>omopgenerics::uniqueId()"]
    end
    
    ValidateResult --> NotUnique
    ValidateLogical --> NotUnique
    DeprecationWarn --> NotUnique
    NotUnique --> XColumn
    XColumn --> GroupColumn
    GroupColumn --> SingleGroup
    SingleGroup --> EmptyX
```

Sources: [R/plotCohortOverlap.R:52-93]()

## Visualization Approach

The overlap visualization uses horizontal bar charts to display percentage distributions across overlap categories. The system enforces a specific factor ordering to ensure consistent visual presentation.

**Overlap Categories and Visual Elements**

```mermaid
graph LR
    subgraph "Overlap Categories"
        OnlyRef["Only in reference cohort"]
        Both["In both cohorts"] 
        OnlyComp["Only in comparator cohort"]
    end
    
    subgraph "Visual Mapping"
        XAxis["X-axis: Percentage values"]
        YAxis["Y-axis: Cohort combinations"]
        Colors["Color: variable_name (overlap category)"]
        Facets["Facets: cdm_name, cohort_name_reference"]
    end
    
    subgraph "ggplot2 Customizations"
        Horizontal["coord_flip() for horizontal bars"]
        Theme["theme_bw() for clean appearance"] 
        Legend["Legend at top, no title"]
    end
    
    OnlyRef --> Colors
    Both --> Colors
    OnlyComp --> Colors
    Colors --> XAxis
    XAxis --> Horizontal
    YAxis --> Horizontal
    Facets --> Theme
    Theme --> Legend
```

Sources: [R/plotCohortOverlap.R:94-118]()

## Integration with visOmopResults

The plotting system delegates core visualization functionality to the `visOmopResults` package while adding overlap-specific customizations.

**visOmopResults Integration Pattern**

```mermaid
sequenceDiagram
    participant PC as plotCohortOverlap
    participant VOR as visOmopResults::barPlot
    participant GP as ggplot2
    
    PC->>PC: Prepare data and parameters
    PC->>VOR: Call barPlot(result, x, y="percentage", facet, colour, label)
    VOR->>GP: Create base ggplot object
    GP-->>VOR: Return ggplot
    VOR-->>PC: Return configured plot
    PC->>GP: Add geom_bar(stat="identity")
    PC->>GP: Add theme_bw()
    PC->>GP: Add coord_flip()
    PC->>GP: Customize legend
    GP-->>PC: Return final plot
```

The function specifically calls `visOmopResults::barPlot()` with these parameters:
- `y = "percentage"` for consistent percentage-based visualization
- `label = notUnique` for appropriate labeling of unique combinations
- Custom `stat = "identity"` for direct value mapping

Sources: [R/plotCohortOverlap.R:103-118]()

## Error Handling and Edge Cases

The visualization system includes robust error handling for common edge cases in overlap analysis.

**Error Handling Flow**

```mermaid
graph TD
    subgraph "Input Validation Errors"
        NoResults["No overlap results found<br/>result_type check fails"]
        InvalidResult["Invalid result object<br/>validateResultArgument fails"]
    end
    
    subgraph "Data Processing Edge Cases"
        EmptyX["Empty x variable<br/>Generate unique ID"]
        SingleCohort["Single cohort group<br/>Handle reference vs comparator"]
        NoGroups["No grouping variables<br/>Set group = NULL"]
    end
    
    subgraph "Error Responses"
        EmptyPlot["emptyPlot() with message"]
        WarningMsg["cli::cli_warn() with context"]
        DefaultValues["Assign sensible defaults"]
    end
    
    NoResults --> WarningMsg
    WarningMsg --> EmptyPlot
    InvalidResult --> EmptyPlot
    EmptyX --> DefaultValues
    SingleCohort --> DefaultValues
    NoGroups --> DefaultValues
```

The system returns an `emptyPlot()` with the message "No results found with `result_type == 'summarise_cohort_overlap'`" when appropriate overlap data is not available.

Sources: [R/plotCohortOverlap.R:58-61](), [R/plotCohortOverlap.R:74-92]()