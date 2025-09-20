# Subset a cdm object to a set of persons — cdmSubset • CDMConnector

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

# Subset a cdm object to a set of persons

Source: [`R/cdmSubset.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/cdmSubset.R)

`cdmSubset.Rd`

`cdmSubset` takes a cdm object and a list of person IDs as input. It returns a new cdm that includes data only for persons matching the provided person IDs. Generated cohorts in the cdm will also be subset to the IDs provided.

## Usage
    
    
    cdmSubset(cdm, personId)

## Arguments

cdm
    

A cdm_reference object

personId
    

A numeric vector of person IDs to include in the cdm

## Value

A modified cdm_reference object where all clinical tables are lazy queries pointing to subset

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](eunomiaDir.html)())
    
    cdm <- [cdmFromCon](cdmFromCon.html)(con, cdmSchema = "main")
    
    cdm2 <- cdmSubset(cdm, personId = [c](https://rdrr.io/r/base/c.html)(2, 18, 42))
    
    cdm2$person [%>%](pipe.html)
      [select](https://dplyr.tidyverse.org/reference/select.html)(1:3)
    #> # Source:   SQL [3 x 3]
    #> # Database: DuckDB 0.6.1
    #>   person_id gender_concept_id year_of_birth
    #>       <dbl>             <dbl>         <dbl>
    #> 1         2              8532          1920
    #> 2        18              8532          1965
    #> 3        42              8532          1909
    
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con, shutdown = TRUE)
    } # }
    

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
