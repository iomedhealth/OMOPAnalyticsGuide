# Export a concept set expression. — exportConceptSetExpression • omopgenerics

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



# Export a concept set expression.

Source: [`R/exportConceptSetExpression.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/exportConceptSetExpression.R)

`exportConceptSetExpression.Rd`

Export a concept set expression.

## Usage
    
    
    exportConceptSetExpression(x, path, type = "json")

## Arguments

x
    

A concept set expression

path
    

Path to where files will be created.

type
    

Type of files to export. Currently 'json' and 'csv' are supported.

## Value

Files with concept set expressions

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
