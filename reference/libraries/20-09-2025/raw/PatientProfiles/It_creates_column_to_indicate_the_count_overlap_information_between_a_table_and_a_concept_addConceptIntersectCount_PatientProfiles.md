# It creates column to indicate the count overlap information between a table and a concept — addConceptIntersectCount • PatientProfiles

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

# It creates column to indicate the count overlap information between a table and a concept

Source: [`R/addConceptIntersect.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addConceptIntersect.R)

`addConceptIntersectCount.Rd`

It creates column to indicate the count overlap information between a table and a concept

## Usage
    
    
    addConceptIntersectCount(
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
      addConceptIntersectCount(conceptSet = [list](https://rdrr.io/r/base/list.html)("acetaminophen" = 1125315))
    #> Warning: ! `codelist` casted to integers.
    #> # Source:   table<og_039_1752077897> [?? x 5]
    #> # Database: DuckDB v1.3.1 [unknown@Linux 6.11.0-1015-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          6 1974-12-08        1976-09-22     
    #>  2                    1          4 1917-06-20        1930-10-24     
    #>  3                    3          3 1921-09-19        1924-01-07     
    #>  4                    1          1 1954-02-08        1997-09-25     
    #>  5                    1          8 2002-01-02        2005-01-26     
    #>  6                    1          7 1903-07-20        1907-03-21     
    #>  7                    3          2 1961-01-02        1968-03-22     
    #>  8                    3         10 1983-10-05        1986-12-08     
    #>  9                    3          5 1962-10-29        1965-11-10     
    #> 10                    2          9 1956-11-03        1957-01-08     
    #> # ℹ 1 more variable: acetaminophen_0_to_inf <dbl>
    
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
