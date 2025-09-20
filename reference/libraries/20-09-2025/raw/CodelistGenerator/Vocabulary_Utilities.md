# Page: Vocabulary Utilities

# Vocabulary Utilities

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/compareCodelists.R](R/compareCodelists.R)
- [R/getMappings.R](R/getMappings.R)
- [R/vocabUtilities.R](R/vocabUtilities.R)
- [man/getDescendants.Rd](man/getDescendants.Rd)
- [man/getDomains.Rd](man/getDomains.Rd)
- [man/getMappings.Rd](man/getMappings.Rd)
- [man/getVocabVersion.Rd](man/getVocabVersion.Rd)
- [man/getVocabularies.Rd](man/getVocabularies.Rd)
- [man/mockVocabRef.Rd](man/mockVocabRef.Rd)
- [tests/testthat/test-compareCodelists.R](tests/testthat/test-compareCodelists.R)
- [tests/testthat/test-getMappings.R](tests/testthat/test-getMappings.R)
- [tests/testthat/test-mockVocabRef.R](tests/testthat/test-mockVocabRef.R)
- [tests/testthat/test-vocabUtilities.R](tests/testthat/test-vocabUtilities.R)

</details>



This document covers utility functions for exploring OMOP CDM vocabularies, analyzing concept relationships, and comparing codelists. These functions provide foundational services for understanding vocabulary structure and concept mappings within the OMOP standardized vocabularies.

