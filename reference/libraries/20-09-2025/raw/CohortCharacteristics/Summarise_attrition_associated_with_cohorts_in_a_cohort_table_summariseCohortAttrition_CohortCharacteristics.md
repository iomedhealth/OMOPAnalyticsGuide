# Summarise attrition associated with cohorts in a cohort table — summariseCohortAttrition • CohortCharacteristics

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

# Summarise attrition associated with cohorts in a cohort table

Source: [`R/summariseCohortAttrition.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/summariseCohortAttrition.R)

`summariseCohortAttrition.Rd`

Summarise attrition associated with cohorts in a cohort table

## Usage
    
    
    summariseCohortAttrition(cohort, cohortId = NULL)

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

## Value

A summary of the attrition for the cohorts in the cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)()
    
    summariseCohortAttrition(cohort = cdm$cohort1) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 12
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3
    #> $ cdm_name         <chr> "PP_MOCK", "PP_MOCK", "PP_MOCK", "PP_MOCK", "PP_MOCK"…
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "cohort_1", "cohort_1", "cohort_1", "cohort_1", "coho…
    #> $ strata_name      <chr> "reason", "reason", "reason", "reason", "reason", "re…
    #> $ strata_level     <chr> "Initial qualifying events", "Initial qualifying even…
    #> $ variable_name    <chr> "number_records", "number_subjects", "excluded_record…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    #> $ estimate_name    <chr> "count", "count", "count", "count", "count", "count",…
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "2", "2", "0", "0", "3", "3", "0", "0", "5", "5", "0"…
    #> $ additional_name  <chr> "reason_id", "reason_id", "reason_id", "reason_id", "…
    #> $ additional_level <chr> "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"…
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
