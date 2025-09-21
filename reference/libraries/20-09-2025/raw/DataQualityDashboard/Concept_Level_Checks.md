# Page: Concept Level Checks

# Concept Level Checks

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [inst/csv/OMOP_CDMv5.2_Concept_Level.csv](inst/csv/OMOP_CDMv5.2_Concept_Level.csv)
- [inst/csv/OMOP_CDMv5.3_Concept_Level.csv](inst/csv/OMOP_CDMv5.3_Concept_Level.csv)
- [inst/csv/OMOP_CDMv5.4_Concept_Level.csv](inst/csv/OMOP_CDMv5.4_Concept_Level.csv)
- [inst/sql/sql_server/concept_plausible_gender_use_descendants.sql](inst/sql/sql_server/concept_plausible_gender_use_descendants.sql)
- [vignettes/checks/plausibleAfterBirth.Rmd](vignettes/checks/plausibleAfterBirth.Rmd)
- [vignettes/checks/plausibleBeforeDeath.Rmd](vignettes/checks/plausibleBeforeDeath.Rmd)
- [vignettes/checks/plausibleStartBeforeEnd.Rmd](vignettes/checks/plausibleStartBeforeEnd.Rmd)

</details>



Concept Level Checks validate the clinical plausibility and consistency of specific OMOP concepts within the CDM database. These checks operate at the most granular level of the data quality framework, examining individual medical concepts for contextual appropriateness, expected prevalence, plausible value ranges, and temporal consistency.

