# Page: Core Codelist Generation

# Core Codelist Generation

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/drugCodes.R](R/drugCodes.R)
- [R/getCandidateCodes.R](R/getCandidateCodes.R)
- [R/runSearch.R](R/runSearch.R)
- [man/getATCCodes.Rd](man/getATCCodes.Rd)
- [man/getCandidateCodes.Rd](man/getCandidateCodes.Rd)
- [man/getDrugIngredientCodes.Rd](man/getDrugIngredientCodes.Rd)
- [tests/testthat/test-drugCodes.R](tests/testthat/test-drugCodes.R)
- [tests/testthat/test-getCandidateCodes.R](tests/testthat/test-getCandidateCodes.R)

</details>



This document covers the primary functions for generating codelists from OMOP CDM vocabularies. These functions form the foundation of the CodelistGenerator package by providing multiple approaches to identify relevant concept codes based on different search strategies and vocabulary hierarchies.

For information about manipulating existing codelists, see [Codelist Manipulation](#4). For analysis of code usage patterns, see [Codelist Analysis and Usage](#3). For importing codes from external sources, see [Data Import and Export](#5).

## Purpose and Scope

The core codelist generation functions provide systematic approaches to identify OMOP concepts of interest through:

- **Keyword-based searching** across concept names and synonyms
- **Drug-specific generation** using ingredient and ATC classification hierarchies  
- **Vocabulary-specific functions** for standardized classifications like ICD-10
- **Hierarchical expansion** through ancestor and descendant relationships

These functions output standardized codelist objects that can be further manipulated, analyzed, or exported for use in clinical studies.

## Generation Architecture

The codelist generation system operates through a multi-layered architecture that transforms user requirements into OMOP concept sets:

**Generation Flow Architecture**

```mermaid
flowchart TD
    UserInput["User Requirements"] --> Strategy["Generation Strategy"]
    
    Strategy --> Keywords["getCandidateCodes()"]
    Strategy --> Drugs["getDrugIngredientCodes()"]
    Strategy --> ATC["getATCCodes()"]
    Strategy --> Standards["getICD10StandardCodes()"]
    
    Keywords --> SearchEngine["runSearch()"]
    Drugs --> BatchProcessor["fetchBatchedDescendants()"]
    ATC --> BatchProcessor
    Standards --> VocabMapping["Vocabulary Mappings"]
    
    SearchEngine --> ConceptTables["OMOP Concept Tables"]
    BatchProcessor --> ConceptTables
    VocabMapping --> ConceptTables
    
    ConceptTables --> ConceptAncestor["concept_ancestor"]
    ConceptTables --> ConceptSynonym["concept_synonym"] 
    ConceptTables --> ConceptRelationship["concept_relationship"]
    ConceptTables --> Concept["concept"]
    ConceptTables --> DrugStrength["drug_strength"]
    
    ConceptAncestor --> Results["Codelist Objects"]
    ConceptSynonym --> Results
    ConceptRelationship --> Results
    Concept --> Results
    DrugStrength --> Results
```

Sources: [R/getCandidateCodes.R:56-125](), [R/drugCodes.R:39-148](), [R/drugCodes.R:173-299](), [R/runSearch.R:17-381]()

## Primary Generation Functions

The package provides four main generation functions, each optimized for different use cases:

| Function | Primary Use Case | Search Method | Output Format |
|----------|------------------|---------------|---------------|
| `getCandidateCodes` | Keyword-based concept discovery | Text matching with hierarchy expansion | Concept tibble |
| `getDrugIngredientCodes` | Drug ingredient-based codelists | Ingredient hierarchy traversal | Codelist or CodelistWithDetails |
| `getATCCodes` | ATC classification-based drugs | ATC level descendant expansion | Codelist or CodelistWithDetails |
| `getICD10StandardCodes` | ICD-10 standard mappings | Vocabulary-specific mappings | Codelist format |

**Function Parameter Patterns**

```mermaid
flowchart LR
    CommonParams["Common Parameters"]
    CommonParams --> CDM["cdm: CDM reference"]
    CommonParams --> NameStyle["nameStyle: Output naming"]
    CommonParams --> Type["type: Output format"]
    
    SearchParams["Search Parameters"]
    SearchParams --> Keywords["keywords: Search terms"]
    SearchParams --> Domains["domains: OMOP domains"]
    SearchParams --> StandardConcept["standardConcept: Concept flags"]
    
    DrugParams["Drug Parameters"]
    DrugParams --> Name["name: Drug/ATC names"]
    DrugParams --> DoseForm["doseForm: Dose form filter"]
    DrugParams --> DoseUnit["doseUnit: Dose unit filter"]
    DrugParams --> RouteCategory["routeCategory: Route filter"]
    
    HierarchyParams["Hierarchy Parameters"]
    HierarchyParams --> IncludeDescendants["includeDescendants: Child concepts"]
    HierarchyParams --> IncludeAncestor["includeAncestor: Parent concepts"]
    HierarchyParams --> Level["level: ATC hierarchy level"]
```

Sources: [man/getCandidateCodes.Rd:6-17](), [man/getDrugIngredientCodes.Rd:6-16](), [man/getATCCodes.Rd:6-16]()

## Search Strategy Implementation

The core search functionality is implemented through a sophisticated multi-step process that handles various search strategies and filtering requirements:

**Search Process Flow**

```mermaid
flowchart TD
    Start["Search Initiation"] --> Validation["Parameter Validation"]
    Validation --> ConceptFiltering["Filter Concepts by Domain/Standard"]
    
    ConceptFiltering --> ExclusionSearch["Build Exclusion Set"]
    ExclusionSearch --> PrimarySearch["Primary Keyword Matching"]
    
    PrimarySearch --> SynonymSearch{"searchInSynonyms?"}
    SynonymSearch -->|Yes| SynonymMatching["Search Concept Synonyms"]
    SynonymSearch -->|No| DescendantCheck
    SynonymMatching --> DescendantCheck
    
    DescendantCheck{"includeDescendants?"}
    DescendantCheck -->|Yes| AddDescendants["Add Descendant Concepts"]
    DescendantCheck -->|No| AncestorCheck
    AddDescendants --> AncestorCheck
    
    AncestorCheck{"includeAncestor?"}
    AncestorCheck -->|Yes| AddAncestors["Add Ancestor Concepts"]
    AncestorCheck -->|No| NonStandardCheck
    AddAncestors --> NonStandardCheck
    
    NonStandardCheck{"searchNonStandard?"}
    NonStandardCheck -->|Yes| NonStandardSearch["Search Non-Standard Concepts"]
    NonStandardCheck -->|No| FinalFiltering
    NonStandardSearch --> FinalFiltering
    
    FinalFiltering["Apply Exclusions & Deduplication"] --> Results["Return Candidate Codes"]
```

Sources: [R/runSearch.R:100-380](), [R/getCandidateCodes.R:90-124]()

## Database Integration Patterns

All generation functions follow consistent patterns for database interaction and performance optimization:

**Database Access Architecture**

```mermaid
flowchart TD
    CDMReference["cdm: CDM Reference"] --> TableValidation["Required Table Validation"]
    
    TableValidation --> CoreTables["Core Tables"]
    TableValidation --> ConditionalTables["Conditional Tables"]
    
    CoreTables --> ConceptTable["concept"]
    CoreTables --> ConceptAncestorTable["concept_ancestor"] 
    CoreTables --> ConceptRelationshipTable["concept_relationship"]
    CoreTables --> VocabularyTable["vocabulary"]
    
    ConditionalTables --> ConceptSynonymTable["concept_synonym (if searchInSynonyms)"]
    ConditionalTables --> DrugStrengthTable["drug_strength (if Drug domain)"]
    
    ConceptTable --> QueryOptimization["Query Optimization"]
    ConceptAncestorTable --> QueryOptimization
    ConceptRelationshipTable --> QueryOptimization
    
    QueryOptimization --> BatchProcessing["Batch Processing (500 concepts)"]
    QueryOptimization --> LazyEvaluation["Lazy Evaluation with compute()"]
    QueryOptimization --> TemporaryTables["Temporary Table Management"]
    
    BatchProcessing --> ResultCollection["Collect Results"]
    LazyEvaluation --> ResultCollection
    TemporaryTables --> ResultCollection
```

Sources: [R/getCandidateCodes.R:83-88](), [R/drugCodes.R:311-341](), [R/runSearch.R:32-38]()

## Output Format Standardization

The generation functions produce standardized output formats that integrate with the broader omopgenerics ecosystem:

**Output Type Hierarchy**

```mermaid
flowchart TD
    OutputTypes["Output Types"] --> SimpleFormat["Simple Formats"]
    OutputTypes --> DetailedFormat["Detailed Formats"]
    
    SimpleFormat --> ConceptTibble["concept tibble"]
    SimpleFormat --> Codelist["codelist"]
    
    DetailedFormat --> CodelistWithDetails["codelist_with_details"]
    DetailedFormat --> ConceptSetExpression["concept_set_expression (planned)"]
    
    ConceptTibble --> Fields1["concept_id, concept_name, domain_id, vocabulary_id"]
    Codelist --> Fields2["Named list of concept_id vectors"]
    CodelistWithDetails --> Fields3["Named list of concept detail tibbles"]
    
    Codelist --> NewCodelist["omopgenerics::newCodelist()"]
    CodelistWithDetails --> NewCodelistWithDetails["omopgenerics::newCodelistWithDetails()"]
```

Sources: [R/drugCodes.R:116-132](), [R/drugCodes.R:269-284](), [R/getCandidateCodes.R:343-371]()

## Error Handling and Validation

The generation functions implement comprehensive validation and error handling patterns:

**Validation Workflow**

```mermaid
flowchart TD
    FunctionCall["Function Invocation"] --> ParameterValidation["Parameter Validation"]
    
    ParameterValidation --> CDMValidation["CDM Reference Validation"]
    ParameterValidation --> InputValidation["Input Type Validation"]
    ParameterValidation --> ChoiceValidation["Choice Parameter Validation"]
    
    CDMValidation --> TableCheck["Required Table Check"]
    InputValidation --> TypeCheck["Character/Numeric Type Check"]
    ChoiceValidation --> DomainCheck["Domain Existence Check"]
    ChoiceValidation --> StandardConceptCheck["Standard Concept Flag Check"]
    
    TableCheck --> ExecutionProceed["Proceed with Execution"]
    TypeCheck --> ExecutionProceed
    DomainCheck --> ExecutionProceed
    StandardConceptCheck --> ExecutionProceed
    
    ExecutionProceed --> RuntimeValidation["Runtime Validation"]
    RuntimeValidation --> EmptyResultCheck["Empty Result Handling"]
    RuntimeValidation --> ConceptExistenceCheck["Concept Existence Check"]
    
    EmptyResultCheck --> InformativeMessages["Informative CLI Messages"]
    ConceptExistenceCheck --> InformativeMessages
```

Sources: [R/getCandidateCodes.R:69-88](), [R/drugCodes.R:48-59](), [R/drugCodes.R:187-205](), [tests/testthat/test-getCandidateCodes.R:220-257]()

The core generation functions provide a robust foundation for systematic codelist creation, with detailed functionality documented in the following sub-sections: [Candidate Code Search](#2.1), [Drug-Specific Code Generation](#2.2), and [ICD-10 and Other Standards](#2.3).