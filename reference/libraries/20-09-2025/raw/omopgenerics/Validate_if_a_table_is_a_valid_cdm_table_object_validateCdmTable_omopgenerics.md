# Validate if a table is a valid cdm_table object. — validateCdmTable • omopgenerics

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



# Validate if a table is a valid cdm_table object.

Source: [`R/classCdmTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmTable.R)

`validateCdmTable.Rd`

Validate if a table is a valid cdm_table object.

## Usage
    
    
    validateCdmTable(table, name = NULL, call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)())

## Arguments

table
    

Object to validate.

name
    

If we want to validate that the table has a specific name.

call
    

Call argument that will be passed to `cli`.

## Value

The table or an error message.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
