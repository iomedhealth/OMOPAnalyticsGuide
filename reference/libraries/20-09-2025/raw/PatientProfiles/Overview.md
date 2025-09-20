# Page: Overview

# Overview

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [DESCRIPTION](DESCRIPTION)
- [NAMESPACE](NAMESPACE)
- [NEWS.md](NEWS.md)
- [README.Rmd](README.Rmd)
- [README.md](README.md)
- [_pkgdown.yml](_pkgdown.yml)

</details>



This document provides a comprehensive overview of the PatientProfiles R package, its architecture, and core functionality for working with OMOP Common Data Model (CDM) data. PatientProfiles enables researchers to identify and add patient characteristics to OMOP CDM tables and perform complex data intersections for patient profiling and cohort analysis.

For specific implementation details about demographics functions, see [Patient Demographics](#2.1). For intersection system internals, see [Data Intersection System](#3.1). For summarization capabilities, see [Data Summarization](#3.2).

## Purpose and Scope

PatientProfiles is designed to identify characteristics of patients in data mapped to the Observational Medical Outcomes Partnership (OMOP) common data model. The package provides 57 exported functions that enable users to add demographic information, perform temporal intersections between different data sources, and summarize patient characteristics for research and analysis.

**Sources:** [DESCRIPTION:24](), [NAMESPACE:1-61](), [README.md:23-25]()

## System Architecture

The PatientProfiles package operates within the broader OMOP CDM ecosystem and follows a layered architecture with core processing engines, specialized function modules, and external integrations.

```mermaid
graph TB
    subgraph "External_Dependencies"
        OMOP_DB[("OMOP CDM Database")]
        CDMConnector["CDMConnector >= 1.3.1"]
        omopgenerics["omopgenerics >= 1.0.0"]
        tidyverse["Tidyverse Stack"]
    end
    
    subgraph "PatientProfiles_Core"
        subgraph "Public_API"
            exported_functions["57 Exported Functions"]
            query_functions["Query Functions"]
        end
        
        subgraph "Core_Processing"
            add_intersect[".addIntersect"]
            validation["Input Validation"]
            demographics_engine["Demographics Engine"]
        end
        
        subgraph "Specialized_Modules"
            cohort_intersect["addCohortIntersect*"]
            concept_intersect["addConceptIntersect*"]
            table_intersect["addTableIntersect*"]
            summarise_result["summariseResult"]
            add_categories["addCategories"]
        end
        
        subgraph "Testing_Infrastructure"
            mock_profiles["mockPatientProfiles"]
            benchmark_tools["benchmarkPatientProfiles"]
        end
    end
    
    OMOP_DB --> CDMConnector
    CDMConnector --> add_intersect
    omopgenerics --> validation
    tidyverse --> add_intersect
    
    exported_functions --> query_functions
    add_intersect --> cohort_intersect
    add_intersect --> concept_intersect  
    add_intersect --> table_intersect
    demographics_engine --> exported_functions
    validation --> add_intersect
    
    summarise_result --> exported_functions
    add_categories --> exported_functions
    mock_profiles --> exported_functions
    benchmark_tools --> exported_functions
```

**Sources:** [DESCRIPTION:53-62](), [NAMESPACE:3-53](), [_pkgdown.yml:16-80]()

## Core Function Categories

The package organizes its functionality into distinct categories, each serving specific aspects of patient profiling and data analysis within the OMOP CDM framework.

```mermaid
graph LR
    subgraph "Individual_Demographics"
        addAge["addAge"]
        addSex["addSex"]  
        addDateOfBirth["addDateOfBirth"]
        addDemographics["addDemographics"]
        addPriorObservation["addPriorObservation"]
        addFutureObservation["addFutureObservation"]
        addInObservation["addInObservation"]
    end
    
    subgraph "Death_Information"
        addDeathDate["addDeathDate"]
        addDeathDays["addDeathDays"]
        addDeathFlag["addDeathFlag"]
    end
    
    subgraph "Cohort_Intersections"
        addCohortIntersectCount["addCohortIntersectCount"]
        addCohortIntersectDate["addCohortIntersectDate"]
        addCohortIntersectDays["addCohortIntersectDays"]
        addCohortIntersectFlag["addCohortIntersectFlag"]
    end
    
    subgraph "Concept_Intersections"
        addConceptIntersectCount["addConceptIntersectCount"]
        addConceptIntersectDate["addConceptIntersectDate"]
        addConceptIntersectDays["addConceptIntersectDays"]
        addConceptIntersectFlag["addConceptIntersectFlag"]
        addConceptIntersectField["addConceptIntersectField"]
    end
    
    subgraph "Table_Intersections"
        addTableIntersectCount["addTableIntersectCount"]
        addTableIntersectDate["addTableIntersectDate"]
        addTableIntersectDays["addTableIntersectDays"]
        addTableIntersectFlag["addTableIntersectFlag"]
        addTableIntersectField["addTableIntersectField"]
    end
    
    subgraph "Analysis_Tools"
        summariseResult["summariseResult"]
        suppress["suppress"]
        addCategories["addCategories"]
        variableTypes["variableTypes"]
        availableEstimates["availableEstimates"]
    end
    
    subgraph "Utilities"
        mockPatientProfiles["mockPatientProfiles"]
        benchmarkPatientProfiles["benchmarkPatientProfiles"]
        addCohortName["addCohortName"]
        addConceptName["addConceptName"]
        addCdmName["addCdmName"]
        filterCohortId["filterCohortId"]
        filterInObservation["filterInObservation"]
    end
```

**Sources:** [NAMESPACE:3-53](), [_pkgdown.yml:18-80]()

## Data Processing Architecture

The package implements a unified data processing pipeline that handles validation, intersection logic, and result formatting across all function categories.

```mermaid
flowchart TD
    subgraph "Input_Layer"
        cdm_tables["CDM Tables"]
        cohort_tables["Cohort Tables"]
        concept_sets["Concept Sets"]
        parameters["Function Parameters"]
    end
    
    subgraph "Validation_Layer"
        checks_r["checks.R validation"]
        omop_validation["OMOP Standards Check"]
        parameter_validation["Parameter Validation"]
    end
    
    subgraph "Core_Engine"
        add_intersect_core[".addIntersect Core Logic"]
        demographics_core["Demographics Calculator"]
        temporal_windows["Temporal Window Logic"]
        sql_generation["SQL Query Generation"]
    end
    
    subgraph "Processing_Modules"
        cohort_processing["Cohort Intersection Processing"]
        concept_processing["Concept Intersection Processing"]
        table_processing["Table Intersection Processing"]
        demographic_processing["Demographic Processing"]
    end
    
    subgraph "Output_Layer"
        result_formatting["Result Formatting"]
        categorization["Data Categorization"]
        summarization["Statistical Summarization"]
        enhanced_tables["Enhanced CDM Tables"]
    end
    
    cdm_tables --> checks_r
    cohort_tables --> checks_r
    concept_sets --> omop_validation
    parameters --> parameter_validation
    
    checks_r --> add_intersect_core
    omop_validation --> add_intersect_core
    parameter_validation --> demographics_core
    
    add_intersect_core --> cohort_processing
    add_intersect_core --> concept_processing
    add_intersect_core --> table_processing
    demographics_core --> demographic_processing
    
    cohort_processing --> result_formatting
    concept_processing --> result_formatting
    table_processing --> result_formatting
    demographic_processing --> result_formatting
    
    result_formatting --> categorization
    categorization --> summarization
    summarization --> enhanced_tables
```

**Sources:** [README.md:42-95](), [_pkgdown.yml:35-47]()

## External Integration Points

PatientProfiles integrates with several external systems and packages to provide seamless OMOP CDM data analysis capabilities.

| Integration Point | Purpose | Key Functions |
|-------------------|---------|---------------|
| **CDMConnector >= 1.3.1** | Database connectivity and CDM reference management | `cdmFromCon()`, table references |
| **omopgenerics >= 1.0.0** | OMOP CDM standards and validation | `settings()`, `suppress()` |
| **DBI/dbplyr** | Database query translation and execution | SQL generation, lazy evaluation |
| **Tidyverse Stack** | Data manipulation and pipeline operations | `dplyr`, `tidyr`, `purrr`, `stringr` |
| **Database Backends** | Data storage (PostgreSQL, SQL Server, DuckDB) | Connection management |

**Sources:** [DESCRIPTION:53-62](), [README.md:51-95]()

## Query vs Compute Functions

The package provides both immediate computation and deferred query functions for performance optimization in large datasets.

```mermaid
graph LR
    subgraph "Compute_Functions"
        addAge_compute["addAge"]
        addSex_compute["addSex"]
        addDemographics_compute["addDemographics"]
        addCohortIntersect_compute["addCohortIntersect*"]
    end
    
    subgraph "Query_Functions"
        addAgeQuery["addAgeQuery"]
        addSexQuery["addSexQuery"] 
        addDemographicsQuery["addDemographicsQuery"]
        addPriorObservationQuery["addPriorObservationQuery"]
        addFutureObservationQuery["addFutureObservationQuery"]
        addInObservationQuery["addInObservationQuery"]
        addObservationPeriodIdQuery["addObservationPeriodIdQuery"]
        addDateOfBirthQuery["addDateOfBirthQuery"]
    end
    
    compute_result["Computed Table Result"]
    deferred_query["Deferred Query Object"]
    
    addAge_compute --> compute_result
    addSex_compute --> compute_result
    addDemographics_compute --> compute_result
    addCohortIntersect_compute --> compute_result
    
    addAgeQuery --> deferred_query
    addSexQuery --> deferred_query
    addDemographicsQuery --> deferred_query
    addPriorObservationQuery --> deferred_query
    addFutureObservationQuery --> deferred_query
    addInObservationQuery --> deferred_query
    addObservationPeriodIdQuery --> deferred_query
    addDateOfBirthQuery --> deferred_query
```

**Sources:** [NAMESPACE:4-34](), [_pkgdown.yml:47-50]()

## Package Distribution and Quality Assurance

The package follows modern R development practices with comprehensive testing, documentation, and distribution infrastructure.

| Component | Implementation | Purpose |
|-----------|---------------|---------|
| **Version Management** | Semantic versioning (1.4.2) | Release tracking |
| **Testing Framework** | `testthat >= 3.1.5` with parallel execution | Quality assurance |
| **Documentation** | `pkgdown` website, comprehensive vignettes | User guidance |
| **Distribution** | CRAN + GitHub releases | Package availability |
| **CI/CD Pipeline** | GitHub Actions with R-CMD-check | Automated quality control |
| **License** | Apache License >= 2 | Open source compliance |

**Sources:** [DESCRIPTION:1-71](), [README.md:4-11]()