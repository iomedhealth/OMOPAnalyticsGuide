# Extract CDM metadata — snapshot • CDMConnector

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

# Extract CDM metadata

Source: [`R/cdm.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/cdm.R)

`snapshot.Rd`

Extract the name, version, and selected record counts from a cdm.

## Usage
    
    
    snapshot(cdm, computeDataHash = FALSE)

## Arguments

cdm
    

A cdm object

computeDataHash
    

Compute a hash of the CDM. See ?DatabaseConnector::computeDataHash for details.

## Value

A named list of attributes about the cdm including selected fields from the cdm_source table and record counts from the person and observation_period tables

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](eunomiaDir.html)())
    cdm <- [cdmFromCon](cdmFromCon.html)(con, "main")
    snapshot(cdm)
    
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con, shutdown = TRUE)
    } # }
    

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
