# Creation of Mock Observational Medical Outcomes Partnership Common Data Model • omock

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
