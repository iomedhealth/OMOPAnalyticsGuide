# To validate a strata list. It makes sure that elements are unique and point to columns in table. — validateStrataArgument • omopgenerics

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



# To validate a strata list. It makes sure that elements are unique and point to columns in table.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateStrataArgument.Rd`

To validate a strata list. It makes sure that elements are unique and point to columns in table.

## Usage
    
    
    validateStrataArgument(strata, table, call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)())

## Arguments

strata
    

A list of characters that point to columns in table.

table
    

A table with columns.

call
    

Passed to cli functions.

## Value

The same strata input or an error if the input is incorrect.

## Examples
    
    
    strata <- [list](https://rdrr.io/r/base/list.html)("age", "sex", [c](https://rdrr.io/r/base/c.html)("age", "sex"))
    x <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(age = 30L, sex = "Female")
    
    validateStrataArgument(strata, x)
    #> [[1]]
    #> [1] "age"
    #> 
    #> [[2]]
    #> [1] "sex"
    #> 
    #> [[3]]
    #> [1] "age" "sex"
    #> 
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
