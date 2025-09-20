# Convert a character vector to snake case — toSnakeCase • omopgenerics

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



# Convert a character vector to snake case

Source: [`R/utilities.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/utilities.R)

`toSnakeCase.Rd`

Convert a character vector to snake case

## Usage
    
    
    toSnakeCase(x)

## Arguments

x
    

Character vector to convert

## Value

A snake_case vector

## Examples
    
    
    toSnakeCase("myVariable")
    #> [1] "my_variable"
    
    toSnakeCase([c](https://rdrr.io/r/base/c.html)("cohort1", "Cohort22b"))
    #> [1] "cohort1"   "cohort22b"
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
