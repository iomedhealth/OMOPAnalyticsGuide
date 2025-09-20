# Summarise and extract the information of a log file into a summarised_result object. — summariseLogFile • omopgenerics

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



# Summarise and extract the information of a log file into a `summarised_result` object.

Source: [`R/logger.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/logger.R)

`summariseLogFile.Rd`

Summarise and extract the information of a log file into a `summarised_result` object.

## Usage
    
    
    summariseLogFile(
      logFile = [getOption](https://rdrr.io/r/base/options.html)("omopgenerics.logFile"),
      cdmName = "unknown"
    )

## Arguments

logFile
    

File path to the log file to summarise. Create a logFile with `[createLogFile()](createLogFile.html)`.

cdmName
    

Name of the cdm for the `summarise_result` object.

## Value

A `summarise_result` with the information of the log file.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    logFile <- [tempfile](https://rdrr.io/r/base/tempfile.html)(pattern = "log_{date}_{time}", fileext = ".txt")
    [createLogFile](createLogFile.html)(logFile = logFile)
    #> ! Overwriting current log file
    #> ℹ Creating log file: /tmp/Rtmpmt8NbS/log_2025_09_19_11_04_211d9d65d639cc.txt.
    #> [2025-09-19 11:04:21] - Log file created
    
    [logMessage](logMessage.html)("Starting analysis")
    #> [2025-09-19 11:04:21] - Starting analysis
    1 + 1
    #> [1] 2
    [logMessage](logMessage.html)("Analysis finished")
    #> [2025-09-19 11:04:21] - Analysis finished
    
    res <- summariseLogFile()
    #> [2025-09-19 11:04:21] - Exporting log file
    
    [glimpse](https://pillar.r-lib.org/reference/glimpse.html)(res)
    #> Rows: 4
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1
    #> $ cdm_name         <chr> "unknown", "unknown", "unknown", "unknown"
    #> $ group_name       <chr> "overall", "overall", "overall", "overall"
    #> $ group_level      <chr> "overall", "overall", "overall", "overall"
    #> $ strata_name      <chr> "log_id", "log_id", "log_id", "log_id"
    #> $ strata_level     <chr> "1", "2", "3", "4"
    #> $ variable_name    <chr> "Log file created", "Starting analysis", "Analysis fi…
    #> $ variable_level   <chr> NA, NA, NA, NA
    #> $ estimate_name    <chr> "date_time", "date_time", "date_time", "date_time"
    #> $ estimate_type    <chr> "character", "character", "character", "character"
    #> $ estimate_value   <chr> "2025-09-19 11:04:21", "2025-09-19 11:04:21", "2025-0…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall"
    #> $ additional_level <chr> "overall", "overall", "overall", "overall"
    
    [tidy](https://generics.r-lib.org/reference/tidy.html)(res)
    #> # A tibble: 4 × 5
    #>   cdm_name log_id variable_name      variable_level date_time          
    #>   <chr>    <chr>  <chr>              <chr>          <chr>              
    #> 1 unknown  1      Log file created   NA             2025-09-19 11:04:21
    #> 2 unknown  2      Starting analysis  NA             2025-09-19 11:04:21
    #> 3 unknown  3      Analysis finished  NA             2025-09-19 11:04:21
    #> 4 unknown  4      Exporting log file NA             2025-09-19 11:04:21
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
