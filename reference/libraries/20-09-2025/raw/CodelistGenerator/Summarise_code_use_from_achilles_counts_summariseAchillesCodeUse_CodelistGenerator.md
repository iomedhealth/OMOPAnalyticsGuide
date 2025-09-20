# Summarise code use from achilles counts. — summariseAchillesCodeUse • CodelistGenerator

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

# Summarise code use from achilles counts.

`summariseAchillesCodeUse.Rd`

Summarise code use from achilles counts.

## Usage
    
    
    summariseAchillesCodeUse(x, cdm, countBy = [c](https://rdrr.io/r/base/c.html)("record", "person"))

## Arguments

x
    

A codelist.

cdm
    

A cdm reference via CDMConnector.

countBy
    

Either "record" for record-level counts or "person" for person-level counts.

## Value

A tibble with summarised counts.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)("database")
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    oa <- [getCandidateCodes](getCandidateCodes.html)(cdm = cdm, keywords = "osteoarthritis")
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Adding descendants
    #> Search completed. Finishing up.
    #> ✔ 2 candidate concepts identified
    #> Time taken: 0 minutes and 0 seconds
    result_achilles <- summariseAchillesCodeUse([list](https://rdrr.io/r/base/list.html)(oa = oa$concept_id), cdm = cdm)
    #> 
    result_achilles
    #> # A tibble: 2 × 13
    #>   result_id cdm_name group_name    group_level strata_name strata_level
    #>       <int> <chr>    <chr>         <chr>       <chr>       <chr>       
    #> 1         1 mock     codelist_name oa          domain_id   condition   
    #> 2         1 mock     codelist_name oa          domain_id   condition   
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
