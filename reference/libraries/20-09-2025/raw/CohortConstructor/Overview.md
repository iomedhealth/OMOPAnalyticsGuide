# Page: Overview

# Overview

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [DESCRIPTION](DESCRIPTION)
- [NAMESPACE](NAMESPACE)
- [R/mockCohortConstructor.R](R/mockCohortConstructor.R)
- [R/reexports.R](R/reexports.R)
- [README.Rmd](README.Rmd)
- [README.md](README.md)
- [_pkgdown.yml](_pkgdown.yml)
- [man/CohortConstructor-package.Rd](man/CohortConstructor-package.Rd)
- [man/mockCohortConstructor.Rd](man/mockCohortConstructor.Rd)
- [man/reexports.Rd](man/reexports.Rd)
- [vignettes/a02_cohort_table_requirements.Rmd](vignettes/a02_cohort_table_requirements.Rmd)
- [vignettes/a10_match_cohorts.Rmd](vignettes/a10_match_cohorts.Rmd)

</details>



This document provides a comprehensive overview of the CohortConstructor R package, which enables the creation and manipulation of study cohorts using data mapped to the OMOP Common Data Model (CDM). CohortConstructor serves as a foundational tool in the OHDSI ecosystem for programmatically building research cohorts with full reproducibility and transparent attrition tracking.

