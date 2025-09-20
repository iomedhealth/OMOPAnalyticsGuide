# It creates columns to indicate number of occurrences of intersection with a cohort — addCohortIntersectCount • PatientProfiles

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

# It creates columns to indicate number of occurrences of intersection with a cohort

Source: [`R/addCohortIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addCohortIntersect.R)

`addCohortIntersectCount.Rd`

It creates columns to indicate number of occurrences of intersection with a cohort

## Usage
    
    
    addCohortIntersectCount(
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
      addCohortIntersectCount(
        targetCohortTable = "cohort2"
      )
    #> # Source:   table<og_004_1752077884> [?? x 7]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          6 1980-09-12        2005-08-18     
    #>  2                    3         10 1975-11-09        1977-04-11     
    #>  3                    3          7 1983-04-18        2002-06-23     
    #>  4                    1          8 1930-02-14        1942-04-25     
    #>  5                    1          9 1953-11-05        1954-04-24     
    #>  6                    1          3 1969-10-19        1977-08-26     
    #>  7                    2          5 1923-06-04        1940-05-22     
    #>  8                    1          2 1993-09-24        1993-12-02     
    #>  9                    3          4 1970-08-12        1971-09-07     
    #> 10                    3          1 1978-12-03        1982-05-08     
    #> # ℹ 3 more variables: cohort_2_0_to_inf <dbl>, cohort_1_0_to_inf <dbl>,
    #> #   cohort_3_0_to_inf <dbl>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
