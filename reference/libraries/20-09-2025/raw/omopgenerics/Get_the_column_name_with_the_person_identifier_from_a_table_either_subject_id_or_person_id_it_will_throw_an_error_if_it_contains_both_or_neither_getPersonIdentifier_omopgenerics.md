# Get the column name with the person identifier from a table (either subject_id or person_id), it will throw an error if it contains both or neither. — getPersonIdentifier • omopgenerics

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



# Get the column name with the person identifier from a table (either subject_id or person_id), it will throw an error if it contains both or neither.

Source: [`R/utilities.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/utilities.R)

`getPersonIdentifier.Rd`

Get the column name with the person identifier from a table (either subject_id or person_id), it will throw an error if it contains both or neither.

## Usage
    
    
    getPersonIdentifier(x, call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)())

## Arguments

x
    

A table.

call
    

A call argument passed to cli functions.

## Value

Person identifier column.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
