# Function to create a mock cdm reference for mockPhenotypeR — mockPhenotypeR • PhenotypeR

Skip to contents

[PhenotypeR](../index.html) 0.2.0

  * [Reference](../reference/index.html)
  * Articles
    * ###### Main functionality

    * [PhenotypeDiagnostics](../articles/PhenotypeDiagnostics.html)
    * [PhenotypeExpectations](../articles/PhenotypeExpectations.html)
    * [ShinyDiagnostics](../articles/ShinyDiagnostics.html)
    * * * *

    * ###### Individual functions

    * [DatabaseDiagnostics](../articles/DatabaseDiagnostics.html)
    * [CodelistDiagnostics](../articles/CodelistDiagnostics.html)
    * [CohortDiagnostics](../articles/CohortDiagnostics.html)
    * [PopulationDiagnostics](../articles/PopulationDiagnostics.html)
  * [PhenotypeR shiny App](https://dpa-pde-oxford.shinyapps.io/PhenotypeRShiny/)


  * [](https://github.com/OHDSI/PhenotypeR)



![](../logo.png)

# Function to create a mock cdm reference for mockPhenotypeR

`mockPhenotypeR.Rd`

`mockPhenotypeR()` creates an example dataset that can be used to show how the package works

## Usage
    
    
    mockPhenotypeR(
      nPerson = 100,
      con = DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)()),
      writeSchema = "main",
      seed = 111
    )

## Arguments

nPerson
    

number of people in the cdm.

con
    

A DBI connection to create the cdm mock object.

writeSchema
    

Name of an schema on the same connection with writing permissions.

seed
    

seed to use when creating the mock data.

## Value

cdm object

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    
    cdm <- mockPhenotypeR()
    
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of mock database ──────────────────────────────
    #> • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
    #> concept_synonym, condition_occurrence, death, device_exposure, drug_exposure,
    #> drug_strength, measurement, observation, observation_period, person,
    #> procedure_occurrence, visit_occurrence, vocabulary
    #> • cohort tables: my_cohort
    #> • achilles tables: achilles_analysis, achilles_results, achilles_results_dist
    #> • other tables: -
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
