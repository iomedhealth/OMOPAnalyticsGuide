# Compute the sex of the individuals — addSex • PatientProfiles

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

# Compute the sex of the individuals

Source: [`R/addDemographics.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographics.R)

`addSex.Rd`

Compute the sex of the individuals

## Usage
    
    
    addSex(x, sexName = "sex", missingSexValue = "None", name = NULL)

## Arguments

x
    

Table with individuals in the cdm.

sexName
    

name of the new column to be added.

missingSexValue
    

Value to include if missing sex.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table x with the added column with sex information.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addSex()
    #> # Source:   table<og_120_1752077949> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date sex   
    #>                   <int>      <int> <date>            <date>          <chr> 
    #>  1                    2          1 1948-09-19        1951-07-04      Female
    #>  2                    1          2 1996-03-02        2006-04-11      Female
    #>  3                    2          3 1975-06-24        1980-12-09      Female
    #>  4                    3          4 1964-10-14        1981-03-17      Male  
    #>  5                    3          5 1954-10-18        1957-04-05      Male  
    #>  6                    2          6 1938-12-16        1939-02-14      Male  
    #>  7                    3          7 1955-05-18        1962-05-10      Male  
    #>  8                    1          8 1939-01-25        1939-04-04      Male  
    #>  9                    3          9 1958-07-31        1962-12-28      Female
    #> 10                    2         10 1910-01-31        1910-03-17      Male  
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
