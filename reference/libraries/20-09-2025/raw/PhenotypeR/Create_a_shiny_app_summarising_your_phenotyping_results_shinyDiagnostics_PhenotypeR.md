# Create a shiny app summarising your phenotyping results — shinyDiagnostics • PhenotypeR

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

# Create a shiny app summarising your phenotyping results

`shinyDiagnostics.Rd`

A shiny app that is designed for any diagnostics results from phenotypeR, this includes:

* A diagnostics on the database via `databaseDiagnostics`. * A diagnostics on the cohort_codelist attribute of the cohort via `codelistDiagnostics`. * A diagnostics on the cohort via `cohortDiagnostics`. * A diagnostics on the population via `populationDiagnostics`. * A diagnostics on the matched cohort via `matchedDiagnostics`.

## Usage
    
    
    shinyDiagnostics(
      result,
      directory,
      minCellCount = 5,
      open = rlang::[is_interactive](https://rlang.r-lib.org/reference/is_interactive.html)(),
      expectations = NULL
    )

## Arguments

result
    

A summarised result

directory
    

Directory where to save report

minCellCount
    

Minimum cell count for suppression when exporting results.

open
    

If TRUE, the shiny app will be launched in a new session. If FALSE, the shiny app will be created but not launched.

expectations
    

Data frame or tibble with cohort expectations. It must contain the following columns: cohort_name, estimate, value, and source.

## Value

A shiny app

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    cdm <- [mockPhenotypeR](mockPhenotypeR.html)()
    
    result <- [phenotypeDiagnostics](phenotypeDiagnostics.html)(cdm$my_cohort)
    #> 
    #> Warning: Vocabulary version in cdm_source (NA) doesn't match the one in the vocabulary
    #> table (mock)
    #> 
    #> Warning: ! cohort_codelist attribute for cohort is empty
    #> ℹ Returning an empty summarised result
    #> ℹ You can add a codelist to a cohort with `addCodelistAttribute()`.
    #> 
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
    #> → Start summary of data, at 2025-09-17 21:04:45.21588
    #> ✔ Summary finished, at 2025-09-17 21:04:45.345943
    #> → Creating matching cohorts
    #> → Sampling cohort `tmp_033_sampled`
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
    #> → Sampling cohort `tmp_033_sampled`
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
    #> → Start summary of data, at 2025-09-17 21:05:11.503108
    #> ✔ Summary finished, at 2025-09-17 21:05:11.826573
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
    #> 
    #> • Creating denominator for incidence and prevalence
    #> • Sampling person table to 1e+06
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 5 sec
    #> • Estimating incidence
    #> ℹ Getting incidence for analysis 1 of 14
    #> ℹ Getting incidence for analysis 2 of 14
    #> ℹ Getting incidence for analysis 3 of 14
    #> ℹ Getting incidence for analysis 4 of 14
    #> ℹ Getting incidence for analysis 5 of 14
    #> ℹ Getting incidence for analysis 6 of 14
    #> ℹ Getting incidence for analysis 7 of 14
    #> ℹ Getting incidence for analysis 8 of 14
    #> ℹ Getting incidence for analysis 9 of 14
    #> ℹ Getting incidence for analysis 10 of 14
    #> ℹ Getting incidence for analysis 11 of 14
    #> ℹ Getting incidence for analysis 12 of 14
    #> ℹ Getting incidence for analysis 13 of 14
    #> ℹ Getting incidence for analysis 14 of 14
    #> ✔ Overall time taken: 0 mins and 13 secs
    #> • Estimating prevalence
    #> ℹ Getting prevalence for analysis 1 of 14
    #> ℹ Getting prevalence for analysis 2 of 14
    #> ℹ Getting prevalence for analysis 3 of 14
    #> ℹ Getting prevalence for analysis 4 of 14
    #> ℹ Getting prevalence for analysis 5 of 14
    #> ℹ Getting prevalence for analysis 6 of 14
    #> ℹ Getting prevalence for analysis 7 of 14
    #> ℹ Getting prevalence for analysis 8 of 14
    #> ℹ Getting prevalence for analysis 9 of 14
    #> ℹ Getting prevalence for analysis 10 of 14
    #> ℹ Getting prevalence for analysis 11 of 14
    #> ℹ Getting prevalence for analysis 12 of 14
    #> ℹ Getting prevalence for analysis 13 of 14
    #> ℹ Getting prevalence for analysis 14 of 14
    #> ✔ Time taken: 0 mins and 7 secs
    #> `populationDateStart`, `populationDateEnd`, and `populationSample` casted to
    #> character.
    #> `populationDateStart` and `populationDateEnd` eliminated from settings as all
    #> elements are NA.
    #> 
    expectations <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)("cohort_name" = [rep](https://rdrr.io/r/base/rep.html)([c](https://rdrr.io/r/base/c.html)("cohort_1", "cohort_2"),3),
                           "value" = [c](https://rdrr.io/r/base/c.html)([rep](https://rdrr.io/r/base/rep.html)([c](https://rdrr.io/r/base/c.html)("Mean age"),2),
                                       [rep](https://rdrr.io/r/base/rep.html)("Male percentage",2),
                                       [rep](https://rdrr.io/r/base/rep.html)("Survival probability after 5y",2)),
                           "estimate" = [c](https://rdrr.io/r/base/c.html)("32", "54", "25%", "74%", "95%", "21%"),
                           "source" = [rep](https://rdrr.io/r/base/rep.html)([c](https://rdrr.io/r/base/c.html)("AlbertAI"),6))
    
    shinyDiagnostics(result, [tempdir](https://rdrr.io/r/base/tempfile.html)(), expectations = expectations)
    #> ℹ Creating shiny from provided data
    #> Warning: codelistDiagnostics not present in the summarised result. Removing tab from the
    #> shiny app.
    #> Warning: No survival analysis present in cohortDiagnostics. Removing tab from the shiny
    #> app.
    #> Warning: '/tmp/RtmpKN25fW/PhenotypeRShiny/data/raw/expectations' already exists
    #> ℹ Shiny app created in /tmp/RtmpKN25fW/PhenotypeRShiny
    
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
