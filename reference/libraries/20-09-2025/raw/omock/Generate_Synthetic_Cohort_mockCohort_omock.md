# Generate Synthetic Cohort — mockCohort • omock

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Generate Synthetic Cohort

Source: [`R/mockCohort.R`](https://github.com/ohdsi/omock/blob/main/R/mockCohort.R)

`mockCohort.Rd`

This function generates synthetic cohort data and adds it to a given CDM (Common Data Model) reference. It allows for creating multiple cohorts with specified properties and simulates the frequency of observations for individuals.

## Usage
    
    
    mockCohort(
      cdm,
      name = "cohort",
      numberCohorts = 1,
      cohortName = [paste0](https://rdrr.io/r/base/paste.html)("cohort_", [seq_len](https://rdrr.io/r/base/seq.html)(numberCohorts)),
      recordPerson = 1,
      seed = NULL
    )

## Arguments

cdm
    

A CDM reference object where the synthetic cohort data will be stored. This object should already include necessary tables such as `person` and `observation_period`.

name
    

A string specifying the name of the table within the CDM where the cohort data will be stored. Defaults to "cohort". This name will be used to reference the new table in the CDM.

numberCohorts
    

An integer specifying the number of different cohorts to create within the table. Defaults to 1. This parameter allows for the creation of multiple cohorts, each with a unique identifier.

cohortName
    

A character vector specifying the names of the cohorts to be created. If not provided, default names based on a sequence (e.g., "cohort_1", "cohort_2", ...) will be generated. The length of this vector must match the value of `numberCohorts`. This parameter provides meaningful names for each cohort.

recordPerson
    

An integer or a vector of integers specifying the expected number of records per person within each cohort. If a single integer is provided, it applies to all cohorts. If a vector is provided, its length must match the value of `numberCohorts`. This parameter helps simulate the frequency of observations for individuals in each cohort, allowing for realistic variability in data.

seed
    

An integer specifying the random seed for reproducibility of the generated data. Setting a seed ensures that the same synthetic data can be generated again, facilitating consistent results across different runs.

## Value

A CDM reference object with the mock cohort tables added. The new table will contain synthetic data representing the specified cohorts, each with its own set of observation records.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    cdm <- [mockCdmReference](mockCdmReference.html)() |>
      [mockPerson](mockPerson.html)(nPerson = 100) |>
      [mockObservationPeriod](mockObservationPeriod.html)() |>
      mockCohort(
        name = "omock_example",
        numberCohorts = 2,
        cohortName = [c](https://rdrr.io/r/base/c.html)("omock_cohort_1", "omock_cohort_2")
      )
    
    cdm
    #> 
    #> ── # OMOP CDM reference (local) of mock database ───────────────────────────────
    #> • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
    #> concept_synonym, drug_strength, observation_period, person, vocabulary
    #> • cohort tables: omock_example
    #> • achilles tables: -
    #> • other tables: -
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
