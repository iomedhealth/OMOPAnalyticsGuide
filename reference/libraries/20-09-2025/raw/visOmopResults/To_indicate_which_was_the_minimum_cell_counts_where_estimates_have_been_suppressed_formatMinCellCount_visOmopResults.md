# To indicate which was the minimum cell counts where estimates have been suppressed. — formatMinCellCount • visOmopResults

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# To indicate which was the minimum cell counts where estimates have been suppressed.

Source: [`R/formatEstimateValue.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/formatEstimateValue.R)

`formatMinCellCount.Rd`

To indicate which was the minimum cell counts where estimates have been suppressed.

## Usage
    
    
    formatMinCellCount(result)

## Arguments

result
    

A `<summarised_result>` object.

## Examples
    
    
    result <- [mockSummarisedResult](mockSummarisedResult.html)()
    result |> formatMinCellCount()
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
