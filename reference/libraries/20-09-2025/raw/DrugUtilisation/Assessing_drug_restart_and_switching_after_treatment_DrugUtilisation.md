# Assessing drug restart and switching after treatment • DrugUtilisation

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

# Assessing drug restart and switching after treatment

Source: [`vignettes/drug_restart.Rmd`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/vignettes/drug_restart.Rmd)

`drug_restart.Rmd`

## Introduction

Obtaining information on drug restart or switching to another drug after discontinuation of the original treatment is often of interest in drug utilisation studies. In this vignette, we show how to assess drug switching and restart with this package.

## Data

### Connect to mock data

For this vignette we will use mock data contained in the DrugUtilisation package.
    
    
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](../reference/mockDrugUtilisation.html)(numberIndividual = 200)

### Generate study cohorts

We will examine the patterns of drug restart and switching among patients taking metformin as an example. Specifically, we will investigate whether patients restart metformin after discontinuation, switch to insulin, try both medications, or remain untreated.

For this we will need two cohorts: one of patients exposed to metformin and another of patients exposed to insulin.
    
    
    # codelists
    metformin <- CodelistGenerator::[getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "metformin")
    insulin <- CodelistGenerator::[getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = "insulin detemir")
    
    cdm <- [generateDrugUtilisationCohortSet](../reference/generateDrugUtilisationCohortSet.html)(
      cdm = cdm, name = "metformin", conceptSet = metformin
    )
    cdm$metformin |>
      [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)()
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1            107              92
    
    cdm <- [generateDrugUtilisationCohortSet](../reference/generateDrugUtilisationCohortSet.html)(
      cdm = cdm, name = "insulin", conceptSet = insulin
    )
    cdm$insulin |>
      [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)()
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1             93              85

## Assess drug restart

The `[summariseDrugRestart()](../reference/summariseDrugRestart.html)` function analyses the outcomes within a treatment cohort following the first exposure to a specific drug. It categorises the events into four distinct groups:

  * Restarting the same treatment.

  * Switching to a different treatment.

  * Restarting the same treatment while also switching to another.

  * Discontinuing treatment altogether (neither the original treatment nor any potential switch).




The figure below illustrates the analysis, focusing on the outcomes after the initial exposure to a particular drug (in blue), with consideration of a specific switch drug (in orange). This study examines what occurs within 100, 180, and 365 days following first treatment discontinuation in the cohort.

![](figures/drug_restart_A.png)

