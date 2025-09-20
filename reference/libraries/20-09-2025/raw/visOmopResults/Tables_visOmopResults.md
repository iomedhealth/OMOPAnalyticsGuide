# Tables • visOmopResults

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Tables

Source: [`vignettes/a01_tables.Rmd`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/vignettes/a01_tables.Rmd)

`a01_tables.Rmd`

## Introduction

The **visOmopResults** package provides user-friendly tools for creating well-formatted tables and plots that are publication-ready. In this vignette, we focus specifically on the table formatting functionalities. The package supports four table formats: [`<tibble>`](https://cran.r-project.org/package=tibble), [`<gt>`](https://cran.r-project.org/package=gt), [`<flextable>`](https://cran.r-project.org/package=flextable), and [`<datatables>`](https://CRAN.R-project.org/package=DT). While `<tibble>` is an `<data.frame>` R object, `<gt>` and `<flextable>` are designed to create publication-ready tables that can be exported to different formats (e.g., PNG, Word, PDF, HTML), and `<datatables>` display tables on HTML pages. These last three can be used in ShinyApps, RMarkdown, Quarto, and more.

Although the primary aim of the package is to simplify the handling of the `<summarised_result>` class (see [omopgenerics](https://CRAN.R-project.org/package=omopgenerics) for more details), its functionalities can be applied to any `<data.frame>` if certain requirements are met.

### Types of Table Functions

There are two main categories of table functions in the package:

  * **Main Table Functions** : Comprehensive functions like `[visOmopTable()](../reference/visOmopTable.html)` and `[visTable()](../reference/visTable.html)` allow users to fully format tables, including specifying headers, grouping columns, and customising styles.

  * **Additional Table Formatting Functions** : The `format` function set provides more granular control over specific table elements, enabling advanced customisation beyond the main functions.




This vignette will guide you through the usage of these functions.

## Main Functions

These functions are built on top of the `format` functions, providing a quick and straightforward way to format tables.

### visTable()

`[visTable()](../reference/visTable.html)` is a flexible function designed to format any `<data.frame>`.

Let’s demonstrate its usage with a dataset from the `palmerpenguins` package.
    
    
    [library](https://rdrr.io/r/base/library.html)([visOmopResults](https://darwin-eu.github.io/visOmopResults/))
    [library](https://rdrr.io/r/base/library.html)([palmerpenguins](https://allisonhorst.github.io/palmerpenguins/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([tidyr](https://tidyr.tidyverse.org))
    x <- penguins |> 
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(![is.na](https://rdrr.io/r/base/NA.html)(sex) & year == 2008) |> 
      [select](https://dplyr.tidyverse.org/reference/select.html)(!"body_mass_g") |>
      [summarise](https://dplyr.tidyverse.org/reference/summarise.html)([across](https://dplyr.tidyverse.org/reference/across.html)([ends_with](https://tidyselect.r-lib.org/reference/starts_with.html)("mm"), ~[mean](https://rdrr.io/r/base/mean.html)(.x)), .by = [c](https://rdrr.io/r/base/c.html)("species", "island", "sex"))
    [head](https://rdrr.io/r/utils/head.html)(x)
    #> # A tibble: 6 × 6
    #>   species island    sex    bill_length_mm bill_depth_mm flipper_length_mm
    #>   <fct>   <fct>     <fct>           <dbl>         <dbl>             <dbl>
    #> 1 Adelie  Biscoe    female           36.6          17.2              187.
    #> 2 Adelie  Biscoe    male             40.8          19.0              193.
    #> 3 Adelie  Torgersen female           36.6          17.4              190 
    #> 4 Adelie  Torgersen male             40.9          18.8              194.
    #> 5 Adelie  Dream     female           36.3          17.8              189 
    #> 6 Adelie  Dream     male             40.1          18.9              195

We can format this data into a `<gt>` table using `[visTable()](../reference/visTable.html)` as follows:
    
    
    [visTable](../reference/visTable.html)(
      result = x,
      groupColumn = [c](https://rdrr.io/r/base/c.html)("sex"),
      rename = [c](https://rdrr.io/r/base/c.html)("Bill length (mm)" = "bill_length_mm",
                 "Bill depth (mm)" = "bill_depth_mm",
                 "Flipper length (mm)" = "flipper_length_mm"),
      type = "gt",
      hide = "year"
    )

Species | Island | Bill length (mm) | Bill depth (mm) | Flipper length (mm)  
---|---|---|---|---  
female  
Adelie | Biscoe | 36.6444444444444 | 17.2222222222222 | 186.555555555556  
| Torgersen | 36.6125 | 17.4 | 190  
| Dream | 36.275 | 17.7875 | 189  
Gentoo | Biscoe | 45.2954545454545 | 14.1318181818182 | 213  
Chinstrap | Dream | 46 | 17.3 | 192.666666666667  
male  
Adelie | Biscoe | 40.7555555555556 | 19.0333333333333 | 192.555555555556  
| Torgersen | 40.925 | 18.8375 | 193.5  
| Dream | 40.1125 | 18.8875 | 195  
Gentoo | Biscoe | 48.5391304347826 | 15.704347826087 | 222.086956521739  
Chinstrap | Dream | 51.4 | 19.6 | 202.777777777778  
  
To use the arguments `estimateName` and `header`, the `<data.frame>` must have the estimates arranged into three columns: `estimate_name`, `estimate_type`, and `estimate_value`. Let’s reshape the example dataset accordingly and demonstrate creating a `<flextable>` object:
    
    
    # Transforming the dataset to include estimate columns
    x <- x |>
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(
        cols = [ends_with](https://tidyselect.r-lib.org/reference/starts_with.html)("_mm"), 
        names_to = "estimate_name", 
        values_to = "estimate_value"
      ) |>
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(estimate_type = "numeric")
    
    # Creating a formatted flextable
    [visTable](../reference/visTable.html)(
      result = x,
      estimateName = [c](https://rdrr.io/r/base/c.html)(
        "Bill length - Bill depth (mm)" = "<bill_length_mm> - <bill_depth_mm>",
        "Flipper length (mm)" = "<flipper_length_mm>"
      ),
      header = [c](https://rdrr.io/r/base/c.html)("species", "island"),
      groupColumn = "sex",
      type = "flextable",
      hide = [c](https://rdrr.io/r/base/c.html)("year", "estimate_type")
    )

Estimate name | Species  
---|---  
Adelie | Gentoo | Chinstrap  
Island  
Biscoe | Torgersen | Dream | Biscoe | Dream  
female  
Bill length - Bill depth (mm) | 36.64 - 17.22 | 36.61 - 17.40 | 36.27 - 17.79 | 45.30 - 14.13 | 46.00 - 17.30  
Flipper length (mm) | 186.56 | 190.00 | 189.00 | 213.00 | 192.67  
male  
Bill length - Bill depth (mm) | 40.76 - 19.03 | 40.92 - 18.84 | 40.11 - 18.89 | 48.54 - 15.70 | 51.40 - 19.60  
Flipper length (mm) | 192.56 | 193.50 | 195.00 | 222.09 | 202.78  
  
### visOmopTable()

`[visOmopTable()](../reference/visOmopTable.html)` extends the functionality of `[visTable()](../reference/visTable.html)` with additional features tailored specifically for handling `<summarised_result>` objects, making it easier to work with standardized result formats.

Let’s demonstrate `[visOmopTable()](../reference/visOmopTable.html)` with a mock `<summarised_result>`:
    
    
    # Creating a mock summarised result
    result <- [mockSummarisedResult](../reference/mockSummarisedResult.html)() |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(strata_name == "age_group &&& sex")
    
    # Displaying the first few rows
    [head](https://rdrr.io/r/utils/head.html)(result)
    #> # A tibble: 6 × 13
    #>   result_id cdm_name group_name  group_level strata_name       strata_level   
    #>       <int> <chr>    <chr>       <chr>       <chr>             <chr>          
    #> 1         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Male   
    #> 2         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Male  
    #> 3         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Female 
    #> 4         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Female
    #> 5         1 mock     cohort_name cohort2     age_group &&& sex <40 &&& Male   
    #> 6         1 mock     cohort_name cohort2     age_group &&& sex >=40 &&& Male  
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    # Creating a formatted gt table
    [visOmopTable](../reference/visOmopTable.html)(
      result = result,
      estimateName = [c](https://rdrr.io/r/base/c.html)(
        "N%" = "<count> (<percentage>)",
        "N" = "<count>",
        "Mean (SD)" = "<mean> (<sd>)"
      ),
      header = [c](https://rdrr.io/r/base/c.html)("package_name", "age_group"),
      groupColumn = [c](https://rdrr.io/r/base/c.html)("cohort_name", "sex"),
      settingsColumn = "package_name",
      type = "gt"
    )

|  Package name  
---|---  
|  visOmopResults  
CDM name | Variable name | Variable level | Estimate name |  Age group  
<40 | >=40  
cohort1; Male  
mock | number subjects | - | N | 3,721,239 | 5,728,534  
| age | - | Mean (SD) | 77.74 (1.08) | 93.47 (7.24)  
| Medications | Amoxiciline | N% | 9,947 (33.38) | 31,627 (47.64)  
|  | Ibuprofen | N% | 5,893 (59.88) | 64,229 (97.62)  
cohort1; Female  
mock | number subjects | - | N | 9,082,078 | 2,016,819  
| age | - | Mean (SD) | 21.21 (4.11) | 65.17 (8.21)  
| Medications | Amoxiciline | N% | 51,863 (89.22) | 66,201 (86.43)  
|  | Ibuprofen | N% | 87,627 (73.18) | 77,891 (35.67)  
cohort2; Male  
mock | number subjects | - | N | 2,059,746 | 1,765,568  
| age | - | Mean (SD) | 86.97 (0.23) | 34.03 (4.77)  
| Medications | Amoxiciline | N% | 65,087 (40.00) | 25,802 (32.54)  
|  | Ibuprofen | N% | 65,472 (44.63) | 35,320 (64.01)  
cohort2; Female  
mock | number subjects | - | N | 6,870,228 | 3,841,037  
| age | - | Mean (SD) | 48.21 (7.32) | 59.96 (6.93)  
| Medications | Amoxiciline | N% | 47,855 (75.71) | 76,631 (20.27)  
|  | Ibuprofen | N% | 27,026 (99.18) | 99,268 (49.56)  
  
The workflow is quite similar to `[visTable()](../reference/visTable.html)`, but it includes specific enhancements for `<summarised_result>` objects:

  * **Automatic splitting** : The result object is always processed using the [`splitAll()`](https://darwin-eu.github.io/visOmopResults/reference/splitAll.html) function. Thereby, column names to use in other arguments must be based on the split result.

  * **`settingsColumn` argument**: Use this argument to specify which settings should be displayed in the main table. The columns specified here can also be referenced in other arguments such as `header`, `rename`, and `groupColumn.`

  * **`header` argument**: accepts specific `<summarised_result>` inputs, in addition to its typical usage as in `[visTable()](../reference/visTable.html)`. For example, use “strata” in the header to display all variables in `strata_name`, or use “settings” to show all settings specified in `settingsColumns.`

  * **Hidden columns** : result_id and estimate_type columns are always hidden as they serve as helper columns for internal processes.

  * **Suppressed estimates** : if the result object has been processed with [suppress()](https://darwin-eu-dev.github.io/omopgenerics/reference/suppress.html), obscured estimates can be displayed as the default `na` value or as “<{minCellCount}” with the corresponding minimum count value used. This can be controlled using the `showMinCellCount` argument.




In the next example, `[visOmopTable()](../reference/visOmopTable.html)` generates a `<gt>` table while displaying suppressed estimates (those with counts below 1,000,000) with the specified minimum cell count.
    
    
    result |>
      [suppress](https://darwin-eu.github.io/omopgenerics/reference/suppress.html)(minCellCount = 1000000) |>
      [visOmopTable](../reference/visOmopTable.html)(
        estimateName = [c](https://rdrr.io/r/base/c.html)(
          "N%" = "<count> (<percentage>)",
          "N" = "<count>",
          "Mean (SD)" = "<mean> (<sd>)"
        ),
        header = [c](https://rdrr.io/r/base/c.html)("group"),
        groupColumn = [c](https://rdrr.io/r/base/c.html)("strata"),
        hide = [c](https://rdrr.io/r/base/c.html)("cdm_name"),
        showMinCellCount = TRUE,
        type = "reactable"
      )

### Customise tables

Tables displayed in `[visOmopResults()](../reference/visOmopResults-package.html)` follow a default style, but customisation is possible through the `style` and `.options` arguments. These allow users to modify various formatting aspects using options from the `format` functions (see the _`format` Functions_ section to learn more).

#### Style

By default, the visOmopResults default style is applied for all tables. At the moment, besides from the default style, the package also supports the “darwin” style.

To inspect the code for the default styles of the different table types supported, you can use the `[tableStyle()](../reference/tableStyle.html)` function as showed next.
    
    
    [tableStyle](../reference/tableStyle.html)(type = "gt", style = "default")
    #> list(header = list(gt::cell_fill(color = "#c8c8c8"), gt::cell_text(weight = "bold", 
    #>     align = "center")), header_name = list(gt::cell_fill(color = "#d9d9d9"), 
    #>     gt::cell_text(weight = "bold", align = "center")), header_level = list(gt::cell_fill(color = "#e1e1e1"), 
    #>     gt::cell_text(weight = "bold", align = "center")), column_name = list(gt::cell_text(weight = "bold", 
    #>     align = "center")), group_label = list(gt::cell_fill(color = "#e9e9e9"), 
    #>     gt::cell_text(weight = "bold")), title = list(gt::cell_text(weight = "bold", 
    #>     size = 15, align = "center")), subtitle = list(gt::cell_text(weight = "bold", 
    #>     size = 12, align = "center")), body = list())

If you want all your tables to use the same type and style, use `[setGlobalTableOptions()](../reference/setGlobalTableOptions.html)`. This will apply the desired settings to all subsequent tables, unless you specify a different style in a specific function call.

#### Further Options

The main `vis` table functions are built on top of specific formatting functions described in the next section. These core table functions do not directly expose all customization arguments in their signature. Instead, additional tweaks can be made via the `.options` argument.

To view the full list of customization options and their default values, use:
    
    
    [tableOptions](../reference/tableOptions.html)()
    #> $decimals
    #>    integer percentage    numeric proportion 
    #>          0          2          2          2 
    #> 
    #> $decimalMark
    #> [1] "."
    #> 
    #> $bigMark
    #> [1] ","
    #> 
    #> $keepNotFormatted
    #> [1] TRUE
    #> 
    #> $useFormatOrder
    #> [1] TRUE
    #> 
    #> $delim
    #> [1] "\n"
    #> 
    #> $includeHeaderName
    #> [1] TRUE
    #> 
    #> $includeHeaderKey
    #> [1] TRUE
    #> 
    #> $na
    #> [1] "-"
    #> 
    #> $title
    #> NULL
    #> 
    #> $subtitle
    #> NULL
    #> 
    #> $caption
    #> NULL
    #> 
    #> $groupAsColumn
    #> [1] FALSE
    #> 
    #> $groupOrder
    #> NULL
    #> 
    #> $merge
    #> [1] "all_columns"

As mentioned, all these arguments originate from specific formatting functions. The table below shows, for each argument, the function it belongs to and its purpose:

Argument | Description  
---|---  
formatEstimateValue()  
decimals | Number of decimals to display, which can be specified per estimate type (integer, numeric, percentage, proportion), per estimate name, or applied to all estimates.  
decimalMark | Symbol to use as the decimal separator.  
bigMark | Symbol to use as the thousands and millions separator.  
formatEstimateName()  
keepNotFormatted | Whether to retain rows with estimate names that are not explicitly formatted.  
useFormatOrder | Whether to display estimate names in the order provided in `estimateName` (TRUE) or in the order of the input data frame (FALSE).  
formatHeader()  
delim | Delimiter to use when separating header components.  
includeHeaderName | Whether to include the column name as part of the header.  
includeHeaderKey | Whether to prefix header elements with their type (e.g., header, header_name, header_level).  
formatTable()  
style | Named list specifying styles for table components (e.g., title, subtitle, header, body). Use `'default'` for the default `visOmopResults` style or `NULL` for the package default (either `gt` or `flextable`). Use `gtStyle()` or `flextableStyle()` to preview the default styles.  
na | Value to display for missing data.  
title | Title of the table. Use `NULL` for no title.  
subtitle | Subtitle of the table. Use `NULL` for no subtitle.  
caption | Caption in markdown format. Use `NULL` for no caption. For example, *Your caption here* renders in italics.  
groupAsColumn | Whether to display group labels as a separate column (`TRUE`) or as row headers (`FALSE`).  
groupOrder | Order in which to display group labels.  
merge | Columns to merge vertically when consecutive cells have the same value. Use `'all_columns'` to merge all, or `NULL` for no merging.  
  
## Formatting Functions

The `format` set of functions can be used in a pipeline to transform and format a `<data.frame>` or a `<summarised_result>` object. Below, we’ll demonstrate how to utilize these functions in a step-by-step manner.

### 1) Format Estimates

The `[formatEstimateName()](../reference/formatEstimateName.html)` and `[formatEstimateValue()](../reference/formatEstimateValue.html)` functions enable you to customise the naming and display of estimates in your table.

To illustrate their usage, we’ll continue with the `result` dataset. Let’s first take a look at some of the estimates before any formatting is applied:
    
    
    result |> 
      [filterGroup](https://darwin-eu.github.io/omopgenerics/reference/filterGroup.html)(cohort_name == "cohort1") |>  # visOmopResult filter function
      [filterStrata](https://darwin-eu.github.io/omopgenerics/reference/filterStrata.html)(age_group == "<40", sex == "Female") |>  # visOmopResult filter function
      [select](https://dplyr.tidyverse.org/reference/select.html)(variable_name, variable_level, estimate_name, estimate_type, estimate_value)
    #> # A tibble: 7 × 5
    #>   variable_name   variable_level estimate_name estimate_type estimate_value  
    #>   <chr>           <chr>          <chr>         <chr>         <chr>           
    #> 1 number subjects NA             count         integer       9082078         
    #> 2 age             NA             mean          numeric       21.2142521282658
    #> 3 age             NA             sd            numeric       4.11274429643527
    #> 4 Medications     Amoxiciline    count         integer       51863           
    #> 5 Medications     Amoxiciline    percentage    percentage    89.2198335845023
    #> 6 Medications     Ibuprofen      count         integer       87627           
    #> 7 Medications     Ibuprofen      percentage    percentage    73.1792511884123

#### 1.1) Suppressed estimates

The function `[formatMinCellCount()](../reference/formatMinCellCount.html)` indicates which estimates have been suppressed due to the minimum cell count specified in the study.

Estimates are suppressed using `[omopgenerics::suppress()](https://darwin-eu.github.io/omopgenerics/reference/suppress.html)`, which replaces the estimate with the symbol “-”. When reporting results, we want to distinguish suppressed estimates from missing values (`NA`), the `[formatMinCellCount()](../reference/formatMinCellCount.html)` function can be used as follows:
    
    
    result <- result |> [formatMinCellCount](../reference/formatMinCellCount.html)()

#### 1.2) Estimate values

The `[formatEstimateValue()](../reference/formatEstimateValue.html)` function allows you to specify the number of decimals for different `estimate_types` or `estimate_names`, as well as customise decimal and thousand separators.

Let’s see how the previous estimates are updated afterwars:
    
    
    # Formatting estimate values
    result <- result |>
      [formatEstimateValue](../reference/formatEstimateValue.html)(
        decimals = [c](https://rdrr.io/r/base/c.html)(integer = 0, numeric = 4, percentage = 2),
        decimalMark = ".",
        bigMark = ","
      )
    
    # Displaying the formatted subset
    result |> 
      [filterGroup](https://darwin-eu.github.io/omopgenerics/reference/filterGroup.html)(cohort_name == "cohort1") |>  
      [filterStrata](https://darwin-eu.github.io/omopgenerics/reference/filterStrata.html)(age_group == "<40", sex == "Female") |> 
      [select](https://dplyr.tidyverse.org/reference/select.html)(variable_name, variable_level, estimate_name, estimate_type, estimate_value)
    #> # A tibble: 7 × 5
    #>   variable_name   variable_level estimate_name estimate_type estimate_value
    #>   <chr>           <chr>          <chr>         <chr>         <chr>         
    #> 1 number subjects NA             count         integer       9,082,078     
    #> 2 age             NA             mean          numeric       21.2143       
    #> 3 age             NA             sd            numeric       4.1127        
    #> 4 Medications     Amoxiciline    count         integer       51,863        
    #> 5 Medications     Amoxiciline    percentage    percentage    89.22         
    #> 6 Medications     Ibuprofen      count         integer       87,627        
    #> 7 Medications     Ibuprofen      percentage    percentage    73.18

As you can see, the estimates now reflect the specified formatting rules.

#### 1.3) Estimate names

Next, we will format the estimate names using the `[formatEstimateName()](../reference/formatEstimateName.html)` function. This function allows us to combine counts and percentages as “N (%)”, among other estimate combinations
    
    
    # Formatting estimate names
    result <- result |> 
      [formatEstimateName](../reference/formatEstimateName.html)(
        estimateName = [c](https://rdrr.io/r/base/c.html)(
          "N (%)" = "<count> (<percentage>%)", 
          "N" = "<count>",
          "Mean (SD)" = "<mean> (<sd>)"
        ),
        keepNotFormatted = TRUE,
        useFormatOrder = FALSE
      )
    
    # Displaying the formatted subset with new estimate names
    result |> 
      [filterGroup](https://darwin-eu.github.io/omopgenerics/reference/filterGroup.html)(cohort_name == "cohort1") |>  
      [filterStrata](https://darwin-eu.github.io/omopgenerics/reference/filterStrata.html)(age_group == "<40", sex == "Female") |> 
      [select](https://dplyr.tidyverse.org/reference/select.html)(variable_name, variable_level, estimate_name, estimate_type, estimate_value)
    #> # A tibble: 4 × 5
    #>   variable_name   variable_level estimate_name estimate_type estimate_value  
    #>   <chr>           <chr>          <chr>         <chr>         <chr>           
    #> 1 number subjects NA             N             character     9,082,078       
    #> 2 age             NA             Mean (SD)     character     21.2143 (4.1127)
    #> 3 Medications     Amoxiciline    N (%)         character     51,863 (89.22%) 
    #> 4 Medications     Ibuprofen      N (%)         character     87,627 (73.18%)

Now, the estimate names are displayed as specified, such as “N (%)” for counts and percentages. The `keepNotFormatted` argument ensures that unformatted rows remain in the dataset, while `useFormatOrder` allows control over the display order of the estimates.

### 2) Format Header

`[formatHeader()](../reference/formatHeader.html)` is used to create complex multi-level headers for tables, making it easy to present grouped data clearly.

#### Header levels

There are 3 different levels of headers, each identified with the following keys:

  * `header`: Custom labels that do not correspond to column names or table values.

  * `header_name`: Labels derived from column names. Can be omitted with `includeHeaderName = FALSE`.

  * `header_level`: Labels derived from values within columns set in `header`.




These keys, together with a delimiter between header levels (`delim`) are used in `[formatTable()](../reference/formatTable.html)` to format and style `gt` or `flextable` tables.

Let’s create a multi-level header for the strata columns, including all three keys. This will show how the column names are transformed:
    
    
    result |>
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)([across](https://dplyr.tidyverse.org/reference/across.html)([c](https://rdrr.io/r/base/c.html)("strata_name", "strata_level"), ~ [gsub](https://rdrr.io/r/base/grep.html)("&&&", "and", .x))) |>
      [formatHeader](../reference/formatHeader.html)(
        header = [c](https://rdrr.io/r/base/c.html)("Stratifications", "strata_name", "strata_level"),
        delim = "\n",
        includeHeaderName = TRUE,
        includeHeaderKey = TRUE
      ) |> 
      [colnames](https://rdrr.io/r/base/colnames.html)()
    #>  [1] "result_id"                                                                                                                                   
    #>  [2] "cdm_name"                                                                                                                                    
    #>  [3] "group_name"                                                                                                                                  
    #>  [4] "group_level"                                                                                                                                 
    #>  [5] "variable_name"                                                                                                                               
    #>  [6] "variable_level"                                                                                                                              
    #>  [7] "estimate_name"                                                                                                                               
    #>  [8] "estimate_type"                                                                                                                               
    #>  [9] "additional_name"                                                                                                                             
    #> [10] "additional_level"                                                                                                                            
    #> [11] "[header]Stratifications\n[header_name]strata_name\n[header_level]age_group and sex\n[header_name]strata_level\n[header_level]<40 and Male"   
    #> [12] "[header]Stratifications\n[header_name]strata_name\n[header_level]age_group and sex\n[header_name]strata_level\n[header_level]>=40 and Male"  
    #> [13] "[header]Stratifications\n[header_name]strata_name\n[header_level]age_group and sex\n[header_name]strata_level\n[header_level]<40 and Female" 
    #> [14] "[header]Stratifications\n[header_name]strata_name\n[header_level]age_group and sex\n[header_name]strata_level\n[header_level]>=40 and Female"

For the table we are formatting, we won’t include the `header_name` labels. Let’s see how it looks when we exclude them:
    
    
    result <- result |>
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)([across](https://dplyr.tidyverse.org/reference/across.html)([c](https://rdrr.io/r/base/c.html)("strata_name", "strata_level"), ~ [gsub](https://rdrr.io/r/base/grep.html)("&&&", "and", .x))) |>
      [formatHeader](../reference/formatHeader.html)(
        header = [c](https://rdrr.io/r/base/c.html)("Stratifications", "strata_name", "strata_level"),
        delim = "\n",
        includeHeaderName = FALSE,
        includeHeaderKey = TRUE
      )  
    
    [colnames](https://rdrr.io/r/base/colnames.html)(result)
    #>  [1] "result_id"                                                                              
    #>  [2] "cdm_name"                                                                               
    #>  [3] "group_name"                                                                             
    #>  [4] "group_level"                                                                            
    #>  [5] "variable_name"                                                                          
    #>  [6] "variable_level"                                                                         
    #>  [7] "estimate_name"                                                                          
    #>  [8] "estimate_type"                                                                          
    #>  [9] "additional_name"                                                                        
    #> [10] "additional_level"                                                                       
    #> [11] "[header]Stratifications\n[header_level]age_group and sex\n[header_level]<40 and Male"   
    #> [12] "[header]Stratifications\n[header_level]age_group and sex\n[header_level]>=40 and Male"  
    #> [13] "[header]Stratifications\n[header_level]age_group and sex\n[header_level]<40 and Female" 
    #> [14] "[header]Stratifications\n[header_level]age_group and sex\n[header_level]>=40 and Female"

### 3) Format Table

`[formatTable()](../reference/formatTable.html)` function is the final step in the formatting pipeline, where the formatted `<data.frame>` is converted to either a `<gt>` or `<flextable>`.

#### Prepare data

Before using `[formatTable()](../reference/formatTable.html)`, we’ll tidy the `<data.frame>` by splitting the group and additional name-level columns (see vignette on tidying `<summarised_result>`), and drop some unwanted columns:
    
    
    result <- result |>
      [splitGroup](https://darwin-eu.github.io/omopgenerics/reference/splitGroup.html)() |>
      [splitAdditional](https://darwin-eu.github.io/omopgenerics/reference/splitAdditional.html)() |>
      [select](https://dplyr.tidyverse.org/reference/select.html)(![c](https://rdrr.io/r/base/c.html)("result_id", "estimate_type", "cdm_name"))
    [head](https://rdrr.io/r/utils/head.html)(result)
    #> # A tibble: 6 × 8
    #>   cohort_name variable_name  variable_level estimate_name [header]Stratificati…¹
    #>   <chr>       <chr>          <chr>          <chr>         <chr>                 
    #> 1 cohort1     number subjec… NA             N             3,721,239             
    #> 2 cohort2     number subjec… NA             N             2,059,746             
    #> 3 cohort1     age            NA             Mean (SD)     77.7445 (1.0794)      
    #> 4 cohort2     age            NA             Mean (SD)     86.9691 (0.2333)      
    #> 5 cohort1     Medications    Amoxiciline    N (%)         9,947 (33.38%)        
    #> 6 cohort2     Medications    Amoxiciline    N (%)         65,087 (40.00%)       
    #> # ℹ abbreviated name:
    #> #   ¹​`[header]Stratifications\n[header_level]age_group and sex\n[header_level]<40 and Male`
    #> # ℹ 3 more variables:
    #> #   `[header]Stratifications\n[header_level]age_group and sex\n[header_level]>=40 and Male` <chr>,
    #> #   `[header]Stratifications\n[header_level]age_group and sex\n[header_level]<40 and Female` <chr>,
    #> #   `[header]Stratifications\n[header_level]age_group and sex\n[header_level]>=40 and Female` <chr>

#### Use `formatTable()`

Now that the data is cleaned and organized, `[formatTable()](../reference/formatTable.html)` can be used to create a well-structured `<gt>`, `<flextable>`, `datatable`, or `reactable`` objects.
    
    
    result |>
      [formatTable](../reference/formatTable.html)(
        type = "gt",
        delim = "\n",
        style = "default",
        na = "-",
        title = "My formatted table!",
        subtitle = "Created with the `visOmopResults` R package.",
        caption = NULL,
        groupColumn = "cohort_name",
        groupAsColumn = FALSE,
        groupOrder = [c](https://rdrr.io/r/base/c.html)("cohort2", "cohort1"),
        merge = "variable_name"
      )

My formatted table!  
---  
Created with the `visOmopResults` R package.  
|  Stratifications  
variable_name | variable_level | estimate_name |  age_group and sex  
<40 and Male | >=40 and Male | <40 and Female | >=40 and Female  
cohort2  
number subjects | - | N | 2,059,746 | 1,765,568 | 6,870,228 | 3,841,037  
age | - | Mean (SD) | 86.9691 (0.2333) | 34.0349 (4.7723) | 48.2080 (7.3231) | 59.9566 (6.9273)  
Medications | Amoxiciline | N (%) | 65,087 (40.00%) | 25,802 (32.54%) | 47,855 (75.71%) | 76,631 (20.27%)  
| Ibuprofen | N (%) | 65,472 (44.63%) | 35,320 (64.01%) | 27,026 (99.18%) | 99,268 (49.56%)  
cohort1  
number subjects | - | N | 3,721,239 | 5,728,534 | 9,082,078 | 2,016,819  
age | - | Mean (SD) | 77.7445 (1.0794) | 93.4705 (7.2371) | 21.2143 (4.1127) | 65.1674 (8.2095)  
Medications | Amoxiciline | N (%) | 9,947 (33.38%) | 31,627 (47.64%) | 51,863 (89.22%) | 66,201 (86.43%)  
| Ibuprofen | N (%) | 5,893 (59.88%) | 64,229 (97.62%) | 87,627 (73.18%) | 77,891 (35.67%)  
  
In the examples above, we used the default style defined in the _visOmopResults_ package (use `[tableStyle()](../reference/tableStyle.html)` to see these styles). However, it’s possible to customise the appearance of different parts of the table to better suit your needs.

#### customising Table Styles

Let’s start by applying a custom style to a `<gt>` table:
    
    
    result |>
      [formatTable](../reference/formatTable.html)(
        type = "gt",
        delim = "\n",
        style = [list](https://rdrr.io/r/base/list.html)(
          "header" = [list](https://rdrr.io/r/base/list.html)(gt::[cell_text](https://gt.rstudio.com/reference/cell_text.html)(weight = "bold"), 
                          gt::[cell_fill](https://gt.rstudio.com/reference/cell_fill.html)(color = "orange")),
          "header_level" = [list](https://rdrr.io/r/base/list.html)(gt::[cell_text](https://gt.rstudio.com/reference/cell_text.html)(weight = "bold"), 
                          gt::[cell_fill](https://gt.rstudio.com/reference/cell_fill.html)(color = "yellow")),
          "column_name" = gt::[cell_text](https://gt.rstudio.com/reference/cell_text.html)(weight = "bold"),
          "group_label" = [list](https://rdrr.io/r/base/list.html)(gt::[cell_fill](https://gt.rstudio.com/reference/cell_fill.html)(color = "blue"),
                               gt::[cell_text](https://gt.rstudio.com/reference/cell_text.html)(color = "white", weight = "bold")),
          "title" = [list](https://rdrr.io/r/base/list.html)(gt::[cell_text](https://gt.rstudio.com/reference/cell_text.html)(size = 20, weight = "bold")),
          "subtitle" = [list](https://rdrr.io/r/base/list.html)(gt::[cell_text](https://gt.rstudio.com/reference/cell_text.html)(size = 15)),
          "body" = gt::[cell_text](https://gt.rstudio.com/reference/cell_text.html)(color = "red")
        ),
        na = "-",
        title = "My formatted table!",
        subtitle = "Created with the `visOmopResults` R package.",
        caption = NULL,
        groupColumn = "cohort_name",
        groupAsColumn = FALSE,
        groupOrder = [c](https://rdrr.io/r/base/c.html)("cohort2", "cohort1"),
        merge = "variable_name"
      )

My formatted table!  
---  
Created with the `visOmopResults` R package.  
|  Stratifications  
variable_name | variable_level | estimate_name |  age_group and sex  
<40 and Male | >=40 and Male | <40 and Female | >=40 and Female  
cohort2  
number subjects | - | N | 2,059,746 | 1,765,568 | 6,870,228 | 3,841,037  
age | - | Mean (SD) | 86.9691 (0.2333) | 34.0349 (4.7723) | 48.2080 (7.3231) | 59.9566 (6.9273)  
Medications | Amoxiciline | N (%) | 65,087 (40.00%) | 25,802 (32.54%) | 47,855 (75.71%) | 76,631 (20.27%)  
| Ibuprofen | N (%) | 65,472 (44.63%) | 35,320 (64.01%) | 27,026 (99.18%) | 99,268 (49.56%)  
cohort1  
number subjects | - | N | 3,721,239 | 5,728,534 | 9,082,078 | 2,016,819  
age | - | Mean (SD) | 77.7445 (1.0794) | 93.4705 (7.2371) | 21.2143 (4.1127) | 65.1674 (8.2095)  
Medications | Amoxiciline | N (%) | 9,947 (33.38%) | 31,627 (47.64%) | 51,863 (89.22%) | 66,201 (86.43%)  
| Ibuprofen | N (%) | 5,893 (59.88%) | 64,229 (97.62%) | 87,627 (73.18%) | 77,891 (35.67%)  
  
For creating a similarly styled `<flextable>`, the [`office`](https://CRAN.R-project.org/package=officer) R package is required to access specific formatting functions.
    
    
    result |>
      [formatTable](../reference/formatTable.html)(
        type = "flextable",
        delim = "\n",
        style = [list](https://rdrr.io/r/base/list.html)(
          "header" = [list](https://rdrr.io/r/base/list.html)(
            "cell" = officer::[fp_cell](https://davidgohel.github.io/officer/reference/fp_cell.html)(background.color = "orange"),
            "text" = officer::[fp_text](https://davidgohel.github.io/officer/reference/fp_text.html)(bold = TRUE)),
          "header_level" = [list](https://rdrr.io/r/base/list.html)(
            "cell" = officer::[fp_cell](https://davidgohel.github.io/officer/reference/fp_cell.html)(background.color = "yellow"),
            "text" = officer::[fp_text](https://davidgohel.github.io/officer/reference/fp_text.html)(bold = TRUE)),
          "column_name" = [list](https://rdrr.io/r/base/list.html)("text" = officer::[fp_text](https://davidgohel.github.io/officer/reference/fp_text.html)(bold = TRUE)),
          "group_label" = [list](https://rdrr.io/r/base/list.html)(
            "cell" = officer::[fp_cell](https://davidgohel.github.io/officer/reference/fp_cell.html)(background.color = "blue"),
            "text" = officer::[fp_text](https://davidgohel.github.io/officer/reference/fp_text.html)(bold = TRUE, color = "white")),
          "title" = [list](https://rdrr.io/r/base/list.html)("text" = officer::[fp_text](https://davidgohel.github.io/officer/reference/fp_text.html)(bold = TRUE, font.size = 20)),
          "subtitle" = [list](https://rdrr.io/r/base/list.html)("text" = officer::[fp_text](https://davidgohel.github.io/officer/reference/fp_text.html)(font.size = 15)),
          "body" = [list](https://rdrr.io/r/base/list.html)("text" = officer::[fp_text](https://davidgohel.github.io/officer/reference/fp_text.html)(color = "red"))
        ),
        na = "-",
        title = "My formatted table!",
        subtitle = "Created with the `visOmopResults` R package.",
        caption = NULL,
        groupColumn = "cohort_name",
        groupAsColumn = FALSE,
        groupOrder = [c](https://rdrr.io/r/base/c.html)("cohort2", "cohort1"),
        merge = "variable_name"
      )

My formatted table!  
---  
Created with the `visOmopResults` R package.  
variable_name | variable_level | estimate_name | Stratifications  
age_group and sex  
<40 and Male | >=40 and Male | <40 and Female | >=40 and Female  
cohort2  
number subjects | - | N | 2,059,746 | 1,765,568 | 6,870,228 | 3,841,037  
age | - | Mean (SD) | 86.9691 (0.2333) | 34.0349 (4.7723) | 48.2080 (7.3231) | 59.9566 (6.9273)  
Medications | Amoxiciline | N (%) | 65,087 (40.00%) | 25,802 (32.54%) | 47,855 (75.71%) | 76,631 (20.27%)  
| Ibuprofen | N (%) | 65,472 (44.63%) | 35,320 (64.01%) | 27,026 (99.18%) | 99,268 (49.56%)  
cohort1  
number subjects | - | N | 3,721,239 | 5,728,534 | 9,082,078 | 2,016,819  
age | - | Mean (SD) | 77.7445 (1.0794) | 93.4705 (7.2371) | 21.2143 (4.1127) | 65.1674 (8.2095)  
Medications | Amoxiciline | N (%) | 9,947 (33.38%) | 31,627 (47.64%) | 51,863 (89.22%) | 66,201 (86.43%)  
| Ibuprofen | N (%) | 5,893 (59.88%) | 64,229 (97.62%) | 87,627 (73.18%) | 77,891 (35.67%)  
  
## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
