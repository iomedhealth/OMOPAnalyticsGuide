# Generate a candidate codelist — getCandidateCodes • CodelistGenerator

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

# Generate a candidate codelist

`getCandidateCodes.Rd`

This function generates a set of codes that can be considered for creating a phenotype using the OMOP CDM.

## Usage
    
    
    getCandidateCodes(
      cdm,
      keywords,
      exclude = NULL,
      domains = "Condition",
      standardConcept = "Standard",
      searchInSynonyms = FALSE,
      searchNonStandard = FALSE,
      includeDescendants = TRUE,
      includeAncestor = FALSE
    )

## Arguments

cdm
    

A cdm reference via CDMConnector.

keywords
    

Character vector of words to search for. Where more than one word is given (e.g. "knee osteoarthritis"), all combinations of those words should be identified positions (e.g. "osteoarthritis of knee") should be identified.

exclude
    

Character vector of words to identify concepts to exclude.

domains
    

Character vector with one or more of the OMOP CDM domain. If NULL, all supported domains are included: Condition, Drug, Procedure, Device, Observation, and Measurement.

standardConcept
    

Character vector with one or more of "Standard", "Classification", and "Non-standard". These correspond to the flags used for the standard_concept field in the concept table of the cdm.

searchInSynonyms
    

Either TRUE or FALSE. If TRUE the code will also search using both the primary name in the concept table and synonyms from the concept synonym table.

searchNonStandard
    

Either TRUE or FALSE. If TRUE the code will also search via non-standard concepts.

includeDescendants
    

Either TRUE or FALSE. If TRUE descendant concepts of identified concepts will be included in the candidate codelist. If FALSE only direct mappings from ICD-10 codes to standard codes will be returned.

includeAncestor
    

Either TRUE or FALSE. If TRUE the direct ancestor concepts of identified concepts will be included in the candidate codelist.

## Value

A tibble with the information on the potential codes of interest.

## Examples
    
    
    # \donttest{
    cdm <- CodelistGenerator::[mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    CodelistGenerator::getCandidateCodes(
      cdm = cdm,
      keywords = "osteoarthritis"
     )
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Adding descendants
    #> Search completed. Finishing up.
    #> ✔ 2 candidate concepts identified
    #> Time taken: 0 minutes and 0 seconds
    #> # A tibble: 2 × 6
    #>   concept_id found_from    concept_name domain_id vocabulary_id standard_concept
    #>        <int> <chr>         <chr>        <chr>     <chr>         <chr>           
    #> 1          4 From initial… Osteoarthri… Condition SNOMED        S               
    #> 2          5 From initial… Osteoarthri… Condition SNOMED        S               
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
