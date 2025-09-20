# CDM table selection helper — tblGroup • CDMConnector

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

# CDM table selection helper

Source: [`R/cdm.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/cdm.R)

`tblGroup.Rd`

The OMOP CDM tables are grouped together and the `tblGroup` function allows users to easily create a CDM reference including one or more table groups.

## Usage
    
    
    tblGroup(group)

## Arguments

group
    

A character vector of CDM table groups: "vocab", "clinical", "all", "default", "derived".

## Value

A character vector of CDM tables names in the groups

## Details

![CDM 5.4](figures/cdm54.png)

The "default" table group is meant to capture the most commonly used set of CDM tables. Currently the "default" group is: person, observation_period, visit_occurrence, visit_detail, condition_occurrence, drug_exposure, procedure_occurrence, device_exposure, measurement, observation, death, note, note_nlp, specimen, fact_relationship, location, care_site, provider, payer_plan_period, cost, drug_era, dose_era, condition_era, concept, vocabulary, concept_relationship, concept_ancestor, concept_synonym, drug_strength

## Examples
    
    
    if (FALSE) { # \dontrun{
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(RPostgres::[Postgres](https://rpostgres.r-dbi.org/reference/Postgres.html)(),
                          dbname = "cdm",
                          host = "localhost",
                          user = "postgres",
                          password = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("PASSWORD"))
    
    cdm <- [cdmFromCon](cdmFromCon.html)(con, cdmName = "test", cdmSchema = "public") [%>%](pipe.html)
      cdmSelectTbl(tblGroup("vocab"))
    } # }
    

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
