# Page: Execution Modes and SQL Generation

# Execution Modes and SQL Generation

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/runCheck.R](R/runCheck.R)
- [R/sqlOnly.R](R/sqlOnly.R)
- [docs/articles/AddNewCheck.html](docs/articles/AddNewCheck.html)
- [docs/articles/CheckStatusDefinitions.html](docs/articles/CheckStatusDefinitions.html)
- [docs/articles/SqlOnly.html](docs/articles/SqlOnly.html)
- [docs/reference/dot-writeResultsToCsv.html](docs/reference/dot-writeResultsToCsv.html)
- [docs/reference/writeJsonResultsToCsv.html](docs/reference/writeJsonResultsToCsv.html)
- [man/dot-runCheck.Rd](man/dot-runCheck.Rd)

</details>



This document covers the different execution modes available in the DataQualityDashboard system and how SQL generation works across these modes. The system supports three primary execution modes: live execution, basic SQL-only mode, and incremental insert SQL-only mode. Each mode serves different use cases from immediate database analysis to distributed execution scenarios.

For information about the main execution function and its parameters, see [executeDqChecks Function](#3.1). For details about the underlying check implementation, see [Check Implementation](#5).

## Execution Mode Overview

The DataQualityDashboard system supports three distinct execution modes controlled by the `sqlOnly` and `sqlOnlyIncrementalInsert` parameters:

```mermaid
flowchart TD
    START["executeDqChecks()"] --> MODE_CHECK{"sqlOnly parameter"}
    
    MODE_CHECK -->|FALSE| LIVE["Live Execution Mode"]
    MODE_CHECK -->|TRUE| SQL_MODE{"sqlOnlyIncrementalInsert parameter"}
    
    SQL_MODE -->|FALSE| BASIC_SQL["Basic SQL-Only Mode"]
    SQL_MODE -->|TRUE| INCR_SQL["Incremental Insert SQL Mode"]
    
    LIVE --> RUNCHECK_LIVE[".runCheck() - Execute SQL"]
    BASIC_SQL --> RUNCHECK_BASIC[".runCheck() - Write SQL files"]
    INCR_SQL --> RUNCHECK_INCR[".runCheck() - Generate INSERT queries"]
    
    RUNCHECK_LIVE --> PROCESSCHECK[".processCheck()"]
    RUNCHECK_BASIC --> WRITE_FILES["Write individual .sql files"]
    RUNCHECK_INCR --> CREATE_QUERIES[".createSqlOnlyQueries()"]
    
    CREATE_QUERIES --> WRITE_UNION[".writeSqlOnlyQueries()"]
    WRITE_UNION --> DDL_GEN[".writeDDL()"]
    
    PROCESSCHECK --> RESULTS["Return check results"]
    WRITE_FILES --> SQL_FILES["Individual SQL files"]
    DDL_GEN --> INSERT_FILES["INSERT SQL files + DDL"]
```

Sources: [R/runCheck.R:95-134](), [R/sqlOnly.R:33-89](), [R/sqlOnly.R:105-145]()

## Live Execution Mode

Live execution mode (`sqlOnly = FALSE`) is the default behavior where checks are executed immediately against the database and results are processed in memory.

### Live Execution Flow

```mermaid
flowchart TD
    RUNCHECK[".runCheck()"] --> FILTER["Filter checks by evaluationFilter"]
    FILTER --> APPLY["apply() over filtered checks"]
    
    APPLY --> RENDER["SqlRender::loadRenderTranslateSql()"]
    RENDER --> PROCESS[".processCheck()"]
    
    PROCESS --> EXECUTE["DatabaseConnector::querySql()"]
    EXECUTE --> RECORD[".recordResult()"]
    RECORD --> STATUS[".calculateQueryExecutionTime()"]
    STATUS --> RETURN["Return results dataframe"]
    
    subgraph "Parameters Used"
        CONN["connectionDetails"]
        SCHEMA["cdmDatabaseSchema"]
        COHORT["cohortDefinitionId"]
    end
    
    RENDER -.-> CONN
    RENDER -.-> SCHEMA
    RENDER -.-> COHORT
```

In live execution mode, the system:
1. Renders SQL templates with actual database parameters
2. Executes queries immediately against the database 
3. Processes results including error handling and timing
4. Returns structured results for threshold evaluation

Sources: [R/runCheck.R:113-122](), [R/runCheck.R:74-94]()

## Basic SQL-Only Mode

Basic SQL-only mode (`sqlOnly = TRUE`, `sqlOnlyIncrementalInsert = FALSE`) generates SQL files without executing them. This mode is useful for manual review, debugging, or execution in external systems.

### Basic SQL Generation Process

```mermaid
flowchart TD
    RUNCHECK[".runCheck()"] --> CHECK_MODE{"sqlOnly && !sqlOnlyIncrementalInsert"}
    CHECK_MODE -->|TRUE| RENDER["SqlRender::loadRenderTranslateSql()"]
    
    RENDER --> WRITE_FILE["write() to outputFolder"]
    WRITE_FILE --> FILENAME["sprintf('%s.sql', checkDescription$checkName)"]
    
    subgraph "Generated Files"
        FILE1["checkName1.sql"]
        FILE2["checkName2.sql"]
        FILE3["checkNameN.sql"]
    end
    
    FILENAME --> FILE1
    FILENAME --> FILE2
    FILENAME --> FILE3
    
    subgraph "SQL Template Parameters"
        DBMS["connectionDetails$dbms"]
        CDM_SCHEMA["cdmDatabaseSchema"]
        VOCAB_SCHEMA["vocabDatabaseSchema"]
        SQL_FILE["checkDescription$sqlFile"]
    end
    
    RENDER -.-> DBMS
    RENDER -.-> CDM_SCHEMA
    RENDER -.-> VOCAB_SCHEMA
    RENDER -.-> SQL_FILE
```

Each generated SQL file contains:
- Rendered SQL specific to the target database dialect
- Parameterized queries ready for execution
- Comments indicating the check type and purpose

Sources: [R/runCheck.R:107-112](), [R/runCheck.R:79-93]()

## Incremental Insert SQL Mode

Incremental insert mode (`sqlOnly = TRUE`, `sqlOnlyIncrementalInsert = TRUE`) generates SQL INSERT statements that populate a results table. This mode supports performance optimization through query unioning.

### Incremental Insert Architecture

```mermaid
flowchart TD
    RUNCHECK[".runCheck()"] --> INCR_CHECK{"sqlOnly && sqlOnlyIncrementalInsert"}
    INCR_CHECK -->|TRUE| CREATE_QUERY[".createSqlOnlyQueries()"]
    
    CREATE_QUERY --> RECORD_RESULT[".recordResult()"]
    RECORD_RESULT --> GET_THRESHOLD[".getThreshold()"]
    GET_THRESHOLD --> RENDER_CTE["SqlRender - cte_sql_for_results_table.sql"]
    
    RENDER_CTE --> UNION_COLLECT["Collect queries for unioning"]
    UNION_COLLECT --> WRITE_QUERIES[".writeSqlOnlyQueries()"]
    
    WRITE_QUERIES --> BATCH_UNION["Batch queries by sqlOnlyUnionCount"]
    BATCH_UNION --> INSERT_RENDER["SqlRender - insert_ctes_into_result_table.sql"]
    INSERT_RENDER --> WRITE_FILES["Write batched INSERT files"]
    
    subgraph "Union Batching"
        BATCH1["Queries 1-100 UNION ALL"]
        BATCH2["Queries 101-200 UNION ALL"]
        BATCHN["Queries N-M UNION ALL"]
    end
    
    BATCH_UNION --> BATCH1
    BATCH_UNION --> BATCH2
    BATCH_UNION --> BATCHN
    
    subgraph "Generated Files"
        DDL_FILE["ddlDqdResults.sql"]
        INSERT1["TABLE_checkName1.sql"]
        INSERT2["FIELD_checkName2.sql"]
        INSERT3["CONCEPT_checkName3.sql"]
    end
    
    WRITE_FILES --> INSERT1
    WRITE_FILES --> INSERT2
    WRITE_FILES --> INSERT3
```

Sources: [R/runCheck.R:95-106](), [R/runCheck.R:127-131](), [R/sqlOnly.R:33-89](), [R/sqlOnly.R:105-145]()

### SQL Union Optimization

The `sqlOnlyUnionCount` parameter controls performance optimization by batching multiple check queries into single INSERT statements:

| Parameter Value | Behavior | Use Case |
|-----------------|----------|----------|
| 1 | One INSERT per check | Maximum granular control |
| 10-50 | Small batches | Moderate performance gain |
| 100+ | Large batches | Maximum performance on systems like Spark |

```mermaid
flowchart LR
    QUERIES["Individual Check Queries"] --> UNION["UNION ALL Batching"]
    UNION --> INSERT["INSERT INTO results_table"]
    
    subgraph "sqlOnlyUnionCount = 1"
        Q1["Query 1"] --> I1["INSERT 1"]
        Q2["Query 2"] --> I2["INSERT 2"]
    end
    
    subgraph "sqlOnlyUnionCount = 100"
        Q1_100["Queries 1-100"] --> UNION_100["UNION ALL"]
        UNION_100 --> I_BATCH["Single INSERT"]
    end
```

Sources: [R/sqlOnly.R:122-144](), [R/sqlOnly.R:106-112]()

## SQL Template System

The SQL generation process relies on a template system that parameterizes queries for different execution contexts.

### Template Parameter Injection

```mermaid
flowchart TD
    TEMPLATE["SQL Template File"] --> PARAMS["Parameter Collection"]
    
    PARAMS --> DBMS["connectionDetails$dbms"]
    PARAMS --> SQL_FILE["checkDescription$sqlFile"]
    PARAMS --> CDM_SCHEMA["cdmDatabaseSchema"]
    PARAMS --> VOCAB_SCHEMA["vocabDatabaseSchema"]
    PARAMS --> COHORT_PARAMS["Cohort Parameters"]
    
    subgraph "Cohort Parameters"
        COHORT_SCHEMA["cohortDatabaseSchema"]
        COHORT_TABLE["cohortTableName"]
        COHORT_ID["cohortDefinitionId"]
        COHORT_FLAG["cohort boolean"]
    end
    
    COHORT_PARAMS --> COHORT_SCHEMA
    COHORT_PARAMS --> COHORT_TABLE
    COHORT_PARAMS --> COHORT_ID
    COHORT_PARAMS --> COHORT_FLAG
    
    DBMS --> RENDER["SqlRender::loadRenderTranslateSql()"]
    SQL_FILE --> RENDER
    CDM_SCHEMA --> RENDER
    VOCAB_SCHEMA --> RENDER
    COHORT_SCHEMA --> RENDER
    COHORT_TABLE --> RENDER
    COHORT_ID --> RENDER
    COHORT_FLAG --> RENDER
    
    RENDER --> TRANSLATED_SQL["Database-Specific SQL"]
```

### Key Template Parameters

| Parameter | Purpose | Example Value |
|-----------|---------|---------------|
| `@cdmDatabaseSchema` | CDM database location | `"my_cdm.dbo"` |
| `@vocabDatabaseSchema` | Vocabulary database location | `"my_vocab.dbo"` |
| `@cohortDatabaseSchema` | Cohort table location | `"results.dbo"` |
| `@cohortTableName` | Cohort table name | `"cohort"` |
| `@cohortDefinitionId` | Specific cohort ID | `1001` |
| `@cdmTableName` | Dynamic table name | `"PERSON"` |
| `@cdmFieldName` | Dynamic field name | `"person_id"` |

Sources: [R/runCheck.R:79-91](), [R/runCheck.R:67-71]()

## Results Table Schema

In incremental insert mode, the system generates DDL for a standardized results table structure:

### Results Table Generation

```mermaid
flowchart TD
    WRITE_DDL[".writeDDL()"] --> RENDER_DDL["SqlRender - result_dataframe_ddl.sql"]
    RENDER_DDL --> TABLE_NAME["resultsDatabaseSchema.writeTableName"]
    TABLE_NAME --> DDL_FILE["ddlDqdResults.sql"]
    
    subgraph "DDL Parameters"
        RESULTS_SCHEMA["resultsDatabaseSchema"]
        WRITE_TABLE["writeTableName"]
        TARGET_DBMS["connectionDetails$dbms"]
    end
    
    RENDER_DDL -.-> RESULTS_SCHEMA
    RENDER_DDL -.-> WRITE_TABLE
    RENDER_DDL -.-> TARGET_DBMS
    
    subgraph "Generated Table Structure"
        COLUMNS["checkId, checkName, checkLevel, checkDescription, cdmTableName, cdmFieldName, numViolatedRows, pctViolatedRows, thresholdValue, notesValue, ..."]
    end
    
    DDL_FILE --> COLUMNS
```

Sources: [R/sqlOnly.R:157-178]()

## Threshold Integration

The SQL generation process includes threshold evaluation logic, particularly in incremental insert mode where thresholds must be embedded in the generated SQL.

### Threshold Retrieval Process

```mermaid
flowchart TD
    GET_THRESHOLD[".getThreshold()"] --> CHECK_LEVEL{"checkLevel"}
    
    CHECK_LEVEL -->|TABLE| TABLE_FILTER["tableChecks$thresholdField[cdmTableName match]"]
    CHECK_LEVEL -->|FIELD| FIELD_FILTER["fieldChecks$thresholdField[table + field match]"]
    CHECK_LEVEL -->|CONCEPT| CONCEPT_FILTER["conceptChecks$thresholdField[concept match]"]
    
    TABLE_FILTER --> THRESHOLD_VALUE["Numeric threshold value"]
    FIELD_FILTER --> THRESHOLD_VALUE
    CONCEPT_FILTER --> THRESHOLD_VALUE
    
    THRESHOLD_VALUE --> DEFAULT_ZERO["NA values become 0"]
    DEFAULT_ZERO --> SQL_EMBED["Embed in generated SQL"]
    
    subgraph "Threshold Field Pattern"
        PATTERN["sprintf('%sThreshold', checkName)"]
        EXAMPLE["'measurePersonCompletenessThreshold'"]
    end
    
    PATTERN --> EXAMPLE
    GET_THRESHOLD -.-> PATTERN
```

Sources: [R/sqlOnly.R:196-279](), [R/sqlOnly.R:47-58]()

This execution mode and SQL generation system provides flexibility for different deployment scenarios while maintaining consistent check logic across all modes.