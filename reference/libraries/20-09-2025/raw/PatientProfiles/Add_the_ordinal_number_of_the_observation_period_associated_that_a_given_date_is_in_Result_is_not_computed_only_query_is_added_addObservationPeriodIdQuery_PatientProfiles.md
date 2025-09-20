# Add the ordinal number of the observation period associated that a given date is in. Result is not computed, only query is added. — addObservationPeriodIdQuery • PatientProfiles

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

# Add the ordinal number of the observation period associated that a given date is in. Result is not computed, only query is added.

Source: [`R/addObservationPeriodId.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addObservationPeriodId.R)

`addObservationPeriodIdQuery.Rd`

Add the ordinal number of the observation period associated that a given date is in. Result is not computed, only query is added.

## Usage
    
    
    addObservationPeriodIdQuery(
      x,
      indexDate = "cohort_start_date",
      nameObservationPeriodId = "observation_period_id"
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the date to compute the observation flag.

nameObservationPeriodId
    

Name of the new column.

## Value

Table with the current observation period id added.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addObservationPeriodIdQuery()
    #> # Source:   SQL [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          9 1959-03-12        1959-05-03     
    #>  2                    3          8 1946-07-31        1947-03-27     
    #>  3                    3          7 1964-05-08        1989-12-19     
    #>  4                    2          3 1996-06-03        2004-07-12     
    #>  5                    1          2 1996-03-22        2006-12-16     
    #>  6                    2          4 1973-12-10        1986-11-03     
    #>  7                    1          6 1999-04-26        2010-12-01     
    #>  8                    1          5 1953-06-05        1963-12-28     
    #>  9                    1          1 2028-05-21        2029-12-02     
    #> 10                    2         10 1940-04-20        1940-06-18     
    #> # ℹ 1 more variable: observation_period_id <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
