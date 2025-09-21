# Page: Adding Custom Checks

# Adding Custom Checks

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [docs/articles/AddNewCheck.html](docs/articles/AddNewCheck.html)
- [docs/articles/CheckStatusDefinitions.html](docs/articles/CheckStatusDefinitions.html)
- [docs/articles/SqlOnly.html](docs/articles/SqlOnly.html)
- [docs/reference/dot-writeResultsToCsv.html](docs/reference/dot-writeResultsToCsv.html)
- [docs/reference/writeJsonResultsToCsv.html](docs/reference/writeJsonResultsToCsv.html)
- [inst/csv/OMOP_CDMv5.2_Check_Descriptions.csv](inst/csv/OMOP_CDMv5.2_Check_Descriptions.csv)
- [inst/csv/OMOP_CDMv5.3_Check_Descriptions.csv](inst/csv/OMOP_CDMv5.3_Check_Descriptions.csv)
- [inst/csv/OMOP_CDMv5.4_Check_Descriptions.csv](inst/csv/OMOP_CDMv5.4_Check_Descriptions.csv)
- [inst/sql/sql_server/field_within_visit_dates.sql](inst/sql/sql_server/field_within_visit_dates.sql)

</details>



This document provides a comprehensive guide for adding new data quality checks to the DataQualityDashboard system. It covers the complete process from writing SQL queries to integrating them into the framework's execution engine and configuration system.

