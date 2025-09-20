# Require cohort subjects to have (or not have) events of a concept list — requireConceptIntersect • CohortConstructor

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

# Require cohort subjects to have (or not have) events of a concept list

Source: [`R/requireConceptIntersect.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireConceptIntersect.R)

`requireConceptIntersect.Rd`

`requireConceptIntersect()` filters a cohort table based on a requirement that an individual is seen (or not seen) to have events related to a concept list in some time window around an index date.

## Usage
    
    
    requireConceptIntersect(
      cohort,
      conceptSet,
      window,
      intersections = [c](https://rdrr.io/r/base/c.html)(1, Inf),
      cohortId = NULL,
      indexDate = "cohort_start_date",
      targetStartDate = "event_start_date",
      targetEndDate = "event_end_date",
      inObservation = TRUE,
      censorDate = NULL,
      atFirst = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

conceptSet
    

A conceptSet, which can either be a codelist or a conceptSetExpression.

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
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(conditionOccurrence = TRUE)
    cdm$cohort2 <-  requireConceptIntersect(
      cohort = cdm$cohort1,
      conceptSet = [list](https://rdrr.io/r/base/list.html)(a = 194152),
      window = [c](https://rdrr.io/r/base/c.html)(-Inf, 0),
      name = "cohort2")
    #> Warning: ! `codelist` casted to integers.
      # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
