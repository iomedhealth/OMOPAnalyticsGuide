# It creates a mock database for testing CohortCharacteristics package — mockCohortCharacteristics • CohortCharacteristics

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# It creates a mock database for testing CohortCharacteristics package

Source: [`R/reexports.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/reexports.R)

`mockCohortCharacteristics.Rd`

It creates a mock database for testing CohortCharacteristics package

## Usage
    
    
    mockCohortCharacteristics(
      con = NULL,
      writeSchema = NULL,
      numberIndividuals = 10,
      ...,
      seed = NULL
    )

## Arguments

con
    

A DBI connection to create the cdm mock object.

writeSchema
    

Name of an schema on the same connection with writing permissions.

numberIndividuals
    

Number of individuals to create in the cdm reference.

...
    

User self defined tables to put in cdm, it can input as many as the user want.

seed
    

A number to set the seed. If NULL seed is not used.

## Value

A mock cdm_reference object created following user's specifications.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    
    cdm <- mockCohortCharacteristics()
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
