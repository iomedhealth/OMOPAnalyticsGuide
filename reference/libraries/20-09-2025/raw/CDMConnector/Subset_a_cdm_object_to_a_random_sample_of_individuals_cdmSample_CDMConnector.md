# Subset a cdm object to a random sample of individuals — cdmSample • CDMConnector

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

# Subset a cdm object to a random sample of individuals

Source: [`R/cdmSubset.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/cdmSubset.R)

`cdmSample.Rd`

`cdmSample` takes a cdm object and returns a new cdm that includes only a random sample of persons in the cdm. Only `person_id`s in both the person table and observation_period table will be considered.

## Usage
    
    
    cdmSample(cdm, n, seed = [sample.int](https://rdrr.io/r/base/sample.html)(1e+06, 1), name = "person_sample")

## Arguments

cdm
    

A cdm_reference object.

n
    

Number of persons to include in the cdm.

seed
    

Seed for the random number generator.

name
    

Name of the table that will contain the sample of persons.

## Value

A modified cdm_reference object where all clinical tables are lazy queries pointing to subset

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](eunomiaDir.html)())
    
    cdm <- [cdmFromCon](cdmFromCon.html)(con, cdmSchema = "main")
    
    cdmSampled <- cdmSample(cdm, n = 2)
    
    cdmSampled$person [%>%](pipe.html)
      [select](https://dplyr.tidyverse.org/reference/select.html)(person_id)
    #> # Source:   SQL [2 x 1]
    #> # Database: DuckDB 0.6.1
    #>   person_id
    #>       <dbl>
    #> 1       155
    #> 2      3422
    
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con, shutdown = TRUE)
    } # }
    

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
