# Changelog • OmopSketch

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

# Changelog

Source: [`NEWS.md`](https://github.com/OHDSI/OmopSketch/blob/main/NEWS.md)

## OmopSketch 0.5.1

CRAN release: 2025-06-19

  * removed overall results when plotting trends by [@cecicampanile](https://github.com/cecicampanile) [#418](https://github.com/OHDSI/OmopSketch/issues/418)



## OmopSketch 0.5.0

CRAN release: 2025-06-18

  * Table top concept counts by [@cecicampanile](https://github.com/cecicampanile) [@catalamarti](https://github.com/catalamarti) [#392](https://github.com/OHDSI/OmopSketch/issues/392)

  * summariseTableQuality function by [@cecicampanile](https://github.com/cecicampanile) [#396](https://github.com/OHDSI/OmopSketch/issues/396)

  * specify arguments in examples and deprecate summariseConceptSetCounts by [@cecicampanile](https://github.com/cecicampanile) [#397](https://github.com/OHDSI/OmopSketch/issues/397)

  * In summariseObservationPeriod age computed after trimming to the study period by [@cecicampanile](https://github.com/cecicampanile) [#403](https://github.com/OHDSI/OmopSketch/issues/403)

  * summariseInObservation refactoring by [@cecicampanile](https://github.com/cecicampanile) [#390](https://github.com/OHDSI/OmopSketch/issues/390)

  * fixed warnings in tests by [@cecicampanile](https://github.com/cecicampanile) [#399](https://github.com/OHDSI/OmopSketch/issues/399)shinyCharacteristics() function by [@cecicampanile](https://github.com/cecicampanile) [#401](https://github.com/OHDSI/OmopSketch/issues/401)

  * observation period functions to work with temp tables by [@cecicampanile](https://github.com/cecicampanile) [#400](https://github.com/OHDSI/OmopSketch/issues/400)

  * eunomia vocabulary in mockOmopSketch.R by [@cecicampanile](https://github.com/cecicampanile) [#398](https://github.com/OHDSI/OmopSketch/issues/398)

  * tableQuality() function by [@cecicampanile](https://github.com/cecicampanile) [#406](https://github.com/OHDSI/OmopSketch/issues/406)

  * summariseTableQuality in databaseCharacteristics() by [@cecicampanile](https://github.com/cecicampanile) [#407](https://github.com/OHDSI/OmopSketch/issues/407)

  * use shinyCharacteristics() to generate the shiny deployed in the website by [@cecicampanile](https://github.com/cecicampanile) [#415](https://github.com/OHDSI/OmopSketch/issues/415)

  * Improve tableClinicalRecords.R by [@cecicampanile](https://github.com/cecicampanile) [#417](https://github.com/OHDSI/OmopSketch/issues/417)

  * Documentation by [@cecicampanile](https://github.com/cecicampanile) [#416](https://github.com/OHDSI/OmopSketch/issues/416)




## OmopSketch 0.4.0

CRAN release: 2025-05-15

  * “sex” and “age” output in summariseInObservation by [@cecicampanile](https://github.com/cecicampanile) [#358](https://github.com/OHDSI/OmopSketch/issues/358)

  * source concept in summariseConceptIdCount and tableConceptIdCounts by [@cecicampanile](https://github.com/cecicampanile) [#362](https://github.com/OHDSI/OmopSketch/issues/362)t

  * ableInObservation and tableRecordCount by [@cecicampanile](https://github.com/cecicampanile) [#363](https://github.com/OHDSI/OmopSketch/issues/363)

  * databaseCharacteristics() function by [@cecicampanile](https://github.com/cecicampanile) [#330](https://github.com/OHDSI/OmopSketch/issues/330)

  * Table Record Count and In Observation by [@cecicampanile](https://github.com/cecicampanile) [#363](https://github.com/OHDSI/OmopSketch/issues/363)

  * Add new examples by [@elinrow](https://github.com/elinrow) [#376](https://github.com/OHDSI/OmopSketch/issues/376)Vignette explaining missing data functions by [@elinrow](https://github.com/elinrow) [#375](https://github.com/OHDSI/OmopSketch/issues/375)

  * Update “Summarise observation period” vignette by [@cecicampanile](https://github.com/cecicampanile) [#377](https://github.com/OHDSI/OmopSketch/issues/377)

  * Update “Summarise clinical tables records” by [@cecicampanile](https://github.com/cecicampanile) [#378](https://github.com/OHDSI/OmopSketch/issues/378)

  * Create shiny app with characterisation of synthetic data by [@catalamarti](https://github.com/catalamarti) [#381](https://github.com/OHDSI/OmopSketch/issues/381)

  * “Summarise concept count” vignette by [@cecicampanile](https://github.com/cecicampanile) [#379](https://github.com/OHDSI/OmopSketch/issues/379)

  * Update vocabulary version in summariseOmopSnapshot() by [@cecicampanile](https://github.com/cecicampanile) [#383](https://github.com/OHDSI/OmopSketch/issues/383)




## OmopSketch 0.3.2

CRAN release: 2025-04-14

  * remove dplyr::compute() from sampleOmopTable() by [@cecicampanile](https://github.com/cecicampanile) [#344](https://github.com/OHDSI/OmopSketch/issues/344)
  * option to summarise by person in summariseInObservation by [@cecicampanile](https://github.com/cecicampanile) [#345](https://github.com/OHDSI/OmopSketch/issues/345)
  * counts of 0 in summariseMissingData by [@cecicampanile](https://github.com/cecicampanile) [#346](https://github.com/OHDSI/OmopSketch/issues/346)
  * x ax ordered by observation period ordinal in plotObservationPeriod by [@cecicampanile](https://github.com/cecicampanile) [#348](https://github.com/OHDSI/OmopSketch/issues/348)
  * byOrdinal boolean argument in summariseObservationPeriod by [@cecicampanile](https://github.com/cecicampanile) [#349](https://github.com/OHDSI/OmopSketch/issues/349)
  * bug that was showing percentages over 100 fixed in summariseClinicalRecords by [@cecicampanile](https://github.com/cecicampanile) [#350](https://github.com/OHDSI/OmopSketch/issues/350)



## OmopSketch 0.3.1

CRAN release: 2025-03-16

  * remove dplyr::collect() from summariseClinicalRecords() by [@cecicampanile](https://github.com/cecicampanile) [#328](https://github.com/OHDSI/OmopSketch/issues/328)
  * bug with time_interval fixed in summariseMissingData() by [@cecicampanile](https://github.com/cecicampanile) [#335](https://github.com/OHDSI/OmopSketch/issues/335)
  * improved tableConceptIdCounts by [@cecicampanile](https://github.com/cecicampanile) [#336](https://github.com/OHDSI/OmopSketch/issues/336)
  * arranged variable_name and variable_level in tableClinicalRecords by [@cecicampanile](https://github.com/cecicampanile) [#337](https://github.com/OHDSI/OmopSketch/issues/337)



## OmopSketch 0.3.0

CRAN release: 2025-03-04

  * eunomiaIsAvailable instead of the deprecated eunomia_is_available by [@cecicampanile](https://github.com/cecicampanile) [#316](https://github.com/OHDSI/OmopSketch/issues/316)
  * Account for int64 in summariseInObservation by [@cecicampanile](https://github.com/cecicampanile) [#312](https://github.com/OHDSI/OmopSketch/issues/312)
  * Add “datatable” as possible table type by [@cecicampanile](https://github.com/cecicampanile) [#314](https://github.com/OHDSI/OmopSketch/issues/314)
  * Interval argument in summariseMissingData and summariseConceptIdCounts, year argument deprecated by [@cecicampanile](https://github.com/cecicampanile) [#317](https://github.com/OHDSI/OmopSketch/issues/317)
  * Only records in observation are accounted in summariseConceptIdCounts and summariseConceptSetCounts by [@cecicampanile](https://github.com/cecicampanile) [#319](https://github.com/OHDSI/OmopSketch/issues/319)
  * vignette with full characterisation and shiny by [@cecicampanile](https://github.com/cecicampanile) [#325](https://github.com/OHDSI/OmopSketch/issues/325)
  * in summariseInObservation and summariseObservationPeriod study range is now applied with cohortConstructor::trimToDateRange instead of requireInDateRange by [@cecicampanile](https://github.com/cecicampanile) [#325](https://github.com/OHDSI/OmopSketch/issues/325)



## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
