# create a ggplot from the output of summariseLargeScaleCharacteristics. — plotComparedLargeScaleCharacteristics • CohortCharacteristics

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

# create a ggplot from the output of summariseLargeScaleCharacteristics.

Source: [`R/plotComparedLargeScaleCharacteristics.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/plotComparedLargeScaleCharacteristics.R)

`plotComparedLargeScaleCharacteristics.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    plotComparedLargeScaleCharacteristics(
      result,
      colour,
      reference = NULL,
      facet = NULL,
      missings = 0
    )

## Arguments

result
    

A summarised_result object.

colour
    

Columns to color by. See options with `availablePlotColumns(result)`.

reference
    

A named character to set up the reference. It must be one of the levels of reference.

facet
    

Columns to facet by. See options with `availablePlotColumns(result)`. Formula is also allowed to specify rows and columns.

missings
    

Value to replace the missing value with. If NULL missing values will be eliminated.

## Value

A ggplot.

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([plotly](https://plotly-r.com), warn.conflicts = FALSE)
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchem = "main", writeSchema = "main")
    
    cdm <- [generateIngredientCohortSet](https://darwin-eu.github.io/DrugUtilisation/reference/generateIngredientCohortSet.html)(
      cdm = cdm, name = "my_cohort", ingredient = "acetaminophen"
    )
    
    resultsLsc <- cdm$my_cohort |>
      [summariseLargeScaleCharacteristics](summariseLargeScaleCharacteristics.html)(
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-365, -1), [c](https://rdrr.io/r/base/c.html)(1, 365)),
        eventInWindow = "condition_occurrence"
      )
    
    resultsLsc |>
      plotComparedLargeScaleCharacteristics(
        colour = "variable_level",
        reference = "-365 to -1",
        missings = NULL
      ) |>
      [ggplotly](https://rdrr.io/pkg/plotly/man/ggplotly.html)()
    
    [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    } # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
