# Create a CDM reference object from a database connection — cdmFromCon • CDMConnector

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

# Create a CDM reference object from a database connection

Source: [`R/cdm.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/cdm.R)

`cdmFromCon.Rd`

Create a CDM reference object from a database connection

## Usage
    
    
    cdmFromCon(
      con,
      cdmSchema,
      writeSchema,
      cohortTables = NULL,
      cdmVersion = NULL,
      cdmName = NULL,
      achillesSchema = NULL,
      .softValidation = FALSE,
      writePrefix = NULL
    )

## Arguments

con
    

A DBI database connection to a database where an OMOP CDM v5.4 or v5.3 instance is located.

cdmSchema
    

The schema where the OMOP CDM tables are located. Defaults to NULL.

writeSchema
    

An optional schema in the CDM database that the user has write access to.

cohortTables
    

A character vector listing the cohort table names to be included in the CDM object.

cdmVersion
    

The version of the OMOP CDM. Cam be "5.3", "5.4", or NULL (default). If NULL we will attempt to automatically determine the cdm version using the cdm_source table and heuristics.

cdmName
    

The name of the CDM. If NULL (default) the cdm_source_name . field in the CDM_SOURCE table will be used.

achillesSchema
    

An optional schema in the CDM database that contains achilles tables.

.softValidation
    

Normally the observation period table should not have overlapping observation periods for a single person. If `.softValidation` is `TRUE` the validation check that looks for overlapping observation periods will be skipped. Other analytic packages may break or produce incorrect results if `softValidation` is `TRUE` and the observation period table contains overlapping observation periods.

writePrefix
    

A prefix that will be added to all tables created in the write_schema. This can be used to create namespace in your database write_schema for your tables.

## Value

A list of dplyr database table references pointing to CDM tables

## Details

cdmFromCon creates a new cdm reference object from a DBI database connection. In addition to the connection the user needs to pass in the schema in the database where the cdm data can be found as well as another schema where the user has write access to create tables. Nearly all downstream analytic packages need the ability to create temporary data in the database so the write_schema is required.

Some database systems have the idea of a catalog or a compound schema with two components. See examples below for how to pass in catalogs and schemas.

You can also specify a `writePrefix`. This is a short character string that will be added to any tables created in the `writeSchema` effectively a namespace in the schema just for your analysis. If the write_schema is a shared between multiple users setting a unique write_prefix ensures you do not overwrite existing tables and allows you to easily clean up tables by dropping all tables that start with the prefix.

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](eunomiaDir.html)())
    
    # minimal example
    cdm <- cdmFromCon(con,
                      cdmSchema = "main",
                      writeSchema = "scratch")
    
    # write prefix is optional but recommended if write_schema is shared
    cdm <- cdmFromCon(con,
                      cdmSchema = "main",
                      writeSchema = "scratch",
                      writePrefix = "tmp_")
    
    # Some database systems use catalogs or compound schemas.
    # These can be specified as follows:
    cdm <- cdmFromCon(con,
                      cdmSchema = "catalog.main",
                      writeSchema = "catalog.scratch",
                      writePrefix = "tmp_")
    
    cdm <- cdmFromCon(con,
                      cdmSchema = [c](https://rdrr.io/r/base/c.html)("my_catalog", "main"),
                      writeSchema = [c](https://rdrr.io/r/base/c.html)("my_catalog", "scratch"),
                      writePrefix = "tmp_")
    
    cdm <- cdmFromCon(con,
                      cdmSchema = [c](https://rdrr.io/r/base/c.html)(catalog = "my_catalog", schema = "main"),
                      writeSchema = [c](https://rdrr.io/r/base/c.html)(catalog = "my_catalog", schema = "scratch"),
                      writePrefix = "tmp_")
    
     DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con)
    } # }
    
    
    

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
