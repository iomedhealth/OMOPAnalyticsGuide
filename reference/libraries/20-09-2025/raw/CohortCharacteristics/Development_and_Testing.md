# Page: Development and Testing

# Development and Testing

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [tests/testthat/test-plotCohortAttrition.R](tests/testthat/test-plotCohortAttrition.R)
- [tests/testthat/test-summariseCharacteristics.R](tests/testthat/test-summariseCharacteristics.R)

</details>



This document covers the development practices, testing infrastructure, and quality assurance processes for the CohortCharacteristics package. It details the test suite organization, mock data generation systems, and testing patterns used to ensure package reliability and maintainability.

For information about the core analysis functions being tested, see [Core Analysis Workflow](#2). For details about specific analysis domains covered by the tests, see [Analysis Domains](#3).

## Test Suite Architecture

The CohortCharacteristics package employs a comprehensive testing strategy built around the testthat framework, with specialized infrastructure for OMOP CDM testing scenarios.

### Testing Infrastructure Components

```mermaid
flowchart TD
    subgraph "Test Infrastructure"
        MOCK["mockCohortCharacteristics()"]
        CONN["connection() / writeSchema()"]
        TESTDATA["Test Data Generation"]
    end
    
    subgraph "Test Categories"
        UNIT["Unit Tests"]
        INTEGRATION["Integration Tests"]
        EDGE["Edge Case Tests"]
        PERF["Performance Tests"]
    end
    
    subgraph "Core Test Files"
        SUMCHAR["test-summariseCharacteristics.R"]
        PLOTATTR["test-plotCohortAttrition.R"]
        OTHERS["test-*.R files"]
    end
    
    subgraph "Mock Data Sources"
        PERSON["person table"]
        COHORT["cohort tables"]
        OBSPER["observation_period"]
        VISIT["visit_occurrence"]
        CONCEPTS["concept tables"]
    end
    
    MOCK --> TESTDATA
    CONN --> TESTDATA
    TESTDATA --> UNIT
    TESTDATA --> INTEGRATION
    TESTDATA --> EDGE
    TESTDATA --> PERF
    
    PERSON --> MOCK
    COHORT --> MOCK
    OBSPER --> MOCK
    VISIT --> MOCK
    CONCEPTS --> MOCK
    
    SUMCHAR --> UNIT
    PLOTATTR --> UNIT
    OTHERS --> UNIT
```

**Test Infrastructure Architecture**

Sources: [tests/testthat/test-summariseCharacteristics.R:1-100](), [tests/testthat/test-plotCohortAttrition.R:1-40]()

### Mock Data Generation System

The package uses a sophisticated mock data generation system centered around `mockCohortCharacteristics()` that creates realistic OMOP CDM test databases.

```mermaid
flowchart LR
    subgraph "Mock Data Pipeline"
        INPUT["Test Parameters"]
        MOCKFUNC["mockCohortCharacteristics()"]
        CDM["Mock CDM Reference"]
        TABLES["Generated Tables"]
    end
    
    subgraph "Generated Components"
        PERSON["person table<br/>demographics"]
        COHORTS["cohort tables<br/>study populations"]
        OBS["observation_period<br/>enrollment periods"]
        CLINICAL["clinical tables<br/>conditions, drugs, visits"]
    end
    
    subgraph "Test Scenarios"
        BASIC["Basic Demographics"]
        INTERSECT["Cohort Intersections"]
        TEMPORAL["Temporal Analysis"]
        EMPTY["Empty Cohorts"]
        LARGE["Large Scale Data"]
    end
    
    INPUT --> MOCKFUNC
    MOCKFUNC --> CDM
    CDM --> TABLES
    
    TABLES --> PERSON
    TABLES --> COHORTS
    TABLES --> OBS
    TABLES --> CLINICAL
    
    PERSON --> BASIC
    COHORTS --> INTERSECT
    OBS --> TEMPORAL
    COHORTS --> EMPTY
    CLINICAL --> LARGE
```

**Mock Data Generation Flow**

Sources: [tests/testthat/test-summariseCharacteristics.R:55-80](), [tests/testthat/test-plotCohortAttrition.R:2-10]()

## Testing Patterns and Practices

### Core Testing Patterns

The test suite follows consistent patterns for validating functionality across all analysis types:

| Testing Pattern | Purpose | Example Usage |
|-----------------|---------|---------------|
| `expect_no_error()` | Function execution validation | [test-summariseCharacteristics.R:81-92]() |
| `expect_identical()` | Exact result matching | [test-summariseCharacteristics.R:94-102]() |
| `expect_true()` | Boolean condition validation | [test-summariseCharacteristics.R:93]() |
| `expect_error()` | Error condition testing | [test-summariseCharacteristics.R:296-299]() |
| `expect_warning()` | Warning condition testing | [test-plotCohortAttrition.R:13]() |

### Parameter Validation Testing

```mermaid
flowchart TD
    subgraph "Parameter Testing Strategy"
        VALID["Valid Parameters"]
        INVALID["Invalid Parameters"]
        EDGE["Edge Cases"]
        DEFAULTS["Default Values"]
    end
    
    subgraph "Validation Types"
        TYPE["Type Checking"]
        RANGE["Range Validation"]
        LOGIC["Logical Consistency"]
        DEPS["Dependency Validation"]
    end
    
    subgraph "Test Outcomes"
        SUCCESS["Successful Execution"]
        ERROR["Expected Errors"]
        WARN["Expected Warnings"]
        EMPTY["Empty Results"]
    end
    
    VALID --> TYPE
    INVALID --> TYPE
    EDGE --> RANGE
    DEFAULTS --> LOGIC
    
    TYPE --> SUCCESS
    RANGE --> ERROR
    LOGIC --> WARN
    DEPS --> EMPTY
```

**Parameter Validation Testing Framework**

Sources: [tests/testthat/test-summariseCharacteristics.R:477-620](), [tests/testthat/test-plotCohortAttrition.R:13-38]()

### Database Backend Testing

The test suite supports multiple database backends and connection patterns:

```mermaid
flowchart LR
    subgraph "Database Testing"
        DUCKDB["DuckDB Backend"]
        EUNOMIA["Eunomia Test Data"]
        MEMORY["In-Memory Testing"]
        PERSIST["Persistent Tables"]
    end
    
    subgraph "Connection Management"
        CONNECT["connection()"]
        SCHEMA["writeSchema()"]
        DISCONNECT["mockDisconnect()"]
        CDM["CDM Reference"]
    end
    
    subgraph "Test Scenarios"
        CRAN["CRAN Tests<br/>skip_on_cran()"]
        LOCAL["Local Development"]
        CI["Continuous Integration"]
        PERF["Performance Testing"]
    end
    
    DUCKDB --> CONNECT
    EUNOMIA --> CONNECT
    MEMORY --> SCHEMA
    PERSIST --> SCHEMA
    
    CONNECT --> CDM
    SCHEMA --> CDM
    CDM --> DISCONNECT
    
    CRAN --> LOCAL
    LOCAL --> CI
    CI --> PERF
```

**Database Backend Testing Architecture**

Sources: [tests/testthat/test-summariseCharacteristics.R:1172-1173](), [tests/testthat/test-summariseCharacteristics.R:961]()

## Test Coverage and Quality Assurance

### Comprehensive Function Testing

Each major function in the package has dedicated test coverage following the three-tier pattern:

```mermaid
flowchart TD
    subgraph "Function Testing Coverage"
        SUMMARISE["summarise* Functions"]
        PLOT["plot* Functions"] 
        TABLE["table* Functions"]
        UTILS["Utility Functions"]
    end
    
    subgraph "Test Dimensions"
        PARAMS["Parameter Combinations"]
        DATATYPES["Data Type Variations"]
        EDGECASES["Edge Cases"]
        ERRORS["Error Conditions"]
    end
    
    subgraph "Quality Metrics"
        COVERAGE["Code Coverage"]
        PERFORMANCE["Performance Benchmarks"]
        REPRODUCIBILITY["Result Reproducibility"]
        COMPATIBILITY["Backend Compatibility"]
    end
    
    SUMMARISE --> PARAMS
    PLOT --> DATATYPES
    TABLE --> EDGECASES
    UTILS --> ERRORS
    
    PARAMS --> COVERAGE
    DATATYPES --> PERFORMANCE
    EDGECASES --> REPRODUCIBILITY
    ERRORS --> COMPATIBILITY
```

**Test Coverage Framework**

Sources: [tests/testthat/test-summariseCharacteristics.R:1-416](), [tests/testthat/test-plotCohortAttrition.R:1-40]()

### Edge Case and Error Handling

The test suite includes comprehensive coverage of edge cases and error conditions:

| Test Category | Examples | Purpose |
|---------------|----------|---------|
| Empty Cohorts | [test-summariseCharacteristics.R:418-475]() | Validate handling of zero-record inputs |
| Invalid Parameters | [test-summariseCharacteristics.R:591-620]() | Ensure proper error messages |
| Type Mismatches | [test-plotCohortAttrition.R:22-38]() | Test input validation |
| Missing Data | [test-summariseCharacteristics.R:1371-1398]() | Handle incomplete datasets |
| Large Scale Data | [test-summariseCharacteristics.R:1400-1438]() | Performance under load |

### Reproducibility and Consistency Testing

```mermaid
flowchart LR
    subgraph "Reproducibility Framework"
        SEED["set.seed() Control"]
        MOCK["Consistent Mock Data"]
        COMPARE["Result Comparison"]
        ROUND["Numeric Rounding"]
    end
    
    subgraph "Consistency Checks"
        MULTIPLE["Multiple Runs"]
        BACKENDS["Different Backends"]
        PLATFORMS["Cross-Platform"]
        VERSIONS["Version Compatibility"]
    end
    
    subgraph "Validation"
        IDENTICAL["expect_identical()"]
        TOLERANCE["Numeric Tolerance"]
        STRUCTURE["Result Structure"]
        METADATA["Settings Consistency"]
    end
    
    SEED --> MULTIPLE
    MOCK --> BACKENDS
    COMPARE --> PLATFORMS
    ROUND --> VERSIONS
    
    MULTIPLE --> IDENTICAL
    BACKENDS --> TOLERANCE
    PLATFORMS --> STRUCTURE
    VERSIONS --> METADATA
```

**Reproducibility Testing Framework**

Sources: [tests/testthat/test-summariseCharacteristics.R:1400-1438]()

## Development Workflow and Standards

### Test-Driven Development Practices

The package follows test-driven development principles with tests organized around user-facing functionality:

```mermaid
flowchart TD
    subgraph "Development Cycle"
        SPEC["Function Specification"]
        TEST["Write Tests"]
        IMPLEMENT["Implement Function"]
        VALIDATE["Validate Results"]
        REFACTOR["Refactor Code"]
    end
    
    subgraph "Test Categories by Development Phase"
        UNIT_DEV["Unit Tests<br/>Individual Functions"]
        INTEGRATION_DEV["Integration Tests<br/>Function Combinations"]
        SYSTEM_DEV["System Tests<br/>End-to-End Workflows"]
        REGRESSION_DEV["Regression Tests<br/>Bug Prevention"]
    end
    
    subgraph "Quality Gates"
        COVERAGE_GATE["Code Coverage > 90%"]
        PERFORMANCE_GATE["Performance Benchmarks"]
        DOCUMENTATION_GATE["Documentation Complete"]
        EXAMPLE_GATE["Working Examples"]
    end
    
    SPEC --> TEST
    TEST --> IMPLEMENT
    IMPLEMENT --> VALIDATE
    VALIDATE --> REFACTOR
    REFACTOR --> SPEC
    
    TEST --> UNIT_DEV
    IMPLEMENT --> INTEGRATION_DEV
    VALIDATE --> SYSTEM_DEV
    REFACTOR --> REGRESSION_DEV
    
    UNIT_DEV --> COVERAGE_GATE
    INTEGRATION_DEV --> PERFORMANCE_GATE
    SYSTEM_DEV --> DOCUMENTATION_GATE
    REGRESSION_DEV --> EXAMPLE_GATE
```

**Development Workflow and Quality Gates**

Sources: [tests/testthat/test-summariseCharacteristics.R:1515-1553](), [tests/testthat/test-summariseCharacteristics.R:1555-1663]()

### Performance and Benchmarking

The package includes performance testing and benchmarking capabilities:

- **Consistency Testing**: Validates that results are identical across multiple runs [test-summariseCharacteristics.R:1400-1438]()
- **Weight Calculations**: Tests complex weighted statistics calculations [test-summariseCharacteristics.R:1555-1663]()
- **Large Dataset Handling**: Ensures performance with realistic data volumes
- **Memory Management**: Validates proper cleanup and resource management [test-summariseCharacteristics.R:961]()

The testing infrastructure ensures that CohortCharacteristics maintains high quality, reliability, and performance standards across all supported OMOP CDM environments and analysis scenarios.

Sources: [tests/testthat/test-summariseCharacteristics.R:1-1664](), [tests/testthat/test-plotCohortAttrition.R:1-41]()