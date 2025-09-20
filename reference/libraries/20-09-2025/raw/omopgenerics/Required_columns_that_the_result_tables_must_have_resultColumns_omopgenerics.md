# Required columns that the result tables must have. — resultColumns • omopgenerics

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



# Required columns that the result tables must have.

Source: [`R/classSummarisedResult.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classSummarisedResult.R)

`resultColumns.Rd`

Required columns that the result tables must have.

## Usage
    
    
    resultColumns(table = "summarised_result")

## Arguments

table
    

Table to see required columns.

## Value

Required columns

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    resultColumns()
    #>  [1] "result_id"        "cdm_name"         "group_name"       "group_level"     
    #>  [5] "strata_name"      "strata_level"     "variable_name"    "variable_level"  
    #>  [9] "estimate_name"    "estimate_type"    "estimate_value"   "additional_name" 
    #> [13] "additional_level"
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
