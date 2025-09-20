# Compute the age of the individuals at a certain date — addAge • PatientProfiles

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

# Compute the age of the individuals at a certain date

Source: [`R/addDemographics.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographics.R)

`addAge.Rd`

Compute the age of the individuals at a certain date

## Usage
    
    
    addAge(
      x,
      indexDate = "cohort_start_date",
      ageName = "age",
      ageGroup = NULL,
      ageMissingMonth = 1,
      ageMissingDay = 1,
      ageImposeMonth = FALSE,
      ageImposeDay = FALSE,
      missingAgeGroupValue = "None",
      name = NULL
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

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

tibble with the age column added.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addAge()
    #> # Source:   table<og_001_1752077876> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date   age
    #>                   <int>      <int> <date>            <date>          <int>
    #>  1                    1         10 1995-08-12        2002-08-14         33
    #>  2                    2          4 1986-05-17        1986-07-22          7
    #>  3                    3          6 1938-08-02        1938-08-19         36
    #>  4                    1          7 1970-09-20        1973-06-22          8
    #>  5                    3          9 1956-11-27        1965-01-19         13
    #>  6                    1          2 1927-11-21        1933-10-31         22
    #>  7                    1          3 1926-01-03        1931-07-22          2
    #>  8                    1          5 1983-11-23        1990-12-19          6
    #>  9                    1          1 1971-08-26        1979-02-11          2
    #> 10                    2          8 1973-08-11        1978-10-05         18
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
