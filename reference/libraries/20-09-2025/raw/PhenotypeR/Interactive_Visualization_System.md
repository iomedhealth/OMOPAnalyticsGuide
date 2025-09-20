# Page: Interactive Visualization System

# Interactive Visualization System

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/shinyDiagnostics.R](R/shinyDiagnostics.R)
- [inst/shiny/global.R](inst/shiny/global.R)
- [man/shinyDiagnostics.Rd](man/shinyDiagnostics.Rd)
- [tests/testthat/test-shinyDiagnostics.R](tests/testthat/test-shinyDiagnostics.R)

</details>



The Interactive Visualization System provides web-based exploration of phenotyping diagnostic results through a Shiny application framework. This system transforms raw diagnostic outputs into interactive dashboards with dynamic filtering, plotting capabilities, and downloadable reports.

For information about the diagnostic engines that generate the underlying data, see [Core Diagnostic System](#2). For deployment and hosting details, see [Deployment and Infrastructure](#5).

## System Architecture

The Interactive Visualization System operates as a self-contained Shiny application that processes diagnostic results and presents them through a web interface.

```mermaid
graph TB
    subgraph "Application Entry Point"
        A["shinyDiagnostics()"]
        B["Directory validation"]
        C["File copying from inst/shiny/"]
    end
    
    subgraph "Shiny Application Structure"
        D["global.R"]
        E["ui.R"] 
        F["server.R"]
        G["scripts/preprocess.R"]
        H["scripts/functions.R"]
    end
    
    subgraph "Data Pipeline"
        I["result.csv export"]
        J["expectations.csv export"]
        K["appData.RData generation"]
        L["Data filtering & transformation"]
    end
    
    subgraph "Runtime Components"
        M["Package validation"]
        N["Interactive tables"]
        O["Dynamic plots"] 
        P["Download handlers"]
    end
    
    A --> B
    B --> C
    C --> D
    C --> E
    C --> F
    C --> G
    C --> H
    
    A --> I
    A --> J
    I --> G
    J --> G
    G --> K
    K --> L
    
    D --> M
    E --> N
    F --> O
    F --> P
    
    style A fill:#e1f5fe,stroke:#01579b,stroke-width:3px
    style D fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
```

**Sources:** [R/shinyDiagnostics.R:1-224](), [inst/shiny/global.R:1-274]()

## Application Creation and Setup

The `shinyDiagnostics()` function serves as the primary interface for creating Shiny applications from diagnostic results. The function performs several key operations:

| Operation | Function | Description |
|-----------|----------|-------------|
| **Input Validation** | `omopgenerics::assertTable()` | Validates expectations table structure |
| **Version Checking** | Version compatibility checks | Ensures result compatibility with current PhenotypeR version |
| **Directory Management** | `validateDirectory()` | Creates target directory and handles overwrites |
| **File Operations** | `copyDirectory()` | Copies Shiny template files from `inst/shiny/` |
| **Data Export** | `omopgenerics::exportSummarisedResult()` | Exports diagnostic results as CSV |
| **UI Customization** | `removeLines()` | Removes tabs for unavailable diagnostics |

```mermaid
flowchart TD
    A["Input: result + directory"] --> B["validateDirectory()"]
    B --> C["copyDirectory() from inst/shiny/"]
    C --> D["exportSummarisedResult() to data/raw/result.csv"]
    D --> E["checkWhichDiagnostics()"]
    E --> F["removeLines() from ui.R"]
    F --> G["Export expectations to data/raw/expectations/"]
    G --> H["Launch or create app"]
    
    subgraph "Dynamic UI Generation"
        I["Database diagnostics tab"]
        J["Codelist diagnostics tab"] 
        K["Cohort diagnostics tab"]
        L["Population diagnostics tab"]
    end
    
    E --> I
    E --> J
    E --> K
    E --> L
```

**Sources:** [R/shinyDiagnostics.R:43-123](), [R/shinyDiagnostics.R:173-197]()

## Global Configuration and Dependencies

The `global.R` file establishes the application runtime environment with comprehensive package loading and utility functions.

### Package Dependencies

The system requires specific minimum versions of core packages:

```mermaid
graph LR
    subgraph "Core OMOP Packages"
        A["omopgenerics >= 1.2.0"]
        B["visOmopResults >= 1.0.0"] 
        C["CodelistGenerator >= 3.4.0"]
        D["CohortCharacteristics >= 1.0.0"]
    end
    
    subgraph "Analysis Packages"
        E["IncidencePrevalence >= 1.2.0"]
        F["OmopSketch >= 0.5.1"]
        G["CohortSurvival >= 1.0.2"]
    end
    
    subgraph "UI/Visualization"
        H["shiny >= 1.11.1"]
        I["DT, reactable, plotly"]
        J["ggplot2, gt"]
        K["bslib, shinyWidgets"]
    end
    
    A --> H
    B --> I
    C --> J
    D --> K
```

**Sources:** [inst/shiny/global.R:1-33]()

### Data Loading and Preprocessing

The global setup implements a sophisticated data loading mechanism:

```mermaid
flowchart TD
    A["Application startup"] --> B["Check appData.RData exists"]
    B -->|No| C["source preprocess.R"]
    B -->|Yes + interactive| D["preprocess_again()"]
    D -->|User confirms| C
    D -->|User declines| E["load appData.RData"]
    C --> F["Generate appData.RData"]
    F --> E
    E --> G["Application ready"]
```

**Sources:** [inst/shiny/global.R:36-59]()

## Visualization Utilities

The global environment includes specialized plotting functions for cohort analysis:

### Age Density Visualization

The `plotAgeDensity()` function creates population pyramids with optional interquartile range overlays:

- **Input Processing**: Filters age density data and applies sex-based transformations
- **Geometric Rendering**: Uses `geom_polygon()` for density visualization
- **Statistical Overlays**: Median and IQR lines with conditional display
- **Faceting**: Supports database and cohort-level grouping

### Large Scale Characteristics Comparison

The `plotComparedLsc()` function implements standardized mean difference (SMD) scatter plots:

- **Data Transformation**: Converts percentages and calculates SMDs
- **Interactive Elements**: Hover details with concept information  
- **Missing Data Handling**: Optional imputation of missing values
- **Reference Lines**: Diagonal reference line for comparison

**Sources:** [inst/shiny/global.R:61-133](), [inst/shiny/global.R:136-219]()

## Table Configuration System

The system provides standardized table formatting through `getColsForTbl()`:

| Feature | Implementation | Purpose |
|---------|----------------|---------|
| **Concept ID Linking** | ATHENA URL generation | Direct links to concept definitions |
| **Number Formatting** | `colFormat(separators = TRUE)` | Thousands separators for readability |
| **NA Handling** | Custom cell renderers | Consistent display of missing values |
| **Sorting** | `sortNALast = TRUE` | Predictable sort behavior |

**Sources:** [inst/shiny/global.R:221-249]()

## Validation Framework

The application implements multiple validation layers:

### Input Validation Functions

```mermaid
graph TB
    A["validateFilteredResult()"] --> B["Check nrow > 0"]
    C["validateExpectations()"] --> D["Check expectations data exists"]
    E["validateExpectationSections()"] --> F["Verify diagnostic types"]
    
    B -->|Fail| G["validate() with custom message"]
    D -->|Fail| G
    F -->|Fail| G
    
    subgraph "Supported Diagnostic Types"
        H["cohort_count"]
        I["cohort_characteristics"] 
        J["large_scale_characteristics"]
        K["compare_cohorts"]
        L["cohort_survival"]
    end
    
    E --> H
    E --> I
    E --> J
    E --> K
    E --> L
```

**Sources:** [inst/shiny/global.R:251-274]()

## Tab Management System

The application dynamically adjusts its interface based on available diagnostic results through the `checkWhichDiagnostics()` and `removeLines()` functions:

### Conditional Tab Display

| Diagnostic Type | Required Result Type | Fallback Action |
|----------------|---------------------|-----------------|
| **Codelist Diagnostics** | `achilles_code_use` | Remove achilles_results tab |
| **Measurement Diagnostics** | `measurement_timings` | Remove measurement_diagnostics tab |
| **Cohort Survival** | `survival_probability` | Remove cohort_survival tab |

**Sources:** [R/shinyDiagnostics.R:173-197](), [R/shinyDiagnostics.R:198-216]()