# Query to add a column with the individual birth date — addDateOfBirthQuery • PatientProfiles

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

# Query to add a column with the individual birth date

Source: [`R/addDemographicsQuery.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographicsQuery.R)

`addDateOfBirthQuery.Rd`

`r lifecycle::badge("experimental")` Same as `addDateOfBirth()`, except query is not computed to a table.

## Usage
    
    
    addDateOfBirthQuery(
      x,
      dateOfBirthName = "date_of_birth",
      missingDay = 1,
      missingMonth = 1,
      imposeDay = FALSE,
      imposeMonth = FALSE
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

## Value

The function returns the table x with an extra column that contains the date of birth.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addDateOfBirthQuery()
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          6 1983-01-30        1988-08-25     
    #>  2                    1          2 1933-10-18        1935-04-25     
    #>  3                    3          3 1943-04-29        1948-02-11     
    #>  4                    2          7 1977-12-29        1980-02-06     
    #>  5                    2          5 1945-08-10        1946-12-12     
    #>  6                    1         10 1938-04-29        1958-05-17     
    #>  7                    2          1 1946-07-01        1952-05-09     
    #>  8                    3          8 1992-11-22        1996-10-29     
    #>  9                    3          4 1983-09-24        1984-02-14     
    #> 10                    3          9 1919-01-22        1933-01-30     
    #> # ℹ 1 more variable: date_of_birth <date>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
