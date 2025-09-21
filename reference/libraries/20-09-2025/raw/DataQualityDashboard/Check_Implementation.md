# Page: Check Implementation

# Check Implementation

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [inst/sql/sql_server/field_cdm_datatype.sql](inst/sql/sql_server/field_cdm_datatype.sql)
- [inst/sql/sql_server/field_cdm_field.sql](inst/sql/sql_server/field_cdm_field.sql)
- [inst/sql/sql_server/field_concept_record_completeness.sql](inst/sql/sql_server/field_concept_record_completeness.sql)
- [inst/sql/sql_server/field_fk_class.sql](inst/sql/sql_server/field_fk_class.sql)
- [inst/sql/sql_server/field_fk_domain.sql](inst/sql/sql_server/field_fk_domain.sql)
- [inst/sql/sql_server/field_is_not_nullable.sql](inst/sql/sql_server/field_is_not_nullable.sql)
- [inst/sql/sql_server/field_is_primary_key.sql](inst/sql/sql_server/field_is_primary_key.sql)
- [inst/sql/sql_server/field_is_standard_valid_concept.sql](inst/sql/sql_server/field_is_standard_valid_concept.sql)
- [inst/sql/sql_server/field_measure_value_completeness.sql](inst/sql/sql_server/field_measure_value_completeness.sql)
- [inst/sql/sql_server/field_source_value_completeness.sql](inst/sql/sql_server/field_source_value_completeness.sql)
- [inst/sql/sql_server/table_cdm_table.sql](inst/sql/sql_server/table_cdm_table.sql)

</details>



This document covers the technical implementation of data quality checks within the DataQualityDashboard system. It explains how checks are structured at different levels (table, field, concept), the SQL template system, parameter injection mechanisms, and common execution patterns used across all check types.

