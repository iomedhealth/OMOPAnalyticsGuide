# Add flag for death for individuals. Only death within the same observation period than `indexDate` will be observed. — addDeathFlag • PatientProfiles

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

# Add flag for death for individuals. Only death within the same observation period than `indexDate` will be observed.

Source: [`R/addDeath.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addDeath.R)

`addDeathFlag.Rd`

Add flag for death for individuals. Only death within the same observation period than `indexDate` will be observed.

## Usage
    
    
    addDeathFlag(
      x,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [c](https://rdrr.io/r/base/c.html)(0, Inf),
      deathFlagName = "death",
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

deathFlagName
    

name of the new column to be added.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table x with the added column with death information added.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addDeathFlag()
    #> # Source:   table<og_105_1752077925> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date death
    #>                   <int>      <int> <date>            <date>          <dbl>
    #>  1                    1          3 1975-02-22        1986-08-28          0
    #>  2                    2          5 1981-09-20        1993-07-16          0
    #>  3                    1          9 1941-03-20        1953-09-03          0
    #>  4                    2          4 1960-11-27        1964-07-15          0
    #>  5                    3          7 1920-11-23        1920-12-30          0
    #>  6                    2          8 1963-07-17        1964-02-16          0
    #>  7                    2         10 1962-10-12        1976-12-01          0
    #>  8                    3          6 1955-09-30        1965-03-06          0
    #>  9                    1          2 1953-12-21        1958-11-17          0
    #> 10                    1          1 2009-07-18        2016-12-13          0
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
