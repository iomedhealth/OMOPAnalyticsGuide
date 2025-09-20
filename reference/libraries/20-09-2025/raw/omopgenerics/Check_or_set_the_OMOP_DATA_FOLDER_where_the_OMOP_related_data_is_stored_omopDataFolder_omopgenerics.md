# Check or set the OMOP_DATA_FOLDER where the OMOP related data is stored. — omopDataFolder • omopgenerics

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



# Check or set the OMOP_DATA_FOLDER where the OMOP related data is stored.

Source: [`R/omopDataFolder.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/omopDataFolder.R)

`omopDataFolder.Rd`

Check or set the OMOP_DATA_FOLDER where the OMOP related data is stored.

## Usage
    
    
    omopDataFolder(path = NULL)

## Arguments

path
    

Path to a folder to store the OMOP related data. If NULL the current `OMOP_DATA_FOLDER` is returned.

## Value

The OMOP data folder.

## Examples
    
    
    # \donttest{
    omopDataFolder()
    #> [1] "/tmp/Rtmpmt8NbS/OMOP_DATA_FOLDER"
    omopDataFolder([file.path](https://rdrr.io/r/base/file.path.html)([tempdir](https://rdrr.io/r/base/tempfile.html)(), "OMOP_DATA"))
    #> ℹ Creating /tmp/Rtmpmt8NbS/OMOP_DATA.
    omopDataFolder()
    #> [1] "/tmp/Rtmpmt8NbS/OMOP_DATA"
    # }
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
