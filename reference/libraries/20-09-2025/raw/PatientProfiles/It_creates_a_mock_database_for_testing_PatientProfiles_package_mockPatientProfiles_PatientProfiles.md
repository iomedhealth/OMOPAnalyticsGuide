# It creates a mock database for testing PatientProfiles package — mockPatientProfiles • PatientProfiles

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# It creates a mock database for testing PatientProfiles package

Source: [`R/mockPatientProfiles.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/mockPatientProfiles.R)

`mockPatientProfiles.Rd`

It creates a mock database for testing PatientProfiles package

## Usage
    
    
    mockPatientProfiles(
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
    

Name of an schema on the same connection with writing permisions.

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
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    
    cdm <- mockPatientProfiles()
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
