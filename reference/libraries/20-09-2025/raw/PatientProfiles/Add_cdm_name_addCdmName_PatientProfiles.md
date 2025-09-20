# Add cdm name — addCdmName • PatientProfiles

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

# Add cdm name

Source: [`R/utilities.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/utilities.R)

`addCdmName.Rd`

Add cdm name

## Usage
    
    
    addCdmName(table, cdm = omopgenerics::[cdmReference](https://darwin-eu.github.io/omopgenerics/reference/cdmReference.html)(table))

## Arguments

table
    

Table in the cdm

cdm
    

A cdm reference object

## Value

Table with an extra column with the cdm names

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    cdm$cohort1 |>
      addCdmName()
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date cdm_name
    #>                   <int>      <int> <date>            <date>          <chr>   
    #>  1                    3          2 1990-03-24        1993-07-05      PP_MOCK 
    #>  2                    3          4 1967-11-12        1983-07-03      PP_MOCK 
    #>  3                    3          6 1923-10-05        1925-11-21      PP_MOCK 
    #>  4                    2          5 1999-03-19        2003-07-23      PP_MOCK 
    #>  5                    3          7 1935-01-04        1937-03-15      PP_MOCK 
    #>  6                    1          1 1966-02-19        1968-05-07      PP_MOCK 
    #>  7                    2          9 1967-08-05        1983-06-26      PP_MOCK 
    #>  8                    3          8 1948-10-22        1951-08-05      PP_MOCK 
    #>  9                    3          3 1956-02-20        1962-06-23      PP_MOCK 
    #> 10                    1         10 2016-10-06        2024-12-11      PP_MOCK 
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
