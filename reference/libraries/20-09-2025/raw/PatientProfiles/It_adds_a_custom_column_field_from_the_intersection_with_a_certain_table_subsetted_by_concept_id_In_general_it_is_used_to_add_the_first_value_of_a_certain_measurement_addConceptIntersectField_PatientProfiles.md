# It adds a custom column (field) from the intersection with a certain table subsetted by concept id. In general it is used to add the first value of a certain measurement. — addConceptIntersectField • PatientProfiles

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

# It adds a custom column (field) from the intersection with a certain table subsetted by concept id. In general it is used to add the first value of a certain measurement.

Source: [`R/addConceptIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addConceptIntersect.R)

`addConceptIntersectField.Rd`

It adds a custom column (field) from the intersection with a certain table subsetted by concept id. In general it is used to add the first value of a certain measurement.

## Usage
    
    
    addConceptIntersectField(
      x,
      conceptSet,
      field,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, Inf)),
      targetDate = "event_start_date",
      order = "first",
      inObservation = TRUE,
      allowDuplicates = FALSE,
      nameStyle = "{field}_{concept_name}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

conceptSet
    

Concept set list.

field
    

Column in the standard omop table that you want to add.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

Whether to censor overlap events at a date column of x

window
    

Window to consider events in.

targetDate
    

Event date to use for the intersection.

order
    

'last' or 'first' to refer to which event consider if multiple events are present in the same window.

inObservation
    

If TRUE only records inside an observation period will be considered.

allowDuplicates
    

Whether to allow multiple records with same conceptSet, person_id and targetDate. If switched to TRUE, it can have a different and unpredictable behavior depending on the cdm_source.

nameStyle
    

naming of the added column or columns, should include required parameters.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

Table with the `field` value obtained from the intersection

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    concept <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      concept_id = [c](https://rdrr.io/r/base/c.html)(1125315),
      domain_id = "Drug",
      vocabulary_id = NA_character_,
      concept_class_id = "Ingredient",
      standard_concept = "S",
      concept_code = NA_character_,
      valid_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("1900-01-01"),
      valid_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2099-01-01"),
      invalid_reason = NA_character_
    ) |>
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(concept_name = [paste0](https://rdrr.io/r/base/paste.html)("concept: ", .data$concept_id))
    cdm <- CDMConnector::[insertTable](https://darwin-eu.github.io/omopgenerics/reference/insertTable.html)(cdm, "concept", concept)
    
    cdm$cohort1 |>
      addConceptIntersectField(
        conceptSet = [list](https://rdrr.io/r/base/list.html)("acetaminophen" = 1125315),
        field = "drug_type_concept_id"
      )
    #> Warning: ! `codelist` casted to integers.
    #> # Source:   table<og_072_1752077907> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          8 1941-07-12        1957-05-12     
    #>  2                    2          3 1994-05-22        1997-11-08     
    #>  3                    3          5 1980-09-16        1980-09-21     
    #>  4                    1         10 1949-11-26        1955-08-07     
    #>  5                    2          1 1922-11-21        1923-02-25     
    #>  6                    3          7 1994-07-30        2016-07-22     
    #>  7                    2          4 1995-03-09        1996-04-10     
    #>  8                    1          6 1937-02-06        1937-12-23     
    #>  9                    3          2 1975-12-19        1981-01-05     
    #> 10                    3          9 1990-06-29        1991-06-01     
    #> # ℹ 1 more variable: drug_type_concept_id_acetaminophen_0_to_inf <chr>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
