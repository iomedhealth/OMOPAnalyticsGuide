# Date of cohorts that are present in a certain window — addCohortIntersectDate • PatientProfiles

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

# Date of cohorts that are present in a certain window

Source: [`R/addCohortIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addCohortIntersect.R)

`addCohortIntersectDate.Rd`

Date of cohorts that are present in a certain window

## Usage
    
    
    addCohortIntersectDate(
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
    

Cohort IDs of interest from the other cohort table. If NULL, all cohorts will be used with a time variable added for each cohort of interest.

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
      addCohortIntersectDate(targetCohortTable = "cohort2")
    #> # Source:   table<og_014_1752077887> [?? x 7]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          2 1923-02-14        1926-02-19     
    #>  2                    3         10 2006-06-15        2017-05-06     
    #>  3                    3          9 2003-01-10        2006-06-01     
    #>  4                    1          1 1936-01-12        1936-08-21     
    #>  5                    2          5 1940-08-05        1940-09-14     
    #>  6                    3          6 1961-08-03        1963-05-20     
    #>  7                    3          8 1956-07-17        1957-08-06     
    #>  8                    1          4 1985-11-12        2000-10-01     
    #>  9                    1          3 1911-10-08        1913-04-20     
    #> 10                    3          7 1937-05-17        1940-11-20     
    #> # ℹ 3 more variables: cohort_3_0_to_inf <date>, cohort_2_0_to_inf <date>,
    #> #   cohort_1_0_to_inf <date>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
