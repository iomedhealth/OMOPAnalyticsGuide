# Page: Mock Data and Testing Utilities

# Mock Data and Testing Utilities

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [.gitignore](.gitignore)
- [DESCRIPTION](DESCRIPTION)
- [NEWS.md](NEWS.md)
- [R/mockVocabRef.R](R/mockVocabRef.R)
- [R/summariseCodeUse.R](R/summariseCodeUse.R)
- [tests/testthat/test-summariseCodeUse.R](tests/testthat/test-summariseCodeUse.R)

</details>



This document covers the mock data generation and testing infrastructure used in CodelistGenerator for development, unit testing, and integration testing. For information about the overall package architecture, see [Package Architecture](#8.1).

## Purpose and Scope

The CodelistGenerator package provides comprehensive testing utilities to support development and validation across multiple database backends. The mock data system creates lightweight vocabulary references for rapid testing, while the testing framework validates functionality against both mock and real OMOP CDM databases.

## Mock Vocabulary Reference

### Core Function: `mockVocabRef`

The `mockVocabRef()` function creates a complete mock OMOP CDM with vocabulary tables for testing purposes. It supports two backend modes: in-memory data frames for unit tests and DuckDB databases for integration tests.

```mermaid
graph TB
    subgraph "Mock Data Generation"
        MVR["mockVocabRef()"]
        BACKEND["backend parameter"]
        DF["data_frame"]
        DB["database"]
    end
    
    subgraph "Mock Tables Created"
        PERSON["person"]
        OBS_PERIOD["observation_period"]
        CONCEPT["concept"]
        CONCEPT_ANC["concept_ancestor"]
        CONCEPT_SYN["concept_synonym"]
        CONCEPT_REL["concept_relationship"]
        VOCAB["vocabulary"]
        DRUG_STR["drug_strength"]
        CDM_SOURCE["cdm_source"]
        ACHILLES["achilles_*"]
    end
    
    subgraph "Output CDM"
        CDM_DF["CDM Data Frame"]
        CDM_DB["CDM Database"]
    end
    
    MVR --> BACKEND
    BACKEND --> DF
    BACKEND --> DB
    
    MVR --> PERSON
    MVR --> OBS_PERIOD
    MVR --> CONCEPT
    MVR --> CONCEPT_ANC
    MVR --> CONCEPT_SYN
    MVR --> CONCEPT_REL
    MVR --> VOCAB
    MVR --> DRUG_STR
    MVR --> CDM_SOURCE
    MVR --> ACHILLES
    
    DF --> CDM_DF
    DB --> CDM_DB
```

Sources: [R/mockVocabRef.R:30-423]()

### Mock Concept Hierarchy

The mock vocabulary contains a structured concept hierarchy designed to test various CodelistGenerator functions:

```mermaid
graph TB
    subgraph "Condition Domain"
        MUSC_DIS[1: "Musculoskeletal disorder"]
        OSTEOART[2: "Osteoarthrosis"]
        ARTHRITIS[3: "Arthritis"]
        KNEE_OA[4: "Osteoarthritis of knee"]
        HIP_OA[5: "Osteoarthritis of hip"]
        OSTEONECROSIS[6: "Osteonecrosis"]
        DEG_ARTHROP[7: "Degenerative arthropathy"]
        KNEE_OA_ALT[8: "Knee osteoarthritis"]
    end
    
    subgraph "Drug Domain"
        ADALIMUMAB[10: "Adalimumab"]
        INJECTION[11: "Injection"]
        DESC_DRUG[13: "Descendant drug"]
        INJECTABLE[14: "Injectable"]
    end
    
    subgraph "Vocabularies"
        SNOMED["SNOMED CT"]
        RXNORM["RxNorm"]
        READ["Read Codes"]
        ICD10["ICD-10"]
        ATC["ATC"]
    end
    
    MUSC_DIS --> OSTEOART
    MUSC_DIS --> ARTHRITIS
    ARTHRITIS --> KNEE_OA
    ARTHRITIS --> HIP_OA
    ADALIMUMAB --> DESC_DRUG
    
    MUSC_DIS -.-> SNOMED
    ADALIMUMAB -.-> RXNORM
    DEG_ARTHROP -.-> READ
```

Sources: [R/mockVocabRef.R:54-125](), [R/mockVocabRef.R:127-206]()

## Testing Framework Architecture

### Multi-Database Testing Strategy

The package implements a comprehensive testing strategy that validates functionality across multiple database backends:

```mermaid
graph LR
    subgraph "Unit Tests"
        MOCK_DATA["Mock CDM Data"]
        UNIT_FUNC["Unit Test Functions"]
    end
    
    subgraph "Integration Tests"
        EUNOMIA["Eunomia CDM"]
        REDSHIFT["Redshift CDM"]
        POSTGRES["PostgreSQL CDM"]
        SNOWFLAKE["Snowflake CDM"]
        SQLSERVER["SQL Server CDM"]
    end
    
    subgraph "Test Scenarios"
        BASIC["Basic Functionality"]
        EDGE_CASES["Edge Cases"]
        CROSS_DB["Cross-Database Validation"]
        PERFORMANCE["Performance Tests"]
    end
    
    MOCK_DATA --> UNIT_FUNC
    UNIT_FUNC --> BASIC
    
    EUNOMIA --> BASIC
    EUNOMIA --> EDGE_CASES
    REDSHIFT --> CROSS_DB
    POSTGRES --> CROSS_DB
    SNOWFLAKE --> CROSS_DB
    SQLSERVER --> CROSS_DB
    
    CROSS_DB --> PERFORMANCE
```

Sources: [tests/testthat/test-summariseCodeUse.R:1-867]()

### Test Data Strategies

The testing framework uses different data strategies for different types of tests:

| Test Type | Data Source | Purpose | Examples |
|-----------|-------------|---------|----------|
| Unit Tests | `mockVocabRef()` | Fast isolated testing | Function parameter validation |
| Integration Tests | Eunomia CDM | Real data scenarios | End-to-end workflows |
| Cross-Platform Tests | Multiple DBs | Database compatibility | SQL dialect differences |
| Performance Tests | Large datasets | Scalability validation | Query optimization |

Sources: [tests/testthat/test-summariseCodeUse.R:4-5](), [tests/testthat/test-summariseCodeUse.R:364-365](), [tests/testthat/test-summariseCodeUse.R:557-568]()

## Mock Data Table Structure

### Concept Table Design

The mock concept table contains 26 concepts spanning multiple domains and vocabularies:

```mermaid
graph TB
    subgraph "Concept Domains"
        COND_DOM["Condition Domain<br/>Concepts 1-8, 15-18, 24"]
        DRUG_DOM["Drug Domain<br/>Concepts 10-14, 19-21"]
        OBS_DOM["Observation Domain<br/>Concept 9"]
        UNIT_DOM["Unit Domain<br/>Concepts 22-23"]
    end
    
    subgraph "Vocabulary Coverage"
        SNOMED_V["SNOMED: 1-6, 24"]
        READ_V["Read: 7-8"]
        RXNORM_V["RxNorm: 10, 13, 19-21"]
        ICD10_V["ICD-10: 15-18"]
        ATC_V["ATC: 12"]
        LOINC_V["LOINC: 9"]
        OMOP_V["OMOP: 11, 14"]
        UCUM_V["UCUM: 22-23"]
    end
    
    subgraph "Standard Concepts"
        STANDARD["Standard Concepts<br/>S flag set"]
        NON_STANDARD["Non-Standard Concepts<br/>Null or other flags"]
    end
    
    COND_DOM --> SNOMED_V
    COND_DOM --> READ_V
    COND_DOM --> ICD10_V
    DRUG_DOM --> RXNORM_V
    DRUG_DOM --> ATC_V
    DRUG_DOM --> OMOP_V
    OBS_DOM --> LOINC_V
    UNIT_DOM --> UCUM_V
```

Sources: [R/mockVocabRef.R:54-125]()

### Relationship Testing Data

The mock data includes concept relationships to test mapping and hierarchy functions:

```mermaid
graph LR
    subgraph "Hierarchical Relationships"
        MAPPED_FROM["Mapped from<br/>2→7, 4→8, 1→24"]
        SUBSUMES["Subsumes<br/>15→16→17→18"]
        MAPS_TO["Maps to<br/>18→3"]
    end
    
    subgraph "Drug Relationships"
        DOSE_FORM["RxNorm has dose form<br/>10→11, 13→14, 20→35604877, 21→35604394"]
        DUE_TO["Due to of<br/>3→6"]
    end
    
    subgraph "Test Scenarios"
        HIERARCHY_TEST["Concept Hierarchy Navigation"]
        MAPPING_TEST["Cross-Vocabulary Mapping"]
        DRUG_FORM_TEST["Drug Form Relationships"]
    end
    
    MAPPED_FROM --> MAPPING_TEST
    SUBSUMES --> HIERARCHY_TEST
    MAPS_TO --> MAPPING_TEST
    DOSE_FORM --> DRUG_FORM_TEST
    DUE_TO --> HIERARCHY_TEST
```

Sources: [R/mockVocabRef.R:220-284]()

### Achilles Test Data

The mock CDM includes Achilles results tables for testing usage analysis functions:

| Analysis ID | Stratum 1 | Count Value | Purpose |
|-------------|-----------|-------------|---------|
| 401 | 4 (Knee OA) | 400 | High usage concept |
| 401 | 5 (Hip OA) | 200 | Medium usage concept |
| 401 | 9 (Observation) | 100 | Low usage concept |

Sources: [R/mockVocabRef.R:372-378]()

## Database Backend Integration

### Connection Management

The testing framework manages connections to multiple database types through a unified interface:

```mermaid
graph TB
    subgraph "Database Backends"
        DUCKDB["DuckDB<br/>duckdb::duckdb()"]
        POSTGRES["PostgreSQL<br/>RPostgres::Postgres()"]
        REDSHIFT["Redshift<br/>RPostgres::Redshift()"]
        SQLSERVER["SQL Server<br/>odbc connection"]
        SNOWFLAKE["Snowflake<br/>odbc connection"]
    end
    
    subgraph "CDMConnector Interface"
        CDM_FROM_CON["CDMConnector::cdmFromCon()"]
        SCHEMA_CONFIG["Schema Configuration"]
        WRITE_SCHEMA["Write Schema Setup"]
    end
    
    subgraph "Test Execution"
        ENV_VARS["Environment Variables"]
        SKIP_CONDITIONS["Skip Conditions"]
        CLEANUP["Connection Cleanup"]
    end
    
    DUCKDB --> CDM_FROM_CON
    POSTGRES --> CDM_FROM_CON
    REDSHIFT --> CDM_FROM_CON
    SQLSERVER --> CDM_FROM_CON
    SNOWFLAKE --> CDM_FROM_CON
    
    CDM_FROM_CON --> SCHEMA_CONFIG
    SCHEMA_CONFIG --> WRITE_SCHEMA
    
    ENV_VARS --> SKIP_CONDITIONS
    SKIP_CONDITIONS --> CLEANUP
```

Sources: [tests/testthat/test-summariseCodeUse.R:4-5](), [tests/testthat/test-summariseCodeUse.R:557-568]()

## Usage Patterns and Best Practices

### Mock Data Usage

For unit testing and development:

- Use `mockVocabRef("data_frame")` for fast, lightweight tests
- Use `mockVocabRef("database")` for database interaction testing  
- Leverage predefined concept hierarchies for relationship testing
- Use Achilles mock data for usage analysis testing

### Integration Testing

For comprehensive validation:

- Use Eunomia CDM for realistic data scenarios
- Test specific concept IDs: acetaminophen (1125315, 1127433, etc.), poliovirus vaccine (40213160)
- Validate edge cases: empty cohorts, missing concepts, null source concept IDs
- Test cross-database compatibility using environment variable configuration

Sources: [tests/testthat/test-summariseCodeUse.R:7-11](), [tests/testthat/test-summariseCodeUse.R:867-883]()