# Query to add demographic characteristics at a certain date — addDemographicsQuery • PatientProfiles

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

# Query to add demographic characteristics at a certain date

Source: [`R/addDemographicsQuery.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographicsQuery.R)

`addDemographicsQuery.Rd`

`r lifecycle::badge("experimental")` Same as `addDemographics()`, except query is not computed to a table.

## Usage
    
    
    addDemographicsQuery(
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
      dateOfBirthName = "date_of_birth"
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

## Value

cohort table with the added demographic information columns.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addDemographicsQuery()
    #> # Source:   SQL [?? x 8]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date   age sex  
    #>                   <int>      <int> <date>            <date>          <int> <chr>
    #>  1                    3          1 1947-10-16        1960-06-03          0 Male 
    #>  2                    3          2 1912-02-15        1919-08-29          8 Male 
    #>  3                    2          3 1962-10-15        1962-11-03         30 Male 
    #>  4                    1          4 1956-10-16        1966-09-14          8 Male 
    #>  5                    1          5 1951-07-26        1973-09-17          4 Male 
    #>  6                    1          6 1977-10-28        1989-09-22          6 Fema…
    #>  7                    3          7 1925-09-09        1930-06-29          3 Male 
    #>  8                    3          8 1953-04-23        1954-06-20         39 Fema…
    #>  9                    1          9 1971-12-11        1980-08-17          4 Male 
    #> 10                    2         10 1978-06-15        1998-04-29         16 Male 
    #> # ℹ 2 more variables: prior_observation <int>, future_observation <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
