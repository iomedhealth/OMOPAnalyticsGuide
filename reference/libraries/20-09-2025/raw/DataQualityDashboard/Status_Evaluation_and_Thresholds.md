# Page: Status Evaluation and Thresholds

# Status Evaluation and Thresholds

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/calculateNotApplicableStatus.R](R/calculateNotApplicableStatus.R)
- [R/evaluateThresholds.R](R/evaluateThresholds.R)
- [docs/articles/AddNewCheck.html](docs/articles/AddNewCheck.html)
- [docs/articles/CheckStatusDefinitions.html](docs/articles/CheckStatusDefinitions.html)
- [docs/articles/SqlOnly.html](docs/articles/SqlOnly.html)
- [docs/reference/dot-writeResultsToCsv.html](docs/reference/dot-writeResultsToCsv.html)
- [docs/reference/writeJsonResultsToCsv.html](docs/reference/writeJsonResultsToCsv.html)

</details>



This document covers the status evaluation and threshold system within the DataQualityDashboard, which determines whether data quality checks pass, fail, are not applicable, or encounter errors. This system processes raw check results and applies business logic to assign final status values.

For information about check execution and SQL generation, see [Execution Modes and SQL Generation](#3.2). For details about output formats and result processing, see [Output Formats and Export](#6.2).

## Status Evaluation System Overview

The DataQualityDashboard uses a hierarchical status system with four mutually exclusive states, evaluated in priority order:

| Status | Priority | Description |
|--------|----------|-------------|
| `isError` | 1 (Highest) | SQL execution failed or other system error occurred |
| `notApplicable` | 2 | Check cannot be meaningfully evaluated (missing tables, empty data, etc.) |
| `failed` | 3 | Check executed successfully but violated the threshold |
| `passed` | 4 (Lowest) | Check executed successfully and met the threshold |

### Status Evaluation Flow

```mermaid
flowchart TD
    RAW[Raw Check Results] --> THRESH[".evaluateThresholds()"]
    THRESH --> ERROR_CHECK{"Has SQL Error?"}
    ERROR_CHECK -->|Yes| ERROR_STATUS["isError = 1"]
    ERROR_CHECK -->|No| THRESHOLD_CHECK{"Threshold Evaluation"}
    
    THRESHOLD_CHECK --> THRESHOLD_EXISTS{"Threshold Exists?"}
    THRESHOLD_EXISTS -->|No or 0%| ANY_VIOLATIONS{"Any Violations?"}
    THRESHOLD_EXISTS -->|Yes| PCT_CHECK{"pctViolatedRows > threshold?"}
    
    ANY_VIOLATIONS -->|Yes| FAILED_STATUS["failed = 1"]
    ANY_VIOLATIONS -->|No| CONTINUE_EVAL[Continue Evaluation]
    PCT_CHECK -->|Yes| FAILED_STATUS
    PCT_CHECK -->|No| CONTINUE_EVAL
    
    CONTINUE_EVAL --> NA_CHECK{".hasNAchecks()?"}
    NA_CHECK -->|Yes| CALC_NA[".calculateNotApplicableStatus()"]
    NA_CHECK -->|No| FINAL_STATUS[Final Status Assignment]
    
    CALC_NA --> NA_STATUS["notApplicable = 1 (if applicable)"]
    NA_STATUS --> FINAL_STATUS
    
    FINAL_STATUS --> PASSED_STATUS["passed = 1 (if not error, failed, or NA)"]
    
    ERROR_STATUS --> OUTPUT[Final Status Results]
    FAILED_STATUS --> OUTPUT
    NA_STATUS --> OUTPUT
    PASSED_STATUS --> OUTPUT
```

Sources: [R/evaluateThresholds.R:26-171](), [R/calculateNotApplicableStatus.R:78-195]()

## Threshold Evaluation System

The threshold evaluation system compares check results against configurable thresholds defined in CSV configuration files. Each check type (TABLE, FIELD, CONCEPT) has its own threshold configuration structure.

### Threshold Configuration Structure

```mermaid
flowchart LR
    subgraph "Threshold Sources"
        TABLE_CSV["tableChecks CSV"]
        FIELD_CSV["fieldChecks CSV"] 
        CONCEPT_CSV["conceptChecks CSV"]
    end
    
    subgraph "Threshold Fields"
        THRESHOLD_FIELD["{checkName}Threshold"]
        NOTES_FIELD["{checkName}Notes"]
    end
    
    subgraph "Lookup Logic"
        TABLE_LOOKUP["cdmTableName match"]
        FIELD_LOOKUP["cdmTableName + cdmFieldName match"]
        CONCEPT_LOOKUP["cdmTableName + cdmFieldName + conceptId [+ unitConceptId] match"]
    end
    
    TABLE_CSV --> TABLE_LOOKUP
    FIELD_CSV --> FIELD_LOOKUP
    CONCEPT_CSV --> CONCEPT_LOOKUP
    
    TABLE_LOOKUP --> THRESHOLD_FIELD
    FIELD_LOOKUP --> THRESHOLD_FIELD
    CONCEPT_LOOKUP --> THRESHOLD_FIELD
    
    THRESHOLD_FIELD --> NOTES_FIELD
```

### Threshold Evaluation Process

The `.evaluateThresholds()` function processes each check result individually:

```mermaid
flowchart TD
    CHECK_RESULT["Individual Check Result"] --> BUILD_THRESHOLD_FIELD["Build thresholdField name: '{checkName}Threshold'"]
    BUILD_THRESHOLD_FIELD --> CHECK_FIELD_EXISTS["Check if threshold field exists in CSV"]
    
    CHECK_FIELD_EXISTS -->|No| NO_THRESHOLD["thresholdValue = NA"]
    CHECK_FIELD_EXISTS -->|Yes| DETERMINE_LEVEL{"Check Level?"}
    
    DETERMINE_LEVEL -->|TABLE| TABLE_FILTER["Filter by cdmTableName"]
    DETERMINE_LEVEL -->|FIELD| FIELD_FILTER["Filter by cdmTableName + cdmFieldName"]
    DETERMINE_LEVEL -->|CONCEPT| CONCEPT_FILTER["Filter by cdmTableName + cdmFieldName + conceptId [+ unitConceptId]"]
    
    TABLE_FILTER --> EXTRACT_THRESHOLD["Extract threshold value"]
    FIELD_FILTER --> EXTRACT_THRESHOLD
    CONCEPT_FILTER --> EXTRACT_THRESHOLD
    
    EXTRACT_THRESHOLD --> THRESHOLD_LOGIC{"Threshold Logic"}
    NO_THRESHOLD --> THRESHOLD_LOGIC
    
    THRESHOLD_LOGIC --> IS_ERROR{"Has Error?"}
    IS_ERROR -->|Yes| SET_ERROR["isError = 1"]
    IS_ERROR -->|No| CHECK_THRESHOLD{"Threshold Value?"}
    
    CHECK_THRESHOLD -->|NA or 0| ANY_VIOLATIONS_CHECK{"numViolatedRows > 0?"}
    CHECK_THRESHOLD -->|Has Value| PCT_COMPARISON{"pctViolatedRows * 100 > thresholdValue?"}
    
    ANY_VIOLATIONS_CHECK -->|Yes| SET_FAILED["failed = 1"]
    ANY_VIOLATIONS_CHECK -->|No| CONTINUE["Continue"]
    PCT_COMPARISON -->|Yes| SET_FAILED
    PCT_COMPARISON -->|No| CONTINUE
    
    SET_ERROR --> RESULT["Check Result with Status"]
    SET_FAILED --> RESULT
    CONTINUE --> RESULT
```

Sources: [R/evaluateThresholds.R:38-164]()

## Not Applicable Status Logic

The Not Applicable status is determined by the `.calculateNotApplicableStatus()` function, which implements complex business rules to identify when checks cannot be meaningfully evaluated.

### Required Checks for Not Applicable Evaluation

Before applying Not Applicable logic, the system verifies that required foundational checks are present:

```mermaid
flowchart TD
    CHECK_RESULTS["Check Results"] --> HAS_NA_CHECKS[".hasNAchecks()"]
    HAS_NA_CHECKS --> CONTAINS_NA_CHECKS[".containsNAchecks()"]
    
    CONTAINS_NA_CHECKS --> REQUIRED_CHECKS["Required Check Names"]
    REQUIRED_CHECKS --> CDM_TABLE["cdmTable"]
    REQUIRED_CHECKS --> CDM_FIELD["cdmField"] 
    REQUIRED_CHECKS --> MEASURE_VALUE["measureValueCompleteness"]
    
    CDM_TABLE --> VALIDATION{"All Present?"}
    CDM_FIELD --> VALIDATION
    MEASURE_VALUE --> VALIDATION
    
    VALIDATION -->|Yes| PROCEED["Proceed with NA Calculation"]
    VALIDATION -->|No| SKIP["Skip NA Calculation"]
```

### Not Applicable Determination Rules

The system builds lookup tables for missing/empty entities and applies rules to determine Not Applicable status:

```mermaid
flowchart TD
    subgraph "Lookup Table Construction"
        MISSING_TABLES["Missing Tables: cdmTable.failed = 1"]
        MISSING_FIELDS["Missing Fields: cdmField.failed = 1"] 
        EMPTY_TABLES["Empty Tables: measureValueCompleteness.numDenominatorRows = 0"]
        EMPTY_FIELDS["Empty Fields: measureValueCompleteness.numDenominatorRows = numViolatedRows"]
    end
    
    subgraph "Special Concept Logic"
        CONCEPT_MISSING["conceptIsMissing: checkLevel = CONCEPT & unitConceptId IS NULL & numDenominatorRows = 0"]
        CONCEPT_UNIT_MISSING["conceptAndUnitAreMissing: checkLevel = CONCEPT & unitConceptId IS NOT NULL & numDenominatorRows = 0"]
    end
    
    subgraph "Individual Check Evaluation"
        CHECK_RESULT["Individual Check"] --> APPLY_NA[".applyNotApplicable()"]
        APPLY_NA --> ERROR_PRECEDENCE{"isError = 1?"}
        ERROR_PRECEDENCE -->|Yes| NOT_APPLICABLE_NO["notApplicable = 0"]
        ERROR_PRECEDENCE -->|No| CHECK_TYPE{"Check Type?"}
        
        CHECK_TYPE -->|cdmTable or cdmField| NOT_APPLICABLE_NO
        CHECK_TYPE -->|Other| ENTITY_MISSING{"Table/Field Missing or Empty?"}
        
        ENTITY_MISSING -->|Yes| NOT_APPLICABLE_YES["notApplicable = 1"]
        ENTITY_MISSING -->|No| COMPLETENESS_CHECK{"measureValueCompleteness?"}
        
        COMPLETENESS_CHECK -->|Yes| NOT_APPLICABLE_NO
        COMPLETENESS_CHECK -->|No| CONCEPT_CHECK{"Concept Missing?"}
        
        CONCEPT_CHECK -->|Yes| NOT_APPLICABLE_YES
        CONCEPT_CHECK -->|No| NOT_APPLICABLE_NO
    end
    
    subgraph "Special Rules"
        CONDITION_ERA["measureConditionEraCompleteness: Check CONDITION_OCCURRENCE table status"]
    end
    
    MISSING_TABLES --> APPLY_NA
    MISSING_FIELDS --> APPLY_NA
    EMPTY_TABLES --> APPLY_NA
    EMPTY_FIELDS --> APPLY_NA
    CONCEPT_MISSING --> APPLY_NA
    CONCEPT_UNIT_MISSING --> APPLY_NA
    CONDITION_ERA --> APPLY_NA
```

### Not Applicable Reason Assignment

When a check is marked as Not Applicable, the system assigns a descriptive reason:

| Condition | Reason Format |
|-----------|---------------|
| `tableIsMissing` | "Table {cdmTableName} does not exist." |
| `fieldIsMissing` | "Field {cdmTableName}.{cdmFieldName} does not exist." |
| `tableIsEmpty` | "Table {cdmTableName} is empty." |
| `fieldIsEmpty` | "Field {cdmTableName}.{cdmFieldName} is not populated." |
| `conceptIsMissing` | "{cdmFieldName}={conceptId} is missing from the {cdmTableName} table." |
| `conceptAndUnitAreMissing` | "Combination of {cdmFieldName}={conceptId}, unitConceptId={unitConceptId} and VALUE_AS_NUMBER IS NOT NULL is missing from the {cdmTableName} table." |

Sources: [R/calculateNotApplicableStatus.R:174-193]()

## Implementation Architecture

### Key Functions and Their Roles

```mermaid
graph TD
    subgraph "Main Evaluation Functions"
        EVAL_THRESHOLDS[".evaluateThresholds()"]
        CALC_NA[".calculateNotApplicableStatus()"]
    end
    
    subgraph "Helper Functions"
        HAS_NA[".hasNAchecks()"]
        CONTAINS_NA[".containsNAchecks()"]
        APPLY_NA[".applyNotApplicable()"]
    end
    
    subgraph "Input Data"
        CHECK_RESULTS["checkResults DataFrame"]
        TABLE_CHECKS["tableChecks CSV"]
        FIELD_CHECKS["fieldChecks CSV"]
        CONCEPT_CHECKS["conceptChecks CSV"]
    end
    
    subgraph "Status Fields"
        FAILED["failed"]
        PASSED["passed"]
        IS_ERROR["isError"]
        NOT_APPLICABLE["notApplicable"]
        THRESHOLD_VALUE["thresholdValue"]
        NOTES_VALUE["notesValue"]
        NOT_APPLICABLE_REASON["notApplicableReason"]
    end
    
    CHECK_RESULTS --> EVAL_THRESHOLDS
    TABLE_CHECKS --> EVAL_THRESHOLDS
    FIELD_CHECKS --> EVAL_THRESHOLDS
    CONCEPT_CHECKS --> EVAL_THRESHOLDS
    
    EVAL_THRESHOLDS --> HAS_NA
    HAS_NA --> CONTAINS_NA
    CONTAINS_NA --> CALC_NA
    CALC_NA --> APPLY_NA
    
    EVAL_THRESHOLDS --> FAILED
    EVAL_THRESHOLDS --> PASSED
    EVAL_THRESHOLDS --> IS_ERROR
    EVAL_THRESHOLDS --> THRESHOLD_VALUE
    EVAL_THRESHOLDS --> NOTES_VALUE
    
    CALC_NA --> NOT_APPLICABLE
    CALC_NA --> NOT_APPLICABLE_REASON
```

### Status Field Initialization and Updates

The `.evaluateThresholds()` function initializes all status fields and updates them through the evaluation process:

```mermaid
flowchart TD
    INIT["Initialize Status Fields"] --> INIT_FAILED["failed = 0"]
    INIT --> INIT_PASSED["passed = 0"]
    INIT --> INIT_ERROR["isError = 0"]
    INIT --> INIT_NA["notApplicable = 0"]
    INIT --> INIT_REASON["notApplicableReason = NA"]
    INIT --> INIT_THRESHOLD["thresholdValue = NA"]
    INIT --> INIT_NOTES["notesValue = NA"]
    
    INIT_FAILED --> ITER_LOOP["For each check result..."]
    INIT_PASSED --> ITER_LOOP
    INIT_ERROR --> ITER_LOOP
    INIT_NA --> ITER_LOOP
    INIT_REASON --> ITER_LOOP
    INIT_THRESHOLD --> ITER_LOOP
    INIT_NOTES --> ITER_LOOP
    
    ITER_LOOP --> THRESHOLD_EVAL["Threshold Evaluation Logic"]
    THRESHOLD_EVAL --> NA_CALC["Not Applicable Calculation"]
    NA_CALC --> FINAL_PASS["Final Passed Status: if !failed & !isError & !notApplicable then passed = 1"]
```

Sources: [R/evaluateThresholds.R:30-37](), [R/calculateNotApplicableStatus.R:189-191]()

## Integration with Execution Flow

The status evaluation and threshold system integrates with the main execution engine as a post-processing step:

```mermaid
flowchart LR
    subgraph "Main Execution Flow"
        EXECUTE_CHECKS["executeDqChecks()"]
        RUN_CHECK["runCheck()"]
        SQL_EXECUTION["SQL Query Execution"]
    end
    
    subgraph "Results Processing"
        RAW_RESULTS["Raw Results (numViolatedRows, pctViolatedRows, etc.)"]
        EVAL_THRESHOLDS[".evaluateThresholds()"]
        FINAL_RESULTS["Final Results with Status"]
    end
    
    subgraph "Configuration"
        CSV_CONFIGS["CSV Configuration Files"]
    end
    
    EXECUTE_CHECKS --> RUN_CHECK
    RUN_CHECK --> SQL_EXECUTION
    SQL_EXECUTION --> RAW_RESULTS
    RAW_RESULTS --> EVAL_THRESHOLDS
    CSV_CONFIGS --> EVAL_THRESHOLDS
    EVAL_THRESHOLDS --> FINAL_RESULTS
```

This system ensures that all data quality check results receive appropriate status assignments based on both their execution outcomes and the business rules encoded in the threshold and Not Applicable logic.

Sources: [R/evaluateThresholds.R:26-171](), [R/calculateNotApplicableStatus.R:78-195]()