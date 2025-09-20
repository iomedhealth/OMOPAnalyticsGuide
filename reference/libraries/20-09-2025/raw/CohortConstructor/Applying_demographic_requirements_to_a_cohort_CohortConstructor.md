# Applying demographic requirements to a cohort • CohortConstructor

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

# Applying demographic requirements to a cohort

Source: [`vignettes/a03_require_demographics.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a03_require_demographics.Rmd)

`a03_require_demographics.Rmd`
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    #> 
    #> Attaching package: 'dplyr'
    #> The following objects are masked from 'package:stats':
    #> 
    #>     filter, lag
    #> The following objects are masked from 'package:base':
    #> 
    #>     intersect, setdiff, setequal, union
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))

In this vignette we’ll show how requirements related to patient demographics can be applied to a cohort. Again we’ll use the Eunomia synthetic data.
    
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", 
                        writeSchema = "main", writePrefix = "my_study_")

Let’s start by creating a cohort of people with a fracture. We’ll first look for codes that might represent a fracture and the build a cohort using these codes, setting cohort exit to 180 days after the fracture.
    
    
    fracture_codes <- [getCandidateCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getCandidateCodes.html)(cdm, "fracture")
    fracture_codes <- [list](https://rdrr.io/r/base/list.html)("fracture" = fracture_codes$concept_id)
    cdm$fracture <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = fracture_codes, 
                                     name = "fracture")
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$fracture)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## Restrict cohort by age

We can choose a specific age range for individuals in our cohort using `[requireAge()](../reference/requireAge.html)` from CohortConstructor.
    
    
    cdm$fracture <- cdm$fracture |> 
      [requireAge](../reference/requireAge.html)(indexDate = "cohort_start_date",
                 ageRange = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(18, 100)))
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$fracture)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

Note that by default individuals are filtered based on the age they were when they entered the cohort.

## Restrict cohort by sex

We can also specify a sex criteria for individuals in our cohort using `[requireSex()](../reference/requireSex.html)` from CohortConstructor.
    
    
    cdm$fracture <- cdm$fracture |> 
      [requireSex](../reference/requireSex.html)(sex = "Female")
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$fracture)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## Restrict cohort by number of prior observations

We can also specify a minimum number of days of prior observations for each individual using `[requirePriorObservation()](../reference/requirePriorObservation.html)` from CohortConstructor.
    
    
    cdm$fracture <- cdm$fracture |> 
      [requirePriorObservation](../reference/requirePriorObservation.html)(indexDate = "cohort_start_date",
                              minPriorObservation = 365)
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$fracture)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

As well as specifying a minimum amount of prior observation, we can require some mimimum amount of follow-up by using `[requireFutureObservation()](../reference/requireFutureObservation.html)` in a similar way.

## Applying multiple demographic requirements to a cohort

We can implement multiple demographic requirements at the same time by using the more general `[requireDemographics()](../reference/requireDemographics.html)` function.
    
    
    cdm$fracture <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = fracture_codes, 
                                     name = "fracture") |> 
      [requireDemographics](../reference/requireDemographics.html)(indexDate = "cohort_start_date",
                          ageRange = [c](https://rdrr.io/r/base/c.html)(18,100),
                          sex = "Female",
                          minPriorObservation = 365, 
                          minFutureObservation = 30)
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$fracture)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
