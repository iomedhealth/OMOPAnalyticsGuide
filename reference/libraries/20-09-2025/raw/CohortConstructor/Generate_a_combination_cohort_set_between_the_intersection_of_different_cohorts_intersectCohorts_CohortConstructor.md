# Generate a combination cohort set between the intersection of different cohorts. — intersectCohorts • CohortConstructor

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

# Generate a combination cohort set between the intersection of different cohorts.

Source: [`R/intersectCohorts.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/intersectCohorts.R)

`intersectCohorts.Rd`

`intersectCohorts()` combines different cohort entries, with those records that overlap combined and kept. Cohort entries are when an individual was in _both_ of the cohorts.

## Usage
    
    
    intersectCohorts(
      cohort,
      cohortId = NULL,
      gap = 0,
      returnNonOverlappingCohorts = FALSE,
      keepOriginalCohorts = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

cohortId
    

Vector identifying which cohorts to include (cohort_definition_id or cohort_name). Cohorts not included will be removed from the cohort set.

gap
    

Number of days between two subsequent cohort entries to be merged in a single cohort record.

returnNonOverlappingCohorts
    

Whether the generated cohorts are mutually exclusive or not.

keepOriginalCohorts
    

If TRUE the original cohorts will be return together with the new ones. If FALSE only the new cohort will be returned.

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
    
    cdm$cohort3 <- intersectCohorts(
      cohort = cdm$cohort2,
      name = "cohort3",
    )
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort3)
    #> # A tibble: 1 × 5
    #>   cohort_definition_id cohort_name         gap cohort_1 cohort_2
    #>                  <int> <chr>             <dbl>    <dbl>    <dbl>
    #> 1                    1 cohort_1_cohort_2     0        1        1
    
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
