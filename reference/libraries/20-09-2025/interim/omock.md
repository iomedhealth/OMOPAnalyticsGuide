# Content from https://ohdsi.github.io/omock/


---

## Content from https://ohdsi.github.io/omock/

Skip to contents

[omock](index.html) 0.5.0.9000

  * [Reference](reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](logo.png)

# omock 

The primary objective of the omock package is to generate mock OMOP CDM (Observational Medical Outcomes Partnership Common Data Model) data to facilitating the testing of various packages within the OMOPverse ecosystem.

## Introduction

You can install the development version of omock using:
    
    
    # install.packages("devtools")
    devtools::install_github("OHDSI/omock")

## Example

With omock we can quickly make a simple mock of OMOP CDM data.
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))

We first start by making an empty cdm reference. This includes the person and observation tables (as they are required) but they are currently empty.
    
    
    cdm <- [emptyCdmReference](https://darwin-eu.github.io/omopgenerics/reference/emptyCdmReference.html)(cdmName = "mock")
    cdm$person [%>%](https://magrittr.tidyverse.org/reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 0
    #> Columns: 18
    #> $ person_id                   <int> 
    #> $ gender_concept_id           <int> 
    #> $ year_of_birth               <int> 
    #> $ month_of_birth              <int> 
    #> $ day_of_birth                <int> 
    #> $ birth_datetime              <date> 
    #> $ race_concept_id             <int> 
    #> $ ethnicity_concept_id        <int> 
    #> $ location_id                 <int> 
    #> $ provider_id                 <int> 
    #> $ care_site_id                <int> 
    #> $ person_source_value         <chr> 
    #> $ gender_source_value         <chr> 
    #> $ gender_source_concept_id    <int> 
    #> $ race_source_value           <chr> 
    #> $ race_source_concept_id      <int> 
    #> $ ethnicity_source_value      <chr> 
    #> $ ethnicity_source_concept_id <int>
    cdm$observation_period [%>%](https://magrittr.tidyverse.org/reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 0
    #> Columns: 5
    #> $ observation_period_id         <int> 
    #> $ person_id                     <int> 
    #> $ observation_period_start_date <date> 
    #> $ observation_period_end_date   <date> 
    #> $ period_type_concept_id        <int>

Once we have have our empty cdm reference, we can quickly add a person table with a specific number of individuals.
    
    
    cdm <- cdm [%>%](https://magrittr.tidyverse.org/reference/pipe.html)
      omock::[mockPerson](reference/mockPerson.html)(nPerson = 1000)
    
    cdm$person [%>%](https://magrittr.tidyverse.org/reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1,000
    #> Columns: 18
    #> $ person_id                   <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,…
    #> $ gender_concept_id           <int> 8532, 8532, 8507, 8532, 8507, 8532, 8532, …
    #> $ year_of_birth               <int> 1988, 1994, 1996, 2000, 1973, 1970, 1986, …
    #> $ month_of_birth              <int> 3, 3, 5, 3, 11, 1, 4, 7, 2, 9, 4, 5, 2, 7,…
    #> $ day_of_birth                <int> 28, 23, 20, 14, 8, 26, 1, 21, 23, 2, 7, 31…
    #> $ race_concept_id             <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ ethnicity_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ birth_datetime              <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ location_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ provider_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ care_site_id                <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ person_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ gender_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ gender_source_concept_id    <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ race_source_value           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ race_source_concept_id      <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ ethnicity_source_value      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ ethnicity_source_concept_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…

We can then fill in the observation period table for these individuals.
    
    
    cdm <- cdm [%>%](https://magrittr.tidyverse.org/reference/pipe.html)
      omock::[mockObservationPeriod](reference/mockObservationPeriod.html)()
    
    cdm$observation_period [%>%](https://magrittr.tidyverse.org/reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1,000
    #> Columns: 5
    #> $ observation_period_id         <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…
    #> $ person_id                     <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…
    #> $ observation_period_start_date <date> 2000-12-12, 2003-12-17, 2004-10-05, 200…
    #> $ observation_period_end_date   <date> 2010-11-16, 2019-08-27, 2019-05-12, 201…
    #> $ period_type_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …

## Links

  * [View on CRAN](https://cloud.r-project.org/package=omock)
  * [Browse source code](https://github.com/ohdsi/omock/)
  * [Report a bug](https://github.com/ohdsi/omock/issues)



## License

  * [Full license](LICENSE.html)
  * Apache License (>= 2)



## Community

  * [Contributing guide](CONTRIBUTING.html)



## Citation

  * [Citing omock](authors.html#citation)



## Developers

  * Mike Du   
Author, maintainer  [](https://orcid.org/0000-0002-9517-8834)
  * Marti Catala   
Author  [](https://orcid.org/0000-0003-3308-9905)
  * Edward Burn   
Author  [](https://orcid.org/0000-0002-9286-1128)
  * Nuria Mercade-Besora   
Author  [](https://orcid.org/0009-0006-7948-3747)
  * Xihang Chen   
Author  [](https://orcid.org/0009-0001-8112-8959)



## Dev status

  * [![R-CMD-check](https://github.com/OHDSI/omock/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/OHDSI/omock/actions/workflows/R-CMD-check.yaml)
  * [![Codecov test coverage](https://codecov.io/gh/OHDSI/omock/branch/main/graph/badge.svg)](https://app.codecov.io/gh/OHDSI/omock?branch=main)
  * [![DOI](https://joss.theoj.org/papers/10.21105/joss.08178/status.svg)](https://doi.org/10.21105/joss.08178)



Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/index.html

Skip to contents

[omock](index.html) 0.5.0.9000

  * [Reference](reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](logo.png)

# omock 

The primary objective of the omock package is to generate mock OMOP CDM (Observational Medical Outcomes Partnership Common Data Model) data to facilitating the testing of various packages within the OMOPverse ecosystem.

## Introduction

You can install the development version of omock using:
    
    
    # install.packages("devtools")
    devtools::install_github("OHDSI/omock")

## Example

With omock we can quickly make a simple mock of OMOP CDM data.
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))

We first start by making an empty cdm reference. This includes the person and observation tables (as they are required) but they are currently empty.
    
    
    cdm <- [emptyCdmReference](https://darwin-eu.github.io/omopgenerics/reference/emptyCdmReference.html)(cdmName = "mock")
    cdm$person [%>%](https://magrittr.tidyverse.org/reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 0
    #> Columns: 18
    #> $ person_id                   <int> 
    #> $ gender_concept_id           <int> 
    #> $ year_of_birth               <int> 
    #> $ month_of_birth              <int> 
    #> $ day_of_birth                <int> 
    #> $ birth_datetime              <date> 
    #> $ race_concept_id             <int> 
    #> $ ethnicity_concept_id        <int> 
    #> $ location_id                 <int> 
    #> $ provider_id                 <int> 
    #> $ care_site_id                <int> 
    #> $ person_source_value         <chr> 
    #> $ gender_source_value         <chr> 
    #> $ gender_source_concept_id    <int> 
    #> $ race_source_value           <chr> 
    #> $ race_source_concept_id      <int> 
    #> $ ethnicity_source_value      <chr> 
    #> $ ethnicity_source_concept_id <int>
    cdm$observation_period [%>%](https://magrittr.tidyverse.org/reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 0
    #> Columns: 5
    #> $ observation_period_id         <int> 
    #> $ person_id                     <int> 
    #> $ observation_period_start_date <date> 
    #> $ observation_period_end_date   <date> 
    #> $ period_type_concept_id        <int>

Once we have have our empty cdm reference, we can quickly add a person table with a specific number of individuals.
    
    
    cdm <- cdm [%>%](https://magrittr.tidyverse.org/reference/pipe.html)
      omock::[mockPerson](reference/mockPerson.html)(nPerson = 1000)
    
    cdm$person [%>%](https://magrittr.tidyverse.org/reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1,000
    #> Columns: 18
    #> $ person_id                   <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,…
    #> $ gender_concept_id           <int> 8532, 8532, 8507, 8532, 8507, 8532, 8532, …
    #> $ year_of_birth               <int> 1988, 1994, 1996, 2000, 1973, 1970, 1986, …
    #> $ month_of_birth              <int> 3, 3, 5, 3, 11, 1, 4, 7, 2, 9, 4, 5, 2, 7,…
    #> $ day_of_birth                <int> 28, 23, 20, 14, 8, 26, 1, 21, 23, 2, 7, 31…
    #> $ race_concept_id             <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ ethnicity_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ birth_datetime              <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ location_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ provider_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ care_site_id                <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ person_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ gender_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ gender_source_concept_id    <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ race_source_value           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ race_source_concept_id      <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ ethnicity_source_value      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ ethnicity_source_concept_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…

We can then fill in the observation period table for these individuals.
    
    
    cdm <- cdm [%>%](https://magrittr.tidyverse.org/reference/pipe.html)
      omock::[mockObservationPeriod](reference/mockObservationPeriod.html)()
    
    cdm$observation_period [%>%](https://magrittr.tidyverse.org/reference/pipe.html)
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1,000
    #> Columns: 5
    #> $ observation_period_id         <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…
    #> $ person_id                     <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…
    #> $ observation_period_start_date <date> 2000-12-12, 2003-12-17, 2004-10-05, 200…
    #> $ observation_period_end_date   <date> 2010-11-16, 2019-08-27, 2019-05-12, 201…
    #> $ period_type_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …

## Links

  * [View on CRAN](https://cloud.r-project.org/package=omock)
  * [Browse source code](https://github.com/ohdsi/omock/)
  * [Report a bug](https://github.com/ohdsi/omock/issues)



## License

  * [Full license](LICENSE.html)
  * Apache License (>= 2)



## Community

  * [Contributing guide](CONTRIBUTING.html)



## Citation

  * [Citing omock](authors.html#citation)



## Developers

  * Mike Du   
Author, maintainer  [](https://orcid.org/0000-0002-9517-8834)
  * Marti Catala   
Author  [](https://orcid.org/0000-0003-3308-9905)
  * Edward Burn   
Author  [](https://orcid.org/0000-0002-9286-1128)
  * Nuria Mercade-Besora   
Author  [](https://orcid.org/0009-0006-7948-3747)
  * Xihang Chen   
Author  [](https://orcid.org/0009-0001-8112-8959)



## Dev status

  * [![R-CMD-check](https://github.com/OHDSI/omock/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/OHDSI/omock/actions/workflows/R-CMD-check.yaml)
  * [![Codecov test coverage](https://codecov.io/gh/OHDSI/omock/branch/main/graph/badge.svg)](https://app.codecov.io/gh/OHDSI/omock?branch=main)
  * [![DOI](https://joss.theoj.org/papers/10.21105/joss.08178/status.svg)](https://doi.org/10.21105/joss.08178)



Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/index.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Package index

## Mock CDM Initialization

This group includes functions that initialize the foundational structures required for the mock CDM environment.

`[mockCdmReference()](mockCdmReference.html)`
    Creates an empty CDM (Common Data Model) reference for a mock database.

`[mockCdmFromTables()](mockCdmFromTables.html)`
    Generates a mock CDM (Common Data Model) object based on existing CDM structures and additional tables.

`[mockCdmFromDataset()](mockCdmFromDataset.html)`
    Create a `local` cdm_reference from a dataset.

## Mock Datasets

This group of functions are utility functions to work with the mock datasets.

`[mockDatasets](mockDatasets.html)`
    Available mock OMOP CDM Synthetic Datasets

`[downloadMockDataset()](downloadMockDataset.html)`
    Download an OMOP Synthetic dataset.

`[availableMockDatasets()](availableMockDatasets.html)`
    List the available datasets

`[isMockDatasetDownloaded()](isMockDatasetDownloaded.html)`
    Check if a certain dataset is downloaded.

`[mockDatasetsStatus()](mockDatasetsStatus.html)`
    Check the availability of the OMOP CDM datasets.

`[mockDatasetsFolder()](mockDatasetsFolder.html)`
    Check or set the datasets Folder

## Mock Table Creation

These functions are focused on adding mock data tables based on the initialized CDM structure.

`[mockPerson()](mockPerson.html)`
    Generates a mock person table and integrates it into an existing CDM object.

`[mockObservationPeriod()](mockObservationPeriod.html)`
    Generates a mock observation period table and integrates it into an existing CDM object.

`[mockConditionOccurrence()](mockConditionOccurrence.html)`
    Generates a mock condition occurrence table and integrates it into an existing CDM object.

`[mockDrugExposure()](mockDrugExposure.html)`
    Generates a mock drug exposure table and integrates it into an existing CDM object.

`[mockMeasurement()](mockMeasurement.html)`
    Generates a mock measurement table and integrates it into an existing CDM object.

`[mockObservation()](mockObservation.html)`
    Generates a mock observation table and integrates it into an existing CDM object.

`[mockProcedureOccurrence()](mockProcedureOccurrence.html)`
    Generates a mock procedure occurrence table and integrates it into an existing CDM object.

`[mockDeath()](mockDeath.html)`
    Generates a mock death table and integrates it into an existing CDM object.

`[mockVisitOccurrence()](mockVisitOccurrence.html)`
    Function to generate visit occurrence table

## Vocabulary Tables Creation

This group includes functions that set up vocabulary tables.

`[mockVocabularyTables()](mockVocabularyTables.html)`
    Creates a mock CDM database populated with various vocabulary tables.

`[mockConcepts()](mockConcepts.html)`
    Adds mock concept data to a concept table within a Common Data Model (CDM) object.

`[mockVocabularySet()](mockVocabularySet.html)`
    Creates an empty mock CDM database populated with various vocabulary tables set.

## Cohort Tables Creation

These functions are focused on adding mock cohort tables based on the initialized CDM structure.

`[mockCohort()](mockCohort.html)`
    Generate Synthetic Cohort

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/articles/a01_Creating_synthetic_clinical_tables.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Creating synthetic clinical tables

Source: [`vignettes/a01_Creating_synthetic_clinical_tables.Rmd`](https://github.com/ohdsi/omock/blob/main/vignettes/a01_Creating_synthetic_clinical_tables.Rmd)

`a01_Creating_synthetic_clinical_tables.Rmd`

The omock package provides functionality to quickly create a cdm reference containing synthetic data based on population settings specified by the user.

First, let’s load packages required for this vignette.
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))

Now, in three lines of code, we can create a cdm reference with a person and observation period table for 1000 people.
    
    
    cdm <- [emptyCdmReference](https://darwin-eu.github.io/omopgenerics/reference/emptyCdmReference.html)(cdmName = "synthetic cdm") |>
      [mockPerson](../reference/mockPerson.html)(nPerson = 1000) |>
      [mockObservationPeriod](../reference/mockObservationPeriod.html)()
    
    cdm
    #> 
    #> ── # OMOP CDM reference (local) of synthetic cdm ───────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    
    cdm$person |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1,000
    #> Columns: 18
    #> $ person_id                   <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,…
    #> $ gender_concept_id           <int> 8532, 8532, 8532, 8507, 8532, 8507, 8507, …
    #> $ year_of_birth               <int> 1991, 1998, 1981, 1956, 1985, 1961, 1982, …
    #> $ month_of_birth              <int> 10, 11, 5, 2, 2, 6, 1, 3, 2, 5, 3, 6, 2, 1…
    #> $ day_of_birth                <int> 15, 24, 22, 23, 9, 4, 3, 22, 28, 3, 26, 4,…
    #> $ race_concept_id             <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ ethnicity_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ birth_datetime              <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ location_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ provider_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ care_site_id                <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ person_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ gender_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ gender_source_concept_id    <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ race_source_value           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ race_source_concept_id      <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ ethnicity_source_value      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    #> $ ethnicity_source_concept_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    
    cdm$observation_period |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1,000
    #> Columns: 5
    #> $ observation_period_id         <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…
    #> $ person_id                     <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…
    #> $ observation_period_start_date <date> 2007-03-18, 2005-12-23, 2016-07-23, 201…
    #> $ observation_period_end_date   <date> 2018-05-20, 2014-02-14, 2018-08-23, 201…
    #> $ period_type_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …

We can add further requirements around the population we create. For example we can require that they were born between 1960 and 1980 like so.
    
    
    cdm <- [emptyCdmReference](https://darwin-eu.github.io/omopgenerics/reference/emptyCdmReference.html)(cdmName = "synthetic cdm") |>
      [mockPerson](../reference/mockPerson.html)(
        nPerson = 1000,
        birthRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("1960-01-01", "1980-12-31"))
      ) |>
      [mockObservationPeriod](../reference/mockObservationPeriod.html)()
    
    
    cdm$person |>
      [collect](https://dplyr.tidyverse.org/reference/compute.html)() |>
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)() +
      [geom_histogram](https://ggplot2.tidyverse.org/reference/geom_histogram.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)([as.integer](https://rdrr.io/r/base/integer.html)(year_of_birth)),
        binwidth = 1, colour = "grey"
      ) +
      [theme_minimal](https://ggplot2.tidyverse.org/reference/ggtheme.html)() +
      [xlab](https://ggplot2.tidyverse.org/reference/labs.html)("Year of birth")

![](a01_Creating_synthetic_clinical_tables_files/figure-html/unnamed-chunk-5-1.png)

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/articles/a02_Creating_synthetic_cohorts.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Creating synthetic cohorts

Source: [`vignettes/a02_Creating_synthetic_cohorts.Rmd`](https://github.com/ohdsi/omock/blob/main/vignettes/a02_Creating_synthetic_cohorts.Rmd)

`a02_Creating_synthetic_cohorts.Rmd`
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))

Here we explain making a mock cohort table using mockCohort(). mockCohort() is designed to generate synthetic cohorts within a given CDM reference. It allows for the creation of multiple cohorts with specified names and the expected number of records per person. This can be useful for testing, simulations, or educational purposes where real patient data cannot be used.

The mockCohort() function has several different arguments to help user to tailored the synthetic cohort creation process. The cdm argument represents the local CDM reference into which the synthetic cohort will be integrated. The tableName argument specifies the name of the table within the CDM to store the cohort data. For scenarios necessitating multiple cohorts, the numberCohorts argument determines how many distinct cohorts to generate within the table, defaulting to 1. The cohortName argument allows for the assignment of names to the created cohorts, supporting either a single name or a vector of names for multiple cohorts. Additionally, the recordPerson argument indicates the expected number of records per person in each cohort. Lastly, the seed argument is used to set a random seed, ensuring the reproducibility of the generated data.

**Example**

The example provided in the vignette demonstrates how to use the mockCohort function within a pipeline that includes generating a mock CDM reference, adding mock persons, and observation periods before finally adding the mock cohorts. This showcases a typical workflow for setting up a synthetic CDM with multiple components for testing or analysis.
    
    
    cdm <- [mockCdmReference](../reference/mockCdmReference.html)() |>
      [mockPerson](../reference/mockPerson.html)(nPerson = 100) |>
      [mockObservationPeriod](../reference/mockObservationPeriod.html)() |>
      [mockCohort](../reference/mockCohort.html)(
        name = "omock_example",
        numberCohorts = 2,
        cohortName = [c](https://rdrr.io/r/base/c.html)("omock_cohort_1", "omock_cohort_2")
      )
    
    cdm
    #> 
    #> ── # OMOP CDM reference (local) of mock database ───────────────────────────────
    #> • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
    #> concept_synonym, drug_strength, observation_period, person, vocabulary
    #> • cohort tables: omock_example
    #> • achilles tables: -
    #> • other tables: -

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/articles/a03_Creating_a_synthetic_vocabulary.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Creating synthetic vocabulary Tables with omock

Source: [`vignettes/a03_Creating_a_synthetic_vocabulary.Rmd`](https://github.com/ohdsi/omock/blob/main/vignettes/a03_Creating_a_synthetic_vocabulary.Rmd)

`a03_Creating_a_synthetic_vocabulary.Rmd`

The `omock` R package provides functions to build and populate mock or user’s bespoke vocabulary tables for their mock cdm.In this vignette, we’ll show how to use the `[mockVocabularyTables()](../reference/mockVocabularyTables.html)` function to initialize standard OMOP vocabulary tables within a mock CDM reference.

First, let’s load packages required for this vignette.
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))

Then we start off with creating an `cdm` object.
    
    
    cdm <- [emptyCdmReference](https://darwin-eu.github.io/omopgenerics/reference/emptyCdmReference.html)(cdmName = "synthetic cdm") |>
      [mockPerson](../reference/mockPerson.html)(nPerson = 10, birthRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("1960-01-01", "1980-12-31"))) |>
      [mockObservationPeriod](../reference/mockObservationPeriod.html)()

To populate this cdm object with synthetic vocabulary table, we simply use the `[mockVocabularyTables()](../reference/mockVocabularyTables.html)` function. The `omock` package comes with two set mock vocabulary tables at the moment. “mock” and “Eunomia”, the “mock” vocabulary set contain a very small subset of vocabularies from the CPRD database and “Eunomia” is the vocabulary set from the eunomia test database. <https://ohdsi.github.io/Eunomia/>.
    
    
    cdm <- [mockVocabularyTables](../reference/mockVocabularyTables.html)(cdm, vocabularySet = "mock")
    cdm$vocabulary |> [print](https://rdrr.io/r/base/print.html)()
    #> # A tibble: 65 × 5
    #>    vocabulary_id        vocabulary_name  vocabulary_reference vocabulary_version
    #>  * <chr>                <chr>            <chr>                <chr>             
    #>  1 ABMS                 Provider Specia… http://www.abms.org… mock              
    #>  2 ATC                  WHO Anatomic Th… http://www.whocc.no… mock              
    #>  3 CDM                  OMOP Common Dat… https://github.com/… mock              
    #>  4 CMS Place of Service Place of Servic… http://www.cms.gov/… mock              
    #>  5 Cohort Type          OMOP Cohort Type OMOP generated       mock              
    #>  6 Concept Class        OMOP Concept Cl… OMOP generated       mock              
    #>  7 Condition Status     OMOP Condition … OMOP generated       mock              
    #>  8 Condition Type       OMOP Condition … OMOP generated       mock              
    #>  9 Cost                 OMOP Cost        OMOP generated       mock              
    #> 10 Cost Type            OMOP Cost Type   OMOP generated       mock              
    #> # ℹ 55 more rows
    #> # ℹ 1 more variable: vocabulary_concept_id <int>

set vocabularySet to eunomia to create the cdm with eunomia vocabulary table.
    
    
    cdm <- [mockVocabularyTables](../reference/mockVocabularyTables.html)(cdm, vocabularySet = "eunomia")
    cdm$vocabulary |> [print](https://rdrr.io/r/base/print.html)()
    #> # A tibble: 125 × 5
    #>    vocabulary_id vocabulary_name         vocabulary_reference vocabulary_version
    #>  * <chr>         <chr>                   <chr>                <chr>             
    #>  1 ABMS          Provider Specialty (Am… http://www.abms.org… 2018-06-26 ABMS   
    #>  2 AMT           Australian Medicines T… https://www.nehta.g… AMT 01-SEP-17     
    #>  3 APC           Ambulatory Payment Cla… http://www.cms.gov/… 2018-January-Adde…
    #>  4 ATC           WHO Anatomic Therapeut… FDB UK distribution… RXNORM 2018-08-12 
    #>  5 BDPM          Public Database of Med… http://base-donnees… BDPM 17-JUL-17    
    #>  6 CDM           OMOP Common DataModel   https://github.com/… CDM v6.0.0        
    #>  7 CDT           Current Dental Termino… http://www.nlm.nih.… 2018 Release      
    #>  8 CIEL          Columbia International… https://wiki.openmr… Openmrs 1.11.0 20…
    #>  9 Cohort        Legacy OMOP HOI or DOI… OMOP generated       NA                
    #> 10 Cohort Type   OMOP Cohort Type        OMOP generated       NA                
    #> # ℹ 115 more rows
    #> # ℹ 1 more variable: vocabulary_concept_id <int>

You can also edit any vocabulary table with your own bespoke vocabulary, for example if you want to insert your own bespoke concept table. you can do below.
    
    
    myConceptTable <- [data.frame](https://rdrr.io/r/base/data.frame.html)(
      concept_id = 1:3,
      concept_name = [c](https://rdrr.io/r/base/c.html)("Condition A", "Condition B", "Drug C"),
      domain_id = [c](https://rdrr.io/r/base/c.html)("Condition", "Condition", "Drug"),
      vocabulary_id = [c](https://rdrr.io/r/base/c.html)("SNOMED", "SNOMED", "RxNorm"),
      concept_class_id = [c](https://rdrr.io/r/base/c.html)("Clinical Finding", "Clinical Finding", "Ingredient"),
      standard_concept = [c](https://rdrr.io/r/base/c.html)("S", "S", "S"),
      concept_code = [c](https://rdrr.io/r/base/c.html)("111", "222", "333"),
      valid_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("1970-01-01"),
      valid_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2099-12-31"),
      invalid_reason = NA
    )
    
    cdm <- [mockVocabularyTables](../reference/mockVocabularyTables.html)(cdm, 
                                vocabularySet = "eunomia",
                                concept = myConceptTable) 
    
    cdm$concept |> [print](https://rdrr.io/r/base/print.html)()
    #> # A tibble: 3 × 10
    #>   concept_id concept_name domain_id vocabulary_id concept_class_id
    #> *      <int> <chr>        <chr>     <chr>         <chr>           
    #> 1          1 Condition A  Condition SNOMED        Clinical Finding
    #> 2          2 Condition B  Condition SNOMED        Clinical Finding
    #> 3          3 Drug C       Drug      RxNorm        Ingredient      
    #> # ℹ 5 more variables: standard_concept <chr>, concept_code <chr>,
    #> #   valid_start_date <date>, valid_end_date <date>, invalid_reason <lgl>

As you can see mockVocabularyTables() allows you to populate a mock CDM with custom vocabulary tables, it provided two different vocabulary set for you to choose from and also give you the flexibility to modify it with your own custom vocabulary tables.

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/articles/a04_Building_a_bespoke_mock_cdm.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Building a bespoke mock cdm

Source: [`vignettes/a04_Building_a_bespoke_mock_cdm.Rmd`](https://github.com/ohdsi/omock/blob/main/vignettes/a04_Building_a_bespoke_mock_cdm.Rmd)

`a04_Building_a_bespoke_mock_cdm.Rmd`
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([lubridate](https://lubridate.tidyverse.org))

There are times where the user will want to create a mock CDM reference from its own bespoke tables. The mockCdmFromTables() function is designed to facilitates the creation of mock CDM reference from bespoke tables.For example if you want to create a CDM reference based on below bespoke cohorts. You can do it simple using the mockCdmFromTable() functions in a few lines of code.
    
    
    # Define a list of user-defined cohort tables
    cohortTables <- [list](https://rdrr.io/r/base/list.html)(
      cohort1 = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        subject_id = 1:10,
        cohort_definition_id = [rep](https://rdrr.io/r/base/rep.html)(1, 10),
        cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-01") + 1:10,
        cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-01") + 11:20
      ),
      cohort2 = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        subject_id = 11:20,
        cohort_definition_id = [rep](https://rdrr.io/r/base/rep.html)(2, 10),
        cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-02-01") + 1:10,
        cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-02-01") + 11:20
      )
    )
    
    # Create a mock CDM object from the user-defined tables
    cdm <- [mockCdmReference](../reference/mockCdmReference.html)() |> [mockCdmFromTables](../reference/mockCdmFromTables.html)(tables = cohortTables)
    
    cdm |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> A cdm reference of mock database with 11 tables: person, observation_period, cdm_source, concept, vocabulary, concept_relationship, concept_synonym, concept_ancestor, drug_strength, cohort1, and cohort2.

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/news/index.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Changelog

Source: [`NEWS.md`](https://github.com/ohdsi/omock/blob/main/NEWS.md)

## omock (development version)

  * Efficient filtering of the drug_strength table by [@catalamarti](https://github.com/catalamarti) [#181](https://github.com/ohdsi/omock/issues/181)



## omock 0.5.0

CRAN release: 2025-09-01

  * add option source to `mockCdmFromDataset` by [@catalamarti](https://github.com/catalamarti) [#158](https://github.com/ohdsi/omock/issues/158)



## omock 0.4.0

CRAN release: 2025-06-12

  * Add contributing guidlines by [@ilovemane](https://github.com/ilovemane) in [#152](https://github.com/ohdsi/omock/issues/152)
  * Speed up start and end dates by [@catalamarti](https://github.com/catalamarti) in [#150](https://github.com/ohdsi/omock/issues/150)
  * Speed up mockObservationPeriod.R by [@ilovemane](https://github.com/ilovemane) in [#153](https://github.com/ohdsi/omock/issues/153)
  * Add mock datasets by [@catalamarti](https://github.com/catalamarti) in [#154](https://github.com/ohdsi/omock/issues/154)
  * Speed up mockCohort.R by [@ilovemane](https://github.com/ilovemane) in [#156](https://github.com/ohdsi/omock/issues/156)
  * Test mock datasets creation by [@catalamarti](https://github.com/catalamarti) in [#155](https://github.com/ohdsi/omock/issues/155)



## omock 0.3.2

CRAN release: 2025-01-23

## omock 0.3.1

CRAN release: 2024-10-15

## omock 0.3.0

CRAN release: 2024-09-20

## omock 0.2.0

CRAN release: 2024-05-20

## omock 0.1.0

CRAN release: 2024-03-08

  * Initial CRAN submission.



## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/mockPerson.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Generates a mock person table and integrates it into an existing CDM object.

Source: [`R/mockPerson.R`](https://github.com/ohdsi/omock/blob/main/R/mockPerson.R)

`mockPerson.Rd`

This function creates a mock person table with specified characteristics for each individual, including a randomly assigned date of birth within a given range and gender based on specified proportions. It populates the CDM object's person table with these entries, ensuring each record is uniquely identified.

## Usage
    
    
    mockPerson(
      cdm = [mockCdmReference](mockCdmReference.html)(),
      nPerson = 10,
      birthRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("1950-01-01", "2000-12-31")),
      proportionFemale = 0.5,
      seed = NULL
    )

## Arguments

cdm
    

A `cdm_reference` object that serves as the base structure for adding the person table. This parameter should be an existing or newly created CDM object that does not yet contain a 'person' table.

nPerson
    

An integer specifying the number of mock persons to create in the person table. This defines the scale of the simulation and allows for the creation of datasets with varying sizes.

birthRange
    

A date range within which the birthdays of the mock persons will be randomly generated. This should be provided as a vector of two dates (`as.Date` format), specifying the start and end of the range.

proportionFemale
    

A numeric value between 0 and 1 indicating the proportion of the persons who are female. For example, a value of 0.5 means approximately 50% of the generated persons will be female. This helps simulate realistic demographic distributions.

seed
    

An optional integer used to set the seed for random number generation, ensuring reproducibility of the generated data. If provided, this seed allows the function to produce consistent results each time it is run with the same inputs. If 'NULL', the seed is not set, which can lead to different outputs on each run.

## Value

A modified `cdm` object with the new 'person' table added. This table includes simulated person data for each generated individual, with unique identifiers and demographic attributes.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    cdm <- mockPerson(cdm = [mockCdmReference](mockCdmReference.html)(), nPerson = 10)
    
    # View the generated person data
    [print](https://rdrr.io/r/base/print.html)(cdm$person)
    #> # A tibble: 10 × 18
    #>    person_id gender_concept_id year_of_birth month_of_birth day_of_birth
    #>  *     <int>             <int>         <int>          <int>        <int>
    #>  1         1              8507          1990              8           19
    #>  2         2              8507          1958              5            8
    #>  3         3              8532          1997             10           14
    #>  4         4              8507          1984              6           22
    #>  5         5              8507          1997             11           18
    #>  6         6              8532          1972              9            1
    #>  7         7              8507          1958              1           31
    #>  8         8              8507          1970              2           21
    #>  9         9              8532          1965              9           17
    #> 10        10              8507          1999              6           26
    #> # ℹ 13 more variables: race_concept_id <int>, ethnicity_concept_id <int>,
    #> #   birth_datetime <dttm>, location_id <int>, provider_id <int>,
    #> #   care_site_id <int>, person_source_value <chr>, gender_source_value <chr>,
    #> #   gender_source_concept_id <int>, race_source_value <chr>,
    #> #   race_source_concept_id <int>, ethnicity_source_value <chr>,
    #> #   ethnicity_source_concept_id <int>
    # }
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/mockObservationPeriod.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Generates a mock observation period table and integrates it into an existing CDM object.

Source: [`R/mockObservationPeriod.R`](https://github.com/ohdsi/omock/blob/main/R/mockObservationPeriod.R)

`mockObservationPeriod.Rd`

This function simulates observation periods for individuals based on their date of birth recorded in the 'person' table of the CDM object. It assigns random start and end dates for each observation period within a realistic timeframe up to a specified or default maximum date.

## Usage
    
    
    mockObservationPeriod(cdm, seed = NULL)

## Arguments

cdm
    

A `cdm_reference` object that must include a 'person' table with valid dates of birth. This object serves as the base CDM structure where the observation period data will be added. The function checks to ensure that the 'person' table is populated and uses the date of birth to generate observation periods.

seed
    

An optional integer used to set the seed for random number generation, ensuring reproducibility of the generated data. If provided, this seed allows the function to produce consistent results each time it is run with the same inputs. If 'NULL', the seed is not set, which can lead to different outputs on each run.

## Value

Returns the modified `cdm` object with the new 'observation_period' table added. This table includes the simulated observation periods for each person, ensuring that each record spans a realistic timeframe based on the person's date of birth.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    # Create a mock CDM reference and add observation periods
    cdm <- [mockCdmReference](mockCdmReference.html)() |>
      [mockPerson](mockPerson.html)(nPerson = 100) |>
      mockObservationPeriod()
    
    # View the generated observation period data
    [print](https://rdrr.io/r/base/print.html)(cdm$observation_period)
    #> # A tibble: 100 × 5
    #>    observation_period_id person_id observation_period_s…¹ observation_period_e…²
    #>  *                 <int>     <int> <date>                 <date>                
    #>  1                     1         1 2004-04-30             2019-03-17            
    #>  2                     2         2 2013-01-25             2014-09-22            
    #>  3                     3         3 1985-07-14             2014-08-12            
    #>  4                     4         4 1997-11-25             2009-02-10            
    #>  5                     5         5 1985-04-02             2007-08-04            
    #>  6                     6         6 1960-09-30             1965-02-23            
    #>  7                     7         7 2017-10-17             2018-12-02            
    #>  8                     8         8 2001-08-07             2016-10-19            
    #>  9                     9         9 2007-09-23             2009-12-12            
    #> 10                    10        10 1999-07-26             2010-01-13            
    #> # ℹ 90 more rows
    #> # ℹ abbreviated names: ¹​observation_period_start_date,
    #> #   ²​observation_period_end_date
    #> # ℹ 1 more variable: period_type_concept_id <int>
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/LICENSE.html

Skip to contents

[omock](index.html) 0.5.0.9000

  * [Reference](reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](logo.png)

# Apache License

Source: [`LICENSE.md`](https://github.com/ohdsi/omock/blob/main/LICENSE.md)

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

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/CONTRIBUTING.html

Skip to contents

[omock](index.html) 0.5.0.9000

  * [Reference](reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](logo.png)

# Contributing to omock

Source: [`.github/CONTRIBUTING.md`](https://github.com/ohdsi/omock/blob/main/.github/CONTRIBUTING.md)

## Filing issues

If you have found a bug, have a question, or want to suggest a new feature please open an issue. If reporting a bug, then a [reprex](https://reprex.tidyverse.org/) would be much appreciated. Before contributing either documentation or code, please make sure to open an issue beforehand to identify what needs to be done and who will do it.

## Contributing code or documentation

### Documenting the package

Run the below to update and check package documentation:
    
    
    devtools::document() 
    devtools::run_examples()
    devtools::build_readme()
    devtools::build_vignettes()
    devtools::check_man()

Note that `devtools::check_man()` should not return any warnings. If your commit is limited to only package documentation, running the above should be sufficient (although running `devtools::check()` will always generally be a good idea before submitting a pull request.

### Run tests

Before starting to contribute any code, first make sure the package tests are all passing. If not raise an issue before going any further (although please first make sure you have all the packages from imports and suggests installed). As you then contribute code, make sure that all the current tests and any you add continue to pass. All package tests can be run together with:
    
    
    devtools::test()

Code to add new functionality should be accompanied by tests. Code coverage can be checked using:
    
    
    # note, you may first have to detach the package
    # detach("package:IncidencePrevalence", unload=TRUE)
    devtools::test_coverage()

### Adhere to code style

Please adhere to the code style when adding any new code. Do not though restyle any code unrelated to your pull request as this will make code review more difficult.
    
    
    lintr::lint_package(".",
                        linters = lintr::linters_with_defaults(
                          lintr::object_name_linter(styles = "camelCase")
                        )
    )

### Run check() before opening a pull request

Before opening any pull request please make sure to run:
    
    
    devtools::check() 

No warnings should be seen.

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/authors.html

Skip to contents

[omock](index.html) 0.5.0.9000

  * [Reference](reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](logo.png)

# Authors and Citation

## Authors

  * **Mike Du**. Author, maintainer. [](https://orcid.org/0000-0002-9517-8834)

  * **Marti Catala**. Author. [](https://orcid.org/0000-0003-3308-9905)

  * **Edward Burn**. Author. [](https://orcid.org/0000-0002-9286-1128)

  * **Nuria Mercade-Besora**. Author. [](https://orcid.org/0009-0006-7948-3747)

  * **Xihang Chen**. Author. [](https://orcid.org/0009-0001-8112-8959)




## Citation

Source: [`inst/CITATION`](https://github.com/ohdsi/omock/blob/main/inst/CITATION)

Du, Mike, Catala, Marti, Burn, Edward, Mercade-Besora, Nuria, Chen, Xihang (2024). “Omock: Creation of mock observational medical outcomes partnership common data model.” [doi:10.32614/CRAN.package.omock](https://doi.org/10.32614/CRAN.package.omock). 
    
    
    @Misc{,
      title = {Omock: Creation of mock observational medical outcomes
                   partnership common data model},
      author = {{Du} and {Mike} and {Catala} and {Marti} and {Burn} and {Edward} and {Mercade-Besora} and {Nuria} and {Chen} and {Xihang}},
      journal = {The R Foundation},
      year = {2024},
      doi = {10.32614/CRAN.package.omock},
    }

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/mockCdmReference.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Creates an empty CDM (Common Data Model) reference for a mock database.

Source: [`R/mockCdmReference.R`](https://github.com/ohdsi/omock/blob/main/R/mockCdmReference.R)

`mockCdmReference.Rd`

This function initializes an empty CDM reference with a specified name and populates it with mock vocabulary tables based on the provided vocabulary set. It is particularly useful for setting up a simulated environment for testing and development purposes within the OMOP CDM framework.

## Usage
    
    
    mockCdmReference(cdmName = "mock database", vocabularySet = "mock")

## Arguments

cdmName
    

A character string specifying the name of the CDM object to be created.This name can be used to identify the CDM object within a larger simulation or testing framework. Default is "mock database".

vocabularySet
    

A character string specifying the name of the vocabulary set to be used when creating the vocabulary tables for the CDM. Options are "mock" or "eunomia":

  * "mock": Provides a very small synthetic vocabulary subset, suitable for tests that do not require realistic vocabulary names or relationships.

  * "eunomia": Uses the vocabulary from the Eunomia test database, which contains real vocabularies available from ATHENA.




## Value

Returns a CDM object that is initially empty but includes mock vocabulary tables.The object structure is compliant with OMOP CDM standards, making it suitable for further population with mock data like person, visit, and observation records.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    # Create a new empty mock CDM reference
    cdm <- mockCdmReference()
    
    # Display the structure of the newly created CDM
    [print](https://rdrr.io/r/base/print.html)(cdm)
    #> 
    #> ── # OMOP CDM reference (local) of mock database ───────────────────────────────
    #> • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
    #> concept_synonym, drug_strength, observation_period, person, vocabulary
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/mockCdmFromTables.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Generates a mock CDM (Common Data Model) object based on existing CDM structures and additional tables.

Source: [`R/mockCdmFromTables.R`](https://github.com/ohdsi/omock/blob/main/R/mockCdmFromTables.R)

`mockCdmFromTables.Rd`

This function takes an existing CDM reference (which can be empty) and a list of additional named tables to create a more complete mock CDM object. It ensures that all provided observations fit within their respective observation periods and that all individual records are consistent with the entries in the person table. This is useful for creating reliable and realistic healthcare data simulations for development and testing within the OMOP CDM framework.

## Usage
    
    
    mockCdmFromTables(
      cdm = [mockCdmReference](mockCdmReference.html)(),
      tables = [list](https://rdrr.io/r/base/list.html)(),
      maxObservationalPeriodEndDate = [as.Date](https://rdrr.io/r/base/as.Date.html)("01-01-2024", "%d-%m-%Y"),
      seed = NULL
    )

## Arguments

cdm
    

A `cdm_reference` object, which serves as the base structure where all additional tables will be integrated. This parameter should already be initialized and can contain pre-existing standard or cohort-specific OMOP tables.

tables
    

A named list of data frames representing additional tables to be integrated into the CDM. These tables can include both standard OMOP tables such as 'drug_exposure' or 'condition_occurrence', as well as cohort-specific tables that are not part of the standard OMOP model but are necessary for specific analyses. Each table should be named according to its intended table name in the CDM structure.

maxObservationalPeriodEndDate
    

A `Date` object specifying the latest allowable end date for the observation period. This value ensures that `observation_period_end_date` values do not exceed the current calendar date.

seed
    

An optional integer that sets the seed for random number generation used in creating mock data entries. Setting a seed ensures that the generated mock data are reproducible across different runs of the function. If 'NULL', the seed is not set, leading to non-deterministic behavior in data generation.

## Value

Returns the updated `cdm` object with all the new tables added and integrated, ensuring consistency across the observational periods and the person entries.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    #> 
    #> Attaching package: ‘dplyr’
    #> The following objects are masked from ‘package:stats’:
    #> 
    #>     filter, lag
    #> The following objects are masked from ‘package:base’:
    #> 
    #>     intersect, setdiff, setequal, union
    
    # Create a mock cohort table
    cohort <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = [c](https://rdrr.io/r/base/c.html)(1, 1, 2, 2, 1, 3, 3, 3, 1, 3),
      subject_id = [c](https://rdrr.io/r/base/c.html)(1, 4, 2, 3, 5, 5, 4, 3, 3, 1),
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)(
        "2020-04-01", "2021-06-01", "2022-05-22", "2010-01-01", "2019-08-01",
        "2019-04-07", "2021-01-01", "2008-02-02", "2009-09-09", "2021-01-01"
      )),
      cohort_end_date = cohort_start_date
    )
    
    # Generate a mock CDM from preexisting CDM structure and cohort table
    cdm <- mockCdmFromTables(cdm = [mockCdmReference](mockCdmReference.html)(), tables = [list](https://rdrr.io/r/base/list.html)(cohort = cohort))
    
    # Access the newly integrated cohort table and the standard person table in the CDM
    [print](https://rdrr.io/r/base/print.html)(cdm$cohort)
    #> # A tibble: 10 × 4
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          1 2020-04-01        2020-04-01     
    #>  2                    1          4 2021-06-01        2021-06-01     
    #>  3                    2          2 2022-05-22        2022-05-22     
    #>  4                    2          3 2010-01-01        2010-01-01     
    #>  5                    1          5 2019-08-01        2019-08-01     
    #>  6                    3          5 2019-04-07        2019-04-07     
    #>  7                    3          4 2021-01-01        2021-01-01     
    #>  8                    3          3 2008-02-02        2008-02-02     
    #>  9                    1          3 2009-09-09        2009-09-09     
    #> 10                    3          1 2021-01-01        2021-01-01     
    [print](https://rdrr.io/r/base/print.html)(cdm$person)
    #> # A tibble: 5 × 18
    #>   person_id gender_concept_id year_of_birth month_of_birth day_of_birth
    #> *     <int>             <int>         <int>          <int>        <int>
    #> 1         1              8507          2010              8           29
    #> 2         2              8507          2011             10           20
    #> 3         3              8532          2007              8           30
    #> 4         4              8532          2018              4           29
    #> 5         5              8507          2015             11           11
    #> # ℹ 13 more variables: birth_datetime <dttm>, race_concept_id <int>,
    #> #   ethnicity_concept_id <int>, location_id <int>, person_source_value <chr>,
    #> #   gender_source_value <chr>, gender_source_concept_id <int>,
    #> #   race_source_value <chr>, race_source_concept_id <int>,
    #> #   ethnicity_source_value <chr>, ethnicity_source_concept_id <int>,
    #> #   provider_id <int>, care_site_id <int>
    # }
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/mockCdmFromDataset.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Create a `local` cdm_reference from a dataset.

Source: [`R/mockDatasets.R`](https://github.com/ohdsi/omock/blob/main/R/mockDatasets.R)

`mockCdmFromDataset.Rd`

Create a `local` cdm_reference from a dataset.

## Usage
    
    
    mockCdmFromDataset(datasetName = "GiBleed", source = "local")

## Arguments

datasetName
    

Name of the mock dataset. See `[availableMockDatasets()](availableMockDatasets.html)` for possibilities.

source
    

Choice between `local` or `duckdb`.

## Value

A local cdm_reference object.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    [mockDatasetsFolder](mockDatasetsFolder.html)([tempdir](https://rdrr.io/r/base/tempfile.html)())
    [downloadMockDataset](downloadMockDataset.html)(datasetName = "GiBleed")
    cdm <- mockCdmFromDataset(datasetName = "GiBleed")
    #> ℹ Reading GiBleed tables.
    #> ℹ Adding drug_strength table.
    #> ℹ Creating local <cdm_reference> object.
    cdm
    #> 
    #> ── # OMOP CDM reference (local) of GiBleed ─────────────────────────────────────
    #> • omop tables: care_site, cdm_source, concept, concept_ancestor, concept_class,
    #> concept_relationship, concept_synonym, condition_era, condition_occurrence,
    #> cost, death, device_exposure, domain, dose_era, drug_era, drug_exposure,
    #> drug_strength, fact_relationship, location, measurement, metadata, note,
    #> note_nlp, observation, observation_period, payer_plan_period, person,
    #> procedure_occurrence, provider, relationship, source_to_concept_map, specimen,
    #> visit_detail, visit_occurrence, vocabulary
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/mockDatasets.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Available mock OMOP CDM Synthetic Datasets

Source: [`R/mockDatasets.R`](https://github.com/ohdsi/omock/blob/main/R/mockDatasets.R)

`mockDatasets.Rd`

These are the mock OMOP CDM Synthetic Datasets that are available to download using the `omock` package.

## Usage
    
    
    mockDatasets

## Format

A data frame with 4 variables:

dataset_name
    

Name of the dataset.

url
    

url to download the dataset.

cdm_name
    

Name of the cdm reference created.

cdm_version
    

OMOP CDM version of the dataset.

size
    

Size in bytes of the dataset.

size_mb
    

Size in Mega bytes of the dataset.

## Examples
    
    
    mockDatasets
    #> # A tibble: 24 × 6
    #>    dataset_name               url            cdm_name cdm_version   size size_mb
    #>    <chr>                      <chr>          <chr>    <chr>        <dbl>   <dbl>
    #>  1 GiBleed                    https://examp… GiBleed  5.3         6.75e6       6
    #>  2 empty_cdm                  https://examp… empty_c… 5.3         8.21e8     783
    #>  3 synpuf-1k_5.3              https://examp… synpuf-… 5.3         5.93e8     566
    #>  4 synpuf-1k_5.4              https://examp… synpuf-… 5.4         3.97e8     379
    #>  5 synthea-allergies-10k      https://examp… synthea… 5.3         8.40e8     801
    #>  6 synthea-anemia-10k         https://examp… synthea… 5.3         8.40e8     801
    #>  7 synthea-breast_cancer-10k  https://examp… synthea… 5.3         8.41e8     802
    #>  8 synthea-contraceptives-10k https://examp… synthea… 5.3         8.42e8     803
    #>  9 synthea-covid19-10k        https://examp… synthea… 5.3         8.41e8     802
    #> 10 synthea-covid19-200k       https://examp… synthea… 5.3         1.18e9    1124
    #> # ℹ 14 more rows
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/downloadMockDataset.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Download an OMOP Synthetic dataset.

Source: [`R/mockDatasets.R`](https://github.com/ohdsi/omock/blob/main/R/mockDatasets.R)

`downloadMockDataset.Rd`

Download an OMOP Synthetic dataset.

## Usage
    
    
    downloadMockDataset(
      datasetName = "GiBleed",
      path = [mockDatasetsFolder](mockDatasetsFolder.html)(),
      overwrite = NULL
    )

## Arguments

datasetName
    

Name of the mock dataset. See `[availableMockDatasets()](availableMockDatasets.html)` for possibilities.

path
    

Path where to download the dataset.

overwrite
    

Whether to overwrite the dataset if it is already downloaded. If NULL the used is asked whether to overwrite.

## Value

The path to the downloaded dataset.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    [isMockDatasetDownloaded](isMockDatasetDownloaded.html)("GiBleed")
    #> [1] FALSE
    downloadMockDataset("GiBleed")
    [isMockDatasetDownloaded](isMockDatasetDownloaded.html)("GiBleed")
    #> [1] TRUE
    # }
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/availableMockDatasets.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# List the available datasets

Source: [`R/mockDatasets.R`](https://github.com/ohdsi/omock/blob/main/R/mockDatasets.R)

`availableMockDatasets.Rd`

List the available datasets

## Usage
    
    
    availableMockDatasets()

## Value

A character vector with the available datasets.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    availableMockDatasets()
    #>  [1] "GiBleed"                             "empty_cdm"                          
    #>  [3] "synpuf-1k_5.3"                       "synpuf-1k_5.4"                      
    #>  [5] "synthea-allergies-10k"               "synthea-anemia-10k"                 
    #>  [7] "synthea-breast_cancer-10k"           "synthea-contraceptives-10k"         
    #>  [9] "synthea-covid19-10k"                 "synthea-covid19-200k"               
    #> [11] "synthea-dermatitis-10k"              "synthea-heart-10k"                  
    #> [13] "synthea-hiv-10k"                     "synthea-lung_cancer-10k"            
    #> [15] "synthea-medications-10k"             "synthea-metabolic_syndrome-10k"     
    #> [17] "synthea-opioid_addiction-10k"        "synthea-rheumatoid_arthritis-10k"   
    #> [19] "synthea-snf-10k"                     "synthea-surgery-10k"                
    #> [21] "synthea-total_joint_replacement-10k" "synthea-veteran_prostate_cancer-10k"
    #> [23] "synthea-veterans-10k"                "synthea-weight_loss-10k"            
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/isMockDatasetDownloaded.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Check if a certain dataset is downloaded.

Source: [`R/mockDatasets.R`](https://github.com/ohdsi/omock/blob/main/R/mockDatasets.R)

`isMockDatasetDownloaded.Rd`

Check if a certain dataset is downloaded.

## Usage
    
    
    isMockDatasetDownloaded(datasetName = "GiBleed", path = [mockDatasetsFolder](mockDatasetsFolder.html)())

## Arguments

datasetName
    

Name of the mock dataset. See `[availableMockDatasets()](availableMockDatasets.html)` for possibilities.

path
    

Path where to search for the dataset.

## Value

Whether the dataset is available or not.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    isMockDatasetDownloaded("GiBleed")
    #> [1] TRUE
    [downloadMockDataset](downloadMockDataset.html)("GiBleed")
    #> ℹ Deleting prior version of GiBleed.
    isMockDatasetDownloaded("GiBleed")
    #> [1] TRUE
    # }
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/mockDatasetsStatus.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Check the availability of the OMOP CDM datasets.

Source: [`R/mockDatasets.R`](https://github.com/ohdsi/omock/blob/main/R/mockDatasets.R)

`mockDatasetsStatus.Rd`

Check the availability of the OMOP CDM datasets.

## Usage
    
    
    mockDatasetsStatus()

## Value

A message with the availability of the datasets.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    mockDatasetsStatus()
    #> ✖ GiBleed
    #> ✖ empty_cdm
    #> ✖ synpuf-1k_5.3
    #> ✖ synpuf-1k_5.4
    #> ✖ synthea-allergies-10k
    #> ✖ synthea-anemia-10k
    #> ✖ synthea-breast_cancer-10k
    #> ✖ synthea-contraceptives-10k
    #> ✖ synthea-covid19-10k
    #> ✖ synthea-covid19-200k
    #> ✖ synthea-dermatitis-10k
    #> ✖ synthea-heart-10k
    #> ✖ synthea-hiv-10k
    #> ✖ synthea-lung_cancer-10k
    #> ✖ synthea-medications-10k
    #> ✖ synthea-metabolic_syndrome-10k
    #> ✖ synthea-opioid_addiction-10k
    #> ✖ synthea-rheumatoid_arthritis-10k
    #> ✖ synthea-snf-10k
    #> ✖ synthea-surgery-10k
    #> ✖ synthea-total_joint_replacement-10k
    #> ✖ synthea-veteran_prostate_cancer-10k
    #> ✖ synthea-veterans-10k
    #> ✖ synthea-weight_loss-10k
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/mockDatasetsFolder.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Check or set the datasets Folder

Source: [`R/mockDatasets.R`](https://github.com/ohdsi/omock/blob/main/R/mockDatasets.R)

`mockDatasetsFolder.Rd`

Check or set the datasets Folder

## Usage
    
    
    mockDatasetsFolder(path = NULL)

## Arguments

path
    

Path to a folder to store the synthetic datasets. If NULL the current OMOP_DATASETS_FOLDER is returned.

## Value

The dataset folder.

## Examples
    
    
    # \donttest{
    mockDatasetsFolder()
    #> [1] "/tmp/RtmpAwwQyg"
    mockDatasetsFolder([file.path](https://rdrr.io/r/base/file.path.html)([tempdir](https://rdrr.io/r/base/tempfile.html)(), "OMOP_DATASETS"))
    #> ℹ Creating /tmp/RtmpAwwQyg/OMOP_DATASETS.
    mockDatasetsFolder()
    #> [1] "/tmp/RtmpAwwQyg/OMOP_DATASETS"
    # }
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/mockConditionOccurrence.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Generates a mock condition occurrence table and integrates it into an existing CDM object.

Source: [`R/mockConditionOccurrence.R`](https://github.com/ohdsi/omock/blob/main/R/mockConditionOccurrence.R)

`mockConditionOccurrence.Rd`

This function simulates condition occurrences for individuals within a specified cohort. It helps create a realistic dataset by generating condition records for each person, based on the number of records specified per person.The generated data are aligned with the existing observation periods to ensure that all conditions are recorded within valid observation windows.

## Usage
    
    
    mockConditionOccurrence(cdm, recordPerson = 1, seed = NULL)

## Arguments

cdm
    

A `cdm_reference` object that should already include 'person', 'observation_period', and 'concept' tables.This object is the base CDM structure where the condition occurrence data will be added. It is essential that these tables are not empty as they provide the necessary context for generating condition data.

recordPerson
    

An integer specifying the expected number of condition records to generate per person.This parameter allows the simulation of varying frequencies of condition occurrences among individuals in the cohort, reflecting the variability seen in real-world medical data.

seed
    

An optional integer used to set the seed for random number generation, ensuring reproducibility of the generated data.If provided, it allows the function to produce the same results each time it is run with the same inputs.If 'NULL', the seed is not set, resulting in different outputs on each run.

## Value

Returns the modified `cdm` object with the new 'condition_occurrence' table added. This table includes the simulated condition data for each person, ensuring that each record is within the valid observation periods and linked to the correct individuals in the 'person' table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    # Create a mock CDM reference and add condition occurrences
    cdm <- [mockCdmReference](mockCdmReference.html)() |>
      [mockPerson](mockPerson.html)() |>
      [mockObservationPeriod](mockObservationPeriod.html)() |>
      mockConditionOccurrence(recordPerson = 2)
    
    # View the generated condition occurrence data
    [print](https://rdrr.io/r/base/print.html)(cdm$condition_occurrence)
    #> # A tibble: 120 × 16
    #>    condition_concept_id person_id condition_start_date condition_end_date
    #>  *                <int>     <int> <date>               <date>            
    #>  1               194152         7 2009-08-10           2011-03-13        
    #>  2               194152         5 2003-08-02           2003-10-12        
    #>  3               194152         4 2004-07-07           2005-11-01        
    #>  4               194152         7 2006-04-14           2007-12-11        
    #>  5               194152        10 1985-01-27           1988-07-20        
    #>  6               194152         6 2009-02-13           2009-07-15        
    #>  7               194152         2 1975-08-05           1985-10-15        
    #>  8               194152         6 2008-10-13           2009-08-18        
    #>  9               194152         8 2019-11-22           2019-11-24        
    #> 10               194152         9 2014-06-19           2018-02-15        
    #> # ℹ 110 more rows
    #> # ℹ 12 more variables: condition_occurrence_id <int>,
    #> #   condition_type_concept_id <int>, condition_start_datetime <dttm>,
    #> #   condition_end_datetime <dttm>, condition_status_concept_id <int>,
    #> #   stop_reason <chr>, provider_id <int>, visit_occurrence_id <int>,
    #> #   visit_detail_id <int>, condition_source_value <chr>,
    #> #   condition_source_concept_id <int>, condition_status_source_value <chr>
    # }
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/mockDrugExposure.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Generates a mock drug exposure table and integrates it into an existing CDM object.

Source: [`R/mockDrugExposure.R`](https://github.com/ohdsi/omock/blob/main/R/mockDrugExposure.R)

`mockDrugExposure.Rd`

This function simulates drug exposure records for individuals within a specified cohort. It creates a realistic dataset by generating drug exposure records based on the specified number of records per person. Each drug exposure record is correctly associated with an individual within valid observation periods, ensuring the integrity of the data.

## Usage
    
    
    mockDrugExposure(cdm, recordPerson = 1, seed = NULL)

## Arguments

cdm
    

A `cdm_reference` object that must already include 'person' and 'observation_period' tables. This object serves as the base CDM structure where the drug exposure data will be added. The 'person' and 'observation_period' tables must be populated as they are necessary for generating accurate drug exposure records.

recordPerson
    

An integer specifying the expected number of drug exposure records to generate per person. This parameter allows for the simulation of varying drug usage frequencies among individuals in the cohort, reflecting real-world variability in medication administration.

seed
    

An optional integer used to set the seed for random number generation, ensuring reproducibility of the generated data. If provided, this seed enables the function to produce consistent results each time it is run with the same inputs. If 'NULL', the seed is not set, which can lead to different outputs on each run.

## Value

Returns the modified `cdm` object with the new 'drug_exposure' table added. This table includes the simulated drug exposure data for each person, ensuring that each record is correctly linked to individuals in the 'person' table and falls within valid observation periods.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    # Create a mock CDM reference and add drug exposure records
    cdm <- [mockCdmReference](mockCdmReference.html)() |>
      [mockPerson](mockPerson.html)() |>
      [mockObservationPeriod](mockObservationPeriod.html)() |>
      mockDrugExposure(recordPerson = 3)
    
    # View the generated drug exposure data
    [print](https://rdrr.io/r/base/print.html)(cdm$drug_exposure)
    #> # A tibble: 930 × 23
    #>    drug_concept_id person_id drug_exposure_start_date drug_exposure_end_date
    #>  *           <int>     <int> <date>                   <date>                
    #>  1         1361364         7 1984-05-20               1993-07-14            
    #>  2         1361364         5 2014-05-10               2016-10-19            
    #>  3         1361364         6 2008-08-31               2012-08-23            
    #>  4         1361364         8 1989-01-13               1989-07-15            
    #>  5         1361364         2 1988-09-14               2008-05-28            
    #>  6         1361364         1 2007-01-26               2007-02-26            
    #>  7         1361364         3 2019-10-11               2019-11-18            
    #>  8         1361364         1 2005-06-13               2006-12-10            
    #>  9         1361364         7 1983-03-31               1993-05-04            
    #> 10         1361364         7 1976-09-19               2001-08-10            
    #> # ℹ 920 more rows
    #> # ℹ 19 more variables: drug_exposure_id <int>, drug_type_concept_id <int>,
    #> #   drug_exposure_start_datetime <dttm>, drug_exposure_end_datetime <dttm>,
    #> #   verbatim_end_date <date>, stop_reason <chr>, refills <int>, quantity <dbl>,
    #> #   days_supply <int>, sig <chr>, route_concept_id <int>, lot_number <chr>,
    #> #   provider_id <int>, visit_occurrence_id <int>, visit_detail_id <int>,
    #> #   drug_source_value <chr>, drug_source_concept_id <int>, …
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/mockMeasurement.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Generates a mock measurement table and integrates it into an existing CDM object.

Source: [`R/mockMeasurement.R`](https://github.com/ohdsi/omock/blob/main/R/mockMeasurement.R)

`mockMeasurement.Rd`

This function simulates measurement records for individuals within a specified cohort. It creates a realistic dataset by generating measurement records based on the specified number of records per person. Each measurement record is correctly associated with an individual within valid observation periods, ensuring the integrity of the data.

## Usage
    
    
    mockMeasurement(cdm, recordPerson = 1, seed = NULL)

## Arguments

cdm
    

A `cdm_reference` object that must already include 'person' and 'observation_period' tables. This object serves as the base CDM structure where the measurement data will be added. The 'person' and 'observation_period' tables must be populated as they are necessary for generating accurate measurement records.

recordPerson
    

An integer specifying the expected number of measurement records to generate per person. This parameter allows for the simulation of varying frequencies of health measurements among individuals in the cohort, reflecting real-world variability in patient monitoring and diagnostic testing.

seed
    

An optional integer used to set the seed for random number generation, ensuring reproducibility of the generated data. If provided, this seed enables the function to produce consistent results each time it is run with the same inputs. If 'NULL', the seed is not set, which can lead to different outputs on each run.

## Value

Returns the modified `cdm` object with the new 'measurement' table added. This table includes the simulated measurement data for each person, ensuring that each record is correctly linked to individuals in the 'person' table and falls within valid observation periods.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    # Create a mock CDM reference and add measurement records
    cdm <- [mockCdmReference](mockCdmReference.html)() |>
      [mockPerson](mockPerson.html)() |>
      [mockObservationPeriod](mockObservationPeriod.html)() |>
      mockMeasurement(recordPerson = 5)
    
    # View the generated measurement data
    [print](https://rdrr.io/r/base/print.html)(cdm$measurement)
    #> # A tibble: 1,000 × 20
    #>    measurement_concept_id person_id measurement_date measurement_id
    #>  *                  <int>     <int> <date>                    <int>
    #>  1                3001467         7 2002-01-05                    1
    #>  2                3001467         8 2009-08-09                    2
    #>  3                3001467        10 2017-04-10                    3
    #>  4                3001467         9 2007-05-25                    4
    #>  5                3001467         8 2016-05-05                    5
    #>  6                3001467         7 2012-08-27                    6
    #>  7                3001467         4 2008-05-07                    7
    #>  8                3001467         9 2008-09-20                    8
    #>  9                3001467         2 2007-04-10                    9
    #> 10                3001467         4 2008-06-30                   10
    #> # ℹ 990 more rows
    #> # ℹ 16 more variables: measurement_type_concept_id <int>,
    #> #   measurement_datetime <dttm>, measurement_time <chr>,
    #> #   operator_concept_id <int>, value_as_number <dbl>,
    #> #   value_as_concept_id <int>, unit_concept_id <int>, range_low <dbl>,
    #> #   range_high <dbl>, provider_id <int>, visit_occurrence_id <int>,
    #> #   visit_detail_id <int>, measurement_source_value <chr>, …
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/mockObservation.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Generates a mock observation table and integrates it into an existing CDM object.

Source: [`R/mockObservation.R`](https://github.com/ohdsi/omock/blob/main/R/mockObservation.R)

`mockObservation.Rd`

This function simulates observation records for individuals within a specified cohort. It creates a realistic dataset by generating observation records based on the specified number of records per person. Each observation record is correctly associated with an individual within valid observation periods, ensuring the integrity of the data.

## Usage
    
    
    mockObservation(cdm, recordPerson = 1, seed = NULL)

## Arguments

cdm
    

A `cdm_reference` object that must already include 'person', 'observation_period', and 'concept' tables. This object serves as the base CDM structure where the observation data will be added. The 'person' and 'observation_period' tables must be populated as they are necessary for generating accurate observation records.

recordPerson
    

An integer specifying the expected number of observation records to generate per person. This parameter allows for the simulation of varying frequencies of healthcare observations among individuals in the cohort, reflecting real-world variability in patient monitoring and health assessments.

seed
    

An optional integer used to set the seed for random number generation, ensuring reproducibility of the generated data. If provided, this seed enables the function to produce consistent results each time it is run with the same inputs. If 'NULL', the seed is not set, which can lead to different outputs on each run.

## Value

Returns the modified `cdm` object with the new 'observation' table added. This table includes the simulated observation data for each person, ensuring that each record is correctly linked to individuals in the 'person' table and falls within valid observation periods.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    # Create a mock CDM reference and add observation records
    cdm <- [mockCdmReference](mockCdmReference.html)() |>
      [mockPerson](mockPerson.html)() |>
      [mockObservationPeriod](mockObservationPeriod.html)() |>
      mockObservation(recordPerson = 3)
    
    # View the generated observation data
    [print](https://rdrr.io/r/base/print.html)(cdm$observation)
    #> # A tibble: 180 × 18
    #>    observation_concept_id person_id observation_date observation_id
    #>  *                  <int>     <int> <date>                    <int>
    #>  1                 437738         7 1985-03-01                    1
    #>  2                 437738         4 2009-03-30                    2
    #>  3                 437738         9 2011-01-23                    3
    #>  4                 437738         8 1991-01-02                    4
    #>  5                 437738         6 2013-04-14                    5
    #>  6                 437738         4 2008-11-05                    6
    #>  7                 437738         4 2009-04-11                    7
    #>  8                 437738         4 2008-11-01                    8
    #>  9                 437738         2 2014-08-19                    9
    #> 10                 437738         9 2004-10-12                   10
    #> # ℹ 170 more rows
    #> # ℹ 14 more variables: observation_type_concept_id <int>,
    #> #   observation_datetime <dttm>, value_as_number <dbl>, value_as_string <chr>,
    #> #   value_as_concept_id <int>, qualifier_concept_id <int>,
    #> #   unit_concept_id <int>, provider_id <int>, visit_occurrence_id <int>,
    #> #   visit_detail_id <int>, observation_source_value <chr>,
    #> #   observation_source_concept_id <int>, unit_source_value <chr>, …
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/mockProcedureOccurrence.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Generates a mock procedure occurrence table and integrates it into an existing CDM object.

Source: [`R/mockProcedureOccurrence.R`](https://github.com/ohdsi/omock/blob/main/R/mockProcedureOccurrence.R)

`mockProcedureOccurrence.Rd`

This function simulates condition occurrences for individuals within a specified cohort. It helps create a realistic dataset by generating condition records for each person, based on the number of records specified per person.The generated data are aligned with the existing observation periods to ensure that all conditions are recorded within valid observation windows.

## Usage
    
    
    mockProcedureOccurrence(cdm, recordPerson = 1, seed = NULL)

## Arguments

cdm
    

A `cdm_reference` object that should already include 'person', 'observation_period', and 'concept' tables.This object is the base CDM structure where the procedure occurrence data will be added. It is essential that these tables are not empty as they provide the necessary context for generating condition data.

recordPerson
    

An integer specifying the expected number of condition records to generate per person.This parameter allows the simulation of varying frequencies of condition occurrences among individuals in the cohort, reflecting the variability seen in real-world medical data.

seed
    

An optional integer used to set the seed for random number generation, ensuring reproducibility of the generated data.If provided, it allows the function to produce the same results each time it is run with the same inputs.If 'NULL', the seed is not set, resulting in different outputs on each run.

## Value

Returns the modified `cdm` object with the new 'condition_occurrence' table added. This table includes the simulated condition data for each person, ensuring that each record is within the valid observation periods and linked to the correct individuals in the 'person' table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    # Create a mock CDM reference and add condition occurrences
    cdm <- [mockCdmReference](mockCdmReference.html)() |>
      [mockPerson](mockPerson.html)() |>
      [mockObservationPeriod](mockObservationPeriod.html)() |>
      mockProcedureOccurrence(recordPerson = 2)
    
    # View the generated condition occurrence data
    [print](https://rdrr.io/r/base/print.html)(cdm$procedure_occurrence)
    #> # A tibble: 20 × 15
    #>    procedure_concept_id person_id procedure_date procedure_end_date
    #>  *                <int>     <int> <date>         <date>            
    #>  1              4012925         5 2010-05-09     2010-09-15        
    #>  2              4012925         2 2013-03-03     2013-09-06        
    #>  3              4012925         9 2008-04-12     2012-05-20        
    #>  4              4012925         1 1980-12-14     1982-01-26        
    #>  5              4012925         9 1999-11-21     2012-01-02        
    #>  6              4012925         5 2000-12-14     2006-12-26        
    #>  7              4012925        10 2011-11-08     2012-04-16        
    #>  8              4012925         2 2011-01-23     2014-08-23        
    #>  9              4012925         9 2003-05-01     2011-06-08        
    #> 10              4012925         6 2008-06-29     2011-04-27        
    #> 11              4012925         4 2014-12-15     2015-01-01        
    #> 12              4012925         5 2010-01-26     2010-06-09        
    #> 13              4012925         9 2007-06-28     2008-04-30        
    #> 14              4012925         5 2001-03-14     2001-03-30        
    #> 15              4012925         7 1998-12-29     2013-02-14        
    #> 16              4012925         4 2014-11-10     2014-12-21        
    #> 17              4012925         3 1966-10-24     1967-04-05        
    #> 18              4012925         7 2012-10-07     2017-07-12        
    #> 19              4012925         9 2000-08-21     2000-12-03        
    #> 20              4012925         6 2011-12-16     2012-02-23        
    #> # ℹ 11 more variables: procedure_occurrence_id <int>,
    #> #   procedure_type_concept_id <int>, procedure_datetime <dttm>,
    #> #   modifier_concept_id <int>, quantity <int>, provider_id <int>,
    #> #   visit_occurrence_id <int>, visit_detail_id <int>,
    #> #   procedure_source_value <chr>, procedure_source_concept_id <int>,
    #> #   modifier_source_value <chr>
    # }
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/mockDeath.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Generates a mock death table and integrates it into an existing CDM object.

Source: [`R/mockDeath.R`](https://github.com/ohdsi/omock/blob/main/R/mockDeath.R)

`mockDeath.Rd`

This function simulates death records for individuals within a specified cohort. It creates a realistic dataset by generating death records according to the specified number of records per person. The function ensures that each death record is associated with a valid person within the observation period to maintain the integrity of the data.

## Usage
    
    
    mockDeath(cdm, recordPerson = 1, seed = NULL)

## Arguments

cdm
    

A `cdm_reference` object that must already include 'person' and 'observation_period' tables.This object is the base CDM structure where the death data will be added. It is essential that the 'person' and 'observation_period' tables are populated as they provide necessary context for generating death records.

recordPerson
    

An integer specifying the expected number of death records to generate per person. This parameter helps simulate varying frequencies of death occurrences among individuals in the cohort, reflecting the variability seen in real-world medical data. Typically, this would be set to 1 or 0, assuming most datasets would only record a single death date per individual if at all.

seed
    

An optional integer used to set the seed for random number generation, ensuring reproducibility of the generated data. If provided, it allows the function to produce the same results each time it is run with the same inputs. If 'NULL', the seed is not set, which can result in different outputs on each run.

## Value

Returns the modified `cdm` object with the new 'death' table added. This table includes the simulated death data for each person, ensuring that each record is linked correctly to individuals in the ' person' table and falls within valid observation periods.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    # Create a mock CDM reference and add death records
    cdm <- [mockCdmReference](mockCdmReference.html)() |>
      [mockPerson](mockPerson.html)() |>
      [mockObservationPeriod](mockObservationPeriod.html)() |>
      mockDeath(recordPerson = 1)
    
    # View the generated death data
    [print](https://rdrr.io/r/base/print.html)(cdm$death)
    #> # A tibble: 10 × 7
    #>    person_id death_date death_type_concept_id death_datetime
    #>  *     <int> <date>                     <int> <dttm>        
    #>  1         7 2010-08-24                     1 NA            
    #>  2         4 2010-09-28                     1 NA            
    #>  3        10 2019-01-23                     1 NA            
    #>  4         1 2014-05-20                     1 NA            
    #>  5         8 2019-03-20                     1 NA            
    #>  6         5 2005-05-24                     1 NA            
    #>  7         3 2017-10-02                     1 NA            
    #>  8         9 2000-11-26                     1 NA            
    #>  9         2 1998-05-22                     1 NA            
    #> 10         6 2010-11-10                     1 NA            
    #> # ℹ 3 more variables: cause_concept_id <int>, cause_source_value <chr>,
    #> #   cause_source_concept_id <int>
    # }
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/mockVisitOccurrence.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Function to generate visit occurrence table

Source: [`R/mockVisitOccurrence.R`](https://github.com/ohdsi/omock/blob/main/R/mockVisitOccurrence.R)

`mockVisitOccurrence.Rd`

Function to generate visit occurrence table

## Usage
    
    
    mockVisitOccurrence(cdm, seed = NULL)

## Arguments

cdm
    

the CDM reference into which the mock visit occurrence table will be added

seed
    

A random seed to ensure reproducibility of the generated data.

## Value

A cdm reference with the visit_occurrence tables added

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/mockVocabularyTables.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Creates a mock CDM database populated with various vocabulary tables.

Source: [`R/mockVocabulary.R`](https://github.com/ohdsi/omock/blob/main/R/mockVocabulary.R)

`mockVocabularyTables.Rd`

This function adds specified vocabulary tables to a CDM object. It can either populate the tables with provided data frames or initialize empty tables if no data is provided. This is useful for setting up a testing environment with controlled vocabulary data.

## Usage
    
    
    mockVocabularyTables(
      cdm = [mockCdmReference](mockCdmReference.html)(),
      vocabularySet = "mock",
      cdmSource = NULL,
      concept = NULL,
      vocabulary = NULL,
      conceptRelationship = NULL,
      conceptSynonym = NULL,
      conceptAncestor = NULL,
      drugStrength = NULL
    )

## Arguments

cdm
    

A `cdm_reference` object that serves as the base structure for adding vocabulary tables. This should be an existing or a newly created CDM object, typically initialized without any vocabulary tables.

vocabularySet
    

A character string specifying the name of the vocabulary set to be used when creating the vocabulary tables for the CDM. Options are "mock" or "eunomia":

  * "mock": Provides a very small synthetic vocabulary subset, suitable for tests that do not require realistic vocabulary names or relationships.

  * "eunomia": Uses the vocabulary from the Eunomia test database, which contains real vocabularies available from ATHENA.



cdmSource
    

An optional data frame representing the CDM source table. If provided, it will be used directly; otherwise, a mock table will be generated based on the `vocabularySet` prefix.

concept
    

An optional data frame representing the concept table. If provided, it will be used directly; if NULL, a mock table will be generated.

vocabulary
    

An optional data frame representing the vocabulary table. If provided, it will be used directly; if NULL, a mock table will be generated.

conceptRelationship
    

An optional data frame representing the concept relationship table. If provided, it will be used directly; if NULL, a mock table will be generated.

conceptSynonym
    

An optional data frame representing the concept synonym table. If provided, it will be used directly; if NULL, a mock table will be generated.

conceptAncestor
    

An optional data frame representing the concept ancestor table. If provided, it will be used directly; if NULL, a mock table will be generated.

drugStrength
    

An optional data frame representing the drug strength table. If provided, it will be used directly; if NULL, a mock table will be generated.

## Value

Returns the modified `cdm` object with the new or provided vocabulary tables added.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    # Create a mock CDM reference and populate it with mock vocabulary tables
    cdm <- [mockCdmReference](mockCdmReference.html)() |> mockVocabularyTables(vocabularySet = "mock")
    
    # View the names of the tables added to the CDM
    [names](https://rdrr.io/r/base/names.html)(cdm)
    #> [1] "person"               "observation_period"   "cdm_source"          
    #> [4] "concept"              "vocabulary"           "concept_relationship"
    #> [7] "concept_synonym"      "concept_ancestor"     "drug_strength"       
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/mockConcepts.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Adds mock concept data to a concept table within a Common Data Model (CDM) object.

Source: [`R/mockConcept.R`](https://github.com/ohdsi/omock/blob/main/R/mockConcept.R)

`mockConcepts.Rd`

This function inserts new concept entries into a specified domain within the concept table of a CDM object.It supports four domains: Condition, Drug, Measurement, and Observation. Existing entries with the same concept IDs will be overwritten, so caution should be used when adding data to prevent unintended data loss.

## Usage
    
    
    mockConcepts(cdm, conceptSet, domain = "Condition", seed = NULL)

## Arguments

cdm
    

A CDM object that represents a common data model containing at least a concept table.This object will be modified in-place to include the new or updated concept entries.

conceptSet
    

A numeric vector of concept IDs to be added or updated in the concept table.These IDs should be unique within the context of the provided domain to avoid unintended overwriting unless that is the intended effect.

domain
    

A character string specifying the domain of the concepts being added.Only accepts "Condition", "Drug", "Measurement", or "Observation". This defines under which category the concepts fall and affects which vocabulary is used for them.

seed
    

An optional integer value used to set the random seed for generating reproducible concept attributes like `vocabulary_id` and `concept_class_id`. Useful for testing or when consistent output is required.

## Value

Returns the modified CDM object with the updated concept table reflecting the newly added concepts.The function directly modifies the provided CDM object.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    # Create a mock CDM reference and add concepts in the 'Condition' domain
    cdm <- [mockCdmReference](mockCdmReference.html)() |> mockConcepts(
    conceptSet = [c](https://rdrr.io/r/base/c.html)(100, 200), domain = "Condition")
    
    # View the updated concept entries for the 'Condition' domain
    cdm$concept |> [filter](https://dplyr.tidyverse.org/reference/filter.html)(domain_id == "Condition")
    #> # A tibble: 21 × 10
    #>    concept_id concept_name              domain_id vocabulary_id concept_class_id
    #>         <dbl> <chr>                     <chr>     <chr>         <chr>           
    #>  1     194152 Renal agenesis and dysge… Condition SNOMED        Clinical Finding
    #>  2     444074 Victim of vehicular AND/… Condition SNOMED        Clinical Finding
    #>  3    4151660 Alkaline phosphatase bon… Condition SNOMED        Clinical Finding
    #>  4    4226696 Manic mood                Condition SNOMED        Clinical Finding
    #>  5    4304866 Elevated mood             Condition SNOMED        Clinical Finding
    #>  6   40475132 Arthropathies             Condition ICD10         ICD10 SubChapter
    #>  7   40475135 Other joint disorders     Condition ICD10         ICD10 SubChapter
    #>  8   45430573 Renal agenesis or dysgen… Condition Read          Read            
    #>  9   45511667 Manic mood                Condition Read          Read            
    #> 10   45533778 Other acquired deformiti… Condition ICD10         ICD10 Hierarchy 
    #> # ℹ 11 more rows
    #> # ℹ 5 more variables: standard_concept <chr>, concept_code <chr>,
    #> #   valid_start_date <date>, valid_end_date <date>, invalid_reason <chr>
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/mockVocabularySet.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Creates an empty mock CDM database populated with various vocabulary tables set.

Source: [`R/mockVocabularySet.R`](https://github.com/ohdsi/omock/blob/main/R/mockVocabularySet.R)

`mockVocabularySet.Rd`

This function create specified vocabulary tables to a CDM object. It can either populate the tables with provided data frames or initialize empty tables if no data is provided. This is useful for setting up a testing environment with controlled vocabulary data.

## Usage
    
    
    mockVocabularySet(cdm = [mockCdmReference](mockCdmReference.html)(), vocabularySet = "GiBleed")

## Arguments

cdm
    

A `cdm_reference` object that serves as the base structure for adding vocabulary tables. This should be an existing or a newly created CDM object, typically initialized without any vocabulary tables.

vocabularySet
    

A character string that specifies a prefix or a set name used to initialize mock data tables. This allows for customization of the source data or structure names when generating vocabulary tables.

## Value

Returns the modified `cdm` object with the provided vocabulary set tables.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    # Create a mock CDM reference and populate it with mock vocabulary tables
    cdm <- [mockCdmReference](mockCdmReference.html)() |> mockVocabularySet(vocabularySet = "GiBleed")
    #> ℹ Reading GiBleed tables.
    
    # View the names of the tables added to the CDM
    [names](https://rdrr.io/r/base/names.html)(cdm)
    #> [1] "person"               "observation_period"   "cdm_source"          
    #> [4] "concept"              "vocabulary"           "concept_relationship"
    #> [7] "concept_synonym"      "concept_ancestor"     "drug_strength"       
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://ohdsi.github.io/omock/reference/mockCohort.html

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Generate Synthetic Cohort

Source: [`R/mockCohort.R`](https://github.com/ohdsi/omock/blob/main/R/mockCohort.R)

`mockCohort.Rd`

This function generates synthetic cohort data and adds it to a given CDM (Common Data Model) reference. It allows for creating multiple cohorts with specified properties and simulates the frequency of observations for individuals.

## Usage
    
    
    mockCohort(
      cdm,
      name = "cohort",
      numberCohorts = 1,
      cohortName = [paste0](https://rdrr.io/r/base/paste.html)("cohort_", [seq_len](https://rdrr.io/r/base/seq.html)(numberCohorts)),
      recordPerson = 1,
      seed = NULL
    )

## Arguments

cdm
    

A CDM reference object where the synthetic cohort data will be stored. This object should already include necessary tables such as `person` and `observation_period`.

name
    

A string specifying the name of the table within the CDM where the cohort data will be stored. Defaults to "cohort". This name will be used to reference the new table in the CDM.

numberCohorts
    

An integer specifying the number of different cohorts to create within the table. Defaults to 1. This parameter allows for the creation of multiple cohorts, each with a unique identifier.

cohortName
    

A character vector specifying the names of the cohorts to be created. If not provided, default names based on a sequence (e.g., "cohort_1", "cohort_2", ...) will be generated. The length of this vector must match the value of `numberCohorts`. This parameter provides meaningful names for each cohort.

recordPerson
    

An integer or a vector of integers specifying the expected number of records per person within each cohort. If a single integer is provided, it applies to all cohorts. If a vector is provided, its length must match the value of `numberCohorts`. This parameter helps simulate the frequency of observations for individuals in each cohort, allowing for realistic variability in data.

seed
    

An integer specifying the random seed for reproducibility of the generated data. Setting a seed ensures that the same synthetic data can be generated again, facilitating consistent results across different runs.

## Value

A CDM reference object with the mock cohort tables added. The new table will contain synthetic data representing the specified cohorts, each with its own set of observation records.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    cdm <- [mockCdmReference](mockCdmReference.html)() |>
      [mockPerson](mockPerson.html)(nPerson = 100) |>
      [mockObservationPeriod](mockObservationPeriod.html)() |>
      mockCohort(
        name = "omock_example",
        numberCohorts = 2,
        cohortName = [c](https://rdrr.io/r/base/c.html)("omock_cohort_1", "omock_cohort_2")
      )
    
    cdm
    #> 
    #> ── # OMOP CDM reference (local) of mock database ───────────────────────────────
    #> • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
    #> concept_synonym, drug_strength, observation_period, person, vocabulary
    #> • cohort tables: omock_example
    #> • achilles tables: -
    #> • other tables: -
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
