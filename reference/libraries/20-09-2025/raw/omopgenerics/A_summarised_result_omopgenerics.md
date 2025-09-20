# A summarised result • omopgenerics

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



# A summarised result

Source: [`vignettes/summarised_result.Rmd`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/vignettes/summarised_result.Rmd)

`summarised_result.Rmd`

## Introduction

A summarised result is a table that contains aggregated summary statistics (result set with no patient-level data). The summarised result object consist in 2 objects: **results table** and **settings table**.

#### Results table

This table consist in 13 columns:

  * `result_id` (1), it is used to identify a group of results with a common settings (see settings below).
  * `cdm_name` (2), it is used to identify the name of the cdm object used to obtain those results.
  * `group_name` (3) - `group_level` (4), these columns work together as a _name-level_ pair. A _name-level_ pair are two columns that work together to summarise information of multiple other columns. The _name_ column contains the column names separated by `&&&` and the _level_ column contains the column values separated by `&&&`. Elements in the _name_ column must be snake_case. Usually group aggregation is used to show high level aggregations: e.g. cohort name or codelist name.
  * `strata_name` (5) - `strata_level` (6), these columns work together as a _name-level_ pair. Usually strata aggregation is used to show stratifications of the results: e.g. age groups or sex.
  * `variable_name` (7), name of the variable of interest.
  * `variable_level` (8), level of the variable of interest, it is usually a subclass of the variable_name.
  * `estimate_name` (9), name of the estimate.
  * `estimate_type` (10), type of the value displayed, the supported types are: numeric, integer, date, character, proportion, percentage, logical.
  * `estimate_value` (11), value of interest.
  * `additional_name` (12) - `additional_level` (13), these columns work together as a _name-level_ pair. Usually additional aggregation is used to include the aggregations that did not fit in the group/strata definition.



The following table summarises the requirements of each column in the summarised_result format:

Column name | Column type | is NA allowed? | Requirements  
---|---|---|---  
result_id | integer | No | NA  
cdm_name | character | No | NA  
group_name | character | No | name1  
group_level | character | No | level1  
strata_name | character | No | name2  
strata_level | character | No | level2  
variable_name | character | No | NA  
variable_level | character | Yes | NA  
estimate_name | character | No | snake_case  
estimate_type | character | No | estimateTypeChoices()  
estimate_value | character | No | NA  
additional_name | character | No | name3  
additional_level | character | No | level3  
  
#### Settings

The settings table provides one row per `result_id` with the settings used to generate those results, there is no limit of columns and parameters to be provided per result_id. But there is at least 3 values that should be provided:

  * `resut_type` (1): it identifies the type of result provided. We would usually use the name of the function that generated that set of result in snake_case. Example if the function that generates the summarised result is named _summariseMyCustomData_ and then the used result_type would be: _summarise_my_custom_data_.
  * `package_name` (2): name of the package that generated the result type.
  * `package_version` (3): version of the package that generated the result type.



All those columns are required to be characters, but this restriction does not apply to other extra columns.

#### newSummarisedResult

The `[newSummarisedResult()](../reference/newSummarisedResult.html)` function can be used to create __objects, the inputs of this function are: the summarised_result table that must fulfill the conditions specified above; and the settings argument. The settings argument can be NULL or do not contain all the required columns and they will be populated by default (a warning will appear). Let’s see a very simple example:
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
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
    )
    
    result <- [newSummarisedResult](../reference/newSummarisedResult.html)(x)
    result |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1
    #> Columns: 13
    #> $ result_id        <int> 1
    #> $ cdm_name         <chr> "my_cdm"
    #> $ group_name       <chr> "cohort_name"
    #> $ group_level      <chr> "cohort1"
    #> $ strata_name      <chr> "sex"
    #> $ strata_level     <chr> "male"
    #> $ variable_name    <chr> "Age group"
    #> $ variable_level   <chr> "10 to 50"
    #> $ estimate_name    <chr> "count"
    #> $ estimate_type    <chr> "numeric"
    #> $ estimate_value   <chr> "5"
    #> $ additional_name  <chr> "overall"
    #> $ additional_level <chr> "overall"
    [settings](../reference/settings.html)(result)
    #> # A tibble: 1 × 8
    #>   result_id result_type package_name package_version group     strata additional
    #>       <int> <chr>       <chr>        <chr>           <chr>     <chr>  <chr>     
    #> 1         1 ""          ""           ""              cohort_n… sex    ""        
    #> # ℹ 1 more variable: min_cell_count <chr>

