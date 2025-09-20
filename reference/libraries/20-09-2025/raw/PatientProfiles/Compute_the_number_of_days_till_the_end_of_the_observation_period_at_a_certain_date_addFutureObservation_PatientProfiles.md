# Compute the number of days till the end of the observation period at a certain date — addFutureObservation • PatientProfiles

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

# Compute the number of days till the end of the observation period at a certain date

Source: [`R/addDemographics.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographics.R)

`addFutureObservation.Rd`

Compute the number of days till the end of the observation period at a certain date

## Usage
    
    
    addFutureObservation(
      x,
      indexDate = "cohort_start_date",
      futureObservationName = "future_observation",
      futureObservationType = "days",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the date to compute the future observation.

futureObservationName
    

name of the new column to be added.

futureObservationType
    

Whether to return a "date" or the number of "days".

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

cohort table with added column containing future observation of the individuals.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addFutureObservation()
    #> # Source:   table<og_115_1752077932> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    3          2 1954-06-30        1955-07-22     
    #>  2                    3          3 1965-07-15        1966-05-07     
    #>  3                    2          9 1928-05-22        1938-06-22     
    #>  4                    3          4 1963-07-23        1973-02-21     
    #>  5                    3          8 1935-03-13        1952-02-24     
    #>  6                    2          7 1936-12-01        1946-12-14     
    #>  7                    3          1 1963-05-29        1972-03-02     
    #>  8                    3         10 1984-11-09        1985-02-05     
    #>  9                    2          6 1972-04-06        1972-12-04     
    #> 10                    1          5 1972-03-05        1974-09-12     
    #> # ℹ 1 more variable: future_observation <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
