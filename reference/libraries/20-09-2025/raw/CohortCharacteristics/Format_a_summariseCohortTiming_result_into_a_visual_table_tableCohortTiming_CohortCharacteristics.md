# Format a summariseCohortTiming result into a visual table. — tableCohortTiming • CohortCharacteristics

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

# Format a summariseCohortTiming result into a visual table.

Source: [`R/tableCohortTiming.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/tableCohortTiming.R)

`tableCohortTiming.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    tableCohortTiming(
      result,
      timeScale = "days",
      uniqueCombinations = TRUE,
      type = "gt",
      header = [strataColumns](https://darwin-eu.github.io/omopgenerics/reference/strataColumns.html)(result),
      groupColumn = [c](https://rdrr.io/r/base/c.html)("cdm_name"),
      hide = [c](https://rdrr.io/r/base/c.html)("variable_level", [settingsColumns](https://darwin-eu.github.io/omopgenerics/reference/settingsColumns.html)(result)),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A summarised_result object.

timeScale
    

Time scale to show, it can be "days" or "years".

uniqueCombinations
    

Whether to restrict to unique reference and comparator comparisons.

type
    

Type of table. Check supported types with `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)`.

header
    

Columns to use as header. See options with `availableTableColumns(result)`.

groupColumn
    

Columns to group by. See options with `availableTableColumns(result)`.

hide
    

Columns to hide from the visualisation. See options with `availableTableColumns(result)`.

.options
    

A named list with additional formatting options. `[visOmopResults::tableOptions()](https://darwin-eu.github.io/visOmopResults/reference/tableOptions.html)` shows allowed arguments and their default values.

## Value

A formatted table.

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
    
    tableCohortTiming(timings, timeScale = "years")
    
    [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    } # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
