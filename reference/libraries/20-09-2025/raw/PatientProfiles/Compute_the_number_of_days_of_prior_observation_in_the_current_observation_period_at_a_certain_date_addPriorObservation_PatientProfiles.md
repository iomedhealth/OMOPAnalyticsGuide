# Compute the number of days of prior observation in the current observation period at a certain date — addPriorObservation • PatientProfiles

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

# Compute the number of days of prior observation in the current observation period at a certain date

Source: [`R/addDemographics.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographics.R)

`addPriorObservation.Rd`

Compute the number of days of prior observation in the current observation period at a certain date

## Usage
    
    
    addPriorObservation(
      x,
      indexDate = "cohort_start_date",
      priorObservationName = "prior_observation",
      priorObservationType = "days",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the date to compute the prior observation.

priorObservationName
    

name of the new column to be added.

priorObservationType
    

Whether to return a "date" or the number of "days".

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

cohort table with added column containing prior observation of the individuals.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addPriorObservation()
    #> # Source:   table<og_119_1752077945> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          8 1963-04-02        1975-08-05     
    #>  2                    2          1 1945-12-20        1964-04-11     
    #>  3                    2         10 1959-01-17        1976-06-12     
    #>  4                    3          4 1975-09-18        1979-05-02     
    #>  5                    2          3 1940-03-02        1940-12-11     
    #>  6                    1          9 1959-07-04        1960-03-27     
    #>  7                    1          7 1913-02-17        1914-10-20     
    #>  8                    3          2 1953-03-30        1954-02-13     
    #>  9                    1          5 1959-07-16        1959-08-27     
    #> 10                    2          6 1916-12-23        1931-10-23     
    #> # ℹ 1 more variable: prior_observation <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
