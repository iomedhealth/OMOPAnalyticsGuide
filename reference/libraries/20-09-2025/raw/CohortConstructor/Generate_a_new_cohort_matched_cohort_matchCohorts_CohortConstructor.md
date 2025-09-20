# Generate a new cohort matched cohort — matchCohorts • CohortConstructor

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

# Generate a new cohort matched cohort

Source: [`R/matchCohorts.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/matchCohorts.R)

`matchCohorts.Rd`

`matchCohorts()` generate a new cohort matched to individuals in an existing cohort. Individuals can be matched based on year of birth and sex. Matching is done at the record level, so if individuals have multiple cohort entries they can be matched to different individuals for each of their records.

Two new cohorts will be created when matching. The first is those cohort entries which were matched ("_sampled" is added to the original cohort name for this cohort). The other is the matches found from the database population ("_matched" is added to the original cohort name for this cohort).

## Usage
    
    
    matchCohorts(
      cohort,
      cohortId = NULL,
      matchSex = TRUE,
      matchYearOfBirth = TRUE,
      ratio = 1,
      keepOriginalCohorts = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

cohortId
    

Vector identifying which cohorts to include (cohort_definition_id or cohort_name). Cohorts not included will be removed from the cohort set.

matchSex
    

Whether to match in sex.

matchYearOfBirth
    

Whether to match in year of birth.

ratio
    

Number of allowed matches per individual in the target cohort.

keepOriginalCohorts
    

If TRUE the original cohorts will be return together with the new ones. If FALSE only the new cohort will be returned.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

A cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    #> 
    #> Attaching package: ‘dplyr’
    #> The following objects are masked from ‘package:stats’:
    #> 
    #>     filter, lag
    #> The following objects are masked from ‘package:base’:
    #> 
    #>     intersect, setdiff, setequal, union
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(nPerson = 200)
    cdm$new_matched_cohort <- cdm$cohort2 |>
      matchCohorts(
        name = "new_matched_cohort",
        cohortId = 2,
        matchSex = TRUE,
        matchYearOfBirth = TRUE,
        ratio = 1)
    #> Starting matching
    #> ℹ Creating copy of target cohort.
    #> • 1 cohort to be matched.
    #> ℹ Creating controls cohorts.
    #> ℹ Excluding cases from controls
    #> • Matching by gender_concept_id and year_of_birth
    #> • Removing controls that were not in observation at index date
    #> • Excluding target records whose pair is not in observation
    #> • Adjusting ratio
    #> Binding cohorts
    #> ✔ Done
    cdm$new_matched_cohort
    #> # Source:   table<new_matched_cohort> [?? x 5]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date cluster_id
    #>                   <int>      <int> <date>            <date>               <dbl>
    #>  1                    1        120 1987-10-15        2000-11-18               6
    #>  2                    1         56 1996-06-26        2001-01-03              64
    #>  3                    1        103 2007-02-18        2009-10-14              17
    #>  4                    1         21 2015-11-07        2016-01-23              20
    #>  5                    1         62 2012-12-24        2014-11-08              38
    #>  6                    1        135 2009-03-10        2009-06-20              52
    #>  7                    1         84 2005-07-02        2005-08-31               1
    #>  8                    1         17 1987-06-26        1987-10-08               3
    #>  9                    1        108 1999-11-14        1999-11-23              12
    #> 10                    1         75 2015-10-20        2016-09-24             108
    #> # ℹ more rows
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
