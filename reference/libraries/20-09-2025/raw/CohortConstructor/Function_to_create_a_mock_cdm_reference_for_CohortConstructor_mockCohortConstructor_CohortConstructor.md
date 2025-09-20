# Function to create a mock cdm reference for CohortConstructor — mockCohortConstructor • CohortConstructor

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Function to create a mock cdm reference for CohortConstructor

Source: [`R/mockCohortConstructor.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/mockCohortConstructor.R)

`mockCohortConstructor.Rd`

`mockCohortConstructor()` creates an example dataset that can be used for demonstrating and testing the package

## Usage
    
    
    mockCohortConstructor(
      nPerson = 10,
      conceptTable = NULL,
      tables = NULL,
      conceptId = NULL,
      conceptIdClass = NULL,
      drugExposure = FALSE,
      conditionOccurrence = FALSE,
      measurement = FALSE,
      death = FALSE,
      otherTables = NULL,
      con = DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)()),
      writeSchema = "main",
      seed = 123
    )

## Arguments

nPerson
    

number of person in the cdm

conceptTable
    

user defined concept table

tables
    

list of tables to include in the cdm

conceptId
    

list of concept id

conceptIdClass
    

the domain class of the conceptId

drugExposure
    

T/F include drug exposure table in the cdm

conditionOccurrence
    

T/F include condition occurrence in the cdm

measurement
    

T/F include measurement in the cdm

death
    

T/F include death table in the cdm

otherTables
    

it takes a list of single tibble with names to include other tables in the cdm

con
    

A DBI connection to create the cdm mock object.

writeSchema
    

Name of an schema on the same connection with writing permissions.

seed
    

Seed passed to omock::mockCdmFromTable

## Value

cdm object

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- mockCohortConstructor()
    
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of mock database ──────────────────────────────
    #> • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
    #> concept_synonym, drug_strength, observation_period, person, vocabulary
    #> • cohort tables: cohort1, cohort2
    #> • achilles tables: -
    #> • other tables: -
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
