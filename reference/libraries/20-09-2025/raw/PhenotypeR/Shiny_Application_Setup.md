# Page: Shiny Application Setup

# Shiny Application Setup

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/shinyDiagnostics.R](R/shinyDiagnostics.R)
- [inst/shiny/global.R](inst/shiny/global.R)
- [man/shinyDiagnostics.Rd](man/shinyDiagnostics.Rd)
- [tests/testthat/test-shinyDiagnostics.R](tests/testthat/test-shinyDiagnostics.R)

</details>



This document covers the setup and configuration of the PhenotypeR Shiny application, including the main orchestrator function `shinyDiagnostics()`, directory structure creation, dependency management, and data preprocessing configuration. For detailed information about the user interface structure, see [User Interface Components](#3.2). For server-side logic and reactive programming, see [Server Logic and Data Processing](#3.3). For data transformation details, see [Data Preprocessing Pipeline](#3.4).

## Setup Workflow Overview

The Shiny application setup follows a structured workflow that transforms diagnostic results into a fully configured web application:

```mermaid
flowchart TD
    A["shinyDiagnostics()"] --> B["validateDirectory()"]
    B --> C["copyDirectory()"]
    C --> D["Export Results to CSV"]
    D --> E["Process Expectations Data"]
    E --> F["checkWhichDiagnostics()"]
    F --> G["removeLines()"]
    G --> H["Configure global.R"]
    H --> I["Launch Application"]
    
    subgraph "Input Data"
        J["Diagnostic Results"] --> A
        K["Expectations Data"] --> A
        L["Directory Path"] --> A
    end
    
    subgraph "Template Files"
        M["inst/shiny/global.R"] --> C
        N["inst/shiny/ui.R"] --> C
        O["inst/shiny/server.R"] --> C
        P["inst/shiny/scripts/"] --> C
    end
    
    subgraph "Output Structure"
        Q["PhenotypeRShiny/global.R"]
        R["PhenotypeRShiny/ui.R"]  
        S["PhenotypeRShiny/server.R"]
        T["PhenotypeRShiny/data/raw/result.csv"]
        U["PhenotypeRShiny/data/appData.RData"]
        I --> Q
        I --> R
        I --> S
        I --> T
        I --> U
    end
```

Sources: [R/shinyDiagnostics.R:43-123](), [inst/shiny/global.R:36-59]()

## Main Setup Function

The `shinyDiagnostics()` function serves as the primary entry point for creating and launching the diagnostic application. It accepts diagnostic results from any PhenotypeR analysis and transforms them into an interactive web application.

### Function Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `result` | `summarised_result` | Diagnostic results from PhenotypeR functions |
| `directory` | `character` | Target directory for app creation |
| `minCellCount` | `numeric` | Minimum cell count for result suppression (default: 5) |
| `open` | `logical` | Whether to launch app automatically |
| `expectations` | `data.frame` | Optional cohort expectations data |

### Version Compatibility Validation

The setup process includes version compatibility checks to ensure consistency between the results and the current PhenotypeR installation:

```mermaid
flowchart TD
    A["Check result structure"] --> B{"phenotyper_version in settings?"}
    B -->|No| C["cli_abort(): Old version error"]
    B -->|Yes| D["Extract version(s)"]
    D --> E{"Multiple versions?"}
    E -->|Yes| F["cli_warn(): Multiple versions"]
    E -->|No| G["Compare with current version"]
    G --> H{"Versions match?"}
    H -->|No| I["cli_warn(): Version mismatch"]
    H -->|Yes| J["Continue setup"]
    F --> J
    I --> J
```

Sources: [R/shinyDiagnostics.R:54-71]()

## Directory Structure and File Management

### Directory Validation and Creation

The `validateDirectory()` function handles directory creation and conflict resolution:

```mermaid
flowchart TD
    A["validateDirectory()"] --> B{"Directory exists?"}
    B -->|No| C["Create directory recursively"]
    B -->|Yes| D{"PhenotypeRShiny folder exists?"}
    D -->|No| E["Continue with setup"]
    D -->|Yes| F{"Interactive mode?"}
    F -->|No| G["Overwrite automatically"]
    F -->|Yes| H["Prompt user choice"]
    H --> I{"User choice?"}
    I -->|Overwrite| J["Delete existing folder"]
    I -->|Cancel| K["Return TRUE (abort)"]
    C --> E
    G --> J
    J --> E
    E --> L["Return directory path"]
    K --> M["Setup aborted"]
```

### File Copy Operations

The `copyDirectory()` function replicates the entire Shiny template structure:

```mermaid
graph TB
    subgraph "Source: inst/shiny/"
        A["global.R"]
        B["ui.R"] 
        C["server.R"]
        D["scripts/functions.R"]
        E["scripts/preprocess.R"]
    end
    
    subgraph "Target: directory/PhenotypeRShiny/"
        F["global.R"]
        G["ui.R"]
        H["server.R"] 
        I["scripts/functions.R"]
        J["scripts/preprocess.R"]
        K["data/raw/result.csv"]
        L["data/raw/expectations/expectations.csv"]
    end
    
    A --> F
    B --> G
    C --> H
    D --> I
    E --> J
```

Sources: [R/shinyDiagnostics.R:126-171](), [R/shinyDiagnostics.R:159-171]()

## Global Configuration and Dependencies

The `global.R` file establishes the runtime environment for the Shiny application through dependency management and utility function definitions.

### Dependency Management

The global configuration enforces minimum package versions and loads required libraries:

| Package | Minimum Version | Purpose |
|---------|----------------|---------|
| `omopgenerics` | 1.2.0 | Core OMOP data structures |
| `visOmopResults` | 1.0.0 | Result visualization |
| `shiny` | 1.11.1 | Web application framework |
| `CodelistGenerator` | 3.4.0 | Concept set management |
| `CohortCharacteristics` | 1.0.0 | Cohort analysis |
| `IncidencePrevalence` | 1.2.0 | Epidemiological calculations |

### Data Loading Pipeline

The global setup implements a conditional data loading strategy:

```mermaid
flowchart TD
    A["global.R execution"] --> B{"appData.RData exists?"}
    B -->|No| C["Execute preprocess.R"]
    B -->|Yes| D{"Interactive mode?"}
    D -->|Yes| E["preprocess_again()"]
    D -->|No| F["Load existing data"]
    E --> G{"User wants reprocessing?"}
    G -->|Yes| C
    G -->|No| F
    C --> H["Create appData.RData"]
    H --> F
    F --> I["Data available for app"]
```

Sources: [inst/shiny/global.R:1-59]()

## Data Export and Configuration

### Result Export Process

Diagnostic results are exported using `omopgenerics::exportSummarisedResult()` with configurable cell count suppression:

```mermaid
flowchart LR
    A["summarised_result object"] --> B["exportSummarisedResult()"]
    B --> C["Apply minCellCount suppression"]
    C --> D["result.csv"]
    D --> E["data/raw/ directory"]
    
    F["minCellCount parameter"] --> B
    G["fileName: result.csv"] --> B
    H["path: PhenotypeRShiny/data/raw"] --> B
```

### Expectations Data Handling

The setup process creates expectations data regardless of input:

```mermaid
flowchart TD
    A["Process expectations"] --> B{"expectations provided?"}
    B -->|Yes| C["Validate structure"]
    C --> D["Write expectations.csv"]
    B -->|No| E["Create empty tibble"]
    E --> F["Write empty expectations.csv"]
    D --> G["data/raw/expectations/"]
    F --> G
```

Sources: [R/shinyDiagnostics.R:87-108]()

## Dynamic UI Configuration

The setup process dynamically removes unused interface components based on available diagnostic types:

### Diagnostic Detection

```mermaid
flowchart TD
    A["checkWhichDiagnostics()"] --> B["Extract diagnostic types from settings"]
    B --> C["Define available diagnostics"]
    C --> D["Identify missing diagnostics"]
    D --> E["Check specific result types"]
    E --> F["Return removal list"]
    
    subgraph "Available Diagnostics"
        G["databaseDiagnostics"]
        H["codelistDiagnostics"] 
        I["cohortDiagnostics"]
        J["populationDiagnostics"]
    end
    
    subgraph "Conditional Components"
        K["achilles_results"]
        L["measurement_diagnostics"]
        M["cohort_survival"]
    end
```

### UI Modification Process

The `removeLines()` function modifies the UI template based on available diagnostics:

```mermaid
flowchart TD
    A["removeLines()"] --> B["For each diagnostic to remove"]
    B --> C["Find start marker in ui.R"]
    C --> D["Find end marker in ui.R"]
    D --> E["Remove lines between markers"]
    E --> F["Write modified ui.R"]
    F --> G["Log removal message"]
```

Sources: [R/shinyDiagnostics.R:173-215]()

## Launch Configuration

The setup concludes with optional application launch based on the `open` parameter:

```mermaid
flowchart TD
    A["Setup completion"] --> B{"open parameter?"}
    B -->|TRUE| C["Check usethis installed"]
    C --> D["usethis::proj_activate()"]
    D --> E["Launch in new session"]
    B -->|FALSE| F["Report directory location"]
    F --> G["Setup complete"]
    E --> G
```

The application can be launched manually by navigating to the created directory and running the Shiny application through standard R/RStudio methods.

Sources: [R/shinyDiagnostics.R:111-122]()