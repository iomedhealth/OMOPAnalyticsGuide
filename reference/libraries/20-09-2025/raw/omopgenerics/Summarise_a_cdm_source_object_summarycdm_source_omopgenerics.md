# Summarise a cdm_source object — summary.cdm_source • omopgenerics

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



# Summarise a `cdm_source` object

Source: [`R/summary.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/summary.R)

`summary.cdm_source.Rd`

Summarise a `cdm_source` object

## Usage
    
    
    # S3 method for class 'cdm_source'
    [summary](https://rdrr.io/r/base/summary.html)(object, ...)

## Arguments

object
    

A generated cohort set object.

...
    

For compatibility (not used).

## Value

A list of properties of the `cdm_source` object.

## Examples
    
    
    [summary](https://rdrr.io/r/base/summary.html)([newLocalSource](newLocalSource.html)())
    #> This is a local source created by omopgenerics package.
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
