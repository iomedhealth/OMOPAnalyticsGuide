# Cohort tables • omopgenerics

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



# Cohort tables

Source: [`vignettes/cohorts.Rmd`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/vignettes/cohorts.Rmd)

`cohorts.Rmd`

## Cohort table

A cohort is a **set of people that fulfill a certain set of criteria for a period of time**.

In omopgenerics we defined the `cohort_table` class that allows us to represent individuals in a cohort.

A `cohort_table` is created using the `[newCohortTable()](../reference/newCohortTable.html)` function that is defined by:

  * A cohort table.

  * A cohort set.

  * A cohort attrition.




Let’s start by creating a cdm reference with just two people.
    
    
    person <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = [c](https://rdrr.io/r/base/c.html)(1, 2),
      gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = [c](https://rdrr.io/r/base/c.html)(1, 2), person_id = [c](https://rdrr.io/r/base/c.html)(1, 2),
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2021-12-31"),
      period_type_concept_id = 0
    )
    cdm <- [cdmFromTables](../reference/cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = person,
        "observation_period" = observation_period
      ),
      cdmName = "example_cdm"
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
    cdm
    #> 
    #> ── # OMOP CDM reference (local) of example_cdm ─────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -

Now let’s say one of these people have a clinical event of interest, we can include them in a cohort table which can then be used as part of an analysis.
    
    
    cohort <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1, subject_id = 1,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-01"),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-10")
    )
    cdm <- [insertTable](../reference/insertTable.html)(cdm = cdm, name = "cohort", table = cohort)
    cdm$cohort <- [newCohortTable](../reference/newCohortTable.html)(cdm$cohort)
    #> Warning: ! 2 casted column in cohort as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> • `subject_id` from numeric to integer

The cohort table will be associated with settings and attrition. As we didn’t specify these in newCohortTable() above they will have been automatically populated. You can access the cohort set of a cohort table using the function `[settings()](../reference/settings.html)`
    
    
    [settings](../reference/settings.html)(cdm$cohort)
    #> # A tibble: 1 × 2
    #>   cohort_definition_id cohort_name
    #>                  <int> <chr>      
    #> 1                    1 cohort_1

Meanwhile, you can access the cohort attrition of a cohort table using the function `[attrition()](../reference/attrition.html)`
    
    
    [attrition](../reference/attrition.html)(cdm$cohort)
    #> # A tibble: 1 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1              1               1         1 Initial qualify…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

Cohort attrition table is also used to compute the number of counts that each cohort (ie from the last row of the attrition). It can be seen with the function `[cohortCount()](../reference/cohortCount.html)`.
    
    
    [cohortCount](../reference/cohortCount.html)(cdm$cohort)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1              1               1

