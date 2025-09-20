# Standard tables that a cdm reference can contain in the OMOP Common Data Model. — omopTables • omopgenerics

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



# Standard tables that a cdm reference can contain in the OMOP Common Data Model.

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`omopTables.Rd`

Standard tables that a cdm reference can contain in the OMOP Common Data Model.

## Usage
    
    
    omopTables(version = "5.3")

## Arguments

version
    

Version of the OMOP Common Data Model.

## Value

Standard tables

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    omopTables()
    #>  [1] "person"                "observation_period"    "visit_occurrence"     
    #>  [4] "visit_detail"          "condition_occurrence"  "drug_exposure"        
    #>  [7] "procedure_occurrence"  "device_exposure"       "measurement"          
    #> [10] "observation"           "death"                 "note"                 
    #> [13] "note_nlp"              "specimen"              "fact_relationship"    
    #> [16] "location"              "care_site"             "provider"             
    #> [19] "payer_plan_period"     "cost"                  "drug_era"             
    #> [22] "dose_era"              "condition_era"         "metadata"             
    #> [25] "cdm_source"            "concept"               "vocabulary"           
    #> [28] "domain"                "concept_class"         "concept_relationship" 
    #> [31] "relationship"          "concept_synonym"       "concept_ancestor"     
    #> [34] "source_to_concept_map" "drug_strength"         "cohort_definition"    
    #> [37] "attribute_definition"  "concept_recommended"  
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
