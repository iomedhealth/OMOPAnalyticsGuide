# Find unmapped concepts related to codelist — summariseUnmappedCodes • CodelistGenerator

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

# Find unmapped concepts related to codelist

`summariseUnmappedCodes.Rd`

Find unmapped concepts related to codelist

## Usage
    
    
    summariseUnmappedCodes(
      x,
      cdm,
      table = [c](https://rdrr.io/r/base/c.html)("condition_occurrence", "device_exposure", "drug_exposure", "measurement",
        "observation", "procedure_occurrence")
    )

## Arguments

x
    

A codelist.

cdm
    

A cdm reference via CDMConnector.

table
    

Names of clinical tables in which to search for unmapped codes. Can be one or more of "condition_occurrence", "device_exposure", "drug_exposure", "measurement", "observation", and "procedure_occurrence".

## Value

A summarised result of unmapped concepts related to given codelist.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)("database")
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    codes <- [list](https://rdrr.io/r/base/list.html)("Musculoskeletal disorder" = 1)
    cdm <- omopgenerics::[insertTable](https://darwin-eu.github.io/omopgenerics/reference/insertTable.html)(cdm, "condition_occurrence",
    dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(person_id = 1,
                  condition_occurrence_id = 1,
                  condition_concept_id = 0,
                  condition_start_date  = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
                  condition_type_concept_id  = NA,
                  condition_source_concept_id = 7))
    summariseUnmappedCodes(x = [list](https://rdrr.io/r/base/list.html)("osteoarthritis" = 2), cdm = cdm,
    table = "condition_occurrence")
    #> Warning: ! `codelist` casted to integers.
    #> Searching for unmapped codes related to osteoarthritis
    #> # A tibble: 1 × 13
    #>   result_id cdm_name group_name    group_level    strata_name strata_level
    #>       <int> <chr>    <chr>         <chr>          <chr>       <chr>       
    #> 1         1 mock     codelist_name osteoarthritis overall     overall     
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
