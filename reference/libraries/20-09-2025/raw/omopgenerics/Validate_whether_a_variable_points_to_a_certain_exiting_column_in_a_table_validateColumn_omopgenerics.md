# Validate whether a variable points to a certain exiting column in a table. — validateColumn • omopgenerics

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



# Validate whether a variable points to a certain exiting column in a table.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateColumn.Rd`

Validate whether a variable points to a certain exiting column in a table.

## Usage
    
    
    validateColumn(
      column,
      x,
      type = [c](https://rdrr.io/r/base/c.html)("character", "date", "logical", "numeric", "integer"),
      validation = "error",
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

column
    

Name of a column that you want to check that exist in `x` table.

x
    

Table to check if the column exist.

type
    

Type of the column.

validation
    

Whether to throw warning or error.

call
    

Passed to cli functions.

## Value

the validated name

## Examples
    
    
    x <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(a = 1, b = "xxx")
    
    validateColumn("a", x, validation = "warning")
    #> [1] "a"
    validateColumn("a", x, type = "character", validation = "warning")
    #> Warning: ! a type must be a choice of: `character`; but it is numeric.
    #> [1] "a"
    validateColumn("a", x, type = "numeric", validation = "warning")
    #> [1] "a"
    validateColumn("not_existing", x, type = "numeric", validation = "warning")
    #> Warning: ! not_existing column does not exist.
    #> [1] "not_existing"
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
