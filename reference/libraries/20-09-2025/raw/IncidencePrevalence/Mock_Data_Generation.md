# Page: Mock Data Generation

# Mock Data Generation

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [tests/testthat/test-estimatePrevalence.R](tests/testthat/test-estimatePrevalence.R)
- [tests/testthat/test-tables.R](tests/testthat/test-tables.R)

</details>



The mock data generation system provides utilities for creating synthetic OMOP Common Data Model (CDM) databases specifically designed for testing incidence and prevalence calculations. This system enables comprehensive testing of analysis functions without requiring access to real patient data.

For information about the main testing framework that uses these utilities, see [Testing Framework](#10.1). For details about the core analysis functions being tested, see [Main Analysis Functions](#9.1).

## Overview and Purpose

The `mockIncidencePrevalence()` function serves as the primary entry point for generating synthetic CDM databases that conform to OMOP CDM standards. This mock data generation system creates controlled datasets with known characteristics, enabling systematic testing of epidemiological calculations, edge cases, and statistical validations.

```mermaid
graph TB
    subgraph "Mock Data Generation System"
        MOCK[mockIncidencePrevalence]
        CONFIG["Configuration Parameters"]
        
        subgraph "Generated Tables"
            PERSON["person table"]
            OBSPER["observation_period table"]
            OUTCOME["outcome cohort table"]
            TARGET["target cohort table"]
        end
        
        subgraph "CDM Structure"
            CDM["CDM Reference Object"]
            ATTR["Cohort Attributes"]
            META["Metadata"]
        end
    end
    
    subgraph "Testing Framework"
        TESTS["Test Cases"]
        PREV["Prevalence Tests"]
        INC["Incidence Tests"]
        VALID["Validation Tests"]
    end
    
    CONFIG --> MOCK
    MOCK --> PERSON
    MOCK --> OBSPER
    MOCK --> OUTCOME
    MOCK --> TARGET
    
    PERSON --> CDM
    OBSPER --> CDM
    OUTCOME --> CDM
    TARGET --> CDM
    
    CDM --> ATTR
    CDM --> META
    
    CDM --> TESTS
    TESTS --> PREV
    TESTS --> INC
    TESTS --> VALID
```

Sources: [tests/testthat/test-estimatePrevalence.R:1-38](), [tests/testthat/test-estimatePrevalence.R:70-74]()

## Core Mock Data Generation Function

The `mockIncidencePrevalence()` function creates a complete CDM reference object with synthetic data. The function accepts both predefined table structures and generation parameters for creating randomized datasets.

### Function Signature and Parameters

The mock data generator supports multiple configuration approaches:

| Parameter | Type | Purpose |
|-----------|------|---------|
| `personTable` | tibble | Custom person demographics data |
| `observationPeriodTable` | tibble | Custom observation periods |
| `outcomeTable` | tibble | Custom outcome cohort events |
| `targetCohortTable` | tibble | Custom target cohort definitions |
| `sampleSize` | integer | Number of synthetic persons to generate |
| `maxOutcomeDays` | integer | Maximum days for outcome events |
| `maxOutcomes` | integer | Maximum number of outcomes per person |
| `outPre` | numeric | Outcome prevalence rate |

```mermaid
flowchart TD
    START["mockIncidencePrevalence()"]
    
    subgraph "Input Options"
        CUSTOM["Custom Tables Provided"]
        PARAMS["Generation Parameters"]
    end
    
    subgraph "Table Generation"
        GENPERSON["Generate person table"]
        GENOBS["Generate observation_period"]
        GENOUT["Generate outcome cohort"]
        GENTARGET["Generate target cohort"]
    end
    
    subgraph "CDM Assembly"
        CREATECDM["Create CDM Reference"]
        ADDATTR["Add Cohort Attributes"]
        ADDMETA["Add Metadata"]
    end
    
    RESULT["CDM Reference Object"]
    
    START --> CUSTOM
    START --> PARAMS
    
    CUSTOM --> CREATECDM
    PARAMS --> GENPERSON
    PARAMS --> GENOBS
    PARAMS --> GENOUT
    PARAMS --> GENTARGET
    
    GENPERSON --> CREATECDM
    GENOBS --> CREATECDM
    GENOUT --> CREATECDM
    GENTARGET --> CREATECDM
    
    CREATECDM --> ADDATTR
    ADDATTR --> ADDMETA
    ADDMETA --> RESULT
```

Sources: [tests/testthat/test-estimatePrevalence.R:42-68](), [tests/testthat/test-estimatePrevalence.R:698-700]()

## Mock CDM Structure

The generated CDM reference object contains all necessary tables and attributes required for incidence and prevalence analysis. The structure follows OMOP CDM conventions with additional cohort-specific metadata.

### Generated Table Structure

```mermaid
erDiagram
    person {
        integer person_id PK
        integer gender_concept_id
        integer year_of_birth
        integer month_of_birth
        integer day_of_birth
    }
    
    observation_period {
        integer observation_period_id PK
        integer person_id FK
        date observation_period_start_date
        date observation_period_end_date
    }
    
    outcome {
        integer cohort_definition_id
        integer subject_id FK
        date cohort_start_date
        date cohort_end_date
    }
    
    target {
        integer cohort_definition_id
        integer subject_id FK
        date cohort_start_date
        date cohort_end_date
    }
    
    person ||--o{ observation_period : "has"
    person ||--o{ outcome : "experiences"
    person ||--o{ target : "belongs_to"
```

Sources: [tests/testthat/test-estimatePrevalence.R:42-48](), [tests/testthat/test-estimatePrevalence.R:49-54](), [tests/testthat/test-estimatePrevalence.R:55-68]()

## Testing Usage Patterns

The mock data generation system supports various testing scenarios through different configuration patterns. Each pattern serves specific validation purposes within the testing framework.

### Basic Mock Data Creation

The simplest usage creates a default CDM with randomized data:

```mermaid
sequenceDiagram
    participant Test as Test Case
    participant Mock as mockIncidencePrevalence
    participant CDM as CDM Reference
    participant Gen as generateDenominatorCohortSet
    participant Analysis as Analysis Function
    
    Test->>Mock: mockIncidencePrevalence()
    Mock->>CDM: Create CDM with default data
    CDM-->>Test: Return CDM reference
    Test->>Gen: generateDenominatorCohortSet(cdm, "denominator")
    Gen-->>Test: Return CDM with denominator
    Test->>Analysis: estimatePrevalence(cdm, ...)
    Analysis-->>Test: Return results
```

Sources: [tests/testthat/test-estimatePrevalence.R:2-3]()

### Custom Data Scenarios

For specific test cases, custom table data enables precise control over test conditions:

| Test Scenario | Custom Tables Used | Purpose |
|---------------|-------------------|---------|
| Single person analysis | `personTable`, `observationPeriodTable`, `outcomeTable` | Test basic calculations |
| Multiple observation periods | `observationPeriodTable` with gaps | Test temporal discontinuity |
| Minimum count validation | Large `personTable` with controlled outcomes | Test statistical thresholds |
| Empty cohort testing | `outcomeTable` with no matching IDs | Test edge case handling |

Sources: [tests/testthat/test-estimatePrevalence.R:42-90](), [tests/testthat/test-estimatePrevalence.R:149-266]()

### Large-Scale Testing

For performance and statistical validation, the system supports large synthetic datasets:

```mermaid
graph LR
    subgraph "Large Scale Testing"
        SIZE["sampleSize = 1000+"]
        OUTCOMES["Multiple Outcomes"]
        STRATA["Stratification Variables"]
    end
    
    subgraph "Validation Targets"
        CI["Confidence Intervals"]
        ATTRITION["Attrition Reporting"]
        PERFORMANCE["Performance Benchmarks"]
    end
    
    SIZE --> CI
    OUTCOMES --> ATTRITION
    STRATA --> CI
    STRATA --> ATTRITION
    
    CI --> PERFORMANCE
    ATTRITION --> PERFORMANCE
```

Sources: [tests/testthat/test-estimatePrevalence.R:1035-1079](), [tests/testthat/test-estimatePrevalence.R:1197-1217]()

## Configuration Options and Advanced Features

The mock data generation system provides sophisticated configuration options for testing complex scenarios including multiple cohorts, stratification variables, and temporal patterns.

### Multiple Cohort Testing

The system supports testing with multiple denominator and outcome cohorts:

```mermaid
flowchart TD
    MOCKDATA["mockIncidencePrevalence(sampleSize=6000)"]
    
    subgraph "Multiple Denominators"
        DENOM1["denominator_1<br/>Age: 25-50<br/>Sex: Both"]
        DENOM2["denominator_2<br/>Multiple age groups<br/>Multiple sexes"]
    end
    
    subgraph "Multiple Outcomes"
        OUT1["outcome cohort_1"]
        OUT2["outcome cohort_2"]
    end
    
    subgraph "Analysis Comparison"
        PREV1["estimatePrevalence(denominator_1)"]
        PREV2["estimatePrevalence(denominator_2)"]
        COMPARE["Result Comparison"]
    end
    
    MOCKDATA --> DENOM1
    MOCKDATA --> DENOM2
    MOCKDATA --> OUT1
    MOCKDATA --> OUT2
    
    DENOM1 --> PREV1
    DENOM2 --> PREV2
    OUT1 --> PREV1
    OUT2 --> PREV2
    
    PREV1 --> COMPARE
    PREV2 --> COMPARE
```

Sources: [tests/testthat/test-estimatePrevalence.R:696-739]()

### Stratification Testing

Mock data supports testing of stratification variables by allowing custom columns in generated cohorts:

```mermaid
graph TB
    subgraph "Mock Data with Strata"
        BASEDATA["Base Mock CDM"]
        ADDSTRATA["Add Stratification Variables"]
        STRATADATA["CDM with Strata Columns"]
    end
    
    subgraph "Strata Variables"
        MYSTRATA["my_strata: first/second"]
        MYSTRATA2["my_strata2: a/b"]
        COMBINED["Combined Strata"]
    end
    
    subgraph "Analysis Results"
        OVERALL["Overall Results"]
        SINGLE["Single Strata Results"]
        MULTI["Multi-Strata Results"]
    end
    
    BASEDATA --> ADDSTRATA
    ADDSTRATA --> STRATADATA
    
    STRATADATA --> MYSTRATA
    STRATADATA --> MYSTRATA2
    MYSTRATA --> COMBINED
    MYSTRATA2 --> COMBINED
    
    STRATADATA --> OVERALL
    MYSTRATA --> SINGLE
    COMBINED --> MULTI
```

Sources: [tests/testthat/test-estimatePrevalence.R:1265-1413]()

## Integration with Testing Framework

The mock data generation system integrates seamlessly with the broader testing framework, enabling comprehensive validation of analysis functions across multiple scenarios and edge cases.

### Database Backend Testing

Mock data works with different database backends supported by the package:

| Backend | Usage Pattern | Testing Focus |
|---------|---------------|---------------|
| DuckDB (default) | In-memory testing | Fast iteration, basic functionality |
| Local CDM | `cdm \|> dplyr::collect()` | Non-database analysis validation |
| Permanent tables | `temporary = FALSE` | Performance and persistence testing |

Sources: [tests/testthat/test-estimatePrevalence.R:1503-1551](), [tests/testthat/test-estimatePrevalence.R:1193-1217]()

### Error and Edge Case Testing

The mock system enables systematic testing of error conditions and edge cases:

```mermaid
flowchart TD
    subgraph "Edge Case Testing"
        EMPTY["Empty Cohorts"]
        MISSING["Missing Attributes"]
        INVALID["Invalid Parameters"]
        BOUNDARY["Boundary Conditions"]
    end
    
    subgraph "Mock Data Configurations"
        EMPTYTABLE["Empty outcome table"]
        NOATTR["Missing cohort_set attributes"]
        BADPARAMS["Invalid cohort IDs"]
        MINDATA["Minimal data sets"]
    end
    
    subgraph "Expected Behaviors"
        ERRORS["Appropriate Error Messages"]
        GRACEFUL["Graceful Degradation"]
        VALIDATION["Input Validation"]
    end
    
    EMPTY --> EMPTYTABLE
    MISSING --> NOATTR
    INVALID --> BADPARAMS
    BOUNDARY --> MINDATA
    
    EMPTYTABLE --> GRACEFUL
    NOATTR --> ERRORS
    BADPARAMS --> VALIDATION
    MINDATA --> VALIDATION
```

Sources: [tests/testthat/test-estimatePrevalence.R:1219-1243](), [tests/testthat/test-estimatePrevalence.R:1245-1263](), [tests/testthat/test-estimatePrevalence.R:796-842]()