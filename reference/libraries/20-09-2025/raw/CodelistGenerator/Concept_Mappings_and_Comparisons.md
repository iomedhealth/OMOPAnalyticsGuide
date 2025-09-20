# Page: Concept Mappings and Comparisons

# Concept Mappings and Comparisons

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/compareCodelists.R](R/compareCodelists.R)
- [R/getMappings.R](R/getMappings.R)
- [R/vocabUtilities.R](R/vocabUtilities.R)
- [man/getMappings.Rd](man/getMappings.Rd)
- [tests/testthat/test-compareCodelists.R](tests/testthat/test-compareCodelists.R)
- [tests/testthat/test-getMappings.R](tests/testthat/test-getMappings.R)
- [tests/testthat/test-mockVocabRef.R](tests/testthat/test-mockVocabRef.R)
- [tests/testthat/test-vocabUtilities.R](tests/testthat/test-vocabUtilities.R)

</details>



This document covers functionality for mapping between different OMOP vocabulary standards and comparing codelists. The core capabilities include retrieving mappings from standard to non-standard vocabularies, performing overlap analysis between codelists, and exploring concept relationships and hierarchies within the OMOP CDM vocabulary structure.

For general vocabulary exploration functions like getting available domains and vocabularies, see [Vocabulary Exploration](#6.1). For codelist manipulation and filtering operations, see [Filtering and Subsetting](#4.2).

## Vocabulary Mappings

The `getMappings` function provides the primary interface for discovering mappings between standard OMOP concepts and their corresponding non-standard vocabulary representations. This is essential for understanding how concepts are represented across different coding systems.

### Mapping Architecture

```mermaid
graph TB
    subgraph "Standard Concepts"
        SC["Standard OMOP Concepts<br/>(candidateCodelist)"]
    end
    
    subgraph "OMOP CDM Tables"
        CR["concept_relationship<br/>Table"]
        C["concept<br/>Table"]
    end
    
    subgraph "Non-Standard Vocabularies"
        ATC["ATC Codes"]
        ICD10CM["ICD10CM Codes"]
        READ["READ Codes"]
        SNOMED["SNOMED Codes"]
        RX["RxNorm Codes"]
        OTHER["Other Vocabularies"]
    end
    
    subgraph "getMappings Function"
        GM["getMappings()<br/>R/getMappings.R"]
    end
    
    subgraph "Output"
        MT["Mapping Table<br/>standard_concept_id<br/>standard_concept_name<br/>non_standard_concept_id<br/>non_standard_concept_name<br/>vocabulary mappings"]
    end
    
    SC --> GM
    CR --> GM
    C --> GM
    GM --> MT
    
    GM -.-> ATC
    GM -.-> ICD10CM
    GM -.-> READ
    GM -.-> SNOMED
    GM -.-> RX
    GM -.-> OTHER
```

The `getMappings` function uses the "Mapped from" relationship in the `concept_relationship` table to identify non-standard concepts that map to standard concepts in the input codelist.

**Sources:** [R/getMappings.R:1-135](), [tests/testthat/test-getMappings.R:1-74]()

### Mapping Process Flow

```mermaid
graph LR
    subgraph "Input Processing"
        CL["candidateCodelist<br/>Input DataFrame"]
        NSV["nonStandardVocabularies<br/>Character Vector"]
    end
    
    subgraph "Database Operations"
        VF["Vocabulary Filtering<br/>lines 70-88"]
        MF["Mapped From Relationship<br/>lines 90-100"]
        JO["Table Joins<br/>lines 109-129"]
    end
    
    subgraph "Output Formatting"
        DC["Data Collection<br/>lines 100-101"]
        RN["Column Renaming<br/>lines 117-128"]
        AR["Result Arrangement<br/>lines 130-133"]
    end
    
    CL --> VF
    NSV --> VF
    VF --> MF
    MF --> JO
    JO --> DC
    DC --> RN
    RN --> AR
```

**Sources:** [R/getMappings.R:41-135]()

## Codelist Comparison

The `compareCodelists` function enables systematic comparison of two codelists to identify overlaps, unique concepts, and differences between different approaches to concept selection.

### Comparison Workflow

```mermaid
graph TB
    subgraph "Input Codelists"
        CL1["codelist1<br/>DataFrame or List"]
        CL2["codelist2<br/>DataFrame or List"]
    end
    
    subgraph "compareCodelists Function"
        ICC["Input Checking<br/>lines 49-65"]
        VLD["Validation<br/>lines 68-69"]
        FJ["Full Join<br/>lines 71-79"]
        CM["Category Mapping<br/>lines 81-89"]
    end
    
    subgraph "Output Categories"
        OC1["Only codelist 1"]
        OC2["Only codelist 2"]
        BOTH["Both codelists"]
    end
    
    CL1 --> ICC
    CL2 --> ICC
    ICC --> VLD
    VLD --> FJ
    FJ --> CM
    CM --> OC1
    CM --> OC2
    CM --> BOTH
```

The function accepts both DataFrame inputs (from functions like `getCandidateCodes`) and list inputs (from `omopgenerics::newCodelist`), automatically converting list formats to the required DataFrame structure.

**Sources:** [R/compareCodelists.R:1-91](), [tests/testthat/test-compareCodelists.R:1-151]()

### Comparison Categories

| Category | Description | Logic |
|----------|-------------|-------|
| `Only codelist 1` | Concepts present only in the first codelist | `!is.na(codelist_1) & is.na(codelist_2)` |
| `Only codelist 2` | Concepts present only in the second codelist | `is.na(codelist_1) & !is.na(codelist_2)` |
| `Both` | Concepts present in both codelists | `!is.na(codelist_1) & !is.na(codelist_2)` |

**Sources:** [R/compareCodelists.R:82-88]()

## Concept Hierarchies and Relationships

The vocabulary utilities provide functions for navigating concept hierarchies and exploring relationships between concepts within the OMOP vocabulary structure.

### Descendant Retrieval Architecture

```mermaid
graph TB
    subgraph "getDescendants Function"
        GD["getDescendants()<br/>R/vocabUtilities.R:240-264"]
        GDO["getDescendantsOnly()<br/>lines 266-298"]
        GDAA["getDescendantsAndAncestor()<br/>lines 300-371"]
    end
    
    subgraph "OMOP CDM Tables"
        CA["concept_ancestor<br/>Table"]
        CC["concept<br/>Table"]
        CR2["concept_relationship<br/>Table"]
    end
    
    subgraph "Filtering Options"
        IR["ingredientRange<br/>Parameter"]
        DF["doseForm<br/>Parameter"]
        WA["withAncestor<br/>Boolean"]
    end
    
    subgraph "Supporting Functions"
        AIC["addIngredientCount()<br/>lines 424-450"]
        PDF["getPresentDoseForms()<br/>lines 373-405"]
        FOD["filterOnDoseForm()<br/>lines 407-422"]
    end
    
    GD --> GDO
    GD --> GDAA
    CA --> GDO
    CA --> GDAA
    CC --> GDO
    CC --> GDAA
    CR2 --> PDF
    
    IR --> AIC
    DF --> PDF
    DF --> FOD
    WA --> GDAA
```

**Sources:** [R/vocabUtilities.R:222-450]()

### Relationship Discovery

The `getRelationshipId` function enables exploration of available concept relationships within specific domains and concept types:

```mermaid
graph LR
    subgraph "Input Parameters"
        SC1["standardConcept1"]
        SC2["standardConcept2"] 
        D1["domains1"]
        D2["domains2"]
    end
    
    subgraph "getRelationshipId Function"
        GRI["getRelationshipId()<br/>lines 473-553"]
        JOP["Join Operations<br/>lines 524-541"]
        FLT["Filtering Logic<br/>lines 542-547"]
    end
    
    subgraph "OMOP Tables"
        CR3["concept_relationship"]
        CC2["concept"]
    end
    
    subgraph "Output"
        REL["Relationship IDs<br/>Sorted Vector"]
    end
    
    SC1 --> GRI
    SC2 --> GRI
    D1 --> GRI
    D2 --> GRI
    CR3 --> JOP
    CC2 --> JOP
    JOP --> FLT
    FLT --> REL
```

**Sources:** [R/vocabUtilities.R:453-553]()

## Vocabulary Exploration Utilities

Several utility functions support the mapping and comparison operations by providing access to vocabulary metadata and structure.

### Core Utility Functions

| Function | Purpose | Output |
|----------|---------|--------|
| `getVocabularies` | List available vocabularies in CDM | Character vector of vocabulary IDs |
| `getDomains` | List available domains | Character vector of domain IDs |
| `getConceptClassId` | Get concept classes for domains | Character vector of concept class IDs |
| `getDoseForm` | Get available dose forms for drugs | Character vector of dose form names |
| `getVocabVersion` | Get vocabulary version information | Character string of version |

**Sources:** [R/vocabUtilities.R:17-220]()

### Vocabulary Structure Query Pattern

```mermaid
graph LR
    subgraph "CDM Reference"
        CDM["cdm<br/>CDMConnector Reference"]
    end
    
    subgraph "Vocabulary Tables"
        VOC["vocabulary<br/>Table"]
        CON["concept<br/>Table"]
        CR4["concept_relationship<br/>Table"]
    end
    
    subgraph "Utility Functions"
        GV["getVocabularies()<br/>lines 108-118"]
        GD2["getDomains()<br/>lines 53-93"]
        GCC["getConceptClassId()<br/>lines 134-184"]
        GDF["getDoseForm()<br/>lines 199-220"]
        GVV["getVocabVersion()<br/>lines 29-38"]
    end
    
    CDM --> VOC
    CDM --> CON
    CDM --> CR4
    
    CON --> GV
    CON --> GD2
    CON --> GCC
    CR4 --> GDF
    VOC --> GVV
```

All utility functions follow a consistent pattern of CDM validation, database querying, and result collection, ensuring reliable access to vocabulary metadata across different database backends.

**Sources:** [R/vocabUtilities.R:17-220](), [tests/testthat/test-vocabUtilities.R:1-138]()