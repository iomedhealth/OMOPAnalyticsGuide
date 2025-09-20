# Assert that an object is a character and fulfill certain conditions. — assertCharacter • omopgenerics

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



# Assert that an object is a character and fulfill certain conditions.

Source: [`R/assert.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/assert.R)

`assertCharacter.Rd`

Assert that an object is a character and fulfill certain conditions.

## Usage
    
    
    assertCharacter(
      x,
      length = NULL,
      na = FALSE,
      null = FALSE,
      unique = FALSE,
      named = FALSE,
      minNumCharacter = 0,
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)(),
      msg = NULL
    )

## Arguments

x
    

Variable to check.

length
    

Required length. If `NULL` length is not checked.

na
    

Whether it can contain NA values.

null
    

Whether it can be NULL.

unique
    

Whether it has to contain unique elements.

named
    

Whether it has to be named.

minNumCharacter
    

Minimum number of characters that all elements must have.

call
    

Call argument that will be passed to `cli` error message.

msg
    

Custom error message.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
