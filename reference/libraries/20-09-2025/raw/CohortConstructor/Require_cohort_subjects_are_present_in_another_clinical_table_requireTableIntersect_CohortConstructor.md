# Require cohort subjects are present in another clinical table — requireTableIntersect • CohortConstructor

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

# Require cohort subjects are present in another clinical table

Source: [`R/requireTableIntersect.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireTableIntersect.R)

`requireTableIntersect.Rd`

`requireTableIntersect()` filters a cohort table based on a requirement that an individual is seen (or not seen) to have a record (or no records) in a clinical table in some time window around an index date.

## Usage
    
    
    requireTableIntersect(
      cohort,
      tableName,
      window,
      intersections = [c](https://rdrr.io/r/base/c.html)(1, Inf),
      cohortId = NULL,
      indexDate = "cohort_start_date",
      targetStartDate = [startDateColumn](https://darwin-eu.github.io/PatientProfiles/reference/startDateColumn.html)(tableName),
      targetEndDate = [endDateColumn](https://darwin-eu.github.io/PatientProfiles/reference/endDateColumn.html)(tableName),
      inObservation = TRUE,
      censorDate = NULL,
      atFirst = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

tableName
    

Name of the table to check for intersect.

window
    

A list of vectors specifying minimum and maximum days from `indexDate` to consider events over.

intersections
    

A range indicating number of intersections for criteria to be fulfilled. If a single number is passed, the number of intersections must match this.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

indexDate
    

Name of the column in the cohort that contains the date to compute the intersection.

targetStartDate
    

Start date of reference in cohort table.

targetEndDate
    

End date of reference in cohort table. If NULL, incidence of target event in the window will be considered as intersection, otherwise prevalence of that event will be used as intersection (overlap between cohort and event).

inObservation
    

If TRUE only records inside an observation period will be considered

censorDate
    

Whether to censor overlap events at a specific date or a column date of the cohort.

atFirst
    

If FALSE the requirement will be applied to all records, if TRUE, it will only be required for the first entry of each subject.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

Cohort table

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(drugExposure = TRUE)
    cdm$cohort1 |>
      requireTableIntersect(tableName = "drug_exposure",
                                indexDate = "cohort_start_date",
                                window = [c](https://rdrr.io/r/base/c.html)(-Inf, 0))
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          2 2010-03-30        2010-04-20     
    #>  2                    1          3 2005-09-25        2007-04-24     
    #>  3                    1          3 2007-04-25        2007-07-09     
    #>  4                    1          3 2007-07-10        2007-11-24     
    #>  5                    1          4 2017-05-07        2017-07-06     
    #>  6                    1          5 2016-08-28        2016-10-13     
    #>  7                    1          5 2016-11-01        2016-12-06     
    #>  8                    1          6 1994-11-23        2001-04-26     
    #>  9                    1          6 2014-10-27        2014-12-11     
    #> 10                    1          9 2007-03-19        2007-09-15     
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
