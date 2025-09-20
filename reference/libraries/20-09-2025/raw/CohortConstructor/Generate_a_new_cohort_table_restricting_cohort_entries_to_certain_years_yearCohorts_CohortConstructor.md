# Generate a new cohort table restricting cohort entries to certain years — yearCohorts • CohortConstructor

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

# Generate a new cohort table restricting cohort entries to certain years

Source: [`R/yearCohorts.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/yearCohorts.R)

`yearCohorts.Rd`

`yearCohorts()` splits a cohort into multiple cohorts, one for each year.

## Usage
    
    
    yearCohorts(
      cohort,
      years,
      cohortId = NULL,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

years
    

Numeric vector of years to use to restrict observation to.

cohortId
    

Vector identifying which cohorts to include (cohort_definition_id or cohort_name). Cohorts not included will be removed from the cohort set.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

A cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(nPerson = 100)
    
    cdm$cohort1 <- cdm$cohort1 |> yearCohorts(years = 2000:2002)
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort1)
    #> # A tibble: 3 × 5
    #>   cohort_definition_id cohort_name   target_cohort_definition_id  year
    #>                  <int> <chr>                               <int> <int>
    #> 1                    1 cohort_1_2000                           1  2000
    #> 2                    2 cohort_1_2001                           1  2001
    #> 3                    3 cohort_1_2002                           1  2002
    #> # ℹ 1 more variable: target_cohort_name <chr>
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
