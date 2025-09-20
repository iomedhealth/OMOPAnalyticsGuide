# Create a ggplot from the output of summariseCharacteristics. — plotCharacteristics • CohortCharacteristics

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

# Create a ggplot from the output of summariseCharacteristics.

Source: [`R/plotCharacteristics.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/plotCharacteristics.R)

`plotCharacteristics.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    plotCharacteristics(
      result,
      plotType = "barplot",
      facet = NULL,
      colour = NULL,
      plotStyle = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)()
    )

## Arguments

result
    

A summarised_result object.

plotType
    

Either `barplot`, `scatterplot` or `boxplot`. If `barplot` or `scatterplot` subset to just one estimate.

facet
    

Columns to facet by. See options with `availablePlotColumns(result)`. Formula is also allowed to specify rows and columns.

colour
    

Columns to color by. See options with `availablePlotColumns(result)`.

plotStyle
    

deprecated.

## Value

A ggplot.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)()
    
    results <- [summariseCharacteristics](summariseCharacteristics.html)(
      cohort = cdm$cohort1,
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 19), [c](https://rdrr.io/r/base/c.html)(20, 39), [c](https://rdrr.io/r/base/c.html)(40, 59), [c](https://rdrr.io/r/base/c.html)(60, 79), [c](https://rdrr.io/r/base/c.html)(80, 150)),
      tableIntersectCount = [list](https://rdrr.io/r/base/list.html)(
        tableName = "visit_occurrence", window = [c](https://rdrr.io/r/base/c.html)(-365, -1)
      ),
      cohortIntersectFlag = [list](https://rdrr.io/r/base/list.html)(
        targetCohortTable = "cohort2", window = [c](https://rdrr.io/r/base/c.html)(-365, -1)
      )
    )
    #> ℹ adding demographics columns
    #> ℹ adding tableIntersectCount 1/1
    #> window names casted to snake_case:
    #> • `-365 to -1` -> `365_to_1`
    #> ℹ adding cohortIntersectFlag 1/1
    #> window names casted to snake_case:
    #> • `-365 to -1` -> `365_to_1`
    #> ℹ summarising data
    #> ℹ summarising cohort cohort_1
    #> ℹ summarising cohort cohort_2
    #> ℹ summarising cohort cohort_3
    #> ✔ summariseCharacteristics finished!
    
    results |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(
        variable_name == "Cohort2 flag -365 to -1", estimate_name == "percentage"
      ) |>
      plotCharacteristics(
        plotType = "barplot",
        colour = "variable_level",
        facet = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name")
      )
    ![](plotCharacteristics-1.png)
    
    results |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "Age", estimate_name == "mean") |>
      plotCharacteristics(
        plotType = "scatterplot",
        facet = "cdm_name"
      )
    ![](plotCharacteristics-2.png)
    
    results |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "Age", group_level == "cohort_1") |>
      plotCharacteristics(
        plotType = "boxplot",
        facet = "cdm_name",
        colour = "cohort_name"
      )
    ![](plotCharacteristics-3.png)
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
