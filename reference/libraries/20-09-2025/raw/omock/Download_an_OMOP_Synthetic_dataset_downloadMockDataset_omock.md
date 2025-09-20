# Download an OMOP Synthetic dataset. — downloadMockDataset • omock

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

# Download an OMOP Synthetic dataset.

Source: [`R/mockDatasets.R`](https://github.com/ohdsi/omock/blob/main/R/mockDatasets.R)

`downloadMockDataset.Rd`

Download an OMOP Synthetic dataset.

## Usage
    
    
    downloadMockDataset(
      datasetName = "GiBleed",
      path = [mockDatasetsFolder](mockDatasetsFolder.html)(),
      overwrite = NULL
    )

## Arguments

datasetName
    

Name of the mock dataset. See `[availableMockDatasets()](availableMockDatasets.html)` for possibilities.

path
    

Path where to download the dataset.

overwrite
    

Whether to overwrite the dataset if it is already downloaded. If NULL the used is asked whether to overwrite.

## Value

The path to the downloaded dataset.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    [isMockDatasetDownloaded](isMockDatasetDownloaded.html)("GiBleed")
    #> [1] FALSE
    downloadMockDataset("GiBleed")
    [isMockDatasetDownloaded](isMockDatasetDownloaded.html)("GiBleed")
    #> [1] TRUE
    # }
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
