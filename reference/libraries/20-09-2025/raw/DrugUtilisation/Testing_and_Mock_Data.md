# Page: Testing and Mock Data

# Testing and Mock Data

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/mockDrugUtilisation.R](R/mockDrugUtilisation.R)
- [man/mockDrugUtilisation.Rd](man/mockDrugUtilisation.Rd)
- [man/plotProportionOfPatientsCovered.Rd](man/plotProportionOfPatientsCovered.Rd)
- [tests/testthat/setup.R](tests/testthat/setup.R)
- [tests/testthat/test-generatedAtcCohortSet.R](tests/testthat/test-generatedAtcCohortSet.R)
- [tests/testthat/test-generatedIngredientCohortSet.R](tests/testthat/test-generatedIngredientCohortSet.R)
- [tests/testthat/test-patterns.R](tests/testthat/test-patterns.R)
- [tests/testthat/test-plotProportionOfPatientsCovered.R](tests/testthat/test-plotProportionOfPatientsCovered.R)
- [tests/testthat/test-plots.R](tests/testthat/test-plots.R)

</details>



This document covers the testing framework and mock data generation systems used for developing and validating the DrugUtilisation package. The testing infrastructure supports multiple database backends and provides comprehensive mock OMOP CDM data for reproducible testing scenarios.

For information about the package's exported functions and public API, see [Function Exports and API](#9.1). For details about documentation generation and CI/CD processes, see [Documentation and CI/CD](#9.3).

## Mock Data Generation System

The DrugUtilisation package provides a comprehensive mock data generation system through the `mockDrugUtilisation()` function, which creates complete OMOP CDM databases for testing purposes.

### Core Mock Data Architecture

```mermaid
graph TB
    subgraph "Mock Data Generation"
        MOCK["mockDrugUtilisation()"]
        VOCAB["vocabularyTables()"]
        PERSON["createPersonTable()"]
        OBS["createObservationPeriod()"]
        DRUG["createDrugExposure()"]
        COND["createConditionOccurrence()"]
        VISIT["createVisitOccurrence()"]
        COHORT["createCohorts()"]
    end
    
    subgraph "Input Parameters"
        CON["con: DBI connection"]
        SCHEMA["writeSchema: target schema"]
        NIND["numberIndividuals: patient count"]
        SEED["seed: random seed"]
        TABLES["...: custom table overrides"]
    end
    
    subgraph "Generated CDM Tables"
        CONCEPT["concept"]
        CONCEPT_ANC["concept_ancestor"]
        DRUG_STR["drug_strength"]
        CONCEPT_REL["concept_relationship"]
        PERSON_T["person"]
        OBS_T["observation_period"]
        DRUG_EXP["drug_exposure"]
        COND_OCC["condition_occurrence"]
        VISIT_OCC["visit_occurrence"]
        OBSERVATION["observation"]
        COHORT1["cohort1"]
        COHORT2["cohort2"]
    end
    
    subgraph "Output"
        CDM_REF["cdm_reference object"]
    end
    
    CON --> MOCK
    SCHEMA --> MOCK
    NIND --> MOCK
    SEED --> MOCK
    TABLES --> MOCK
    
    MOCK --> VOCAB
    MOCK --> PERSON
    MOCK --> OBS
    MOCK --> DRUG
    MOCK --> COND
    MOCK --> VISIT
    MOCK --> COHORT
    
    VOCAB --> CONCEPT
    VOCAB --> CONCEPT_ANC
    VOCAB --> DRUG_STR
    VOCAB --> CONCEPT_REL
    
    PERSON --> PERSON_T
    OBS --> OBS_T
    DRUG --> DRUG_EXP
    COND --> COND_OCC
    VISIT --> VISIT_OCC
    MOCK --> OBSERVATION
    COHORT --> COHORT1
    COHORT --> COHORT2
    
    CONCEPT --> CDM_REF
    CONCEPT_ANC --> CDM_REF
    DRUG_STR --> CDM_REF
    CONCEPT_REL --> CDM_REF
    PERSON_T --> CDM_REF
    OBS_T --> CDM_REF
    DRUG_EXP --> CDM_REF
    COND_OCC --> CDM_REF
    VISIT_OCC --> CDM_REF
    OBSERVATION --> CDM_REF
    COHORT1 --> CDM_REF
    COHORT2 --> CDM_REF
```

**Sources:** [R/mockDrugUtilisation.R:17-160]()

### Mock Data Generation Process

The `mockDrugUtilisation()` function follows a systematic approach to create comprehensive mock CDM databases:

