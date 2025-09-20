# Add the ordinal number of the observation period associated that a given date is in. — addObservationPeriodId • PatientProfiles

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

# Add the ordinal number of the observation period associated that a given date is in.

Source: [`R/addObservationPeriodId.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addObservationPeriodId.R)

`addObservationPeriodId.Rd`

Add the ordinal number of the observation period associated that a given date is in.

## Usage
    
    
    addObservationPeriodId(
      x,
      indexDate = "cohort_start_date",
      nameObservationPeriodId = "observation_period_id",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the date to compute the observation flag.

nameObservationPeriodId
    

Name of the new column.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

Table with the current observation period id added.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addObservationPeriodId()
    #> # Source:   table<og_118_1752077941> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          4 1970-05-25        1974-04-12     
    #>  2                    1          2 1961-08-10        1992-12-26     
    #>  3                    1          6 1943-11-08        1955-09-30     
    #>  4                    2         10 1986-09-04        1993-07-04     
    #>  5                    3          1 1998-03-29        1998-04-24     
    #>  6                    3          5 1944-06-16        1946-01-18     
    #>  7                    2          8 1929-07-09        1930-04-11     
    #>  8                    1          9 1982-10-04        1983-04-21     
    #>  9                    2          3 1929-08-19        1936-05-01     
    #> 10                    1          7 1966-02-28        1967-01-22     
    #> # ℹ 1 more variable: observation_period_id <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
