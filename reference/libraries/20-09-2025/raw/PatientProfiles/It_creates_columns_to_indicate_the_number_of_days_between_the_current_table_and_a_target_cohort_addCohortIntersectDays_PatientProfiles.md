# It creates columns to indicate the number of days between the current table and a target cohort — addCohortIntersectDays • PatientProfiles

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

# It creates columns to indicate the number of days between the current table and a target cohort

Source: [`R/addCohortIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addCohortIntersect.R)

`addCohortIntersectDays.Rd`

It creates columns to indicate the number of days between the current table and a target cohort

## Usage
    
    
    addCohortIntersectDays(
      x,
      targetCohortTable,
      targetCohortId = NULL,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      targetDate = "cohort_start_date",
      order = "first",
      window = [c](https://rdrr.io/r/base/c.html)(0, Inf),
      nameStyle = "{cohort_name}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

targetCohortTable
    

Cohort table to.

targetCohortId
    

Cohort IDs of interest from the other cohort table. If NULL, all cohorts will be used with a days variable added for each cohort of interest.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a specific date or a column date of x.

targetDate
    

Date of interest in the other cohort table. Either cohort_start_date or cohort_end_date.

order
    

date to use if there are multiple records for an individual during the window of interest. Either first or last.

window
    

Window of time to identify records relative to the indexDate. Records outside of this time period will be ignored.

nameStyle
    

naming of the added column or columns, should include required parameters.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

x along with additional columns for each cohort of interest.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addCohortIntersectDays(targetCohortTable = "cohort2")
    #> # Source:   table<og_021_1752077889> [?? x 7]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    3          1 1957-05-28        1960-02-18     
    #>  2                    1         10 1951-03-24        1969-10-06     
    #>  3                    3          5 1958-01-08        1965-11-13     
    #>  4                    3          2 1988-11-20        2000-05-23     
    #>  5                    1          4 1955-01-13        1962-02-16     
    #>  6                    2          8 1997-04-11        2003-01-20     
    #>  7                    3          6 1985-05-23        1993-10-25     
    #>  8                    2          9 1961-12-14        1965-09-21     
    #>  9                    3          3 1951-12-31        1957-11-21     
    #> 10                    3          7 1978-06-08        1985-08-02     
    #> # ℹ 3 more variables: cohort_2_0_to_inf <dbl>, cohort_1_0_to_inf <dbl>,
    #> #   cohort_3_0_to_inf <dbl>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
