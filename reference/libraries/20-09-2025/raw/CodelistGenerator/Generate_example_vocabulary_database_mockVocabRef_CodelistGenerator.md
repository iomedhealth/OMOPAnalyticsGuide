# Generate example vocabulary database — mockVocabRef • CodelistGenerator

Skip to contents

[CodelistGenerator](../index.html) 3.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Getting the OMOP CDM vocabularies](../articles/a01_GettingOmopCdmVocabularies.html)
    * [Exploring the OMOP CDM vocabulary tables](../articles/a02_ExploreCDMvocabulary.html)
    * [Generate a candidate codelist](../articles/a03_GenerateCandidateCodelist.html)
    * [Generating vocabulary based codelists for medications](../articles/a04_GenerateVocabularyBasedCodelist.html)
    * [Generating vocabulary based codelists for conditions](../articles/a04b_icd_codes.html)
    * [Extract codelists from JSON files](../articles/a05_ExtractCodelistFromJSONfile.html)
    * [Compare, subset or stratify codelists](../articles/a06_CreateSubsetsFromCodelist.html)
    * [Codelist diagnostics](../articles/a07_RunCodelistDiagnostics.html)
  * [Changelog](../news/index.html)




![](../logo.png)

# Generate example vocabulary database

`mockVocabRef.Rd`

Generate example vocabulary database

## Usage
    
    
    mockVocabRef(backend = "data_frame")

## Arguments

backend
    

'database' (duckdb) or 'data_frame'.

## Value

cdm reference with mock vocabulary.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    cdm <- mockVocabRef()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    cdm
    #> 
    #> ── # OMOP CDM reference (local) of mock ────────────────────────────────────────
    #> • omop tables: person, concept, concept_ancestor, concept_synonym,
    #> concept_relationship, vocabulary, drug_strength, observation_period, cdm_source
    #> • cohort tables: -
    #> • achilles tables: achilles_analysis, achilles_results, achilles_results_dist
    #> • other tables: -
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
