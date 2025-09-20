# Page: Orphan Code Detection

# Orphan Code Detection

<details>
<summary>Relevant source files</summary>

The following files were used as context for generating this wiki page:

- [R/summariseOrphanCodes.R](R/summariseOrphanCodes.R)
- [man/summariseOrphanCodes.Rd](man/summariseOrphanCodes.Rd)
- [tests/testthat/test-codesInUse.R](tests/testthat/test-codesInUse.R)
- [tests/testthat/test-summariseOrphanCodes.R](tests/testthat/test-summariseOrphanCodes.R)

</details>



This document covers the orphan code detection functionality in CodelistGenerator, which identifies concept codes that are related to a given codelist but are not explicitly included in it. This helps researchers discover potentially missing codes that may be relevant to their clinical definitions.

For information about general code usage analysis, see [Code Usage Summarization](#3.1). For Achilles-based analysis workflows, see [Achilles Integration](#3.2).

## Purpose and Scope

Orphan code detection addresses the common problem where researchers create codelists but may miss related concepts that are actually used in their database. The `summariseOrphanCodes` function analyzes concept relationships and database usage patterns to suggest codes that might be missing from a codelist but are semantically related to the included concepts.

Sources: [R/summariseOrphanCodes.R:1-25]()

## Core Functionality

The primary function `summariseOrphanCodes` takes a codelist and identifies related codes through multiple relationship pathways:

| Parameter | Type | Description |
|-----------|------|-------------|
| `x` | Codelist | Input codelist to analyze for orphan codes |
| `cdm` | CDM reference | Database connection with required Achilles tables |
| `domain` | Character vector | OMOP domains to restrict results to |

The function returns a `SummarisedResult` object containing frequency information for identified orphan codes.

```mermaid
graph TD
    Input["Input Codelist"] --> Analysis["summariseOrphanCodes"]
    Achilles["Achilles Tables"] --> Analysis
    PHOEBE["PHOEBE Recommendations<br/>(Optional)"] --> Analysis
    Analysis --> Discovery["Relationship Discovery"]
    Discovery --> Descendants["Descendant Codes"]
    Discovery --> Ancestors["Direct Ancestor Codes"]
    Discovery --> Relationships["Concept Relationships"]
    Discovery --> PhoebeRecs["PHOEBE Recommendations"]
    Descendants --> Filter["Filter & Deduplicate"]
    Ancestors --> Filter
    Relationships --> Filter
    PhoebeRecs --> Filter
    Filter --> Output["SummarisedResult<br/>with Orphan Codes"]
```

Sources: [R/summariseOrphanCodes.R:26-41](), [man/summariseOrphanCodes.Rd:8-27]()

## Data Dependencies and Requirements

The orphan code detection requires specific database tables and validates their presence:

```mermaid
graph LR
    CDM["CDM Reference"] --> Validation["omopgenerics::validateCdmArgument"]
    Validation --> AchillesAnalysis["achilles_analysis"]
    Validation --> AchillesResults["achilles_results"] 
    Validation --> AchillesResultsDist["achilles_results_dist"]
    Validation --> ConceptAncestor["concept_ancestor"]
    Validation --> ConceptRelationship["concept_relationship"]
    
    Optional["Optional Tables"] --> ConceptRecommended["concept_recommended<br/>(PHOEBE)"]
    
    AchillesResults --> CodesUsed["fetchAchillesCodesInUse"]
    CodesUsed --> OrphanDetection["Orphan Code Detection"]
```

The function requires Achilles tables to be present and populated, as these provide the usage statistics that determine which codes are actually used in the database.

Sources: [R/summariseOrphanCodes.R:35-46]()

## Relationship Discovery Methods

The orphan code detection employs multiple strategies to find related codes:

### Descendant Code Discovery

```mermaid
graph TD
    InputCodes["Input Codelist Codes"] --> ConceptAncestor["concept_ancestor table"]
    ConceptAncestor --> DescendantFilter["Filter: ancestor_concept_id IN input"]
    CodesInUse["Achilles Codes in Use"] --> DescendantFilter
    DescendantFilter --> DescendantCodes["descendant_concept_id"]
    DescendantCodes --> UsedDescendants["Used Descendant Codes"]
```

This method finds more specific concepts that are children of the input codes in the OMOP vocabulary hierarchy.

### Ancestor Code Discovery

```mermaid
graph TD
    InputCodes["Input Codelist Codes"] --> ConceptAncestor["concept_ancestor table"]
    ConceptAncestor --> AncestorFilter["Filter: descendant_concept_id IN input<br/>AND min_levels_of_separation = 1"]
    CodesInUse["Achilles Codes in Use"] --> AncestorFilter
    AncestorFilter --> AncestorCodes["ancestor_concept_id"]
    AncestorCodes --> DirectParents["Direct Parent Codes"]
```

This method identifies direct parent concepts that are one level above the input codes in the hierarchy.

### Concept Relationship Discovery

The function examines bidirectional concept relationships to find related codes:

```mermaid
graph LR
    InputCodes["Input Codes"] --> Rel1["concept_relationship<br/>concept_id_2 = input"]
    InputCodes --> Rel2["concept_relationship<br/>concept_id_1 = input"]
    Rel1 --> Related1["concept_id_1<br/>as related codes"]
    Rel2 --> Related2["concept_id_2<br/>as related codes"]
    CodesInUse["Codes in Use"] --> Related1
    CodesInUse --> Related2
```

Sources: [R/summariseOrphanCodes.R:47-59](), [R/summariseOrphanCodes.R:84-123]()

## PHOEBE Integration

When available, the function integrates with PHOEBE (Phenotype Operations to Harmonize Evidence-Based Estimates) concept recommendations:

```mermaid
graph TD
    CDMCheck["Check for concept_recommended table"] --> PHOEBEAvailable{"PHOEBE Available?"}
    PHOEBEAvailable -->|Yes| PHOEBEJoin["Join with concept_recommended"]
    PHOEBEAvailable -->|No| InfoMessage["cli::cli_inform<br/>'PHOEBE results not available'"]
    
    PHOEBEJoin --> PHOEBECodes["concept_id_2 from<br/>concept_recommended"]
    PHOEBECodes --> OrphanCollection["Add to Orphan Codes"]
    
    InputCodes["Input Codes"] --> PHOEBEJoin
    CodesInUse["Codes in Use"] --> PHOEBEJoin
```

PHOEBE provides machine learning-based concept recommendations that can identify semantically related concepts not captured through traditional vocabulary relationships.

Sources: [R/summariseOrphanCodes.R:60-69](), [R/summariseOrphanCodes.R:126-137]()

## Processing Pipeline and Output

The complete orphan code detection pipeline processes each codelist and produces standardized output:

```mermaid
graph TD
    StartLoop["For each codelist"] --> CreateTable["omopgenerics::insertTable<br/>temporary codelist table"]
    CreateTable --> GetDescendants["Get Used Descendants"]
    GetDescendants --> GetAncestors["Get Direct Ancestors"]
    GetAncestors --> GetRelationships["Get Relationship Codes"]
    GetRelationships --> CheckPHOEBE{"PHOEBE Available?"}
    CheckPHOEBE -->|Yes| GetPHOEBE["Get PHOEBE Recommendations"]
    CheckPHOEBE -->|No| CombineCodes["Combine All Orphan Codes"]
    GetPHOEBE --> CombineCodes
    CombineCodes --> ExcludeOriginal["setdiff: Remove Original Codes"]
    ExcludeOriginal --> NextCodelist{"More Codelists?"}
    NextCodelist -->|Yes| StartLoop
    NextCodelist -->|No| CheckEmpty{"Any Orphan Codes?"}
    CheckEmpty -->|No| EmptyResult["omopgenerics::emptySummarisedResult"]
    CheckEmpty -->|Yes| FilterDomain["subsetOnDomain"]
    FilterDomain --> GetUsageStats["summariseAchillesCodeUse"]
    GetUsageStats --> SetResultType["Set result_type = 'orphan_code_use'"]
    SetResultType --> FinalOutput["SummarisedResult"]
    EmptyResult --> FinalOutput
```

The output follows the `omopgenerics::SummarisedResult` format with `result_type` set to `"orphan_code_use"` and includes usage frequency statistics from Achilles.

Sources: [R/summariseOrphanCodes.R:75-165](), [tests/testthat/test-summariseOrphanCodes.R:15-22]()

## Usage Patterns and Examples

The function is typically used after initial codelist generation to identify potentially missing concepts:

```mermaid
graph LR
    InitialCodes["getCandidateCodes<br/>or other generation"] --> Codelist["Initial Codelist"]
    Codelist --> OrphanAnalysis["summariseOrphanCodes"]
    OrphanAnalysis --> Review["Manual Review of<br/>Suggested Codes"]
    Review --> Decision{"Include Suggested<br/>Codes?"}
    Decision -->|Yes| UpdatedCodelist["Updated Codelist"]
    Decision -->|No| FinalCodelist["Final Codelist"]
    UpdatedCodelist --> FinalCodelist
```

The function helps in the iterative refinement of codelists by suggesting related concepts that researchers might want to consider including.

Sources: [man/summariseOrphanCodes.Rd:33-46](), [tests/testthat/test-summariseOrphanCodes.R:5-23]()