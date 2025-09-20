# Update cohort start date to be the first date from of a set of column dates — entryAtFirstDate • CohortConstructor

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

# Update cohort start date to be the first date from of a set of column dates

Source: [`R/entryAtColumnDate.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/entryAtColumnDate.R)

`entryAtFirstDate.Rd`

`entryAtFirstDate()` resets cohort start date based on a set of specified column dates. The first date that occurs is chosen.

## Usage
    
    
    entryAtFirstDate(
      cohort,
      dateColumns,
      cohortId = NULL,
      returnReason = FALSE,
      keepDateColumns = TRUE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

dateColumns
    

Character vector indicating date columns in the cohort table to consider.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

returnReason
    

If TRUE it will return a column indicating which of the `dateColumns` was used.

keepDateColumns
    

If TRUE the returned cohort will keep columns in `dateColumns`.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

The cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(tables = [list](https://rdrr.io/r/base/list.html)(
    "cohort" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1,
      subject_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3, 4),
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2000-06-03", "2000-01-01", "2015-01-15", "2000-12-09")),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2001-09-01", "2001-01-12", "2015-02-15", "2002-12-09")),
      date_1 = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2001-08-01", "2001-01-01", "2015-01-15", "2002-12-09")),
      date_2 = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2001-08-01", NA, "2015-02-14", "2002-12-09"))
    )
    ))
    cdm$cohort |> [entryAtLastDate](entryAtLastDate.html)(dateColumns = [c](https://rdrr.io/r/base/c.html)("date_1", "date_2"))
    #> Joining with `by = join_by(cohort_definition_id, subject_id, cohort_end_date)`
    #> # Source:   table<cohort> [?? x 6]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date date_1    
    #>                  <int>      <int> <date>            <date>          <date>    
    #> 1                    1          1 2001-08-01        2001-09-01      2001-08-01
    #> 2                    1          2 2001-01-01        2001-01-12      2001-01-01
    #> 3                    1          3 2015-02-14        2015-02-15      2015-01-15
    #> 4                    1          4 2002-12-09        2002-12-09      2002-12-09
    #> # ℹ 1 more variable: date_2 <date>
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
