# Package index • CDMConnector

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

# Package index

### CDM Object

Create or transform a CDM reference object. These accept and return cdm objects.

`[cdmCon()](cdmCon.html)`
    Get underlying database connection

`[cdmDisconnect(_< db_cdm>_)](cdmDisconnect.db_cdm.html)`
    Disconnect the connection of the cdm object

`[cdmFlatten()](cdmFlatten.html)`
    Flatten a cdm into a single observation table

`[cdmFromCon()](cdmFromCon.html)`
    Create a CDM reference object from a database connection

`[cdmSample()](cdmSample.html)`
    Subset a cdm object to a random sample of individuals

`[cdmSubset()](cdmSubset.html)`
    Subset a cdm object to a set of persons

`[cdmSubsetCohort()](cdmSubsetCohort.html)`
    Subset a cdm to the individuals in one or more cohorts

`[cdmWriteSchema()](cdmWriteSchema.html)`
    Get cdm write schema

`[computeDataHashByTable()](computeDataHashByTable.html)`
    Compute a hash for each CDM table

`[copyCdmTo()](copyCdmTo.html)`
    Copy a cdm object from one database to another

`[dbSource()](dbSource.html)`
    Create a source for a cdm in a database.

`[dropTable(_< db_cdm>_)](dropTable.db_cdm.html)`
    Drop table from a database backed cdm object

`[snapshot()](snapshot.html)`
    Extract CDM metadata

`[tblGroup()](tblGroup.html)`
    CDM table selection helper

`[version()](version.html)`
    Get the CDM version

### Cohort Creation and Transformation

A cohort is a set of person-days representing the time during which people in a CDM exhibited some observable characteristics. Cohorts are often the foundation of downstream analyses.

`[generateCohortSet()](generateCohortSet.html)` experimental
    Generate a cohort set on a cdm object

`[generateConceptCohortSet()](generateConceptCohortSet.html)`
    Create a new generated cohort set from a list of concept sets

`[readCohortSet()](readCohortSet.html)`
    Read a set of cohort definitions into R

`[summariseQuantile()](summariseQuantile.html)`
    Quantile calculation using dbplyr

`[summariseQuantile2()](summariseQuantile2.html)`
    Quantile calculation using dbplyr

### dbplyr workarounds

Functions that can be used in cross database dplyr pipelines

`[appendPermanent()](appendPermanent.html)`
    Run a dplyr query and add the result set to an existing

`[asDate()](asDate.html)`
    as.Date dbplyr translation wrapper

`[computeQuery()](computeQuery.html)`
    Execute dplyr query and save result in remote database

`[dateadd()](dateadd.html)`
    Add days or years to a date in a dplyr query

`[datediff()](datediff.html)`
    Compute the difference between two days

`[datepart()](datepart.html)`
    Extract the day, month or year of a date in a dplyr pipeline

`[inSchema()](inSchema.html)`
    Helper for working with compound schemas

### DBI connection

Functions that accept DBI connections and are useful in cross database DBI code

`[dbms()](dbms.html)`
    Get the database management system (dbms) from a cdm_reference or DBI connection

`[listTables()](listTables.html)`
    List tables in a schema

### Eunomia example CDM

Easily create and use example CDMs in a [duckdb](https://duckdb.org/) database

`[downloadEunomiaData()](downloadEunomiaData.html)`
    Download Eunomia data files

`[eunomiaDir()](eunomiaDir.html)`
    Create a copy of an example OMOP CDM dataset

`[eunomiaIsAvailable()](eunomiaIsAvailable.html)`
    Has the Eunomia dataset been cached?

`[exampleDatasets()](exampleDatasets.html)`
    List the available example CDM datasets

`[requireEunomia()](requireEunomia.html)`
    Require eunomia to be available. The function makes sure that you can later create a eunomia database with `[eunomiaDir()](../reference/eunomiaDir.html)`.

### Benchmarking

Run benchmarking of simple queries against your CDM reference

`[benchmarkCDMConnector()](benchmarkCDMConnector.html)`
    Run benchmark of tasks using CDMConnector

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
