# Page: Timing Visualization

# Timing Visualization

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/plotCohortTiming.R](R/plotCohortTiming.R)
- [inst/doc/summarise_cohort_timing.html](inst/doc/summarise_cohort_timing.html)

</details>



This page covers the visualization capabilities for cohort timing analysis within the CohortCharacteristics package. It focuses specifically on the `plotCohortTiming` function and related visualization infrastructure for temporal relationships between cohort entries.

For information about timing summarization, see [3.4.1](#3.4.1). For timing table generation, see [3.4.3](#3.4.3).

## Overview

The timing visualization system transforms summarized cohort timing results into interactive plots that display the temporal relationships between different cohorts. The primary function `plotCohortTiming` supports multiple visualization formats optimized for different analytical needs.

Sources: [R/plotCohortTiming.R:17-28]()

## Core Visualization Function

### Function Architecture

```mermaid
flowchart TD
    subgraph "Input Processing"
        A["result"] --> B["omopgenerics::validateResultArgument"]
        B --> C["Filter result_type == 'summarise_cohort_timing'"]
        C --> D["Extract 'days_between_cohort_entries'"]
    end
    
    subgraph "Validation & Warnings"
        D --> E["Check count < 10"]
        E --> F["Generate warnings for low counts"]
        F --> G["Format warning messages"]
    end
    
    subgraph "Plot Generation"
        G --> H["plotInternal"]
        H --> I{"plotType"}
        I -->|"boxplot"| J["coord_flip + geom_hline"]
        I -->|"densityplot"| K["geom_vline + minimumRange"]
    end
    
    subgraph "Output"
        J --> L["ggplot object"]
        K --> L
    end
```

The `plotCohortTiming` function follows a structured pipeline that validates inputs, processes timing data, and generates appropriate visualizations based on the specified plot type.

Sources: [R/plotCohortTiming.R:69-172]()

### Parameters and Configuration

| Parameter | Type | Options | Purpose |
|-----------|------|---------|---------|
| `result` | `data.frame` | Summarised result object | Input timing data |
| `plotType` | `character` | "boxplot", "densityplot" | Visualization method |
| `timeScale` | `character` | "days", "years" | Time unit display |
| `uniqueCombinations` | `logical` | TRUE, FALSE | Combination filtering |
| `facet` | `character` | Column names | Plot faceting variables |
| `colour` | `character` | Column names | Plot coloring variables |

Sources: [R/plotCohortTiming.R:69-74]()

## Plot Types and Characteristics

### Boxplot Visualization

```mermaid
flowchart LR
    subgraph "Boxplot Features"
        A["coord_flip()"] --> B["Horizontal orientation"]
        C["geom_hline(yintercept = 0)"] --> D["Zero reference line"]
        E["Quartile boxes"] --> F["Distribution summary"]
        G["Outlier points"] --> H["Extreme values"]
    end
    
    subgraph "Use Cases"
        I["Comparing distributions"]
        J["Identifying outliers"]
        K["Summary statistics"]
    end
    
    B --> I
    D --> J
    F --> K
```

Boxplots provide a compact view of timing distributions with coordinate flipping for better readability and horizontal reference lines at zero to emphasize the temporal direction.

Sources: [R/plotCohortTiming.R:147-157]()

### Density Plot Visualization

```mermaid
flowchart LR
    subgraph "Density Features"
        A["geom_vline(xintercept = 0)"] --> B["Vertical reference line"]
        C["Density curves"] --> D["Distribution shape"]
        E["minimumRange()"] --> F["Scale adjustment"]
    end
    
    subgraph "Use Cases"
        G["Distribution shapes"]
        H["Multiple comparisons"]
        I["Continuous patterns"]
    end
    
    B --> G
    D --> H
    F --> I
```

Density plots show the full distribution shape with automatic range adjustment to ensure meaningful visualization even for narrow time ranges.

Sources: [R/plotCohortTiming.R:158-169](), [R/plotCohortTiming.R:173-183]()

## Data Processing Pipeline

### Input Validation and Filtering

```mermaid
flowchart TD
    subgraph "Validation Layer"
        A["omopgenerics::validateResultArgument"] --> B["Check result structure"]
        B --> C["Verify required columns"]
    end
    
    subgraph "Filtering Layer"
        C --> D["filterSettings: result_type == 'summarise_cohort_timing'"]
        D --> E["Extract variable_name == 'days_between_cohort_entries'"]
    end
    
    subgraph "Quality Checks"
        E --> F["Count validation"]
        F --> G["Warning generation for count < 10"]
        G --> H["Message formatting"]
    end
    
    H --> I["Processed data ready for plotting"]
```

The function implements comprehensive input validation and provides user warnings when data quality might affect interpretation.

Sources: [R/plotCohortTiming.R:78-82](), [R/plotCohortTiming.R:85-124](), [R/plotCohortTiming.R:127-129]()

### Time Scale Conversion

The system supports automatic conversion between time scales through the `toYears` parameter in the internal plotting function, allowing users to visualize timing data in either days or years based on analytical needs.

```mermaid
flowchart LR
    A["timeScale parameter"] --> B{"timeScale == 'years'"}
    B -->|TRUE| C["toYears = TRUE"]
    B -->|FALSE| D["toYears = FALSE"]
    C --> E["Convert days to years"]
    D --> F["Keep days scale"]
    E --> G["Update axis labels"]
    F --> G
```

Sources: [R/plotCohortTiming.R:139](), [R/plotCohortTiming.R:143-145]()

## Integration with Analysis Pipeline

### Connection to Timing Analysis System

```mermaid
flowchart TD
    subgraph "Input Source"
        A["summariseCohortTiming()"] --> B["summarised_result object"]
    end
    
    subgraph "Visualization Layer"
        B --> C["plotCohortTiming()"]
        C --> D["plotInternal()"]
    end
    
    subgraph "Output Integration"
        D --> E["ggplot2 object"]
        E --> F["visOmopResults integration"]
        E --> G["Report generation"]
    end
    
    subgraph "Supporting Functions"
        H["minimumRange()"] --> D
        I["getUniqueCombinationsSr()"] --> C
    end
```

The timing visualization integrates seamlessly with the broader OMOP analysis ecosystem, accepting standardized result objects and producing ggplot2 outputs compatible with downstream reporting tools.

Sources: [R/plotCohortTiming.R:131-141](), [R/plotCohortTiming.R:173-183](), [R/plotCohortTiming.R:90]()

### Warning System

The function implements a sophisticated warning system for low-count scenarios that could affect result interpretation:

```mermaid
flowchart TD
    A["Check number records < 10"] --> B["Apply uniqueCombinations filter"]
    B --> C["Extract group and strata information"]
    C --> D["Format warning messages"]
    D --> E["Generate cli::cli_warn output"]
    
    subgraph "Message Components"
        F["Cohort comparison pairs"]
        G["Strata information"]
        H["Count thresholds"]
    end
    
    D --> F
    D --> G
    D --> H
```

Sources: [R/plotCohortTiming.R:85-124]()