# Columns for the table functions — tableColumns • visOmopResults

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Columns for the table functions

Source: [`R/helperFunctions.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/helperFunctions.R)

`tableColumns.Rd`

Names of the columns that can be used in the input arguments for the table functions.

## Usage
    
    
    tableColumns(result)

## Arguments

result
    

A `<summarised_result>` object.

## Value

A character vector of supported columns for tables.

## Examples
    
    
    result <- [mockSummarisedResult](mockSummarisedResult.html)()
    tableColumns(result)
    #> [1] "cdm_name"       "cohort_name"    "age_group"      "sex"           
    #> [5] "variable_name"  "variable_level" "estimate_name" 
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
