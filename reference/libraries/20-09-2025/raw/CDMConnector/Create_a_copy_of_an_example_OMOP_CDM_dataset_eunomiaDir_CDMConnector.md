# Create a copy of an example OMOP CDM dataset — eunomiaDir • CDMConnector

Skip to contents

[CDMConnector](../index.html) 2.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Getting Started](../articles/a01_getting-started.html)
    * [Working with cohorts](../articles/a02_cohorts.html)
    * [CDMConnector and dbplyr](../articles/a03_dbplyr.html)
    * [DBI connection examples](../articles/a04_DBI_connection_examples.html)
    * [Using CDM attributes](../articles/a06_using_cdm_attributes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CDMConnector/)



![](../logo.png)

# Create a copy of an example OMOP CDM dataset

Source: [`R/Eunomia.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/Eunomia.R)

`eunomiaDir.Rd`

Eunomia is an OHDSI project that provides several example OMOP CDM datasets for testing and development. This function creates a copy of a Eunomia database in [duckdb](https://duckdb.org/) and returns the path to the new database file. If the dataset does not yet exist on the user's computer it will attempt to download the source data to the the path defined by the EUNOMIA_DATA_FOLDER environment variable.

## Usage
    
    
    eunomiaDir(
      datasetName = "GiBleed",
      cdmVersion = "5.3",
      databaseFile = [tempfile](https://rdrr.io/r/base/tempfile.html)(fileext = ".duckdb")
    )

## Arguments

datasetName
    

One of "GiBleed" (default), "synthea-allergies-10k", "synthea-anemia-10k", "synthea-breast_cancer-10k", "synthea-contraceptives-10k", "synthea-covid19-10k", "synthea-covid19-200k", "synthea-dermatitis-10k", "synthea-heart-10k", "synthea-hiv-10k", "synthea-lung_cancer-10k", "synthea-medications-10k", "synthea-metabolic_syndrome-10k", "synthea-opioid_addiction-10k", "synthea-rheumatoid_arthritis-10k", "synthea-snf-10k", "synthea-surgery-10k", "synthea-total_joint_replacement-10k", "synthea-veteran_prostate_cancer-10k", "synthea-veterans-10k", "synthea-weight_loss-10k", "empty_cdm", "synpuf-1k"

cdmVersion
    

The OMOP CDM version. Must be "5.3" or "5.4".

databaseFile
    

The full path to the new copy of the example CDM dataset.

## Value

The file path to the new Eunomia dataset copy

## Details

Most of the Eunomia datasets available in CDMConnector are from the Synthea project. Synthea is an open-source synthetic patient generator that models the medical history of synthetic patients. The Synthea datasets are generated using the Synthea tool and then converted to the OMOP CDM format using the OHDSI ETL-Synthea project <https://ohdsi.github.io/ETL-Synthea/>. Currently the synthea datasets are only available in the OMOP CDM v5.3 format. See <https://synthetichealth.github.io/synthea/> for details on the Synthea project.

In addition to Synthea, the Eunomia project provides the CMS Synthetic Public Use Files (SynPUFs) in both 5.3 and 5.4 OMOP CDM formats. This data is synthetic US Medicare claims data mapped to OMOP CDM format. The OMOP CDM has a set of optional metadata tables, called Achilles tables, that include pre-computed analytics about the entire dataset such as record and person counts. The Eunomia Synpuf datasets include the Achilles tables.

Eunomia also provides empty cdms that can be used as a starting point for creating a new example CDM. This is useful for creating test data for studies or analytic packages. The empty CDM includes the vocabulary tables and all OMOP CDM tables but the clinical tables are empty and need to be populated with data. For additional information on creating small test CDM datasets see <https://ohdsi.github.io/omock/> and <https://darwin-eu.github.io/TestGenerator/>.

To contribute synthetic observational health data to the Eunomia project please open an issue at <https://github.com/OHDSI/Eunomia/issues/>

Setup: To use the `eunomiaDir` function please set the `EUNOMIA_DATA_FOLDER` in your .Renviron file to a folder on your computer where the datasets will be downloaded to. This file can be opened by calling `[usethis::edit_r_environ()](https://usethis.r-lib.org/reference/edit.html)`.

## Examples
    
    
    if (FALSE) { # \dontrun{
    
     # The defaults GiBleed dataset is a small dataset that is useful for testing
     [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
     con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), eunomiaDir())
     cdm <- [cdmFromCon](cdmFromCon.html)(con, "main", "main")
     [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    
     # Synpuf datasets include the Achilles tables
     con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), eunomiaDir("synpuf-1k", "5.3"))
     cdm <- [cdmFromCon](cdmFromCon.html)(con, "main", "main", achillesSchema = "main")
     [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    
     # Currently the only 5.4 dataset is synpuf-1k
     con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), eunomiaDir("synpuf-1k", "5.4"))
     cdm <- [cdmFromCon](cdmFromCon.html)(con, "main", "main", achillesSchema = "main")
     [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    
    } # }
    

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
