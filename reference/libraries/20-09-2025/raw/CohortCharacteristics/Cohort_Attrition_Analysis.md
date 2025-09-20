# Page: Cohort Attrition Analysis

# Cohort Attrition Analysis

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/plotCohortAttrition.R](R/plotCohortAttrition.R)
- [tests/testthat/test-plotCohortAttrition.R](tests/testthat/test-plotCohortAttrition.R)

</details>



Cohort attrition analysis tracks the flow of subjects through cohort definitions, documenting how many subjects and records are excluded at each step of the cohort creation process. This analysis type provides transparency into cohort construction by visualizing the impact of each inclusion/exclusion criterion on the final cohort size.

For detailed information about the summarization functions, see [Attrition Summarization](#3.2.1). For visualization capabilities, see [Attrition Visualization](#3.2.2). For table generation, see [Attrition Tables](#3.2.3).

## Overview

Cohort attrition analysis is essential for understanding how cohorts are constructed and ensuring reproducible research. It documents the step-by-step reduction in cohort size as various inclusion and exclusion criteria are applied. This analysis follows the standard three-tier pattern used throughout the CohortCharacteristics package: summarization, visualization, and table generation.

The attrition tracking leverages the `omopgenerics` package's built-in attrition recording capabilities, where each cohort modification operation can record its impact on subject and record counts. The `CohortCharacteristics` package then processes this attrition data to create standardized flow diagrams and summary tables.

```mermaid
flowchart TD
    subgraph "Attrition Analysis Workflow"
        COHORT["cohort_table with attrition"]
        SUMMARISE["summariseCohortAttrition()"]
        PLOT["plotCohortAttrition()"]
        TABLE["tableCohortAttrition()"]
        
        COHORT --> SUMMARISE
        SUMMARISE --> PLOT
        SUMMARISE --> TABLE
    end
    
    subgraph "Attrition Data Structure"
        ATTR["attrition slot"]
        REASONS["reason descriptions"]
        COUNTS["subject/record counts"]
        EXCLUDED["excluded counts"]
        
        ATTR --> REASONS
        ATTR --> COUNTS
        ATTR --> EXCLUDED
    end
    
    subgraph "Output Formats"
        DIAGRAM["DiagrammeR flow diagrams"]
        HTMLWIDGET["Interactive HTML widgets"]
        PNG["PNG static images"]
        TABLES["Formatted attrition tables"]
        
        PLOT --> DIAGRAM
        PLOT --> HTMLWIDGET
        PLOT --> PNG
        TABLE --> TABLES
    end
    
    COHORT --> ATTR
    ATTR --> SUMMARISE
```

**Sources:** [R/plotCohortAttrition.R:1-421]()

## Attrition Tracking Integration

The cohort attrition analysis integrates with the OMOP ecosystem's standardized attrition tracking mechanism. When cohorts are modified using operations like filtering or joining, these operations can record their impact using `omopgenerics::recordCohortAttrition()`. This creates a structured log of all transformations applied to the cohort.

```mermaid
flowchart LR
    subgraph "Cohort Modification Pipeline"
        ORIGINAL["Original cohort_table"]
        FILTER1["filter() operation"]
        RECORD1["recordCohortAttrition()"]
        FILTER2["filter() operation"]
        RECORD2["recordCohortAttrition()"]
        FINAL["Final cohort_table"]
        
        ORIGINAL --> FILTER1
        FILTER1 --> RECORD1
        RECORD1 --> FILTER2
        FILTER2 --> RECORD2
        RECORD2 --> FINAL
    end
    
    subgraph "Attrition Data Capture"
        STEP1["Step 1: Initial cohort"]
        STEP2["Step 2: Date restriction"]
        STEP3["Step 3: Additional filter"]
        
        RECORD1 --> STEP2
        RECORD2 --> STEP3
    end
    
    subgraph "Analysis Functions"
        EXTRACT["summariseCohortAttrition()"]
        VISUALIZE["plotCohortAttrition()"]
        
        FINAL --> EXTRACT
        EXTRACT --> VISUALIZE
    end
```

**Sources:** [tests/testthat/test-plotCohortAttrition.R:4-9](), [R/plotCohortAttrition.R:40-47]()

## Visualization Architecture

The attrition visualization system uses `DiagrammeR` to create flow diagrams that clearly show the progression of subjects through cohort inclusion/exclusion steps. The visualization supports multiple output formats and can display both subject counts and record counts simultaneously.

```mermaid
flowchart TD
    subgraph "plotCohortAttrition Function Flow"
        INPUT["result from summariseCohortAttrition()"]
        VALIDATE["omopgenerics::validateResultArgument()"]
        PREPARE["prepareData()"]
        GRAPH["prepareGraph()"]
        EXPORT["exportGraph()"]
        OUTPUT["DiagrammeR visualization"]
        
        INPUT --> VALIDATE
        VALIDATE --> PREPARE
        PREPARE --> GRAPH
        GRAPH --> EXPORT
        EXPORT --> OUTPUT
    end
    
    subgraph "Data Preparation Functions"
        SPLITALL["omopgenerics::splitAll()"]
        PIVOT["omopgenerics::pivotEstimates()"]
        LIMIT["limitMessage() for text wrapping"]
        POSITION["boxesPosition() for layout"]
        
        PREPARE --> SPLITALL
        PREPARE --> PIVOT
        PREPARE --> LIMIT
        GRAPH --> POSITION
    end
    
    subgraph "DiagrammeR Components"
        NODES["add_node() for boxes"]
        EDGES["add_edge() for arrows"]
        STYLE["defaultStyle() configuration"]
        RENDER["render_graph()"]
        
        GRAPH --> NODES
        GRAPH --> EDGES
        GRAPH --> STYLE
        EXPORT --> RENDER
    end
```

**Sources:** [R/plotCohortAttrition.R:56-111](), [R/plotCohortAttrition.R:151-189](), [R/plotCohortAttrition.R:190-307]()

## Data Flow and Structure

The attrition analysis processes structured result objects that contain both the numeric data (subject counts, exclusion counts) and metadata (exclusion reasons, cohort names). The data preparation phase transforms this into a format suitable for diagram generation.

| Component | Function | Purpose |
|-----------|----------|---------|
| `prepareData()` | [R/plotCohortAttrition.R:151-189]() | Transforms result data into diagram format |
| `limitMessage()` | [R/plotCohortAttrition.R:128-150]() | Wraps long text for display in diagram boxes |
| `prepareGraph()` | [R/plotCohortAttrition.R:190-307]() | Creates DiagrammeR graph structure |
| `boxesPosition()` | [R/plotCohortAttrition.R:369-417]() | Calculates spatial layout of diagram elements |
| `defaultStyle()` | [R/plotCohortAttrition.R:328-368]() | Defines visual styling parameters |

The visualization supports flexible display options through the `show` parameter, which can display "subjects", "records", or both. The system also handles edge cases like empty results or missing data by generating appropriate warning diagrams.

```mermaid
flowchart TD
    subgraph "Result Data Structure"
        RESULT["summarised_result object"]
        SETTINGS["result settings with min_cell_count"]
        ESTIMATES["estimate values for counts"]
        VARIABLES["variable_name: number_subjects, excluded_subjects"]
        
        RESULT --> SETTINGS
        RESULT --> ESTIMATES
        RESULT --> VARIABLES
    end
    
    subgraph "Transformed Data"
        COUNTS["count messages for diagram boxes"]
        REASONS["reason messages for exclusion steps"]
        EXCLUDES["exclude messages for excluded subjects"]
        POSITIONS["x,y coordinates for diagram layout"]
        
        ESTIMATES --> COUNTS
        VARIABLES --> REASONS
        VARIABLES --> EXCLUDES
        REASONS --> POSITIONS
    end
    
    subgraph "DiagrammeR Graph Elements"
        TITLEBOX["title box with cohort name"]
        COUNTBOXES["count boxes showing remaining subjects"]
        REASONBOXES["reason boxes explaining exclusions"]
        EXCLUDEBOXES["exclude boxes showing excluded counts"]
        ARROWS["arrows connecting flow"]
        
        COUNTS --> COUNTBOXES
        REASONS --> REASONBOXES
        EXCLUDES --> EXCLUDEBOXES
        POSITIONS --> TITLEBOX
        POSITIONS --> ARROWS
    end
```

**Sources:** [R/plotCohortAttrition.R:151-189](), [R/plotCohortAttrition.R:369-417]()

## Output Format Support

The attrition visualization system supports multiple output formats to accommodate different use cases, from interactive exploration to publication-ready static images.

| Format | Type | Use Case |
|--------|------|----------|
| `"htmlwidget"` | Interactive | Default format for RStudio/Jupyter |
| `"png"` | Static Image | Publication figures |
| `"svg"` | Vector Image | Scalable graphics |
| `"DiagrammeR"` | Raw Object | Further programmatic manipulation |

The PNG export functionality uses `DiagrammeRsvg` and `rsvg` packages to convert the vector-based DiagrammeR output into raster format, with automatic width scaling based on the number of cohorts being displayed.

**Sources:** [R/plotCohortAttrition.R:308-327](), [R/plotCohortAttrition.R:56-65]()