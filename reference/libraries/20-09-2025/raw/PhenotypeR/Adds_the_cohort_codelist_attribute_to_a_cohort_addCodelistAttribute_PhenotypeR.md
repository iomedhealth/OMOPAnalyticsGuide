# Adds the cohort_codelist attribute to a cohort — addCodelistAttribute • PhenotypeR

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

# Adds the cohort_codelist attribute to a cohort

`addCodelistAttribute.Rd`

`addCodelistAttribute()` allows the users to add a codelist to a cohort in OMOP CDM.

This is particularly important for the use of `codelistDiagnostics()`, as the underlying assumption is that the cohort that is fed into `codelistDiagnostics()` has a cohort_codelist attribute attached to it.

## Usage
    
    
    addCodelistAttribute(cohort, codelist, cohortName = [names](https://rdrr.io/r/base/names.html)(codelist))

## Arguments

cohort
    

Cohort table in a cdm reference

codelist
    

Named list of concepts

cohortName
    

For each element of the codelist, the name of the cohort in `cohort` to which the codelist refers

## Value

A cohort

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    
    cdm <- [mockPhenotypeR](mockPhenotypeR.html)()
    
    cohort <- addCodelistAttribute(cohort = cdm$my_cohort, codelist = [list](https://rdrr.io/r/base/list.html)("cohort_1" = 1L))
    [attr](https://rdrr.io/r/base/attr.html)(cohort, "cohort_codelist")
    #> # Source:   table<my_cohort_codelist> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id codelist_name concept_id codelist_type
    #>                  <int> <chr>              <int> <chr>        
    #> 1                    1 cohort_1               1 index event  
    
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
