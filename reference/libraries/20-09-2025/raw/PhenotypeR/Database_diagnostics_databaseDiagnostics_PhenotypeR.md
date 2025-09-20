# Database diagnostics — databaseDiagnostics • PhenotypeR

Skip to contents

[PhenotypeR](../index.html) 0.2.0

  * [Reference](../reference/index.html)
  * Articles
    * ###### Main functionality

    * [PhenotypeDiagnostics](../articles/PhenotypeDiagnostics.html)
    * [PhenotypeExpectations](../articles/PhenotypeExpectations.html)
    * [ShinyDiagnostics](../articles/ShinyDiagnostics.html)
    * * * *

    * ###### Individual functions

    * [DatabaseDiagnostics](../articles/DatabaseDiagnostics.html)
    * [CodelistDiagnostics](../articles/CodelistDiagnostics.html)
    * [CohortDiagnostics](../articles/CohortDiagnostics.html)
    * [PopulationDiagnostics](../articles/PopulationDiagnostics.html)
  * [PhenotypeR shiny App](https://dpa-pde-oxford.shinyapps.io/PhenotypeRShiny/)


  * [](https://github.com/OHDSI/PhenotypeR)



![](../logo.png)

# Database diagnostics

`databaseDiagnostics.Rd`

phenotypeR diagnostics on the cdm object.

Diagnostics include: * Summarise a cdm_reference object, creating a snapshot with the metadata of the cdm_reference object. * Summarise the observation period table getting some overall statistics in a summarised_result object.

## Usage
    
    
    databaseDiagnostics(cdm)

## Arguments

cdm
    

CDM reference

## Value

A summarised result

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    
    cdm <- [mockPhenotypeR](mockPhenotypeR.html)()
    
    result <- databaseDiagnostics(cdm)
    #> Warning: Vocabulary version in cdm_source (NA) doesn't match the one in the vocabulary
    #> table (mock)
    
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
