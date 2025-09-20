# Build and Manipulate Study Cohorts Using a Common Data Model • CohortConstructor

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