We can also associate settings with our results. These will typically be used to explain how the result was created.
    
    
    result <- [newSummarisedResult](../reference/newSummarisedResult.html)(
      x = x,
      settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        result_id = 1L,
        package_name = "PatientProfiles",
        study = "my_characterisation_study"
      )
    )
    
    result |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1
    #> Columns: 13
    #> $ result_id        <int> 1
    #> $ cdm_name         <chr> "my_cdm"
    #> $ group_name       <chr> "cohort_name"
    #> $ group_level      <chr> "cohort1"
    #> $ strata_name      <chr> "sex"
    #> $ strata_level     <chr> "male"
    #> $ variable_name    <chr> "Age group"
    #> $ variable_level   <chr> "10 to 50"
    #> $ estimate_name    <chr> "count"
    #> $ estimate_type    <chr> "numeric"
    #> $ estimate_value   <chr> "5"
    #> $ additional_name  <chr> "overall"
    #> $ additional_level <chr> "overall"
    [settings](../reference/settings.html)(result)
    #> # A tibble: 1 × 9
    #>   result_id result_type package_name    package_version group  strata additional
    #>       <int> <chr>       <chr>           <chr>           <chr>  <chr>  <chr>     
    #> 1         1 ""          PatientProfiles ""              cohor… sex    ""        
    #> # ℹ 2 more variables: min_cell_count <chr>, study <chr>

## Combining summarised results

Multiple summarised results objects can be combined using the bind function. Result id will be assigned for each set of results with the same settings. So if two groups of results have the same settings althought being in different objects they will be merged into a single one.
    
    
    result1 <- [newSummarisedResult](../reference/newSummarisedResult.html)(
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
    
    result2 <- [newSummarisedResult](../reference/newSummarisedResult.html)(
      x = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        result_id = 1L,
        cdm_name = "my_cdm",
        group_name = "overall",
        group_level = "overall",
        strata_name = "overall",
        strata_level = "overall",
        variable_name = "overall",
        variable_level = "overall",
        estimate_name = "count",
        estimate_type = "numeric",
        estimate_value = "55",
        additional_name = "overall",
        additional_level = "overall"
      ),
      settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        result_id = 1L,
        package_name = "PatientProfiles",
        package_version = "1.0.0",
        study = "my_characterisation_study",
        result_type = "overall_analysis"
      )
    )

Now we have our results we can combine them using bind. Because the two sets of results contain the same result ID, when the results are combined this will be automatically updated.
    
    
    result <- [bind](../reference/bind.html)(result1, result2)
    result |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 2
    #> Columns: 13
    #> $ result_id        <int> 1, 2
    #> $ cdm_name         <chr> "my_cdm", "my_cdm"
    #> $ group_name       <chr> "cohort_name", "overall"
    #> $ group_level      <chr> "cohort1", "overall"
    #> $ strata_name      <chr> "sex", "overall"
    #> $ strata_level     <chr> "male", "overall"
    #> $ variable_name    <chr> "Age group", "overall"
    #> $ variable_level   <chr> "10 to 50", "overall"
    #> $ estimate_name    <chr> "count", "count"
    #> $ estimate_type    <chr> "numeric", "numeric"
    #> $ estimate_value   <chr> "5", "55"
    #> $ additional_name  <chr> "overall", "overall"
    #> $ additional_level <chr> "overall", "overall"
    [settings](../reference/settings.html)(result)
    #> # A tibble: 2 × 9
    #>   result_id result_type     package_name package_version group strata additional
    #>       <int> <chr>           <chr>        <chr>           <chr> <chr>  <chr>     
    #> 1         1 stratified_by_… PatientProf… 1.0.0           "coh… "sex"  ""        
    #> 2         2 overall_analys… PatientProf… 1.0.0           ""    ""     ""        
    #> # ℹ 2 more variables: min_cell_count <chr>, study <chr>

## Minimum cell count suppression

