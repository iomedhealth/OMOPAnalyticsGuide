# Require that an index date is within a date range — requireInDateRange • CohortConstructor

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

# Require that an index date is within a date range

Source: [`R/requireDateRange.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireDateRange.R)

`requireInDateRange.Rd`

`requireInDateRange()` filters cohort records, keeping only those for which the index date is within the specified date range.

## Usage
    
    
    requireInDateRange(
      cohort,
      dateRange,
      cohortId = NULL,
      indexDate = "cohort_start_date",
      atFirst = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

dateRange
    

A date vector with the minimum and maximum dates between which the index date must have been observed.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

indexDate
    

Name of the column in the cohort that contains the date of interest.

atFirst
    

If FALSE the requirement will be applied to all records, if TRUE, it will only be required for the first entry of each subject.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

The cohort table with any cohort entries outside of the date range dropped

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(nPerson = 100)
    cdm$cohort1 |>
      requireInDateRange(indexDate = "cohort_start_date",
                         dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2010-01-01", "2019-01-01")))
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          7 2013-03-03        2014-09-18     
    #>  2                    1          7 2014-09-19        2014-12-14     
    #>  3                    1          7 2015-04-04        2018-01-18     
    #>  4                    1          8 2013-12-19        2016-08-09     
    #>  5                    1         14 2018-02-26        2018-03-03     
    #>  6                    1         16 2016-10-31        2016-11-22     
    #>  7                    1         21 2015-11-25        2016-07-31     
    #>  8                    1         25 2012-10-25        2013-11-11     
    #>  9                    1         25 2013-11-12        2014-03-03     
    #> 10                    1         25 2014-03-04        2014-07-26     
    #> # ℹ more rows
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
