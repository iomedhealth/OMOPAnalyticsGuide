# Page: Patient Demographics

# Patient Demographics

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/addDemographics.R](R/addDemographics.R)
- [R/mockPatientProfiles.R](R/mockPatientProfiles.R)
- [man/addAge.Rd](man/addAge.Rd)
- [man/addDemographics.Rd](man/addDemographics.Rd)
- [man/addFutureObservation.Rd](man/addFutureObservation.Rd)
- [man/addInObservation.Rd](man/addInObservation.Rd)
- [man/addPriorObservation.Rd](man/addPriorObservation.Rd)
- [man/addSex.Rd](man/addSex.Rd)
- [tests/testthat/test-addAttributes.R](tests/testthat/test-addAttributes.R)
- [tests/testthat/test-addDemographics.R](tests/testthat/test-addDemographics.R)
- [tests/testthat/test-addFutureObservation.R](tests/testthat/test-addFutureObservation.R)
- [tests/testthat/test-addInObservation.R](tests/testthat/test-addInObservation.R)
- [tests/testthat/test-addPriorObservation.R](tests/testthat/test-addPriorObservation.R)
- [tests/testthat/test-addSex.R](tests/testthat/test-addSex.R)

</details>



This document covers the functions and systems for adding demographic information to OMOP CDM tables, including age, sex, and observation period characteristics. These functions enrich patient data with essential demographic context needed for clinical analyses.

