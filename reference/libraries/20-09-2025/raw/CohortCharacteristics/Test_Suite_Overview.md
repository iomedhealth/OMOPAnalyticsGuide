# Page: Test Suite Overview

# Test Suite Overview

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [tests/testthat/test-plotCohortAttrition.R](tests/testthat/test-plotCohortAttrition.R)
- [tests/testthat/test-summariseCharacteristics.R](tests/testthat/test-summariseCharacteristics.R)

</details>



This document describes the organization, patterns, and infrastructure of the CohortCharacteristics package test suite. The test suite validates the core analysis functions, plotting capabilities, and integration with OMOP CDM structures through comprehensive unit tests using the `testthat` framework.

For information about the core analysis functions being tested, see [Core Analysis Workflow](#2). For details about package development practices, see [Package Development and Evolution](#5.2).

## Test Suite Architecture

The test suite follows a systematic approach to validate the three-tier analysis pattern (summarise → plot → table) that defines the package architecture. Tests are organized around functional domains and utilize mock OMOP CDM data to ensure consistent, reproducible testing environments.

```mermaid
flowchart TD
    subgraph "Test Suite Structure"
        MOCK["mockCohortCharacteristics()"]
        TESTDATA["Mock OMOP CDM Data"]
        
        subgraph "Core Function Tests"
            SUMM_TESTS["summariseCharacteristics Tests"]
            PLOT_TESTS["plotCohortAttrition Tests"] 
            TABLE_TESTS["Table Function Tests"]
        end
        
        subgraph "Test Categories"
            BASIC["Basic Functionality"]
            PARAMS["Parameter Validation"]
            EDGE["Edge Cases"]
            ERROR["Error Handling"]
            INTEGRATION["OMOP Integration"]
        end
        
        subgraph "Test Utilities"
            EXPECT["expect_* Assertions"]
            SETUP["Test Setup/Teardown"]
            VALIDATION["Result Validation"]
        end
    end
    
    MOCK --> TESTDATA
    TESTDATA --> SUMM_TESTS
    TESTDATA --> PLOT_TESTS
    TESTDATA --> TABLE_TESTS
    
    SUMM_TESTS --> BASIC
    SUMM_TESTS --> PARAMS
    SUMM_TESTS --> EDGE
    SUMM_TESTS --> ERROR
    SUMM_TESTS --> INTEGRATION
    
    PLOT_TESTS --> BASIC
    PLOT_TESTS --> PARAMS
    PLOT_TESTS --> EDGE
    PLOT_TESTS --> ERROR
    
    BASIC --> EXPECT
    PARAMS --> SETUP
    EDGE --> VALIDATION
    ERROR --> EXPECT
    INTEGRATION --> VALIDATION
```

**Sources:** [tests/testthat/test-summariseCharacteristics.R:1-100](), [tests/testthat/test-plotCohortAttrition.R:1-40]()

## Mock Data Infrastructure

The test suite relies heavily on `mockCohortCharacteristics()` to create standardized OMOP CDM test environments. This function generates realistic cohort tables, person demographics, observation periods, and clinical event tables that mirror real-world OMOP structures.

```mermaid
flowchart LR
    subgraph "Mock Data Creation"
        MOCK_FUNC["mockCohortCharacteristics()"]
        
        subgraph "OMOP CDM Tables"
            PERSON["person table"]
            COHORT["cohort tables"] 
            OBS_PERIOD["observation_period"]
            VISIT["visit_occurrence"]
            CONDITION["condition_occurrence"]
            DRUG["drug_exposure"]
        end
        
        subgraph "Test Cohorts"
            DUS_COHORT["dus_cohort"]
            COMORBID["comorbidities"]
            MEDICATION["medication"]
        end
        
        subgraph "CDM Reference"
            CDM_REF["CDM Reference Object"]
            TABLES["Linked Table References"]
            METADATA["OMOP Metadata"]
        end
    end
    
    MOCK_FUNC --> PERSON
    MOCK_FUNC --> COHORT
    MOCK_FUNC --> OBS_PERIOD
    MOCK_FUNC --> VISIT
    MOCK_FUNC --> CONDITION
    MOCK_FUNC --> DRUG
    
    PERSON --> DUS_COHORT
    COHORT --> COMORBID
    COHORT --> MEDICATION
    
    DUS_COHORT --> CDM_REF
    COMORBID --> TABLES
    MEDICATION --> METADATA
```

**Sources:** [tests/testthat/test-summariseCharacteristics.R:55-80](), [tests/testthat/test-summariseCharacteristics.R:529-555]()

## Core Testing Patterns

### Summarization Function Tests

The `summariseCharacteristics` tests follow a comprehensive pattern that validates input parameters, data processing, and output standardization:

| Test Category | Purpose | Key Validations |
|---------------|---------|-----------------|
| **Basic Functionality** | Core function operation | Result structure, data types, estimate calculations |
| **Parameter Combinations** | Input validation | `cohortIntersectFlag`, `demographics`, `otherVariables` |
| **Edge Cases** | Boundary conditions | Empty cohorts, missing data, single records |
| **Integration** | OMOP compliance | `summarised_result` format, settings metadata |

```mermaid
flowchart TD
    subgraph "summariseCharacteristics Test Flow"
        INPUT["Test Input Creation"]
        SETUP["CDM Setup with Mock Data"]
        
        subgraph "Test Execution"
            BASIC_CALL["Basic Function Call"]
            PARAM_TESTS["Parameter Validation"]
            EDGE_TESTS["Edge Case Testing"]
        end
        
        subgraph "Result Validation"
            STRUCTURE["Result Structure Check"]
            VALUES["Estimate Value Validation"]
            METADATA["Settings/Metadata Check"]
            FORMAT["OMOP Format Compliance"]
        end
        
        subgraph "Assertions"
            EXPECT_NO_ERROR["expect_no_error()"]
            EXPECT_TRUE["expect_true()"]
            EXPECT_IDENTICAL["expect_identical()"]
            EXPECT_ERROR["expect_error()"]
        end
    end
    
    INPUT --> SETUP
    SETUP --> BASIC_CALL
    SETUP --> PARAM_TESTS
    SETUP --> EDGE_TESTS
    
    BASIC_CALL --> STRUCTURE
    PARAM_TESTS --> VALUES
    EDGE_TESTS --> METADATA
    
    STRUCTURE --> EXPECT_TRUE
    VALUES --> EXPECT_IDENTICAL
    METADATA --> EXPECT_NO_ERROR
    FORMAT --> EXPECT_TRUE
```

**Sources:** [tests/testthat/test-summariseCharacteristics.R:81-93](), [tests/testthat/test-summariseCharacteristics.R:217-276]()

### Plot Function Tests

Plot function tests validate visualization output types and handle different data states, including empty results and edge cases:

```mermaid
flowchart LR
    subgraph "Plot Testing Pattern"
        ATTRITION_DATA["Cohort Attrition Data"]
        
        subgraph "Test Scenarios"
            NORMAL["Normal Data"]
            EMPTY["Empty Results"]
            WARNING["Warning Conditions"]
            ERROR["Error Conditions"]
        end
        
        subgraph "Output Validation"
            HTMLWIDGET["htmlwidget Check"]
            GRVIZ["grViz Object Check"]
            CLASS_CHECK["inherits() Validation"]
        end
        
        subgraph "Function Calls"
            PLOT_FUNC["plotCohortAttrition()"]
            EXPECT_WARN["expect_warning()"]
            EXPECT_ERR["expect_error()"]
        end
    end
    
    ATTRITION_DATA --> NORMAL
    ATTRITION_DATA --> EMPTY
    ATTRITION_DATA --> WARNING
    ATTRITION_DATA --> ERROR
    
    NORMAL --> PLOT_FUNC
    EMPTY --> EXPECT_WARN
    WARNING --> EXPECT_WARN
    ERROR --> EXPECT_ERR
    
    PLOT_FUNC --> HTMLWIDGET
    PLOT_FUNC --> GRVIZ
    PLOT_FUNC --> CLASS_CHECK
```

**Sources:** [tests/testthat/test-plotCohortAttrition.R:11-25](), [tests/testthat/test-plotCohortAttrition.R:34-40]()

## Test Coverage Areas

### Cohort Intersection Analysis

Tests extensively validate cohort intersection functionality across multiple dimensions:

| Intersection Type | Test Coverage | Key Functions |
|------------------|---------------|---------------|
| **Flag Intersections** | `cohortIntersectFlag` parameter | Binary presence/absence analysis |
| **Count Intersections** | `cohortIntersectCount` parameter | Frequency calculations |
| **Date Intersections** | `cohortIntersectDate` parameter | Temporal relationship analysis |
| **Days Intersections** | `cohortIntersectDays` parameter | Time interval calculations |

**Sources:** [tests/testthat/test-summariseCharacteristics.R:964-1168]()

### Table Intersection Analysis

The test suite validates integration with OMOP CDM clinical tables:

```mermaid
flowchart TD
    subgraph "Table Intersection Tests"
        VISIT_TESTS["visit_occurrence Tests"]
        
        subgraph "Intersection Types"
            COUNT_INT["tableIntersectCount"]
            FLAG_INT["tableIntersectFlag"] 
            DATE_INT["tableIntersectDate"]
            DAYS_INT["tableIntersectDays"]
        end
        
        subgraph "Window Specifications"
            INF_BEFORE["c(-Inf, -1)"]
            BEFORE_PERIOD["c(-365, 0)"]
            AFTER_PERIOD["c(1, Inf)"]
        end
        
        subgraph "Statistical Validation"
            MIN_MAX["min/max calculations"]
            MEDIAN["median calculations"]
            COUNTS["count validations"]
        end
    end
    
    VISIT_TESTS --> COUNT_INT
    VISIT_TESTS --> FLAG_INT
    VISIT_TESTS --> DATE_INT
    VISIT_TESTS --> DAYS_INT
    
    COUNT_INT --> INF_BEFORE
    FLAG_INT --> BEFORE_PERIOD
    DATE_INT --> AFTER_PERIOD
    
    COUNT_INT --> MIN_MAX
    FLAG_INT --> COUNTS
    DATE_INT --> MEDIAN
```

**Sources:** [tests/testthat/test-summariseCharacteristics.R:679-961]()

### Demographics and Custom Variables

Tests validate demographic analysis and custom variable handling:

- **Age Groups**: Multiple age group specifications and ordering
- **Sex/Gender**: Binary demographic categorization
- **Custom Variables**: `otherVariables` parameter with custom estimates
- **Temporal Variables**: Cohort start/end dates, observation periods

**Sources:** [tests/testthat/test-summariseCharacteristics.R:319-416](), [tests/testthat/test-summariseCharacteristics.R:1440-1514]()

## Error Handling and Edge Cases

The test suite includes comprehensive error handling validation:

### Input Validation Tests

```mermaid
flowchart LR
    subgraph "Error Handling Tests"
        INVALID_COHORT["Invalid Cohort IDs"]
        EMPTY_DATA["Empty Input Data"]
        WRONG_PARAMS["Wrong Parameter Types"]
        
        subgraph "Expected Behaviors"
            EXPECT_ERROR_CALLS["expect_error() calls"]
            EXPECT_WARNING_CALLS["expect_warning() calls"]
            GRACEFUL_HANDLING["Graceful degradation"]
        end
        
        subgraph "Validation Areas"
            COHORT_ID_VAL["cohortId validation"]
            PARAM_TYPE_VAL["Parameter type checking"]
            DATA_STRUCTURE_VAL["Data structure validation"]
        end
    end
    
    INVALID_COHORT --> EXPECT_ERROR_CALLS
    EMPTY_DATA --> EXPECT_WARNING_CALLS
    WRONG_PARAMS --> GRACEFUL_HANDLING
    
    EXPECT_ERROR_CALLS --> COHORT_ID_VAL
    EXPECT_WARNING_CALLS --> PARAM_TYPE_VAL
    GRACEFUL_HANDLING --> DATA_STRUCTURE_VAL
```

**Sources:** [tests/testthat/test-summariseCharacteristics.R:591-620](), [tests/testthat/test-plotCohortAttrition.R:13-25]()

### Empty Data Handling

Tests specifically validate behavior with empty cohorts and missing data scenarios, ensuring the package handles edge cases gracefully while maintaining OMOP compliance.

**Sources:** [tests/testthat/test-summariseCharacteristics.R:418-476](), [tests/testthat/test-summariseCharacteristics.R:1371-1398]()

## Test Utilities and Assertions

The test suite employs standardized testing utilities for consistent validation:

- **`expect_no_error()`**: Validates successful function execution
- **`expect_true()`/`expect_false()`**: Boolean condition validation  
- **`expect_identical()`**: Exact value matching for estimates
- **`expect_error()`/`expect_warning()`**: Error condition validation
- **`inherits()`**: Object class validation for plots and results

These utilities ensure comprehensive validation of both successful operations and error conditions across all major package functions.

**Sources:** [tests/testthat/test-summariseCharacteristics.R:81-100](), [tests/testthat/test-plotCohortAttrition.R:15-20]()