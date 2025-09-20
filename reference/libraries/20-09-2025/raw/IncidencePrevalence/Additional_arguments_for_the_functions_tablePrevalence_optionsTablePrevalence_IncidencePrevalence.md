# Additional arguments for the functions tablePrevalence. — optionsTablePrevalence • IncidencePrevalence

Skip to contents

[IncidencePrevalence](../index.html) 1.2.1

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction to IncidencePrevalence](../articles/a01_Introduction_to_IncidencePrevalence.html)
    * [Creating denominator cohorts](../articles/a02_Creating_denominator_populations.html)
    * [Creating target denominator populations](../articles/a03_Creating_target_denominator_populations.html)
    * [Calculating prevalence](../articles/a04_Calculating_prevalence.html)
    * [Calculating incidence](../articles/a05_Calculating_incidence.html)
    * [Working with IncidencePrevalence results](../articles/a06_Working_with_IncidencePrevalence_Results.html)
    * [Benchmarking the IncidencePrevalence R package](../articles/a07_benchmark.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/IncidencePrevalence/)



![](../logo.png)

# Additional arguments for the functions tablePrevalence.

Source: [`R/tables.R`](https://github.com/darwin-eu/IncidencePrevalence/blob/v1.2.1/R/tables.R)

`optionsTablePrevalence.Rd`

It provides a list of allowed inputs for .option argument in tablePrevalence, and their given default values.

## Usage
    
    
    optionsTablePrevalence()

## Value

The default .options named list.

## Examples
    
    
    {
      optionsTablePrevalence()
    }
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

Developed by Edward Burn, Berta Raventos, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
