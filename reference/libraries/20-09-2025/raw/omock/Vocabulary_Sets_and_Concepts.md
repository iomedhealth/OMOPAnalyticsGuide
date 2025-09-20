# Page: Vocabulary Sets and Concepts

# Vocabulary Sets and Concepts

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [NAMESPACE](NAMESPACE)
- [R/mockConcept.R](R/mockConcept.R)
- [R/mockVocabulary.R](R/mockVocabulary.R)
- [data-raw/default/concept.csv](data-raw/default/concept.csv)
- [data-raw/default/conceptAncestor.csv](data-raw/default/conceptAncestor.csv)
- [data-raw/default/conceptRelationship.csv](data-raw/default/conceptRelationship.csv)
- [data-raw/default/conceptSynonym.csv](data-raw/default/conceptSynonym.csv)
- [data-raw/default/drugStrength.csv](data-raw/default/drugStrength.csv)
- [man/mockConcepts.Rd](man/mockConcepts.Rd)
- [tests/testthat/test-mockConcepts.R](tests/testthat/test-mockConcepts.R)
- [tests/testthat/test-mockVocabularyTables.R](tests/testthat/test-mockVocabularyTables.R)

</details>



This page covers the vocabulary and concept management system within omock, which provides standardized medical terminology and concept definitions for mock OMOP CDM databases. The system supports creating vocabulary tables with predefined concept sets and adding custom medical concepts to existing CDM objects.

