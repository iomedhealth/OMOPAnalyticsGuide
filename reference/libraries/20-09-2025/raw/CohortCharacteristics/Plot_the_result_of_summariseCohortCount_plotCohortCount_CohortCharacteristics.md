# Plot the result of summariseCohortCount. — plotCohortCount • CohortCharacteristics

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

# Plot the result of summariseCohortCount.

Source: [`R/plotCohortCount.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/plotCohortCount.R)

`plotCohortCount.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    plotCohortCount(result, x = NULL, facet = [c](https://rdrr.io/r/base/c.html)("cdm_name"), colour = NULL)

## Arguments

result
    

A summarised_result object.

x
    

Variables to use in x axis.

facet
    

Columns to facet by. See options with `availablePlotColumns(result)`. Formula is also allowed to specify rows and columns.

colour
    

Columns to color by. See options with `availablePlotColumns(result)`.

## Value

A ggplot.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)(numberIndividuals = 100)
    
    counts <- cdm$cohort2 |>
      [addSex](https://darwin-eu.github.io/PatientProfiles/reference/addSex.html)() |>
      [addAge](https://darwin-eu.github.io/PatientProfiles/reference/addAge.html)(ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 29), [c](https://rdrr.io/r/base/c.html)(30, 59), [c](https://rdrr.io/r/base/c.html)(60, Inf))) |>
      [summariseCohortCount](summariseCohortCount.html)(strata = [list](https://rdrr.io/r/base/list.html)("age_group", "sex", [c](https://rdrr.io/r/base/c.html)("age_group", "sex"))) |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "Number subjects")
    #> ℹ summarising data
    #> ℹ summarising cohort cohort_1
    #> ℹ summarising cohort cohort_2
    #> ℹ summarising cohort cohort_3
    #> ✔ summariseCharacteristics finished!
    
    counts |>
      plotCohortCount(
        x = "sex",
        facet = cohort_name ~ age_group,
        colour = "sex"
      )
    ![](plotCohortCount-1.png)
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
