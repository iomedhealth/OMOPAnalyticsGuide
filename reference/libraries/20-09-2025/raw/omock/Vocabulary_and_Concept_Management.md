# Page: Vocabulary and Concept Management

# Vocabulary and Concept Management

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [NAMESPACE](NAMESPACE)
- [R/mockVocabulary.R](R/mockVocabulary.R)
- [R/mockVocabularySet.R](R/mockVocabularySet.R)
- [inst/WORDLIST](inst/WORDLIST)
- [man/figures/coffee.png](man/figures/coffee.png)
- [man/mockVocabularySet.Rd](man/mockVocabularySet.Rd)
- [man/omock-package.Rd](man/omock-package.Rd)
- [tests/testthat/test-mockVocabularySet.R](tests/testthat/test-mockVocabularySet.R)
- [tests/testthat/test-mockVocabularyTables.R](tests/testthat/test-mockVocabularyTables.R)
- [vignettes/a03_Creating_a_synthetic_vocabulary.Rmd](vignettes/a03_Creating_a_synthetic_vocabulary.Rmd)

</details>



This document covers the vocabulary and concept management system in omock, which handles OMOP Common Data Model (CDM) vocabulary tables that define medical concepts, terminologies, and their relationships. The system provides both predefined vocabulary sets and the flexibility to create custom medical terminologies for testing purposes.

