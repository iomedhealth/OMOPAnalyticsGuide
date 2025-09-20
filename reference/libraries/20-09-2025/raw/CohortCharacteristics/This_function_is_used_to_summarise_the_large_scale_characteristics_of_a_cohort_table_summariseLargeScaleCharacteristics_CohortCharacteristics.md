# This function is used to summarise the large scale characteristics of a cohort table — summariseLargeScaleCharacteristics • CohortCharacteristics

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

# This function is used to summarise the large scale characteristics of a cohort table

Source: [`R/summariseLargeScaleCharacteristics.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/summariseLargeScaleCharacteristics.R)

`summariseLargeScaleCharacteristics.Rd`

This function is used to summarise the large scale characteristics of a cohort table

## Usage
    
    
    summariseLargeScaleCharacteristics(
      cohort,
      cohortId = NULL,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-Inf, -366), [c](https://rdrr.io/r/base/c.html)(-365, -31), [c](https://rdrr.io/r/base/c.html)(-30, -1), [c](https://rdrr.io/r/base/c.html)(0, 0), [c](https://rdrr.io/r/base/c.html)(1, 30), [c](https://rdrr.io/r/base/c.html)(31, 365),
        [c](https://rdrr.io/r/base/c.html)(366, Inf)),
      eventInWindow = NULL,
      episodeInWindow = NULL,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      includeSource = FALSE,
      minimumFrequency = 0.005,
      excludedCodes = [c](https://rdrr.io/r/base/c.html)(0)
    )

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

strata
    

A list of variables to stratify results. These variables must have been added as additional columns in the cohort table.

window
    

Temporal windows that we want to characterize.

eventInWindow
    

Tables to characterise the events in the window. eventInWindow must be provided if episodeInWindow is not specified.

episodeInWindow
    

Tables to characterise the episodes in the window. episodeInWindow must be provided if eventInWindow is not specified.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a specific date or a column date of x

includeSource
    

Whether to include source concepts.

minimumFrequency
    

Minimum frequency of codes to be reported. If a concept_id has a frequency smaller than `minimumFrequency` in a certain window that estimate will be eliminated from the result object.

excludedCodes
    

Codes excluded.

## Value

The output of this function is a `ResultSummary` containing the relevant information.

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchem = "main", writeSchema = "main")
    
    cdm <- [generateIngredientCohortSet](https://darwin-eu.github.io/DrugUtilisation/reference/generateIngredientCohortSet.html)(
      cdm = cdm, name = "my_cohort", ingredient = "acetaminophen"
    )
    
    cdm$my_cohort |>
      summariseLargeScaleCharacteristics(
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-365, -1), [c](https://rdrr.io/r/base/c.html)(1, 365)),
        eventInWindow = "condition_occurrence"
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    } # }
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
