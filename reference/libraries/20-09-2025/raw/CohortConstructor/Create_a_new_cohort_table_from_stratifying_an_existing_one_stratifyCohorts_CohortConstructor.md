# Create a new cohort table from stratifying an existing one — stratifyCohorts • CohortConstructor

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

# Create a new cohort table from stratifying an existing one

Source: [`R/stratifyCohorts.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/stratifyCohorts.R)

`stratifyCohorts.Rd`

`stratifyCohorts()` creates new cohorts, splitting an existing cohort based on specified columns on which to stratify on.

## Usage
    
    
    stratifyCohorts(
      cohort,
      strata,
      cohortId = NULL,
      removeStrata = TRUE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

strata
    

A strata list that point to columns in cohort table.

cohortId
    

Vector identifying which cohorts to include (cohort_definition_id or cohort_name). Cohorts not included will be removed from the cohort set.

removeStrata
    

Whether to remove strata columns from final cohort table.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

Cohort table stratified.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    
    cdm$my_cohort <- cdm$cohort1 |>
      [addAge](https://darwin-eu.github.io/PatientProfiles/reference/addAge.html)(ageGroup = [list](https://rdrr.io/r/base/list.html)("child" = [c](https://rdrr.io/r/base/c.html)(0, 17), "adult" = [c](https://rdrr.io/r/base/c.html)(18, Inf))) |>
      [addSex](https://darwin-eu.github.io/PatientProfiles/reference/addSex.html)(name = "my_cohort") |>
      stratifyCohorts(
        strata = [list](https://rdrr.io/r/base/list.html)("sex", [c](https://rdrr.io/r/base/c.html)("sex", "age_group")), name = "my_cohort"
      )
    
    cdm$my_cohort
    #> # Source:   table<my_cohort> [?? x 5]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date   age
    #>                   <int>      <int> <date>            <date>          <int>
    #>  1                    1          2 2010-03-30        2010-04-20         55
    #>  2                    1          3 2005-09-25        2007-04-24         46
    #>  3                    1          3 2007-04-25        2007-07-09         48
    #>  4                    1          3 2007-07-10        2007-11-24         48
    #>  5                    1          4 2017-05-07        2017-07-06         35
    #>  6                    1          5 2016-08-28        2016-10-13         53
    #>  7                    1          5 2016-11-01        2016-12-06         53
    #>  8                    2          6 1994-11-23        2001-04-26         26
    #>  9                    2          6 2014-10-27        2014-12-11         46
    #> 10                    1          9 2007-03-19        2007-09-15         22
    #> 11                    3          2 2010-03-30        2010-04-20         55
    #> 12                    3          3 2005-09-25        2007-04-24         46
    #> 13                    3          3 2007-04-25        2007-07-09         48
    #> 14                    3          3 2007-07-10        2007-11-24         48
    #> 15                    3          4 2017-05-07        2017-07-06         35
    #> 16                    3          5 2016-08-28        2016-10-13         53
    #> 17                    3          5 2016-11-01        2016-12-06         53
    #> 18                    4          6 1994-11-23        2001-04-26         26
    #> 19                    4          6 2014-10-27        2014-12-11         46
    #> 20                    3          9 2007-03-19        2007-09-15         22
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$my_cohort)
    #> # A tibble: 4 × 8
    #>   cohort_definition_id cohort_name           target_cohort_id target_cohort_name
    #>                  <int> <chr>                            <int> <chr>             
    #> 1                    1 cohort_1_female                      1 cohort_1          
    #> 2                    2 cohort_1_male                        1 cohort_1          
    #> 3                    3 cohort_1_female_adult                1 cohort_1          
    #> 4                    4 cohort_1_male_adult                  1 cohort_1          
    #> # ℹ 4 more variables: target_cohort_table_name <chr>, strata_columns <chr>,
    #> #   sex <chr>, age_group <chr>
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$my_cohort)
    #> # A tibble: 10 × 7
    #>    cohort_definition_id number_records number_subjects reason_id reason         
    #>                   <int>          <int>           <int>     <int> <chr>          
    #>  1                    1             10               6         1 Initial qualif…
    #>  2                    1              8               5         2 filter strata:…
    #>  3                    2             10               6         1 Initial qualif…
    #>  4                    2              2               1         2 filter strata:…
    #>  5                    3             10               6         1 Initial qualif…
    #>  6                    3              8               5         2 filter strata:…
    #>  7                    3              8               5         3 filter strata:…
    #>  8                    4             10               6         1 Initial qualif…
    #>  9                    4              2               1         2 filter strata:…
    #> 10                    4              2               1         3 filter strata:…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
