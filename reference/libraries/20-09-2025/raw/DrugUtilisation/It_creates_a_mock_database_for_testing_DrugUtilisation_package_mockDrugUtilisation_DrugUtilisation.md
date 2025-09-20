# It creates a mock database for testing DrugUtilisation package — mockDrugUtilisation • DrugUtilisation

Skip to contents

[DrugUtilisation](../index.html) 1.0.4

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Create mock data to test DrugUtilisation package](../articles/mock_data.html)
    * [Creating drug cohorts](../articles/create_cohorts.html)
    * [Identify and summarise indications among a drug cohort](../articles/indication.html)
    * [Daily dose calculation](../articles/daily_dose_calculation.html)
    * [Getting drug utilisation related information of subjects in a cohort](../articles/drug_utilisation.html)
    * [Summarise treatments](../articles/summarise_treatments.html)
    * [Summarising treatment adherence](../articles/treatment_discontinuation.html)
    * [Assessing drug restart and switching after treatment](../articles/drug_restart.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/DrugUtilisation/)



![](../logo.png)

# It creates a mock database for testing DrugUtilisation package

Source: [`R/mockDrugUtilisation.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/mockDrugUtilisation.R)

`mockDrugUtilisation.Rd`

It creates a mock database for testing DrugUtilisation package

## Usage
    
    
    mockDrugUtilisation(
      con = NULL,
      writeSchema = NULL,
      numberIndividuals = 10,
      seed = NULL,
      ...
    )

## Arguments

con
    

A DBIConnection object to a database. If NULL a new duckdb connection will be used.

writeSchema
    

A schema with writing permissions to copy there the cdm tables.

numberIndividuals
    

Number of individuals in the mock cdm.

seed
    

Seed for the random numbers. If NULL no seed is used.

...
    

Tables to use as basis to create the mock. If some tables are provided they will be used to construct the cdm object.

## Value

A cdm reference with the mock tables

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- mockDrugUtilisation()
    
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of DUS MOCK ───────────────────────────────────
    #> • omop tables: person, observation_period, concept, concept_ancestor,
    #> drug_strength, concept_relationship, drug_exposure, condition_occurrence,
    #> observation, visit_occurrence
    #> • cohort tables: cohort1, cohort2
    #> • achilles tables: -
    #> • other tables: -
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
