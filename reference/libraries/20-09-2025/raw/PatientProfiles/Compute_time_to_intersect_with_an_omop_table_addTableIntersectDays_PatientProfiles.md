# Compute time to intersect with an omop table. — addTableIntersectDays • PatientProfiles

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

# Compute time to intersect with an omop table.

Source: [`R/addTableIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addTableIntersect.R)

`addTableIntersectDays.Rd`

Compute time to intersect with an omop table.

## Usage
    
    
    addTableIntersectDays(
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
      addTableIntersectDays(tableName = "visit_occurrence")
    #> # Source:   table<og_134_1752077958> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          8 1940-06-22        1944-11-10     
    #>  2                    2         10 1929-10-21        1933-01-31     
    #>  3                    1          2 1917-05-04        1926-07-16     
    #>  4                    3          3 1986-05-23        1987-09-06     
    #>  5                    1          4 1965-04-11        1972-01-20     
    #>  6                    2          9 1947-08-23        1952-11-04     
    #>  7                    3          1 1932-06-22        1934-03-12     
    #>  8                    1          5 1924-01-12        1938-04-10     
    #>  9                    1          6 1982-11-05        1984-07-06     
    #> 10                    3          7 1909-08-03        1909-12-21     
    #> # ℹ 1 more variable: visit_occurrence_0_to_inf <dbl>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
