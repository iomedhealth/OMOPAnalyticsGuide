# Creating synthetic cohorts • omock

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

# Creating synthetic cohorts

Source: [`vignettes/a02_Creating_synthetic_cohorts.Rmd`](https://github.com/ohdsi/omock/blob/main/vignettes/a02_Creating_synthetic_cohorts.Rmd)

`a02_Creating_synthetic_cohorts.Rmd`
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))

Here we explain making a mock cohort table using mockCohort(). mockCohort() is designed to generate synthetic cohorts within a given CDM reference. It allows for the creation of multiple cohorts with specified names and the expected number of records per person. This can be useful for testing, simulations, or educational purposes where real patient data cannot be used.

The mockCohort() function has several different arguments to help user to tailored the synthetic cohort creation process. The cdm argument represents the local CDM reference into which the synthetic cohort will be integrated. The tableName argument specifies the name of the table within the CDM to store the cohort data. For scenarios necessitating multiple cohorts, the numberCohorts argument determines how many distinct cohorts to generate within the table, defaulting to 1. The cohortName argument allows for the assignment of names to the created cohorts, supporting either a single name or a vector of names for multiple cohorts. Additionally, the recordPerson argument indicates the expected number of records per person in each cohort. Lastly, the seed argument is used to set a random seed, ensuring the reproducibility of the generated data.

**Example**

The example provided in the vignette demonstrates how to use the mockCohort function within a pipeline that includes generating a mock CDM reference, adding mock persons, and observation periods before finally adding the mock cohorts. This showcases a typical workflow for setting up a synthetic CDM with multiple components for testing or analysis.
    
    
    cdm <- [mockCdmReference](../reference/mockCdmReference.html)() |>
      [mockPerson](../reference/mockPerson.html)(nPerson = 100) |>
      [mockObservationPeriod](../reference/mockObservationPeriod.html)() |>
      [mockCohort](../reference/mockCohort.html)(
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

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