For information about clinical event tables that use these vocabularies, see [Clinical Event Tables](#3.2). For CDM construction methods that incorporate vocabularies, see [CDM Construction Methods](#5).

## Purpose and Scope

The vocabulary management system enables creation of mock CDM environments with standardized medical terminologies. It supports multiple vocabulary sources including synthetic test vocabularies, real OMOP vocabularies from ATHENA, and custom user-defined concepts. The system ensures vocabulary tables conform to OMOP CDM specifications while providing flexibility for different testing scenarios.

## Core Vocabulary System Architecture

The vocabulary system consists of two primary functions that handle different vocabulary creation approaches, plus supporting infrastructure for format standardization and validation.

```mermaid
graph TD
    subgraph "Vocabulary Creation Functions"
        A[mockVocabularyTables] --> B["Predefined vocabulary sets"]
        C[mockVocabularySet] --> D["Dataset-specific vocabularies"]
    end
    
    subgraph "Vocabulary Sets"
        B --> E["mock vocabulary set"]
        B --> F["eunomia vocabulary set"]
        D --> G["GiBleed vocabulary"]
        D --> H["Other datasets"]
    end
    
    subgraph "Generated Tables"
        I["cdm_source"]
        J["concept"]
        K["vocabulary"]
        L["concept_relationship"]
        M["concept_synonym"]
        N["concept_ancestor"]
        O["drug_strength"]
    end
    
    subgraph "Processing Pipeline"
        P[addOtherColumns]
        Q[correctCdmFormat]
        R[omopgenerics::insertTable]
    end
    
    E --> I
    E --> J
    E --> K
    F --> I
    F --> J
    F --> K
    G --> I
    G --> J
    G --> K
    
    I --> P
    J --> P
    K --> P
    L --> P
    M --> P
    N --> P
    O --> P
    
    P --> Q
    Q --> R
    R --> S[CDM Reference Object]
```

**Sources:** [R/mockVocabulary.R:1-125](), [R/mockVocabularySet.R:1-95](), [NAMESPACE:31-32]()

## Vocabulary Table Management

The system manages seven core OMOP vocabulary tables, each serving specific roles in the medical terminology framework:

| Table Name | Purpose | Key Columns |
|------------|---------|-------------|
| `cdm_source` | CDM metadata and versioning | `cdm_source_name`, `cdm_version`, `vocabulary_version` |
| `concept` | Individual medical concepts | `concept_id`, `concept_name`, `domain_id`, `vocabulary_id` |
| `vocabulary` | Vocabulary metadata | `vocabulary_id`, `vocabulary_name`, `vocabulary_reference` |
| `concept_relationship` | Relationships between concepts | `concept_id_1`, `concept_id_2`, `relationship_id` |
| `concept_synonym` | Alternative names for concepts | `concept_id`, `concept_synonym_name` |
| `concept_ancestor` | Hierarchical concept relationships | `ancestor_concept_id`, `descendant_concept_id` |
| `drug_strength` | Drug dosage information | `drug_concept_id`, `ingredient_concept_id`, `amount_value` |

**Sources:** [R/mockVocabulary.R:66-74](), [R/mockVocabularySet.R:45-53]()

## Predefined Vocabulary Sets

The `mockVocabularyTables()` function provides two predefined vocabulary sets optimized for different testing scenarios:

### Mock Vocabulary Set
- **Purpose**: Minimal synthetic vocabulary for basic functionality testing
- **Content**: Small subset of medical concepts with simple relationships
- **Use Case**: Unit tests that don't require realistic medical terminology
- **Access**: `vocabularySet = "mock"`

### Eunomia Vocabulary Set  
- **Purpose**: Real OMOP vocabularies for realistic testing environments
- **Content**: Complete vocabulary tables from ATHENA via Eunomia database
- **Use Case**: Integration testing requiring authentic medical terminology
- **Access**: `vocabularySet = "eunomia"`

```mermaid
graph LR
    subgraph "mockVocabularyTables Function"
        A[vocabularySet_parameter] --> B{vocabulary_set_type}
        B -->|"mock"| C[mockCdmSource]
        B -->|"mock"| D[mockConcept]
        B -->|"mock"| E[mockVocabulary]
        B -->|"eunomia"| F[eunomaeCdmSource]
        B -->|"eunomia"| G[eunomaeConcept]
        B -->|"eunomia"| H[eunomaaVocabulary]
    end
    
    subgraph "Table Generation Pipeline"
        I[eval_parse_text] --> J[addOtherColumns]
        J --> K[correctCdmFormat]
        K --> L[snakecase_conversion]
        L --> M[omopgenerics_insertTable]
    end
    
    C --> I
    D --> I
    E --> I
    F --> I
    G --> I
    H --> I
    
    M --> N[CDM_Reference_Object]
```

**Sources:** [R/mockVocabulary.R:76-109](), [vignettes/a03_Creating_a_synthetic_vocabulary.Rmd:34-44]()

## Dataset-Specific Vocabulary Creation

The `mockVocabularySet()` function creates vocabularies from external datasets, particularly useful for domain-specific testing scenarios:

```mermaid
graph TD
    subgraph "Dataset Vocabulary Workflow"
        A[mockVocabularySet] --> B[validateDatasetName]
        B --> C[datasetAvailable]
        C --> D[utils_unzip]
        D --> E[readTables_vocab_true]
        E --> F[vocabulary_table_extraction]
    end
    
    subgraph "Dataset Sources"
        G["GiBleed dataset"]
        H["Other medical datasets"]
        I["Remote ZIP files"]
    end
    
    subgraph "Extracted Tables"
        J["dataset$cdm_source"]
        K["dataset$concept"]
        L["dataset$vocabulary"]
        M["dataset$concept_relationship"]
        N["dataset$concept_synonym"]
        O["dataset$concept_ancestor"]
        P["dataset$drug_strength"]
    end
    
    G --> I
    H --> I
    I --> C
    
    F --> J
    F --> K
    F --> L
    F --> M
    F --> N
    F --> O
    F --> P
    
    J --> Q[CDM_Table_Processing]
    K --> Q
    L --> Q
```

**Sources:** [R/mockVocabularySet.R:21-42](), [tests/testthat/test-mockVocabularySet.R:6-12]()

## Custom Vocabulary Integration

Both vocabulary functions support custom table integration, allowing users to provide their own medical terminologies while leveraging the system's standardization pipeline:

```mermaid
graph LR
    subgraph "Custom Table Integration"
        A["User-provided concept table"] --> B[mockVocabularyTables]
        C["User-provided vocabulary table"] --> B
        D["User-provided relationships"] --> B
        E["Generated tables for NULL inputs"] --> B
    end
    
    subgraph "Validation and Processing"
        B --> F[check_table_function]
        F --> G{all_tables_valid}
        G -->|Yes| H[format_standardization]
        G -->|No| I[cli_abort_error]
    end
    
    subgraph "Table Standardization"
        H --> J[addOtherColumns]
        J --> K[correctCdmFormat]
        K --> L[snakecase_to_snake_case]
        L --> M[omopgenerics_insertTable]
    end
    
    M --> N[Complete_CDM_Object]
```

**Sources:** [R/mockVocabulary.R:80-89](), [tests/testthat/test-mockVocabularyTables.R:23-200](), [vignettes/a03_Creating_a_synthetic_vocabulary.Rmd:47-66]()

## Integration with CDM Construction

The vocabulary system integrates seamlessly with broader CDM construction workflows, supporting both empty CDM references and populated clinical data environments:

```mermaid
graph TD
    subgraph "CDM Construction Integration"
        A[mockCdmReference] --> B[mockVocabularyTables]
        C[emptyCdmReference] --> B
        D[mockCdmFromDataset] --> E[vocabulary_extraction]
        F[mockCdmFromTables] --> G[vocabulary_requirements]
    end
    
    subgraph "Clinical Data Dependencies"
        B --> H[mockPerson]
        B --> I[mockDrugExposure]
        B --> J[mockConditionOccurrence]
        B --> K[mockCohort]
    end
    
    subgraph "Vocabulary Requirements"
        L["concept_id references"]
        M["domain_id validation"]
        N["vocabulary_id consistency"]
    end
    
    H --> L
    I --> L
    J --> L
    K --> L
    
    L --> M
    M --> N
    N --> O[OMOP_Compliant_CDM]
```

**Sources:** [R/mockVocabulary.R:52-53](), [vignettes/a03_Creating_a_synthetic_vocabulary.Rmd:28-32](), [R/mockVocabularySet.R:82-91]()

## Error Handling and Validation

The vocabulary system implements comprehensive validation to ensure data quality and OMOP compliance:

- **Input Validation**: Ensures vocabulary set parameters are valid (`"mock"` or `"eunomia"`)
- **Table Structure Validation**: Verifies all provided tables are data frames or NULL
- **Format Standardization**: Applies OMOP column types and naming conventions
- **Integration Validation**: Confirms vocabulary tables integrate properly with CDM objects

**Sources:** [R/mockVocabulary.R:76-89](), [R/mockVocabularySet.R:55-63]()