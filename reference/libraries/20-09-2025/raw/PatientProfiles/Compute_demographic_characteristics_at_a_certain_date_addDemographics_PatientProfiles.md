# Compute demographic characteristics at a certain date — addDemographics • PatientProfiles

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

# Compute demographic characteristics at a certain date

Source: [`R/addDemographics.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographics.R)

`addDemographics.Rd`

Compute demographic characteristics at a certain date

## Usage
    
    
    addDemographics(
      x,
      indexDate = "cohort_start_date",
      age = TRUE,
      ageName = "age",
      ageMissingMonth = 1,
      ageMissingDay = 1,
      ageImposeMonth = FALSE,
      ageImposeDay = FALSE,
      ageGroup = NULL,
      missingAgeGroupValue = "None",
      sex = TRUE,
      sexName = "sex",
      missingSexValue = "None",
      priorObservation = TRUE,
      priorObservationName = "prior_observation",
      priorObservationType = "days",
      futureObservation = TRUE,
      futureObservationName = "future_observation",
      futureObservationType = "days",
      dateOfBirth = FALSE,
      dateOfBirthName = "date_of_birth",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the date to compute the demographics characteristics.

age
    

TRUE or FALSE. If TRUE, age will be calculated relative to indexDate.

ageName
    

Age variable name.

ageMissingMonth
    

Month of the year assigned to individuals with missing month of birth.

ageMissingDay
    

day of the month assigned to individuals with missing day of birth.

ageImposeMonth
    

TRUE or FALSE. Whether the month of the date of birth will be considered as missing for all the individuals.

ageImposeDay
    

TRUE or FALSE. Whether the day of the date of birth will be considered as missing for all the individuals.

ageGroup
    

if not NULL, a list of ageGroup vectors.

missingAgeGroupValue
    

Value to include if missing age.

sex
    

TRUE or FALSE. If TRUE, sex will be identified.

sexName
    

Sex variable name.

missingSexValue
    

Value to include if missing sex.

priorObservation
    

TRUE or FALSE. If TRUE, days of between the start of the current observation period and the indexDate will be calculated.

priorObservationName
    

Prior observation variable name.

priorObservationType
    

Whether to return a "date" or the number of "days".

futureObservation
    

TRUE or FALSE. If TRUE, days between the indexDate and the end of the current observation period will be calculated.

futureObservationName
    

Future observation variable name.

futureObservationType
    

Whether to return a "date" or the number of "days".

dateOfBirth
    

TRUE or FALSE, if true the date of birth will be return.

dateOfBirthName
    

dateOfBirth column name.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

cohort table with the added demographic information columns.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addDemographics()
    #> # Source:   table<og_114_1752077928> [?? x 8]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date   age sex  
    #>                   <int>      <int> <date>            <date>          <int> <chr>
    #>  1                    2          1 1973-06-21        1975-05-16         41 Fema…
    #>  2                    3          2 1963-12-29        1964-12-14         12 Male 
    #>  3                    2          3 1943-10-25        1944-05-13         38 Fema…
    #>  4                    3          4 1931-07-03        1940-06-25          1 Fema…
    #>  5                    2          5 1944-07-23        1962-01-31         17 Fema…
    #>  6                    3          6 1977-01-05        1998-03-25          1 Fema…
    #>  7                    3          7 1996-07-05        1996-11-24         36 Male 
    #>  8                    2          8 1942-01-09        1949-01-17         14 Fema…
    #>  9                    2          9 1942-06-17        1942-11-28         15 Male 
    #> 10                    1         10 1905-10-16        1911-05-06          0 Fema…
    #> # ℹ 2 more variables: prior_observation <int>, future_observation <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
