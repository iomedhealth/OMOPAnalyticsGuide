# Page: Utility and Helper Functions

# Utility and Helper Functions

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/inputValidation.R](R/inputValidation.R)
- [R/mockMGUS2cdm.R](R/mockMGUS2cdm.R)
- [man/addCohortSurvival.Rd](man/addCohortSurvival.Rd)

</details>



This page documents the supporting functions in CohortSurvival that facilitate data validation, mock data generation, and internal processing. These functions work behind the scenes to ensure data integrity and provide testing capabilities for the core survival analysis functions.

For information about the primary survival estimation functions, see [Core Survival Analysis Functions](#2). For details about data preparation with `addCohortSurvival`, see [Data Preparation with addCohortSurvival](#2.3).

## Overview of Utility Function Categories

The CohortSurvival package includes several categories of utility functions that support the main survival analysis workflow:

```mermaid
graph TD
    subgraph "Mock Data Generation"
        MockMGUS["mockMGUS2cdm()"]
        AddAttr["addAttrition()"]
    end
    
    subgraph "Input Validation"
        CheckCohort["checkCohortId()"]
        CheckExposure["checkExposureCohortId()"]  
        CheckCensor["checkCensorOnDate()"]
    end
    
    subgraph "Core Analysis Functions"
        EstSingle["estimateSingleEventSurvival()"]
        EstComp["estimateCompetingRiskSurvival()"]
        AddSurv["addCohortSurvival()"]
    end
    
    MockMGUS --> EstSingle
    MockMGUS --> EstComp
    MockMGUS --> AddSurv
    
    CheckCohort --> AddSurv
    CheckExposure --> AddSurv
    CheckCensor --> AddSurv
    
    AddAttr --> MockMGUS
```

**Sources**: [R/mockMGUS2cdm.R:1-226](), [R/inputValidation.R:1-53]()

## Mock Data Generation Functions

### mockMGUS2cdm Function

The `mockMGUS2cdm()` function creates a complete CDM reference object using the well-known MGUS (Monoclonal Gammopathy of Undetermined Significance) dataset from the survival package. This function is essential for examples, testing, and demonstrations.

| Function | Purpose | Return Type |
|----------|---------|-------------|
| `mockMGUS2cdm()` | Creates CDM reference with MGUS survival data | CDM reference object |

#### Data Transformation Process

```mermaid
flowchart TD
    MGUS2["`survival::mgus2
    Raw Dataset`"] --> Transform["Data Transformation
    - Convert dates
    - Create cohort tables  
    - Add OMOP structure"]
    
    Transform --> DiagCohort["mgus_diagnosis
    Target Cohort"]
    Transform --> ProgCohort["progression
    Outcome Cohort"]
    Transform --> DeathCohort["death_cohort
    Competing Risk"]
    Transform --> ProgType["progression_type
    Multiple Outcomes"]
    
    Transform --> PersonTable["person
    OMOP CDM Table"]
    Transform --> ObsPeriod["observation_period
    OMOP CDM Table"]
    Transform --> VisitOcc["visit_occurrence
    OMOP CDM Table"]
    
    DiagCohort --> CDMRef["CDM Reference Object"]
    ProgCohort --> CDMRef
    DeathCohort --> CDMRef
    ProgType --> CDMRef
    PersonTable --> CDMRef
    ObsPeriod --> CDMRef
    VisitOcc --> CDMRef
```

**Sources**: [R/mockMGUS2cdm.R:27-192]()

The function performs several key transformations:

1. **Date Calculations**: Converts the original time variables into proper date columns
2. **Cohort Creation**: Generates multiple cohort tables for different survival scenarios
3. **OMOP Compliance**: Structures data according to OMOP CDM standards
4. **Database Setup**: Creates an in-memory DuckDB database for testing

#### Cohort Tables Generated

| Cohort Table | Description | Cohort IDs |
|--------------|-------------|------------|
| `mgus_diagnosis` | Target cohort with MGUS diagnosis | 1 |
| `progression` | Single progression outcome | 1 |
| `progression_type` | Multiple progression types | 1, 2, 3 |
| `death_cohort` | Death as competing risk | 1 |

**Sources**: [R/mockMGUS2cdm.R:47-124]()

### addAttrition Helper Function

The internal `addAttrition()` function creates cohort attrition tables that comply with omopgenerics standards:

```mermaid
graph LR
    Cohort["Cohort Table"] --> CalcStats["Calculate
    - number_records
    - number_subjects"]
    CalcStats --> AddMeta["Add Metadata
    - reason_id
    - reason
    - excluded counts"]
    AddMeta --> AttritionTable["Cohort Attrition Table"]
```

**Sources**: [R/mockMGUS2cdm.R:194-225]()

## Input Validation Functions

The package includes several validation functions that ensure data integrity and prevent common errors during survival analysis.

### Validation Function Overview

```mermaid
graph TD
    subgraph "Validation Types"
        CohortVal["Cohort ID Validation"]
        ExposureVal["Exposure Cohort Validation"] 
        CensorVal["Censoring Date Validation"]
    end
    
    subgraph "Validation Functions"
        CheckCohortId["checkCohortId()"]
        CheckExposureCohortId["checkExposureCohortId()"]
        CheckCensorOnDate["checkCensorOnDate()"]
    end
    
    CohortVal --> CheckCohortId
    ExposureVal --> CheckExposureCohortId
    CensorVal --> CheckCensorOnDate
    
    CheckCohortId --> AddSurvival["addCohortSurvival()"]
    CheckExposureCohortId --> AddSurvival
    CheckCensorOnDate --> AddSurvival
```

**Sources**: [R/inputValidation.R:17-52]()

### checkCohortId Function

Validates that specified cohort IDs exist in the cohort table:

| Parameter | Type | Description |
|-----------|------|-------------|
| `cohort` | cohort table | Cohort table to validate against |
| `cohortId` | integer vector | Cohort IDs to check |

**Validation Logic**:
- Checks that `cohortId` is an integer vector
- Verifies all specified IDs exist in the cohort settings
- Returns boolean indicating validity

**Sources**: [R/inputValidation.R:17-26]()

### checkExposureCohortId Function

Ensures the exposure cohort contains only one unique cohort definition ID:

```mermaid
graph TD
    ExposureCohort["Exposure Cohort"] --> ExtractIds["Extract
    cohort_definition_id"]
    ExtractIds --> CheckUnique{"Is Unique?"}
    CheckUnique -->|Yes| Valid["Validation Passes"]
    CheckUnique -->|No| Error["cli::cli_abort()
    Error Message"]
```

This validation prevents issues during survival analysis where multiple exposure cohorts could cause ambiguous results.

**Sources**: [R/inputValidation.R:28-39]()

### checkCensorOnDate Function

Validates that the censoring date is appropriate for the cohort data:

| Validation | Logic |
|------------|-------|
| Date comparison | `max(cohort$cohort_start_date) <= censorOnDate` |
| Error condition | Any cohort start date after censor date |

**Sources**: [R/inputValidation.R:41-52]()

## Function Integration in Analysis Workflow

The utility functions integrate seamlessly into the main survival analysis workflow:

```mermaid
sequenceDiagram
    participant User
    participant MockData as "mockMGUS2cdm()"
    participant Validation as "Input Validation"
    participant Analysis as "Core Functions"
    
    User->>MockData: Create test data
    MockData-->>User: CDM reference
    
    User->>Analysis: Call survival function
    Analysis->>Validation: checkCohortId()
    Validation-->>Analysis: Validation result
    Analysis->>Validation: checkExposureCohortId()
    Validation-->>Analysis: Validation result
    Analysis->>Validation: checkCensorOnDate()
    Validation-->>Analysis: Validation result
    
    alt Validation Passes
        Analysis-->>User: Survival results
    else Validation Fails
        Analysis-->>User: Error message
    end
```

**Sources**: [R/mockMGUS2cdm.R:27-192](), [R/inputValidation.R:17-52]()

## Usage Patterns

### Testing and Development

The mock data function is primarily used for:
- **Package Examples**: Providing consistent test data for documentation
- **Unit Testing**: Creating reproducible test scenarios
- **User Experimentation**: Allowing users to explore functionality without their own data

### Input Validation Integration

The validation functions are called internally by core functions to:
- **Prevent Runtime Errors**: Catch invalid inputs before processing
- **Provide Clear Error Messages**: Use `cli::cli_abort()` for user-friendly errors
- **Ensure Data Consistency**: Validate assumptions about cohort structure

### Error Handling Strategy

```mermaid
graph TD
    FunctionCall["Function Call"] --> InputValidation["Input Validation"]
    InputValidation --> ValidCheck{"Valid Input?"}
    ValidCheck -->|Yes| ProcessData["Process Data"]
    ValidCheck -->|No| ErrorMsg["cli::cli_abort()
    Clear Error Message"]
    ProcessData --> Results["Return Results"]
    ErrorMsg --> Stop["Function Stops"]
```

**Sources**: [R/inputValidation.R:35-37](), [R/inputValidation.R:47-50]()

These utility and helper functions ensure the CohortSurvival package maintains high data quality standards while providing convenient testing capabilities for both developers and users.