For information about table-level validation, see [Table Level Checks](#5.1). For field-level validation rules, see [Field Level Checks](#5.2). For overall check framework and categories, see [Check Types and Categories](#4.1).

## Check Architecture

Concept Level Checks are implemented through a configuration-driven system that defines validation rules for specific OMOP concept IDs across different CDM table and field combinations.

```mermaid
graph TD
    subgraph "Configuration System"
        CSV_V54["OMOP_CDMv5.4_Concept_Level.csv"]
        CSV_V53["OMOP_CDMv5.3_Concept_Level.csv"] 
        CSV_V52["OMOP_CDMv5.2_Concept_Level.csv"]
    end
    
    subgraph "Check Types"
        GENDER["plausibleGender"]
        VALUES["plausibleValueLow/High"]
        TEMPORAL["isTemporallyConstant"]
        PREVALENCE["validPrevalenceLow/High"]
        UNITS["plausibleUnitConceptIds"]
    end
    
    subgraph "SQL Implementation"
        GENDER_SQL["concept_plausible_gender_use_descendants.sql"]
        VALUE_SQL["concept_plausible_value_low.sql"]
        TEMPORAL_SQL["concept_is_temporally_constant.sql"]
        PREVALENCE_SQL["concept_valid_prevalence.sql"]
        UNIT_SQL["concept_plausible_unit_concept_ids.sql"]
    end
    
    subgraph "OMOP CDM Context"
        CONCEPT_ID["concept_id"]
        TABLE_FIELD["cdmTableName.cdmFieldName"]
        PERSON["person.gender_concept_id"]
        VOCAB["vocabulary tables"]
    end
    
    CSV_V54 --> GENDER
    CSV_V54 --> VALUES
    CSV_V54 --> TEMPORAL
    CSV_V54 --> PREVALENCE
    CSV_V54 --> UNITS
    
    GENDER --> GENDER_SQL
    VALUES --> VALUE_SQL
    TEMPORAL --> TEMPORAL_SQL
    PREVALENCE --> PREVALENCE_SQL
    UNITS --> UNIT_SQL
    
    GENDER_SQL --> CONCEPT_ID
    GENDER_SQL --> PERSON
    VALUE_SQL --> VOCAB
    TEMPORAL_SQL --> TABLE_FIELD
```

**Sources:** [inst/csv/OMOP_CDMv5.4_Concept_Level.csv:1-1000](), [inst/csv/OMOP_CDMv5.3_Concept_Level.csv:1-1000](), [inst/csv/OMOP_CDMv5.2_Concept_Level.csv:1-1000](), [inst/sql/sql_server/concept_plausible_gender_use_descendants.sql:1-64]()

## Configuration Schema

The concept-level configuration files define validation parameters for specific concept-table-field combinations:

| Column | Purpose | Example |
|--------|---------|---------|
| `cdmTableName` | Target OMOP table | `CONDITION_OCCURRENCE` |
| `cdmFieldName` | Target field within table | `CONDITION_CONCEPT_ID` |
| `conceptId` | Specific OMOP concept ID | `26662` (Testicular hypofunction) |
| `conceptName` | Human-readable concept name | `Testicular hypofunction` |
| `plausibleGender` | Expected gender for concept | `Male` |
| `plausibleGenderThreshold` | Failure threshold percentage | `5` |
| `plausibleValueLow/High` | Expected value ranges | Numeric bounds |
| `isTemporallyConstant` | Should remain constant over time | `Yes` |
| `validPrevalenceLow/High` | Expected population prevalence | `0.0584`, `0.5252` |
| `plausibleUnitConceptIds` | Valid measurement units | Concept ID list |

**Sources:** [inst/csv/OMOP_CDMv5.4_Concept_Level.csv:1-2]()

## Check Types

### Gender Plausibility Checks

Gender plausibility validation ensures that gender-specific medical concepts occur in patients with the appropriate biological sex.

```mermaid
graph LR
    subgraph "Input Data"
        CONDITION["condition_occurrence.condition_concept_id = 26662"]
        PERSON_ID["person_id = 12345"]
    end
    
    subgraph "Validation Logic"
        CONCEPT_DEF["conceptId: 26662<br/>conceptName: Testicular hypofunction<br/>plausibleGender: Male"]
        PERSON_GENDER["person.gender_concept_id = 8532 (Female)"]
    end
    
    subgraph "Check Result"
        VIOLATION["VIOLATION:<br/>Male-specific condition<br/>in Female patient"]
    end
    
    CONDITION --> CONCEPT_DEF
    PERSON_ID --> PERSON_GENDER
    CONCEPT_DEF --> VIOLATION
    PERSON_GENDER --> VIOLATION
```

The implementation uses concept hierarchies to include descendant concepts:

**Sources:** [inst/sql/sql_server/concept_plausible_gender_use_descendants.sql:33-47](), [inst/csv/OMOP_CDMv5.4_Concept_Level.csv:5-6]()

### Value Range Plausibility

Value range checks validate that measurement values fall within clinically reasonable bounds for specific concepts:

| Concept | Unit | Low Threshold | High Threshold | Clinical Context |
|---------|------|---------------|----------------|------------------|
| `concept_id` with `unitConceptId` | Specific unit | `plausibleValueLow` | `plausibleValueHigh` | Expected clinical range |

**Sources:** [inst/csv/OMOP_CDMv5.4_Concept_Level.csv:1-2]()

### Temporal Consistency Checks

Temporal consistency validation identifies concepts that should remain constant across a patient's timeline:

```mermaid
graph TD
    subgraph "Patient Timeline"
        T1["Visit 1: concept_id X"]
        T2["Visit 2: concept_id Y"] 
        T3["Visit 3: concept_id X"]
    end
    
    subgraph "Validation"
        TEMPORAL_CHECK["isTemporallyConstant = Yes<br/>for concept_id X"]
    end
    
    subgraph "Result"
        INCONSISTENCY["VIOLATION:<br/>Concept changed<br/>between visits"]
    end
    
    T1 --> TEMPORAL_CHECK
    T2 --> TEMPORAL_CHECK
    T3 --> TEMPORAL_CHECK
    TEMPORAL_CHECK --> INCONSISTENCY
```

**Sources:** [inst/csv/OMOP_CDMv5.4_Concept_Level.csv:1-2]()

### Prevalence Validation

Prevalence checks ensure that concept occurrence rates fall within expected population-level ranges:

| Check Component | Configuration | Purpose |
|----------------|---------------|---------|
| `validPrevalenceLow` | Lower bound percentage | Minimum expected prevalence |
| `validPrevalenceHigh` | Upper bound percentage | Maximum expected prevalence |
| `validPrevalenceLowThreshold` | Failure threshold | Allowable deviation |

Examples from the configuration:
- Osteoarthritis: 5.84% - 52.52% prevalence range
- Diabetes mellitus: 3.9% - 35.14% prevalence range
- HIV infection: 0.06% - 0.57% prevalence range

**Sources:** [inst/csv/OMOP_CDMv5.4_Concept_Level.csv:12](), [inst/csv/OMOP_CDMv5.4_Concept_Level.csv:132](), [inst/csv/OMOP_CDMv5.4_Concept_Level.csv:165]()

### Unit Concept Validation

Unit concept checks validate that measurement units are appropriate for specific clinical concepts:

```mermaid
graph LR
    subgraph "Measurement Record"
        CONCEPT["measurement.measurement_concept_id"]
        UNIT["measurement.unit_concept_id"]
        VALUE["measurement.value_as_number"]
    end
    
    subgraph "Configuration"
        VALID_UNITS["plausibleUnitConceptIds<br/>for measurement concept"]
        THRESHOLD["plausibleUnitConceptIdsThreshold"]
    end
    
    subgraph "Validation"
        UNIT_CHECK{"unit_concept_id in<br/>plausibleUnitConceptIds?"}
        PASS["PASS"]
        FAIL["VIOLATION"]
    end
    
    CONCEPT --> VALID_UNITS
    UNIT --> UNIT_CHECK
    VALID_UNITS --> UNIT_CHECK
    UNIT_CHECK -->|Yes| PASS
    UNIT_CHECK -->|No| FAIL
```

**Sources:** [inst/csv/OMOP_CDMv5.4_Concept_Level.csv:1-2]()

## CDM Version Support

The system supports multiple OMOP CDM versions through separate configuration files:

```mermaid
graph TB
    subgraph "CDM Version Files"
        V54["OMOP_CDMv5.4_Concept_Level.csv<br/>Latest version"]
        V53["OMOP_CDMv5.3_Concept_Level.csv<br/>Current standard"] 
        V52["OMOP_CDMv5.2_Concept_Level.csv<br/>Legacy support"]
    end
    
    subgraph "Execution Context"
        CDM_SCHEMA["cdmDatabaseSchema parameter"]
        VERSION_DETECT["CDM version detection"]
    end
    
    subgraph "Check Execution"
        CONFIG_LOAD["Load appropriate config"]
        SQL_PARAM["Parameterize SQL templates"]
        EXECUTE["Execute concept checks"]
    end
    
    V54 --> CONFIG_LOAD
    V53 --> CONFIG_LOAD
    V52 --> CONFIG_LOAD
    
    CDM_SCHEMA --> VERSION_DETECT
    VERSION_DETECT --> CONFIG_LOAD
    CONFIG_LOAD --> SQL_PARAM
    SQL_PARAM --> EXECUTE
```

**Sources:** [inst/csv/OMOP_CDMv5.4_Concept_Level.csv:1-1](), [inst/csv/OMOP_CDMv5.3_Concept_Level.csv:1-1](), [inst/csv/OMOP_CDMv5.2_Concept_Level.csv:1-1]()

## SQL Implementation Pattern

Concept-level checks follow a standardized SQL template pattern with parameterization:

```sql
-- Template parameters from concept_plausible_gender_use_descendants.sql
cdmDatabaseSchema = @cdmDatabaseSchema
vocabDatabaseSchema = @vocabDatabaseSchema  
cdmTableName = @cdmTableName
cdmFieldName = @cdmFieldName
conceptId = @conceptId
plausibleGenderUseDescendants = @plausibleGenderUseDescendants
```

The SQL queries join concept hierarchies, person demographics, and clinical data to perform contextual validation:

**Sources:** [inst/sql/sql_server/concept_plausible_gender_use_descendants.sql:1-17](), [inst/sql/sql_server/concept_plausible_gender_use_descendants.sql:34-47]()

## Integration with Check Execution

Concept-level checks integrate with the broader data quality framework through the main execution engine, contributing to the overall assessment of CDM data quality at the most specific clinical concept level.

**Sources:** [inst/csv/OMOP_CDMv5.4_Concept_Level.csv:1-1000](), [inst/sql/sql_server/concept_plausible_gender_use_descendants.sql:1-64]()