# Page: Visualization and Output

# Visualization and Output

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/plotSurvival.R](R/plotSurvival.R)
- [R/tableSurvival.R](R/tableSurvival.R)
- [tests/testthat/test-plotSurvival.R](tests/testthat/test-plotSurvival.R)

</details>



This document covers the visualization and output capabilities of CohortSurvival, including survival plot generation, summary table creation, and risk table formatting. These functions transform survival analysis results into publication-ready visualizations and tables for clinical research and reporting.

The three core output functions work with standardized `survival_result` objects to produce different types of outputs: `plotSurvival` creates Kaplan-Meier curves and cumulative incidence plots, `tableSurvival` generates summary statistics tables, and `riskTable` produces numbers-at-risk tables. For detailed usage of individual functions, see [Plotting Survival Curves](#4.1), [Generating Summary Tables](#4.2), and [Risk Tables and Event Counts](#4.3).

## Output Generation Workflow

The visualization and output system follows a standardized pipeline that transforms survival analysis results into various presentation formats:

```mermaid
flowchart TD
    SR["survival_result object<br/>(from asSurvivalResult)"]
    
    SR --> PS["plotSurvival()"]
    SR --> TS["tableSurvival()"]
    SR --> RT["riskTable()"]
    
    PS --> PL["ggplot2 objects<br/>Survival curves"]
    PS --> PR["ggplot2 objects<br/>+ Risk tables"]
    
    TS --> SUM["Formatted tables<br/>Summary statistics"]
    TS --> PROB["Formatted tables<br/>Time-specific probabilities"]
    
    RT --> RISK["Formatted tables<br/>Numbers at risk/events"]
    
    subgraph "Plot Types"
        PL
        PR
        CUM["Cumulative incidence plots"]
        LOG["Log-log plots"]
    end
    
    subgraph "Table Types"
        SUM
        PROB
        RISK
    end
    
    PS --> CUM
    PS --> LOG
    
    subgraph "Output Formats"
        GT["gt tables"]
        FLEX["flextable tables"]
        TIB["tibble tables"]
    end
    
    TS --> GT
    TS --> FLEX
    TS --> TIB
    RT --> GT
    RT --> FLEX
    RT --> TIB
```

Sources: [R/plotSurvival.R:42-247](), [R/tableSurvival.R:44-276](), [R/tableSurvival.R:329-437]()

## Core Visualization Functions

The package provides three primary functions for generating outputs from survival analysis results:

| Function | Purpose | Key Parameters | Output Type |
|----------|---------|----------------|-------------|
| `plotSurvival` | Survival curves and plots | `ribbon`, `facet`, `colour`, `cumulativeFailure`, `riskTable`, `timeScale`, `logLog` | ggplot2 objects |
| `tableSurvival` | Summary statistics tables | `times`, `timeScale`, `header`, `type`, `.options` | Formatted tables |
| `riskTable` | Numbers at risk tables | `eventGap`, `header`, `type`, `.options` | Formatted tables |

### Function Integration Architecture

```mermaid
graph TD
    subgraph "Input Processing"
        ASR["asSurvivalResult()"]
        CHECK["Input validation<br/>Empty result checks"]
    end
    
    subgraph "plotSurvival Components"
        SCALE["Time scale conversion<br/>days/months/years"]
        TRANS["Data transformation<br/>cumulative failure/log-log"]
        PLOT["visOmopResults::scatterPlot()"]
        RIBBON["addRibbon()"]
        RISK_GEN["generateRiskData()"]
    end
    
    subgraph "Table Components"
        FILTER["Result filtering<br/>by result_type"]
        FORMAT["visOmopResults formatting<br/>decimals/estimates"]
        UNITE["omopgenerics::uniteAdditional()"]
        VIS_TABLE["visOmopResults::visOmopTable()"]
    end
    
    subgraph "External Dependencies"
        VOR["visOmopResults"]
        GG["ggplot2"]
        PATCH["patchwork"]
        OMOP["omopgenerics"]
    end
    
    ASR --> CHECK
    CHECK --> SCALE
    CHECK --> FILTER
    
    SCALE --> TRANS
    TRANS --> PLOT
    PLOT --> RIBBON
    PLOT --> RISK_GEN
    
    FILTER --> FORMAT
    FORMAT --> UNITE
    UNITE --> VIS_TABLE
    
    VOR --> PLOT
    VOR --> VIS_TABLE
    GG --> PLOT
    GG --> RIBBON
    PATCH --> RISK_GEN
    OMOP --> UNITE
```

Sources: [R/plotSurvival.R:62-63](), [R/plotSurvival.R:113-129](), [R/tableSurvival.R:67-72](), [R/tableSurvival.R:264-273]()

## Visualization Capabilities

### Plot Types and Transformations

The `plotSurvival` function supports multiple visualization modes through parameter combinations:

```mermaid
graph LR
    subgraph "Base Plot Types"
        SURV["Survival probability<br/>cumulativeFailure=FALSE"]
        CUM["Cumulative incidence<br/>cumulativeFailure=TRUE"]
    end
    
    subgraph "Transformations"
        TIME["Time scale<br/>timeScale parameter"]
        LOG["Log-log transformation<br/>logLog=TRUE"]
    end
    
    subgraph "Visual Elements"
        RIB["Confidence ribbons<br/>ribbon=TRUE"]
        FACETS["Faceting<br/>facet parameter"]
        COLORS["Color grouping<br/>colour parameter"]
        RTABLE["Risk tables<br/>riskTable=TRUE"]
    end
    
    SURV --> TIME
    CUM --> TIME
    TIME --> LOG
    
    SURV --> RIB
    CUM --> RIB
    RIB --> FACETS
    FACETS --> COLORS
    COLORS --> RTABLE
```

Sources: [R/plotSurvival.R:23-24](), [R/plotSurvival.R:27-28](), [R/plotSurvival.R:46-50](), [R/plotSurvival.R:101-109]()

### Parameter Dependencies and Constraints

The visualization functions have specific parameter dependencies and validation rules:

- **Competing Risk Constraint**: When `result_type` is `"cumulative_failure_probability"`, `cumulativeFailure` must be `TRUE` [R/plotSurvival.R:77-79]()
- **Time Scale Conversion**: Automatic conversion between days, months, and years with appropriate axis labeling [R/plotSurvival.R:65-75]()
- **Risk Table Integration**: When `riskTable=TRUE`, generates combined plots using `patchwork` for layout [R/plotSurvival.R:135-244]()
- **Log-Log Transformation**: Applies `log(-log(estimate))` transformation for diagnostic plots [R/plotSurvival.R:102-106]()

## Table Generation System

### Summary Table Architecture

The table generation system processes survival results through a multi-stage pipeline:

```mermaid
flowchart TD
    INPUT["survival_result input"]
    
    subgraph "tableSurvival Pipeline"
        CLEAN["Filter probability/summary results<br/>splitAdditional()"]
        TIME_PROC["Time-specific processing<br/>Scale conversion"]
        SUMMARY["Overall summary statistics<br/>median, RMST, counts"]
        COMBINE["Combine time-specific + summary"]
        FORMAT_EST["formatEstimateValue()<br/>formatEstimateName()"]
    end
    
    subgraph "riskTable Pipeline"
        EVENTS["Filter events results<br/>by eventGap"]
        RISK_FORMAT["Format risk/events/censor counts"]
        TIME_FORMAT["Time and eventGap formatting"]
    end
    
    INPUT --> CLEAN
    INPUT --> EVENTS
    
    CLEAN --> TIME_PROC
    TIME_PROC --> SUMMARY
    SUMMARY --> COMBINE
    COMBINE --> FORMAT_EST
    
    EVENTS --> RISK_FORMAT
    RISK_FORMAT --> TIME_FORMAT
    
    FORMAT_EST --> OUTPUT_TABLE["visOmopTable()"]
    TIME_FORMAT --> OUTPUT_TABLE
    
    OUTPUT_TABLE --> GT["gt format"]
    OUTPUT_TABLE --> FLEX["flextable format"]
    OUTPUT_TABLE --> TIB["tibble format"]
```

Sources: [R/tableSurvival.R:67-72](), [R/tableSurvival.R:168-228](), [R/tableSurvival.R:350-369](), [R/tableSurvival.R:369-387]()

### Table Content Organization

Tables organize survival statistics into standardized categories with specific estimate names and formatting:

| Estimate Type | tableSurvival | riskTable | 
|---------------|---------------|-----------|
| **Summary Statistics** | `"Number records"`, `"Number events"`, `"median_survival"`, `"restricted_mean_survival"` | - |
| **Time-specific Probabilities** | User-defined `times` with confidence intervals | - |
| **Event Counts** | - | `"Number at risk"`, `"Number events"`, `"Number censored"` |

Sources: [R/tableSurvival.R:179-183](), [R/tableSurvival.R:371-376]()

## Integration with Analysis Results

### Data Flow from Analysis to Output

The output functions seamlessly integrate with the broader CohortSurvival analysis pipeline:

```mermaid
sequenceDiagram
    participant Analysis as "estimateSingleEventSurvival<br/>estimateCompetingRiskSurvival"
    participant Format as "asSurvivalResult"
    participant Plot as "plotSurvival"
    participant Table as "tableSurvival"
    participant Risk as "riskTable"
    
    Analysis->>Format: summarised_result object
    Format->>Format: Validate and standardize<br/>Add events attribute
    
    Format->>Plot: survival_result object
    Plot->>Plot: Convert time scales<br/>Apply transformations
    Plot-->>Analysis: ggplot2 visualization
    
    Format->>Table: survival_result object  
    Table->>Table: Filter by result_type<br/>Format estimates
    Table-->>Analysis: Formatted summary table
    
    Format->>Risk: survival_result object
    Risk->>Risk: Extract events data<br/>Filter by eventGap
    Risk-->>Analysis: Risk table
```

Sources: [R/plotSurvival.R:62](), [R/tableSurvival.R:67](), [R/tableSurvival.R:339]()

### Result Type Compatibility

Different analysis types produce specific result types that determine output compatibility:

- **Single Event Analysis**: Produces `"survival_probability"` results, compatible with all output functions
- **Competing Risk Analysis**: Produces `"cumulative_failure_probability"` results, requires `cumulativeFailure=TRUE` in plots
- **Events Data**: All analyses produce `"events"` results for risk table generation

Sources: [R/plotSurvival.R:77-89](), [R/tableSurvival.R:69](), [R/tableSurvival.R:352]()