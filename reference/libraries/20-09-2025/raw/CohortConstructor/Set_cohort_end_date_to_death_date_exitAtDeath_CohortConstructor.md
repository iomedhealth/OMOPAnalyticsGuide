# Set cohort end date to death date — exitAtDeath • CohortConstructor

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

# Set cohort end date to death date

Source: [`R/exitAtDate.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/exitAtDate.R)

`exitAtDeath.Rd`

This functions changes cohort end date to subject's death date. In the case were this generates overlapping records in the cohort, those overlapping entries will be merged.

## Usage
    
    
    exitAtDeath(
      cohort,
      cohortId = NULL,
      requireDeath = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

requireDeath
    

If TRUE, subjects without a death record will be dropped, while if FALSE their end date will be left as is.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

The cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockPatientProfiles](https://darwin-eu.github.io/PatientProfiles/reference/mockPatientProfiles.html)()
    cdm$cohort1 |> exitAtDeath()
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          2 2003-03-30        2004-12-31     
    #>  2                    3          8 1979-07-30        1982-04-14     
    #>  3                    2          1 1964-06-25        1973-07-25     
    #>  4                    3          9 1963-01-28        1964-08-25     
    #>  5                    1          3 1917-08-29        1948-04-14     
    #>  6                    2          4 1940-10-28        1977-03-08     
    #>  7                    3         10 1980-03-04        1980-11-09     
    #>  8                    2          6 1990-07-28        2005-06-20     
    #>  9                    3          7 1926-02-15        1926-07-26     
    #> 10                    1          5 1968-12-02        1972-12-04     
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
