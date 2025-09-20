# Drop table from a database backed cdm object — dropTable.db_cdm • CDMConnector

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

# Drop table from a database backed cdm object

Source: [`R/dbSource.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/dbSource.R)

`dropTable.db_cdm.Rd`

Tables will be dropped from the write schema of the cdm.

## Usage
    
    
    # S3 method for class 'db_cdm'
    [dropTable](https://darwin-eu.github.io/omopgenerics/reference/dropTable.html)(cdm, name)

## Arguments

cdm
    

a cdm_reference object

name
    

A character vector of table names to be dropped

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
