# It creates columns to indicate the presence of cohorts — addCohortIntersectFlag • PatientProfiles

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

# It creates columns to indicate the presence of cohorts

Source: [`R/addCohortIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addCohortIntersect.R)

`addCohortIntersectFlag.Rd`

It creates columns to indicate the presence of cohorts

## Usage
    
    
    addCohortIntersectFlag(
      x,
      targetCohortTable,
      targetCohortId = NULL,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      targetStartDate = "cohort_start_date",
      targetEndDate = "cohort_end_date",
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, Inf)),
      nameStyle = "{cohort_name}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

targetCohortTable
    

name of the cohort that we want to check for overlap.

targetCohortId
    

vector of cohort definition ids to include.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a specific date or a column date of x.

targetStartDate
    

date of reference in cohort table, either for start (in overlap) or on its own (for incidence).

targetEndDate
    

date of reference in cohort table, either for end (overlap) or NULL (if incidence).

window
    

window to consider events of.

nameStyle
    

naming of the added column or columns, should include required parameters.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table with added columns with overlap information.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addCohortIntersectFlag(
        targetCohortTable = "cohort2"
      )
    #> # Source:   table<og_027_1752077892> [?? x 7]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          3 1952-10-08        1958-09-10     
    #>  2                    3          4 1941-08-11        1947-04-26     
    #>  3                    3          5 1990-05-15        1995-07-25     
    #>  4                    2          9 1936-08-20        1944-12-19     
    #>  5                    3          7 1967-01-03        1972-10-31     
    #>  6                    1         10 1919-04-06        1939-09-01     
    #>  7                    3          2 1951-07-30        1955-01-08     
    #>  8                    2          8 1950-08-19        1977-04-20     
    #>  9                    3          6 1952-06-04        1965-07-15     
    #> 10                    3          1 1948-05-23        1966-02-05     
    #> # ℹ 3 more variables: cohort_1_0_to_inf <dbl>, cohort_3_0_to_inf <dbl>,
    #> #   cohort_2_0_to_inf <dbl>
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
