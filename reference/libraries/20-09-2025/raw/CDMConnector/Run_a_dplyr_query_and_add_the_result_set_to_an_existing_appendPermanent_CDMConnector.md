# Run a dplyr query and add the result set to an existing — appendPermanent • CDMConnector

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

# Run a dplyr query and add the result set to an existing

Source: [`R/compute.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/compute.R)

`appendPermanent.Rd`

Run a dplyr query and add the result set to an existing

## Usage
    
    
    appendPermanent(x, name, schema = NULL)

## Arguments

x
    

A dplyr query

name
    

Name of the table to be appended. If it does not already exist it will be created.

schema
    

Schema where the table exists. Can be a length 1 or 2 vector. (e.g. schema = "my_schema", schema = c("my_schema", "dbo"))

## Value

A dplyr reference to the newly created table

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](eunomiaDir.html)())
    concept <- dplyr::[tbl](https://dplyr.tidyverse.org/reference/tbl.html)(con, "concept")
    
    # create a table
    rxnorm_count <- concept [%>%](pipe.html)
      dplyr::[filter](https://dplyr.tidyverse.org/reference/filter.html)(domain_id == "Drug") [%>%](pipe.html)
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(isRxnorm = (vocabulary_id == "RxNorm")) [%>%](pipe.html)
      dplyr::[count](https://dplyr.tidyverse.org/reference/count.html)(domain_id, isRxnorm) [%>%](pipe.html)
      [compute](https://dplyr.tidyverse.org/reference/compute.html)("rxnorm_count")
    
    # append to an existing table
    rxnorm_count <- concept [%>%](pipe.html)
      dplyr::[filter](https://dplyr.tidyverse.org/reference/filter.html)(domain_id == "Procedure") [%>%](pipe.html)
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(isRxnorm = (vocabulary_id == "RxNorm")) [%>%](pipe.html)
      dplyr::[count](https://dplyr.tidyverse.org/reference/count.html)(domain_id, isRxnorm) [%>%](pipe.html)
      appendPermanent("rxnorm_count")
    
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con, shutdown = TRUE)
    
    } # }
    

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
