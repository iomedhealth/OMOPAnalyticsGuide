# Page: Data Intersection System

# Data Intersection System

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/addIntersect.R](R/addIntersect.R)
- [R/checks.R](R/checks.R)
- [tests/testthat/test-addIntersect.R](tests/testthat/test-addIntersect.R)
- [tests/testthat/test-checks.R](tests/testthat/test-checks.R)

</details>



The Data Intersection System is the foundational architecture that powers all intersection functions in PatientProfiles. This system provides a unified interface for finding temporal relationships between patient records and various OMOP CDM tables, cohorts, or concept sets. It handles complex temporal windowing, data validation, and result aggregation through a single core engine.

For specific intersection implementations, see [Cohort Intersection](#3.1.1), [Concept Intersection](#3.1.2), and [Table Intersection](#3.1.3). For statistical analysis of intersection results, see [Data Summarization](#3.2).

## System Architecture

The Data Intersection System is built around the `.addIntersect()` function, which serves as the unified processing engine for all intersection operations. This architecture ensures consistency across different intersection types while supporting flexible configuration for various analytical needs.

```mermaid
graph TB
    subgraph "Input Layer"
        CDM_TABLE["CDM Table/Cohort<br/>(x parameter)"]
        TARGET_TABLE["Target Table<br/>(tableName parameter)"]
        PARAMS["Configuration Parameters<br/>window, value, indexDate"]
    end
    
    subgraph "Validation System"
        CHECKX["checkX()<br/>Validates input table"]
        CHECKCDM["checkCdm()<br/>Validates CDM reference"]
        CHECKVALUE["checkValue()<br/>Validates value parameters"]
        CHECKFILTER["checkFilter()<br/>Validates filter parameters"]
        CHECKWINDOW["validateWindowArgument()<br/>Validates temporal windows"]
    end
    
    subgraph "Core Processing Engine"
        ADDINTERSECT[".addIntersect()<br/>Unified intersection logic"]
        OVERLAP_TABLE["overlapTable<br/>Filtered target records"]
        TEMPORAL_FILTER["Temporal Window Filtering<br/>Date calculations and joins"]
        VALUE_AGGREGATION["Value Aggregation<br/>count, flag, date, days"]
    end
    
    subgraph "Output Generation"
        PIVOT_WIDE["tidyr::pivot_wider()<br/>Column expansion"]
        MISSING_COLS["Missing Column Creation<br/>Default values for NA results"]
        FINAL_JOIN["dplyr::left_join()<br/>Final result assembly"]
    end
    
    CDM_TABLE --> CHECKX
    TARGET_TABLE --> CHECKCDM
    PARAMS --> CHECKVALUE
    PARAMS --> CHECKFILTER
    PARAMS --> CHECKWINDOW
    
    CHECKX --> ADDINTERSECT
    CHECKCDM --> ADDINTERSECT
    CHECKVALUE --> ADDINTERSECT
    CHECKFILTER --> ADDINTERSECT
    CHECKWINDOW --> ADDINTERSECT
    
    ADDINTERSECT --> OVERLAP_TABLE
    OVERLAP_TABLE --> TEMPORAL_FILTER
    TEMPORAL_FILTER --> VALUE_AGGREGATION
    
    VALUE_AGGREGATION --> PIVOT_WIDE
    PIVOT_WIDE --> MISSING_COLS
    MISSING_COLS --> FINAL_JOIN
```

Sources: [R/addIntersect.R:17-442](), [R/checks.R:18-462]()

## Core Validation Framework

The intersection system implements comprehensive input validation through a series of specialized check functions. This validation layer ensures data integrity and provides clear error messages for invalid configurations.

| Validation Function | Purpose | Key Checks |
|---------------------|---------|------------|
| `checkX()` | Validates input table | Person identifier presence, table structure |
| `checkCdm()` | Validates CDM reference | CDM object type, required tables availability |
| `checkValue()` | Validates value parameters | Valid value types, column name conflicts |
| `checkFilter()` | Validates filtering parameters | Filter variable existence, ID compatibility |
| `checkVariableInX()` | Validates column references | Column existence in specified tables |
| `checkSnakeCase()` | Standardizes naming | Snake case conversion, special character handling |

```mermaid
flowchart LR
    INPUT_PARAMS["Input Parameters"]
    
    subgraph "Validation Chain"
        V1["checkX()<br/>Table validation"]
        V2["checkCdm()<br/>CDM validation"] 
        V3["checkValue()<br/>Value validation"]
        V4["checkFilter()<br/>Filter validation"]
        V5["checkVariableInX()<br/>Column validation"]
        V6["checkSnakeCase()<br/>Name standardization"]
    end
    
    ERROR_HANDLING["Error Messages<br/>with cli::cli_abort()"]
    PROCESSED_INPUT["Validated Parameters"]
    
    INPUT_PARAMS --> V1
    V1 --> V2
    V2 --> V3
    V3 --> V4
    V4 --> V5
    V5 --> V6
    
    V1 -.-> ERROR_HANDLING
    V2 -.-> ERROR_HANDLING
    V3 -.-> ERROR_HANDLING
    V4 -.-> ERROR_HANDLING
    V5 -.-> ERROR_HANDLING
    
    V6 --> PROCESSED_INPUT
```

Sources: [R/checks.R:18-91](), [R/checks.R:94-112](), [R/checks.R:133-161]()

## Processing Pipeline

The `.addIntersect()` function implements a sophisticated processing pipeline that handles temporal windowing, data joining, and result aggregation. The pipeline supports multiple value types and complex filtering scenarios.

### Temporal Window Processing

The system processes temporal windows by calculating date differences and applying filters based on configurable window boundaries:

```mermaid
graph TB
    subgraph "Window Configuration"
        WINDOW_LIST["window parameter<br/>list(c(start, end))"]
        INFINITE_HANDLING["Infinite boundary support<br/>-Inf, Inf values"]
        WINDOW_NAMES["Window naming<br/>m30_to_30, 0_to_inf"]
    end
    
    subgraph "Date Calculations"
        INDEX_DATE["indexDate<br/>(e.g., cohort_start_date)"]
        TARGET_DATES["Target dates<br/>start_date, end_date"]
        DATE_DIFF["CDMConnector::datediff()<br/>Calculate day differences"]
    end
    
    subgraph "Window Filtering"
        FILTER_LOGIC["Window boundary filtering<br/>start <= day_diff <= end"]
        RESULT_SUBSET["Filtered result set<br/>Records within window"]
    end
    
    WINDOW_LIST --> FILTER_LOGIC
    INFINITE_HANDLING --> FILTER_LOGIC
    
    INDEX_DATE --> DATE_DIFF
    TARGET_DATES --> DATE_DIFF
    DATE_DIFF --> FILTER_LOGIC
    
    FILTER_LOGIC --> RESULT_SUBSET
```

Sources: [R/addIntersect.R:224-325](), [R/addIntersect.R:210-218]()

### Value Type Processing

The system supports multiple value types, each with specific aggregation logic:

| Value Type | Processing Logic | Output Format |
|------------|------------------|---------------|
| `count` | `dplyr::n()` per group | Numeric count |
| `flag` | Binary presence indicator | 0/1 integer |
| `date` | First/last occurrence date | Date format |
| `days` | Days from index date | Numeric days |
| Custom columns | Direct column values | Original data type |

Sources: [R/addIntersect.R:245-325](), [R/addIntersect.R:327-402]()

## Column Name Generation System

The intersection system implements a flexible naming system using glue templates and automated snake_case conversion:

```mermaid
graph LR
    subgraph "Name Components"
        VALUE["value<br/>(count, flag, date)"]
        ID_NAME["id_name<br/>(filter identifier)"]
        WINDOW_NAME["window_name<br/>(temporal window)"]
    end
    
    subgraph "Name Generation"
        NAME_STYLE["nameStyle template<br/>'{value}_{id_name}_{window_name}'"]
        GLUE_EXPANSION["glue::glue()<br/>Template expansion"]
        SNAKE_CASE["checkSnakeCase()<br/>Standardization"]
    end
    
    subgraph "Output Columns"
        FINAL_NAMES["Generated column names<br/>count_all_0_to_inf"]
        OVERWRITE_CHECK["warnOverwriteColumns()<br/>Conflict detection"]
    end
    
    VALUE --> NAME_STYLE
    ID_NAME --> NAME_STYLE
    WINDOW_NAME --> NAME_STYLE
    
    NAME_STYLE --> GLUE_EXPANSION
    GLUE_EXPANSION --> SNAKE_CASE
    SNAKE_CASE --> FINAL_NAMES
    FINAL_NAMES --> OVERWRITE_CHECK
```

Sources: [R/addIntersect.R:92-104](), [R/checks.R:133-161](), [R/checks.R:330-350]()

## Integration with OMOP CDM

The intersection system provides specialized functions for working with standard OMOP CDM table structures:

```mermaid
graph TB
    subgraph "OMOP Table Mapping Functions"
        START_COL["startDateColumn()<br/>Maps to *_start_date columns"]
        END_COL["endDateColumn()<br/>Maps to *_end_date columns"]  
        CONCEPT_COL["standardConceptIdColumn()<br/>Maps to *_concept_id columns"]
        SOURCE_COL["sourceConceptIdColumn()<br/>Maps to *_source_concept_id columns"]
    end
    
    subgraph "Standard OMOP Tables"
        CONDITION["condition_occurrence<br/>condition_start_date, condition_end_date"]
        DRUG["drug_exposure<br/>drug_exposure_start_date, drug_exposure_end_date"]
        PROCEDURE["procedure_occurrence<br/>procedure_date"]
        VISIT["visit_occurrence<br/>visit_start_date, visit_end_date"]
    end
    
    subgraph "Custom Tables"
        COHORT["Cohort tables<br/>cohort_start_date, cohort_end_date"]
        CUSTOM["Custom tables<br/>User-defined date columns"]
    end
    
    START_COL --> CONDITION
    START_COL --> DRUG
    START_COL --> PROCEDURE
    START_COL --> VISIT
    
    END_COL --> CONDITION
    END_COL --> DRUG
    END_COL --> VISIT
    
    START_COL --> COHORT
    END_COL --> COHORT
    
    START_COL --> CUSTOM
    END_COL --> CUSTOM
```

Sources: [R/addIntersect.R:461-537](), [R/addIntersect.R:26-27](), [R/addIntersect.R:38-39]()

## Error Handling and User Feedback

The system implements comprehensive error handling with informative messages using the `cli` package:

- **Input validation errors**: Clear messages about invalid parameters or missing data
- **Column overwrite warnings**: Notifications when existing columns will be replaced
- **Data integrity checks**: Validation of duplicates and data consistency
- **Performance considerations**: Warnings about potentially expensive operations

Sources: [R/checks.R:19-65](), [R/addIntersect.R:374-381](), [R/checks.R:330-350]()