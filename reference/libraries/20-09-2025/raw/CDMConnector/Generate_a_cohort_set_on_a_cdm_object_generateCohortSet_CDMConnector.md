# Generate a cohort set on a cdm object — generateCohortSet • CDMConnector

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

# Generate a cohort set on a cdm object

Source: [`R/generateCohortSet.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/generateCohortSet.R)

`generateCohortSet.Rd`

A "cohort_table" object consists of four components

  * A remote table reference to an OHDSI cohort table with at least the columns: cohort_definition_id, subject_id, cohort_start_date, cohort_end_date. Additional columns are optional and some analytic packages define additional columns specific to certain analytic cohorts.

  * A **settings attribute** which points to a remote table containing cohort settings including the names of the cohorts.

  * An **attrition attribute** which points to a remote table with attrition information recorded during generation. This attribute is optional. Since calculating attrition takes additional compute it can be skipped resulting in a NULL attrition attribute.

  * A **cohortCounts attribute** which points to a remote table containing cohort counts




Each of the three attributes are tidy tables. The implementation of this object is experimental and user feedback is welcome.

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental) One key design principle is that cohort_table objects are created once and can persist across analysis execution but should not be modified after creation. While it is possible to modify a cohort_table object doing so will invalidate it and it's attributes may no longer be accurate.

## Usage
    
    
    generateCohortSet(
      cdm,
      cohortSet,
      name,
      computeAttrition = TRUE,
      overwrite = TRUE
    )

## Arguments

cdm
    

A cdm reference created by CDMConnector. write_schema must be specified.

cohortSet
    

A cohortSet dataframe created with `[readCohortSet()](readCohortSet.html)`

name
    

Name of the cohort table to be created. This will also be used as a prefix for the cohort attribute tables. This must be a lowercase character string that starts with a letter and only contains letters, numbers, and underscores.

computeAttrition
    

Should attrition be computed? TRUE (default) or FALSE

overwrite
    

Should the cohort table be overwritten if it already exists? TRUE (default) or FALSE

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](eunomiaDir.html)())
    cdm <- [cdmFromCon](cdmFromCon.html)(con,
                      cdmSchema = "main",
                      writeSchema = "main")
    
    cohortSet <- [readCohortSet](readCohortSet.html)([system.file](https://rdrr.io/r/base/system.file.html)("cohorts2", package = "CDMConnector"))
    cdm <- generateCohortSet(cdm, cohortSet, name = "cohort")
    
    [print](https://rdrr.io/r/base/print.html)(cdm$cohort)
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$cohort)
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort)
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$cohort)
    } # }
    

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
