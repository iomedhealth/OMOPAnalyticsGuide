# Show mappings from non-standard vocabularies to standard. — getMappings • CodelistGenerator

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

# Show mappings from non-standard vocabularies to standard.

`getMappings.Rd`

Show mappings from non-standard vocabularies to standard.

## Usage
    
    
    getMappings(
      candidateCodelist,
      cdm = NULL,
      nonStandardVocabularies = [c](https://rdrr.io/r/base/c.html)("ATC", "ICD10CM", "ICD10PCS", "ICD9CM", "ICD9Proc",
        "LOINC", "OPCS4", "Read", "RxNorm", "RxNorm Extension", "SNOMED")
    )

## Arguments

candidateCodelist
    

Dataframe.

cdm
    

A cdm reference via CDMConnector.

nonStandardVocabularies
    

Character vector.

## Value

Tibble with the information of potential standard to non-standard mappings for the codelist of interest.

## Examples
    
    
    # \donttest{
    cdm <- CodelistGenerator::[mockVocabRef](mockVocabRef.html)()
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    codes <- CodelistGenerator::[getCandidateCodes](getCandidateCodes.html)(
      cdm = cdm,
      keywords = "osteoarthritis"
    )
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Adding descendants
    #> Search completed. Finishing up.
    #> ✔ 2 candidate concepts identified
    #> Time taken: 0 minutes and 0 seconds
    CodelistGenerator::getMappings(
      cdm = cdm,
      candidateCodelist = codes,
      nonStandardVocabularies = "READ"
    )
    #> # A tibble: 1 × 7
    #>   standard_concept_id standard_concept_name  standard_vocabulary_id
    #>                 <int> <chr>                  <chr>                 
    #> 1                   4 Osteoarthritis of knee SNOMED                
    #> # ℹ 4 more variables: non_standard_concept_id <int>,
    #> #   non_standard_concept_name <chr>, non_standard_concept_code <chr>,
    #> #   non_standard_vocabulary_id <chr>
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