For specific implementation details on building base cohorts, see [Core Cohort Building](#3). For information on applying filters and requirements, see [Applying Requirements and Filters](#5). For advanced cohort operations and manipulations, see [Cohort Manipulation Operations](#4).

## Purpose and Scope

CohortConstructor provides a systematic approach to cohort construction through four main capabilities:

- **Base Cohort Generation**: Creating initial cohorts from OMOP concept sets, demographics, measurements, and death records
- **Requirement Application**: Filtering cohorts based on demographic criteria, date ranges, and intersections with other data sources  
- **Cohort Manipulation**: Combining, splitting, sampling, and transforming existing cohorts
- **Metadata Management**: Comprehensive tracking of cohort settings, attrition, and provenance

The package operates exclusively on OMOP CDM-mapped data and integrates seamlessly with `CDMConnector`, `omopgenerics`, and `PatientProfiles` to provide a complete cohort construction workflow.

Sources: [DESCRIPTION:23-24](), [README.md:17-18](), [man/CohortConstructor-package.Rd:8-11]()

## System Architecture

**CohortConstructor Core Architecture**

```mermaid
graph TB
    subgraph "OMOP CDM Environment"
        CDM[("OMOP CDM Database")]
        CDMConn["CDMConnector"]
        OG["omopgenerics"]
        PP["PatientProfiles"]
    end
    
    subgraph "CohortConstructor Core"
        BaseGen["Base Cohort Generation"]
        ReqFilter["Requirement Filtering"]
        CohortManip["Cohort Manipulation"]
        DateOps["Date Operations"]
    end
    
    subgraph "Base Cohort Builders"
        conceptCohort["conceptCohort"]
        demographicsCohort["demographicsCohort"]
        measurementCohort["measurementCohort"]
        deathCohort["deathCohort"]
    end
    
    subgraph "Requirement Functions"
        requireDemographics["requireDemographics"]
        requireCohortIntersect["requireCohortIntersect"]
        requireConceptIntersect["requireConceptIntersect"]
        requireTableIntersect["requireTableIntersect"]
        requireInDateRange["requireInDateRange"]
    end
    
    subgraph "Manipulation Functions"
        unionCohorts["unionCohorts"]
        intersectCohorts["intersectCohorts"]
        collapseCohorts["collapseCohorts"]
        stratifyCohorts["stratifyCohorts"]
        sampleCohorts["sampleCohorts"]
        matchCohorts["matchCohorts"]
    end
    
    subgraph "Infrastructure"
        mockCohortConstructor["mockCohortConstructor"]
        benchmarkCohortConstructor["benchmarkCohortConstructor"]
        Validation["Validation System"]
    end
    
    CDM --> CDMConn
    CDMConn --> BaseGen
    OG --> BaseGen
    PP --> BaseGen
    
    BaseGen --> conceptCohort
    BaseGen --> demographicsCohort
    BaseGen --> measurementCohort
    BaseGen --> deathCohort
    
    ReqFilter --> requireDemographics
    ReqFilter --> requireCohortIntersect
    ReqFilter --> requireConceptIntersect
    ReqFilter --> requireTableIntersect
    ReqFilter --> requireInDateRange
    
    CohortManip --> unionCohorts
    CohortManip --> intersectCohorts
    CohortManip --> collapseCohorts
    CohortManip --> stratifyCohorts
    CohortManip --> sampleCohorts
    CohortManip --> matchCohorts
    
    conceptCohort --> ReqFilter
    demographicsCohort --> ReqFilter
    measurementCohort --> ReqFilter
    deathCohort --> ReqFilter
    
    ReqFilter --> CohortManip
    CohortManip --> DateOps
```

This architecture demonstrates the modular design where base cohort builders feed into requirement filters, which then connect to manipulation operations. The system maintains tight integration with the OMOP ecosystem through standardized interfaces.

Sources: [NAMESPACE:3-51](), [_pkgdown.yml:15-77](), [DESCRIPTION:37-42]()

## Core Workflow Pipeline

**Typical CohortConstructor Workflow**

```mermaid
flowchart LR
    subgraph "Input Data"
        OMOP[("OMOP CDM")]
        ConceptSets["Concept Sets"]
        Demographics["Demographics"]
        Measurements["Measurements"]
    end
    
    subgraph "Base Cohort Creation"
        conceptCohort_func["conceptCohort()"]
        demographicsCohort_func["demographicsCohort()"]
        measurementCohort_func["measurementCohort()"]
        deathCohort_func["deathCohort()"]
    end
    
    subgraph "Apply Requirements"
        requireDemographics_func["requireDemographics()"]
        requireInDateRange_func["requireInDateRange()"]
        requireCohortIntersect_func["requireCohortIntersect()"]
        requireConceptIntersect_func["requireConceptIntersect()"]
    end
    
    subgraph "Manipulate Cohorts"
        unionCohorts_func["unionCohorts()"]
        intersectCohorts_func["intersectCohorts()"]
        collapseCohorts_func["collapseCohorts()"]
        stratifyCohorts_func["stratifyCohorts()"]
    end
    
    subgraph "Output & Metadata"
        FinalCohorts["Study Cohorts"]
        AttritionData["Attrition Records"]
        SettingsData["Cohort Settings"]
        CohortCount["Cohort Counts"]
    end
    
    OMOP --> conceptCohort_func
    ConceptSets --> conceptCohort_func
    Demographics --> demographicsCohort_func
    Measurements --> measurementCohort_func
    
    conceptCohort_func --> requireDemographics_func
    demographicsCohort_func --> requireInDateRange_func
    measurementCohort_func --> requireCohortIntersect_func
    
    requireDemographics_func --> unionCohorts_func
    requireInDateRange_func --> intersectCohorts_func
    requireCohortIntersect_func --> collapseCohorts_func
    requireConceptIntersect_func --> stratifyCohorts_func
    
    unionCohorts_func --> FinalCohorts
    intersectCohorts_func --> FinalCohorts
    collapseCohorts_func --> FinalCohorts
    stratifyCohorts_func --> FinalCohorts
    
    FinalCohorts --> AttritionData
    FinalCohorts --> SettingsData
    FinalCohorts --> CohortCount
```

This pipeline shows the typical progression from raw OMOP data through base cohort creation, requirement application, manipulation operations, and final output with comprehensive metadata tracking.

Sources: [README.md:42-302](), [vignettes/a02_cohort_table_requirements.Rmd:44-209]()

## Function Organization by Category

**CohortConstructor Function Taxonomy**

```mermaid
graph TB
    subgraph "Base Cohort Builders"
        direction TB
        conceptCohort_node["conceptCohort"]
        demographicsCohort_node["demographicsCohort"]
        measurementCohort_node["measurementCohort"]
        deathCohort_node["deathCohort"]
    end
    
    subgraph "Singular Requirements"
        direction TB
        requireAge["requireAge"]
        requireSex["requireSex"]
        requirePriorObservation["requirePriorObservation"]
        requireFutureObservation["requireFutureObservation"]
    end
    
    subgraph "Multiple Requirements"
        direction TB
        requireDemographics_node["requireDemographics"]
    end
    
    subgraph "Intersection Requirements"
        direction TB
        requireCohortIntersect_node["requireCohortIntersect"]
        requireConceptIntersect_node["requireConceptIntersect"]
        requireTableIntersect_node["requireTableIntersect"]
    end
    
    subgraph "Cohort Table Requirements"
        direction TB
        requireMinCohortCount_node["requireMinCohortCount"]
        requireInDateRange_node["requireInDateRange"]
        requireIsFirstEntry_node["requireIsFirstEntry"]
        requireIsLastEntry_node["requireIsLastEntry"]
        requireIsEntry_node["requireIsEntry"]
    end
    
    subgraph "Date Operations"
        direction TB
        trimDemographics_node["trimDemographics"]
        exitAtDeath_node["exitAtDeath"]
        exitAtObservationEnd_node["exitAtObservationEnd"]
        entryAtFirstDate_node["entryAtFirstDate"]
        padCohortDate_node["padCohortDate"]
    end
    
    subgraph "Cohort Combinations"
        direction TB
        unionCohorts_node["unionCohorts"]
        intersectCohorts_node["intersectCohorts"]
    end
    
    subgraph "Cohort Transformations"
        direction TB
        collapseCohorts_node["collapseCohorts"]
        stratifyCohorts_node["stratifyCohorts"]
        yearCohorts_node["yearCohorts"]
        sampleCohorts_node["sampleCohorts"]
        subsetCohorts_node["subsetCohorts"]
        matchCohorts_node["matchCohorts"]
    end
    
    subgraph "Utility Functions"
        direction TB
        mockCohortConstructor_node["mockCohortConstructor"]
        benchmarkCohortConstructor_node["benchmarkCohortConstructor"]
        renameCohort_node["renameCohort"]
        addCohortTableIndex_node["addCohortTableIndex"]
    end
```

This taxonomy reflects the organization defined in the package documentation, grouping functions by their primary purpose and typical usage patterns in cohort construction workflows.

Sources: [_pkgdown.yml:15-77](), [NAMESPACE:3-51]()

## Integration with OMOP Ecosystem

**CohortConstructor Dependencies and Integration**

```mermaid
graph TB
    subgraph "External OMOP Ecosystem"
        CDMConnector_ext["CDMConnector"]
        CodelistGenerator_ext["CodelistGenerator"]
        CohortCharacteristics_ext["CohortCharacteristics"]
        IncidencePrevalence_ext["IncidencePrevalence"]
        DrugUtilisation_ext["DrugUtilisation"]
    end
    
    subgraph "Core Dependencies"
        omopgenerics_dep["omopgenerics"]
        PatientProfiles_dep["PatientProfiles"]
        dbplyr_dep["dbplyr"]
        dplyr_dep["dplyr"]
    end
    
    subgraph "CohortConstructor"
        direction TB
        CohortFunctions["Cohort Functions"]
        ReexportedFunctions["Re-exported Functions"]
        MockSystem["Mock System"]
    end
    
    subgraph "Re-exported from omopgenerics"
        direction TB
        cohortCount_reexp["cohortCount"]
        settings_reexp["settings"] 
        attrition_reexp["attrition"]
        cohortCodelist_reexp["cohortCodelist"]
        tableName_reexp["tableName"]
        bind_reexp["bind"]
    end
    
    subgraph "Re-exported from PatientProfiles"
        direction TB
        startDateColumn_reexp["startDateColumn"]
        endDateColumn_reexp["endDateColumn"]
    end
    
    CDMConnector_ext --> CohortFunctions
    omopgenerics_dep --> ReexportedFunctions
    PatientProfiles_dep --> ReexportedFunctions
    dbplyr_dep --> CohortFunctions
    dplyr_dep --> CohortFunctions
    
    ReexportedFunctions --> cohortCount_reexp
    ReexportedFunctions --> settings_reexp
    ReexportedFunctions --> attrition_reexp
    ReexportedFunctions --> cohortCodelist_reexp
    ReexportedFunctions --> tableName_reexp
    ReexportedFunctions --> bind_reexp
    ReexportedFunctions --> startDateColumn_reexp
    ReexportedFunctions --> endDateColumn_reexp
    
    CodelistGenerator_ext -.-> CohortFunctions
    CohortCharacteristics_ext -.-> CohortFunctions
    IncidencePrevalence_ext -.-> CohortFunctions
    DrugUtilisation_ext -.-> CohortFunctions
```

The package serves as a bridge between low-level OMOP data access (via `CDMConnector`) and higher-level analytical packages, providing standardized cohort objects that work seamlessly across the ecosystem.

Sources: [DESCRIPTION:29-42](), [DESCRIPTION:44-69](), [R/reexports.R:1-32](), [man/reexports.Rd:20-24]()

## Key Concepts and Data Structures

### Cohort Table Structure
CohortConstructor operates on cohort tables following the OMOP CDM cohort standard with four core columns:
- `subject_id`: Patient identifier linking to the person table
- `cohort_start_date`: Entry date into the cohort
- `cohort_end_date`: Exit date from the cohort  
- `cohort_definition_id`: Identifier for the specific cohort definition

### Metadata Tracking
Every cohort operation maintains comprehensive metadata through three key components:
- **Settings**: Cohort definitions, parameters, and configurations accessible via `settings()`
- **Attrition**: Step-by-step exclusion tracking accessible via `attrition()` 
- **Counts**: Summary statistics accessible via `cohortCount()`

### Mock Data System
The package includes a sophisticated mock data generation system via `mockCohortConstructor()` for testing and development, supporting configurable OMOP table generation with controlled vocabularies and patient populations.

### Validation Framework
Input validation occurs at multiple levels using the `checkmate` package for parameter validation and custom validation functions to ensure OMOP CDM compliance and data integrity throughout the workflow.

Sources: [R/mockCohortConstructor.R:1-112](), [man/mockCohortConstructor.Rd:1-67](), [DESCRIPTION:30]()