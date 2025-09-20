# Classify the variables between 5 types: "numeric", "categorical", "binary", "date", or NA. — variableTypes • PatientProfiles

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

# Classify the variables between 5 types: "numeric", "categorical", "binary", "date", or NA.

Source: [`R/formats.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/formats.R)

`variableTypes.Rd`

Classify the variables between 5 types: "numeric", "categorical", "binary", "date", or NA.

## Usage
    
    
    variableTypes(table)

## Arguments

table
    

Tibble.

## Value

Tibble with the variables type and classification.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    x <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = [c](https://rdrr.io/r/base/c.html)(1, 2),
      start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2020-05-02", "2021-11-19")),
      asthma = [c](https://rdrr.io/r/base/c.html)(0, 1)
    )
    variableTypes(x)
    #> # A tibble: 3 × 2
    #>   variable_name variable_type
    #>   <chr>         <chr>        
    #> 1 person_id     numeric      
    #> 2 start_date    date         
    #> 3 asthma        numeric      
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
