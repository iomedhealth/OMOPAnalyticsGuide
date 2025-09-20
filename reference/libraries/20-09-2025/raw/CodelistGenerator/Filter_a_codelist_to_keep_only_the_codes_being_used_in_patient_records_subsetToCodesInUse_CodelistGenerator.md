# Filter a codelist to keep only the codes being used in patient records — subsetToCodesInUse • CodelistGenerator

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

# Filter a codelist to keep only the codes being used in patient records

`subsetToCodesInUse.Rd`

Filter a codelist to keep only the codes being used in patient records

## Usage
    
    
    subsetToCodesInUse(
      x,
      cdm,
      minimumCount = 0L,
      table = [c](https://rdrr.io/r/base/c.html)("condition_occurrence", "device_exposure", "drug_exposure", "measurement",
        "observation", "procedure_occurrence", "visit_occurrence")
    )

## Arguments

x
    

A codelist.

cdm
    

A cdm reference via CDMConnector.

minimumCount
    

Any codes with a frequency under this will be removed.

table
    

cdm table of interest.

## Value

The filtered codelist with only the codes used in the database

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)("database")
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    codes <- [getCandidateCodes](getCandidateCodes.html)(cdm = cdm,
                               keywords = "arthritis",
                               domains = "Condition",
                               includeDescendants = FALSE)
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Search completed. Finishing up.
    #> ✔ 3 candidate concepts identified
    #> Time taken: 0 minutes and 0 seconds
    x <- subsetToCodesInUse([list](https://rdrr.io/r/base/list.html)("cs1" = codes$concept_id,
                                   "cs2" = 999),
                                    cdm = cdm)
    #> No codes from codelist cs2 found in the database
    
    x
    #> $cs1
    #> [1] 5 4
    #> 
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
