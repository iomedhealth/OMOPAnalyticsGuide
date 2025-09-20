# Store results in a table. — compute.cdm_table • omopgenerics

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



# Store results in a table.

Source: [`R/compute.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/compute.R)

`compute.cdm_table.Rd`

Store results in a table.

## Usage
    
    
    # S3 method for class 'cdm_table'
    [compute](https://dplyr.tidyverse.org/reference/compute.html)(
      x,
      name = NULL,
      temporary = NULL,
      overwrite = TRUE,
      logPrefix = NULL,
      ...
    )

## Arguments

x
    

Table in the cdm.

name
    

Name to store the table with.

temporary
    

Whether to store table temporarily (TRUE) or permanently (FALSE).

overwrite
    

Whether to overwrite previously existing table with name same.

logPrefix
    

Prefix to use when saving a log file.

...
    

For compatibility (not used).

## Value

Reference to a table in the cdm

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
