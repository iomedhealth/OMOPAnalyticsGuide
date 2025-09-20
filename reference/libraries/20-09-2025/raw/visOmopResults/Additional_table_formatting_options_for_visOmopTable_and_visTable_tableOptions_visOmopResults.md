# Additional table formatting options for visOmopTable() and visTable() — tableOptions • visOmopResults

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Additional table formatting options for `visOmopTable()` and `visTable()`

Source: [`R/helperFunctions.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/helperFunctions.R)

`tableOptions.Rd`

This function provides a list of allowed inputs for the `.option` argument in `[visOmopTable()](visOmopTable.html)` and `[visTable()](visTable.html)`, and their corresponding default values.

## Usage
    
    
    tableOptions()

## Value

A named list of default options for table customisation.

## Examples
    
    
    tableOptions()
    #> $decimals
    #>    integer percentage    numeric proportion 
    #>          0          2          2          2 
    #> 
    #> $decimalMark
    #> [1] "."
    #> 
    #> $bigMark
    #> [1] ","
    #> 
    #> $keepNotFormatted
    #> [1] TRUE
    #> 
    #> $useFormatOrder
    #> [1] TRUE
    #> 
    #> $delim
    #> [1] "\n"
    #> 
    #> $includeHeaderName
    #> [1] TRUE
    #> 
    #> $includeHeaderKey
    #> [1] TRUE
    #> 
    #> $na
    #> [1] "-"
    #> 
    #> $title
    #> NULL
    #> 
    #> $subtitle
    #> NULL
    #> 
    #> $caption
    #> NULL
    #> 
    #> $groupAsColumn
    #> [1] FALSE
    #> 
    #> $groupOrder
    #> NULL
    #> 
    #> $merge
    #> [1] "all_columns"
    #> 
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
