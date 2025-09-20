# Page: Overview

# Overview

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [DESCRIPTION](DESCRIPTION)
- [README.Rmd](README.Rmd)
- [README.md](README.md)
- [man/CohortSurvival-package.Rd](man/CohortSurvival-package.Rd)

</details>



## Purpose and Scope

This document provides a comprehensive overview of the CohortSurvival package, an R package designed for performing survival analysis on data structured according to the Observational Medical Outcomes Partnership (OMOP) Common Data Model (CDM). The package enables researchers to estimate survival probabilities, generate survival curves, and perform competing risk analyses using standardized cohort data.

For detailed installation instructions, see [Installation and Setup](#1.1). For step-by-step tutorials on performing specific analyses, see [User Guides and Examples](#5). For complete function documentation, see [API Reference](#6).

**Sources**: [DESCRIPTION:1-66](), [README.Rmd:17-22](), [man/CohortSurvival-package.Rd:7-11]()

## Core Functionality Overview

CohortSurvival provides a comprehensive suite of functions for survival analysis within the OMOP CDM ecosystem. The package transforms cohort data into survival estimates and visualizations through a structured pipeline.

### Main Analysis Functions

```mermaid
graph TB
    subgraph "Primary Analysis Functions"
        ESE["estimateSingleEventSurvival()"]
        ECR["estimateCompetingRiskSurvival()"]
    end
    
    subgraph "Data Preparation"
        ACS["addCohortSurvival()"]
    end
    
    subgraph "Output Functions"
        PS["plotSurvival()"]
        TS["tableSurvival()"]
        RT["riskTable()"]
    end
    
    subgraph "Result Processing"
        ASR["asSurvivalResult()"]
    end
    
    ACS --> ESE
    ACS --> ECR
    ESE --> ASR
    ECR --> ASR
    ASR --> PS
    ASR --> TS
    ASR --> RT
```

**Sources**: [README.Rmd:75-79](), [README.Rmd:110-115](), [README.Rmd:86-87]()

### Key Capabilities

| Function Category | Primary Functions | Purpose |
|-------------------|-------------------|---------|
| **Single Event Analysis** | `estimateSingleEventSurvival()` | Kaplan-Meier survival estimation for single outcomes |
| **Competing Risk Analysis** | `estimateCompetingRiskSurvival()` | Aalen-Johansen estimation for competing events |
| **Data Preparation** | `addCohortSurvival()` | Calculate time-to-event and censoring status |
| **Visualization** | `plotSurvival()` | Generate survival curves with confidence intervals |
| **Tabulation** | `tableSurvival()`, `riskTable()` | Summary statistics and risk tables |
| **Result Standardization** | `asSurvivalResult()` | Format results according to omopgenerics standards |

**Sources**: [README.Rmd:75-104](), [README.Rmd:110-136]()

## OMOP CDM Integration Architecture

CohortSurvival operates within the broader OMOP ecosystem, leveraging standardized data structures and interfaces for seamless integration with other OMOP tools.

### OMOP Ecosystem Dependencies

```mermaid
graph LR
    subgraph "OMOP Infrastructure"
        CDM["OMOP CDM Database"]
        CDMC["CDMConnector"]
        OMOPG["omopgenerics"]
        PP["PatientProfiles"]
    end
    
    subgraph "CohortSurvival Core"
        CS["CohortSurvival Functions"]
    end
    
    subgraph "Statistical Backend"
        SURV["survival package"]
        CMPRSK["cmprsk package"]
    end
    
    subgraph "Cohort Tables"
        TC["Target Cohort Table"]
        OC["Outcome Cohort Table"]
        CC["Competing Outcome Table"]
    end
    
    CDM --> CDMC
    CDMC --> TC
    CDMC --> OC  
    CDMC --> CC
    TC --> CS
    OC --> CS
    CC --> CS
    OMOPG --> CS
    PP --> CS
    SURV --> CS
    CMPRSK --> CS
```

**Sources**: [DESCRIPTION:28-46](), [README.Rmd:35-45]()

### Required Cohort Structure

The package expects cohort tables following OMOP CDM standards with specific columns:

| Table Type | Required Columns | Purpose |
|------------|------------------|---------|
| **Target Cohort** | `cohort_definition_id`, `subject_id`, `cohort_start_date`, `cohort_end_date` | Defines the study population |
| **Outcome Cohort** | `cohort_definition_id`, `subject_id`, `cohort_start_date`, `cohort_end_date` | Defines events of interest |
| **Competing Outcome** | `cohort_definition_id`, `subject_id`, `cohort_start_date`, `cohort_end_date` | Defines competing events (optional) |

**Sources**: [README.Rmd:48-69]()

## Package Architecture and Data Flow

### Core Data Processing Pipeline

```mermaid
flowchart TD
    A["CDM Reference Object"] --> B["Target Cohort"]
    A --> C["Outcome Cohort"]
    A --> D["Competing Outcome Cohort"]
    
    B --> E["addCohortSurvival()"]
    C --> E
    D --> F["estimateCompetingRiskSurvival()"]
    E --> G["estimateSingleEventSurvival()"]
    E --> F
    
    G --> H["summarised_result Object"]
    F --> H
    
    H --> I["asSurvivalResult()"]
    I --> J["survival_result Object"]
    
    J --> K["plotSurvival()"]
    J --> L["tableSurvival()"]
    J --> M["riskTable()"]
    
    K --> N["ggplot2 Visualizations"]
    L --> O["Summary Tables"]
    M --> P["Numbers at Risk Tables"]
```

**Sources**: [README.Rmd:75-104](), [README.Rmd:110-136]()

### Technical Dependencies

The package builds on established R packages for different functionality layers:

```mermaid
graph TB
    subgraph "Core Dependencies"
        A["CDMConnector >= 2.0.0"]
        B["omopgenerics >= 1.1.0"]
        C["PatientProfiles >= 1.3.1"]
        D["survival >= 3.7.0"]
    end
    
    subgraph "Data Manipulation"
        E["dplyr"]
        F["tidyr"]
        G["purrr"]
    end
    
    subgraph "Suggested Extensions"
        H["visOmopResults >= 1.0.0"]
        I["ggplot2"]
        J["cmprsk"]
    end
    
    subgraph "CohortSurvival Layer"
        K["Analysis Functions"]
        L["Visualization Functions"]
        M["Utility Functions"]
    end
    
    A --> K
    B --> K
    C --> K
    D --> K
    E --> K
    F --> K
    G --> K
    
    H --> L
    I --> L
    J --> K
```

**Sources**: [DESCRIPTION:28-61]()

## Key Analysis Types

### Single Event Survival Analysis

Uses the `estimateSingleEventSurvival()` function to perform Kaplan-Meier survival analysis for scenarios where participants can experience at most one event of interest.

**Typical Use Case**: Time from diagnosis to death, where death is the single event of interest.

**Key Parameters**:
- `targetCohortTable`: Name of the target cohort table
- `outcomeCohortTable`: Name of the outcome cohort table  
- `strata`: List of stratification variables
- `followUpDays`: Maximum follow-up time

**Sources**: [README.Rmd:75-104]()

### Competing Risk Survival Analysis  

Uses the `estimateCompetingRiskSurvival()` function to perform Aalen-Johansen estimation for scenarios where multiple competing events can occur.

**Typical Use Case**: Time from diagnosis to disease progression, where death acts as a competing risk.

**Key Parameters**:
- `targetCohortTable`: Name of the target cohort table
- `outcomeCohortTable`: Name of the primary outcome cohort table
- `competingOutcomeCohortTable`: Name of the competing outcome cohort table
- `strata`: List of stratification variables

**Sources**: [README.Rmd:110-136]()

## Output and Visualization Capabilities

### Standardized Result Objects

All survival analysis functions return `summarised_result` objects that conform to omopgenerics standards, enabling interoperability with other OMOP packages.

```mermaid
graph LR
    subgraph "Analysis Results"
        SR["summarised_result"]
    end
    
    subgraph "Formatted Results"
        SVR["survival_result"]
    end
    
    subgraph "Output Types"
        P["Survival Plots"]
        T["Summary Tables"]  
        R["Risk Tables"]
        E["Export Files"]
    end
    
    SR --> SVR
    SVR --> P
    SVR --> T
    SVR --> R
    SVR --> E
```

### Visualization Features

The `plotSurvival()` function provides flexible visualization options:

- **Survival Curves**: Kaplan-Meier or cumulative incidence curves
- **Confidence Intervals**: Automatic calculation and display
- **Stratification**: Support for multiple grouping variables
- **Faceting**: Multi-panel plots for complex comparisons
- **Customization**: Color schemes, themes, and annotations

**Sources**: [README.Rmd:86-104](), [README.Rmd:131-136]()

### Export and Persistence

Results can be exported using standard omopgenerics functions:
- `exportSummarisedResult()`: Save results to CSV files
- `importSummarisedResult()`: Reload previously saved results

This enables reproducible research workflows and result sharing across teams.

**Sources**: Based on omopgenerics integration patterns referenced in [DESCRIPTION:38]()