For codelist generation from vocabularies, see [Core Codelist Generation](#2). For analyzing code usage patterns, see [Codelist Analysis and Usage](#3).

## Vocabulary Exploration Functions

The CodelistGenerator package provides several functions to explore the structure and content of OMOP vocabularies. These functions help users understand what vocabularies, domains, and concept relationships are available in their CDM instance.

### Basic Vocabulary Information

The package offers functions to retrieve fundamental information about the vocabulary structure:

```mermaid
graph TB
    CDM["cdm_reference"]
    
    subgraph "Basic Vocabulary Info"
        GVV["getVocabVersion()"]
        GV["getVocabularies()"]
        GD["getDomains()"]
    end
    
    subgraph "Vocabulary Tables"
        VOCAB["vocabulary"]
        CONCEPT["concept"]
    end
    
    subgraph "Output"
        VERSION["Vocabulary Version"]
        VOCABS["Available Vocabularies"]
        DOMAINS["Available Domains"]
    end
    
    CDM --> GVV
    CDM --> GV
    CDM --> GD
    
    GVV --> VOCAB
    GV --> CONCEPT
    GD --> CONCEPT
    
    GVV --> VERSION
    GV --> VOCABS
    GD --> DOMAINS
```

The `getVocabVersion()` function extracts the vocabulary version from the vocabulary table by filtering for vocabulary_id "None" [R/vocabUtilities.R:29-38](). The `getVocabularies()` function returns all unique vocabulary identifiers from the concept table [R/vocabUtilities.R:108-118](). The `getDomains()` function retrieves all available domains, with optional filtering by standard concept type [R/vocabUtilities.R:53-93]().

**Sources:** [R/vocabUtilities.R:17-93](), [tests/testthat/test-vocabUtilities.R:8-18]()

### Concept Class and Relationship Exploration

The package provides functions to explore concept classes and relationships within domains:

```mermaid
graph TB
    subgraph "Input Parameters"
        CDM["cdm_reference"]
        DOMAIN["domain"]
        STANDARD["standardConcept"]
    end
    
    subgraph "Exploration Functions"
        GCCI["getConceptClassId()"]
        GDF["getDoseForm()"]
        GRI["getRelationshipId()"]
    end
    
    subgraph "Vocabulary Tables"
        CONCEPT["concept"]
        CONCEPT_REL["concept_relationship"]
    end
    
    subgraph "Output"
        CLASSES["Concept Classes"]
        FORMS["Dose Forms"]
        RELATIONSHIPS["Relationship Types"]
    end
    
    CDM --> GCCI
    CDM --> GDF
    CDM --> GRI
    DOMAIN --> GCCI
    STANDARD --> GCCI
    
    GCCI --> CONCEPT
    GDF --> CONCEPT_REL
    GRI --> CONCEPT_REL
    
    GCCI --> CLASSES
    GDF --> FORMS
    GRI --> RELATIONSHIPS
```

The `getConceptClassId()` function returns concept classes for specified domains and standard concept types [R/vocabUtilities.R:134-184](). The `getDoseForm()` function specifically retrieves drug dose forms using the "RxNorm has dose form" relationship [R/vocabUtilities.R:199-220](). The `getRelationshipId()` function explores available relationships between concept domains [R/vocabUtilities.R:473-553]().

**Sources:** [R/vocabUtilities.R:120-220](), [R/vocabUtilities.R:453-553](), [tests/testthat/test-vocabUtilities.R:20-112]()

### Concept Hierarchy Navigation

The `getDescendants()` function provides powerful functionality for navigating concept hierarchies:

```mermaid
graph TB
    subgraph "Input"
        CONCEPT_ID["conceptId"]
        WITH_ANC["withAncestor"]
        ING_RANGE["ingredientRange"]
        DOSE_FORM["doseForm"]
    end
    
    subgraph "Processing Pipeline"
        GET_DESC["getDescendants()"]
        GET_DESC_ONLY["getDescendantsOnly()"]
        GET_DESC_ANC["getDescendantsAndAncestor()"]
        ADD_ING["addIngredientCount()"]
        FILTER_DOSE["filterOnDoseForm()"]
    end
    
    subgraph "Vocabulary Tables"
        CONCEPT_ANC["concept_ancestor"]
        CONCEPT["concept"]
        CONCEPT_REL["concept_relationship"]
    end
    
    subgraph "Output"
        DESCENDANTS["Descendant Concepts"]
        WITH_ANCESTORS["Concepts with Ancestors"]
    end
    
    CONCEPT_ID --> GET_DESC
    WITH_ANC --> GET_DESC
    ING_RANGE --> GET_DESC
    DOSE_FORM --> GET_DESC
    
    GET_DESC --> GET_DESC_ONLY
    GET_DESC --> GET_DESC_ANC
    
    GET_DESC_ONLY --> CONCEPT_ANC
    GET_DESC_ANC --> CONCEPT_ANC
    ADD_ING --> CONCEPT
    FILTER_DOSE --> CONCEPT_REL
    
    GET_DESC_ONLY --> DESCENDANTS
    GET_DESC_ANC --> WITH_ANCESTORS
```

The function supports filtering by ingredient count for drug concepts [R/vocabUtilities.R:424-450]() and dose form filtering [R/vocabUtilities.R:407-422](). When `withAncestor = TRUE`, it returns ancestor information alongside descendants [R/vocabUtilities.R:300-371]().

**Sources:** [R/vocabUtilities.R:222-451](), [tests/testthat/test-vocabUtilities.R:29-71]()

## Concept Mappings and Comparisons

### Vocabulary Mappings

The `getMappings()` function provides mappings between standard and non-standard vocabularies:

```mermaid
graph LR
    subgraph "Input"
        CODELIST["candidateCodelist"]
        NON_STD_VOCAB["nonStandardVocabularies"]
    end
    
    subgraph "Mapping Process"
        GET_MAP["getMappings()"]
        MAPPED_FROM["'Mapped from' relationships"]
        VOCAB_FILTER["Vocabulary filtering"]
    end
    
    subgraph "Database Tables"
        CONCEPT["concept"]
        CONCEPT_REL["concept_relationship"]
    end
    
    subgraph "Output Columns"
        STD_ID["standard_concept_id"]
        STD_NAME["standard_concept_name"]
        NON_STD_ID["non_standard_concept_id"]
        NON_STD_NAME["non_standard_concept_name"]
        NON_STD_CODE["non_standard_concept_code"]
        VOCAB_IDS["vocabulary_ids"]
    end
    
    CODELIST --> GET_MAP
    NON_STD_VOCAB --> GET_MAP
    
    GET_MAP --> MAPPED_FROM
    GET_MAP --> VOCAB_FILTER
    
    MAPPED_FROM --> CONCEPT_REL
    VOCAB_FILTER --> CONCEPT
    
    GET_MAP --> STD_ID
    GET_MAP --> STD_NAME
    GET_MAP --> NON_STD_ID
    GET_MAP --> NON_STD_NAME
    GET_MAP --> NON_STD_CODE
    GET_MAP --> VOCAB_IDS
```

The function uses "Mapped from" relationships to connect standard concepts with their non-standard equivalents [R/getMappings.R:90-100](). It supports multiple non-standard vocabularies including ATC, ICD10CM, Read codes, and others [R/getMappings.R:43-49]().

**Sources:** [R/getMappings.R:18-135](), [tests/testthat/test-getMappings.R:1-74]()

### Codelist Comparison

The `compareCodelists()` function analyzes overlap between two codelists:

| Comparison Result | Description |
|------------------|-------------|
| "Only codelist 1" | Concepts present only in the first codelist |
| "Only codelist 2" | Concepts present only in the second codelist |
| "Both" | Concepts present in both codelists |

```mermaid
graph TB
    subgraph "Input Codelists"
        CL1["codelist1"]
        CL2["codelist2"]
    end
    
    subgraph "Processing"
        COMP["compareCodelists()"]
        FULL_JOIN["Full join on concept_id"]
        CATEGORIZE["Categorize overlap"]
    end
    
    subgraph "Output Categories"
        ONLY1["Only codelist 1"]
        ONLY2["Only codelist 2"]
        BOTH["Both"]
    end
    
    CL1 --> COMP
    CL2 --> COMP
    
    COMP --> FULL_JOIN
    FULL_JOIN --> CATEGORIZE
    
    CATEGORIZE --> ONLY1
    CATEGORIZE --> ONLY2
    CATEGORIZE --> BOTH
```

The function supports both data frame codelists and `omopgenerics::codelist` objects [R/compareCodelists.R:49-65](). It performs a full join on concept_id and concept_name to identify overlapping and unique concepts [R/compareCodelists.R:71-91]().

**Sources:** [R/compareCodelists.R:18-91](), [tests/testthat/test-compareCodelists.R:1-151]()

## Testing and Development Utilities

### Mock Vocabulary Reference

The `mockVocabRef()` function creates a test vocabulary database for development and testing:

```mermaid
graph TB
    subgraph "Mock Database Creation"
        MVR["mockVocabRef()"]
        BACKEND["backend parameter"]
    end
    
    subgraph "Backend Options"
        DB["'database' (DuckDB)"]
        DF["'data_frame'"]
    end
    
    subgraph "Mock Tables"
        CONCEPT["concept"]
        CONCEPT_ANC["concept_ancestor"]
        CONCEPT_REL["concept_relationship"]
        CONCEPT_SYN["concept_synonym"]
        VOCABULARY["vocabulary"]
    end
    
    subgraph "Test Usage"
        UNIT_TESTS["Unit Tests"]
        EXAMPLES["Documentation Examples"]
        DEVELOPMENT["Development Testing"]
    end
    
    BACKEND --> MVR
    MVR --> DB
    MVR --> DF
    
    MVR --> CONCEPT
    MVR --> CONCEPT_ANC
    MVR --> CONCEPT_REL
    MVR --> CONCEPT_SYN
    MVR --> VOCABULARY
    
    MVR --> UNIT_TESTS
    MVR --> EXAMPLES
    MVR --> DEVELOPMENT
```

The mock database provides consistent test data across different backend implementations, supporting both in-memory data frames and database connections [tests/testthat/test-mockVocabRef.R:1-13]().

**Sources:** [tests/testthat/test-mockVocabRef.R:1-13](), [man/mockVocabRef.Rd:1-25]()