# Import a set of summarised results. — importSummarisedResult • omopgenerics

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



# Import a set of summarised results.

Source: [`R/importSummarisedResult.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/importSummarisedResult.R)

`importSummarisedResult.Rd`

Import a set of summarised results.

## Usage
    
    
    importSummarisedResult(path, recursive = FALSE, ...)

## Arguments

path
    

Path to directory with CSV files containing summarised results or to a specific CSV file with a summarised result.

recursive
    

If TRUE and path is a directory, search for files will recurse into directories

...
    

Passed to `[readr::read_csv](https://readr.tidyverse.org/reference/read_delim.html)`.

## Value

A summarised result

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
