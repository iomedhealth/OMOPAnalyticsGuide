# Query to add the number of days till the end of the observation period at a certain date — addFutureObservationQuery • PatientProfiles

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

# Query to add the number of days till the end of the observation period at a certain date

Source: [`R/addDemographicsQuery.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographicsQuery.R)

`addFutureObservationQuery.Rd`

`r lifecycle::badge("experimental")` Same as `addFutureObservation()`, except query is not computed to a table.

## Usage
    
    
    addFutureObservationQuery(
      x,
      indexDate = "cohort_start_date",
      futureObservationName = "future_observation",
      futureObservationType = "days"
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

## Value

cohort table with added column containing future observation of the individuals.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addFutureObservationQuery()
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    3          1 1977-08-29        1982-12-01     
    #>  2                    1         10 1980-04-24        1986-02-12     
    #>  3                    3          5 1914-09-24        1929-12-27     
    #>  4                    3          6 1997-06-03        1998-06-16     
    #>  5                    1          7 1913-12-24        1919-07-31     
    #>  6                    1          3 1972-04-24        1972-10-03     
    #>  7                    3          4 1947-11-14        1957-07-09     
    #>  8                    1          2 1918-10-13        1920-10-21     
    #>  9                    1          8 1938-09-11        1953-11-12     
    #> 10                    2          9 1927-05-18        1930-03-22     
    #> # ℹ 1 more variable: future_observation <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
