# Filter cohorts to keep only records for those with a minimum amount of subjects — requireMinCohortCount • CohortConstructor

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

# Filter cohorts to keep only records for those with a minimum amount of subjects

Source: [`R/requireMinCohortCount.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireMinCohortCount.R)

`requireMinCohortCount.Rd`

`requireMinCohortCount()` filters an existing cohort table, keeping only records from cohorts with a minimum number of individuals

## Usage
    
    
    requireMinCohortCount(
      cohort,
      minCohortCount,
      cohortId = NULL,
      updateSettings = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort)
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

minCohortCount
    

The minimum count of sbjects for a cohort to be included.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

updateSettings
    

If TRUE, dropped cohorts will also be removed from all cohort table attributes (i.e., settings, attrition, counts, and codelist). If FALSE, these attributes will be retained but updated to reflect that the affected cohorts have been suppressed.

name
    

Name of the new cohort table created in the cdm object.

## Value

Cohort table

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(nPerson = 100)
    
    cdm$cohort1 |>
    requireMinCohortCount(5)
    #> Warning: There was 1 warning in `dplyr::filter()`.
    #> ℹ In argument: `.data$reason_id %in% max(.data$reason_id)`.
    #> Caused by warning in `max()`:
    #> ! no non-missing arguments to max; returning -Inf
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          4 2019-06-09        2019-08-31     
    #>  2                    1          6 1983-03-10        1996-03-21     
    #>  3                    1          7 2013-03-03        2014-09-18     
    #>  4                    1          7 2014-09-19        2014-12-14     
    #>  5                    1          7 2015-04-04        2018-01-18     
    #>  6                    1          8 2013-12-19        2016-08-09     
    #>  7                    1          9 2005-11-05        2005-11-06     
    #>  8                    1          9 2005-11-07        2006-07-18     
    #>  9                    1          9 2006-07-19        2010-07-28     
    #> 10                    1         12 2003-02-09        2007-02-05     
    #> # ℹ more rows
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
