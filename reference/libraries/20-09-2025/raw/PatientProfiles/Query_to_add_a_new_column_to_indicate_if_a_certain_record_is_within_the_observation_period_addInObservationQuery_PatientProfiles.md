# Query to add a new column to indicate if a certain record is within the observation period — addInObservationQuery • PatientProfiles

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

# Query to add a new column to indicate if a certain record is within the observation period

Source: [`R/addDemographicsQuery.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographicsQuery.R)

`addInObservationQuery.Rd`

`r lifecycle::badge("experimental")` Same as `addInObservation()`, except query is not computed to a table.

## Usage
    
    
    addInObservationQuery(
      x,
      indexDate = "cohort_start_date",
      window = [c](https://rdrr.io/r/base/c.html)(0, 0),
      completeInterval = FALSE,
      nameStyle = "in_observation"
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the date to compute the observation flag.

window
    

window to consider events of.

completeInterval
    

If the individuals are in observation for the full window.

nameStyle
    

Name of the new columns to create, it must contain "window_name" if multiple windows are provided.

## Value

cohort table with the added binary column assessing inObservation.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addInObservationQuery()
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2         10 1913-10-17        1913-12-18     
    #>  2                    1          5 1969-02-28        1986-01-18     
    #>  3                    1          4 1931-10-22        1932-06-30     
    #>  4                    2          8 1985-11-25        1986-05-21     
    #>  5                    3          6 1937-05-01        1947-08-11     
    #>  6                    3          7 1923-02-14        1930-02-19     
    #>  7                    2          1 1931-04-11        1963-07-28     
    #>  8                    3          9 2002-04-11        2002-05-07     
    #>  9                    2          2 1975-07-18        1984-09-14     
    #> 10                    2          3 1929-09-27        1937-04-29     
    #> # ℹ 1 more variable: in_observation <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