| Component | Function | Purpose | Default Behavior |
|-----------|----------|---------|------------------|
| **Vocabulary Tables** | `vocabularyTables()` | Creates concept, concept_ancestor, drug_strength, concept_relationship | Uses predefined mock vocabulary data |
| **Person Demographics** | `createPersonTable()` | Generates person records with demographics | Creates random demographics for specified number of individuals |
| **Observation Periods** | `createObservationPeriod()` | Defines patient observation windows | Random periods between birth and 2023-01-01 |
| **Drug Exposures** | `createDrugExposure()` | Generates drug exposure records | Poisson-distributed exposures using drug concepts |
| **Conditions** | `createConditionOccurrence()` | Creates condition occurrence records | Random conditions during observation periods |
| **Cohorts** | `createCohorts()` | Generates cohort membership data | Two default cohorts with random membership |

**Sources:** [R/mockDrugUtilisation.R:163-573]()

### Database Connection Management

```mermaid
graph LR
    subgraph "Connection Types"
        DEFAULT["con = NULL"]
        CUSTOM["con = DBI connection"]
    end
    
    subgraph "Database Backends"
        DUCKDB["DuckDB :memory:"]
        CUSTOM_DB["Custom Database"]
    end
    
    subgraph "Schema Configuration"
        DEFAULT_SCHEMA["main.mock_*"]
        CUSTOM_SCHEMA["custom schema.prefix_*"]
    end
    
    DEFAULT --> DUCKDB
    CUSTOM --> CUSTOM_DB
    
    DUCKDB --> DEFAULT_SCHEMA
    CUSTOM_DB --> CUSTOM_SCHEMA
```

**Sources:** [R/mockDrugUtilisation.R:51-52]()

## Testing Framework Structure

The package uses the `testthat` framework with specialized utilities for multi-database testing and cohort comparison.

### Test Environment Setup

```mermaid
graph TB
    subgraph "Test Setup Infrastructure"
        SETUP["tests/testthat/setup.R"]
        CONNECTION["connection()"]
        SCHEMA["schema()"]
        COLLECT["collectCohort()"]
    end
    
    subgraph "Database Backends"
        DUCKDB["DuckDB (default)"]
        SQLSERVER["SQL Server"]
        REDSHIFT["Redshift"]
    end
    
    subgraph "Environment Variables"
        DB_TYPE["DB_TO_TEST"]
        SQL_SERVER["CDM5_SQL_SERVER_*"]
        REDSHIFT_ENV["CDM5_REDSHIFT_*"]
    end
    
    subgraph "Connection Parameters"
        DUCKDB_PARAMS["In-memory database"]
        SQL_PARAMS["Server, Database, Credentials"]
        REDSHIFT_PARAMS["Host, Port, Credentials"]
    end
    
    SETUP --> CONNECTION
    SETUP --> SCHEMA
    SETUP --> COLLECT
    
    DB_TYPE --> CONNECTION
    SQL_SERVER --> CONNECTION
    REDSHIFT_ENV --> CONNECTION
    
    CONNECTION --> DUCKDB
    CONNECTION --> SQLSERVER
    CONNECTION --> REDSHIFT
    
    DUCKDB --> DUCKDB_PARAMS
    SQLSERVER --> SQL_PARAMS
    REDSHIFT --> REDSHIFT_PARAMS
```

**Sources:** [tests/testthat/setup.R:1-44]()

### Database Backend Configuration

The testing framework supports multiple database backends through environment-driven configuration:

| Backend | Environment Variable | Connection Parameters |
|---------|---------------------|----------------------|
| **DuckDB** | `DB_TO_TEST="duckdb"` | In-memory connection |
| **SQL Server** | `DB_TO_TEST="sql server"` | Server, Database, UID, PWD from environment |
| **Redshift** | `DB_TO_TEST="redshift"` | Host, Port, Database, User, Password from environment |

**Schema Configuration:**
- **DuckDB:** `c(schema = "main", prefix = "dus_")`
- **SQL Server:** Uses `CDM5_SQL_SERVER_OHDSI_SCHEMA` environment variable
- **Redshift:** Uses `CDM5_REDSHIFT_SCRATCH_SCHEMA` environment variable

**Sources:** [tests/testthat/setup.R:2-31]()

## Testing Utilities

### Cohort Data Collection and Comparison

The `collectCohort()` utility function standardizes cohort data extraction for testing:

```mermaid
graph LR
    subgraph "collectCohort() Process"
        INPUT["cohort table"]
        FILTER["filter by cohort_definition_id"]
        COLLECT["dplyr::collect()"]
        ARRANGE["arrange by all columns"]
        CLEAN["remove attributes"]
        OUTPUT["standardized data frame"]
    end
    
    INPUT --> FILTER
    FILTER --> COLLECT
    COLLECT --> ARRANGE
    ARRANGE --> CLEAN
    CLEAN --> OUTPUT
    
    subgraph "Removed Attributes"
        COHORT_SET["cohort_set"]
        COHORT_ATT["cohort_attrition"]
        COHORT_CODE["cohort_codelist"]
    end
    
    CLEAN --> COHORT_SET
    CLEAN --> COHORT_ATT
    CLEAN --> COHORT_CODE
```

