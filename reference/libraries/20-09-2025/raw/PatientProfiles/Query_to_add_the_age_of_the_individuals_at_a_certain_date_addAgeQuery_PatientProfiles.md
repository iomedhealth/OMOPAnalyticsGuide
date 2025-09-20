# Query to add the age of the individuals at a certain date — addAgeQuery • PatientProfiles

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

# Query to add the age of the individuals at a certain date

Source: [`R/addDemographicsQuery.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographicsQuery.R)

`addAgeQuery.Rd`

`r lifecycle::badge("experimental")` Same as `addAge()`, except query is not computed to a table.

## Usage
    
    
    addAgeQuery(
      x,
      indexDate = "cohort_start_date",
      ageName = "age",
      ageGroup = NULL,
      ageMissingMonth = 1,
      ageMissingDay = 1,
      ageImposeMonth = FALSE,
      ageImposeDay = FALSE,
      missingAgeGroupValue = "None"
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the date to compute the age.

ageName
    

Name of the new column that contains age.

ageGroup
    

List of age groups to be added.

ageMissingMonth
    

Month of the year assigned to individuals with missing month of birth. By default: 1.

ageMissingDay
    

day of the month assigned to individuals with missing day of birth. By default: 1.

ageImposeMonth
    

Whether the month of the date of birth will be considered as missing for all the individuals.

ageImposeDay
    

Whether the day of the date of birth will be considered as missing for all the individuals.

missingAgeGroupValue
    

Value to include if missing age.

## Value

tibble with the age column added.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addAgeQuery()
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date   age
    #>                   <int>      <int> <date>            <date>          <int>
    #>  1                    1          4 1948-11-06        1950-08-02         22
    #>  2                    3          8 1981-05-14        1997-02-24         25
    #>  3                    2         10 1950-10-09        1955-07-29         42
    #>  4                    3          5 1942-07-31        1942-08-29          6
    #>  5                    2          9 1940-07-19        1941-10-31         20
    #>  6                    3          3 1950-03-10        1951-04-15         40
    #>  7                    2          1 1958-01-29        1971-06-15         14
    #>  8                    1          7 1942-09-04        1947-07-28          8
    #>  9                    2          2 1919-02-04        1937-02-18         12
    #> 10                    3          6 1993-07-26        1993-08-05         45
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
