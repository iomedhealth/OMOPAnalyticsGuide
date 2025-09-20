# Returns an empty table — emptyTable • visOmopResults

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Returns an empty table

Source: [`R/visTable.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/visTable.R)

`emptyTable.Rd`

Returns an empty table

## Usage
    
    
    emptyTable(type = "gt")

## Arguments

type
    

The desired format of the output table. See `[tableType()](tableType.html)` for allowed options.

## Value

An empty table of the class specified in `type`

## Examples
    
    
    emptyTable(type = "flextable")
    
    
    Table has no data  
    ---  
      
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