For data intersection and temporal analysis capabilities, see [Data Intersection System](#3.1). For statistical summarization of demographic characteristics, see [Data Summarization](#3.2).

## Purpose and Scope

The Patient Demographics system provides a comprehensive set of functions to calculate and add demographic characteristics to any CDM table containing patient identifiers. The system handles:

- Age calculation at specific index dates with missing birth date imputation
- Sex determination from OMOP gender concepts  
- Observation period analysis (prior and future observation time)
- Date of birth extraction with flexible missing value handling
- Age group categorization for analysis stratification

## Core Function Architecture

```mermaid
graph TB
    subgraph "Public API Functions"
        DEMOGRAPHICS["addDemographics()"]
        AGE["addAge()"] 
        SEX["addSex()"]
        PRIOR["addPriorObservation()"]
        FUTURE["addFutureObservation()"]
        IN_OBS["addInObservation()"]
        DOB["addDateOfBirth()"]
    end
    
    subgraph "Internal Processing"
        DEMO_QUERY[".addDemographicsQuery()"]
        IN_OBS_QUERY[".addInObservationQuery()"]
        VALIDATION["Input Validation"]
        COMPUTE["computeTable()"]
    end
    
    subgraph "OMOP CDM Tables"
        PERSON["person"]
        OBS_PERIOD["observation_period"] 
        INPUT_TABLE["Input Table<br/>(cohort, condition_occurrence, etc.)"]
    end
    
    DEMOGRAPHICS --> DEMO_QUERY
    AGE --> DEMO_QUERY
    SEX --> DEMO_QUERY
    PRIOR --> DEMO_QUERY
    FUTURE --> DEMO_QUERY
    DOB --> DEMO_QUERY
    
    IN_OBS --> IN_OBS_QUERY
    
    DEMO_QUERY --> VALIDATION
    IN_OBS_QUERY --> VALIDATION
    VALIDATION --> COMPUTE
    
    DEMO_QUERY --> PERSON
    DEMO_QUERY --> OBS_PERIOD
    DEMO_QUERY --> INPUT_TABLE
    
    IN_OBS_QUERY --> OBS_PERIOD
    IN_OBS_QUERY --> INPUT_TABLE
    
    COMPUTE --> INPUT_TABLE
```

Sources: [R/addDemographics.R:67-114](), [R/addDemographics.R:144-179]()

## Primary Functions

### addDemographics()

The comprehensive function for adding multiple demographic characteristics simultaneously. It serves as the main entry point and can selectively enable/disable specific demographic calculations.

**Key Parameters:**
- `indexDate`: Date column for calculations (default: `"cohort_start_date"`)
- `age`: Boolean to include age calculation
- `sex`: Boolean to include sex determination  
- `priorObservation`: Boolean to include prior observation days
- `futureObservation`: Boolean to include future observation days
- `ageGroup`: List of age ranges for categorization

```mermaid
graph LR
    INPUT["Input Table<br/>person_id/subject_id<br/>+ indexDate"]
    DEMOGRAPHICS["addDemographics()"]
    OUTPUT["Enhanced Table<br/>+ age, sex<br/>+ prior_observation<br/>+ future_observation"]
    
    INPUT --> DEMOGRAPHICS
    DEMOGRAPHICS --> OUTPUT
```

Sources: [R/addDemographics.R:17-114](), [man/addDemographics.Rd:6-30]()

### Individual Demographic Functions

Each demographic aspect can be added independently:

| Function | Purpose | Default Column | Key Features |
|----------|---------|---------------|--------------|
| `addAge()` | Age calculation | `"age"` | Missing date imputation, age groups |
| `addSex()` | Sex determination | `"sex"` | OMOP concept mapping, missing value handling |
| `addPriorObservation()` | Prior observation time | `"prior_observation"` | Days or date format options |
| `addFutureObservation()` | Future observation time | `"future_observation"` | Days or date format options |
| `addInObservation()` | Observation status flag | `"in_observation"` | Window-based assessment |
| `addDateOfBirth()` | Date of birth | `"date_of_birth"` | Missing month/day imputation |

Sources: [R/addDemographics.R:116-179](), [R/addDemographics.R:344-394](), [R/addDemographics.R:422-454]()

## Age Calculation System

```mermaid
graph TD
    INDEX_DATE["Index Date<br/>(e.g., cohort_start_date)"]
    PERSON_DATA["Person Table<br/>year_of_birth<br/>month_of_birth<br/>day_of_birth"]
    
    subgraph "Missing Value Handling"
        MISSING_MONTH["ageMissingMonth<br/>(default: 1)"]
        MISSING_DAY["ageMissingDay<br/>(default: 1)"] 
        IMPOSE_MONTH["ageImposeMonth<br/>(treat all months as missing)"]
        IMPOSE_DAY["ageImposeDay<br/>(treat all days as missing)"]
    end
    
    subgraph "Age Processing"
        DOB_CONSTRUCT["Construct Date of Birth<br/>Handle Missing Values"]
        AGE_CALC["Calculate Age<br/>(indexDate - dateOfBirth)"]
        AGE_GROUP["Optional Age Groups<br/>Categorization"]
    end
    
    OUTPUT_AGE["Age Column(s)<br/>+ Optional Age Groups"]
    
    INDEX_DATE --> DOB_CONSTRUCT
    PERSON_DATA --> DOB_CONSTRUCT
    MISSING_MONTH --> DOB_CONSTRUCT
    MISSING_DAY --> DOB_CONSTRUCT
    IMPOSE_MONTH --> DOB_CONSTRUCT
    IMPOSE_DAY --> DOB_CONSTRUCT
    
    DOB_CONSTRUCT --> AGE_CALC
    AGE_CALC --> AGE_GROUP
    AGE_GROUP --> OUTPUT_AGE
```

**Age Imputation Logic:**
- Missing months default to January (1)  
- Missing days default to 1st of month
- `ageImposeMonth`/`ageImposeDay` force all births to use default values for consistency
- Age groups automatically categorize ages into ranges like `"0 to 40"`, `"41 or above"`

Sources: [R/addDemographics.R:116-179](), [tests/testthat/test-addDemographics.R:514-574]()

## Sex Determination System

```mermaid
graph LR
    GENDER_CONCEPT["gender_concept_id<br/>(from person table)"]
    
    subgraph "OMOP Concept Mapping"
        MALE["8507 → 'Male'"]
        FEMALE["8532 → 'Female'"]
        UNKNOWN["0, NULL, Other → missingSexValue"]
    end
    
    SEX_OUTPUT["Sex Column<br/>Values: Male/Female/None"]
    
    GENDER_CONCEPT --> MALE
    GENDER_CONCEPT --> FEMALE  
    GENDER_CONCEPT --> UNKNOWN
    
    MALE --> SEX_OUTPUT
    FEMALE --> SEX_OUTPUT
    UNKNOWN --> SEX_OUTPUT
```

The system maps OMOP standard gender concept IDs to human-readable sex values, with configurable handling for missing or non-standard values.

Sources: [R/addDemographics.R:344-394](), [tests/testthat/test-addSex.R:24-63]()

## Observation Period Analysis

```mermaid
graph TB
    subgraph "Input Data"
        INDEX["Index Date"]
        OBS_PERIOD["observation_period table<br/>observation_period_start_date<br/>observation_period_end_date"]
    end
    
    subgraph "Temporal Calculations"
        PRIOR_CALC["Prior Observation<br/>indexDate - obs_period_start_date"]
        FUTURE_CALC["Future Observation<br/>obs_period_end_date - indexDate"]
        IN_OBS_CALC["In Observation<br/>Check if indexDate within period"]
    end
    
    subgraph "Output Options"
        DAYS_FORMAT["Days Format<br/>(numeric)"]
        DATE_FORMAT["Date Format<br/>(actual dates)"]
        BINARY_FLAG["Binary Flag<br/>(0/1 for in observation)"]
    end
    
    INDEX --> PRIOR_CALC
    INDEX --> FUTURE_CALC
    INDEX --> IN_OBS_CALC
    
    OBS_PERIOD --> PRIOR_CALC
    OBS_PERIOD --> FUTURE_CALC
    OBS_PERIOD --> IN_OBS_CALC
    
    PRIOR_CALC --> DAYS_FORMAT
    PRIOR_CALC --> DATE_FORMAT
    FUTURE_CALC --> DAYS_FORMAT
    FUTURE_CALC --> DATE_FORMAT
    IN_OBS_CALC --> BINARY_FLAG
```

**Key Behaviors:**
- Multiple observation periods: Uses the most relevant period containing the index date
- Outside observation periods: Returns `NA` for prior/future calculations
- Window support: `addInObservation()` supports time windows around index dates

Sources: [R/addDemographics.R:181-342](), [tests/testthat/test-addDemographics.R:351-416]()

## Data Processing Pipeline

```mermaid
graph TD
    INPUT_TABLE["Input Table<br/>subject_id/person_id<br/>+ index_date"]
    
    subgraph "Validation Layer"
        CHECK_TABLE["Validate Table Structure"]
        CHECK_PARAMS["Validate Parameters"]
        CHECK_COLUMNS["Check Required Columns"]
    end
    
    subgraph "Core Processing"
        JOIN_PERSON["Join with person table<br/>Get birth info, gender_concept_id"]
        JOIN_OBS["Join with observation_period<br/>Get temporal boundaries"]
        APPLY_LOGIC["Apply Business Logic<br/>Age calc, sex mapping, etc."]
    end
    
    subgraph "Output Generation"
        ADD_COLUMNS["Add New Columns<br/>age, sex, prior_observation, etc."]
        COMPUTE_TABLE["computeTable()<br/>Materialize Results"]
        FINAL_OUTPUT["Enhanced Table<br/>Original + Demographics"]
    end
    
    INPUT_TABLE --> CHECK_TABLE
    CHECK_TABLE --> CHECK_PARAMS
    CHECK_PARAMS --> CHECK_COLUMNS
    
    CHECK_COLUMNS --> JOIN_PERSON
    JOIN_PERSON --> JOIN_OBS
    JOIN_OBS --> APPLY_LOGIC
    
    APPLY_LOGIC --> ADD_COLUMNS
    ADD_COLUMNS --> COMPUTE_TABLE
    COMPUTE_TABLE --> FINAL_OUTPUT
```

The system uses lazy evaluation through database queries until `computeTable()` materializes the results, enabling efficient processing of large datasets.

Sources: [R/addDemographics.R:89-113](), [tests/testthat/test-addDemographics.R:23-42]()

## Integration Patterns

### Cohort Table Enhancement
```r
# Basic demographic enrichment
cdm$cohort1 |> addDemographics()

# Selective demographics with custom parameters  
cdm$cohort1 |>
  addDemographics(
    indexDate = "cohort_end_date",
    ageGroup = list("adult" = list(c(18, 64), c(65, Inf))),
    sex = TRUE,
    priorObservation = FALSE
  )
```

### Clinical Table Enhancement  
```r
# Add demographics to condition occurrences
cdm$condition_occurrence |>
  addDemographics(indexDate = "condition_start_date")

# Chain with other PatientProfiles functions
cdm$drug_exposure |>
  addAge(indexDate = "drug_exposure_start_date") |>
  addTableIntersectCount(tableName = "condition_occurrence")
```

Sources: [tests/testthat/test-addDemographics.R:44-81](), [tests/testthat/test-addDemographics.R:148-249]()

## Testing Infrastructure

The system includes comprehensive testing through `mockPatientProfiles()` which creates realistic test data:

- **Mock CDM Generation**: Creates person, observation_period, and clinical tables
- **Edge Case Testing**: Missing values, multiple observation periods, date boundaries  
- **Integration Testing**: Verification with different CDM table types
- **Performance Testing**: Large dataset handling validation

Sources: [R/mockPatientProfiles.R:17-41](), [tests/testthat/test-addDemographics.R:1-22]()