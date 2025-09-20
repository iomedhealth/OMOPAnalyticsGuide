# Assert that an object has a certain class. — assertClass • omopgenerics

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



# Assert that an object has a certain class.

Source: [`R/assert.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/assert.R)

`assertClass.Rd`

Assert that an object has a certain class.

## Usage
    
    
    assertClass(
      x,
      class,
      length = NULL,
      null = FALSE,
      all = FALSE,
      extra = TRUE,
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)(),
      msg = NULL
    )

## Arguments

x
    

To check.

class
    

Expected class or classes.

length
    

Required length. If `NULL` length is not checked.

null
    

Whether it can be NULL.

all
    

Whether it should have all the classes or only at least one of them.

extra
    

Whether the object can have extra classes.

call
    

Call argument that will be passed to `cli`.

msg
    

Custom error message.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