For information about the existing check types and their implementations, see [Check Implementation](#5). For details about threshold configuration and evaluation, see [Status Evaluation and Thresholds](#6.1).

## Overview

The DataQualityDashboard allows extension through custom checks that follow the same architectural patterns as the built-in checks. Custom checks integrate with the existing framework through configuration files and parameterized SQL templates.

```mermaid
graph TD
    subgraph "Custom Check Development Process"
        WRITE_SQL["Write SQL Query<br/>Custom business logic"]
        FORMAT_TEMPLATE["Format as DQD Template<br/>Add parameters & output structure"]
        CREATE_SQL_FILE["Create SQL File<br/>inst/sql/sql_server/"]
        ADD_DESCRIPTION["Add to Check Descriptions<br/>OMOP_CDMv5.X_Check_Descriptions.csv"]
        ADD_LEVEL_CONFIG["Add to Level Configuration<br/>Field/Table/Concept CSV files"]
    end
    
    subgraph "DQD Framework Integration"
        EXECUTEDQCHECKS["executeDqChecks"]
        RUNCHECK["runCheck"]
        SQLRENDER["SqlRender"]
        CHECKDEFS["Check Definitions"]
    end
    
    WRITE_SQL --> FORMAT_TEMPLATE
    FORMAT_TEMPLATE --> CREATE_SQL_FILE
    CREATE_SQL_FILE --> ADD_DESCRIPTION
    ADD_DESCRIPTION --> ADD_LEVEL_CONFIG
    
    ADD_LEVEL_CONFIG --> CHECKDEFS
    CHECKDEFS --> EXECUTEDQCHECKS
    EXECUTEDQCHECKS --> RUNCHECK
    RUNCHECK --> SQLRENDER
    
    CREATE_SQL_FILE --> SQLRENDER
```

**Sources:** [docs/articles/AddNewCheck.html:207-348](), [inst/csv/OMOP_CDMv5.4_Check_Descriptions.csv:1-28]()

## Check Development Architecture

The custom check system integrates with the core execution engine through a structured configuration and template system:

```mermaid
graph LR
    subgraph "Configuration Layer"
        CHECK_DESC["Check Descriptions CSV<br/>checkName, sqlFile, evaluationFilter"]
        LEVEL_CONFIG["Level Configuration CSV<br/>Table/Field/Concept specific"]
        THRESHOLD_CONFIG["Threshold Configuration<br/>testNameThreshold columns"]
    end
    
    subgraph "SQL Template System"
        SQL_FILE["SQL Template File<br/>inst/sql/sql_server/"]
        PARAMETERS["Template Parameters<br/>@cdmDatabaseSchema, @cdmTableName"]
        SQLRENDER_ENGINE["SqlRender Engine<br/>Parameter substitution"]
    end
    
    subgraph "Execution Engine"
        EXECUTEDQCHECKS_FUNC["executeDqChecks"]
        RUNCHECK_FUNC["runCheck"]
        DATABASE["Target Database"]
    end
    
    CHECK_DESC --> EXECUTEDQCHECKS_FUNC
    LEVEL_CONFIG --> EXECUTEDQCHECKS_FUNC
    THRESHOLD_CONFIG --> EXECUTEDQCHECKS_FUNC
    
    SQL_FILE --> SQLRENDER_ENGINE
    PARAMETERS --> SQLRENDER_ENGINE
    
    EXECUTEDQCHECKS_FUNC --> RUNCHECK_FUNC
    SQLRENDER_ENGINE --> RUNCHECK_FUNC
    RUNCHECK_FUNC --> DATABASE
```

**Sources:** [docs/articles/AddNewCheck.html:280-307](), [inst/csv/OMOP_CDMv5.4_Check_Descriptions.csv:1-28]()

## Step 1: Writing the SQL Query

Custom checks begin with writing SQL queries that identify data quality violations. The query should return a count of rows that fail the quality criterion.

### Query Structure Requirements

All DQD check queries must return three specific columns:
- `num_violated_rows`: Count of records that fail the check
- `pct_violated_rows`: Percentage of violated rows relative to denominator  
- `num_denominator_rows`: Total count of applicable records

### Template Pattern

```sql
SELECT num_violated_rows,
    CASE 
        WHEN denominator.num_rows = 0 THEN 0 
        ELSE 1.0*dqd_check.num_violated_rows/denominator.num_rows 
    END AS pct_violated_rows, 
    denominator.num_rows as num_denominator_rows
FROM (
    -- Your violation detection query here
    SELECT COUNT(*) AS num_violated_rows
    FROM @cdmDatabaseSchema.@cdmTableName
    WHERE [violation_condition]
) dqd_check
CROSS JOIN (
    SELECT COUNT_BIG(*) AS num_rows
    FROM @cdmDatabaseSchema.@cdmTableName cdmTable
) denominator;
```

**Sources:** [docs/articles/AddNewCheck.html:234-263](), [inst/sql/sql_server/field_within_visit_dates.sql:17-22]()

## Step 2: SQL Template Configuration

### Parameter System

DQD uses `SqlRender` for parameter substitution in SQL templates. Standard parameters include:

| Parameter | Description | Example |
|-----------|-------------|---------|
| `@cdmDatabaseSchema` | CDM database schema name | `"my_cdm"` |
| `@cdmTableName` | Target table name | `"visit_occurrence"` |
| `@cdmFieldName` | Target field name | `"visit_start_date"` |
| `@vocabDatabaseSchema` | Vocabulary schema | `"my_vocab"` |

### Cohort Integration

For cohort-based checks, use conditional SQL blocks:

```sql
{@cohort & '@runForCohort' == 'Yes'}?{
    JOIN @cohortDatabaseSchema.@cohortTableName c
        ON cdmTable.person_id = c.subject_id
        AND c.cohort_definition_id = @cohortDefinitionId
}
```

**Sources:** [inst/sql/sql_server/field_within_visit_dates.sql:9-13](), [inst/sql/sql_server/field_within_visit_dates.sql:32-36]()

## Step 3: Check Descriptions Configuration

### Check Descriptions CSV Structure

Add your check to the appropriate CDM version's check descriptions file:

```mermaid
graph TD
    subgraph "Check Description Fields"
        CHECKLEVEL["checkLevel<br/>TABLE, FIELD, or CONCEPT"]
        CHECKNAME["checkName<br/>Unique identifier"]
        CHECKDESC["checkDescription<br/>User-facing description"]
        KAHNCAT["Kahn Framework<br/>kahnContext, kahnCategory, kahnSubcategory"]
        SQLFILE["sqlFile<br/>Template filename"]
        EVALFILTER["evaluationFilter<br/>Execution condition"]
        SEVERITY["severity<br/>fatal, convention, characterization"]
    end
    
    subgraph "Example Configuration"
        EXAMPLE["checkLevel: FIELD<br/>checkName: ERVisitLength<br/>sqlFile: field_ERVisitLength.sql<br/>evaluationFilter: ERVisitLength=='Yes'"]
    end
    
    CHECKLEVEL --> EXAMPLE
    CHECKNAME --> EXAMPLE
    SQLFILE --> EXAMPLE
    EVALFILTER --> EXAMPLE
```

### Configuration Fields

| Field | Purpose | Example Values |
|-------|---------|----------------|
| `checkLevel` | Determines which level CSV file controls execution | `TABLE`, `FIELD`, `CONCEPT` |
| `checkName` | Unique identifier used in code and configuration | `"ERVisitLength"` |
| `evaluationFilter` | Condition determining when check executes | `"ERVisitLength=='Yes'"` |
| `severity` | Impact classification | `"fatal"`, `"convention"`, `"characterization"` |

**Sources:** [docs/articles/AddNewCheck.html:286-306](), [inst/csv/OMOP_CDMv5.4_Check_Descriptions.csv:1-28]()

## Step 4: Level-Specific Configuration

### Field Level Configuration

For field-level checks, add three columns to the Field Level CSV:
- `{checkName}`: Execution flag (`"Yes"` to enable)
- `{checkName}Threshold`: Failure threshold (0-100)
- `{checkName}Notes`: Optional documentation

```mermaid
graph LR
    subgraph "Field Level CSV Structure"
        CDMTABLE["cdmTableName<br/>visit_occurrence"]
        CDMFIELD["cdmFieldName<br/>visit_start_date"] 
        TESTCOL["ERVisitLength<br/>Yes"]
        THRESHCOL["ERVisitLengthThreshold<br/>0"]
        NOTESCOL["ERVisitLengthNotes<br/>(blank)"]
    end
    
    subgraph "Execution Logic"
        EVALFILTER["evaluationFilter<br/>ERVisitLength=='Yes'"]
        RUNCHECK["Check executes for this<br/>table/field combination"]
    end
    
    TESTCOL --> EVALFILTER
    EVALFILTER --> RUNCHECK
    THRESHCOL --> RUNCHECK
```

### Table and Concept Levels

Similar patterns apply for `TABLE` and `CONCEPT` level checks, using their respective configuration CSV files.

**Sources:** [docs/articles/AddNewCheck.html:308-347]()

## SQL File Organization

### File Naming Convention

SQL template files follow the pattern: `{checkLevel}_{checkName}.sql`
- Field level: `field_ERVisitLength.sql`
- Table level: `table_ERVisitLength.sql`  
- Concept level: `concept_ERVisitLength.sql`

### File Location

All SQL templates are stored in: [inst/sql/sql_server/]()

The `SqlRender` package translates SQL Server syntax to other database dialects during execution.

**Sources:** [docs/articles/AddNewCheck.html:277-278](), [inst/sql/sql_server/field_within_visit_dates.sql:1-57]()

## Integration with Execution Engine

### Check Execution Flow

```mermaid
graph TD
    subgraph "executeDqChecks Function"
        LOAD_CONFIG["Load Configuration<br/>Check descriptions & level configs"]
        FILTER_CHECKS["Filter Applicable Checks<br/>Based on evaluationFilter"]
        EXEC_LOOP["Execute Check Loop<br/>For each applicable check"]
    end
    
    subgraph "runCheck Function"
        LOAD_TEMPLATE["Load SQL Template<br/>From inst/sql/sql_server/"]
        RENDER_SQL["Render SQL<br/>Substitute parameters"]  
        EXECUTE_SQL["Execute on Database<br/>Return results"]
        EVAL_THRESHOLD["Evaluate Against Threshold<br/>Determine pass/fail status"]
    end
    
    LOAD_CONFIG --> FILTER_CHECKS
    FILTER_CHECKS --> EXEC_LOOP
    EXEC_LOOP --> LOAD_TEMPLATE
    LOAD_TEMPLATE --> RENDER_SQL
    RENDER_SQL --> EXECUTE_SQL
    EXECUTE_SQL --> EVAL_THRESHOLD
```

### Parameter Resolution

During execution, the framework:
1. Loads the appropriate SQL template file
2. Resolves database schema parameters
3. Substitutes table and field names from level configuration
4. Executes the rendered SQL against the target database
5. Evaluates results against configured thresholds

**Sources:** [docs/articles/AddNewCheck.html:345-347]()

## Testing and Validation

### Using SqlRender Developer Tool

The `SqlRender` package provides `launchSqlRenderDeveloper()` for testing SQL templates:
1. Paste your complete SQL template
2. Define parameter values
3. Review rendered output for target database dialect
4. Test execution against your OMOP CDM instance

### Isolated Check Execution

Test individual checks using the `checkNames` parameter:

```r
DataQualityDashboard::executeDqChecks(
  checkNames = c("ERVisitLength"),
  # ... other parameters
)
```

**Sources:** [docs/articles/AddNewCheck.html:260-277](), [docs/articles/AddNewCheck.html:345-347]()

## Best Practices

### SQL Template Design
- Use parameterized queries for database portability
- Include cohort filtering blocks when applicable
- Follow the standard three-column output format
- Test against multiple database dialects

### Configuration Management
- Use descriptive check names that indicate purpose
- Set appropriate severity levels based on business impact
- Document complex checks in the `Notes` columns
- Consider threshold values carefully based on expected data patterns

### Integration Considerations
- Verify check descriptions are added to all relevant CDM version files
- Ensure level configuration is complete for target tables/fields
- Test execution in both live and SQL-only modes

**Sources:** [docs/articles/AddNewCheck.html:207-348](), [inst/csv/OMOP_CDMv5.4_Check_Descriptions.csv:1-28]()