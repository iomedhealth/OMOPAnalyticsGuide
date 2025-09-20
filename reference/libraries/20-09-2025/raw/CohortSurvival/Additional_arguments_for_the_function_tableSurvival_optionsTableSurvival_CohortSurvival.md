# Additional arguments for the function tableSurvival() — optionsTableSurvival • CohortSurvival

Skip to contents

[CohortSurvival](../index.html) 1.0.3

  * [Reference](../reference/index.html)
  * Articles
    * [Single outcome event of interest](../articles/a01_Single_event_of_interest.html)
    * [Competing risk survival](../articles/a02_Competing_risk_survival.html)
    * [Further survival analyses](../articles/a03_Further_survival_analyses.html)
  * [Changelog](../news/index.html)




![](../logo.png)

# Additional arguments for the function tableSurvival()

`optionsTableSurvival.Rd`

It provides a list of allowed inputs for .option argument in tableSurvival and their given default value.

## Usage
    
    
    optionsTableSurvival()

## Value

The default .options named list.

## Examples
    
    
    {
    optionsTableSurvival()
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

Developed by Kim López-Güell, Edward Burn, Marti Catala, Xintong Li, Danielle Newby, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
