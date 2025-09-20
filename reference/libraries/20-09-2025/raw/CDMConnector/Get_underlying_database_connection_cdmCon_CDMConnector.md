# Get underlying database connection — cdmCon • CDMConnector

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

# Get underlying database connection

Source: [`R/cdm.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/cdm.R)

`cdmCon.Rd`

Get underlying database connection

## Usage
    
    
    cdmCon(cdm)

## Arguments

cdm
    

A cdm reference object created by `cdmFromCon`

## Value

A reference to the database containing tables in the cdm reference

## Examples
    
    
    if (FALSE) { # \dontrun{
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](eunomiaDir.html)())
    
    cdm <- [cdmFromCon](cdmFromCon.html)(con = con, cdmName = "Eunomia",
                      cdmSchema =  "main", writeSchema = "main")
    
    cdmCon(cdm)
    
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con)
    } # }
    

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
