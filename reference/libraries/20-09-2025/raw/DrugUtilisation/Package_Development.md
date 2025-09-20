# Page: Package Development

# Package Development

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [NAMESPACE](NAMESPACE)
- [R/mockDrugUtilisation.R](R/mockDrugUtilisation.R)
- [man/mockDrugUtilisation.Rd](man/mockDrugUtilisation.Rd)
- [man/plotProportionOfPatientsCovered.Rd](man/plotProportionOfPatientsCovered.Rd)
- [man/reexports.Rd](man/reexports.Rd)
- [tests/testthat/setup.R](tests/testthat/setup.R)

</details>



This document covers the internal structure, development tools, testing framework, and contribution guidelines for the DrugUtilisation R package. It provides technical details for package maintainers and contributors who need to understand the codebase architecture, dependency management, and development workflows.

For information about using the package's exported functions, see [Function Exports and API](#9.1). For details about the testing framework and mock data systems, see [Testing and Mock Data](#9.2). For documentation generation and CI/CD processes, see [Documentation and CI/CD](#9.3).

## Package Architecture Overview

The DrugUtilisation package follows standard R package conventions with additional integration into the DARWIN EU ecosystem. The package is structured around a clear separation between exported public functions and internal development utilities.

### Package File Structure

```mermaid
graph TB
    subgraph "Core Package Files"
        NAMESPACE["NAMESPACE<br/>Export declarations"]
        DESCRIPTION["DESCRIPTION<br/>Package metadata"]
    end
    
    subgraph "R/ Source Code"
        MOCK["mockDrugUtilisation.R<br/>Mock data generation"]
        REEXPORTS["reexports.R<br/>Function re-exports"]
        CORE_R["Other R files<br/>Core functionality"]
    end
    
    subgraph "man/ Documentation"
        MOCK_RD["mockDrugUtilisation.Rd"]
        REEXPORTS_RD["reexports.Rd"]
        OTHER_RD["Other .Rd files"]
    end
    
    subgraph "tests/ Testing Infrastructure"
        SETUP["testthat/setup.R<br/>Test configuration"]
        TEST_FILES["testthat/test-*.R<br/>Unit tests"]
    end
    
    subgraph "Development Tools"
        ROXYGEN["roxygen2 comments<br/>Documentation generation"]
        PKGDOWN["pkgdown configuration<br/>Website generation"]
    end
    
    NAMESPACE --> MOCK
    NAMESPACE --> REEXPORTS
    MOCK --> MOCK_RD
    REEXPORTS --> REEXPORTS_RD
    SETUP --> TEST_FILES
    ROXYGEN --> MOCK_RD
    ROXYGEN --> REEXPORTS_RD
```

Sources: [NAMESPACE:1-79](), [R/mockDrugUtilisation.R:1-573](), [man/mockDrugUtilisation.Rd:1-45](), [man/reexports.Rd:1-32](), [tests/testthat/setup.R:1-45]()

## Development Ecosystem Integration

The package integrates deeply with the DARWIN EU ecosystem and external R package dependencies. The dependency structure is designed to leverage existing OMOP CDM tools while providing specialized drug utilization functionality.

### Dependency Architecture

```mermaid
graph TB
    subgraph "DrugUtilisation Package"
        DU_CORE["Core Functions"]
        DU_MOCK["mockDrugUtilisation"]
        DU_NAMESPACE["NAMESPACE exports"]
    end
    
    subgraph "DARWIN EU Dependencies"
        OMOP_GEN["omopgenerics<br/>Core OMOP operations"]
        CDM_CONN["CDMConnector<br/>Database interface"]
        PAT_PROF["PatientProfiles<br/>Patient operations"]
        CODE_GEN["CodelistGenerator<br/>Concept sets"]
    end
    
    subgraph "Data Manipulation"
        DPLYR["dplyr<br/>Data transformation"]
        PURRR["purrr<br/>Functional programming"]
        RLANG["rlang<br/>Language tools"]
        TIDYR["tidyr<br/>Data reshaping"]
    end
    
    subgraph "Database Backends"
        DUCKDB["duckdb<br/>In-memory database"]
        DBI["DBI<br/>Database interface"]
        POSTGRES["RPostgres<br/>PostgreSQL driver"]
    end
    
    subgraph "Testing Infrastructure"
        TESTTHAT["testthat<br/>Unit testing"]
        CLOCK["clock<br/>Date handling"]
    end
    
    DU_CORE --> OMOP_GEN
    DU_CORE --> CDM_CONN
    DU_CORE --> PAT_PROF
    DU_MOCK --> DUCKDB
    DU_MOCK --> DPLYR
    DU_MOCK --> CLOCK
    
    OMOP_GEN --> DBI
    CDM_CONN --> DBI
    CDM_CONN --> DUCKDB
    CDM_CONN --> POSTGRES
    
    DU_NAMESPACE --> OMOP_GEN
    DU_NAMESPACE --> PAT_PROF
```

