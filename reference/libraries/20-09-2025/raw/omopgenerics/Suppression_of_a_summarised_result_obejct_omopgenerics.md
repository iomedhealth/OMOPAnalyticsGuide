# Suppression of a summarised_result obejct • omopgenerics

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



# Suppression of a summarised_result obejct

Source: [`vignettes/suppression.Rmd`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/vignettes/suppression.Rmd)

`suppression.Rmd`

## Minimum cell count suppression

Minimum cell count suppression is very important in studies as it is essential step to ensure no reidentification. The min cell count suppression can vary source to source, but in general a minimum cell count of 5 is fixed. In this vignette we explain how the suppression process works for `summarised_result` objects.

### How suppression works

In general a record is suppressed if 3 conditions are met:

  1. The `estimate_name` field contains the word ‘count’ (e.g ‘count’, ‘outcome_count’, ‘count_of_individuals’, …).
  2. The `estimate_type` field is either _numeric_ or _integer_.
  3. The `estimate_value` numeric value is smaller than _minCellCount_ and bigger than 0.



This simple rule determines the suppression at record level. The suppressed record is not removed from the results, instead the `estimate_value` field is populated as ‘<{minCellCount}’.

Once one record is suppressed this can trigger suppression of other _linked_ estimates. This suppression is done at different level and affects different rows of the result object:

  * **Suppression at group level** : if in the suppressed estimate the field `variable_name` is populated with the word “number records” or “number subjects” (it is not case sensitive) then the whole group of records will be suppressed. Note a group of records is a set of rows with the same: `result_id`, `cdm_name`, `group_name`, `group_level`, `strata_name`, `strata_level`, `additional_name`, `additional_level`. This level of suppression is for example to suppress all the demographics of a cohort of individuals that has less than the minimum amount of records required. For developers note that creating a row with `variable_name` = “number records/subjects” can have a big impact on the suppression, but at the same point it gives you the ability to link a group of estimates and suppress all of them at the same point.

  * **Suppression at variable_name level** : if in the suppressed estimate the field `estimate_name` is populated with either “count”, “denominator_count”, “outcome_count”, “record_count” or “subject_count” then the suppression is done at the variable level, meaning that all the estimates with the same: `result_id`, `cdm_name`, `group_name`, `group_level`, `strata_name`, `strata_level`, `additional_name`, `additional_level` and `variable_name` will be suppressed. This level of suppression is for example to suppress the statistics associated with an outcome count for example, but not do not affect the different outcomes for example. For developers use one of this key words to link the estimates at the variable level.

  * **Suppression of percentages** : if an estimate is suppressed any estimate in the same level (same `result_id`, `cdm_name`, `group_name`, `group_level`, `strata_name`, `strata_level`, `additional_name`, `additional_level`, `variable_name` and `variable_level`) with the same estimate name but changing ‘count’ for ‘percentage’ (e.g. ‘event_count’ -> ‘event_percentage’) will be suppressed.




Note that linked estimate records will be suppressed as ‘-’.

You can view the source code for minimum cell suppression [here](https://github.com/darwin-eu/omopgenerics/blob/main/R/methodSuppress.R).

### Suppressing a summarised_result object

Once we have a summarised result, we can suppress the object based on a desired minimum cell count value using the [`suppress()`](https://darwin-eu.github.io/omopgenerics/reference/suppress.html) function.
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    result <- [newSummarisedResult](../reference/newSummarisedResult.html)(
      x = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        result_id = 1L,
        cdm_name = "my_cdm",
        group_name = "cohort_name",
        group_level = "cohort1",
        strata_name = "sex",
        strata_level = "male",
        variable_name = "Age group",
        variable_level = "10 to 50",
        estimate_name = "count",
        estimate_type = "numeric",
        estimate_value = "5",
        additional_name = "overall",
        additional_level = "overall"
      ),
      settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        result_id = 1L,
        package_name = "PatientProfiles",
        package_version = "1.0.0",
        study = "my_characterisation_study",
        result_type = "stratified_by_age_group"
      )
    )
    
    suppressedResult <- [suppress](../reference/suppress.html)(result = result, minCellCount = 7)

### Is a summarised_result object suppressed?

The minCellCount suppression is recorded in the settings of the object:
    
    
    [glimpse](https://pillar.r-lib.org/reference/glimpse.html)([settings](../reference/settings.html)(result))
    #> Rows: 1
    #> Columns: 9
    #> $ result_id       <int> 1
    #> $ result_type     <chr> "stratified_by_age_group"
    #> $ package_name    <chr> "PatientProfiles"
    #> $ package_version <chr> "1.0.0"
    #> $ group           <chr> "cohort_name"
    #> $ strata          <chr> "sex"
    #> $ additional      <chr> ""
    #> $ min_cell_count  <chr> "0"
    #> $ study           <chr> "my_characterisation_study"
    [glimpse](https://pillar.r-lib.org/reference/glimpse.html)([settings](../reference/settings.html)(suppressedResult))
    #> Rows: 1
    #> Columns: 9
    #> $ result_id       <int> 1
    #> $ result_type     <chr> "stratified_by_age_group"
    #> $ package_name    <chr> "PatientProfiles"
    #> $ package_version <chr> "1.0.0"
    #> $ group           <chr> "cohort_name"
    #> $ strata          <chr> "sex"
    #> $ additional      <chr> ""
    #> $ min_cell_count  <chr> "7"
    #> $ study           <chr> "my_characterisation_study"

As a result object can be partially suppressed (e.g. binding an object that has already been suppressed with another one that is not suppressed) and settings of results objects can be long we also have a utility function to check if an object has been suppressed or not, [`isResultSuppressed()`](https://darwin-eu.github.io/omopgenerics/reference/isResultSuppressed.html):
    
    
    [isResultSuppressed](../reference/isResultSuppressed.html)(result = result, minCellCount = 5)
    #> Warning: ✖ 1 set (1 row) not suppressed.
    #> [1] FALSE
    [isResultSuppressed](../reference/isResultSuppressed.html)(result = suppressedResult, minCellCount = 5)
    #> Warning: ! 1 set (1 row) suppressed with minCellCount > 5.
    #> [1] FALSE
    [isResultSuppressed](../reference/isResultSuppressed.html)(result = suppressedResult, minCellCount = 7)
    #> ✔ The <summarised_result> is suppressed with
    #> minCellCount = 7.
    #> [1] TRUE
    [isResultSuppressed](../reference/isResultSuppressed.html)(result = suppressedResult, minCellCount = 10)
    #> Warning: ✖ 1 set (1 row) suppressed with minCellCount < 10.
    #> [1] FALSE

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
