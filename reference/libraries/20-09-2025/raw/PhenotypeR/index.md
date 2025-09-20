# Content from https://ohdsi.github.io/PhenotypeR/


---

## Content from https://ohdsi.github.io/PhenotypeR/

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

---

## Content from https://ohdsi.github.io/PhenotypeR/index.html

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

---

## Content from https://ohdsi.github.io/PhenotypeR/reference/index.html

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

# Package index

### Run all diagnostics

`[phenotypeDiagnostics()](phenotypeDiagnostics.html)`
    Phenotype a cohort

### Run individual diagnostics

`[databaseDiagnostics()](databaseDiagnostics.html)`
    Database diagnostics

`[codelistDiagnostics()](codelistDiagnostics.html)`
    Run codelist-level diagnostics

`[cohortDiagnostics()](cohortDiagnostics.html)`
    Run cohort-level diagnostics

`[populationDiagnostics()](populationDiagnostics.html)`
    Population-level diagnostics

### Visualise results

`[shinyDiagnostics()](shinyDiagnostics.html)`
    Create a shiny app summarising your phenotyping results

### Create expectations to compare results against

`[getCohortExpectations()](getCohortExpectations.html)`
    Get cohort expectations using an LLM

`[tableCohortExpectations()](tableCohortExpectations.html)`
    Create a table summarising cohort expectations

### Codelist diagnostics helper

`[addCodelistAttribute()](addCodelistAttribute.html)`
    Adds the cohort_codelist attribute to a cohort

### Mock data

`[mockPhenotypeR()](mockPhenotypeR.html)`
    Function to create a mock cdm reference for mockPhenotypeR

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/articles/PhenotypeDiagnostics.html

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

# Phenotype diagnostics

`PhenotypeDiagnostics.Rmd`

## Introduction: Run PhenotypeDiagnostics

In this vignette, we are going to present how to run `PhenotypeDiagnostics()`. We are going to use the following packages and mock data:
    
    
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                                    cdmName = "Eunomia Synpuf",
                                    cdmSchema   = "main",
                                    writeSchema = "main", 
                                    achillesSchema = "main")
    cdm

