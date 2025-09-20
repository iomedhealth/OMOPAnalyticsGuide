# Applying cohort table requirements • CohortConstructor

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

# Applying cohort table requirements

Source: [`vignettes/a02_cohort_table_requirements.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a02_cohort_table_requirements.Rmd)

`a02_cohort_table_requirements.Rmd`

In this vignette we’ll show how requirements related to the data contained in the cohort table can be applied. For this we’ll use the Eunomia synthetic data.
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", 
                        writeSchema = "main", writePrefix = "my_study_")

Let’s start by creating a cohort of acetaminophen users. Individuals will have a cohort entry for each drug exposure record they have for acetaminophen with cohort exit based on their drug record end date. Note when creating the cohort, any overlapping records will be concatenated.
    
    
    acetaminophen_codes <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm, 
                                                  name = "acetaminophen", 
                                                  nameStyle = "{concept_name}")
    cdm$acetaminophen <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                       conceptSet = acetaminophen_codes, 
                                       exit = "event_end_date",
                                       name = "acetaminophen")

At this point we have just created our base cohort without having applied any restrictions. To visualise the current state of the cohort, we can use the `[summariseCohortAttrition()](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)` function to summarise attrition and then plot the results using `[plotCohortAttrition()](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)`.
    
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$acetaminophen)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## Keep only the first record per person

We can see that in our starting cohort individuals have multiple entries for each use of acetaminophen. However, we could keep only their earliest cohort entry by using `[requireIsFirstEntry()](../reference/requireIsFirstEntry.html)` from CohortConstructor.
    
    
    cdm$acetaminophen <- cdm$acetaminophen |> 
      [requireIsFirstEntry](../reference/requireIsFirstEntry.html)()
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$acetaminophen)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

While the number of individuals remains unchanged, records after an individual’s first have been excluded.

## Keep only the last record per person

If we want to require cohort entries to last a specific amount of time then we can use `[requireDuration()](../reference/requireDuration.html)`. Here for example we create an acetaminophen cohort and keep only those records that last for at least 30 days.
    
    
    cdm$acetaminophen <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                       conceptSet = acetaminophen_codes, 
                                       exit = "event_end_date",
                                       name = "acetaminophen") |> 
      [requireDuration](../reference/requireDuration.html)([c](https://rdrr.io/r/base/c.html)(30, Inf))
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$acetaminophen)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## Keep only a range of records per person

If we want to keep only a specific range of records per person, we can use the `[requireIsEntry()](../reference/requireIsEntry.html)` function. For example, o keep only the first two entries for each person, we can set `entryRange = c(1, 2)`.
    
    
    cdm$acetaminophen <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                       conceptSet = acetaminophen_codes, 
                                       exit = "event_end_date",
                                       name = "acetaminophen")
    cdm$acetaminophen <- cdm$acetaminophen |> 
      [requireIsEntry](../reference/requireIsEntry.html)(entryRange = [c](https://rdrr.io/r/base/c.html)(1,2))
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$acetaminophen)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## Keep only records within a date range

Individuals may contribute multiple records over extended periods. We can filter out records that fall outside a specified date range using the `requireInDateRange` function.
    
    
    cdm$acetaminophen <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = acetaminophen_codes, 
                                     name = "acetaminophen")
    
    
    cdm$acetaminophen <- cdm$acetaminophen |> 
      [requireInDateRange](../reference/requireInDateRange.html)(dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2010-01-01", "2015-01-01")))
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$acetaminophen)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## Keep only if entry lasts a given duration
    
    
    cdm$acetaminophen <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = acetaminophen_codes, 
                                     name = "acetaminophen")
    
    
    cdm$acetaminophen <- cdm$acetaminophen |> 
      [requireInDateRange](../reference/requireInDateRange.html)(dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2010-01-01", "2015-01-01")))
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$acetaminophen)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## Applying multiple cohort requirements

Multiple restrictions can be applied to a cohort, however it is important to note that the order that requirements are applied will often matter.
    
    
    cdm$acetaminophen_1 <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = acetaminophen_codes, 
                                     name = "acetaminophen_1") |> 
      [requireIsFirstEntry](../reference/requireIsFirstEntry.html)() |>
      [requireInDateRange](../reference/requireInDateRange.html)(dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2010-01-01", "2016-01-01")))
    
    cdm$acetaminophen_2 <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = acetaminophen_codes, 
                                     name = "acetaminophen_2") |>
      [requireInDateRange](../reference/requireInDateRange.html)(dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2010-01-01", "2016-01-01"))) |> 
      [requireIsFirstEntry](../reference/requireIsFirstEntry.html)()
    
    
    summary_attrition_1 <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$acetaminophen_1)
    summary_attrition_2 <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$acetaminophen_2)

Here we see attrition if we apply our entry requirement before our date requirement. In this case we have a cohort of people with their first ever record of acetaminophen which occurs in our study period.
    
    
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition_1)

And here we see attrition if we apply our date requirement before our entry requirement. In this case we have a cohort of people with their first record of acetaminophen in the study period, although this will not necessarily be their first record ever.
    
    
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition_2)

## Keep only records from cohorts with a minimum number of individuals

Another useful functionality, particularly when working with multiple cohorts or performing a network study, is provided by `requireMinCohortCount`. Here we will only keep cohorts with a minimum count, filtering out records from cohorts with fewer than this number.

As an example let’s create a cohort for every drug ingredient we see in Eunomia. We can first get the drug ingredient codes.
    
    
    medication_codes <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, nameStyle = "{concept_name}")
    medication_codes
    #> 
    #> - acetaminophen (7 codes)
    #> - albuterol (2 codes)
    #> - alendronate (2 codes)
    #> - alfentanil (1 codes)
    #> - alteplase (2 codes)
    #> - amiodarone (2 codes)
    #> along with 85 more codelists

We can see that when we make all these cohorts many have only a small number of individuals.
    
    
    cdm$medications <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = medication_codes,
                                     name = "medications")
    
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications) |> 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(number_subjects > 0) |> 
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)() +
      [geom_histogram](https://ggplot2.tidyverse.org/reference/geom_histogram.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(number_subjects),
                     colour = "black",
                     binwidth = 25) +  
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Number of subjects") +
      [theme_bw](https://ggplot2.tidyverse.org/reference/ggtheme.html)()

![](a02_cohort_table_requirements_files/figure-html/unnamed-chunk-19-1.png)

If we apply a minimum cohort count of 500, we end up with far fewer cohorts that all have a sufficient number of study participants.
    
    
    cdm$medications <- cdm$medications |> 
      [requireMinCohortCount](../reference/requireMinCohortCount.html)(minCohortCount = 500)
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications) |> 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(number_subjects > 0) |> 
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)() +
      [geom_histogram](https://ggplot2.tidyverse.org/reference/geom_histogram.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(number_subjects),
                     colour = "black",
                     binwidth = 25) + 
      [xlim](https://ggplot2.tidyverse.org/reference/lims.html)(0, NA) + 
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Number of subjects") +
      [theme_bw](https://ggplot2.tidyverse.org/reference/ggtheme.html)()

![](a02_cohort_table_requirements_files/figure-html/unnamed-chunk-20-1.png)

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
