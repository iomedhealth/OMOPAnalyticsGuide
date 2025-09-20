# Add date of death for individuals. Only death within the same observation period than `indexDate` will be observed. — addDeathDate • PatientProfiles

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

# Add date of death for individuals. Only death within the same observation period than `indexDate` will be observed.

Source: [`R/addDeath.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDeath.R)

`addDeathDate.Rd`

Add date of death for individuals. Only death within the same observation period than `indexDate` will be observed.

## Usage
    
    
    addDeathDate(
      x,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [c](https://rdrr.io/r/base/c.html)(0, Inf),
      deathDateName = "date_of_death",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

indexDate
    

Variable in x that contains the window origin.

censorDate
    

Name of a column to stop followup.

window
    

window to consider events over.

deathDateName
    

name of the new column to be added.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table x with the added column with death information added.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addDeathDate()
    #> # Source:   table<og_093_1752077920> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    3          5 1974-05-13        1976-11-03     
    #>  2                    1          2 1913-05-22        1925-01-17     
    #>  3                    2          1 1991-02-24        1995-02-10     
    #>  4                    2          8 1988-08-14        1993-08-05     
    #>  5                    1          7 1952-12-01        1961-03-14     
    #>  6                    1         10 1993-08-21        1996-09-23     
    #>  7                    1          9 1934-06-14        1935-10-28     
    #>  8                    1          4 1982-07-22        1984-06-09     
    #>  9                    1          3 1909-05-22        1917-07-04     
    #> 10                    1          6 1977-01-06        1977-07-07     
    #> # ℹ 1 more variable: date_of_death <date>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
