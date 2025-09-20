# Generating a matched cohort • CohortConstructor

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

# Generating a matched cohort

Source: [`vignettes/a10_match_cohorts.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a10_match_cohorts.Rmd)

`a10_match_cohorts.Rmd`

## Introduction

CohortConstructor packages includes a function to obtain an age and sex matched cohort, the `[matchCohorts()](../reference/matchCohorts.html)` function. In this vignette, we will explore the usage of this function.

### Create mock data

We will first use `mockDrugUtilisation()` function from DrugUtilisation package to create mock data.
    
    
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    cdm <- [mockCohortConstructor](../reference/mockCohortConstructor.html)(nPerson = 1000)

As we will use `cohort1` to explore `[matchCohorts()](../reference/matchCohorts.html)`, let us first use `[settings()](https://darwin-eu.github.io/omopgenerics/reference/settings.html)` from omopgenerics package to explore this cohort:
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort1)

## Use matchCohorts() to create an age-sex matched cohort

Let us first see an example of how this function works. For its usage, we need to provide a `cdm` object, the `targetCohortName`, which is the name of the table containing the cohort of interest, and the `name` of the new generated tibble containing the cohort and the matched cohort. We will also use the argument `targetCohortId` to specify that we only want a matched cohort for `cohort_definition_id = 1`.
    
    
    cdm$matched_cohort1 <- [matchCohorts](../reference/matchCohorts.html)(
      cohort = cdm$cohort1,
      cohortId = 1,
      name = "matched_cohort1")
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$matched_cohort1)

Notice that in the generated tibble, there are two cohorts: `cohort_definition_id = 1` (original cohort), and `cohort_definition_id = 4` (matched cohort). _target_cohort_name_ column indicates which is the original cohort. _match_sex_ and _match_year_of_birth_ adopt boolean values (`TRUE`/`FALSE`) indicating if we have matched for sex and age, or not. _match_status_ indicate if it is the original cohort (`target`) or if it is the matched cohort (`matched`). _target_cohort_id_ indicates which is the cohort_id of the original cohort.

Check the exclusion criteria applied to generate the new cohorts by using `[attrition()](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)` from omopgenerics package:
    
    
    # Original cohort
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$matched_cohort1) |> [filter](https://dplyr.tidyverse.org/reference/filter.html)(cohort_definition_id == 1)
    
    # Matched cohort
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$matched_cohort1) |> [filter](https://dplyr.tidyverse.org/reference/filter.html)(cohort_definition_id == 4)

Briefly, from the original cohort, we exclude first those individuals that do not have a match, and then individuals that their matching pair is not in observation during the assigned _cohort_start_date_. From the matched cohort, we start from the whole database and we first exclude individuals that are in the original cohort. Afterwards, we exclude individuals that do not have a match, then individuals that are not in observation during the assigned _cohort_start_date_ , and finally we remove as many individuals as required to fulfill the ratio.

Notice that matching pairs are randomly assigned, so it is probable that every time you execute this function, the generated cohorts change. Use `[set.seed()](https://rdrr.io/r/base/Random.html)` to avoid this.

### matchSex parameter

`matchSex` is a boolean parameter (`TRUE`/`FALSE`) indicating if we want to match by sex (`TRUE`) or we do not want to (`FALSE`).

### matchYear parameter

`matchYear` is another boolean parameter (`TRUE`/`FALSE`) indicating if we want to match by age (`TRUE`) or we do not want (`FALSE`).

Notice that if `matchSex = FALSE` and `matchYear = FALSE`, we will obtain an unmatched comparator cohort.

### ratio parameter

The default matching ratio is 1:1 (`ratio = 1`). Use `[cohortCount()](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)` from CDMConnector to check if the matching has been done as desired.
    
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$matched_cohort1)

You can modify the `ratio` parameter to tailor your matched cohort. `ratio` can adopt values from 1 to Inf.
    
    
    cdm$matched_cohort2 <- [matchCohorts](../reference/matchCohorts.html)(
      cohort = cdm$cohort1,
      cohortId = 1,
      name = "matched_cohort2",
      ratio = Inf)
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$matched_cohort2)

### Generate matched cohorts simultaneously across multiple cohorts

All these functionalities can be implemented across multiple cohorts simultaneously. Specify in `targetCohortId` parameter which are the cohorts of interest. If set to NULL, all the cohorts present in `targetCohortName` will be matched.
    
    
    cdm$matched_cohort3 <- [matchCohorts](../reference/matchCohorts.html)(
      cohort = cdm$cohort1,
      cohortId = [c](https://rdrr.io/r/base/c.html)(1,3),
      name = "matched_cohort3",
      ratio = 2)
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$matched_cohort3) |> [arrange](https://dplyr.tidyverse.org/reference/arrange.html)(cohort_definition_id)
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$matched_cohort3) |> [arrange](https://dplyr.tidyverse.org/reference/arrange.html)(cohort_definition_id)

Notice that each cohort has their own (and independent of other cohorts) matched cohort.

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
