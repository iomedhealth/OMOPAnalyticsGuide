# Add a column with the individual birth date — addDateOfBirth • PatientProfiles

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

# Add a column with the individual birth date

Source: [`R/addDemographics.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographics.R)

`addDateOfBirth.Rd`

Add a column with the individual birth date

## Usage
    
    
    addDateOfBirth(
      x,
      dateOfBirthName = "date_of_birth",
      missingDay = 1,
      missingMonth = 1,
      imposeDay = FALSE,
      imposeMonth = FALSE,
      name = NULL
    )

## Arguments

x
    

Table in the cdm that contains 'person_id' or 'subject_id'.

dateOfBirthName
    

Name of the column to be added with the date of birth.

missingDay
    

Day of the individuals with no or imposed day of birth.

missingMonth
    

Month of the individuals with no or imposed month of birth.

imposeDay
    

Whether to impose day of birth.

imposeMonth
    

Whether to impose month of birth.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

The function returns the table x with an extra column that contains the date of birth.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addDateOfBirth()
    #> # Source:   table<og_092_1752077916> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          1 1980-06-16        2005-08-11     
    #>  2                    2          4 1936-09-15        1939-10-27     
    #>  3                    1         10 1952-08-16        1954-05-10     
    #>  4                    2          9 2001-01-23        2002-04-18     
    #>  5                    3          2 1974-10-04        1979-05-21     
    #>  6                    1          5 1993-11-01        1996-08-26     
    #>  7                    2          3 1979-05-02        1999-11-28     
    #>  8                    3          8 1956-01-15        1964-03-09     
    #>  9                    1          7 1947-04-12        1951-04-21     
    #> 10                    1          6 1936-01-30        1942-05-05     
    #> # ℹ 1 more variable: date_of_birth <date>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
