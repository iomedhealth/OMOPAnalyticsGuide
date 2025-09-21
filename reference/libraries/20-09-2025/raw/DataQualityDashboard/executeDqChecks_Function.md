# Page: executeDqChecks Function

# executeDqChecks Function

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [DESCRIPTION](DESCRIPTION)
- [NAMESPACE](NAMESPACE)
- [NEWS.md](NEWS.md)
- [R/executeDqChecks.R](R/executeDqChecks.R)
- [docs/LICENSE-text.html](docs/LICENSE-text.html)
- [docs/authors.html](docs/authors.html)
- [docs/reference/executeDqChecks.html](docs/reference/executeDqChecks.html)
- [docs/reference/index.html](docs/reference/index.html)
- [docs/reference/viewDqDashboard.html](docs/reference/viewDqDashboard.html)
- [docs/reference/writeJsonResultsToTable.html](docs/reference/writeJsonResultsToTable.html)

</details>



This page provides comprehensive documentation for the `executeDqChecks` function, which serves as the primary entry point and orchestrator for the entire Data Quality Dashboard system. The function coordinates database connections, SQL generation, parallel execution of data quality checks, results processing, and output generation across multiple formats.

For information about specific execution modes and SQL generation details, see [Execution Modes and SQL Generation](#3.2). For details about individual check implementations, see [Check Implementation](#5).

## Function Overview

The `executeDqChecks` function is defined in [R/executeDqChecks.R:63-391]() and serves as the main interface for running data quality assessments against OMOP CDM databases. It supports three primary execution modes: live database execution, SQL-only script generation, and incremental insert batch processing.

```mermaid
graph TD
    subgraph "Function Input Parameters"
        CONN["connectionDetails"]
        SCHEMAS["Database Schemas<br/>cdmDatabaseSchema<br/>resultsDatabaseSchema<br/>vocabDatabaseSchema"]
        EXEC_PARAMS["Execution Parameters<br/>numThreads<br/>sqlOnly<br/>verboseMode"]
        OUTPUT_PARAMS["Output Parameters<br/>outputFolder<br/>writeToTable<br/>writeToCsv"]
        FILTER_PARAMS["Filter Parameters<br/>checkLevels<br/>checkNames<br/>checkSeverity"]
    end
    
    subgraph "executeDqChecks Function"
        VALIDATE["Parameter Validation<br/>Lines 90-130"]
        METADATA["Metadata Capture<br/>Lines 135-158"]
        SETUP["Output Setup<br/>Lines 160-197"]
        LOAD_CONFIG["Load Configuration<br/>Lines 203-289"]
        PARALLEL_EXEC["Parallel Execution<br/>Lines 290-316"]
        PROCESS_RESULTS["Results Processing<br/>Lines 320-390"]
    end
    
    subgraph "Function Outputs"
        JSON_OUT["JSON Results File"]
        DB_OUT["Database Table"]
        CSV_OUT["CSV File"]
        SQL_OUT["SQL Scripts"]
        LOGS["Log Files"]
    end
    
    CONN --> VALIDATE
    SCHEMAS --> VALIDATE
    EXEC_PARAMS --> VALIDATE
    OUTPUT_PARAMS --> VALIDATE
    FILTER_PARAMS --> VALIDATE
    
    VALIDATE --> METADATA
    METADATA --> SETUP
    SETUP --> LOAD_CONFIG
    LOAD_CONFIG --> PARALLEL_EXEC
    PARALLEL_EXEC --> PROCESS_RESULTS
    
    PROCESS_RESULTS --> JSON_OUT
    PROCESS_RESULTS --> DB_OUT
    PROCESS_RESULTS --> CSV_OUT
    PROCESS_RESULTS --> SQL_OUT
    SETUP --> LOGS
```

Sources: [R/executeDqChecks.R:63-391]()

## Parameter Categories

The function accepts 27 parameters organized into logical categories for database connectivity, execution control, filtering, and output configuration.

### Database Connection Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `connectionDetails` | ConnectionDetails | Database connection object |
| `cdmDatabaseSchema` | character | CDM schema location |
| `resultsDatabaseSchema` | character | Results schema location |
| `vocabDatabaseSchema` | character | Vocabulary schema (defaults to CDM schema) |

### Execution Control Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `numThreads` | 1 | Concurrent execution threads |
| `sqlOnly` | FALSE | Generate SQL scripts without execution |
| `sqlOnlyUnionCount` | 1 | SQL unions per incremental insert query |
| `sqlOnlyIncrementalInsert` | FALSE | Generate incremental insert SQL |
| `verboseMode` | FALSE | Console logging verbosity |

### Check Filtering Parameters

```mermaid
graph LR
    subgraph "Check Level Filtering"
        TABLE_LEVEL["TABLE Level<br/>cdmTable, measurePersonCompleteness"]
        FIELD_LEVEL["FIELD Level<br/>isRequired, cdmDatatype"]
        CONCEPT_LEVEL["CONCEPT Level<br/>plausibleGender, plausibleUnitConceptIds"]
    end
    
    subgraph "Severity Filtering"
        FATAL["fatal<br/>Critical CDM integrity"]
        CONVENTION["convention<br/>OMOP best practices"]
        CHARACTERIZATION["characterization<br/>Data understanding"]
    end
    
    subgraph "Granular Filtering"
        CHECK_NAMES["checkNames<br/>Specific check selection"]
        TABLES_EXCLUDE["tablesToExclude<br/>Skip vocabulary tables"]
    end
    
    TABLE_LEVEL --> FATAL
    FIELD_LEVEL --> CONVENTION
    CONCEPT_LEVEL --> CHARACTERIZATION
```

Sources: [R/executeDqChecks.R:79-81](), [R/executeDqChecks.R:85](), [R/executeDqChecks.R:110-118]()

## Execution Modes

The function supports three distinct execution modes controlled by the `sqlOnly` and `sqlOnlyIncrementalInsert` parameters.

### Live Execution Mode

When `sqlOnly = FALSE` (default), the function:
- Establishes database connections
- Executes SQL queries in parallel
- Processes and evaluates results
- Generates output files and database records

```mermaid
sequenceDiagram
    participant User
    participant executeDqChecks
    participant DatabaseConnector
    participant ParallelLogger
    participant ResultsProcessor

    User->>executeDqChecks: Call with sqlOnly=FALSE
    executeDqChecks->>DatabaseConnector: Connect to database
    executeDqChecks->>ParallelLogger: Create thread cluster
    executeDqChecks->>ParallelLogger: Execute checks in parallel
    ParallelLogger->>ResultsProcessor: Process check results
    ResultsProcessor->>executeDqChecks: Return processed results
    executeDqChecks->>User: Return results list
```

### SQL-Only Mode

When `sqlOnly = TRUE`, the function generates SQL scripts without database execution:

```mermaid
graph TD
    SQL_ONLY["sqlOnly = TRUE"]
    INCR_FLAG{"sqlOnlyIncrementalInsert?"}
    
    SQL_ONLY --> INCR_FLAG
    
    INCR_FLAG -->|FALSE| BASIC_SQL["Generate Basic SQL Scripts<br/>Backward compatibility mode"]
    INCR_FLAG -->|TRUE| INCR_SQL["Generate Incremental Insert SQL<br/>With metadata and batching"]
    
    BASIC_SQL --> DDL_OUT["Output DDL Scripts"]
    INCR_SQL --> DDL_OUT
    INCR_SQL --> BATCH_SQL["Batched INSERT Statements<br/>sqlOnlyUnionCount parameter"]
```

Sources: [R/executeDqChecks.R:69-71](), [R/executeDqChecks.R:99-101](), [R/executeDqChecks.R:358-360]()

## Internal Execution Flow

The function follows a structured execution pipeline with comprehensive error handling and logging.

```mermaid
flowchart TD
    START["Function Entry"] --> VALIDATE["Parameter Validation<br/>Lines 90-130"]
    
    VALIDATE --> METADATA_CHECK{"sqlOnly?"}
    METADATA_CHECK -->|FALSE| DB_METADATA["Database Metadata Capture<br/>Lines 136-152"]
    METADATA_CHECK -->|TRUE| STATIC_METADATA["Static Metadata Creation<br/>Lines 153-158"]
    
    DB_METADATA --> SETUP_OUTPUT
    STATIC_METADATA --> SETUP_OUTPUT["Output Folder Setup<br/>Lines 160-169"]
    
    SETUP_OUTPUT --> LOGGING["Logging Configuration<br/>Lines 171-197"]
    
    LOGGING --> LOAD_THRESHOLDS["Load Threshold Files<br/>Lines 203-225"]
    
    LOAD_THRESHOLDS --> FILTER_CHECKS["Filter and Configure Checks<br/>Lines 227-289"]
    
    FILTER_CHECKS --> PARALLEL_SETUP["Parallel Execution Setup<br/>Lines 290-291"]
    
    PARALLEL_SETUP --> RUN_CHECKS["Execute Checks via .runCheck<br/>Lines 291-312"]
    
    RUN_CHECKS --> EXECUTION_MODE{"sqlOnly?"}
    
    EXECUTION_MODE -->|FALSE| PROCESS_RESULTS["Process Results<br/>Lines 320-347"]
    EXECUTION_MODE -->|TRUE| WRITE_DDL["Write DDL Scripts<br/>Line 359"]
    
    PROCESS_RESULTS --> WRITE_OUTPUTS["Write Output Files<br/>Lines 364-384"]
    WRITE_DDL --> END_SQL["Return NULL"]
    WRITE_OUTPUTS --> RETURN_RESULTS["Return Results List<br/>Line 389"]
    
    END_SQL --> FUNCTION_END
    RETURN_RESULTS --> FUNCTION_END["Function Exit"]
```

Sources: [R/executeDqChecks.R:90-391]()

### Parallel Execution Architecture

The function uses `ParallelLogger` to execute checks concurrently:

```mermaid
graph TD
    subgraph "Main Thread"
        MAIN["executeDqChecks Main Function"]
        CLUSTER_SETUP["ParallelLogger::makeCluster<br/>Line 290"]
        CLUSTER_APPLY["ParallelLogger::clusterApply<br/>Lines 291-311"]
        CLUSTER_STOP["ParallelLogger::stopCluster<br/>Line 312"]
    end
    
    subgraph "Worker Threads"
        WORKER1[".runCheck Worker 1"]
        WORKER2[".runCheck Worker 2"]
        WORKERN[".runCheck Worker N"]
    end
    
    subgraph "Check Execution Parameters"
        CHECK_DESC["checkDescriptions<br/>Split by check"]
        TABLE_CHECKS["tableChecks configuration"]
        FIELD_CHECKS["fieldChecks configuration"]
        CONCEPT_CHECKS["conceptChecks configuration"]
        CONN_DETAILS["connectionDetails"]
    end
    
    MAIN --> CLUSTER_SETUP
    CLUSTER_SETUP --> CLUSTER_APPLY
    
    CLUSTER_APPLY --> WORKER1
    CLUSTER_APPLY --> WORKER2
    CLUSTER_APPLY --> WORKERN
    
    CHECK_DESC --> WORKER1
    CHECK_DESC --> WORKER2
    CHECK_DESC --> WORKERN
    
    TABLE_CHECKS --> WORKER1
    FIELD_CHECKS --> WORKER1
    CONCEPT_CHECKS --> WORKER1
    CONN_DETAILS --> WORKER1
    
    WORKER1 --> CLUSTER_STOP
    WORKER2 --> CLUSTER_STOP
    WORKERN --> CLUSTER_STOP
    
    CLUSTER_STOP --> MAIN
```

Sources: [R/executeDqChecks.R:290-312]()

## Return Values and Output Formats

### Live Execution Return Object

When `sqlOnly = FALSE`, the function returns a structured list containing:

| Field | Type | Description |
|-------|------|-------------|
| `startTimestamp` | POSIXct | Execution start time |
| `endTimestamp` | POSIXct | Execution end time |
| `executionTime` | character | Human-readable duration |
| `executionTimeSeconds` | numeric | Duration in seconds |
| `CheckResults` | data.frame | Individual check results |
| `Metadata` | data.frame | CDM source metadata |
| `Overview` | data.frame | Results summary |

### Output File Generation

```mermaid
graph LR
    subgraph "Output Generation Flow"
        RESULTS["allResults List Object"]
        
        JSON_WRITE["writeResultsToJson<br/>Line 355"]
        TABLE_WRITE["writeResultsToTable<br/>Lines 364-372"]
        CSV_WRITE["writeResultsToCsv<br/>Lines 376-384"]
        
        RESULTS --> JSON_WRITE
        RESULTS --> TABLE_WRITE
        RESULTS --> CSV_WRITE
    end
    
    subgraph "Output Files"
        JSON_FILE["JSON Results File<br/>cdmsource-timestamp.json"]
        DB_TABLE["dqdashboard_results Table"]
        CSV_FILE["Results CSV File"]
    end
    
    JSON_WRITE --> JSON_FILE
    TABLE_WRITE --> DB_TABLE
    CSV_WRITE --> CSV_FILE
```

Sources: [R/executeDqChecks.R:338-347](), [R/executeDqChecks.R:355](), [R/executeDqChecks.R:364-384]()

## Error Handling and Validation

The function implements comprehensive parameter validation and error handling throughout execution.

### Parameter Validation

```mermaid
graph TD
    subgraph "Validation Checks"
        CONN_VALID["ConnectionDetails Validation<br/>Lines 91-93"]
        CDM_VERSION["CDM Version Regex Check<br/>Lines 95-97"]
        SQL_MODE_VALID["SQL Mode Consistency<br/>Lines 99-101"]
        TYPE_CHECKS["Parameter Type Validation<br/>Lines 103-125"]
        ENUM_CHECKS["Enumeration Validation<br/>Lines 110-118"]
    end
    
    subgraph "Validation Rules"
        CONNECTION_CLASS["Must be connectionDetails or ConnectionDetails"]
        VERSION_REGEX["Must match acceptedCdmRegex pattern"]
        SQL_CONSISTENCY["sqlOnlyIncrementalInsert requires sqlOnly=TRUE"]
        CHECK_LEVELS["Must be subset of TABLE, FIELD, CONCEPT"]
        CHECK_SEVERITY["Must be subset of fatal, convention, characterization"]
    end
    
    CONN_VALID --> CONNECTION_CLASS
    CDM_VERSION --> VERSION_REGEX
    SQL_MODE_VALID --> SQL_CONSISTENCY
    TYPE_CHECKS --> CHECK_LEVELS
    ENUM_CHECKS --> CHECK_SEVERITY
```

### Runtime Error Handling

The function includes error handling for:
- Database connection failures [R/executeDqChecks.R:137-143]()
- Empty CDM source table [R/executeDqChecks.R:144-146]()
- Missing check configurations [R/executeDqChecks.R:264-266]()
- Invalid threshold file locations
- SQL execution errors within individual checks

Sources: [R/executeDqChecks.R:90-130](), [R/executeDqChecks.R:137-158](), [R/executeDqChecks.R:264-266]()