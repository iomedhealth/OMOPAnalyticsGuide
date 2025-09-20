# Create a visual table from <summarised_result> object from summariseCohortCodelist() — tableCohortCodelist • CohortCharacteristics

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

# Create a visual table from `<summarised_result>` object from `summariseCohortCodelist()`

Source: [`R/summariseCohortCodelist.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/summariseCohortCodelist.R)

`tableCohortCodelist.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    tableCohortCodelist(result, type = "reactable")

## Arguments

result
    

A summarised_result object.

type
    

Type of table. Supported types: "gt", "flextable", "tibble", "datatable", "reactable".

## Value

A visual table with the results.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    dbName <- "GiBleed"
    [requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)(datasetName = dbName)
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(drv = [duckdb](https://r.duckdb.org/reference/duckdb.html)(dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)(datasetName = dbName)))
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, cdmSchema = "main", writeSchema = "main")
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(cdm = cdm,
                                    conceptSet = [list](https://rdrr.io/r/base/list.html)(pharyngitis = 4112343L),
                                    name = "my_cohort")
    
    result <- [summariseCohortCodelist](summariseCohortCodelist.html)(cdm$my_cohort)
    
    tableCohortCodelist(result)
    
    
    
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
