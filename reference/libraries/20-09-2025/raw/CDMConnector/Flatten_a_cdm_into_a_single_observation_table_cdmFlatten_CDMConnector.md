# Flatten a cdm into a single observation table — cdmFlatten • CDMConnector

Skip to contents

[CDMConnector](../index.html) 2.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Getting Started](../articles/a01_getting-started.html)
    * [Working with cohorts](../articles/a02_cohorts.html)
    * [CDMConnector and dbplyr](../articles/a03_dbplyr.html)
    * [DBI connection examples](../articles/a04_DBI_connection_examples.html)
    * [Using CDM attributes](../articles/a06_using_cdm_attributes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CDMConnector/)



![](../logo.png)

# Flatten a cdm into a single observation table

Source: [`R/cdmSubset.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/cdmSubset.R)

`cdmFlatten.Rd`

This experimental function transforms the OMOP CDM into a single observation table. This is only recommended for use with a filtered CDM or a cdm that is small in size.

## Usage
    
    
    cdmFlatten(
      cdm,
      domain = [c](https://rdrr.io/r/base/c.html)("condition_occurrence", "drug_exposure", "procedure_occurrence"),
      includeConceptName = TRUE
    )

## Arguments

cdm
    

A cdm_reference object

domain
    

Domains to include. Must be a subset of "condition_occurrence", "drug_exposure", "procedure_occurrence", "measurement", "visit_occurrence", "death", "observation"

includeConceptName
    

Should concept_name and type_concept_name be include in the output table? TRUE (default) or FALSE

## Value

A lazy query that when evaluated will result in a single table

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](eunomiaDir.html)())
    
    cdm <- [cdmFromCon](cdmFromCon.html)(con, cdmSchema = "main")
    
    all_observations <- [cdmSubset](cdmSubset.html)(cdm, personId = [c](https://rdrr.io/r/base/c.html)(2, 18, 42)) [%>%](pipe.html)
      cdmFlatten() [%>%](pipe.html)
      [collect](https://dplyr.tidyverse.org/reference/compute.html)()
    
    all_observations
    #> # A tibble: 213 × 8
    #>    person_id observation_.  start_date end_date   type_.  domain obser.  type_.
    #>        <dbl>          <dbl> <date>     <date>       <dbl> <chr>  <chr>   <chr>
    #>  1         2       40213201 1986-09-09 1986-09-09  5.81e5 drug   pneumo  <NA>
    #>  2        18        4116491 1997-11-09 1998-01-09  3.20e4 condi  Escher  <NA>
    #>  3        18       40213227 2017-01-04 2017-01-04  5.81e5 drug   tetanu  <NA>
    #>  4        42        4156265 1974-06-13 1974-06-27  3.20e4 condi  Facial  <NA>
    #>  5        18       40213160 1966-02-23 1966-02-23  5.81e5 drug   poliov  <NA>
    #>  6        42        4198190 1933-10-29 1933-10-29  3.80e7 proce  Append  <NA>
    #>  7         2        4109685 1952-07-13 1952-07-27  3.20e4 condi  Lacera  <NA>
    #>  8        18       40213260 2017-01-04 2017-01-04  5.81e5 drug   zoster  <NA>
    #>  9        42        4151422 1985-02-03 1985-02-03  3.80e7 proce  Sputum  <NA>
    #> 10         2        4163872 1993-03-29 1993-03-29  3.80e7 proce  Plain   <NA>
    #> # ... with 203 more rows, and abbreviated variable names observation_concept_id,
    #> #   type_concept_id, observation_concept_name, type_concept_name
    
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con, shutdown = TRUE)
    } # }
    

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
