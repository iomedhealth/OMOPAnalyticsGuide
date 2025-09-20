# Creates a mock database to test OmopSketch package. — mockOmopSketch • OmopSketch

Skip to contents

[OmopSketch](../index.html) 0.5.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Summarise clinical tables records](../articles/summarise_clinical_tables_records.html)
    * [Summarise concept id counts](../articles/summarise_concept_id_counts.html)
    * [Summarise observation period](../articles/summarise_observation_period.html)
    * [Characterisation of OMOP CDM](../articles/characterisation.html)
    * [Summarise missing data](../articles/missing_data.html)
    * [Summarise database characteristics](../articles/database_characteristics.html)
  * [Changelog](../news/index.html)
  * [Characterisation synthetic datasets](https://dpa-pde-oxford.shinyapps.io/OmopSketchCharacterisation/)


  *   * [](https://github.com/OHDSI/OmopSketch/)



![](../logo.png)

# Creates a mock database to test OmopSketch package.

Source: [`R/mockOmopSketch.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/mockOmopSketch.R)

`mockOmopSketch.Rd`

Creates a mock database to test OmopSketch package.

## Usage
    
    
    mockOmopSketch(
      numberIndividuals = 100,
      con = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)(),
      writeSchema = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)(),
      seed = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)()
    )

## Arguments

numberIndividuals
    

Number of individuals to create in the cdm reference object.

con
    

deprecated.

writeSchema
    

deprecated.

seed
    

deprecated.

## Value

A mock cdm_reference object.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    
    cdm <- mockOmopSketch(numberIndividuals = 100)
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of mockOmopSketch ─────────────────────────────
    #> • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
    #> concept_synonym, condition_occurrence, death, device_exposure, drug_exposure,
    #> drug_strength, measurement, observation, observation_period, person,
    #> procedure_occurrence, visit_occurrence, vocabulary
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    
    # to insert into a duck db connection
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    #> Loading required package: DBI
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(drv = [duckdb](https://r.duckdb.org/reference/duckdb.html)())
    to <- [dbSource](https://darwin-eu.github.io/CDMConnector/reference/dbSource.html)(con = con, writeSchema = "main")
    cdm <- [insertCdmTo](https://darwin-eu.github.io/omopgenerics/reference/insertCdmTo.html)(cdm = cdm, to = to)
    
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of mockOmopSketch ─────────────────────────────
    #> • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
    #> concept_synonym, condition_occurrence, death, device_exposure, drug_exposure,
    #> drug_strength, measurement, observation, observation_period, person,
    #> procedure_occurrence, visit_occurrence, vocabulary
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    # }
    
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
