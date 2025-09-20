# Content from https://ohdsi.github.io/CohortConstructor/


---

## Content from https://ohdsi.github.io/CohortConstructor/

Skip to contents

[CohortConstructor](index.html) 0.5.0

  * [Reference](reference/index.html)
  * Articles
    * [Introduction](articles/a00_introduction.html)
    * [Building base cohorts](articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](articles/a07_filter_cohorts.html)
    * [Splitting cohorts](articles/a08_split_cohorts.html)
    * [Combining Cohorts](articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](articles/a11_benchmark.html)
    * [Behind the scenes](articles/a12_behind_the_scenes.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](logo.png)

# CohortConstructor 

The goal of CohortConstructor is to support the creation and manipulation of study cohorts in data mapped to the OMOP CDM.

## Installation

The package can be installed from CRAN:
    
    
    [install.packages](https://rdrr.io/r/utils/install.packages.html)("CohortConstructor")

Or you can install the development version of the package from GitHub:
    
    
    # install.packages("devtools")
    devtools::install_github("ohdsi/CohortConstructor")

## Creating and manipulating cohorts

To illustrate the functionality provided by CohortConstructor let’s create a cohort of people with a fracture using the Eunomia dataset. We’ll first load required packages and create a cdm reference for the data.
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", 
                        writeSchema = [c](https://rdrr.io/r/base/c.html)(prefix = "my_study_", schema = "main"))
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of Synthea ────────────────────────────────────
    #> • omop tables: person, observation_period, visit_occurrence, visit_detail,
    #> condition_occurrence, drug_exposure, procedure_occurrence, device_exposure,
    #> measurement, observation, death, note, note_nlp, specimen, fact_relationship,
    #> location, care_site, provider, payer_plan_period, cost, drug_era, dose_era,
    #> condition_era, metadata, cdm_source, concept, vocabulary, domain,
    #> concept_class, concept_relationship, relationship, concept_synonym,
    #> concept_ancestor, source_to_concept_map, drug_strength
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -

### Generating concept-based fracture cohorts

We will first need to identify codes that could be used to represent fractures of interest. To find these we’ll use the CodelistGenerator package (note, we will just find a few codes because we are using synthetic data with a subset of the full vocabularies).
    
    
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    
    hip_fx_codes <- [getCandidateCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getCandidateCodes.html)(cdm, "hip fracture")
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Adding descendants
    #> Search completed. Finishing up.
    #> ✔ 1 candidate concept identified
    #> 
    #> Time taken: 0 minutes and 0 seconds
    forearm_fx_codes <- [getCandidateCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getCandidateCodes.html)(cdm, "forearm fracture")
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Adding descendants
    #> Search completed. Finishing up.
    #> ✔ 1 candidate concept identified
    #> 
    #> Time taken: 0 minutes and 0 seconds
    
    fx_codes <- [newCodelist](https://darwin-eu.github.io/omopgenerics/reference/newCodelist.html)([list](https://rdrr.io/r/base/list.html)("hip_fracture" = hip_fx_codes$concept_id,
                                 "forearm_fracture"= forearm_fx_codes$concept_id))
    fx_codes
    #> 
    #> ── 2 codelists ─────────────────────────────────────────────────────────────────
    #> 
    #> - forearm_fracture (1 codes)
    #> - hip_fracture (1 codes)

Now we can quickly create our cohorts. For this we only need to provide the codes we have defined and we will get a cohort back, where we start by setting cohort exit as the same day as event start (the date of the fracture).
    
    
    cdm$fractures <- cdm |> 
      [conceptCohort](reference/conceptCohort.html)(conceptSet = fx_codes, 
                    exit = "event_start_date", 
                    name = "fractures")

After creating our initial cohort we will update it so that exit is set at up to 180 days after start (so long as individuals’ observation end date is on or after this - if not, exit will be at observation period end).
    
    
    cdm$fractures <- cdm$fractures |> 
      [padCohortEnd](reference/padCohortEnd.html)(days = 180)

We can see that our starting cohorts, before we add any additional restrictions, have the following associated settings, counts, and attrition.
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$fractures) |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 2
    #> Columns: 4
    #> $ cohort_definition_id <int> 1, 2
    #> $ cohort_name          <chr> "forearm_fracture", "hip_fracture"
    #> $ cdm_version          <chr> "5.3", "5.3"
    #> $ vocabulary_version   <chr> "v5.0 18-JAN-19", "v5.0 18-JAN-19"
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$fractures) |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 2
    #> Columns: 3
    #> $ cohort_definition_id <int> 1, 2
    #> $ number_records       <int> 569, 138
    #> $ number_subjects      <int> 510, 132
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$fractures) |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 10
    #> Columns: 7
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 2, 2, 2, 2, 2
    #> $ number_records       <int> 569, 569, 569, 569, 569, 138, 138, 138, 138, 138
    #> $ number_subjects      <int> 510, 510, 510, 510, 510, 132, 132, 132, 132, 132
    #> $ reason_id            <int> 1, 2, 3, 4, 5, 1, 2, 3, 4, 5
    #> $ reason               <chr> "Initial qualifying events", "Record start <= rec…
    #> $ excluded_records     <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    #> $ excluded_subjects    <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

### Create an overall fracture cohort

So far we have created three separate fracture cohorts. Let’s say we also want a cohort of people with any of the fractures. We could union our three cohorts to create this overall cohort like so:
    
    
    cdm$fractures <- [unionCohorts](reference/unionCohorts.html)(cdm$fractures,
                                  cohortName = "any_fracture", 
                                  keepOriginalCohorts = TRUE,
                                  name ="fractures")
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$fractures)
    #> # A tibble: 3 × 5
    #>   cohort_definition_id cohort_name      cdm_version vocabulary_version   gap
    #>                  <int> <chr>            <chr>       <chr>              <dbl>
    #> 1                    1 forearm_fracture 5.3         v5.0 18-JAN-19        NA
    #> 2                    2 hip_fracture     5.3         v5.0 18-JAN-19        NA
    #> 3                    3 any_fracture     <NA>        <NA>                   0
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$fractures)
    #> # A tibble: 3 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1            569             510
    #> 2                    2            138             132
    #> 3                    3            707             611

### Require in date range

Once we have created our base fracture cohort, we can then start applying additional cohort requirements. For example, first we can require that individuals’ cohort start date fall within a certain date range.
    
    
    cdm$fractures <- cdm$fractures |> 
      [requireInDateRange](reference/requireInDateRange.html)(dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2000-01-01", "2020-01-01")))

Now that we’ve applied this date restriction, we can see that our cohort attributes have been updated
    
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$fractures) |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 3
    #> Columns: 3
    #> $ cohort_definition_id <int> 1, 2, 3
    #> $ number_records       <int> 152, 62, 214
    #> $ number_subjects      <int> 143, 60, 196
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$fractures) |> 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(reason == "cohort_start_date between 2000-01-01 & 2020-01-01") |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 0
    #> Columns: 7
    #> $ cohort_definition_id <int> 
    #> $ number_records       <int> 
    #> $ number_subjects      <int> 
    #> $ reason_id            <int> 
    #> $ reason               <chr> 
    #> $ excluded_records     <int> 
    #> $ excluded_subjects    <int>

### Applying demographic requirements

We can also add restrictions on patient characteristics such as age (on cohort start date by default) and sex.
    
    
    cdm$fractures <- cdm$fractures |> 
      [requireDemographics](reference/requireDemographics.html)(ageRange = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(40, 65)),
                          sex = "Female")

Again we can see how many individuals we’ve lost after applying these criteria.
    
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$fractures) |> 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(reason == "Age requirement: 40 to 65") |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 3
    #> Columns: 7
    #> $ cohort_definition_id <int> 1, 2, 3
    #> $ number_records       <int> 64, 22, 86
    #> $ number_subjects      <int> 62, 22, 83
    #> $ reason_id            <int> 8, 8, 4
    #> $ reason               <chr> "Age requirement: 40 to 65", "Age requirement: 40…
    #> $ excluded_records     <int> 88, 40, 128
    #> $ excluded_subjects    <int> 81, 38, 113
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$fractures) |> 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(reason == "Sex requirement: Female") |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 3
    #> Columns: 7
    #> $ cohort_definition_id <int> 1, 2, 3
    #> $ number_records       <int> 37, 12, 49
    #> $ number_subjects      <int> 36, 12, 48
    #> $ reason_id            <int> 9, 9, 5
    #> $ reason               <chr> "Sex requirement: Female", "Sex requirement: Fema…
    #> $ excluded_records     <int> 27, 10, 37
    #> $ excluded_subjects    <int> 26, 10, 35

### Require presence in another cohort

