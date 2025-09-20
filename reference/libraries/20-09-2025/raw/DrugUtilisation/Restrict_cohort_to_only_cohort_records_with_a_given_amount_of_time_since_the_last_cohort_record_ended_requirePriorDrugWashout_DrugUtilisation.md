# Restrict cohort to only cohort records with a given amount of time since the last cohort record ended — requirePriorDrugWashout • DrugUtilisation

Skip to contents

[DrugUtilisation](../index.html) 1.0.4

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Create mock data to test DrugUtilisation package](../articles/mock_data.html)
    * [Creating drug cohorts](../articles/create_cohorts.html)
    * [Identify and summarise indications among a drug cohort](../articles/indication.html)
    * [Daily dose calculation](../articles/daily_dose_calculation.html)
    * [Getting drug utilisation related information of subjects in a cohort](../articles/drug_utilisation.html)
    * [Summarise treatments](../articles/summarise_treatments.html)
    * [Summarising treatment adherence](../articles/treatment_discontinuation.html)
    * [Assessing drug restart and switching after treatment](../articles/drug_restart.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/DrugUtilisation/)



![](../logo.png)

# Restrict cohort to only cohort records with a given amount of time since the last cohort record ended

Source: [`R/require.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/require.R)

`requirePriorDrugWashout.Rd`

Filter the cohort table keeping only the cohort records for which the required amount of time has passed since the last cohort entry ended for that individual.

## Usage
    
    
    requirePriorDrugWashout(
      cohort,
      days,
      cohortId = NULL,
      name = omopgenerics::[tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort)
    )

## Arguments

cohort
    

A cohort_table object.

days
    

The number of days required to have passed since the last cohort record finished. Any records with fewer days than this will be dropped. Note that setting days to Inf will lead to the same result as that from using the `requireIsFirstDrugEntry` function (with only an individual´s first cohort record kept).

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

name
    

Name of the new cohort table, it must be a length 1 character vector.

## Value

The cohort table having applied the washout requirement.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    cdm$cohort1 <- cdm$cohort1 |>
      requirePriorDrugWashout(days = 90)
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$cohort1) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 6
    #> Columns: 7
    #> $ cohort_definition_id <int> 1, 1, 2, 2, 3, 3
    #> $ number_records       <int> 4, 4, 4, 4, 2, 2
    #> $ number_subjects      <int> 4, 4, 4, 4, 2, 2
    #> $ reason_id            <int> 1, 2, 1, 2, 1, 2
    #> $ reason               <chr> "Initial qualifying events", "require prior use d…
    #> $ excluded_records     <int> 0, 0, 0, 0, 0, 0
    #> $ excluded_subjects    <int> 0, 0, 0, 0, 0, 0
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
