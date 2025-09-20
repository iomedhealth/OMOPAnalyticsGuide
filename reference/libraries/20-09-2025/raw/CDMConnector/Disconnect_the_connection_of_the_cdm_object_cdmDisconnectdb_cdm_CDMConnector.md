# Disconnect the connection of the cdm object — cdmDisconnect.db_cdm • CDMConnector

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

# Disconnect the connection of the cdm object

Source: [`R/dbSource.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/dbSource.R)

`cdmDisconnect.db_cdm.Rd`

This function will disconnect from the database as well as drop "temporary" tables that were created on database systems that do not support actual temporary tables. Currently temp tables are emulated on Spark/Databricks systems.

## Usage
    
    
    # S3 method for class 'db_cdm'
    [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm, dropWriteSchema = FALSE, ...)

## Arguments

cdm
    

cdm reference

dropWriteSchema
    

Whether to drop tables in the writeSchema

...
    

Not used

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
