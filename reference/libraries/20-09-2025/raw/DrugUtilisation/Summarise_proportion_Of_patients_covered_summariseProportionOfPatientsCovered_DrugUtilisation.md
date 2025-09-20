# Summarise proportion Of patients covered — summariseProportionOfPatientsCovered • DrugUtilisation

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

# Summarise proportion Of patients covered

Source: [`R/summariseProportionOfPatientsCovered.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/summariseProportionOfPatientsCovered.R)

`summariseProportionOfPatientsCovered.Rd`

Gives the proportion of patients still in observation who are in the cohort on any given day following their first cohort entry. This is known as the “proportion of patients covered” (PPC) method for assessing treatment persistence.

## Usage
    
    
    summariseProportionOfPatientsCovered(
      cohort,
      cohortId = NULL,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      followUpDays = NULL
    )

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

strata
    

A list of variables to stratify results. These variables must have been added as additional columns in the cohort table.

followUpDays
    

Number of days to follow up individuals for. If NULL the maximum amount of days from an individuals first cohort start date to their last cohort end date will be used

## Value

A summarised result

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)(numberIndividuals = 100)
    
    result <- cdm$cohort1 |>
      summariseProportionOfPatientsCovered(followUpDays = 365)
    #> Getting PPC for cohort cohort_1
    #> Collecting cohort into memory
    #> Geting PPC over 365 days following first cohort entry
    #>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■           258 of 365 days
    #>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  365 of 365 days
    #> Getting PPC for cohort cohort_2
    #> Collecting cohort into memory
    #> Geting PPC over 365 days following first cohort entry
    #>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■           259 of 365 days
    #>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  365 of 365 days
    #> Getting PPC for cohort cohort_3
    #> Collecting cohort into memory
    #> Geting PPC over 365 days following first cohort entry
    #>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■           258 of 365 days
    #>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  365 of 365 days
    
    [tidy](https://generics.r-lib.org/reference/tidy.html)(result)
    #> # A tibble: 1,098 × 11
    #>    cdm_name cohort_name variable_name variable_level time  outcome_count
    #>    <chr>    <chr>       <chr>         <chr>          <chr>         <int>
    #>  1 DUS MOCK cohort_1    overall       overall        0                26
    #>  2 DUS MOCK cohort_1    overall       overall        1                26
    #>  3 DUS MOCK cohort_1    overall       overall        2                26
    #>  4 DUS MOCK cohort_1    overall       overall        3                26
    #>  5 DUS MOCK cohort_1    overall       overall        4                25
    #>  6 DUS MOCK cohort_1    overall       overall        5                25
    #>  7 DUS MOCK cohort_1    overall       overall        6                25
    #>  8 DUS MOCK cohort_1    overall       overall        7                25
    #>  9 DUS MOCK cohort_1    overall       overall        8                25
    #> 10 DUS MOCK cohort_1    overall       overall        9                25
    #> # ℹ 1,088 more rows
    #> # ℹ 5 more variables: denominator_count <int>, ppc <dbl>, ppc_lower <dbl>,
    #> #   ppc_upper <dbl>, cohort_table_name <chr>
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
