# Summarise cohort entries • CohortCharacteristics

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Summarise cohort entries

Source: [`vignettes/articles/summarise_cohort_entries.Rmd`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/vignettes/articles/summarise_cohort_entries.Rmd)

`summarise_cohort_entries.Rmd`

## Introduction

In this example we’re going to summarise the characteristics of individuals with an ankle sprain, ankle fracture, forearm fracture, or a hip fracture using the Eunomia synthetic data.

We’ll begin by creating our study cohorts.
    
    
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con = con, cdmSchem = "main", writeSchema = "main", cdmName = "Eunomia"
    )
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      name = "injuries",
      conceptSet = [list](https://rdrr.io/r/base/list.html)(
        "ankle_sprain" = 81151,
        "ankle_fracture" = 4059173,
        "forearm_fracture" = 4278672,
        "hip_fracture" = 4230399
      ),
      end = "event_end_date",
      limit = "all"
    )

## Summarising cohort counts

We can first quickly summarise and present the overall counts of our cohorts.
    
    
    cohortCounts <- [summariseCohortCount](../reference/summariseCohortCount.html)(cdm$injuries)
    [tableCohortCount](../reference/tableCohortCount.html)(cohortCounts)

CDM name | Variable name | Estimate name |  Cohort name  
---|---|---|---  
ankle_sprain | ankle_fracture | forearm_fracture | hip_fracture  
Eunomia | Number records | N | 1,915 | 464 | 569 | 138  
| Number subjects | N | 1,357 | 427 | 510 | 132  
  
Moreover, we can also easily stratify these counts. For example, here we add age groups and then stratify our counts by t We can summarise the overall counts of our cohorts.
    
    
    cdm$injuries <- cdm$injuries |>
      [addAge](https://darwin-eu.github.io/PatientProfiles/reference/addAge.html)(
        ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 3), [c](https://rdrr.io/r/base/c.html)(4, 17), [c](https://rdrr.io/r/base/c.html)(18, Inf)),
        name = "injuries"
      )
    
    cohortCounts <- [summariseCohortCount](../reference/summariseCohortCount.html)(cdm[["injuries"]], strata = "age_group")
    [tableCohortCount](../reference/tableCohortCount.html)(cohortCounts)

CDM name | Age group | Variable name | Estimate name |  Cohort name  
---|---|---|---|---  
ankle_sprain | ankle_fracture | forearm_fracture | hip_fracture  
Eunomia | overall | Number records | N | 1,915 | 464 | 569 | 138  
|  | Number subjects | N | 1,357 | 427 | 510 | 132  
| 0 to 3 | Number records | N | 202 | 49 | 51 | 7  
|  | Number subjects | N | 196 | 49 | 51 | 7  
| 18 or above | Number records | N | 1,047 | 213 | 268 | 88  
|  | Number subjects | N | 847 | 204 | 249 | 83  
| 4 to 17 | Number records | N | 666 | 202 | 250 | 43  
|  | Number subjects | N | 597 | 195 | 239 | 43  
  
