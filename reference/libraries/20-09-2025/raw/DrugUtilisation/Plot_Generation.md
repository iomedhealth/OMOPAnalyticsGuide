# Page: Plot Generation

# Plot Generation

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/plots.R](R/plots.R)
- [man/plotDrugRestart.Rd](man/plotDrugRestart.Rd)
- [man/plotIndication.Rd](man/plotIndication.Rd)
- [man/plotTreatment.Rd](man/plotTreatment.Rd)
- [man/summariseTreatment.Rd](man/summariseTreatment.Rd)
- [tests/testthat/test-generatedAtcCohortSet.R](tests/testthat/test-generatedAtcCohortSet.R)
- [tests/testthat/test-generatedIngredientCohortSet.R](tests/testthat/test-generatedIngredientCohortSet.R)
- [tests/testthat/test-patterns.R](tests/testthat/test-patterns.R)
- [tests/testthat/test-plotProportionOfPatientsCovered.R](tests/testthat/test-plotProportionOfPatientsCovered.R)
- [tests/testthat/test-plots.R](tests/testthat/test-plots.R)

</details>



This document covers the visualization system for generating plots from analysis results within the DrugUtilisation package. The plot generation functions create standardized visualizations using ggplot2 from `summarised_result` objects produced by various analysis functions. For table generation from the same analysis results, see [Table Generation](#8.1).

## Purpose and Architecture

The plot generation system provides specialized plotting functions for each analysis type supported by the package. All plotting functions follow a consistent pattern: they accept `summarised_result` objects as input and return customizable ggplot2 objects for visualization.

### Plot Generation System Architecture

```mermaid
graph TB
    subgraph "Analysis Results"
        SR["summarised_result objects"]
        TRT["Treatment Analysis Results"]
        IND["Indication Analysis Results"] 
        DRG["Drug Utilisation Results"]
        RST["Drug Restart Results"]
        PPC["Patient Coverage Results"]
    end
    
    subgraph "Plot Functions"
        PTR["plotTreatment()"]
        PIN["plotIndication()"]
        PDU["plotDrugUtilisation()"]
        PDR["plotDrugRestart()"]
        PPP["plotProportionOfPatientsCovered()"]
    end
    
    subgraph "Internal Utilities"
        BPI["barPlotInternal()"]
        GV["getVariables()"]
        UC["uniteColumn()"]
        EP["emptyPlot()"]
    end
    
    subgraph "External Dependencies"
        VOR["visOmopResults package"]
        GG["ggplot2"]
        RL["rlang"]
    end
    
    subgraph "Output"
        GGPLOT["ggplot2 objects"]
    end
    
    TRT --> PTR
    IND --> PIN
    DRG --> PDU
    RST --> PDR
    PPC --> PPP
    
    PTR --> BPI
    PIN --> BPI
    PDR --> BPI
    
    PDU --> VOR
    PPP --> GG
    
    BPI --> VOR
    BPI --> GV
    
    PDU --> GV
    PPP --> UC
    
    PTR --> GGPLOT
    PIN --> GGPLOT
    PDU --> GGPLOT
    PDR --> GGPLOT
    PPP --> GGPLOT
    
    GV --> EP
```

Sources: [R/plots.R:1-548]()

## Core Plotting Functions

### Treatment Analysis Plots

The `plotTreatment()` function creates bar plots for treatment analysis results from `summariseTreatment()`. It visualizes the percentage of patients receiving different treatments within specified time windows.

```mermaid
graph LR
    subgraph "Treatment Plot Flow"
        TSUMM["summariseTreatment() result"]
        PTRT["plotTreatment()"]
        BPI["barPlotInternal()"]
        VBAR["visOmopResults::barPlot()"]
        TPLOT["Treatment bar plot"]
    end
    
    TSUMM --> PTRT
    PTRT --> BPI
    BPI --> VBAR
    VBAR --> TPLOT
    
    subgraph "Customization"
        FACET["facet parameter"]
        COLOR["colour parameter"]
    end
    
    FACET --> PTRT
    COLOR --> PTRT
```

The function accepts parameters for customizing faceting and coloring:
- `facet`: Controls plot faceting, defaults to `cdm_name + cohort_name ~ window_name`
- `colour`: Controls color mapping, defaults to `"variable_level"`

Sources: [R/plots.R:41-51](), [man/plotTreatment.Rd:1-46]()

### Drug Restart Analysis Plots

The `plotDrugRestart()` function visualizes drug restart patterns from `summariseDrugRestart()` results, showing events like discontinuation, switches, and restarts across different follow-up periods.

```mermaid
graph TB
    subgraph "Drug Restart Visualization"
        RSUMM["summariseDrugRestart() result"]
        PRST["plotDrugRestart()"]
        RPLOT["Drug restart bar plot"]
    end
    
    RSUMM --> PRST
    PRST --> RPLOT
    
    subgraph "Default Settings"
        RFACET["facet = cdm_name + cohort_name ~ follow_up_days"]
        RCOLOR["colour = variable_level"]
    end
    
    RFACET --> PRST
    RCOLOR --> PRST
```

Sources: [R/plots.R:80-90](), [man/plotDrugRestart.Rd:1-49]()

### Indication Analysis Plots

The `plotIndication()` function creates visualizations for indication analysis results, displaying the distribution of known and unknown indications across different time windows.

Sources: [R/plots.R:128-138](), [man/plotIndication.Rd:1-58]()

### Drug Utilisation Analysis Plots

The `plotDrugUtilisation()` function provides flexible visualization options for drug utilization metrics, supporting multiple plot types and variables.

```mermaid
graph TB
    subgraph "Plot Type Options"
        DUSUMM["summariseDrugUtilisation() result"]
        PTYPE["plotType parameter"]
        
        BAR["barplot"]
        SCATTER["scatterplot"] 
        DENSITY["densityplot"]
        BOX["boxplot"]
    end
    
    subgraph "Variable Selection"
        VNAME["variable parameter"]
        NEXPO["number exposures"]
        DEXPO["days exposed"]
        CUMUL["cumulative dose milligram"]
    end
    
    subgraph "Plot Generation"
        VBAR2["visOmopResults::barPlot()"]
        VSCAT["visOmopResults::scatterPlot()"]
        VBOX["visOmopResults::boxPlot()"]
        DUPLOT["Drug utilisation plot"]
    end
    
    DUSUMM --> PTYPE
    PTYPE --> BAR
    PTYPE --> SCATTER
    PTYPE --> DENSITY
    PTYPE --> BOX
    
    DUSUMM --> VNAME
    VNAME --> NEXPO
    VNAME --> DEXPO
    VNAME --> CUMUL
    
    BAR --> VBAR2
    SCATTER --> VSCAT
    DENSITY --> VSCAT
    BOX --> VBOX
    
    VBAR2 --> DUPLOT
    VSCAT --> DUPLOT
    VBOX --> DUPLOT
```

The function supports four distinct plot types, each with specific requirements:
- **Barplot/Scatterplot**: Requires single estimate, uses `visOmopResults::barPlot()` or `visOmopResults::scatterPlot()`
- **Densityplot**: Requires `density_x` and `density_y` estimates, uses line plotting
- **Boxplot**: Requires five-number summary estimates (`min`, `q25`, `median`, `q75`, `max`)

Sources: [R/plots.R:198-321]()

### Patient Coverage Over Time Plots

The `plotProportionOfPatientsCovered()` function creates line plots showing the proportion of patients covered over time, with optional confidence interval ribbons.

```mermaid
graph LR
    subgraph "Coverage Plot Components"
        PPSUMM["summariseProportionOfPatientsCovered() result"]
        PPPLOT["plotProportionOfPatientsCovered()"]
        
        LINE["ggplot2::geom_line()"]
        RIBBON["ggplot2::geom_ribbon()"]
        SCALE["scales::percent_format()"]
        
        COVPLOT["Coverage line plot"]
    end
    
    PPSUMM --> PPPLOT
    PPPLOT --> LINE
    PPPLOT --> RIBBON
    PPPLOT --> SCALE
    
    LINE --> COVPLOT
    RIBBON --> COVPLOT
    SCALE --> COVPLOT
    
    subgraph "Optional Features"
        RIBB["ribbon parameter"]
        CONF["Confidence intervals"]
    end
    
    RIBB --> RIBBON
    CONF --> RIBBON
```

This function includes specialized features:
- Time-based x-axis with days as the unit
- Y-axis formatted as percentages with 0.1% accuracy
- Optional confidence interval ribbons controlled by the `ribbon` parameter
- Automatic handling of proportion data conversion from percentages

Sources: [R/plots.R:358-446]()

## Internal Plotting Utilities

### Bar Plot Internal Function

The `barPlotInternal()` function provides shared functionality for treatment, indication, and drug restart plotting functions.

```mermaid
graph TB
    subgraph "Bar Plot Internal Flow"
        RESULT["summarised_result input"]
        VALIDATE["omopgenerics::validateResultArgument()"]
        FILTER["Filter by result_type and percentage"]
        
        PROCESS["Data Processing"]
        ORDER["Variable level ordering"]
        TIDY["omopgenerics::tidy()"]
        WINDOW["Window name factor ordering"]
        
        VBAR3["visOmopResults::barPlot()"]
        COORD["ggplot2::coord_flip()"]
        THEME["Theme and label customization"]
        
        BAROUT["Final bar plot"]
    end
    
    RESULT --> VALIDATE
    VALIDATE --> FILTER
    FILTER --> PROCESS
    
    PROCESS --> ORDER
    ORDER --> TIDY
    TIDY --> WINDOW
    
    WINDOW --> VBAR3
    VBAR3 --> COORD
    COORD --> THEME
    THEME --> BAROUT
```

The function handles common bar plot requirements:
- Result validation and filtering for percentage estimates
- Proper ordering of categorical variables with `rev()` for display
- Window name ordering based on numeric ranges
- Consistent theming with flipped coordinates and top legend positioning

Sources: [R/plots.R:465-531]()

### Helper Functions

The plotting system includes several utility functions:

| Function | Purpose | Usage |
|----------|---------|-------|
| `getVariables()` | Extract variable columns with multiple values | Used for determining plot variables |
| `asCharacterFacet()` | Parse facet formulas into character vectors | Facet handling in drug utilization plots |
| `correctX()` | Handle empty x variable lists | X-axis correction for visOmopResults |
| `uniteColumn()` | Combine multiple columns for grouping | Used in coverage plots for grouping |
| `emptyPlot()` | Create empty ggplot when no data | Fallback for empty results |

Sources: [R/plots.R:322-331](), [R/plots.R:448-463](), [R/plots.R:532-547]()

## Plot Customization Options

### Faceting Options

All plotting functions support flexible faceting through the `facet` parameter:

```mermaid
graph LR
    subgraph "Faceting Options"
        FORM["Formula syntax"]
        CHAR["Character vector"]
        NULL["NULL (no faceting)"]
    end
    
    subgraph "Formula Examples" 
        F1["cdm_name ~ cohort_name"]
        F2["cohort_name + sex ~ window_name"]
        F3[". ~ variable_level"]
    end
    
    subgraph "Character Examples"
        C1["cohort_name"]
        C2["c('sex', 'age_group')"]
    end
    
    FORM --> F1
    FORM --> F2
    FORM --> F3
    
    CHAR --> C1
    CHAR --> C2
```

Sources: [R/plots.R:423-443]()

### Color Mapping

The `colour` parameter controls aesthetic mapping across all plot functions, supporting both single variables and combinations:

- Single variable: `"cohort_name"`, `"sex"`, `"variable_level"`
- Multiple variables: `c("sex", "age_group")` (automatically combined with separator)
- Function-specific defaults optimize for each analysis type

Sources: [R/plots.R:388-394]()

## Integration with External Packages

### visOmopResults Integration

Most plotting functions leverage `visOmopResults` for standardized OMOP result visualization:

```mermaid
graph TB
    subgraph "visOmopResults Functions"
        VBAR4["visOmopResults::barPlot()"]
        VSCAT2["visOmopResults::scatterPlot()"]
        VBOX2["visOmopResults::boxPlot()"]
    end
    
    subgraph "DrugUtilisation Functions"
        PTRT2["plotTreatment()"]
        PIND2["plotIndication()"]
        PDR2["plotDrugRestart()"]
        PDU2["plotDrugUtilisation()"]
    end
    
    subgraph "Parameters Passed"
        XLABEL["x parameter"]
        YLABEL["y parameter"]
        FACETPARAM["facet parameter"]
        COLORPARAM["colour parameter"]
        LABELPARAM["label parameter"]
    end
    
    PTRT2 --> VBAR4
    PIND2 --> VBAR4
    PDR2 --> VBAR4
    PDU2 --> VBAR4
    PDU2 --> VSCAT2
    PDU2 --> VBOX2
    
    XLABEL --> VBAR4
    YLABEL --> VBAR4
    FACETPARAM --> VBAR4
    COLORPARAM --> VBAR4
    LABELPARAM --> VBAR4
```

The integration ensures consistent styling and behavior across the DARWIN EU ecosystem while allowing function-specific customizations.

Sources: [R/plots.R:203-204](), [R/plots.R:471-472]()