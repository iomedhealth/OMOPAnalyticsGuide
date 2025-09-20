# Get codelist from a cohort_table object. — cohortCodelist • omopgenerics

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get codelist from a cohort_table object.

Source: [`R/cohortCodelist.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/cohortCodelist.R)

`cohortCodelist.Rd`

Get codelist from a cohort_table object.

## Usage
    
    
    cohortCodelist(
      cohortTable,
      cohortId,
      codelistType = [c](https://rdrr.io/r/base/c.html)("index event", "inclusion criteria", "exit criteria"),
      type = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)()
    )

## Arguments

cohortTable
    

A cohort_table object.

cohortId
    

A particular cohort definition id that is present in the cohort table.

codelistType
    

The reason for the codelist. Can be "index event", "inclusion criteria", or "exit criteria".

type
    

deprecated.

## Value

A table with the codelists used.

## Examples
    
    
     # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    person <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = 1, person_id = 1,
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
      period_type_concept_id = 0
    )
    cohort <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = [c](https://rdrr.io/r/base/c.html)(1, 1, 1, 2),
      subject_id = 1,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)(
        "2020-01-01", "2021-01-01", "2022-01-01", "2022-01-01"
      )),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)(
        "2020-01-01", "2021-01-01", "2022-01-01", "2022-01-01"
      ))
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)("person" = person, "observation_period" = observation_period),
      cdmName = "my_example_cdm",
      cohortTables = [list](https://rdrr.io/r/base/list.html)("cohort1" = cohort)
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 3 casted column in observation_period as do not match expected column type:
    #> • `observation_period_id` from numeric to integer
    #> • `person_id` from numeric to integer
    #> • `period_type_concept_id` from numeric to integer
    #> Warning: ! 2 casted column in cohort1 as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> • `subject_id` from numeric to integer
    cdm$cohort1 <- [newCohortTable](newCohortTable.html)(table = cdm$cohort1,
                                    cohortCodelistRef = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
                                    cohort_definition_id = [c](https://rdrr.io/r/base/c.html)(1,1,1,2,2),
                                    codelist_name =[c](https://rdrr.io/r/base/c.html)("disease X", "disease X", "disease X",
                                                     "disease Y", "disease Y"),
                                    concept_id = [c](https://rdrr.io/r/base/c.html)(1,2,3,4,5),
                                    codelist_type = "index event"
                                  ))
    cohortCodelist(cdm$cohort1, cohortId = 1, codelistType = "index event")
    #> Warning: ! `codelist` casted to integers.
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - disease X (3 codes)
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
