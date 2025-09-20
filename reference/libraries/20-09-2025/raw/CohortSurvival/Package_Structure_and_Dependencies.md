# Page: Package Structure and Dependencies

# Package Structure and Dependencies

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [DESCRIPTION](DESCRIPTION)
- [NAMESPACE](NAMESPACE)
- [NEWS.md](NEWS.md)
- [R/addCohortSurvival.R](R/addCohortSurvival.R)

</details>



This document provides a comprehensive overview of the CohortSurvival package architecture, dependency relationships, and internal organization. It covers the core package structure, import/export patterns, and dependency management strategy that enables the package to integrate seamlessly with the OMOP Common Data Model ecosystem.

For information about the testing framework and development workflows, see [Testing Framework](#7.1). For contribution guidelines and CI/CD processes, see [Contributing and CI/CD](#7.3).

## Package Overview and Architecture

CohortSurvival is structured as a specialized R package that bridges survival analysis methodology with the OMOP CDM ecosystem. The package follows standard R package conventions while implementing a layered architecture that separates data preparation, statistical analysis, and result formatting.

### Core Package Structure

```mermaid
graph TB
    subgraph "Package Root"
        DESC["DESCRIPTION<br/>Package Metadata"]
        NAMESPACE["NAMESPACE<br/>Export/Import Definitions"]
        NEWS["NEWS.md<br/>Version History"]
    end
    
    subgraph "R/ Directory - Core Functions"
        ACS["addCohortSurvival.R<br/>Data Preparation Layer"]
        ESE["estimateSingleEventSurvival.R<br/>Single Event Analysis"]
        ECR["estimateCompetingRiskSurvival.R<br/>Competing Risk Analysis"]
        ASR["asSurvivalResult.R<br/>Result Standardization"]
        PS["plotSurvival.R<br/>Visualization Engine"]
        TS["tableSurvival.R<br/>Table Generation"]
        RT["riskTable.R<br/>Risk Table Creation"]
        UTILS["utils.R<br/>Helper Functions"]
        MOCK["mockMGUS2cdm.R<br/>Test Data Generation"]
    end
    
    subgraph "Supporting Directories"
        TESTS["tests/<br/>Test Suite"]
        VIGN["vignettes/<br/>Documentation"]
        MAN["man/<br/>Function Documentation"]
    end
    
    DESC --> ACS
    NAMESPACE --> ACS
    ACS --> ESE
    ACS --> ECR
    ESE --> ASR
    ECR --> ASR
    ASR --> PS
    ASR --> TS
    ASR --> RT
    
    style ACS fill:#e3f2fd
    style ESE fill:#e8f5e8
    style ECR fill:#e8f5e8
    style ASR fill:#fff3e0
    style PS fill:#f3e5f5
    style TS fill:#f3e5f5
    style RT fill:#f3e5f5
```

**Sources:** [DESCRIPTION:1-66](), [NAMESPACE:1-43](), [R/addCohortSurvival.R:1-262]()

## Dependency Architecture

The package implements a strategic dependency management approach with clear separation between core requirements and optional extensions.

### Import Dependencies

```mermaid
graph LR
    subgraph "Core OMOP Dependencies"
        OMOPG["omopgenerics<br/>≥ 1.1.0"]
        CDMC["CDMConnector<br/>≥ 2.0.0"] 
        PP["PatientProfiles<br/>≥ 1.3.1"]
    end
    
    subgraph "Statistical Dependencies"
        SURV["survival<br/>≥ 3.7.0"]
        BROOM["broom<br/>Model Tidying"]
        STATS["stats<br/>Base Statistics"]
    end
    
    subgraph "Data Manipulation"
        DPLYR["dplyr<br/>Data Transformation"]
        TIDYR["tidyr<br/>Data Reshaping"]
        PURRR["purrr<br/>Functional Programming"]
        TIBBLE["tibble<br/>Modern Data Frames"]
        STRINGR["stringr<br/>String Operations"]
    end
    
    subgraph "Infrastructure"
        CHECKMATE["checkmate<br/>Input Validation"]
        CLI["cli<br/>User Interface"]
        CLOCK["clock<br/>Date/Time Operations"]
        DBI["DBI<br/>Database Interface"]
        GLUE["glue<br/>String Interpolation"]
        MAGRITTR["magrittr<br/>Pipe Operator"]
        RLANG["rlang<br/>≥ 0.4.11"]
    end
    
    subgraph "CohortSurvival Functions"
        CS_CORE["Core Analysis Functions<br/>estimateSingleEventSurvival<br/>estimateCompetingRiskSurvival"]
        CS_PREP["Data Preparation<br/>addCohortSurvival"]
        CS_OUTPUT["Output Generation<br/>plotSurvival<br/>tableSurvival<br/>riskTable"]
    end
    
    OMOPG --> CS_CORE
    OMOPG --> CS_PREP
    OMOPG --> CS_OUTPUT
    CDMC --> CS_PREP
    PP --> CS_PREP
    SURV --> CS_CORE
    BROOM --> CS_CORE
    DPLYR --> CS_PREP
    DPLYR --> CS_CORE
    TIDYR --> CS_OUTPUT
    PURRR --> CS_CORE
    CHECKMATE --> CS_PREP
    CLI --> CS_CORE
    RLANG --> CS_CORE
```

**Sources:** [DESCRIPTION:28-46]()

### Suggested Dependencies

| Category | Package | Version | Purpose |
|----------|---------|---------|---------|
| Testing | `testthat` | ≥ 3.0.0 | Unit testing framework |
| Documentation | `roxygen2` | - | Function documentation |
| Documentation | `knitr` | - | Vignette generation |
| Documentation | `rmarkdown` | - | R Markdown support |
| Visualization | `ggplot2` | - | Advanced plotting |
| Visualization | `patchwork` | - | Plot composition |
| Visualization | `scales` | - | Plot scaling |
| Visualization | `visOmopResults` | ≥ 1.0.0 | OMOP-specific visualization |
| Statistical | `cmprsk` | - | Competing risk analysis |
| Cohort Definition | `CodelistGenerator` | - | Cohort creation utilities |
| Database | `duckdb` | - | Local database testing |
| Table Formatting | `gt` | - | Table generation |
| Table Formatting | `flextable` | - | Flexible table formatting |
| Performance | `tictoc` | - | Performance measurement |

**Sources:** [DESCRIPTION:47-61]()

## Export/Import Pattern Analysis

The package follows a structured export/import pattern that reveals its integration strategy with the OMOP ecosystem.

### Function Exports

```mermaid
graph TB
    subgraph "Core Analysis Exports"
        ESE_EXP["estimateSingleEventSurvival"]
        ECR_EXP["estimateCompetingRiskSurvival"]
        ACS_EXP["addCohortSurvival"]
        ASR_EXP["asSurvivalResult"]
    end
    
    subgraph "Visualization Exports" 
        PS_EXP["plotSurvival"]
        TS_EXP["tableSurvival"]
        RT_EXP["riskTable"]
        OTS_EXP["optionsTableSurvival"]
    end
    
    subgraph "Utility Exports"
        MOCK_EXP["mockMGUS2cdm"]
    end
    
    subgraph "Re-exported from omopgenerics"
        ATTR_EXP["attrition"]
        BIND_EXP["bind"]
        CC_EXP["cohortCodelist"]
        CCNT_EXP["cohortCount"]
        ESR_EXP["exportSummarisedResult"]
        ISR_EXP["importSummarisedResult"]
        SET_EXP["settings"]
        SUPP_EXP["suppress"]
    end
    
    subgraph "Re-exported from rlang"
        ASSIGN_EXP[":="]
        DATA_EXP[".data"]
        LABEL_EXP["as_label"]
        NAME_EXP["as_name"]
        ENQUO_EXP["enquo"]
        ENQUOS_EXP["enquos"]
    end
    
    subgraph "Re-exported from magrittr"
        PIPE_EXP["%>%"]
    end
    
    style ESE_EXP fill:#e8f5e8
    style ECR_EXP fill:#e8f5e8
    style ACS_EXP fill:#e3f2fd
    style ASR_EXP fill:#fff3e0
    style PS_EXP fill:#f3e5f5
    style TS_EXP fill:#f3e5f5
    style RT_EXP fill:#f3e5f5
```

**Sources:** [NAMESPACE:3-26]()

### Import Strategy

The package imports selectively from key dependencies:

```mermaid
graph LR
    subgraph "omopgenerics Imports"
        OG_ATTR["attrition"]
        OG_BIND["bind"] 
        OG_CC["cohortCodelist"]
        OG_CCNT["cohortCount"]
        OG_ESR["exportSummarisedResult"]
        OG_ISR["importSummarisedResult"]
        OG_SET["settings"]
        OG_SUPP["suppress"]
    end
    
    subgraph "rlang Imports"
        RL_ASSIGN[":="]
        RL_DATA[".data"]
        RL_ENV[".env"]
        RL_LABEL["as_label"]
        RL_NAME["as_name"]
        RL_ENQUO["enquo"]
        RL_ENQUOS["enquos"]
    end
    
    subgraph "magrittr Imports"
        MG_PIPE["%>%"]
    end
    
    subgraph "Internal Usage"
        INTERNAL["Function Implementations<br/>Input Validation<br/>Data Processing"]
    end
    
    OG_ATTR --> INTERNAL
    OG_BIND --> INTERNAL
    OG_ESR --> INTERNAL
    OG_ISR --> INTERNAL
    RL_DATA --> INTERNAL
    RL_ENV --> INTERNAL
    MG_PIPE --> INTERNAL
```

**Sources:** [NAMESPACE:27-42]()

## Version Management and Constraints

The package implements strict version constraints for critical dependencies:

### Critical Version Dependencies

| Package | Minimum Version | Rationale |
|---------|----------------|-----------|
| `omopgenerics` | ≥ 1.1.0 | Required for updated object structures and validation |
| `CDMConnector` | ≥ 2.0.0 | Major version with breaking changes in CDM interface |
| `PatientProfiles` | ≥ 1.3.1 | Specific functions for patient-level data operations |
| `survival` | ≥ 3.7.0 | Established statistical methods and stability |
| `rlang` | ≥ 0.4.11 | Tidy evaluation support |
| `visOmopResults` | ≥ 1.0.0 | Stable visualization interface |

**Sources:** [DESCRIPTION:28-61]()

## Data Preparation Layer Architecture

The `addCohortSurvival` function represents the core data preparation layer, implementing a sophisticated censoring and time calculation system.

### Data Flow in addCohortSurvival

```mermaid
flowchart TD
    INPUT["Input Cohort Table<br/>x"]
    CDM["CDM Reference<br/>cdm"]
    OUTCOME["Outcome Cohort Table<br/>outcomeCohortTable"]
    
    VALIDATE["validateExtractSurvivalInputs<br/>Input Validation"]
    
    PREP["Data Preparation"]
    ADD_OBS["PatientProfiles::addFutureObservation<br/>Calculate days_to_exit"]
    ADD_WASHOUT["Handle Washout Period<br/>event_in_washout calculation"]
    ADD_INTERSECT["PatientProfiles::addCohortIntersectDays<br/>Calculate days_to_event"]
    
    CENSOR_LOGIC["Censoring Logic"]
    CENSOR_EXIT["Censor on Cohort Exit<br/>censorOnCohortExit"]
    CENSOR_DATE["Censor on Date<br/>censorOnDate"]
    CENSOR_FOLLOWUP["Censor on Follow-up<br/>followUpDays"]
    
    FINAL["Final Status/Time Calculation"]
    STATUS["status = 1 if event, 0 if censored"]
    TIME["time = days to event or censoring"]
    
    OUTPUT["Enhanced Cohort Table<br/>with time and status columns"]
    
    INPUT --> VALIDATE
    CDM --> VALIDATE
    OUTCOME --> VALIDATE
    
    VALIDATE --> PREP
    PREP --> ADD_OBS
    ADD_OBS --> ADD_WASHOUT
    ADD_WASHOUT --> ADD_INTERSECT
    
    ADD_INTERSECT --> CENSOR_LOGIC
    CENSOR_LOGIC --> CENSOR_EXIT
    CENSOR_LOGIC --> CENSOR_DATE
    CENSOR_LOGIC --> CENSOR_FOLLOWUP
    
    CENSOR_EXIT --> FINAL
    CENSOR_DATE --> FINAL
    CENSOR_FOLLOWUP --> FINAL
    
    FINAL --> STATUS
    FINAL --> TIME
    STATUS --> OUTPUT
    TIME --> OUTPUT
```

**Sources:** [R/addCohortSurvival.R:51-219]()

## Package Configuration and Metadata

The package includes several configuration elements that support its integration with the R ecosystem:

### Build Configuration

- **Roxygen Version**: 7.3.2 with markdown support enabled
- **Test Configuration**: testthat edition 3 with parallel testing enabled
- **Vignette Builder**: knitr for documentation generation
- **Encoding**: UTF-8 for international character support

### Licensing and Distribution

- **License**: Apache License (≥ 2) for permissive open-source distribution
- **URL**: Documentation hosted at https://darwin-eu-dev.github.io/CohortSurvival/
- **CRAN Configuration**: Optimized for CRAN submission with proper metadata

**Sources:** [DESCRIPTION:24-66]()

## Integration Points with OMOP Ecosystem

The package's architecture reveals strategic integration points with the broader OMOP ecosystem:

### Key Integration Patterns

1. **Data Model Compliance**: Direct integration with `CDMConnector` for database operations
2. **Object Standardization**: Heavy reliance on `omopgenerics` for consistent object structures
3. **Patient-Level Operations**: Integration with `PatientProfiles` for cohort-level calculations
4. **Result Standardization**: Use of `omopgenerics` export/import functions for data persistence
5. **Visualization Consistency**: Optional integration with `visOmopResults` for standardized plotting

This architectural approach ensures that CohortSurvival functions seamlessly within existing OMOP analytical workflows while providing specialized survival analysis capabilities.

**Sources:** [DESCRIPTION:28-61](), [NAMESPACE:27-42]()