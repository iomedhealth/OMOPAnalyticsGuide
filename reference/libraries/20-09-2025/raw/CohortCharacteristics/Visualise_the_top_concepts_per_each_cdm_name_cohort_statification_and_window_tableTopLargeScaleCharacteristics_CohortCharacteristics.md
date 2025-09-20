# Visualise the top concepts per each cdm name, cohort, statification and window. — tableTopLargeScaleCharacteristics • CohortCharacteristics

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

# Visualise the top concepts per each cdm name, cohort, statification and window.

Source: [`R/tableLargeScaleCharacteristics.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/tableLargeScaleCharacteristics.R)

`tableTopLargeScaleCharacteristics.Rd`

Visualise the top concepts per each cdm name, cohort, statification and window.

## Usage
    
    
    tableTopLargeScaleCharacteristics(result, topConcepts = 10, type = "gt")

## Arguments

result
    

A summarised_result object.

topConcepts
    

Number of concepts to restrict the table.

type
    

Type of table, it can be any of the supported `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)` formats.

## Value

A formated table.

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, cdmSchema = "main", writeSchema = "main")
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      conceptSet = [list](https://rdrr.io/r/base/list.html)(viral_pharyngitis = 4112343),
      name = "my_cohort"
    )
    
    result <- [summariseLargeScaleCharacteristics](summariseLargeScaleCharacteristics.html)(
      cohort = cdm$my_cohort,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-Inf, -1), [c](https://rdrr.io/r/base/c.html)(0, 0), [c](https://rdrr.io/r/base/c.html)(1, Inf)),
      episodeInWindow = "drug_exposure"
    )
    
    tableTopLargeScaleCharacteristics(result)
    
    [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    } # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
