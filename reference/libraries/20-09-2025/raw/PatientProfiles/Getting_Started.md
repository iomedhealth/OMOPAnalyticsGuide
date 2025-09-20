# Page: Getting Started

# Getting Started

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [DESCRIPTION](DESCRIPTION)
- [NAMESPACE](NAMESPACE)
- [NEWS.md](NEWS.md)
- [R/addDemographics.R](R/addDemographics.R)
- [R/mockPatientProfiles.R](R/mockPatientProfiles.R)
- [README.Rmd](README.Rmd)
- [README.md](README.md)
- [_pkgdown.yml](_pkgdown.yml)
- [tests/testthat/test-addDemographics.R](tests/testthat/test-addDemographics.R)

</details>



This section provides essential information for new users to begin working with PatientProfiles. The focus is on the most commonly used functions for adding patient characteristics to OMOP CDM tables and creating test environments for development and examples.

For information about advanced intersection operations between cohorts and clinical concepts, see [Core Features](#3). For performance optimization and large-scale studies, see [Large Scale Characteristics](#4.1).

## Essential Workflow Overview

The typical PatientProfiles workflow involves connecting to an OMOP CDM database, selecting a table containing patient data, and enriching it with demographic or temporal characteristics. For development and testing, mock data can be generated to simulate this process.

```mermaid
flowchart TD
    subgraph "Data Connection"
        CDM_REF["CDM Reference<br/>omopgenerics::cdmReference"]
        MOCK_CDM["mockPatientProfiles()<br/>Test Environment"]
        REAL_CDM["CDMConnector::cdmFromCon()<br/>Production Database"]
    end
    
    subgraph "Target Tables"
        COHORT_TBL["cdm$cohort1<br/>Cohort Table"]
        CLINICAL_TBL["cdm$condition_occurrence<br/>Clinical Tables"]
        PERSON_TBL["cdm$person<br/>Person Table"]
    end
    
    subgraph "Core Enhancement Functions"
        ADD_DEMO["addDemographics()<br/>Complete Demographics"]
        ADD_AGE["addAge()<br/>Age Calculation"]
        ADD_SEX["addSex()<br/>Gender Information"]
        ADD_PRIOR["addPriorObservation()<br/>Observation History"]
        ADD_FUTURE["addFutureObservation()<br/>Future Observation"]
    end
    
    subgraph "Enhanced Output"
        ENRICHED["Enhanced Table<br/>Original + New Columns"]
    end
    
    MOCK_CDM --> CDM_REF
    REAL_CDM --> CDM_REF
    CDM_REF --> COHORT_TBL
    CDM_REF --> CLINICAL_TBL
    
    COHORT_TBL --> ADD_DEMO
    CLINICAL_TBL --> ADD_DEMO
    COHORT_TBL --> ADD_AGE
    CLINICAL_TBL --> ADD_SEX
    COHORT_TBL --> ADD_PRIOR
    
    ADD_DEMO --> ENRICHED
    ADD_AGE --> ENRICHED
    ADD_SEX --> ENRICHED
    ADD_PRIOR --> ENRICHED
    
    PERSON_TBL -.-> ADD_DEMO
    PERSON_TBL -.-> ADD_AGE
    PERSON_TBL -.-> ADD_SEX
```

Sources: [README.md:56-95](), [R/addDemographics.R:17-114](), [R/mockPatientProfiles.R:17-41]()

## Core Demographics Functions

PatientProfiles provides both individual and comprehensive functions for adding patient characteristics. The main entry point is `addDemographics()`, which can add multiple characteristics in a single operation.

```mermaid
graph TD
    subgraph "Demographics System Architecture"
        DEMOGRAPHICS_MAIN["addDemographics()<br/>Line 67, R/addDemographics.R"]
        
        subgraph "Individual Functions"
            ADD_AGE_FUNC["addAge()<br/>Line 144"]
            ADD_SEX_FUNC["addSex()<br/>Line 365"]
            ADD_PRIOR_FUNC["addPriorObservation()<br/>Line 262"]
            ADD_FUTURE_FUNC["addFutureObservation()<br/>Line 205"]
            ADD_IN_OBS["addInObservation()<br/>Line 318"]
            ADD_DOB["addDateOfBirth()<br/>Line 422"]
        end
        
        subgraph "Internal Query System"
            DEMO_QUERY[".addDemographicsQuery()<br/>Internal Logic"]
            COMPUTE["computeTable()<br/>Result Materialization"]
        end
        
        subgraph "Configuration Parameters"
            INDEX_DATE["indexDate parameter<br/>Reference Date"]
            AGE_GROUPS["ageGroup parameter<br/>Categorization"]
            MISSING_VALUES["Missing Value Handling<br/>ageMissingMonth/Day"]
        end
    end
    
    DEMOGRAPHICS_MAIN --> DEMO_QUERY
    ADD_AGE_FUNC --> DEMO_QUERY
    ADD_SEX_FUNC --> DEMO_QUERY
    ADD_PRIOR_FUNC --> DEMO_QUERY
    ADD_FUTURE_FUNC --> DEMO_QUERY
    
    DEMO_QUERY --> COMPUTE
    
    INDEX_DATE --> DEMO_QUERY
    AGE_GROUPS --> DEMO_QUERY
    MISSING_VALUES --> DEMO_QUERY
```

Sources: [R/addDemographics.R:67-114](), [R/addDemographics.R:144-179](), [R/addDemographics.R:365-394]()

## Key Function Parameters

The demographics functions share common parameters that control their behavior:

| Parameter | Purpose | Default | Example |
|-----------|---------|---------|---------|
| `indexDate` | Reference date for calculations | `"cohort_start_date"` | `"condition_start_date"` |
| `ageName` | Output column name for age | `"age"` | `"age_at_diagnosis"` |
| `ageGroup` | Age categorization ranges | `NULL` | `list(c(0,18), c(19,65))` |
| `sexName` | Output column name for sex | `"sex"` | `"gender"` |
| `priorObservationType` | Return format for prior observation | `"days"` | `"date"` |
| `name` | Result table name | `NULL` (temporary) | `"enriched_cohort"` |

Sources: [R/addDemographics.R:67-88](), [R/addDemographics.R:144-153]()

## Mock Data Environment

For development and testing, PatientProfiles provides `mockPatientProfiles()` to create simulated OMOP CDM databases. This function generates realistic test data following OMOP CDM structure.

```mermaid
flowchart LR
    subgraph "Mock Data Generation"
        MOCK_FUNC["mockPatientProfiles()<br/>R/mockPatientProfiles.R:42"]
        
        subgraph "Generated Tables"
            PERSON_T["person table<br/>Demographics"]
            OBS_PERIOD["observation_period<br/>Temporal Bounds"]
            CONDITION["condition_occurrence<br/>Clinical Events"]
            DRUG_EXP["drug_exposure<br/>Medication Events"]
            COHORT1["cohort1<br/>Test Cohort"]
            COHORT2["cohort2<br/>Test Cohort"]
        end
        
        subgraph "Configuration"
            NUM_IND["numberIndividuals<br/>Sample Size"]
            SEED["seed parameter<br/>Reproducibility"]
            CONNECTION["con parameter<br/>Database Connection"]
        end
    end
    
    MOCK_FUNC --> PERSON_T
    MOCK_FUNC --> OBS_PERIOD
    MOCK_FUNC --> CONDITION
    MOCK_FUNC --> DRUG_EXP
    MOCK_FUNC --> COHORT1
    MOCK_FUNC --> COHORT2
    
    NUM_IND --> MOCK_FUNC
    SEED --> MOCK_FUNC
    CONNECTION --> MOCK_FUNC
    
    subgraph "Cleanup"
        DISCONNECT["mockDisconnect()<br/>R/mockPatientProfiles.R:384"]
    end
```

Sources: [R/mockPatientProfiles.R:42-340](), [R/mockPatientProfiles.R:384-391]()

## Essential Usage Patterns

### Basic Demographics Addition

The most common pattern is using `addDemographics()` to add comprehensive patient information:

```r
# Complete demographics package
cdm$cohort1 |>
  addDemographics(
    indexDate = "cohort_start_date",
    ageGroup = list(c(0, 18), c(19, 65), c(66, 100))
  )
```

### Individual Characteristic Functions

For specific needs, individual functions provide focused functionality:

```r
# Age only
cdm$condition_occurrence |>
  addAge(indexDate = "condition_start_date")

# Sex information
cdm$cohort1 |>
  addSex()

# Observation periods
cdm$cohort1 |>
  addPriorObservation() |>
  addFutureObservation()
```

Sources: [README.md:183-191](), [README.md:105-122](), [tests/testthat/test-addDemographics.R:157-179]()

### Test Environment Setup

Creating and managing mock data environments follows this pattern:

```r
# Create test environment
cdm <- mockPatientProfiles(
  numberIndividuals = 100,
  seed = 123
)

# Use the mock data
result <- cdm$cohort1 |>
  addDemographics()

# Clean up
mockDisconnect(cdm)
```

Sources: [R/mockPatientProfiles.R:32-41](), [tests/testthat/test-addDemographics.R:25-30]()

## Function Name Mapping

PatientProfiles exports 57 functions organized into logical groups. The essential functions for getting started are:

| Function Category | Core Functions | Purpose |
|-------------------|----------------|---------|
| Complete Demographics | `addDemographics` | Add multiple characteristics |
| Individual Age | `addAge` | Age calculation only |
| Individual Sex | `addSex` | Gender information only |
| Observation Periods | `addPriorObservation`, `addFutureObservation` | Temporal constraints |
| Test Environment | `mockPatientProfiles`, `mockDisconnect` | Development support |

Sources: [NAMESPACE:3-53](), [_pkgdown.yml:16-28]()

## Integration with OMOP CDM

PatientProfiles integrates with the broader OMOP ecosystem through standardized interfaces. The package depends on `CDMConnector` for database connections and `omopgenerics` for CDM standards compliance.

```mermaid
graph TB
    subgraph "OMOP CDM Integration"
        CDM_CONN["CDMConnector >= 1.3.1<br/>Database Interface"]
        OMOP_GEN["omopgenerics >= 1.0.0<br/>CDM Standards"]
        
        subgraph "PatientProfiles Core"
            PP_FUNCTIONS["PatientProfiles Functions<br/>Demographics & Intersections"]
            VALIDATION["Input Validation<br/>checks.R system"]
        end
        
        subgraph "Database Support"
            POSTGRES["PostgreSQL<br/>Production"]
            DUCKDB["DuckDB<br/>Development"]
            SQL_SERVER["SQL Server<br/>Enterprise"]
        end
    end
    
    CDM_CONN --> PP_FUNCTIONS
    OMOP_GEN --> VALIDATION
    VALIDATION --> PP_FUNCTIONS
    
    POSTGRES --> CDM_CONN
    DUCKDB --> CDM_CONN
    SQL_SERVER --> CDM_CONN
```

Sources: [DESCRIPTION:53-62](), [README.md:68-85]()

This Getting Started guide covers the essential functions needed to begin using PatientProfiles effectively. For more complex intersection operations with cohorts and concepts, proceed to [Core Features](#3). For specialized analysis patterns, see [Data Summarization](#3.2) and [Advanced Features](#4).