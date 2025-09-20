# Package index • omock

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

# Package index

## Mock CDM Initialization

This group includes functions that initialize the foundational structures required for the mock CDM environment.

`[mockCdmReference()](mockCdmReference.html)`
    Creates an empty CDM (Common Data Model) reference for a mock database.

`[mockCdmFromTables()](mockCdmFromTables.html)`
    Generates a mock CDM (Common Data Model) object based on existing CDM structures and additional tables.

`[mockCdmFromDataset()](mockCdmFromDataset.html)`
    Create a `local` cdm_reference from a dataset.

## Mock Datasets

This group of functions are utility functions to work with the mock datasets.

`[mockDatasets](mockDatasets.html)`
    Available mock OMOP CDM Synthetic Datasets

`[downloadMockDataset()](downloadMockDataset.html)`
    Download an OMOP Synthetic dataset.

`[availableMockDatasets()](availableMockDatasets.html)`
    List the available datasets

`[isMockDatasetDownloaded()](isMockDatasetDownloaded.html)`
    Check if a certain dataset is downloaded.

`[mockDatasetsStatus()](mockDatasetsStatus.html)`
    Check the availability of the OMOP CDM datasets.

`[mockDatasetsFolder()](mockDatasetsFolder.html)`
    Check or set the datasets Folder

## Mock Table Creation

These functions are focused on adding mock data tables based on the initialized CDM structure.

`[mockPerson()](mockPerson.html)`
    Generates a mock person table and integrates it into an existing CDM object.

`[mockObservationPeriod()](mockObservationPeriod.html)`
    Generates a mock observation period table and integrates it into an existing CDM object.

`[mockConditionOccurrence()](mockConditionOccurrence.html)`
    Generates a mock condition occurrence table and integrates it into an existing CDM object.

`[mockDrugExposure()](mockDrugExposure.html)`
    Generates a mock drug exposure table and integrates it into an existing CDM object.

`[mockMeasurement()](mockMeasurement.html)`
    Generates a mock measurement table and integrates it into an existing CDM object.

`[mockObservation()](mockObservation.html)`
    Generates a mock observation table and integrates it into an existing CDM object.

`[mockProcedureOccurrence()](mockProcedureOccurrence.html)`
    Generates a mock procedure occurrence table and integrates it into an existing CDM object.

`[mockDeath()](mockDeath.html)`
    Generates a mock death table and integrates it into an existing CDM object.

`[mockVisitOccurrence()](mockVisitOccurrence.html)`
    Function to generate visit occurrence table

## Vocabulary Tables Creation

This group includes functions that set up vocabulary tables.

`[mockVocabularyTables()](mockVocabularyTables.html)`
    Creates a mock CDM database populated with various vocabulary tables.

`[mockConcepts()](mockConcepts.html)`
    Adds mock concept data to a concept table within a Common Data Model (CDM) object.

`[mockVocabularySet()](mockVocabularySet.html)`
    Creates an empty mock CDM database populated with various vocabulary tables set.

## Cohort Tables Creation

These functions are focused on adding mock cohort tables based on the initialized CDM structure.

`[mockCohort()](mockCohort.html)`
    Generate Synthetic Cohort

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
