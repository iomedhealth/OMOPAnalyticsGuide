# Combining Cohorts • CohortConstructor

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

# Combining Cohorts

Source: [`vignettes/a09_combine_cohorts.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a09_combine_cohorts.Rmd)

`a09_combine_cohorts.Rmd`
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))

For this example we’ll use the Eunomia synthetic data from the CDMConnector package.
    
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", 
                        writeSchema = [c](https://rdrr.io/r/base/c.html)(prefix = "my_study_", schema = "main"))

Let’s start by creating two drug cohorts, one for users of diclofenac and another for users of acetaminophen.
    
    
    cdm$medications <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = [list](https://rdrr.io/r/base/list.html)("diclofenac" = 1124300,
                                                       "acetaminophen" = 1127433), 
                                     name = "medications")
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications)
    #> # A tibble: 2 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           9365            2580
    #> 2                    2            830             830

To check whether there is an overlap between records in both cohorts using the function `[intersectCohorts()](../reference/intersectCohorts.html)`.
    
    
    cdm$medintersect <- [intersectCohorts](../reference/intersectCohorts.html)(
      cohort = cdm$medications,
      name = "medintersect"
    )
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medintersect)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1              6               6

There are 6 individuals who had overlapping records in the diclofenac and acetaminophen cohorts.

We can choose the number of days between cohort entries using the `gap` argument.
    
    
    cdm$medintersect <- [intersectCohorts](../reference/intersectCohorts.html)(
      cohort = cdm$medications,
      gap = 365,
      name = "medintersect"
    )
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medintersect)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1             94              94

There are 94 individuals who had overlapping records (within 365 days) in the diclofenac and acetaminophen cohorts.

We can also combine different cohorts using the function `[unionCohorts()](../reference/unionCohorts.html)`.
    
    
    cdm$medunion <- [unionCohorts](../reference/unionCohorts.html)(
      cohort = cdm$medications,
      name = "medunion"
    )
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medunion)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1          10189            2605

We have now created a new cohort which includes individuals in either the diclofenac cohort or the acetaminophen cohort.

You can keep the original cohorts in the new table if you use the argument `keepOriginalCohorts = TRUE`.
    
    
    cdm$medunion <- [unionCohorts](../reference/unionCohorts.html)(
      cohort = cdm$medications,
      name = "medunion",
      keepOriginalCohorts = TRUE
    )
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medunion)
    #> # A tibble: 3 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           9365            2580
    #> 2                    2            830             830
    #> 3                    3          10189            2605

You can also choose the number of days between two subsequent cohort entries to be merged using the `gap` argument.
    
    
    cdm$medunion <- [unionCohorts](../reference/unionCohorts.html)(
      cohort = cdm$medications,
      name = "medunion",
      gap = 365,
      keepOriginalCohorts = TRUE
    )
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medunion)
    #> # A tibble: 3 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           9365            2580
    #> 2                    2            830             830
    #> 3                    3           9682            2605

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
