# Create a source for a cdm in a database. — dbSource • CDMConnector

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

# Create a source for a cdm in a database.

Source: [`R/dbSource.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/dbSource.R)

`dbSource.Rd`

Create a source for a cdm in a database.

## Usage
    
    
    dbSource(con, writeSchema)

## Arguments

con
    

Connection to a database.

writeSchema
    

Schema where cohort tables are. You must have read and write access to it.

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
