# Page: Mock Data and Testing

# Mock Data and Testing

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/addDemographics.R](R/addDemographics.R)
- [R/mockPatientProfiles.R](R/mockPatientProfiles.R)
- [tests/testthat/test-addAttributes.R](tests/testthat/test-addAttributes.R)
- [tests/testthat/test-addDemographics.R](tests/testthat/test-addDemographics.R)
- [tests/testthat/test-addFutureObservation.R](tests/testthat/test-addFutureObservation.R)
- [tests/testthat/test-addInObservation.R](tests/testthat/test-addInObservation.R)
- [tests/testthat/test-addPriorObservation.R](tests/testthat/test-addPriorObservation.R)
- [tests/testthat/test-addSex.R](tests/testthat/test-addSex.R)

</details>



This section covers the mock data generation system and testing infrastructure used to develop and validate PatientProfiles functionality. The `mockPatientProfiles()` function creates synthetic OMOP CDM databases for testing without requiring access to real patient data.

For information about the core demographic functions being tested, see [Patient Demographics](#2.1). For details about the broader development and quality assurance processes, see [Quality Assurance and CI/CD](#5.2).

## Mock CDM Database Generation

The mock data system centers around the `mockPatientProfiles()` function, which generates a complete OMOP CDM reference object with synthetic data. This function creates all standard OMOP tables required for testing PatientProfiles functionality.

```mermaid
graph TB
    subgraph "Mock Data Generation"
        MOCK_FUNC["mockPatientProfiles()"]
        PARAMS["Parameters<br/>• numberIndividuals<br/>• seed<br/>• con (connection)<br/>• writeSchema<br/>• ... (custom tables)"]
        MOCK_FUNC --> CDM_REF["CDM Reference Object"]
    end
    
    subgraph "Generated OMOP Tables"
        PERSON["person<br/>Demographics & Birth Info"]
        OBS_PERIOD["observation_period<br/>Temporal Boundaries"]
        DRUG_EXP["drug_exposure<br/>Medication Records"]
        COND_OCC["condition_occurrence<br/>Diagnosis Records"]
        VISIT_OCC["visit_occurrence<br/>Healthcare Encounters"]
        DEATH["death<br/>Mortality Data"]
    end
    
    subgraph "Generated Cohort Tables"
        COHORT1["cohort1<br/>Test Cohort A"]
        COHORT2["cohort2<br/>Test Cohort B"]
    end
    
    subgraph "Database Backends"
        DUCKDB["DuckDB<br/>(Default In-Memory)"]
        CUSTOM_DB["Custom Database<br/>(PostgreSQL, SQL Server)"]
    end
    
    CDM_REF --> PERSON
    CDM_REF --> OBS_PERIOD
    CDM_REF --> DRUG_EXP
    CDM_REF --> COND_OCC
    CDM_REF --> VISIT_OCC
    CDM_REF --> DEATH
    CDM_REF --> COHORT1
    CDM_REF --> COHORT2
    
    MOCK_FUNC --> DUCKDB
    MOCK_FUNC --> CUSTOM_DB
    
    PERSON --> OBS_PERIOD
    OBS_PERIOD --> DRUG_EXP
    OBS_PERIOD --> COND_OCC
    OBS_PERIOD --> VISIT_OCC
    OBS_PERIOD --> DEATH
```

**Mock Data Generation Architecture**

Sources: [R/mockPatientProfiles.R:42-340](), [tests/testthat/test-addDemographics.R:25-30]()

## Core Mock Data Functions

| Function | Purpose | Key Parameters |
|----------|---------|----------------|
| `mockPatientProfiles()` | Creates complete mock CDM | `numberIndividuals`, `seed`, `con`, `writeSchema`, custom tables |
| `mockDisconnect()` | Cleans up database connections | `cdm` object |
| `addDate()` | Internal function for date generation | `x`, `cols` |

The system supports both automatic table generation and custom table injection through the `...` parameter, allowing tests to specify exact data scenarios.

```mermaid
flowchart LR
    subgraph "Input Processing"
        CUSTOM_TABLES["Custom Tables<br/>(... parameter)"]
        DEFAULT_PARAMS["Default Parameters<br/>numberIndividuals: 10<br/>seed: NULL"]
    end
    
    subgraph "Person ID Resolution"
        PERSON_EXTRACT["Extract person_id/subject_id<br/>from custom tables"]
        PERSON_LIST["persons <- unique(ids)"]
    end
    
    subgraph "Table Generation Pipeline"
        PERSON_TABLE["Generate person table<br/>gender_concept_id<br/>year_of_birth"]
        DATE_COLLECT["Collect all dates<br/>from custom tables"]
        OBS_PERIOD_GEN["Generate observation_period<br/>based on date ranges"]
        OMOP_TABLES_GEN["Generate OMOP tables<br/>drug_exposure<br/>condition_occurrence<br/>visit_occurrence<br/>death"]
        COHORT_GEN["Generate cohort tables<br/>cohort1, cohort2"]
    end
    
    subgraph "Database Integration"
        DB_INSERT["Insert tables into database<br/>CDMConnector::dbSource()"]
        CDM_CREATE["Create CDM object<br/>CDMConnector::cdmFromCon()"]
    end
    
    CUSTOM_TABLES --> PERSON_EXTRACT
    DEFAULT_PARAMS --> PERSON_EXTRACT
    PERSON_EXTRACT --> PERSON_LIST
    PERSON_LIST --> PERSON_TABLE
    CUSTOM_TABLES --> DATE_COLLECT
    DATE_COLLECT --> OBS_PERIOD_GEN
    PERSON_TABLE --> OBS_PERIOD_GEN
    OBS_PERIOD_GEN --> OMOP_TABLES_GEN
    OMOP_TABLES_GEN --> COHORT_GEN
    COHORT_GEN --> DB_INSERT
    DB_INSERT --> CDM_CREATE
```

**Mock Data Generation Flow**

Sources: [R/mockPatientProfiles.R:62-340](), [R/mockPatientProfiles.R:342-376]()

## Testing Integration Patterns

The mock system integrates seamlessly with the testthat framework, providing consistent test environments across all PatientProfiles functions.

### Standard Testing Pattern

```mermaid
graph TD
    subgraph "Test Setup"
        TEST_START["test_that() block"]
        SKIP_CRAN["skip_on_cran()"]
        MOCK_CREATE["cdm <- mockPatientProfiles()"]
    end
    
    subgraph "Test Execution"
        FUNC_CALL["PatientProfiles function call<br/>addDemographics()<br/>addAge()<br/>addSex()"]
        ASSERTIONS["expect_*() assertions<br/>Column presence<br/>Value correctness<br/>Row count"]
    end
    
    subgraph "Test Cleanup"
        MOCK_DISCONNECT["mockDisconnect(cdm)"]
    end
    
    TEST_START --> SKIP_CRAN
    SKIP_CRAN --> MOCK_CREATE
    MOCK_CREATE --> FUNC_CALL
    FUNC_CALL --> ASSERTIONS
    ASSERTIONS --> MOCK_DISCONNECT
```

**Standard Test Pattern**

### Custom Data Testing Pattern

For specific test scenarios, the system allows injection of custom tables to test edge cases and specific data configurations.

```mermaid
flowchart TD
    subgraph "Custom Test Data"
        PERSON_CUSTOM["Custom person table<br/>Specific gender_concept_id<br/>Missing birth dates"]
        COHORT_CUSTOM["Custom cohort table<br/>Specific date ranges<br/>Multiple definitions"]
        OBS_CUSTOM["Custom observation_period<br/>Gap testing<br/>Overlap scenarios"]
    end
    
    subgraph "Mock Generation"
        MOCK_CALL["mockPatientProfiles(<br/>  person = person_custom,<br/>  cohort1 = cohort_custom,<br/>  observation_period = obs_custom<br/>)"]
    end
    
    subgraph "Targeted Testing"
        EDGE_CASES["Test edge cases<br/>Missing data handling<br/>Date boundary conditions<br/>Multiple observation periods"]
    end
    
    PERSON_CUSTOM --> MOCK_CALL
    COHORT_CUSTOM --> MOCK_CALL
    OBS_CUSTOM --> MOCK_CALL
    MOCK_CALL --> EDGE_CASES
```

**Custom Data Testing Pattern**

Sources: [tests/testthat/test-addDemographics.R:84-146](), [tests/testthat/test-addDemographics.R:514-574]()

## Database Connection Management

The mock system supports multiple database backends and handles connection lifecycle management automatically.

| Connection Type | Usage | Configuration |
|----------------|--------|---------------|
| DuckDB (Default) | In-memory testing | `con = NULL`, `writeSchema = "main"` |
| Custom PostgreSQL | Integration testing | `con = postgres_connection`, `writeSchema = schema_name` |
| Custom SQL Server | Production-like testing | `con = sqlserver_connection`, `writeSchema = schema_name` |

### Connection Lifecycle

```mermaid
sequenceDiagram
    participant Test as "Test Function"
    participant Mock as "mockPatientProfiles()"
    participant CDM as "CDM Connector"
    participant DB as "Database"
    
    Test->>Mock: Create mock CDM
    alt No connection provided
        Mock->>DB: Create DuckDB connection
    else Custom connection
        Mock->>DB: Use provided connection
    end
    
    Mock->>CDM: dbSource(con, writeSchema)
    Mock->>DB: Insert generated tables
    Mock->>CDM: cdmFromCon()
    CDM->>Test: Return CDM reference
    
    Note over Test: Execute test logic
    
    Test->>Mock: mockDisconnect(cdm)
    Mock->>CDM: dropSourceTable()
    alt DuckDB connection
        Mock->>DB: dbDisconnect(shutdown=TRUE)
    end
```

**Database Connection Lifecycle**

Sources: [R/mockPatientProfiles.R:47-56](), [R/mockPatientProfiles.R:384-391]()

## Mock Data Characteristics

The generated mock data follows specific patterns to ensure realistic testing scenarios:

### Demographic Distribution
- Gender: Random assignment between Male (8507) and Female (8532) concept IDs
- Birth years: 1900 + random integers up to 80 years
- Missing data: Configurable through custom tables

### Temporal Relationships
- Observation periods: Automatically calculated from provided dates or randomly generated
- Drug exposures: Random within observation periods, 0 to 2×numberIndividuals records
- Condition occurrences: Random within observation periods, 0 to 2×numberIndividuals records
- Death records: ~20% of individuals, at end of final observation period

### Cohort Generation
- Two cohort tables (`cohort1`, `cohort2`) generated by default
- Random cohort definition IDs (1-3)
- Start/end dates within observation periods
- Configurable through custom table injection

Sources: [R/mockPatientProfiles.R:82-309](), [R/mockPatientProfiles.R:230-249]()