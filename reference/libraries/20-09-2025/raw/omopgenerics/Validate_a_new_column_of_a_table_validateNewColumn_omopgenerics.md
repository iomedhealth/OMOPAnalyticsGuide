# Validate a new column of a table — validateNewColumn • omopgenerics

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



# Validate a new column of a table

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateNewColumn.Rd`

Validate a new column of a table

## Usage
    
    
    validateNewColumn(table, column, validation = "warning", call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)())

## Arguments

table
    

The table to check if the column already exists.

column
    

Character vector with the name(s) of the new column(s).

validation
    

Whether to throw warning or error.

call
    

Passed to cli functions.

## Value

table without conflicting columns.

## Examples
    
    
    x <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      column1 = [c](https://rdrr.io/r/base/c.html)(1L, 2L),
      column2 = [c](https://rdrr.io/r/base/c.html)("a", "b")
    )
    validateNewColumn(x, "not_exiting_column")
    #> # A tibble: 2 × 2
    #>   column1 column2
    #>     <int> <chr>  
    #> 1       1 a      
    #> 2       2 b      
    validateNewColumn(x, "column1")
    #> Warning: ! columns `column1` already exist in the table. They will be overwritten.
    #> # A tibble: 2 × 1
    #>   column2
    #>   <chr>  
    #> 1 a      
    #> 2 b      
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
