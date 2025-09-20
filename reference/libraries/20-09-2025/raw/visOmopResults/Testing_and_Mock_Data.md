# Page: Testing and Mock Data

# Testing and Mock Data

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/formatEstimateValue.R](R/formatEstimateValue.R)
- [R/mockResults.R](R/mockResults.R)
- [man/formatEstimateValue.Rd](man/formatEstimateValue.Rd)
- [tests/testthat/test-formatEstimateValue.R](tests/testthat/test-formatEstimateValue.R)
- [tests/testthat/test-fxTable.R](tests/testthat/test-fxTable.R)
- [tests/testthat/test-gtTable.R](tests/testthat/test-gtTable.R)

</details>



## Purpose and Scope

This document covers the testing framework and mock data generation utilities in visOmopResults. The testing system provides comprehensive validation of table and plot generation functionality, while the mock data system creates realistic `summarised_result` objects for testing and documentation examples.

For information about the core table generation functionality being tested, see [Core Table Functions](#2.1). For details about data processing and validation, see [Data Processing and Utilities](#4).

## Mock Data Generation System

The package provides a centralized mock data generation system through the `mockSummarisedResult()` function, which creates realistic test data that covers all major use cases of the visualization system.

### Mock Data Structure

```mermaid
flowchart TD
    subgraph "Mock Data Generation"
        MSR["mockSummarisedResult()"]
        SEED["set.seed(1)"]
        BASE["Base tibble creation"]
    end
    
    subgraph "Data Components"
        DEMO["Demographics Data<br/>count estimates"]
        AGE_MEAN["Age Statistics<br/>mean estimates"]
        AGE_SD["Age Statistics<br/>sd estimates"] 
        MED_COUNT["Medication Counts<br/>count estimates"]
        MED_PERC["Medication Percentages<br/>percentage estimates"]
    end
    
    subgraph "Data Attributes"
        STRATA["Multiple Strata<br/>overall, age_group, sex"]
        GROUPS["Group Levels<br/>cohort1, cohort2"]
        VARS["Variable Types<br/>subjects, age, medications"]
        TYPES["Estimate Types<br/>integer, numeric, percentage"]
    end
    
    subgraph "Final Output"
        SR["summarised_result object"]
        SETTINGS["Settings metadata"]
    end
    
    MSR --> SEED
    SEED --> BASE
    BASE --> DEMO
    BASE --> AGE_MEAN  
    BASE --> AGE_SD
    BASE --> MED_COUNT
    BASE --> MED_PERC
    
    DEMO --> STRATA
    AGE_MEAN --> GROUPS
    AGE_SD --> VARS
    MED_COUNT --> TYPES
    
    STRATA --> SR
    GROUPS --> SR
    VARS --> SR
    TYPES --> SR
    SR --> SETTINGS
```

Sources: [R/mockResults.R:28-193]()

The `mockSummarisedResult()` function creates a comprehensive dataset with:
- **18 rows per data type** covering different demographic strata
- **Multiple estimate types**: integer counts, numeric means/standard deviations, percentages
- **Realistic stratification**: overall, age groups, sex, and combinations
- **Multiple cohorts**: cohort1 and cohort2 for group comparisons
- **Medication data**: Amoxiciline and Ibuprofen with counts and percentages

### Mock Data Implementation Details

The function uses a systematic approach to generate consistent test data:

| Component | Rows | Estimate Types | Purpose |
|-----------|------|----------------|---------|
| Demographics | 18 | integer (count) | Basic subject counts across strata |
| Age Mean | 18 | numeric (mean) | Continuous variable testing |  
| Age SD | 18 | numeric (sd) | Standard deviation testing |
| Medication Counts | 36 | integer (count) | Drug-specific count data |
| Medication Percentages | 36 | percentage | Proportion testing |

Sources: [R/mockResults.R:30-181]()

## Testing Framework Architecture

The testing system uses a modular approach where each major component has dedicated test files that validate functionality using mock data.

### Test File Organization

```mermaid
graph TB
    subgraph "Test Files Structure"
        MOCK["mockSummarisedResult()"]
        
        subgraph "Table Backend Tests"
            GT_TEST["test-gtTable.R"]
            FX_TEST["test-fxTable.R"] 
            DT_TEST["test-datatableTable.R"]
            RT_TEST["test-reactableTable.R"]
            TT_TEST["test-tinytableTable.R"]
        end
        
        subgraph "Formatting Tests"
            FEV_TEST["test-formatEstimateValue.R"]
            FEN_TEST["test-formatEstimateName.R"] 
            FH_TEST["test-formatHeader.R"]
            FMC_TEST["test-formatMinCellCount.R"]
        end
        
        subgraph "Plot Tests"
            PLOT_TEST["test-plots.R"]
            THEME_TEST["test-themes.R"]
        end
        
        subgraph "Utility Tests"
            TIDY_TEST["test-tidySummarisedResult.R"]
            VALID_TEST["test-validation.R"]
        end
    end
    
    MOCK --> GT_TEST
    MOCK --> FX_TEST
    MOCK --> FEV_TEST
    MOCK --> FEN_TEST
    MOCK --> PLOT_TEST
    MOCK --> TIDY_TEST
```

Sources: [tests/testthat/test-gtTable.R:1-335](), [tests/testthat/test-fxTable.R:1-348](), [tests/testthat/test-formatEstimateValue.R:1-322]()

### Test Pattern Implementation

Each test file follows a consistent pattern for validating functionality:

```mermaid
sequenceDiagram
    participant TF as "Test Function"
    participant MSR as "mockSummarisedResult()"
    participant FF as "Formatting Functions"
    participant BE as "Backend Engine"
    participant VA as "Validation Assertions"
    
    TF->>MSR: Generate mock data
    MSR->>TF: Return summarised_result
    TF->>FF: Apply formatting pipeline
    FF->>TF: Return formatted data
    TF->>BE: Render with backend
    BE->>TF: Return rendered object
    TF->>VA: Assert expected properties
    VA->>TF: Pass/Fail result
```

Sources: [tests/testthat/test-gtTable.R:1-30](), [tests/testthat/test-fxTable.R:2-28]()

## Table Backend Testing

The table backend tests validate that each rendering engine correctly processes formatted data and applies styling options.

### GT Table Testing Pattern

```mermaid
flowchart LR
    subgraph "GT Test Flow"
        MOCK_DATA["mockSummarisedResult()"]
        FORMAT_HEADER["formatHeader()"]
        FORMAT_EST["formatEstimateName()"]
        GT_INTERNAL["gtTableInternal()"]
        
        subgraph "Validation Areas"
            SPANNERS["Spanner Structure"]
            STYLES["Style Application"]  
            GROUPING["Group Labels"]
            HEADERS["Header Formatting"]
        end
    end
    
    MOCK_DATA --> FORMAT_HEADER
    FORMAT_HEADER --> FORMAT_EST
    FORMAT_EST --> GT_INTERNAL
    GT_INTERNAL --> SPANNERS
    GT_INTERNAL --> STYLES
    GT_INTERNAL --> GROUPING  
    GT_INTERNAL --> HEADERS
```

Sources: [tests/testthat/test-gtTable.R:2-30](), [tests/testthat/test-gtTable.R:64-87]()

The GT table tests validate:
- **Spanner creation**: Multi-level headers are correctly structured [tests/testthat/test-gtTable.R:33-41]()
- **Style application**: Custom styles are properly applied to different table sections [tests/testthat/test-gtTable.R:42-48]()
- **Group handling**: Row grouping and column grouping functionality [tests/testthat/test-gtTable.R:114-116]()
- **Merge functionality**: Cell merging for repeated values [tests/testthat/test-gtTable.R:226-292]()

### Flextable Testing Pattern

The flextable tests follow a similar structure but focus on Microsoft Office compatibility features:

```mermaid
flowchart TD
    subgraph "Flextable Test Scenarios"
        INPUT1["Input 1: Basic Styling<br/>header colors, fonts"]
        INPUT2["Input 2: Grouping<br/>subtitle, body styling"]
        INPUT3["Input 3: Advanced<br/>delimiters, group ordering"]
    end
    
    subgraph "Validation Points"
        HEADER_STYLE["Header Styling<br/>background colors, borders"]
        BODY_STYLE["Body Styling<br/>text colors, cell borders"]
        GROUP_MERGE["Group Label Merging<br/>spans and alignment"]
        CAPTION["Caption Handling<br/>markdown formatting"]
    end
    
    INPUT1 --> HEADER_STYLE
    INPUT2 --> BODY_STYLE
    INPUT3 --> GROUP_MERGE
    INPUT2 --> CAPTION
```

Sources: [tests/testthat/test-fxTable.R:7-28](), [tests/testthat/test-fxTable.R:60-84](), [tests/testthat/test-fxTable.R:118-142]()

## Formatting Function Testing

The formatting tests validate the data transformation pipeline that prepares `summarised_result` objects for visualization.

### EstimateValue Formatting Tests

The `formatEstimateValue()` tests cover comprehensive number formatting scenarios:

| Test Scenario | Purpose | Mock Data Usage |
|--------------|---------|-----------------|
| Decimal formatting | Validate decimal place control | Uses integer, numeric, percentage estimates |
| Thousands separators | Test big mark insertion | Uses large count values from mock data |
| Estimate type precedence | Verify formatting hierarchy | Tests estimate_name vs estimate_type precedence |
| NULL handling | Edge case validation | Tests with NA and NULL values |

Sources: [tests/testthat/test-formatEstimateValue.R:2-10](), [tests/testthat/test-formatEstimateValue.R:11-31]()

### Test Data Validation Patterns

```mermaid
flowchart LR
    subgraph "Formatting Test Flow"
        MOCK["mockSummarisedResult()"]
        FORMAT["formatEstimateValue()"]
        
        subgraph "Test Validations"
            DECIMAL_CHECK["Decimal Count Validation"]
            SEPARATOR_CHECK["Thousands Mark Validation"] 
            TYPE_CHECK["Estimate Type Preservation"]
            NA_CHECK["NA Value Handling"]
        end
    end
    
    MOCK --> FORMAT
    FORMAT --> DECIMAL_CHECK
    FORMAT --> SEPARATOR_CHECK
    FORMAT --> TYPE_CHECK
    FORMAT --> NA_CHECK
```

Sources: [tests/testthat/test-formatEstimateValue.R:35-53](), [tests/testthat/test-formatEstimateValue.R:126-140]()

The formatting tests use specific validation patterns:
- **String parsing**: Tests split formatted values to validate decimal places [tests/testthat/test-formatEstimateValue.R:45-46]()
- **Mark counting**: Counts separator characters to validate thousands formatting [tests/testthat/test-formatEstimateValue.R:16-24]()
- **Type preservation**: Ensures formatting doesn't change estimate types [tests/testthat/test-formatEstimateValue.R:81-82]()

## Test Utilities and Helpers

The testing framework includes several utility patterns for consistent validation across test files.

### Style Testing Utilities

Table backend tests use consistent patterns for validating style application:

```mermaid
graph TD
    subgraph "Style Testing Pattern"
        STYLE_DEF["Style Definition<br/>list of styling options"]
        APPLY_STYLE["Apply to Internal Function<br/>gtTableInternal/fxTableInternal"]
        
        subgraph "Validation Methods"
            EXTRACT_STYLES["Extract Applied Styles"]
            COMPARE_EXPECTED["Compare with Expected"]
            VALIDATE_STRUCTURE["Validate Object Structure"]
        end
    end
    
    STYLE_DEF --> APPLY_STYLE
    APPLY_STYLE --> EXTRACT_STYLES
    EXTRACT_STYLES --> COMPARE_EXPECTED
    EXTRACT_STYLES --> VALIDATE_STRUCTURE
```

Sources: [tests/testthat/test-gtTable.R:9-30](), [tests/testthat/test-fxTable.R:9-28]()

### Error Handling Tests

The test suite includes comprehensive error validation:
- **Parameter validation**: Tests invalid parameter combinations [tests/testthat/test-formatEstimateValue.R:234-254]()
- **Data structure validation**: Validates required columns exist [tests/testthat/test-formatEstimateValue.R:254]()
- **Type mismatch handling**: Tests incompatible data types [tests/testthat/test-formatEstimateValue.R:313-314]()

### Mock Data Edge Cases

The testing system handles several edge cases using enhanced mock data:
- **Missing values**: Tests with `NA` estimate values [tests/testthat/test-formatEstimateValue.R:207-232]()
- **Suppressed data**: Tests with "-" placeholder values [tests/testthat/test-formatEstimateValue.R:317-321]()
- **Date handling**: Special handling for date estimate types [tests/testthat/test-formatEstimateValue.R:258-315]()

Sources: [R/formatEstimateValue.R:92-120](), [tests/testthat/test-formatEstimateValue.R:317-322]()