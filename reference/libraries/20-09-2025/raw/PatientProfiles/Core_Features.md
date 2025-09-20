# Page: Core Features

# Core Features

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/addIntersect.R](R/addIntersect.R)
- [R/checks.R](R/checks.R)
- [R/summariseResult.R](R/summariseResult.R)
- [tests/testthat/test-addIntersect.R](tests/testthat/test-addIntersect.R)
- [tests/testthat/test-checks.R](tests/testthat/test-checks.R)
- [tests/testthat/test-summariseResult.R](tests/testthat/test-summariseResult.R)

</details>



This document covers the main functional capabilities of the PatientProfiles package for analyzing OMOP CDM data. These core features provide the foundation for patient profiling and cohort characterization through data intersection, statistical summarization, and categorization operations.

For information about getting started with basic demographics and mock data, see [Getting Started](#2). For advanced specialized functions, see [Advanced Features](#4).

## Data Intersection Architecture

The PatientProfiles package centers around a unified intersection system that enables temporal analysis between different clinical data sources. The core architecture processes OMOP CDM tables through a common pipeline that handles validation, temporal filtering, and result aggregation.

### Core Intersection Engine

```mermaid
flowchart TD
    subgraph "Input Processing"
        CDM_TABLE["`CDM Table
        (cohort, condition_occurrence, 
        drug_exposure, etc.)`"]
        VALIDATION["`checkX()
        checkCdm()
        checkVariableInX()`"]
        FILTERS["`checkFilter()
        checkValue()
        checkSnakeCase()`"]
    end
    
    subgraph "Core Engine"
        ADD_INTERSECT["`addIntersect()
        Core Intersection Logic`"]
        TEMPORAL_FILTER["`Window Filtering
        c(-Inf, 0), c(0, Inf), etc.`"]
        VALUE_CALC["`Value Calculation
        count, flag, date, days`"]
    end
    
    subgraph "Result Processing"
        PIVOT["`tidyr::pivot_wider()
        Result Reshaping`"]
        JOIN["`dplyr::left_join()
        Back to Original Table`"]
        COMPUTE["`dplyr::compute()
        Database Materialization`"]
    end
    
    subgraph "Output Types"
        COUNT_FLAG["count/flag columns"]
        DATE_DAYS["date/days columns"] 
        EXTRA_COLS["additional value columns"]
    end
    
    CDM_TABLE --> VALIDATION
    VALIDATION --> FILTERS
    FILTERS --> ADD_INTERSECT
    ADD_INTERSECT --> TEMPORAL_FILTER
    TEMPORAL_FILTER --> VALUE_CALC
    VALUE_CALC --> PIVOT
    PIVOT --> JOIN
    JOIN --> COMPUTE
    COMPUTE --> COUNT_FLAG
    COMPUTE --> DATE_DAYS
    COMPUTE --> EXTRA_COLS
```

The `.addIntersect()` function serves as the universal intersection engine, processing temporal relationships between any two OMOP CDM tables. It supports multiple value types (`count`, `flag`, `date`, `days`) and flexible time windows.

Sources: [R/addIntersect.R:17-442](), [R/checks.R:18-462]()

### Validation and Input Processing

```mermaid
flowchart LR
    subgraph "Input Validation Pipeline"
        INPUT_TABLE["`Input Table (x)`"]
        PERSON_CHECK["`checkX()
        Validates person_id/subject_id`"]
        CDM_CHECK["`checkCdm()
        Validates CDM structure`"]
        DATE_CHECK["`checkVariableInX()
        Validates date columns`"]
        FILTER_CHECK["`checkFilter()
        Validates filter parameters`"]
        VALUE_CHECK["`checkValue()
        Validates value parameters`"]
        
        INPUT_TABLE --> PERSON_CHECK
        PERSON_CHECK --> CDM_CHECK  
        CDM_CHECK --> DATE_CHECK
        DATE_CHECK --> FILTER_CHECK
        FILTER_CHECK --> VALUE_CHECK
    end
    
    subgraph "Validation Functions"
        PERSON_VAR["`personVariable
        'person_id' or 'subject_id'`"]
        TABLE_EXISTS["`tables in CDM
        tableName validation`"]
        VALID_COLS["`indexDate, targetStartDate
        targetEndDate validation`"]
        FILTER_TBL["`filterTbl
        dplyr::tibble(id, id_name)`"]
        EXTRA_VALUE["`extraValue
        additional column extraction`"]
    end
    
    PERSON_CHECK --> PERSON_VAR
    CDM_CHECK --> TABLE_EXISTS
    DATE_CHECK --> VALID_COLS
    FILTER_CHECK --> FILTER_TBL
    VALUE_CHECK --> EXTRA_VALUE
```

The validation system ensures data integrity before intersection operations. Key validation functions include `checkX()` for person identifiers, `checkCdm()` for CDM structure, and specialized checks for temporal columns and filter parameters.

Sources: [R/checks.R:18-38](), [R/checks.R:41-56](), [R/checks.R:59-65](), [R/checks.R:68-91](), [R/checks.R:94-112]()

## Statistical Summarization System

The `summariseResult()` function provides comprehensive statistical analysis capabilities with support for grouping, stratification, and various statistical estimates.

### Summarization Processing Flow

```mermaid
flowchart TD
    subgraph "Input Processing"
        TABLE["`Input Table
        (collected or db table)`"]
        GROUP_STRATA["`Group/Strata Definition
        list(c('sex', 'age_group'))`"]
        VAR_EST["`Variables & Estimates
        variables, estimates lists`"]
    end
    
    subgraph "Core Processing"
        CHECK_FUNCS["`checkVariablesFunctions()
        Variable-estimate validation`"]
        SUMMARISE_INTERNAL["`summariseInternal()
        Core summarization logic`"]
        
        subgraph "Estimate Calculations"
            NUMERIC["`summariseNumeric()
            min, max, mean, median, etc.`"]
            BINARY["`summariseBinary()
            count, percentage for 0/1`"]
            CATEGORIES["`summariseCategories()
            categorical summaries`"]
            MISSING["`summariseMissings()
            count_missing, percentage_missing`"]
        end
        
        COUNT_SUBJ["`countSubjects()
        number_records, number_subjects`"]
    end
    
    subgraph "Output Processing"
        BIND_RESULTS["`dplyr::bind_rows()
        Combine all estimates`"]
        FORMAT_SR["`omopgenerics::newSummarisedResult()
        Standard format`"]
        ORDER_VARS["`orderVariables()
        Variable/estimate ordering`"]
    end
    
    TABLE --> CHECK_FUNCS
    GROUP_STRATA --> CHECK_FUNCS
    VAR_EST --> CHECK_FUNCS
    CHECK_FUNCS --> SUMMARISE_INTERNAL
    SUMMARISE_INTERNAL --> COUNT_SUBJ
    SUMMARISE_INTERNAL --> NUMERIC
    SUMMARISE_INTERNAL --> BINARY
    SUMMARISE_INTERNAL --> CATEGORIES
    SUMMARISE_INTERNAL --> MISSING
    COUNT_SUBJ --> BIND_RESULTS
    NUMERIC --> BIND_RESULTS
    BINARY --> BIND_RESULTS
    CATEGORIES --> BIND_RESULTS
    MISSING --> BIND_RESULTS
    BIND_RESULTS --> ORDER_VARS
    ORDER_VARS --> FORMAT_SR
```

The summarization system processes data through specialized functions for different variable types. Each estimate type (numeric, binary, categorical, missing) has dedicated processing logic that handles database-specific optimizations.

Sources: [R/summariseResult.R:52-237](), [R/summariseResult.R:239-307]()

### Variable Type Classification and Estimates

```mermaid
flowchart LR
    subgraph "Variable Types"
        NUMERIC["`numeric/integer
        Age, measurements`"]
        CATEGORICAL["`categorical
        Sex, cohort names`"] 
        DATE["`date
        Converted to integer`"]
        LOGICAL["`logical
        Converted to integer`"]
        BINARY["`binary (0/1)
        Special numeric case`"]
    end
    
    subgraph "Available Estimates"
        NUMERIC_EST["`Numeric Estimates:
        min, max, mean, median
        q25, q75, sd, density`"]
        CAT_EST["`Categorical Estimates:
        count, percentage`"]
        MISSING_EST["`Missing Estimates:
        count_missing
        percentage_missing`"]
        COUNT_EST["`Count Estimates:
        number_records
        number_subjects`"]
    end
    
    subgraph "Processing Functions"
        ESTIMATE_FUNC["`estimatesFunc
        Base estimate functions`"]
        ESTIMATE_FUNC_WEIGHTS["`estimatesFuncWeights
        Weighted estimate functions`"]
        VARIABLE_TYPES["`variableTypes()
        Type classification`"]
        AVAILABLE_EST["`availableEstimates()
        Valid estimate registry`"]
    end
    
    NUMERIC --> NUMERIC_EST
    CATEGORICAL --> CAT_EST
    BINARY --> CAT_EST
    DATE --> NUMERIC_EST
    LOGICAL --> NUMERIC_EST
    
    NUMERIC_EST --> ESTIMATE_FUNC
    CAT_EST --> ESTIMATE_FUNC
    MISSING_EST --> ESTIMATE_FUNC
    COUNT_EST --> ESTIMATE_FUNC
    
    ESTIMATE_FUNC --> ESTIMATE_FUNC_WEIGHTS
    VARIABLE_TYPES --> AVAILABLE_EST
```

The system automatically classifies variables into appropriate types and applies compatible statistical estimates. Binary variables (containing only 0/1 values) are treated specially to enable count/percentage calculations.

Sources: [R/summariseResult.R:366-448](), [R/summariseResult.R:517-612](), [R/summariseResult.R:614-662](), [R/checks.R:207-277]()

## Integration with OMOP CDM Standards

The core features integrate deeply with OMOP CDM conventions through standardized column name functions and table structure expectations.

### OMOP Table Column Resolution

```mermaid
flowchart LR
    subgraph "Column Name Functions"
        START_DATE["`startDateColumn()
        Table-specific start date`"]
        END_DATE["`endDateColumn() 
        Table-specific end date`"]
        STD_CONCEPT["`standardConceptIdColumn()
        Standard concept ID`"]
        SRC_CONCEPT["`sourceConceptIdColumn()
        Source concept ID`"]
    end
    
    subgraph "OMOP Tables"
        CONDITION["`condition_occurrence
        condition_start_date
        condition_end_date
        condition_concept_id`"]
        DRUG["`drug_exposure
        drug_exposure_start_date
        drug_exposure_end_date  
        drug_concept_id`"]
        COHORT["`cohort (non-OMOP)
        cohort_start_date
        cohort_end_date
        cohort_definition_id`"]
    end
    
    subgraph "Resolution Logic"
        OMOP_CHECK["`omopgenerics::omopTables()
        Check if standard OMOP table`"]
        OMOP_COLS["`omopgenerics::omopColumns()
        Get standard column names`"]
        DEFAULT_COLS["`Default cohort columns
        for non-OMOP tables`"]
    end
    
    START_DATE --> OMOP_CHECK
    END_DATE --> OMOP_CHECK
    STD_CONCEPT --> OMOP_CHECK
    SRC_CONCEPT --> OMOP_CHECK
    
    OMOP_CHECK --> OMOP_COLS
    OMOP_CHECK --> DEFAULT_COLS
    
    OMOP_COLS --> CONDITION
    OMOP_COLS --> DRUG
    DEFAULT_COLS --> COHORT
```

These helper functions automatically resolve appropriate column names based on table type, enabling consistent intersection operations across different OMOP CDM tables without manual column specification.

Sources: [R/addIntersect.R:461-537]()

## Error Handling and Data Quality

The package implements comprehensive error handling and data quality checks throughout the core processing pipeline.

### Validation Error Patterns

| Validation Type | Function | Error Conditions | File Location |
|-----------------|----------|------------------|---------------|
| Table Structure | `checkX()` | Missing person_id/subject_id, both present | [R/checks.R:18-38]() |
| CDM Reference | `checkCdm()` | Invalid CDM object, missing tables | [R/checks.R:41-56]() |
| Variable Presence | `checkVariableInX()` | Column not in table | [R/checks.R:59-65]() |
| Filter Parameters | `checkFilter()` | Invalid filter variable/ID combinations | [R/checks.R:68-91]() |
| Value Specifications | `checkValue()` | Invalid value types for table | [R/checks.R:94-112]() |
| Statistical Functions | `checkVariablesFunctions()` | Incompatible variable-estimate pairs | [R/checks.R:207-277]() |

The validation system provides clear error messages and handles edge cases like empty tables, missing data, and incompatible parameter combinations.

Sources: [R/checks.R:1-462]()

---

This core features system provides the foundation for all patient profiling operations in the package, with robust validation, flexible intersection capabilities, and comprehensive statistical summarization. The modular design allows for extension while maintaining consistency with OMOP CDM standards.