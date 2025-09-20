# Compute a hash for each CDM table — computeDataHashByTable • CDMConnector

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

# Compute a hash for each CDM table

Source: [`R/utils.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/utils.R)

`computeDataHashByTable.Rd`

Compute a hash for each CDM table

## Usage
    
    
    computeDataHashByTable(cdm)

## Arguments

cdm
    

A cdm_reference object created by `cdmFromCon`

## Value

A dataframe with one row per table, row counts, unique value counts for one column, and a hash

## Details

This function is used to track changes in CDM databases. It returns a dataframe with one hash for each table. The hash is based on the overall row count and the number of unique values of one column of the table. For clinical tables we count the number of unique concept IDs. For some tables we do not calculate any unique value count (e.g. the location table) and simply use the total row count.

`r lifecycle::badge("experimental")

## Examples
    
    
    if (FALSE) { # \dontrun{
     [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
     con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](eunomiaDir.html)())
     cdm <- [cdmFromCon](cdmFromCon.html)(con, "main", "main")
     computeDataHashByTable(cdm)
     [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    } # }
    

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
