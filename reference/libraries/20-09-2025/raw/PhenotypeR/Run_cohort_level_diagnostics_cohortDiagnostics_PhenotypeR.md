# Run cohort-level diagnostics — cohortDiagnostics • PhenotypeR

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

# Run cohort-level diagnostics

`cohortDiagnostics.Rd`

Runs phenotypeR diagnostics on the cohort. The diganostics include: * Age groups and sex summarised. * A summary of visits of everyone in the cohort using visit_occurrence table. * A summary of age and sex density of the cohort. * Attritions of the cohorts. * Overlap between cohorts (if more than one cohort is being used).

## Usage
    
    
    cohortDiagnostics(
      cohort,
      survival = FALSE,
      cohortSample = 20000,
      matchedSample = 1000
    )

## Arguments

cohort
    

Cohort table in a cdm reference

survival
    

Boolean variable. Whether to conduct survival analysis (TRUE) or not (FALSE).

cohortSample
    

The number of people to take a random sample for cohortDiagnostics. If `cohortSample = NULL`, no sampling will be performed,

matchedSample
    

The number of people to take a random sample for matching. If `matchedSample = NULL`, no sampling will be performed. If `matchedSample = 0`, no matched cohorts will be created.

## Value

A summarised result

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    
    cdm <- [mockPhenotypeR](mockPhenotypeR.html)()
    
    result <- cohortDiagnostics(cdm$my_cohort)
    #> • Starting Cohort Diagnostics
    #> → Getting cohort attrition
    #> → Getting cohort count
    #> ℹ summarising data
    #> ℹ summarising cohort cohort_1
    #> ℹ summarising cohort cohort_2
    #> ✔ summariseCharacteristics finished!
    #> → Skipping cohort sampling as all cohorts have less than 20000 individuals.
    #> → Getting cohort overlap
    #> → Getting cohort timing
    #> ℹ The following estimates will be computed:
    #> • days_between_cohort_entries: median, q25, q75, min, max, density
    #> ! Table is collected to memory as not all requested estimates are supported on
    #>   the database side
    #> → Start summary of data, at 2025-09-17 20:58:56.727136
    #> ✔ Summary finished, at 2025-09-17 20:58:56.863192
    #> → Creating matching cohorts
    #> → Sampling cohort `tmp_002_sampled`
    #> Returning entry cohort as the size of the cohorts to be sampled is equal or
    #> smaller than `n`.
    #> • Generating an age and sex matched cohort for cohort_1
    #> Starting matching
    #> ℹ Creating copy of target cohort.
    #> • 1 cohort to be matched.
    #> ℹ Creating controls cohorts.
    #> ℹ Excluding cases from controls
    #> • Matching by gender_concept_id and year_of_birth
    #> • Removing controls that were not in observation at index date
    #> • Excluding target records whose pair is not in observation
    #> • Adjusting ratio
    #> Binding cohorts
    #> ✔ Done
    #> → Sampling cohort `tmp_002_sampled`
    #> Returning entry cohort as the size of the cohorts to be sampled is equal or
    #> smaller than `n`.
    #> • Generating an age and sex matched cohort for cohort_2
    #> Starting matching
    #> ℹ Creating copy of target cohort.
    #> • 1 cohort to be matched.
    #> ℹ Creating controls cohorts.
    #> ℹ Excluding cases from controls
    #> • Matching by gender_concept_id and year_of_birth
    #> • Removing controls that were not in observation at index date
    #> • Excluding target records whose pair is not in observation
    #> • Adjusting ratio
    #> Binding cohorts
    #> ✔ Done
    #> → Getting cohorts and indexes
    #> → Summarising cohort characteristics
    #> ℹ adding demographics columns
    #> ℹ adding tableIntersectCount 1/1
    #> window names casted to snake_case:
    #> • `-365 to -1` -> `365_to_1`
    #> ℹ summarising data
    #> ℹ summarising cohort cohort_1
    #> ℹ summarising cohort cohort_2
    #> ℹ summarising cohort cohort_1_sampled
    #> ℹ summarising cohort cohort_1_matched
    #> ℹ summarising cohort cohort_2_sampled
    #> ℹ summarising cohort cohort_2_matched
    #> ✔ summariseCharacteristics finished!
    #> → Calculating age density
    #> ℹ The following estimates will be computed:
    #> • age: density
    #> → Start summary of data, at 2025-09-17 20:59:23.378124
    #> ✔ Summary finished, at 2025-09-17 20:59:23.708119
    #> → Run large scale characteristics (including source and standard codes)
    #> ℹ Summarising large scale characteristics 
    #>  - getting characteristics from table condition_occurrence (1 of 6)
    #>  - getting characteristics from table visit_occurrence (2 of 6)
    #>  - getting characteristics from table measurement (3 of 6)
    #>  - getting characteristics from table procedure_occurrence (4 of 6)
    #>  - getting characteristics from table observation (5 of 6)
    #>  - getting characteristics from table drug_exposure (6 of 6)
    #> Formatting result
    #> ✔ Summarising large scale characteristics
    #> → Run large scale characteristics (including only standard codes)
    #> ℹ Summarising large scale characteristics 
    #>  - getting characteristics from table condition_occurrence (1 of 6)
    #>  - getting characteristics from table visit_occurrence (2 of 6)
    #>  - getting characteristics from table measurement (3 of 6)
    #>  - getting characteristics from table procedure_occurrence (4 of 6)
    #>  - getting characteristics from table observation (5 of 6)
    #>  - getting characteristics from table drug_exposure (6 of 6)
    #> Formatting result
    #> ✔ Summarising large scale characteristics
    #> `cohort_sample` and `matched_sample` casted to character.
    
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
