# Export a summarised_result object to a csv file. — exportSummarisedResult • omopgenerics

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Export a summarised_result object to a csv file.

Source: [`R/exportSummarisedResult.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/exportSummarisedResult.R)

`exportSummarisedResult.Rd`

Export a summarised_result object to a csv file.

## Usage
    
    
    exportSummarisedResult(
      ...,
      minCellCount = 5,
      fileName = "results_{cdm_name}_{date}.csv",
      path = [getwd](https://rdrr.io/r/base/getwd.html)(),
      logFile = [getOption](https://rdrr.io/r/base/options.html)("omopgenerics.logFile")
    )

## Arguments

...
    

A set of summarised_result objects.

minCellCount
    

Minimum count for suppression purposes.

fileName
    

Name of the file that will be created. Use {cdm_name} to refer to the cdmName of the objects and {date} to add the export date.

path
    

Path where to create the csv file. It is ignored if fileName it is a full name with path included.

logFile
    

Path to the log file to export.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
