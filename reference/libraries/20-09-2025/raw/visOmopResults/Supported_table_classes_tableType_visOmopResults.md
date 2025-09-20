# Supported table classes — tableType • visOmopResults

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Supported table classes

Source: [`R/helperFunctions.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/helperFunctions.R)

`tableType.Rd`

This function returns the supported table classes that can be used in the `type` argument of `[visOmopTable()](visOmopTable.html)`, `[visTable()](visTable.html)`, and `[formatTable()](formatTable.html)` functions.

## Usage
    
    
    tableType()

## Value

A character vector of supported table types.

## Examples
    
    
    tableType()
    #> [1] "gt"        "flextable" "tibble"    "datatable" "reactable" "tinytable"
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
