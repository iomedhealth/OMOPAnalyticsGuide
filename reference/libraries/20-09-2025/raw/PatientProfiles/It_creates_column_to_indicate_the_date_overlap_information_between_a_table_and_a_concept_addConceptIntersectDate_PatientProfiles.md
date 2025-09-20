# It creates column to indicate the date overlap information between a table and a concept — addConceptIntersectDate • PatientProfiles

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

# It creates column to indicate the date overlap information between a table and a concept

Source: [`R/addConceptIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addConceptIntersect.R)

`addConceptIntersectDate.Rd`

It creates column to indicate the date overlap information between a table and a concept

## Usage
    
    
    addConceptIntersectDate(
      x,
      conceptSet,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, Inf)),
      targetDate = "event_start_date",
      order = "first",
      inObservation = TRUE,
      nameStyle = "{concept_name}_{window_name}",
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

conceptSet
    

Concept set list.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a date column of x

window
    

window to consider events in.

targetDate
    

Event date to use for the intersection.

order
    

last or first date to use for date/days calculations.

inObservation
    

If TRUE only records inside an observation period will be considered.

nameStyle
    

naming of the added column or columns, should include required parameters.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

table with added columns with overlap information

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
      addConceptIntersectDate(conceptSet = [list](https://rdrr.io/r/base/list.html)("acetaminophen" = 1125315))
    #> Warning: ! `codelist` casted to integers.
    #> # Source:   table<og_052_1752077901> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    3          8 2015-07-04        2016-07-05     
    #>  2                    2          2 1954-12-27        1988-12-04     
    #>  3                    3          7 1949-04-10        1992-01-21     
    #>  4                    2         10 2006-01-13        2009-11-18     
    #>  5                    1          4 1978-07-14        1995-03-14     
    #>  6                    1          1 1951-04-24        1951-06-25     
    #>  7                    1          9 1935-07-29        1950-08-08     
    #>  8                    1          3 1946-05-04        1951-12-29     
    #>  9                    2          6 1930-07-04        1947-10-09     
    #> 10                    3          5 1976-08-29        1981-12-03     
    #> # ℹ 1 more variable: acetaminophen_0_to_inf <date>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