Now, let’s use the function to assess metformin restart and switch to insulin after the first metformin treatment.
    
    
    results <- cdm$metformin |>
      [summariseDrugRestart](../reference/summariseDrugRestart.html)(
        switchCohortTable = "insulin",
        switchCohortId = NULL,
        strata = [list](https://rdrr.io/r/base/list.html)(),
        followUpDays = Inf,
        censorDate = NULL,
        restrictToFirstDiscontinuation = TRUE
      )
    
    results |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 8
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1
    #> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "6809_metformin", "6809_metformin", "6809_metformin",…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Drug restart till end of observation", "Drug restart…
    #> $ variable_level   <chr> "restart", "restart", "switch", "switch", "restart an…
    #> $ estimate_name    <chr> "count", "percentage", "count", "percentage", "count"…
    #> $ estimate_type    <chr> "integer", "percentage", "integer", "percentage", "in…
    #> $ estimate_value   <chr> "13", "14.1304347826087", "3", "3.26086956521739", "2…
    #> $ additional_name  <chr> "follow_up_days", "follow_up_days", "follow_up_days",…
    #> $ additional_level <chr> "inf days", "inf days", "inf days", "inf days", "inf …

We could be interested in getting these results in different follow-up periods since the first metformin exposure ended. For instance, next we get the results in the first 180 days, the first year, and until the end of observation.
    
    
    results <- cdm$metformin |>
      [summariseDrugRestart](../reference/summariseDrugRestart.html)(
        switchCohortTable = "insulin",
        switchCohortId = NULL,
        strata = [list](https://rdrr.io/r/base/list.html)(),
        followUpDays = [c](https://rdrr.io/r/base/c.html)(180, 365, Inf),
        censorDate = NULL,
        restrictToFirstDiscontinuation = TRUE
      )

Other options that this function allows are:

  * **restrictToFirstDiscontinuation**



By default this argument is set to TRUE, which means that we only consider the firsts exposure of the subject. If FALSE, the analysis is conducted on a record level, considering all exposures in the cohort, as the following image illustrates:

![](figures/drug_restart_B.png)

  * **censorEndDate**



This argument allows to stop considering restart and switch events after a certain date, which must specified as a column in the cohort.

  * **incident**



This argument is by default TRUE, which means we will only consider switch treatments starting after discontinuation. If set to FALSE, we will allow switch treatments starting before the discontinuation of the treatment and ending afterwards.

  * **followUpDays**



The follow-up of the individuals will be set to Inf by default, i.e. we will follow them up for as long as possible. However, we can restrict the follow-up period to any other time interval as seen in the previous example.

  * **strata**



This argument must be a list pointing to columns or combinations of columns in the cohort to use as strata. It will produce stratified estimates as well as for the overall cohort.

For instance, we reproduce the last calculation but this time straifying by sex. We first use PatientProfiles to add a column indicating the sex, which later we use in strata.
    
    
    results <- cdm$cohort1 |>
      PatientProfiles::[addSex](https://darwin-eu.github.io/PatientProfiles/reference/addSex.html)(name = "cohort1") |>
      [summariseDrugRestart](../reference/summariseDrugRestart.html)(
        switchCohortTable = "insulin",
        switchCohortId = NULL,
        strata = [list](https://rdrr.io/r/base/list.html)("sex"),
        followUpDays = [c](https://rdrr.io/r/base/c.html)(180, 365, Inf),
        censorDate = NULL,
        restrictToFirstDiscontinuation = TRUE
      )

## Visualise drug restart

The package has table and plot functions to help visualising the results from `[summariseDrugRestart()](../reference/summariseDrugRestart.html)`.

### Table

The function `[tableDrugRestart()](../reference/tableDrugRestart.html)` will create a gt, flextable or tibble table from the summarised_result object created with `[summariseDrugRestart()](../reference/summariseDrugRestart.html)`. This function offers multiple customisation options to format the resulting table according to the user preferences.
    
    
    results |>
      [tableDrugRestart](../reference/tableDrugRestart.html)()
    #> Warning: cdm_name, cohort_name, variable_name, follow_up_days, censor_date,
    #> cohort_table_name, incident, restrict_to_first_discontinuation, and
    #> switch_cohort_table are missing in `columnOrder`, will be added last.

|  CDM name  
---|---  
|  DUS MOCK  
Sex | Treatment | Estimate name |  Cohort name  
cohort_1 | cohort_2 | cohort_3  
Drug restart in 180 days  
overall | restart | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| switch | N (%) | 3 (4.55 %) | 3 (5.88 %) | 4 (4.82 %)  
| restart and switch | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| untreated | N (%) | 63 (95.45 %) | 48 (94.12 %) | 79 (95.18 %)  
Female | restart | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| switch | N (%) | 2 (6.90 %) | 2 (7.41 %) | 3 (7.69 %)  
| restart and switch | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| untreated | N (%) | 27 (93.10 %) | 25 (92.59 %) | 36 (92.31 %)  
Male | restart | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| switch | N (%) | 1 (2.70 %) | 1 (4.17 %) | 1 (2.27 %)  
| restart and switch | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| untreated | N (%) | 36 (97.30 %) | 23 (95.83 %) | 43 (97.73 %)  
Drug restart in 365 days  
overall | restart | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| switch | N (%) | 3 (4.55 %) | 5 (9.80 %) | 5 (6.02 %)  
| restart and switch | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| untreated | N (%) | 63 (95.45 %) | 46 (90.20 %) | 78 (93.98 %)  
Female | restart | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| switch | N (%) | 2 (6.90 %) | 3 (11.11 %) | 4 (10.26 %)  
| restart and switch | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| untreated | N (%) | 27 (93.10 %) | 24 (88.89 %) | 35 (89.74 %)  
Male | restart | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| switch | N (%) | 1 (2.70 %) | 2 (8.33 %) | 1 (2.27 %)  
| restart and switch | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| untreated | N (%) | 36 (97.30 %) | 22 (91.67 %) | 43 (97.73 %)  
Drug restart till end of observation  
overall | restart | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| switch | N (%) | 5 (7.58 %) | 8 (15.69 %) | 8 (9.64 %)  
| restart and switch | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| untreated | N (%) | 61 (92.42 %) | 43 (84.31 %) | 75 (90.36 %)  
Female | restart | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| switch | N (%) | 4 (13.79 %) | 5 (18.52 %) | 6 (15.38 %)  
| restart and switch | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| untreated | N (%) | 25 (86.21 %) | 22 (81.48 %) | 33 (84.62 %)  
Male | restart | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| switch | N (%) | 1 (2.70 %) | 3 (12.50 %) | 2 (4.55 %)  
| restart and switch | N (%) | 0 (0.00 %) | 0 (0.00 %) | 0 (0.00 %)  
| untreated | N (%) | 36 (97.30 %) | 21 (87.50 %) | 42 (95.45 %)  
  
### Plot

The `[plotDrugRestart()](../reference/plotDrugRestart.html)` function creates a bar plot depicting the percentage of drug restart events for each cohort, stratum, and follow-up time (specified in the variable_name column of the summarised result). This function offers customisation options for colours, facetting, and handling of strata.
    
    
    results |>
      [plotDrugRestart](../reference/plotDrugRestart.html)(facet = cohort_name + sex ~ follow_up_days)

![](drug_restart_files/figure-html/unnamed-chunk-10-1.png)

### Adding the information to an existing cohort

We can directly add the drug restart information to an existing cohort as a column instead of asking for a summarising object. In this case we will use the function `[addDrugRestart()](../reference/addDrugRestart.html)`, which will add one column per follow-up window we ask for:
    
    
    cdm$metformin |>
      [addDrugRestart](../reference/addDrugRestart.html)(
        switchCohortTable = "insulin",
        switchCohortId = NULL,
        followUpDays = [c](https://rdrr.io/r/base/c.html)(180, 365, Inf),
        censorDate = NULL
      ) |>
      gt::[gt](https://gt.rstudio.com/reference/gt.html)()

cohort_definition_id | subject_id | cohort_start_date | cohort_end_date | drug_restart_180 | drug_restart_365 | drug_restart_inf  
---|---|---|---|---|---|---  
1 | 103 | 2010-11-18 | 2014-07-23 | restart | restart | restart  
1 | 59 | 2019-09-08 | 2020-06-19 | untreated | untreated | restart  
1 | 116 | 2016-12-01 | 2017-06-29 | untreated | untreated | restart  
1 | 69 | 2020-04-28 | 2020-10-03 | restart | restart | restart  
1 | 129 | 2020-01-10 | 2020-08-31 | restart | restart | restart  
1 | 98 | 2014-07-10 | 2016-02-06 | restart | restart | restart  
1 | 99 | 2020-03-12 | 2020-04-10 | untreated | untreated | restart  
1 | 128 | 2021-08-20 | 2021-08-20 | restart | restart | restart  
1 | 19 | 2009-03-10 | 2011-04-27 | untreated | restart | restart  
1 | 191 | 2019-11-02 | 2020-04-17 | restart | restart | restart  
1 | 54 | 1987-06-05 | 1990-04-03 | restart | restart | restart  
1 | 4 | 2009-05-01 | 2009-11-27 | untreated | restart | restart  
1 | 121 | 2019-05-17 | 2019-11-13 | restart | restart | restart  
1 | 48 | 2021-07-21 | 2021-12-05 | untreated | untreated | untreated  
1 | 152 | 2021-10-24 | 2021-12-02 | untreated | untreated | untreated  
1 | 191 | 2020-05-17 | 2020-05-19 | untreated | untreated | untreated  
1 | 127 | 2019-09-07 | 2019-09-15 | untreated | untreated | untreated  
1 | 99 | 2021-05-16 | 2021-06-22 | untreated | untreated | untreated  
1 | 78 | 2016-08-20 | 2016-11-02 | untreated | untreated | untreated  
1 | 151 | 2005-05-06 | 2007-12-30 | untreated | untreated | untreated  
1 | 51 | 2014-09-11 | 2017-09-02 | untreated | untreated | untreated  
1 | 111 | 2021-03-01 | 2022-06-28 | untreated | untreated | untreated  
1 | 68 | 2003-04-21 | 2007-10-04 | untreated | untreated | untreated  
1 | 118 | 2010-04-22 | 2013-07-06 | untreated | untreated | untreated  
1 | 181 | 1987-06-02 | 1997-12-15 | untreated | untreated | untreated  
1 | 187 | 1994-10-31 | 1996-09-28 | untreated | untreated | untreated  
1 | 114 | 2021-03-19 | 2021-06-24 | untreated | untreated | untreated  
1 | 56 | 2017-05-04 | 2018-03-04 | untreated | untreated | untreated  
1 | 199 | 2020-04-16 | 2020-04-25 | untreated | untreated | untreated  
1 | 4 | 2010-07-25 | 2011-12-11 | untreated | untreated | untreated  
1 | 70 | 2018-01-01 | 2018-08-23 | untreated | untreated | untreated  
1 | 11 | 2007-04-03 | 2007-05-07 | untreated | untreated | untreated  
1 | 36 | 1999-08-07 | 2004-01-08 | untreated | untreated | untreated  
1 | 34 | 2018-09-26 | 2018-10-02 | untreated | untreated | untreated  
1 | 108 | 2001-09-04 | 2007-10-06 | untreated | untreated | untreated  
1 | 137 | 2020-06-16 | 2020-07-01 | untreated | untreated | untreated  
1 | 80 | 2018-08-03 | 2018-09-08 | untreated | untreated | untreated  
1 | 132 | 2007-05-18 | 2008-04-24 | untreated | untreated | untreated  
1 | 175 | 2022-09-13 | 2022-09-27 | untreated | untreated | untreated  
1 | 174 | 2019-05-21 | 2019-06-13 | untreated | untreated | untreated  
1 | 194 | 2022-02-16 | 2022-03-10 | untreated | untreated | untreated  
1 | 35 | 2014-12-01 | 2016-04-11 | untreated | untreated | untreated  
1 | 47 | 2016-02-29 | 2016-09-10 | untreated | untreated | untreated  
1 | 69 | 2021-01-06 | 2021-01-19 | untreated | untreated | untreated  
1 | 125 | 2013-01-13 | 2013-07-15 | untreated | untreated | untreated  
1 | 38 | 2000-03-27 | 2003-07-03 | untreated | untreated | untreated  
1 | 43 | 1972-03-04 | 1990-03-14 | untreated | untreated | untreated  
1 | 16 | 2019-03-19 | 2019-10-19 | untreated | untreated | untreated  
1 | 45 | 2020-11-27 | 2020-12-18 | untreated | untreated | untreated  
1 | 116 | 2019-01-28 | 2019-03-06 | untreated | untreated | untreated  
1 | 65 | 2004-09-04 | 2015-07-24 | untreated | untreated | untreated  
1 | 82 | 2004-02-25 | 2008-06-14 | untreated | untreated | untreated  
1 | 169 | 2016-03-29 | 2020-10-15 | untreated | untreated | untreated  
1 | 12 | 1991-08-30 | 1994-01-03 | untreated | untreated | untreated  
1 | 107 | 2021-07-04 | 2021-07-08 | untreated | untreated | untreated  
1 | 172 | 2003-07-30 | 2005-08-24 | untreated | untreated | untreated  
1 | 155 | 1999-08-04 | 2001-12-26 | untreated | untreated | untreated  
1 | 185 | 1993-07-02 | 1999-05-12 | untreated | untreated | untreated  
1 | 124 | 2021-07-09 | 2022-08-07 | untreated | untreated | untreated  
1 | 22 | 1958-05-12 | 1975-05-23 | untreated | untreated | untreated  
1 | 183 | 1999-12-27 | 2003-01-03 | untreated | untreated | untreated  
1 | 19 | 2011-12-01 | 2014-01-15 | untreated | untreated | untreated  
1 | 143 | 2020-11-20 | 2020-11-21 | untreated | untreated | untreated  
1 | 40 | 2022-07-02 | 2022-07-09 | untreated | untreated | untreated  
1 | 130 | 2019-01-01 | 2019-07-20 | untreated | untreated | untreated  
1 | 54 | 1990-06-01 | 1990-06-26 | untreated | untreated | untreated  
1 | 7 | 2010-01-08 | 2011-05-13 | untreated | untreated | untreated  
1 | 179 | 2017-08-07 | 2017-08-11 | untreated | untreated | untreated  
1 | 177 | 2022-02-05 | 2022-03-17 | untreated | untreated | untreated  
1 | 20 | 2018-01-25 | 2018-03-07 | untreated | untreated | untreated  
1 | 25 | 2006-05-08 | 2009-02-17 | untreated | untreated | untreated  
1 | 31 | 2019-07-28 | 2019-12-28 | untreated | untreated | untreated  
1 | 123 | 1982-07-20 | 1982-08-03 | untreated | untreated | untreated  
1 | 86 | 2008-04-13 | 2013-09-23 | untreated | untreated | untreated  
1 | 95 | 2000-12-05 | 2001-09-12 | untreated | untreated | untreated  
1 | 166 | 2004-01-31 | 2014-03-25 | untreated | untreated | untreated  
1 | 57 | 2010-12-03 | 2013-03-16 | untreated | untreated | untreated  
1 | 66 | 2006-09-07 | 2006-09-25 | untreated | untreated | untreated  
1 | 192 | 1981-09-01 | 1985-05-07 | untreated | untreated | untreated  
1 | 67 | 2009-09-27 | 2012-08-13 | untreated | untreated | untreated  
1 | 98 | 2016-05-09 | 2017-03-17 | untreated | untreated | untreated  
1 | 171 | 2000-01-18 | 2002-04-03 | untreated | untreated | untreated  
1 | 121 | 2020-05-04 | 2021-09-09 | untreated | untreated | untreated  
1 | 129 | 2020-11-08 | 2020-11-22 | untreated | untreated | untreated  
1 | 21 | 2015-10-09 | 2018-01-10 | untreated | untreated | untreated  
1 | 73 | 2019-09-04 | 2019-10-15 | untreated | untreated | untreated  
1 | 140 | 1997-04-09 | 1999-02-14 | untreated | untreated | untreated  
1 | 103 | 2014-10-08 | 2020-01-23 | untreated | untreated | untreated  
1 | 144 | 2011-12-07 | 2013-03-06 | untreated | untreated | untreated  
1 | 128 | 2021-09-30 | 2021-10-07 | untreated | untreated | untreated  
1 | 102 | 2009-03-20 | 2009-09-23 | untreated | untreated | untreated  
1 | 196 | 2000-11-04 | 2004-05-07 | untreated | untreated | untreated  
1 | 158 | 2015-01-16 | 2018-11-30 | untreated | untreated | untreated  
1 | 3 | 2001-07-12 | 2002-03-10 | untreated | untreated | untreated  
1 | 76 | 2013-05-10 | 2019-10-08 | untreated | untreated | untreated  
1 | 110 | 1980-11-27 | 1984-11-11 | untreated | untreated | untreated  
1 | 74 | 2008-03-21 | 2017-06-02 | untreated | untreated | untreated  
1 | 134 | 2016-04-21 | 2017-01-31 | untreated | untreated | untreated  
1 | 59 | 2021-10-24 | 2022-03-31 | untreated | untreated | untreated  
1 | 92 | 2022-09-29 | 2022-10-11 | untreated | untreated | untreated  
1 | 71 | 2010-10-25 | 2011-12-13 | untreated | untreated | untreated  
1 | 136 | 2012-12-09 | 2013-11-15 | untreated | restart | restart and switch  
1 | 177 | 2012-12-18 | 2014-07-01 | untreated | untreated | restart and switch  
1 | 136 | 2014-09-03 | 2015-10-01 | untreated | switch | switch  
1 | 29 | 2022-12-12 | 2022-12-15 | switch | switch | switch  
1 | 15 | 2012-11-05 | 2019-04-21 | switch | switch | switch  
1 | 186 | 2004-12-30 | 2006-09-08 | untreated | untreated | switch  
  
## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
