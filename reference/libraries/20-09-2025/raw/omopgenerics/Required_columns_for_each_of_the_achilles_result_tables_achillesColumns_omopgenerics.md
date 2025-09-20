# Required columns for each of the achilles result tables — achillesColumns • omopgenerics

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



# Required columns for each of the achilles result tables

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`achillesColumns.Rd`

Required columns for each of the achilles result tables

## Usage
    
    
    achillesColumns(table, version = "5.3", onlyRequired = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)())

## Arguments

table
    

Table for which to see the required columns. One of "achilles_analysis", "achilles_results", or "achilles_results_dist".

version
    

Version of the OMOP Common Data Model.

onlyRequired
    

deprecated.

## Value

Character vector with the column names

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    achillesColumns("achilles_analysis")
    #> [1] "analysis_id"    "analysis_name"  "stratum_1_name" "stratum_2_name"
    #> [5] "stratum_3_name" "stratum_4_name" "stratum_5_name" "is_default"    
    #> [9] "category"      
    achillesColumns("achilles_results")
    #> [1] "analysis_id" "stratum_1"   "stratum_2"   "stratum_3"   "stratum_4"  
    #> [6] "stratum_5"   "count_value"
    achillesColumns("achilles_results_dist")
    #>  [1] "analysis_id"  "stratum_1"    "stratum_2"    "stratum_3"    "stratum_4"   
    #>  [6] "stratum_5"    "count_value"  "min_value"    "max_value"    "avg_value"   
    #> [11] "stdev_value"  "median_value" "p10_value"    "p25_value"    "p75_value"   
    #> [16] "p90_value"   
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
