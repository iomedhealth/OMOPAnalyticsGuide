# Find orphan codes related to a codelist using achilles counts and, if available, PHOEBE concept recommendations — summariseOrphanCodes • CodelistGenerator

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

# Find orphan codes related to a codelist using achilles counts and, if available, PHOEBE concept recommendations

`summariseOrphanCodes.Rd`

Find orphan codes related to a codelist using achilles counts and, if available, PHOEBE concept recommendations

## Usage
    
    
    summariseOrphanCodes(
      x,
      cdm,
      domain = [c](https://rdrr.io/r/base/c.html)("condition", "device", "drug", "measurement", "observation", "procedure",
        "visit")
    )

## Arguments

x
    

A codelist.

cdm
    

A cdm reference via CDMConnector.

domain
    

Character vector with one or more of the OMOP CDM domains. The results will be restricted to the given domains. Check the available ones by running getDomains(). If NULL, all supported domains are included: Condition, Drug, Procedure, Device, Observation, and Measurement.

## Value

A summarised result containg the frequency of codes related to (but not in) the codelist.

## Examples
    
    
    # \donttest{
    cdm <- [mockVocabRef](mockVocabRef.html)("database")
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    #> Warning: There are observation period end dates after the current date: 2025-04-11
    #> ℹ The latest max observation period end date found is 2025-12-31
    codes <- [getCandidateCodes](getCandidateCodes.html)(cdm = cdm,
    keywords = "Musculoskeletal disorder",
    domains = "Condition",
    includeDescendants = FALSE)
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Search completed. Finishing up.
    #> ✔ 1 candidate concept identified
    #> Time taken: 0 minutes and 0 seconds
    
    orphan_codes <- summariseOrphanCodes(x = [list](https://rdrr.io/r/base/list.html)("msk" = codes$concept_id),
    cdm = cdm)
    #> PHOEBE results not available
    #> ℹ The concept_recommended table is not present in the cdm.
    #> Getting orphan codes for msk
    #> 
    
    orphan_codes
    #> # A tibble: 2 × 13
    #>   result_id cdm_name group_name    group_level strata_name strata_level
    #>       <int> <chr>    <chr>         <chr>       <chr>       <chr>       
    #> 1         1 mock     codelist_name msk         domain_id   condition   
    #> 2         1 mock     codelist_name msk         domain_id   condition   
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
