# Set cohort start or cohort end — padCohortDate • CohortConstructor

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

# Set cohort start or cohort end

Source: [`R/padCohortDate.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/padCohortDate.R)

`padCohortDate.Rd`

Set cohort start or cohort end

## Usage
    
    
    padCohortDate(
      cohort,
      days,
      cohortDate = "cohort_start_date",
      indexDate = "cohort_start_date",
      collapse = TRUE,
      padObservation = TRUE,
      cohortId = NULL,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

days
    

Integer with the number of days to add or name of a column (that must be numeric) to add.

cohortDate
    

'cohort_start_date' or 'cohort_end_date'.

indexDate
    

Variable in cohort that contains the index date to add.

collapse
    

Whether to collapse the overlapping records (TRUE) or drop the records that have an ongoing prior record.

padObservation
    

Whether to pad observations if they are outside observation_period (TRUE) or drop the records if they are outside observation_period (FALSE)

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

Cohort table

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    cdm$cohort1 |>
      padCohortDate(
        cohortDate = "cohort_end_date",
        indexDate = "cohort_start_date",
        days = 10)
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          6 1994-11-23        1994-12-03     
    #>  2                    1          6 2014-10-27        2014-11-06     
    #>  3                    1          2 2010-03-30        2010-04-09     
    #>  4                    1          3 2007-04-25        2007-05-05     
    #>  5                    1          5 2016-08-28        2016-09-07     
    #>  6                    1          3 2005-09-25        2005-10-05     
    #>  7                    1          5 2016-11-01        2016-11-11     
    #>  8                    1          4 2017-05-07        2017-05-17     
    #>  9                    1          3 2007-07-10        2007-07-20     
    #> 10                    1          9 2007-03-19        2007-03-29     
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
