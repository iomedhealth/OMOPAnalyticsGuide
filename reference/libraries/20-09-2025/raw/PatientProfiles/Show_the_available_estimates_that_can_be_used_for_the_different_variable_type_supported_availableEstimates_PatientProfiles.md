# Show the available estimates that can be used for the different variable_type supported. — availableEstimates • PatientProfiles

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Show the available estimates that can be used for the different variable_type supported.

Source: [`R/formats.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/formats.R)

`availableEstimates.Rd`

Show the available estimates that can be used for the different variable_type supported.

## Usage
    
    
    availableEstimates(variableType = NULL, fullQuantiles = FALSE)

## Arguments

variableType
    

A set of variable types.

fullQuantiles
    

Whether to display the exact quantiles that can be computed or only the qXX to summarise all of them.

## Value

A tibble with the available estimates.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    
    availableEstimates()
    #> # A tibble: 37 × 4
    #>    variable_type estimate_name      estimate_description           estimate_type
    #>    <chr>         <chr>              <chr>                          <chr>        
    #>  1 date          mean               mean of the variable of inter… date         
    #>  2 date          sd                 standard deviation of the var… date         
    #>  3 date          median             median of the variable of int… date         
    #>  4 date          qXX                qualtile of XX% the variable … date         
    #>  5 date          min                minimum of the variable of in… date         
    #>  6 date          max                maximum of the variable of in… date         
    #>  7 date          count_missing      number of missing values.      integer      
    #>  8 date          percentage_missing percentage of missing values   percentage   
    #>  9 numeric       sum                sum of all the values for the… numeric      
    #> 10 numeric       mean               mean of the variable of inter… numeric      
    #> # ℹ 27 more rows
    availableEstimates("numeric")
    #> # A tibble: 12 × 4
    #>    variable_type estimate_name      estimate_description           estimate_type
    #>    <chr>         <chr>              <chr>                          <chr>        
    #>  1 numeric       sum                sum of all the values for the… numeric      
    #>  2 numeric       mean               mean of the variable of inter… numeric      
    #>  3 numeric       sd                 standard deviation of the var… numeric      
    #>  4 numeric       median             median of the variable of int… numeric      
    #>  5 numeric       qXX                qualtile of XX% the variable … numeric      
    #>  6 numeric       min                minimum of the variable of in… numeric      
    #>  7 numeric       max                maximum of the variable of in… numeric      
    #>  8 numeric       count_missing      number of missing values.      integer      
    #>  9 numeric       percentage_missing percentage of missing values   percentage   
    #> 10 numeric       count              count number of `1`.           integer      
    #> 11 numeric       percentage         percentage of occurrences of … percentage   
    #> 12 numeric       density            density distribution           multiple     
    availableEstimates([c](https://rdrr.io/r/base/c.html)("numeric", "categorical"))
    #> # A tibble: 14 × 4
    #>    variable_type estimate_name      estimate_description           estimate_type
    #>    <chr>         <chr>              <chr>                          <chr>        
    #>  1 numeric       sum                sum of all the values for the… numeric      
    #>  2 numeric       mean               mean of the variable of inter… numeric      
    #>  3 numeric       sd                 standard deviation of the var… numeric      
    #>  4 numeric       median             median of the variable of int… numeric      
    #>  5 numeric       qXX                qualtile of XX% the variable … numeric      
    #>  6 numeric       min                minimum of the variable of in… numeric      
    #>  7 numeric       max                maximum of the variable of in… numeric      
    #>  8 numeric       count_missing      number of missing values.      integer      
    #>  9 numeric       percentage_missing percentage of missing values   percentage   
    #> 10 numeric       count              count number of `1`.           integer      
    #> 11 numeric       percentage         percentage of occurrences of … percentage   
    #> 12 categorical   count              number of times that each cat… integer      
    #> 13 categorical   percentage         percentage of individuals wit… percentage   
    #> 14 numeric       density            density distribution           multiple     
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
