# Check or set the datasets Folder — mockDatasetsFolder • omock

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

# Check or set the datasets Folder

Source: [`R/mockDatasets.R`](https://github.com/ohdsi/omock/blob/main/R/mockDatasets.R)

`mockDatasetsFolder.Rd`

Check or set the datasets Folder

## Usage
    
    
    mockDatasetsFolder(path = NULL)

## Arguments

path
    

Path to a folder to store the synthetic datasets. If NULL the current OMOP_DATASETS_FOLDER is returned.

## Value

The dataset folder.

## Examples
    
    
    # \donttest{
    mockDatasetsFolder()
    #> [1] "/tmp/RtmpAwwQyg"
    mockDatasetsFolder([file.path](https://rdrr.io/r/base/file.path.html)([tempdir](https://rdrr.io/r/base/tempfile.html)(), "OMOP_DATASETS"))
    #> ℹ Creating /tmp/RtmpAwwQyg/OMOP_DATASETS.
    mockDatasetsFolder()
    #> [1] "/tmp/RtmpAwwQyg/OMOP_DATASETS"
    # }
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