We have an entire vignette explaining how the summarised_result object is suppressed: [`vignette("suppression", "omopgenerics")`](https://darwin-eu.github.io/omopgenerics/articles/suppression.html).

## Export and import summarised results

The summarised_result object can be exported and imported as a .csv file with the following functions:

  * **importSummarisedResult()**

  * **exportSummarisedResult()**




Note that exportSummarisedResult also suppresses the results.
    
    
    x <- [tempdir](https://rdrr.io/r/base/tempfile.html)()
    files <- [list.files](https://rdrr.io/r/base/list.files.html)(x)
    
    [exportSummarisedResult](../reference/exportSummarisedResult.html)(result, path = x, fileName = "result.csv")
    [setdiff](https://generics.r-lib.org/reference/setops.html)([list.files](https://rdrr.io/r/base/list.files.html)(x), files)
    #> [1] "result.csv"

Note that the settings are included in the csv file:
    
    
    #> "result_id","cdm_name","group_name","group_level","strata_name","strata_level","variable_name","variable_level","estimate_name","estimate_type","estimate_value","additional_name","additional_level" "1","my_cdm","cohort_name","cohort1","sex","male","Age group","10 to 50","count","numeric","5","overall","overall" "2","my_cdm","overall","overall","overall","overall","overall","overall","count","numeric","55","overall","overall" "1",NA,"overall","overall","overall","overall","settings",NA,"result_type","character","stratified_by_age_group","overall","overall" "1",NA,"overall","overall","overall","overall","settings",NA,"package_name","character","PatientProfiles","overall","overall" "1",NA,"overall","overall","overall","overall","settings",NA,"package_version","character","1.0.0","overall","overall" "1",NA,"overall","overall","overall","overall","settings",NA,"group","character","cohort_name","overall","overall" "1",NA,"overall","overall","overall","overall","settings",NA,"strata","character","sex","overall","overall" "1",NA,"overall","overall","overall","overall","settings",NA,"additional","character","","overall","overall" "1",NA,"overall","overall","overall","overall","settings",NA,"min_cell_count","character","5","overall","overall" "1",NA,"overall","overall","overall","overall","settings",NA,"study","character","my_characterisation_study","overall","overall" "2",NA,"overall","overall","overall","overall","settings",NA,"result_type","character","overall_analysis","overall","overall" "2",NA,"overall","overall","overall","overall","settings",NA,"package_name","character","PatientProfiles","overall","overall" "2",NA,"overall","overall","overall","overall","settings",NA,"package_version","character","1.0.0","overall","overall" "2",NA,"overall","overall","overall","overall","settings",NA,"group","character","","overall","overall" "2",NA,"overall","overall","overall","overall","settings",NA,"strata","character","","overall","overall" "2",NA,"overall","overall","overall","overall","settings",NA,"additional","character","","overall","overall" "2",NA,"overall","overall","overall","overall","settings",NA,"min_cell_count","character","5","overall","overall" "2",NA,"overall","overall","overall","overall","settings",NA,"study","character","my_characterisation_study","overall","overall"

You can later import the results back with `[importSummarisedResult()](../reference/importSummarisedResult.html)`:
    
    
    res <- [importSummarisedResult](../reference/importSummarisedResult.html)(path = [file.path](https://rdrr.io/r/base/file.path.html)(x, "result.csv"))
    [class](https://rdrr.io/r/base/class.html)(res)
    #> [1] "summarised_result" "omop_result"       "tbl_df"           
    #> [4] "tbl"               "data.frame"
    res |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 2
    #> Columns: 13
    #> $ result_id        <int> 1, 2
    #> $ cdm_name         <chr> "my_cdm", "my_cdm"
    #> $ group_name       <chr> "cohort_name", "overall"
    #> $ group_level      <chr> "cohort1", "overall"
    #> $ strata_name      <chr> "sex", "overall"
    #> $ strata_level     <chr> "male", "overall"
    #> $ variable_name    <chr> "Age group", "overall"
    #> $ variable_level   <chr> "10 to 50", "overall"
    #> $ estimate_name    <chr> "count", "count"
    #> $ estimate_type    <chr> "numeric", "numeric"
    #> $ estimate_value   <chr> "5", "55"
    #> $ additional_name  <chr> "overall", "overall"
    #> $ additional_level <chr> "overall", "overall"
    res |>
      [settings](../reference/settings.html)()
    #> # A tibble: 2 × 9
    #>   result_id result_type     package_name package_version group strata additional
    #>       <int> <chr>           <chr>        <chr>           <chr> <chr>  <chr>     
    #> 1         1 stratified_by_… PatientProf… 1.0.0           "coh… "sex"  ""        
    #> 2         2 overall_analys… PatientProf… 1.0.0           ""    ""     ""        
    #> # ℹ 2 more variables: min_cell_count <chr>, study <chr>

## Tidy a `<summarised_result>`

### Tidy method

`ompgenerics` defines the method tidy for `<summarised_result>` object, what this function does is to:

#### 1\. Split _group_ , _strata_ , and _additional_ pairs into separate columns:

The `<summarised_result>` object has the following pair columns: group_name-group_level, strata_name-strata_level, and additional_name-additional_level. These pairs use the `&&&` separator to combine multiple fields, for example if you want to combine cohort_name and age_group in group_name-group_level pair: `group_name = "cohort_name &&& age_group"` and `group_level = "my_cohort &&& <40"`. By default if no aggregation is produced in group_name-group_level pair: `group_name = "overall"` and `group_level = "overall"`.

**ORIGINAL FORMAT:**

group_name | group_level  
---|---  
cohort_name | acetaminophen  
cohort_name &&& sex | acetaminophen &&& Female  
sex &&& age_group | Male &&& <40  
  
The tidy format puts each one of the values as a columns. Making it easier to manipulate but at the same time the output is not standardised anymore as each `<summarised_result>` object will have a different number and names of columns. Missing values will be filled with the “overall” label.

**TIDY FORMAT:**

cohort_name | sex | age_group  
---|---|---  
acetaminophen | overall | overall  
acetaminophen | Female | overall  
overall | Male | <40  
  
#### 2\. Add settings of the `<summarised_result>` object as columns:

Each `<summarised_result>` object has a setting attribute that relates the ‘result_id’ column with each different set of settings. The columns ‘result_type’, ‘package_name’ and ‘package_version’ are always present in settings, but then we may have some extra parameters depending how the object was created. So in the `<summarised_result>` format we need to use these `[settings()](../reference/settings.html)` functions to see those variables:

**ORIGINAL FORMAT:**

`settings`:

result_id | my_setting | package_name  
---|---|---  
1 | TRUE | omopgenerics  
2 | FALSE | omopgenerics  
  
`<summarised_result>`:

result_id | cdm_name |  | additional_name  
---|---|---|---  
1 | omop | ... | overall  
... | ... | ... | ...  
2 | omop | ... | overall  
... | ... | ... | ...  
  
But in the tidy format we add the settings as columns, making that their value is repeated multiple times (there is only one row per result_id in settings, whereas there can be multiple rows in the `<summarised_result>` object). The column ‘result_id’ is eliminated as it does not provide information anymore. Again we loose on standardisation (multiple different settings), but we gain in flexibility:

**TIDY FORMAT:**

cdm_name |  | additional_name | my_setting | package_name  
---|---|---|---|---  
omop | ... | overall | TRUE | omopgenerics  
... | ... | ... | ... | ...  
omop | ... | overall | FALSE | omopgenerics  
... | ... | ... | ... | ...  
  
#### 3\. Pivot estimates as columns:

In the `<summarised_result>` format estimates are displayed in 3 columns:

  * ‘estimate_name’ indicates the name of the estimate.
  * ‘estimate_type’ indicates the type of the estimate (as all of them will be casted to character). Possible values are: _numeric, integer, date, character, proportion, percentage, logical_.
  * ‘estimate_value’ value of the estimate as `<character>`.



**ORIGINAL FORMAT:**

variable_name | estimate_name | estimate_type | estimate_value  
---|---|---|---  
number individuals | count | integer | 100  
age | mean | numeric | 50.3  
age | sd | numeric | 20.7  
  
In the tidy format we pivot the estimates, creating a new column for each one of the ‘estimate_name’ values. The columns will be casted to ‘estimate_type’. If there are multiple estimate_type(s) for same estimate_name they won’t be casted and they will be displayed as character (a warning will be thrown). Missing data are populated with NAs.

**TIDY FORMAT:**

variable_name | count | mean | sd  
---|---|---|---  
number individuals | 100 | NA | NA  
age | NA | 50.3 | 20.7  
  
#### Example

Let’s see a simple example with some toy data:
    
    
    result |>
      [tidy](https://generics.r-lib.org/reference/tidy.html)()
    #> # A tibble: 2 × 7
    #>   cdm_name cohort_name sex     variable_name variable_level count study         
    #>   <chr>    <chr>       <chr>   <chr>         <chr>          <dbl> <chr>         
    #> 1 my_cdm   cohort1     male    Age group     10 to 50           5 my_characteri…
    #> 2 my_cdm   overall     overall overall       overall           55 my_characteri…

### Split

The functions split are provided independent:

  * `[splitGroup()](../reference/splitGroup.html)` only splits the pair group_name-group_level columns.
  * `[splitStrata()](../reference/splitStrata.html)` only splits the pair strata_name-strata_level columns.
  * `[splitAdditional()](../reference/splitAdditional.html)` only splits the pair additional_name-additional_level columns.



There is also the function: - `[splitAll()](../reference/splitAll.html)` that splits any pair x_name-x_level that is found on the data.
    
    
    [splitAll](../reference/splitAll.html)(result)
    #> # A tibble: 2 × 9
    #>   result_id cdm_name cohort_name sex     variable_name variable_level
    #>       <int> <chr>    <chr>       <chr>   <chr>         <chr>         
    #> 1         1 my_cdm   cohort1     male    Age group     10 to 50      
    #> 2         2 my_cdm   overall     overall overall       overall       
    #> # ℹ 3 more variables: estimate_name <chr>, estimate_type <chr>,
    #> #   estimate_value <chr>

### Pivot estimates

`[pivotEstimates()](../reference/pivotEstimates.html)` can be used to pivot the variables that we are interested in.

The argument `pivotEstimatesBy` specifies which are the variables that we want to use to pivot by, there are four options:

  * `NULL/character()` to not pivot anything.
  * `c("estimate_name")` to pivot only estimate_name.
  * `c("variable_level", "estimate_name")` to pivot estimate_name and variable_level.
  * `c("variable_name", "variable_level", "estimate_name")` to pivot estimate_name, variable_level and variable_name.



Note that `variable_level` can contain NA values, these will be ignored on the naming part.
    
    
    [pivotEstimates](../reference/pivotEstimates.html)(
      result,
      pivotEstimatesBy = [c](https://rdrr.io/r/base/c.html)("variable_name", "variable_level", "estimate_name")
    )
    #> # A tibble: 2 × 10
    #>   result_id cdm_name group_name  group_level strata_name strata_level
    #>       <int> <chr>    <chr>       <chr>       <chr>       <chr>       
    #> 1         1 my_cdm   cohort_name cohort1     sex         male        
    #> 2         2 my_cdm   overall     overall     overall     overall     
    #> # ℹ 4 more variables: additional_name <chr>, additional_level <chr>,
    #> #   `Age group_10 to 50_count` <dbl>, overall_overall_count <dbl>

### Add settings

`[addSettings()](../reference/addSettings.html)` is used to add the settings that we want as new columns to our `<summarised_result>` object.

The `settingsColumn` argument is used to choose which are the settings we want to add.
    
    
    [addSettings](../reference/addSettings.html)(
      result,
      settingsColumn = "result_type"
    )
    #> # A tibble: 2 × 14
    #>   result_id cdm_name group_name  group_level strata_name strata_level
    #>       <int> <chr>    <chr>       <chr>       <chr>       <chr>       
    #> 1         1 my_cdm   cohort_name cohort1     sex         male        
    #> 2         2 my_cdm   overall     overall     overall     overall     
    #> # ℹ 8 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>, result_type <chr>

### Filter

Dealing with an `<summarised_result>` object can be difficult to handle specially when we are trying to filter. For example, difficult tasks would be to filter to a certain result_type or when there are many strata joined together filter only one of the variables. On the other hand it exists the `tidy` format that makes it easy to filter, but then you loose the `<summarised_result>` object.

**omopgenerics** package contains some functionalities that helps on this process:

  * `filterSettings` to filter the `<summarised_result>` object using the `[settings()](../reference/settings.html)` attribute.
  * `filterGroup` to filter the `<summarised_result>` object using the group_name-group_level tidy columns.
  * `filterStrata` to filter the `<summarised_result>` object using the strata_name-starta_level tidy columns.
  * `filterAdditional` to filter the `<summarised_result>` object using the additional_name-additional_level tidy columns.



For instance, let’s filter `result` so it only has results for males:
    
    
    result |>
      [filterStrata](../reference/filterStrata.html)(sex == "male")
    #> # A tibble: 1 × 13
    #>   result_id cdm_name group_name  group_level strata_name strata_level
    #>       <int> <chr>    <chr>       <chr>       <chr>       <chr>       
    #> 1         1 my_cdm   cohort_name cohort1     sex         male        
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>

Now let’s see an example using the information on settings to filter the result. In this case, we only one results of the “overall_analysis”, since this information is in the result_type column in settings, we procees as follows:
    
    
    result |>
      [filterSettings](../reference/filterSettings.html)(result_type == "overall_analysis")
    #> # A tibble: 1 × 13
    #>   result_id cdm_name group_name group_level strata_name strata_level
    #>       <int> <chr>    <chr>      <chr>       <chr>       <chr>       
    #> 1         2 my_cdm   overall    overall     overall     overall     
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>

## Utility functions for `<summarised_result>`

### Column retrieval functions

Working with `<summarised_result>` objects often involves managing columns for **settings** , **grouping** , **strata** , and **additional** levels. These retrieval functions help you identify and manage columns:

  * `[settingsColumns()](../reference/settingsColumns.html)` gives you the setting names that are available in a `<summarised_result>` object.
  * `[groupColumns()](../reference/groupColumns.html)` gives you the new columns that will be generated when splitting group_name-group_level pair into different columns.
  * `[strataColumns()](../reference/strataColumns.html)` gives you the new columns that will be generated when splitting strata_name-strata_level pair into different columns.
  * `[additionalColumns()](../reference/additionalColumns.html)` gives you the new columns that will be generated when splitting additional_name-additional_level pair into different columns.
  * `[tidyColumns()](../reference/tidyColumns.html)` gives you the columns that will have the object if you tidy it (`tidy(result)`). This function in very useful to know which are the columns that can be included in **plot** and **table** functions.



Let’s see the different values with out example result data:
    
    
    [settingsColumns](../reference/settingsColumns.html)(result)
    #> [1] "study"
    [groupColumns](../reference/groupColumns.html)(result)
    #> [1] "cohort_name"
    [strataColumns](../reference/strataColumns.html)(result)
    #> [1] "sex"
    [additionalColumns](../reference/additionalColumns.html)(result)
    #> character(0)
    [tidyColumns](../reference/tidyColumns.html)(result)
    #> [1] "cdm_name"       "cohort_name"    "sex"            "variable_name" 
    #> [5] "variable_level" "count"          "study"

### Unite functions

The unite functions serve as the complementary tools to the split functions, allowing you to generate name-level pair columns from targeted columns within a `<dataframe>`.

There are three `unite` functions that allow to create group, strata, and additional name-level columns from specified sets of columns:

  * `[uniteAdditional()](../reference/uniteAdditional.html)`

  * `[uniteGroup()](../reference/uniteGroup.html)`

  * `[uniteStrata()](../reference/uniteStrata.html)`




#### Example

For example, to create group_name and group_level columns from a tibble, you can use:
    
    
    # Create and show mock data
    data <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      denominator_cohort_name = [c](https://rdrr.io/r/base/c.html)("general_population", "older_than_60", "younger_than_60"),
      outcome_cohort_name = [c](https://rdrr.io/r/base/c.html)("stroke", "stroke", "stroke")
    )
    [head](https://rdrr.io/r/utils/head.html)(data)
    #> # A tibble: 3 × 2
    #>   denominator_cohort_name outcome_cohort_name
    #>   <chr>                   <chr>              
    #> 1 general_population      stroke             
    #> 2 older_than_60           stroke             
    #> 3 younger_than_60         stroke
    
    # Unite into group name-level columns
    data |>
      [uniteGroup](../reference/uniteGroup.html)(cols = [c](https://rdrr.io/r/base/c.html)("denominator_cohort_name", "outcome_cohort_name"))
    #> # A tibble: 3 × 2
    #>   group_name                                      group_level                  
    #>   <chr>                                           <chr>                        
    #> 1 denominator_cohort_name &&& outcome_cohort_name general_population &&& stroke
    #> 2 denominator_cohort_name &&& outcome_cohort_name older_than_60 &&& stroke     
    #> 3 denominator_cohort_name &&& outcome_cohort_name younger_than_60 &&& stroke

These functions can be helpful when creating your own `<summarised_result>`.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
