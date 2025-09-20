# It creates column to indicate the flag overlap information between a table and a concept — addConceptIntersectFlag • PatientProfiles

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

# It creates column to indicate the flag overlap information between a table and a concept

Source: [`R/addConceptIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addConceptIntersect.R)

`addConceptIntersectFlag.Rd`

It creates column to indicate the flag overlap information between a table and a concept

## Usage
    
    
    addConceptIntersectFlag(
      x,
      conceptSet,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, Inf)),
      targetStartDate = "event_start_date",
      targetEndDate = "event_end_date",
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

targetStartDate
    

Event start date to use for the intersection.

targetEndDate
    

Event end date to use for the intersection.

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
      addConceptIntersectFlag(conceptSet = [list](https://rdrr.io/r/base/list.html)("acetaminophen" = 1125315))
    #> Warning: ! `codelist` casted to integers.
    #> # Source:   table<og_082_1752077910> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    2          2 1916-01-01        1936-02-18     
    #>  2                    2          3 1906-01-21        1916-06-29     
    #>  3                    1          4 1937-07-21        1940-10-11     
    #>  4                    1          7 1934-11-06        1940-05-06     
    #>  5                    3          5 1953-03-27        1986-11-03     
    #>  6                    2          9 1945-05-09        1955-11-24     
    #>  7                    1          6 1972-05-14        1975-05-25     
    #>  8                    2         10 1944-10-15        1949-07-15     
    #>  9                    2          8 1947-12-26        1968-03-18     
    #> 10                    2          1 2030-01-04        2031-09-23     
    #> # ℹ 1 more variable: acetaminophen_0_to_inf <dbl>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
