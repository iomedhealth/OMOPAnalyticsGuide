# Building a bespoke mock cdm • omock

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

# Building a bespoke mock cdm

Source: [`vignettes/a04_Building_a_bespoke_mock_cdm.Rmd`](https://github.com/ohdsi/omock/blob/main/vignettes/a04_Building_a_bespoke_mock_cdm.Rmd)

`a04_Building_a_bespoke_mock_cdm.Rmd`
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([lubridate](https://lubridate.tidyverse.org))

There are times where the user will want to create a mock CDM reference from its own bespoke tables. The mockCdmFromTables() function is designed to facilitates the creation of mock CDM reference from bespoke tables.For example if you want to create a CDM reference based on below bespoke cohorts. You can do it simple using the mockCdmFromTable() functions in a few lines of code.
    
    
    # Define a list of user-defined cohort tables
    cohortTables <- [list](https://rdrr.io/r/base/list.html)(
      cohort1 = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        subject_id = 1:10,
        cohort_definition_id = [rep](https://rdrr.io/r/base/rep.html)(1, 10),
        cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-01") + 1:10,
        cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-01") + 11:20
      ),
      cohort2 = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        subject_id = 11:20,
        cohort_definition_id = [rep](https://rdrr.io/r/base/rep.html)(2, 10),
        cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-02-01") + 1:10,
        cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-02-01") + 11:20
      )
    )
    
    # Create a mock CDM object from the user-defined tables
    cdm <- [mockCdmReference](../reference/mockCdmReference.html)() |> [mockCdmFromTables](../reference/mockCdmFromTables.html)(tables = cohortTables)
    
    cdm |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> A cdm reference of mock database with 11 tables: person, observation_period, cdm_source, concept, vocabulary, concept_relationship, concept_synonym, concept_ancestor, drug_strength, cohort1, and cohort2.

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
