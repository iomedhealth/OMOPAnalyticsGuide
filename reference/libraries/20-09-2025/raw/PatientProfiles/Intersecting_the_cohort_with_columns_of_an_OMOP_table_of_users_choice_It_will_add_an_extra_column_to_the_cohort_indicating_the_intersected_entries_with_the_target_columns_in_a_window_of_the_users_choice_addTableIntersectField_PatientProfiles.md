# Intersecting the cohort with columns of an OMOP table of user's choice. It will add an extra column to the cohort, indicating the intersected entries with the target columns in a window of the user's choice. — addTableIntersectField • PatientProfiles

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

# Intersecting the cohort with columns of an OMOP table of user's choice. It will add an extra column to the cohort, indicating the intersected entries with the target columns in a window of the user's choice.

Source: [`R/addTableIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addTableIntersect.R)

`addTableIntersectField.Rd`

Intersecting the cohort with columns of an OMOP table of user's choice. It will add an extra column to the cohort, indicating the intersected entries with the target columns in a window of the user's choice.

## Usage
    
    
    addTableIntersectField(
      x,
      tableName,
      field,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, Inf)),
      targetDate = [startDateColumn](startDateColumn.html)(tableName),
      inObservation = TRUE,
      order = "first",
      allowDuplicates = FALSE,
      nameStyle = "{table_name}_{extra_value}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

tableName
    

Name of the table to intersect with. Options: visit_occurrence, condition_occurrence, drug_exposure, procedure_occurrence, device_exposure, measurement, observation, drug_era, condition_era, specimen, episode.

field
    

The columns from the table in tableName to intersect over. For example, if the user uses visit_occurrence in tableName then for field the possible options include visit_occurrence_id, visit_concept_id, visit_type_concept_id.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a specific date or a column date of x.

window
    

window to consider events in when intersecting with the chosen column.

targetDate
    

The dates in the target columns in tableName that the user may want to restrict to.

inObservation
    

If TRUE only records inside an observation period will be considered.

order
    

which record is considered in case of multiple records (only required for date and days options).

allowDuplicates
    

Whether to allow multiple records with same conceptSet, person_id and targetDate. If switched to TRUE, it can have a different and unpredictable behavior depending on the cdm_source.

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
      addTableIntersectField(
        tableName = "visit_occurrence",
        field = "visit_concept_id",
        order = "last",
        window = [c](https://rdrr.io/r/base/c.html)(-Inf, -1)
      )
    #> # Source:   table<og_139_1752077960> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          3 1913-04-17        1934-09-30     
    #>  2                    1         10 1926-07-09        1932-08-03     
    #>  3                    1          1 1964-04-09        1964-04-28     
    #>  4                    2          5 2006-06-04        2012-04-19     
    #>  5                    1          6 1939-09-12        1939-10-24     
    #>  6                    3          7 1949-08-27        1955-07-15     
    #>  7                    1          2 1994-05-27        1994-11-27     
    #>  8                    2          8 1953-12-12        1956-06-29     
    #>  9                    1          4 1933-11-23        1946-04-22     
    #> 10                    3          9 1953-07-16        1975-08-19     
    #> # ℹ 1 more variable: visit_occurrence_visit_concept_id_minf_to_m1 <int>
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
