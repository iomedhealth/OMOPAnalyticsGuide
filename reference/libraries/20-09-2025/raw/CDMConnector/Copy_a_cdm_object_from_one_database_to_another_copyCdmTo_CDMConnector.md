# Copy a cdm object from one database to another — copyCdmTo • CDMConnector

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

# Copy a cdm object from one database to another

Source: [`R/copyCdmTo.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/copyCdmTo.R)

`copyCdmTo.Rd`

It may be helpful to be able to easily copy a small test cdm from a local database to a remote for testing. copyCdmTo takes a cdm object and a connection. It copies the cdm to the remote database connection. CDM tables can be prefixed in the new database allowing for multiple cdms in a single shared database schema.

## Usage
    
    
    copyCdmTo(con, cdm, schema, overwrite = FALSE)

## Arguments

con
    

A DBI database connection created by `[DBI::dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)`

cdm
    

A cdm reference object created by `[CDMConnector::cdmFromCon](cdmFromCon.html)` or `CDMConnector::cdm_from_con`

schema
    

schema name in the remote database where the user has write permission

overwrite
    

Should the cohort table be overwritten if it already exists? TRUE or FALSE (default)

## Value

A cdm reference object pointing to the newly created cdm in the remote database

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
