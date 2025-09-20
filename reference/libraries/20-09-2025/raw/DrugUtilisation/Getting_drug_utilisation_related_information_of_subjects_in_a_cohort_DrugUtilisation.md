# Getting drug utilisation related information of subjects in a cohort • DrugUtilisation

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

# Getting drug utilisation related information of subjects in a cohort

Source: [`vignettes/drug_utilisation.Rmd`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/vignettes/drug_utilisation.Rmd)

`drug_utilisation.Rmd`

## Introduction

The DrugUtilisation package includes a range of functions that add drug-related information of subjects in OMOP CDM tables and cohort tables. Essentially, there are two functionalities: `add` and `summarise`. While the first return patient-level information on drug usage, the second returns aggregate estimates of it. In this vignette, we will explore these functions and provide some examples for its usage.

## Set up

### Mock data

For this vignette we will use mock data contained in the DrugUtilisation package. This mock dataset contains cohorts, we will take “cohort1” as the cohort table of interest from which we want to study drug usage of acetaminophen.
    
    
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](../reference/mockDrugUtilisation.html)(numberIndividual = 200)
    cdm$cohort1 |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 3, 1, 1, 3, 3, 2, 1, 3, 2, 3, 3, 1, 2, 3, 2, 2, 1…
    #> $ subject_id           <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15…
    #> $ cohort_start_date    <date> 2004-08-15, 2015-06-19, 2001-07-26, 2008-06-25, …
    #> $ cohort_end_date      <date> 2005-04-10, 2017-10-21, 2001-12-07, 2012-03-22, …

### Drug codes