Note that because the cohort count is taken from the last row of attrition, if we make changes to a cohort we should then update attrition as we go. We can do this
    
    
    cdm$cohort <- cdm$cohort |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(cohort_start_date == [as.Date](https://rdrr.io/r/base/as.Date.html)("2019-01-01")) |>
      [compute](https://dplyr.tidyverse.org/reference/compute.html)(name = "cohort", temporary = FALSE) |>
      [recordCohortAttrition](../reference/recordCohortAttrition.html)("Require cohort start January 1st 2019")
    [attrition](../reference/attrition.html)(cdm$cohort)
    #> # A tibble: 2 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1              1               1         1 Initial qualify…
    #> 2                    1              0               0         2 Require cohort …
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    [cohortCount](../reference/cohortCount.html)(cdm$cohort)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1              0               0

An additional, optional, attribute keeps track of the concepts used to create the cohort. In this example we do not have a codelist associated with our cohort.
    
    
    [cohortCodelist](../reference/cohortCodelist.html)(cdm$cohort, cohortId = 1, type = "index event")
    #> Warning: The `type` argument of `cohortCodelist()` is deprecated as of omopgenerics
    #> 1.2.0.
    #> ℹ Please use the `codelistType` argument instead.
    #> This warning is displayed once every 8 hours.
    #> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
    #> generated.
    #> Warning: No codelists found for the specified cohorts
    #> 
    #> ── 0 codelists ─────────────────────────────────────────────────────────────────

We could though associate our cohort with a codelist
    
    
    cdm$cohort <- [newCohortTable](../reference/newCohortTable.html)(cdm$cohort,
      cohortCodelistRef = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        cohort_definition_id = [c](https://rdrr.io/r/base/c.html)(1, 1),
        codelist_name = [c](https://rdrr.io/r/base/c.html)("disease X", "disease X"),
        concept_id = [c](https://rdrr.io/r/base/c.html)(101, 102),
        type = "index event"
      )
    )
    [cohortCodelist](../reference/cohortCodelist.html)(cdm$cohort, cohortId = 1, type = "index event")
    #> Warning: ! `codelist` casted to integers.
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - disease X (2 codes)

Each one of the elements that define a cohort table have to fulfill certain criteria.

### Cohort Set

A cohort set must be a table with:

  * Lower case column names.

  * At least cohort_definition_id, cohort_name columns (`cohortColumns("cohort_set")`).

  * `cohort_name` it must contain unique cohort names (currently they are cased to snake case).

  * `cohort_definition_id` it must contain unique cohort ids, all the ids present in table must be present in the cohort set and the same ids must be present in cohort attrition.




### Cohort Attrition

A cohort attrition must be a table with:

  * Lower case column names.

  * At least cohort_definition_id, number_records, number_subjects, reason_id, reason, excluded_records, excluded_subjects columns (`cohortColumns("cohort_attrition")`).

  * `cohort_definition_id` it must contain cohort ids, all the ids present in table must be present in the cohort attrition and the same ids must be present in cohort set.

  * There must exist unique pairs of `cohort_definition_id` and `reason_id`.




### Cohort Codelist

A cohort codelist must be a table with:

  * Lower case column names.

  * At least cohort_definition_id, codelist_name, concept_id, codelist_type columns (`cohortColumns("cohort_codelist")`).

  * `cohort_definition_id` it must contain cohort ids, all the ids present in table must be present in the cohort attrition and the same ids must be present in cohort set.

  * `type` must be one of “index event”, “inclusion criteria”, and “exit criteria”




### Cohort Table

A cohort table must be a table with:

  * It comes from a cdm_reference (extracted via `cdm$cohort`).

  * It has the same source than this cdm_reference.

  * Lower case column names.

  * At least cohort_definition_id, subject_id, cohort_start_date, cohort_end_date columns (`cohortColumns("cohort")`).

  * There is no record with `NA` value in the required columns.

  * There is no record with `cohort_start_date` after `cohort_end_date`.

  * There is no overlap between records. A person can be in a cohort several times (several records with the same subject_id). But it can’t enter (cohort_start_date) the cohort again before leaving it (cohort_end_date). So an individual can’t be simultaneously more than once in the same cohort. This rule is applied at the cohort_definition_id level, so records with different cohort_definition_id can overlap.

  * All the time between cohort_start_date and cohort_end_date (both included) the individual must be in observation.




## Combining generated cohort sets

You can bind two cohort tables using the method `[bind()](../reference/bind.html)`. You can combine several cohort tables using this method. The only constrain is that cohort names must be unique across the different cohort tables. You have to provide a name for the new cohort table.
    
    
    asthma <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1, subject_id = 1,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-01"),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-10")
    )
    cdm <- [insertTable](../reference/insertTable.html)(cdm, name = "asthma", table = asthma)
    cdm$asthma <- [newCohortTable](../reference/newCohortTable.html)(cdm$asthma,
      cohortSetRef = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        cohort_definition_id = 1,
        cohort_name = "asthma"
      )
    )
    #> Warning: ! 2 casted column in asthma as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> • `subject_id` from numeric to integer
    
    copd <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1, subject_id = 2,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-01"),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-10")
    )
    cdm <- [insertTable](../reference/insertTable.html)(cdm, name = "copd", table = copd)
    cdm$copd <- [newCohortTable](../reference/newCohortTable.html)(cdm$copd,
      cohortSetRef = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        cohort_definition_id = 1,
        cohort_name = "copd"
      )
    )
    #> Warning: ! 2 casted column in copd as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> • `subject_id` from numeric to integer
    
    cdm <- [bind](../reference/bind.html)(cdm$asthma,
      cdm$copd,
      name = "exposures"
    )
    cdm$exposures
    #> # A tibble: 2 × 4
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #> *                <int>      <int> <date>            <date>         
    #> 1                    1          1 2020-01-01        2020-01-10     
    #> 2                    2          2 2020-01-01        2020-01-10
    
    [settings](../reference/settings.html)(cdm$exposures)
    #> # A tibble: 2 × 2
    #>   cohort_definition_id cohort_name
    #>                  <int> <chr>      
    #> 1                    1 asthma     
    #> 2                    2 copd
    [attrition](../reference/attrition.html)(cdm$exposures)
    #> # A tibble: 2 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1              1               1         1 Initial qualify…
    #> 2                    2              1               1         1 Initial qualify…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    [cohortCount](../reference/cohortCount.html)(cdm$exposures)
    #> # A tibble: 2 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1              1               1
    #> 2                    2              1               1

## Export metadata about a cohort table

You can export the metadata of a `cohort_table` using the function: `[summary()](https://rdrr.io/r/base/summary.html)`:
    
    
    [summary](https://rdrr.io/r/base/summary.html)(cdm$exposures) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> `cohort_definition_id` casted to character.
    #> `cohort_definition_id` casted to character.
    #> Rows: 12
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4
    #> $ cdm_name         <chr> "example_cdm", "example_cdm", "example_cdm", "example…
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "asthma", "asthma", "copd", "copd", "asthma", "asthma…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "reason",…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "Initial …
    #> $ variable_name    <chr> "number_records", "number_subjects", "number_records"…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    #> $ estimate_name    <chr> "count", "count", "count", "count", "count", "count",…
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "1", "1", "1", "1", "1", "1", "0", "0", "1", "1", "0"…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "reason_i…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "1", "1",…

This will provide a `summarised_result` object with the metadata of the cohort (cohort set, cohort counts and cohort attrition).

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