We can also apply minimum cell count suppression to our cohort counts. In this case we will obscure any counts below 10.
    
    
    cohortCounts <- cohortCounts |>
      [suppress](https://darwin-eu.github.io/omopgenerics/reference/suppress.html)(minCellCount = 10)
    [tableCohortCount](../reference/tableCohortCount.html)(cohortCounts)

CDM name | Age group | Variable name | Estimate name |  Cohort name  
---|---|---|---|---  
ankle_sprain | ankle_fracture | forearm_fracture | hip_fracture  
Eunomia | overall | Number records | N | 1,915 | 464 | 569 | 138  
|  | Number subjects | N | 1,357 | 427 | 510 | 132  
| 0 to 3 | Number records | N | 202 | 49 | 51 | <10  
|  | Number subjects | N | 196 | 49 | 51 | <10  
| 18 or above | Number records | N | 1,047 | 213 | 268 | 88  
|  | Number subjects | N | 847 | 204 | 249 | 83  
| 4 to 17 | Number records | N | 666 | 202 | 250 | 43  
|  | Number subjects | N | 597 | 195 | 239 | 43  
  
## Summarising cohort attrition

Say we specify two inclusion criteria. First, we keep only cohort entries after the year 2000. Second, we keep only cohort entries for those aged 18 or older. We can easily create plots summarising our cohort attrition.
    
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      name = "ankle_sprain",
      conceptSet = [list](https://rdrr.io/r/base/list.html)("ankle_sprain" = 81151),
      end = "event_end_date",
      limit = "all"
    )
    
    cdm$ankle_sprain <- cdm$ankle_sprain |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(year(cohort_start_date) >= 2000) |>
      [compute](https://dplyr.tidyverse.org/reference/compute.html)(temporary = FALSE, name = "ankle_sprain") |>
      [recordCohortAttrition](https://darwin-eu.github.io/omopgenerics/reference/recordCohortAttrition.html)("Restrict to cohort_start_date >= 2000")
    
    attritionSummary <- [summariseCohortAttrition](../reference/summariseCohortAttrition.html)(cdm$ankle_sprain)
    
    [plotCohortAttrition](../reference/plotCohortAttrition.html)(attritionSummary)
    
    
    cdm$ankle_sprain <- cdm$ankle_sprain |>
      [addAge](https://darwin-eu.github.io/PatientProfiles/reference/addAge.html)() |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(age >= 18) |>
      [compute](https://dplyr.tidyverse.org/reference/compute.html)(temporary = FALSE, name = "ankle_sprain") |>
      [recordCohortAttrition](https://darwin-eu.github.io/omopgenerics/reference/recordCohortAttrition.html)("Restrict to age >= 18")
    
    attritionSummary <- [summariseCohortAttrition](../reference/summariseCohortAttrition.html)(cdm$ankle_sprain)
    
    [plotCohortAttrition](../reference/plotCohortAttrition.html)(attritionSummary)

We could, of course, have applied these requirements the other way around.
    
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      name = "ankle_sprain",
      conceptSet = [list](https://rdrr.io/r/base/list.html)("ankle_sprain" = 81151),
      end = "event_end_date",
      limit = "all"
    )
    
    cdm$ankle_sprain <- cdm$ankle_sprain |>
      [addAge](https://darwin-eu.github.io/PatientProfiles/reference/addAge.html)() |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(age >= 18) |>
      [compute](https://dplyr.tidyverse.org/reference/compute.html)(temporary = FALSE, name = "ankle_sprain") |>
      [recordCohortAttrition](https://darwin-eu.github.io/omopgenerics/reference/recordCohortAttrition.html)("Restrict to age >= 18")
    
    cdm$ankle_sprain <- cdm$ankle_sprain |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(year(cohort_start_date) >= 2000) |>
      [compute](https://dplyr.tidyverse.org/reference/compute.html)(temporary = FALSE, name = "ankle_sprain") |>
      [recordCohortAttrition](https://darwin-eu.github.io/omopgenerics/reference/recordCohortAttrition.html)("Restrict to cohort_start_date >= 2000")
    
    attritionSummary <- [summariseCohortAttrition](../reference/summariseCohortAttrition.html)(cdm$ankle_sprain)
    
    [plotCohortAttrition](../reference/plotCohortAttrition.html)(attritionSummary)

As well as plotting cohort attrition, we can also create a table of our results.
    
    
    [tableCohortAttrition](../reference/tableCohortAttrition.html)(attritionSummary)

Reason |  Variable name  
---|---  
number_records | number_subjects | excluded_records | excluded_subjects  
Eunomia; ankle_sprain  
Initial qualifying events | 1,915 | 1,357 | 0 | 0  
Restrict to age >= 18 | 1,047 | 847 | 868 | 510  
Restrict to cohort_start_date >= 2000 | 454 | 420 | 593 | 427  
  
## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
