# Add cohort name for each cohort_definition_id — addCohortName • PatientProfiles

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

# Add cohort name for each cohort_definition_id

Source: [`R/utilities.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/utilities.R)

`addCohortName.Rd`

Add cohort name for each cohort_definition_id

## Usage
    
    
    addCohortName(cohort)

## Arguments

cohort
    

cohort to which add the cohort name

## Value

cohort with an extra column with the cohort names

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    cdm$cohort1 |>
      addCohortName()
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date cohort_name
    #>                   <int>      <int> <date>            <date>          <chr>      
    #>  1                    2          6 1962-05-15        1980-12-24      cohort_2   
    #>  2                    3          5 1940-09-14        1954-11-21      cohort_3   
    #>  3                    2          7 1971-01-26        1975-08-12      cohort_2   
    #>  4                    3          1 1948-10-20        1966-10-26      cohort_3   
    #>  5                    1          3 1957-10-29        1962-07-29      cohort_1   
    #>  6                    2         10 1974-12-24        1976-07-06      cohort_2   
    #>  7                    1          8 1991-08-31        1991-10-03      cohort_1   
    #>  8                    1          4 1923-05-31        1931-06-08      cohort_1   
    #>  9                    3          2 1935-08-08        1937-09-14      cohort_3   
    #> 10                    1          9 1962-01-21        1971-12-16      cohort_1   
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
