# Get the name of the source concept_id column for a certain table in the cdm — sourceConceptIdColumn • PatientProfiles

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Get the name of the source concept_id column for a certain table in the cdm

Source: [`R/addIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addIntersect.R)

`sourceConceptIdColumn.Rd`

Get the name of the source concept_id column for a certain table in the cdm

## Usage
    
    
    sourceConceptIdColumn(tableName)

## Arguments

tableName
    

Name of the table.

## Value

Name of the source_concept_id column in that table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    sourceConceptIdColumn("condition_occurrence")
    #> [1] "condition_source_concept_id"
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
