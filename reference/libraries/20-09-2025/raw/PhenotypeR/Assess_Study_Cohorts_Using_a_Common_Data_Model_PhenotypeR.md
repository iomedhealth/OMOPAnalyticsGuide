# Assess Study Cohorts Using a Common Data Model • PhenotypeR

Skip to contents

[PhenotypeR](index.html) 0.2.0

  * [Reference](reference/index.html)
  * Articles
    * ###### Main functionality

    * [PhenotypeDiagnostics](articles/PhenotypeDiagnostics.html)
    * [PhenotypeExpectations](articles/PhenotypeExpectations.html)
    * [ShinyDiagnostics](articles/ShinyDiagnostics.html)
    * * * *

    * ###### Individual functions

    * [DatabaseDiagnostics](articles/DatabaseDiagnostics.html)
    * [CodelistDiagnostics](articles/CodelistDiagnostics.html)
    * [CohortDiagnostics](articles/CohortDiagnostics.html)
    * [PopulationDiagnostics](articles/PopulationDiagnostics.html)
  * [PhenotypeR shiny App](https://dpa-pde-oxford.shinyapps.io/PhenotypeRShiny/)


  * [](https://github.com/OHDSI/PhenotypeR)



![](logo.png)

# PhenotypeR 

The PhenotypeR package helps us to assess the research-readiness of a set of cohorts we have defined. This assessment includes:

  * **_Database diagnostics_** which help us to better understand the database in which they have been created. This includes information about the size of the data, the time period covered, the number of people in the data as a whole. More granular information that may influence analytic decisions, such as the number of observation periods per person, is also described.  

  * **_Codelist diagnostics_** which help to answer questions like what concepts from our codelist are used in the database? What concepts were present led to individuals’ entry in the cohort? Are there any concepts being used in the database that we didn’t include in our codelist but maybe we should have?  

  * **_Cohort diagnostics_** which help to answer questions like how many individuals did we include in our cohort and how many were excluded because of our inclusion criteria? If we have multiple cohorts, is there overlap between them and when do people enter one cohort relative to another? What is the incidence of cohort entry and what is the prevalence of the cohort in the database? It can also compare our study cohorts to the general population by matching people with similar age and sex.  

  * **_Population diagnostics_** which estimates the frequency of our study cohorts in the database in terms of their incidence rates and prevalence.



## Installation

You can install PhenotypeR from CRAN:
    
    
    [install.packages](https://rdrr.io/r/utils/install.packages.html)("PhenotypeR")

Or you can install the development version from GitHub:
    
    
    # install.packages("remotes")
    remotes::install_github("OHDSI/PhenotypeR")

## Example usage

To illustrate the functionality of PhenotypeR, let’s create a cohort using the Eunomia Synpuf dataset. We’ll first load the required packages and create the cdm reference for the data.
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    
    
    # Connect to the database and create the cdm object
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                                    cdmName = "Eunomia Synpuf",
                                    cdmSchema   = "main",
                                    writeSchema = "main",
                                    achillesSchema = "main")

Note that we’ve included achilles results in our cdm reference. Where we can we’ll use these precomputed counts to speed up our analysis.
    
    
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of Eunomia Synpuf ─────────────────────────────
    #> • omop tables: person, observation_period, visit_occurrence, visit_detail,
    #> condition_occurrence, drug_exposure, procedure_occurrence, device_exposure,
    #> measurement, observation, death, note, note_nlp, specimen, fact_relationship,
    #> location, care_site, provider, payer_plan_period, cost, drug_era, dose_era,
    #> condition_era, metadata, cdm_source, concept, vocabulary, domain,
    #> concept_class, concept_relationship, relationship, concept_synonym,
    #> concept_ancestor, source_to_concept_map, drug_strength, cohort_definition,
    #> attribute_definition
    #> • cohort tables: -
    #> • achilles tables: achilles_analysis, achilles_results, achilles_results_dist
    #> • other tables: -
    
    
    # Create a code lists
    codes <- [list](https://rdrr.io/r/base/list.html)("warfarin" = [c](https://rdrr.io/r/base/c.html)(1310149L, 40163554L),
                  "acetaminophen" = [c](https://rdrr.io/r/base/c.html)(1125315L, 1127078L, 1127433L, 40229134L, 40231925L, 40162522L, 19133768L),
                  "morphine" = [c](https://rdrr.io/r/base/c.html)(1110410L, 35605858L, 40169988L),
                  "measurements_cohort" = [c](https://rdrr.io/r/base/c.html)(40660437L, 2617206L, 4034850L,  2617239L, 4098179L))
    
    # Instantiate cohorts with CohortConstructor
    cdm$my_cohort <- [conceptCohort](https://ohdsi.github.io/CohortConstructor/reference/conceptCohort.html)(cdm = cdm,
                                   conceptSet = codes, 
                                   exit = "event_end_date",
                                   overlap = "merge",
                                   name = "my_cohort")

We can easily run all the analyses explained above (**database diagnostics** , **codelist diagnostics** , **cohort diagnostics** , and **population diagnostics**) using `[phenotypeDiagnostics()](reference/phenotypeDiagnostics.html)`:
    
    
    result <- [phenotypeDiagnostics](reference/phenotypeDiagnostics.html)(cdm$my_cohort, survival = TRUE)

You can also create a table with the expected results, so you can compare later with the actual results.
    
    
    expectations <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      "cohort_name" = [c](https://rdrr.io/r/base/c.html)("warfarin", "acetaminophen", "morphine", "measurements_cohort"),
      "estimate" = [c](https://rdrr.io/r/base/c.html)("Male percentage", "Survival probability after 5y", "Median age", "Median age"),
      "value" = [c](https://rdrr.io/r/base/c.html)("56%", "96%", "57-58", "42-45"),
      "source" = [c](https://rdrr.io/r/base/c.html)("A clinician", "A clinician", "A clinician", "A clinician"),
      "diagnostic" = [c](https://rdrr.io/r/base/c.html)("cohort_characteristics", "cohort_survival", "cohort_characteristics", "cohort_characteristics") 
    )

Or alternatively, you can use AI to generate expectations
    
    
    [library](https://rdrr.io/r/base/library.html)([ellmer](https://ellmer.tidyverse.org))
    # Notice that you may need to generate an google gemini API with https://aistudio.google.com/app/apikey and add it to your R environment:
    # usethis::edit_r_environ()
    # GEMINI_API_KEY = "your API"
    
    chat <- [chat](https://ellmer.tidyverse.org/reference/chat-any.html)("google_gemini")
    
    expectations <- [getCohortExpectations](reference/getCohortExpectations.html)(chat = chat, 
                          phenotypes = result)

Once we have our results we can quickly view them in an interactive application. Here we’ll apply a minimum cell count of 10 to our results and save our shiny app to a temporary directory.
    
    
    [shinyDiagnostics](reference/shinyDiagnostics.html)(result = result, minCellCount = 2, directory = [tempdir](https://rdrr.io/r/base/tempfile.html)(), expectations = expectations)

See the shiny app generated from the example cohort in [here](https://dpa-pde-oxford.shinyapps.io/PhenotypeRShiny/).

### More information

To see more details regarding each one of the analyses, please refer to the package vignettes.

## Links

  * [View on CRAN](https://cloud.r-project.org/package=PhenotypeR)



## License

  * [Full license](LICENSE.html)
  * Apache License (>= 2)



## Citation

  * [Citing PhenotypeR](authors.html#citation)



## Developers

  * Edward Burn   
Author, maintainer  [](https://orcid.org/0000-0002-9286-1128)
  * Marti Catala   
Author  [](https://orcid.org/0000-0003-3308-9905)
  * Xihang Chen   
Author  [](https://orcid.org/0009-0001-8112-8959)
  * Marta Alcalde-Herraiz   
Author  [](https://orcid.org/0009-0002-4405-1814)
  * Nuria Mercade-Besora   
Author  [](https://orcid.org/0009-0006-7948-3747)
  * Albert Prats-Uribe   
Author  [](https://orcid.org/0000-0003-1202-9153)



## Dev status

  * [![CRAN status](https://www.r-pkg.org/badges/version/PhenotypeR)](https://CRAN.R-project.org/package=PhenotypeR)
  * [![R-CMD-check](https://github.com/ohdsi/PhenotypeR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ohdsi/PhenotypeR/actions/workflows/R-CMD-check.yaml)
  * [![Lifecycle:Experimental](https://img.shields.io/badge/Lifecycle-Experimental-339999)](https://lifecycle.r-lib.org/articles/stages.html#experimental)



Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