**Sources:** [tests/testthat/setup.R:32-44]()

### Mock Database Lifecycle Management

Testing follows a consistent pattern for database setup and teardown:

1. **Setup:** `cdm <- mockDrugUtilisation(con = connection(), writeSchema = schema())`
2. **Test Operations:** Generate cohorts, run analyses, collect results
3. **Assertions:** Compare expected vs actual results using `expect_equal()`
4. **Teardown:** `mockDisconnect(cdm = cdm)`

**Sources:** [tests/testthat/test-generatedIngredientCohortSet.R:3-28]()

## Test Organization Patterns

### Cohort Generation Testing

```mermaid
graph TB
    subgraph "Cohort Generation Tests"
        ING_TEST["test-generatedIngredientCohortSet.R"]
        ATC_TEST["test-generatedAtcCohortSet.R"]
        PATTERN_TEST["test-patterns.R"]
    end
    
    subgraph "Test Categories"
        EQUIVALENCE["Equivalence Testing"]
        OPTIONS["Parameter Options"]
        ERROR_HANDLING["Error Handling"]
        DATE_FILTERING["Date Range Filtering"]
    end
    
    subgraph "Test Patterns"
        SKIP_CRAN["skip_on_cran()"]
        MOCK_SETUP["mockDrugUtilisation() setup"]
        COLLECT_COMPARE["collectCohort() comparison"]
        MOCK_DISCONNECT["mockDisconnect() cleanup"]
    end
    
    ING_TEST --> EQUIVALENCE
    ING_TEST --> OPTIONS
    ING_TEST --> ERROR_HANDLING
    ING_TEST --> DATE_FILTERING
    
    ATC_TEST --> EQUIVALENCE
    PATTERN_TEST --> OPTIONS
    
    EQUIVALENCE --> SKIP_CRAN
    OPTIONS --> MOCK_SETUP
    ERROR_HANDLING --> COLLECT_COMPARE
    DATE_FILTERING --> MOCK_DISCONNECT
```

**Sources:** [tests/testthat/test-generatedIngredientCohortSet.R:1-128](), [tests/testthat/test-generatedAtcCohortSet.R:1-33](), [tests/testthat/test-patterns.R:1-65]()

### Visualization Testing

Visualization tests focus on plot generation and data structure validation:

```mermaid
graph TB
    subgraph "Plot Testing Framework"
        PLOT_TESTS["test-plots.R"]
        PPC_TESTS["test-plotProportionOfPatientsCovered.R"]
    end
    
    subgraph "Plot Validation Patterns"
        GGPLOT_CHECK["ggplot2::is.ggplot()"]
        DATA_STRUCTURE["data frame column checks"]
        ERROR_EXPECTED["expect_error() for invalid inputs"]
        WARNING_EXPECTED["expect_warning() for edge cases"]
    end
    
    subgraph "Test Data Scenarios"
        LARGE_DATASET["Large mock datasets (10k exposures)"]
        MULTI_COHORT["Multiple cohort scenarios"]
        STRATIFICATION["Stratified analysis results"]
        EMPTY_RESULTS["Empty result handling"]
    end
    
    PLOT_TESTS --> GGPLOT_CHECK
    PPC_TESTS --> DATA_STRUCTURE
    
    GGPLOT_CHECK --> LARGE_DATASET
    DATA_STRUCTURE --> MULTI_COHORT
    ERROR_EXPECTED --> STRATIFICATION
    WARNING_EXPECTED --> EMPTY_RESULTS
```

**Sources:** [tests/testthat/test-plots.R:1-263](), [tests/testthat/test-plotProportionOfPatientsCovered.R:1-154]()

### Mock Data Customization Testing

Tests demonstrate how to customize mock data for specific scenarios:

| Test Scenario | Custom Tables | Purpose |
|---------------|---------------|---------|
| **Drug Restart Analysis** | `drug_exposure`, `dus_cohort`, `observation_period`, `person` | Complex temporal patterns |
| **Indication Analysis** | `targetCohortName`, `indicationCohortName`, `condition_occurrence` | Medical indication testing |
| **Large Scale Testing** | 10,000 exposures, 1,000 persons | Performance and scalability |
| **Pattern Testing** | Custom `drug_strength`, `concept`, `concept_relationship` | Dose calculation validation |

**Sources:** [tests/testthat/test-plots.R:6-64](), [tests/testthat/test-plots.R:94-154](), [tests/testthat/test-patterns.R:3-42]()