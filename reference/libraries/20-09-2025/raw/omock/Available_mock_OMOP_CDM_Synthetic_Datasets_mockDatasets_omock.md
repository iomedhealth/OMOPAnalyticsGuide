# Available mock OMOP CDM Synthetic Datasets — mockDatasets • omock

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

# Available mock OMOP CDM Synthetic Datasets

Source: [`R/mockDatasets.R`](https://github.com/ohdsi/omock/blob/main/R/mockDatasets.R)

`mockDatasets.Rd`

These are the mock OMOP CDM Synthetic Datasets that are available to download using the `omock` package.

## Usage
    
    
    mockDatasets

## Format

A data frame with 4 variables:

dataset_name
    

Name of the dataset.

url
    

url to download the dataset.

cdm_name
    

Name of the cdm reference created.

cdm_version
    

OMOP CDM version of the dataset.

size
    

Size in bytes of the dataset.

size_mb
    

Size in Mega bytes of the dataset.

## Examples
    
    
    mockDatasets
    #> # A tibble: 24 × 6
    #>    dataset_name               url            cdm_name cdm_version   size size_mb
    #>    <chr>                      <chr>          <chr>    <chr>        <dbl>   <dbl>
    #>  1 GiBleed                    https://examp… GiBleed  5.3         6.75e6       6
    #>  2 empty_cdm                  https://examp… empty_c… 5.3         8.21e8     783
    #>  3 synpuf-1k_5.3              https://examp… synpuf-… 5.3         5.93e8     566
    #>  4 synpuf-1k_5.4              https://examp… synpuf-… 5.4         3.97e8     379
    #>  5 synthea-allergies-10k      https://examp… synthea… 5.3         8.40e8     801
    #>  6 synthea-anemia-10k         https://examp… synthea… 5.3         8.40e8     801
    #>  7 synthea-breast_cancer-10k  https://examp… synthea… 5.3         8.41e8     802
    #>  8 synthea-contraceptives-10k https://examp… synthea… 5.3         8.42e8     803
    #>  9 synthea-covid19-10k        https://examp… synthea… 5.3         8.41e8     802
    #> 10 synthea-covid19-200k       https://examp… synthea… 5.3         1.18e9    1124
    #> # ℹ 14 more rows
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
