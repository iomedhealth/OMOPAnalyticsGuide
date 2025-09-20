# Page: Plotting Survival Curves

# Plotting Survival Curves

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/plotSurvival.R](R/plotSurvival.R)
- [man/plotSurvival.Rd](man/plotSurvival.Rd)
- [tests/testthat/test-plotSurvival.R](tests/testthat/test-plotSurvival.R)

</details>



This document covers the visualization capabilities of the CohortSurvival package, specifically the `plotSurvival()` function and its associated plotting utilities. This page focuses on creating publication-ready survival curves, risk tables, and customization options for survival analysis results.

For information about generating survival analysis results that serve as input to these plotting functions, see [Core Survival Analysis Functions](#2). For creating summary tables instead of plots, see [Generating Summary Tables](#4.2).

## Purpose and Scope

The `plotSurvival()` function transforms survival analysis results into publication-ready visualizations using the `visOmopResults` plotting framework. It supports both standard survival probability curves and cumulative failure probability plots, with extensive customization options including faceting, coloring, confidence ribbons, and integrated risk tables.

Sources: [R/plotSurvival.R:17-31](), [man/plotSurvival.Rd:5-17]()

## Core Plotting Architecture

The plotting system builds upon the `visOmopResults` package to create standardized, publication-ready survival visualizations with extensive customization capabilities.

```mermaid
graph TD
    subgraph "Input Processing"
        SR["survival result"] --> ASR["asSurvivalResult()"]
        ASR --> VR["validated result"]
    end
    
    subgraph "Plot Generation"
        VR --> SP["visOmopResults::scatterPlot()"]
        SP --> BP["base plot"]
        BP --> AR["addRibbon()"]
        AR --> FP["final plot"]
    end
    
    subgraph "Risk Table Generation"
        VR --> GRD["generateRiskData()"]
        GRD --> RT["risk table plot"]
        RT --> CP["combined plot"]
    end
    
    subgraph "Customization Options"
        FACET["facet parameter"] --> SP
        COLOUR["colour parameter"] --> SP
        RIBBON["ribbon parameter"] --> AR
        RISKTABLE["riskTable parameter"] --> GRD
    end
    
    FP --> OUTPUT["ggplot2 object"]
    CP --> OUTPUT
    
    style ASR fill:#e3f2fd
    style SP fill:#f3e5f5
    style GRD fill:#e8f5e8
    style OUTPUT fill:#fff3e0
```

**Plot Generation Flow**

This diagram illustrates how `plotSurvival()` processes survival results through validation, base plot creation, and optional enhancements like ribbons and risk tables.

Sources: [R/plotSurvival.R:42-51](), [R/plotSurvival.R:113-129]()

## Function Interface and Parameters

The `plotSurvival()` function provides comprehensive control over survival curve visualization through its parameter interface:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `result` | `summarised_result` | Required | Survival analysis results from `estimateSingleEventSurvival()` or `estimateCompetingRiskSurvival()` |
| `ribbon` | `logical` | `TRUE` | Whether to display confidence interval ribbons |
| `facet` | `character` | `NULL` | Variables for creating subplot facets |
| `colour` | `character` | `NULL` | Variables for curve coloring |
| `cumulativeFailure` | `logical` | `FALSE` | Plot cumulative failure instead of survival probability |
| `riskTable` | `logical` | `FALSE` | Include numbers-at-risk table below plot |
| `riskInterval` | `numeric` | `30` | Time interval for risk table entries |
| `logLog` | `logical` | `FALSE` | Apply log-log transformation to survival probabilities |
| `timeScale` | `character` | `"days"` | Time axis scale: `"days"`, `"months"`, or `"years"` |

Sources: [R/plotSurvival.R:42-50](), [man/plotSurvival.Rd:19-37]()

## Time Scale Transformation

The plotting function supports automatic time scale conversion to improve readability for different follow-up periods:

```mermaid
graph LR
    subgraph "Time Scale Processing"
        DAYS["timeScale = 'days'"] --> NOCONV["No conversion<br/>xlab = 'Time in days'"]
        MONTHS["timeScale = 'months'"] --> MONTHCONV["time / 30.4375<br/>xlab = 'Time in months'"]
        YEARS["timeScale = 'years'"] --> YEARCONV["time / 365.25<br/>xlab = 'Time in years'"]
    end
    
    subgraph "Result Transformation"
        NOCONV --> PLOT["ggplot object"]
        MONTHCONV --> PLOT
        YEARCONV --> PLOT
    end
    
    style DAYS fill:#e8f5e8
    style MONTHS fill:#e8f5e8
    style YEARS fill:#e8f5e8
```

**Time Scale Conversion Logic**

The conversion factors use standard epidemiological conventions: 30.4375 days per month (365.25/12) and 365.25 days per year to account for leap years.

Sources: [R/plotSurvival.R:64-75]()

## Survival vs Cumulative Failure Visualization

The function can display either survival probabilities or cumulative failure probabilities, with automatic validation for competing risk results:

```mermaid
graph TD
    subgraph "Plot Type Logic"
        CR["Competing Risk Result"] --> CF_REQUIRED["cumulativeFailure = TRUE<br/>Required"]
        SE["Single Event Result"] --> CF_OPTIONAL["cumulativeFailure = TRUE/FALSE<br/>Optional"]
    end
    
    subgraph "Probability Transformation"
        CF_OPTIONAL --> CF_TRUE["Transform to Failure<br/>1 - survival_probability"]
        CF_OPTIONAL --> CF_FALSE["Keep Survival<br/>survival_probability"]
        CF_REQUIRED --> CF_COMP["Plot Failure<br/>cumulative_failure_probability"]
    end
    
    subgraph "Validation"
        CF_COMP --> VALIDATE["Check result_type"]
        VALIDATE --> ERROR["cli::cli_abort() if mismatch"]
    end
    
    style CR fill:#ffebee
    style SE fill:#e8f5e8
    style ERROR fill:#ffcdd2
```

**Cumulative Failure Mode Selection**

Competing risk analyses require `cumulativeFailure = TRUE` since they produce cumulative failure probabilities rather than survival probabilities.

Sources: [R/plotSurvival.R:77-89]()

## Ribbon and Confidence Interval Display

The `addRibbon()` helper function enhances plots with confidence interval visualization:

```mermaid
graph LR
    subgraph "Ribbon Configuration"
        RIBBON_TRUE["ribbon = TRUE"] --> ADD_RIBBON["addRibbon()"]
        RIBBON_FALSE["ribbon = FALSE"] --> SKIP_RIBBON["Line plot only"]
    end
    
    subgraph "Ribbon Implementation"
        ADD_RIBBON --> GEOM_RIBBON["ggplot2::geom_ribbon()"]
        GEOM_RIBBON --> ALPHA["alpha = 0.3"]
        ALPHA --> GEOM_LINE["ggplot2::geom_line()"]
        GEOM_LINE --> LINEWIDTH["linewidth = 0.25"]
    end
    
    SKIP_RIBBON --> FINAL["Final plot"]
    LINEWIDTH --> FINAL
    
    style ADD_RIBBON fill:#e3f2fd
    style GEOM_RIBBON fill:#f3e5f5
```

**Confidence Interval Ribbon Implementation**

The ribbon uses semi-transparent shading (`alpha = 0.3`) with `estimate_95CI_lower` and `estimate_95CI_upper` as boundaries, overlaid with a thin survival curve line.

Sources: [R/plotSurvival.R:131-133](), [R/plotSurvival.R:304-311]()

## Risk Table Integration

Risk tables display numbers-at-risk at specified time intervals below the survival curves, with support for stratified analyses:

```mermaid
graph TD
    subgraph "Risk Table Logic"
        RT_TRUE["riskTable = TRUE"] --> CALC_TIMES["Calculate riskTimes<br/>seq(0, max_t, riskInterval)"]
        CALC_TIMES --> CHECK_FACET["Check facet parameter"]
    end
    
    subgraph "Faceted vs Non-Faceted"
        CHECK_FACET --> FACET_NULL["facet = NULL"]
        CHECK_FACET --> FACET_SET["facet specified"]
        
        FACET_NULL --> GRD_SIMPLE["generateRiskData()"]
        FACET_SET --> APPLY_PLOT["applyPlot() for each facet"]
        
        GRD_SIMPLE --> SIMPLE_TABLE["Single risk table"]
        APPLY_PLOT --> MULTIPLE_TABLES["Multiple risk tables"]
    end
    
    subgraph "Plot Combination"
        SIMPLE_TABLE --> PATCHWORK["patchwork layout<br/>heights = c(8,1)"]
        MULTIPLE_TABLES --> WRAP_PLOTS["patchwork::wrap_plots()"]
    end
    
    style GRD_SIMPLE fill:#e8f5e8
    style APPLY_PLOT fill:#fff3e0
    style PATCHWORK fill:#f3e5f5
```

**Risk Table Generation Process**

Risk tables are created using `generateRiskData()` and combined with survival plots using the `patchwork` package, with the survival plot taking 8/9 of the height and risk table taking 1/9.

Sources: [R/plotSurvival.R:135-244](), [R/plotSurvival.R:249-302]()

## Log-Log Transformation

The `logLog` parameter applies the complementary log-log transformation commonly used in survival analysis diagnostics:

```mermaid
graph LR
    subgraph "Log-Log Transformation"
        LOGLOG_TRUE["logLog = TRUE"] --> TRANSFORM["Apply Transformations"]
        TRANSFORM --> EST_TRANS["estimate = log(-log(estimate))"]
        EST_TRANS --> CI_TRANS["CI bounds = log(-log(CI))"]
        CI_TRANS --> TIME_TRANS["time = log(time)"]
    end
    
    subgraph "Plot Labeling"
        TIME_TRANS --> PLOT_NAME["plot_name = 'Log-log ' + plot_name"]
        PLOT_NAME --> LOG_PLOT["Log-log survival plot"]
    end
    
    style TRANSFORM fill:#e3f2fd
    style LOG_PLOT fill:#e8f5e8
```

**Log-Log Transformation Implementation**

The transformation converts both survival estimates and time values to log scale, producing linearized curves that can help assess proportional hazards assumptions.

Sources: [R/plotSurvival.R:101-109]()

## Integration with visOmopResults

The plotting system leverages `visOmopResults::scatterPlot()` as the foundation for standardized OMOP result visualization:

```mermaid
graph TD
    subgraph "visOmopResults Integration"
        RESULT["survival result"] --> SCATTER_PLOT["visOmopResults::scatterPlot()"]
        SCATTER_PLOT --> PLOT_CONFIG["Configure plot parameters"]
    end
    
    subgraph "Plot Configuration"
        PLOT_CONFIG --> X_AXIS["x = 'time'"]
        X_AXIS --> Y_AXIS["y = 'estimate'"]
        Y_AXIS --> LINE_TRUE["line = TRUE"]
        LINE_TRUE --> POINT_FALSE["point = FALSE"]
        POINT_FALSE --> RIBBON_FALSE["ribbon = FALSE"]
    end
    
    subgraph "Styling"
        RIBBON_FALSE --> SCALE_Y["scale_y_continuous(labels = scales::comma)"]
        SCALE_Y --> THEME["visOmopResults::themeVisOmop()"]
        THEME --> FINAL_PLOT["Styled ggplot object"]
    end
    
    style SCATTER_PLOT fill:#e3f2fd
    style THEME fill:#f3e5f5
    style FINAL_PLOT fill:#e8f5e8
```

**visOmopResults Integration Pattern**

The function uses `visOmopResults::scatterPlot()` with specific parameters optimized for survival curves: line plots without points, custom y-axis formatting, and consistent OMOP theming.

Sources: [R/plotSurvival.R:113-129]()

## Error Handling and Validation

The plotting function includes comprehensive validation to ensure proper input formatting and parameter compatibility:

```mermaid
graph TD
    subgraph "Input Validation"
        EMPTY_CHECK["nrow(result) == 0"] --> EMPTY_PLOT["visOmopResults::emptyPlot()"]
        NON_EMPTY["nrow(result) > 0"] --> AS_SURVIVAL["asSurvivalResult()"]
    end
    
    subgraph "Parameter Validation"
        AS_SURVIVAL --> CF_CHECK["Check cumulativeFailure compatibility"]
        CF_CHECK --> CF_ERROR["cli::cli_abort() for competing risk mismatch"]
        CF_CHECK --> CF_VALID["Proceed with plotting"]
    end
    
    subgraph "Risk Table Validation"
        CF_VALID --> RT_CHECK["Check riskInterval validity"]
        RT_CHECK --> RT_ERROR["cli::cli_abort() for invalid interval"]
        RT_CHECK --> RT_VALID["Generate risk table"]
    end
    
    style EMPTY_PLOT fill:#ffcdd2
    style CF_ERROR fill:#ffcdd2
    style RT_ERROR fill:#ffcdd2
    style RT_VALID fill:#e8f5e8
```

**Validation and Error Handling Flow**

The function validates inputs at multiple stages, providing informative error messages through `cli::cli_abort()` for invalid parameter combinations or data issues.

Sources: [R/plotSurvival.R:57-60](), [R/plotSurvival.R:77-79](), [R/plotSurvival.R:186-191]()