We can also require that individuals are (or are not) in another cohort over some window. Here for example we require that study participants are in a GI bleed cohort any time prior up to their entry in the fractures cohort.
    
    
    cdm$gibleed <- cdm |> 
      [conceptCohort](reference/conceptCohort.html)(conceptSet = [list](https://rdrr.io/r/base/list.html)("gibleed" = 192671L),
      name = "gibleed")
    
    cdm$fractures <- cdm$fractures |> 
      [requireCohortIntersect](reference/requireCohortIntersect.html)(targetCohortTable = "gibleed",
                             intersections = 0,
                             window = [c](https://rdrr.io/r/base/c.html)(-Inf, 0))
    
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$fractures) |> 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(reason == "Not in cohort gibleed between -Inf & 0 days relative to cohort_start_date") |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 3
    #> Columns: 7
    #> $ cohort_definition_id <int> 1, 2, 3
    #> $ number_records       <int> 30, 10, 40
    #> $ number_subjects      <int> 30, 10, 40
    #> $ reason_id            <int> 12, 12, 8
    #> $ reason               <chr> "Not in cohort gibleed between -Inf & 0 days rela…
    #> $ excluded_records     <int> 7, 2, 9
    #> $ excluded_subjects    <int> 6, 2, 8
    
    
    [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)

### More information

CohortConstructor provides much more functionality for creating and manipulating cohorts. See the package vignettes for more details.

## Links

  * [View on CRAN](https://cloud.r-project.org/package=CohortConstructor)
  * [Browse source code](https://github.com/OHDSI/CohortConstructor/)



## License

  * [Full license](LICENSE.html)
  * Apache License (>= 2)



## Citation

  * [Citing CohortConstructor](authors.html#citation)



## Developers

  * Edward Burn   
Author, maintainer  [](https://orcid.org/0000-0002-9286-1128)
  * Marti Catala   
Author  [](https://orcid.org/0000-0003-3308-9905)
  * Nuria Mercade-Besora   
Author  [](https://orcid.org/0009-0006-7948-3747)
  * Marta Alcalde-Herraiz   
Author  [](https://orcid.org/0009-0002-4405-1814)
  * Mike Du   
Author  [](https://orcid.org/0000-0002-9517-8834)
  * Yuchen Guo   
Author  [](https://orcid.org/0000-0002-0847-4855)
  * Xihang Chen   
Author  [](https://orcid.org/0009-0001-8112-8959)
  * Kim Lopez-Guell   
Author  [](https://orcid.org/0000-0002-8462-8668)
  * Elin Rowlands   
Author  [](https://orcid.org/0009-0005-5166-0417)



## Dev status

  * [![CRAN status](https://www.r-pkg.org/badges/version/CohortConstructor)](https://CRAN.R-project.org/package=CohortConstructor)
  * [![R-CMD-check](https://github.com/OHDSI/CohortConstructor/workflows/R-CMD-check/badge.svg)](https://github.com/OHDSI/CohortConstructor/actions)
  * [![Codecov test coverage](https://codecov.io/gh/OHDSI/CohortConstructor/branch/main/graph/badge.svg)](https://app.codecov.io/gh/OHDSI/CohortConstructor?branch=main)
  * [![Lifecycle:Experimental](https://img.shields.io/badge/Lifecycle-Experimental-339999)](https://lifecycle.r-lib.org/articles/stages.html#experimental)



Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/index.html

Skip to contents

[CohortConstructor](index.html) 0.5.0

  * [Reference](reference/index.html)
  * Articles
    * [Introduction](articles/a00_introduction.html)
    * [Building base cohorts](articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](articles/a07_filter_cohorts.html)
    * [Splitting cohorts](articles/a08_split_cohorts.html)
    * [Combining Cohorts](articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](articles/a11_benchmark.html)
    * [Behind the scenes](articles/a12_behind_the_scenes.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](logo.png)

# CohortConstructor 

The goal of CohortConstructor is to support the creation and manipulation of study cohorts in data mapped to the OMOP CDM.

## Installation

The package can be installed from CRAN:
    
    
    [install.packages](https://rdrr.io/r/utils/install.packages.html)("CohortConstructor")

Or you can install the development version of the package from GitHub:
    
    
    # install.packages("devtools")
    devtools::install_github("ohdsi/CohortConstructor")

## Creating and manipulating cohorts

To illustrate the functionality provided by CohortConstructor let’s create a cohort of people with a fracture using the Eunomia dataset. We’ll first load required packages and create a cdm reference for the data.
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", 
                        writeSchema = [c](https://rdrr.io/r/base/c.html)(prefix = "my_study_", schema = "main"))
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of Synthea ────────────────────────────────────
    #> • omop tables: person, observation_period, visit_occurrence, visit_detail,
    #> condition_occurrence, drug_exposure, procedure_occurrence, device_exposure,
    #> measurement, observation, death, note, note_nlp, specimen, fact_relationship,
    #> location, care_site, provider, payer_plan_period, cost, drug_era, dose_era,
    #> condition_era, metadata, cdm_source, concept, vocabulary, domain,
    #> concept_class, concept_relationship, relationship, concept_synonym,
    #> concept_ancestor, source_to_concept_map, drug_strength
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -

### Generating concept-based fracture cohorts

We will first need to identify codes that could be used to represent fractures of interest. To find these we’ll use the CodelistGenerator package (note, we will just find a few codes because we are using synthetic data with a subset of the full vocabularies).
    
    
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    
    hip_fx_codes <- [getCandidateCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getCandidateCodes.html)(cdm, "hip fracture")
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Adding descendants
    #> Search completed. Finishing up.
    #> ✔ 1 candidate concept identified
    #> 
    #> Time taken: 0 minutes and 0 seconds
    forearm_fx_codes <- [getCandidateCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getCandidateCodes.html)(cdm, "forearm fracture")
    #> Limiting to domains of interest
    #> Getting concepts to include
    #> Adding descendants
    #> Search completed. Finishing up.
    #> ✔ 1 candidate concept identified
    #> 
    #> Time taken: 0 minutes and 0 seconds
    
    fx_codes <- [newCodelist](https://darwin-eu.github.io/omopgenerics/reference/newCodelist.html)([list](https://rdrr.io/r/base/list.html)("hip_fracture" = hip_fx_codes$concept_id,
                                 "forearm_fracture"= forearm_fx_codes$concept_id))
    fx_codes
    #> 
    #> ── 2 codelists ─────────────────────────────────────────────────────────────────
    #> 
    #> - forearm_fracture (1 codes)
    #> - hip_fracture (1 codes)

Now we can quickly create our cohorts. For this we only need to provide the codes we have defined and we will get a cohort back, where we start by setting cohort exit as the same day as event start (the date of the fracture).
    
    
    cdm$fractures <- cdm |> 
      [conceptCohort](reference/conceptCohort.html)(conceptSet = fx_codes, 
                    exit = "event_start_date", 
                    name = "fractures")

After creating our initial cohort we will update it so that exit is set at up to 180 days after start (so long as individuals’ observation end date is on or after this - if not, exit will be at observation period end).
    
    
    cdm$fractures <- cdm$fractures |> 
      [padCohortEnd](reference/padCohortEnd.html)(days = 180)

We can see that our starting cohorts, before we add any additional restrictions, have the following associated settings, counts, and attrition.
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$fractures) |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 2
    #> Columns: 4
    #> $ cohort_definition_id <int> 1, 2
    #> $ cohort_name          <chr> "forearm_fracture", "hip_fracture"
    #> $ cdm_version          <chr> "5.3", "5.3"
    #> $ vocabulary_version   <chr> "v5.0 18-JAN-19", "v5.0 18-JAN-19"
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$fractures) |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 2
    #> Columns: 3
    #> $ cohort_definition_id <int> 1, 2
    #> $ number_records       <int> 569, 138
    #> $ number_subjects      <int> 510, 132
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$fractures) |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 10
    #> Columns: 7
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 2, 2, 2, 2, 2
    #> $ number_records       <int> 569, 569, 569, 569, 569, 138, 138, 138, 138, 138
    #> $ number_subjects      <int> 510, 510, 510, 510, 510, 132, 132, 132, 132, 132
    #> $ reason_id            <int> 1, 2, 3, 4, 5, 1, 2, 3, 4, 5
    #> $ reason               <chr> "Initial qualifying events", "Record start <= rec…
    #> $ excluded_records     <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    #> $ excluded_subjects    <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

### Create an overall fracture cohort

So far we have created three separate fracture cohorts. Let’s say we also want a cohort of people with any of the fractures. We could union our three cohorts to create this overall cohort like so:
    
    
    cdm$fractures <- [unionCohorts](reference/unionCohorts.html)(cdm$fractures,
                                  cohortName = "any_fracture", 
                                  keepOriginalCohorts = TRUE,
                                  name ="fractures")
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$fractures)
    #> # A tibble: 3 × 5
    #>   cohort_definition_id cohort_name      cdm_version vocabulary_version   gap
    #>                  <int> <chr>            <chr>       <chr>              <dbl>
    #> 1                    1 forearm_fracture 5.3         v5.0 18-JAN-19        NA
    #> 2                    2 hip_fracture     5.3         v5.0 18-JAN-19        NA
    #> 3                    3 any_fracture     <NA>        <NA>                   0
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$fractures)
    #> # A tibble: 3 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1            569             510
    #> 2                    2            138             132
    #> 3                    3            707             611

### Require in date range

Once we have created our base fracture cohort, we can then start applying additional cohort requirements. For example, first we can require that individuals’ cohort start date fall within a certain date range.
    
    
    cdm$fractures <- cdm$fractures |> 
      [requireInDateRange](reference/requireInDateRange.html)(dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2000-01-01", "2020-01-01")))

Now that we’ve applied this date restriction, we can see that our cohort attributes have been updated
    
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$fractures) |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 3
    #> Columns: 3
    #> $ cohort_definition_id <int> 1, 2, 3
    #> $ number_records       <int> 152, 62, 214
    #> $ number_subjects      <int> 143, 60, 196
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$fractures) |> 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(reason == "cohort_start_date between 2000-01-01 & 2020-01-01") |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 0
    #> Columns: 7
    #> $ cohort_definition_id <int> 
    #> $ number_records       <int> 
    #> $ number_subjects      <int> 
    #> $ reason_id            <int> 
    #> $ reason               <chr> 
    #> $ excluded_records     <int> 
    #> $ excluded_subjects    <int>

### Applying demographic requirements

We can also add restrictions on patient characteristics such as age (on cohort start date by default) and sex.
    
    
    cdm$fractures <- cdm$fractures |> 
      [requireDemographics](reference/requireDemographics.html)(ageRange = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(40, 65)),
                          sex = "Female")

Again we can see how many individuals we’ve lost after applying these criteria.
    
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$fractures) |> 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(reason == "Age requirement: 40 to 65") |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 3
    #> Columns: 7
    #> $ cohort_definition_id <int> 1, 2, 3
    #> $ number_records       <int> 64, 22, 86
    #> $ number_subjects      <int> 62, 22, 83
    #> $ reason_id            <int> 8, 8, 4
    #> $ reason               <chr> "Age requirement: 40 to 65", "Age requirement: 40…
    #> $ excluded_records     <int> 88, 40, 128
    #> $ excluded_subjects    <int> 81, 38, 113
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$fractures) |> 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(reason == "Sex requirement: Female") |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 3
    #> Columns: 7
    #> $ cohort_definition_id <int> 1, 2, 3
    #> $ number_records       <int> 37, 12, 49
    #> $ number_subjects      <int> 36, 12, 48
    #> $ reason_id            <int> 9, 9, 5
    #> $ reason               <chr> "Sex requirement: Female", "Sex requirement: Fema…
    #> $ excluded_records     <int> 27, 10, 37
    #> $ excluded_subjects    <int> 26, 10, 35

### Require presence in another cohort

We can also require that individuals are (or are not) in another cohort over some window. Here for example we require that study participants are in a GI bleed cohort any time prior up to their entry in the fractures cohort.
    
    
    cdm$gibleed <- cdm |> 
      [conceptCohort](reference/conceptCohort.html)(conceptSet = [list](https://rdrr.io/r/base/list.html)("gibleed" = 192671L),
      name = "gibleed")
    
    cdm$fractures <- cdm$fractures |> 
      [requireCohortIntersect](reference/requireCohortIntersect.html)(targetCohortTable = "gibleed",
                             intersections = 0,
                             window = [c](https://rdrr.io/r/base/c.html)(-Inf, 0))
    
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$fractures) |> 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(reason == "Not in cohort gibleed between -Inf & 0 days relative to cohort_start_date") |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 3
    #> Columns: 7
    #> $ cohort_definition_id <int> 1, 2, 3
    #> $ number_records       <int> 30, 10, 40
    #> $ number_subjects      <int> 30, 10, 40
    #> $ reason_id            <int> 12, 12, 8
    #> $ reason               <chr> "Not in cohort gibleed between -Inf & 0 days rela…
    #> $ excluded_records     <int> 7, 2, 9
    #> $ excluded_subjects    <int> 6, 2, 8
    
    
    [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)

### More information

CohortConstructor provides much more functionality for creating and manipulating cohorts. See the package vignettes for more details.

## Links

  * [View on CRAN](https://cloud.r-project.org/package=CohortConstructor)
  * [Browse source code](https://github.com/OHDSI/CohortConstructor/)



## License

  * [Full license](LICENSE.html)
  * Apache License (>= 2)



## Citation

  * [Citing CohortConstructor](authors.html#citation)



## Developers

  * Edward Burn   
Author, maintainer  [](https://orcid.org/0000-0002-9286-1128)
  * Marti Catala   
Author  [](https://orcid.org/0000-0003-3308-9905)
  * Nuria Mercade-Besora   
Author  [](https://orcid.org/0009-0006-7948-3747)
  * Marta Alcalde-Herraiz   
Author  [](https://orcid.org/0009-0002-4405-1814)
  * Mike Du   
Author  [](https://orcid.org/0000-0002-9517-8834)
  * Yuchen Guo   
Author  [](https://orcid.org/0000-0002-0847-4855)
  * Xihang Chen   
Author  [](https://orcid.org/0009-0001-8112-8959)
  * Kim Lopez-Guell   
Author  [](https://orcid.org/0000-0002-8462-8668)
  * Elin Rowlands   
Author  [](https://orcid.org/0009-0005-5166-0417)



## Dev status

  * [![CRAN status](https://www.r-pkg.org/badges/version/CohortConstructor)](https://CRAN.R-project.org/package=CohortConstructor)
  * [![R-CMD-check](https://github.com/OHDSI/CohortConstructor/workflows/R-CMD-check/badge.svg)](https://github.com/OHDSI/CohortConstructor/actions)
  * [![Codecov test coverage](https://codecov.io/gh/OHDSI/CohortConstructor/branch/main/graph/badge.svg)](https://app.codecov.io/gh/OHDSI/CohortConstructor?branch=main)
  * [![Lifecycle:Experimental](https://img.shields.io/badge/Lifecycle-Experimental-339999)](https://lifecycle.r-lib.org/articles/stages.html#experimental)



Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/index.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Package index

### Build base cohorts

`[conceptCohort()](conceptCohort.html)`
    Create cohorts based on a concept set

`[deathCohort()](deathCohort.html)`
    Create cohort based on the death table

`[demographicsCohort()](demographicsCohort.html)`
    Create cohorts based on patient demographics

`[measurementCohort()](measurementCohort.html)`
    Create measurement-based cohorts

### Apply cohort table related requirements

`[requireMinCohortCount()](requireMinCohortCount.html)`
    Filter cohorts to keep only records for those with a minimum amount of subjects

`[requireInDateRange()](requireInDateRange.html)`
    Require that an index date is within a date range

`[requireDuration()](requireDuration.html)`
    Require cohort entries last for a certain number of days

`[requireIsFirstEntry()](requireIsFirstEntry.html)`
    Restrict cohort to first entry

`[requireIsLastEntry()](requireIsLastEntry.html)`
    Restrict cohort to last entry per person

`[requireIsEntry()](requireIsEntry.html)`
    Restrict cohort to specific entry

### Impose singular demographic requirements on existing cohorts

`[requireAge()](requireAge.html)`
    Restrict cohort on age

`[requireSex()](requireSex.html)`
    Restrict cohort on sex

`[requirePriorObservation()](requirePriorObservation.html)`
    Restrict cohort on prior observation

`[requireFutureObservation()](requireFutureObservation.html)`
    Restrict cohort on future observation

### Impose multiple demographic requirements on existing cohorts

`[requireDemographics()](requireDemographics.html)`
    Restrict cohort on patient demographics

### Impose requirements of presence or absence in other cohorts, concept sets, or table

`[requireCohortIntersect()](requireCohortIntersect.html)`
    Require cohort subjects are present (or absence) in another cohort

`[requireConceptIntersect()](requireConceptIntersect.html)`
    Require cohort subjects to have (or not have) events of a concept list

`[requireTableIntersect()](requireTableIntersect.html)`
    Require cohort subjects are present in another clinical table

### Update cohort start and end dates

`[entryAtFirstDate()](entryAtFirstDate.html)`
    Update cohort start date to be the first date from of a set of column dates

`[entryAtLastDate()](entryAtLastDate.html)`
    Set cohort start date to the last of a set of column dates

`[exitAtDeath()](exitAtDeath.html)`
    Set cohort end date to death date

`[exitAtFirstDate()](exitAtFirstDate.html)`
    Set cohort end date to the first of a set of column dates

`[exitAtLastDate()](exitAtLastDate.html)`
    Set cohort end date to the last of a set of column dates

`[exitAtObservationEnd()](exitAtObservationEnd.html)`
    Set cohort end date to end of observation

`[padCohortDate()](padCohortDate.html)`
    Set cohort start or cohort end

`[padCohortEnd()](padCohortEnd.html)`
    Add days to cohort end

`[padCohortStart()](padCohortStart.html)`
    Add days to cohort start

`[trimDemographics()](trimDemographics.html)`
    Trim cohort on patient demographics

`[trimToDateRange()](trimToDateRange.html)`
    Trim cohort dates to be within a date range

### Concatanate cohort entries

`[collapseCohorts()](collapseCohorts.html)`
    Collapse cohort entries using a certain gap to concatenate records.

### Filter cohorts

`[subsetCohorts()](subsetCohorts.html)`
    Generate a cohort table keeping a subset of cohorts.

`[sampleCohorts()](sampleCohorts.html)`
    Sample a cohort table for a given number of individuals.

### Copy cohorts

`[copyCohorts()](copyCohorts.html)`
    Copy a cohort table

### Split cohorts

`[yearCohorts()](yearCohorts.html)`
    Generate a new cohort table restricting cohort entries to certain years

`[stratifyCohorts()](stratifyCohorts.html)`
    Create a new cohort table from stratifying an existing one

### Combine cohorts

`[intersectCohorts()](intersectCohorts.html)`
    Generate a combination cohort set between the intersection of different cohorts.

`[unionCohorts()](unionCohorts.html)`
    Generate cohort from the union of different cohorts

### Match cohorts

`[matchCohorts()](matchCohorts.html)`
    Generate a new cohort matched cohort

### Mock data

`[mockCohortConstructor()](mockCohortConstructor.html)`
    Function to create a mock cdm reference for CohortConstructor

### Package benchmark

`[benchmarkCohortConstructor()](benchmarkCohortConstructor.html)`
    Run benchmark of CohortConstructor package

`[benchmarkData](benchmarkData.html)`
    Benchmarking results

### Utility functions

`[renameCohort()](renameCohort.html)`
    Utility function to change the name of a cohort.

`[addCohortTableIndex()](addCohortTableIndex.html)`
    Add an index to a cohort table

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/articles/a00_introduction.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Introduction

Source: [`vignettes/a00_introduction.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a00_introduction.Rmd)

`a00_introduction.Rmd`

## Introduction

The CohortConstructor package is designed to support cohort building pipelines. When using the package the general workflow is to first build a set of base cohorts and then subsequently apply inclusion criteria to derive the final study cohorts of interest. Base cohorts are built by domain (rather than by cohort definition) and from one base cohort many study cohorts can be derived.

## Building a cohort set by domain/ clinical table

Let´s say we want to build 5 cohorts with 3 (asthma, copd, and diabetes) defined based on concepts seen in the condition occurrence table while the other 2 (acetaminophen and warfarin) are based on concepts recorded in the drug exposure table. We can build these cohorts independently, one after the other. However, this approach will mean repeating 3 joins to the condition occurrence tables and 2 joins to the drug exposure table (with the concepts in the concept sets). To make this less computationally expensive, we could instead create the cohorts by domain. In this case we will instead make one join with the condition occurrence table and one to the drug exposure (using all the concept sets together).

![](images/cohort_by_domain.png)

## Deriving study cohorts from base cohorts

When making study cohorts we often have a concept sets to define a clinical event along with various study-specific inclusion criteria, for example criteria around an amount of prior observation and age. Often we may have sensitivity analysis where the concept set remains the same but these inclusion criteria change. In such situations we can make cohorts one-by-one. However, this can lead to duplication as we can see in the example below we identify asthma records multiple times. An alternative approach is to build a base cohort, in this case based on asthma records, after which we derive multiple cohorts from this where the different inclusion criteria are each applied.

![](images/combined_cohort.png)

## Considerations when building cohorts

CohortConstructor provides a means of building cohorts via a pipeline, with cohorts created through the application of a sequence of functions. It is important to note that the order of the sequence will often have important implications. In the example below we have just one individual who has three recorded diagnoses of asthma. One diagnosis was in 2008 and two in 2009, with only the last coming after the individual´s 18th birthday. Below three cohort pipelines are shown with restrictions around calendar dates, age, and that the record was the first. Only in cohort pipeline A, however, would the individual be included in the final cohort, with their third diagnosis used for cohort start. In pipeline B and C the individual would have been excluded.

![](images/pipeline.png)

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/articles/a01_building_base_cohorts.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Building base cohorts

Source: [`vignettes/a01_building_base_cohorts.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a01_building_base_cohorts.Rmd)

`a01_building_base_cohorts.Rmd`

## Introduction

Let’s first create a cdm reference to the Eunomia synthetic data.
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", writeSchema = "main", 
                      writePrefix = "my_study_")

## Concept based cohort creation

A way of defining base cohorts is to identify clinical records with codes from some pre-specified concept list. Here for example we’ll first find codes for diclofenac and acetaminophen. We use the `[getDrugIngredientCodes()](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)` function from the package **CodelistGenerator** to obtain the codes for these drugs.
    
    
    drug_codes <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm, 
                                         name = [c](https://rdrr.io/r/base/c.html)("acetaminophen",
                                                  "amoxicillin", 
                                                  "diclofenac", 
                                                  "simvastatin",
                                                  "warfarin"))
    
    drug_codes
    #> 
    #> - 11289_warfarin (2 codes)
    #> - 161_acetaminophen (7 codes)
    #> - 3355_diclofenac (1 codes)
    #> - 36567_simvastatin (2 codes)
    #> - 723_amoxicillin (4 codes)

Now we have our codes of interest, we’ll make cohorts for each of these where cohort exit is defined as the event start date (which for these will be their drug exposure end date).
    
    
    cdm$drugs <- [conceptCohort](../reference/conceptCohort.html)(cdm, 
                               conceptSet = drug_codes,
                               exit = "event_end_date",
                               name = "drugs")
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$drugs)
    #> # A tibble: 5 × 4
    #>   cohort_definition_id cohort_name       cdm_version vocabulary_version
    #>                  <int> <chr>             <chr>       <chr>             
    #> 1                    1 11289_warfarin    5.3         v5.0 18-JAN-19    
    #> 2                    2 161_acetaminophen 5.3         v5.0 18-JAN-19    
    #> 3                    3 3355_diclofenac   5.3         v5.0 18-JAN-19    
    #> 4                    4 36567_simvastatin 5.3         v5.0 18-JAN-19    
    #> 5                    5 723_amoxicillin   5.3         v5.0 18-JAN-19
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$drugs)
    #> # A tibble: 5 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1            137             137
    #> 2                    2          13908            2679
    #> 3                    3            830             830
    #> 4                    4            182             182
    #> 5                    5           4307            2130
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$drugs)
    #> # A tibble: 30 × 7
    #>    cohort_definition_id number_records number_subjects reason_id reason         
    #>                   <int>          <int>           <int>     <int> <chr>          
    #>  1                    1            137             137         1 Initial qualif…
    #>  2                    1            137             137         2 Record in obse…
    #>  3                    1            137             137         3 Record start <…
    #>  4                    1            137             137         4 Non-missing sex
    #>  5                    1            137             137         5 Non-missing ye…
    #>  6                    1            137             137         6 Merge overlapp…
    #>  7                    2          14205            2679         1 Initial qualif…
    #>  8                    2          14205            2679         2 Record in obse…
    #>  9                    2          14205            2679         3 Record start <…
    #> 10                    2          14205            2679         4 Non-missing sex
    #> # ℹ 20 more rows
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

This creates a cohort where individuals are defined by their exposure to the specified drugs, and their cohort duration is determined by the exposure end date.

Next, let’s create a cohort for individuals with bronchitis. We define a set of codes representing bronchitis and use the `[conceptCohort()](../reference/conceptCohort.html)` function to create the cohort. Here, the cohort exit is defined by the event start date (i.e., `event_start_date`). We set `table = "condition_occurrence"` so that the records for the provided concepts will be searched only in the _condition_occurrence_ table. We then set `subsetCohort = "drugs"` to restrict the cohort creation to individuals already in the `drugs` cohort. Additionally, we use `subsetCohortId = 1` to include only subjects from the cohort 1 (which corresponds to individuals who have been exposed to warfarin).
    
    
    
    bronchitis_codes <- [list](https://rdrr.io/r/base/list.html)(bronchitis = [c](https://rdrr.io/r/base/c.html)(260139, 256451, 4232302))
    
    cdm$bronchitis <- [conceptCohort](../reference/conceptCohort.html)(cdm, 
                               conceptSet = bronchitis_codes,
                               exit = "event_start_date",
                               name = "bronchitis",
                               table = "condition_occurrence", 
                               subsetCohort = "drugs", 
                               subsetCohortId = 1
                               )
    
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$bronchitis)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1            533             130
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$bronchitis)
    #> # A tibble: 6 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1            533             130         1 Initial qualify…
    #> 2                    1            533             130         2 Record in obser…
    #> 3                    1            533             130         3 Record start <=…
    #> 4                    1            533             130         4 Non-missing sex 
    #> 5                    1            533             130         5 Non-missing yea…
    #> 6                    1            533             130         6 Merge overlappi…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

When some records in the cohort overlap, the cohort start date will be set to the earliest start date. If we set `overlap = "merge"`, the cohort end date will be set to the latest end date of the overlapping records.
    
    
    cdm$drugs_merge <- [conceptCohort](../reference/conceptCohort.html)(cdm, 
                               conceptSet = drug_codes,
                               overlap = "merge",
                               name = "drugs_merge")
    
    cdm$drugs_merge |>
      [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)()
    #> # A tibble: 30 × 7
    #>    cohort_definition_id number_records number_subjects reason_id reason         
    #>                   <int>          <int>           <int>     <int> <chr>          
    #>  1                    1            137             137         1 Initial qualif…
    #>  2                    1            137             137         2 Record in obse…
    #>  3                    1            137             137         3 Record start <…
    #>  4                    1            137             137         4 Non-missing sex
    #>  5                    1            137             137         5 Non-missing ye…
    #>  6                    1            137             137         6 Merge overlapp…
    #>  7                    2          14205            2679         1 Initial qualif…
    #>  8                    2          14205            2679         2 Record in obse…
    #>  9                    2          14205            2679         3 Record start <…
    #> 10                    2          14205            2679         4 Non-missing sex
    #> # ℹ 20 more rows
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

Alternatively, if we set `overlap = "extend"`, the cohort end date will be extended by summing the durations of each overlapping record.
    
    
    cdm$drugs_extend <- [conceptCohort](../reference/conceptCohort.html)(cdm, 
                               conceptSet = drug_codes,
                               overlap = "extend",
                               name = "drugs_extend")
    
    cdm$drugs_extend |>
      [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)()
    #> # A tibble: 50 × 7
    #>    cohort_definition_id number_records number_subjects reason_id reason         
    #>                   <int>          <int>           <int>     <int> <chr>          
    #>  1                    1            137             137         1 Initial qualif…
    #>  2                    1            137             137         2 Record in obse…
    #>  3                    1            137             137         3 Record start <…
    #>  4                    1            137             137         4 Non-missing sex
    #>  5                    1            137             137         5 Non-missing ye…
    #>  6                    1            137             137         6 Add overlappin…
    #>  7                    1            137             137         7 Record in obse…
    #>  8                    1            137             137         8 Record start <…
    #>  9                    1            137             137         9 Non-missing sex
    #> 10                    1            137             137        10 Non-missing ye…
    #> # ℹ 40 more rows
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

To create a cohort from a concept set and include records outside of the observation period, we can set `useRecordsBeforeObservation = TRUE`. If we also want to search for the given concepts in the source concept_id fields, rather than only the standard concept_id fields, we can set `useSourceFields = TRUE`.
    
    
    
    cdm$celecoxib <- [conceptCohort](../reference/conceptCohort.html)(cdm, 
                               conceptSet = [list](https://rdrr.io/r/base/list.html)(celecoxib = 44923712),
                               name = "celecoxib", 
                               useRecordsBeforeObservation = TRUE, 
                               useSourceFields = TRUE)
    cdm$celecoxib |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/RtmpRzA3TJ/file27e013b5926.duckdb]
    #> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    #> $ subject_id           <int> 1, 919, 2175, 2406, 5103, 43, 505, 1408, 2244, 25…
    #> $ cohort_start_date    <date> 1982-08-12, 2009-06-05, 2013-08-07, 1979-04-20, …
    #> $ cohort_end_date      <date> 1982-08-12, 2009-06-05, 2013-08-07, 1979-04-20, …

## Demographic based cohort creation

One base cohort we can create is based around patient demographics. Here for example we create a cohort where people enter on their 18th birthday and leave at on the day before their 66th birthday.
    
    
    cdm$working_age_cohort <- [demographicsCohort](../reference/demographicsCohort.html)(cdm = cdm, 
                                                 ageRange = [c](https://rdrr.io/r/base/c.html)(18, 65), 
                                                 name = "working_age_cohort")
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$working_age_cohort)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id cohort_name  age_range
    #>                  <int> <chr>        <chr>    
    #> 1                    1 demographics 18_65
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$working_age_cohort)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           2694            2694
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$working_age_cohort)
    #> # A tibble: 2 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1           2694            2694         1 Initial qualify…
    #> 2                    1           2694            2694         2 Age requirement…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

We can also add an additional requirement of only people of working age with sex “female”.
    
    
    cdm$female_working_age_cohort <- [demographicsCohort](../reference/demographicsCohort.html)(cdm = cdm, 
                                                 ageRange = [c](https://rdrr.io/r/base/c.html)(18, 65),
                                                 sex = "Female",
                                                 name = "female_working_age_cohort")
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$female_working_age_cohort)
    #> # A tibble: 1 × 4
    #>   cohort_definition_id cohort_name  age_range sex   
    #>                  <int> <chr>        <chr>     <chr> 
    #> 1                    1 demographics 18_65     Female
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$female_working_age_cohort)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           1373            1373
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$female_working_age_cohort)
    #> # A tibble: 3 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1           2694            2694         1 Initial qualify…
    #> 2                    1           1373            1373         2 Sex requirement…
    #> 3                    1           1373            1373         3 Age requirement…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

We can also use this function to create cohorts for different combinations of age groups and sex.
    
    
    cdm$age_sex_cohorts <- [demographicsCohort](../reference/demographicsCohort.html)(cdm = cdm, 
                                                 ageRange = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 17), [c](https://rdrr.io/r/base/c.html)(18, 65), [c](https://rdrr.io/r/base/c.html)(66,120)),
                                                 sex = [c](https://rdrr.io/r/base/c.html)("Female", "Male"),
                                                 name = "age_sex_cohorts")
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$age_sex_cohorts)
    #> # A tibble: 6 × 4
    #>   cohort_definition_id cohort_name    age_range sex   
    #>                  <int> <chr>          <chr>     <chr> 
    #> 1                    1 demographics_1 0_17      Female
    #> 2                    2 demographics_2 0_17      Male  
    #> 3                    3 demographics_3 18_65     Female
    #> 4                    4 demographics_4 18_65     Male  
    #> 5                    5 demographics_5 66_120    Female
    #> 6                    6 demographics_6 66_120    Male
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$age_sex_cohorts)
    #> # A tibble: 6 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           1373            1373
    #> 2                    2           1321            1321
    #> 3                    3           1373            1373
    #> 4                    4           1321            1321
    #> 5                    5            393             393
    #> 6                    6            378             378
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$age_sex_cohorts)
    #> # A tibble: 18 × 7
    #>    cohort_definition_id number_records number_subjects reason_id reason         
    #>                   <int>          <int>           <int>     <int> <chr>          
    #>  1                    1           2694            2694         1 Initial qualif…
    #>  2                    1           1373            1373         2 Sex requiremen…
    #>  3                    1           1373            1373         3 Age requiremen…
    #>  4                    2           2694            2694         1 Initial qualif…
    #>  5                    2           1321            1321         2 Sex requiremen…
    #>  6                    2           1321            1321         3 Age requiremen…
    #>  7                    3           2694            2694         1 Initial qualif…
    #>  8                    3           1373            1373         2 Sex requiremen…
    #>  9                    3           1373            1373         3 Age requiremen…
    #> 10                    4           2694            2694         1 Initial qualif…
    #> 11                    4           1321            1321         2 Sex requiremen…
    #> 12                    4           1321            1321         3 Age requiremen…
    #> 13                    5           2694            2694         1 Initial qualif…
    #> 14                    5           1373            1373         2 Sex requiremen…
    #> 15                    5            393             393         3 Age requiremen…
    #> 16                    6           2694            2694         1 Initial qualif…
    #> 17                    6           1321            1321         2 Sex requiremen…
    #> 18                    6            378             378         3 Age requiremen…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

We can also specify the minimum number of days of prior observation required.
    
    
    cdm$working_age_cohort_0_365 <- [demographicsCohort](../reference/demographicsCohort.html)(cdm = cdm, 
                                                 ageRange = [c](https://rdrr.io/r/base/c.html)(18, 65), 
                                                 name = "working_age_cohort_0_365",
                                                 minPriorObservation = [c](https://rdrr.io/r/base/c.html)(0,365))
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$working_age_cohort_0_365)
    #> # A tibble: 2 × 4
    #>   cohort_definition_id cohort_name    age_range min_prior_observation
    #>                  <int> <chr>          <chr>                     <dbl>
    #> 1                    1 demographics_1 18_65                         0
    #> 2                    2 demographics_2 18_65                       365
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$working_age_cohort_0_365)
    #> # A tibble: 2 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           2694            2694
    #> 2                    2           2694            2694
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$working_age_cohort_0_365)
    #> # A tibble: 6 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1           2694            2694         1 Initial qualify…
    #> 2                    1           2694            2694         2 Age requirement…
    #> 3                    1           2694            2694         3 Prior observati…
    #> 4                    2           2694            2694         1 Initial qualify…
    #> 5                    2           2694            2694         2 Age requirement…
    #> 6                    2           2694            2694         3 Prior observati…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

## Measurement Cohort

Another base cohort we can create is based around patient measurements. Here for example we create a cohort of patients who have a normal BMI (BMI between 18 and 25). To do this you must first identify the measurement you want to look at (in this case BMI (concept id = 4245997)), the unit of measurement (kg per square-meter (concept id = 9531)) and ‘normal’ value concept (concept id = 4069590). The value concept is included for the cases where the exact BMI measurement is not specified, but the BMI category (i.e. normal, overweight, obese etc) is. This means that if a record matches the value concept OR has a normal BMI score then it is included in the cohort.
    
    
    cdm$cohort <- [measurementCohort](../reference/measurementCohort.html)(
      cdm = cdm,
      name = "cohort",
      conceptSet = [list](https://rdrr.io/r/base/list.html)("bmi_normal" = [c](https://rdrr.io/r/base/c.html)(4245997)),
      valueAsConcept = [c](https://rdrr.io/r/base/c.html)(4069590),
      valueAsNumber = [list](https://rdrr.io/r/base/list.html)("9531" = [c](https://rdrr.io/r/base/c.html)(18, 25))
    )
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$cohort)
    #> # A tibble: 6 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1              5               3         1 Initial qualify…
    #> 2                    1              3               2         2 Record in obser…
    #> 3                    1              3               2         3 Not missing rec…
    #> 4                    1              3               2         4 Non-missing sex 
    #> 5                    1              3               2         5 Non-missing yea…
    #> 6                    1              3               2         6 Distinct measur…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort)
    #> # A tibble: 1 × 4
    #>   cohort_definition_id cohort_name cdm_version vocabulary_version
    #>                  <int> <chr>       <chr>       <chr>             
    #> 1                    1 bmi_normal  5.3         mock
    cdm$cohort
    #> # Source:   table<cohort> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <dbl> <date>            <date>         
    #> 1                    1          1 2009-07-01        2009-07-01     
    #> 2                    1          3 1999-09-08        1999-09-08     
    #> 3                    1          1 2015-02-19        2015-02-19

As you can see in the above code, the concept set is the list of BMI concepts, the concept value is the ‘normal’ weight concept, and the values are the minimum and maximum BMI scores to be considered.

It is also possible to include records outside of observation by setting the `useRecordsBeforeObservation` argument to TRUE.
    
    
    cdm$cohort <- [measurementCohort](../reference/measurementCohort.html)(
      cdm = cdm,
      name = "cohort",
      conceptSet = [list](https://rdrr.io/r/base/list.html)("bmi_normal" = [c](https://rdrr.io/r/base/c.html)(4245997)),
      valueAsConcept = [c](https://rdrr.io/r/base/c.html)(4069590),
      valueAsNumber = [list](https://rdrr.io/r/base/list.html)("9531" = [c](https://rdrr.io/r/base/c.html)(18, 25)),
      useRecordsBeforeObservation = TRUE
    )
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$cohort)
    #> # A tibble: 6 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1              5               3         1 Initial qualify…
    #> 2                    1              4               3         2 Record in obser…
    #> 3                    1              4               3         3 Not missing rec…
    #> 4                    1              4               3         4 Non-missing sex 
    #> 5                    1              4               3         5 Non-missing yea…
    #> 6                    1              4               3         6 Distinct measur…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort)
    #> # A tibble: 1 × 4
    #>   cohort_definition_id cohort_name cdm_version vocabulary_version
    #>                  <int> <chr>       <chr>       <chr>             
    #> 1                    1 bmi_normal  5.3         mock
    cdm$cohort
    #> # Source:   table<cohort> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <dbl> <date>            <date>         
    #> 1                    1          2 2006-04-01        2006-04-01     
    #> 2                    1          3 1999-09-08        1999-09-08     
    #> 3                    1          1 2009-07-01        2009-07-01     
    #> 4                    1          1 2015-02-19        2015-02-19

## Death cohort

Another base cohort we can make is one with individuals who have died. For this we’ll simply be finding those people in the OMOP CDM death table and creating a cohort with them.
    
    
    cdm$death_cohort <- [deathCohort](../reference/deathCohort.html)(cdm = cdm,
                                    name = "death_cohort")

To create a cohort of individuals who have died, but restrict it to those already part of another cohort (e.g., the “drugs” cohort), you can use `subsetCohort = "drugs"`. This ensures that only individuals from the “drugs” cohort are included in the death cohort.
    
    
    cdm$death_drugs <- [deathCohort](../reference/deathCohort.html)(cdm = cdm,
                                   name = "death_drugs",
                                   subsetCohort = "drugs")

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/articles/a02_cohort_table_requirements.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Applying cohort table requirements

Source: [`vignettes/a02_cohort_table_requirements.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a02_cohort_table_requirements.Rmd)

`a02_cohort_table_requirements.Rmd`

In this vignette we’ll show how requirements related to the data contained in the cohort table can be applied. For this we’ll use the Eunomia synthetic data.
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", 
                        writeSchema = "main", writePrefix = "my_study_")

Let’s start by creating a cohort of acetaminophen users. Individuals will have a cohort entry for each drug exposure record they have for acetaminophen with cohort exit based on their drug record end date. Note when creating the cohort, any overlapping records will be concatenated.
    
    
    acetaminophen_codes <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm, 
                                                  name = "acetaminophen", 
                                                  nameStyle = "{concept_name}")
    cdm$acetaminophen <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                       conceptSet = acetaminophen_codes, 
                                       exit = "event_end_date",
                                       name = "acetaminophen")

At this point we have just created our base cohort without having applied any restrictions. To visualise the current state of the cohort, we can use the `[summariseCohortAttrition()](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)` function to summarise attrition and then plot the results using `[plotCohortAttrition()](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)`.
    
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$acetaminophen)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## Keep only the first record per person

We can see that in our starting cohort individuals have multiple entries for each use of acetaminophen. However, we could keep only their earliest cohort entry by using `[requireIsFirstEntry()](../reference/requireIsFirstEntry.html)` from CohortConstructor.
    
    
    cdm$acetaminophen <- cdm$acetaminophen |> 
      [requireIsFirstEntry](../reference/requireIsFirstEntry.html)()
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$acetaminophen)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

While the number of individuals remains unchanged, records after an individual’s first have been excluded.

## Keep only the last record per person

If we want to require cohort entries to last a specific amount of time then we can use `[requireDuration()](../reference/requireDuration.html)`. Here for example we create an acetaminophen cohort and keep only those records that last for at least 30 days.
    
    
    cdm$acetaminophen <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                       conceptSet = acetaminophen_codes, 
                                       exit = "event_end_date",
                                       name = "acetaminophen") |> 
      [requireDuration](../reference/requireDuration.html)([c](https://rdrr.io/r/base/c.html)(30, Inf))
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$acetaminophen)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## Keep only a range of records per person

If we want to keep only a specific range of records per person, we can use the `[requireIsEntry()](../reference/requireIsEntry.html)` function. For example, o keep only the first two entries for each person, we can set `entryRange = c(1, 2)`.
    
    
    cdm$acetaminophen <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                       conceptSet = acetaminophen_codes, 
                                       exit = "event_end_date",
                                       name = "acetaminophen")
    cdm$acetaminophen <- cdm$acetaminophen |> 
      [requireIsEntry](../reference/requireIsEntry.html)(entryRange = [c](https://rdrr.io/r/base/c.html)(1,2))
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$acetaminophen)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## Keep only records within a date range

Individuals may contribute multiple records over extended periods. We can filter out records that fall outside a specified date range using the `requireInDateRange` function.
    
    
    cdm$acetaminophen <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = acetaminophen_codes, 
                                     name = "acetaminophen")
    
    
    cdm$acetaminophen <- cdm$acetaminophen |> 
      [requireInDateRange](../reference/requireInDateRange.html)(dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2010-01-01", "2015-01-01")))
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$acetaminophen)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## Keep only if entry lasts a given duration
    
    
    cdm$acetaminophen <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = acetaminophen_codes, 
                                     name = "acetaminophen")
    
    
    cdm$acetaminophen <- cdm$acetaminophen |> 
      [requireInDateRange](../reference/requireInDateRange.html)(dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2010-01-01", "2015-01-01")))
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$acetaminophen)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## Applying multiple cohort requirements

Multiple restrictions can be applied to a cohort, however it is important to note that the order that requirements are applied will often matter.
    
    
    cdm$acetaminophen_1 <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = acetaminophen_codes, 
                                     name = "acetaminophen_1") |> 
      [requireIsFirstEntry](../reference/requireIsFirstEntry.html)() |>
      [requireInDateRange](../reference/requireInDateRange.html)(dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2010-01-01", "2016-01-01")))
    
    cdm$acetaminophen_2 <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = acetaminophen_codes, 
                                     name = "acetaminophen_2") |>
      [requireInDateRange](../reference/requireInDateRange.html)(dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2010-01-01", "2016-01-01"))) |> 
      [requireIsFirstEntry](../reference/requireIsFirstEntry.html)()
    
    
    summary_attrition_1 <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$acetaminophen_1)
    summary_attrition_2 <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$acetaminophen_2)

Here we see attrition if we apply our entry requirement before our date requirement. In this case we have a cohort of people with their first ever record of acetaminophen which occurs in our study period.
    
    
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition_1)

And here we see attrition if we apply our date requirement before our entry requirement. In this case we have a cohort of people with their first record of acetaminophen in the study period, although this will not necessarily be their first record ever.
    
    
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition_2)

## Keep only records from cohorts with a minimum number of individuals

Another useful functionality, particularly when working with multiple cohorts or performing a network study, is provided by `requireMinCohortCount`. Here we will only keep cohorts with a minimum count, filtering out records from cohorts with fewer than this number.

As an example let’s create a cohort for every drug ingredient we see in Eunomia. We can first get the drug ingredient codes.
    
    
    medication_codes <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm = cdm, nameStyle = "{concept_name}")
    medication_codes
    #> 
    #> - acetaminophen (7 codes)
    #> - albuterol (2 codes)
    #> - alendronate (2 codes)
    #> - alfentanil (1 codes)
    #> - alteplase (2 codes)
    #> - amiodarone (2 codes)
    #> along with 85 more codelists

We can see that when we make all these cohorts many have only a small number of individuals.
    
    
    cdm$medications <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = medication_codes,
                                     name = "medications")
    
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications) |> 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(number_subjects > 0) |> 
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)() +
      [geom_histogram](https://ggplot2.tidyverse.org/reference/geom_histogram.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(number_subjects),
                     colour = "black",
                     binwidth = 25) +  
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Number of subjects") +
      [theme_bw](https://ggplot2.tidyverse.org/reference/ggtheme.html)()

![](a02_cohort_table_requirements_files/figure-html/unnamed-chunk-19-1.png)

If we apply a minimum cohort count of 500, we end up with far fewer cohorts that all have a sufficient number of study participants.
    
    
    cdm$medications <- cdm$medications |> 
      [requireMinCohortCount](../reference/requireMinCohortCount.html)(minCohortCount = 500)
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications) |> 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(number_subjects > 0) |> 
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)() +
      [geom_histogram](https://ggplot2.tidyverse.org/reference/geom_histogram.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(number_subjects),
                     colour = "black",
                     binwidth = 25) + 
      [xlim](https://ggplot2.tidyverse.org/reference/lims.html)(0, NA) + 
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Number of subjects") +
      [theme_bw](https://ggplot2.tidyverse.org/reference/ggtheme.html)()

![](a02_cohort_table_requirements_files/figure-html/unnamed-chunk-20-1.png)

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/articles/a03_require_demographics.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Applying demographic requirements to a cohort

Source: [`vignettes/a03_require_demographics.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a03_require_demographics.Rmd)

`a03_require_demographics.Rmd`
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    #> 
    #> Attaching package: 'dplyr'
    #> The following objects are masked from 'package:stats':
    #> 
    #>     filter, lag
    #> The following objects are masked from 'package:base':
    #> 
    #>     intersect, setdiff, setequal, union
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))

In this vignette we’ll show how requirements related to patient demographics can be applied to a cohort. Again we’ll use the Eunomia synthetic data.
    
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", 
                        writeSchema = "main", writePrefix = "my_study_")

Let’s start by creating a cohort of people with a fracture. We’ll first look for codes that might represent a fracture and the build a cohort using these codes, setting cohort exit to 180 days after the fracture.
    
    
    fracture_codes <- [getCandidateCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getCandidateCodes.html)(cdm, "fracture")
    fracture_codes <- [list](https://rdrr.io/r/base/list.html)("fracture" = fracture_codes$concept_id)
    cdm$fracture <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = fracture_codes, 
                                     name = "fracture")
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$fracture)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## Restrict cohort by age

We can choose a specific age range for individuals in our cohort using `[requireAge()](../reference/requireAge.html)` from CohortConstructor.
    
    
    cdm$fracture <- cdm$fracture |> 
      [requireAge](../reference/requireAge.html)(indexDate = "cohort_start_date",
                 ageRange = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(18, 100)))
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$fracture)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

Note that by default individuals are filtered based on the age they were when they entered the cohort.

## Restrict cohort by sex

We can also specify a sex criteria for individuals in our cohort using `[requireSex()](../reference/requireSex.html)` from CohortConstructor.
    
    
    cdm$fracture <- cdm$fracture |> 
      [requireSex](../reference/requireSex.html)(sex = "Female")
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$fracture)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## Restrict cohort by number of prior observations

We can also specify a minimum number of days of prior observations for each individual using `[requirePriorObservation()](../reference/requirePriorObservation.html)` from CohortConstructor.
    
    
    cdm$fracture <- cdm$fracture |> 
      [requirePriorObservation](../reference/requirePriorObservation.html)(indexDate = "cohort_start_date",
                              minPriorObservation = 365)
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$fracture)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

As well as specifying a minimum amount of prior observation, we can require some mimimum amount of follow-up by using `[requireFutureObservation()](../reference/requireFutureObservation.html)` in a similar way.

## Applying multiple demographic requirements to a cohort

We can implement multiple demographic requirements at the same time by using the more general `[requireDemographics()](../reference/requireDemographics.html)` function.
    
    
    cdm$fracture <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = fracture_codes, 
                                     name = "fracture") |> 
      [requireDemographics](../reference/requireDemographics.html)(indexDate = "cohort_start_date",
                          ageRange = [c](https://rdrr.io/r/base/c.html)(18,100),
                          sex = "Female",
                          minPriorObservation = 365, 
                          minFutureObservation = 30)
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$fracture)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/articles/a04_require_intersections.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Applying requirements related to other cohorts, concept sets, or tables

Source: [`vignettes/a04_require_intersections.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a04_require_intersections.Rmd)

`a04_require_intersections.Rmd`
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([visOmopResults](https://darwin-eu.github.io/visOmopResults/))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))

For this example we’ll use the Eunomia synthetic data from the CDMConnector package.
    
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", 
                        writeSchema = "main", writePrefix = "my_study_")

Let’s start by creating a cohort of warfarin users.
    
    
    warfarin_codes <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm, "warfarin")
    cdm$warfarin <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = warfarin_codes, 
                                     name = "warfarin")
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$warfarin)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1            137             137

As well as our warfarin cohort, let’s also make another cohort containing individuals with a record of a GI bleed. Later we’ll use this cohort when specifying inclusion/ exclusion criteria.
    
    
    cdm$gi_bleed <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm,  
                                  conceptSet = [list](https://rdrr.io/r/base/list.html)("gi_bleed" = 192671L),
                                  name = "gi_bleed")

## Restrictions on cohort presence

We could require that individuals in our medication cohorts are seen (or not seen) in another cohort. To do this we can use the `[requireCohortIntersect()](../reference/requireCohortIntersect.html)` function. Here, for example, we require that individuals have one or more intersections with the GI bleed cohort.
    
    
    cdm$warfarin_gi_bleed <- cdm$warfarin  |>
      [requireCohortIntersect](../reference/requireCohortIntersect.html)(intersections = [c](https://rdrr.io/r/base/c.html)(1,Inf),
                             targetCohortTable = "gi_bleed", 
                             targetCohortId = 1,
                             indexDate = "cohort_start_date", 
                             window = [c](https://rdrr.io/r/base/c.html)(-Inf, 0), 
                             name = "warfarin_gi_bleed")
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$warfarin_gi_bleed)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

The flow chart above illustrates the changes to the cohort of users of acetaminophen when restricted to only include individuals who have at least one record in the GI bleed cohort before their start date for acetaminophen.

Instead of requiring that individuals have a record in the GI bleed cohort, we could instead require that they don’t. In this case we can again use the `[requireCohortIntersect()](../reference/requireCohortIntersect.html)` function, but this time we set the intersections argument to 0 so as to require individuals’ absence in this other cohort.
    
    
    cdm$warfarin_no_gi_bleed <- cdm$warfarin |>
      [requireCohortIntersect](../reference/requireCohortIntersect.html)(intersections = 0,
                             targetCohortTable = "gi_bleed", 
                             targetCohortId = 1,
                             indexDate = "cohort_start_date", 
                             window = [c](https://rdrr.io/r/base/c.html)(-Inf, 0), 
                             name = "warfarin_no_gi_bleed") 
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$warfarin_no_gi_bleed)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## Restrictions on concept presence

We could require that individuals in our medication cohorts have been seen (or not seen) to have events related to a concept list. To do this we can use the `[requireConceptIntersect()](../reference/requireConceptIntersect.html)` function, allowing us to filter our cohort based on whether they have or have not had events of GI bleeding before they entered the cohort.
    
    
    cdm$warfarin_gi_bleed <- cdm$warfarin  |>
      [requireConceptIntersect](../reference/requireConceptIntersect.html)(conceptSet = [list](https://rdrr.io/r/base/list.html)("gi_bleed" = 192671), 
                             indexDate = "cohort_start_date", 
                             window = [c](https://rdrr.io/r/base/c.html)(-Inf, 0), 
                             name = "warfarin_gi_bleed")
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$warfarin_gi_bleed)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

The flow chart above illustrates the changes to cohort 1 when restricted to only include individuals who have had events of GI bleeding at least once before the cohort start date. 2,296 individuals and 8,765 records were excluded.

Instead of requiring that individuals have events of GI bleeding, we could instead require that they don’t have any events of it. In this case we can again use the `[requireConceptIntersect()](../reference/requireConceptIntersect.html)` function, but this time set the intersections argument to 0 to require individuals without past events of GI bleeding.
    
    
    cdm$warfarin_no_gi_bleed <- cdm$warfarin  |>
      [requireConceptIntersect](../reference/requireConceptIntersect.html)(intersections = 0,
                             conceptSet = [list](https://rdrr.io/r/base/list.html)("gi_bleed" = 192671), 
                             indexDate = "cohort_start_date", 
                             window = [c](https://rdrr.io/r/base/c.html)(-Inf, 0), 
                             name = "warfarin_no_gi_bleed")
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$warfarin_no_gi_bleed)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## Restrictions on presence in clinical tables

We can also impose requirements around individuals presence (or absence) in clinical tables in the OMOP CDM using the `[requireTableIntersect()](../reference/requireTableIntersect.html)` function. Here for example we reuire that individuals in our warfarin cohort have at least one prior record in the visit occurrence table.
    
    
    cdm$warfarin_visit <- cdm$warfarin  |>
      [requireTableIntersect](../reference/requireTableIntersect.html)(tableName = "visit_occurrence",
                             indexDate = "cohort_start_date", 
                             window = [c](https://rdrr.io/r/base/c.html)(-Inf, -1), 
                             name = "warfarin_visit")
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$warfarin_visit)
    [plotCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html)(summary_attrition)

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/articles/a05_update_cohort_start_end.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Updating cohort start and end dates

Source: [`vignettes/a05_update_cohort_start_end.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a05_update_cohort_start_end.Rmd)

`a05_update_cohort_start_end.Rmd`

## Introduction

Accurately defining cohort entry and exit dates is crucial in observational research to ensure the validity of study findings. The `CohortConstructor` package provides several functions to adjust these dates based on specific criteria, and this vignette demonstrates how to use them.

Functions to update cohort dates can be categorized into four groups:

  * **Exit at Specific Date Functions:** Adjust the cohort end date to predefined events (observation end and death date).

  * **Cohort Entry or Exit Based on Other Date Columns:** Modify cohort start or end dates to the earliest or latests from a set of date columns.

  * **Trim Dates Functions:** Restrict cohort entries based on demographic criteria or specific date ranges.

  * **Pad Dates Functions:** Adjust cohort start or end dates by adding or subtracting a specified number of days.




We’ll explore each category in the following sections.

First, we’ll connect to the Eunomia synthetic data and create a mock cohort of women in the database to use as example in the vignette.
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    
    if ([Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("EUNOMIA_DATA_FOLDER") == ""){
    [Sys.setenv](https://rdrr.io/r/base/Sys.setenv.html)("EUNOMIA_DATA_FOLDER" = [file.path](https://rdrr.io/r/base/file.path.html)([tempdir](https://rdrr.io/r/base/tempfile.html)(), "eunomia"))}
    if (![dir.exists](https://rdrr.io/r/base/files2.html)([Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("EUNOMIA_DATA_FOLDER"))){ [dir.create](https://rdrr.io/r/base/files2.html)([Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("EUNOMIA_DATA_FOLDER"))
    [downloadEunomiaData](https://darwin-eu.github.io/CDMConnector/reference/downloadEunomiaData.html)()  
    }
    #> 
    #> Download completed!
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    #> Creating CDM database /tmp/RtmpVPsbLM/eunomia/GiBleed_5.3.zip
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", 
                        writeSchema = "main", writePrefix = "my_study_")
    
    cdm$cohort <- [demographicsCohort](../reference/demographicsCohort.html)(cdm = cdm, name = "cohort", sex = "Female")
    #> ℹ Building new trimmed cohort
    #> Adding demographics information
    #> Creating initial cohort
    #> Trim sex
    #> ✔ Cohort trimmed

## Exit at Specific Date

###  `exitAtObservationEnd()`

The `[exitAtObservationEnd()](../reference/exitAtObservationEnd.html)` function updates the cohort end date to the end of the observation period for each subject. This ensures that the cohort exit does not extend beyond the period during which data is available for the subject.
    
    
    cdm$cohort_observation_end <- cdm$cohort |> 
      [exitAtObservationEnd](../reference/exitAtObservationEnd.html)(name = "cohort_observation_end")

As cohort entries cannot overlap, updating the end date to the observation end may result in overlapping records. In such cases, overlapping records are collapsed into a single entry (starting at the earliest entry and ending at the end of observation).

This function has an argument `persistAcrossObservationPeriods` to consider cases when a subject may have more than one observation period. If `persistAcrossObservationPeriods = FALSE` then cohort end date will be set to the end of the observation period where the record occurs. If `persistAcrossObservationPeriods = TRUE`, in addition to updating the cohort end to the current observation end, cohort entries are created for each of the subsequent observation periods.

###  `exitAtDeath()`

The `[exitAtDeath()](../reference/exitAtDeath.html)` function sets the cohort end date to the recorded death date of the subject.

By default, it keeps the end date of subjects who do not have a death record unmodified; however, these can be dropped with the argument `requireDeath.`
    
    
    cdm$cohort_death <- cdm$cohort |> 
      [exitAtDeath](../reference/exitAtDeath.html)(requireDeath = TRUE, name = "cohort_death")

## Cohort Entry or Exit Based on Other Date Columns

###  `entryAtFirstDate()`

The `[entryAtFirstDate()](../reference/entryAtFirstDate.html)` function updates the cohort start date to the earliest date among specified columns.

Next we want to set the entry date to the first of: diclofenac or acetaminophen prescriptions after cohort start, or cohort end date.
    
    
    # create cohort with of drugs diclofenac and acetaminophen 
    cdm$medications <- [conceptCohort](../reference/conceptCohort.html)(
      cdm = cdm, name = "medications",
      conceptSet = [list](https://rdrr.io/r/base/list.html)("diclofenac" = 1124300, "acetaminophen" = 1127433)
    )
    #> Warning: ! `codelist` casted to integers.
    #> ℹ Subsetting table drug_exposure using 2 concepts with domain: drug.
    #> ℹ Combining tables.
    #> ℹ Creating cohort attributes.
    #> ℹ Applying cohort requirements.
    #> ℹ Merging overlapping records.
    #> ✔ Cohort medications created.
    
    # add date first ocurrence of these drugs from index date
    cdm$cohort_dates <- cdm$cohort |> 
      [addCohortIntersectDate](https://darwin-eu.github.io/PatientProfiles/reference/addCohortIntersectDate.html)(
        targetCohortTable = "medications", 
        nameStyle = "{cohort_name}",
        name = "cohort_dates"
        ) 
    
    # set cohort start at the first ocurrence of one of the drugs, or the end date
    cdm$cohort_entry_first <- cdm$cohort_dates |>
      [entryAtFirstDate](../reference/entryAtFirstDate.html)(
        dateColumns = [c](https://rdrr.io/r/base/c.html)("diclofenac", "acetaminophen", "cohort_end_date"), 
        name = "cohort_entry_first"
      )
    #> Joining with `by = join_by(cohort_definition_id, subject_id, cohort_end_date)`
    cdm$cohort_entry_first 
    #> # Source:   table<my_study_cohort_entry_first> [?? x 6]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/RtmpVPsbLM/file2915669b5bb2.duckdb]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date diclofenac
    #>                   <int>      <int> <date>            <date>          <date>    
    #>  1                    1        877 1992-05-28        2019-05-14      NA        
    #>  2                    1       1511 1966-01-22        2019-05-19      2010-01-29
    #>  3                    1       3386 2007-09-08        2019-02-04      2007-09-08
    #>  4                    1       3676 1975-10-19        2018-12-06      NA        
    #>  5                    1       1397 1989-02-15        2019-02-15      2016-08-26
    #>  6                    1       4777 1971-04-05        2018-07-10      NA        
    #>  7                    1       5031 1928-02-17        2019-05-25      NA        
    #>  8                    1       4807 1957-10-24        2019-05-23      NA        
    #>  9                    1       1829 1985-04-02        2018-08-28      2002-08-09
    #> 10                    1       3083 1951-05-30        2018-08-05      NA        
    #> # ℹ more rows
    #> # ℹ 1 more variable: acetaminophen <date>

###  `entryAtLastDate()`

The `[entryAtLastDate()](../reference/entryAtLastDate.html)` function works similarly to `[entryAtFirstDate()](../reference/entryAtFirstDate.html)`, however now the selected column is the latest date among specified columns.
    
    
    cdm$cohort_entry_last <- cdm$cohort_dates |>
      [entryAtLastDate](../reference/entryAtLastDate.html)(
        dateColumns = [c](https://rdrr.io/r/base/c.html)("diclofenac", "acetaminophen", "cohort_end_date"), 
        keepDateColumns = FALSE,
        name = "cohort_entry_last"
      )
    
    cdm$cohort_entry_last
    #> # Source:   table<my_study_cohort_entry_last> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/RtmpVPsbLM/file2915669b5bb2.duckdb]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1         16 2017-11-02        2017-11-02     
    #>  2                    1         38 2019-01-30        2019-01-30     
    #>  3                    1        153 2018-11-01        2018-11-01     
    #>  4                    1        715 2018-02-20        2018-02-20     
    #>  5                    1        857 2016-05-30        2016-05-30     
    #>  6                    1       1102 2019-02-05        2019-02-05     
    #>  7                    1       1132 2018-07-30        2018-07-30     
    #>  8                    1       1352 2019-02-03        2019-02-03     
    #>  9                    1       1524 2019-05-02        2019-05-02     
    #> 10                    1       1770 2017-12-31        2017-12-31     
    #> # ℹ more rows

In this example, we set `keepDateColumns` to FALSE, which drops columns in `dateColumns`.

###  `exitAtFirstDate()`

The `[exitAtFirstDate()](../reference/exitAtFirstDate.html)` function updates the cohort end date to the earliest date among specified columns.

For instance, next we want the exit to be observation end, except if there is a record of diclofenac or acetaminophen, in which case that would be the end:
    
    
    cdm$cohort_exit_first <- cdm$cohort_dates |>
      [addFutureObservation](https://darwin-eu.github.io/PatientProfiles/reference/addFutureObservation.html)(futureObservationType = "date", name = "cohort_exit_first") |>
      [exitAtFirstDate](../reference/exitAtFirstDate.html)(
        dateColumns = [c](https://rdrr.io/r/base/c.html)("future_observation", "acetaminophen", "diclofenac"),
        keepDateColumns = FALSE
      )
    
    cdm$cohort_exit_first 
    #> # Source:   table<my_study_cohort_exit_first> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/RtmpVPsbLM/file2915669b5bb2.duckdb]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1         12 1963-01-30        1974-08-01     
    #>  2                    1        404 1960-06-14        1965-03-22     
    #>  3                    1        431 1948-01-02        1964-11-03     
    #>  4                    1        905 1968-09-21        1973-01-30     
    #>  5                    1        987 1953-08-30        1954-01-28     
    #>  6                    1       1098 1955-12-10        1956-11-05     
    #>  7                    1       1113 1971-11-16        2013-07-23     
    #>  8                    1       1253 1955-03-10        1970-12-16     
    #>  9                    1       1508 1924-01-01        1967-05-20     
    #> 10                    1       1850 1956-12-14        1976-09-26     
    #> # ℹ more rows

###  `exitAtLastDate()`

Similarly, the `[exitAtLastDate()](../reference/exitAtLastDate.html)` function sets the cohort end date to the latest date among specified columns.
    
    
    cdm$cohort_exit_last <- cdm$cohort_dates |> 
      [exitAtLastDate](../reference/exitAtLastDate.html)(
        dateColumns = [c](https://rdrr.io/r/base/c.html)("cohort_end_date", "acetaminophen", "diclofenac"),
        returnReason = FALSE,
        keepDateColumns = FALSE,
        name = "cohort_exit_last"
      )
    cdm$cohort_exit_last
    #> # Source:   table<my_study_cohort_exit_last> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/RtmpVPsbLM/file2915669b5bb2.duckdb]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1         19 1949-01-30        2018-08-19     
    #>  2                    1         36 1958-10-21        2019-01-15     
    #>  3                    1        190 1930-07-08        2016-04-12     
    #>  4                    1        276 1977-06-10        2018-10-26     
    #>  5                    1        387 1973-08-31        2017-09-15     
    #>  6                    1        525 1949-04-04        2018-07-23     
    #>  7                    1        763 1965-03-18        2019-04-11     
    #>  8                    1        905 1968-09-21        2019-04-26     
    #>  9                    1       1098 1955-12-10        2019-02-23     
    #> 10                    1       1118 1973-08-12        2019-06-23     
    #> # ℹ more rows

In this last example, the return cohort doesn’t have the specified date columns, neither the “reason” column indicating which date was used for entry/exit. These was set with the `keepDateColumns` and `returnReason` arguments, common throughout the functions in this category.

## Trim Dates Functions

###  `trimDemographics()`

The `[trimDemographics()](../reference/trimDemographics.html)` function restricts the cohort based on patient demographics. This means that cohort start and end dates are moved (within the original cohort entry dates) to ensure that individuals meet specific demographic criteria throughout their cohort participation. If individuals do not satisfy the criteria at any point during their cohort period, their records are excluded.

For instance, if we trim using an age range from 18 to 65, individuals will only contribute in the cohort form the day they are 18 or older, up to the day before turning 66 (or before if they leave the database).
    
    
    cdm$cohort_trim <- cdm$cohort |>
      [trimDemographics](../reference/trimDemographics.html)(ageRange = [c](https://rdrr.io/r/base/c.html)(18, 65), name = "cohort_trim")
    #> ℹ Building new trimmed cohort
    #> Adding demographics information
    #> Creating initial cohort
    #> Trim age
    #> ✔ Cohort trimmed

###  `trimToDateRange()`

The `[trimToDateRange()](../reference/trimToDateRange.html)` function confines cohort entry and exit dates within a specified date range, ensuring that cohort periods align with the defined timeframe. If only the start or end of a range is required, the other can be set to `NA`.

For example, to restrict cohort dates to be on or after January 1st, 2015:
    
    
    # Trim cohort dates to be within the year 2000
    cdm$cohort_trim <- cdm$cohort_trim |> 
      [trimToDateRange](../reference/trimToDateRange.html)(dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2015-01-01", NA)))

## Pad Dates Functions

###  `padCohortStart()`

The `[padCohortStart()](../reference/padCohortStart.html)` function adds (or subtracts) a specified number of days to the cohort start date.

For example, to subtract 50 days from the cohort start date:
    
    
    # Substract 50 days to cohort start
    cdm$cohort <- cdm$cohort |> [padCohortStart](../reference/padCohortStart.html)(days = -50, collapse = FALSE)

When subtracting days, it may result in cohort start dates preceding the observation period start. By default, such entries are corrected to the observation period start. To drop these entries instead, set the `padObservation` argument to FALSE.

Additionally, adjusting cohort start dates may lead to overlapping entries for the same subject. The `collapse` argument manages this: if TRUE, merges overlapping entries into a single record with the earliest start and latest end date (default), if FALSE retains only the first of the overlapping entries.

###  `padCohortEnd()`

Similarly, the `[padCohortEnd()](../reference/padCohortEnd.html)` function adjusts the cohort end date by adding (or subtracting) a specified number of days.

The example below adds 1000 days to cohort end date, while dropping records that are outside of observation after adding days.
    
    
    cdm$cohort_pad <- cdm$cohort |> 
      [padCohortEnd](../reference/padCohortEnd.html)(days = 1000, padObservation = FALSE, name = "cohort_pad")

Additionally, days to add can also be specified with a numeric column in the cohort, which allows to add a specific number of days for each record:
    
    
    cdm$cohort <- cdm$cohort [%>%](https://magrittr.tidyverse.org/reference/pipe.html) 
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(days_to_add = !![datediff](https://darwin-eu.github.io/CDMConnector/reference/datediff.html)("cohort_start_date", "cohort_end_date")) |>
      [padCohortEnd](../reference/padCohortEnd.html)(days = "days_to_add", padObservation = FALSE)

###  `padCohortDate()`

The `[padCohortDate()](../reference/padCohortDate.html)` function provides a more flexible approach by allowing adjustments to either the cohort start or end date based on specified parameters. You can define which date to adjust (`cohortDate`), the reference date for the adjustment (`indexDate`), and the number of days to add or subtract.

For example, to set the cohort end date to be 365 days after the cohort start date:
    
    
    cdm$cohort <- cdm$cohort |> 
      [padCohortDate](../reference/padCohortDate.html)(days = 365, cohortDate = "cohort_end_date", indexDate = "cohort_start_date")

## Cohort ID argument

For all these functions, the cohortId argument specifies which cohorts to modify. This allows for targeted adjustments without altering other cohorts. For instance, to add 10 days to the end date of the acetaminophen cohort and 20 days to the diclofenac cohort we can do the following:
    
    
    cdm$medications <- cdm$medications |> 
      [padCohortDate](../reference/padCohortDate.html)(days = 10, cohortId = "acetaminophen") |> 
      [padCohortDate](../reference/padCohortDate.html)(days = 20, cohortId = "diclofenac")

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/articles/a06_concatanate_cohorts.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Concatenating cohort records

Source: [`vignettes/a06_concatanate_cohorts.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a06_concatanate_cohorts.Rmd)

`a06_concatanate_cohorts.Rmd`
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))

For this example we’ll use the Eunomia synthetic data from the CDMConnector package.
    
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", 
                        writeSchema = "main", writePrefix = "my_study_")

Let’s start by creating a cohort of users of acetaminophen
    
    
    cdm$medications <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = [list](https://rdrr.io/r/base/list.html)("acetaminophen" = 1127433), 
                                     name = "medications")
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           9365            2580

We can merge cohort records using the `[collapseCohorts()](../reference/collapseCohorts.html)` function in the CohortConstructor package. The function allows us to specifying the number of days between two cohort entries, which will then be merged into a single record.

Let’s first define a new cohort where records within 1095 days (~ 3 years) of each other will be merged.
    
    
    cdm$medications_collapsed <- cdm$medications |> 
      [collapseCohorts](../reference/collapseCohorts.html)(
      gap = 1095,
      name = "medications_collapsed"
    )

Let’s compare how this function would change the records of a single individual.
    
    
    cdm$medications |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id == 1)
    #> # Source:   SQL [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/RtmpKSn3kh/file295f2362deec.duckdb]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1          1 1980-03-15        1980-03-29     
    #> 2                    1          1 1971-01-04        1971-01-18     
    #> 3                    1          1 1982-09-11        1982-10-02     
    #> 4                    1          1 1976-10-20        1976-11-03
    cdm$medications_collapsed |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id == 1)
    #> # Source:   SQL [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/RtmpKSn3kh/file295f2362deec.duckdb]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1          1 1980-03-15        1982-10-02     
    #> 2                    1          1 1971-01-04        1971-01-18     
    #> 3                    1          1 1976-10-20        1976-11-03

Subject 1 initially had 4 records between 1971 and 1982. After specifying that records within three years of each other are to be merged, the number of records decreases to three. The record from 1980-03-15 to 1980-03-29 and the record from 1982-09-11 to 1982-10-02 are merged to create a new record from 1980-03-15 to 1982-10-02.

Now let’s look at how the cohorts have been changed.
    
    
    summary_attrition <- [summariseCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html)(cdm$medications_collapsed)
    [tableCohortAttrition](https://darwin-eu.github.io/CohortCharacteristics/reference/tableCohortAttrition.html)(summary_attrition)

Reason |  Variable name  
---|---  
number_records | number_subjects | excluded_records | excluded_subjects  
Synthea; acetaminophen  
Initial qualifying events | 9,365 | 2,580 | 0 | 0  
Record in observation | 9,365 | 2,580 | 0 | 0  
Record start <= record end | 9,365 | 2,580 | 0 | 0  
Non-missing sex | 9,365 | 2,580 | 0 | 0  
Non-missing year of birth | 9,365 | 2,580 | 0 | 0  
Merge overlapping records | 9,365 | 2,580 | 0 | 0  
Collapse cohort with a gap of 1095 days. | 7,975 | 2,580 | 1,390 | 0  
  
Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/articles/a07_filter_cohorts.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Filtering cohorts

Source: [`vignettes/a07_filter_cohorts.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a07_filter_cohorts.Rmd)

`a07_filter_cohorts.Rmd`
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))

For this example we’ll use the Eunomia synthetic data from the CDMConnector package.
    
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", 
                        writeSchema = "main", writePrefix = "my_study_")

Let’s start by creating two drug cohorts, one for users of diclofenac and another for users of acetaminophen.
    
    
    cdm$medications <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = [list](https://rdrr.io/r/base/list.html)("diclofenac" = 1124300,
                                                       "acetaminophen" = 1127433), 
                                     name = "medications")
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications)
    #> # A tibble: 2 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           9365            2580
    #> 2                    2            830             830

We can take a sample from a cohort table using the function `sampleCohort()`. This allows us to specify the number of individuals in each cohort.
    
    
    cdm$medications |> [sampleCohorts](../reference/sampleCohorts.html)(cohortId = NULL, n = 100)
    #> # Source:   table<my_study_medications> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/RtmpeV7jIu/file29a4369244db.duckdb]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1       5096 1971-03-25        1971-04-08     
    #>  2                    2       4847 1977-07-08        1977-07-08     
    #>  3                    2       1751 2017-09-08        2017-09-08     
    #>  4                    1        246 2018-03-15        2018-04-05     
    #>  5                    1        870 2002-11-11        2002-12-02     
    #>  6                    1       1900 1980-01-04        1980-01-11     
    #>  7                    1       2780 1968-04-16        1968-04-30     
    #>  8                    1       3469 2015-09-18        2015-10-02     
    #>  9                    1       3580 1989-05-15        1989-06-14     
    #> 10                    2       2218 2011-08-03        2011-08-03     
    #> # ℹ more rows
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications)
    #> # A tibble: 2 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1            344             100
    #> 2                    2            100             100

When cohortId = NULL all cohorts in the table are used. Note that this function does not reduced the number of records in each cohort, only the number of individuals.

It is also possible to only sample one cohort within cohort table, however the remaining cohorts will still remain.
    
    
    cdm$medications <- cdm$medications |> [sampleCohorts](../reference/sampleCohorts.html)(cohortId = 2, n = 100)
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications)
    #> # A tibble: 2 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           9365            2580
    #> 2                    2            100             100

The chosen cohort (users of diclofenac) has been reduced to 100 individuals, as specified in the function, however all individuals from cohort 1 (users of acetaminophen) and their records remain.

If you want to filter the cohort table to only include individuals and records from a specified cohort, you can use the function `subsetCohorts`.
    
    
    cdm$medications <- cdm$medications |> [subsetCohorts](../reference/subsetCohorts.html)(cohortId = 2)
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    2            830             830

The cohort table has been filtered so it now only includes individuals and records from cohort 2. If you want to take a sample of the filtered cohort table then you can use the `sampleCohorts` function.
    
    
    cdm$medications <- cdm$medications |> [sampleCohorts](../reference/sampleCohorts.html)(cohortId = 2, n = 100)
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    2            100             100

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/articles/a08_split_cohorts.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Splitting cohorts

Source: [`vignettes/a08_split_cohorts.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a08_split_cohorts.Rmd)

`a08_split_cohorts.Rmd`

## Introduction

In this vignette we show how to split existing cohorts. We are going to use the _GiBleed_ database to conduct the different examples. To make sure _GiBleed_ database is available you can use the function `[requireEunomia()](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)` so let’s get started.

Load necessary packages:
    
    
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([clock](https://clock.r-lib.org))

Create `cdm_reference` object from _GiBleed_ database:
    
    
    [requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)(datasetName = "GiBleed")
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(drv = [duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con = con, cdmSchema = "main", writeSchema = "main", writePrefix = "my_study_"
    )

Let’s start by creating two drug cohorts, one for users of diclofenac and another for users of acetaminophen.
    
    
    cdm$medications <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = [list](https://rdrr.io/r/base/list.html)("diclofenac" = 1124300L,
                                                       "acetaminophen" = 1127433L), 
                                     name = "medications")
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications)
    #> # A tibble: 2 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           9365            2580
    #> 2                    2            830             830
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$medications)
    #> # A tibble: 2 × 4
    #>   cohort_definition_id cohort_name   cdm_version vocabulary_version
    #>                  <int> <chr>         <chr>       <chr>             
    #> 1                    1 acetaminophen 5.3         v5.0 18-JAN-19    
    #> 2                    2 diclofenac    5.3         v5.0 18-JAN-19

## stratifyCohorts

If we want to create separate cohorts by sex we could use the function `[requireSex()](../reference/requireSex.html)`:
    
    
    cdm$medications_female <- cdm$medications |>
      [requireSex](../reference/requireSex.html)(sex = "Female", name = "medications_female") |>
      [renameCohort](../reference/renameCohort.html)(
        cohortId = [c](https://rdrr.io/r/base/c.html)("acetaminophen", "diclofenac"), 
        newCohortName = [c](https://rdrr.io/r/base/c.html)("acetaminophen_female", "diclofenac_female")
      )
    cdm$medications_male <- cdm$medications |>
      [requireSex](../reference/requireSex.html)(sex = "Male", name = "medications_male") |>
      [renameCohort](../reference/renameCohort.html)(
        cohortId = [c](https://rdrr.io/r/base/c.html)("acetaminophen", "diclofenac"), 
        newCohortName = [c](https://rdrr.io/r/base/c.html)("acetaminophen_male", "diclofenac_male")
      )
    cdm <- [bind](https://darwin-eu.github.io/omopgenerics/reference/bind.html)(cdm$medications_female, cdm$medications_male, name = "medications_sex")
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications_sex)
    #> # A tibble: 4 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           4718            1316
    #> 2                    2            435             435
    #> 3                    3           4647            1264
    #> 4                    4            395             395
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$medications_sex)
    #> # A tibble: 4 × 5
    #>   cohort_definition_id cohort_name          cdm_version vocabulary_version sex  
    #>                  <int> <chr>                <chr>       <chr>              <chr>
    #> 1                    1 acetaminophen_female 5.3         v5.0 18-JAN-19     Fema…
    #> 2                    2 diclofenac_female    5.3         v5.0 18-JAN-19     Fema…
    #> 3                    3 acetaminophen_male   5.3         v5.0 18-JAN-19     Male 
    #> 4                    4 diclofenac_male      5.3         v5.0 18-JAN-19     Male

The `[stratifyCohorts()](../reference/stratifyCohorts.html)` function will produce a similar output but it relies on a column being already created so let’s first add a column sex to my existent cohort:
    
    
    cdm$medications <- cdm$medications |>
      [addSex](https://darwin-eu.github.io/PatientProfiles/reference/addSex.html)()
    cdm$medications
    #> # Source:   table<og_009_1758270112> [?? x 5]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/Rtmp5jJxPo/file29f454de3f40.duckdb]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date sex   
    #>                   <int>      <int> <date>            <date>          <chr> 
    #>  1                    1        222 2014-07-18        2014-08-01      Female
    #>  2                    1        248 2009-05-19        2009-06-18      Male  
    #>  3                    1        363 1995-10-16        1995-10-23      Male  
    #>  4                    1        392 2019-01-31        2019-02-08      Male  
    #>  5                    1        406 1987-06-15        1987-06-29      Male  
    #>  6                    1        776 2003-02-01        2003-02-15      Female
    #>  7                    1        841 1966-08-31        1966-09-07      Male  
    #>  8                    1       1151 2014-01-26        2014-02-09      Female
    #>  9                    1       1325 2001-04-06        2001-04-13      Male  
    #> 10                    1       1513 1968-07-26        1968-08-09      Female
    #> # ℹ more rows

Now we can use the function `[stratifyCohorts()](../reference/stratifyCohorts.html)` to create a new cohort based on the `sex` column, one new cohort will be created for any value of the `sex` column:
    
    
    cdm$medications_sex_2 <- cdm$medications |>
      [stratifyCohorts](../reference/stratifyCohorts.html)(strata = "sex", name = "medications_sex_2")
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications_sex_2)
    #> # A tibble: 4 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           4718            1316
    #> 2                    2           4647            1264
    #> 3                    3            435             435
    #> 4                    4            395             395
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$medications_sex_2)
    #> # A tibble: 4 × 9
    #>   cohort_definition_id cohort_name          target_cohort_id target_cohort_name
    #>                  <int> <chr>                           <int> <chr>             
    #> 1                    1 acetaminophen_female                1 acetaminophen     
    #> 2                    2 acetaminophen_male                  1 acetaminophen     
    #> 3                    3 diclofenac_female                   2 diclofenac        
    #> 4                    4 diclofenac_male                     2 diclofenac        
    #> # ℹ 5 more variables: cdm_version <chr>, vocabulary_version <chr>,
    #> #   target_cohort_table_name <chr>, strata_columns <chr>, sex <chr>

Note that both cohorts can be slightly different, in the first case four cohorts will always be created, whereas in the second one it will rely on whatever is in the data, if one the diclofenac cohort does not have ‘Female’ records the `diclofenac_female` cohort is not going to be created, if we have individuals with sex ‘None’ then a `{cohort_name}_none` cohort will be created.

The function is very powerful and multiple cohorts can be created in one go, in this example we will create cohorts by “age and sex” and by “year”.
    
    
    cdm$stratified <- cdm$medications |>
      [addAge](https://darwin-eu.github.io/PatientProfiles/reference/addAge.html)(ageGroup = [list](https://rdrr.io/r/base/list.html)("child" = [c](https://rdrr.io/r/base/c.html)(0,17), "18_to_65" = [c](https://rdrr.io/r/base/c.html)(18,64), "65_and_over" = [c](https://rdrr.io/r/base/c.html)(65, Inf))) |>
      [addSex](https://darwin-eu.github.io/PatientProfiles/reference/addSex.html)() |>
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(year = [get_year](https://clock.r-lib.org/reference/clock-getters.html)(cohort_start_date)) |>
      [stratifyCohorts](../reference/stratifyCohorts.html)(strata = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)("sex", "age_group"), "year"), name = "stratified")
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$stratified)
    #> # A tibble: 232 × 3
    #>    cohort_definition_id number_records number_subjects
    #>                   <int>          <int>           <int>
    #>  1                    1           2941            2894
    #>  2                    2            380             370
    #>  3                    3           1397            1382
    #>  4                    4           2916            2857
    #>  5                    5            336             328
    #>  6                    6           1395            1373
    #>  7                    7            435             435
    #>  8                    8              0               0
    #>  9                    9              0               0
    #> 10                   10            395             395
    #> # ℹ 222 more rows
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$stratified)
    #> # A tibble: 232 × 11
    #>    cohort_definition_id cohort_name          target_cohort_id target_cohort_name
    #>                   <int> <chr>                           <int> <chr>             
    #>  1                    1 acetaminophen_femal…                1 acetaminophen     
    #>  2                    2 acetaminophen_femal…                1 acetaminophen     
    #>  3                    3 acetaminophen_femal…                1 acetaminophen     
    #>  4                    4 acetaminophen_male_…                1 acetaminophen     
    #>  5                    5 acetaminophen_male_…                1 acetaminophen     
    #>  6                    6 acetaminophen_male_…                1 acetaminophen     
    #>  7                    7 diclofenac_female_1…                2 diclofenac        
    #>  8                    8 diclofenac_female_6…                2 diclofenac        
    #>  9                    9 diclofenac_female_c…                2 diclofenac        
    #> 10                   10 diclofenac_male_18_…                2 diclofenac        
    #> # ℹ 222 more rows
    #> # ℹ 7 more variables: cdm_version <chr>, vocabulary_version <chr>,
    #> #   target_cohort_table_name <chr>, strata_columns <chr>, sex <chr>,
    #> #   age_group <chr>, year <dbl>

A total of 232 cohorts were created in one go, 12 related to sex & age group combination, and 220 by year.

Note that these year cohorts were created based on the prescription start date, but they can have end dates after that year. If you want to split the cohorts on yearly contributions see the next section.

## yearCohorts

`[yearCohorts()](../reference/yearCohorts.html)` is a function that is used to split the contribution of a cohort into the different years that is spread across, let’s see this simple example:

![](a08_split_cohorts_files/figure-html/unnamed-chunk-9-1.png)

In this example we have an individual that has a cohort entry that starts on the ‘2010-05-01’ and ends on the ‘2012-06-12’ then its contributions will be split into three contributions:

  * From ‘2010-05-01’ to ‘2010-12-31’.
  * From ‘2011-01-01’ to ‘2011-12-31’.
  * From ‘2012-01-01’ to ‘2012-06-12’.



So let’s use it in one example:
    
    
    cdm$medications_year <- cdm$medications |>
      [yearCohorts](../reference/yearCohorts.html)(years = [c](https://rdrr.io/r/base/c.html)(1990:1993), name = "medications_year")
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$medications_year)
    #> # A tibble: 8 × 7
    #>   cohort_definition_id cohort_name        target_cohort_definition…¹ cdm_version
    #>                  <int> <chr>                                   <int> <chr>      
    #> 1                    1 acetaminophen_1990                          1 5.3        
    #> 2                    2 diclofenac_1990                             2 5.3        
    #> 3                    3 acetaminophen_1991                          1 5.3        
    #> 4                    4 diclofenac_1991                             2 5.3        
    #> 5                    5 acetaminophen_1992                          1 5.3        
    #> 6                    6 diclofenac_1992                             2 5.3        
    #> 7                    7 acetaminophen_1993                          1 5.3        
    #> 8                    8 diclofenac_1993                             2 5.3        
    #> # ℹ abbreviated name: ¹​target_cohort_definition_id
    #> # ℹ 3 more variables: vocabulary_version <chr>, year <int>,
    #> #   target_cohort_name <chr>
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications_year)
    #> # A tibble: 8 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1            200             191
    #> 2                    2             16              16
    #> 3                    3            196             191
    #> 4                    4             12              12
    #> 5                    5            201             194
    #> 6                    6             13              13
    #> 7                    7            211             207
    #> 8                    8             15              15

Note we could choose the years of interest and that invididuals. Let’s look closer to one of the individuals (`person_id = 4383`) that has 6 records:
    
    
    cdm$medications |> 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id == 4383)
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/Rtmp5jJxPo/file29f454de3f40.duckdb]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date sex  
    #>                  <int>      <int> <date>            <date>          <chr>
    #> 1                    1       4383 1990-12-20        1991-01-03      Male 
    #> 2                    1       4383 2004-05-21        2004-06-11      Male 
    #> 3                    1       4383 1990-10-13        1990-10-27      Male 
    #> 4                    1       4383 2000-03-12        2000-03-19      Male 
    #> 5                    1       4383 1971-02-06        1971-02-13      Male 
    #> 6                    1       4383 1992-07-18        1992-08-22      Male

From the 6 records only 3 are within our period of interest `1990-1993`, there are two contributions that start and end in the same year that’s why they are going to be unaltered and just assigned to the year of interest. But one of the cohort entries starts in 1990 and ends in 1991, then their contribution will be split into the two years, so we expect to see 4 cohort contributions for this subject (2 in 1990, 1 in 1991 and 1 in 1992):
    
    
    cdm$medications_year |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(subject_id == 4383)
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/Rtmp5jJxPo/file29f454de3f40.duckdb]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date sex  
    #>                  <int>      <int> <date>            <date>          <chr>
    #> 1                    1       4383 1990-12-20        1990-12-31      Male 
    #> 2                    1       4383 1990-10-13        1990-10-27      Male 
    #> 3                    3       4383 1991-01-01        1991-01-03      Male 
    #> 4                    5       4383 1992-07-18        1992-08-22      Male

Let’s disconnect from our cdm object to finish.
    
    
    [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/articles/a09_combine_cohorts.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Combining Cohorts

Source: [`vignettes/a09_combine_cohorts.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a09_combine_cohorts.Rmd)

`a09_combine_cohorts.Rmd`
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))

For this example we’ll use the Eunomia synthetic data from the CDMConnector package.
    
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", 
                        writeSchema = [c](https://rdrr.io/r/base/c.html)(prefix = "my_study_", schema = "main"))

Let’s start by creating two drug cohorts, one for users of diclofenac and another for users of acetaminophen.
    
    
    cdm$medications <- [conceptCohort](../reference/conceptCohort.html)(cdm = cdm, 
                                     conceptSet = [list](https://rdrr.io/r/base/list.html)("diclofenac" = 1124300,
                                                       "acetaminophen" = 1127433), 
                                     name = "medications")
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medications)
    #> # A tibble: 2 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           9365            2580
    #> 2                    2            830             830

To check whether there is an overlap between records in both cohorts using the function `[intersectCohorts()](../reference/intersectCohorts.html)`.
    
    
    cdm$medintersect <- [intersectCohorts](../reference/intersectCohorts.html)(
      cohort = cdm$medications,
      name = "medintersect"
    )
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medintersect)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1              6               6

There are 6 individuals who had overlapping records in the diclofenac and acetaminophen cohorts.

We can choose the number of days between cohort entries using the `gap` argument.
    
    
    cdm$medintersect <- [intersectCohorts](../reference/intersectCohorts.html)(
      cohort = cdm$medications,
      gap = 365,
      name = "medintersect"
    )
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medintersect)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1             94              94

There are 94 individuals who had overlapping records (within 365 days) in the diclofenac and acetaminophen cohorts.

We can also combine different cohorts using the function `[unionCohorts()](../reference/unionCohorts.html)`.
    
    
    cdm$medunion <- [unionCohorts](../reference/unionCohorts.html)(
      cohort = cdm$medications,
      name = "medunion"
    )
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medunion)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1          10189            2605

We have now created a new cohort which includes individuals in either the diclofenac cohort or the acetaminophen cohort.

You can keep the original cohorts in the new table if you use the argument `keepOriginalCohorts = TRUE`.
    
    
    cdm$medunion <- [unionCohorts](../reference/unionCohorts.html)(
      cohort = cdm$medications,
      name = "medunion",
      keepOriginalCohorts = TRUE
    )
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medunion)
    #> # A tibble: 3 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           9365            2580
    #> 2                    2            830             830
    #> 3                    3          10189            2605

You can also choose the number of days between two subsequent cohort entries to be merged using the `gap` argument.
    
    
    cdm$medunion <- [unionCohorts](../reference/unionCohorts.html)(
      cohort = cdm$medications,
      name = "medunion",
      gap = 365,
      keepOriginalCohorts = TRUE
    )
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$medunion)
    #> # A tibble: 3 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           9365            2580
    #> 2                    2            830             830
    #> 3                    3           9682            2605

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/articles/a10_match_cohorts.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Generating a matched cohort

Source: [`vignettes/a10_match_cohorts.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a10_match_cohorts.Rmd)

`a10_match_cohorts.Rmd`

## Introduction

CohortConstructor packages includes a function to obtain an age and sex matched cohort, the `[matchCohorts()](../reference/matchCohorts.html)` function. In this vignette, we will explore the usage of this function.

### Create mock data

We will first use `mockDrugUtilisation()` function from DrugUtilisation package to create mock data.
    
    
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    cdm <- [mockCohortConstructor](../reference/mockCohortConstructor.html)(nPerson = 1000)

As we will use `cohort1` to explore `[matchCohorts()](../reference/matchCohorts.html)`, let us first use `[settings()](https://darwin-eu.github.io/omopgenerics/reference/settings.html)` from omopgenerics package to explore this cohort:
    
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort1)

## Use matchCohorts() to create an age-sex matched cohort

Let us first see an example of how this function works. For its usage, we need to provide a `cdm` object, the `targetCohortName`, which is the name of the table containing the cohort of interest, and the `name` of the new generated tibble containing the cohort and the matched cohort. We will also use the argument `targetCohortId` to specify that we only want a matched cohort for `cohort_definition_id = 1`.
    
    
    cdm$matched_cohort1 <- [matchCohorts](../reference/matchCohorts.html)(
      cohort = cdm$cohort1,
      cohortId = 1,
      name = "matched_cohort1")
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$matched_cohort1)

Notice that in the generated tibble, there are two cohorts: `cohort_definition_id = 1` (original cohort), and `cohort_definition_id = 4` (matched cohort). _target_cohort_name_ column indicates which is the original cohort. _match_sex_ and _match_year_of_birth_ adopt boolean values (`TRUE`/`FALSE`) indicating if we have matched for sex and age, or not. _match_status_ indicate if it is the original cohort (`target`) or if it is the matched cohort (`matched`). _target_cohort_id_ indicates which is the cohort_id of the original cohort.

Check the exclusion criteria applied to generate the new cohorts by using `[attrition()](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)` from omopgenerics package:
    
    
    # Original cohort
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$matched_cohort1) |> [filter](https://dplyr.tidyverse.org/reference/filter.html)(cohort_definition_id == 1)
    
    # Matched cohort
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$matched_cohort1) |> [filter](https://dplyr.tidyverse.org/reference/filter.html)(cohort_definition_id == 4)

Briefly, from the original cohort, we exclude first those individuals that do not have a match, and then individuals that their matching pair is not in observation during the assigned _cohort_start_date_. From the matched cohort, we start from the whole database and we first exclude individuals that are in the original cohort. Afterwards, we exclude individuals that do not have a match, then individuals that are not in observation during the assigned _cohort_start_date_ , and finally we remove as many individuals as required to fulfill the ratio.

Notice that matching pairs are randomly assigned, so it is probable that every time you execute this function, the generated cohorts change. Use `[set.seed()](https://rdrr.io/r/base/Random.html)` to avoid this.

### matchSex parameter

`matchSex` is a boolean parameter (`TRUE`/`FALSE`) indicating if we want to match by sex (`TRUE`) or we do not want to (`FALSE`).

### matchYear parameter

`matchYear` is another boolean parameter (`TRUE`/`FALSE`) indicating if we want to match by age (`TRUE`) or we do not want (`FALSE`).

Notice that if `matchSex = FALSE` and `matchYear = FALSE`, we will obtain an unmatched comparator cohort.

### ratio parameter

The default matching ratio is 1:1 (`ratio = 1`). Use `[cohortCount()](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)` from CDMConnector to check if the matching has been done as desired.
    
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$matched_cohort1)

You can modify the `ratio` parameter to tailor your matched cohort. `ratio` can adopt values from 1 to Inf.
    
    
    cdm$matched_cohort2 <- [matchCohorts](../reference/matchCohorts.html)(
      cohort = cdm$cohort1,
      cohortId = 1,
      name = "matched_cohort2",
      ratio = Inf)
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$matched_cohort2)

### Generate matched cohorts simultaneously across multiple cohorts

All these functionalities can be implemented across multiple cohorts simultaneously. Specify in `targetCohortId` parameter which are the cohorts of interest. If set to NULL, all the cohorts present in `targetCohortName` will be matched.
    
    
    cdm$matched_cohort3 <- [matchCohorts](../reference/matchCohorts.html)(
      cohort = cdm$cohort1,
      cohortId = [c](https://rdrr.io/r/base/c.html)(1,3),
      name = "matched_cohort3",
      ratio = 2)
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$matched_cohort3) |> [arrange](https://dplyr.tidyverse.org/reference/arrange.html)(cohort_definition_id)
    
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$matched_cohort3) |> [arrange](https://dplyr.tidyverse.org/reference/arrange.html)(cohort_definition_id)

Notice that each cohort has their own (and independent of other cohorts) matched cohort.

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/articles/a11_benchmark.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# CohortConstructor benchmarking results

Source: [`vignettes/a11_benchmark.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a11_benchmark.Rmd)

`a11_benchmark.Rmd`

## Introduction

Cohorts are a fundamental building block for studies that use the OMOP CDM, identifying people who satisfy one or more inclusion criteria for a duration of time based on their clinical records. Currently cohorts are typically built using [CIRCE](https://github.com/OHDSI/circe-be) which allows complex cohorts to be represented using JSON. This JSON is then converted to SQL for execution against a database containing data mapped to the OMOP CDM. CIRCE JSON can be created via the [ATLAS](https://github.com/OHDSI/Atlas) GUI or programmatically via the [Capr](https://github.com/OHDSI/Capr) R package. However, although a powerful tool for expressing and operationalising cohort definitions, the SQL generated can be cumbersome especially for complex cohort definitions, moreover cohorts are instantiated independently, leading to duplicated work.

The CohortConstructor package offers an alternative approach, emphasising cohort building in a pipeline format. It first creates base cohorts and then applies specific inclusion criteria. Unlike the “by definition” approach, where cohorts are built independently, CohortConstructor follows a “by domain/ table” approach, which minimises redundant queries to large OMOP tables. More details on this approach can be found in the [Introduction vignette](https://ohdsi.github.io/CohortConstructor/articles/a00_introduction.html).

To test the performance of the package there is a benchmarking function which uses nine phenotypes from the [OHDSI Phenotype library](https://github.com/OHDSI/PhenotypeLibrary) that cover a range of concept domains, entry and inclusion criteria, and cohort exit options. We replicated these cohorts using CohortConstructor to assess computational time and agreement between CIRCE and CohortConstructor.
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", writeSchema = "main", 
                      writePrefix = "my_study_")

Once we have created our cdm reference we can run the benchmark. Once run we’ll have a set of results with the time taken to run the different tasks. For this example we will just run task of creating all the cohorts at once using CohortConstructor.
    
    
    benchmark_results <- [benchmarkCohortConstructor](../reference/benchmarkCohortConstructor.html)(
      cdm,
      runCIRCE = FALSE,
      runCohortConstructorDefinition = FALSE,
      runCohortConstructorDomain = TRUE
    )
    #> cc_set_no_strata: 108.911 sec elapsed
    #> cc_set_strata: 1.702 sec elapsed
    benchmark_results |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 297
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9,…
    #> $ cdm_name         <chr> "Synthea", "Synthea", "Synthea", "Synthea", "Synthea"…
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "cc_asthma_no_copd", "cc_asthma_no_copd", "cc_beta_bl…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "number_records", "number_subjects", "number_records"…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "count", "count", "count", "count", "count", "count",…
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "101", "101", "0", "0", "0", "0", "0", "0", "1037", "…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…

### Collaboration

If you are interested in running the code on your database, feel free to reach out to us for assistance, and we can also update the vignette with your results! :)

The benchmark script was executed against the following databases:

  * **CPRD Gold** : A primary care database from the UK, capturing data mostly from Northern Ireland, Wales, and Scotland clinics. The benchmark utilized a 100,000-person sample from this dataset, which is managed using PostgreSQL.

  * **CPRD Aurum** : Another UK primary care database, primarily covering clinics in England. This database is managed on SQL Server.

  * **Coriva** : A sample of approximately 400,000 patients from the Estonia National Health Insurance database, managed on PostgreSQL.

  * **OHDSI SQL Server** : A mock OMOP CDM dataset provided by OHDSI, hosted on SQL Server.




The table below presents the number of records in the OMOP tables used in the benchmark script for each of the participating databases.

OMOP table |  Database  
---|---  
CPRD Aurum | CORIVA-Estonia | CPRD Gold 100k | OHDSI Postgres server | OHDSI redshift | OHDSI snowflake | OHDSI SQL server  
person | 47,193,158 | 438,433 | 100,000 | 1,000 | 1,000 | 116,352 | 1,000  
observation_period | 47,193,158 | 438,433 | 100,000 | 1,048 | 1,000 | 104,891 | 1,048  
drug_exposure | 3,256,609,138 | 31,265,445 | 12,403,195 | 49,542 | 57,095 | 6,303,388 | 49,542  
condition_occurrence | 2,110,992,846 | 40,957,155 | 3,191,739 | 160,322 | 147,186 | 14,455,993 | 160,322  
procedure_occurrence | 2,267,113,392 | 14,545,615 | 1,914,271 | 62,189 | 137,522 | 13,926,771 | 62,189  
visit_occurrence | 7,091,248,835 | 38,037,330 | 9,183,206 | 47,457 | 55,261 | 5,579,542 | 47,457  
measurement | 8,255,241,316 | 39,378,570 | 10,913,588 | 2,858 | 34,556 | 3,704,839 | 2,858  
observation | 16,425,069,199 | 37,010,044 | 11,107,039 | 13,481 | 19,339 | 1,876,834 | 13,481  
  
## Cohorts

We replicated the following cohorts from the OHDSI phenotype library: COVID-19 (ID 56), inpatient hospitalisation (23), new users of beta blockers nested in essential hypertension (1049), transverse myelitis (63), major non cardiac surgery (1289), asthma without COPD (27), endometriosis procedure (722), new fluoroquinolone users (1043), acquired neutropenia or unspecified leukopenia (213).

The COVID-19 cohort was used to evaluate the performance of common cohort stratifications. To compare the package with CIRCE, we created definitions in Atlas, stratified by age groups and sex, which are available in the [benchmark GitHub repository](https://github.com/oxford-pharmacoepi/BenchmarkCohortConstructor/tree/main/JSONCohorts) with the benchmark code.

### Cohort counts and overlap

The following table displays the number of records and subjects for each cohort across the participating databases:

|  Tool  
---|---  
Cohort name |  CIRCE |  CohortConstructor  
Number records | Number subjects | Number records | Number subjects  
CPRD Aurum  
Acquired neutropenia or unspecified leukopenia | 1,429,966 | 632,966 | 1,302,498 | 633,030  
Asthma without COPD | 4,009,925 | 4,009,925 | 3,934,106 | 3,934,106  
COVID-19 | 5,600,429 | 4,452,410 | 6,206,907 | 4,452,196  
COVID-19: female | 3,111,643 | 2,434,062 | 3,452,138 | 2,438,759  
COVID-19: female, 0 to 50 | 2,172,113 | 1,730,180 | 2,382,039 | 1,730,116  
COVID-19: female, 51 to 150 | 939,818 | 708,838 | 1,070,099 | 708,643  
COVID-19: male | 2,488,786 | 2,018,348 | 2,754,769 | 2,020,625  
COVID-19: male, 0 to 50 | 1,709,375 | 1,422,999 | 1,862,219 | 1,422,962  
COVID-19: male, 51 to 150 | 779,629 | 597,804 | 892,550 | 597,663  
Endometriosis procedure | 139 | 108 | 77 | 77  
Inpatient hospitalisation | 0 | 0 | 0 | 0  
Major non cardiac surgery | 1,932,745 | 1,932,745 | 1,932,745 | 1,932,745  
New fluoroquinolone users | 1,765,274 | 1,765,274 | 1,817,439 | 1,817,439  
New users of beta blockers nested in essential hypertension | 98,592 | 98,592 | 102,589 | 102,589  
Transverse myelitis | 11,930 | 4,040 | 5,818 | 4,119  
CORIVA-Estonia  
Acquired neutropenia or unspecified leukopenia | 2,231 | 634 | 2,188 | 634  
Asthma without COPD | 25,867 | 25,867 | 25,867 | 25,867  
COVID-19 | 421,053 | 193,435 | 435,059 | 193,435  
COVID-19: female | 235,740 | 105,849 | 243,773 | 106,322  
COVID-19: female, 0 to 50 | 150,121 | 69,168 | 155,256 | 69,168  
COVID-19: female, 51 to 150 | 85,620 | 37,154 | 88,517 | 37,154  
COVID-19: male | 185,313 | 87,586 | 191,286 | 87,891  
COVID-19: male, 0 to 50 | 130,252 | 63,558 | 134,415 | 63,558  
COVID-19: male, 51 to 150 | 55,062 | 24,333 | 56,871 | 24,333  
Endometriosis procedure | 0 | 0 | 0 | 0  
Inpatient hospitalisation | 267,010 | 133,705 | 267,010 | 133,705  
Major non cardiac surgery | 4,025 | 4,025 | 4,025 | 4,025  
New fluoroquinolone users | 39,712 | 39,712 | 39,712 | 39,712  
New users of beta blockers nested in essential hypertension | 18,967 | 18,967 | 18,967 | 18,967  
Transverse myelitis | 27 | 10 | 12 | 10  
CPRD Gold 100k  
Acquired neutropenia or unspecified leukopenia | 2,719 | 1,167 | 2,675 | 1,167  
Asthma without COPD | 8,808 | 8,808 | 8,741 | 8,741  
COVID-19 | 3,231 | 2,881 | 3,275 | 2,881  
COVID-19: female | 1,748 | 1,543 | 1,771 | 1,543  
COVID-19: female, 0 to 50 | 1,271 | 1,125 | 1,291 | 1,125  
COVID-19: female, 51 to 150 | 477 | 418 | 480 | 418  
COVID-19: male | 1,483 | 1,338 | 1,504 | 1,341  
COVID-19: male, 0 to 50 | 1,054 | 960 | 1,072 | 960  
COVID-19: male, 51 to 150 | 429 | 381 | 432 | 381  
Endometriosis procedure | 0 | 0 | 0 | 0  
Inpatient hospitalisation | 0 | 0 | 0 | 0  
Major non cardiac surgery | 4,146 | 4,146 | 4,146 | 4,146  
New fluoroquinolone users | 5,412 | 5,412 | 5,412 | 5,412  
New users of beta blockers nested in essential hypertension | 1,723 | 1,723 | 1,723 | 1,723  
Transverse myelitis | 31 | 11 | 15 | 11  
OHDSI Postgres server  
Acquired neutropenia or unspecified leukopenia | 151 | 86 | 106 | 86  
Asthma without COPD | 126 | 126 | 126 | 126  
COVID-19 | 0 | 0 | 0 | 0  
COVID-19: female | 0 | 0 | 0 | 0  
COVID-19: female, 0 to 50 | 0 | 0 | 0 | 0  
COVID-19: female, 51 to 150 | 0 | 0 | 0 | 0  
COVID-19: male | 0 | 0 | 0 | 0  
COVID-19: male, 0 to 50 | 0 | 0 | 0 | 0  
COVID-19: male, 51 to 150 | 0 | 0 | 0 | 0  
Endometriosis procedure | 0 | 0 | 0 | 0  
Inpatient hospitalisation | 522 | 321 | 522 | 321  
Major non cardiac surgery | 88 | 88 | 92 | 92  
New fluoroquinolone users | 145 | 145 | 145 | 145  
New users of beta blockers nested in essential hypertension | 112 | 112 | 112 | 112  
Transverse myelitis | 0 | 0 | 0 | 0  
OHDSI redshift  
Acquired neutropenia or unspecified leukopenia | 155 | 88 | 108 | 88  
Asthma without COPD | 228 | 228 | 228 | 228  
COVID-19 | 0 | 0 | 0 | 0  
COVID-19: female | 0 | 0 | 0 | 0  
COVID-19: female, 0 to 50 | 0 | 0 | 0 | 0  
COVID-19: female, 51 to 150 | 0 | 0 | 0 | 0  
COVID-19: male | 0 | 0 | 0 | 0  
COVID-19: male, 0 to 50 | 0 | 0 | 0 | 0  
COVID-19: male, 51 to 150 | 0 | 0 | 0 | 0  
Endometriosis procedure | 0 | 0 | 0 | 0  
Inpatient hospitalisation | 612 | 365 | 612 | 365  
Major non cardiac surgery | 616 | 616 | 613 | 613  
New fluoroquinolone users | 109 | 109 | 109 | 109  
New users of beta blockers nested in essential hypertension | 25 | 25 | 25 | 25  
Transverse myelitis | - | - | - | -  
OHDSI snowflake  
Acquired neutropenia or unspecified leukopenia | 13,960 | 8,525 | 10,147 | 8,525  
Asthma without COPD | 24,288 | 24,288 | 24,291 | 24,291  
COVID-19 | 0 | 0 | 0 | 0  
COVID-19: female | 0 | 0 | 0 | 0  
COVID-19: female, 0 to 50 | 0 | 0 | 0 | 0  
COVID-19: female, 51 to 150 | 0 | 0 | 0 | 0  
COVID-19: male | 0 | 0 | 0 | 0  
COVID-19: male, 0 to 50 | 0 | 0 | 0 | 0  
COVID-19: male, 51 to 150 | 0 | 0 | 0 | 0  
Endometriosis procedure | - | - | 0 | 0  
Inpatient hospitalisation | 64,275 | 37,780 | 64,275 | 37,780  
Major non cardiac surgery | 66,171 | 66,171 | 66,034 | 66,034  
New fluoroquinolone users | 14,203 | 14,203 | 13,398 | 13,398  
New users of beta blockers nested in essential hypertension | 2,022 | 2,022 | 2,028 | 2,028  
Transverse myelitis | 102 | 43 | 42 | 42  
OHDSI SQL server  
Acquired neutropenia or unspecified leukopenia | 151 | 86 | 106 | 86  
Asthma without COPD | 126 | 126 | 126 | 126  
COVID-19 | 0 | 0 | 0 | 0  
COVID-19: female | 0 | 0 | 0 | 0  
COVID-19: female, 0 to 50 | 0 | 0 | 0 | 0  
COVID-19: female, 51 to 150 | 0 | 0 | 0 | 0  
COVID-19: male | 0 | 0 | 0 | 0  
COVID-19: male, 0 to 50 | 0 | 0 | 0 | 0  
COVID-19: male, 51 to 150 | 0 | 0 | 0 | 0  
Endometriosis procedure | 0 | 0 | 0 | 0  
Inpatient hospitalisation | 522 | 321 | 522 | 321  
Major non cardiac surgery | 88 | 88 | 92 | 92  
New fluoroquinolone users | 145 | 145 | 145 | 145  
New users of beta blockers nested in essential hypertension | 112 | 112 | 112 | 112  
Transverse myelitis | 0 | 0 | 0 | 0  
  
We also computed the overlap between patients in CIRCE and CohortConstructor cohorts, with results shown in the plot below:

![](a11_benchmark_files/figure-html/unnamed-chunk-8-1.png)

## Performance

To evaluate CohortConstructor performance we generated each of the CIRCE cohorts using functionalities provided by both CodelistGenerator and CohortConstructor, and measured the computational time taken.

Two different approaches with CohortConstructor were tested:

  * _By definition_ : we created each of the cohorts seprately.

  * _By domain_ : All nine targeted cohorts were created together in a set, following the by domain approach described in the [Introduction vignette](https://ohdsi.github.io/CohortConstructor/articles/a00_introduction.html). Briefly, this approach involves creating all base cohorts at once, requiring only one call to each involved OMOP table.




### By definition

The following plot shows the times taken to create each cohort using CIRCE and CohortConstructor when each cohorts were created separately.

![](a11_benchmark_files/figure-html/unnamed-chunk-10-1.png)

### By domain

The table below depicts the total time it took to create the nine cohorts when using the _by domain_ approach for CohortConstructor.

Database_name |  Time (minutes)  
---|---  
CIRCE | CohortConstructor  
CORIVA-Estonia | 9.51 | 9.95  
CPRD Aurum | 3,288.11 | 109.08  
CPRD Gold 100k | 73.41 | 7.85  
OHDSI Postgres server | 4.32 | 29.20  
OHDSI SQL server | 2.89 | 18.56  
OHDSI redshift | 5.44 | 34.05  
OHDSI snowflake | 11.40 | 84.56  
  
### Cohort stratification

Cohorts are often stratified in studies. With Atlas cohort definitions, each stratum requires a new CIRCE JSON to be instantiated, while CohortConstructor allows stratifications to be generated from an overall cohort. The following table shows the time taken to create age and sex stratifications for the COVID-19 cohort with both CIRCE and CohortConstructor.

Database |  Time (minutes)  
---|---  
CIRCE | CohortConstructor  
CORIVA-Estonia | 14.38 | 23.51  
CPRD Aurum | 3,300.18 | 241.81  
CPRD Gold 100k | 166.66 | 19.52  
OHDSI Postgres server | 6.75 | 73.24  
OHDSI SQL server | 4.56 | 46.64  
OHDSI redshift | 8.32 | 84.79  
OHDSI snowflake | 17.04 | 202.95  
  
## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/articles/a12_behind_the_scenes.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Behind the scenes

Source: [`vignettes/a12_behind_the_scenes.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a12_behind_the_scenes.Rmd)

`a12_behind_the_scenes.Rmd`

In previous vignettes we have seen numerous R functions that can help us to add a cohort of interest to a cdm reference. When our cdm reference is to tables in a database, as is often the code, our R code will have been translated to SQL that is run against tables in the databases (for more details on how this is all implemented see <https://oxford-pharmacoepi.github.io/Tidy-R-programming-with-OMOP/>).

Let’s again work with Eunomia and get the codes needed to create a set of drug cohorts.
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(),
                     dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", writeSchema = "main", 
                      writePrefix = "my_study_")
    drug_codes <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(cdm, 
                                         name = [c](https://rdrr.io/r/base/c.html)("acetaminophen",
                                                  "amoxicillin", 
                                                  "diclofenac", 
                                                  "simvastatin",
                                                  "warfarin"))

To capture all the SQL executed as we use CohortConstructor functions we can set a global option. For this, we just need to point to a directory in which we’ll save each SQL statement run behind the scenes. Note that in this example we’re using duckdb so the SQL is for this database management system. If you were running on a different type of database the SQL would be adapted accordingly.
    
    
    dir_sql <- [file.path](https://rdrr.io/r/base/file.path.html)([tempdir](https://rdrr.io/r/base/tempfile.html)(), "sql_folder")
    [dir.create](https://rdrr.io/r/base/files2.html)(dir_sql)
    [options](https://rdrr.io/r/base/options.html)("omopgenerics.log_sql_path" = dir_sql)
    
    cdm$drugs <- [conceptCohort](../reference/conceptCohort.html)(cdm, 
                               conceptSet = drug_codes,
                               exit = "event_end_date",
                               name = "drugs")
    
    # print sql in order they were saved
    files <- [file.info](https://rdrr.io/r/base/file.info.html)([list.files](https://rdrr.io/r/base/list.files.html)(dir_sql, full.names = TRUE))
    sorted_files <- [rownames](https://rdrr.io/r/base/colnames.html)(files[[order](https://rdrr.io/r/base/order.html)(files$ctime),])
    for(i in [seq_along](https://rdrr.io/r/base/seq.html)(sorted_files)) {
      [cat](https://rdrr.io/r/base/cat.html)([paste0](https://rdrr.io/r/base/paste.html)("### ", sorted_files[i], "\n\n"))
      sql_with_quotes <- [paste0](https://rdrr.io/r/base/paste.html)('"', [paste](https://rdrr.io/r/base/paste.html)([readLines](https://rdrr.io/r/base/readLines.html)(sorted_files[i]), collapse = '\n'), '"')
      [cat](https://rdrr.io/r/base/cat.html)(sql_with_quotes, "\n```\n\n")
    }
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00003_on_2025_09_19_at_08_25_11.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: tmp_001_og_004_1758270312
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_uploadCohortCodelist
    #> <SQL>
    #> SELECT
    #>   cohort_definition_id,
    #>   CAST(concept_id AS INTEGER) AS concept_id,
    #>   LOWER(domain_id) AS domain_id
    #> FROM (
    #>   SELECT my_study_tmp_001_og_004_1758270312.*, domain_id
    #>   FROM my_study_tmp_001_og_004_1758270312
    #>   LEFT JOIN concept
    #>     ON (my_study_tmp_001_og_004_1758270312.concept_id = concept.concept_id)
    #> ) q01" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00004_on_2025_09_19_at_08_25_12.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: og_005_1758270312_1
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_tempCohort_
    #> <SQL>
    #> SELECT
    #>   person_id AS subject_id,
    #>   drug_concept_id AS concept_id,
    #>   drug_exposure_start_date AS cohort_start_date,
    #>   drug_exposure_end_date AS cohort_end_date,
    #>   cohort_definition_id
    #> FROM drug_exposure
    #> INNER JOIN (
    #>   SELECT concept_id, cohort_definition_id
    #>   FROM my_study_tmp_001_og_004_1758270312
    #>   WHERE (domain_id IN ('drug'))
    #> ) RHS
    #>   ON (drug_exposure.drug_concept_id = RHS.concept_id)" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00005_on_2025_09_19_at_08_25_12.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: drugs
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_conceptCohort_reduce_
    #> <SQL>
    #> SELECT
    #>   cohort_definition_id,
    #>   subject_id,
    #>   cohort_start_date,
    #>   COALESCE(cohort_end_date, cohort_start_date) AS cohort_end_date
    #> FROM my_study_og_005_1758270312_1" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00006_on_2025_09_19_at_08_25_12.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: drugs
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_fulfillCohortReqs_observationJoin_
    #> <SQL>
    #> SELECT
    #>   my_study_drugs.*,
    #>   observation_period_id,
    #>   observation_period_start_date,
    #>   observation_period_end_date
    #> FROM my_study_drugs
    #> LEFT JOIN observation_period
    #>   ON (my_study_drugs.subject_id = observation_period.person_id)" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00007_on_2025_09_19_at_08_25_13.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: drugs
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_fulfillCohortReqs_useRecordsBeforeObservation_
    #> <SQL>
    #> SELECT
    #>   cohort_definition_id,
    #>   subject_id,
    #>   cohort_start_date,
    #>   CASE WHEN (observation_period_end_date >= cohort_end_date) THEN cohort_end_date WHEN NOT (observation_period_end_date >= cohort_end_date) THEN observation_period_end_date END AS cohort_end_date
    #> FROM my_study_drugs
    #> WHERE
    #>   (cohort_start_date >= observation_period_start_date) AND
    #>   (cohort_start_date <= observation_period_end_date)" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00008_on_2025_09_19_at_08_25_13.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: drugs
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_fulfillCohortReqs_filterStartEnd_
    #> <SQL>
    #> SELECT my_study_drugs.*
    #> FROM my_study_drugs
    #> WHERE
    #>   (NOT((cohort_start_date IS NULL))) AND
    #>   (cohort_start_date <= cohort_end_date)" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00009_on_2025_09_19_at_08_25_14.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: drugs
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_fulfillCohortReqs_sex_
    #> <SQL>
    #> SELECT q01.*
    #> FROM (
    #>   SELECT my_study_drugs.*, gender_concept_id, year_of_birth
    #>   FROM my_study_drugs
    #>   INNER JOIN person
    #>     ON (my_study_drugs.subject_id = person.person_id)
    #> ) q01
    #> WHERE (NOT((gender_concept_id IS NULL)))" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00010_on_2025_09_19_at_08_25_15.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: drugs
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_fulfillCohortReqs_birth_year_
    #> <SQL>
    #> SELECT cohort_definition_id, subject_id, cohort_start_date, cohort_end_date
    #> FROM my_study_drugs
    #> WHERE (NOT((year_of_birth IS NULL)))" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00011_on_2025_09_19_at_08_25_15.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: og_006_1758270316
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_joinOverlap_workingTbl_
    #> <SQL>
    #> SELECT q01.*, -1.0 AS date_id
    #> FROM (
    #>   SELECT cohort_definition_id, subject_id, cohort_start_date AS date
    #>   FROM my_study_drugs
    #> ) q01
    #> 
    #> UNION ALL
    #> 
    #> SELECT q01.*, 1.0 AS date_id
    #> FROM (
    #>   SELECT cohort_definition_id, subject_id, cohort_end_date AS date
    #>   FROM my_study_drugs
    #> ) q01" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00012_on_2025_09_19_at_08_25_15.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: og_006_1758270316
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_joinOverlap_ids_
    #> <SQL>
    #> SELECT
    #>   cohort_definition_id,
    #>   subject_id,
    #>   SUM(CAST(era_id AS NUMERIC)) OVER (PARTITION BY cohort_definition_id, subject_id ORDER BY date, date_id ROWS UNBOUNDED PRECEDING) AS era_id,
    #>   "name",
    #>   date
    #> FROM (
    #>   SELECT
    #>     my_study_og_006_1758270316.*,
    #>     SUM(date_id) OVER (PARTITION BY cohort_definition_id, subject_id ORDER BY date, date_id ROWS UNBOUNDED PRECEDING) AS cum_id,
    #>     CASE WHEN (date_id = -1.0) THEN 'cohort_start_date' WHEN NOT (date_id = -1.0) THEN 'cohort_end_date' END AS "name",
    #>     CASE WHEN (date_id = -1.0) THEN 1.0 WHEN NOT (date_id = -1.0) THEN 0.0 END AS era_id
    #>   FROM my_study_og_006_1758270316
    #> ) q01
    #> WHERE (cum_id = 0.0 OR (cum_id = -1.0 AND date_id = -1.0))" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00013_on_2025_09_19_at_08_25_16.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: og_006_1758270316
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_joinOverlap_pivot_wider_
    #> <SQL>
    #> SELECT
    #>   cohort_definition_id,
    #>   subject_id,
    #>   MAX(CASE WHEN ("name" = 'cohort_start_date') THEN date END) AS cohort_start_date,
    #>   MAX(CASE WHEN ("name" = 'cohort_end_date') THEN date END) AS cohort_end_date
    #> FROM my_study_og_006_1758270316
    #> GROUP BY cohort_definition_id, subject_id, era_id" 
    #> ```
    #> 
    #> ### /tmp/RtmpU2tOK6/sql_folder/logged_query_00014_on_2025_09_19_at_08_25_16.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: drugs
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_joinOverlap_relocate_
    #> <SQL>
    #> SELECT DISTINCT my_study_og_006_1758270316.*
    #> FROM my_study_og_006_1758270316" 
    #> ```

If we want even more detail, we also have the option to see the execution plan along with the SQL.
    
    
    dir_explain <- [file.path](https://rdrr.io/r/base/file.path.html)([tempdir](https://rdrr.io/r/base/tempfile.html)(), "explain_folder")
    [dir.create](https://rdrr.io/r/base/files2.html)(dir_explain)
    [options](https://rdrr.io/r/base/options.html)("omopgenerics.log_sql_explain_path" = dir_explain)
    
    cdm$drugs <- cdm$drugs |> 
      [requireIsFirstEntry](../reference/requireIsFirstEntry.html)()
    
    files <- [list.files](https://rdrr.io/r/base/list.files.html)(dir_explain, full.names = TRUE)
    file_names <- [list.files](https://rdrr.io/r/base/list.files.html)(dir_explain, full.names = FALSE)
    
    for(i in [seq_along](https://rdrr.io/r/base/seq.html)(files)) {
      [cat](https://rdrr.io/r/base/cat.html)([paste0](https://rdrr.io/r/base/paste.html)("### ", file_names[i], "\n\n"))
      sql_with_quotes <- [paste0](https://rdrr.io/r/base/paste.html)('"', [paste](https://rdrr.io/r/base/paste.html)([readLines](https://rdrr.io/r/base/readLines.html)(files[i]), collapse = '\n'), '"')
      [cat](https://rdrr.io/r/base/cat.html)(sql_with_quotes, "\n```\n\n")
    }
    #> ### logged_explain_00015_on_2025_09_19_at_08_25_18.sql
    #> 
    #> "type: compute
    #> schema: main
    #> prefix: my_study_
    #> name: drugs
    #> temporary: FALSE
    #> overwrite: TRUE
    #> log_prefix: CohortConstructor_requireIsFirstEntry_min_
    #> <SQL>
    #> SELECT cohort_definition_id, subject_id, cohort_start_date, cohort_end_date
    #> FROM (
    #>   SELECT
    #>     my_study_drugs.*,
    #>     MIN(cohort_start_date) OVER (PARTITION BY subject_id, cohort_definition_id) AS col01
    #>   FROM my_study_drugs
    #> ) q01
    #> WHERE (cohort_start_date = col01)
    #> 
    #> <PLAN>
    #> physical_plan
    #> ┌───────────────────────────┐
    #> │         PROJECTION        │
    #> │    ────────────────────   │
    #> │             #0            │
    #> │             #1            │
    #> │             #2            │
    #> │             #3            │
    #> │                           │
    #> │         ~3872 Rows        │
    #> └─────────────┬─────────────┘
    #> ┌─────────────┴─────────────┐
    #> │           FILTER          │
    #> │    ────────────────────   │
    #> │(cohort_start_date = col01)│
    #> │                           │
    #> │         ~3872 Rows        │
    #> └─────────────┬─────────────┘
    #> ┌─────────────┴─────────────┐
    #> │         PROJECTION        │
    #> │    ────────────────────   │
    #> │             #0            │
    #> │             #1            │
    #> │             #2            │
    #> │             #3            │
    #> │             #4            │
    #> │                           │
    #> │        ~19364 Rows        │
    #> └─────────────┬─────────────┘
    #> ┌─────────────┴─────────────┐
    #> │           WINDOW          │
    #> │    ────────────────────   │
    #> │        Projections:       │
    #> │   min(cohort_start_date)  │
    #> │     OVER (PARTITION BY    │
    #> │         subject_id,       │
    #> │    cohort_definition_id)  │
    #> └─────────────┬─────────────┘
    #> ┌─────────────┴─────────────┐
    #> │         SEQ_SCAN          │
    #> │    ────────────────────   │
    #> │   Table: my_study_drugs   │
    #> │   Type: Sequential Scan   │
    #> │                           │
    #> │        Projections:       │
    #> │    cohort_definition_id   │
    #> │         subject_id        │
    #> │     cohort_start_date     │
    #> │      cohort_end_date      │
    #> │                           │
    #> │        ~19364 Rows        │
    #> └───────────────────────────┘" 
    #> ```

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/news/index.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Changelog

Source: [`NEWS.md`](https://github.com/OHDSI/CohortConstructor/blob/main/NEWS.md)

## CohortConstructor 0.5.0

CRAN release: 2025-07-30

  * Speed up cohort creation step.
  * Allow cohort requirements to be applied relative to first entry.
  * Fix attrition bug in conceptCohort().



## CohortConstructor 0.4.0

CRAN release: 2025-05-08

  * Added a `NEWS.md` file to track changes to the package.



## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/conceptCohort.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Create cohorts based on a concept set

Source: [`R/conceptCohort.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/conceptCohort.R)

`conceptCohort.Rd`

`conceptCohort()` creates a cohort table from patient records from the clinical tables in the OMOP CDM.

The following tables are currently supported for creating concept cohorts:

  * condition_occurrence

  * device_exposure

  * drug_exposure

  * measurement

  * observation

  * procedure_occurrence

  * visit_occurrence




Cohort duration is based on record start and end (e.g. condition_start_date and condition_end_date for records coming from the condition_occurrence tables). So that the resulting table satisfies the requirements of an OMOP CDM cohort table:

  * Cohort entries will not overlap. Overlapping records will be combined based on the overlap argument.

  * Cohort entries will not go out of observation. If a record starts outside of an observation period it will be silently ignored. If a record ends outside of an observation period it will be trimmed so as to end at the preceding observation period end date.




## Usage
    
    
    conceptCohort(
      cdm,
      conceptSet,
      name,
      exit = "event_end_date",
      overlap = "merge",
      table = NULL,
      useRecordsBeforeObservation = FALSE,
      useSourceFields = FALSE,
      subsetCohort = NULL,
      subsetCohortId = NULL
    )

## Arguments

cdm
    

A cdm reference.

conceptSet
    

A conceptSet, which can either be a codelist or a conceptSetExpression.

name
    

Name of the new cohort table created in the cdm object.

exit
    

How the cohort end date is defined. Can be either "event_end_date" or "event_start_date".

overlap
    

How to deal with overlapping records. In all cases cohort start will be set as the earliest start date. If "merge", cohort end will be the latest end date. If "extend", cohort end date will be set by adding together the total days from each of the overlapping records.

table
    

Name of OMOP tables to search for records of the concepts provided. If NULL, each concept will be search at the assigned domain in the concept table.

useRecordsBeforeObservation
    

If FALSE, only records in observation will be used. If TRUE, records before the start of observation period will be considered, with cohort start date set as the start date of the individuals next observation period (as cohort records must be within observation).

useSourceFields
    

If TRUE, the source concept_id fields will also be used when identifying relevant clinical records. If FALSE, only the standard concept_id fields will be used.

subsetCohort
    

A character refering to a cohort table containing individuals for whom cohorts will be generated. Only individuals in this table will appear in the generated cohort.

subsetCohortId
    

Optional. Specifies cohort IDs from the `subsetCohort` table to include. If none are provided, all cohorts from the `subsetCohort` are included.

## Value

A cohort table

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(conditionOccurrence = TRUE, drugExposure = TRUE)
    
    cdm$cohort <- conceptCohort(cdm = cdm, conceptSet = [list](https://rdrr.io/r/base/list.html)(a = 444074), name = "cohort")
    #> Warning: ! `codelist` casted to integers.
    #> ℹ Subsetting table condition_occurrence using 1 concept with domain: condition.
    #> ℹ Combining tables.
    #> ℹ Creating cohort attributes.
    #> ℹ Applying cohort requirements.
    #> ℹ Merging overlapping records.
    #> ✔ Cohort cohort created.
    
    cdm$cohort |> [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)()
    #> # A tibble: 6 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1             10               5         1 Initial qualify…
    #> 2                    1             10               5         2 Record in obser…
    #> 3                    1             10               5         3 Record start <=…
    #> 4                    1             10               5         4 Non-missing sex 
    #> 5                    1             10               5         5 Non-missing yea…
    #> 6                    1              5               5         6 Merge overlappi…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    
    # Create a cohort based on a concept set. The cohort exit is set to the event start date.
    # If two records overlap, the cohort end date is set as the sum of the duration of
    # all overlapping records. Only individuals included in the existing `cohort` will be considered.
    
    conceptSet <- [list](https://rdrr.io/r/base/list.html)("nitrogen" = [c](https://rdrr.io/r/base/c.html)(35604434, 35604439),
    "potassium" = [c](https://rdrr.io/r/base/c.html)(40741270, 42899580, 44081436))
    
    cdm$study_cohort <- conceptCohort(cdm,
                                 conceptSet = conceptSet,
                                 name = "study_cohort",
                                 exit = "event_start_date",
                                 overlap = "extend",
                                 subsetCohort = "cohort"
    )
    #> Warning: ! `codelist` casted to integers.
    #> ℹ Subsetting table drug_exposure using 5 concepts with domain: drug.
    #> ℹ Combining tables.
    #> ℹ Creating cohort attributes.
    #> ℹ Applying cohort requirements.
    #> ℹ Adding overlapping records.
    #> ℹ Re-appplying cohort requirements.
    #> ✔ Cohort study_cohort created.
    
     cdm$study_cohort |> [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)()
    #> # A tibble: 20 × 7
    #>    cohort_definition_id number_records number_subjects reason_id reason         
    #>                   <int>          <int>           <int>     <int> <chr>          
    #>  1                    1             10               5         1 Initial qualif…
    #>  2                    1             10               5         2 Record in obse…
    #>  3                    1             10               5         3 Record start <…
    #>  4                    1             10               5         4 Non-missing sex
    #>  5                    1             10               5         5 Non-missing ye…
    #>  6                    1             10               5         6 Add overlappin…
    #>  7                    1             10               5         7 Record in obse…
    #>  8                    1             10               5         8 Record start <…
    #>  9                    1             10               5         9 Non-missing sex
    #> 10                    1             10               5        10 Non-missing ye…
    #> 11                    2             17               5         1 Initial qualif…
    #> 12                    2             17               5         2 Record in obse…
    #> 13                    2             17               5         3 Record start <…
    #> 14                    2             17               5         4 Non-missing sex
    #> 15                    2             17               5         5 Non-missing ye…
    #> 16                    2             17               5         6 Add overlappin…
    #> 17                    2             17               5         7 Record in obse…
    #> 18                    2             17               5         8 Record start <…
    #> 19                    2             17               5         9 Non-missing sex
    #> 20                    2             17               5        10 Non-missing ye…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/padCohortEnd.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Add days to cohort end

Source: [`R/padCohortDate.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/padCohortDate.R)

`padCohortEnd.Rd`

`padCohortEnd()` Adds (or subtracts) a certain number of days to the cohort end date. Note:

  * If the days added means that cohort end would be after observation period end date, then observation period end date will be used for cohort exit.

  * If the days added means that cohort exit would be after the next cohort start then these overlapping cohort entries will be collapsed.

  * If days subtracted means that cohort end would be before cohort start then the cohort entry will be dropped.




## Usage
    
    
    padCohortEnd(
      cohort,
      days,
      collapse = TRUE,
      padObservation = TRUE,
      cohortId = NULL,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

days
    

Integer with the number of days to add or name of a column (that must be numeric) to add.

collapse
    

Whether to collapse the overlapping records (TRUE) or drop the records that have an ongoing prior record.

padObservation
    

Whether to pad observations if they are outside observation_period (TRUE) or drop the records if they are outside observation_period (FALSE)

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

Cohort table

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    # add 10 days to each cohort exit
    cdm$cohort1 |>
      padCohortEnd(days = 10)
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1          9 2007-03-19        2007-09-25     
    #> 2                    1          6 1994-11-23        2001-05-06     
    #> 3                    1          5 2016-08-28        2016-10-23     
    #> 4                    1          5 2016-11-01        2016-12-16     
    #> 5                    1          4 2017-05-07        2017-07-16     
    #> 6                    1          6 2014-10-27        2014-12-21     
    #> 7                    1          2 2010-03-30        2010-04-30     
    #> 8                    1          3 2005-09-25        2007-12-04     
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/unionCohorts.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Generate cohort from the union of different cohorts

Source: [`R/unionCohorts.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/unionCohorts.R)

`unionCohorts.Rd`

`unionCohorts()` combines different cohort entries, with those records that overlap combined and kept. Cohort entries are when an individual was in _either_ of the cohorts.

## Usage
    
    
    unionCohorts(
      cohort,
      cohortId = NULL,
      gap = 0,
      cohortName = NULL,
      keepOriginalCohorts = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

cohortId
    

Vector identifying which cohorts to include (cohort_definition_id or cohort_name). Cohorts not included will be removed from the cohort set.

gap
    

Number of days between two subsequent cohort entries to be merged in a single cohort record.

cohortName
    

Name of the returned cohort. If NULL, the cohort name will be created by collapsing the individual cohort names, separated by "_".

keepOriginalCohorts
    

If TRUE the original cohorts will be return together with the new ones. If FALSE only the new cohort will be returned.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

A cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(nPerson = 100)
    
    cdm$cohort2 <- cdm$cohort2 |> unionCohorts()
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort2)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id cohort_name         gap
    #>                  <int> <chr>             <dbl>
    #> 1                    1 cohort_1_cohort_2     0
    
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/requireInDateRange.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Require that an index date is within a date range

Source: [`R/requireDateRange.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireDateRange.R)

`requireInDateRange.Rd`

`requireInDateRange()` filters cohort records, keeping only those for which the index date is within the specified date range.

## Usage
    
    
    requireInDateRange(
      cohort,
      dateRange,
      cohortId = NULL,
      indexDate = "cohort_start_date",
      atFirst = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

dateRange
    

A date vector with the minimum and maximum dates between which the index date must have been observed.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

indexDate
    

Name of the column in the cohort that contains the date of interest.

atFirst
    

If FALSE the requirement will be applied to all records, if TRUE, it will only be required for the first entry of each subject.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

The cohort table with any cohort entries outside of the date range dropped

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(nPerson = 100)
    cdm$cohort1 |>
      requireInDateRange(indexDate = "cohort_start_date",
                         dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2010-01-01", "2019-01-01")))
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          7 2013-03-03        2014-09-18     
    #>  2                    1          7 2014-09-19        2014-12-14     
    #>  3                    1          7 2015-04-04        2018-01-18     
    #>  4                    1          8 2013-12-19        2016-08-09     
    #>  5                    1         14 2018-02-26        2018-03-03     
    #>  6                    1         16 2016-10-31        2016-11-22     
    #>  7                    1         21 2015-11-25        2016-07-31     
    #>  8                    1         25 2012-10-25        2013-11-11     
    #>  9                    1         25 2013-11-12        2014-03-03     
    #> 10                    1         25 2014-03-04        2014-07-26     
    #> # ℹ more rows
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/requireDemographics.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Restrict cohort on patient demographics

Source: [`R/requireDemographics.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireDemographics.R)

`requireDemographics.Rd`

`requireDemographics()` filters cohort records, keeping only records where individuals satisfy the specified demographic criteria.

## Usage
    
    
    requireDemographics(
      cohort,
      cohortId = NULL,
      indexDate = "cohort_start_date",
      ageRange = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 150)),
      sex = [c](https://rdrr.io/r/base/c.html)("Both"),
      minPriorObservation = 0,
      minFutureObservation = 0,
      atFirst = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

indexDate
    

Variable in cohort that contains the date to compute the demographics characteristics on which to restrict on.

ageRange
    

A list of vectors specifying minimum and maximum age.

sex
    

Can be "Both", "Male" or "Female".

minPriorObservation
    

A minimum number of continuous prior observation days in the database.

minFutureObservation
    

A minimum number of continuous future observation days in the database.

atFirst
    

If FALSE the requirement will be applied to all records, if TRUE, it will only be required for the first entry of each subject.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

The cohort table with only records for individuals satisfying the demographic requirements

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(nPerson = 100)
    cdm$cohort1 |>
      requireDemographics(indexDate = "cohort_start_date",
                          ageRange = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(18, 65)),
                          sex = "Female",
                          minPriorObservation = 365)
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          7 2013-03-03        2014-09-18     
    #>  2                    1         13 2001-01-18        2001-01-20     
    #>  3                    1         17 1979-09-09        1983-01-12     
    #>  4                    1         36 2009-08-30        2009-11-12     
    #>  5                    1         37 2017-03-27        2018-07-25     
    #>  6                    1         51 1986-08-18        1991-12-26     
    #>  7                    1         53 2013-07-14        2013-07-30     
    #>  8                    1         63 2000-09-28        2001-10-18     
    #>  9                    1         69 2016-08-05        2016-08-15     
    #> 10                    1         74 2010-12-06        2011-10-08     
    #> # ℹ more rows
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/requireCohortIntersect.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Require cohort subjects are present (or absence) in another cohort

Source: [`R/requireCohortIntersect.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireCohortIntersect.R)

`requireCohortIntersect.Rd`

`requireCohortIntersect()` filters a cohort table based on a requirement that an individual is seen (or not seen) in another cohort in some time window around an index date.

## Usage
    
    
    requireCohortIntersect(
      cohort,
      targetCohortTable,
      window,
      intersections = [c](https://rdrr.io/r/base/c.html)(1, Inf),
      cohortId = NULL,
      targetCohortId = NULL,
      indexDate = "cohort_start_date",
      targetStartDate = "cohort_start_date",
      targetEndDate = "cohort_end_date",
      censorDate = NULL,
      atFirst = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

targetCohortTable
    

Name of the cohort that we want to check for intersect.

window
    

A list of vectors specifying minimum and maximum days from `indexDate` to consider events over.

intersections
    

A range indicating number of intersections for criteria to be fulfilled. If a single number is passed, the number of intersections must match this.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

targetCohortId
    

Vector of cohort definition ids to include.

indexDate
    

Name of the column in the cohort that contains the date to compute the intersection.

targetStartDate
    

Start date of reference in cohort table.

targetEndDate
    

End date of reference in cohort table. If NULL, incidence of target event in the window will be considered as intersection, otherwise prevalence of that event will be used as intersection (overlap between cohort and event).

censorDate
    

Whether to censor overlap events at a specific date or a column date of the cohort.

atFirst
    

If FALSE the requirement will be applied to all records, if TRUE, it will only be required for the first entry of each subject.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

Cohort table with only those entries satisfying the criteria

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    cdm$cohort1 |>
      requireCohortIntersect(targetCohortTable = "cohort2",
                             targetCohortId = 1,
                             indexDate = "cohort_start_date",
                             window = [c](https://rdrr.io/r/base/c.html)(-Inf, 0))
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          2 2010-03-30        2010-04-20     
    #>  2                    1          3 2005-09-25        2007-04-24     
    #>  3                    1          3 2007-04-25        2007-07-09     
    #>  4                    1          3 2007-07-10        2007-11-24     
    #>  5                    1          4 2017-05-07        2017-07-06     
    #>  6                    1          5 2016-08-28        2016-10-13     
    #>  7                    1          5 2016-11-01        2016-12-06     
    #>  8                    1          6 1994-11-23        2001-04-26     
    #>  9                    1          6 2014-10-27        2014-12-11     
    #> 10                    1          9 2007-03-19        2007-09-15     
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/LICENSE.html

Skip to contents

[CohortConstructor](index.html) 0.5.0

  * [Reference](reference/index.html)
  * Articles
    * [Introduction](articles/a00_introduction.html)
    * [Building base cohorts](articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](articles/a07_filter_cohorts.html)
    * [Splitting cohorts](articles/a08_split_cohorts.html)
    * [Combining Cohorts](articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](articles/a11_benchmark.html)
    * [Behind the scenes](articles/a12_behind_the_scenes.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](logo.png)

# Apache License

Source: [`LICENSE.md`](https://github.com/OHDSI/CohortConstructor/blob/main/LICENSE.md)

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

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/authors.html

Skip to contents

[CohortConstructor](index.html) 0.5.0

  * [Reference](reference/index.html)
  * Articles
    * [Introduction](articles/a00_introduction.html)
    * [Building base cohorts](articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](articles/a07_filter_cohorts.html)
    * [Splitting cohorts](articles/a08_split_cohorts.html)
    * [Combining Cohorts](articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](articles/a11_benchmark.html)
    * [Behind the scenes](articles/a12_behind_the_scenes.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](logo.png)

# Authors and Citation

## Authors

  * **Edward Burn**. Author, maintainer. [](https://orcid.org/0000-0002-9286-1128)

  * **Marti Catala**. Author. [](https://orcid.org/0000-0003-3308-9905)

  * **Nuria Mercade-Besora**. Author. [](https://orcid.org/0009-0006-7948-3747)

  * **Marta Alcalde-Herraiz**. Author. [](https://orcid.org/0009-0002-4405-1814)

  * **Mike Du**. Author. [](https://orcid.org/0000-0002-9517-8834)

  * **Yuchen Guo**. Author. [](https://orcid.org/0000-0002-0847-4855)

  * **Xihang Chen**. Author. [](https://orcid.org/0009-0001-8112-8959)

  * **Kim Lopez-Guell**. Author. [](https://orcid.org/0000-0002-8462-8668)

  * **Elin Rowlands**. Author. [](https://orcid.org/0009-0005-5166-0417)




## Citation

Source: [`DESCRIPTION`](https://github.com/OHDSI/CohortConstructor/blob/main/DESCRIPTION)

Burn E, Catala M, Mercade-Besora N, Alcalde-Herraiz M, Du M, Guo Y, Chen X, Lopez-Guell K, Rowlands E (2025). _CohortConstructor: Build and Manipulate Study Cohorts Using a Common Data Model_. R package version 0.5.0, <https://ohdsi.github.io/CohortConstructor/>. 
    
    
    @Manual{,
      title = {CohortConstructor: Build and Manipulate Study Cohorts Using a Common Data Model},
      author = {Edward Burn and Marti Catala and Nuria Mercade-Besora and Marta Alcalde-Herraiz and Mike Du and Yuchen Guo and Xihang Chen and Kim Lopez-Guell and Elin Rowlands},
      year = {2025},
      note = {R package version 0.5.0},
      url = {https://ohdsi.github.io/CohortConstructor/},
    }

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/deathCohort.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Create cohort based on the death table

Source: [`R/deathCohort.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/deathCohort.R)

`deathCohort.Rd`

Create cohort based on the death table

## Usage
    
    
    deathCohort(cdm, name, subsetCohort = NULL, subsetCohortId = NULL)

## Arguments

cdm
    

A cdm reference.

name
    

Name of the new cohort table created in the cdm object.

subsetCohort
    

A character refering to a cohort table containing individuals for whom cohorts will be generated. Only individuals in this table will appear in the generated cohort.

subsetCohortId
    

Optional. Specifies cohort IDs from the `subsetCohort` table to include. If none are provided, all cohorts from the `subsetCohort` are included.

## Value

A cohort table with a death cohort in cdm

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(death = TRUE)
    
    # Generate a death cohort
    death_cohort <- deathCohort(cdm, name = "death_cohort")
    #> ℹ Applying cohort requirements.
    #> ✔ Cohort death_cohort created.
    death_cohort
    #> # Source:   table<death_cohort> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          7 2010-10-22        2010-10-22     
    #>  2                    1         10 2018-11-23        2018-11-23     
    #>  3                    1          3 2008-06-03        2008-06-03     
    #>  4                    1          6 2015-01-28        2015-01-28     
    #>  5                    1          5 2016-12-16        2016-12-16     
    #>  6                    1          9 2009-04-30        2009-04-30     
    #>  7                    1          1 2018-02-06        2018-02-06     
    #>  8                    1          4 2018-02-04        2018-02-04     
    #>  9                    1          8 2013-07-25        2013-07-25     
    #> 10                    1          2 2012-06-26        2012-06-26     
    
    # Create a death cohort for females aged over 50 years old.
    
    # Create a demographics cohort with age range and sex filters
    cdm$my_cohort <- [demographicsCohort](demographicsCohort.html)(cdm, "my_cohort", ageRange = [c](https://rdrr.io/r/base/c.html)(50,100), sex = "Female")
    #> ℹ Building new trimmed cohort
    #> Adding demographics information
    #> Creating initial cohort
    #> Trim sex
    #> Trim age
    #> ✔ Cohort trimmed
    
    # Generate a death cohort, restricted to individuals in 'my_cohort'
    death_cohort <- deathCohort(cdm, name = "death_cohort", subsetCohort = "my_cohort")
    #> ℹ Applying cohort requirements.
    #> ✔ Cohort death_cohort created.
    death_cohort |> [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)()
    #> # A tibble: 7 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1             10              10         1 Initial qualify…
    #> 2                    1             10              10         2 Record in obser…
    #> 3                    1             10              10         3 Not missing rec…
    #> 4                    1             10              10         4 Non-missing sex 
    #> 5                    1             10              10         5 Non-missing yea…
    #> 6                    1              4               4         6 In subset cohort
    #> 7                    1              4               4         7 First death rec…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/demographicsCohort.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Create cohorts based on patient demographics

Source: [`R/demographicsCohort.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/demographicsCohort.R)

`demographicsCohort.Rd`

`demographicsCohort()` creates a cohort table based on patient characteristics. If and when an individual satisfies all the criteria they enter the cohort. When they stop satisfying any of the criteria their cohort entry ends.

## Usage
    
    
    demographicsCohort(
      cdm,
      name,
      ageRange = NULL,
      sex = NULL,
      minPriorObservation = NULL,
      .softValidation = TRUE
    )

## Arguments

cdm
    

A cdm reference.

name
    

Name of the new cohort table created in the cdm object.

ageRange
    

A list of vectors specifying minimum and maximum age.

sex
    

Can be "Both", "Male" or "Female".

minPriorObservation
    

A minimum number of continuous prior observation days in the database.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

A cohort table

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    
    cohort <-  cdm |>
        demographicsCohort(name = "cohort3", ageRange = [c](https://rdrr.io/r/base/c.html)(18,40), sex = "Male")
    #> ℹ Building new trimmed cohort
    #> Adding demographics information
    #> Creating initial cohort
    #> Trim sex
    #> Trim age
    #> ✔ Cohort trimmed
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cohort)
    #> # A tibble: 3 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1             10              10         1 Initial qualify…
    #> 2                    1              2               2         2 Sex requirement…
    #> 3                    1              1               1         3 Age requirement…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    
    # Can also create multiple demographic cohorts, and add minimum prior history requirements.
    
    cohort <- cdm |>
        demographicsCohort(name = "cohort4",
        ageRange = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 19),[c](https://rdrr.io/r/base/c.html)(20, 64),[c](https://rdrr.io/r/base/c.html)(65, 150)),
        sex = [c](https://rdrr.io/r/base/c.html)("Male", "Female", "Both"),
        minPriorObservation = 365)
    #> ℹ Building new trimmed cohort
    #> Adding demographics information
    #> Creating initial cohort
    #> Trim sex
    #> Trim age
    #> Trim prior observation
    #> ✔ Cohort trimmed
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cohort)
    #> # A tibble: 36 × 7
    #>    cohort_definition_id number_records number_subjects reason_id reason         
    #>                   <int>          <int>           <int>     <int> <chr>          
    #>  1                    1             10              10         1 Initial qualif…
    #>  2                    1             10              10         2 Sex requiremen…
    #>  3                    1              4               4         3 Age requiremen…
    #>  4                    1              3               3         4 Prior observat…
    #>  5                    2             10              10         1 Initial qualif…
    #>  6                    2              8               8         2 Sex requiremen…
    #>  7                    2              2               2         3 Age requiremen…
    #>  8                    2              1               1         4 Prior observat…
    #>  9                    3             10              10         1 Initial qualif…
    #> 10                    3              2               2         2 Sex requiremen…
    #> # ℹ 26 more rows
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/measurementCohort.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Create measurement-based cohorts

Source: [`R/measurementCohort.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/measurementCohort.R)

`measurementCohort.Rd`

`measurementCohort()` creates cohorts based on patient records contained in the measurement table. This function extends the `[conceptCohort()](conceptCohort.html)` as it allows for measurement values associated with the records to be specified.

  * If `valueAsConcept` and `valueAsNumber` are NULL then no requirements on of the values associated with measurement records and using `measurementCohort()` will lead to the same result as using `[conceptCohort()](conceptCohort.html)` (so long as all concepts are from the measurement domain).

  * If one of `valueAsConcept` and `valueAsNumber` is not NULL then records will be required to have values that satisfy the requirement specified.

  * If both `valueAsConcept` and `valueAsNumber` are not NULL, records will be required to have values that fulfill _either_ of the requirements




## Usage
    
    
    measurementCohort(
      cdm,
      conceptSet,
      name,
      valueAsConcept = NULL,
      valueAsNumber = NULL,
      table = [c](https://rdrr.io/r/base/c.html)("measurement", "observation"),
      useRecordsBeforeObservation = FALSE
    )

## Arguments

cdm
    

A cdm reference.

conceptSet
    

A conceptSet, which can either be a codelist or a conceptSetExpression.

name
    

Name of the new cohort table created in the cdm object.

valueAsConcept
    

A vector of cohort IDs used to filter measurements. Only measurements with these values in the `value_as_concept_id` column of the measurement table will be included. If NULL all entries independent of their value as concept will be considered.

valueAsNumber
    

A list indicating the range of values and the unit they correspond to, as follows: list("unit_concept_id" = c(rangeValue1, rangeValue2)). If no name is supplied in the list, no requirement on unit concept id will be applied. If NULL, all entries independent of their value as number will be included.

table
    

Name of OMOP tables to search for records of the concepts provided. Options are "measurement" and/or "observation".

useRecordsBeforeObservation
    

If FALSE, only records in observation will be used. If FALSE, records before the start of observation period will be considered, with cohort start date set to the start of their next observation period.

## Value

A cohort table

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(con = NULL)
    cdm$concept <- cdm$concept |>
      dplyr::[union_all](https://dplyr.tidyverse.org/reference/setops.html)(
        dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          concept_id = [c](https://rdrr.io/r/base/c.html)(4326744, 4298393, 45770407, 8876, 4124457),
          concept_name = [c](https://rdrr.io/r/base/c.html)("Blood pressure", "Systemic blood pressure",
                           "Baseline blood pressure", "millimeter mercury column",
                           "Normal range"),
          domain_id = "Measurement",
          vocabulary_id = [c](https://rdrr.io/r/base/c.html)("SNOMED", "SNOMED", "SNOMED", "UCUM", "SNOMED"),
          standard_concept = "S",
          concept_class_id = [c](https://rdrr.io/r/base/c.html)("Observable Entity", "Observable Entity",
                               "Observable Entity", "Unit", "Qualifier Value"),
          concept_code = NA,
          valid_start_date = NA,
          valid_end_date = NA,
          invalid_reason = NA
        )
      )
    cdm$measurement <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      measurement_id = 1:4,
      person_id = [c](https://rdrr.io/r/base/c.html)(1, 1, 2, 3),
      measurement_concept_id = [c](https://rdrr.io/r/base/c.html)(4326744, 4298393, 4298393, 45770407),
      measurement_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2000-07-01", "2000-12-11", "2002-09-08",
      "2015-02-19")),
      measurement_type_concept_id = NA,
      value_as_number = [c](https://rdrr.io/r/base/c.html)(100, 125, NA, NA),
      value_as_concept_id = [c](https://rdrr.io/r/base/c.html)(0, 0, 0, 4124457),
      unit_concept_id = [c](https://rdrr.io/r/base/c.html)(8876, 8876, 0, 0)
    )
    cdm <- CDMConnector::[copyCdmTo](https://darwin-eu.github.io/CDMConnector/reference/copyCdmTo.html)(
      con = DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)()),
      cdm = cdm, schema = "main")
    
    cdm$cohort <- measurementCohort(
      cdm = cdm,
      name = "cohort",
      conceptSet = [list](https://rdrr.io/r/base/list.html)("normal_blood_pressure" = [c](https://rdrr.io/r/base/c.html)(4326744, 4298393, 45770407)),
      valueAsConcept = [c](https://rdrr.io/r/base/c.html)(4124457),
      valueAsNumber = [list](https://rdrr.io/r/base/list.html)("8876" = [c](https://rdrr.io/r/base/c.html)(70, 120)),
      useRecordsBeforeObservation = FALSE
    )
    #> Warning: ! `codelist` casted to integers.
    #> Warning: ✖ Domain observation (3 concepts) excluded because table observation is not
    #>   present in the cdm.
    #> ℹ Subsetting table measurement using 3 concepts with domain: measurement.
    #> ℹ Combining tables.
    #> ℹ Applying measurement requirements.
    #> ℹ Getting records in observation.
    #> ℹ Creating cohort attributes.
    #> ✔ Cohort cohort created.
    
    cdm$cohort
    #> # Source:   table<cohort> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <dbl> <date>            <date>         
    #> 1                    1          1 2000-07-01        2000-07-01     
    
    # You can also create multiple measurement cohorts, and include records
    # outside the observation period.
    
    cdm$cohort2 <- measurementCohort(
      cdm = cdm,
      name = "cohort2",
      conceptSet = [list](https://rdrr.io/r/base/list.html)("normal_blood_pressure" = [c](https://rdrr.io/r/base/c.html)(4326744, 4298393, 45770407),
                      "high_blood_pressure" = [c](https://rdrr.io/r/base/c.html)(4326744, 4298393, 45770407)),
      valueAsConcept = [c](https://rdrr.io/r/base/c.html)(4124457),
      valueAsNumber = [list](https://rdrr.io/r/base/list.html)("8876" = [c](https://rdrr.io/r/base/c.html)(70, 120),
                           "8876" = [c](https://rdrr.io/r/base/c.html)(121, 200)),
      useRecordsBeforeObservation = FALSE
    )
    #> Warning: ! `codelist` casted to integers.
    #> Warning: ✖ Domain observation (6 concepts) excluded because table observation is not
    #>   present in the cdm.
    #> ℹ Subsetting table measurement using 6 concepts with domain: measurement.
    #> ℹ Combining tables.
    #> ℹ Applying measurement requirements.
    #> ℹ Getting records in observation.
    #> ℹ Creating cohort attributes.
    #> ✔ Cohort cohort2 created.
    
    cdm$cohort2
    #> # Source:   table<cohort2> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <dbl> <date>            <date>         
    #> 1                    2          1 2000-12-11        2000-12-11     
    #> 2                    1          1 2000-07-01        2000-07-01     
    #> 3                    1          1 2000-12-11        2000-12-11     
    #> 4                    2          1 2000-07-01        2000-07-01     
    
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/requireMinCohortCount.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Filter cohorts to keep only records for those with a minimum amount of subjects

Source: [`R/requireMinCohortCount.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireMinCohortCount.R)

`requireMinCohortCount.Rd`

`requireMinCohortCount()` filters an existing cohort table, keeping only records from cohorts with a minimum number of individuals

## Usage
    
    
    requireMinCohortCount(
      cohort,
      minCohortCount,
      cohortId = NULL,
      updateSettings = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort)
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

minCohortCount
    

The minimum count of sbjects for a cohort to be included.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

updateSettings
    

If TRUE, dropped cohorts will also be removed from all cohort table attributes (i.e., settings, attrition, counts, and codelist). If FALSE, these attributes will be retained but updated to reflect that the affected cohorts have been suppressed.

name
    

Name of the new cohort table created in the cdm object.

## Value

Cohort table

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(nPerson = 100)
    
    cdm$cohort1 |>
    requireMinCohortCount(5)
    #> Warning: There was 1 warning in `dplyr::filter()`.
    #> ℹ In argument: `.data$reason_id %in% max(.data$reason_id)`.
    #> Caused by warning in `max()`:
    #> ! no non-missing arguments to max; returning -Inf
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          4 2019-06-09        2019-08-31     
    #>  2                    1          6 1983-03-10        1996-03-21     
    #>  3                    1          7 2013-03-03        2014-09-18     
    #>  4                    1          7 2014-09-19        2014-12-14     
    #>  5                    1          7 2015-04-04        2018-01-18     
    #>  6                    1          8 2013-12-19        2016-08-09     
    #>  7                    1          9 2005-11-05        2005-11-06     
    #>  8                    1          9 2005-11-07        2006-07-18     
    #>  9                    1          9 2006-07-19        2010-07-28     
    #> 10                    1         12 2003-02-09        2007-02-05     
    #> # ℹ more rows
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/requireDuration.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Require cohort entries last for a certain number of days

Source: [`R/requireDuration.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireDuration.R)

`requireDuration.Rd`

`requireDuration()` filters cohort records, keeping only those which last for the specified amount of days

## Usage
    
    
    requireDuration(
      cohort,
      daysInCohort,
      cohortId = NULL,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort)
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

daysInCohort
    

Number of days cohort entries must last. Can be a vector of length two if a range, or a vector of length one if a specific number of days

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

name
    

Name of the new cohort table created in the cdm object.

## Value

The cohort table with any cohort entries that last less or more than the required duration dropped

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(nPerson = 100)
    cdm$cohort1 |>
      requireDuration(daysInCohort = [c](https://rdrr.io/r/base/c.html)(1, Inf))
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          4 2019-06-09        2019-08-31     
    #>  2                    1          6 1983-03-10        1996-03-21     
    #>  3                    1          7 2013-03-03        2014-09-18     
    #>  4                    1          7 2014-09-19        2014-12-14     
    #>  5                    1          7 2015-04-04        2018-01-18     
    #>  6                    1          8 2013-12-19        2016-08-09     
    #>  7                    1          9 2005-11-05        2005-11-06     
    #>  8                    1          9 2005-11-07        2006-07-18     
    #>  9                    1          9 2006-07-19        2010-07-28     
    #> 10                    1         12 2003-02-09        2007-02-05     
    #> # ℹ more rows
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/requireIsFirstEntry.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Restrict cohort to first entry

Source: [`R/requireIsEntry.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireIsEntry.R)

`requireIsFirstEntry.Rd`

`requireIsFirstEntry()` filters cohort records, keeping only the first cohort entry per person.

## Usage
    
    
    requireIsFirstEntry(
      cohort,
      cohortId = NULL,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

A cohort table in a cdm reference.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    cdm$cohort1 <- requireIsFirstEntry(cdm$cohort1)
    # }
    
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/requireIsLastEntry.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Restrict cohort to last entry per person

Source: [`R/requireIsEntry.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireIsEntry.R)

`requireIsLastEntry.Rd`

`requireIsLastEntry()` filters cohort records, keeping only the last cohort entry per person.

## Usage
    
    
    requireIsLastEntry(
      cohort,
      cohortId = NULL,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

A cohort table in a cdm reference.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    cdm$cohort1 <- requireIsLastEntry(cdm$cohort1)
    # }
    
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/requireIsEntry.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Restrict cohort to specific entry

Source: [`R/requireIsEntry.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireIsEntry.R)

`requireIsEntry.Rd`

`[requireIsFirstEntry()](requireIsFirstEntry.html)` filters cohort records, keeping only the first cohort entry per person.

## Usage
    
    
    requireIsEntry(
      cohort,
      entryRange,
      cohortId = NULL,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

entryRange
    

Range for entries to include.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

A cohort table in a cdm reference.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    cdm$cohort1 <- requireIsEntry(cdm$cohort1, [c](https://rdrr.io/r/base/c.html)(1, Inf))
    # }
    
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/requireAge.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Restrict cohort on age

Source: [`R/requireDemographics.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireDemographics.R)

`requireAge.Rd`

`requireAge()` filters cohort records, keeping only records where individuals satisfy the specified age criteria.

## Usage
    
    
    requireAge(
      cohort,
      ageRange,
      cohortId = NULL,
      indexDate = "cohort_start_date",
      atFirst = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

ageRange
    

A list of vectors specifying minimum and maximum age.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

indexDate
    

Variable in cohort that contains the date to compute the demographics characteristics on which to restrict on.

atFirst
    

If FALSE the requirement will be applied to all records, if TRUE, it will only be required for the first entry of each subject.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

The cohort table with only records for individuals satisfying the age requirement

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    cdm$cohort1 |>
      requireAge(indexDate = "cohort_start_date",
                 ageRange = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(18, 65)))
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          2 2010-03-30        2010-04-20     
    #>  2                    1          3 2005-09-25        2007-04-24     
    #>  3                    1          3 2007-04-25        2007-07-09     
    #>  4                    1          3 2007-07-10        2007-11-24     
    #>  5                    1          4 2017-05-07        2017-07-06     
    #>  6                    1          5 2016-08-28        2016-10-13     
    #>  7                    1          5 2016-11-01        2016-12-06     
    #>  8                    1          6 1994-11-23        2001-04-26     
    #>  9                    1          6 2014-10-27        2014-12-11     
    #> 10                    1          9 2007-03-19        2007-09-15     
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/requireSex.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Restrict cohort on sex

Source: [`R/requireDemographics.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireDemographics.R)

`requireSex.Rd`

`requireSex()` filters cohort records, keeping only records where individuals satisfy the specified sex criteria.

## Usage
    
    
    requireSex(
      cohort,
      sex,
      cohortId = NULL,
      atFirst = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

sex
    

Can be "Both", "Male" or "Female".

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

atFirst
    

If FALSE the requirement will be applied to all records, if TRUE, it will only be required for the first entry of each subject.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

The cohort table with only records for individuals satisfying the sex requirement

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    cdm$cohort1 |>
      requireSex(sex = "Female")
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1          2 2010-03-30        2010-04-20     
    #> 2                    1          3 2007-07-10        2007-11-24     
    #> 3                    1          4 2017-05-07        2017-07-06     
    #> 4                    1          5 2016-11-01        2016-12-06     
    #> 5                    1          9 2007-03-19        2007-09-15     
    #> 6                    1          3 2007-04-25        2007-07-09     
    #> 7                    1          5 2016-08-28        2016-10-13     
    #> 8                    1          3 2005-09-25        2007-04-24     
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/requirePriorObservation.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Restrict cohort on prior observation

Source: [`R/requireDemographics.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireDemographics.R)

`requirePriorObservation.Rd`

`requirePriorObservation()` filters cohort records, keeping only records where individuals satisfy the specified prior observation criteria.

## Usage
    
    
    requirePriorObservation(
      cohort,
      minPriorObservation,
      cohortId = NULL,
      indexDate = "cohort_start_date",
      atFirst = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

minPriorObservation
    

A minimum number of continuous prior observation days in the database.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

indexDate
    

Variable in cohort that contains the date to compute the demographics characteristics on which to restrict on.

atFirst
    

If FALSE the requirement will be applied to all records, if TRUE, it will only be required for the first entry of each subject.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

The cohort table with only records for individuals satisfying the prior observation requirement

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    cdm$cohort1 |>
      requirePriorObservation(indexDate = "cohort_start_date",
                              minPriorObservation = 365)
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1          2 2010-03-30        2010-04-20     
    #> 2                    1          3 2005-09-25        2007-04-24     
    #> 3                    1          3 2007-04-25        2007-07-09     
    #> 4                    1          3 2007-07-10        2007-11-24     
    #> 5                    1          4 2017-05-07        2017-07-06     
    #> 6                    1          6 1994-11-23        2001-04-26     
    #> 7                    1          6 2014-10-27        2014-12-11     
    #> 8                    1          9 2007-03-19        2007-09-15     
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/requireFutureObservation.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Restrict cohort on future observation

Source: [`R/requireDemographics.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireDemographics.R)

`requireFutureObservation.Rd`

`requireFutureObservation()` filters cohort records, keeping only records where individuals satisfy the specified future observation criteria.

## Usage
    
    
    requireFutureObservation(
      cohort,
      minFutureObservation,
      cohortId = NULL,
      indexDate = "cohort_start_date",
      atFirst = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

minFutureObservation
    

A minimum number of continuous future observation days in the database.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

indexDate
    

Variable in cohort that contains the date to compute the demographics characteristics on which to restrict on.

atFirst
    

If FALSE the requirement will be applied to all records, if TRUE, it will only be required for the first entry of each subject.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

The cohort table with only records for individuals satisfying the future observation requirement

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    cdm$cohort1 |>
      requireFutureObservation(indexDate = "cohort_start_date",
                               minFutureObservation = 30)
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          2 2010-03-30        2010-04-20     
    #>  2                    1          3 2005-09-25        2007-04-24     
    #>  3                    1          3 2007-04-25        2007-07-09     
    #>  4                    1          3 2007-07-10        2007-11-24     
    #>  5                    1          4 2017-05-07        2017-07-06     
    #>  6                    1          5 2016-08-28        2016-10-13     
    #>  7                    1          5 2016-11-01        2016-12-06     
    #>  8                    1          6 1994-11-23        2001-04-26     
    #>  9                    1          6 2014-10-27        2014-12-11     
    #> 10                    1          9 2007-03-19        2007-09-15     
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/requireConceptIntersect.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Require cohort subjects to have (or not have) events of a concept list

Source: [`R/requireConceptIntersect.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireConceptIntersect.R)

`requireConceptIntersect.Rd`

`requireConceptIntersect()` filters a cohort table based on a requirement that an individual is seen (or not seen) to have events related to a concept list in some time window around an index date.

## Usage
    
    
    requireConceptIntersect(
      cohort,
      conceptSet,
      window,
      intersections = [c](https://rdrr.io/r/base/c.html)(1, Inf),
      cohortId = NULL,
      indexDate = "cohort_start_date",
      targetStartDate = "event_start_date",
      targetEndDate = "event_end_date",
      inObservation = TRUE,
      censorDate = NULL,
      atFirst = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

conceptSet
    

A conceptSet, which can either be a codelist or a conceptSetExpression.

window
    

A list of vectors specifying minimum and maximum days from `indexDate` to consider events over.

intersections
    

A range indicating number of intersections for criteria to be fulfilled. If a single number is passed, the number of intersections must match this.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

indexDate
    

Name of the column in the cohort that contains the date to compute the intersection.

targetStartDate
    

Start date of reference in cohort table.

targetEndDate
    

End date of reference in cohort table. If NULL, incidence of target event in the window will be considered as intersection, otherwise prevalence of that event will be used as intersection (overlap between cohort and event).

inObservation
    

If TRUE only records inside an observation period will be considered

censorDate
    

Whether to censor overlap events at a specific date or a column date of the cohort.

atFirst
    

If FALSE the requirement will be applied to all records, if TRUE, it will only be required for the first entry of each subject.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

Cohort table

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(conditionOccurrence = TRUE)
    cdm$cohort2 <-  requireConceptIntersect(
      cohort = cdm$cohort1,
      conceptSet = [list](https://rdrr.io/r/base/list.html)(a = 194152),
      window = [c](https://rdrr.io/r/base/c.html)(-Inf, 0),
      name = "cohort2")
    #> Warning: ! `codelist` casted to integers.
      # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/requireTableIntersect.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Require cohort subjects are present in another clinical table

Source: [`R/requireTableIntersect.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireTableIntersect.R)

`requireTableIntersect.Rd`

`requireTableIntersect()` filters a cohort table based on a requirement that an individual is seen (or not seen) to have a record (or no records) in a clinical table in some time window around an index date.

## Usage
    
    
    requireTableIntersect(
      cohort,
      tableName,
      window,
      intersections = [c](https://rdrr.io/r/base/c.html)(1, Inf),
      cohortId = NULL,
      indexDate = "cohort_start_date",
      targetStartDate = [startDateColumn](https://darwin-eu.github.io/PatientProfiles/reference/startDateColumn.html)(tableName),
      targetEndDate = [endDateColumn](https://darwin-eu.github.io/PatientProfiles/reference/endDateColumn.html)(tableName),
      inObservation = TRUE,
      censorDate = NULL,
      atFirst = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

tableName
    

Name of the table to check for intersect.

window
    

A list of vectors specifying minimum and maximum days from `indexDate` to consider events over.

intersections
    

A range indicating number of intersections for criteria to be fulfilled. If a single number is passed, the number of intersections must match this.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

indexDate
    

Name of the column in the cohort that contains the date to compute the intersection.

targetStartDate
    

Start date of reference in cohort table.

targetEndDate
    

End date of reference in cohort table. If NULL, incidence of target event in the window will be considered as intersection, otherwise prevalence of that event will be used as intersection (overlap between cohort and event).

inObservation
    

If TRUE only records inside an observation period will be considered

censorDate
    

Whether to censor overlap events at a specific date or a column date of the cohort.

atFirst
    

If FALSE the requirement will be applied to all records, if TRUE, it will only be required for the first entry of each subject.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

Cohort table

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(drugExposure = TRUE)
    cdm$cohort1 |>
      requireTableIntersect(tableName = "drug_exposure",
                                indexDate = "cohort_start_date",
                                window = [c](https://rdrr.io/r/base/c.html)(-Inf, 0))
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          2 2010-03-30        2010-04-20     
    #>  2                    1          3 2005-09-25        2007-04-24     
    #>  3                    1          3 2007-04-25        2007-07-09     
    #>  4                    1          3 2007-07-10        2007-11-24     
    #>  5                    1          4 2017-05-07        2017-07-06     
    #>  6                    1          5 2016-08-28        2016-10-13     
    #>  7                    1          5 2016-11-01        2016-12-06     
    #>  8                    1          6 1994-11-23        2001-04-26     
    #>  9                    1          6 2014-10-27        2014-12-11     
    #> 10                    1          9 2007-03-19        2007-09-15     
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/entryAtFirstDate.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Update cohort start date to be the first date from of a set of column dates

Source: [`R/entryAtColumnDate.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/entryAtColumnDate.R)

`entryAtFirstDate.Rd`

`entryAtFirstDate()` resets cohort start date based on a set of specified column dates. The first date that occurs is chosen.

## Usage
    
    
    entryAtFirstDate(
      cohort,
      dateColumns,
      cohortId = NULL,
      returnReason = FALSE,
      keepDateColumns = TRUE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

dateColumns
    

Character vector indicating date columns in the cohort table to consider.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

returnReason
    

If TRUE it will return a column indicating which of the `dateColumns` was used.

keepDateColumns
    

If TRUE the returned cohort will keep columns in `dateColumns`.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

The cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(tables = [list](https://rdrr.io/r/base/list.html)(
    "cohort" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1,
      subject_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3, 4),
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2000-06-03", "2000-01-01", "2015-01-15", "2000-12-09")),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2001-09-01", "2001-01-12", "2015-02-15", "2002-12-09")),
      date_1 = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2001-08-01", "2001-01-01", "2015-01-15", "2002-12-09")),
      date_2 = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2001-08-01", NA, "2015-02-14", "2002-12-09"))
    )
    ))
    cdm$cohort |> [entryAtLastDate](entryAtLastDate.html)(dateColumns = [c](https://rdrr.io/r/base/c.html)("date_1", "date_2"))
    #> Joining with `by = join_by(cohort_definition_id, subject_id, cohort_end_date)`
    #> # Source:   table<cohort> [?? x 6]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date date_1    
    #>                  <int>      <int> <date>            <date>          <date>    
    #> 1                    1          1 2001-08-01        2001-09-01      2001-08-01
    #> 2                    1          2 2001-01-01        2001-01-12      2001-01-01
    #> 3                    1          3 2015-02-14        2015-02-15      2015-01-15
    #> 4                    1          4 2002-12-09        2002-12-09      2002-12-09
    #> # ℹ 1 more variable: date_2 <date>
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/entryAtLastDate.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Set cohort start date to the last of a set of column dates

Source: [`R/entryAtColumnDate.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/entryAtColumnDate.R)

`entryAtLastDate.Rd`

`entryAtLastDate()` resets cohort end date based on a set of specified column dates. The last date is chosen.

## Usage
    
    
    entryAtLastDate(
      cohort,
      dateColumns,
      cohortId = NULL,
      returnReason = FALSE,
      keepDateColumns = TRUE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

dateColumns
    

Character vector indicating date columns in the cohort table to consider.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

returnReason
    

If TRUE it will return a column indicating which of the `dateColumns` was used.

keepDateColumns
    

If TRUE the returned cohort will keep columns in `dateColumns`.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

The cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(tables = [list](https://rdrr.io/r/base/list.html)(
    "cohort" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1,
      subject_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3, 4),
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2000-06-03", "2000-01-01", "2015-01-15", "2000-12-09")),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2001-09-01", "2001-01-12", "2015-02-15", "2002-12-09")),
      date_1 = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2001-08-01", "2001-01-01", "2015-01-15", "2002-12-09")),
      date_2 = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2001-08-01", NA, "2015-02-14", "2002-12-09"))
    )
    ))
    cdm$cohort |> entryAtLastDate(dateColumns = [c](https://rdrr.io/r/base/c.html)("date_1", "date_2"))
    #> Joining with `by = join_by(cohort_definition_id, subject_id, cohort_end_date)`
    #> # Source:   table<cohort> [?? x 6]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date date_1    
    #>                  <int>      <int> <date>            <date>          <date>    
    #> 1                    1          1 2001-08-01        2001-09-01      2001-08-01
    #> 2                    1          2 2001-01-01        2001-01-12      2001-01-01
    #> 3                    1          3 2015-02-14        2015-02-15      2015-01-15
    #> 4                    1          4 2002-12-09        2002-12-09      2002-12-09
    #> # ℹ 1 more variable: date_2 <date>
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/exitAtDeath.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Set cohort end date to death date

Source: [`R/exitAtDate.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/exitAtDate.R)

`exitAtDeath.Rd`

This functions changes cohort end date to subject's death date. In the case were this generates overlapping records in the cohort, those overlapping entries will be merged.

## Usage
    
    
    exitAtDeath(
      cohort,
      cohortId = NULL,
      requireDeath = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

requireDeath
    

If TRUE, subjects without a death record will be dropped, while if FALSE their end date will be left as is.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

The cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockPatientProfiles](https://darwin-eu.github.io/PatientProfiles/reference/mockPatientProfiles.html)()
    cdm$cohort1 |> exitAtDeath()
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          2 2003-03-30        2004-12-31     
    #>  2                    3          8 1979-07-30        1982-04-14     
    #>  3                    2          1 1964-06-25        1973-07-25     
    #>  4                    3          9 1963-01-28        1964-08-25     
    #>  5                    1          3 1917-08-29        1948-04-14     
    #>  6                    2          4 1940-10-28        1977-03-08     
    #>  7                    3         10 1980-03-04        1980-11-09     
    #>  8                    2          6 1990-07-28        2005-06-20     
    #>  9                    3          7 1926-02-15        1926-07-26     
    #> 10                    1          5 1968-12-02        1972-12-04     
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/exitAtFirstDate.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Set cohort end date to the first of a set of column dates

Source: [`R/exitAtColumnDate.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/exitAtColumnDate.R)

`exitAtFirstDate.Rd`

`exitAtFirstDate()` resets cohort end date based on a set of specified column dates. The first date that occurs is chosen.

## Usage
    
    
    exitAtFirstDate(
      cohort,
      dateColumns,
      cohortId = NULL,
      returnReason = FALSE,
      keepDateColumns = TRUE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

dateColumns
    

Character vector indicating date columns in the cohort table to consider.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

returnReason
    

If TRUE it will return a column indicating which of the `dateColumns` was used.

keepDateColumns
    

If TRUE the returned cohort will keep columns in `dateColumns`.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

The cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(tables = [list](https://rdrr.io/r/base/list.html)(
    "cohort" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1,
      subject_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3, 4),
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2000-06-03", "2000-01-01", "2015-01-15", "2000-12-09")),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2001-09-01", "2001-01-12", "2015-02-15", "2002-12-09")),
      date_1 = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2001-08-01", "2001-01-01", "2015-01-15", "2002-12-09")),
      date_2 = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2001-08-01", NA, "2015-04-15", "2002-12-09"))
    )
    ))
    cdm$cohort |> exitAtFirstDate(dateColumns = [c](https://rdrr.io/r/base/c.html)("date_1", "date_2"))
    #> Joining with `by = join_by(cohort_definition_id, subject_id, cohort_start_date)`
    #> # Source:   table<cohort> [?? x 6]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date date_1    
    #>                  <int>      <int> <date>            <date>          <date>    
    #> 1                    1          1 2000-06-03        2001-08-01      2001-08-01
    #> 2                    1          2 2000-01-01        2001-01-01      2001-01-01
    #> 3                    1          3 2015-01-15        2015-01-15      2015-01-15
    #> 4                    1          4 2000-12-09        2002-12-09      2002-12-09
    #> # ℹ 1 more variable: date_2 <date>
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/exitAtLastDate.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Set cohort end date to the last of a set of column dates

Source: [`R/exitAtColumnDate.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/exitAtColumnDate.R)

`exitAtLastDate.Rd`

`exitAtLastDate()` resets cohort end date based on a set of specified column dates. The last date that occurs is chosen.

## Usage
    
    
    exitAtLastDate(
      cohort,
      dateColumns,
      cohortId = NULL,
      returnReason = FALSE,
      keepDateColumns = TRUE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

dateColumns
    

Character vector indicating date columns in the cohort table to consider.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

returnReason
    

If TRUE it will return a column indicating which of the `dateColumns` was used.

keepDateColumns
    

If TRUE the returned cohort will keep columns in `dateColumns`.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

The cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(tables = [list](https://rdrr.io/r/base/list.html)(
    "cohort" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1,
      subject_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3, 4),
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2000-06-03", "2000-01-01", "2015-01-15", "2000-12-09")),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2001-09-01", "2001-01-12", "2015-02-15", "2002-12-09")),
      date_1 = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2001-08-01", "2001-01-01", "2015-01-15", "2002-12-09")),
      date_2 = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2001-08-01", NA, "2015-04-15", "2002-12-09"))
    )
    ))
    cdm$cohort |> exitAtLastDate(dateColumns = [c](https://rdrr.io/r/base/c.html)("date_1", "date_2"))
    #> Joining with `by = join_by(cohort_definition_id, subject_id, cohort_start_date)`
    #> # Source:   table<cohort> [?? x 6]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date date_1    
    #>                  <int>      <int> <date>            <date>          <date>    
    #> 1                    1          1 2000-06-03        2001-08-01      2001-08-01
    #> 2                    1          2 2000-01-01        2001-01-01      2001-01-01
    #> 3                    1          3 2015-01-15        2015-04-15      2015-01-15
    #> 4                    1          4 2000-12-09        2002-12-09      2002-12-09
    #> # ℹ 1 more variable: date_2 <date>
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/exitAtObservationEnd.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Set cohort end date to end of observation

Source: [`R/exitAtDate.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/exitAtDate.R)

`exitAtObservationEnd.Rd`

`exitAtObservationEnd()` resets cohort end date based on a set of specified column dates. The last date that occurs is chosen.

This functions changes cohort end date to the end date of the observation period corresponding to the cohort entry. In the case were this generates overlapping records in the cohort, overlapping entries will be merged.

## Usage
    
    
    exitAtObservationEnd(
      cohort,
      cohortId = NULL,
      persistAcrossObservationPeriods = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

persistAcrossObservationPeriods
    

If FALSE, limits the cohort to one entry per person, ending at the current observation period. If TRUE, subsequent observation periods will create new cohort entries (starting from the start of that observation period and ending at the end of that observation period).

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

The cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    cdm$cohort1 |> exitAtObservationEnd()
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1          9 2007-03-19        2009-04-30     
    #> 2                    1          4 2017-05-07        2018-02-04     
    #> 3                    1          6 1994-11-23        2015-01-28     
    #> 4                    1          3 2005-09-25        2008-06-03     
    #> 5                    1          2 2010-03-30        2012-06-26     
    #> 6                    1          5 2016-08-28        2016-12-16     
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/padCohortDate.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Set cohort start or cohort end

Source: [`R/padCohortDate.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/padCohortDate.R)

`padCohortDate.Rd`

Set cohort start or cohort end

## Usage
    
    
    padCohortDate(
      cohort,
      days,
      cohortDate = "cohort_start_date",
      indexDate = "cohort_start_date",
      collapse = TRUE,
      padObservation = TRUE,
      cohortId = NULL,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

days
    

Integer with the number of days to add or name of a column (that must be numeric) to add.

cohortDate
    

'cohort_start_date' or 'cohort_end_date'.

indexDate
    

Variable in cohort that contains the index date to add.

collapse
    

Whether to collapse the overlapping records (TRUE) or drop the records that have an ongoing prior record.

padObservation
    

Whether to pad observations if they are outside observation_period (TRUE) or drop the records if they are outside observation_period (FALSE)

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

Cohort table

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    cdm$cohort1 |>
      padCohortDate(
        cohortDate = "cohort_end_date",
        indexDate = "cohort_start_date",
        days = 10)
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          6 1994-11-23        1994-12-03     
    #>  2                    1          6 2014-10-27        2014-11-06     
    #>  3                    1          2 2010-03-30        2010-04-09     
    #>  4                    1          3 2007-04-25        2007-05-05     
    #>  5                    1          5 2016-08-28        2016-09-07     
    #>  6                    1          3 2005-09-25        2005-10-05     
    #>  7                    1          5 2016-11-01        2016-11-11     
    #>  8                    1          4 2017-05-07        2017-05-17     
    #>  9                    1          3 2007-07-10        2007-07-20     
    #> 10                    1          9 2007-03-19        2007-03-29     
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/padCohortStart.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Add days to cohort start

Source: [`R/padCohortDate.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/padCohortDate.R)

`padCohortStart.Rd`

`padCohortStart()` Adds (or subtracts) a certain number of days to the cohort start date. Note:

  * If the days added means that cohort start would be after cohort end then the cohort entry will be dropped.

  * If subtracting day means that cohort start would be before observation period start then the cohort entry will be dropped.




## Usage
    
    
    padCohortStart(
      cohort,
      days,
      collapse = TRUE,
      padObservation = TRUE,
      cohortId = NULL,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

days
    

Integer with the number of days to add or name of a column (that must be numeric) to add.

collapse
    

Whether to collapse the overlapping records (TRUE) or drop the records that have an ongoing prior record.

padObservation
    

Whether to pad observations if they are outside observation_period (TRUE) or drop the records if they are outside observation_period (FALSE)

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

Cohort table

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    # add 10 days to each cohort entry
    cdm$cohort1 |>
      padCohortStart(days = 10)
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          3 2007-07-20        2007-11-24     
    #>  2                    1          9 2007-03-29        2007-09-15     
    #>  3                    1          6 1994-12-03        2001-04-26     
    #>  4                    1          4 2017-05-17        2017-07-06     
    #>  5                    1          5 2016-09-07        2016-10-13     
    #>  6                    1          3 2005-10-05        2007-04-24     
    #>  7                    1          6 2014-11-06        2014-12-11     
    #>  8                    1          5 2016-11-11        2016-12-06     
    #>  9                    1          2 2010-04-09        2010-04-20     
    #> 10                    1          3 2007-05-05        2007-07-09     
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/trimDemographics.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Trim cohort on patient demographics

Source: [`R/trimDemographics.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/trimDemographics.R)

`trimDemographics.Rd`

`trimDemographics()` resets the cohort start and end date based on the specified demographic criteria is satisfied.

## Usage
    
    
    trimDemographics(
      cohort,
      cohortId = NULL,
      ageRange = NULL,
      sex = NULL,
      minPriorObservation = NULL,
      minFutureObservation = NULL,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

ageRange
    

A list of vectors specifying minimum and maximum age.

sex
    

Can be "Both", "Male" or "Female".

minPriorObservation
    

A minimum number of continuous prior observation days in the database.

minFutureObservation
    

A minimum number of continuous future observation days in the database.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

The cohort table with only records for individuals satisfying the demographic requirements

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(nPerson = 100)
    
    cdm$cohort1 |> trimDemographics(ageRange = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(10, 30)))
    #> ℹ Building new trimmed cohort
    #> Adding demographics information
    #> Creating initial cohort
    #> Trim age
    #> ✔ Cohort trimmed
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          6 1983-03-10        1996-03-21     
    #>  2                    1         22 2007-12-28        2008-05-08     
    #>  3                    1         43 1996-10-05        1996-11-09     
    #>  4                    1         46 1985-04-02        1988-11-03     
    #>  5                    1         51 1986-08-18        1991-12-26     
    #>  6                    1         54 1981-02-26        1982-04-20     
    #>  7                    1         64 1991-08-19        1994-10-14     
    #>  8                    1         74 2010-12-06        2011-10-08     
    #>  9                    1         78 2012-05-28        2014-05-09     
    #> 10                    1         43 1996-09-18        1996-09-19     
    #> # ℹ more rows
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/trimToDateRange.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Trim cohort dates to be within a date range

Source: [`R/requireDateRange.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/requireDateRange.R)

`trimToDateRange.Rd`

`trimToDateRange()` resets the cohort start and end date based on the specified date range.

## Usage
    
    
    trimToDateRange(
      cohort,
      dateRange,
      cohortId = NULL,
      startDate = "cohort_start_date",
      endDate = "cohort_end_date",
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

dateRange
    

A window of time during which the start and end date must have been observed.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

startDate
    

Variable with earliest date.

endDate
    

Variable with latest date.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

The cohort table with record timings updated to only be within the date range. Any records with all time outside of the range will have been dropped.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    cdm$cohort1 |>
      trimToDateRange(startDate = "cohort_start_date",
                      endDate = "cohort_end_date",
                      dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2015-01-01",
                                            "2015-12-31")))
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #> # ℹ 4 variables: cohort_definition_id <int>, subject_id <int>,
    #> #   cohort_start_date <date>, cohort_end_date <date>
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/collapseCohorts.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Collapse cohort entries using a certain gap to concatenate records.

Source: [`R/collapseCohorts.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/collapseCohorts.R)

`collapseCohorts.Rd`

`collapseCohorts()` concatenates cohort records, allowing for some number of days between one finishing and the next starting.

## Usage
    
    
    collapseCohorts(
      cohort,
      cohortId = NULL,
      gap = 0,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

gap
    

Number of days between two subsequent cohort entries to be merged in a single cohort record.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

A cohort table

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/subsetCohorts.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Generate a cohort table keeping a subset of cohorts.

Source: [`R/subsetCohorts.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/subsetCohorts.R)

`subsetCohorts.Rd`

`subsetCohorts()` filters an existing cohort table, keeping only the records from cohorts that are specified.

## Usage
    
    
    subsetCohorts(
      cohort,
      cohortId,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

cohortId
    

Vector identifying which cohorts to include (cohort_definition_id or cohort_name). Cohorts not included will be removed from the cohort set.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

Cohort table with only cohorts in cohortId.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(nPerson = 100)
    
    cdm$cohort1 |> subsetCohorts(cohortId = 1)
    #> # Source:   table<cohort1> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          4 2019-06-09        2019-08-31     
    #>  2                    1          6 1983-03-10        1996-03-21     
    #>  3                    1          7 2013-03-03        2014-09-18     
    #>  4                    1          7 2014-09-19        2014-12-14     
    #>  5                    1          7 2015-04-04        2018-01-18     
    #>  6                    1          8 2013-12-19        2016-08-09     
    #>  7                    1          9 2005-11-05        2005-11-06     
    #>  8                    1          9 2005-11-07        2006-07-18     
    #>  9                    1          9 2006-07-19        2010-07-28     
    #> 10                    1         12 2003-02-09        2007-02-05     
    #> # ℹ more rows
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/sampleCohorts.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Sample a cohort table for a given number of individuals.

Source: [`R/sampleCohorts.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/sampleCohorts.R)

`sampleCohorts.Rd`

`sampleCohorts()` samples an existing cohort table for a given number of people. All records of these individuals are preserved.

## Usage
    
    
    sampleCohorts(cohort, n, cohortId = NULL, name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort))

## Arguments

cohort
    

A cohort table in a cdm reference.

n
    

Number of people to be sampled for each included cohort.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

name
    

Name of the new cohort table created in the cdm object.

## Value

Cohort table with the specified cohorts sampled.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(nPerson = 100)
    
    cdm$cohort2 |> sampleCohorts(cohortId = 1, n = 10)
    #> # Source:   table<cohort2> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1         13 2000-09-24        2000-10-18     
    #>  2                    1         13 2001-01-18        2001-01-20     
    #>  3                    1         15 1988-05-09        2003-06-21     
    #>  4                    1         22 2007-12-28        2009-12-01     
    #>  5                    1         26 2015-03-24        2019-03-08     
    #>  6                    1         34 2017-07-18        2017-12-07     
    #>  7                    1         34 2017-12-08        2018-02-26     
    #>  8                    1         37 2017-03-27        2018-07-25     
    #>  9                    1         60 1988-03-15        1988-06-05     
    #> 10                    1         60 1988-06-06        1991-10-20     
    #> # ℹ more rows
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/copyCohorts.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Copy a cohort table

Source: [`R/copyCohorts.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/copyCohorts.R)

`copyCohorts.Rd`

`copyCohorts()` copies an existing cohort table to a new location.

## Usage
    
    
    copyCohorts(cohort, name, n = 1, cohortId = NULL, .softValidation = TRUE)

## Arguments

cohort
    

A cohort table in a cdm reference.

name
    

Name of the new cohort table created in the cdm object.

n
    

Number of times to duplicate the selected cohorts.

cohortId
    

Vector identifying which cohorts to include (cohort_definition_id or cohort_name). Cohorts not included will be removed from the cohort set.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

A new cohort table containing cohorts from the original cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    cdm$cohort3 <- copyCohorts(cdm$cohort1, n = 2, cohortId = 1, name = "cohort3")
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/yearCohorts.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Generate a new cohort table restricting cohort entries to certain years

Source: [`R/yearCohorts.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/yearCohorts.R)

`yearCohorts.Rd`

`yearCohorts()` splits a cohort into multiple cohorts, one for each year.

## Usage
    
    
    yearCohorts(
      cohort,
      years,
      cohortId = NULL,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

years
    

Numeric vector of years to use to restrict observation to.

cohortId
    

Vector identifying which cohorts to include (cohort_definition_id or cohort_name). Cohorts not included will be removed from the cohort set.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

A cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(nPerson = 100)
    
    cdm$cohort1 <- cdm$cohort1 |> yearCohorts(years = 2000:2002)
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort1)
    #> # A tibble: 3 × 5
    #>   cohort_definition_id cohort_name   target_cohort_definition_id  year
    #>                  <int> <chr>                               <int> <int>
    #> 1                    1 cohort_1_2000                           1  2000
    #> 2                    2 cohort_1_2001                           1  2001
    #> 3                    3 cohort_1_2002                           1  2002
    #> # ℹ 1 more variable: target_cohort_name <chr>
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/stratifyCohorts.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Create a new cohort table from stratifying an existing one

Source: [`R/stratifyCohorts.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/stratifyCohorts.R)

`stratifyCohorts.Rd`

`stratifyCohorts()` creates new cohorts, splitting an existing cohort based on specified columns on which to stratify on.

## Usage
    
    
    stratifyCohorts(
      cohort,
      strata,
      cohortId = NULL,
      removeStrata = TRUE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = TRUE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

strata
    

A strata list that point to columns in cohort table.

cohortId
    

Vector identifying which cohorts to include (cohort_definition_id or cohort_name). Cohorts not included will be removed from the cohort set.

removeStrata
    

Whether to remove strata columns from final cohort table.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

Cohort table stratified.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    
    cdm$my_cohort <- cdm$cohort1 |>
      [addAge](https://darwin-eu.github.io/PatientProfiles/reference/addAge.html)(ageGroup = [list](https://rdrr.io/r/base/list.html)("child" = [c](https://rdrr.io/r/base/c.html)(0, 17), "adult" = [c](https://rdrr.io/r/base/c.html)(18, Inf))) |>
      [addSex](https://darwin-eu.github.io/PatientProfiles/reference/addSex.html)(name = "my_cohort") |>
      stratifyCohorts(
        strata = [list](https://rdrr.io/r/base/list.html)("sex", [c](https://rdrr.io/r/base/c.html)("sex", "age_group")), name = "my_cohort"
      )
    
    cdm$my_cohort
    #> # Source:   table<my_cohort> [?? x 5]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date   age
    #>                   <int>      <int> <date>            <date>          <int>
    #>  1                    1          2 2010-03-30        2010-04-20         55
    #>  2                    1          3 2005-09-25        2007-04-24         46
    #>  3                    1          3 2007-04-25        2007-07-09         48
    #>  4                    1          3 2007-07-10        2007-11-24         48
    #>  5                    1          4 2017-05-07        2017-07-06         35
    #>  6                    1          5 2016-08-28        2016-10-13         53
    #>  7                    1          5 2016-11-01        2016-12-06         53
    #>  8                    2          6 1994-11-23        2001-04-26         26
    #>  9                    2          6 2014-10-27        2014-12-11         46
    #> 10                    1          9 2007-03-19        2007-09-15         22
    #> 11                    3          2 2010-03-30        2010-04-20         55
    #> 12                    3          3 2005-09-25        2007-04-24         46
    #> 13                    3          3 2007-04-25        2007-07-09         48
    #> 14                    3          3 2007-07-10        2007-11-24         48
    #> 15                    3          4 2017-05-07        2017-07-06         35
    #> 16                    3          5 2016-08-28        2016-10-13         53
    #> 17                    3          5 2016-11-01        2016-12-06         53
    #> 18                    4          6 1994-11-23        2001-04-26         26
    #> 19                    4          6 2014-10-27        2014-12-11         46
    #> 20                    3          9 2007-03-19        2007-09-15         22
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$my_cohort)
    #> # A tibble: 4 × 8
    #>   cohort_definition_id cohort_name           target_cohort_id target_cohort_name
    #>                  <int> <chr>                            <int> <chr>             
    #> 1                    1 cohort_1_female                      1 cohort_1          
    #> 2                    2 cohort_1_male                        1 cohort_1          
    #> 3                    3 cohort_1_female_adult                1 cohort_1          
    #> 4                    4 cohort_1_male_adult                  1 cohort_1          
    #> # ℹ 4 more variables: target_cohort_table_name <chr>, strata_columns <chr>,
    #> #   sex <chr>, age_group <chr>
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cdm$my_cohort)
    #> # A tibble: 10 × 7
    #>    cohort_definition_id number_records number_subjects reason_id reason         
    #>                   <int>          <int>           <int>     <int> <chr>          
    #>  1                    1             10               6         1 Initial qualif…
    #>  2                    1              8               5         2 filter strata:…
    #>  3                    2             10               6         1 Initial qualif…
    #>  4                    2              2               1         2 filter strata:…
    #>  5                    3             10               6         1 Initial qualif…
    #>  6                    3              8               5         2 filter strata:…
    #>  7                    3              8               5         3 filter strata:…
    #>  8                    4             10               6         1 Initial qualif…
    #>  9                    4              2               1         2 filter strata:…
    #> 10                    4              2               1         3 filter strata:…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/intersectCohorts.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Generate a combination cohort set between the intersection of different cohorts.

Source: [`R/intersectCohorts.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/intersectCohorts.R)

`intersectCohorts.Rd`

`intersectCohorts()` combines different cohort entries, with those records that overlap combined and kept. Cohort entries are when an individual was in _both_ of the cohorts.

## Usage
    
    
    intersectCohorts(
      cohort,
      cohortId = NULL,
      gap = 0,
      returnNonOverlappingCohorts = FALSE,
      keepOriginalCohorts = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

cohortId
    

Vector identifying which cohorts to include (cohort_definition_id or cohort_name). Cohorts not included will be removed from the cohort set.

gap
    

Number of days between two subsequent cohort entries to be merged in a single cohort record.

returnNonOverlappingCohorts
    

Whether the generated cohorts are mutually exclusive or not.

keepOriginalCohorts
    

If TRUE the original cohorts will be return together with the new ones. If FALSE only the new cohort will be returned.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

A cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(nPerson = 100)
    
    cdm$cohort3 <- intersectCohorts(
      cohort = cdm$cohort2,
      name = "cohort3",
    )
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort3)
    #> # A tibble: 1 × 5
    #>   cohort_definition_id cohort_name         gap cohort_1 cohort_2
    #>                  <int> <chr>             <dbl>    <dbl>    <dbl>
    #> 1                    1 cohort_1_cohort_2     0        1        1
    
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/matchCohorts.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Generate a new cohort matched cohort

Source: [`R/matchCohorts.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/matchCohorts.R)

`matchCohorts.Rd`

`matchCohorts()` generate a new cohort matched to individuals in an existing cohort. Individuals can be matched based on year of birth and sex. Matching is done at the record level, so if individuals have multiple cohort entries they can be matched to different individuals for each of their records.

Two new cohorts will be created when matching. The first is those cohort entries which were matched ("_sampled" is added to the original cohort name for this cohort). The other is the matches found from the database population ("_matched" is added to the original cohort name for this cohort).

## Usage
    
    
    matchCohorts(
      cohort,
      cohortId = NULL,
      matchSex = TRUE,
      matchYearOfBirth = TRUE,
      ratio = 1,
      keepOriginalCohorts = FALSE,
      name = [tableName](https://darwin-eu.github.io/omopgenerics/reference/tableName.html)(cohort),
      .softValidation = FALSE
    )

## Arguments

cohort
    

A cohort table in a cdm reference.

cohortId
    

Vector identifying which cohorts to include (cohort_definition_id or cohort_name). Cohorts not included will be removed from the cohort set.

matchSex
    

Whether to match in sex.

matchYearOfBirth
    

Whether to match in year of birth.

ratio
    

Number of allowed matches per individual in the target cohort.

keepOriginalCohorts
    

If TRUE the original cohorts will be return together with the new ones. If FALSE only the new cohort will be returned.

name
    

Name of the new cohort table created in the cdm object.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

A cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    #> 
    #> Attaching package: ‘dplyr’
    #> The following objects are masked from ‘package:stats’:
    #> 
    #>     filter, lag
    #> The following objects are masked from ‘package:base’:
    #> 
    #>     intersect, setdiff, setequal, union
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(nPerson = 200)
    cdm$new_matched_cohort <- cdm$cohort2 |>
      matchCohorts(
        name = "new_matched_cohort",
        cohortId = 2,
        matchSex = TRUE,
        matchYearOfBirth = TRUE,
        ratio = 1)
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
    cdm$new_matched_cohort
    #> # Source:   table<new_matched_cohort> [?? x 5]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date cluster_id
    #>                   <int>      <int> <date>            <date>               <dbl>
    #>  1                    1        120 1987-10-15        2000-11-18               6
    #>  2                    1         56 1996-06-26        2001-01-03              64
    #>  3                    1        103 2007-02-18        2009-10-14              17
    #>  4                    1         21 2015-11-07        2016-01-23              20
    #>  5                    1         62 2012-12-24        2014-11-08              38
    #>  6                    1        135 2009-03-10        2009-06-20              52
    #>  7                    1         84 2005-07-02        2005-08-31               1
    #>  8                    1         17 1987-06-26        1987-10-08               3
    #>  9                    1        108 1999-11-14        1999-11-23              12
    #> 10                    1         75 2015-10-20        2016-09-24             108
    #> # ℹ more rows
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/mockCohortConstructor.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Function to create a mock cdm reference for CohortConstructor

Source: [`R/mockCohortConstructor.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/mockCohortConstructor.R)

`mockCohortConstructor.Rd`

`mockCohortConstructor()` creates an example dataset that can be used for demonstrating and testing the package

## Usage
    
    
    mockCohortConstructor(
      nPerson = 10,
      conceptTable = NULL,
      tables = NULL,
      conceptId = NULL,
      conceptIdClass = NULL,
      drugExposure = FALSE,
      conditionOccurrence = FALSE,
      measurement = FALSE,
      death = FALSE,
      otherTables = NULL,
      con = DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)()),
      writeSchema = "main",
      seed = 123
    )

## Arguments

nPerson
    

number of person in the cdm

conceptTable
    

user defined concept table

tables
    

list of tables to include in the cdm

conceptId
    

list of concept id

conceptIdClass
    

the domain class of the conceptId

drugExposure
    

T/F include drug exposure table in the cdm

conditionOccurrence
    

T/F include condition occurrence in the cdm

measurement
    

T/F include measurement in the cdm

death
    

T/F include death table in the cdm

otherTables
    

it takes a list of single tibble with names to include other tables in the cdm

con
    

A DBI connection to create the cdm mock object.

writeSchema
    

Name of an schema on the same connection with writing permissions.

seed
    

Seed passed to omock::mockCdmFromTable

## Value

cdm object

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- mockCohortConstructor()
    
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of mock database ──────────────────────────────
    #> • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
    #> concept_synonym, drug_strength, observation_period, person, vocabulary
    #> • cohort tables: cohort1, cohort2
    #> • achilles tables: -
    #> • other tables: -
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/benchmarkCohortConstructor.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Run benchmark of CohortConstructor package

Source: [`R/benchmark.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/benchmark.R)

`benchmarkCohortConstructor.Rd`

Run benchmark of CohortConstructor cohort instantiation time compared to CIRCE from JSON. More information in the benchmarking vignette.

## Usage
    
    
    benchmarkCohortConstructor(
      cdm,
      runCIRCE = TRUE,
      runCohortConstructorDefinition = TRUE,
      runCohortConstructorDomain = TRUE,
      dropCohorts = TRUE
    )

## Arguments

cdm
    

A cdm reference.

runCIRCE
    

Whether to run cohorts from JSON definitions generated with Atlas.

runCohortConstructorDefinition
    

Whether to run the benchmark part where cohorts are created with CohortConstructor by definition (one by one, separately).

runCohortConstructorDomain
    

Whether to run the benchmark part where cohorts are created with CohortConstructor by domain (instantianting base cohort all together, as a set).

dropCohorts
    

Whether to drop cohorts created during benchmark.

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/benchmarkData.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Benchmarking results

Source: [`R/data.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/data.R)

`benchmarkData.Rd`

Benchmarking results

## Usage
    
    
    benchmarkData

## Format

A list of results from benchmarking

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/renameCohort.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Utility function to change the name of a cohort.

Source: [`R/renameCohort.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/renameCohort.R)

`renameCohort.Rd`

Utility function to change the name of a cohort.

## Usage
    
    
    renameCohort(cohort, cohortId, newCohortName, .softValidation = TRUE)

## Arguments

cohort
    

A cohort table in a cdm reference.

cohortId
    

Vector identifying which cohorts to modify (cohort_definition_id or cohort_name). If NULL, all cohorts will be used; otherwise, only the specified cohorts will be modified, and the rest will remain unchanged.

newCohortName
    

Character vector with same

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

A cohort_table object.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(nPerson = 100)
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort1)
    #> # A tibble: 1 × 2
    #>   cohort_definition_id cohort_name
    #>                  <int> <chr>      
    #> 1                    1 cohort_1   
    
    cdm$cohort1 <- cdm$cohort1 |>
      renameCohort(cohortId = 1, newCohortName = "new_name")
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$cohort1)
    #> # A tibble: 1 × 2
    #>   cohort_definition_id cohort_name
    #>                  <int> <chr>      
    #> 1                    1 new_name   
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/CohortConstructor/reference/addCohortTableIndex.html

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Add an index to a cohort table

Source: [`R/addIndex.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/addIndex.R)

`addCohortTableIndex.Rd`

Adds an index on subject_id and cohort_start_date to a cohort table. Note, currently only indexes will be added if the table is in a postgres database.

## Usage
    
    
    addCohortTableIndex(cohort)

## Arguments

cohort
    

A cohort table in a cdm reference.

## Value

The cohort table

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
