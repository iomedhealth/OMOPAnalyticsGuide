# Summarise the cohort codelist attribute — summariseCohortCodelist • CohortCharacteristics

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

# Summarise the cohort codelist attribute

Source: [`R/summariseCohortCodelist.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/summariseCohortCodelist.R)

`summariseCohortCodelist.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    summariseCohortCodelist(cohort, cohortId = NULL)

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

## Value

A summarised_result object with the exported cohort codelist information.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    #> Loading required package: DBI
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    dbName <- "GiBleed"
    [requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)(datasetName = dbName)
    #> ℹ `EUNOMIA_DATA_FOLDER` set to: /tmp/RtmpQYHaYw.
    #> 
    #> Download completed!
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(drv = [duckdb](https://r.duckdb.org/reference/duckdb.html)(dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)(datasetName = dbName)))
    #> Creating CDM database /tmp/RtmpQYHaYw/GiBleed_5.3.zip
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, cdmSchema = "main", writeSchema = "main")
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(cdm = cdm,
                                    conceptSet = [list](https://rdrr.io/r/base/list.html)(pharyngitis = 4112343L),
                                    name = "my_cohort")
    
    result <- summariseCohortCodelist(cdm$my_cohort)
    
    [glimpse](https://pillar.r-lib.org/reference/glimpse.html)(result)
    #> Rows: 1
    #> Columns: 13
    #> $ result_id        <int> 1
    #> $ cdm_name         <chr> "Synthea"
    #> $ group_name       <chr> "cohort_name"
    #> $ group_level      <chr> "pharyngitis"
    #> $ strata_name      <chr> "codelist_name &&& codelist_type"
    #> $ strata_level     <chr> "pharyngitis &&& index event"
    #> $ variable_name    <chr> "overall"
    #> $ variable_level   <chr> "overall"
    #> $ estimate_name    <chr> "concept_id"
    #> $ estimate_type    <chr> "integer"
    #> $ estimate_value   <chr> "4112343"
    #> $ additional_name  <chr> "concept_name"
    #> $ additional_level <chr> "Acute viral pharyngitis"
    
    [tidy](https://generics.r-lib.org/reference/tidy.html)(result)
    #> # A tibble: 1 × 8
    #>   cdm_name cohort_name codelist_name codelist_type variable_name variable_level
    #>   <chr>    <chr>       <chr>         <chr>         <chr>         <chr>         
    #> 1 Synthea  pharyngitis pharyngitis   index event   overall       overall       
    #> # ℹ 2 more variables: concept_name <chr>, concept_id <int>
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
