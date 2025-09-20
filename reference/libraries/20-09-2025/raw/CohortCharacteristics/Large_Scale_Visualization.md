# Page: Large Scale Visualization

# Large Scale Visualization

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/plotComparedLargeScaleCharacteristics.R](R/plotComparedLargeScaleCharacteristics.R)
- [R/summariseCohortAttrition.R](R/summariseCohortAttrition.R)
- [inst/doc/summarise_large_scale_characteristics.html](inst/doc/summarise_large_scale_characteristics.html)

</details>



This document covers the visualization capabilities for large-scale characteristics analysis in the CohortCharacteristics package. Large scale visualization focuses on creating comparative plots for concept-level analysis across extensive vocabularies and classification systems, particularly for comparing prevalence rates between different time periods, cohorts, or population subgroups.

For information about large scale summarization, see [3.5.1](#3.5.1). For large scale table generation, see [3.5.3](#3.5.3).

## Purpose and Scope

Large scale visualization provides specialized plotting functions designed to handle the unique challenges of visualizing concept-level characteristics data. Unlike general characteristics visualization, large scale visualization is optimized for:

- **Comparative Analysis**: Plotting percentage prevalences between reference and comparator groups
- **Concept-Level Data**: Handling thousands of medical concepts from OMOP vocabularies
- **Missing Data Management**: Sophisticated handling of sparse concept occurrence patterns
- **Interactive Exploration**: Integration with plotly for dynamic exploration of large datasets

## Primary Visualization Function

The core visualization functionality is provided by `plotComparedLargeScaleCharacteristics()`, which creates scatter plots comparing concept prevalences between a reference group and one or more comparator groups.

```mermaid
flowchart TD
    subgraph "Input Processing"
        RESULT["summarised_result<br/>from summariseLargeScaleCharacteristics()"]
        VALIDATE["omopgenerics::validateResultArgument()"]
        FILTER["Filter: result_type == 'summarise_large_scale_characteristics'<br/>estimate_name == 'percentage'"]
    end
    
    subgraph "Data Preparation"
        TIDY["omopgenerics::tidy()<br/>Rename variable_name to concept_name"]
        REF_PREP["Reference Preparation<br/>Extract reference group data"]
        JOIN["dplyr::full_join()<br/>Merge reference with comparators"]
        MISSING["correctMissings()<br/>Handle missing values"]
    end
    
    subgraph "Visualization Generation"
        SCATTER["visOmopResults::scatterPlot()<br/>x = reference_percentage<br/>y = percentage"]
        LINE["ggplot2::geom_line()<br/>Diagonal reference line"]
        LABELS["ggplot2 labels<br/>Custom axes and legends"]
    end
    
    subgraph "Output"
        GGPLOT["ggplot2 object"]
        PLOTLY["Optional plotly integration<br/>for interactivity"]
    end
    
    RESULT --> VALIDATE
    VALIDATE --> FILTER
    FILTER --> TIDY
    TIDY --> REF_PREP
    REF_PREP --> JOIN
    JOIN --> MISSING
    MISSING --> SCATTER
    SCATTER --> LINE
    LINE --> LABELS
    LABELS --> GGPLOT
    GGPLOT --> PLOTLY
```

Sources: [R/plotComparedLargeScaleCharacteristics.R:68-143]()

## Function Parameters and Configuration

The `plotComparedLargeScaleCharacteristics()` function provides several parameters for customizing the visualization:

| Parameter | Type | Purpose | Valid Options |
|-----------|------|---------|---------------|
| `result` | summarised_result | Input data from large scale analysis | Result from `summariseLargeScaleCharacteristics()` |
| `colour` | character | Variable to color points by | `"cdm_name"`, `"cohort_name"`, strata columns, `"variable_level"`, `"type"` |
| `reference` | character | Reference group for comparison | Any level from the colour variable |
| `facet` | character/formula | Variables for plot faceting | Available plot columns or formula specification |
| `missings` | numeric | Value to replace missing data | Numeric value or `NULL` to exclude |

```mermaid
graph TD
    subgraph "Parameter Processing"
        COLOUR["colour parameter<br/>Must be one of available choices"]
        REFERENCE["reference parameter<br/>Defaults to first option if NULL"]
        FACET["facet parameter<br/>Supports formula syntax"]
        MISSINGS["missings parameter<br/>NULL = exclude, numeric = replace"]
    end
    
    subgraph "Validation Logic"
        CHECK_OPTS["unique(result[[colour]])<br/>Must have >= 2 values"]
        CHECK_REF["omopgenerics::assertChoice()<br/>Validate reference exists"]
        STRATA["omopgenerics::strataColumns()<br/>Get available strata"]
    end
    
    subgraph "Data Processing"
        FILTER_REF["Filter reference data<br/>result[[colour]] == reference"]
        CROSS_JOIN["dplyr::cross_join()<br/>Create comparator combinations"]
        FULL_JOIN["dplyr::full_join()<br/>Merge with filtered data"]
    end
    
    COLOUR --> CHECK_OPTS
    REFERENCE --> CHECK_REF
    CHECK_OPTS --> FILTER_REF
    CHECK_REF --> FILTER_REF
    FILTER_REF --> CROSS_JOIN
    CROSS_JOIN --> FULL_JOIN
    STRATA --> CHECK_OPTS
```

Sources: [R/plotComparedLargeScaleCharacteristics.R:76-114]()

## Missing Data Handling

Large scale characteristics data often contains sparse patterns where many concepts have zero prevalence in certain groups. The `correctMissings()` function provides flexible handling of these patterns:

```mermaid
flowchart LR
    INPUT["Input Data<br/>reference_percentage, percentage"]
    
    subgraph "Missing Value Logic"
        NULL_CHECK{"missings == NULL?"}
        FILTER_NA["dplyr::filter()<br/>Remove NA values<br/>!is.na(percentage)<br/>!is.na(reference_percentage)"]
        REPLACE_NA["dplyr::mutate()<br/>dplyr::if_else()<br/>Replace NA with missings value"]
    end
    
    OUTPUT["Clean Data<br/>Ready for plotting"]
    
    INPUT --> NULL_CHECK
    NULL_CHECK -->|Yes| FILTER_NA
    NULL_CHECK -->|No| REPLACE_NA
    FILTER_NA --> OUTPUT
    REPLACE_NA --> OUTPUT
```

Sources: [R/plotComparedLargeScaleCharacteristics.R:145-160]()

## Integration with OMOP Ecosystem

Large scale visualization integrates closely with the broader OMOP ecosystem and CohortCharacteristics architecture:

```mermaid
graph TB
    subgraph "Data Sources"
        LSC["summariseLargeScaleCharacteristics()<br/>Concept-level analysis results"]
        OMOP["OMOP CDM<br/>Concept vocabularies"]
    end
    
    subgraph "CohortCharacteristics Pipeline"
        SUMMARISE["summarise layer<br/>Large scale analysis"]
        PLOT["plot layer<br/>plotComparedLargeScaleCharacteristics()"]
        TABLE["table layer<br/>tableLargeScaleCharacteristics()"]
    end
    
    subgraph "Visualization Dependencies"
        VIS["visOmopResults<br/>scatterPlot() function"]
        GGPLOT["ggplot2<br/>Graphics framework"]
        OMOPGEN["omopgenerics<br/>Data validation & structure"]
    end
    
    subgraph "Output Integration"
        PLOTLY["plotly<br/>Interactive visualization"]
        STATIC["Static ggplot2<br/>Publication-ready plots"]
    end
    
    LSC --> SUMMARISE
    OMOP --> LSC
    SUMMARISE --> PLOT
    PLOT --> TABLE
    
    VIS --> PLOT
    GGPLOT --> PLOT
    OMOPGEN --> PLOT
    
    PLOT --> PLOTLY
    PLOT --> STATIC
```

Sources: [R/plotComparedLargeScaleCharacteristics.R:73-74](), [R/plotComparedLargeScaleCharacteristics.R:125-129]()

## Visualization Output and Customization

The function generates publication-ready scatter plots with several built-in features:

### Core Plot Elements

- **Scatter Points**: Each point represents a medical concept with x-axis showing reference prevalence and y-axis showing comparator prevalence
- **Diagonal Reference Line**: A dashed line indicating perfect correlation (x = y) for visual reference
- **Custom Labeling**: Automatically generated axis labels and legend titles with proper formatting
- **Faceting Support**: Multi-panel layouts for complex comparisons

### Plot Enhancement Features

```mermaid
flowchart TD
    subgraph "Base Plot Generation"
        SCATTER["visOmopResults::scatterPlot()<br/>Basic scatter plot framework"]
        POINTS["point = TRUE<br/>Show individual concepts"]
        NO_RIBBON["line = FALSE, ribbon = FALSE<br/>Disable trend lines"]
    end
    
    subgraph "Plot Enhancements"
        DIAG_LINE["ggplot2::geom_line()<br/>x = c(0, 100), y = c(0, 100)<br/>color = 'black', linetype = 'dashed'"]
        LABELS["ggplot2::ylab('Comparator (%)')<br/>ggplot2::xlab('Reference (%)')"]
        LEGEND["ggplot2::labs()<br/>colour and fill legends"]
    end
    
    subgraph "Advanced Features"
        FACETING["facet parameter<br/>Multi-panel layouts"]
        COLORING["colour parameter<br/>Group differentiation"]
        GROUPING["label parameter<br/>Concept identification"]
    end
    
    SCATTER --> DIAG_LINE
    POINTS --> DIAG_LINE
    NO_RIBBON --> DIAG_LINE
    DIAG_LINE --> LABELS
    LABELS --> LEGEND
    LEGEND --> FACETING
    FACETING --> COLORING
    COLORING --> GROUPING
```

Sources: [R/plotComparedLargeScaleCharacteristics.R:125-139]()

## Error Handling and Edge Cases

The function includes robust error handling for common edge cases in large scale data:

### Insufficient Comparison Groups

When the specified `colour` variable has fewer than 2 unique values, the function generates an informative empty plot rather than failing:

```mermaid
flowchart LR
    INPUT["colour variable"]
    CHECK{"length(unique(result[[colour]])) < 2?"}
    ERROR_PLOT["ggplot2::ggplot() +<br/>ggplot2::annotate()<br/>Informative message plot"]
    NORMAL_PLOT["Standard comparison plot"]
    OUTPUT["ggplot object"]
    
    INPUT --> CHECK
    CHECK -->|Yes| ERROR_PLOT
    CHECK -->|No| NORMAL_PLOT
    ERROR_PLOT --> OUTPUT
    NORMAL_PLOT --> OUTPUT
```

Sources: [R/plotComparedLargeScaleCharacteristics.R:88-98]()

### Parameter Validation

The function validates all parameters against available options and provides clear error messages:

- **Colour validation**: Checks against available columns including CDM name, cohort name, strata columns, variable level, and type
- **Reference validation**: Ensures the specified reference exists in the colour variable options
- **Result validation**: Uses `omopgenerics::validateResultArgument()` for standardized input checking

Sources: [R/plotComparedLargeScaleCharacteristics.R:75-83]()

# Large Scale Visualization

This document covers the visualization capabilities for large-scale characteristics analysis in the CohortCharacteristics package. Large scale visualization focuses on creating comparative plots for concept-level analysis across extensive vocabularies and classification systems, particularly for comparing prevalence rates between different time periods, cohorts, or population subgroups.

For information about large scale summarization, see [3.5.1](#3.5.1). For large scale table generation, see [3.5.3](#3.5.3).

## Purpose and Scope

Large scale visualization provides specialized plotting functions designed to handle the unique challenges of visualizing concept-level characteristics data. Unlike general characteristics visualization, large scale visualization is optimized for:

- **Comparative Analysis**: Plotting percentage prevalences between reference and comparator groups
- **Concept-Level Data**: Handling thousands of medical concepts from OMOP vocabularies
- **Missing Data Management**: Sophisticated handling of sparse concept occurrence patterns
- **Interactive Exploration**: Integration with plotly for dynamic exploration of large datasets

## Primary Visualization Function

The core visualization functionality is provided by `plotComparedLargeScaleCharacteristics()`, which creates scatter plots comparing concept prevalences between a reference group and one or more comparator groups.

```mermaid
flowchart TD
    subgraph "Input Processing"
        RESULT["summarised_result<br/>from summariseLargeScaleCharacteristics()"]
        VALIDATE["omopgenerics::validateResultArgument()"]
        FILTER["Filter: result_type == 'summarise_large_scale_characteristics'<br/>estimate_name == 'percentage'"]
    end
    
    subgraph "Data Preparation"
        TIDY["omopgenerics::tidy()<br/>Rename variable_name to concept_name"]
        REF_PREP["Reference Preparation<br/>Extract reference group data"]
        JOIN["dplyr::full_join()<br/>Merge reference with comparators"]
        MISSING["correctMissings()<br/>Handle missing values"]
    end
    
    subgraph "Visualization Generation"
        SCATTER["visOmopResults::scatterPlot()<br/>x = reference_percentage<br/>y = percentage"]
        LINE["ggplot2::geom_line()<br/>Diagonal reference line"]
        LABELS["ggplot2 labels<br/>Custom axes and legends"]
    end
    
    subgraph "Output"
        GGPLOT["ggplot2 object"]
        PLOTLY["Optional plotly integration<br/>for interactivity"]
    end
    
    RESULT --> VALIDATE
    VALIDATE --> FILTER
    FILTER --> TIDY
    TIDY --> REF_PREP
    REF_PREP --> JOIN
    JOIN --> MISSING
    MISSING --> SCATTER
    SCATTER --> LINE
    LINE --> LABELS
    LABELS --> GGPLOT
    GGPLOT --> PLOTLY
```

Sources: [R/plotComparedLargeScaleCharacteristics.R:68-143]()

## Function Parameters and Configuration

The `plotComparedLargeScaleCharacteristics()` function provides several parameters for customizing the visualization:

| Parameter | Type | Purpose | Valid Options |
|-----------|------|---------|---------------|
| `result` | summarised_result | Input data from large scale analysis | Result from `summariseLargeScaleCharacteristics()` |
| `colour` | character | Variable to color points by | `"cdm_name"`, `"cohort_name"`, strata columns, `"variable_level"`, `"type"` |
| `reference` | character | Reference group for comparison | Any level from the colour variable |
| `facet` | character/formula | Variables for plot faceting | Available plot columns or formula specification |
| `missings` | numeric | Value to replace missing data | Numeric value or `NULL` to exclude |

```mermaid
graph TD
    subgraph "Parameter Processing"
        COLOUR["colour parameter<br/>Must be one of available choices"]
        REFERENCE["reference parameter<br/>Defaults to first option if NULL"]
        FACET["facet parameter<br/>Supports formula syntax"]
        MISSINGS["missings parameter<br/>NULL = exclude, numeric = replace"]
    end
    
    subgraph "Validation Logic"
        CHECK_OPTS["unique(result[[colour]])<br/>Must have >= 2 values"]
        CHECK_REF["omopgenerics::assertChoice()<br/>Validate reference exists"]
        STRATA["omopgenerics::strataColumns()<br/>Get available strata"]
    end
    
    subgraph "Data Processing"
        FILTER_REF["Filter reference data<br/>result[[colour]] == reference"]
        CROSS_JOIN["dplyr::cross_join()<br/>Create comparator combinations"]
        FULL_JOIN["dplyr::full_join()<br/>Merge with filtered data"]
    end
    
    COLOUR --> CHECK_OPTS
    REFERENCE --> CHECK_REF
    CHECK_OPTS --> FILTER_REF
    CHECK_REF --> FILTER_REF
    FILTER_REF --> CROSS_JOIN
    CROSS_JOIN --> FULL_JOIN
    STRATA --> CHECK_OPTS
```

Sources: [R/plotComparedLargeScaleCharacteristics.R:76-114]()

## Missing Data Handling

Large scale characteristics data often contains sparse patterns where many concepts have zero prevalence in certain groups. The `correctMissings()` function provides flexible handling of these patterns:

```mermaid
flowchart LR
    INPUT["Input Data<br/>reference_percentage, percentage"]
    
    subgraph "Missing Value Logic"
        NULL_CHECK{"missings == NULL?"}
        FILTER_NA["dplyr::filter()<br/>Remove NA values<br/>!is.na(percentage)<br/>!is.na(reference_percentage)"]
        REPLACE_NA["dplyr::mutate()<br/>dplyr::if_else()<br/>Replace NA with missings value"]
    end
    
    OUTPUT["Clean Data<br/>Ready for plotting"]
    
    INPUT --> NULL_CHECK
    NULL_CHECK -->|Yes| FILTER_NA
    NULL_CHECK -->|No| REPLACE_NA
    FILTER_NA --> OUTPUT
    REPLACE_NA --> OUTPUT
```

Sources: [R/plotComparedLargeScaleCharacteristics.R:145-160]()

## Integration with OMOP Ecosystem

Large scale visualization integrates closely with the broader OMOP ecosystem and CohortCharacteristics architecture:

```mermaid
graph TB
    subgraph "Data Sources"
        LSC["summariseLargeScaleCharacteristics()<br/>Concept-level analysis results"]
        OMOP["OMOP CDM<br/>Concept vocabularies"]
    end
    
    subgraph "CohortCharacteristics Pipeline"
        SUMMARISE["summarise layer<br/>Large scale analysis"]
        PLOT["plot layer<br/>plotComparedLargeScaleCharacteristics()"]
        TABLE["table layer<br/>tableLargeScaleCharacteristics()"]
    end
    
    subgraph "Visualization Dependencies"
        VIS["visOmopResults<br/>scatterPlot() function"]
        GGPLOT["ggplot2<br/>Graphics framework"]
        OMOPGEN["omopgenerics<br/>Data validation & structure"]
    end
    
    subgraph "Output Integration"
        PLOTLY["plotly<br/>Interactive visualization"]
        STATIC["Static ggplot2<br/>Publication-ready plots"]
    end
    
    LSC --> SUMMARISE
    OMOP --> LSC
    SUMMARISE --> PLOT
    PLOT --> TABLE
    
    VIS --> PLOT
    GGPLOT --> PLOT
    OMOPGEN --> PLOT
    
    PLOT --> PLOTLY
    PLOT --> STATIC
```

Sources: [R/plotComparedLargeScaleCharacteristics.R:73-74](), [R/plotComparedLargeScaleCharacteristics.R:125-129]()

## Visualization Output and Customization

The function generates publication-ready scatter plots with several built-in features:

### Core Plot Elements

- **Scatter Points**: Each point represents a medical concept with x-axis showing reference prevalence and y-axis showing comparator prevalence
- **Diagonal Reference Line**: A dashed line indicating perfect correlation (x = y) for visual reference
- **Custom Labeling**: Automatically generated axis labels and legend titles with proper formatting
- **Faceting Support**: Multi-panel layouts for complex comparisons

### Plot Enhancement Features

```mermaid
flowchart TD
    subgraph "Base Plot Generation"
        SCATTER["visOmopResults::scatterPlot()<br/>Basic scatter plot framework"]
        POINTS["point = TRUE<br/>Show individual concepts"]
        NO_RIBBON["line = FALSE, ribbon = FALSE<br/>Disable trend lines"]
    end
    
    subgraph "Plot Enhancements"
        DIAG_LINE["ggplot2::geom_line()<br/>x = c(0, 100), y = c(0, 100)<br/>color = 'black', linetype = 'dashed'"]
        LABELS["ggplot2::ylab('Comparator (%)')<br/>ggplot2::xlab('Reference (%)')"]
        LEGEND["ggplot2::labs()<br/>colour and fill legends"]
    end
    
    subgraph "Advanced Features"
        FACETING["facet parameter<br/>Multi-panel layouts"]
        COLORING["colour parameter<br/>Group differentiation"]
        GROUPING["label parameter<br/>Concept identification"]
    end
    
    SCATTER --> DIAG_LINE
    POINTS --> DIAG_LINE
    NO_RIBBON --> DIAG_LINE
    DIAG_LINE --> LABELS
    LABELS --> LEGEND
    LEGEND --> FACETING
    FACETING --> COLORING
    COLORING --> GROUPING
```

Sources: [R/plotComparedLargeScaleCharacteristics.R:125-139]()

## Error Handling and Edge Cases

The function includes robust error handling for common edge cases in large scale data:

### Insufficient Comparison Groups

When the specified `colour` variable has fewer than 2 unique values, the function generates an informative empty plot rather than failing:

```mermaid
flowchart LR
    INPUT["colour variable"]
    CHECK{"length(unique(result[[colour]])) < 2?"}
    ERROR_PLOT["ggplot2::ggplot() +<br/>ggplot2::annotate()<br/>Informative message plot"]
    NORMAL_PLOT["Standard comparison plot"]
    OUTPUT["ggplot object"]
    
    INPUT --> CHECK
    CHECK -->|Yes| ERROR_PLOT
    CHECK -->|No| NORMAL_PLOT
    ERROR_PLOT --> OUTPUT
    NORMAL_PLOT --> OUTPUT
```

Sources: [R/plotComparedLargeScaleCharacteristics.R:88-98]()

### Parameter Validation

The function validates all parameters against available options and provides clear error messages:

- **Colour validation**: Checks against available columns including CDM name, cohort name, strata columns, variable level, and type
- **Reference validation**: Ensures the specified reference exists in the colour variable options
- **Result validation**: Uses `omopgenerics::validateResultArgument()` for standardized input checking

Sources: [R/plotComparedLargeScaleCharacteristics.R:75-83]()