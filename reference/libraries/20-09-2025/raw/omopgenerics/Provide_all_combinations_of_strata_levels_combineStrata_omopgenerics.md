# Provide all combinations of strata levels. — combineStrata • omopgenerics

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Provide all combinations of strata levels.

Source: [`R/combineStrata.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/combineStrata.R)

`combineStrata.Rd`

Provide all combinations of strata levels.

## Usage
    
    
    combineStrata(levels, overall = FALSE)

## Arguments

levels
    

Vector of all strata levels to combine.

overall
    

Whether to provide an empty element `[character()](https://rdrr.io/r/base/character.html)`.

## Value

A vector of all combinations of strata.

## Examples
    
    
    combineStrata([character](https://rdrr.io/r/base/character.html)())
    #> list()
    combineStrata([character](https://rdrr.io/r/base/character.html)(), overall = TRUE)
    #> [[1]]
    #> character(0)
    #> 
    combineStrata([c](https://rdrr.io/r/base/c.html)("age", "sex"), overall = TRUE)
    #> [[1]]
    #> character(0)
    #> 
    #> [[2]]
    #> [1] "age"
    #> 
    #> [[3]]
    #> [1] "sex"
    #> 
    #> [[4]]
    #> [1] "age" "sex"
    #> 
    combineStrata([c](https://rdrr.io/r/base/c.html)("age", "sex", "year"))
    #> [[1]]
    #> [1] "age"
    #> 
    #> [[2]]
    #> [1] "sex"
    #> 
    #> [[3]]
    #> [1] "year"
    #> 
    #> [[4]]
    #> [1] "age" "sex"
    #> 
    #> [[5]]
    #> [1] "age"  "year"
    #> 
    #> [[6]]
    #> [1] "sex"  "year"
    #> 
    #> [[7]]
    #> [1] "age"  "sex"  "year"
    #> 
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
