# Summarise characteristics of cohorts in a cohort table — summariseCharacteristics • CohortCharacteristics

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

# Summarise characteristics of cohorts in a cohort table

Source: [`R/summariseCharacteristics.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/summariseCharacteristics.R)

`summariseCharacteristics.Rd`

Summarise characteristics of cohorts in a cohort table

## Usage
    
    
    summariseCharacteristics(
      cohort,
      cohortId = NULL,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      counts = TRUE,
      demographics = TRUE,
      ageGroup = NULL,
      tableIntersectFlag = [list](https://rdrr.io/r/base/list.html)(),
      tableIntersectCount = [list](https://rdrr.io/r/base/list.html)(),
      tableIntersectDate = [list](https://rdrr.io/r/base/list.html)(),
      tableIntersectDays = [list](https://rdrr.io/r/base/list.html)(),
      cohortIntersectFlag = [list](https://rdrr.io/r/base/list.html)(),
      cohortIntersectCount = [list](https://rdrr.io/r/base/list.html)(),
      cohortIntersectDate = [list](https://rdrr.io/r/base/list.html)(),
      cohortIntersectDays = [list](https://rdrr.io/r/base/list.html)(),
      conceptIntersectFlag = [list](https://rdrr.io/r/base/list.html)(),
      conceptIntersectCount = [list](https://rdrr.io/r/base/list.html)(),
      conceptIntersectDate = [list](https://rdrr.io/r/base/list.html)(),
      conceptIntersectDays = [list](https://rdrr.io/r/base/list.html)(),
      otherVariables = [character](https://rdrr.io/r/base/character.html)(),
      estimates = [list](https://rdrr.io/r/base/list.html)(),
      weights = NULL,
      otherVariablesEstimates = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)()
    )

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

strata
    

A list of variables to stratify results. These variables must have been added as additional columns in the cohort table.

counts
    

TRUE or FALSE. If TRUE, record and person counts will be produced.

demographics
    

TRUE or FALSE. If TRUE, patient demographics (cohort start date, cohort end date, age, sex, prior observation, and future observation will be summarised).

ageGroup
    

A list of age groups to stratify results by.

tableIntersectFlag
    

A list of arguments that uses PatientProfiles::addTableIntersectFlag() to add variables to summarise.

tableIntersectCount
    

A list of arguments that uses PatientProfiles::addTableIntersectCount() to add variables to summarise.

tableIntersectDate
    

A list of arguments that uses PatientProfiles::addTableIntersectDate() to add variables to summarise.

tableIntersectDays
    

A list of arguments that uses PatientProfiles::addTableIntersectDays() to add variables to summarise.

cohortIntersectFlag
    

A list of arguments that uses PatientProfiles::addCohortIntersectFlag() to add variables to summarise.

cohortIntersectCount
    

A list of arguments that uses PatientProfiles::addCohortIntersectCount() to add variables to summarise.

cohortIntersectDate
    

A list of arguments that uses PatientProfiles::addCohortIntersectDate() to add variables to summarise.

cohortIntersectDays
    

A list of arguments that uses PatientProfiles::addCohortIntersectDays() to add variables to summarise.

conceptIntersectFlag
    

A list of arguments that uses PatientProfiles::addConceptIntersectFlag() to add variables to summarise.

conceptIntersectCount
    

A list of arguments that uses PatientProfiles::addConceptIntersectCount() to add variables to summarise.

conceptIntersectDate
    

A list of arguments that uses PatientProfiles::addConceptIntersectDate() to add variables to summarise.

conceptIntersectDays
    

A list of arguments that uses PatientProfiles::addConceptIntersectDays() to add variables to summarise.

otherVariables
    

Other variables contained in cohort that you want to be summarised.

estimates
    

To modify the default estimates for a variable. By default: 'min', 'q25', 'median', 'q75', 'max' for "date", "numeric" and "integer" variables ("numeric" and "integer" also use 'mean' and 'sd' estimates). 'count' and 'percentage' for "categorical" and "binary". You have to provide them as a list: `list(age = c("median", "density"))`. You can also use 'date', 'numeric', 'integer', 'binary', 'categorical', 'demographics', 'intersect', 'other', 'table_intersect_count', ...

weights
    

Column in cohort that points to weights of each individual.

otherVariablesEstimates
    

deprecated.

## Value

A summary of the characteristics of the cohorts in the cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)()
    
    cdm$cohort1 |>
      [addSex](https://darwin-eu.github.io/PatientProfiles/reference/addSex.html)() |>
      [addAge](https://darwin-eu.github.io/PatientProfiles/reference/addAge.html)(
        ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 40), [c](https://rdrr.io/r/base/c.html)(41, 150))
      ) |>
      summariseCharacteristics(
        strata = [list](https://rdrr.io/r/base/list.html)("sex", "age_group"),
        cohortIntersectFlag = [list](https://rdrr.io/r/base/list.html)(
          "Cohort 2 Flag" = [list](https://rdrr.io/r/base/list.html)(
            targetCohortTable = "cohort2", window = [c](https://rdrr.io/r/base/c.html)(-365, 0)
          )
        ),
        cohortIntersectCount = [list](https://rdrr.io/r/base/list.html)(
          "Cohort 2 Count" = [list](https://rdrr.io/r/base/list.html)(
            targetCohortTable = "cohort2", window = [c](https://rdrr.io/r/base/c.html)(-365, 0)
          )
        )
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> ℹ adding demographics columns
    #> ℹ adding cohortIntersectFlag 1/1
    #> window names casted to snake_case:
    #> • `-365 to 0` -> `365_to_0`
    #> ℹ adding cohortIntersectCount 1/1
    #> window names casted to snake_case:
    #> • `-365 to 0` -> `365_to_0`
    #> ℹ summarising data
    #> ℹ summarising cohort cohort_1
    #> ℹ summarising cohort cohort_2
    #> ℹ summarising cohort cohort_3
    #> ✔ summariseCharacteristics finished!
    #> Rows: 840
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "PP_MOCK", "PP_MOCK", "PP_MOCK", "PP_MOCK", "PP_MOCK"…
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "cohort_1", "cohort_1", "cohort_1", "cohort_1", "coho…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Number records", "Number subjects", "Cohort start da…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "count", "count", "min", "q25", "median", "q75", "max…
    #> $ estimate_type    <chr> "integer", "integer", "date", "date", "date", "date",…
    #> $ estimate_value   <chr> "3", "3", "1941-02-23", "1960-11-23", "1980-08-22", "…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
