# This function is used to summarise the dose utilisation table over multiple cohorts. — summariseDrugUtilisation • DrugUtilisation

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

# This function is used to summarise the dose utilisation table over multiple cohorts.

Source: [`R/summariseDrugUtilisation.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/summariseDrugUtilisation.R)

`summariseDrugUtilisation.Rd`

This function is used to summarise the dose utilisation table over multiple cohorts.

## Usage
    
    
    summariseDrugUtilisation(
      cohort,
      cohortId = NULL,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      estimates = [c](https://rdrr.io/r/base/c.html)("q25", "median", "q75", "mean", "sd", "count_missing",
        "percentage_missing"),
      ingredientConceptId = NULL,
      conceptSet = NULL,
      indexDate = "cohort_start_date",
      censorDate = "cohort_end_date",
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
      cumulativeDose = TRUE
    )

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

strata
    

A list of variables to stratify results. These variables must have been added as additional columns in the cohort table.

estimates
    

Estimates that we want for the columns.

ingredientConceptId
    

Ingredient OMOP concept that we are interested for the study.

conceptSet
    

List of concepts to be included.

indexDate
    

Name of a column that indicates the date to start the analysis.

censorDate
    

Name of a column that indicates the date to stop the analysis, if NULL end of individuals observation is used.

restrictIncident
    

Whether to include only incident prescriptions in the analysis. If FALSE all prescriptions that overlap with the study period will be included.

gapEra
    

Number of days between two continuous exposures to be considered in the same era.

numberExposures
    

Whether to include 'number_exposures' (number of drug exposure records between indexDate and censorDate).

numberEras
    

Whether to include 'number_eras' (number of continuous exposure episodes between indexDate and censorDate).

daysExposed
    

Whether to include 'days_exposed' (number of days that the individual is in a continuous exposure episode, including allowed treatment gaps, between indexDate and censorDate; sum of the length of the different drug eras).

daysPrescribed
    

Whether to include 'days_prescribed' (sum of the number of days for each prescription that contribute in the analysis).

timeToExposure
    

Whether to include 'time_to_exposure' (number of days between indexDate and the first episode).

initialExposureDuration
    

Whether to include 'initial_exposure_duration' (number of prescribed days of the first drug exposure record).

initialQuantity
    

Whether to include 'initial_quantity' (quantity of the first drug exposure record).

cumulativeQuantity
    

Whether to include 'cumulative_quantity' (sum of the quantity of the different exposures considered in the analysis).

initialDailyDose
    

Whether to include 'initial_daily_dose_{unit}' (daily dose of the first considered prescription).

cumulativeDose
    

Whether to include 'cumulative_dose_{unit}' (sum of the cumulative dose of the analysed drug exposure records).

## Value

A summary of drug utilisation stratified by cohort_name and strata_name

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    cdm <- [generateIngredientCohortSet](generateIngredientCohortSet.html)(cdm = cdm,
                                       ingredient = "acetaminophen",
                                       name = "dus_cohort")
    #> ℹ Subsetting drug_exposure table
    #> ℹ Checking whether any record needs to be dropped.
    #> ℹ Collapsing overlaping records.
    #> ℹ Collapsing records with gapEra = 1 days.
    
    cdm$dus_cohort |>
      summariseDrugUtilisation(ingredientConceptId = 1125315)
    #> # A tibble: 72 × 13
    #>    result_id cdm_name group_name  group_level   strata_name strata_level
    #>        <int> <chr>    <chr>       <chr>         <chr>       <chr>       
    #>  1         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #>  2         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #>  3         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #>  4         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #>  5         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #>  6         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #>  7         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #>  8         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #>  9         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #> 10         1 DUS MOCK cohort_name acetaminophen overall     overall     
    #> # ℹ 62 more rows
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
