# Page: Data Import and Export

# Data Import and Export

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [NAMESPACE](NAMESPACE)
- [R/codesFromConceptSet.R](R/codesFromConceptSet.R)
- [R/tableUnmappedCodes.R](R/tableUnmappedCodes.R)
- [_pkgdown.yml](_pkgdown.yml)
- [cran-comments.md](cran-comments.md)
- [man/codesFromConceptSet.Rd](man/codesFromConceptSet.Rd)
- [tests/testthat/test-codesFrom.R](tests/testthat/test-codesFrom.R)
- [tests/testthat/test-findUnmappedCodes.R](tests/testthat/test-findUnmappedCodes.R)

</details>



This document covers the data import and export functionality within CodelistGenerator, specifically focusing on importing concept codes from JSON files and exporting codelists in various formats. This functionality enables seamless integration with OMOP concept set expressions and cohort definitions created in external tools.

For information about codelist manipulation after import, see [Codelist Manipulation](#4). For details about the various output types and formats supported, see [Package Structure and Development](#8).

## JSON Import Architecture

The CodelistGenerator package provides comprehensive support for importing concept codes from JSON files containing either OMOP concept set expressions or cohort definitions. The import system is built around two primary functions that handle different JSON structures while sharing common processing logic.

```mermaid
flowchart TD
    subgraph "Input Sources"
        CS_JSON["JSON Concept Sets<br/>(OMOP Atlas exports)"]
        COH_JSON["JSON Cohort Definitions<br/>(ATLAS cohort exports)"]
        PATH["File/Directory Path"]
    end
    
    subgraph "Import Functions"
        CCS["codesFromConceptSet()"]
        CFC["codesFromCohort()"]
    end
    
    subgraph "JSON Processing"
        RCS["readConceptSet()"]
        EC["extractCodes()"]
        LJ["listJsonFromPath()"]
    end
    
    subgraph "Concept Resolution"
        FC["formatConceptList()"]
        AD["appendDescendants()"]
        EXC["excludeCodes()"]
        TTL["tibbleToList()"]
    end
    
    subgraph "Output Formats"
        CL["codelist"]
        CLD["codelist_with_details"] 
        CSE["concept_set_expression"]
    end
    
    PATH --> CCS
    PATH --> CFC
    CS_JSON --> CCS
    COH_JSON --> CFC
    
    CCS --> RCS
    CFC --> EC
    CFC --> LJ
    
    RCS --> FC
    EC --> AD
    AD --> EXC
    EXC --> TTL
    
    FC --> CL
    TTL --> CL
    FC --> CLD
    TTL --> CLD
    RCS --> CSE
    EC --> CSE
```

**Sources:** [R/codesFromConceptSet.R:1-550](), [NAMESPACE:7-8]()

## Concept Set Import Processing

The `codesFromConceptSet` function handles JSON files containing OMOP concept set expressions, which are typically exported from ATLAS or other OMOP tools. The processing pipeline validates JSON structure, resolves concept hierarchies, and handles inclusion/exclusion logic.

```mermaid
flowchart LR
    subgraph "JSON Structure Validation"
        JSON_INPUT["JSON Concept Set File"]
        VALIDATE["JSON Structure Check"]
        CONCEPTS["Extract Concept Items"]
    end
    
    subgraph "Concept Processing"
        DESCENDANTS["includeDescendants<br/>Resolution"]
        MAPPED["includeMapped<br/>Validation"]
        EXCLUDED["isExcluded<br/>Processing"]
    end
    
    subgraph "Database Operations"
        CDM_INSERT["Insert to CDM"]
        ANCESTOR_JOIN["concept_ancestor Join"]
        CONCEPT_JOIN["concept Table Join"]
    end
    
    subgraph "Output Generation"
        FILTER_EXC["Filter Excluded Concepts"]
        BUILD_LIST["Build Named List"]
        ADD_DETAILS["Add Concept Details"]
    end
    
    JSON_INPUT --> VALIDATE
    VALIDATE --> CONCEPTS
    CONCEPTS --> DESCENDANTS
    CONCEPTS --> MAPPED
    CONCEPTS --> EXCLUDED
    
    DESCENDANTS --> CDM_INSERT
    MAPPED --> CDM_INSERT
    EXCLUDED --> CDM_INSERT
    
    CDM_INSERT --> ANCESTOR_JOIN
    ANCESTOR_JOIN --> CONCEPT_JOIN
    
    CONCEPT_JOIN --> FILTER_EXC
    FILTER_EXC --> BUILD_LIST
    BUILD_LIST --> ADD_DETAILS
```

**Sources:** [R/codesFromConceptSet.R:36-134](), [R/codesFromConceptSet.R:493-549]()

## Cohort Definition Import Processing

The `codesFromCohort` function processes JSON cohort definitions that contain embedded concept sets. This function extracts all concept sets from cohort definitions and processes them through a similar pipeline, with additional logic for handling multiple concept sets per cohort.

```mermaid
flowchart TD
    subgraph "Cohort JSON Processing"
        COH_FILE["Cohort Definition JSON"]
        EXTRACT["extractCodes()"]
        CONCEPT_SETS["Multiple Concept Sets"]
    end
    
    subgraph "Concept Set Extraction" 
        CS_NAME["Concept Set Names"]
        CS_CONCEPTS["Concept IDs"]
        CS_FLAGS["Descendant/Exclude Flags"]
    end
    
    subgraph "Descendant Resolution"
        TEMP_TABLE["Temporary CDM Table"]
        DESC_QUERY["appendDescendants()"]
        ANCESTOR_LOOKUP["concept_ancestor Lookup"]
    end
    
    subgraph "Exclusion Processing"
        EXCL_FILTER["excludeCodes()"]
        ANTI_JOIN["Anti-join Excluded"]
        FINAL_LIST["tibbleToList()"]
    end
    
    COH_FILE --> EXTRACT
    EXTRACT --> CONCEPT_SETS
    CONCEPT_SETS --> CS_NAME
    CONCEPT_SETS --> CS_CONCEPTS  
    CONCEPT_SETS --> CS_FLAGS
    
    CS_CONCEPTS --> TEMP_TABLE
    CS_FLAGS --> DESC_QUERY
    TEMP_TABLE --> DESC_QUERY
    DESC_QUERY --> ANCESTOR_LOOKUP
    
    ANCESTOR_LOOKUP --> EXCL_FILTER
    EXCL_FILTER --> ANTI_JOIN
    ANTI_JOIN --> FINAL_LIST
```

**Sources:** [R/codesFromConceptSet.R:154-236](), [R/codesFromConceptSet.R:251-294](), [R/codesFromConceptSet.R:296-316]()

## Export Functionality

The package provides export capabilities through functions imported from the `omopgenerics` package. These functions enable converting codelists back to standardized formats for sharing and archival purposes.

| Function | Purpose | Output Format |
|----------|---------|---------------|
| `exportCodelist` | Export codelist objects | JSON or CSV format |
| `exportConceptSetExpression` | Export concept set expressions | OMOP-compliant JSON |
| `importCodelist` | Import previously exported codelists | Codelist object |
| `importConceptSetExpression` | Import concept set expressions | ConceptSetExpression object |

**Sources:** [NAMESPACE:12-13](), [NAMESPACE:28-29](), [NAMESPACE:53-56]()

## Output Type Processing

The import functions support three distinct output types, each serving different use cases within the OMOP ecosystem. The `type` parameter controls which format is returned.

```mermaid
flowchart LR
    subgraph "Input Processing"
        JSON_DATA["Parsed JSON Data"]
        CONCEPT_LIST["Concept List Table"]
    end
    
    subgraph "Type Selection"
        TYPE_PARAM["type Parameter"]
        CODELIST_BRANCH["codelist"]
        DETAILS_BRANCH["codelist_with_details"]
        EXPR_BRANCH["concept_set_expression"]
    end
    
    subgraph "Processing Paths"
        SIMPLE["Basic Concept IDs"]
        ENRICH["addDetails()<br/>concept table join"]
        PRESERVE["Preserve JSON Structure"]
    end
    
    subgraph "Output Objects"
        CL_OBJ["newCodelist()"]
        CLD_OBJ["newCodelistWithDetails()"]
        CSE_OBJ["newConceptSetExpression()"]
    end
    
    JSON_DATA --> CONCEPT_LIST
    CONCEPT_LIST --> TYPE_PARAM
    
    TYPE_PARAM --> CODELIST_BRANCH
    TYPE_PARAM --> DETAILS_BRANCH  
    TYPE_PARAM --> EXPR_BRANCH
    
    CODELIST_BRANCH --> SIMPLE
    DETAILS_BRANCH --> ENRICH
    EXPR_BRANCH --> PRESERVE
    
    SIMPLE --> CL_OBJ
    ENRICH --> CLD_OBJ
    PRESERVE --> CSE_OBJ
```

**Sources:** [R/codesFromConceptSet.R:120-128](), [R/codesFromConceptSet.R:366-431](), [R/codesFromConceptSet.R:75-94]()

## Database Integration and Temporary Tables

The import process heavily utilizes the CDM database connection for concept resolution and hierarchy traversal. Temporary tables are created and managed to efficiently process large concept sets and perform complex joins.

```mermaid
flowchart TD
    subgraph "CDM Database"
        CONCEPT["concept"]
        CONCEPT_ANCESTOR["concept_ancestor"]
        TEMP_TABLES["Temporary Tables"]
    end
    
    subgraph "Table Operations"
        INSERT["omopgenerics::insertTable()"]
        UNIQUE_NAME["omopgenerics::uniqueTableName()"]
        DROP["CDMConnector::dropTable()"]
    end
    
    subgraph "Query Operations"
        ANCESTOR_JOIN["Ancestor Hierarchy Joins"]
        CONCEPT_DETAILS["Concept Name/Domain Lookup"]
        COLLECT["dplyr::collect()"]
    end
    
    UNIQUE_NAME --> INSERT
    INSERT --> TEMP_TABLES
    TEMP_TABLES --> ANCESTOR_JOIN
    TEMP_TABLES --> CONCEPT_DETAILS
    
    CONCEPT_ANCESTOR --> ANCESTOR_JOIN
    CONCEPT --> CONCEPT_DETAILS
    
    ANCESTOR_JOIN --> COLLECT
    CONCEPT_DETAILS --> COLLECT
    COLLECT --> DROP
```

**Sources:** [R/codesFromConceptSet.R:110-118](), [R/codesFromConceptSet.R:201-215](), [R/codesFromConceptSet.R:384-415]()

## Error Handling and Validation

The import system includes comprehensive validation to ensure JSON files conform to expected OMOP structures and that unsupported features are properly flagged.

| Validation Check | Function | Error Condition |
|------------------|----------|-----------------|
| Path validation | `checkInputs` | Non-existent paths or invalid file types |
| JSON structure | `readConceptSet` | Malformed OMOP concept set JSON |
| Mapped concepts | Multiple locations | `includeMapped = TRUE` (unsupported) |
| Duplicate names | `tibbleToList` | Same concept set name with different definitions |
| Empty results | Multiple functions | No concepts found in input files |

**Sources:** [R/codesFromConceptSet.R:40-44](), [R/codesFromConceptSet.R:66-73](), [R/codesFromConceptSet.R:97-103](), [R/codesFromConceptSet.R:356-361]()