Sources: [NAMESPACE:60-78](), [R/mockDrugUtilisation.R:41-160]()

## Export System and Function Organization

The package uses roxygen2 for automatic generation of the `NAMESPACE` file, which defines 58 exported functions organized into functional categories. The export system follows a clear pattern based on function purpose and user workflow.

### Function Export Categories

```mermaid
graph LR
    subgraph "Generation Functions"
        GEN1["generateDrugUtilisationCohortSet"]
        GEN2["generateIngredientCohortSet"] 
        GEN3["generateAtcCohortSet"]
    end
    
    subgraph "Requirement Functions"
        REQ1["requirePriorDrugWashout"]
        REQ2["requireIsFirstDrugEntry"]
        REQ3["requireObservationBeforeDrug"]
        REQ4["requireDrugInDateRange"]
    end
    
    subgraph "Add Functions"
        ADD1["addDrugUtilisation"]
        ADD2["addIndication"]
        ADD3["addDrugRestart"]
        ADD4["addTreatment"]
        ADD5["addDaysExposed"]
        ADD6["addInitialDailyDose"]
    end
    
    subgraph "Summarise Functions"
        SUM1["summariseDrugUtilisation"]
        SUM2["summariseIndication"]
        SUM3["summariseDrugRestart"]
        SUM4["summariseTreatment"]
        SUM5["summariseDoseCoverage"]
    end
    
    subgraph "Output Functions"
        OUT1["tableDrugUtilisation"]
        OUT2["plotDrugUtilisation"]
        OUT3["tableIndication"]
        OUT4["plotIndication"]
    end
    
    subgraph "Re-exported Functions"
        REEXP1["cohortCount"]
        REEXP2["settings"]
        REEXP3["bind"]
        REEXP4["suppress"]
    end
    
    GEN1 --> REQ1
    REQ1 --> ADD1
    ADD1 --> SUM1
    SUM1 --> OUT1
    SUM1 --> OUT2
```

Sources: [NAMESPACE:3-58](), [man/reexports.Rd:6-19]()

## Testing Infrastructure

The testing system uses `testthat` with a comprehensive setup that supports multiple database backends and mock data generation. The setup provides utilities for database connections, schema management, and cohort collection that are used across all test files.

### Test Setup Architecture

```mermaid
graph TB
    subgraph "Test Configuration"
        SETUP_R["setup.R<br/>Global test utilities"]
        ENV_VARS["Environment variables<br/>DB_TO_TEST, connection strings"]
    end
    
    subgraph "Database Connections"
        CONN_FUNC["connection() function<br/>Multi-backend support"]
        DUCKDB_CONN["DuckDB connection<br/>:memory: database"]
        SQLSERVER_CONN["SQL Server connection<br/>ODBC driver"]
        REDSHIFT_CONN["Redshift connection<br/>RPostgres driver"]
    end
    
    subgraph "Schema Management"
        SCHEMA_FUNC["schema() function<br/>Environment-specific schemas"]
        DUCKDB_SCHEMA["main.dus_"]
        SQLSERVER_SCHEMA["env.dus_"]
        REDSHIFT_SCHEMA["env.dus_"]
    end
    
    subgraph "Test Utilities"
        COLLECT_COHORT["collectCohort() function<br/>Standardized cohort collection"]
        EUNOMIA_REQ["CDMConnector::requireEunomia()<br/>Test data requirement"]
    end
    
    SETUP_R --> CONN_FUNC
    SETUP_R --> SCHEMA_FUNC
    SETUP_R --> COLLECT_COHORT
    
    CONN_FUNC --> DUCKDB_CONN
    CONN_FUNC --> SQLSERVER_CONN
    CONN_FUNC --> REDSHIFT_CONN
    
    SCHEMA_FUNC --> DUCKDB_SCHEMA
    SCHEMA_FUNC --> SQLSERVER_SCHEMA
    SCHEMA_FUNC --> REDSHIFT_SCHEMA
    
    ENV_VARS --> CONN_FUNC
    ENV_VARS --> SCHEMA_FUNC
```

Sources: [tests/testthat/setup.R:1-44]()

## Mock Data Generation System

The `mockDrugUtilisation` function provides a comprehensive mock data generation system for testing and development. It creates a complete OMOP CDM database with realistic drug utilization data patterns, supporting both in-memory testing and development workflows.

### Mock Data Generation Flow

