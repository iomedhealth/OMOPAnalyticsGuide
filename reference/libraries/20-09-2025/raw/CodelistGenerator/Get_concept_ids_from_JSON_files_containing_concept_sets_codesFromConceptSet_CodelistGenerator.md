# Get concept ids from JSON files containing concept sets — codesFromConceptSet • CodelistGenerator

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

# Get concept ids from JSON files containing concept sets

`codesFromConceptSet.Rd`

Get concept ids from JSON files containing concept sets

## Usage
    
    
    codesFromConceptSet(path, cdm, type = [c](https://rdrr.io/r/base/c.html)("codelist"))

## Arguments

path
    

Path to a file or folder containing JSONs of concept sets.

cdm
    

A cdm reference via CDMConnector.

type
    

Can be "codelist", "codelist_with_details" or "concept_set_expression".

## Value

Named list with concept_ids for each concept set.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)("database")
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    x <- codesFromConceptSet(cdm = cdm,
                             path =  [system.file](https://rdrr.io/r/base/system.file.html)(package = "CodelistGenerator",
                             "concepts_for_mock"))
    x
    #> 
    #> ── 3 codelists ─────────────────────────────────────────────────────────────────
    #> 
    #> - arthritis_desc (3 codes)
    #> - arthritis_no_desc (1 codes)
    #> - arthritis_with_excluded (2 codes)
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
