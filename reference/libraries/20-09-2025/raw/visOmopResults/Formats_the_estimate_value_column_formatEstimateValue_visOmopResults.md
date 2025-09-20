# Formats the estimate_value column — formatEstimateValue • visOmopResults

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Formats the estimate_value column

Source: [`R/formatEstimateValue.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/formatEstimateValue.R)

`formatEstimateValue.Rd`

Formats the estimate_value column of `<summarised_result>` object by editing number of decimals, decimal and thousand/millions separator marks.

## Usage
    
    
    formatEstimateValue(
      result,
      decimals = [c](https://rdrr.io/r/base/c.html)(integer = 0, numeric = 2, percentage = 1, proportion = 3),
      decimalMark = ".",
      bigMark = ","
    )

## Arguments

result
    

A `<summarised_result>`.

decimals
    

Number of decimals per estimate type (integer, numeric, percentage, proportion), estimate name, or all estimate values (introduce the number of decimals).

decimalMark
    

Decimal separator mark.

bigMark
    

Thousand and millions separator mark.

## Value

A `<summarised_result>`.

## Examples
    
    
    result <- [mockSummarisedResult](mockSummarisedResult.html)()
    
    result |> formatEstimateValue(decimals = 1)
    #> # A tibble: 126 × 13
    #>    result_id cdm_name group_name  group_level strata_name       strata_level   
    #>        <int> <chr>    <chr>       <chr>       <chr>             <chr>          
    #>  1         1 mock     cohort_name cohort1     overall           overall        
    #>  2         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Male   
    #>  3         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Male  
    #>  4         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Female 
    #>  5         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Female
    #>  6         1 mock     cohort_name cohort1     sex               Male           
    #>  7         1 mock     cohort_name cohort1     sex               Female         
    #>  8         1 mock     cohort_name cohort1     age_group         <40            
    #>  9         1 mock     cohort_name cohort1     age_group         >=40           
    #> 10         1 mock     cohort_name cohort2     overall           overall        
    #> # ℹ 116 more rows
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    result |> formatEstimateValue(decimals = [c](https://rdrr.io/r/base/c.html)(integer = 0, numeric = 1))
    #> # A tibble: 126 × 13
    #>    result_id cdm_name group_name  group_level strata_name       strata_level   
    #>        <int> <chr>    <chr>       <chr>       <chr>             <chr>          
    #>  1         1 mock     cohort_name cohort1     overall           overall        
    #>  2         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Male   
    #>  3         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Male  
    #>  4         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Female 
    #>  5         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Female
    #>  6         1 mock     cohort_name cohort1     sex               Male           
    #>  7         1 mock     cohort_name cohort1     sex               Female         
    #>  8         1 mock     cohort_name cohort1     age_group         <40            
    #>  9         1 mock     cohort_name cohort1     age_group         >=40           
    #> 10         1 mock     cohort_name cohort2     overall           overall        
    #> # ℹ 116 more rows
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    result |>
      formatEstimateValue(decimals = [c](https://rdrr.io/r/base/c.html)(numeric = 1, count = 0))
    #> # A tibble: 126 × 13
    #>    result_id cdm_name group_name  group_level strata_name       strata_level   
    #>        <int> <chr>    <chr>       <chr>       <chr>             <chr>          
    #>  1         1 mock     cohort_name cohort1     overall           overall        
    #>  2         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Male   
    #>  3         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Male  
    #>  4         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Female 
    #>  5         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Female
    #>  6         1 mock     cohort_name cohort1     sex               Male           
    #>  7         1 mock     cohort_name cohort1     sex               Female         
    #>  8         1 mock     cohort_name cohort1     age_group         <40            
    #>  9         1 mock     cohort_name cohort1     age_group         >=40           
    #> 10         1 mock     cohort_name cohort2     overall           overall        
    #> # ℹ 116 more rows
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