```mermaid
graph TB
    subgraph "Input Processing"
        MOCK_FUNC["mockDrugUtilisation()"]
        USER_TABLES["User-provided tables<br/>..."]
        PARAMS["Parameters<br/>numberIndividuals, seed"]
    end
    
    subgraph "Vocabulary Generation"
        VOCAB_FUNC["vocabularyTables()"]
        MOCK_CONCEPT["mockConcept"]
        MOCK_ANCESTOR["mockConceptAncestor"] 
        MOCK_STRENGTH["mockDrugStrength"]
        MOCK_REL["mockConceptRelationship"]
    end
    
    subgraph "Core Table Creation"
        CREATE_PERSON["createPersonTable()"]
        CREATE_OBS_PERIOD["createObservationPeriod()"]
        CREATE_DRUG_EXP["createDrugExposure()"]
        CREATE_CONDITION["createConditionOccurrence()"]
        CREATE_VISIT["createVisitOccurrence()"]
    end
    
    subgraph "Date Consistency"
        CALC_MIN_DATE["calculateMinDate()"]
        CORRECT_PERSON["correctPersonDates()"]
        CORRECT_OBS["correctObsDates()"]
    end
    
    subgraph "Output Generation"
        CDM_FROM_TABLES["omopgenerics::cdmFromTables()"]
        COPY_CDM["CDMConnector::copyCdmTo()"]
        CDM_REFERENCE["cdm_reference object"]
    end
    
    MOCK_FUNC --> VOCAB_FUNC
    MOCK_FUNC --> CREATE_PERSON
    VOCAB_FUNC --> MOCK_CONCEPT
    VOCAB_FUNC --> MOCK_ANCESTOR
    
    CREATE_PERSON --> CREATE_OBS_PERIOD
    CREATE_OBS_PERIOD --> CREATE_DRUG_EXP
    CREATE_DRUG_EXP --> CREATE_CONDITION
    CREATE_CONDITION --> CREATE_VISIT
    
    CALC_MIN_DATE --> CORRECT_PERSON
    CALC_MIN_DATE --> CORRECT_OBS
    
    CREATE_VISIT --> CDM_FROM_TABLES
    CDM_FROM_TABLES --> COPY_CDM
    COPY_CDM --> CDM_REFERENCE
    
    PARAMS --> CREATE_PERSON
    USER_TABLES --> VOCAB_FUNC
```

Sources: [R/mockDrugUtilisation.R:41-160](), [R/mockDrugUtilisation.R:163-202](), [R/mockDrugUtilisation.R:205-244](), [R/mockDrugUtilisation.R:269-310]()

### Mock Data Table Relationships

The mock data system creates a complete OMOP CDM with proper referential integrity and realistic data patterns. Each table creation function includes logic for generating appropriate sample sizes and maintaining temporal consistency.

```mermaid
graph LR
    subgraph "Core Demographics"
        PERSON["person table<br/>createPersonTable()"]
        OBS_PERIOD["observation_period<br/>createObservationPeriod()"]
    end
    
    subgraph "Clinical Events"
        DRUG_EXP["drug_exposure<br/>createDrugExposure()"]
        CONDITION["condition_occurrence<br/>createConditionOccurrence()"]
        OBSERVATION["observation<br/>createObservation()"]
        VISIT["visit_occurrence<br/>createVisitOccurrence()"]
    end
    
    subgraph "Vocabulary Tables"
        CONCEPT["concept<br/>mockConcept"]
        CONCEPT_ANC["concept_ancestor<br/>mockConceptAncestor"]
        DRUG_STRENGTH["drug_strength<br/>mockDrugStrength"]
        CONCEPT_REL["concept_relationship<br/>mockConceptRelationship"]
    end
    
    subgraph "Cohort Tables"
        COHORT1["cohort1<br/>createCohort()"]
        COHORT2["cohort2<br/>createCohort()"]
    end
    
    PERSON --> OBS_PERIOD
    OBS_PERIOD --> DRUG_EXP
    OBS_PERIOD --> CONDITION
    OBS_PERIOD --> OBSERVATION
    OBS_PERIOD --> COHORT1
    OBS_PERIOD --> COHORT2
    
    DRUG_EXP --> VISIT
    CONDITION --> VISIT
    
    CONCEPT --> DRUG_EXP
    CONCEPT --> CONDITION
    CONCEPT --> OBSERVATION
    
    DRUG_STRENGTH --> DRUG_EXP
    CONCEPT_REL --> CONCEPT
```

Sources: [R/mockDrugUtilisation.R:367-412](), [R/mockDrugUtilisation.R:414-468](), [R/mockDrugUtilisation.R:470-495](), [R/mockDrugUtilisation.R:312-350]()