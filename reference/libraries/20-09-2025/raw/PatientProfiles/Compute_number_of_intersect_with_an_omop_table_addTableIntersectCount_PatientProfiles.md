# Compute number of intersect with an omop table. — addTableIntersectCount • PatientProfiles

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

# Compute number of intersect with an omop table.

Source: [`R/addTableIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addTableIntersect.R)

`addTableIntersectCount.Rd`

Compute number of intersect with an omop table.

## Usage
    
    
    addTableIntersectCount(
      x,
      tableName,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, Inf)),
      targetStartDate = [startDateColumn](startDateColumn.html)(tableName),
      targetEndDate = [endDateColumn](endDateColumn.html)(tableName),
      inObservation = TRUE,
      nameStyle = "{table_name}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

tableName
    

Name of the table to intersect with. Options: visit_occurrence, condition_occurrence, drug_exposure, procedure_occurrence, device_exposure, measurement, observation, drug_era, condition_era, specimen, episode.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a specific date or a column date of x.

window
    

window to consider events in.

targetStartDate
    

Column name with start date for comparison.

targetEndDate
    

Column name with end date for comparison.

inObservation
    

If TRUE only records inside an observation period will be considered.

nameStyle
    

naming of the added column or columns, should include required parameters.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table with added columns with intersect information.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    cdm$cohort1 |>
      addTableIntersectCount(tableName = "visit_occurrence")
    #> # Source:   table<og_121_1752077953> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          5 1989-09-06        1991-07-02     
    #>  2                    2          7 1967-02-08        1968-08-01     
    #>  3                    2         10 1979-12-02        2003-08-10     
    #>  4                    2          8 2005-12-29        2015-03-13     
    #>  5                    2          2 1913-02-12        1921-03-10     
    #>  6                    3          4 1980-01-30        1981-04-05     
    #>  7                    3          3 1995-03-24        1998-11-13     
    #>  8                    2          1 1912-07-28        1912-09-17     
    #>  9                    2          6 1946-10-01        1959-05-09     
    #> 10                    2          9 1955-10-31        1956-06-15     
    #> # ℹ 1 more variable: visit_occurrence_0_to_inf <dbl>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
