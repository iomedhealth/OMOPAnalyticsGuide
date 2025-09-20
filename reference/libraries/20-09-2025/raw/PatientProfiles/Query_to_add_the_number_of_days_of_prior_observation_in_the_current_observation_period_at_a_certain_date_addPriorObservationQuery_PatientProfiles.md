# Query to add the number of days of prior observation in the current observation period at a certain date — addPriorObservationQuery • PatientProfiles

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

# Query to add the number of days of prior observation in the current observation period at a certain date

Source: [`R/addDemographicsQuery.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographicsQuery.R)

`addPriorObservationQuery.Rd`

`r lifecycle::badge("experimental")` Same as `addPriorObservation()`, except query is not computed to a table.

## Usage
    
    
    addPriorObservationQuery(
      x,
      indexDate = "cohort_start_date",
      priorObservationName = "prior_observation",
      priorObservationType = "days"
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

## Value

cohort table with added column containing prior observation of the individuals.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addPriorObservationQuery()
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          4 1988-07-02        1988-07-15     
    #>  2                    1          7 1986-01-19        1995-05-19     
    #>  3                    3          8 1955-12-28        1956-08-19     
    #>  4                    2          1 1958-01-08        1961-06-04     
    #>  5                    2         10 1935-02-08        1940-12-14     
    #>  6                    1          5 1994-04-17        2012-05-29     
    #>  7                    3          6 1917-11-19        1919-09-11     
    #>  8                    2          3 1944-03-02        1944-06-22     
    #>  9                    2          2 1911-07-06        1954-07-06     
    #> 10                    3          9 2004-06-11        2012-02-06     
    #> # ℹ 1 more variable: prior_observation <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
