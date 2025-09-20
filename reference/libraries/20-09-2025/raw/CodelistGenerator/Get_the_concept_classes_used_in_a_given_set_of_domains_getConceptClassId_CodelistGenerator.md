# Get the concept classes used in a given set of domains — getConceptClassId • CodelistGenerator

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

# Get the concept classes used in a given set of domains

`getConceptClassId.Rd`

Get the concept classes used in a given set of domains

## Usage
    
    
    getConceptClassId(cdm, standardConcept = "Standard", domain = NULL)

## Arguments

cdm
    

A cdm reference via CDMConnector.

standardConcept
    

Character vector with one or more of "Standard", "Classification", and "Non-standard". These correspond to the flags used for the standard_concept field in the concept table of the cdm.

domain
    

Character vector with one or more of the OMOP CDM domains. The results will be restricted to the given domains. Check the available ones by running getDomains(). If NULL, all supported domains are included: Condition, Drug, Procedure, Device, Observation, and Measurement.

## Value

The concept classes used for the requested domains.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    getConceptClassId(cdm = cdm, domain = "drug")
    #> [1] "Clinical Drug Form" "Drug"               "Ingredient"        
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
