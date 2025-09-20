# Filter the rows of a `cdm_table` to the ones in observation that `indexDate` is in observation. — filterInObservation • PatientProfiles

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Filter the rows of a `cdm_table` to the ones in observation that `indexDate` is in observation.

Source: [`R/filterInObservation.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/filterInObservation.R)

`filterInObservation.Rd`

Filter the rows of a `cdm_table` to the ones in observation that `indexDate` is in observation.

## Usage
    
    
    filterInObservation(x, indexDate)

## Arguments

x
    

A `cdm_table` object.

indexDate
    

Name of a column of x that is a date.

## Value

A `cdm_table` that is a subset of the original table.

## Examples
    
    
    if (FALSE) { # \dontrun{
    con <- duckdb::dbConnect(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)()))
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con = con, cdmSchema = "main", writeSchema = "main"
    )
    
    cdm$condition_occurrence |>
      filterInObservation(indexDate = "condition_start_date") |>
      dplyr::[compute](https://dplyr.tidyverse.org/reference/compute.html)()
    } # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
