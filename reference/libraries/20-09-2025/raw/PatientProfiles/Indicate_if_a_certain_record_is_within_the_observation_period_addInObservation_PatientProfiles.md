# Indicate if a certain record is within the observation period — addInObservation • PatientProfiles

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

# Indicate if a certain record is within the observation period

Source: [`R/addDemographics.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDemographics.R)

`addInObservation.Rd`

Indicate if a certain record is within the observation period

## Usage
    
    
    addInObservation(
      x,
      indexDate = "cohort_start_date",
      window = [c](https://rdrr.io/r/base/c.html)(0, 0),
      completeInterval = FALSE,
      nameStyle = "in_observation",
      name = NULL
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

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

cohort table with the added binary column assessing inObservation.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addInObservation()
    #> # Source:   table<og_117_1752077937> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          1 1953-10-29        1954-04-12     
    #>  2                    1          9 1988-08-25        1990-01-07     
    #>  3                    3          4 1974-08-13        1980-06-01     
    #>  4                    3          8 1975-05-15        1996-12-29     
    #>  5                    1          6 1923-09-01        1928-12-03     
    #>  6                    3          7 1909-02-09        1921-09-17     
    #>  7                    2          5 1909-10-21        1922-07-08     
    #>  8                    1          2 1996-04-09        1996-05-30     
    #>  9                    3         10 1920-05-26        1927-09-15     
    #> 10                    2          3 1959-05-05        1965-08-27     
    #> # ℹ 1 more variable: in_observation <int>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
