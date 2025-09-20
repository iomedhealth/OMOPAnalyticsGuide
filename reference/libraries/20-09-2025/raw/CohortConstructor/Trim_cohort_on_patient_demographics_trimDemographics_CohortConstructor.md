# Trim cohort on patient demographics — trimDemographics • CohortConstructor

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

# Trim cohort on patient demographics

Source: [`R/trimDemographics.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/trimDemographics.R)

`trimDemographics.Rd`

`trimDemographics()` resets the cohort start and end date based on the specified demographic criteria is satisfied.

## Usage
    
    
    trimDemographics(
      cohort,
      cohortId = NULL,
      ageRange = NULL,
      sex = NULL,
      minPriorObservation = NULL,
      minFutureObservation = NULL,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

ageRange
    

A list of vectors specifying minimum and maximum age.

sex
    

Can be "Both", "Male" or "Female".

minPriorObservation
    

A minimum number of continuous prior observation days in the database.

minFutureObservation
    

A minimum number of continuous future observation days in the database.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

The cohort table with only records for individuals satisfying the demographic requirements

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(nPerson = 100)
    
    cdm$cohort1 |> trimDemographics(ageRange = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(10, 30)))
    #> ℹ Building new trimmed cohort
    #> Adding demographics information
    #> Creating initial cohort
    #> Trim age
    #> ✔ Cohort trimmed
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          6 1983-03-10        1996-03-21     
    #>  2                    1         22 2007-12-28        2008-05-08     
    #>  3                    1         43 1996-10-05        1996-11-09     
    #>  4                    1         46 1985-04-02        1988-11-03     
    #>  5                    1         51 1986-08-18        1991-12-26     
    #>  6                    1         54 1981-02-26        1982-04-20     
    #>  7                    1         64 1991-08-19        1994-10-14     
    #>  8                    1         74 2010-12-06        2011-10-08     
    #>  9                    1         78 2012-05-28        2014-05-09     
    #> 10                    1         43 1996-09-18        1996-09-19     
    #> # ℹ more rows
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
