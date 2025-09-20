# Summarise treatments • DrugUtilisation

Skip to contents

[DrugUtilisation](../index.html) 1.0.4

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Create mock data to test DrugUtilisation package](../articles/mock_data.html)
    * [Creating drug cohorts](../articles/create_cohorts.html)
    * [Identify and summarise indications among a drug cohort](../articles/indication.html)
    * [Daily dose calculation](../articles/daily_dose_calculation.html)
    * [Getting drug utilisation related information of subjects in a cohort](../articles/drug_utilisation.html)
    * [Summarise treatments](../articles/summarise_treatments.html)
    * [Summarising treatment adherence](../articles/treatment_discontinuation.html)
    * [Assessing drug restart and switching after treatment](../articles/drug_restart.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/DrugUtilisation/)



![](../logo.png)

# Summarise treatments

Source: [`vignettes/summarise_treatments.Rmd`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/vignettes/summarise_treatments.Rmd)

`summarise_treatments.Rmd`

## Introduction

After creating a study cohort, for example of some specific condition of interest, we may be interested in describing the treatments received by the individuals within it. Here we show how such a summary can be obtained.

### Create mock table

We will use mock data contained in the package throughout the vignette. Let’s modify cohort tables `cohort1` and `cohort2` in our mock dataset, so the first table includes 3 cohorts of health conditions (our study cohorts), while the second contains three are of treatments they could receive.
    
    
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](../reference/mockDrugUtilisation.html)(numberIndividual = 200)
    
    new_cohort_set <- [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort1) |>
      dplyr::[arrange](https://dplyr.tidyverse.org/reference/arrange.html)(cohort_definition_id) |>
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(cohort_name = [c](https://rdrr.io/r/base/c.html)("asthma", "bronchitis", "pneumonia"))
    
    cdm$cohort1 <- cdm$cohort1 |>
      omopgenerics::[newCohortTable](https://darwin-eu.github.io/omopgenerics/reference/newCohortTable.html)(cohortSetRef = new_cohort_set)
    
    new_cohort_set <- [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort2) |>
      dplyr::[arrange](https://dplyr.tidyverse.org/reference/arrange.html)(cohort_definition_id) |>
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(cohort_name = [c](https://rdrr.io/r/base/c.html)("albuterol", "fluticasone", "montelukast"))
    
    cdm$cohort2 <- cdm$cohort2 |>
      omopgenerics::[newCohortTable](https://darwin-eu.github.io/omopgenerics/reference/newCohortTable.html)(cohortSetRef = new_cohort_set)

Notice that `cohort1` is a cohort table with three cohorts representing three different conditions:
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort1)
    #> # A tibble: 3 × 2
    #>   cohort_definition_id cohort_name
    #>                  <int> <chr>      
    #> 1                    1 asthma     
    #> 2                    2 bronchitis 
    #> 3                    3 pneumonia

And `cohort2` is a cohort table with three different treatment cohorts:
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort2)
    #> # A tibble: 3 × 2
    #>   cohort_definition_id cohort_name
    #>                  <int> <chr>      
    #> 1                    1 albuterol  
    #> 2                    2 fluticasone
    #> 3                    3 montelukast

## Summarise treatment

The `[summariseTreatment()](../reference/summariseTreatment.html)` function produces a summary of the treatment received by our study cohorts. There are three mandatory arguments:

  1. `cohort`: cohort from the cdm object.
  2. `treatmentCohortName`: name of the treatment cohort table.
  3. `window`: a list specifying the time windows during which treatments should be summarised.



See an example of its usage below, where we use `[summariseTreatment()](../reference/summariseTreatment.html)` to summarise treatments defined in `cohort2` in the target cohorts defined in `cohort1`.
    
    
    [summariseTreatment](../reference/summariseTreatment.html)(
      cohort = cdm$cohort1,
      treatmentCohortName = [c](https://rdrr.io/r/base/c.html)("cohort2"),
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0), [c](https://rdrr.io/r/base/c.html)(1, 30))
    )

### strata parameter

We can also stratify our cohort and calculate the estimates within each strata group by using the `strata` parameter.
    
    
    cdm[["cohort1"]] <- cdm[["cohort1"]] |>
      PatientProfiles::[addSex](https://darwin-eu.github.io/PatientProfiles/reference/addSex.html)() |>
      PatientProfiles::[addAge](https://darwin-eu.github.io/PatientProfiles/reference/addAge.html)(ageGroup = [list](https://rdrr.io/r/base/list.html)("<40" = [c](https://rdrr.io/r/base/c.html)(0, 39), ">=40" = [c](https://rdrr.io/r/base/c.html)(40, 150)))
    
    results <- [summariseTreatment](../reference/summariseTreatment.html)(
      cohort = cdm$cohort1,
      treatmentCohortName = [c](https://rdrr.io/r/base/c.html)("cohort2"),
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0)),
      treatmentCohortId = 1,
      strata = [list](https://rdrr.io/r/base/list.html)("sex", "age_group")
    )

Notice that we have also used the `treatmentCohortId` parameter to specify that we only want to explore `albuterol` (which corresponds to the cohort id 1 in our cohort table) across the cohorts defined in `cohort1`.

### other parameters

The `[summariseTreatment()](../reference/summariseTreatment.html)` functions also has other input parameters which can be tuned:

  * `cohortId`: to restrict the analysis to a particular cohort definition id in the target cohort.
  * `indexDate`: what column to use as the index date to start the analysis. By default we use `cohort_start_date`, but any other date column, such as `cohort_end_date`, can be specified instead.
  * `censorDate`: whether to end the analysis at any specific date. Otherwise we will follow the individuals until end of their respective observation period.
  * `mutuallyExclusive`: by default set to FALSE, this will consider the treatments separately, so an individual can belong to different treatment groups at the same time (i.e. if they are treated with multiple drugs). Therefore, for each target cohort, we could have a sum of percentages of all treatment drugs greater than 100%. If set to TRUE, non-overlapping treatment groups will be assessed (with multiple drugs in some of those if needed), so that all individuals will belong to only one of them, and the percentages will add up to a 100.


    
    
    result_not_mutually_exc <- [summariseTreatment](../reference/summariseTreatment.html)(
      cohort = cdm$cohort1,
      treatmentCohortName = [c](https://rdrr.io/r/base/c.html)("cohort2"),
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0))
    )
    #> ℹ Intersect with medications table (cohort2)
    #> ℹ Summarising medications.
    
    result_mutually_exc <- [summariseTreatment](../reference/summariseTreatment.html)(
      cohort = cdm$cohort1,
      treatmentCohortName = [c](https://rdrr.io/r/base/c.html)("cohort2"),
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 0)),
      mutuallyExclusive = TRUE
    )
    #> ℹ Intersect with medications table (cohort2)
    #> ℹ Summarising medications.
    
    [tableTreatment](../reference/tableTreatment.html)(result = result_not_mutually_exc)
    #> Warning: cdm_name, cohort_name, variable_name, window_name, censor_date,
    #> cohort_table_name, index_date, mutually_exclusive, and treatment_cohort_name
    #> are missing in `columnOrder`, will be added last.

|  CDM name  
---|---  
|  DUS MOCK  
Treatment | Estimate name |  Cohort name  
asthma | bronchitis | pneumonia  
Medication on index date  
albuterol | N (%) | 5 (7.58 %) | 6 (11.76 %) | 7 (8.43 %)  
fluticasone | N (%) | 10 (15.15 %) | 5 (9.80 %) | 9 (10.84 %)  
montelukast | N (%) | 6 (9.09 %) | 5 (9.80 %) | 2 (2.41 %)  
untreated | N (%) | 45 (68.18 %) | 35 (68.63 %) | 65 (78.31 %)  
not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
      
    
    [tableTreatment](../reference/tableTreatment.html)(result = result_mutually_exc)
    #> Warning: cdm_name, cohort_name, variable_name, window_name, censor_date,
    #> cohort_table_name, index_date, mutually_exclusive, and treatment_cohort_name
    #> are missing in `columnOrder`, will be added last.

|  CDM name  
---|---  
|  DUS MOCK  
Treatment | Estimate name |  Cohort name  
asthma | bronchitis | pneumonia  
Medication on index date  
albuterol | N (%) | 5 (7.58 %) | 6 (11.76 %) | 7 (8.43 %)  
fluticasone | N (%) | 10 (15.15 %) | 5 (9.80 %) | 9 (10.84 %)  
montelukast | N (%) | 6 (9.09 %) | 5 (9.80 %) | 2 (2.41 %)  
albuterol and fluticasone | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
albuterol and montelukast | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
fluticasone and montelukast | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
albuterol and fluticasone and montelukast | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
untreated | N (%) | 45 (68.18 %) | 35 (68.63 %) | 65 (78.31 %)  
not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
  
In this case, as no individual was given more than one of the treatment drugs, the percentages are the same. However, we can easily see how these analyses would provide different results in other contexts.

## Visualise results

The package includes `table` and `plot` functions to help visualise the results from `[summariseTreatment()](../reference/summariseTreatment.html)`, like we have just used to show the results above.

### Tables

The `[tableTreatment()](../reference/tableTreatment.html)` function generates a table in gt, flextable, or tibble format from the summarised_result produced by `[summariseTreatment()](../reference/summariseTreatment.html)`. This function has customisation options to format the table according to user preferences.
    
    
    [tableTreatment](../reference/tableTreatment.html)(result = results)
    #> Warning: cdm_name, cohort_name, variable_name, window_name, censor_date,
    #> cohort_table_name, index_date, mutually_exclusive, and treatment_cohort_name
    #> are missing in `columnOrder`, will be added last.

|  CDM name  
---|---  
|  DUS MOCK  
Sex | Age group | Treatment | Estimate name |  Cohort name  
asthma | bronchitis | pneumonia  
Medication on index date  
overall | overall | albuterol | N (%) | 5 (7.58 %) | 6 (11.76 %) | 7 (8.43 %)  
|  | untreated | N (%) | 61 (92.42 %) | 45 (88.24 %) | 76 (91.57 %)  
|  | not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
Female | overall | albuterol | N (%) | 2 (6.90 %) | 3 (11.11 %) | 2 (5.13 %)  
|  | untreated | N (%) | 27 (93.10 %) | 24 (88.89 %) | 37 (94.87 %)  
|  | not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
Male | overall | albuterol | N (%) | 3 (8.11 %) | 3 (12.50 %) | 5 (11.36 %)  
|  | untreated | N (%) | 34 (91.89 %) | 21 (87.50 %) | 39 (88.64 %)  
|  | not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
overall | <40 | albuterol | N (%) | 5 (9.80 %) | 6 (13.64 %) | 4 (6.67 %)  
|  | untreated | N (%) | 46 (90.20 %) | 38 (86.36 %) | 56 (93.33 %)  
|  | not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| >=40 | albuterol | N (%) | 0 (0.00 %) | 0 (0.00 %) | 3 (13.04 %)  
|  | untreated | N (%) | 15 (100.00 %) | 7 (100.00 %) | 20 (86.96 %)  
|  | not in observation | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
  
### Plots

The `[plotTreatment()](../reference/plotTreatment.html)` function creates a bar plot showing the percentage of treated and untreated in each cohort, stratum, and time-window. This function offers customization options for colors, faceting, and handling of strata.
    
    
    [plotTreatment](../reference/plotTreatment.html)(
      result = results,
      facet =  sex + age_group ~ window_name + cohort_name,
      colour = "variable_level"
    )

![](summarise_treatments_files/figure-html/unnamed-chunk-9-1.png)

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
