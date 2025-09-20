# Helper for working with compound schemas — inSchema • CDMConnector

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

# Helper for working with compound schemas

Source: [`R/utils.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/utils.R)

`inSchema.Rd`

This is similar to dbplyr::in_schema but has been tested across multiple database platforms. It only exists to work around some of the limitations of dbplyr::in_schema.

## Usage
    
    
    inSchema(schema, table, dbms = NULL)

## Arguments

schema
    

A schema name as a character string

table
    

A table name as character string

dbms
    

The name of the database management system as returned by `dbms(connection)`

## Value

A DBI::Id that represents a qualified table and schema

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
