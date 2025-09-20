# Download Eunomia data files — downloadEunomiaData • CDMConnector

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

# Download Eunomia data files

Source: [`R/Eunomia.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/Eunomia.R)

`downloadEunomiaData.Rd`

Download the Eunomia data files from https://github.com/darwin-eu/EunomiaDatasets

## Usage
    
    
    downloadEunomiaData(
      datasetName = "GiBleed",
      cdmVersion = "5.3",
      pathToData = [Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("EUNOMIA_DATA_FOLDER"),
      overwrite = FALSE
    )

## Arguments

datasetName
    

The data set name as found on https://github.com/darwin-eu/EunomiaDatasets. The data set name corresponds to the folder with the data set ZIP files

cdmVersion
    

The OMOP CDM version. This version will appear in the suffix of the data file, for example: synpuf_5.3.zip. Must be '5.3' (default) or '5.4'.

pathToData
    

The path where the Eunomia data is stored on the file system., By default the value of the environment variable "EUNOMIA_DATA_FOLDER" is used.

overwrite
    

Control whether the existing archive file will be overwritten should it already exist.

## Value

Invisibly returns the destination if the download was successful.

## Examples
    
    
    if (FALSE) { # \dontrun{
    downloadEunomiaData("GiBleed")
    } # }
    

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
