# Run codelist-level diagnostics — codelistDiagnostics • PhenotypeR

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

# Run codelist-level diagnostics

`codelistDiagnostics.Rd`

`codelistDiagnostics()` runs phenotypeR diagnostics on the cohort_codelist attribute on the cohort. Thus codelist attribute of the cohort must be populated. If it is missing then it could be populated using `addCodelistAttribute()` function.

Furthermore `codelistDiagnostics()` requires achilles tables to be present in the cdm so that concept counts could be derived.

## Usage
    
    
    codelistDiagnostics(cohort)

## Arguments

cohort
    

A cohort table in a cdm reference. The cohort_codelist attribute must be populated. The cdm reference must contain achilles tables as these will be used for deriving concept counts.

## Value

A summarised result

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    
    cdm <- [mockPhenotypeR](mockPhenotypeR.html)()
    
    cdm$arthropathies <- [conceptCohort](https://ohdsi.github.io/CohortConstructor/reference/conceptCohort.html)(cdm,
                                       conceptSet = [list](https://rdrr.io/r/base/list.html)("arthropathies" = [c](https://rdrr.io/r/base/c.html)(37110496)),
                                       name = "arthropathies")
    #> Warning: ! `codelist` casted to integers.
    #> ℹ Subsetting table condition_occurrence using 1 concept with domain: condition.
    #> ℹ Combining tables.
    #> ℹ Creating cohort attributes.
    #> ℹ Applying cohort requirements.
    #> ℹ Merging overlapping records.
    #> ✔ Cohort arthropathies created.
    
    result <- codelistDiagnostics(cdm$arthropathies)
    #> • Getting codelists from cohorts
    #> • Getting index event breakdown
    #> Getting counts of arthropathies codes for cohort arthropathies
    #> • Getting code counts in database based on achilles
    #> 
    #> • Getting orphan concepts
    #> PHOEBE results not available
    #> ℹ The concept_recommended table is not present in the cdm.
    #> Getting orphan codes for arthropathies
    #> 
    
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
