# Check coverage of daily dose computation in a sample of the cdm for selected concept sets and ingredient — summariseDoseCoverage • DrugUtilisation

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

# Check coverage of daily dose computation in a sample of the cdm for selected concept sets and ingredient

Source: [`R/dailyDose.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/dailyDose.R)

`summariseDoseCoverage.Rd`

Check coverage of daily dose computation in a sample of the cdm for selected concept sets and ingredient

## Usage
    
    
    summariseDoseCoverage(
      cdm,
      ingredientConceptId,
      estimates = [c](https://rdrr.io/r/base/c.html)("count_missing", "percentage_missing", "mean", "sd", "q25", "median",
        "q75"),
      sampleSize = NULL
    )

## Arguments

cdm
    

A `cdm_reference` object.

ingredientConceptId
    

Ingredient OMOP concept that we are interested for the study.

estimates
    

Estimates to obtain.

sampleSize
    

Maximum number of records of an ingredient to estimate dose coverage. If an ingredient has more, a random sample equal to `sampleSize` will be considered. If NULL, all records will be used.

## Value

The function returns information of the coverage of computeDailyDose.R for the selected ingredients and concept sets

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    summariseDoseCoverage(cdm = cdm, ingredientConceptId = 1125315)
    #> ℹ The following estimates will be computed:
    #> • daily_dose: count_missing, percentage_missing, mean, sd, q25, median, q75
    #> ! Table is collected to memory as not all requested estimates are supported on
    #>   the database side
    #> → Start summary of data, at 2025-07-03 14:03:08.642649
    #> ✔ Summary finished, at 2025-07-03 14:03:09.067993
    #> # A tibble: 56 × 13
    #>    result_id cdm_name group_name      group_level   strata_name strata_level
    #>        <int> <chr>    <chr>           <chr>         <chr>       <chr>       
    #>  1         1 DUS MOCK ingredient_name acetaminophen overall     overall     
    #>  2         1 DUS MOCK ingredient_name acetaminophen overall     overall     
    #>  3         1 DUS MOCK ingredient_name acetaminophen overall     overall     
    #>  4         1 DUS MOCK ingredient_name acetaminophen overall     overall     
    #>  5         1 DUS MOCK ingredient_name acetaminophen overall     overall     
    #>  6         1 DUS MOCK ingredient_name acetaminophen overall     overall     
    #>  7         1 DUS MOCK ingredient_name acetaminophen overall     overall     
    #>  8         1 DUS MOCK ingredient_name acetaminophen overall     overall     
    #>  9         1 DUS MOCK ingredient_name acetaminophen unit        milligram   
    #> 10         1 DUS MOCK ingredient_name acetaminophen unit        milligram   
    #> # ℹ 46 more rows
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
