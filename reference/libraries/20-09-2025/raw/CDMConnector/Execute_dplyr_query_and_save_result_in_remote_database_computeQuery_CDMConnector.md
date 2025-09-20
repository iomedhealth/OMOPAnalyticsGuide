# Execute dplyr query and save result in remote database — computeQuery • CDMConnector

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

# Execute dplyr query and save result in remote database

Source: [`R/compute.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/compute.R)

`computeQuery.Rd`

This function is a wrapper around `[dplyr::compute](https://dplyr.tidyverse.org/reference/compute.html)` that is tested on several database systems. It is needed to handle edge cases where `[dplyr::compute](https://dplyr.tidyverse.org/reference/compute.html)` does not produce correct SQL.

## Usage
    
    
    computeQuery(
      x,
      name = [uniqueTableName](https://darwin-eu.github.io/omopgenerics/reference/uniqueTableName.html)(),
      temporary = TRUE,
      schema = NULL,
      overwrite = TRUE,
      ...
    )

## Arguments

x
    

A dplyr query

name
    

The name of the table to create.

temporary
    

Should the table be temporary: TRUE (default) or FALSE

schema
    

The schema where the table should be created. Ignored if temporary = TRUE.

overwrite
    

Should the table be overwritten if it already exists: TRUE (default) or FALSE Ignored if temporary = TRUE.

...
    

Further arguments passed on the `[dplyr::compute](https://dplyr.tidyverse.org/reference/compute.html)`

## Value

A `[dplyr::tbl()](https://dplyr.tidyverse.org/reference/tbl.html)` reference to the newly created table.

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](eunomiaDir.html)())
    cdm <- [cdmFromCon](cdmFromCon.html)(con, "main")
    
    # create a temporary table in the remote database from a dplyr query
    drugCount <- cdm$concept [%>%](pipe.html)
      dplyr::[count](https://dplyr.tidyverse.org/reference/count.html)(domain_id == "Drug") [%>%](pipe.html)
      computeQuery()
    
    # create a permanent table in the remote database from a dplyr query
    drugCount <- cdm$concept [%>%](pipe.html)
      dplyr::[count](https://dplyr.tidyverse.org/reference/count.html)(domain_id == "Drug") [%>%](pipe.html)
      computeQuery("tmp_table", temporary = FALSE, schema = "main")
    
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con, shutdown = TRUE)
    } # }
    

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
