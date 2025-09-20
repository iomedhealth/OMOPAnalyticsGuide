# Compare overlap between two sets of codes — compareCodelists • CodelistGenerator

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

# Compare overlap between two sets of codes

`compareCodelists.Rd`

Compare overlap between two sets of codes

## Usage
    
    
    compareCodelists(codelist1, codelist2)

## Arguments

codelist1
    

Output of getCandidateCodes or a codelist

codelist2
    

Output of getCandidateCodes.

## Value

Tibble with information on the overlap of codes in both codelists.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    codes1 <- [getCandidateCodes](getCandidateCodes.html)(
     cdm = cdm,
     keywords = "Arthritis",
     domains = "Condition",
     includeDescendants = TRUE
    )
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Adding descendants
    #> Search completed. Finishing up.
    #> ✔ 3 candidate concepts identified
    #> Time taken: 0 minutes and 0 seconds
    codes2 <- [getCandidateCodes](getCandidateCodes.html)(
     cdm = cdm,
     keywords = [c](https://rdrr.io/r/base/c.html)("knee osteoarthritis", "arthrosis"),
     domains = "Condition",
     includeDescendants = TRUE
    )
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Adding descendants
    #> Search completed. Finishing up.
    #> ✔ 2 candidate concepts identified
    #> Time taken: 0 minutes and 0 seconds
    compareCodelists(
     codelist1 = codes1,
     codelist2 = codes2
    )
    #> # A tibble: 4 × 5
    #>   concept_id concept_name           codelist_1 codelist_2 codelist       
    #>        <int> <chr>                       <dbl>      <dbl> <chr>          
    #> 1          3 Arthritis                       1         NA Only codelist 1
    #> 2          4 Osteoarthritis of knee          1          1 Both           
    #> 3          5 Osteoarthritis of hip           1         NA Only codelist 1
    #> 4          2 Osteoarthrosis                 NA          1 Only codelist 2
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
