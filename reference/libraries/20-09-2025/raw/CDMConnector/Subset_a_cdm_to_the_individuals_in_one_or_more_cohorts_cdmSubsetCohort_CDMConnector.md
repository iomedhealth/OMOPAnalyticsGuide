# Subset a cdm to the individuals in one or more cohorts — cdmSubsetCohort • CDMConnector

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

# Subset a cdm to the individuals in one or more cohorts

Source: [`R/cdmSubset.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/cdmSubset.R)

`cdmSubsetCohort.Rd`

`cdmSubset` will return a new cdm object that contains lazy queries pointing to each of the cdm tables but subset to individuals in a generated cohort. Since the cdm tables are lazy queries, the subset operation will only be done when the tables are used. `computeQuery` can be used to run the SQL used to subset a cdm table and store it as a new table in the database.

## Usage
    
    
    cdmSubsetCohort(cdm, cohortTable = "cohort", cohortId = NULL, verbose = FALSE)

## Arguments

cdm
    

A cdm_reference object

cohortTable
    

The name of a cohort table in the cdm reference

cohortId
    

IDs of the cohorts that we want to subset from the cohort table. If NULL (default) all cohorts in cohort table are considered.

verbose
    

Should subset messages be printed? TRUE or FALSE (default)

## Value

A modified cdm_reference with all clinical tables subset to just the persons in the selected cohorts.

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](eunomiaDir.html)())
    
    cdm <- [cdmFromCon](cdmFromCon.html)(con, cdmSchema = "main", writeSchema = "main")
    
    # generate a cohort
    path <- [system.file](https://rdrr.io/r/base/system.file.html)("cohorts2", mustWork = TRUE, package = "CDMConnector")
    
    cohortSet <- [readCohortSet](readCohortSet.html)(path) [%>%](pipe.html)
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(cohort_name == "GIBleed_male")
    
    # subset cdm to persons in the generated cohort
    cdm <- [generateCohortSet](generateCohortSet.html)(cdm, cohortSet = cohortSet, name = "gibleed")
    
    cdmGiBleed <- cdmSubsetCohort(cdm, cohortTable = "gibleed")
    
    cdmGiBleed$person [%>%](pipe.html)
      [tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [1 x 1]
    #> # Database: DuckDB 0.6.1
    #>       n
    #>   <dbl>
    #> 1   237
    
    cdm$person [%>%](pipe.html)
      [tally](https://dplyr.tidyverse.org/reference/count.html)()
    #> # Source:   SQL [1 x 1]
    #> # Database: DuckDB 0.6.1
    #>       n
    #>   <dbl>
    #> 1  2694
    
    
    DBI::[dbDisconnect](https://dbi.r-dbi.org/reference/dbDisconnect.html)(con, shutdown = TRUE)
    } # }
    

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
