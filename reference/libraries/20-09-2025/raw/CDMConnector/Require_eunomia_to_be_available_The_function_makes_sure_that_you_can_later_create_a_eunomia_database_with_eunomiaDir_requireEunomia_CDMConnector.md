# Require eunomia to be available. The function makes sure that you can later create a eunomia database with eunomiaDir(). — requireEunomia • CDMConnector

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

# Require eunomia to be available. The function makes sure that you can later create a eunomia database with `eunomiaDir()`.

Source: [`R/Eunomia.R`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/R/Eunomia.R)

`requireEunomia.Rd`

Require eunomia to be available. The function makes sure that you can later create a eunomia database with `[eunomiaDir()](eunomiaDir.html)`.

## Usage
    
    
    requireEunomia(datasetName = "GiBleed", cdmVersion = "5.3")

## Arguments

datasetName
    

Name of the Eunomia dataset to check. Defaults to "GiBleed".

cdmVersion
    

Version of the Eunomia dataset to check. Must be "5.3" or "5.4".

## Value

Path to eunomia database.

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
