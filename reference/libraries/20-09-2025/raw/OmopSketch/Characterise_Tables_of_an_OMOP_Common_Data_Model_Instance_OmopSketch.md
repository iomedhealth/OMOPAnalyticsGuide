# Characterise Tables of an OMOP Common Data Model Instance • OmopSketch

Skip to contents

[OmopSketch](index.html) 0.5.1

  * [Reference](reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Summarise clinical tables records](articles/summarise_clinical_tables_records.html)
    * [Summarise concept id counts](articles/summarise_concept_id_counts.html)
    * [Summarise observation period](articles/summarise_observation_period.html)
    * [Characterisation of OMOP CDM](articles/characterisation.html)
    * [Summarise missing data](articles/missing_data.html)
    * [Summarise database characteristics](articles/database_characteristics.html)
  * [Changelog](news/index.html)
  * [Characterisation synthetic datasets](https://dpa-pde-oxford.shinyapps.io/OmopSketchCharacterisation/)


  *   * [](https://github.com/OHDSI/OmopSketch/)



![](logo.png)

# OmopSketch 

The goal of OmopSketch is to characterise and visualise an OMOP CDM instance to asses if it meets the necessary criteria to answer a specific clinical question and conduct a certain study.

## Installation

You can install the development version of OmopSketch from [GitHub](https://github.com/) with:
    
    
    # install.packages("remotes")
    remotes::[install_github](https://remotes.r-lib.org/reference/install_github.html)("OHDSI/OmopSketch")

## Example

Let’s start by creating a cdm object using the Eunomia mock dataset:
    
    
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    #> Loading required package: DBI
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, cdmSchema = "main", writeSchema = "main")
    #> Note: method with signature 'DBIConnection#Id' chosen for function 'dbExistsTable',
    #>  target signature 'duckdb_connection#Id'.
    #>  "duckdb_connection#ANY" would also be valid
    #> ! cdm name not specified and could not be inferred from the cdm source table
    cdm
    #> 
    #> ── # OMOP CDM reference (duckdb) of An OMOP CDM database ───────────────────────
    #> • omop tables: person, observation_period, visit_occurrence, visit_detail,
    #> condition_occurrence, drug_exposure, procedure_occurrence, device_exposure,
    #> measurement, observation, death, note, note_nlp, specimen, fact_relationship,
    #> location, care_site, provider, payer_plan_period, cost, drug_era, dose_era,
    #> condition_era, metadata, cdm_source, concept, vocabulary, domain,
    #> concept_class, concept_relationship, relationship, concept_synonym,
    #> concept_ancestor, source_to_concept_map, drug_strength
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -

### Snapshot

We first create a snapshot of our database. This will allow us to track when the analysis has been conducted and capture details about the CDM version or the data release.
    
    
    [summariseOmopSnapshot](reference/summariseOmopSnapshot.html)(cdm) |>
      [tableOmopSnapshot](reference/tableOmopSnapshot.html)(type = "flextable")

![](reference/figures/README-unnamed-chunk-3-1.png)

### Characterise the clinical tables

Once we have collected the snapshot information, we can start characterising the clinical tables of the CDM. By using `[summariseClinicalRecords()](reference/summariseClinicalRecords.html)` and `[tableClinicalRecords()](reference/tableClinicalRecords.html)`, we can easily visualise the main characteristics of specific clinical tables.
    
    
    [summariseClinicalRecords](reference/summariseClinicalRecords.html)(cdm, [c](https://rdrr.io/r/base/c.html)("condition_occurrence", "drug_exposure")) |>
      [tableClinicalRecords](reference/tableClinicalRecords.html)(type = "flextable")
    #> ℹ Adding variables of interest to condition_occurrence.
    #> ℹ Summarising records per person in condition_occurrence.
    #> ℹ Summarising condition_occurrence: `in_observation`, `standard_concept`,
    #>   `source_vocabulary`, `domain_id`, and `type_concept`.
    #> ℹ Adding variables of interest to drug_exposure.
    #> ℹ Summarising records per person in drug_exposure.
    #> ℹ Summarising drug_exposure: `in_observation`, `standard_concept`,
    #>   `source_vocabulary`, `domain_id`, and `type_concept`.

![](reference/figures/README-unnamed-chunk-4-1.png)

We can also explore trends in the clinical table records over time.
    
    
    [summariseRecordCount](reference/summariseRecordCount.html)(cdm, [c](https://rdrr.io/r/base/c.html)("condition_occurrence", "drug_exposure"), interval = "years") |>
      [plotRecordCount](reference/plotRecordCount.html)(facet = "omop_table", colour = "cdm_name")

![](reference/figures/README-unnamed-chunk-5-1.png)

### Characterise the observation period

After visualising the main characteristics of our clinical tables, we can explore the observation period details. OmopSketch provides several functions to have an overview the dataset study period.

Using `[summariseInObservation()](reference/summariseInObservation.html)` and `[plotInObservation()](reference/plotInObservation.html)`, we can gather information on the number of records per year.
    
    
    [summariseInObservation](reference/summariseInObservation.html)(cdm$observation_period, output = "records", interval = "years") |>
      [plotInObservation](reference/plotInObservation.html)(colour = "cdm_name")
    #> `result_id` is not present in result.
    #> `result_id` is not present in result.

![](reference/figures/README-unnamed-chunk-6-1.png)

You can also visualise and explore the characteristics of the observation period per each individual in the database using `[summariseObservationPeriod()](reference/summariseObservationPeriod.html)`.
    
    
    [summariseObservationPeriod](reference/summariseObservationPeriod.html)(cdm$observation_period) |>
      [tableObservationPeriod](reference/tableObservationPeriod.html)(type = "flextable")

![](reference/figures/README-unnamed-chunk-7-1.png)

Or if visualisation is preferred, you can easily build a histogram to explore how many participants have more than one observation period.
    
    
    [summariseObservationPeriod](reference/summariseObservationPeriod.html)(cdm$observation_period) |>
      [plotObservationPeriod](reference/plotObservationPeriod.html)(colour = "observation_period_ordinal")

![](reference/figures/README-unnamed-chunk-8-1.png)

### Characterise the concepts

OmopSketch also provides functions to explore some of (or all) the concepts in the dataset.
    
    
    acetaminophen <- [c](https://rdrr.io/r/base/c.html)(1125315,  1127433, 1127078)
    
    [summariseConceptSetCounts](reference/summariseConceptSetCounts.html)(cdm, conceptSet = [list](https://rdrr.io/r/base/list.html)("acetaminophen" = acetaminophen)) |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "Number records") |> 
      [plotConceptSetCounts](reference/plotConceptSetCounts.html)(colour = "codelist_name")
    #> Warning: ! `codelist` contains numeric values, they are casted to integers.
    #> ℹ Searching concepts from domain drug in drug_exposure.
    #> ℹ Counting concepts

![](reference/figures/README-unnamed-chunk-9-1.png)

As seen, OmopSketch offers multiple functionalities to provide a general overview of a database. Additionally, it includes more tools and arguments that allow for deeper exploration, helping to assess the database’s suitability for specific research studies. For further information, please refer to the vignettes.

## Links

  * [View on CRAN](https://cloud.r-project.org/package=OmopSketch)
  * [Browse source code](https://github.com/OHDSI/OmopSketch/)
  * [Report a bug](https://github.com/OHDSI/OmopSketch/issues)



## License

  * [Full license](LICENSE.html)
  * Apache License (>= 2)



## Citation

  * [Citing OmopSketch](authors.html#citation)



## Developers

  * Marta Alcalde-Herraiz   
Author  [](https://orcid.org/0009-0002-4405-1814)
  * Kim Lopez-Guell   
Author  [](https://orcid.org/0000-0002-8462-8668)
  * Elin Rowlands   
Author  [](https://orcid.org/0009-0005-5166-0417)
  * Cecilia Campanile   
Author, maintainer  [](https://orcid.org/0009-0007-6629-4661)
  * Edward Burn   
Author  [](https://orcid.org/0000-0002-9286-1128)
  * Martí Català   
Author  [](https://orcid.org/0000-0003-3308-9905)



## Dev status

  * [![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
  * [![R-CMD-check](https://github.com/OHDSI/OmopSketch/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/OHDSI/OmopSketch/actions/workflows/R-CMD-check.yaml)
  * [![CRAN status](https://www.r-pkg.org/badges/version/OmopSketch)](https://CRAN.R-project.org/package=OmopSketch)
  * [![Codecov test coverage](https://codecov.io/gh/OHDSI/OmopSketch/branch/main/graph/badge.svg)](https://app.codecov.io/gh/OHDSI/OmopSketch?branch=main)



Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