Since we want to characterise _acetaminophen_ and _simvastatin_ usage for subjects in cohort1, we first have to get the codelist with CodelistGenerator:
    
    
    drugConcepts <- CodelistGenerator::[getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, name = [c](https://rdrr.io/r/base/c.html)("acetaminophen", "simvastatin"))

## Add drug utilisation information

### addNumberExposures()

With the function **`[addNumberExposures()](../reference/addNumberExposures.html)`** we can get how many exposures to acetaminophen each patient in our cohort had during a certain time. There are 2 thing to keep in mind when using this function:

  * **Time period of interest:** The `indexDate` and `censorDate` arguments refer to the time-period in which we are interested to compute the number of exposure to acetaminophen. The refer to date columns in the cohort table, and by default this are “cohort_start_date” and “cohort_end_date” respectively.

  * **Incident or prevalent events?** Do we want to consider only those exposures to the drug of interest starting during the time-period (`restrictIncident = TRUE`), or do we also want to take into account those that started before but underwent for at least some time during the follow-up period considered (`restrictIncident = FALSE`)?




In what follows we add a column in the cohort table, with the number of incident exposures during the time patients are in the cohort:
    
    
    cohort <- [addNumberExposures](../reference/addNumberExposures.html)(
      cohort = cdm$cohort1, # cohort with the population of interest
      conceptSet = drugConcepts, # concepts of the drugs of interest
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      restrictIncident = TRUE,
      nameStyle = "number_exposures_{concept_name}",
      name = NULL
    )
    
    cohort |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 6
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id               <int> 3, 2, 1, 2, 3, 1, 3, 2, 1, 2, 3, 1,…
    #> $ subject_id                         <int> 1, 6, 7, 9, 10, 12, 14, 15, 17, 20,…
    #> $ cohort_start_date                  <date> 2004-08-15, 2012-07-24, 2013-06-10…
    #> $ cohort_end_date                    <date> 2005-04-10, 2012-08-10, 2013-08-26…
    #> $ number_exposures_36567_simvastatin <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    #> $ number_exposures_161_acetaminophen <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…

### addNumberEras()

This function works like the previous one, but calculates the **number of eras** instead of exposures. The difference between these two is given by the `gapEra` argument: consecutive drug exposures separated by less than the days specified in `gapEra`, are collapsed together into the same era.

Next we compute the number of eras, considering a gap of 3 days.

Additionally, we use the argument `nameStyle` so the new columns are only identified by the concept name, instead of using the prefix “number_eras_” set by default.
    
    
    cohort <- [addNumberEras](../reference/addNumberEras.html)(
      cohort = cdm$cohort1, # cohort with the population of interest
      conceptSet = drugConcepts, # concepts of the drugs of interest
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      gapEra = 3,
      restrictIncident = TRUE,
      nameStyle = "{concept_name}",
      name = NULL
    )
    
    cohort |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 6
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id <int> 3, 2, 1, 2, 3, 1, 3, 2, 1, 2, 3, 1, 3, 3, 3, 1, 1…
    #> $ subject_id           <int> 1, 6, 7, 9, 10, 12, 14, 15, 17, 20, 21, 22, 23, 2…
    #> $ cohort_start_date    <date> 2004-08-15, 2012-07-24, 2013-06-10, 2017-11-04, …
    #> $ cohort_end_date      <date> 2005-04-10, 2012-08-10, 2013-08-26, 2018-02-24, …
    #> $ `36567_simvastatin`  <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ `161_acetaminophen`  <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…

### daysExposed

This argument set to TRUE will add a column specifying the time in days a person has been exposed to the drug of interest. Take note that `gapEra` and `restrictIncident` will be taken into account for this calculation:

  1. **Drug eras:** exposed time will be based on drug eras according to `gapEra`.

  2. **Incident exposures:** if `restrictIncident = TRUE`, exposed time will consider only those drug exposures starting after indexDate, while if `restrictIncident = FALSE`, exposures that started before indexDate and ended afterwards will also be taken into account.




The subfunction to get only this information is `[addDaysExposed()](../reference/addDaysExposed.html)`.

### daysPrescribed

Similarly to the previous one, this argument adds a column with the number of days the individual is prescribed with the drug of interest, if set to TRUE. This number is calculated by adding up the days for all prescriptions that contribute to the analysis. In this case, `restrictIncident` will influence the calculation as follows: if set to TRUE, drug prescriptions will only be counted if happening after index date; if FALSE, all prescriptions will contribute to the sum.

The subfunction to get only this information is `[addDaysPrescribed()](../reference/addDaysPrescribed.html)`.

### timeToExposure

If set to TRUE, a column will be added that shows the number of days until the first exposure occurring within the considered time window. Notice that the value of `restrictIncident` will be taken into account: if TRUE, the time to the first incident exposure during the time interval is measured; otherwise, exposures that start before the `indexDate` and end afterwards will be considered (in these cases, time to exposure is 0).

The subfunction to get only this information is `[addTimeToExposure()](../reference/addTimeToExposure.html)`.

### initialExposureDuration

This argument will add a column with information on the number of days of the first prescription of the drug. If `restrictIncident = TRUE`, this first drug exposure record after index date will be selected. Otherwise, the first record ever will be the one contributing this number.

The subfunction to get only this information is `[addInitialExposureDuration()](../reference/addInitialExposureDuration.html)`.

### initialQuantity and cumulativeQuantity

These, if TRUE, will add a column each specifying which was the initial quantity prescribed at the start of the first exposure considered (`initialQuantity`), and the cumulative quantity taken throughout the exposures in the considered time-window (`cumulativeQuantity`).

Quantities are measured at conceptSet level not ingredient. Notice that for both measures `restrictIncident` is considered, while `gapEra` is used for the `cumulative quantity`.

The subfunctions to get this information are `[addInitialQuantity()](../reference/addInitialQuantity.html)` and `[addCumulativeQuantity()](../reference/addCumulativeQuantity.html)` respectively.

### initialDailyDose and cumulativeDose

If `initialDailyDose` is TRUE, a column will be add specifying for each of the ingredients in a conceptSet which was the initial daily dose given. The `cumulativeDose` will measure for each ingredient the total dose taken throughout the exposures considered in the time-window. Recall that `restrictIncident` is considered in these calculations, and that the cumulative dose also considers `gapEra`.

The subfunctions to get this information are `[addInitialDailyDose()](../reference/addInitialDailyDose.html)` and `[addCumulativeDose()](../reference/addCumulativeDose.html)` respectively.

### addDrugUtilisation()

All the explained **`add`** functions are subfunctions of the more comprehensive **`[addDrugUtilisation()](../reference/addDrugUtilisation.html)`**. This broader function computes multiple drug utilization metrics.
    
    
    [addDrugUtilisation](../reference/addDrugUtilisation.html)(
      cohort,
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      ingredientConceptId = NULL,
      conceptSet = NULL,
      restrictIncident = TRUE,
      gapEra = 1,
      numberExposures = TRUE,
      numberEras = TRUE,
      daysExposed = TRUE,
      daysPrescribed = TRUE,
      timeToExposure = TRUE,
      initialExposureDuration = TRUE,
      initialQuantity = TRUE,
      cumulativeQuantity = TRUE,
      initialDailyDose = TRUE,
      cumulativeDose = TRUE,
      nameStyle = "{value}_{concept_name}_{ingredient}",
      name = NULL
    )

  * Using `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` is recommended when multiple parameters are needed, as it is more computationally efficient than chaining the different subfunctions.

  * If `conceptSet` is NULL, it will be produced from descendants of given ingredients.

  * `nameStyle` argument allows customisation of the names of the new columns added by the function, following the glue package style.

  * By default it returns a temporal table, but if `name` is not NULL a permanent table with the defined name will be computed in the database.




### Use case

In what follows we create a permanent table “drug_utilisation_example” in the database with the information on dosage and quantity of the ingredients 1125315 (acetaminophen) and 1503297 (metformin). We are interested in exposures happening from cohort end date, until the end of the patient’s observation data. Additionally, we define an exposure era using a gap of 7 days, and we only consider incident exposures during that time.
    
    
    cdm$drug_utilisation_example <- cdm$cohort1 |>
      # add end of current observation date with the package PatientProfiels
      PatientProfiles::[addFutureObservation](https://darwin-eu.github.io/PatientProfiles/reference/addFutureObservation.html)(futureObservationType = "date") |>
      # add the targeted drug utilisation measures
      [addDrugUtilisation](../reference/addDrugUtilisation.html)(
        indexDate = "cohort_end_date",
        censorDate = "future_observation",
        ingredientConceptId = [c](https://rdrr.io/r/base/c.html)(1125315, 1503297),
        conceptSet = NULL,
        restrictIncident = TRUE,
        gapEra = 7,
        numberExposures = FALSE,
        numberEras = FALSE,
        daysExposed = FALSE,
        daysPrescribed = FALSE,
        timeToExposure = FALSE,
        initialExposureDuration = FALSE,
        initialQuantity = TRUE,
        cumulativeQuantity = TRUE,
        initialDailyDose = TRUE,
        cumulativeDose = TRUE,
        nameStyle = "{value}_{concept_name}_{ingredient}",
        name = "drug_utilisation_example"
      )
    
    cdm$drug_utilisation_example |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 13
    #> Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #> $ cohort_definition_id                                                <int> 3,…
    #> $ subject_id                                                          <int> 1,…
    #> $ cohort_start_date                                                   <date> 2…
    #> $ cohort_end_date                                                     <date> 2…
    #> $ future_observation                                                  <date> 2…
    #> $ cumulative_quantity_ingredient_1503297_descendants                  <dbl> 0,…
    #> $ cumulative_quantity_ingredient_1125315_descendants                  <dbl> 0,…
    #> $ initial_quantity_ingredient_1503297_descendants                     <dbl> 0,…
    #> $ initial_quantity_ingredient_1125315_descendants                     <dbl> 0,…
    #> $ cumulative_dose_milligram_ingredient_1125315_descendants_1125315    <dbl> 0,…
    #> $ initial_daily_dose_milligram_ingredient_1125315_descendants_1125315 <dbl> 0,…
    #> $ cumulative_dose_milligram_ingredient_1503297_descendants_1503297    <dbl> 0,…
    #> $ initial_daily_dose_milligram_ingredient_1503297_descendants_1503297 <dbl> 0,…

## Summarise drug utilisation information

The information given by `[addDrugUtilisation()](../reference/addDrugUtilisation.html)` or its sub-functions is at patient level. If we are interested in aggregated estimates for these measure we can use `[summariseDrugUtilisation()](../reference/summariseDrugUtilisation.html)`.

### summariseDrugUtilisation()

This function will provide the desired estimates (set in the argument `estimates`) of the targeted drug utilisation measures. Similar to `[addDrugUtilisation()](../reference/addDrugUtilisation.html)`, by setting TRUE or FALSE each of the drug utilisation measures, the user can choose which measures to obtain.
    
    
    duResults <- [summariseDrugUtilisation](../reference/summariseDrugUtilisation.html)(
      cohort = cdm$cohort1,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      estimates = [c](https://rdrr.io/r/base/c.html)(
        "q25", "median", "q75", "mean", "sd", "count_missing",
        "percentage_missing"
      ),
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
      ingredientConceptId = [c](https://rdrr.io/r/base/c.html)(1125315, 1503297),
      conceptSet = NULL,
      restrictIncident = TRUE,
      gapEra = 7,
      numberExposures = TRUE,
      numberEras = TRUE,
      daysExposed = TRUE,
      daysPrescribed = TRUE,
      timeToExposure = TRUE,
      initialExposureDuration = TRUE,
      initialQuantity = TRUE,
      cumulativeQuantity = TRUE,
      initialDailyDose = TRUE,
      cumulativeDose = TRUE
    )
    
    duResults |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 426
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "cohort_1", "cohort_1", "cohort_1", "cohort_1", "coho…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "number records", "number subjects", "number exposure…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "count", "count", "q25", "median", "q75", "mean", "sd…
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "66", "66", "0", "0", "0", "0.196969696969697", "0.50…
    #> $ additional_name  <chr> "overall", "overall", "concept_set", "concept_set", "…
    #> $ additional_level <chr> "overall", "overall", "ingredient_1503297_descendants…

As seen below, the result of this function is a `summarised_result` object. For more information on these class of objects see `omopgenerics` package.

Additionally, the `strata` argument will provide the estimates for different stratifications defined by columns in the cohort. For instance, we can add a column indicating the sex, and another indicating if the subject is older than 50, and use those to stratify by sex and age, together and separately as follows:
    
    
    duResults <- cdm$cohort1 |>
      # add age and sex
      PatientProfiles::[addDemographics](https://darwin-eu.github.io/PatientProfiles/reference/addDemographics.html)(
        age = TRUE,
        ageGroup = [list](https://rdrr.io/r/base/list.html)("<=50" = [c](https://rdrr.io/r/base/c.html)(0, 50), ">50" = [c](https://rdrr.io/r/base/c.html)(51, 150)),
        sex = TRUE,
        priorObservation = FALSE,
        futureObservation = FALSE
      ) |>
      # drug utilisation
      [summariseDrugUtilisation](../reference/summariseDrugUtilisation.html)(
        strata = [list](https://rdrr.io/r/base/list.html)("age_group", "sex", [c](https://rdrr.io/r/base/c.html)("age_group", "sex")),
        estimates = [c](https://rdrr.io/r/base/c.html)("mean", "sd", "count_missing", "percentage_missing"),
        indexDate = "cohort_start_date",
        censorDate = "cohort_end_date",
        ingredientConceptId = [c](https://rdrr.io/r/base/c.html)(1125315, 1503297),
        conceptSet = NULL,
        restrictIncident = TRUE,
        gapEra = 7,
        numberExposures = TRUE,
        numberEras = TRUE,
        daysExposed = TRUE,
        daysPrescribed = TRUE,
        timeToExposure = TRUE,
        initialExposureDuration = TRUE,
        initialQuantity = TRUE,
        cumulativeQuantity = TRUE,
        initialDailyDose = TRUE,
        cumulativeDose = TRUE
      )
    
    duResults |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1,968
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "cohort_1", "cohort_1", "cohort_1", "cohort_1", "coho…
    #> $ strata_name      <chr> "age_group", "age_group", "age_group", "age_group", "…
    #> $ strata_level     <chr> "<=50", "<=50", "<=50", "<=50", "<=50", "<=50", "<=50…
    #> $ variable_name    <chr> "number records", "number subjects", "number exposure…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "count", "count", "mean", "sd", "count_missing", "per…
    #> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "integer"…
    #> $ estimate_value   <chr> "63", "63", "0.158730158730159", "0.447442524921401",…
    #> $ additional_name  <chr> "overall", "overall", "concept_set", "concept_set", "…
    #> $ additional_level <chr> "overall", "overall", "ingredient_1503297_descendants…

The estimates obtained in this last part correspond to the mean (`mean`) and standard deviation (`sd`) of those that had information on dose and quantity, and the number (`count_missing`) (and percentage (`percentage_missing`)) of subjects with missing information.

### tableDrugUtilisation()

Results from `[summariseDrugUtilisation()](../reference/summariseDrugUtilisation.html)` can be nicely visualised in a tabular format using the function `[tableDrugUtilisation()](../reference/tableDrugUtilisation.html)`.
    
    
    [tableDrugUtilisation](../reference/tableDrugUtilisation.html)(duResults)
    #> Warning: cdm_name, cohort_name, age_group, sex, variable_level, censor_date,
    #> cohort_table_name, gap_era, index_date, and restrict_incident are missing in
    #> `columnOrder`, will be added last.
    #> ℹ <median> (<q25> - <q75>) has not been formatted.

Concept set | Ingredient | Variable name | Estimate name |  CDM name  
---|---|---|---|---  
DUS MOCK  
cohort_1; <=50; overall  
overall | overall | number records | N | 63  
|  | number subjects | N | 63  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.16 (0.45)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.16 (0.51)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 55 (87.30 %)  
|  |  | Mean (SD) | 800.62 (1,209.49)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 56 (88.89 %)  
|  |  | Mean (SD) | 108.71 (105.41)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5.79 (17.21)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3.59 (13.36)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2.56 (11.06)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5.16 (15.96)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 56 (88.89 %)  
|  |  | Mean (SD) | 170.00 (120.53)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 55 (87.30 %)  
|  |  | Mean (SD) | 500.25 (563.30)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.13 (0.34)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.14 (0.43)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 54.08 (210.81)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 53.41 (333.70)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 56.22 (215.84)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 55.51 (335.44)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3,599.55 (18,139.68)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 207.39 (1,574.38)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3,430.17 (10,342.89)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 282.65 (1,900.60)  
cohort_1; >50; overall  
overall | overall | number records | N | 3  
|  | number subjects | N | 3  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 1.00 (1.00)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 1 (33.33 %)  
|  |  | Mean (SD) | 411.50 (309.01)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 3 (100.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 23.67 (40.13)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 10.33 (17.04)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 3 (100.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 1 (33.33 %)  
|  |  | Mean (SD) | 139.50 (58.69)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 1.00 (1.00)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 86.00 (128.73)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 86.00 (128.73)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5,756.07 (9,863.94)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 29.32 (46.44)  
cohort_1; <=50; Female  
overall | overall | number records | N | 28  
|  | number subjects | N | 28  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.11 (0.42)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.25 (0.65)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 26 (92.86 %)  
|  |  | Mean (SD) | 285.50 (38.89)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 23 (82.14 %)  
|  |  | Mean (SD) | 104.00 (126.39)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2.32 (9.76)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 6.82 (19.20)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.86 (16.12)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 1.25 (4.64)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 23 (82.14 %)  
|  |  | Mean (SD) | 119.00 (100.79)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 26 (92.86 %)  
|  |  | Mean (SD) | 101.50 (112.43)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.07 (0.26)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.21 (0.50)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12.07 (59.71)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 17.71 (61.18)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 15.64 (78.57)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 22.43 (82.12)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5,063.67 (22,769.17)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 465.44 (2,359.55)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 1,853.87 (7,431.16)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 26.32 (128.89)  
cohort_1; <=50; Male  
overall | overall | number records | N | 35  
|  | number subjects | N | 35  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.20 (0.47)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.09 (0.37)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 29 (82.86 %)  
|  |  | Mean (SD) | 972.33 (1,380.64)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 33 (94.29 %)  
|  |  | Mean (SD) | 120.50 (48.79)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.57 (21.13)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 1.00 (4.17)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.71 (3.01)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.29 (20.61)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 33 (94.29 %)  
|  |  | Mean (SD) | 297.50 (31.82)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 29 (82.86 %)  
|  |  | Mean (SD) | 633.17 (597.41)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.17 (0.38)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.09 (0.37)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 87.69 (274.93)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 81.97 (445.20)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 88.69 (278.58)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 81.97 (445.20)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,428.25 (13,607.07)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.95 (3.95)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4,691.21 (12,146.47)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 487.71 (2,544.90)  
cohort_1; >50; Female  
overall | overall | number records | N | 1  
|  | number subjects | N | 1  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 1 (100.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 1 (100.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | -  
cohort_1; >50; Male  
overall | overall | number records | N | 2  
|  | number subjects | N | 2  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.50 (0.71)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 1 (50.00 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 2 (100.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.50 (0.71)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.50 (0.71)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 2 (100.00 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 1 (50.00 %)  
|  |  | Mean (SD) | -  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.50 (0.71)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12.00 (16.97)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12.00 (16.97)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 61.22 (86.58)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2.55 (3.61)  
cohort_1; overall; overall  
overall | overall | number records | N | 66  
|  | number subjects | N | 66  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.20 (0.50)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.15 (0.50)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 56 (84.85 %)  
|  |  | Mean (SD) | 722.80 (1,084.12)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 59 (89.39 %)  
|  |  | Mean (SD) | 108.71 (105.41)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 6.61 (18.60)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3.42 (13.07)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2.44 (10.82)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5.39 (15.91)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 59 (89.39 %)  
|  |  | Mean (SD) | 170.00 (120.53)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 56 (84.85 %)  
|  |  | Mean (SD) | 428.10 (519.91)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.17 (0.41)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.14 (0.43)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 55.53 (207.23)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 50.98 (326.10)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 57.58 (212.10)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 52.98 (327.81)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3,435.93 (17,732.23)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 197.96 (1,538.24)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3,535.89 (10,260.13)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 271.13 (1,857.00)  
cohort_1; overall; Female  
overall | overall | number records | N | 29  
|  | number subjects | N | 29  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.17 (0.54)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.24 (0.64)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 26 (89.66 %)  
|  |  | Mean (SD) | 400.33 (200.79)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 24 (82.76 %)  
|  |  | Mean (SD) | 104.00 (126.39)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.66 (15.81)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 6.59 (18.89)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.69 (15.85)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2.24 (7.02)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 24 (82.76 %)  
|  |  | Mean (SD) | 119.00 (100.79)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 26 (89.66 %)  
|  |  | Mean (SD) | 128.00 (91.80)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.14 (0.44)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.21 (0.49)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 19.72 (71.67)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 17.10 (60.17)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 23.17 (87.16)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 21.66 (80.75)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4,889.06 (22,378.64)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 449.39 (2,318.64)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,381.18 (7,830.29)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 28.27 (127.00)  
cohort_1; overall; Male  
overall | overall | number records | N | 37  
|  | number subjects | N | 37  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.22 (0.48)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.08 (0.36)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 30 (81.08 %)  
|  |  | Mean (SD) | 861.00 (1,294.31)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 35 (94.59 %)  
|  |  | Mean (SD) | 120.50 (48.79)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.14 (20.62)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.95 (4.05)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.68 (2.93)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 7.86 (20.11)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 35 (94.59 %)  
|  |  | Mean (SD) | 297.50 (31.82)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 30 (81.08 %)  
|  |  | Mean (SD) | 556.71 (581.66)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.19 (0.40)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.08 (0.36)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 83.59 (267.77)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 77.54 (433.06)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 84.54 (271.32)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 77.54 (433.06)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,297.00 (13,235.41)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.90 (3.85)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4,440.94 (11,851.88)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 461.48 (2,475.70)  
cohort_2; <=50; overall  
overall | overall | number records | N | 51  
|  | number subjects | N | 51  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.14 (0.49)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.24 (0.47)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 46 (90.20 %)  
|  |  | Mean (SD) | 178.60 (255.32)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 40 (78.43 %)  
|  |  | Mean (SD) | 436.91 (723.62)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.41 (13.63)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 9.22 (19.40)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.43 (17.85)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3.53 (11.97)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 40 (78.43 %)  
|  |  | Mean (SD) | 725.55 (1,102.02)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 46 (90.20 %)  
|  |  | Mean (SD) | 183.00 (168.31)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.10 (0.30)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.22 (0.42)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 21.47 (99.72)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 86.76 (379.84)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 33.39 (181.83)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 87.08 (379.81)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 25,634.49 (85,811.30)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,624.79 (15,813.75)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,083.35 (6,610.92)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 42.88 (236.52)  
cohort_2; <=50; Female  
overall | overall | number records | N | 27  
|  | number subjects | N | 27  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.11 (0.32)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.22 (0.42)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 24 (88.89 %)  
|  |  | Mean (SD) | 205.00 (329.31)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 21 (77.78 %)  
|  |  | Mean (SD) | 150.33 (220.69)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.81 (14.04)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.89 (19.38)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.89 (19.38)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.81 (14.04)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 21 (77.78 %)  
|  |  | Mean (SD) | 780.33 (1,277.84)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 24 (88.89 %)  
|  |  | Mean (SD) | 129.67 (103.18)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.11 (0.32)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.22 (0.42)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12.85 (46.63)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 49.41 (240.14)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12.85 (46.63)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 49.41 (240.14)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 21,126.45 (71,475.11)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4,868.94 (21,672.36)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,005.59 (5,919.70)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 69.68 (320.44)  
cohort_2; <=50; Male  
overall | overall | number records | N | 24  
|  | number subjects | N | 24  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.17 (0.64)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.25 (0.53)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 22 (91.67 %)  
|  |  | Mean (SD) | 139.00 (196.58)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 19 (79.17 %)  
|  |  | Mean (SD) | 780.80 (988.51)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3.96 (13.43)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 9.58 (19.83)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 7.92 (16.35)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2.08 (9.20)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 19 (79.17 %)  
|  |  | Mean (SD) | 659.80 (992.52)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 22 (91.67 %)  
|  |  | Mean (SD) | 263.00 (265.87)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.08 (0.28)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.21 (0.41)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 31.17 (137.75)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 128.79 (494.95)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 56.50 (261.47)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 129.46 (494.84)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 30,706.03 (100,906.10)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 100.11 (349.98)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,170.83 (7,441.80)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12.73 (61.20)  
cohort_2; overall; overall  
overall | overall | number records | N | 51  
|  | number subjects | N | 51  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.14 (0.49)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.24 (0.47)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 46 (90.20 %)  
|  |  | Mean (SD) | 178.60 (255.32)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 40 (78.43 %)  
|  |  | Mean (SD) | 436.91 (723.62)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.41 (13.63)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 9.22 (19.40)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.43 (17.85)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3.53 (11.97)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 40 (78.43 %)  
|  |  | Mean (SD) | 725.55 (1,102.02)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 46 (90.20 %)  
|  |  | Mean (SD) | 183.00 (168.31)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.10 (0.30)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.22 (0.42)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 21.47 (99.72)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 86.76 (379.84)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 33.39 (181.83)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 87.08 (379.81)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 25,634.49 (85,811.30)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,624.79 (15,813.75)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,083.35 (6,610.92)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 42.88 (236.52)  
cohort_2; overall; Female  
overall | overall | number records | N | 27  
|  | number subjects | N | 27  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.11 (0.32)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.22 (0.42)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 24 (88.89 %)  
|  |  | Mean (SD) | 205.00 (329.31)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 21 (77.78 %)  
|  |  | Mean (SD) | 150.33 (220.69)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.81 (14.04)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.89 (19.38)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.89 (19.38)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.81 (14.04)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 21 (77.78 %)  
|  |  | Mean (SD) | 780.33 (1,277.84)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 24 (88.89 %)  
|  |  | Mean (SD) | 129.67 (103.18)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.11 (0.32)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.22 (0.42)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12.85 (46.63)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 49.41 (240.14)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12.85 (46.63)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 49.41 (240.14)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 21,126.45 (71,475.11)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4,868.94 (21,672.36)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,005.59 (5,919.70)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 69.68 (320.44)  
cohort_2; overall; Male  
overall | overall | number records | N | 24  
|  | number subjects | N | 24  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.17 (0.64)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.25 (0.53)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 22 (91.67 %)  
|  |  | Mean (SD) | 139.00 (196.58)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 19 (79.17 %)  
|  |  | Mean (SD) | 780.80 (988.51)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3.96 (13.43)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 9.58 (19.83)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 7.92 (16.35)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2.08 (9.20)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 19 (79.17 %)  
|  |  | Mean (SD) | 659.80 (992.52)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 22 (91.67 %)  
|  |  | Mean (SD) | 263.00 (265.87)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.08 (0.28)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.21 (0.41)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 31.17 (137.75)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 128.79 (494.95)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 56.50 (261.47)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 129.46 (494.84)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 30,706.03 (100,906.10)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 100.11 (349.98)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 2,170.83 (7,441.80)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12.73 (61.20)  
cohort_3; <=50; overall  
overall | overall | number records | N | 71  
|  | number subjects | N | 71  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.24 (0.55)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.24 (0.52)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 58 (81.69 %)  
|  |  | Mean (SD) | 1,281.31 (2,611.47)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 57 (80.28 %)  
|  |  | Mean (SD) | 812.64 (990.41)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 9.38 (21.92)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 6.83 (22.48)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4.86 (14.04)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.59 (20.89)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 57 (80.28 %)  
|  |  | Mean (SD) | 549.86 (623.05)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 58 (81.69 %)  
|  |  | Mean (SD) | 604.00 (1,050.42)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.20 (0.43)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.20 (0.40)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 89.31 (329.54)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 89.37 (295.29)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 100.49 (379.93)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 94.63 (307.04)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 12,536.55 (46,614.74)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 289.25 (1,215.14)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5,384.64 (14,803.58)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 380.78 (1,901.85)  
cohort_3; >50; overall  
overall | overall | number records | N | 12  
|  | number subjects | N | 12  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.08 (0.29)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.33 (0.65)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 11 (91.67 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 9 (75.00 %)  
|  |  | Mean (SD) | 78.67 (124.33)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.42 (1.44)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 15.92 (51.75)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.42 (25.85)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.42 (1.44)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 9 (75.00 %)  
|  |  | Mean (SD) | 297.33 (480.46)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 11 (91.67 %)  
|  |  | Mean (SD) | -  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.08 (0.29)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.33 (0.65)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 66.25 (229.50)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 76.75 (263.98)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 66.25 (229.50)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 76.75 (263.98)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5,180.08 (17,438.09)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 38.85 (114.76)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 162.86 (564.15)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.20 (0.71)  
cohort_3; <=50; Female  
overall | overall | number records | N | 33  
|  | number subjects | N | 33  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.24 (0.50)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.15 (0.36)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 26 (78.79 %)  
|  |  | Mean (SD) | 1,976.43 (3,464.24)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 28 (84.85 %)  
|  |  | Mean (SD) | 1,047.60 (1,292.92)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.97 (18.47)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3.18 (9.59)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3.18 (9.59)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.94 (18.40)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 28 (84.85 %)  
|  |  | Mean (SD) | 309.40 (339.47)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 26 (78.79 %)  
|  |  | Mean (SD) | 535.29 (600.76)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.21 (0.42)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.15 (0.36)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 106.03 (327.99)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 45.85 (161.64)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 117.42 (363.26)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 45.85 (161.64)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 14,435.20 (54,907.07)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 231.40 (764.49)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4,669.78 (11,540.00)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 91.37 (284.10)  
cohort_3; <=50; Male  
overall | overall | number records | N | 38  
|  | number subjects | N | 38  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.24 (0.59)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.32 (0.62)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 32 (84.21 %)  
|  |  | Mean (SD) | 470.33 (707.54)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 29 (76.32 %)  
|  |  | Mean (SD) | 682.11 (839.34)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 9.74 (24.77)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 10.00 (29.22)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 6.32 (16.99)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.29 (23.08)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 29 (76.32 %)  
|  |  | Mean (SD) | 683.44 (719.01)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 32 (84.21 %)  
|  |  | Mean (SD) | 684.17 (1,483.47)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.18 (0.46)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.24 (0.43)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 74.79 (334.57)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 127.16 (373.12)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 85.79 (398.10)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 137.00 (389.61)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 10,887.73 (38,698.41)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 339.49 (1,510.79)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 6,005.45 (17,279.29)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 632.10 (2,575.59)  
cohort_3; >50; Female  
overall | overall | number records | N | 6  
|  | number subjects | N | 6  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.50 (0.84)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 6 (100.00 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 4 (66.67 %)  
|  |  | Mean (SD) | 118.00 (147.08)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 30.17 (73.40)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 15.17 (36.66)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 4 (66.67 %)  
|  |  | Mean (SD) | 441.00 (581.24)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 6 (100.00 %)  
|  |  | Mean (SD) | -  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.50 (0.84)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 152.83 (373.38)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 152.83 (373.38)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 10,093.49 (24,710.83)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 11.03 (21.16)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.00 (0.00)  
cohort_3; >50; Male  
overall | overall | number records | N | 6  
|  | number subjects | N | 6  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.17 (0.41)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.17 (0.41)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 5 (83.33 %)  
|  |  | Mean (SD) | -  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 5 (83.33 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.83 (2.04)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 1.67 (4.08)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 1.67 (4.08)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.83 (2.04)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 5 (83.33 %)  
|  |  | Mean (SD) | -  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 5 (83.33 %)  
|  |  | Mean (SD) | -  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.17 (0.41)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.17 (0.41)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 132.50 (324.56)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.67 (1.63)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 132.50 (324.56)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.67 (1.63)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 266.67 (653.20)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 66.67 (163.30)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 325.71 (797.83)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.41 (1.00)  
cohort_3; overall; overall  
overall | overall | number records | N | 83  
|  | number subjects | N | 83  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.22 (0.52)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.25 (0.54)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 69 (83.13 %)  
|  |  | Mean (SD) | 1,235.36 (2,514.90)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 66 (79.52 %)  
|  |  | Mean (SD) | 683.12 (939.21)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.08 (20.50)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.14 (28.30)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5.37 (16.11)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 7.41 (19.53)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 66 (79.52 %)  
|  |  | Mean (SD) | 505.29 (595.07)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 69 (83.13 %)  
|  |  | Mean (SD) | 633.50 (1,015.23)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.18 (0.42)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.22 (0.44)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 85.98 (315.96)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 87.54 (289.49)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 95.54 (361.16)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 92.05 (299.78)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 11,472.97 (43,617.78)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 253.05 (1,126.99)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 4,629.69 (13,803.33)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 325.75 (1,762.34)  
cohort_3; overall; Female  
overall | overall | number records | N | 39  
|  | number subjects | N | 39  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.21 (0.47)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.21 (0.47)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 32 (82.05 %)  
|  |  | Mean (SD) | 1,976.43 (3,464.24)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 32 (82.05 %)  
|  |  | Mean (SD) | 782.00 (1,150.56)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 7.59 (17.27)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 7.33 (29.73)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5.03 (16.54)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 7.56 (17.20)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 32 (82.05 %)  
|  |  | Mean (SD) | 347.00 (370.48)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 32 (82.05 %)  
|  |  | Mean (SD) | 535.29 (600.76)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.18 (0.39)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.21 (0.47)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 89.72 (303.47)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 62.31 (204.63)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 99.36 (336.10)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 62.31 (204.63)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 13,767.25 (51,201.87)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 197.50 (706.19)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 3,951.35 (10,726.51)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 77.32 (262.84)  
cohort_3; overall; Male  
overall | overall | number records | N | 44  
|  | number subjects | N | 44  
ingredient_1503297_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.23 (0.57)  
ingredient_1125315_descendants | overall | number exposures | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.30 (0.59)  
ingredient_1503297_descendants | overall | time to exposure | missing N (%) | 37 (84.09 %)  
|  |  | Mean (SD) | 494.29 (649.00)  
ingredient_1125315_descendants | overall | time to exposure | missing N (%) | 34 (77.27 %)  
|  |  | Mean (SD) | 613.90 (820.20)  
ingredient_1503297_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.52 (23.19)  
ingredient_1125315_descendants | overall | cumulative quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 8.86 (27.30)  
|  | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5.68 (15.91)  
ingredient_1503297_descendants | overall | initial quantity | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 7.27 (21.58)  
ingredient_1125315_descendants | overall | initial exposure duration | missing N (%) | 34 (77.27 %)  
|  |  | Mean (SD) | 616.10 (710.56)  
ingredient_1503297_descendants | overall | initial exposure duration | missing N (%) | 37 (84.09 %)  
|  |  | Mean (SD) | 731.71 (1,360.05)  
|  | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.18 (0.45)  
ingredient_1125315_descendants | overall | number eras | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 0.23 (0.42)  
ingredient_1503297_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 82.66 (330.11)  
ingredient_1125315_descendants | overall | days exposed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 109.91 (348.88)  
ingredient_1503297_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 92.16 (385.86)  
ingredient_1125315_descendants | overall | days prescribed | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 118.41 (364.49)  
| acetaminophen | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 9,439.40 (36,086.67)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 302.29 (1,405.73)  
ingredient_1503297_descendants | metformin | cumulative dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 5,230.94 (16,151.59)  
|  | initial daily dose milligram | missing N (%) | 0 (0.00 %)  
|  |  | Mean (SD) | 545.96 (2,399.19)  
  
## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
