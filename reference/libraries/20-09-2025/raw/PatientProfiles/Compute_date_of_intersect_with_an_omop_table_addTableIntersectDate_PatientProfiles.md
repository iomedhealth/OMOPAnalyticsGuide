# Compute date of intersect with an omop table. — addTableIntersectDate • PatientProfiles

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

# Compute date of intersect with an omop table.

Source: [`R/addTableIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addTableIntersect.R)

`addTableIntersectDate.Rd`

Compute date of intersect with an omop table.

## Usage
    
    
    addTableIntersectDate(
      x,
      tableName,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, Inf)),
      targetDate = [startDateColumn](startDateColumn.html)(tableName),
      inObservation = TRUE,
      order = "first",
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

targetDate
    

Target date in tableName.

inObservation
    

If TRUE only records inside an observation period will be considered.

order
    

which record is considered in case of multiple records (only required for date and days options).

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
      addTableIntersectDate(tableName = "visit_occurrence")
    #> # Source:   table<og_129_1752077955> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          9 1980-05-20        1981-11-17     
    #>  2                    2          2 1926-09-04        1927-12-31     
    #>  3                    2         10 1982-12-16        1983-05-20     
    #>  4                    2          3 1962-05-28        1980-10-16     
    #>  5                    3          4 1923-04-19        1929-01-14     
    #>  6                    1          8 1959-02-03        1966-10-01     
    #>  7                    3          1 1946-08-30        1971-11-30     
    #>  8                    3          6 1977-10-07        1981-03-22     
    #>  9                    3          7 1972-09-13        1973-10-05     
    #> 10                    1          5 1978-07-21        1996-05-05     
    #> # ℹ 1 more variable: visit_occurrence_0_to_inf <date>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
