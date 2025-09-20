# Logging with omopgenerics • omopgenerics

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



# Logging with omopgenerics

Source: [`vignettes/logging.Rmd`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/vignettes/logging.Rmd)

`logging.Rmd`

## Logging

Logging is a common practice in studies, specially when sharing code. Logging can be useful to check timings or record error messages. There exist multiple packages in R that allow you to record these log messages. For example the `logger` package is quite useful.

### Logging with omopgenerics

`omopgenerics` does not want to replace any of these packages, we just provide simple functionality to log messages. In the future we might consider building this on top of one of the existing log packages, but for the moment we have these three simple functions:

  * `[createLogFile()](../reference/createLogFile.html)` It is used to create the log file.
  * `[logMessage()](../reference/logMessage.html)` It is used to record the messages that we want in the log file, note those messages will also be displayed in the console. If `logFile` does not exist the message is only displayed in the console.
  * `[summariseLogFile()](../reference/summariseLogFile.html)` It is used to read the log file and format it into a `summarised_result` object.



### Example

Let’s see a simple example of logging with omopgenerics:
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/), warn.conflicts = FALSE)
    
    # create the log file
    [createLogFile](../reference/createLogFile.html)(logFile = [tempfile](https://rdrr.io/r/base/tempfile.html)(pattern = "log_{date}_{time}"))
    #> ℹ Creating log file: /tmp/RtmpXsLQf9/log_2025_09_19_11_04_4327ae49b1949c.txt.
    #> [2025-09-19 11:04:43] - Log file created
    
    # study
    [logMessage](../reference/logMessage.html)("Generating random numbers")
    #> [2025-09-19 11:04:43] - Generating random numbers
    x <- [runif](https://rdrr.io/r/stats/Uniform.html)(1e6)
    
    [logMessage](../reference/logMessage.html)("Calculating the sum")
    #> [2025-09-19 11:04:43] - Calculating the sum
    result <- [sum](https://rdrr.io/r/base/sum.html)(x)
    
    # export logger to a `summarised_result`
    log <- [summariseLogFile](../reference/summariseLogFile.html)()
    #> [2025-09-19 11:04:43] - Exporting log file
    
    # content of the log file
    [readLines](https://rdrr.io/r/base/readLines.html)([getOption](https://rdrr.io/r/base/options.html)("omopgenerics.logFile")) |>
      [cat](https://rdrr.io/r/base/cat.html)(sep = "\n")
    #> [2025-09-19 11:04:43] - Log file created
    #> [2025-09-19 11:04:43] - Generating random numbers
    #> [2025-09-19 11:04:43] - Calculating the sum
    #> [2025-09-19 11:04:43] - Exporting log file
    
    # `summarised_result` object
    log
    #> # A tibble: 4 × 13
    #>   result_id cdm_name group_name group_level strata_name strata_level
    #>       <int> <chr>    <chr>      <chr>       <chr>       <chr>       
    #> 1         1 unknown  overall    overall     log_id      1           
    #> 2         1 unknown  overall    overall     log_id      2           
    #> 3         1 unknown  overall    overall     log_id      3           
    #> 4         1 unknown  overall    overall     log_id      4           
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    # `summarised_result` object settings
    [settings](../reference/settings.html)(log)
    #> # A tibble: 1 × 8
    #>   result_id result_type     package_name package_version group strata additional
    #>       <int> <chr>           <chr>        <chr>           <chr> <chr>  <chr>     
    #> 1         1 summarise_log_… omopgenerics 1.3.1           ""    log_id ""        
    #> # ℹ 1 more variable: min_cell_count <chr>
    
    # tidy version of the `summarised_result`
    [tidy](https://generics.r-lib.org/reference/tidy.html)(log)
    #> # A tibble: 4 × 5
    #>   cdm_name log_id variable_name             variable_level date_time          
    #>   <chr>    <chr>  <chr>                     <chr>          <chr>              
    #> 1 unknown  1      Log file created          NA             2025-09-19 11:04:43
    #> 2 unknown  2      Generating random numbers NA             2025-09-19 11:04:43
    #> 3 unknown  3      Calculating the sum       NA             2025-09-19 11:04:43
    #> 4 unknown  4      Exporting log file        NA             2025-09-19 11:04:43

Note that if the logFile is not created the `[logMessage()](../reference/logMessage.html)` function only displays the message in the console.

###  `exportSummarisedResult`

The `[exportSummarisedResult()](../reference/exportSummarisedResult.html)` exports by default the logger if there is one. See example code:
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([tidyr](https://tidyr.tidyverse.org), warn.conflicts = FALSE)
    
    # create the log file
    [createLogFile](../reference/createLogFile.html)(logFile = [tempfile](https://rdrr.io/r/base/tempfile.html)(pattern = "log_{date}_{time}"))
    #> ℹ Creating log file: /tmp/RtmpXsLQf9/log_2025_09_19_11_04_4427ae3d57aa1a.txt.
    #> [2025-09-19 11:04:44] - Log file created
    
    # start analysis
    [logMessage](../reference/logMessage.html)("Deffining toy data")
    #> [2025-09-19 11:04:44] - Deffining toy data
    n <- 1e5
    x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(person_id = [seq_len](https://rdrr.io/r/base/seq.html)(n), age = [rnorm](https://rdrr.io/r/stats/Normal.html)(n = n, mean = 55, sd = 20))
    
    [logMessage](../reference/logMessage.html)("Summarise toy data")
    #> [2025-09-19 11:04:44] - Summarise toy data
    res <- x |>
      [summarise](https://dplyr.tidyverse.org/reference/summarise.html)(
        `number subjects_count` = [n](https://dplyr.tidyverse.org/reference/context.html)(),
        `age_mean` = [mean](https://rdrr.io/r/base/mean.html)(age),
        `age_sd` = [sd](https://rdrr.io/r/stats/sd.html)(age),
        `age_median` = [median](https://rdrr.io/r/stats/median.html)(age),
        `age_q25` = [quantile](https://rdrr.io/r/stats/quantile.html)(age, 0.25),
        `age_q75` = [quantile](https://rdrr.io/r/stats/quantile.html)(age, 0.75)
      ) |>
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(
        cols = [everything](https://tidyselect.r-lib.org/reference/everything.html)(), 
        names_to = [c](https://rdrr.io/r/base/c.html)("variable_name", "estimate_name"), 
        names_sep = "_",
        values_to = "estimate_value"
      ) |>
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(
        result_id = 1L,
        cdm_name = "mock data",
        variable_level = NA_character_,
        estimate_type = [if_else](https://dplyr.tidyverse.org/reference/if_else.html)(estimate_name == "count", "integer", "numeric"),
        estimate_value = [as.character](https://rdrr.io/r/base/character.html)(estimate_value)
      ) |>
      [uniteGroup](../reference/uniteGroup.html)() |>
      [uniteStrata](../reference/uniteStrata.html)() |>
      [uniteAdditional](../reference/uniteAdditional.html)() |>
      [newSummarisedResult](../reference/newSummarisedResult.html)()
    #> `result_type`, `package_name`, and `package_version` added to
    #> settings.
    
    # res is a summarised_result object that we can export using the `exportSummarisedResult`
    tempDir <- [tempdir](https://rdrr.io/r/base/tempfile.html)()
    [exportSummarisedResult](../reference/exportSummarisedResult.html)(res, path = tempDir)
    #> [2025-09-19 11:04:44] - Exporting log file

`[exportSummarisedResult()](../reference/exportSummarisedResult.html)` also exported the log file, let’s see it. Let’s start importing the exported `summarised_result` object:
    
    
    result <- [importSummarisedResult](../reference/importSummarisedResult.html)(tempDir)
    #> Reading file: /tmp/RtmpXsLQf9/results_mock data_2025_09_19.csv.
    #> Converting to summarised_result:
    #> /tmp/RtmpXsLQf9/results_mock data_2025_09_19.csv.

We can see that the log file is exported see `result_type = "summarise_log_file"`:
    
    
    result |>
      [settings](../reference/settings.html)() |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 2
    #> Columns: 8
    #> $ result_id       <int> 1, 2
    #> $ result_type     <chr> "", "summarise_log_file"
    #> $ package_name    <chr> "", "omopgenerics"
    #> $ package_version <chr> "", "1.3.1"
    #> $ group           <chr> "", ""
    #> $ strata          <chr> "", "log_id"
    #> $ additional      <chr> "", ""
    #> $ min_cell_count  <chr> "5", "5"

The easiest way to explore the log is using the `[tidy()](https://generics.r-lib.org/reference/tidy.html)` version:
    
    
    result |>
      [filterSettings](../reference/filterSettings.html)(result_type == "summarise_log_file") |>
      [tidy](https://generics.r-lib.org/reference/tidy.html)()
    #> # A tibble: 4 × 5
    #>   cdm_name  log_id variable_name      variable_level date_time          
    #>   <chr>     <chr>  <chr>              <chr>          <chr>              
    #> 1 mock data 1      Log file created   NA             2025-09-19 11:04:44
    #> 2 mock data 2      Deffining toy data NA             2025-09-19 11:04:44
    #> 3 mock data 3      Summarise toy data NA             2025-09-19 11:04:44
    #> 4 mock data 4      Exporting log file NA             2025-09-19 11:04:44

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
