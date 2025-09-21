# Page: Advanced Usage

# Advanced Usage

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



This page covers advanced features and configuration options for the DataQualityDashboard package, including SQL-only execution modes, cohort-based analysis, custom thresholds, performance optimization, and output format customization. For basic usage and getting started, see [Getting Started](#2). For details on adding new data quality checks to the system, see [Adding Custom Checks](#8.2).

## SQL-Only Mode and Performance Optimization

The DataQualityDashboard supports advanced SQL generation modes that allow for optimized execution patterns and deployment flexibility. The primary modes are controlled through the `sqlOnly`, `sqlOnlyIncrementalInsert`, and `sqlOnlyUnionCount` parameters in the `executeDqChecks` function.

### SQL Generation Modes

```mermaid
graph TD
    EXEC["executeDqChecks()"] --> MODE_CHECK{"sqlOnly = TRUE?"}
    MODE_CHECK -->|No| LIVE_EXEC["Live Execution Mode"]
    MODE_CHECK -->|Yes| SQL_MODE_CHECK{"sqlOnlyIncrementalInsert?"}
    
    SQL_MODE_CHECK -->|FALSE| BASIC_SQL[".runCheck()<br/>Basic SQL Generation"]
    SQL_MODE_CHECK -->|TRUE| INCREMENTAL[".createSqlOnlyQueries()<br/>Incremental Insert Mode"]
    
    BASIC_SQL --> SQL_FILES["Individual .sql files<br/>One per check"]
    
    INCREMENTAL --> UNION_CHECK{"sqlOnlyUnionCount > 1?"}
    UNION_CHECK -->|Yes| UNION_QUERIES[".writeSqlOnlyQueries()<br/>Batched UNION queries"]
    UNION_CHECK -->|No| SINGLE_QUERIES["Individual INSERT queries"]
    
    UNION_QUERIES --> PERF_FILES["Optimized .sql files<br/>Multiple checks per file"]
    SINGLE_QUERIES --> BASIC_FILES["Standard .sql files<br/>One check per file"]
    
    LIVE_EXEC --> RESULTS["Direct Results"]
    SQL_FILES --> MANUAL_EXEC["Manual Execution Required"]
    PERF_FILES --> DATABASE_INSERT["Direct Database INSERT"]
    BASIC_FILES --> DATABASE_INSERT
```

**SQL-Only Mode Configuration**

Sources: [R/runCheck.R:95-106](), [R/sqlOnly.R:33-89](), [docs/articles/SqlOnly.html:250-314]()

### Incremental Insert Mode

The `sqlOnlyIncrementalInsert` mode generates SQL queries that directly populate a results table in the database. This mode uses the `.createSqlOnlyQueries()` function to wrap individual check queries with metadata insertion logic.

```mermaid
graph LR
    subgraph "Query Generation Pipeline"
        CHECK_DESC["checkDescription"] --> PARAMS["SQL Parameters<br/>@cdmDatabaseSchema<br/>@cdmTableName<br/>@cdmFieldName"]
        PARAMS --> RENDER["SqlRender::loadRenderTranslateSql()"]
        RENDER --> BASE_SQL["Base Check Query"]
    end
    
    subgraph "Incremental Insert Wrapping"
        BASE_SQL --> RECORD_RESULT[".recordResult()<br/>Add metadata shell"]
        RECORD_RESULT --> GET_THRESHOLD[".getThreshold()<br/>Retrieve threshold value"]
        GET_THRESHOLD --> CTE_WRAPPER["CTE Wrapper SQL<br/>cte_sql_for_results_table.sql"]
    end
    
    subgraph "Batch Processing"
        CTE_WRAPPER --> UNION_LOGIC[".writeSqlOnlyQueries()<br/>Union multiple CTEs"]
        UNION_LOGIC --> FINAL_INSERT["INSERT INTO results table"]
    end
```

**Incremental Insert Process**

Sources: [R/sqlOnly.R:68-88](), [R/sqlOnly.R:105-145]()

### Performance Tuning Parameters

| Parameter | Default | Purpose | Performance Impact |
|-----------|---------|---------|-------------------|
| `sqlOnlyUnionCount` | 1 | Number of checks to union in single query | 10x+ improvement on Spark with higher values |
| `sqlOnlyIncrementalInsert` | FALSE | Generate INSERT queries vs. standalone SQL | Enables batch processing |
| `sqlOnly` | FALSE | Generate SQL without execution | Eliminates R-to-database round trips |

Sources: [R/runCheck.R:33-34](), [docs/articles/SqlOnly.html:217-228]()

## Cohort-Based Analysis

The system supports running data quality checks on specific patient cohorts rather than entire CDM databases. This is implemented through cohort filtering parameters that modify the SQL generation process.

### Cohort Configuration

```mermaid
graph TD
    subgraph "Cohort Parameters"
        COHORT_SCHEMA["cohortDatabaseSchema<br/>Schema containing cohort table"]
        COHORT_TABLE["cohortTableName<br/>Name of cohort table"]
        COHORT_ID["cohortDefinitionId<br/>Specific cohort to analyze"]
    end
    
    subgraph "SQL Parameter Injection"
        PARAMS_BUILD["Parameter Collection<br/>R/runCheck.R:79-91"]
        COHORT_FLAG["cohort = TRUE/FALSE<br/>R/runCheck.R:67-71"]
    end
    
    subgraph "Query Modification"
        SQL_RENDER["SqlRender::loadRenderTranslateSql()"]
        COHORT_FILTER["Cohort JOIN conditions<br/>Added to base queries"]
    end
    
    COHORT_SCHEMA --> PARAMS_BUILD
    COHORT_TABLE --> PARAMS_BUILD
    COHORT_ID --> PARAMS_BUILD
    COHORT_ID --> COHORT_FLAG
    
    PARAMS_BUILD --> SQL_RENDER
    COHORT_FLAG --> SQL_RENDER
    SQL_RENDER --> COHORT_FILTER
```

**Cohort Parameter Flow**

### Implementation Details

The cohort filtering is implemented through SQL parameter injection in the `.runCheck()` function. When `cohortDefinitionId` is provided, the system sets `cohort = TRUE` and passes cohort-related parameters to the SQL rendering engine.

```mermaid
graph LR
    CHECK_EXECUTION[".runCheck()"] --> COHORT_CHECK{"length(cohortDefinitionId) > 0"}
    COHORT_CHECK -->|Yes| SET_COHORT["cohort = TRUE"]
    COHORT_CHECK -->|No| SET_NO_COHORT["cohort = FALSE"]
    
    SET_COHORT --> PARAM_LIST["Parameter List:<br/>- cohortDatabaseSchema<br/>- cohortTableName<br/>- cohortDefinitionId<br/>- cohort = TRUE"]
    SET_NO_COHORT --> PARAM_LIST_BASIC["Basic Parameters Only"]
    
    PARAM_LIST --> SQL_TEMPLATE["SQL Template Processing"]
    PARAM_LIST_BASIC --> SQL_TEMPLATE
```

**Cohort Logic Flow**

Sources: [R/runCheck.R:67-71](), [R/runCheck.R:85-89]()

## Custom Thresholds and Configuration

The threshold system allows fine-grained control over pass/fail criteria for data quality checks. Thresholds are managed through the `.getThreshold()` function and are hierarchically organized by check level.

### Threshold Resolution Hierarchy

```mermaid
graph TD
    subgraph "Threshold Sources"
        TABLE_THRESH["tableChecks$<checkName>Threshold"]
        FIELD_THRESH["fieldChecks$<checkName>Threshold"]
        CONCEPT_THRESH["conceptChecks$<checkName>Threshold"]
    end
    
    subgraph "Resolution Logic"
        CHECK_LEVEL{"checkLevel"}
        FIELD_EXISTS{"thresholdField exists?"}
        THRESHOLD_FILTER["Dynamic filter construction"]
    end
    
    subgraph "Matching Criteria"
        TABLE_MATCH["cdmTableName match"]
        FIELD_MATCH["cdmTableName + cdmFieldName match"]
        CONCEPT_MATCH["cdmTableName + cdmFieldName + conceptId match"]
        UNIT_MATCH["+ unitConceptId match (if applicable)"]
    end
    
    CHECK_LEVEL -->|TABLE| TABLE_THRESH
    CHECK_LEVEL -->|FIELD| FIELD_THRESH
    CHECK_LEVEL -->|CONCEPT| CONCEPT_THRESH
    
    TABLE_THRESH --> FIELD_EXISTS
    FIELD_THRESH --> FIELD_EXISTS
    CONCEPT_THRESH --> FIELD_EXISTS
    
    FIELD_EXISTS -->|Yes| THRESHOLD_FILTER
    FIELD_EXISTS -->|No| DEFAULT_ZERO["thresholdValue = 0"]
    
    THRESHOLD_FILTER --> TABLE_MATCH
    THRESHOLD_FILTER --> FIELD_MATCH
    THRESHOLD_FILTER --> CONCEPT_MATCH
    CONCEPT_MATCH --> UNIT_MATCH
```

**Threshold Resolution Process**

### Dynamic Threshold Filtering

The `.getThreshold()` function constructs dynamic filter expressions based on the check level and available identifiers:

| Check Level | Filter Pattern | Example |
|-------------|----------------|---------|
| TABLE | `tableChecks$<field>[tableChecks$cdmTableName == '<table>']` | `measurePersonCompletenessThreshold` |
| FIELD | `fieldChecks$<field>[fieldChecks$cdmTableName == '<table>' & fieldChecks$cdmFieldName == '<field>']` | `isRequiredThreshold` |
| CONCEPT | Complex logic handling `conceptId` and optional `unitConceptId` | `plausibleGenderThreshold` |

Sources: [R/sqlOnly.R:196-279](), [R/sqlOnly.R:220-268]()

## Output Format Customization

The system supports multiple output formats through a flexible export system that can be customized for different use cases.

### Output Format Pipeline

```mermaid
graph LR
    subgraph "Core Results"
        RESULTS_DF["Check Results DataFrame"]
        JSON_CORE["JSON Results"]
        DB_TABLE["Database Table"]
    end
    
    subgraph "Export Functions"
        JSON_TO_CSV["writeJsonResultsToCsv()"]
        RESULTS_TO_CSV[".writeResultsToCsv()"]
        DB_TO_JSON["writeDBResultsToJson()"]
    end
    
    subgraph "Output Formats"
        CSV_FILE["CSV Export<br/>Customizable columns"]
        JSON_FILE["JSON Export<br/>Full metadata"]
        CUSTOM_FORMAT["Custom Delimiter<br/>Tab, pipe, etc."]
    end
    
    RESULTS_DF --> RESULTS_TO_CSV
    JSON_CORE --> JSON_TO_CSV
    DB_TABLE --> DB_TO_JSON
    
    JSON_TO_CSV --> CSV_FILE
    RESULTS_TO_CSV --> CSV_FILE
    RESULTS_TO_CSV --> CUSTOM_FORMAT
    DB_TO_JSON --> JSON_FILE
```

**Output Format Options**

### Column Customization

Both CSV export functions support column selection through the `columns` parameter:

```mermaid
graph TD
    DEFAULT_COLS["Default Column Set<br/>checkId, failed, passed, isError, notApplicable<br/>checkName, checkDescription, thresholdValue<br/>notesValue, checkLevel, category, subcategory<br/>context, cdmTableName, cdmFieldName<br/>conceptId, unitConceptId, numViolatedRows<br/>pctViolatedRows, numDenominatorRows<br/>executionTime, notApplicableReason<br/>error, queryText"]
    
    CUSTOM_COLS["Custom Column Selection<br/>User-specified subset"]
    
    DELIMITER_OPT["Delimiter Options<br/>Comma (default), Tab, Pipe, etc."]
    
    DEFAULT_COLS --> CSV_OUTPUT["CSV File Output"]
    CUSTOM_COLS --> CSV_OUTPUT
    DELIMITER_OPT --> CSV_OUTPUT
```

**CSV Export Customization**

Sources: [docs/reference/writeJsonResultsToCsv.html:172-181](), [docs/reference/dot-writeResultsToCsv.html:172-181]()

## Performance Optimization Strategies

The system provides several mechanisms for optimizing performance in large-scale deployments.

### Execution Mode Performance Comparison

```mermaid
graph TD
    subgraph "Standard Execution"
        STD_EXEC["executeDqChecks()<br/>sqlOnly = FALSE"]
        STD_SINGLE["Individual R-to-DB calls<br/>One per check"]
        STD_PROCESS["R processing overhead<br/>Status evaluation, formatting"]
    end
    
    subgraph "SQL-Only Basic"
        SQL_BASIC["executeDqChecks()<br/>sqlOnly = TRUE<br/>sqlOnlyIncrementalInsert = FALSE"]
        SQL_FILES["Generated .sql files<br/>Manual execution required"]
    end
    
    subgraph "SQL-Only Incremental"
        SQL_INCR["executeDqChecks()<br/>sqlOnly = TRUE<br/>sqlOnlyIncrementalInsert = TRUE<br/>sqlOnlyUnionCount = 100"]
        SQL_BATCH["Batched INSERT queries<br/>100 checks per statement"]
        SQL_PERF["10x+ performance improvement"]
    end
    
    STD_EXEC --> STD_SINGLE
    STD_SINGLE --> STD_PROCESS
    
    SQL_BASIC --> SQL_FILES
    
    SQL_INCR --> SQL_BATCH
    SQL_BATCH --> SQL_PERF
```

**Performance Mode Comparison**

### Optimization Parameters

| Parameter | Impact | Recommendation |
|-----------|--------|----------------|
| `sqlOnlyUnionCount` | Query batching efficiency | 25-100 for most databases |
| `checkLevels` | Scope reduction | Limit to needed levels only |
| `tablesToExclude` | Reduces check count | Exclude unused CDM tables |
| `checkNames` | Targeted execution | Specify subset for testing |

Sources: [docs/articles/SqlOnly.html:264-289](), [R/sqlOnly.R:122-144]()

## System Extension Points

The DataQualityDashboard provides several extension points for customization and integration with other systems.

### Extension Architecture

```mermaid
graph LR
    subgraph "Configuration Extension"
        CHECK_DESC["Check Descriptions<br/>inst/csv/*.csv"]
        SQL_TEMPLATES["SQL Templates<br/>inst/sql/sql_server/*.sql"]
        THRESHOLD_CONFIG["Threshold Configuration<br/>CSV field definitions"]
    end
    
    subgraph "Processing Extension"
        RUN_CHECK[".runCheck()<br/>Individual check processor"]
        PROCESS_CHECK[".processCheck()<br/>Result handling"]
        RECORD_RESULT[".recordResult()<br/>Metadata assembly"]
    end
    
    subgraph "Output Extension"
        RESULT_SUMMARY[".summarizeResults()<br/>Status evaluation"]
        WRITE_JSON[".writeResultsToJson()<br/>JSON formatting"]
        WRITE_CSV[".writeResultsToCsv()<br/>CSV formatting"]
    end
    
    CHECK_DESC --> RUN_CHECK
    SQL_TEMPLATES --> RUN_CHECK
    THRESHOLD_CONFIG --> RUN_CHECK
    
    RUN_CHECK --> PROCESS_CHECK
    PROCESS_CHECK --> RECORD_RESULT
    
    RECORD_RESULT --> RESULT_SUMMARY
    RESULT_SUMMARY --> WRITE_JSON
    RESULT_SUMMARY --> WRITE_CSV
```

**Extension Points**

### Custom Integration Patterns

The system supports several integration patterns for embedding into larger ETL or quality monitoring workflows:

1. **SQL-Only Integration**: Generate SQL for execution within existing ETL processes
2. **Result Export Integration**: Export results in custom formats for downstream processing  
3. **Threshold Override**: Programmatic threshold management for dynamic quality criteria
4. **Custom Output Processing**: Extend output formatters for specific reporting requirements

Sources: [R/runCheck.R:41-139](), [R/sqlOnly.R:17-89](), [docs/articles/AddNewCheck.html:207-347]()