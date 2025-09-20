# Create a local cdm_reference from a dataset. — mockCdmFromDataset • omock

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Create a `local` cdm_reference from a dataset.

Source: [`R/mockDatasets.R`](https://github.com/ohdsi/omock/blob/main/R/mockDatasets.R)

`mockCdmFromDataset.Rd`

Create a `local` cdm_reference from a dataset.

## Usage
    
    
    mockCdmFromDataset(datasetName = "GiBleed", source = "local")

## Arguments

datasetName
    

Name of the mock dataset. See `[availableMockDatasets()](availableMockDatasets.html)` for possibilities.

source
    

Choice between `local` or `duckdb`.

## Value

A local cdm_reference object.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    [mockDatasetsFolder](mockDatasetsFolder.html)([tempdir](https://rdrr.io/r/base/tempfile.html)())
    [downloadMockDataset](downloadMockDataset.html)(datasetName = "GiBleed")
    cdm <- mockCdmFromDataset(datasetName = "GiBleed")
    #> ℹ Reading GiBleed tables.
    #> ℹ Adding drug_strength table.
    #> ℹ Creating local <cdm_reference> object.
    cdm
    #> 
    #> ── # OMOP CDM reference (local) of GiBleed ─────────────────────────────────────
    #> • omop tables: care_site, cdm_source, concept, concept_ancestor, concept_class,
    #> concept_relationship, concept_synonym, condition_era, condition_occurrence,
    #> cost, death, device_exposure, domain, dose_era, drug_era, drug_exposure,
    #> drug_strength, fact_relationship, location, measurement, metadata, note,
    #> note_nlp, observation, observation_period, payer_plan_period, person,
    #> procedure_occurrence, provider, relationship, source_to_concept_map, specimen,
    #> visit_detail, visit_occurrence, vocabulary
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
