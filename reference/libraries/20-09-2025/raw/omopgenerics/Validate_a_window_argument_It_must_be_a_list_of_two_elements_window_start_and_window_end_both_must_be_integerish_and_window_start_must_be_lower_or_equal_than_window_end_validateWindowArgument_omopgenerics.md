# Validate a window argument. It must be a list of two elements (window start and window end), both must be integerish and window start must be lower or equal than window end. — validateWindowArgument • omopgenerics

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



# Validate a window argument. It must be a list of two elements (window start and window end), both must be integerish and window start must be lower or equal than window end.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateWindowArgument.Rd`

Validate a window argument. It must be a list of two elements (window start and window end), both must be integerish and window start must be lower or equal than window end.

## Usage
    
    
    validateWindowArgument(window, snakeCase = TRUE, call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)())

## Arguments

window
    

time window

snakeCase
    

return default window name in snake case if TRUE

call
    

A call argument to pass to cli functions.

## Value

time window

## Examples
    
    
    validateWindowArgument([list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 15), [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)))
    #> $`0_to_15`
    #> [1]  0 15
    #> 
    #> $minf_to_inf
    #> [1] -Inf  Inf
    #> 
    validateWindowArgument([list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 15), [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)), snakeCase = FALSE)
    #> $`0 to 15`
    #> [1]  0 15
    #> 
    #> $`-inf to inf`
    #> [1] -Inf  Inf
    #> 
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
