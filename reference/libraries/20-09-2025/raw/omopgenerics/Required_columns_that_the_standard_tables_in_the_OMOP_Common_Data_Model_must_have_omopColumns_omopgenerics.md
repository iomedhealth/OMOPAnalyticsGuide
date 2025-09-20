# Required columns that the standard tables in the OMOP Common Data Model must have. — omopColumns • omopgenerics

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



# Required columns that the standard tables in the OMOP Common Data Model must have.

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`omopColumns.Rd`

Required columns that the standard tables in the OMOP Common Data Model must have.

## Usage
    
    
    omopColumns(
      table,
      field = NULL,
      version = "5.3",
      onlyRequired = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)()
    )

## Arguments

table
    

Table to see required columns.

field
    

Name of the specific field.

version
    

Version of the OMOP Common Data Model.

onlyRequired
    

deprecated

## Value

Character vector with the column names

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    omopColumns("person")
    #>  [1] "person_id"                   "gender_concept_id"          
    #>  [3] "year_of_birth"               "month_of_birth"             
    #>  [5] "day_of_birth"                "birth_datetime"             
    #>  [7] "race_concept_id"             "ethnicity_concept_id"       
    #>  [9] "location_id"                 "provider_id"                
    #> [11] "care_site_id"                "person_source_value"        
    #> [13] "gender_source_value"         "gender_source_concept_id"   
    #> [15] "race_source_value"           "race_source_concept_id"     
    #> [17] "ethnicity_source_value"      "ethnicity_source_concept_id"
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
