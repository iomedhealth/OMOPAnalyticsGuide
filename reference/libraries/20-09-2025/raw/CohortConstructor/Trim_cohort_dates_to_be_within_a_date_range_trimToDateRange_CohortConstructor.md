# Trim cohort dates to be within a date range — trimToDateRange • CohortConstructor

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

# Trim cohort dates to be within a date range

Source: [`R/requireDateRange.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireDateRange.R)

`trimToDateRange.Rd`

`trimToDateRange()` resets the cohort start and end date based on the specified date range.

## Usage
    
    
    trimToDateRange(
      cohort,
      dateRange,
      cohortId = NULL,
      startDate = "cohort_start_date",
      endDate = "cohort_end_date",
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

dateRange
    

A window of time during which the start and end date must have been observed.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

startDate
    

Variable with earliest date.

endDate
    

Variable with latest date.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

The cohort table with record timings updated to only be within the date range. Any records with all time outside of the range will have been dropped.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    cdm$cohort1 |>
      trimToDateRange(startDate = "cohort_start_date",
                      endDate = "cohort_end_date",
                      dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2015-01-01",
                                            "2015-12-31")))
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #> # ℹ 4 variables: cohort_definition_id <int>, subject_id <int>,
    #> #   cohort_start_date <date>, cohort_end_date <date>
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