Note that we have included [achilles tables](https://github.com/OHDSI/Achilles) in our cdm reference, which will be used to speed up some of the analyses.

## Create a cohort

First, we are going to use the package [CohortConstructor](https://ohdsi.github.io/CohortConstructor/) to generate three cohorts of _warfarin_ , _acetaminophen_ and _morphine_ users.
    
    
    # Create a codelist
    codes <- [list](https://rdrr.io/r/base/list.html)("warfarin" = [c](https://rdrr.io/r/base/c.html)(1310149, 40163554),
                  "acetaminophen" = [c](https://rdrr.io/r/base/c.html)(1125315, 1127078, 1127433, 40229134, 40231925, 40162522, 19133768),
                  "morphine" = [c](https://rdrr.io/r/base/c.html)(1110410, 35605858, 40169988))
    
    # Instantiate cohorts with CohortConstructor
    cdm$my_cohort <- [conceptCohort](https://ohdsi.github.io/CohortConstructor/reference/conceptCohort.html)(cdm = cdm,
                                   conceptSet = codes, 
                                   exit = "event_end_date",
                                   overlap = "merge",
                                   name = "my_cohort")

## Run PhenotypeDiagnostics

Now we will proceed to run `phenotypeDiagnotics()`. This function will run the following analyses:

  * **Database diagnostics** : This includes information about the size of the data, the time period covered, the number of people in the data, and other meta-data of the CDM object. See [Database diagnostics vignette](https://ohdsi.github.io/PhenotypeR/articles/a03_DatabaseDiagnostics.html) for more details.
  * **Codelist diagnostics** : This includes information on the concepts included in our cohorts’ codelist. See [Codelist diagnostics vignette](https://ohdsi.github.io/PhenotypeR/articles/a04_CodelistDiagnostics.html) for further details.
  * **Cohort diagnostics** : This summarises the characteristics of our cohorts, as well as comparing them to age and sex matched controls from the database.. See [Cohort diagnostics vignette](https://ohdsi.github.io/PhenotypeR/articles/a05_CohortDiagnostics.html) for further details.
  * **Population diagnostics** : Calculates the frequency of our study cohorts in the database in terms of their incidence rates and prevalence. See [Population diagnostics vignette](https://ohdsi.github.io/PhenotypeR/articles/a07_PopulationDiagnostics.html) for further details.



We can specify which analysis we want to perform by setting to TRUE or FALSE each one of the corresponding arguments:
    
    
    result <- phenotypeDiagnostics(
      cohort = cdm$my_cohort, 
      diagnostics = c("databaseDiagnostics", "codelistDiagnostics", 
                      "cohortDiagnostics", "populationDiagnostics"),
      cohortSample = 20000,
      matchedSample = 1000
      populationSample = 1e+06,
      populationDateRange = as.Date(c(NA, NA))
      )
    result |> glimpse()

Notice that we have three additional arguments:

  * `populationSample`: It allows to specify a number of people that randomly will be extracted from the CDM to perform the **Population diagnostics** analysis. If NULL, all the participants in the CDM will be included. It helps to reduce the computational time. This is particularly useful when outcomes of interest are relatively common, but when they are rarer we may wish to maximise statistical power and calculate estimates for the dataset as a whole in which case we would set this argument to NULL.
  * `populationDateRange`: We can use it to specify the time period when we want to perform our **Population diagnostics** analysis.
  * `cohortSample`: This argument will subset a random sample of people from our cohort and performs the cohortDiagnostics on this sample (notice that the attrition and the cohort counts will be calculated from the original cohorts, not the sampled ones). If the sample specified is bigger than the number of individuals in the cohort, no sampling will be performed. We recommend to use this option when there are cohorts bigger than 20,000 individuals.
  * `matchedSample`: Similar to populationSample, this arguments subsets a random sample of people from our cohort and performs the matched analysis on this sample. If the sample specified is bigger than the size of the cohort, no sampling will be performed. If we have specified a cohortSample, the sampling will be performed on top of the sampled cohorts. If we do not want to create matched cohorts, we can define `matchedSample = 0`.



## Save the results

To save the results, we can use [exportSummarisedResult](https://darwin-eu.github.io/omopgenerics/reference/exportSummarisedResult.html) function from [omopgenerics](https://darwin-eu.github.io/omopgenerics/index.html) R Package:
    
    
    [exportSummarisedResult](https://darwin-eu.github.io/omopgenerics/reference/exportSummarisedResult.html)(result, directory = here::[here](https://here.r-lib.org/reference/here.html)(), minCellCount = 5)

## Visualisation of the results

Once we get our **Phenotype diagnostics** result, we can use `shinyDiagnostics` to easily create a shiny app and visualise our results:
    
    
    result <- [shinyDiagnostics](../reference/shinyDiagnostics.html)(result,
                               directory = [tempdir](https://rdrr.io/r/base/tempfile.html)(),
                               minCellCount = 5, 
                               open = TRUE)

Notice that we have specified the minimum number of counts (`minCellCount`) for suppression to be shown in the shiny app, and also that we want the shiny to be launched in a new R session (`open`). You can see the shiny app generated for this example in [here](https://dpa-pde-oxford.shinyapps.io/PhenotypeRShiny/).See [Shiny diagnostics vignette](https://ohdsi.github.io/PhenotypeR/articles/a02_ShinyDiagnostics.html) for a full explanation of the shiny app.

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/articles/PhenotypeExpectations.html

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

# Phenotype expectations

`PhenotypeExpectations.Rmd`

## Comparing phenotype diagnostic results against phenotype expectations

We use PhenotypeR to help assess the research readiness of a set of study cohorts. To help make such assessments it can help to have an explicit set of expectations to compare our results. For example, is the age of our study cohort similar to what would be expected? Is the proportion of the cohort that is male vs female similar to what would be expected based on what we know about the phenotype of interest?

### Creating phenotype expectations

We can define a set of expectations about what we expect to see in our phenotype diagnostic results. So that we can visualise these easily using the `[tableCohortExpectations()](../reference/tableCohortExpectations.html)` function, we will create a tibble with the following columns: cohort_name (so we know which expectation corresponds to which cohort), estimate (the estimate for which our expectation is associated with), value (our expectation on the value we should see in our results). As an example, say we have one cohort called “knee_osteoarthritis” and another called “knee_replacement”. We could create expectations about median age and the proportion that is male for each cohort like so.
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    
    knee_oa <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(cohort_name = "knee_osteoarthritis",
                      estimate = [c](https://rdrr.io/r/base/c.html)("Median age", "Proportion male"),
                      value = [c](https://rdrr.io/r/base/c.html)("60 to 65", "45%"),
                      source = "Clinician")
    knee_replacement <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(cohort_name = "knee_replacement",
                               estimate = [c](https://rdrr.io/r/base/c.html)("Median age", "Proportion male"),
                               value = [c](https://rdrr.io/r/base/c.html)("65 to 70", "50%"),
                               source = "Clinician")
    
    expectations <- [bind_rows](https://dplyr.tidyverse.org/reference/bind_rows.html)(knee_oa, knee_replacement)

Now we have our structured expectations, we can quickly create a summary of them (we’ll see in the next vignette how we can then also include them in our shiny app).
    
    
    [tableCohortExpectations](../reference/tableCohortExpectations.html)(expectations)

Note as long as we make sure to include our four required columns we can create any set of expectations that is relevant for our cohorts.
    
    
    [tibble](https://tibble.tidyverse.org/reference/tibble.html)(cohort_name = "knee_osteoarthritis",
                      estimate = [c](https://rdrr.io/r/base/c.html)("Commonly seen subsequent procedures"),
                      value = [c](https://rdrr.io/r/base/c.html)("Knee replacement"),
                      source = "Expert opinion") |> 
      [tableCohortExpectations](../reference/tableCohortExpectations.html)()

### Using an LLM to draft your phenotype expectations

The custom expectations created above might be based on our (or a friendly colleagues’) clinical knowledge. This though requires access to the requisite clinical knowledge and is often time-consuming, especially if we have many cohorts and start considering the many different estimates from phenotype diagnostics.

To speed up the process we can use an LLM to help us draft our expectations. We could use this to create a custom set. Here for example we’ll use Google Gemini to populate our expectations.

Notice that you may need first to create a Gemini API to run the example. You can do that following this link: <https://aistudio.google.com/app/apikey>. And then add the API in your R environment:
    
    
    usethis::[edit_r_environ](https://usethis.r-lib.org/reference/edit.html)()
    
    # Add your API in your R environment:
    GEMINI_API_KEY = "your API"
    
    # Restrart R
    
    
    [library](https://rdrr.io/r/base/library.html)([ellmer](https://ellmer.tidyverse.org))
    
    chat <- [chat](https://ellmer.tidyverse.org/reference/chat-any.html)("google_gemini")
    llm_expectation <- chat$chat(
        [interpolate](https://ellmer.tidyverse.org/reference/interpolate.html)("What are the typical characteristics we can expect to see in our real-world data for a cohort of people with an ankle sprain (average age, proportion male vs female, subsequent medications, etc)? Be brief and provide summar with a few sentences.")) 
    
    [tibble](https://tibble.tidyverse.org/reference/tibble.html)(cohort_name = "diagnosis_of_ankle_sprain",
           estimate = "General summary",
           value = llm_expectation,
           source = "llm") |> 
      [tableCohortExpectations](../reference/tableCohortExpectations.html)()

To help us create a consistent set of phenotype expectations from LLMs, PhenotypeR provides the `[getCohortExpectations()](../reference/getCohortExpectations.html)`. This function will generate a set of expectations that are associated with the various cohort diagnostic function results.
    
    
    [getCohortExpectations](../reference/getCohortExpectations.html)(chat = chat, 
                          phenotypes = [c](https://rdrr.io/r/base/c.html)("diagnosis_of_ankle_sprain", 
                                         "diagnosis_of_prostate_cancer", 
                                         "new_user_of_morphine")) |> 
      [tableCohortExpectations](../reference/tableCohortExpectations.html)()

Instead of passing our cohort names, we could instead pass our results set from `[phenotypeDiagnostics()](../reference/phenotypeDiagnostics.html)` instead. In this case we’ll automatically get expectations for each of the study cohorts in our results.
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
        con = con, cdmSchema = "main", writeSchema = "main", cdmName = "Eunomia"
      )
    
    codes <- [list](https://rdrr.io/r/base/list.html)("diagnosis_of_ankle_sprain" = 81151,
                  "diagnosis_of_prostate_cancer" = 4163261,
                  "new_user_of_morphine" = [c](https://rdrr.io/r/base/c.html)(1110410L, 35605858L, 40169988L))
    
    cdm$my_cohort <- [conceptCohort](https://ohdsi.github.io/CohortConstructor/reference/conceptCohort.html)(cdm = cdm,
                                     conceptSet = codes,
                                     exit = "event_end_date",
                                     name = "my_cohort")
    
    diag_results <- [phenotypeDiagnostics](../reference/phenotypeDiagnostics.html)(cdm$my_cohort)
    
    [getCohortExpectations](../reference/getCohortExpectations.html)(chat = chat, 
                          phenotypes = diag_results) |> 
      [tableCohortExpectations](../reference/tableCohortExpectations.html)()

Instead of Google Gemini we could use Mistral instead.
    
    
    chat <- ellmer::[chat](https://ellmer.tidyverse.org/reference/chat-any.html)("mistral")
    diag_results <- [phenotypeDiagnostics](../reference/phenotypeDiagnostics.html)(cdm$my_cohort)
    [getCohortExpectations](../reference/getCohortExpectations.html)(chat = chat, 
                          phenotypes = diag_results) |> 
      [tableCohortExpectations](../reference/tableCohortExpectations.html)()

It is important to note the importance of a descriptive cohort name. These are the names passed to the LLM and so the more informative the name, the better we can expect the LLM to do when generating our expectations. In general to make them amenable to the LLM workflow when naming cohorts we should:

  * avoid abbreviations as they could be misinterpreted
  * indicate type of cohort (e.g. “incident_diagnosis_of_knee_osteoarthritis”, “routine_measurement_of_creatine”, “new_user_of_paracetamol”)
  * include key eligibility criteria (e.g. “new_user_of_paracetamol_under_age_21”)



It should also go without saying that we should not treat the output of the LLM as the unequivocal truth. While LLM expectations may well prove a useful starting point, clinical judgement and knowledge of the data source at hand will still be vital in appropriately interpreting our results. Our typical workflow may well be using LLMs to help generate phenotype expectations for review by a clinical expert which should save them time while ensuring we have an appropriate set to compare our results against.

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/articles/ShinyDiagnostics.html

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

# Shiny diagnostics

`ShinyDiagnostics.Rmd`

## Introduction: Run ShinyDiagnostics

In the previous vignettes we have seen how to run a phenotype diagnostics and it’s expectations. ShinyDiagnostics can help us to visualise all the results in an interactive shiny app. See an example of how to run it below:
    
    
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                                    cdmName = "Eunomia Synpuf",
                                    cdmSchema   = "main",
                                    writeSchema = "main", 
                                    achillesSchema = "main")
    
    # Create a code lists
    codes <- [list](https://rdrr.io/r/base/list.html)("user_of_warfarin" = [c](https://rdrr.io/r/base/c.html)(1310149L, 40163554L),
                  "user_of_acetaminophen" = [c](https://rdrr.io/r/base/c.html)(1125315L, 1127078L, 1127433L, 40229134L, 
                                              40231925L, 40162522L, 19133768L),
                  "user_of_morphine" = [c](https://rdrr.io/r/base/c.html)(1110410L, 35605858L, 40169988L),
                  "measurements_cohort" = [c](https://rdrr.io/r/base/c.html)(40660437L, 2617206L, 4034850L,  2617239L, 
                                            4098179L))
    
    # Instantiate cohorts with CohortConstructor
    cdm$my_cohort <- [conceptCohort](https://ohdsi.github.io/CohortConstructor/reference/conceptCohort.html)(cdm = cdm,
                                   conceptSet = codes, 
                                   exit = "event_end_date",
                                   overlap = "merge",
                                   name = "my_cohort")
    
    # Run PhenotypeDiagnostics including all diagnostics
    result <- [phenotypeDiagnostics](../reference/phenotypeDiagnostics.html)(cdm$my_cohort, survival = TRUE)
    
    # Generate expectations
    chat <- [chat](https://ellmer.tidyverse.org/reference/chat-any.html)("google_gemini")
    
    expectations <- [getCohortExpectations](../reference/getCohortExpectations.html)(chat = chat, 
                          phenotypes = result)
    
    # Create the shiny app based on PhenotypeDiagnostics results, suppressing all 
    # cell counts smaller than 2, saved in a temporary directory, and with the 
    # expectations created using "gemini".
    [shinyDiagnostics](../reference/shinyDiagnostics.html)(result = result, minCellCount = 2, directory = [tempdir](https://rdrr.io/r/base/tempfile.html)(), expectations = expectations)

## Shiny App Overview

Let’s now explore the Shiny App created together! Please, find it [here](https://dpa-pde-oxford.shinyapps.io/Readme_PhenotypeR/).

The first thing we will find when creating the PhenotypeR Shiny Diagnostics is a **Background** tab with a small summary of all the diagnostics:

![](https://images.tango.us/workflows/ca96746e-ccf0-443d-9d2a-4d05dfd09b79/steps/b4b51d14-328e-4af6-998e-ea93e9b3e145/d15f4486-c1d1-4fca-a8be-6c6612a205a0.png?crop=focalpoint&fit=crop&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n)

You can see which PhenotypeR version was used to generate the Shiny App by clicking the _i_ tab at the top.

![](https://images.tango.us/workflows/ca96746e-ccf0-443d-9d2a-4d05dfd09b79/steps/d840b82f-65e7-4e72-8e9c-75d75b408f04/f16eada5-592e-47b2-8536-a73815fe6fad.png?crop=focalpoint&fit=crop&fp-x=0.9490&fp-y=0.0417&fp-z=3.0761&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=977&mark-y=81&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz03MCZoPTcwJmZpdD1jcm9wJmNvcm5lci1yYWRpdXM9MTA%3D)

Or download the summarised result by clicking the _download_ tab:

![](https://images.tango.us/workflows/ca96746e-ccf0-443d-9d2a-4d05dfd09b79/steps/753afbf7-e341-4364-9d02-e0152aec396a/f0cef53a-0350-4dd0-84e9-e74da6050ee0.png?crop=focalpoint&fit=crop&fp-x=0.9746&fp-y=0.0417&fp-z=3.0761&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=1071&mark-y=81&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz03MCZoPTcwJmZpdD1jcm9wJmNvcm5lci1yYWRpdXM9MTA%3D)

Notice that we have a tab for each one of the diagnostics, and those contain the specific analyses performed. Results are visualised in the form of interactive tables and plots.

**Database Diagnostics:**

![](https://images.tango.us/workflows/ca96746e-ccf0-443d-9d2a-4d05dfd09b79/steps/74de0ecb-abbc-4fa9-93e1-c253fa07a5bb/951f5b8b-ed55-40b8-b9c3-b533ef9948c8.png?crop=focalpoint&fit=crop&fp-x=0.3008&fp-y=0.0420&fp-z=2.1606&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=389&mark-y=31&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz00MjImaD0xMDMmZml0PWNyb3AmY29ybmVyLXJhZGl1cz0xMA%3D%3D)

**Codelist Diagnostics:**

![](https://images.tango.us/workflows/ca96746e-ccf0-443d-9d2a-4d05dfd09b79/steps/dbdef269-1bc9-43c3-95b8-8cd9b8aa9333/26e29e56-a2f5-4807-a207-9a776e37e386.png?crop=focalpoint&fit=crop&fp-x=0.4671&fp-y=0.0420&fp-z=2.1940&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=395&mark-y=31&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz00MTAmaD0xMDUmZml0PWNyb3AmY29ybmVyLXJhZGl1cz0xMA%3D%3D)

**Cohort Diagnostics:**

![](https://images.tango.us/workflows/ca96746e-ccf0-443d-9d2a-4d05dfd09b79/steps/4d9e0589-20b1-4044-8dbd-f891587e8cb3/3819d210-4245-4d8c-b84f-651b6af2a7eb.png?crop=focalpoint&fit=crop&fp-x=0.6256&fp-y=0.0420&fp-z=2.2286&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=401&mark-y=32&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz0zOTgmaD0xMDYmZml0PWNyb3AmY29ybmVyLXJhZGl1cz0xMA%3D%3D)

**Population Diagnostics:**

![](https://images.tango.us/workflows/ca96746e-ccf0-443d-9d2a-4d05dfd09b79/steps/4f39b227-4d43-4096-bdc8-e837b9162f0e/51726bf5-6b93-49b9-9fdd-da2a9ac4588f.png?crop=focalpoint&fit=crop&fp-x=0.7897&fp-y=0.0420&fp-z=2.8368&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=312&mark-y=41&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz01NzUmaD0xMzUmZml0PWNyb3AmY29ybmVyLXJhZGl1cz0xMA%3D%3D)

Let’s now explore additional functionalities that the ShinyDiagnostics offers. If we click to _Codelist diagnostics / Achilles code use_ or _Codelist diagnostics / Orphan code use_ tab, we will first find a horizontal purple bar that will show us all the databases we included:

![](https://images.tango.us/workflows/ca96746e-ccf0-443d-9d2a-4d05dfd09b79/steps/bfcca651-f44a-435e-84a5-d54a55f5c7b2/7329950d-353f-4327-b692-3f9aca309dd8.png?crop=focalpoint&fit=crop&fp-x=0.2654&fp-y=0.2191&fp-z=2.0622&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=371&mark-y=366&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz00NTgmaD04OCZmaXQ9Y3JvcCZjb3JuZXItcmFkaXVzPTEw)

Once we have selected the ones of interest, we will need to click the **UPDATE** button to generate the table with the results.

For **Codelist diagnostics / cohort code use** , *Codelist diagnostics / measurement diagnostics**,** Cohort diagnostics**and** Population diagnostics**, we will also have the option to select the cohorts of interest:

![](https://images.tango.us/workflows/ca96746e-ccf0-443d-9d2a-4d05dfd09b79/steps/2ee82c56-6ed2-4975-9ffa-be595cf1d8cd/692fc4b7-ea4a-4d5c-a79d-6270de4688ed.png?crop=focalpoint&fit=crop&fp-x=0.4998&fp-y=0.0484&fp-z=1.0062&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=4&mark-y=2&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz0xMTkyJmg9ODQmZml0PWNyb3AmY29ybmVyLXJhZGl1cz0xMA%3D%3D)

We will always find (in all the tabs) a _download_ icon on the right which will download the table, gt table, or plot that is being shown:

![](https://images.tango.us/workflows/ca96746e-ccf0-443d-9d2a-4d05dfd09b79/steps/c97c9f65-afb1-485d-8fff-7d6fbacffb34/71ec72da-5426-434b-893e-273f5ac4353f.png?crop=focalpoint&fit=crop&fp-x=0.8963&fp-y=0.3451&fp-z=2.8797&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=775&mark-y=392&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz0xMzQmaD0xMjQmZml0PWNyb3AmY29ybmVyLXJhZGl1cz0xMA%3D%3D)

In some tabs, we will also find a left tab that will show additional filtering or formatting options (remember to click **UPDATE** every time you change a parameter!):

![](https://images.tango.us/workflows/ca96746e-ccf0-443d-9d2a-4d05dfd09b79/steps/12d15497-9f91-4741-bcf0-ed741f144717/80a95e21-0b19-4e62-88fc-27db5fdd0531.png?crop=focalpoint&fit=crop&fp-x=0.4932&fp-y=0.0484&fp-z=1.0062&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=7&mark-y=2&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz0xMTc2Jmg9ODQmZml0PWNyb3AmY29ybmVyLXJhZGl1cz0xMA%3D%3D)

When we have two (or more) subtabs with different formatting formats (which is the case for _Population diagnositcs / Incidence_ , where we have a table and a plot), the formatting tab will be on the right:

![](https://images.tango.us/workflows/ca96746e-ccf0-443d-9d2a-4d05dfd09b79/steps/a8b29859-4641-47ff-9f18-3d3543a09a72/785acbac-8afb-4c48-847d-f3433809f7b2.png?crop=focalpoint&fit=crop&fp-x=0.5000&fp-y=0.5000&fp-z=1.0018&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=1&mark-y=1&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz0xMTk4Jmg9OTA1JmZpdD1jcm9wJmNvcm5lci1yYWRpdXM9MTA%3D)

Now it’s your turn to explore the [Shiny App](https://dpa-pde-oxford.shinyapps.io/Readme_PhenotypeR/)!

## Special cases

As mentioned, `ShinyDiagnostics()` can be run with specific diagnostic results. This includes `DatabaseDiagnostics()`, `CodelistDiagnostics()`, `CohortDiagnostics()`, and `PopulationDiagnostics()`. Alternatively, you can disable diagnostics within `PhenotypeDiagnostics()`. If a diagnostic is not performed, its corresponding tab will not appear in the Shiny App. Similarly, if survival analysis is skipped in `CohortDiagnostics()`, its tab will be removed. The same applies if your CDM lacks ACHILLES tables, which means “achilles code use” and “orphan code use” cannot be performed. In such cases, their tabs will also be automatically removed from the Shiny App.

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/articles/DatabaseDiagnostics.html

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

`DatabaseDiagnostics.Rmd`

## Introduction

In this example we’re going to be using the Eunomia synthetic data.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                                    cdmName = "Eunomia Synpuf",
                                    cdmSchema   = "main",
                                    writeSchema = "main", 
                                    achillesSchema = "main")

## Database diagnostics

Although we may have created our study cohort, to inform analytic decisions and interpretation of results requires an understanding of the dataset from which it has been derived. The `[databaseDiagnostics()](../reference/databaseDiagnostics.html)` function will help us better understand a data source.

To run database diagnostics we just need to provide our cdm reference to the function.
    
    
    db_diagnostics <- [databaseDiagnostics](../reference/databaseDiagnostics.html)(cdm)

Database diagnostics builds on [OmopSketch](https://ohdsi.github.io/OmopSketch/index.html) package to perform the following analyses:

  * **Snapshot:** Summarises the meta data of a CDM object by using [summariseOmopSnapshot()](https://ohdsi.github.io/OmopSketch/reference/summariseOmopSnapshot.html)
  * **Observation periods:** Summarises the observation period table by using [summariseObservationPeriod()](https://ohdsi.github.io/OmopSketch/reference/summariseObservationPeriod.html). This will allow us to see if there are individuals with multiple, non-overlapping, observation periods and how long each observation period lasts on average.



The output is a summarised result object.

## Visualise the results

We can use [OmopSketch](https://ohdsi.github.io/OmopSketch/index.html) package functions to visualise the results obtained.

### Snapshot
    
    
    [tableOmopSnapshot](https://OHDSI.github.io/OmopSketch/reference/tableOmopSnapshot.html)(db_diagnostics)

Estimate |  Database name  
---|---  
Eunomia Synpuf  
General  
Snapshot date | 2025-09-17  
Person count | 1,000  
Vocabulary version | v5.0 06-AUG-21  
Observation period  
N | 1,048  
Start date | 2008-01-01  
End date | 2010-12-31  
Cdm  
Source name | Synpuf  
Version | v5.3.1  
Holder name | ohdsi  
Release date | 2018-03-15  
Description |   
Documentation reference |   
Source type | duckdb  
  
### Observation periods
    
    
    [tableObservationPeriod](https://OHDSI.github.io/OmopSketch/reference/tableObservationPeriod.html)(db_diagnostics)

Observation period ordinal | Variable name | Estimate name |  CDM name  
---|---|---|---  
Eunomia Synpuf  
all | Number records | N | 1,048  
| Number subjects | N | 1,000  
| Records per person | mean (sd) | 1.05 (0.21)  
|  | median [Q25 - Q75] | 1 [1 - 1]  
| Duration in days | mean (sd) | 979.71 (262.79)  
|  | median [Q25 - Q75] | 1,096 [1,096 - 1,096]  
| Days to next observation period | mean (sd) | 172.17 (108.35)  
|  | median [Q25 - Q75] | 138 [93 - 254]  
1st | Number subjects | N | 1,000  
| Duration in days | mean (sd) | 994.16 (257.95)  
|  | median [Q25 - Q75] | 1,096 [1,096 - 1,096]  
| Days to next observation period | mean (sd) | 172.17 (108.35)  
|  | median [Q25 - Q75] | 138 [93 - 254]  
2nd | Number subjects | N | 48  
| Duration in days | mean (sd) | 678.60 (164.50)  
|  | median [Q25 - Q75] | 730 [730 - 730]  
| Days to next observation period | mean (sd) | -  
|  | median [Q25 - Q75] | -  
  
## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/articles/CodelistDiagnostics.html

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

# Codelist diagnostics

`CodelistDiagnostics.Rmd`

## Introduction

In this example we’re going to summarise the characteristics of individuals with an ankle sprain, ankle fracture, forearm fracture, a hip fracture and different measurements using the Eunomia synthetic data.

We’ll begin by creating our study cohorts.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    [library](https://rdrr.io/r/base/library.html)([MeasurementDiagnostics](https://ohdsi.github.io/MeasurementDiagnostics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                                    cdmName = "Eunomia Synpuf",
                                    cdmSchema   = "main",
                                    writeSchema = "main", 
                                    achillesSchema = "main")
    
    cdm$injuries <- [conceptCohort](https://ohdsi.github.io/CohortConstructor/reference/conceptCohort.html)(cdm = cdm,
      conceptSet = [list](https://rdrr.io/r/base/list.html)(
        "ankle_sprain" = 81151,
        "ankle_fracture" = 4059173,
        "forearm_fracture" = 4278672,
        "hip_fracture" = 4230399,
        "measurements_cohort" = [c](https://rdrr.io/r/base/c.html)(40660437L, 2617206L, 4034850L,  2617239L, 4098179L)
      ),
      name = "injuries")
    cdm$injuries |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/RtmpO08e18/file22d365fad4ab.duckdb]
    #> $ cohort_definition_id <int> 2, 2, 5, 5, 2, 5, 5, 5, 5, 5, 5, 5, 5, 5, 2, 5, 5…
    #> $ subject_id           <int> 147, 304, 147, 554, 429, 652, 449, 1052, 309, 663…
    #> $ cohort_start_date    <date> 2008-03-29, 2010-01-16, 2008-12-22, 2009-06-02, …
    #> $ cohort_end_date      <date> 2008-03-29, 2010-01-16, 2008-12-22, 2009-06-02, …

## Summarising code use

To get a good understanding of the codes we’ve used to define our cohorts we can use the `[codelistDiagnostics()](../reference/codelistDiagnostics.html)` function.
    
    
    code_diag <- [codelistDiagnostics](../reference/codelistDiagnostics.html)(cdm$injuries)

Codelist diagnostics builds on [CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/) and [MeasurementDiagnostics](https://ohdsi.github.io/MeasurementDiagnostics/) R packages to perform the following analyses:

  * **Achilles code use:** Which summarises the counts of our codes in our database based on achilles results using [summariseAchillesCodeUse()](https://darwin-eu.github.io/CodelistGenerator/reference/summariseAchillesCodeUse.html).
  * **Orphan code use:** Orphan codes refer to codes that we did not include in our cohort definition, but that have any relationship with the codes in our codelist. So, although many can be false positives, we may identify some codes that we may want to use in our cohort definitions. This analysis uses [summariseOrphanCodes()](https://darwin-eu.github.io/CodelistGenerator/reference/summariseOrphanCodes.html).
  * **Cohort code use:** Summarises the cohort code use in our cohort using [summariseCohortCodeUse()](https://darwin-eu.github.io/CodelistGenerator/reference/summariseCohortCodeUse.html).
  * **Measurement diagnostics:** If any of the concepts used in our codelist is a measurement, it summarises its code use using [summariseCohortMeasurementUse()](https://ohdsi.github.io/MeasurementDiagnostics/reference/summariseCohortMeasurementUse.html).



The output of a function is a summarised result table.

### Add codelist attribute

Some cohorts that may be created manually may not have the codelists recorded in the `cohort_codelist` attribute. The package has a utility function to record a codelist in a `cohort_table` object:
    
    
    [cohortCodelist](https://darwin-eu.github.io/omopgenerics/reference/cohortCodelist.html)(cdm$injuries, cohortId = 1)
    #> 
    #> - ankle_fracture (1 codes)
    cdm$injuries <- cdm$injuries |>
      [addCodelistAttribute](../reference/addCodelistAttribute.html)(codelist = [list](https://rdrr.io/r/base/list.html)(new_codelist = [c](https://rdrr.io/r/base/c.html)(1L, 2L)), cohortName = "ankle_fracture")
    [cohortCodelist](https://darwin-eu.github.io/omopgenerics/reference/cohortCodelist.html)(cdm$injuries, cohortId = 1)
    #> 
    #> - new_codelist (2 codes)

## Visualise the results

We will now use different functions to visualise the results generated by CohortDiagnostics. Notice that these functions are from [CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/) and [MeasurementDiagnostics](https://ohdsi.github.io/MeasurementDiagnostics/) R packages packages.

### Achilles code use
    
    
    [tableAchillesCodeUse](https://darwin-eu.github.io/CodelistGenerator/reference/tableAchillesCodeUse.html)(code_diag)

|  Database name  
---|---  
|  Eunomia Synpuf  
Codelist name | Domain ID | Standard concept name | Standard concept ID | Standard concept | Vocabulary ID |  Estimate name  
Record count | Person count  
ankle_sprain | condition | Sprain of ankle | 81151 | standard | SNOMED | 31 | 27  
measurements_cohort | measurement | Prostate cancer screening; prostate specific antigen test (psa) | 2617206 | standard | HCPCS | 146 | 124  
|  | Screening cytopathology, cervical or vaginal (any reporting system), collected in preservative fluid, automated thin layer preparation, with screening by automated system and manual rescreening under physician supervision | 2617239 | standard | HCPCS | 52 | 47  
|  | Laboratory test | 4034850 | standard | SNOMED | 101 | 95  
|  | Drug screen, qualitative; multiple drug classes by high complexity test method (e.g., immunoassay, enzyme assay), per patient encounter | 40660437 | standard | HCPCS | 45 | 26  
|  | Immunology laboratory test | 4098179 | standard | SNOMED | 20 | 20  
  
### Orphan code use
    
    
    [tableOrphanCodes](https://darwin-eu.github.io/CodelistGenerator/reference/tableOrphanCodes.html)(code_diag)

|  Database name  
---|---  
|  Eunomia Synpuf  
Codelist name | Domain ID | Standard concept name | Standard concept ID | Standard concept | Vocabulary ID |  Estimate name  
Record count | Person count  
ankle_fracture | condition | Open fracture of medial malleolus | 432749 | standard | SNOMED | 3 | 3  
|  | Open fracture of lateral malleolus | 437998 | standard | SNOMED | 3 | 3  
|  | Closed bimalleolar fracture | 438879 | standard | SNOMED | 9 | 7  
|  | Closed fracture of medial malleolus | 439162 | standard | SNOMED | 4 | 3  
|  | Open bimalleolar fracture | 441154 | standard | SNOMED | 1 | 1  
|  | Closed trimalleolar fracture | 441155 | standard | SNOMED | 5 | 4  
|  | Closed fracture of lateral malleolus | 441428 | standard | SNOMED | 21 | 12  
|  | Closed fracture of talus | 74777 | standard | SNOMED | 2 | 2  
|  | Closed fracture of ankle | 75095 | standard | SNOMED | 19 | 16  
|  | Open fracture of talus | 77131 | standard | SNOMED | 2 | 2  
|  | Open fracture of ankle | 78888 | standard | SNOMED | 5 | 4  
ankle_sprain | condition | Sprain of distal tibiofibular ligament | 73889 | standard | SNOMED | 4 | 4  
|  | Sprain of calcaneofibular ligament | 75667 | standard | SNOMED | 1 | 1  
|  | Sprain of deltoid ligament of ankle | 77707 | standard | SNOMED | 4 | 4  
forearm_fracture | condition | Closed fracture of shaft of bone of forearm | 4101989 | standard | SNOMED | 1 | 1  
|  | Open fracture of shaft of bone of forearm | 4195752 | standard | SNOMED | 2 | 2  
|  | Open fracture of neck of radius | 432744 | standard | SNOMED | 1 | 1  
|  | Open fracture of lower end of radius AND ulna | 432747 | standard | SNOMED | 1 | 1  
|  | Open fracture of proximal end of ulna | 433047 | standard | SNOMED | 2 | 2  
|  | Open fracture of shaft of ulna | 433333 | standard | SNOMED | 1 | 1  
|  | Open Colles' fracture | 434767 | standard | SNOMED | 2 | 2  
|  | Open fracture of upper end of forearm | 434771 | standard | SNOMED | 1 | 1  
|  | Closed fracture of distal end of ulna | 435374 | standard | SNOMED | 4 | 3  
|  | Closed fracture of radius AND ulna | 435380 | standard | SNOMED | 6 | 6  
|  | Closed Colles' fracture | 435950 | standard | SNOMED | 20 | 13  
|  | Closed fracture of proximal end of ulna | 436251 | standard | SNOMED | 1 | 1  
|  | Closed fracture of ulna | 436541 | standard | SNOMED | 1 | 1  
|  | Closed fracture of shaft of radius | 436826 | standard | SNOMED | 2 | 2  
|  | Closed fracture of neck of radius | 436837 | standard | SNOMED | 3 | 2  
|  | Closed fracture of distal end of radius | 437116 | standard | SNOMED | 48 | 33  
|  | Open fracture of lower end of forearm | 437122 | standard | SNOMED | 1 | 1  
|  | Open fracture of upper end of radius AND ulna | 437393 | standard | SNOMED | 1 | 1  
|  | Closed fracture of lower end of forearm | 437394 | standard | SNOMED | 4 | 3  
|  | Closed fracture of shaft of ulna | 437400 | standard | SNOMED | 1 | 1  
|  | Open fracture of ulna | 438576 | standard | SNOMED | 1 | 1  
|  | Closed fracture of radius | 439166 | standard | SNOMED | 11 | 7  
|  | Closed fracture of upper end of forearm | 439940 | standard | SNOMED | 4 | 3  
|  | Pathological fracture - forearm | 440511 | standard | SNOMED | 1 | 1  
|  | Closed fracture of lower end of radius AND ulna | 440538 | standard | SNOMED | 6 | 5  
|  | Closed fracture of upper end of radius AND ulna | 440544 | standard | SNOMED | 6 | 2  
|  | Open fracture of distal end of radius | 440546 | standard | SNOMED | 3 | 3  
|  | Open fracture of forearm | 440851 | standard | SNOMED | 1 | 1  
|  | Closed fracture of proximal end of radius | 441973 | standard | SNOMED | 3 | 3  
|  | Closed fracture of forearm | 441974 | standard | SNOMED | 1 | 1  
|  | Fracture of radius AND ulna | 442598 | standard | SNOMED | 1 | 1  
|  | Torus fracture of radius | 443428 | standard | SNOMED | 1 | 1  
|  | Closed fracture of olecranon process of ulna | 73036 | standard | SNOMED | 7 | 5  
|  | Closed fracture of head of radius | 73341 | standard | SNOMED | 6 | 4  
|  | Open fracture of coronoid process of ulna | 74192 | standard | SNOMED | 1 | 1  
|  | Open fracture of olecranon process of ulna | 74763 | standard | SNOMED | 4 | 4  
|  | Closed Monteggia's fracture | 79165 | standard | SNOMED | 1 | 1  
|  | Closed fracture of coronoid process of ulna | 79172 | standard | SNOMED | 2 | 2  
|  | Open Monteggia's fracture | 81148 | standard | SNOMED | 1 | 1  
hip_fracture | condition | Closed intertrochanteric fracture | 136834 | standard | SNOMED | 56 | 38  
|  | Closed fracture proximal femur, subtrochanteric | 4009610 | standard | SNOMED | 12 | 9  
|  | Closed fracture of neck of femur | 434500 | standard | SNOMED | 144 | 77  
|  | Closed fracture of base of neck of femur | 435956 | standard | SNOMED | 15 | 10  
|  | Closed fracture of midcervical section of femur | 436247 | standard | SNOMED | 16 | 14  
|  | Closed fracture of intracapsular section of femur | 437703 | standard | SNOMED | 8 | 7  
|  | Closed transcervical fracture of femur | 440556 | standard | SNOMED | 20 | 17  
|  | Closed fracture of acetabulum | 81696 | standard | SNOMED | 10 | 6  
measurements_cohort | procedure | Antibody screen, RBC, each serum technique | 2212937 | standard | CPT4 | 55 | 53  
|  | Antibody identification, RBC antibodies, each panel for each serum technique | 2212939 | standard | CPT4 | 1 | 1  
|  | Pathology consultation during surgery; cytologic examination (eg, touch prep, squash prep), initial site | 2213298 | standard | CPT4 | 3 | 3  
| measurement | Screening cytopathology, cervical or vaginal (any reporting system), collected in preservative fluid, automated thin layer preparation, requiring interpretation by physician | 2617226 | standard | HCPCS | 1 | 1  
|  | Screening cytopathology smears, cervical or vaginal, performed by automated system with manual rescreening | 2617241 | standard | HCPCS | 1 | 1  
|  | Wet mounts, including preparations of vaginal, cervical or skin specimens | 2720582 | standard | HCPCS | 1 | 1  
|  | Detection of parasite | 4047338 | standard | SNOMED | 3 | 3  
|  | Antenatal RhD antibody screening | 4060266 | standard | SNOMED | 8 | 8  
|  | Type 1 hypersensitivity skin test | 4091110 | standard | SNOMED | 3 | 3  
|  | Hematology screening test | 4198132 | standard | SNOMED | 20 | 20  
|  | Sickle cell disease screening test | 4199173 | standard | SNOMED | 9 | 9  
|  | Microscopic examination of cervical Papanicolaou smear | 4208622 | standard | SNOMED | 10 | 10  
|  | Genetic test | 4237017 | standard | SNOMED | 23 | 23  
|  | Blood group typing | 4258677 | standard | SNOMED | 14 | 14  
|  | Microscopic examination of vaginal Papanicolaou smear | 4258831 | standard | SNOMED | 22 | 22  
  
### Cohort code use
    
    
    [tableCohortCodeUse](https://darwin-eu.github.io/CodelistGenerator/reference/tableCohortCodeUse.html)(code_diag)

|  Database name  
---|---  
|  Eunomia Synpuf  
Cohort name | Codelist name | Standard concept name | Standard concept ID | Source concept name | Source concept ID | Source concept value | Domain ID | Diagnostic | Phenotyper version |  Estimate name  
Person count | Record count  
ankle_sprain | ankle_sprain | Sprain of ankle | 81151 | Other sprains and strains of ankle | 44829371 | 84509 | condition | codelistDiagnostics | 0.2.0 | 6 | 6  
|  |  |  | Sprain of ankle, unspecified site | 44820150 | 84500 | condition | codelistDiagnostics | 0.2.0 | 23 | 25  
|  | overall | - | NA | NA | NA | NA | codelistDiagnostics | 0.2.0 | 27 | 31  
measurements_cohort | measurements_cohort | Drug screen, qualitative; multiple drug classes by high complexity test method (e.g., immunoassay, enzyme assay), per patient encounter | 40660437 | Drug screen, qualitative; multiple drug classes by high complexity test method (e.g., immunoassay, enzyme assay), per patient encounter | 40660437 | G0431 | measurement | codelistDiagnostics | 0.2.0 | 26 | 45  
|  | Immunology laboratory test | 4098179 | Antibody response examination | 44830850 | V7261 | measurement | codelistDiagnostics | 0.2.0 | 11 | 11  
|  |  |  | Other and unspecified nonspecific immunological findings | 44830461 | 79579 | measurement | codelistDiagnostics | 0.2.0 | 9 | 9  
|  | Laboratory test | 4034850 | Laboratory examination | 44836706 | V726 | measurement | codelistDiagnostics | 0.2.0 | 45 | 48  
|  |  |  | Laboratory examination ordered as part of a routine general medical examination | 44823881 | V7262 | measurement | codelistDiagnostics | 0.2.0 | 14 | 14  
|  |  |  | Laboratory examination, unspecified | 44835527 | V7260 | measurement | codelistDiagnostics | 0.2.0 | 16 | 16  
|  |  |  | Other laboratory examination | 44835528 | V7269 | measurement | codelistDiagnostics | 0.2.0 | 13 | 13  
|  |  |  | Pre-procedural laboratory examination | 44827407 | V7263 | measurement | codelistDiagnostics | 0.2.0 | 10 | 10  
|  | Prostate cancer screening; prostate specific antigen test (psa) | 2617206 | Prostate cancer screening; prostate specific antigen test (psa) | 2617206 | G0103 | measurement | codelistDiagnostics | 0.2.0 | 124 | 146  
|  | Screening cytopathology, cervical or vaginal (any reporting system), collected in preservative fluid, automated thin layer preparation, with screening by automated system and manual rescreening under physician supervision | 2617239 | Screening cytopathology, cervical or vaginal (any reporting system), collected in preservative fluid, automated thin layer preparation, with screening by automated system and manual rescreening under physician supervision | 2617239 | G0145 | measurement | codelistDiagnostics | 0.2.0 | 47 | 52  
|  | overall | - | NA | NA | NA | NA | codelistDiagnostics | 0.2.0 | 255 | 364  
  
### Measurement timings
    
    
    [tableMeasurementTimings](https://ohdsi.github.io/MeasurementDiagnostics/reference/tableMeasurementTimings.html)(code_diag)

CDM name | Cohort name | Variable name | Estimate name | Estimate value  
---|---|---|---|---  
measurements_cohort  
Eunomia Synpuf | measurements_cohort | Number records | N | 364  
|  | Number subjects | N | 255  
|  | Time (days) | Median [Q25 - Q75] | 150 [19 - 356]  
|  |  | Range | 0 to 930  
|  | Measurements per subject | Median [Q25 - Q75] | 2.00 [1.00 - 2.00]  
|  |  | Range | 1.00 to 10.00  
      
    
    [plotMeasurementTimings](https://ohdsi.github.io/MeasurementDiagnostics/reference/plotMeasurementTimings.html)(code_diag)

![](CodelistDiagnostics_files/figure-html/unnamed-chunk-9-1.png)

### Measurement value as concept
    
    
    [tableMeasurementValueAsConcept](https://ohdsi.github.io/MeasurementDiagnostics/reference/tableMeasurementValueAsConcept.html)(code_diag)

CDM name | Cohort name | Concept name | Concept ID | Domain ID | Variable name | Value as concept name | Value as concept ID | Estimate name | Estimate value  
---|---|---|---|---|---|---|---|---|---  
measurements_cohort  
Eunomia Synpuf | measurements_cohort | overall | overall | overall | Value as concept name | No matching concept | 0 | N (%) | 364 (100.00%)  
|  | Immunology laboratory test | 4098179 | Measurement | Value as concept name | No matching concept | 0 | N (%) | 20 (100.00%)  
|  | Laboratory test | 4034850 | Measurement | Value as concept name | No matching concept | 0 | N (%) | 101 (100.00%)  
|  | Prostate cancer screening; prostate specific antigen test (psa) | 2617206 | Measurement | Value as concept name | No matching concept | 0 | N (%) | 146 (100.00%)  
|  | Screening cytopathology, cervical or vaginal (any reporting system), collected in preservative fluid, automated thin layer preparation, with screening by automated system and manual rescreening under physician supervision | 2617239 | Measurement | Value as concept name | No matching concept | 0 | N (%) | 52 (100.00%)  
|  | Drug screen, qualitative; multiple drug classes by high complexity test method (e.g., immunoassay, enzyme assay), per patient encounter | 40660437 | Measurement | Value as concept name | No matching concept | 0 | N (%) | 45 (100.00%)  
      
    
    [plotMeasurementValueAsConcept](https://ohdsi.github.io/MeasurementDiagnostics/reference/plotMeasurementValueAsConcept.html)(code_diag)

![](CodelistDiagnostics_files/figure-html/unnamed-chunk-11-1.png)

### Measurement value as numeric
    
    
    [tableMeasurementValueAsNumeric](https://ohdsi.github.io/MeasurementDiagnostics/reference/tableMeasurementValueAsNumeric.html)(code_diag)

CDM name | Cohort name | Concept name | Concept ID | Domain ID | Unit concept name | Unit concept ID | Estimate name | Estimate value  
---|---|---|---|---|---|---|---|---  
measurements_cohort  
Eunomia Synpuf | measurements_cohort | overall | overall | overall | No matching concept | 0 | N | 364  
|  |  |  |  |  |  | Median [Q25 - Q75] | -  
|  |  |  |  |  |  | Q05 - Q95 | -  
|  |  |  |  |  |  | Q01 - Q99 | -  
|  |  |  |  |  |  | Range | -  
|  |  |  |  |  |  | Missing value, N (%) | 364 (100.00%)  
|  | Prostate cancer screening; prostate specific antigen test (psa) | 2617206 | Measurement | No matching concept | 0 | N | 146  
|  |  |  |  |  |  | Median [Q25 - Q75] | -  
|  |  |  |  |  |  | Q05 - Q95 | -  
|  |  |  |  |  |  | Q01 - Q99 | -  
|  |  |  |  |  |  | Range | -  
|  |  |  |  |  |  | Missing value, N (%) | 146 (100.00%)  
|  | Laboratory test | 4034850 | Measurement | No matching concept | 0 | N | 101  
|  |  |  |  |  |  | Median [Q25 - Q75] | -  
|  |  |  |  |  |  | Q05 - Q95 | -  
|  |  |  |  |  |  | Q01 - Q99 | -  
|  |  |  |  |  |  | Range | -  
|  |  |  |  |  |  | Missing value, N (%) | 101 (100.00%)  
|  | Screening cytopathology, cervical or vaginal (any reporting system), collected in preservative fluid, automated thin layer preparation, with screening by automated system and manual rescreening under physician supervision | 2617239 | Measurement | No matching concept | 0 | N | 52  
|  |  |  |  |  |  | Median [Q25 - Q75] | -  
|  |  |  |  |  |  | Q05 - Q95 | -  
|  |  |  |  |  |  | Q01 - Q99 | -  
|  |  |  |  |  |  | Range | -  
|  |  |  |  |  |  | Missing value, N (%) | 52 (100.00%)  
|  | Drug screen, qualitative; multiple drug classes by high complexity test method (e.g., immunoassay, enzyme assay), per patient encounter | 40660437 | Measurement | No matching concept | 0 | N | 45  
|  |  |  |  |  |  | Median [Q25 - Q75] | -  
|  |  |  |  |  |  | Q05 - Q95 | -  
|  |  |  |  |  |  | Q01 - Q99 | -  
|  |  |  |  |  |  | Range | -  
|  |  |  |  |  |  | Missing value, N (%) | 45 (100.00%)  
|  | Immunology laboratory test | 4098179 | Measurement | No matching concept | 0 | N | 20  
|  |  |  |  |  |  | Median [Q25 - Q75] | -  
|  |  |  |  |  |  | Q05 - Q95 | -  
|  |  |  |  |  |  | Q01 - Q99 | -  
|  |  |  |  |  |  | Range | -  
|  |  |  |  |  |  | Missing value, N (%) | 20 (100.00%)  
      
    
    [plotMeasurementValueAsNumeric](https://ohdsi.github.io/MeasurementDiagnostics/reference/plotMeasurementValueAsNumeric.html)(code_diag)

![](CodelistDiagnostics_files/figure-html/unnamed-chunk-13-1.png)

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/articles/CohortDiagnostics.html

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

# Cohort diagnostics

`CohortDiagnostics.Rmd`

## Introduction

In this example we’re going to summarise cohort diagnostics results for cohorts of individuals with an ankle sprain, ankle fracture, forearm fracture, or a hip fracture using the Eunomia synthetic data.

Again, we’ll begin by creating our study cohorts.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([CohortSurvival](https://darwin-eu-dev.github.io/CohortSurvival/))
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                                    cdmName = "Eunomia Synpuf",
                                    cdmSchema   = "main",
                                    writeSchema = "main", 
                                    achillesSchema = "main")
    
    cdm$injuries <- [conceptCohort](https://ohdsi.github.io/CohortConstructor/reference/conceptCohort.html)(cdm = cdm,
      conceptSet = [list](https://rdrr.io/r/base/list.html)(
        "ankle_sprain" = 81151,
        "ankle_fracture" = 4059173,
        "forearm_fracture" = 4278672,
        "hip_fracture" = 4230399
      ),
      name = "injuries")

## Cohort diagnostics

We can run cohort diagnostics analyses for each of our overall cohorts like so:
    
    
    cohort_diag <- [cohortDiagnostics](../reference/cohortDiagnostics.html)(cdm$injuries, 
                                     cohortSample = NULL,
                                     matchedSample = NULL,
                                     survival = TRUE)

Cohort diagnostics builds on [CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/) and [CohortSurvival](https://darwin-eu-dev.github.io/CohortSurvival/) R packages to perform the following analyses on our cohorts:

  * **Cohort count:** Summarises the number of records and persons in each one of the cohorts using [summariseCohortCount()](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortCount.html).
  * **Cohort attrition:** Summarises the attrition associated with the cohorts using [summariseCohortAttrition()](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html).
  * **Cohort characteristics:** Summarises cohort baseline characteristics using [summariseCharacteristics()](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCharacteristics.html). Results are stratified by sex and by age group (0 to 17, 18 to 64, 65 to 150). Age groups cannot be modified.
  * **Cohort large scale characteristics:** Summarises cohort large scale characteristics using [summariseLargeScaleCharacteristics()](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseLargeScaleCharacteristics.html). Results are stratified by sex and by age group (0 to 17, 18 to 64, 65 to 150). Time windows (relative to cohort entry) included are: -Inf to -1, -Inf to -366, -365 to -31, -30 to -1, 0, 1 to 30, 31 to 365, 366 to Inf, and 1 to Inf. The analysis is perform at standard and source code level.
  * **Cohort overlap:** If there is more than one cohort in the cohort table supplied, summarises the overlap between them using [summariseCohortOverlap()](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortOverlap.html).
  * **Cohort timing:** If there is more than one cohort in the cohort table supplied, summarises the timing between them using [summariseCohortTiming()](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortTiming.html).
  * **Cohort survival:** If `survival = TRUE`, summarises the survival until the event of death (if death table is present in the cdm) using  
[estimateSingleEventSurvival()](https://darwin-eu-dev.github.io/CohortSurvival/reference/estimateSingleEventSurvival.html).



The analyses **cohort characteristics** , **cohort age distribution** , **cohort large scale characteristics** , and **cohort survival** will also be performed (by default) in a matched cohort. The matched cohort will be created based on year of birth and sex (see [matchCohorts()](https://ohdsi.github.io/CohortConstructor/reference/matchCohorts.html) function in CohortConstructor package). This can help us to compare the results in our cohorts to those obtain in the matched cohort, representing the general population. Notice that the analysis will be performed in: (1) the original cohort, (2) individuals in the original cohorts that have a match (named the sampled cohort), and (3) the matched cohort.

As the matched process can be computationally expensive, specially when the cohorts are very big, we can reduce the matching analysis to a subset of participants from the original cohort using the `matchedSample` parameter. Alternatively, if we do not want to create the matched cohorts, we can use `matchedSample = 0`.

The output of `[cohortDiagnostics()](../reference/cohortDiagnostics.html)` will be a summarised result table.

## Visualise cohort diagnostics results

We will now use different functions to visualise the results generated by CohortDiagnostics. Notice that these functions are from [CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/) and [CohortSurvival](https://darwin-eu-dev.github.io/CohortSurvival/) R packages packages. ### Cohort counts
    
    
    [tableCohortCount](https://darwin-eu.github.io/CohortCharacteristics/reference/tableCohortCount.html)(cohort_diag)

CDM name | Variable name | Estimate name |  Cohort name  
---|---|---|---  
ankle_fracture | ankle_sprain | forearm_fracture | hip_fracture  
Eunomia Synpuf | Number records | N | 0 | 28 | 0 | 0  
| Number subjects | N | 0 | 27 | 0 | 0  
  
### Cohort attrition
    
    
    [tableCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/tableCohortAttrition.html)(cohort_diag)

Reason |  Variable name  
---|---  
number_records | number_subjects | excluded_records | excluded_subjects  
Eunomia Synpuf; ankle_fracture  
Initial qualifying events | 0 | 0 | 0 | 0  
Record in observation | 0 | 0 | 0 | 0  
Record start <= record end | 0 | 0 | 0 | 0  
Non-missing sex | 0 | 0 | 0 | 0  
Non-missing year of birth | 0 | 0 | 0 | 0  
Merge overlapping records | 0 | 0 | 0 | 0  
Eunomia Synpuf; ankle_sprain  
Initial qualifying events | 31 | 27 | 0 | 0  
Record in observation | 31 | 27 | 0 | 0  
Record start <= record end | 31 | 27 | 0 | 0  
Non-missing sex | 31 | 27 | 0 | 0  
Non-missing year of birth | 31 | 27 | 0 | 0  
Merge overlapping records | 28 | 27 | 3 | 0  
Eunomia Synpuf; forearm_fracture  
Initial qualifying events | 0 | 0 | 0 | 0  
Record in observation | 0 | 0 | 0 | 0  
Record start <= record end | 0 | 0 | 0 | 0  
Non-missing sex | 0 | 0 | 0 | 0  
Non-missing year of birth | 0 | 0 | 0 | 0  
Merge overlapping records | 0 | 0 | 0 | 0  
Eunomia Synpuf; hip_fracture  
Initial qualifying events | 0 | 0 | 0 | 0  
Record in observation | 0 | 0 | 0 | 0  
Record start <= record end | 0 | 0 | 0 | 0  
Non-missing sex | 0 | 0 | 0 | 0  
Non-missing year of birth | 0 | 0 | 0 | 0  
Merge overlapping records | 0 | 0 | 0 | 0  
      
    
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(cohort_diag)

### Cohort characteristics
    
    
    [tableCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/reference/tableCharacteristics.html)(cohort_diag)

|  CDM name  
---|---  
|  Eunomia Synpuf  
Age group | Sex | Variable name | Variable level | Estimate name |  Cohort name  
ankle_fracture | ankle_sprain | forearm_fracture | hip_fracture | ankle_fracture_sampled | ankle_fracture_matched | ankle_sprain_sampled | ankle_sprain_matched | forearm_fracture_sampled | forearm_fracture_matched | hip_fracture_sampled | hip_fracture_matched  
overall | overall | Number records | - | N | 0 | 28 | 0 | 0 | 0 | 0 | 27 | 27 | 0 | 0 | 0 | 0  
|  | Number subjects | - | N | 0 | 27 | 0 | 0 | 0 | 0 | 26 | 27 | 0 | 0 | 0 | 0  
|  | Cohort start date | - | Median [Q25 - Q75] | - | 2009-04-23 [2008-10-30 - 2010-02-02] | - | - | - | - | 2009-05-12 [2008-10-28 - 2010-02-18] | 2009-05-12 [2008-10-28 - 2010-02-18] | - | - | - | -  
|  |  |  | Range | - | 2008-01-10 to 2010-09-13 | - | - | - | - | 2008-01-10 to 2010-09-13 | 2008-01-10 to 2010-09-13 | - | - | - | -  
|  | Cohort end date | - | Median [Q25 - Q75] | - | 2009-04-24 [2008-10-30 - 2010-02-02] | - | - | - | - | 2009-05-12 [2008-10-28 - 2010-02-18] | 2010-12-31 [2010-12-31 - 2010-12-31] | - | - | - | -  
|  |  |  | Range | - | 2008-01-10 to 2010-09-13 | - | - | - | - | 2008-01-10 to 2010-09-13 | 2008-11-30 to 2010-12-31 | - | - | - | -  
|  | Age | - | Median [Q25 - Q75] | - | 72 [66 - 77] | - | - | - | - | 73 [66 - 78] | 73 [67 - 78] | - | - | - | -  
|  |  |  | Mean (SD) | - | 71.14 (15.68) | - | - | - | - | 72.19 (14.96) | 72.15 (14.95) | - | - | - | -  
|  |  |  | Range | - | 27 to 98 | - | - | - | - | 27 to 98 | 27 to 98 | - | - | - | -  
|  | Sex | Female | N (%) | - | 11 (39.29%) | - | - | - | - | 10 (37.04%) | 10 (37.04%) | - | - | - | -  
|  |  | Male | N (%) | - | 17 (60.71%) | - | - | - | - | 17 (62.96%) | 17 (62.96%) | - | - | - | -  
|  | Prior observation | - | Median [Q25 - Q75] | - | 478 [303 - 762] | - | - | - | - | 497 [302 - 779] | 497 [292 - 779] | - | - | - | -  
|  |  |  | Mean (SD) | - | 499.54 (296.82) | - | - | - | - | 503.81 (301.59) | 490.26 (315.82) | - | - | - | -  
|  |  |  | Range | - | 9 to 986 | - | - | - | - | 9 to 986 | 2 to 986 | - | - | - | -  
|  | Future observation | - | Median [Q25 - Q75] | - | 572 [280 - 768] | - | - | - | - | 547 [278 - 775] | 479 [278 - 760] | - | - | - | -  
|  |  |  | Mean (SD) | - | 575.89 (301.07) | - | - | - | - | 570.89 (305.62) | 546.11 (316.38) | - | - | - | -  
|  |  |  | Range | - | 109 to 1,086 | - | - | - | - | 109 to 1,086 | 36 to 1,086 | - | - | - | -  
|  | Days in cohort | - | Median [Q25 - Q75] | - | 1 [1 - 1] | - | - | - | - | 1 [1 - 1] | 480 [279 - 760] | - | - | - | -  
|  |  |  | Mean (SD) | - | 1.11 (0.42) | - | - | - | - | 1.11 (0.42) | 547.11 (316.38) | - | - | - | -  
|  |  |  | Range | - | 1 to 3 | - | - | - | - | 1 to 3 | 37 to 1,087 | - | - | - | -  
|  | Number visits prior year | - | Median [Q25 - Q75] | - | 31.00 [16.50 - 45.00] | - | - | - | - | 28.00 [14.00 - 45.00] | 14.00 [3.00 - 28.50] | - | - | - | -  
|  |  |  | Mean (SD) | - | 31.71 (20.36) | - | - | - | - | 31.22 (20.57) | 16.33 (16.17) | - | - | - | -  
|  |  |  | Range | - | 0.00 to 73.00 | - | - | - | - | 0.00 to 73.00 | 0.00 to 62.00 | - | - | - | -  
18 to 64 | overall | Number records | - | N | - | 5 | - | - | - | - | 4 | 4 | - | - | - | -  
|  | Number subjects | - | N | - | 5 | - | - | - | - | 4 | 4 | - | - | - | -  
|  | Cohort start date | - | Median [Q25 - Q75] | - | 2009-09-08 [2009-01-19 - 2010-05-24] | - | - | - | - | 2010-01-15 [2009-04-15 - 2010-05-31] | 2010-01-15 [2009-04-15 - 2010-05-31] | - | - | - | -  
|  |  |  | Range | - | 2008-02-03 to 2010-06-19 | - | - | - | - | 2008-02-03 to 2010-06-19 | 2008-02-03 to 2010-06-19 | - | - | - | -  
|  | Cohort end date | - | Median [Q25 - Q75] | - | 2009-09-08 [2009-01-19 - 2010-05-24] | - | - | - | - | 2010-01-15 [2009-04-15 - 2010-05-31] | 2010-12-31 [2010-12-31 - 2010-12-31] | - | - | - | -  
|  |  |  | Range | - | 2008-02-03 to 2010-06-19 | - | - | - | - | 2008-02-03 to 2010-06-19 | 2010-12-31 to 2010-12-31 | - | - | - | -  
|  | Age | - | Median [Q25 - Q75] | - | 44 [43 - 56] | - | - | - | - | 50 [40 - 58] | 50 [40 - 58] | - | - | - | -  
|  |  |  | Mean (SD) | - | 46.60 (13.79) | - | - | - | - | 47.50 (15.76) | 47.50 (15.76) | - | - | - | -  
|  |  |  | Range | - | 27 to 63 | - | - | - | - | 27 to 63 | 27 to 63 | - | - | - | -  
|  | Sex | Female | N (%) | - | 2 (40.00%) | - | - | - | - | 1 (25.00%) | 1 (25.00%) | - | - | - | -  
|  |  | Male | N (%) | - | 3 (60.00%) | - | - | - | - | 3 (75.00%) | 3 (75.00%) | - | - | - | -  
|  | Prior observation | - | Median [Q25 - Q75] | - | 616 [384 - 874] | - | - | - | - | 745 [470 - 880] | 745 [470 - 880] | - | - | - | -  
|  |  |  | Mean (SD) | - | 561.40 (362.64) | - | - | - | - | 605.75 (402.78) | 605.75 (402.78) | - | - | - | -  
|  |  |  | Range | - | 33 to 900 | - | - | - | - | 33 to 900 | 33 to 900 | - | - | - | -  
|  | Future observation | - | Median [Q25 - Q75] | - | 479 [221 - 711] | - | - | - | - | 350 [214 - 625] | 350 [214 - 625] | - | - | - | -  
|  |  |  | Mean (SD) | - | 533.60 (362.64) | - | - | - | - | 489.25 (402.78) | 489.25 (402.78) | - | - | - | -  
|  |  |  | Range | - | 195 to 1,062 | - | - | - | - | 195 to 1,062 | 195 to 1,062 | - | - | - | -  
|  | Days in cohort | - | Median [Q25 - Q75] | - | 1 [1 - 1] | - | - | - | - | 1 [1 - 1] | 351 [216 - 626] | - | - | - | -  
|  |  |  | Mean (SD) | - | 1.00 (0.00) | - | - | - | - | 1.00 (0.00) | 490.25 (402.78) | - | - | - | -  
|  |  |  | Range | - | 1 to 1 | - | - | - | - | 1 to 1 | 196 to 1,063 | - | - | - | -  
|  | Number visits prior year | - | Median [Q25 - Q75] | - | 23.00 [5.00 - 26.00] | - | - | - | - | 14.00 [4.25 - 23.75] | 20.50 [7.00 - 33.50] | - | - | - | -  
|  |  |  | Mean (SD) | - | 20.20 (17.46) | - | - | - | - | 14.00 (12.25) | 20.00 (17.80) | - | - | - | -  
|  |  |  | Range | - | 2.00 to 45.00 | - | - | - | - | 2.00 to 26.00 | 1.00 to 38.00 | - | - | - | -  
65 to 150 | overall | Number records | - | N | - | 23 | - | - | - | - | 23 | 23 | - | - | - | -  
|  | Number subjects | - | N | - | 22 | - | - | - | - | 22 | 23 | - | - | - | -  
|  | Cohort start date | - | Median [Q25 - Q75] | - | 2009-04-04 [2008-10-28 - 2009-12-27] | - | - | - | - | 2009-04-04 [2008-10-28 - 2009-12-27] | 2009-04-04 [2008-10-28 - 2009-12-27] | - | - | - | -  
|  |  |  | Range | - | 2008-01-10 to 2010-09-13 | - | - | - | - | 2008-01-10 to 2010-09-13 | 2008-01-10 to 2010-09-13 | - | - | - | -  
|  | Cohort end date | - | Median [Q25 - Q75] | - | 2009-04-05 [2008-10-28 - 2009-12-27] | - | - | - | - | 2009-04-05 [2008-10-28 - 2009-12-27] | 2010-12-31 [2010-12-31 - 2010-12-31] | - | - | - | -  
|  |  |  | Range | - | 2008-01-10 to 2010-09-13 | - | - | - | - | 2008-01-10 to 2010-09-13 | 2008-11-30 to 2010-12-31 | - | - | - | -  
|  | Age | - | Median [Q25 - Q75] | - | 75 [68 - 81] | - | - | - | - | 75 [68 - 81] | 74 [68 - 81] | - | - | - | -  
|  |  |  | Mean (SD) | - | 76.48 (10.03) | - | - | - | - | 76.48 (10.03) | 76.43 (10.04) | - | - | - | -  
|  |  |  | Range | - | 66 to 98 | - | - | - | - | 66 to 98 | 65 to 98 | - | - | - | -  
|  | Sex | Female | N (%) | - | 9 (39.13%) | - | - | - | - | 9 (39.13%) | 9 (39.13%) | - | - | - | -  
|  |  | Male | N (%) | - | 14 (60.87%) | - | - | - | - | 14 (60.87%) | 14 (60.87%) | - | - | - | -  
|  | Prior observation | - | Median [Q25 - Q75] | - | 459 [302 - 726] | - | - | - | - | 459 [302 - 726] | 459 [292 - 726] | - | - | - | -  
|  |  |  | Mean (SD) | - | 486.09 (288.36) | - | - | - | - | 486.09 (288.36) | 470.17 (304.81) | - | - | - | -  
|  |  |  | Range | - | 9 to 986 | - | - | - | - | 9 to 986 | 2 to 986 | - | - | - | -  
|  | Future observation | - | Median [Q25 - Q75] | - | 598 [316 - 775] | - | - | - | - | 598 [316 - 775] | 547 [308 - 760] | - | - | - | -  
|  |  |  | Mean (SD) | - | 585.09 (294.69) | - | - | - | - | 585.09 (294.69) | 556.00 (309.00) | - | - | - | -  
|  |  |  | Range | - | 109 to 1,086 | - | - | - | - | 109 to 1,086 | 36 to 1,086 | - | - | - | -  
|  | Days in cohort | - | Median [Q25 - Q75] | - | 1 [1 - 1] | - | - | - | - | 1 [1 - 1] | 548 [310 - 760] | - | - | - | -  
|  |  |  | Mean (SD) | - | 1.13 (0.46) | - | - | - | - | 1.13 (0.46) | 557.00 (309.00) | - | - | - | -  
|  |  |  | Range | - | 1 to 3 | - | - | - | - | 1 to 3 | 37 to 1,087 | - | - | - | -  
|  | Number visits prior year | - | Median [Q25 - Q75] | - | 40.00 [20.50 - 47.00] | - | - | - | - | 40.00 [20.50 - 47.00] | 14.00 [3.00 - 20.50] | - | - | - | -  
|  |  |  | Mean (SD) | - | 34.22 (20.41) | - | - | - | - | 34.22 (20.41) | 15.70 (16.22) | - | - | - | -  
|  |  |  | Range | - | 0.00 to 73.00 | - | - | - | - | 0.00 to 73.00 | 0.00 to 62.00 | - | - | - | -  
overall | Female | Number records | - | N | - | 11 | - | - | - | - | 10 | 10 | - | - | - | -  
|  | Number subjects | - | N | - | 11 | - | - | - | - | 10 | 10 | - | - | - | -  
|  | Cohort start date | - | Median [Q25 - Q75] | - | 2008-12-02 [2008-03-30 - 2009-04-11] | - | - | - | - | 2008-11-13 [2008-03-29 - 2009-05-14] | 2008-11-13 [2008-03-29 - 2009-05-14] | - | - | - | -  
|  |  |  | Range | - | 2008-01-10 to 2010-04-02 | - | - | - | - | 2008-01-10 to 2010-04-02 | 2008-01-10 to 2010-04-02 | - | - | - | -  
|  | Cohort end date | - | Median [Q25 - Q75] | - | 2008-12-04 [2008-03-30 - 2009-04-11] | - | - | - | - | 2008-11-14 [2008-03-29 - 2009-05-14] | 2010-12-31 [2010-12-31 - 2010-12-31] | - | - | - | -  
|  |  |  | Range | - | 2008-01-10 to 2010-04-02 | - | - | - | - | 2008-01-10 to 2010-04-02 | 2008-11-30 to 2010-12-31 | - | - | - | -  
|  | Age | - | Median [Q25 - Q75] | - | 70 [66 - 74] | - | - | - | - | 70 [67 - 75] | 70 [67 - 74] | - | - | - | -  
|  |  |  | Mean (SD) | - | 70.09 (12.28) | - | - | - | - | 72.80 (8.82) | 72.70 (8.74) | - | - | - | -  
|  |  |  | Range | - | 43 to 92 | - | - | - | - | 63 to 92 | 63 to 92 | - | - | - | -  
|  | Sex | Female | N (%) | - | 11 (100.00%) | - | - | - | - | 10 (100.00%) | 10 (100.00%) | - | - | - | -  
|  | Prior observation | - | Median [Q25 - Q75] | - | 336 [88 - 466] | - | - | - | - | 317 [88 - 499] | 317 [88 - 499] | - | - | - | -  
|  |  |  | Mean (SD) | - | 342.91 (288.53) | - | - | - | - | 338.80 (303.79) | 338.80 (303.79) | - | - | - | -  
|  |  |  | Range | - | 9 to 822 | - | - | - | - | 9 to 822 | 9 to 822 | - | - | - | -  
|  | Future observation | - | Median [Q25 - Q75] | - | 742 [415 - 1,006] | - | - | - | - | 750 [349 - 1,007] | 750 [349 - 1,007] | - | - | - | -  
|  |  |  | Mean (SD) | - | 702.27 (325.00) | - | - | - | - | 701.40 (342.57) | 680.10 (378.55) | - | - | - | -  
|  |  |  | Range | - | 249 to 1,086 | - | - | - | - | 249 to 1,086 | 36 to 1,086 | - | - | - | -  
|  | Days in cohort | - | Median [Q25 - Q75] | - | 1 [1 - 1] | - | - | - | - | 1 [1 - 1] | 752 [350 - 1,008] | - | - | - | -  
|  |  |  | Mean (SD) | - | 1.18 (0.60) | - | - | - | - | 1.20 (0.63) | 681.10 (378.55) | - | - | - | -  
|  |  |  | Range | - | 1 to 3 | - | - | - | - | 1 to 3 | 37 to 1,087 | - | - | - | -  
|  | Number visits prior year | - | Median [Q25 - Q75] | - | 28.00 [6.50 - 45.00] | - | - | - | - | 23.50 [5.25 - 44.50] | 13.50 [1.75 - 16.00] | - | - | - | -  
|  |  |  | Mean (SD) | - | 26.82 (20.58) | - | - | - | - | 25.00 (20.74) | 12.80 (12.15) | - | - | - | -  
|  |  |  | Range | - | 0.00 to 51.00 | - | - | - | - | 0.00 to 51.00 | 0.00 to 38.00 | - | - | - | -  
| Male | Number records | - | N | - | 17 | - | - | - | - | 17 | 17 | - | - | - | -  
|  | Number subjects | - | N | - | 16 | - | - | - | - | 16 | 17 | - | - | - | -  
|  | Cohort start date | - | Median [Q25 - Q75] | - | 2009-10-08 [2009-01-03 - 2010-04-17] | - | - | - | - | 2009-10-08 [2009-01-03 - 2010-04-17] | 2009-10-08 [2009-01-03 - 2010-04-17] | - | - | - | -  
|  |  |  | Range | - | 2008-03-21 to 2010-09-13 | - | - | - | - | 2008-03-21 to 2010-09-13 | 2008-03-21 to 2010-09-13 | - | - | - | -  
|  | Cohort end date | - | Median [Q25 - Q75] | - | 2009-10-08 [2009-01-03 - 2010-04-17] | - | - | - | - | 2009-10-08 [2009-01-03 - 2010-04-17] | 2010-12-31 [2010-12-31 - 2010-12-31] | - | - | - | -  
|  |  |  | Range | - | 2008-03-21 to 2010-09-13 | - | - | - | - | 2008-03-21 to 2010-09-13 | 2009-10-01 to 2010-12-31 | - | - | - | -  
|  | Age | - | Median [Q25 - Q75] | - | 75 [66 - 79] | - | - | - | - | 75 [66 - 79] | 75 [66 - 79] | - | - | - | -  
|  |  |  | Mean (SD) | - | 71.82 (17.88) | - | - | - | - | 71.82 (17.88) | 71.82 (17.89) | - | - | - | -  
|  |  |  | Range | - | 27 to 98 | - | - | - | - | 27 to 98 | 27 to 98 | - | - | - | -  
|  | Sex | Male | N (%) | - | 17 (100.00%) | - | - | - | - | 17 (100.00%) | 17 (100.00%) | - | - | - | -  
|  | Prior observation | - | Median [Q25 - Q75] | - | 646 [368 - 837] | - | - | - | - | 646 [368 - 837] | 646 [335 - 837] | - | - | - | -  
|  |  |  | Mean (SD) | - | 600.88 (262.41) | - | - | - | - | 600.88 (262.41) | 579.35 (295.63) | - | - | - | -  
|  |  |  | Range | - | 80 to 986 | - | - | - | - | 80 to 986 | 2 to 986 | - | - | - | -  
|  | Future observation | - | Median [Q25 - Q75] | - | 449 [258 - 727] | - | - | - | - | 449 [258 - 727] | 401 [258 - 636] | - | - | - | -  
|  |  |  | Mean (SD) | - | 494.12 (262.41) | - | - | - | - | 494.12 (262.41) | 467.29 (253.43) | - | - | - | -  
|  |  |  | Range | - | 109 to 1,015 | - | - | - | - | 109 to 1,015 | 109 to 1,015 | - | - | - | -  
|  | Days in cohort | - | Median [Q25 - Q75] | - | 1 [1 - 1] | - | - | - | - | 1 [1 - 1] | 402 [259 - 637] | - | - | - | -  
|  |  |  | Mean (SD) | - | 1.06 (0.24) | - | - | - | - | 1.06 (0.24) | 468.29 (253.43) | - | - | - | -  
|  |  |  | Range | - | 1 to 2 | - | - | - | - | 1 to 2 | 110 to 1,016 | - | - | - | -  
|  | Number visits prior year | - | Median [Q25 - Q75] | - | 34.00 [23.00 - 45.00] | - | - | - | - | 34.00 [23.00 - 45.00] | 14.00 [5.00 - 32.00] | - | - | - | -  
|  |  |  | Mean (SD) | - | 34.88 (20.18) | - | - | - | - | 34.88 (20.18) | 18.41 (18.15) | - | - | - | -  
|  |  |  | Range | - | 5.00 to 73.00 | - | - | - | - | 5.00 to 73.00 | 0.00 to 62.00 | - | - | - | -  
  
### Cohort large scale characteristics
    
    
    [tableLargeScaleCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/reference/tableLargeScaleCharacteristics.html)(cohort_diag)

### Cohort overlap
    
    
    [tableCohortOverlap](https://darwin-eu.github.io/CohortCharacteristics/reference/tableCohortOverlap.html)(cohort_diag)

Cohort name reference | Cohort name comparator | Estimate name |  Variable name  
---|---|---|---  
Only in reference cohort | In both cohorts | Only in comparator cohort  
Eunomia Synpuf  
ankle_fracture | ankle_sprain | N (%) | 0 (0.00%) | 0 (0.00%) | 27 (100.00%)  
| forearm_fracture | N (%) | 0 (NaN%) | 0 (NaN%) | 0 (NaN%)  
| hip_fracture | N (%) | 0 (NaN%) | 0 (NaN%) | 0 (NaN%)  
ankle_sprain | forearm_fracture | N (%) | 27 (100.00%) | 0 (0.00%) | 0 (0.00%)  
| hip_fracture | N (%) | 27 (100.00%) | 0 (0.00%) | 0 (0.00%)  
forearm_fracture | hip_fracture | N (%) | 0 (NaN%) | 0 (NaN%) | 0 (NaN%)  
      
    
    [plotCohortOverlap](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortOverlap.html)(cohort_diag)

![](CohortDiagnostics_files/figure-html/unnamed-chunk-11-1.png) ### Cohort timing
    
    
    [tableCohortTiming](https://darwin-eu.github.io/CohortCharacteristics/reference/tableCohortTiming.html)(cohort_diag)

Table has no data  
---  
      
    
    [plotCohortTiming](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortTiming.html)(cohort_diag)

![](CohortDiagnostics_files/figure-html/unnamed-chunk-13-1.png) ### Cohort survival
    
    
    [tableSurvival](https://darwin-eu.github.io/CohortSurvival/reference/tableSurvival.html)(cohort_diag, header = "estimate_name")

CDM name | Cohort name | Cohort name reference | Cohort name comparator | Target cohort | Age group | Sex | Outcome name |  Estimate name  
---|---|---|---|---|---|---|---|---  
Number records | Number events | Median survival (95% CI) | Restricted mean survival (95% CI)  
Eunomia Synpuf | overall | overall | overall | ankle_sprain | overall | overall | death_cohort | 28 | 1 | - | 1,051.00 (984.00, 1,118.00)  
|  |  |  | ankle_sprain_sampled | overall | overall | death_cohort | 27 | 1 | - | 1,050.00 (980.00, 1,119.00)  
|  |  |  | ankle_sprain_matched | overall | overall | death_cohort | 27 | 1 | - | 1,046.00 (971.00, 1,122.00)  
      
    
    [plotSurvival](https://darwin-eu.github.io/CohortSurvival/reference/plotSurvival.html)(cohort_diag, colour = "target_cohort", facet = "cdm_name")

![](CohortDiagnostics_files/figure-html/unnamed-chunk-15-1.png)

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/articles/PopulationDiagnostics.html

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

# Population diagnostics

`PopulationDiagnostics.Rmd`

## Introduction

In this example we’re going to just create a cohort of individuals with an ankle sprain using the Eunomia synthetic data.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([IncidencePrevalence](https://darwin-eu.github.io/IncidencePrevalence/))
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                                    cdmName = "Eunomia Synpuf",
                                    cdmSchema   = "main",
                                    writeSchema = "main", 
                                    achillesSchema = "main")
    
    cdm$injuries <- [conceptCohort](https://ohdsi.github.io/CohortConstructor/reference/conceptCohort.html)(cdm = cdm,
      conceptSet = [list](https://rdrr.io/r/base/list.html)(
        "ankle_sprain" = 81151
      ),
      name = "injuries")

We can get the incidence and prevalence of our study cohort using `[populationDiagnostics()](../reference/populationDiagnostics.html)`:
    
    
    pop_diag <- [populationDiagnostics](../reference/populationDiagnostics.html)(cdm$injuries)

This function builds on [IncidencePrevalence](https://darwin-eu.github.io/IncidencePrevalence/index.html) R package to perform the following analyses:

  * **Incidence:** It estimates the incidence of our cohort using [estimateIncidence()](https://darwin-eu.github.io/IncidencePrevalence/reference/estimateIncidence.html).
  * **Prevalence:** It estimates the prevalence of our cohort on a year basis using [estimatePeriodPrevalence()](https://darwin-eu.github.io/IncidencePrevalence/reference/estimatePeriodPrevalence.html).



All analyses are performed for:

  * Overall and stratified by age groups: 0 to 17, 18 to 64, 65 to 150. Age groups cannot be modified.
  * Overall and stratified by sex (Female, Male).
  * Restricting the denominator population to those with 0 and 365 of days of prior observation.



## Visualising the results

We can use [IncidencePrevalence](https://darwin-eu.github.io/IncidencePrevalence/index.html) package to visualise the results obtained.

### Incidence
    
    
    [tableIncidence](https://darwin-eu.github.io/IncidencePrevalence/reference/tableIncidence.html)(pop_diag,     
                   groupColumn = [c](https://rdrr.io/r/base/c.html)("cdm_name", "outcome_cohort_name"),
                   hide = "denominator_cohort_name",
                   settingsColumn = [c](https://rdrr.io/r/base/c.html)("denominator_age_group",
                             "denominator_sex",
                             "denominator_days_prior_observation",
                             "outcome_cohort_name"))

Incidence start date | Incidence end date | Analysis interval | Denominator age group | Denominator sex | Denominator days prior observation |  Estimate name  
---|---|---|---|---|---|---  
Denominator (N) | Person-years | Outcome (N) | Incidence 100,000 person-years [95% CI]  
Eunomia Synpuf; ankle_sprain  
2008-01-01 | 2008-12-31 | years | 0 to 150 | Both | 0 | 973 | 941.90 | 11 | 1,167.85 (582.99 - 2,089.61)  
2009-01-01 | 2009-12-31 | years | 0 to 150 | Both | 0 | 947 | 932.17 | 8 | 858.22 (370.52 - 1,691.03)  
2010-01-01 | 2010-12-31 | years | 0 to 150 | Both | 0 | 912 | 894.83 | 8 | 894.02 (385.98 - 1,761.58)  
2008-01-01 | 2010-12-31 | overall | 0 to 150 | Both | 0 | 1,000 | 2,768.90 | 27 | 975.12 (642.61 - 1,418.74)  
2008-12-31 | 2008-12-31 | years | 0 to 150 | Both | 365 | 898 | 2.46 | 0 | 0.00 (0.00 - 150,015.43)  
2009-01-01 | 2009-12-31 | years | 0 to 150 | Both | 365 | 874 | 860.47 | 8 | 929.73 (401.39 - 1,831.93)  
2010-01-01 | 2010-12-31 | years | 0 to 150 | Both | 365 | 910 | 894.42 | 8 | 894.44 (386.15 - 1,762.40)  
2008-12-31 | 2010-12-31 | overall | 0 to 150 | Both | 365 | 968 | 1,757.34 | 16 | 910.46 (520.41 - 1,478.54)  
2008-01-01 | 2008-12-31 | years | 0 to 150 | Female | 0 | 485 | 467.68 | 7 | 1,496.73 (601.76 - 3,083.84)  
2009-01-01 | 2009-12-31 | years | 0 to 150 | Female | 0 | 475 | 466.24 | 2 | 428.96 (51.95 - 1,549.56)  
2010-01-01 | 2010-12-31 | years | 0 to 150 | Female | 0 | 460 | 452.91 | 2 | 441.59 (53.48 - 1,595.17)  
2008-01-01 | 2010-12-31 | overall | 0 to 150 | Female | 0 | 498 | 1,386.84 | 11 | 793.17 (395.95 - 1,419.20)  
| 2008-12-31 | years | 0 to 150 | Male | 0 | 488 | 474.21 | 4 | 843.50 (229.82 - 2,159.69)  
2009-01-01 | 2009-12-31 | years | 0 to 150 | Male | 0 | 472 | 465.92 | 6 | 1,287.76 (472.59 - 2,802.91)  
2010-01-01 | 2010-12-31 | years | 0 to 150 | Male | 0 | 452 | 441.92 | 6 | 1,357.71 (498.25 - 2,955.15)  
2008-01-01 | 2010-12-31 | overall | 0 to 150 | Male | 0 | 502 | 1,382.06 | 16 | 1,157.69 (661.72 - 1,880.02)  
| 2008-12-31 | years | 18 to 64 | Both | 0 | 192 | 169.81 | 1 | 588.90 (14.91 - 3,281.16)  
2009-01-01 | 2009-12-31 | years | 18 to 64 | Both | 0 | 154 | 146.70 | 2 | 1,363.35 (165.11 - 4,924.90)  
2010-01-01 | 2010-12-31 | years | 18 to 64 | Both | 0 | 139 | 133.08 | 2 | 1,502.90 (182.01 - 5,428.99)  
2008-01-01 | 2010-12-31 | overall | 18 to 64 | Both | 0 | 200 | 449.58 | 5 | 1,112.15 (361.11 - 2,595.39)  
| 2008-12-31 | years | 65 to 150 | Both | 0 | 813 | 772.09 | 10 | 1,295.18 (621.09 - 2,381.88)  
2009-01-01 | 2009-12-31 | years | 65 to 150 | Both | 0 | 801 | 785.47 | 6 | 763.87 (280.33 - 1,662.63)  
2010-01-01 | 2010-12-31 | years | 65 to 150 | Both | 0 | 781 | 761.76 | 6 | 787.66 (289.06 - 1,714.39)  
2008-01-01 | 2010-12-31 | overall | 65 to 150 | Both | 0 | 854 | 2,319.32 | 22 | 948.56 (594.45 - 1,436.12)  
      
    
    results <- pop_diag |> 
      omopgenerics::[filterSettings](https://darwin-eu.github.io/omopgenerics/reference/filterSettings.html)(result_type == "incidence") |>
      visOmopResults::[filterAdditional](https://darwin-eu.github.io/omopgenerics/reference/filterAdditional.html)(analysis_interval == "years")
    [plotIncidence](https://darwin-eu.github.io/IncidencePrevalence/reference/plotIncidence.html)(results,
                  colour = "denominator_age_group",
                  facet = [c](https://rdrr.io/r/base/c.html)("denominator_sex", "denominator_days_prior_observation"))

![](PopulationDiagnostics_files/figure-html/unnamed-chunk-5-1.png)

### Prevalence
    
    
    [tablePrevalence](https://darwin-eu.github.io/IncidencePrevalence/reference/tablePrevalence.html)(pop_diag,     
                   groupColumn = [c](https://rdrr.io/r/base/c.html)("cdm_name", "outcome_cohort_name"),
                   hide = "denominator_cohort_name",
                   settingsColumn = [c](https://rdrr.io/r/base/c.html)("denominator_age_group",
                             "denominator_sex",
                             "denominator_days_prior_observation",
                             "outcome_cohort_name"))

Prevalence start date | Prevalence end date | Analysis interval | Denominator age group | Denominator sex | Denominator days prior observation |  Estimate name  
---|---|---|---|---|---|---  
Denominator (N) | Outcome (N) | Prevalence [95% CI]  
Eunomia Synpuf; ankle_sprain  
2008-01-01 | 2008-12-31 | years | 0 to 150 | Both | 0 | 973 | 11 | 0.01 (0.01 - 0.02)  
2009-01-01 | 2009-12-31 | years | 0 to 150 | Both | 0 | 958 | 9 | 0.01 (0.00 - 0.02)  
2010-01-01 | 2010-12-31 | years | 0 to 150 | Both | 0 | 930 | 8 | 0.01 (0.00 - 0.02)  
2008-01-01 | 2010-12-31 | overall | 0 to 150 | Both | 0 | 1,000 | 27 | 0.03 (0.02 - 0.04)  
2009-01-01 | 2009-12-31 | years | 0 to 150 | Both | 365 | 885 | 9 | 0.01 (0.01 - 0.02)  
2010-01-01 | 2010-12-31 | years | 0 to 150 | Both | 365 | 928 | 8 | 0.01 (0.00 - 0.02)  
2008-12-31 | 2010-12-31 | overall | 0 to 150 | Both | 365 | 979 | 17 | 0.02 (0.01 - 0.03)  
2008-01-01 | 2008-12-31 | years | 0 to 150 | Female | 0 | 485 | 7 | 0.01 (0.01 - 0.03)  
2009-01-01 | 2009-12-31 | years | 0 to 150 | Female | 0 | 482 | 2 | 0.00 (0.00 - 0.01)  
2010-01-01 | 2010-12-31 | years | 0 to 150 | Female | 0 | 468 | 2 | 0.00 (0.00 - 0.02)  
2008-01-01 | 2010-12-31 | overall | 0 to 150 | Female | 0 | 498 | 11 | 0.02 (0.01 - 0.04)  
| 2008-12-31 | years | 0 to 150 | Male | 0 | 488 | 4 | 0.01 (0.00 - 0.02)  
2009-01-01 | 2009-12-31 | years | 0 to 150 | Male | 0 | 476 | 7 | 0.01 (0.01 - 0.03)  
2010-01-01 | 2010-12-31 | years | 0 to 150 | Male | 0 | 462 | 6 | 0.01 (0.01 - 0.03)  
2008-01-01 | 2010-12-31 | overall | 0 to 150 | Male | 0 | 502 | 16 | 0.03 (0.02 - 0.05)  
| 2008-12-31 | years | 18 to 64 | Both | 0 | 192 | 1 | 0.01 (0.00 - 0.03)  
2009-01-01 | 2009-12-31 | years | 18 to 64 | Both | 0 | 155 | 2 | 0.01 (0.00 - 0.05)  
2010-01-01 | 2010-12-31 | years | 18 to 64 | Both | 0 | 141 | 2 | 0.01 (0.00 - 0.05)  
2008-01-01 | 2010-12-31 | overall | 18 to 64 | Both | 0 | 200 | 5 | 0.03 (0.01 - 0.06)  
| 2008-12-31 | years | 65 to 150 | Both | 0 | 813 | 10 | 0.01 (0.01 - 0.02)  
2009-01-01 | 2009-12-31 | years | 65 to 150 | Both | 0 | 812 | 7 | 0.01 (0.00 - 0.02)  
2010-01-01 | 2010-12-31 | years | 65 to 150 | Both | 0 | 797 | 6 | 0.01 (0.00 - 0.02)  
2008-01-01 | 2010-12-31 | overall | 65 to 150 | Both | 0 | 855 | 22 | 0.03 (0.02 - 0.04)  
      
    
    results <- pop_diag |> 
      omopgenerics::[filterSettings](https://darwin-eu.github.io/omopgenerics/reference/filterSettings.html)(result_type == "prevalence") |>
      visOmopResults::[filterAdditional](https://darwin-eu.github.io/omopgenerics/reference/filterAdditional.html)(analysis_interval == "years")
    [plotPrevalence](https://darwin-eu.github.io/IncidencePrevalence/reference/plotPrevalence.html)(results,
                   colour = "denominator_age_group",
                   facet = [c](https://rdrr.io/r/base/c.html)("denominator_sex", "denominator_days_prior_observation"))

![](PopulationDiagnostics_files/figure-html/unnamed-chunk-7-1.png)

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/reference/phenotypeDiagnostics.html

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

# Phenotype a cohort

`phenotypeDiagnostics.Rd`

This comprises all the diagnostics that are being offered in this package, this includes:

* A diagnostics on the database via `databaseDiagnostics`. * A diagnostics on the cohort_codelist attribute of the cohort via `codelistDiagnostics`. * A diagnostics on the cohort via `cohortDiagnostics`. * A diagnostics on the population via `populationDiagnostics`.

## Usage
    
    
    phenotypeDiagnostics(
      cohort,
      diagnostics = [c](https://rdrr.io/r/base/c.html)("databaseDiagnostics", "codelistDiagnostics", "cohortDiagnostics",
        "populationDiagnostics"),
      survival = FALSE,
      cohortSample = 20000,
      matchedSample = 1000,
      populationSample = 1e+06,
      populationDateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)(NA, NA))
    )

## Arguments

cohort
    

Cohort table in a cdm reference

diagnostics
    

Vector indicating which diagnostics to perform. Options include: `databaseDiagnostics`, `codelistDiagnostics`, `cohortDiagnostics`, and `populationDiagnostics`.

survival
    

Boolean variable. Whether to conduct survival analysis (TRUE) or not (FALSE).

cohortSample
    

The number of people to take a random sample for cohortDiagnostics. If `cohortSample = NULL`, no sampling will be performed,

matchedSample
    

The number of people to take a random sample for matching. If `matchedSample = NULL`, no sampling will be performed. If `matchedSample = 0`, no matched cohorts will be created.

populationSample
    

Number of people from the cdm to sample. If NULL no sampling will be performed. Sample will be within populationDateRange if specified.

populationDateRange
    

Two dates. The first indicating the earliest cohort start date and the second indicating the latest possible cohort end date. If NULL or the first date is set as missing, the earliest observation_start_date in the observation_period table will be used for the former. If NULL or the second date is set as missing, the latest observation_end_date in the observation_period table will be used for the latter.

## Value

A summarised result

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    
    cdm <- [mockPhenotypeR](mockPhenotypeR.html)()
    
    result <- phenotypeDiagnostics(cdm$my_cohort)
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
    #> → Start summary of data, at 2025-09-17 21:01:28.591644
    #> ✔ Summary finished, at 2025-09-17 21:01:28.71771
    #> → Creating matching cohorts
    #> → Sampling cohort `tmp_018_sampled`
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
    #> → Sampling cohort `tmp_018_sampled`
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
    #> → Start summary of data, at 2025-09-17 21:01:55.163749
    #> ✔ Summary finished, at 2025-09-17 21:01:55.498816
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
    
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/reference/getCohortExpectations.html

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

# Get cohort expectations using an LLM

`getCohortExpectations.Rd`

Get cohort expectations using an LLM

## Usage
    
    
    getCohortExpectations(chat, phenotypes)

## Arguments

chat
    

An ellmer chat

phenotypes
    

Either a vector of phenotype names or results from PhenotypeR.

## Value

A tibble with expectations about the cohort.

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/reference/shinyDiagnostics.html

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

---

## Content from https://ohdsi.github.io/PhenotypeR/LICENSE.html

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

# Apache License

_Version 2.0, January 2004_ _<<http://www.apache.org/licenses/>>_

### Terms and Conditions for use, reproduction, and distribution

#### 1\. Definitions

“License” shall mean the terms and conditions for use, reproduction, and distribution as defined by Sections 1 through 9 of this document.

“Licensor” shall mean the copyright owner or entity authorized by the copyright owner that is granting the License.

“Legal Entity” shall mean the union of the acting entity and all other entities that control, are controlled by, or are under common control with that entity. For the purposes of this definition, “control” means **(i)** the power, direct or indirect, to cause the direction or management of such entity, whether by contract or otherwise, or **(ii)** ownership of fifty percent (50%) or more of the outstanding shares, or **(iii)** beneficial ownership of such entity.

“You” (or “Your”) shall mean an individual or Legal Entity exercising permissions granted by this License.

“Source” form shall mean the preferred form for making modifications, including but not limited to software source code, documentation source, and configuration files.

“Object” form shall mean any form resulting from mechanical transformation or translation of a Source form, including but not limited to compiled object code, generated documentation, and conversions to other media types.

“Work” shall mean the work of authorship, whether in Source or Object form, made available under the License, as indicated by a copyright notice that is included in or attached to the work (an example is provided in the Appendix below).

“Derivative Works” shall mean any work, whether in Source or Object form, that is based on (or derived from) the Work and for which the editorial revisions, annotations, elaborations, or other modifications represent, as a whole, an original work of authorship. For the purposes of this License, Derivative Works shall not include works that remain separable from, or merely link (or bind by name) to the interfaces of, the Work and Derivative Works thereof.

“Contribution” shall mean any work of authorship, including the original version of the Work and any modifications or additions to that Work or Derivative Works thereof, that is intentionally submitted to Licensor for inclusion in the Work by the copyright owner or by an individual or Legal Entity authorized to submit on behalf of the copyright owner. For the purposes of this definition, “submitted” means any form of electronic, verbal, or written communication sent to the Licensor or its representatives, including but not limited to communication on electronic mailing lists, source code control systems, and issue tracking systems that are managed by, or on behalf of, the Licensor for the purpose of discussing and improving the Work, but excluding communication that is conspicuously marked or otherwise designated in writing by the copyright owner as “Not a Contribution.”

“Contributor” shall mean Licensor and any individual or Legal Entity on behalf of whom a Contribution has been received by Licensor and subsequently incorporated within the Work.

#### 2\. Grant of Copyright License

Subject to the terms and conditions of this License, each Contributor hereby grants to You a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable copyright license to reproduce, prepare Derivative Works of, publicly display, publicly perform, sublicense, and distribute the Work and such Derivative Works in Source or Object form.

#### 3\. Grant of Patent License

Subject to the terms and conditions of this License, each Contributor hereby grants to You a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable (except as stated in this section) patent license to make, have made, use, offer to sell, sell, import, and otherwise transfer the Work, where such license applies only to those patent claims licensable by such Contributor that are necessarily infringed by their Contribution(s) alone or by combination of their Contribution(s) with the Work to which such Contribution(s) was submitted. If You institute patent litigation against any entity (including a cross-claim or counterclaim in a lawsuit) alleging that the Work or a Contribution incorporated within the Work constitutes direct or contributory patent infringement, then any patent licenses granted to You under this License for that Work shall terminate as of the date such litigation is filed.

#### 4\. Redistribution

You may reproduce and distribute copies of the Work or Derivative Works thereof in any medium, with or without modifications, and in Source or Object form, provided that You meet the following conditions:

  * **(a)** You must give any other recipients of the Work or Derivative Works a copy of this License; and
  * **(b)** You must cause any modified files to carry prominent notices stating that You changed the files; and
  * **(c)** You must retain, in the Source form of any Derivative Works that You distribute, all copyright, patent, trademark, and attribution notices from the Source form of the Work, excluding those notices that do not pertain to any part of the Derivative Works; and
  * **(d)** If the Work includes a “NOTICE” text file as part of its distribution, then any Derivative Works that You distribute must include a readable copy of the attribution notices contained within such NOTICE file, excluding those notices that do not pertain to any part of the Derivative Works, in at least one of the following places: within a NOTICE text file distributed as part of the Derivative Works; within the Source form or documentation, if provided along with the Derivative Works; or, within a display generated by the Derivative Works, if and wherever such third-party notices normally appear. The contents of the NOTICE file are for informational purposes only and do not modify the License. You may add Your own attribution notices within Derivative Works that You distribute, alongside or as an addendum to the NOTICE text from the Work, provided that such additional attribution notices cannot be construed as modifying the License.



You may add Your own copyright statement to Your modifications and may provide additional or different license terms and conditions for use, reproduction, or distribution of Your modifications, or for any such Derivative Works as a whole, provided Your use, reproduction, and distribution of the Work otherwise complies with the conditions stated in this License.

#### 5\. Submission of Contributions

Unless You explicitly state otherwise, any Contribution intentionally submitted for inclusion in the Work by You to the Licensor shall be under the terms and conditions of this License, without any additional terms or conditions. Notwithstanding the above, nothing herein shall supersede or modify the terms of any separate license agreement you may have executed with Licensor regarding such Contributions.

#### 6\. Trademarks

This License does not grant permission to use the trade names, trademarks, service marks, or product names of the Licensor, except as required for reasonable and customary use in describing the origin of the Work and reproducing the content of the NOTICE file.

#### 7\. Disclaimer of Warranty

Unless required by applicable law or agreed to in writing, Licensor provides the Work (and each Contributor provides its Contributions) on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied, including, without limitation, any warranties or conditions of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A PARTICULAR PURPOSE. You are solely responsible for determining the appropriateness of using or redistributing the Work and assume any risks associated with Your exercise of permissions under this License.

#### 8\. Limitation of Liability

In no event and under no legal theory, whether in tort (including negligence), contract, or otherwise, unless required by applicable law (such as deliberate and grossly negligent acts) or agreed to in writing, shall any Contributor be liable to You for damages, including any direct, indirect, special, incidental, or consequential damages of any character arising as a result of this License or out of the use or inability to use the Work (including but not limited to damages for loss of goodwill, work stoppage, computer failure or malfunction, or any and all other commercial damages or losses), even if such Contributor has been advised of the possibility of such damages.

#### 9\. Accepting Warranty or Additional Liability

While redistributing the Work or Derivative Works thereof, You may choose to offer, and charge a fee for, acceptance of support, warranty, indemnity, or other liability obligations and/or rights consistent with this License. However, in accepting such obligations, You may act only on Your own behalf and on Your sole responsibility, not on behalf of any other Contributor, and only if You agree to indemnify, defend, and hold each Contributor harmless for any liability incurred by, or claims asserted against, such Contributor by reason of your accepting any such warranty or additional liability.

_END OF TERMS AND CONDITIONS_

### APPENDIX: How to apply the Apache License to your work

To apply the Apache License to your work, attach the following boilerplate notice, with the fields enclosed by brackets `[]` replaced with your own identifying information. (Don’t include the brackets!) The text should be enclosed in the appropriate comment syntax for the file format. We also recommend that a file or class name and description of purpose be included on the same “printed page” as the copyright notice for easier identification within third-party archives.
    
    
    Copyright [yyyy] [name of copyright owner]
    
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
      http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/authors.html

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

# Authors and Citation

## Authors

  * **Edward Burn**. Author, maintainer. [](https://orcid.org/0000-0002-9286-1128)

  * **Marti Catala**. Author. [](https://orcid.org/0000-0003-3308-9905)

  * **Xihang Chen**. Author. [](https://orcid.org/0009-0001-8112-8959)

  * **Marta Alcalde-Herraiz**. Author. [](https://orcid.org/0009-0002-4405-1814)

  * **Nuria Mercade-Besora**. Author. [](https://orcid.org/0009-0006-7948-3747)

  * **Albert Prats-Uribe**. Author. [](https://orcid.org/0000-0003-1202-9153)




## Citation

Burn E, Catala M, Chen X, Alcalde-Herraiz M, Mercade-Besora N, Prats-Uribe A (2025). _PhenotypeR: Assess Study Cohorts Using a Common Data Model_. R package version 0.2.0, <https://ohdsi.github.io/PhenotypeR/>. 
    
    
    @Manual{,
      title = {PhenotypeR: Assess Study Cohorts Using a Common Data Model},
      author = {Edward Burn and Marti Catala and Xihang Chen and Marta Alcalde-Herraiz and Nuria Mercade-Besora and Albert Prats-Uribe},
      year = {2025},
      note = {R package version 0.2.0},
      url = {https://ohdsi.github.io/PhenotypeR/},
    }

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/reference/databaseDiagnostics.html

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

---

## Content from https://ohdsi.github.io/PhenotypeR/reference/codelistDiagnostics.html

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

---

## Content from https://ohdsi.github.io/PhenotypeR/reference/cohortDiagnostics.html

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

---

## Content from https://ohdsi.github.io/PhenotypeR/reference/populationDiagnostics.html

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

# Population-level diagnostics

`populationDiagnostics.Rd`

phenotypeR diagnostics on the cohort of input with relation to a denomination population. Diagnostics include:

* Incidence * Prevalence

## Usage
    
    
    populationDiagnostics(
      cohort,
      populationSample = 1e+06,
      populationDateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)(NA, NA))
    )

## Arguments

cohort
    

Cohort table in a cdm reference

populationSample
    

Number of people from the cdm to sample. If NULL no sampling will be performed. Sample will be within populationDateRange if specified.

populationDateRange
    

Two dates. The first indicating the earliest cohort start date and the second indicating the latest possible cohort end date. If NULL or the first date is set as missing, the earliest observation_start_date in the observation_period table will be used for the former. If NULL or the second date is set as missing, the latest observation_end_date in the observation_period table will be used for the latter.

## Value

A summarised result

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    #> 
    #> Attaching package: ‘dplyr’
    #> The following objects are masked from ‘package:stats’:
    #> 
    #>     filter, lag
    #> The following objects are masked from ‘package:base’:
    #> 
    #>     intersect, setdiff, setequal, union
    
    cdm <- [mockPhenotypeR](mockPhenotypeR.html)()
    
    dateStart <- cdm$my_cohort |>
      [summarise](https://dplyr.tidyverse.org/reference/summarise.html)(start = [min](https://rdrr.io/r/base/Extremes.html)(cohort_start_date, na.rm = TRUE)) |>
      [pull](https://dplyr.tidyverse.org/reference/pull.html)("start")
    dateEnd   <- cdm$my_cohort |>
      [summarise](https://dplyr.tidyverse.org/reference/summarise.html)(start = [max](https://rdrr.io/r/base/Extremes.html)(cohort_start_date, na.rm = TRUE)) |>
      [pull](https://dplyr.tidyverse.org/reference/pull.html)("start")
    
    result <- cdm$my_cohort |>
      populationDiagnostics(populationDateRange = [c](https://rdrr.io/r/base/c.html)(dateStart, dateEnd))
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
    
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/reference/tableCohortExpectations.html

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

# Create a table summarising cohort expectations

`tableCohortExpectations.Rd`

Create a table summarising cohort expectations

## Usage
    
    
    tableCohortExpectations(expectations, type = "reactable")

## Arguments

expectations
    

Data frame or tibble with cohort expectations. It must contain the following columns: cohort_name, estimate, value, and source.

type
    

Table type to view results. See visOmopResults::tableType() for supported tables.

## Value

Summary of cohort expectations

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/reference/addCodelistAttribute.html

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

---

## Content from https://ohdsi.github.io/PhenotypeR/reference/mockPhenotypeR.html

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

# Function to create a mock cdm reference for mockPhenotypeR

`mockPhenotypeR.Rd`

`mockPhenotypeR()` creates an example dataset that can be used to show how the package works

## Usage
    
    
    mockPhenotypeR(
      nPerson = 100,
      con = DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)()),
      writeSchema = "main",
      seed = 111
    )

## Arguments

nPerson
    

number of people in the cdm.

con
    

A DBI connection to create the cdm mock object.

writeSchema
    

Name of an schema on the same connection with writing permissions.

seed
    

seed to use when creating the mock data.

## Value

cdm object

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    
    cdm <- mockPhenotypeR()
    
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of mock database ──────────────────────────────
    #> • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
    #> concept_synonym, condition_occurrence, death, device_exposure, drug_exposure,
    #> drug_strength, measurement, observation, observation_period, person,
    #> procedure_occurrence, visit_occurrence, vocabulary
    #> • cohort tables: my_cohort
    #> • achilles tables: achilles_analysis, achilles_results, achilles_results_dist
    #> • other tables: -
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/articles/a03_DatabaseDiagnostics.html

Skip to contents

[PhenotypeR](../index.html) 0.1.6

  * [Reference](../reference/index.html)
  * Articles
    * [Phenotype diagnostics](../articles/a01_PhenotypeDiagnostics.html)
    * [Shiny diagnostics](../articles/a02_ShinyDiagnostics.html)
    * [Database diagnostics](../articles/a03_DatabaseDiagnostics.html)
    * [Codelist diagnostics](../articles/a04_CodelistDiagnostics.html)
    * [Cohort diagnostics](../articles/a05_CohortDiagnostics.html)
    * [Population diagnostics](../articles/a07_PopulationDiagnostics.html)
    * [Phenotype expectations](../articles/phenotypeExpectations.html)


  * 


![](../logo.png)

# Database diagnostics

`a03_DatabaseDiagnostics.Rmd`

## Introduction

In this example we’re going to be using the Eunomia synthetic data.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                                    cdmName = "Eunomia Synpuf",
                                    cdmSchema   = "main",
                                    writeSchema = "main", 
                                    achillesSchema = "main")

## Database diagnostics

Although we may have created our study cohort, to inform analytic decisions and interpretation of results requires an understanding of the dataset from which it has been derived. The `[databaseDiagnostics()](../reference/databaseDiagnostics.html)` function will help us better understand a data source.

To run database diagnostics we just need to provide our cdm reference to the function.
    
    
    db_diagnostics <- [databaseDiagnostics](../reference/databaseDiagnostics.html)(cdm)

Database diagnostics builds on [OmopSketch](https://ohdsi.github.io/OmopSketch/index.html) package to perform the following analyses:

  * **Snapshot:** Summarises the meta data of a CDM object by using [summariseOmopSnapshot()](https://ohdsi.github.io/OmopSketch/reference/summariseOmopSnapshot.html)
  * **Observation periods:** Summarises the observation period table by using [summariseObservationPeriod()](https://ohdsi.github.io/OmopSketch/reference/summariseObservationPeriod.html). This will allow us to see if there are individuals with multiple, non-overlapping, observation periods and how long each observation period lasts on average.



The output is a summarised result object.

## Visualise the results

We can use [OmopSketch](https://ohdsi.github.io/OmopSketch/index.html) package functions to visualise the results obtained.

### Snapshot
    
    
    [tableOmopSnapshot](https://OHDSI.github.io/OmopSketch/reference/tableOmopSnapshot.html)(db_diagnostics)

Estimate |  Database name  
---|---  
Eunomia Synpuf  
General  
Snapshot date | 2025-07-22  
Person count | 1,000  
Vocabulary version | v5.0 06-AUG-21  
Observation period  
N | 1,048  
Start date | 2008-01-01  
End date | 2010-12-31  
Cdm  
Source name | Synpuf  
Version | v5.3.1  
Holder name | ohdsi  
Release date | 2018-03-15  
Description |   
Documentation reference |   
Source type | duckdb  
  
### Observation periods
    
    
    [tableObservationPeriod](https://OHDSI.github.io/OmopSketch/reference/tableObservationPeriod.html)(db_diagnostics)

Observation period ordinal | Variable name | Estimate name |  CDM name  
---|---|---|---  
Eunomia Synpuf  
all | Number records | N | 1,048  
| Number subjects | N | 1,000  
| Records per person | mean (sd) | 1.05 (0.21)  
|  | median [Q25 - Q75] | 1 [1 - 1]  
| Duration in days | mean (sd) | 979.71 (262.79)  
|  | median [Q25 - Q75] | 1,096 [1,096 - 1,096]  
| Days to next observation period | mean (sd) | 172.17 (108.35)  
|  | median [Q25 - Q75] | 138 [93 - 254]  
1st | Number subjects | N | 1,000  
| Duration in days | mean (sd) | 994.16 (257.95)  
|  | median [Q25 - Q75] | 1,096 [1,096 - 1,096]  
| Days to next observation period | mean (sd) | 172.17 (108.35)  
|  | median [Q25 - Q75] | 138 [93 - 254]  
2nd | Number subjects | N | 48  
| Duration in days | mean (sd) | 678.60 (164.50)  
|  | median [Q25 - Q75] | 730 [730 - 730]  
| Days to next observation period | mean (sd) | -  
|  | median [Q25 - Q75] | -  
  
## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/articles/a04_CodelistDiagnostics.html

Skip to contents

[PhenotypeR](../index.html) 0.1.6

  * [Reference](../reference/index.html)
  * Articles
    * [Phenotype diagnostics](../articles/a01_PhenotypeDiagnostics.html)
    * [Shiny diagnostics](../articles/a02_ShinyDiagnostics.html)
    * [Database diagnostics](../articles/a03_DatabaseDiagnostics.html)
    * [Codelist diagnostics](../articles/a04_CodelistDiagnostics.html)
    * [Cohort diagnostics](../articles/a05_CohortDiagnostics.html)
    * [Population diagnostics](../articles/a07_PopulationDiagnostics.html)
    * [Phenotype expectations](../articles/phenotypeExpectations.html)


  * 


![](../logo.png)

# Codelist diagnostics

`a04_CodelistDiagnostics.Rmd`

## Introduction

In this example we’re going to summarise the characteristics of individuals with an ankle sprain, ankle fracture, forearm fracture, a hip fracture and different measurements using the Eunomia synthetic data.

We’ll begin by creating our study cohorts.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    [library](https://rdrr.io/r/base/library.html)(MeasurementDiagnostics)
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                                    cdmName = "Eunomia Synpuf",
                                    cdmSchema   = "main",
                                    writeSchema = "main", 
                                    achillesSchema = "main")
    
    cdm$injuries <- [conceptCohort](https://ohdsi.github.io/CohortConstructor/reference/conceptCohort.html)(cdm = cdm,
      conceptSet = [list](https://rdrr.io/r/base/list.html)(
        "ankle_sprain" = 81151,
        "ankle_fracture" = 4059173,
        "forearm_fracture" = 4278672,
        "hip_fracture" = 4230399,
        "measurements_cohort" = [c](https://rdrr.io/r/base/c.html)(40660437L, 2617206L, 4034850L,  2617239L, 4098179L)
      ),
      name = "injuries")
    cdm$injuries |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/RtmpsGR7XW/file234542b5c5e7.duckdb]
    #> $ cohort_definition_id <int> 5, 5, 5, 5, 5, 2, 2, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5…
    #> $ subject_id           <int> 592, 848, 481, 898, 1238, 480, 245, 278, 863, 828…
    #> $ cohort_start_date    <date> 2009-07-23, 2010-02-18, 2009-11-14, 2010-01-07, …
    #> $ cohort_end_date      <date> 2009-07-23, 2010-02-18, 2009-11-14, 2010-01-07, …

## Summarising code use

To get a good understanding of the codes we’ve used to define our cohorts we can use the `[codelistDiagnostics()](../reference/codelistDiagnostics.html)` function.
    
    
    code_diag <- [codelistDiagnostics](../reference/codelistDiagnostics.html)(cdm$injuries)

Codelist diagnostics builds on [CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/) and [MeasurementDiagnostics](https://ohdsi.github.io/MeasurementDiagnostics/) R packages to perform the following analyses:

  * **Achilles code use:** Which summarises the counts of our codes in our database based on achilles results using [summariseAchillesCodeUse()](https://darwin-eu.github.io/CodelistGenerator/reference/summariseAchillesCodeUse.html).
  * **Orphan code use:** Orphan codes refer to codes that we did not include in our cohort definition, but that have any relationship with the codes in our codelist. So, although many can be false positives, we may identify some codes that we may want to use in our cohort definitions. This analysis uses [summariseOrphanCodes()](https://darwin-eu.github.io/CodelistGenerator/reference/summariseOrphanCodes.html).
  * **Cohort code use:** Summarises the cohort code use in our cohort using [summariseCohortCodeUse()](https://darwin-eu.github.io/CodelistGenerator/reference/summariseCohortCodeUse.html).
  * **Measurement diagnostics:** If any of the concepts used in our codelist is a measurement, it summarises its code use using [summariseCohortMeasurementUse()](https://ohdsi.github.io/MeasurementDiagnostics/reference/summariseCohortMeasurementUse.html).



The output of a function is a summarised result table.

### Add codelist attribute

Some cohorts that may be created manually may not have the codelists recorded in the `cohort_codelist` attribute. The package has a utility function to record a codelist in a `cohort_table` object:
    
    
    [cohortCodelist](https://darwin-eu.github.io/omopgenerics/reference/cohortCodelist.html)(cdm$injuries, cohortId = 1)
    #> 
    #> - ankle_fracture (1 codes)
    cdm$injuries <- cdm$injuries |>
      [addCodelistAttribute](../reference/addCodelistAttribute.html)(codelist = [list](https://rdrr.io/r/base/list.html)(new_codelist = [c](https://rdrr.io/r/base/c.html)(1L, 2L)), cohortName = "ankle_fracture")
    [cohortCodelist](https://darwin-eu.github.io/omopgenerics/reference/cohortCodelist.html)(cdm$injuries, cohortId = 1)
    #> 
    #> - new_codelist (2 codes)

## Visualise the results

We will now use different functions to visualise the results generated by CohortDiagnostics. Notice that these functions are from [CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/) and [MeasurementDiagnostics](https://ohdsi.github.io/MeasurementDiagnostics/) R packages packages.

### Achilles code use
    
    
    [tableAchillesCodeUse](https://darwin-eu.github.io/CodelistGenerator/reference/tableAchillesCodeUse.html)(code_diag)

|  Database name  
---|---  
|  Eunomia Synpuf  
Codelist name | Domain ID | Standard concept name | Standard concept ID | Standard concept | Vocabulary ID |  Estimate name  
Record count | Person count  
ankle_sprain | condition | Sprain of ankle | 81151 | standard | SNOMED | 31 | 27  
measurements_cohort | measurement | Prostate cancer screening; prostate specific antigen test (psa) | 2617206 | standard | HCPCS | 146 | 124  
|  | Screening cytopathology, cervical or vaginal (any reporting system), collected in preservative fluid, automated thin layer preparation, with screening by automated system and manual rescreening under physician supervision | 2617239 | standard | HCPCS | 52 | 47  
|  | Laboratory test | 4034850 | standard | SNOMED | 101 | 95  
|  | Drug screen, qualitative; multiple drug classes by high complexity test method (e.g., immunoassay, enzyme assay), per patient encounter | 40660437 | standard | HCPCS | 45 | 26  
|  | Immunology laboratory test | 4098179 | standard | SNOMED | 20 | 20  
  
### Orphan code use
    
    
    [tableOrphanCodes](https://darwin-eu.github.io/CodelistGenerator/reference/tableOrphanCodes.html)(code_diag)

|  Database name  
---|---  
|  Eunomia Synpuf  
Codelist name | Domain ID | Standard concept name | Standard concept ID | Standard concept | Vocabulary ID |  Estimate name  
Record count | Person count  
ankle_fracture | condition | Open fracture of medial malleolus | 432749 | standard | SNOMED | 3 | 3  
|  | Open fracture of lateral malleolus | 437998 | standard | SNOMED | 3 | 3  
|  | Closed bimalleolar fracture | 438879 | standard | SNOMED | 9 | 7  
|  | Closed fracture of medial malleolus | 439162 | standard | SNOMED | 4 | 3  
|  | Open bimalleolar fracture | 441154 | standard | SNOMED | 1 | 1  
|  | Closed trimalleolar fracture | 441155 | standard | SNOMED | 5 | 4  
|  | Closed fracture of lateral malleolus | 441428 | standard | SNOMED | 21 | 12  
|  | Closed fracture of talus | 74777 | standard | SNOMED | 2 | 2  
|  | Closed fracture of ankle | 75095 | standard | SNOMED | 19 | 16  
|  | Open fracture of talus | 77131 | standard | SNOMED | 2 | 2  
|  | Open fracture of ankle | 78888 | standard | SNOMED | 5 | 4  
ankle_sprain | condition | Sprain of distal tibiofibular ligament | 73889 | standard | SNOMED | 4 | 4  
|  | Sprain of calcaneofibular ligament | 75667 | standard | SNOMED | 1 | 1  
|  | Sprain of deltoid ligament of ankle | 77707 | standard | SNOMED | 4 | 4  
forearm_fracture | condition | Closed fracture of shaft of bone of forearm | 4101989 | standard | SNOMED | 1 | 1  
|  | Open fracture of shaft of bone of forearm | 4195752 | standard | SNOMED | 2 | 2  
|  | Open fracture of neck of radius | 432744 | standard | SNOMED | 1 | 1  
|  | Open fracture of lower end of radius AND ulna | 432747 | standard | SNOMED | 1 | 1  
|  | Open fracture of proximal end of ulna | 433047 | standard | SNOMED | 2 | 2  
|  | Open fracture of shaft of ulna | 433333 | standard | SNOMED | 1 | 1  
|  | Open Colles' fracture | 434767 | standard | SNOMED | 2 | 2  
|  | Open fracture of upper end of forearm | 434771 | standard | SNOMED | 1 | 1  
|  | Closed fracture of distal end of ulna | 435374 | standard | SNOMED | 4 | 3  
|  | Closed fracture of radius AND ulna | 435380 | standard | SNOMED | 6 | 6  
|  | Closed Colles' fracture | 435950 | standard | SNOMED | 20 | 13  
|  | Closed fracture of proximal end of ulna | 436251 | standard | SNOMED | 1 | 1  
|  | Closed fracture of ulna | 436541 | standard | SNOMED | 1 | 1  
|  | Closed fracture of shaft of radius | 436826 | standard | SNOMED | 2 | 2  
|  | Closed fracture of neck of radius | 436837 | standard | SNOMED | 3 | 2  
|  | Closed fracture of distal end of radius | 437116 | standard | SNOMED | 48 | 33  
|  | Open fracture of lower end of forearm | 437122 | standard | SNOMED | 1 | 1  
|  | Open fracture of upper end of radius AND ulna | 437393 | standard | SNOMED | 1 | 1  
|  | Closed fracture of lower end of forearm | 437394 | standard | SNOMED | 4 | 3  
|  | Closed fracture of shaft of ulna | 437400 | standard | SNOMED | 1 | 1  
|  | Open fracture of ulna | 438576 | standard | SNOMED | 1 | 1  
|  | Closed fracture of radius | 439166 | standard | SNOMED | 11 | 7  
|  | Closed fracture of upper end of forearm | 439940 | standard | SNOMED | 4 | 3  
|  | Pathological fracture - forearm | 440511 | standard | SNOMED | 1 | 1  
|  | Closed fracture of lower end of radius AND ulna | 440538 | standard | SNOMED | 6 | 5  
|  | Closed fracture of upper end of radius AND ulna | 440544 | standard | SNOMED | 6 | 2  
|  | Open fracture of distal end of radius | 440546 | standard | SNOMED | 3 | 3  
|  | Open fracture of forearm | 440851 | standard | SNOMED | 1 | 1  
|  | Closed fracture of proximal end of radius | 441973 | standard | SNOMED | 3 | 3  
|  | Closed fracture of forearm | 441974 | standard | SNOMED | 1 | 1  
|  | Fracture of radius AND ulna | 442598 | standard | SNOMED | 1 | 1  
|  | Torus fracture of radius | 443428 | standard | SNOMED | 1 | 1  
|  | Closed fracture of olecranon process of ulna | 73036 | standard | SNOMED | 7 | 5  
|  | Closed fracture of head of radius | 73341 | standard | SNOMED | 6 | 4  
|  | Open fracture of coronoid process of ulna | 74192 | standard | SNOMED | 1 | 1  
|  | Open fracture of olecranon process of ulna | 74763 | standard | SNOMED | 4 | 4  
|  | Closed Monteggia's fracture | 79165 | standard | SNOMED | 1 | 1  
|  | Closed fracture of coronoid process of ulna | 79172 | standard | SNOMED | 2 | 2  
|  | Open Monteggia's fracture | 81148 | standard | SNOMED | 1 | 1  
hip_fracture | condition | Closed intertrochanteric fracture | 136834 | standard | SNOMED | 56 | 38  
|  | Closed fracture proximal femur, subtrochanteric | 4009610 | standard | SNOMED | 12 | 9  
|  | Closed fracture of neck of femur | 434500 | standard | SNOMED | 144 | 77  
|  | Closed fracture of base of neck of femur | 435956 | standard | SNOMED | 15 | 10  
|  | Closed fracture of midcervical section of femur | 436247 | standard | SNOMED | 16 | 14  
|  | Closed fracture of intracapsular section of femur | 437703 | standard | SNOMED | 8 | 7  
|  | Closed transcervical fracture of femur | 440556 | standard | SNOMED | 20 | 17  
|  | Closed fracture of acetabulum | 81696 | standard | SNOMED | 10 | 6  
measurements_cohort | procedure | Antibody screen, RBC, each serum technique | 2212937 | standard | CPT4 | 55 | 53  
|  | Antibody identification, RBC antibodies, each panel for each serum technique | 2212939 | standard | CPT4 | 1 | 1  
|  | Pathology consultation during surgery; cytologic examination (eg, touch prep, squash prep), initial site | 2213298 | standard | CPT4 | 3 | 3  
| measurement | Screening cytopathology, cervical or vaginal (any reporting system), collected in preservative fluid, automated thin layer preparation, requiring interpretation by physician | 2617226 | standard | HCPCS | 1 | 1  
|  | Screening cytopathology smears, cervical or vaginal, performed by automated system with manual rescreening | 2617241 | standard | HCPCS | 1 | 1  
|  | Wet mounts, including preparations of vaginal, cervical or skin specimens | 2720582 | standard | HCPCS | 1 | 1  
|  | Detection of parasite | 4047338 | standard | SNOMED | 3 | 3  
|  | Antenatal RhD antibody screening | 4060266 | standard | SNOMED | 8 | 8  
|  | Type 1 hypersensitivity skin test | 4091110 | standard | SNOMED | 3 | 3  
|  | Hematology screening test | 4198132 | standard | SNOMED | 20 | 20  
|  | Sickle cell disease screening test | 4199173 | standard | SNOMED | 9 | 9  
|  | Microscopic examination of cervical Papanicolaou smear | 4208622 | standard | SNOMED | 10 | 10  
|  | Genetic test | 4237017 | standard | SNOMED | 23 | 23  
|  | Blood group typing | 4258677 | standard | SNOMED | 14 | 14  
|  | Microscopic examination of vaginal Papanicolaou smear | 4258831 | standard | SNOMED | 22 | 22  
  
### Cohort code use
    
    
    [tableCohortCodeUse](https://darwin-eu.github.io/CodelistGenerator/reference/tableCohortCodeUse.html)(code_diag)

|  Database name  
---|---  
|  Eunomia Synpuf  
Cohort name | Codelist name | Standard concept name | Standard concept ID | Source concept name | Source concept ID | Source concept value | Domain ID |  Estimate name  
Person count | Record count  
ankle_sprain | ankle_sprain | Sprain of ankle | 81151 | Other sprains and strains of ankle | 44829371 | 84509 | condition | 6 | 6  
|  |  |  | Sprain of ankle, unspecified site | 44820150 | 84500 | condition | 23 | 25  
|  | overall | - | NA | NA | NA | NA | 27 | 31  
measurements_cohort | measurements_cohort | Drug screen, qualitative; multiple drug classes by high complexity test method (e.g., immunoassay, enzyme assay), per patient encounter | 40660437 | Drug screen, qualitative; multiple drug classes by high complexity test method (e.g., immunoassay, enzyme assay), per patient encounter | 40660437 | G0431 | measurement | 26 | 45  
|  | Immunology laboratory test | 4098179 | Antibody response examination | 44830850 | V7261 | measurement | 11 | 11  
|  |  |  | Other and unspecified nonspecific immunological findings | 44830461 | 79579 | measurement | 9 | 9  
|  | Laboratory test | 4034850 | Laboratory examination | 44836706 | V726 | measurement | 45 | 48  
|  |  |  | Laboratory examination ordered as part of a routine general medical examination | 44823881 | V7262 | measurement | 14 | 14  
|  |  |  | Laboratory examination, unspecified | 44835527 | V7260 | measurement | 16 | 16  
|  |  |  | Other laboratory examination | 44835528 | V7269 | measurement | 13 | 13  
|  |  |  | Pre-procedural laboratory examination | 44827407 | V7263 | measurement | 10 | 10  
|  | Prostate cancer screening; prostate specific antigen test (psa) | 2617206 | Prostate cancer screening; prostate specific antigen test (psa) | 2617206 | G0103 | measurement | 124 | 146  
|  | Screening cytopathology, cervical or vaginal (any reporting system), collected in preservative fluid, automated thin layer preparation, with screening by automated system and manual rescreening under physician supervision | 2617239 | Screening cytopathology, cervical or vaginal (any reporting system), collected in preservative fluid, automated thin layer preparation, with screening by automated system and manual rescreening under physician supervision | 2617239 | G0145 | measurement | 47 | 52  
|  | overall | - | NA | NA | NA | NA | 255 | 364  
  
### Measurement timings
    
    
    [tableMeasurementTimings](https://rdrr.io/pkg/MeasurementDiagnostics/man/tableMeasurementTimings.html)(code_diag)

CDM name | Cohort name | Variable name | Estimate name | Estimate value  
---|---|---|---|---  
measurements_cohort  
Eunomia Synpuf | measurements_cohort | Number records | N | 364  
|  | Number subjects | N | 255  
|  | Time | Median [Q25 - Q75] | 150.00 [19.00 - 356.00]  
|  |  | Range | 0.00 to 930.00  
|  | Measurements per subject | Median [Q25 - Q75] | 2.00 [1.00 - 2.00]  
|  |  | Range | 1.00 to 10.00  
      
    
    [plotMeasurementTimings](https://rdrr.io/pkg/MeasurementDiagnostics/man/plotMeasurementTimings.html)(code_diag)

![](a04_CodelistDiagnostics_files/figure-html/unnamed-chunk-9-1.png)

### Measurement value as concept
    
    
    [tableMeasurementValueAsConcept](https://rdrr.io/pkg/MeasurementDiagnostics/man/tableMeasurementValueAsConcept.html)(code_diag)

CDM name | Cohort name | Concept name | Concept ID | Domain ID | Variable name | Value as concept name | Value as concept ID | Estimate name | Estimate value  
---|---|---|---|---|---|---|---|---|---  
measurements_cohort  
Eunomia Synpuf | measurements_cohort | overall | overall | overall | Value as concept name | No matching concept | 0 | N (%) | 364 (100.00%)  
|  | Laboratory test | 4034850 | Measurement | Value as concept name | No matching concept | 0 | N (%) | 101 (100.00%)  
|  | Prostate cancer screening; prostate specific antigen test (psa) | 2617206 | Measurement | Value as concept name | No matching concept | 0 | N (%) | 146 (100.00%)  
|  | Drug screen, qualitative; multiple drug classes by high complexity test method (e.g., immunoassay, enzyme assay), per patient encounter | 40660437 | Measurement | Value as concept name | No matching concept | 0 | N (%) | 45 (100.00%)  
|  | Immunology laboratory test | 4098179 | Measurement | Value as concept name | No matching concept | 0 | N (%) | 20 (100.00%)  
|  | Screening cytopathology, cervical or vaginal (any reporting system), collected in preservative fluid, automated thin layer preparation, with screening by automated system and manual rescreening under physician supervision | 2617239 | Measurement | Value as concept name | No matching concept | 0 | N (%) | 52 (100.00%)  
      
    
    [plotMeasurementValueAsConcept](https://rdrr.io/pkg/MeasurementDiagnostics/man/plotMeasurementValueAsConcept.html)(code_diag)

![](a04_CodelistDiagnostics_files/figure-html/unnamed-chunk-11-1.png)

### Measurement value as numeric
    
    
    [tableMeasurementValueAsNumeric](https://rdrr.io/pkg/MeasurementDiagnostics/man/tableMeasurementValueAsNumeric.html)(code_diag)

CDM name | Cohort name | Concept name | Concept ID | Domain ID | Unit concept name | Unit concept ID | Estimate name | Estimate value  
---|---|---|---|---|---|---|---|---  
measurements_cohort  
Eunomia Synpuf | measurements_cohort | overall | overall | overall | No matching concept | 0 | N | 364  
|  |  |  |  |  |  | Median [Q25 - Q75] | -  
|  |  |  |  |  |  | Range | -  
|  |  |  |  |  |  | Missing value, N (%) | 364 (100.00%)  
|  | Prostate cancer screening; prostate specific antigen test (psa) | 2617206 | Measurement | No matching concept | 0 | N | 146  
|  |  |  |  |  |  | Median [Q25 - Q75] | -  
|  |  |  |  |  |  | Range | -  
|  |  |  |  |  |  | Missing value, N (%) | 146 (100.00%)  
|  | Laboratory test | 4034850 | Measurement | No matching concept | 0 | N | 101  
|  |  |  |  |  |  | Median [Q25 - Q75] | -  
|  |  |  |  |  |  | Range | -  
|  |  |  |  |  |  | Missing value, N (%) | 101 (100.00%)  
|  | Screening cytopathology, cervical or vaginal (any reporting system), collected in preservative fluid, automated thin layer preparation, with screening by automated system and manual rescreening under physician supervision | 2617239 | Measurement | No matching concept | 0 | N | 52  
|  |  |  |  |  |  | Median [Q25 - Q75] | -  
|  |  |  |  |  |  | Range | -  
|  |  |  |  |  |  | Missing value, N (%) | 52 (100.00%)  
|  | Drug screen, qualitative; multiple drug classes by high complexity test method (e.g., immunoassay, enzyme assay), per patient encounter | 40660437 | Measurement | No matching concept | 0 | N | 45  
|  |  |  |  |  |  | Median [Q25 - Q75] | -  
|  |  |  |  |  |  | Range | -  
|  |  |  |  |  |  | Missing value, N (%) | 45 (100.00%)  
|  | Immunology laboratory test | 4098179 | Measurement | No matching concept | 0 | N | 20  
|  |  |  |  |  |  | Median [Q25 - Q75] | -  
|  |  |  |  |  |  | Range | -  
|  |  |  |  |  |  | Missing value, N (%) | 20 (100.00%)  
      
    
    [plotMeasurementValueAsNumeric](https://rdrr.io/pkg/MeasurementDiagnostics/man/plotMeasurementValueAsNumeric.html)(code_diag)

![](a04_CodelistDiagnostics_files/figure-html/unnamed-chunk-13-1.png)

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/articles/a05_CohortDiagnostics.html

Skip to contents

[PhenotypeR](../index.html) 0.1.6

  * [Reference](../reference/index.html)
  * Articles
    * [Phenotype diagnostics](../articles/a01_PhenotypeDiagnostics.html)
    * [Shiny diagnostics](../articles/a02_ShinyDiagnostics.html)
    * [Database diagnostics](../articles/a03_DatabaseDiagnostics.html)
    * [Codelist diagnostics](../articles/a04_CodelistDiagnostics.html)
    * [Cohort diagnostics](../articles/a05_CohortDiagnostics.html)
    * [Population diagnostics](../articles/a07_PopulationDiagnostics.html)
    * [Phenotype expectations](../articles/phenotypeExpectations.html)


  * 


![](../logo.png)

# Cohort diagnostics

`a05_CohortDiagnostics.Rmd`

## Introduction

In this example we’re going to summarise cohort diagnostics results for cohorts of individuals with an ankle sprain, ankle fracture, forearm fracture, or a hip fracture using the Eunomia synthetic data.

Again, we’ll begin by creating our study cohorts.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([CohortSurvival](https://darwin-eu-dev.github.io/CohortSurvival/))
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                                    cdmName = "Eunomia Synpuf",
                                    cdmSchema   = "main",
                                    writeSchema = "main", 
                                    achillesSchema = "main")
    
    cdm$injuries <- [conceptCohort](https://ohdsi.github.io/CohortConstructor/reference/conceptCohort.html)(cdm = cdm,
      conceptSet = [list](https://rdrr.io/r/base/list.html)(
        "ankle_sprain" = 81151,
        "ankle_fracture" = 4059173,
        "forearm_fracture" = 4278672,
        "hip_fracture" = 4230399
      ),
      name = "injuries")

## Cohort diagnostics

We can run cohort diagnostics analyses for each of our overall cohorts like so:
    
    
    cohort_diag <- [cohortDiagnostics](../reference/cohortDiagnostics.html)(cdm$injuries, 
                                     match = TRUE, 
                                     matchedSample = NULL,
                                     survival = TRUE)

Cohort diagnostics builds on [CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/) and [CohortSurvival](https://darwin-eu-dev.github.io/CohortSurvival/) R packages to perform the following analyses on our cohorts:

  * **Cohort count:** Summarises the number of records and persons in each one of the cohorts using [summariseCohortCount()](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortCount.html).
  * **Cohort attrition:** Summarises the attrition associated with the cohorts using [summariseCohortAttrition()](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html).
  * **Cohort characteristics:** Summarises cohort baseline characteristics using [summariseCharacteristics()](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCharacteristics.html). Results are stratified by sex and by age group (0 to 17, 18 to 64, 65 to 150). Age groups cannot be modified.
  * **Cohort large scale characteristics:** Summarises cohort large scale characteristics using [summariseLargeScaleCharacteristics()](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseLargeScaleCharacteristics.html). Results are stratified by sex and by age group (0 to 17, 18 to 64, 65 to 150). Time windows (relative to cohort entry) included are: -Inf to -1, -Inf to -366, -365 to -31, -30 to -1, 0, 1 to 30, 31 to 365, 366 to Inf, and 1 to Inf. The analysis is perform at standard and source code level.
  * **Cohort overlap:** If there is more than one cohort in the cohort table supplied, summarises the overlap between them using [summariseCohortOverlap()](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortOverlap.html).
  * **Cohort timing:** If there is more than one cohort in the cohort table supplied, summarises the timing between them using [summariseCohortTiming()](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortTiming.html).
  * **Cohort survival:** If `survival = TRUE`, summarises the survival until the event of death (if death table is present in the cdm) using  
[estimateSingleEventSurvival()](https://darwin-eu-dev.github.io/CohortSurvival/reference/estimateSingleEventSurvival.html).



If `match = TRUE`, the analyses **cohort characteristics** , **cohort age distribution** , **cohort large scale characteristics** , and **cohort survival** will also be performed in a matched cohort. The matched cohort will be created based on year of birth and sex (see [matchCohorts()](https://ohdsi.github.io/CohortConstructor/reference/matchCohorts.html) function in CohortConstructor package). This can help us to compare the results in our cohorts to those obtain in the matched cohort, representing the general population. Notice that by setting `match = TRUE`, the analysis will be performed in: (1) the original cohort, (2) individuals in the original cohorts that have a match (named the sampled cohort), and (3) the matched cohort.

As the matched process can be computationally expensive, specially when the cohorts are very big, we can reduce the matching analysis to a subset of participants from the original cohort using the `matchedSample` parameter.

The output of `[cohortDiagnostics()](../reference/cohortDiagnostics.html)` will be a summarised result table.

## Visualise cohort diagnostics results

We will now use different functions to visualise the results generated by CohortDiagnostics. Notice that these functions are from [CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/) and [CohortSurvival](https://darwin-eu-dev.github.io/CohortSurvival/) R packages packages. ### Cohort counts
    
    
    [tableCohortCount](https://darwin-eu.github.io/CohortCharacteristics/reference/tableCohortCount.html)(cohort_diag)

CDM name | Variable name | Estimate name |  Cohort name  
---|---|---|---  
ankle_fracture | ankle_sprain | forearm_fracture | hip_fracture  
Eunomia Synpuf | Number records | N | 0 | 28 | 0 | 0  
| Number subjects | N | 0 | 27 | 0 | 0  
  
### Cohort attrition
    
    
    [tableCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/tableCohortAttrition.html)(cohort_diag)

Reason |  Variable name  
---|---  
number_records | number_subjects | excluded_records | excluded_subjects  
Eunomia Synpuf; ankle_fracture  
Initial qualifying events | 0 | 0 | 0 | 0  
Record start <= record end | 0 | 0 | 0 | 0  
Record in observation | 0 | 0 | 0 | 0  
Non-missing sex | 0 | 0 | 0 | 0  
Non-missing year of birth | 0 | 0 | 0 | 0  
Merge overlapping records | 0 | 0 | 0 | 0  
Eunomia Synpuf; ankle_sprain  
Initial qualifying events | 31 | 27 | 0 | 0  
Record start <= record end | 31 | 27 | 0 | 0  
Record in observation | 31 | 27 | 0 | 0  
Non-missing sex | 31 | 27 | 0 | 0  
Non-missing year of birth | 31 | 27 | 0 | 0  
Merge overlapping records | 28 | 27 | 3 | 0  
Eunomia Synpuf; forearm_fracture  
Initial qualifying events | 0 | 0 | 0 | 0  
Record start <= record end | 0 | 0 | 0 | 0  
Record in observation | 0 | 0 | 0 | 0  
Non-missing sex | 0 | 0 | 0 | 0  
Non-missing year of birth | 0 | 0 | 0 | 0  
Merge overlapping records | 0 | 0 | 0 | 0  
Eunomia Synpuf; hip_fracture  
Initial qualifying events | 0 | 0 | 0 | 0  
Record start <= record end | 0 | 0 | 0 | 0  
Record in observation | 0 | 0 | 0 | 0  
Non-missing sex | 0 | 0 | 0 | 0  
Non-missing year of birth | 0 | 0 | 0 | 0  
Merge overlapping records | 0 | 0 | 0 | 0  
      
    
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(cohort_diag)

### Cohort characteristics
    
    
    [tableCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/reference/tableCharacteristics.html)(cohort_diag)

|  CDM name  
---|---  
|  Eunomia Synpuf  
Age group | Sex | Variable name | Variable level | Estimate name |  Cohort name  
ankle_fracture | ankle_sprain | forearm_fracture | hip_fracture | ankle_fracture_sampled | ankle_fracture_matched | ankle_sprain_sampled | ankle_sprain_matched | forearm_fracture_sampled | forearm_fracture_matched | hip_fracture_sampled | hip_fracture_matched  
overall | overall | Number records | - | N | 0 | 28 | 0 | 0 | 0 | 0 | 27 | 27 | 0 | 0 | 0 | 0  
|  | Number subjects | - | N | 0 | 27 | 0 | 0 | 0 | 0 | 26 | 27 | 0 | 0 | 0 | 0  
|  | Cohort start date | - | Median [Q25 - Q75] | - | 2009-04-23 [2008-10-30 - 2010-02-02] | - | - | - | - | 2009-05-12 [2008-10-28 - 2010-02-18] | 2009-05-12 [2008-10-28 - 2010-02-18] | - | - | - | -  
|  |  |  | Range | - | 2008-01-10 to 2010-09-13 | - | - | - | - | 2008-01-10 to 2010-09-13 | 2008-01-10 to 2010-09-13 | - | - | - | -  
|  | Cohort end date | - | Median [Q25 - Q75] | - | 2009-04-24 [2008-10-30 - 2010-02-02] | - | - | - | - | 2009-05-12 [2008-10-28 - 2010-02-18] | 2010-12-31 [2010-12-31 - 2010-12-31] | - | - | - | -  
|  |  |  | Range | - | 2008-01-10 to 2010-09-13 | - | - | - | - | 2008-01-10 to 2010-09-13 | 2009-10-01 to 2010-12-31 | - | - | - | -  
|  | Age | - | Median [Q25 - Q75] | - | 72 [66 - 77] | - | - | - | - | 73 [66 - 78] | 73 [66 - 78] | - | - | - | -  
|  |  |  | Mean (SD) | - | 71.14 (15.68) | - | - | - | - | 72.19 (14.96) | 72.26 (14.75) | - | - | - | -  
|  |  |  | Range | - | 27 to 98 | - | - | - | - | 27 to 98 | 28 to 98 | - | - | - | -  
|  | Sex | Female | N (%) | - | 11 (39.29%) | - | - | - | - | 10 (37.04%) | 10 (37.04%) | - | - | - | -  
|  |  | Male | N (%) | - | 17 (60.71%) | - | - | - | - | 17 (62.96%) | 17 (62.96%) | - | - | - | -  
|  | Prior observation | - | Median [Q25 - Q75] | - | 478 [303 - 762] | - | - | - | - | 497 [302 - 779] | 459 [292 - 779] | - | - | - | -  
|  |  |  | Mean (SD) | - | 499.54 (296.82) | - | - | - | - | 503.81 (301.59) | 476.70 (314.05) | - | - | - | -  
|  |  |  | Range | - | 9 to 986 | - | - | - | - | 9 to 986 | 2 to 986 | - | - | - | -  
|  | Future observation | - | Median [Q25 - Q75] | - | 572 [280 - 768] | - | - | - | - | 547 [278 - 775] | 547 [282 - 760] | - | - | - | -  
|  |  |  | Mean (SD) | - | 575.89 (301.07) | - | - | - | - | 570.89 (305.62) | 556.30 (294.15) | - | - | - | -  
|  |  |  | Range | - | 109 to 1,086 | - | - | - | - | 109 to 1,086 | 109 to 1,086 | - | - | - | -  
|  | Days in cohort | - | Median [Q25 - Q75] | - | 1 [1 - 1] | - | - | - | - | 1 [1 - 1] | 548 [282 - 760] | - | - | - | -  
|  |  |  | Mean (SD) | - | 1.11 (0.42) | - | - | - | - | 1.11 (0.42) | 557.30 (294.15) | - | - | - | -  
|  |  |  | Range | - | 1 to 3 | - | - | - | - | 1 to 3 | 110 to 1,087 | - | - | - | -  
|  | Number visits prior year | - | Median [Q25 - Q75] | - | 31.00 [16.50 - 45.00] | - | - | - | - | 28.00 [14.00 - 45.00] | 17.00 [0.00 - 27.50] | - | - | - | -  
|  |  |  | Mean (SD) | - | 31.71 (20.36) | - | - | - | - | 31.22 (20.57) | 17.30 (17.89) | - | - | - | -  
|  |  |  | Range | - | 0.00 to 73.00 | - | - | - | - | 0.00 to 73.00 | 0.00 to 62.00 | - | - | - | -  
18 to 64 | overall | Number records | - | N | - | 5 | - | - | - | - | 4 | 4 | - | - | - | -  
|  | Number subjects | - | N | - | 5 | - | - | - | - | 4 | 4 | - | - | - | -  
|  | Cohort start date | - | Median [Q25 - Q75] | - | 2009-09-08 [2009-01-19 - 2010-05-24] | - | - | - | - | 2010-01-15 [2009-04-15 - 2010-05-31] | 2010-01-15 [2009-04-15 - 2010-05-31] | - | - | - | -  
|  |  |  | Range | - | 2008-02-03 to 2010-06-19 | - | - | - | - | 2008-02-03 to 2010-06-19 | 2008-02-03 to 2010-06-19 | - | - | - | -  
|  | Cohort end date | - | Median [Q25 - Q75] | - | 2009-09-08 [2009-01-19 - 2010-05-24] | - | - | - | - | 2010-01-15 [2009-04-15 - 2010-05-31] | 2010-12-31 [2010-12-31 - 2010-12-31] | - | - | - | -  
|  |  |  | Range | - | 2008-02-03 to 2010-06-19 | - | - | - | - | 2008-02-03 to 2010-06-19 | 2010-12-31 to 2010-12-31 | - | - | - | -  
|  | Age | - | Median [Q25 - Q75] | - | 44 [43 - 56] | - | - | - | - | 50 [40 - 58] | 50 [40 - 58] | - | - | - | -  
|  |  |  | Mean (SD) | - | 46.60 (13.79) | - | - | - | - | 47.50 (15.76) | 48.00 (15.66) | - | - | - | -  
|  |  |  | Range | - | 27 to 63 | - | - | - | - | 27 to 63 | 28 to 64 | - | - | - | -  
|  | Sex | Female | N (%) | - | 2 (40.00%) | - | - | - | - | 1 (25.00%) | 1 (25.00%) | - | - | - | -  
|  |  | Male | N (%) | - | 3 (60.00%) | - | - | - | - | 3 (75.00%) | 3 (75.00%) | - | - | - | -  
|  | Prior observation | - | Median [Q25 - Q75] | - | 616 [384 - 874] | - | - | - | - | 745 [470 - 880] | 745 [470 - 880] | - | - | - | -  
|  |  |  | Mean (SD) | - | 561.40 (362.64) | - | - | - | - | 605.75 (402.78) | 605.75 (402.78) | - | - | - | -  
|  |  |  | Range | - | 33 to 900 | - | - | - | - | 33 to 900 | 33 to 900 | - | - | - | -  
|  | Future observation | - | Median [Q25 - Q75] | - | 479 [221 - 711] | - | - | - | - | 350 [214 - 625] | 350 [214 - 625] | - | - | - | -  
|  |  |  | Mean (SD) | - | 533.60 (362.64) | - | - | - | - | 489.25 (402.78) | 489.25 (402.78) | - | - | - | -  
|  |  |  | Range | - | 195 to 1,062 | - | - | - | - | 195 to 1,062 | 195 to 1,062 | - | - | - | -  
|  | Days in cohort | - | Median [Q25 - Q75] | - | 1 [1 - 1] | - | - | - | - | 1 [1 - 1] | 351 [216 - 626] | - | - | - | -  
|  |  |  | Mean (SD) | - | 1.00 (0.00) | - | - | - | - | 1.00 (0.00) | 490.25 (402.78) | - | - | - | -  
|  |  |  | Range | - | 1 to 1 | - | - | - | - | 1 to 1 | 196 to 1,063 | - | - | - | -  
|  | Number visits prior year | - | Median [Q25 - Q75] | - | 23.00 [5.00 - 26.00] | - | - | - | - | 14.00 [4.25 - 23.75] | 8.50 [0.00 - 25.75] | - | - | - | -  
|  |  |  | Mean (SD) | - | 20.20 (17.46) | - | - | - | - | 14.00 (12.25) | 17.25 (24.51) | - | - | - | -  
|  |  |  | Range | - | 2.00 to 45.00 | - | - | - | - | 2.00 to 26.00 | 0.00 to 52.00 | - | - | - | -  
65 to 150 | overall | Number records | - | N | - | 23 | - | - | - | - | 23 | 23 | - | - | - | -  
|  | Number subjects | - | N | - | 22 | - | - | - | - | 22 | 23 | - | - | - | -  
|  | Cohort start date | - | Median [Q25 - Q75] | - | 2009-04-04 [2008-10-28 - 2009-12-27] | - | - | - | - | 2009-04-04 [2008-10-28 - 2009-12-27] | 2009-04-04 [2008-10-28 - 2009-12-27] | - | - | - | -  
|  |  |  | Range | - | 2008-01-10 to 2010-09-13 | - | - | - | - | 2008-01-10 to 2010-09-13 | 2008-01-10 to 2010-09-13 | - | - | - | -  
|  | Cohort end date | - | Median [Q25 - Q75] | - | 2009-04-05 [2008-10-28 - 2009-12-27] | - | - | - | - | 2009-04-05 [2008-10-28 - 2009-12-27] | 2010-12-31 [2010-12-31 - 2010-12-31] | - | - | - | -  
|  |  |  | Range | - | 2008-01-10 to 2010-09-13 | - | - | - | - | 2008-01-10 to 2010-09-13 | 2009-10-01 to 2010-12-31 | - | - | - | -  
|  | Age | - | Median [Q25 - Q75] | - | 75 [68 - 81] | - | - | - | - | 75 [68 - 81] | 75 [68 - 81] | - | - | - | -  
|  |  |  | Mean (SD) | - | 76.48 (10.03) | - | - | - | - | 76.48 (10.03) | 76.48 (9.91) | - | - | - | -  
|  |  |  | Range | - | 66 to 98 | - | - | - | - | 66 to 98 | 66 to 98 | - | - | - | -  
|  | Sex | Female | N (%) | - | 9 (39.13%) | - | - | - | - | 9 (39.13%) | 9 (39.13%) | - | - | - | -  
|  |  | Male | N (%) | - | 14 (60.87%) | - | - | - | - | 14 (60.87%) | 14 (60.87%) | - | - | - | -  
|  | Prior observation | - | Median [Q25 - Q75] | - | 459 [302 - 726] | - | - | - | - | 459 [302 - 726] | 353 [292 - 720] | - | - | - | -  
|  |  |  | Mean (SD) | - | 486.09 (288.36) | - | - | - | - | 486.09 (288.36) | 454.26 (301.47) | - | - | - | -  
|  |  |  | Range | - | 9 to 986 | - | - | - | - | 9 to 986 | 2 to 986 | - | - | - | -  
|  | Future observation | - | Median [Q25 - Q75] | - | 598 [316 - 775] | - | - | - | - | 598 [316 - 775] | 598 [308 - 760] | - | - | - | -  
|  |  |  | Mean (SD) | - | 585.09 (294.69) | - | - | - | - | 585.09 (294.69) | 567.96 (281.38) | - | - | - | -  
|  |  |  | Range | - | 109 to 1,086 | - | - | - | - | 109 to 1,086 | 109 to 1,086 | - | - | - | -  
|  | Days in cohort | - | Median [Q25 - Q75] | - | 1 [1 - 1] | - | - | - | - | 1 [1 - 1] | 599 [310 - 760] | - | - | - | -  
|  |  |  | Mean (SD) | - | 1.13 (0.46) | - | - | - | - | 1.13 (0.46) | 568.96 (281.38) | - | - | - | -  
|  |  |  | Range | - | 1 to 3 | - | - | - | - | 1 to 3 | 110 to 1,087 | - | - | - | -  
|  | Number visits prior year | - | Median [Q25 - Q75] | - | 40.00 [20.50 - 47.00] | - | - | - | - | 40.00 [20.50 - 47.00] | 17.00 [0.00 - 27.50] | - | - | - | -  
|  |  |  | Mean (SD) | - | 34.22 (20.41) | - | - | - | - | 34.22 (20.41) | 17.30 (17.21) | - | - | - | -  
|  |  |  | Range | - | 0.00 to 73.00 | - | - | - | - | 0.00 to 73.00 | 0.00 to 62.00 | - | - | - | -  
overall | Female | Number records | - | N | - | 11 | - | - | - | - | 10 | 10 | - | - | - | -  
|  | Number subjects | - | N | - | 11 | - | - | - | - | 10 | 10 | - | - | - | -  
|  | Cohort start date | - | Median [Q25 - Q75] | - | 2008-12-02 [2008-03-30 - 2009-04-11] | - | - | - | - | 2008-11-13 [2008-03-29 - 2009-05-14] | 2008-11-13 [2008-03-29 - 2009-05-14] | - | - | - | -  
|  |  |  | Range | - | 2008-01-10 to 2010-04-02 | - | - | - | - | 2008-01-10 to 2010-04-02 | 2008-01-10 to 2010-04-02 | - | - | - | -  
|  | Cohort end date | - | Median [Q25 - Q75] | - | 2008-12-04 [2008-03-30 - 2009-04-11] | - | - | - | - | 2008-11-14 [2008-03-29 - 2009-05-14] | 2010-12-31 [2010-12-31 - 2010-12-31] | - | - | - | -  
|  |  |  | Range | - | 2008-01-10 to 2010-04-02 | - | - | - | - | 2008-01-10 to 2010-04-02 | 2009-12-31 to 2010-12-31 | - | - | - | -  
|  | Age | - | Median [Q25 - Q75] | - | 70 [66 - 74] | - | - | - | - | 70 [67 - 75] | 70 [67 - 75] | - | - | - | -  
|  |  |  | Mean (SD) | - | 70.09 (12.28) | - | - | - | - | 72.80 (8.82) | 72.90 (8.70) | - | - | - | -  
|  |  |  | Range | - | 43 to 92 | - | - | - | - | 63 to 92 | 64 to 92 | - | - | - | -  
|  | Sex | Female | N (%) | - | 11 (100.00%) | - | - | - | - | 10 (100.00%) | 10 (100.00%) | - | - | - | -  
|  | Prior observation | - | Median [Q25 - Q75] | - | 336 [88 - 466] | - | - | - | - | 317 [88 - 499] | 317 [88 - 499] | - | - | - | -  
|  |  |  | Mean (SD) | - | 342.91 (288.53) | - | - | - | - | 338.80 (303.79) | 338.80 (303.79) | - | - | - | -  
|  |  |  | Range | - | 9 to 822 | - | - | - | - | 9 to 822 | 9 to 822 | - | - | - | -  
|  | Future observation | - | Median [Q25 - Q75] | - | 742 [415 - 1,006] | - | - | - | - | 750 [349 - 1,007] | 750 [570 - 954] | - | - | - | -  
|  |  |  | Mean (SD) | - | 702.27 (325.00) | - | - | - | - | 701.40 (342.57) | 719.70 (292.15) | - | - | - | -  
|  |  |  | Range | - | 249 to 1,086 | - | - | - | - | 249 to 1,086 | 273 to 1,086 | - | - | - | -  
|  | Days in cohort | - | Median [Q25 - Q75] | - | 1 [1 - 1] | - | - | - | - | 1 [1 - 1] | 752 [572 - 956] | - | - | - | -  
|  |  |  | Mean (SD) | - | 1.18 (0.60) | - | - | - | - | 1.20 (0.63) | 720.70 (292.15) | - | - | - | -  
|  |  |  | Range | - | 1 to 3 | - | - | - | - | 1 to 3 | 274 to 1,087 | - | - | - | -  
|  | Number visits prior year | - | Median [Q25 - Q75] | - | 28.00 [6.50 - 45.00] | - | - | - | - | 23.50 [5.25 - 44.50] | 13.50 [1.00 - 19.25] | - | - | - | -  
|  |  |  | Mean (SD) | - | 26.82 (20.58) | - | - | - | - | 25.00 (20.74) | 14.60 (15.76) | - | - | - | -  
|  |  |  | Range | - | 0.00 to 51.00 | - | - | - | - | 0.00 to 51.00 | 0.00 to 50.00 | - | - | - | -  
| Male | Number records | - | N | - | 17 | - | - | - | - | 17 | 17 | - | - | - | -  
|  | Number subjects | - | N | - | 16 | - | - | - | - | 16 | 17 | - | - | - | -  
|  | Cohort start date | - | Median [Q25 - Q75] | - | 2009-10-08 [2009-01-03 - 2010-04-17] | - | - | - | - | 2009-10-08 [2009-01-03 - 2010-04-17] | 2009-10-08 [2009-01-03 - 2010-04-17] | - | - | - | -  
|  |  |  | Range | - | 2008-03-21 to 2010-09-13 | - | - | - | - | 2008-03-21 to 2010-09-13 | 2008-03-21 to 2010-09-13 | - | - | - | -  
|  | Cohort end date | - | Median [Q25 - Q75] | - | 2009-10-08 [2009-01-03 - 2010-04-17] | - | - | - | - | 2009-10-08 [2009-01-03 - 2010-04-17] | 2010-12-31 [2010-12-31 - 2010-12-31] | - | - | - | -  
|  |  |  | Range | - | 2008-03-21 to 2010-09-13 | - | - | - | - | 2008-03-21 to 2010-09-13 | 2009-10-01 to 2010-12-31 | - | - | - | -  
|  | Age | - | Median [Q25 - Q75] | - | 75 [66 - 79] | - | - | - | - | 75 [66 - 79] | 75 [66 - 79] | - | - | - | -  
|  |  |  | Mean (SD) | - | 71.82 (17.88) | - | - | - | - | 71.82 (17.88) | 71.88 (17.63) | - | - | - | -  
|  |  |  | Range | - | 27 to 98 | - | - | - | - | 27 to 98 | 28 to 98 | - | - | - | -  
|  | Sex | Male | N (%) | - | 17 (100.00%) | - | - | - | - | 17 (100.00%) | 17 (100.00%) | - | - | - | -  
|  | Prior observation | - | Median [Q25 - Q75] | - | 646 [368 - 837] | - | - | - | - | 646 [368 - 837] | 616 [335 - 837] | - | - | - | -  
|  |  |  | Mean (SD) | - | 600.88 (262.41) | - | - | - | - | 600.88 (262.41) | 557.82 (299.13) | - | - | - | -  
|  |  |  | Range | - | 80 to 986 | - | - | - | - | 80 to 986 | 2 to 986 | - | - | - | -  
|  | Future observation | - | Median [Q25 - Q75] | - | 449 [258 - 727] | - | - | - | - | 449 [258 - 727] | 389 [258 - 636] | - | - | - | -  
|  |  |  | Mean (SD) | - | 494.12 (262.41) | - | - | - | - | 494.12 (262.41) | 460.18 (257.08) | - | - | - | -  
|  |  |  | Range | - | 109 to 1,015 | - | - | - | - | 109 to 1,015 | 109 to 1,015 | - | - | - | -  
|  | Days in cohort | - | Median [Q25 - Q75] | - | 1 [1 - 1] | - | - | - | - | 1 [1 - 1] | 390 [259 - 637] | - | - | - | -  
|  |  |  | Mean (SD) | - | 1.06 (0.24) | - | - | - | - | 1.06 (0.24) | 461.18 (257.08) | - | - | - | -  
|  |  |  | Range | - | 1 to 2 | - | - | - | - | 1 to 2 | 110 to 1,016 | - | - | - | -  
|  | Number visits prior year | - | Median [Q25 - Q75] | - | 34.00 [23.00 - 45.00] | - | - | - | - | 34.00 [23.00 - 45.00] | 17.00 [0.00 - 30.00] | - | - | - | -  
|  |  |  | Mean (SD) | - | 34.88 (20.18) | - | - | - | - | 34.88 (20.18) | 18.88 (19.31) | - | - | - | -  
|  |  |  | Range | - | 5.00 to 73.00 | - | - | - | - | 5.00 to 73.00 | 0.00 to 62.00 | - | - | - | -  
  
### Cohort large scale characteristics
    
    
    [tableLargeScaleCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/reference/tableLargeScaleCharacteristics.html)(cohort_diag)

---

## Content from https://ohdsi.github.io/PhenotypeR/articles/a07_PopulationDiagnostics.html

Skip to contents

[PhenotypeR](../index.html) 0.1.6

  * [Reference](../reference/index.html)
  * Articles
    * [Phenotype diagnostics](../articles/a01_PhenotypeDiagnostics.html)
    * [Shiny diagnostics](../articles/a02_ShinyDiagnostics.html)
    * [Database diagnostics](../articles/a03_DatabaseDiagnostics.html)
    * [Codelist diagnostics](../articles/a04_CodelistDiagnostics.html)
    * [Cohort diagnostics](../articles/a05_CohortDiagnostics.html)
    * [Population diagnostics](../articles/a07_PopulationDiagnostics.html)
    * [Phenotype expectations](../articles/phenotypeExpectations.html)


  * 


![](../logo.png)

# Population diagnostics

`a07_PopulationDiagnostics.Rmd`

## Introduction

In this example we’re going to just create a cohort of individuals with an ankle sprain using the Eunomia synthetic data.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([IncidencePrevalence](https://darwin-eu.github.io/IncidencePrevalence/))
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                                    cdmName = "Eunomia Synpuf",
                                    cdmSchema   = "main",
                                    writeSchema = "main", 
                                    achillesSchema = "main")
    
    cdm$injuries <- [conceptCohort](https://ohdsi.github.io/CohortConstructor/reference/conceptCohort.html)(cdm = cdm,
      conceptSet = [list](https://rdrr.io/r/base/list.html)(
        "ankle_sprain" = 81151
      ),
      name = "injuries")

We can get the incidence and prevalence of our study cohort using `[populationDiagnostics()](../reference/populationDiagnostics.html)`:
    
    
    pop_diag <- [populationDiagnostics](../reference/populationDiagnostics.html)(cdm$injuries)

This function builds on [IncidencePrevalence](https://darwin-eu.github.io/IncidencePrevalence/index.html) R package to perform the following analyses:

  * **Incidence:** It estimates the incidence of our cohort using [estimateIncidence()](https://darwin-eu.github.io/IncidencePrevalence/reference/estimateIncidence.html).
  * **Prevalence:** It estimates the prevalence of our cohort on a year basis using [estimatePeriodPrevalence()](https://darwin-eu.github.io/IncidencePrevalence/reference/estimatePeriodPrevalence.html).



All analyses are performed for:

  * Overall and stratified by age groups: 0 to 17, 18 to 64, 65 to 150. Age groups cannot be modified.
  * Overall and stratified by sex (Female, Male).
  * Restricting the denominator population to those with 0 and 365 of days of prior observation.



## Visualising the results

We can use [IncidencePrevalence](https://darwin-eu.github.io/IncidencePrevalence/index.html) package to visualise the results obtained.

### Incidence
    
    
    [tableIncidence](https://darwin-eu.github.io/IncidencePrevalence/reference/tableIncidence.html)(pop_diag,     
                   groupColumn = [c](https://rdrr.io/r/base/c.html)("cdm_name", "outcome_cohort_name"),
                   hide = "denominator_cohort_name",
                   settingsColumn = [c](https://rdrr.io/r/base/c.html)("denominator_age_group",
                             "denominator_sex",
                             "denominator_days_prior_observation",
                             "outcome_cohort_name"))

Incidence start date | Incidence end date | Analysis interval | Denominator age group | Denominator sex | Denominator days prior observation |  Estimate name  
---|---|---|---|---|---|---  
Denominator (N) | Person-years | Outcome (N) | Incidence 100,000 person-years [95% CI]  
Eunomia Synpuf; ankle_sprain  
2008-01-01 | 2008-12-31 | years | 0 to 150 | Both | 0 | 973 | 941.90 | 11 | 1,167.85 (582.99 - 2,089.61)  
2009-01-01 | 2009-12-31 | years | 0 to 150 | Both | 0 | 947 | 932.17 | 8 | 858.22 (370.52 - 1,691.03)  
2010-01-01 | 2010-12-31 | years | 0 to 150 | Both | 0 | 912 | 894.83 | 8 | 894.02 (385.98 - 1,761.58)  
2008-01-01 | 2010-12-31 | overall | 0 to 150 | Both | 0 | 1,000 | 2,768.90 | 27 | 975.12 (642.61 - 1,418.74)  
2008-12-31 | 2008-12-31 | years | 0 to 150 | Both | 365 | 898 | 2.46 | 0 | 0.00 (0.00 - 150,015.43)  
2009-01-01 | 2009-12-31 | years | 0 to 150 | Both | 365 | 874 | 860.47 | 8 | 929.73 (401.39 - 1,831.93)  
2010-01-01 | 2010-12-31 | years | 0 to 150 | Both | 365 | 910 | 894.42 | 8 | 894.44 (386.15 - 1,762.40)  
2008-12-31 | 2010-12-31 | overall | 0 to 150 | Both | 365 | 968 | 1,757.34 | 16 | 910.46 (520.41 - 1,478.54)  
2008-01-01 | 2008-12-31 | years | 0 to 150 | Female | 0 | 485 | 467.68 | 7 | 1,496.73 (601.76 - 3,083.84)  
2009-01-01 | 2009-12-31 | years | 0 to 150 | Female | 0 | 475 | 466.24 | 2 | 428.96 (51.95 - 1,549.56)  
2010-01-01 | 2010-12-31 | years | 0 to 150 | Female | 0 | 460 | 452.91 | 2 | 441.59 (53.48 - 1,595.17)  
2008-01-01 | 2010-12-31 | overall | 0 to 150 | Female | 0 | 498 | 1,386.84 | 11 | 793.17 (395.95 - 1,419.20)  
| 2008-12-31 | years | 0 to 150 | Male | 0 | 488 | 474.21 | 4 | 843.50 (229.82 - 2,159.69)  
2009-01-01 | 2009-12-31 | years | 0 to 150 | Male | 0 | 472 | 465.92 | 6 | 1,287.76 (472.59 - 2,802.91)  
2010-01-01 | 2010-12-31 | years | 0 to 150 | Male | 0 | 452 | 441.92 | 6 | 1,357.71 (498.25 - 2,955.15)  
2008-01-01 | 2010-12-31 | overall | 0 to 150 | Male | 0 | 502 | 1,382.06 | 16 | 1,157.69 (661.72 - 1,880.02)  
| 2008-12-31 | years | 18 to 64 | Both | 0 | 192 | 169.81 | 1 | 588.90 (14.91 - 3,281.16)  
2009-01-01 | 2009-12-31 | years | 18 to 64 | Both | 0 | 154 | 146.70 | 2 | 1,363.35 (165.11 - 4,924.90)  
2010-01-01 | 2010-12-31 | years | 18 to 64 | Both | 0 | 139 | 133.08 | 2 | 1,502.90 (182.01 - 5,428.99)  
2008-01-01 | 2010-12-31 | overall | 18 to 64 | Both | 0 | 200 | 449.58 | 5 | 1,112.15 (361.11 - 2,595.39)  
| 2008-12-31 | years | 65 to 150 | Both | 0 | 813 | 772.09 | 10 | 1,295.18 (621.09 - 2,381.88)  
2009-01-01 | 2009-12-31 | years | 65 to 150 | Both | 0 | 801 | 785.47 | 6 | 763.87 (280.33 - 1,662.63)  
2010-01-01 | 2010-12-31 | years | 65 to 150 | Both | 0 | 781 | 761.76 | 6 | 787.66 (289.06 - 1,714.39)  
2008-01-01 | 2010-12-31 | overall | 65 to 150 | Both | 0 | 854 | 2,319.32 | 22 | 948.56 (594.45 - 1,436.12)  
      
    
    results <- pop_diag |> 
      omopgenerics::[filterSettings](https://darwin-eu.github.io/omopgenerics/reference/filterSettings.html)(result_type == "incidence") |>
      visOmopResults::[filterAdditional](https://darwin-eu.github.io/omopgenerics/reference/filterAdditional.html)(analysis_interval == "years")
    [plotIncidence](https://darwin-eu.github.io/IncidencePrevalence/reference/plotIncidence.html)(results,
                  colour = "denominator_age_group",
                  facet = [c](https://rdrr.io/r/base/c.html)("denominator_sex", "denominator_days_prior_observation"))

![](a07_PopulationDiagnostics_files/figure-html/unnamed-chunk-5-1.png)

### Prevalence
    
    
    [tablePrevalence](https://darwin-eu.github.io/IncidencePrevalence/reference/tablePrevalence.html)(pop_diag,     
                   groupColumn = [c](https://rdrr.io/r/base/c.html)("cdm_name", "outcome_cohort_name"),
                   hide = "denominator_cohort_name",
                   settingsColumn = [c](https://rdrr.io/r/base/c.html)("denominator_age_group",
                             "denominator_sex",
                             "denominator_days_prior_observation",
                             "outcome_cohort_name"))

Prevalence start date | Prevalence end date | Analysis interval | Denominator age group | Denominator sex | Denominator days prior observation |  Estimate name  
---|---|---|---|---|---|---  
Denominator (N) | Outcome (N) | Prevalence [95% CI]  
Eunomia Synpuf; ankle_sprain  
2008-01-01 | 2008-12-31 | years | 0 to 150 | Both | 0 | 973 | 11 | 0.01 (0.01 - 0.02)  
2009-01-01 | 2009-12-31 | years | 0 to 150 | Both | 0 | 958 | 9 | 0.01 (0.00 - 0.02)  
2010-01-01 | 2010-12-31 | years | 0 to 150 | Both | 0 | 930 | 8 | 0.01 (0.00 - 0.02)  
2008-01-01 | 2010-12-31 | overall | 0 to 150 | Both | 0 | 1,000 | 27 | 0.03 (0.02 - 0.04)  
2009-01-01 | 2009-12-31 | years | 0 to 150 | Both | 365 | 885 | 9 | 0.01 (0.01 - 0.02)  
2010-01-01 | 2010-12-31 | years | 0 to 150 | Both | 365 | 928 | 8 | 0.01 (0.00 - 0.02)  
2008-12-31 | 2010-12-31 | overall | 0 to 150 | Both | 365 | 979 | 17 | 0.02 (0.01 - 0.03)  
2008-01-01 | 2008-12-31 | years | 0 to 150 | Female | 0 | 485 | 7 | 0.01 (0.01 - 0.03)  
2009-01-01 | 2009-12-31 | years | 0 to 150 | Female | 0 | 482 | 2 | 0.00 (0.00 - 0.01)  
2010-01-01 | 2010-12-31 | years | 0 to 150 | Female | 0 | 468 | 2 | 0.00 (0.00 - 0.02)  
2008-01-01 | 2010-12-31 | overall | 0 to 150 | Female | 0 | 498 | 11 | 0.02 (0.01 - 0.04)  
| 2008-12-31 | years | 0 to 150 | Male | 0 | 488 | 4 | 0.01 (0.00 - 0.02)  
2009-01-01 | 2009-12-31 | years | 0 to 150 | Male | 0 | 476 | 7 | 0.01 (0.01 - 0.03)  
2010-01-01 | 2010-12-31 | years | 0 to 150 | Male | 0 | 462 | 6 | 0.01 (0.01 - 0.03)  
2008-01-01 | 2010-12-31 | overall | 0 to 150 | Male | 0 | 502 | 16 | 0.03 (0.02 - 0.05)  
| 2008-12-31 | years | 18 to 64 | Both | 0 | 192 | 1 | 0.01 (0.00 - 0.03)  
2009-01-01 | 2009-12-31 | years | 18 to 64 | Both | 0 | 155 | 2 | 0.01 (0.00 - 0.05)  
2010-01-01 | 2010-12-31 | years | 18 to 64 | Both | 0 | 141 | 2 | 0.01 (0.00 - 0.05)  
2008-01-01 | 2010-12-31 | overall | 18 to 64 | Both | 0 | 200 | 5 | 0.03 (0.01 - 0.06)  
| 2008-12-31 | years | 65 to 150 | Both | 0 | 813 | 10 | 0.01 (0.01 - 0.02)  
2009-01-01 | 2009-12-31 | years | 65 to 150 | Both | 0 | 812 | 7 | 0.01 (0.00 - 0.02)  
2010-01-01 | 2010-12-31 | years | 65 to 150 | Both | 0 | 797 | 6 | 0.01 (0.00 - 0.02)  
2008-01-01 | 2010-12-31 | overall | 65 to 150 | Both | 0 | 855 | 22 | 0.03 (0.02 - 0.04)  
      
    
    results <- pop_diag |> 
      omopgenerics::[filterSettings](https://darwin-eu.github.io/omopgenerics/reference/filterSettings.html)(result_type == "prevalence") |>
      visOmopResults::[filterAdditional](https://darwin-eu.github.io/omopgenerics/reference/filterAdditional.html)(analysis_interval == "years")
    [plotPrevalence](https://darwin-eu.github.io/IncidencePrevalence/reference/plotPrevalence.html)(results,
                   colour = "denominator_age_group",
                   facet = [c](https://rdrr.io/r/base/c.html)("denominator_sex", "denominator_days_prior_observation"))

![](a07_PopulationDiagnostics_files/figure-html/unnamed-chunk-7-1.png)

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/articles/a02_ShinyDiagnostics.html

Skip to contents

[PhenotypeR](../index.html) 0.1.6

  * [Reference](../reference/index.html)
  * Articles
    * [Phenotype diagnostics](../articles/a01_PhenotypeDiagnostics.html)
    * [Shiny diagnostics](../articles/a02_ShinyDiagnostics.html)
    * [Database diagnostics](../articles/a03_DatabaseDiagnostics.html)
    * [Codelist diagnostics](../articles/a04_CodelistDiagnostics.html)
    * [Cohort diagnostics](../articles/a05_CohortDiagnostics.html)
    * [Population diagnostics](../articles/a07_PopulationDiagnostics.html)
    * [Phenotype expectations](../articles/phenotypeExpectations.html)


  * 


![](../logo.png)

# Shiny diagnostics

`a02_ShinyDiagnostics.Rmd`

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/articles/a01_PhenotypeDiagnostics.html

Skip to contents

[PhenotypeR](../index.html) 0.1.6

  * [Reference](../reference/index.html)
  * Articles
    * [Phenotype diagnostics](../articles/a01_PhenotypeDiagnostics.html)
    * [Shiny diagnostics](../articles/a02_ShinyDiagnostics.html)
    * [Database diagnostics](../articles/a03_DatabaseDiagnostics.html)
    * [Codelist diagnostics](../articles/a04_CodelistDiagnostics.html)
    * [Cohort diagnostics](../articles/a05_CohortDiagnostics.html)
    * [Population diagnostics](../articles/a07_PopulationDiagnostics.html)
    * [Phenotype expectations](../articles/phenotypeExpectations.html)


  * 


![](../logo.png)

# Phenotype diagnostics

`a01_PhenotypeDiagnostics.Rmd`

## Introduction: Run PhenotypeDiagnostics

In this vignette, we are going to present how to run `PhenotypeDiagnostics()`. We are going to use the following packages and mock data:
    
    
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                                    cdmName = "Eunomia Synpuf",
                                    cdmSchema   = "main",
                                    writeSchema = "main", 
                                    achillesSchema = "main")
    cdm

Note that we have included [achilles tables](https://github.com/OHDSI/Achilles) in our cdm reference, which will be used to speed up some of the analyses.

## Create a cohort

First, we are going to use the package [CohortConstructor](https://ohdsi.github.io/CohortConstructor/) to generate three cohorts of _warfarin_ , _acetaminophen_ and _morphine_ users.
    
    
    # Create a codelist
    codes <- [list](https://rdrr.io/r/base/list.html)("warfarin" = [c](https://rdrr.io/r/base/c.html)(1310149, 40163554),
                  "acetaminophen" = [c](https://rdrr.io/r/base/c.html)(1125315, 1127078, 1127433, 40229134, 40231925, 40162522, 19133768),
                  "morphine" = [c](https://rdrr.io/r/base/c.html)(1110410, 35605858, 40169988))
    
    # Instantiate cohorts with CohortConstructor
    cdm$my_cohort <- [conceptCohort](https://ohdsi.github.io/CohortConstructor/reference/conceptCohort.html)(cdm = cdm,
                                   conceptSet = codes, 
                                   exit = "event_end_date",
                                   overlap = "merge",
                                   name = "my_cohort")

## Run PhenotypeDiagnostics

Now we will proceed to run `phenotypeDiagnotics()`. This function will run the following analyses:

  * **Database diagnostics** : This includes information about the size of the data, the time period covered, the number of people in the data, and other meta-data of the CDM object. See [Database diagnostics vignette](https://ohdsi.github.io/PhenotypeR/articles/a03_DatabaseDiagnostics.html) for more details.
  * **Codelist diagnostics** : This includes information on the concepts included in our cohorts’ codelist. See [Codelist diagnostics vignette](https://ohdsi.github.io/PhenotypeR/articles/a04_CodelistDiagnostics.html) for further details.
  * **Cohort diagnostics** : This summarises the characteristics of our cohorts, as well as comparing them to age and sex matched controls from the database.. See [Cohort diagnostics vignette](https://ohdsi.github.io/PhenotypeR/articles/a05_CohortDiagnostics.html) for further details.
  * **Population diagnostics** : Calculates the frequency of our study cohorts in the database in terms of their incidence rates and prevalence. See [Population diagnostics vignette](https://ohdsi.github.io/PhenotypeR/articles/a07_PopulationDiagnostics.html) for further details.



We can specify which analysis we want to perform by setting to TRUE or FALSE each one of the corresponding arguments:
    
    
    result <- phenotypeDiagnostics(
      cohort = cdm$my_cohort, 
      databaseDiagnostics = TRUE, 
      codelistDiagnostics = TRUE, 
      cohortDiagnostics   = TRUE, 
      match = TRUE,
      matchedSample = 1000
      populationDiagnostics = TRUE,
      populationSample = 1e+06,
      populationDateRange = as.Date(c(NA, NA))
      )
    result |> glimpse()

Notice that we have three additional arguments:

  * `populationSample`: It allows to specify a number of people that randomly will be extracted from the CDM to perform the **Population diagnostics** analysis. If NULL, all the participants in the CDM will be included. It helps to reduce the computational time. This is particularly useful when outcomes of interest are relatively common, but when they are rarer we may wish to maximise statistical power and calculate estimates for the dataset as a whole in which case we would set this argument to NULL.
  * `populationDateRange`: We can use it to specify the time period when we want to perform our **Population diagnostics** analysis.
  * `match`: If set to TRUE, our study cohorts will be matched with people with similar age and sex in the database, and will perform a large-scale characterisation on our original cohort, the sampled cohort (those participants from our cohort that have found a match) and the matched cohort. If set to FALSE, cohortDiagnostics will only be performed on our original cohorts.
  * `matchedSample`: Similar to populationSample, this arguments subsets a random sample of people from our cohort and performs the matched analysis on this sample. If we have very large cohorts we can use this to save computational time.



## Save the results

To save the results, we can use [exportSummarisedResult](https://darwin-eu.github.io/omopgenerics/reference/exportSummarisedResult.html) function from [omopgenerics](https://darwin-eu.github.io/omopgenerics/index.html) R Package:
    
    
    [exportSummarisedResult](https://darwin-eu.github.io/omopgenerics/reference/exportSummarisedResult.html)(result, directory = here::[here](https://here.r-lib.org/reference/here.html)(), minCellCount = 5)

## Visualisation of the results

Once we get our **Phenotype diagnostics** result, we can use `shinyDiagnostics` to easily create a shiny app and visualise our results:
    
    
    result <- [shinyDiagnostics](../reference/shinyDiagnostics.html)(result,
                               directory = [tempdir](https://rdrr.io/r/base/tempfile.html)(),
                               minCellCount = 5, 
                               open = TRUE)

Notice that we have specified the minimum number of counts (`minCellCount`) for suppression to be shown in the shiny app, and also that we want the shiny to be launched in a new R session (`open`). You can see the shiny app generated for this example in [here](https://dpa-pde-oxford.shinyapps.io/Readme_PhenotypeR/).See [Shiny diagnostics vignette](https://ohdsi.github.io/PhenotypeR/articles/a02_ShinyDiagnostics.html) for a full explanation of the shiny app.

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/PhenotypeR/articles/phenotypeExpectations.html

Skip to contents

[PhenotypeR](../index.html) 0.1.6

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
    * [PopulationDisgnostics](../articles/PopulationDisgnostics.html)
  * [PhenotypeR shiny App](https://dpa-pde-oxford.shinyapps.io/PhenotypeRShiny/)


  * [](https://github.com/OHDSI/PhenotypeR)



![](../logo.png)

# Phenotype expectations

`phenotypeExpectations.Rmd`

## Comparing phenotype diagnostic results against expectations

We use PhenotypeR to help assess the research readiness of a set of study cohorts. To help make such assessments it can help to have an explicit set of expectations to compare our results. For example, is the age of our study cohort similar to what would be expected? Is the proportion of the cohort that is male vs female similar to what would be expected based on what we know about the phenotype of interest?

### Custom expectations

We can define a set of custom expectations. So that we can visualise these easily using the `[tableCohortExpectations()](../reference/tableCohortExpectations.html)` function, we will create a tibble with the following columns: name (cohort name), estimate (the estimate of interest), value (our expectation on the value we should see in our results). As an example, say we have one cohort called “knee_osteoarthritis” and another called “knee_replacement”. We could create expectations about median age of the cohort and the proportion that is male like so.
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    
    knee_oa <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(cohort_name = "knee_osteoarthritis",
                      estimate = [c](https://rdrr.io/r/base/c.html)("Median age", "Proportion male"),
                      value = [c](https://rdrr.io/r/base/c.html)("60 to 65", "45%"),
                      source = "Clinician")
    knee_replacement <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(cohort_name = "knee_replacement",
                               estimate = [c](https://rdrr.io/r/base/c.html)("Median age", "Proportion male"),
                               value = [c](https://rdrr.io/r/base/c.html)("65 to 70", "50%"),
                               source = "Clinician")
    
    expectations <- [bind_rows](https://dplyr.tidyverse.org/reference/bind_rows.html)(knee_oa, knee_replacement)

Now we have our structured expectaitions, we can quickly create a summary of them. We’ll see in the next vignette how we can then also include them in our shiny app.
    
    
    [tableCohortExpectations](../reference/tableCohortExpectations.html)(expectations)

### LLM based expectations via ellmer

The custom expectations created above might be based on our (or a friendly colleagues’) clinical knowledge. This though will have required access to the requisite clinical knowledge and, especially if we have many cohorts and/ or start considering the many different estimates that are generated, will have been rather time-consuming.

To speed up the process we can use an LLM to help us generate our expectations. We could use this to create a custom set like above. But PhenotypeR also provides the `[getCohortExpectations()](../reference/getCohortExpectations.html)` which will generate a set of expectations using an LLM available via the ellmer R package.

Here for example we’ll use Google Gemini to populate our expectations. Notice that you may need first to create a Gemini API to run the example. You can do that following this link: <https://aistudio.google.com/app/apikey>.

And adding the API in your R environment:
    
    
    usethis::[edit_r_environ](https://usethis.r-lib.org/reference/edit.html)()
    
    # Add your API in your R environment:
    GEMINI_API_KEY = "your API"
    
    # Restrart R
    
    
    [library](https://rdrr.io/r/base/library.html)([ellmer](https://ellmer.tidyverse.org))
    
    chat <- [chat_google_gemini](https://ellmer.tidyverse.org/reference/chat_google_gemini.html)()
    
    [getCohortExpectations](../reference/getCohortExpectations.html)(chat = chat, 
                          phenotypes = [c](https://rdrr.io/r/base/c.html)("ankle sprain", "prostate cancer", "morphine")) |> 
      [tableCohortExpectations](../reference/tableCohortExpectations.html)()

Instead of passing our cohort names, we could instead pass our results set from `[phenotypeDiagnostics()](../reference/phenotypeDiagnostics.html)` instead. In this case we’ll automatically get expectations for each of the study cohorts in our results.
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
        con = con, cdmSchema = "main", writeSchema = "main", cdmName = "Eunomia"
      )
    
    codes <- [list](https://rdrr.io/r/base/list.html)("ankle_sprain" = 81151,
                  "prostate_cancer" = 4163261,
                  "morphine" = [c](https://rdrr.io/r/base/c.html)(1110410L, 35605858L, 40169988L))
    
    cdm$my_cohort <- [conceptCohort](https://ohdsi.github.io/CohortConstructor/reference/conceptCohort.html)(cdm = cdm,
                                     conceptSet = codes,
                                     exit = "event_end_date",
                                     name = "my_cohort")
    
    diag_results <- [phenotypeDiagnostics](../reference/phenotypeDiagnostics.html)(cdm$my_cohort)
    
    [getCohortExpectations](../reference/getCohortExpectations.html)(chat = chat, 
                          phenotypes = diag_results) |> 
      [tableCohortExpectations](../reference/tableCohortExpectations.html)()

It is important to note the importance of a descriptive cohort name. These are the names passed to the LLM and so the more informative the name, the better we can expect the LLM to do.

It should also go without saying that we should not treat the output of the LLM as the unequivocal truth. While LLM expectations may well prove an important starting point, clinical judgement and knowledge of the data source at hand will still be vital in appropriately interpretting our results.

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
