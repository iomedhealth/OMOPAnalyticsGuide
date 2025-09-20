# Summarise counts for cohorts in a cohort table — summariseCohortCount • CohortCharacteristics

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Summarise counts for cohorts in a cohort table

Source: [`R/summariseCohortCount.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/summariseCohortCount.R)

`summariseCohortCount.Rd`

Summarise counts for cohorts in a cohort table

## Usage
    
    
    summariseCohortCount(cohort, cohortId = NULL, strata = [list](https://rdrr.io/r/base/list.html)())

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

strata
    

A list of variables to stratify results. These variables must have been added as additional columns in the cohort table.

## Value

A summary of counts of the cohorts in the cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)()
    
    summariseCohortCount(cohort = cdm$cohort1) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> ℹ summarising data
    #> ℹ summarising cohort cohort_1
    #> ℹ summarising cohort cohort_2
    #> ℹ summarising cohort cohort_3
    #> ✔ summariseCharacteristics finished!
    #> Rows: 6
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1
    #> $ cdm_name         <chr> "PP_MOCK", "PP_MOCK", "PP_MOCK", "PP_MOCK", "PP_MOCK"…
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "cohort_1", "cohort_1", "cohort_2", "cohort_2", "coho…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Number records", "Number subjects", "Number records"…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA
    #> $ estimate_name    <chr> "count", "count", "count", "count", "count", "count"
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "3", "3", "4", "4", "3", "3"
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
