# Compute a flag intersect with an omop table. — addTableIntersectFlag • PatientProfiles

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

# Compute a flag intersect with an omop table.

Source: [`R/addTableIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addTableIntersect.R)

`addTableIntersectFlag.Rd`

Compute a flag intersect with an omop table.

## Usage
    
    
    addTableIntersectFlag(
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
      addTableIntersectFlag(tableName = "visit_occurrence")
    #> # Source:   table<og_144_1752077963> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          3 1976-05-05        1985-04-10     
    #>  2                    2          4 1938-02-14        1938-04-23     
    #>  3                    2          6 1910-08-21        1911-10-24     
    #>  4                    3          2 1925-02-18        1927-09-16     
    #>  5                    2          7 1937-02-06        1955-03-13     
    #>  6                    3          1 1931-03-25        1932-12-19     
    #>  7                    1          9 1975-05-27        1981-10-23     
    #>  8                    1          5 1967-03-13        1969-11-07     
    #>  9                    1          8 1943-06-02        1943-08-21     
    #> 10                    3         10 1948-01-23        1957-10-30     
    #> # ℹ 1 more variable: visit_occurrence_0_to_inf <dbl>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
