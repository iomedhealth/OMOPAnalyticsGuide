# Validate nameStyle argument. If any of the element in ... has length greater than 1 it must be contained in nameStyle. Note that snake case notation is used. — validateNameStyle • omopgenerics

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



# Validate `nameStyle` argument. If any of the element in `...` has length greater than 1 it must be contained in nameStyle. Note that snake case notation is used.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateNameStyle.Rd`

Validate `nameStyle` argument. If any of the element in `...` has length greater than 1 it must be contained in nameStyle. Note that snake case notation is used.

## Usage
    
    
    validateNameStyle(nameStyle, ..., call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)())

## Arguments

nameStyle
    

A character vector. It must contain all the `...` elements in snake_case format and between `[{}](https://rdrr.io/r/base/Paren.html)`.

...
    

Elements to be included.

call
    

Passed to cli functions.

## Value

invisible nameStyle.

## Examples
    
    
    validateNameStyle(
      nameStyle = "hi_{cohort_name}",
      cohortName = [c](https://rdrr.io/r/base/c.html)("cohort1", "cohort2"),
      otherVariable = [c](https://rdrr.io/r/base/c.html)("only 1 value")
    )
    
    if (FALSE) { # \dontrun{
    validateNameStyle(
      nameStyle = "hi_{cohort_name}",
      cohortName = [c](https://rdrr.io/r/base/c.html)("cohort1", "cohort2"),
      otherVariable = [c](https://rdrr.io/r/base/c.html)("value1", "value2")
    )
    } # }
    validateNameStyle(
      nameStyle = "{other_variable}_hi_{cohort_name}",
      cohortName = [c](https://rdrr.io/r/base/c.html)("cohort1", "cohort2"),
      otherVariable = [c](https://rdrr.io/r/base/c.html)("value1", "value2")
    )
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
