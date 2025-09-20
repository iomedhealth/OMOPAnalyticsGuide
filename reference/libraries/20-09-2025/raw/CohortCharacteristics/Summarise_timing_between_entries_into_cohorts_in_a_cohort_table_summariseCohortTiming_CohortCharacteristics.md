# Summarise timing between entries into cohorts in a cohort table — summariseCohortTiming • CohortCharacteristics

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

# Summarise timing between entries into cohorts in a cohort table

Source: [`R/summariseCohortTiming.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/summariseCohortTiming.R)

`summariseCohortTiming.Rd`

Summarise timing between entries into cohorts in a cohort table

## Usage
    
    
    summariseCohortTiming(
      cohort,
      cohortId = NULL,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      restrictToFirstEntry = TRUE,
      estimates = [c](https://rdrr.io/r/base/c.html)("min", "q25", "median", "q75", "max", "density"),
      density = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)()
    )

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

strata
    

A list of variables to stratify results. These variables must have been added as additional columns in the cohort table.

restrictToFirstEntry
    

If TRUE only an individual's first entry per cohort will be considered. If FALSE all entries per individual will be considered.

estimates
    

Summary statistics to use when summarising timing.

density
    

deprecated.

## Value

A summary of timing between entries into cohorts in the cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)(numberIndividuals = 100)
    
    summariseCohortTiming(cdm$cohort2) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 0
    #> Columns: 13
    #> $ result_id        <int> 
    #> $ cdm_name         <chr> 
    #> $ group_name       <chr> 
    #> $ group_level      <chr> 
    #> $ strata_name      <chr> 
    #> $ strata_level     <chr> 
    #> $ variable_name    <chr> 
    #> $ variable_level   <chr> 
    #> $ estimate_name    <chr> 
    #> $ estimate_type    <chr> 
    #> $ estimate_value   <chr> 
    #> $ additional_name  <chr> 
    #> $ additional_level <chr> 
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
