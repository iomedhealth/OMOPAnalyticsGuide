# Plot summariseCohortTiming results. — plotCohortTiming • CohortCharacteristics

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

# Plot summariseCohortTiming results.

Source: [`R/plotCohortTiming.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/plotCohortTiming.R)

`plotCohortTiming.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    plotCohortTiming(
      result,
      plotType = "boxplot",
      timeScale = "days",
      uniqueCombinations = TRUE,
      facet = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name_reference"),
      colour = [c](https://rdrr.io/r/base/c.html)("cohort_name_comparator")
    )

## Arguments

result
    

A summarised_result object.

plotType
    

Type of desired formatted table, possibilities are "boxplot" and "densityplot".

timeScale
    

Time scale to show, it can be "days" or "years".

uniqueCombinations
    

Whether to restrict to unique reference and comparator comparisons.

facet
    

Columns to facet by. See options with `availablePlotColumns(result)`. Formula is also allowed to specify rows and columns.

colour
    

Columns to color by. See options with `availablePlotColumns(result)`.

## Value

A ggplot.

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchem = "main", writeSchema = "main")
    
    cdm <- [generateIngredientCohortSet](https://darwin-eu.github.io/DrugUtilisation/reference/generateIngredientCohortSet.html)(
      cdm = cdm,
      name = "my_cohort",
      ingredient = [c](https://rdrr.io/r/base/c.html)("acetaminophen", "morphine", "warfarin")
    )
    
    timings <- [summariseCohortTiming](summariseCohortTiming.html)(cdm$my_cohort)
    
    plotCohortTiming(
      timings,
      timeScale = "years",
      uniqueCombinations = FALSE,
      facet = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name_reference"),
      colour = [c](https://rdrr.io/r/base/c.html)("cohort_name_comparator")
    )
    
    plotCohortTiming(
      timings,
      plotType = "densityplot",
      timeScale = "years",
      uniqueCombinations = FALSE,
      facet = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name_reference"),
      colour = [c](https://rdrr.io/r/base/c.html)("cohort_name_comparator")
    )
    
    [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    } # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
