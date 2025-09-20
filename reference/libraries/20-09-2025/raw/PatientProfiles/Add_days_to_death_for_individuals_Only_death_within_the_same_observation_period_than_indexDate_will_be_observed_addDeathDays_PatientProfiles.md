# Add days to death for individuals. Only death within the same observation period than `indexDate` will be observed. — addDeathDays • PatientProfiles

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

# Add days to death for individuals. Only death within the same observation period than `indexDate` will be observed.

Source: [`R/addDeath.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDeath.R)

`addDeathDays.Rd`

Add days to death for individuals. Only death within the same observation period than `indexDate` will be observed.

## Usage
    
    
    addDeathDays(
      x,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [c](https://rdrr.io/r/base/c.html)(0, Inf),
      deathDaysName = "days_to_death",
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

deathDaysName
    

name of the new column to be added.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table x with the added column with death information added.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addDeathDays()
    #> # Source:   table<og_099_1752077923> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          5 1971-10-31        1984-10-02     
    #>  2                    1          6 1993-02-18        1994-05-24     
    #>  3                    1          7 1992-03-08        1997-10-05     
    #>  4                    3         10 1952-08-12        1955-11-26     
    #>  5                    1          9 1965-07-21        1966-11-18     
    #>  6                    2          8 1910-10-08        1927-04-22     
    #>  7                    3          4 1951-08-01        1955-01-19     
    #>  8                    2          1 1935-02-23        1937-10-23     
    #>  9                    3          3 1924-08-03        1934-08-09     
    #> 10                    2          2 1966-01-07        1966-12-08     
    #> # ℹ 1 more variable: days_to_death <dbl>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