For information about generating complete CDM objects, see [CDM Construction Methods](#5).

## Vocabulary Sets Overview

The omock package supports two primary vocabulary sets that determine the medical terminology available in mock CDM databases:

```mermaid
graph TB
    subgraph "Vocabulary System"
        VS["`vocabularySet Parameter`"]
        M["`mock`"]
        E["`eunomia`"]
        
        VS --> M
        VS --> E
        
        M --> MC["`Small synthetic vocabulary`<br/>Suitable for basic tests"]
        E --> EC["`Real ATHENA vocabularies`<br/>From Eunomia database"]
        
        MC --> MVT["`mockVocabularyTables()`"]
        EC --> MVT
        
        MVT --> CDM["`CDM with vocabulary tables`"]
    end
    
    subgraph "Vocabulary Tables"
        CDM --> CS["`cdm_source`"]
        CDM --> C["`concept`"]
        CDM --> V["`vocabulary`"]
        CDM --> CR["`concept_relationship`"]
        CDM --> CSyn["`concept_synonym`"]
        CDM --> CA["`concept_ancestor`"]
        CDM --> DS["`drug_strength`"]
    end
```

**Sources**: [R/mockVocabulary.R:8-18](), [R/mockVocabulary.R:76-78]()

## Core Functions and Components

The vocabulary system centers on two primary functions that handle different aspects of concept management:

| Function | Purpose | Input Requirements |
|----------|---------|-------------------|
| `mockVocabularyTables()` | Creates complete vocabulary table set | CDM reference, vocabulary set choice |
| `mockConcepts()` | Adds custom concepts to existing tables | CDM with concept table, concept IDs, domain |

```mermaid
flowchart TD
    CDM_REF["`mockCdmReference()`"] --> MVT["`mockVocabularyTables()`"]
    MVT --> CDM_VOCAB["`CDM with vocabulary tables`"]
    CDM_VOCAB --> MC["`mockConcepts()`"]
    MC --> CDM_FINAL["`CDM with custom concepts`"]
    
    subgraph "Input Parameters"
        VS["`vocabularySet: 'mock' | 'eunomia'`"]
        CS["`conceptSet: numeric vector`"]
        D["`domain: 'Condition' | 'Drug' | 'Measurement' | 'Observation'`"]
    end
    
    VS --> MVT
    CS --> MC
    D --> MC
    
    subgraph "Generated Tables"
        CDM_FINAL --> CONCEPT["`concept`"]
        CDM_FINAL --> VOCAB["`vocabulary`"] 
        CDM_FINAL --> REL["`concept_relationship`"]
    end
```

**Sources**: [R/mockVocabulary.R:52-125](), [R/mockConcept.R:45-132]()

## Vocabulary Table Generation Process

The `mockVocabularyTables()` function implements a dynamic table generation system that loads predefined data based on the selected vocabulary set:

```mermaid
graph LR
    subgraph "Table Generation Logic"
        INPUT["`User Input Tables`"] --> CHECK{"`Table provided?`"}
        CHECK -->|Yes| USE["`Use provided table`"]
        CHECK -->|No| GEN["`Generate from vocabularySet`"]
        
        GEN --> CONSTRUCT["`Construct table name:`<br/>`vocabularySet + TableName`"]
        CONSTRUCT --> EVAL["`eval(parse(text = tableName))`"]
        EVAL --> FORMAT["`addOtherColumns()`<br/>`correctCdmFormat()`"]
        FORMAT --> INSERT["`insertTable()`"]
        INSERT --> CDM["`Updated CDM`"]
        
        USE --> INSERT
    end
    
    subgraph "Example Table Names"
        MOCK_CONCEPT["`mockConcept`"]
        EUNOMIA_CONCEPT["`eunomiaConcept`"]
        MOCK_VOCAB["`mockVocabulary`"]
        EUNOMIA_VOCAB["`eunomiaVocabulary`"]
    end
    
    CONSTRUCT --> MOCK_CONCEPT
    CONSTRUCT --> EUNOMIA_CONCEPT
    CONSTRUCT --> MOCK_VOCAB
    CONSTRUCT --> EUNOMIA_VOCAB
```

**Sources**: [R/mockVocabulary.R:94-111](), [R/mockVocabulary.R:115-122]()

## Custom Concept Addition

The `mockConcepts()` function provides domain-specific concept generation with automatic vocabulary assignment:

```mermaid
flowchart TB
    subgraph "Domain-Specific Generation"
        DOMAIN["`domain parameter`"]
        DOMAIN --> CONDITION["`'Condition'`"]
        DOMAIN --> DRUG["`'Drug'`"]
        DOMAIN --> MEASUREMENT["`'Measurement'`"]
        DOMAIN --> OBSERVATION["`'Observation'`"]
        
        CONDITION --> CV["`vocabulary_id: 'SNOMED'`<br/>`concept_class_id: 'Clinical Finding'`<br/>`concept_name: 'Condition_' + conceptId`"]
        DRUG --> DV["`vocabulary_id: 'RxNorm'`<br/>`concept_class_id: 'Drug'`<br/>`concept_name: 'Drug_' + conceptId`"]
        MEASUREMENT --> MV["`vocabulary_id: 'RxNorm'`<br/>`concept_class_id: 'Measurement'`<br/>`concept_name: 'Measurement_' + conceptId`"]
        OBSERVATION --> OV["`vocabulary_id: 'LOINC'`<br/>`concept_class_id: 'Observation'`<br/>`concept_name: 'Observation_' + conceptId`"]
    end
    
    subgraph "Concept Generation"
        CV --> TABLE["`Generate concept tibble`"]
        DV --> TABLE
        MV --> TABLE
        OV --> TABLE
        
        TABLE --> APPEND["`dplyr::add_row()`"]
        APPEND --> UPDATED["`Updated concept table`"]
    end
```

**Sources**: [R/mockConcept.R:85-127]()

## Vocabulary Data Structures

The vocabulary system relies on interconnected tables that follow OMOP CDM standards:

### Core Vocabulary Tables

| Table | Key Columns | Purpose |
|-------|-------------|---------|
| `concept` | `concept_id`, `concept_name`, `domain_id`, `vocabulary_id` | Central concept definitions |
| `vocabulary` | `vocabulary_id`, `vocabulary_name` | Vocabulary metadata |
| `concept_relationship` | `concept_id_1`, `concept_id_2`, `relationship_id` | Inter-concept relationships |
| `concept_synonym` | `concept_id`, `concept_synonym_name` | Alternative concept names |
| `concept_ancestor` | `ancestor_concept_id`, `descendant_concept_id` | Hierarchical relationships |
| `drug_strength` | `drug_concept_id`, `ingredient_concept_id` | Drug composition data |

```mermaid
erDiagram
    CONCEPT {
        int concept_id PK
        string concept_name
        string domain_id
        string vocabulary_id FK
        string standard_concept
        string concept_class_id
    }
    
    VOCABULARY {
        string vocabulary_id PK
        string vocabulary_name
        string vocabulary_reference
    }
    
    CONCEPT_RELATIONSHIP {
        int concept_id_1 FK
        int concept_id_2 FK
        string relationship_id
    }
    
    CONCEPT_SYNONYM {
        int concept_id FK
        string concept_synonym_name
    }
    
    CONCEPT ||--o{ CONCEPT_RELATIONSHIP : "participates_in"
    CONCEPT ||--o{ CONCEPT_SYNONYM : "has_synonym"
    VOCABULARY ||--o{ CONCEPT : "categorizes"
```

**Sources**: [data-raw/default/concept.csv:1-2](), [data-raw/default/conceptRelationship.csv:1-2](), [data-raw/default/conceptSynonym.csv:1-2]()

## Integration with CDM Construction

The vocabulary system integrates seamlessly with CDM construction workflows:

```mermaid
sequenceDiagram
    participant User
    participant mockCdmReference
    participant mockVocabularyTables
    participant mockConcepts
    participant CDM
    
    User->>mockCdmReference: Create empty CDM
    mockCdmReference->>CDM: Basic CDM structure
    
    User->>mockVocabularyTables: vocabularySet = "eunomia"
    mockVocabularyTables->>CDM: Insert vocabulary tables
    CDM->>mockVocabularyTables: Updated CDM
    
    User->>mockConcepts: conceptSet = c(100, 200), domain = "Condition"
    mockConcepts->>CDM: Check existing concepts
    CDM->>mockConcepts: Current concept table
    mockConcepts->>CDM: Add new concepts
    
    CDM->>User: Complete CDM with vocabularies
```

**Sources**: [tests/testthat/test-mockVocabularyTables.R:2-3](), [tests/testthat/test-mockConcepts.R:2-3]()

## Validation and Error Handling

The vocabulary system includes comprehensive validation for data integrity:

```mermaid
flowchart TD
    subgraph "mockVocabularyTables Validation"
        VS_CHECK{"`vocabularySet in c('mock', 'eunomia')`"}
        VS_CHECK -->|No| VS_ERROR["`cli_abort: vocabularySet must be mock or eunomia`"]
        VS_CHECK -->|Yes| TABLE_CHECK{"`All tables NULL or data.frame?`"}
        TABLE_CHECK -->|No| TABLE_ERROR["`cli_abort: tables must be NULL or dataframe`"]
        TABLE_CHECK -->|Yes| PROCEED["`Process tables`"]
    end
    
    subgraph "mockConcepts Validation"
        CONCEPT_EXISTS{"`concept table has rows?`"}
        CONCEPT_EXISTS -->|No| CONCEPT_ERROR["`cli_abort: concept table must exist and not be empty`"]
        CONCEPT_EXISTS -->|Yes| DOMAIN_CHECK{"`domain in supported domains?`"}
        DOMAIN_CHECK -->|No| DOMAIN_ERROR["`cli_abort: unsupported domain`"]
        DOMAIN_CHECK -->|Yes| CONFLICT_CHECK{"`conceptSet IDs already exist?`"}
        CONFLICT_CHECK -->|Yes| WARNING["`cli_warn: will overwrite existing concepts`"]
        CONFLICT_CHECK -->|No| ADD_CONCEPTS["`Add new concepts`"]
        WARNING --> ADD_CONCEPTS
    end
```

**Sources**: [R/mockVocabulary.R:76-89](), [R/mockConcept.R:62-80]()