For information about specific check types and their business logic, see [Check Types and Categories](#4.1). For details about the main execution orchestration, see [Core Execution Engine](#3).

## Check Implementation Architecture

The DataQualityDashboard implements checks through a hierarchical system of parameterized SQL templates. Each check is implemented as a SQL template that follows standardized patterns for counting violations and calculating percentages.

```mermaid
graph TB
    subgraph "Check Level Hierarchy"
        TABLE_LEVEL["table_cdm_table.sql<br/>Table Existence Checks"]
        FIELD_LEVEL["field_*.sql<br/>Field-Level Validations"] 
        CONCEPT_LEVEL["concept_*.sql<br/>Concept-Level Validations"]
    end
    
    subgraph "SQL Template Components"
        PARAM_INJECTION["Parameter Injection<br/>@schema, @cdmTableName, @cdmFieldName"]
        VIOLATION_COUNT["Violation Counting<br/>COUNT_BIG(violated_rows)"]
        PERCENTAGE_CALC["Percentage Calculation<br/>num_violated_rows/num_rows"]
    end
    
    subgraph "Common Check Patterns"
        EXISTENCE_CHECK["Existence Validation<br/>Table/Field Exists"]
        NULLABILITY_CHECK["Nullability Validation<br/>Required Fields Not Null"]
        DATATYPE_CHECK["Data Type Validation<br/>Numeric, Integer Constraints"]
        FK_VALIDATION["Foreign Key Validation<br/>Domain, Class, Standard Concept"]
        COMPLETENESS_CHECK["Completeness Validation<br/>Missing Values, Zero Concepts"]
    end
    
    subgraph "Execution Context"
        COHORT_FILTER["Cohort Filtering<br/>@runForCohort = 'Yes'"]
        VOCAB_SCHEMA["Vocabulary Schema<br/>@vocabDatabaseSchema"]
        CDM_SCHEMA["CDM Schema<br/>@schema/@cdmDatabaseSchema"]
    end
    
    %% Template structure
    TABLE_LEVEL --> PARAM_INJECTION
    FIELD_LEVEL --> PARAM_INJECTION
    CONCEPT_LEVEL --> PARAM_INJECTION
    
    PARAM_INJECTION --> VIOLATION_COUNT
    VIOLATION_COUNT --> PERCENTAGE_CALC
    
    %% Pattern implementation
    FIELD_LEVEL --> EXISTENCE_CHECK
    FIELD_LEVEL --> NULLABILITY_CHECK
    FIELD_LEVEL --> DATATYPE_CHECK
    FIELD_LEVEL --> FK_VALIDATION
    FIELD_LEVEL --> COMPLETENESS_CHECK
    
    %% Context integration
    COHORT_FILTER --> FIELD_LEVEL
    VOCAB_SCHEMA --> FK_VALIDATION
    CDM_SCHEMA --> EXISTENCE_CHECK
```

Sources: [inst/sql/sql_server/table_cdm_table.sql:1-38](), [inst/sql/sql_server/field_cdm_field.sql:1-34](), [inst/sql/sql_server/field_is_not_nullable.sql:1-54]()

## SQL Template Structure

All data quality checks follow a standardized SQL template structure that produces consistent output metrics. The template pattern ensures uniform handling of violation counting, percentage calculations, and denominator management.

### Standard Template Pattern

```mermaid
graph TD
    subgraph "SQL Template Structure"
        SELECT_CLAUSE["SELECT Statement<br/>num_violated_rows, pct_violated_rows, num_denominator_rows"]
        VIOLATION_SUBQUERY["Violation Subquery<br/>/*violatedRowsBegin*/ ... /*violatedRowsEnd*/"]
        DENOMINATOR_SUBQUERY["Denominator Subquery<br/>Total record count with same filters"]
        PERCENTAGE_LOGIC["Percentage Logic<br/>CASE WHEN denominator = 0 THEN 0 ELSE 1.0*violated/total END"]
    end
    
    subgraph "Parameter Substitution"
        SCHEMA_PARAMS["Schema Parameters<br/>@schema, @cdmDatabaseSchema, @vocabDatabaseSchema"]
        TABLE_FIELD_PARAMS["Table/Field Parameters<br/>@cdmTableName, @cdmFieldName"]
        CONDITIONAL_PARAMS["Conditional Parameters<br/>@runForCohort, @cohortDefinitionId"]
        CHECK_SPECIFIC_PARAMS["Check-Specific Parameters<br/>@fkDomain, @fkClass, @standardConceptFieldName"]
    end
    
    subgraph "Cohort Integration"
        COHORT_CONDITION["Cohort Condition<br/>{@cohort & '@runForCohort' == 'Yes'}"]
        COHORT_JOIN["Cohort Join<br/>JOIN @cohortDatabaseSchema.@cohortTableName"]
        PERSON_FILTER["Person Filter<br/>ON cdmTable.person_id = c.subject_id"]
    end
    
    SELECT_CLAUSE --> VIOLATION_SUBQUERY
    SELECT_CLAUSE --> DENOMINATOR_SUBQUERY
    SELECT_CLAUSE --> PERCENTAGE_LOGIC
    
    SCHEMA_PARAMS --> VIOLATION_SUBQUERY
    TABLE_FIELD_PARAMS --> VIOLATION_SUBQUERY
    CONDITIONAL_PARAMS --> COHORT_CONDITION
    CHECK_SPECIFIC_PARAMS --> VIOLATION_SUBQUERY
    
    COHORT_CONDITION --> COHORT_JOIN
    COHORT_JOIN --> PERSON_FILTER
    PERSON_FILTER --> VIOLATION_SUBQUERY
```

Sources: [inst/sql/sql_server/field_cdm_datatype.sql:15-46](), [inst/sql/sql_server/field_fk_domain.sql:20-58](), [inst/sql/sql_server/field_measure_value_completeness.sql:18-55]()

## Parameter Injection System

The SQL templates use a sophisticated parameter injection system that allows the same template to be reused across multiple tables, fields, and contexts. Parameters are injected using the `@parameterName` syntax.

### Core Parameter Types

| Parameter Category | Parameters | Purpose |
|-------------------|------------|---------|
| Schema Parameters | `@schema`, `@cdmDatabaseSchema`, `@vocabDatabaseSchema` | Database schema targeting |
| Entity Parameters | `@cdmTableName`, `@cdmFieldName` | Table and field targeting |
| Cohort Parameters | `@cohortDefinitionId`, `@cohortDatabaseSchema`, `@cohortTableName` | Population filtering |
| Check-Specific | `@fkDomain`, `@fkClass`, `@standardConceptFieldName` | Check logic configuration |

### Conditional Parameter Blocks

The templates use conditional parameter blocks to include or exclude code sections based on execution context:

```sql
{@cohort & '@runForCohort' == 'Yes'}?{
    JOIN @cohortDatabaseSchema.@cohortTableName c 
        ON cdmTable.person_id = c.subject_id
        AND c.cohort_definition_id = @cohortDefinitionId
}
```

Sources: [inst/sql/sql_server/field_fk_domain.sql:13-17](), [inst/sql/sql_server/field_fk_class.sql:14-18](), [inst/sql/sql_server/field_is_standard_valid_concept.sql:12-16]()

## Check Implementation Patterns

Different types of checks follow specific implementation patterns based on their validation logic. These patterns are consistently applied across all check templates.

### Existence Validation Pattern

Used by `table_cdm_table.sql` and `field_cdm_field.sql` to verify that database objects exist:

```mermaid
graph LR
    subgraph "Existence Check Logic"
        COUNT_QUERY["COUNT_BIG(*) or COUNT_BIG(field)"]
        CASE_LOGIC["CASE WHEN COUNT = 0 THEN 0 ELSE 0 END"]
        FIXED_DENOMINATOR["Fixed Denominator = 1"]
    end
    
    COUNT_QUERY --> CASE_LOGIC
    CASE_LOGIC --> FIXED_DENOMINATOR
```

Sources: [inst/sql/sql_server/table_cdm_table.sql:27-33](), [inst/sql/sql_server/field_cdm_field.sql:22-29]()

### Nullability Validation Pattern

Used by `field_is_not_nullable.sql` and `field_measure_value_completeness.sql` to check for missing values:

```mermaid
graph LR
    subgraph "Nullability Check Logic"
        NULL_WHERE["WHERE cdmTable.@cdmFieldName IS NULL"]
        VIOLATION_COUNT["COUNT_BIG(violated_rows)"]
        TOTAL_COUNT["COUNT_BIG(*) FROM table"]
        PERCENTAGE["violated_rows/total_rows"]
    end
    
    NULL_WHERE --> VIOLATION_COUNT
    TOTAL_COUNT --> PERCENTAGE
    VIOLATION_COUNT --> PERCENTAGE
```

Sources: [inst/sql/sql_server/field_is_not_nullable.sql:40-53](), [inst/sql/sql_server/field_measure_value_completeness.sql:41-54]()

### Foreign Key Validation Pattern

Used by `field_fk_domain.sql`, `field_fk_class.sql`, and `field_is_standard_valid_concept.sql` for concept validation:

```mermaid
graph TD
    subgraph "Foreign Key Validation Logic"
        CDM_TABLE["@schema.@cdmTableName cdmTable"]
        VOCAB_JOIN["LEFT JOIN @vocabDatabaseSchema.concept co<br/>ON cdmTable.@cdmFieldName = co.concept_id"]
        VALIDATION_WHERE["WHERE Validation Logic<br/>(domain, class, standard_concept)"]
        COHORT_JOIN["Optional Cohort JOIN"]
    end
    
    CDM_TABLE --> VOCAB_JOIN
    VOCAB_JOIN --> VALIDATION_WHERE
    COHORT_JOIN --> VALIDATION_WHERE
```

Sources: [inst/sql/sql_server/field_fk_domain.sql:35-44](), [inst/sql/sql_server/field_fk_class.sql:37-46](), [inst/sql/sql_server/field_is_standard_valid_concept.sql:42-45]()

### Data Type Validation Pattern

Used by `field_cdm_datatype.sql` to validate numeric data types:

```mermaid
graph LR
    subgraph "Data Type Check Logic"
        ISNUMERIC_CHECK["ISNUMERIC(cdmTable.@cdmFieldName) = 0"]
        DECIMAL_CHECK["CHARINDEX('.', CAST(ABS(field) AS varchar)) != 0"]
        NOT_NULL_FILTER["AND cdmTable.@cdmFieldName IS NOT NULL"]
        COMBINED_WHERE["WHERE (NOT_NUMERIC OR HAS_DECIMAL) AND NOT_NULL"]
    end
    
    ISNUMERIC_CHECK --> COMBINED_WHERE
    DECIMAL_CHECK --> COMBINED_WHERE
    NOT_NULL_FILTER --> COMBINED_WHERE
```

Sources: [inst/sql/sql_server/field_cdm_datatype.sql:34-37]()

## Violation Identification System

Each check template includes a standardized `violatedRowsBegin` and `violatedRowsEnd` block that identifies specific violating records. This allows for detailed debugging and analysis of data quality issues.

```mermaid
graph TB
    subgraph "Violation Row Identification"
        VIOLATED_ROWS_BEGIN["/*violatedRowsBegin*/"]
        VIOLATING_FIELD["'@cdmTableName.@cdmFieldName' AS violating_field"]
        FULL_RECORD["cdmTable.* (Complete record data)"]
        WHERE_CONDITION["WHERE (Specific violation logic)"]
        VIOLATED_ROWS_END["/*violatedRowsEnd*/"]
    end
    
    subgraph "Violation Counting"
        COUNT_VIOLATIONS["COUNT_BIG(violated_rows.violating_field)"]
        DENOMINATOR_COUNT["COUNT_BIG(*) FROM same table with same filters"]
        PERCENTAGE_CALC["1.0*num_violated_rows/denominator.num_rows"]
    end
    
    VIOLATED_ROWS_BEGIN --> VIOLATING_FIELD
    VIOLATING_FIELD --> FULL_RECORD
    FULL_RECORD --> WHERE_CONDITION
    WHERE_CONDITION --> VIOLATED_ROWS_END
    
    VIOLATED_ROWS_END --> COUNT_VIOLATIONS
    COUNT_VIOLATIONS --> PERCENTAGE_CALC
    DENOMINATOR_COUNT --> PERCENTAGE_CALC
```

Sources: [inst/sql/sql_server/field_fk_domain.sql:31-45](), [inst/sql/sql_server/field_is_standard_valid_concept.sql:32-46](), [inst/sql/sql_server/field_concept_record_completeness.sql:27-38]()

## Cohort Integration Pattern

Many checks support optional cohort-based filtering to restrict analysis to specific patient populations. This is implemented through conditional SQL blocks.

| Check Template | Cohort Support | Implementation |
|---------------|----------------|----------------|
| `field_fk_domain.sql` | Yes | Conditional JOIN with cohort table |
| `field_fk_class.sql` | Yes | Conditional JOIN with cohort table |
| `field_is_standard_valid_concept.sql` | Yes | Conditional JOIN with cohort table |
| `field_concept_record_completeness.sql` | Yes | Conditional JOIN with cohort table |
| `field_measure_value_completeness.sql` | Yes | Conditional JOIN with cohort table |
| `field_is_not_nullable.sql` | Yes | Conditional JOIN with cohort table |
| `field_is_primary_key.sql` | Yes | Conditional JOIN with cohort table |
| `table_cdm_table.sql` | No | Table-level check, no person filtering |
| `field_cdm_field.sql` | No | Field existence check, no person filtering |

Sources: [inst/sql/sql_server/field_fk_domain.sql:38-42](), [inst/sql/sql_server/field_concept_record_completeness.sql:32-36](), [inst/sql/sql_server/field_measure_value_completeness.sql:36-40]()