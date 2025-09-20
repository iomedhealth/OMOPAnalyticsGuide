# Check if a certain dataset is downloaded. — isMockDatasetDownloaded • omock

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

# Check if a certain dataset is downloaded.

Source: [`R/mockDatasets.R`](https://github.com/ohdsi/omock/blob/main/R/mockDatasets.R)

`isMockDatasetDownloaded.Rd`

Check if a certain dataset is downloaded.

## Usage
    
    
    isMockDatasetDownloaded(datasetName = "GiBleed", path = [mockDatasetsFolder](mockDatasetsFolder.html)())

## Arguments

datasetName
    

Name of the mock dataset. See `[availableMockDatasets()](availableMockDatasets.html)` for possibilities.

path
    

Path where to search for the dataset.

## Value

Whether the dataset is available or not.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    isMockDatasetDownloaded("GiBleed")
    #> [1] TRUE
    [downloadMockDataset](downloadMockDataset.html)("GiBleed")
    #> ℹ Deleting prior version of GiBleed.
    isMockDatasetDownloaded("GiBleed")
    #> [1] TRUE
    # }
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
