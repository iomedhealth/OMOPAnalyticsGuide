# Sample a cohort table for a given number of individuals. — sampleCohorts • CohortConstructor

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

# Sample a cohort table for a given number of individuals.

Source: [`R/sampleCohorts.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/sampleCohorts.R)

`sampleCohorts.Rd`

`sampleCohorts()` samples an existing cohort table for a given number of people. All records of these individuals are preserved.

## Usage
    
    
    sampleCohorts(cohort, n, cohortId = NULL, name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort))

## Arguments

cohort
    

A cohort table in a cdm reference.

n
    

Number of people to be sampled for each included cohort.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

name
    

Name of the new cohort table created in the cdm object.

## Value

Cohort table with the specified cohorts sampled.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(nPerson = 100)
    
    cdm$cohort2 |> sampleCohorts(cohortId = 1, n = 10)
    #> # Source:   table<cohort2> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1         13 2000-09-24        2000-10-18     
    #>  2                    1         13 2001-01-18        2001-01-20     
    #>  3                    1         15 1988-05-09        2003-06-21     
    #>  4                    1         22 2007-12-28        2009-12-01     
    #>  5                    1         26 2015-03-24        2019-03-08     
    #>  6                    1         34 2017-07-18        2017-12-07     
    #>  7                    1         34 2017-12-08        2018-02-26     
    #>  8                    1         37 2017-03-27        2018-07-25     
    #>  9                    1         60 1988-03-15        1988-06-05     
    #> 10                    1         60 1988-06-06        1991-10-20     
    #> # ℹ more rows
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
