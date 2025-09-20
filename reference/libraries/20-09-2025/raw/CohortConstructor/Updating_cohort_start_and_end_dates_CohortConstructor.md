# Updating cohort start and end dates • CohortConstructor

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Updating cohort start and end dates

Source: [`vignettes/a05_update_cohort_start_end.Rmd`](https://github.com/OHDSI/CohortConstructor/blob/main/vignettes/a05_update_cohort_start_end.Rmd)

`a05_update_cohort_start_end.Rmd`

## Introduction

Accurately defining cohort entry and exit dates is crucial in observational research to ensure the validity of study findings. The `CohortConstructor` package provides several functions to adjust these dates based on specific criteria, and this vignette demonstrates how to use them.

Functions to update cohort dates can be categorized into four groups:

  * **Exit at Specific Date Functions:** Adjust the cohort end date to predefined events (observation end and death date).

  * **Cohort Entry or Exit Based on Other Date Columns:** Modify cohort start or end dates to the earliest or latests from a set of date columns.

  * **Trim Dates Functions:** Restrict cohort entries based on demographic criteria or specific date ranges.

  * **Pad Dates Functions:** Adjust cohort start or end dates by adding or subtracting a specified number of days.




We’ll explore each category in the following sections.

First, we’ll connect to the Eunomia synthetic data and create a mock cohort of women in the database to use as example in the vignette.
    
    
    [library](https://rdrr.io/r/base/library.html)([DBI](https://dbi.r-dbi.org))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    
    if ([Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("EUNOMIA_DATA_FOLDER") == ""){
    [Sys.setenv](https://rdrr.io/r/base/Sys.setenv.html)("EUNOMIA_DATA_FOLDER" = [file.path](https://rdrr.io/r/base/file.path.html)([tempdir](https://rdrr.io/r/base/tempfile.html)(), "eunomia"))}
    if (![dir.exists](https://rdrr.io/r/base/files2.html)([Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("EUNOMIA_DATA_FOLDER"))){ [dir.create](https://rdrr.io/r/base/files2.html)([Sys.getenv](https://rdrr.io/r/base/Sys.getenv.html)("EUNOMIA_DATA_FOLDER"))
    [downloadEunomiaData](https://darwin-eu.github.io/CDMConnector/reference/downloadEunomiaData.html)()  
    }
    #> 
    #> Download completed!
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    #> Creating CDM database /tmp/RtmpVPsbLM/eunomia/GiBleed_5.3.zip
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchema = "main", 
                        writeSchema = "main", writePrefix = "my_study_")
    
    cdm$cohort <- [demographicsCohort](../reference/demographicsCohort.html)(cdm = cdm, name = "cohort", sex = "Female")
    #> ℹ Building new trimmed cohort
    #> Adding demographics information
    #> Creating initial cohort
    #> Trim sex
    #> ✔ Cohort trimmed

## Exit at Specific Date

###  `exitAtObservationEnd()`

The `[exitAtObservationEnd()](../reference/exitAtObservationEnd.html)` function updates the cohort end date to the end of the observation period for each subject. This ensures that the cohort exit does not extend beyond the period during which data is available for the subject.
    
    
    cdm$cohort_observation_end <- cdm$cohort |> 
      [exitAtObservationEnd](../reference/exitAtObservationEnd.html)(name = "cohort_observation_end")

As cohort entries cannot overlap, updating the end date to the observation end may result in overlapping records. In such cases, overlapping records are collapsed into a single entry (starting at the earliest entry and ending at the end of observation).

This function has an argument `persistAcrossObservationPeriods` to consider cases when a subject may have more than one observation period. If `persistAcrossObservationPeriods = FALSE` then cohort end date will be set to the end of the observation period where the record occurs. If `persistAcrossObservationPeriods = TRUE`, in addition to updating the cohort end to the current observation end, cohort entries are created for each of the subsequent observation periods.

###  `exitAtDeath()`

The `[exitAtDeath()](../reference/exitAtDeath.html)` function sets the cohort end date to the recorded death date of the subject.

By default, it keeps the end date of subjects who do not have a death record unmodified; however, these can be dropped with the argument `requireDeath.`
    
    
    cdm$cohort_death <- cdm$cohort |> 
      [exitAtDeath](../reference/exitAtDeath.html)(requireDeath = TRUE, name = "cohort_death")

## Cohort Entry or Exit Based on Other Date Columns

###  `entryAtFirstDate()`

The `[entryAtFirstDate()](../reference/entryAtFirstDate.html)` function updates the cohort start date to the earliest date among specified columns.

Next we want to set the entry date to the first of: diclofenac or acetaminophen prescriptions after cohort start, or cohort end date.
    
    
    # create cohort with of drugs diclofenac and acetaminophen 
    cdm$medications <- [conceptCohort](../reference/conceptCohort.html)(
      cdm = cdm, name = "medications",
      conceptSet = [list](https://rdrr.io/r/base/list.html)("diclofenac" = 1124300, "acetaminophen" = 1127433)
    )
    #> Warning: ! `codelist` casted to integers.
    #> ℹ Subsetting table drug_exposure using 2 concepts with domain: drug.
    #> ℹ Combining tables.
    #> ℹ Creating cohort attributes.
    #> ℹ Applying cohort requirements.
    #> ℹ Merging overlapping records.
    #> ✔ Cohort medications created.
    
    # add date first ocurrence of these drugs from index date
    cdm$cohort_dates <- cdm$cohort |> 
      [addCohortIntersectDate](https://darwin-eu.github.io/PatientProfiles/reference/addCohortIntersectDate.html)(
        targetCohortTable = "medications", 
        nameStyle = "{cohort_name}",
        name = "cohort_dates"
        ) 
    
    # set cohort start at the first ocurrence of one of the drugs, or the end date
    cdm$cohort_entry_first <- cdm$cohort_dates |>
      [entryAtFirstDate](../reference/entryAtFirstDate.html)(
        dateColumns = [c](https://rdrr.io/r/base/c.html)("diclofenac", "acetaminophen", "cohort_end_date"), 
        name = "cohort_entry_first"
      )
    #> Joining with `by = join_by(cohort_definition_id, subject_id, cohort_end_date)`
    cdm$cohort_entry_first 
    #> # Source:   table<my_study_cohort_entry_first> [?? x 6]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/RtmpVPsbLM/file2915669b5bb2.duckdb]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date diclofenac
    #>                   <int>      <int> <date>            <date>          <date>    
    #>  1                    1        877 1992-05-28        2019-05-14      NA        
    #>  2                    1       1511 1966-01-22        2019-05-19      2010-01-29
    #>  3                    1       3386 2007-09-08        2019-02-04      2007-09-08
    #>  4                    1       3676 1975-10-19        2018-12-06      NA        
    #>  5                    1       1397 1989-02-15        2019-02-15      2016-08-26
    #>  6                    1       4777 1971-04-05        2018-07-10      NA        
    #>  7                    1       5031 1928-02-17        2019-05-25      NA        
    #>  8                    1       4807 1957-10-24        2019-05-23      NA        
    #>  9                    1       1829 1985-04-02        2018-08-28      2002-08-09
    #> 10                    1       3083 1951-05-30        2018-08-05      NA        
    #> # ℹ more rows
    #> # ℹ 1 more variable: acetaminophen <date>

###  `entryAtLastDate()`

The `[entryAtLastDate()](../reference/entryAtLastDate.html)` function works similarly to `[entryAtFirstDate()](../reference/entryAtFirstDate.html)`, however now the selected column is the latest date among specified columns.
    
    
    cdm$cohort_entry_last <- cdm$cohort_dates |>
      [entryAtLastDate](../reference/entryAtLastDate.html)(
        dateColumns = [c](https://rdrr.io/r/base/c.html)("diclofenac", "acetaminophen", "cohort_end_date"), 
        keepDateColumns = FALSE,
        name = "cohort_entry_last"
      )
    
    cdm$cohort_entry_last
    #> # Source:   table<my_study_cohort_entry_last> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/RtmpVPsbLM/file2915669b5bb2.duckdb]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1         16 2017-11-02        2017-11-02     
    #>  2                    1         38 2019-01-30        2019-01-30     
    #>  3                    1        153 2018-11-01        2018-11-01     
    #>  4                    1        715 2018-02-20        2018-02-20     
    #>  5                    1        857 2016-05-30        2016-05-30     
    #>  6                    1       1102 2019-02-05        2019-02-05     
    #>  7                    1       1132 2018-07-30        2018-07-30     
    #>  8                    1       1352 2019-02-03        2019-02-03     
    #>  9                    1       1524 2019-05-02        2019-05-02     
    #> 10                    1       1770 2017-12-31        2017-12-31     
    #> # ℹ more rows

In this example, we set `keepDateColumns` to FALSE, which drops columns in `dateColumns`.

###  `exitAtFirstDate()`

The `[exitAtFirstDate()](../reference/exitAtFirstDate.html)` function updates the cohort end date to the earliest date among specified columns.

For instance, next we want the exit to be observation end, except if there is a record of diclofenac or acetaminophen, in which case that would be the end:
    
    
    cdm$cohort_exit_first <- cdm$cohort_dates |>
      [addFutureObservation](https://darwin-eu.github.io/PatientProfiles/reference/addFutureObservation.html)(futureObservationType = "date", name = "cohort_exit_first") |>
      [exitAtFirstDate](../reference/exitAtFirstDate.html)(
        dateColumns = [c](https://rdrr.io/r/base/c.html)("future_observation", "acetaminophen", "diclofenac"),
        keepDateColumns = FALSE
      )
    
    cdm$cohort_exit_first 
    #> # Source:   table<my_study_cohort_exit_first> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/RtmpVPsbLM/file2915669b5bb2.duckdb]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1         12 1963-01-30        1974-08-01     
    #>  2                    1        404 1960-06-14        1965-03-22     
    #>  3                    1        431 1948-01-02        1964-11-03     
    #>  4                    1        905 1968-09-21        1973-01-30     
    #>  5                    1        987 1953-08-30        1954-01-28     
    #>  6                    1       1098 1955-12-10        1956-11-05     
    #>  7                    1       1113 1971-11-16        2013-07-23     
    #>  8                    1       1253 1955-03-10        1970-12-16     
    #>  9                    1       1508 1924-01-01        1967-05-20     
    #> 10                    1       1850 1956-12-14        1976-09-26     
    #> # ℹ more rows

###  `exitAtLastDate()`

Similarly, the `[exitAtLastDate()](../reference/exitAtLastDate.html)` function sets the cohort end date to the latest date among specified columns.
    
    
    cdm$cohort_exit_last <- cdm$cohort_dates |> 
      [exitAtLastDate](../reference/exitAtLastDate.html)(
        dateColumns = [c](https://rdrr.io/r/base/c.html)("cohort_end_date", "acetaminophen", "diclofenac"),
        returnReason = FALSE,
        keepDateColumns = FALSE,
        name = "cohort_exit_last"
      )
    cdm$cohort_exit_last
    #> # Source:   table<my_study_cohort_exit_last> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/RtmpVPsbLM/file2915669b5bb2.duckdb]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1         19 1949-01-30        2018-08-19     
    #>  2                    1         36 1958-10-21        2019-01-15     
    #>  3                    1        190 1930-07-08        2016-04-12     
    #>  4                    1        276 1977-06-10        2018-10-26     
    #>  5                    1        387 1973-08-31        2017-09-15     
    #>  6                    1        525 1949-04-04        2018-07-23     
    #>  7                    1        763 1965-03-18        2019-04-11     
    #>  8                    1        905 1968-09-21        2019-04-26     
    #>  9                    1       1098 1955-12-10        2019-02-23     
    #> 10                    1       1118 1973-08-12        2019-06-23     
    #> # ℹ more rows

In this last example, the return cohort doesn’t have the specified date columns, neither the “reason” column indicating which date was used for entry/exit. These was set with the `keepDateColumns` and `returnReason` arguments, common throughout the functions in this category.

## Trim Dates Functions

###  `trimDemographics()`

The `[trimDemographics()](../reference/trimDemographics.html)` function restricts the cohort based on patient demographics. This means that cohort start and end dates are moved (within the original cohort entry dates) to ensure that individuals meet specific demographic criteria throughout their cohort participation. If individuals do not satisfy the criteria at any point during their cohort period, their records are excluded.

For instance, if we trim using an age range from 18 to 65, individuals will only contribute in the cohort form the day they are 18 or older, up to the day before turning 66 (or before if they leave the database).
    
    
    cdm$cohort_trim <- cdm$cohort |>
      [trimDemographics](../reference/trimDemographics.html)(ageRange = [c](https://rdrr.io/r/base/c.html)(18, 65), name = "cohort_trim")
    #> ℹ Building new trimmed cohort
    #> Adding demographics information
    #> Creating initial cohort
    #> Trim age
    #> ✔ Cohort trimmed

###  `trimToDateRange()`

The `[trimToDateRange()](../reference/trimToDateRange.html)` function confines cohort entry and exit dates within a specified date range, ensuring that cohort periods align with the defined timeframe. If only the start or end of a range is required, the other can be set to `NA`.

For example, to restrict cohort dates to be on or after January 1st, 2015:
    
    
    # Trim cohort dates to be within the year 2000
    cdm$cohort_trim <- cdm$cohort_trim |> 
      [trimToDateRange](../reference/trimToDateRange.html)(dateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2015-01-01", NA)))

## Pad Dates Functions

###  `padCohortStart()`

The `[padCohortStart()](../reference/padCohortStart.html)` function adds (or subtracts) a specified number of days to the cohort start date.

For example, to subtract 50 days from the cohort start date:
    
    
    # Substract 50 days to cohort start
    cdm$cohort <- cdm$cohort |> [padCohortStart](../reference/padCohortStart.html)(days = -50, collapse = FALSE)

When subtracting days, it may result in cohort start dates preceding the observation period start. By default, such entries are corrected to the observation period start. To drop these entries instead, set the `padObservation` argument to FALSE.

Additionally, adjusting cohort start dates may lead to overlapping entries for the same subject. The `collapse` argument manages this: if TRUE, merges overlapping entries into a single record with the earliest start and latest end date (default), if FALSE retains only the first of the overlapping entries.

###  `padCohortEnd()`

Similarly, the `[padCohortEnd()](../reference/padCohortEnd.html)` function adjusts the cohort end date by adding (or subtracting) a specified number of days.

The example below adds 1000 days to cohort end date, while dropping records that are outside of observation after adding days.
    
    
    cdm$cohort_pad <- cdm$cohort |> 
      [padCohortEnd](../reference/padCohortEnd.html)(days = 1000, padObservation = FALSE, name = "cohort_pad")

Additionally, days to add can also be specified with a numeric column in the cohort, which allows to add a specific number of days for each record:
    
    
    cdm$cohort <- cdm$cohort [%>%](https://magrittr.tidyverse.org/reference/pipe.html) 
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(days_to_add = !![datediff](https://darwin-eu.github.io/CDMConnector/reference/datediff.html)("cohort_start_date", "cohort_end_date")) |>
      [padCohortEnd](../reference/padCohortEnd.html)(days = "days_to_add", padObservation = FALSE)

###  `padCohortDate()`

The `[padCohortDate()](../reference/padCohortDate.html)` function provides a more flexible approach by allowing adjustments to either the cohort start or end date based on specified parameters. You can define which date to adjust (`cohortDate`), the reference date for the adjustment (`indexDate`), and the number of days to add or subtract.

For example, to set the cohort end date to be 365 days after the cohort start date:
    
    
    cdm$cohort <- cdm$cohort |> 
      [padCohortDate](../reference/padCohortDate.html)(days = 365, cohortDate = "cohort_end_date", indexDate = "cohort_start_date")

## Cohort ID argument

For all these functions, the cohortId argument specifies which cohorts to modify. This allows for targeted adjustments without altering other cohorts. For instance, to add 10 days to the end date of the acetaminophen cohort and 20 days to the diclofenac cohort we can do the following:
    
    
    cdm$medications <- cdm$medications |> 
      [padCohortDate](../reference/padCohortDate.html)(days = 10, cohortId = "acetaminophen") |> 
      [padCohortDate](../reference/padCohortDate.html)(days = 20, cohortId = "diclofenac")

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
