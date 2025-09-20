# Summarise concept counts in patient-level data. Only concepts recorded during observation period are counted. — summariseConceptCounts • OmopSketch

Skip to contents

[OmopSketch](../index.html) 0.5.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Summarise clinical tables records](../articles/summarise_clinical_tables_records.html)
    * [Summarise concept id counts](../articles/summarise_concept_id_counts.html)
    * [Summarise observation period](../articles/summarise_observation_period.html)
    * [Characterisation of OMOP CDM](../articles/characterisation.html)
    * [Summarise missing data](../articles/missing_data.html)
    * [Summarise database characteristics](../articles/database_characteristics.html)
  * [Changelog](../news/index.html)
  * [Characterisation synthetic datasets](https://dpa-pde-oxford.shinyapps.io/OmopSketchCharacterisation/)


  *   * [](https://github.com/OHDSI/OmopSketch/)



![](../logo.png)

# Summarise concept counts in patient-level data. Only concepts recorded during observation period are counted.

Source: [`R/summariseConceptCounts.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/summariseConceptCounts.R)

`summariseConceptCounts.Rd`

[![\[Deprecated\]](figures/lifecycle-deprecated.svg)](https://lifecycle.r-lib.org/articles/stages.html#deprecated)

## Usage
    
    
    summariseConceptCounts(
      cdm,
      conceptId,
      countBy = [c](https://rdrr.io/r/base/c.html)("record", "person"),
      concept = TRUE,
      interval = "overall",
      sex = FALSE,
      ageGroup = NULL,
      dateRange = NULL
    )

## Arguments

cdm
    

A cdm object

conceptId
    

List of concept IDs to summarise.

countBy
    

Either "record" for record-level counts or "person" for person-level counts

concept
    

TRUE or FALSE. If TRUE code use will be summarised by concept.

interval
    

Time interval to stratify by. It can either be "years", "quarters", "months" or "overall".

sex
    

TRUE or FALSE. If TRUE code use will be summarised by sex.

ageGroup
    

A list of ageGroup vectors of length two. Code use will be thus summarised by age groups.

dateRange
    

A vector of two dates defining the desired study period. Only the `start_date` column of the OMOP table is checked to ensure it falls within this range. If `dateRange` is `NULL`, no restriction is applied.

## Value

A summarised_result object with results overall and, if specified, by strata.

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
