# Function to create a tibble with the patterns from current drug strength table — patternTable • DrugUtilisation

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

# Function to create a tibble with the patterns from current drug strength table

Source: [`R/pattern.R`](https://github.com/darwin-eu/DrugUtilisation/blob/v1.0.4/R/pattern.R)

`patternTable.Rd`

Function to create a tibble with the patterns from current drug strength table

## Usage
    
    
    patternTable(cdm)

## Arguments

cdm
    

A `cdm_reference` object.

## Value

The function creates a tibble with the different patterns found in the table, plus a column of potentially valid and invalid combinations.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    cdm <- [mockDrugUtilisation](mockDrugUtilisation.html)()
    
    patternTable(cdm)
    #> # A tibble: 5 × 12
    #>   pattern_id formula_name            validity number_concepts number_ingredients
    #>        <dbl> <chr>                   <chr>              <dbl>              <dbl>
    #> 1          9 fixed amount formulati… pattern…               7                  4
    #> 2         18 concentration formulat… pattern…               1                  1
    #> 3         24 concentration formulat… pattern…               1                  1
    #> 4         40 concentration formulat… pattern…               1                  1
    #> 5         NA NA                      no patt…               4                  4
    #> # ℹ 7 more variables: number_records <dbl>, amount_numeric <dbl>,
    #> #   amount_unit_concept_id <dbl>, numerator_numeric <dbl>,
    #> #   numerator_unit_concept_id <dbl>, denominator_numeric <dbl>,
    #> #   denominator_unit_concept_id <dbl>
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
