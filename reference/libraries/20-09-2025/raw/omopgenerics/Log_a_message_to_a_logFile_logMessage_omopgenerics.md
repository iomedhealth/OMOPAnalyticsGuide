# Log a message to a logFile — logMessage • omopgenerics

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



# Log a message to a logFile

Source: [`R/logger.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/logger.R)

`logMessage.Rd`

The message is written to the logFile and displayed in the console, if `logFile` does not exist the message is only displayed in the console.

## Usage
    
    
    logMessage(
      message = "Start logging file",
      logFile = [getOption](https://rdrr.io/r/base/options.html)("omopgenerics.logFile")
    )

## Arguments

message
    

Message to log.

logFile
    

File path to write logging messages. Create a logFile with `[createLogFile()](createLogFile.html)`.

## Value

Invisible TRUE if the logging message is written to a log file.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    logFile <- [tempfile](https://rdrr.io/r/base/tempfile.html)(pattern = "log_{date}_{time}", fileext = ".txt")
    [createLogFile](createLogFile.html)(logFile = logFile)
    #> ! Overwriting current log file
    #> ℹ Creating log file: /tmp/Rtmpmt8NbS/log_2025_09_19_11_04_101d9d758f4f55.txt.
    #> [2025-09-19 11:04:10] - Log file created
    
    logMessage("Starting analysis")
    #> [2025-09-19 11:04:10] - Starting analysis
    1 + 1
    #> [1] 2
    logMessage("Analysis finished")
    #> [2025-09-19 11:04:10] - Analysis finished
    
    res <- [summariseLogFile](summariseLogFile.html)()
    #> [2025-09-19 11:04:10] - Exporting log file
    
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
    #> $ estimate_value   <chr> "2025-09-19 11:04:10", "2025-09-19 11:04:10", "2025-0…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall"
    #> $ additional_level <chr> "overall", "overall", "overall", "overall"
    
    [tidy](https://generics.r-lib.org/reference/tidy.html)(res)
    #> # A tibble: 4 × 5
    #>   cdm_name log_id variable_name      variable_level date_time          
    #>   <chr>    <chr>  <chr>              <chr>          <chr>              
    #> 1 unknown  1      Log file created   NA             2025-09-19 11:04:10
    #> 2 unknown  2      Starting analysis  NA             2025-09-19 11:04:10
    #> 3 unknown  3      Analysis finished  NA             2025-09-19 11:04:10
    #> 4 unknown  4      Exporting log file NA             2025-09-19 11:04:10
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
