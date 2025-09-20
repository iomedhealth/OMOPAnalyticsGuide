# Content from https://darwin-eu.github.io/visOmopResults/


---

## Content from https://darwin-eu.github.io/visOmopResults/

Skip to contents

[visOmopResults](index.html) 1.2.0

  * [Reference](reference/index.html)
  * Articles
    * [Tables](articles/a01_tables.html)
    * [Plots](articles/a02_plots.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](logo.png)

# visOmopResults 

## Package overview

**visOmopResults** offers a set of functions tailored to format objects of class `<summarised_result>` (as defined in [omopgenerics](https://darwin-eu.github.io/omopgenerics/articles/summarised_result.html) package).

It provides functionalities to create formatted **tables** and generate **plots**. These visualisations are highly versatile for reporting results through Shiny apps, RMarkdown, Quarto, and more, supporting various output formats such as HTML, PNG, Word, and PDF.

## Let’s get started

You can install the latest version of **visOmopResults** from CRAN:
    
    
    [install.packages](https://rdrr.io/r/utils/install.packages.html)("visOmopResults")

Or you can install the development version from [GitHub](https://github.com/darwin-eu/visOmopResults) with:
    
    
    # install.packages("pak")
    pak::[pkg_install](https://pak.r-lib.org/reference/pkg_install.html)("darwin-eu/visOmopResults")

The `<summarised_result>` is a standardised output format utilized across various packages, including:

  * [CohortCharacteristics](https://cran.r-project.org/package=CohortCharacteristics)
  * [DrugUtilisation](https://cran.r-project.org/package=DrugUtilisation)
  * [IncidencePrevalence](https://cran.r-project.org/package=IncidencePrevalence)
  * [PatientProfiles](https://cran.r-project.org/package=PatientProfiles)
  * [CodelistGenerator](https://cran.r-project.org/package=CodelistGenerator)
  * [CohortSurvival](https://cran.r-project.org/package=CohortSurvival)
  * [CohortSymmetry](https://cran.r-project.org/package=CohortSymmetry)



Although this standard output format is essential, it can sometimes be challenging to manage. The **visOmopResults** package aims to simplify this process. To demonstrate the package’s functionality, let’s start by using some mock results:
    
    
    [library](https://rdrr.io/r/base/library.html)([visOmopResults](https://darwin-eu.github.io/visOmopResults/))
    result <- [mockSummarisedResult](reference/mockSummarisedResult.html)()

## Tables visualisations

Currently all table functionalities are built around 4 packages: [tibble](https://cran.r-project.org/package=tibble), [gt](https://cran.r-project.org/package=gt), [flextable](https://cran.r-project.org/package=flextable), and [datatable](https://CRAN.R-project.org/package=DT).

There are two main functions:

  * `[visOmopTable()](reference/visOmopTable.html)`: Creates a well-formatted table specifically from a `<summarised_result>` object.
  * `[visTable()](reference/visTable.html)`: Creates a nicely formatted table from any `<data.frame>` object.



Let’s see a simple example:
    
    
    result |>
      [filterStrata](https://darwin-eu.github.io/omopgenerics/reference/filterStrata.html)(sex != "overall" & age_group != "overall") |>
      [visOmopTable](reference/visOmopTable.html)(
        type = "flextable",
        estimateName = [c](https://rdrr.io/r/base/c.html)(
          "N(%)" = "<count> (<percentage>%)", 
          "N" = "<count>", 
          "mean (sd)" = "<mean> (<sd>)"),
        header = [c](https://rdrr.io/r/base/c.html)("sex", "age_group"),
        settingsColumn = NULL,
        groupColumn = [c](https://rdrr.io/r/base/c.html)("cohort_name"),
        rename = [c](https://rdrr.io/r/base/c.html)("Variable" = "variable_name", " " = "variable_level"),
        hide = "cdm_name",
        style = "darwin"
      )

![](reference/figures/README-unnamed-chunk-5-1.png)

## Plots visualisations

Currently all plot functionalities are built around [ggplot2](https://cran.r-project.org/package=ggplot2). The output of these plot functions is a `<ggplot2>` object that can be further customised.

There are three plotting functions:

  * `plotScatter()` to create a scatter plot.
  * `plotBar()` to create a bar plot.
  * `plotBox()` to create a box plot.



Additionally, the `[themeVisOmop()](reference/themeVisOmop.html)` function applies a consistent styling to the plots, aligning them with the package’s visual design.

Let’s see how we can create a simple boxplot for age:
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    result |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "number subjects") |>
      [filterStrata](https://darwin-eu.github.io/omopgenerics/reference/filterStrata.html)(sex != "overall") |>
      [barPlot](reference/barPlot.html)(
        x = "age_group", 
        y = "count",
        facet = "cohort_name", 
        colour = "sex",
        style = "darwin"
      )

![](reference/figures/README-unnamed-chunk-6-1.png)

## Links

  * [View on CRAN](https://cloud.r-project.org/package=visOmopResults)
  * [Browse source code](https://github.com/darwin-eu/visOmopResults/)
  * [Report a bug](https://github.com/darwin-eu/visOmopResults/issues)



## License

  * [Full license](LICENSE.html)
  * Apache License (>= 2)



## Citation

  * [Citing visOmopResults](authors.html#citation)



## Developers

  * Martí Català   
Author  [](https://orcid.org/0000-0003-3308-9905)
  * Núria Mercadé-Besora   
Author, maintainer  [](https://orcid.org/0009-0006-7948-3747)
  * [More about authors...](authors.html)



## Dev status

  * [![R-CMD-check](https://github.com/darwin-eu/visOmopResults/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/darwin-eu/visOmopResults/actions/workflows/R-CMD-check.yaml)
  * [![CRAN status](https://www.r-pkg.org/badges/version/visOmopResults)](https://CRAN.R-project.org/package=visOmopResults)
  * [![Lifecycle:stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
  * [![Codecov test coverage](https://codecov.io/gh/darwin-eu/visOmopResults/branch/main/graph/badge.svg)](https://app.codecov.io/gh/darwin-eu/visOmopResults?branch=main)



Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/index.html

Skip to contents

[visOmopResults](index.html) 1.2.0

  * [Reference](reference/index.html)
  * Articles
    * [Tables](articles/a01_tables.html)
    * [Plots](articles/a02_plots.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](logo.png)

# visOmopResults 

## Package overview

**visOmopResults** offers a set of functions tailored to format objects of class `<summarised_result>` (as defined in [omopgenerics](https://darwin-eu.github.io/omopgenerics/articles/summarised_result.html) package).

It provides functionalities to create formatted **tables** and generate **plots**. These visualisations are highly versatile for reporting results through Shiny apps, RMarkdown, Quarto, and more, supporting various output formats such as HTML, PNG, Word, and PDF.

## Let’s get started

You can install the latest version of **visOmopResults** from CRAN:
    
    
    [install.packages](https://rdrr.io/r/utils/install.packages.html)("visOmopResults")

Or you can install the development version from [GitHub](https://github.com/darwin-eu/visOmopResults) with:
    
    
    # install.packages("pak")
    pak::[pkg_install](https://pak.r-lib.org/reference/pkg_install.html)("darwin-eu/visOmopResults")

The `<summarised_result>` is a standardised output format utilized across various packages, including:

  * [CohortCharacteristics](https://cran.r-project.org/package=CohortCharacteristics)
  * [DrugUtilisation](https://cran.r-project.org/package=DrugUtilisation)
  * [IncidencePrevalence](https://cran.r-project.org/package=IncidencePrevalence)
  * [PatientProfiles](https://cran.r-project.org/package=PatientProfiles)
  * [CodelistGenerator](https://cran.r-project.org/package=CodelistGenerator)
  * [CohortSurvival](https://cran.r-project.org/package=CohortSurvival)
  * [CohortSymmetry](https://cran.r-project.org/package=CohortSymmetry)



Although this standard output format is essential, it can sometimes be challenging to manage. The **visOmopResults** package aims to simplify this process. To demonstrate the package’s functionality, let’s start by using some mock results:
    
    
    [library](https://rdrr.io/r/base/library.html)([visOmopResults](https://darwin-eu.github.io/visOmopResults/))
    result <- [mockSummarisedResult](reference/mockSummarisedResult.html)()

## Tables visualisations

Currently all table functionalities are built around 4 packages: [tibble](https://cran.r-project.org/package=tibble), [gt](https://cran.r-project.org/package=gt), [flextable](https://cran.r-project.org/package=flextable), and [datatable](https://CRAN.R-project.org/package=DT).

There are two main functions:

  * `[visOmopTable()](reference/visOmopTable.html)`: Creates a well-formatted table specifically from a `<summarised_result>` object.
  * `[visTable()](reference/visTable.html)`: Creates a nicely formatted table from any `<data.frame>` object.



Let’s see a simple example:
    
    
    result |>
      [filterStrata](https://darwin-eu.github.io/omopgenerics/reference/filterStrata.html)(sex != "overall" & age_group != "overall") |>
      [visOmopTable](reference/visOmopTable.html)(
        type = "flextable",
        estimateName = [c](https://rdrr.io/r/base/c.html)(
          "N(%)" = "<count> (<percentage>%)", 
          "N" = "<count>", 
          "mean (sd)" = "<mean> (<sd>)"),
        header = [c](https://rdrr.io/r/base/c.html)("sex", "age_group"),
        settingsColumn = NULL,
        groupColumn = [c](https://rdrr.io/r/base/c.html)("cohort_name"),
        rename = [c](https://rdrr.io/r/base/c.html)("Variable" = "variable_name", " " = "variable_level"),
        hide = "cdm_name",
        style = "darwin"
      )

![](reference/figures/README-unnamed-chunk-5-1.png)

## Plots visualisations

Currently all plot functionalities are built around [ggplot2](https://cran.r-project.org/package=ggplot2). The output of these plot functions is a `<ggplot2>` object that can be further customised.

There are three plotting functions:

  * `plotScatter()` to create a scatter plot.
  * `plotBar()` to create a bar plot.
  * `plotBox()` to create a box plot.



Additionally, the `[themeVisOmop()](reference/themeVisOmop.html)` function applies a consistent styling to the plots, aligning them with the package’s visual design.

Let’s see how we can create a simple boxplot for age:
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    result |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "number subjects") |>
      [filterStrata](https://darwin-eu.github.io/omopgenerics/reference/filterStrata.html)(sex != "overall") |>
      [barPlot](reference/barPlot.html)(
        x = "age_group", 
        y = "count",
        facet = "cohort_name", 
        colour = "sex",
        style = "darwin"
      )

![](reference/figures/README-unnamed-chunk-6-1.png)

## Links

  * [View on CRAN](https://cloud.r-project.org/package=visOmopResults)
  * [Browse source code](https://github.com/darwin-eu/visOmopResults/)
  * [Report a bug](https://github.com/darwin-eu/visOmopResults/issues)



## License

  * [Full license](LICENSE.html)
  * Apache License (>= 2)



## Citation

  * [Citing visOmopResults](authors.html#citation)



## Developers

  * Martí Català   
Author  [](https://orcid.org/0000-0003-3308-9905)
  * Núria Mercadé-Besora   
Author, maintainer  [](https://orcid.org/0009-0006-7948-3747)
  * [More about authors...](authors.html)



## Dev status

  * [![R-CMD-check](https://github.com/darwin-eu/visOmopResults/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/darwin-eu/visOmopResults/actions/workflows/R-CMD-check.yaml)
  * [![CRAN status](https://www.r-pkg.org/badges/version/visOmopResults)](https://CRAN.R-project.org/package=visOmopResults)
  * [![Lifecycle:stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
  * [![Codecov test coverage](https://codecov.io/gh/darwin-eu/visOmopResults/branch/main/graph/badge.svg)](https://app.codecov.io/gh/darwin-eu/visOmopResults?branch=main)



Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/index.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Package index

## Table functions

### Main functions

`[visOmopTable()](visOmopTable.html)`
    Generate a formatted table from a `<summarised_result>`

`[visTable()](visTable.html)`
    Generate a formatted table from a `<data.table>`

### Additional table formating functions

`[formatEstimateName()](formatEstimateName.html)`
    Formats estimate_name and estimate_value column

`[formatEstimateValue()](formatEstimateValue.html)`
    Formats the estimate_value column

`[formatHeader()](formatHeader.html)`
    Create a header for gt and flextable objects

`[formatMinCellCount()](formatMinCellCount.html)`
    To indicate which was the minimum cell counts where estimates have been suppressed.

`[formatTable()](formatTable.html)`
    Creates a flextable or gt object from a dataframe

### Helper table functions

`[emptyTable()](emptyTable.html)`
    Returns an empty table

`[setGlobalTableOptions()](setGlobalTableOptions.html)`
    Set format options for all subsequent tables

`[tableColumns()](tableColumns.html)`
    Columns for the table functions

`[tableOptions()](tableOptions.html)`
    Additional table formatting options for `[visOmopTable()](../reference/visOmopTable.html)` and `[visTable()](../reference/visTable.html)`

`[tableStyle()](tableStyle.html)`
    Supported predefined styles for formatted tables

`[tableType()](tableType.html)`
    Supported table classes

## Plot functions

`[barPlot()](barPlot.html)`
    Create a bar plot visualisation from a `<summarised_result>` object

`[boxPlot()](boxPlot.html)`
    Create a box plot visualisation from a `<summarised_result>` object

`[emptyPlot()](emptyPlot.html)`
    Returns an empty plot

`[scatterPlot()](scatterPlot.html)`
    Create a scatter plot visualisation from a `<summarised_result>` object

### Helper plot functions

`[plotColumns()](plotColumns.html)`
    Columns for the plot functions

`[setGlobalPlotOptions()](setGlobalPlotOptions.html)`
    Set format options for all subsequent plots

`[themeDarwin()](themeDarwin.html)`
    Apply Darwin styling to a ggplot

`[themeVisOmop()](themeVisOmop.html)`
    Apply visOmopResults default styling to a ggplot

## Other functionalities

### To style text

`[customiseText()](customiseText.html)`
    Apply styling to text or column names

### Mock `<summarised_result>`

`[mockSummarisedResult()](mockSummarisedResult.html)`
    A `<summarised_result>` object filled with mock data

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/articles/a01_tables.html

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

---

## Content from https://darwin-eu.github.io/visOmopResults/articles/a02_plots.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Plots

Source: [`vignettes/a02_plots.Rmd`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/vignettes/a02_plots.Rmd)

`a02_plots.Rmd`

**visOmopResults** provides plotting tools that simplify visualising data in `<summarised_result>` format while also being compatible with other formats.
    
    
    [library](https://rdrr.io/r/base/library.html)([visOmopResults](https://darwin-eu.github.io/visOmopResults/))

## Plotting with a `<summarised_result>`

For this vignette, we will use the `penguins` dataset from the **palmerpenguins** package. This dataset will be summarised using the `[PatientProfiles::summariseResult()](https://darwin-eu.github.io/PatientProfiles/reference/summariseResult.html)` function, which aggregates the data into the `<summarised_result>` format:
    
    
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([palmerpenguins](https://allisonhorst.github.io/palmerpenguins/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    summariseIsland <- function(island) {
      penguins |>
        [filter](https://dplyr.tidyverse.org/reference/filter.html)(.data$island == .env$island) |>
        [summariseResult](https://darwin-eu.github.io/PatientProfiles/reference/summariseResult.html)(
          group = "species",
          includeOverallGroup = TRUE,
          strata = [list](https://rdrr.io/r/base/list.html)("year", "sex", [c](https://rdrr.io/r/base/c.html)("year", "sex")),
          variables = [c](https://rdrr.io/r/base/c.html)(
            "bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g", 
            "sex"),
          estimates = [c](https://rdrr.io/r/base/c.html)(
            "median", "q25", "q75", "min", "max", "count_missing", "count", 
            "percentage", "density")
        ) |>
        [suppressMessages](https://rdrr.io/r/base/message.html)() |>
        [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(cdm_name = island)
    }
    
    penguinsSummary <- [bind](https://darwin-eu.github.io/omopgenerics/reference/bind.html)(
      summariseIsland("Torgersen"), 
      summariseIsland("Biscoe"), 
      summariseIsland("Dream")
    )
    
    penguinsSummary |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 429,296
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "Torgersen", "Torgersen", "Torgersen", "Torgersen", "…
    #> $ group_name       <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ group_level      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "number records", "bill_length_mm", "bill_length_mm",…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, "density_001", "density_0…
    #> $ estimate_name    <chr> "count", "median", "q25", "q75", "min", "max", "count…
    #> $ estimate_type    <chr> "integer", "numeric", "numeric", "numeric", "numeric"…
    #> $ estimate_value   <chr> "52", "38.9", "36.65", "41.1", "33.5", "46", "1", "29…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…

### Plotting principles for `<summarised_result>` objects

**1) Tidy Format**  
When working with `<summarised_result>` objects, the data is internally converted into the tidy format before plotting. This is an important distinction because columns such as `strata_name` and `strata_level` from the original `<summarised_result>` cannot be used directly with the plotting functions. Instead, tidy columns should be referenced.

For more information about the tidy format, refer to the **omopgenerics** package vignette on `<summarised_result>` [here](https://darwin-eu.github.io/omopgenerics/articles/summarised_result.html#tidy-a-summarised_result).

To identify the available tidy columns, use the `[tidyColumns()](https://darwin-eu.github.io/omopgenerics/reference/tidyColumns.html)` function:
    
    
    [tidyColumns](https://darwin-eu.github.io/omopgenerics/reference/tidyColumns.html)(penguinsSummary)
    #>  [1] "cdm_name"       "species"        "year"           "sex"           
    #>  [5] "variable_name"  "variable_level" "count"          "median"        
    #>  [9] "q25"            "q75"            "min"            "max"           
    #> [13] "count_missing"  "density_x"      "density_y"      "percentage"

**2) Subsetting Variables**  
Before calling the plotting functions, always subset the `<summarised_result>` object to the variable of interest. Avoid combining results from unrelated variables, as this may lead to NA values in the tidy format, which can affect your plots.

### Scatter plot

We can create simple scatter plots using the `plotScatter()` let’s see some examples:
    
    
    penguinsSummary |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "bill_depth_mm") |>
      [filterStrata](https://darwin-eu.github.io/omopgenerics/reference/filterStrata.html)(year != "overall", sex == "overall") |>
      [scatterPlot](../reference/scatterPlot.html)(
        x = "year", 
        y = "median",
        line = TRUE, 
        point = TRUE,
        ribbon = FALSE,
        facet = "cdm_name",
        colour = "species"
      )

![](a02_plots_files/figure-html/unnamed-chunk-4-1.png)

We can use the argument `style` to update the theme of the plot to either the visOmopResults _default_ style, or our _darwin_ style.
    
    
    penguinsSummary |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name [%in%](https://rdrr.io/r/base/match.html) [c](https://rdrr.io/r/base/c.html)("bill_length_mm", "bill_depth_mm"))|>
      [filterStrata](https://darwin-eu.github.io/omopgenerics/reference/filterStrata.html)(year == "overall", sex == "overall") |>
      [filterGroup](https://darwin-eu.github.io/omopgenerics/reference/filterGroup.html)(species != "overall") |>
      [scatterPlot](../reference/scatterPlot.html)(
        x = "density_x", 
        y = "density_y",
        line = TRUE, 
        point = FALSE,
        ribbon = FALSE,
        facet = cdm_name ~ variable_name,
        colour = "species",
        style = "darwin"
      ) 

![](a02_plots_files/figure-html/unnamed-chunk-5-1.png)

Otherwise, the style can be applied afterwards with the functions `themeVisOmop` and `themeDarwin`. Not only that, but the returned plot can be futher customised with the usual ggplot2 functionalities:
    
    
    penguinsSummary |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "flipper_length_mm") |>
      [filterStrata](https://darwin-eu.github.io/omopgenerics/reference/filterStrata.html)(year != "overall", sex [%in%](https://rdrr.io/r/base/match.html) [c](https://rdrr.io/r/base/c.html)("female", "male")) |>
      [scatterPlot](../reference/scatterPlot.html)(
        x = [c](https://rdrr.io/r/base/c.html)("year", "sex"), 
        y = "median",
        ymin = "q25",
        ymax = "q75",
        line = FALSE, 
        point = TRUE,
        ribbon = FALSE,
        facet = cdm_name ~ species,
        colour = "sex",
        group = [c](https://rdrr.io/r/base/c.html)("year", "sex")
      )  +
      [themeVisOmop](../reference/themeVisOmop.html)(fontsizeRef = 13) +
      ggplot2::[coord_flip](https://ggplot2.tidyverse.org/reference/coord_flip.html)() +
      ggplot2::[labs](https://ggplot2.tidyverse.org/reference/labs.html)(y = "Flipper length (mm)") + 
      ggplot2::[theme](https://ggplot2.tidyverse.org/reference/theme.html)(axis.text.x = ggplot2::[element_text](https://ggplot2.tidyverse.org/reference/element.html)(angle = 90, vjust = 0.5, hjust=1))

![](a02_plots_files/figure-html/unnamed-chunk-6-1.png)
    
    
    penguinsSummary |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(
        variable_name [%in%](https://rdrr.io/r/base/match.html) [c](https://rdrr.io/r/base/c.html)("flipper_length_mm", "bill_length_mm", "bill_depth_mm")
      ) |>
      [filterStrata](https://darwin-eu.github.io/omopgenerics/reference/filterStrata.html)(sex == "overall") |>
      [scatterPlot](../reference/scatterPlot.html)(
        x = "year", 
        y = "median",
        ymin = "min",
        ymax = "max",
        line = FALSE, 
        point = TRUE,
        ribbon = TRUE,
        facet = cdm_name ~ species,
        colour = "variable_name",
        group = [c](https://rdrr.io/r/base/c.html)("variable_name")
      ) +
      [themeDarwin](../reference/themeDarwin.html)(fontsizeRef = 12) + 
      ggplot2::[theme](https://ggplot2.tidyverse.org/reference/theme.html)(axis.text.x = ggplot2::[element_text](https://ggplot2.tidyverse.org/reference/element.html)(angle = 90, vjust = 0.5, hjust=1))

![](a02_plots_files/figure-html/unnamed-chunk-7-1.png)

### Bar plot

Let’s create a bar plots:
    
    
    penguinsSummary |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "number records") |>
      [filterGroup](https://darwin-eu.github.io/omopgenerics/reference/filterGroup.html)(species != "overall") |>
      [filterStrata](https://darwin-eu.github.io/omopgenerics/reference/filterStrata.html)(sex != "overall", year != "overall") |>
      [barPlot](../reference/barPlot.html)(
        x = "year",
        y = "count",
        colour = "sex",
        facet = cdm_name ~ species
      ) +
      [themeVisOmop](../reference/themeVisOmop.html)(fontsizeRef = 12)

![](a02_plots_files/figure-html/unnamed-chunk-8-1.png)

### Box plot

Let’s create some box plots of their body mass:
    
    
    penguinsSummary |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "body_mass_g") |>
      [boxPlot](../reference/boxPlot.html)(x = "year", facet = species ~ cdm_name, colour = "sex", style = "default")

![](a02_plots_files/figure-html/unnamed-chunk-9-1.png)
    
    
    penguinsSummary |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "body_mass_g") |>
      [filterGroup](https://darwin-eu.github.io/omopgenerics/reference/filterGroup.html)(species != "overall") |>
      [filterStrata](https://darwin-eu.github.io/omopgenerics/reference/filterStrata.html)(sex [%in%](https://rdrr.io/r/base/match.html) [c](https://rdrr.io/r/base/c.html)("female", "male"), year != "overall") |>
      [boxPlot](../reference/boxPlot.html)(x = "cdm_name", facet = [c](https://rdrr.io/r/base/c.html)("sex", "species"), colour = "year") +
      [themeVisOmop](../reference/themeVisOmop.html)(fontsizeRef = 11)

![](a02_plots_files/figure-html/unnamed-chunk-10-1.png)

Note that as we didnt specify x there is no levels in the x axis, but box plots are produced anyway.

## Plotting style

The package provides support for standard plot themes, which can be applied either after plot creation using the functions `[themeVisOmop()](../reference/themeVisOmop.html)` and `[themeDarwin()](../reference/themeDarwin.html)`, or directly at the time of creation via the `style` argument.

For creating multiple plots with the same style, you can use `[setGlobalPlotOptions()](../reference/setGlobalPlotOptions.html)` to apply a default style to all subsequent plots, unless a different style is specified in a specific function call.

## Plotting with a `<data.frame>`

Plotting functions can also be used with the usual `<data.frame>`. In this case we will use the tidy format of `penguinsSummary`.
    
    
    penguinsTidy <- penguinsSummary |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(!estimate_name [%in%](https://rdrr.io/r/base/match.html) [c](https://rdrr.io/r/base/c.html)("density_x", "density_y")) |> # remove density for simplicity
      [tidy](https://generics.r-lib.org/reference/tidy.html)()
    penguinsTidy |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 720
    #> Columns: 14
    #> $ cdm_name       <chr> "Torgersen", "Torgersen", "Torgersen", "Torgersen", "To…
    #> $ species        <chr> "overall", "overall", "overall", "overall", "overall", …
    #> $ year           <chr> "overall", "overall", "overall", "overall", "overall", …
    #> $ sex            <chr> "overall", "overall", "overall", "overall", "overall", …
    #> $ variable_name  <chr> "number records", "bill_length_mm", "bill_depth_mm", "f…
    #> $ variable_level <chr> NA, NA, NA, NA, NA, "female", "male", NA, NA, NA, NA, N…
    #> $ count          <int> 52, NA, NA, NA, NA, 24, 23, 5, 20, 16, 16, NA, NA, NA, …
    #> $ median         <int> NA, 38, 18, 191, 3700, NA, NA, NA, NA, NA, NA, 38, 38, …
    #> $ q25            <int> NA, 36, 17, 187, 3338, NA, NA, NA, NA, NA, NA, 37, 35, …
    #> $ q75            <int> NA, 41, 19, 195, 4000, NA, NA, NA, NA, NA, NA, 39, 41, …
    #> $ min            <int> NA, 33, 15, 176, 2900, NA, NA, NA, NA, NA, NA, 34, 33, …
    #> $ max            <int> NA, 46, 21, 210, 4700, NA, NA, NA, NA, NA, NA, 46, 45, …
    #> $ count_missing  <int> NA, 1, 1, 1, 1, NA, NA, NA, NA, NA, NA, 1, 0, 0, 1, 0, …
    #> $ percentage     <dbl> NA, NA, NA, NA, NA, 46.153846, 44.230769, 9.615385, NA,…

Using this tidy format, we can replicate plots. For instance, we recreate the previous example:
    
    
    penguinsTidy |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(
        variable_name == "body_mass_g",
        species != "overall",
        sex [%in%](https://rdrr.io/r/base/match.html) [c](https://rdrr.io/r/base/c.html)("female", "male"),
        year != "overall"
      ) |>
      [boxPlot](../reference/boxPlot.html)(x = "cdm_name", facet = sex ~ species, colour = "year", style = "darwin")

![](a02_plots_files/figure-html/unnamed-chunk-12-1.png)

## Custom plotting

The tidy format is very useful to apply any other custom ggplot2 function that we may be interested on:
    
    
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    penguinsSummary |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "number records") |>
      [tidy](https://generics.r-lib.org/reference/tidy.html)() |>
      [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)([aes](https://ggplot2.tidyverse.org/reference/aes.html)(x = year, y = sex, fill = count, label = count)) +
      [themeVisOmop](../reference/themeVisOmop.html)() +
      [geom_tile](https://ggplot2.tidyverse.org/reference/geom_tile.html)() +
      [scale_fill_viridis_c](https://ggplot2.tidyverse.org/reference/scale_viridis.html)(trans = "log") + 
      [geom_text](https://ggplot2.tidyverse.org/reference/geom_text.html)() +
      [facet_grid](https://ggplot2.tidyverse.org/reference/facet_grid.html)(cdm_name ~ species) + 
      ggplot2::[theme](https://ggplot2.tidyverse.org/reference/theme.html)(axis.text.x = ggplot2::[element_text](https://ggplot2.tidyverse.org/reference/element.html)(angle = 90, vjust = 0.5, hjust=1))

![](a02_plots_files/figure-html/unnamed-chunk-13-1.png)

## Combine with `ggplot2`

The plotting functions are a wrapper around the ggplot2 package, outputs of the plotting functions can be later customised with ggplot2 and similar tools. For example we can use `[ggplot2::labs()](https://ggplot2.tidyverse.org/reference/labs.html)` to change the labels and `[ggplot2::theme()](https://ggplot2.tidyverse.org/reference/theme.html)` to move the location of the legend.
    
    
    penguinsSummary |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(
        group_level != "overall",
        strata_name == "year &&& sex",
        ![grepl](https://rdrr.io/r/base/grep.html)("NA", strata_level),
        variable_name == "body_mass_g") |>
      [boxPlot](../reference/boxPlot.html)(x = "species", facet = cdm_name ~ sex, colour = "year") +
      [themeVisOmop](../reference/themeVisOmop.html)(fontsizeRef = 12) +
      [ylim](https://ggplot2.tidyverse.org/reference/lims.html)([c](https://rdrr.io/r/base/c.html)(0, 6500)) +
      [labs](https://ggplot2.tidyverse.org/reference/labs.html)(x = "My custom x label")

![](a02_plots_files/figure-html/unnamed-chunk-14-1.png)

You can also use `[ggplot2::ggsave()](https://ggplot2.tidyverse.org/reference/ggsave.html)` to later save one of this plots into ‘.png’ file.
    
    
    [ggsave](https://ggplot2.tidyverse.org/reference/ggsave.html)(
      "figure8.png", plot = [last_plot](https://ggplot2.tidyverse.org/reference/last_plot.html)(), device = "png", width = 15, height = 12, 
      units = "cm", dpi = 300)

## Combine with `plotly`

Although the package currently does not provide any plotly functionality ggplots can be easily converted to `<plotly>` ones using the function `[plotly::ggplotly()](https://rdrr.io/pkg/plotly/man/ggplotly.html)`. This can make the interactivity of some plots better.

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/news/index.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Changelog

Source: [`NEWS.md`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/NEWS.md)

## visOmopResults 1.2.0

CRAN release: 2025-09-02

  * Support `tinytable`
  * Add argument `style` for plots
  * Add function `[setGlobalPlotOptions()](../reference/setGlobalPlotOptions.html)` to set global arguments to plots
  * Add function `[setGlobalTableOptions()](../reference/setGlobalTableOptions.html)` to set global arguments to tables
  * Union borders from merged cells in flextable



## visOmopResults 1.1.1

CRAN release: 2025-06-19

  * Fix that all table types were required to be installed even if not used
  * `columnOrder` when non-table columns passed, throw warning instead of error
  * `columnOrder` when missing table columns adds them at the end instead of throwing error



## visOmopResults 1.1.0

CRAN release: 2025-05-21

  * Support `reactable`
  * Add darwin style



## visOmopResults 1.0.2

CRAN release: 2025-03-06

  * Header pivotting - warning and addition of needed columns to get unique estimates in cells
  * Fixed headers in datatable
  * Show min cell counts only for counts, set the other estimates to NA



## visOmopResults 1.0.1

CRAN release: 2025-02-27

  * Obscure percentage when there are less than five counts
  * `formatMinCellCount` function



## visOmopResults 1.0.0

CRAN release: 2025-01-15

  * Stable release of the package
  * Added a `NEWS.md` file to track changes to the package.



## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/mockSummarisedResult.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# A `<summarised_result>` object filled with mock data

Source: [`R/mockResults.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/mockResults.R)

`mockSummarisedResult.Rd`

Creates an object of the class `<summarised_result>` with mock data for illustration purposes.

## Usage
    
    
    mockSummarisedResult()

## Value

An object of the class `<summarised_result>` with mock data.

## Examples
    
    
    mockSummarisedResult()
    #> # A tibble: 126 × 13
    #>    result_id cdm_name group_name  group_level strata_name       strata_level   
    #>        <int> <chr>    <chr>       <chr>       <chr>             <chr>          
    #>  1         1 mock     cohort_name cohort1     overall           overall        
    #>  2         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Male   
    #>  3         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Male  
    #>  4         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Female 
    #>  5         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Female
    #>  6         1 mock     cohort_name cohort1     sex               Male           
    #>  7         1 mock     cohort_name cohort1     sex               Female         
    #>  8         1 mock     cohort_name cohort1     age_group         <40            
    #>  9         1 mock     cohort_name cohort1     age_group         >=40           
    #> 10         1 mock     cohort_name cohort2     overall           overall        
    #> # ℹ 116 more rows
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/visOmopTable.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Generate a formatted table from a `<summarised_result>`

Source: [`R/visOmopTable.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/visOmopTable.R)

`visOmopTable.Rd`

This function combines the functionalities of `[formatEstimateValue()](formatEstimateValue.html)`, `estimateName()`, `[formatHeader()](formatHeader.html)`, and `[formatTable()](formatTable.html)` into a single function specifically for `<summarised_result>` objects.

## Usage
    
    
    visOmopTable(
      result,
      estimateName = [character](https://rdrr.io/r/base/character.html)(),
      header = [character](https://rdrr.io/r/base/character.html)(),
      settingsColumn = [character](https://rdrr.io/r/base/character.html)(),
      groupColumn = [character](https://rdrr.io/r/base/character.html)(),
      rename = [character](https://rdrr.io/r/base/character.html)(),
      type = "gt",
      hide = [character](https://rdrr.io/r/base/character.html)(),
      columnOrder = [character](https://rdrr.io/r/base/character.html)(),
      factor = [list](https://rdrr.io/r/base/list.html)(),
      style = "default",
      showMinCellCount = TRUE,
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A `<summarised_result>` object.

estimateName
    

A named list of estimate names to join, sorted by computation order. Use `<...>` to indicate estimate names.

header
    

A vector specifying the elements to include in the header. The order of elements matters, with the first being the topmost header. Elements in header can be:

  * Any of the columns returned by `tableColumns(result)` to create a header for these columns.

  * Any other input to create an overall header.



settingsColumn
    

A character vector with the names of settings to include in the table. To see options use `settingsColumns(result)`.

groupColumn
    

Columns to use as group labels, to see options use `tableColumns(result)`. By default, the name of the new group will be the tidy* column names separated by ";". To specify a custom group name, use a named list such as: list("newGroupName" = c("variable_name", "variable_level")).

*tidy: The tidy format applied to column names replaces "_" with a space and converts to sentence case. Use `rename` to customise specific column names.

rename
    

A named vector to customise column names, e.g., c("Database name" = "cdm_name"). The function renames all column names not specified here into a tidy* format.

type
    

The desired format of the output table. See `[tableType()](tableType.html)` for allowed options.

hide
    

Columns to drop from the output table. By default, `result_id` and `estimate_type` are always dropped.

columnOrder
    

Character vector establishing the position of the columns in the formatted table. Columns in either header, groupColumn, or hide will be ignored.

factor
    

A named list where names refer to columns (see available columns in `[tableColumns()](tableColumns.html)`) and list elements are the level order of that column to arrange the results. The column order in the list will be used for arranging the result.

style
    

Named list that specifies how to style the different parts of the table generated. It can either be a pre-defined style ("default" or "darwin" - the latter just for gt and flextable), NULL to get the table default style, or custom. Keep in mind that styling code is different for all table styles. To see the different styles use `[tableStyle()](tableStyle.html)`.

showMinCellCount
    

If `TRUE`, suppressed estimates will be indicated with "<{min_cell_count}", otherwise, the default `na` defined in `.options` will be used.

.options
    

A named list with additional formatting options. `[visOmopResults::tableOptions()](tableOptions.html)` shows allowed arguments and their default values.

## Value

A tibble, gt, or flextable object.

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/visTable.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Generate a formatted table from a `<data.table>`

Source: [`R/visTable.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/visTable.R)

`visTable.Rd`

This function combines the functionalities of `[formatEstimateValue()](formatEstimateValue.html)`, `[formatEstimateName()](formatEstimateName.html)`, `[formatHeader()](formatHeader.html)`, and `[formatTable()](formatTable.html)` into a single function. While it does not require the input table to be a `<summarised_result>`, it does expect specific fields to apply some formatting functionalities.

## Usage
    
    
    visTable(
      result,
      estimateName = [character](https://rdrr.io/r/base/character.html)(),
      header = [character](https://rdrr.io/r/base/character.html)(),
      groupColumn = [character](https://rdrr.io/r/base/character.html)(),
      rename = [character](https://rdrr.io/r/base/character.html)(),
      type = "gt",
      hide = [character](https://rdrr.io/r/base/character.html)(),
      style = "default",
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A table to format.

estimateName
    

A named list of estimate names to join, sorted by computation order. Use `<...>` to indicate estimate names.

header
    

A vector specifying the elements to include in the header. The order of elements matters, with the first being the topmost header. The vector elements can be column names or labels for overall headers. The table must contain an `estimate_value` column to pivot the headers.

groupColumn
    

Columns to use as group labels, to see options use `tableColumns(result)`. By default, the name of the new group will be the tidy* column names separated by ";". To specify a custom group name, use a named list such as: list("newGroupName" = c("variable_name", "variable_level")).

*tidy: The tidy format applied to column names replaces "_" with a space and converts to sentence case. Use `rename` to customise specific column names.

rename
    

A named vector to customise column names, e.g., c("Database name" = "cdm_name"). The function renames all column names not specified here into a tidy* format.

type
    

The desired format of the output table. See `[tableType()](tableType.html)` for allowed options.

hide
    

Columns to drop from the output table.

style
    

Named list that specifies how to style the different parts of the table generated. It can either be a pre-defined style ("default" or "darwin" - the latter just for gt and flextable), NULL to get the table default style, or custom. Keep in mind that styling code is different for all table styles. To see the different styles use `[tableStyle()](tableStyle.html)`.

.options
    

A named list with additional formatting options. `[visOmopResults::tableOptions()](tableOptions.html)` shows allowed arguments and their default values.

## Value

A tibble, gt, flextable, reactable, or datatable object.

## Examples
    
    
    result <- [mockSummarisedResult](mockSummarisedResult.html)()
    result |>
      visTable(
        estimateName = [c](https://rdrr.io/r/base/c.html)("N%" = "<count> (<percentage>)",
                         "N" = "<count>",
                         "Mean (SD)" = "<mean> (<sd>)"),
        header = [c](https://rdrr.io/r/base/c.html)("Estimate"),
        rename = [c](https://rdrr.io/r/base/c.html)("Database name" = "cdm_name"),
        groupColumn = [c](https://rdrr.io/r/base/c.html)("strata_name", "strata_level"),
        hide = [c](https://rdrr.io/r/base/c.html)("additional_name", "additional_level", "estimate_type", "result_type")
      )
    #> 
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> | **Result id** | **Database name** | **Group name** | **Group level** | **Variable name** | **Variable level** | **Estimate name** | **Estimate**   |
    #> +===============+===================+================+=================+===================+====================+===================+================+
    #> | **overall; overall**                                                                                                                               |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> | 1             | mock              | cohort_name    | cohort1         | number subjects   | -                  | N                 | 2,655,087      |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | number subjects   | -                  | N                 | 617,863        |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | age               | -                  | Mean (SD)         | 38.00 (7.94)   |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | age               | -                  | Mean (SD)         | 38.24 (7.89)   |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | Medications       | Amoxiciline        | N%                | 7,068 (34.67)  |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | Medications       | Amoxiciline        | N%                | 33,239 (71.25) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | Medications       | Ibuprofen          | N%                | 23,963 (92.41) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | Medications       | Ibuprofen          | N%                | 60,493 (10.32) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> | **age_group &&& sex; <40 &&& Male**                                                                                                                |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> | 1             | mock              | cohort_name    | cohort1         | number subjects   | -                  | N                 | 3,721,239      |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | number subjects   | -                  | N                 | 2,059,746      |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | age               | -                  | Mean (SD)         | 77.74 (1.08)   |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | age               | -                  | Mean (SD)         | 86.97 (0.23)   |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | Medications       | Amoxiciline        | N%                | 9,947 (33.38)  |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | Medications       | Amoxiciline        | N%                | 65,087 (40.00) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | Medications       | Ibuprofen          | N%                | 5,893 (59.88)  |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | Medications       | Ibuprofen          | N%                | 65,472 (44.63) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> | **age_group &&& sex; >=40 &&& Male**                                                                                                               |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> | 1             | mock              | cohort_name    | cohort1         | number subjects   | -                  | N                 | 5,728,534      |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | number subjects   | -                  | N                 | 1,765,568      |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | age               | -                  | Mean (SD)         | 93.47 (7.24)   |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | age               | -                  | Mean (SD)         | 34.03 (4.77)   |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | Medications       | Amoxiciline        | N%                | 31,627 (47.64) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | Medications       | Amoxiciline        | N%                | 25,802 (32.54) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | Medications       | Ibuprofen          | N%                | 64,229 (97.62) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | Medications       | Ibuprofen          | N%                | 35,320 (64.01) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> | **age_group &&& sex; <40 &&& Female**                                                                                                              |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> | 1             | mock              | cohort_name    | cohort1         | number subjects   | -                  | N                 | 9,082,078      |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | number subjects   | -                  | N                 | 6,870,228      |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | age               | -                  | Mean (SD)         | 21.21 (4.11)   |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | age               | -                  | Mean (SD)         | 48.21 (7.32)   |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | Medications       | Amoxiciline        | N%                | 51,863 (89.22) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | Medications       | Amoxiciline        | N%                | 47,855 (75.71) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | Medications       | Ibuprofen          | N%                | 87,627 (73.18) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | Medications       | Ibuprofen          | N%                | 27,026 (99.18) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> | **age_group &&& sex; >=40 &&& Female**                                                                                                             |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> | 1             | mock              | cohort_name    | cohort1         | number subjects   | -                  | N                 | 2,016,819      |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | number subjects   | -                  | N                 | 3,841,037      |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | age               | -                  | Mean (SD)         | 65.17 (8.21)   |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | age               | -                  | Mean (SD)         | 59.96 (6.93)   |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | Medications       | Amoxiciline        | N%                | 66,201 (86.43) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | Medications       | Amoxiciline        | N%                | 76,631 (20.27) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | Medications       | Ibuprofen          | N%                | 77,891 (35.67) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | Medications       | Ibuprofen          | N%                | 99,268 (49.56) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> | **sex; Male**                                                                                                                                      |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> | 1             | mock              | cohort_name    | cohort1         | number subjects   | -                  | N                 | 8,983,897      |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | number subjects   | -                  | N                 | 7,698,414      |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | age               | -                  | Mean (SD)         | 12.56 (6.47)   |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | age               | -                  | Mean (SD)         | 49.35 (4.78)   |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | Medications       | Amoxiciline        | N%                | 40,683 (39.00) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | Medications       | Amoxiciline        | N%                | 8,425 (71.11)  |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | Medications       | Ibuprofen          | N%                | 79,731 (43.15) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | Medications       | Ibuprofen          | N%                | 63,349 (48.43) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> | **sex; Female**                                                                                                                                    |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> | 1             | mock              | cohort_name    | cohort1         | number subjects   | -                  | N                 | 9,446,753      |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | number subjects   | -                  | N                 | 4,976,992      |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | age               | -                  | Mean (SD)         | 26.72 (7.83)   |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | age               | -                  | Mean (SD)         | 18.62 (8.61)   |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | Medications       | Amoxiciline        | N%                | 91,288 (77.73) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | Medications       | Amoxiciline        | N%                | 87,532 (12.17) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | Medications       | Ibuprofen          | N%                | 45,527 (14.82) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | Medications       | Ibuprofen          | N%                | 21,321 (17.34) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> | **age_group; <40**                                                                                                                                 |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> | 1             | mock              | cohort_name    | cohort1         | number subjects   | -                  | N                 | 6,607,978      |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | number subjects   | -                  | N                 | 7,176,185      |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | age               | -                  | Mean (SD)         | 38.61 (5.53)   |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | age               | -                  | Mean (SD)         | 82.74 (4.38)   |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | Medications       | Amoxiciline        | N%                | 29,360 (96.06) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | Medications       | Amoxiciline        | N%                | 33,907 (24.55) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | Medications       | Ibuprofen          | N%                | 41,008 (1.31)  |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | Medications       | Ibuprofen          | N%                | 12,937 (75.48) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> | **age_group; >=40**                                                                                                                                |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> | 1             | mock              | cohort_name    | cohort1         | number subjects   | -                  | N                 | 6,291,140      |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | number subjects   | -                  | N                 | 9,919,061      |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | age               | -                  | Mean (SD)         | 1.34 (5.30)    |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | age               | -                  | Mean (SD)         | 66.85 (2.45)   |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | Medications       | Amoxiciline        | N%                | 45,907 (43.47) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | Medications       | Amoxiciline        | N%                | 83,944 (14.33) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort1         | Medications       | Ibuprofen          | N%                | 81,087 (71.56) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+
    #> |               |                   |                | cohort2         | Medications       | Ibuprofen          | N%                | 47,812 (45.39) |
    #> +---------------+-------------------+----------------+-----------------+-------------------+--------------------+-------------------+----------------+ 
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/themeVisOmop.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Apply visOmopResults default styling to a ggplot

Source: [`R/plottingThemes.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/plottingThemes.R)

`themeVisOmop.Rd`

Apply visOmopResults default styling to a ggplot

## Usage
    
    
    themeVisOmop(fontsizeRef = 10)

## Arguments

fontsizeRef
    

An integer to use as reference when adjusting label fontsize.

## Examples
    
    
    result <- [mockSummarisedResult](mockSummarisedResult.html)() |> dplyr::[filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "age")
    
    [barPlot](barPlot.html)(
      result = result,
      x = "cohort_name",
      y = "mean",
      facet = [c](https://rdrr.io/r/base/c.html)("age_group", "sex"),
      colour = "sex") +
     themeVisOmop()
    ![](themeVisOmop-1.png)
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/barPlot.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Create a bar plot visualisation from a `<summarised_result>` object

Source: [`R/plot.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/plot.R)

`barPlot.Rd`

Create a bar plot visualisation from a `<summarised_result>` object

## Usage
    
    
    barPlot(
      result,
      x,
      y,
      width = NULL,
      just = 0.5,
      facet = NULL,
      colour = NULL,
      style = "default",
      label = [character](https://rdrr.io/r/base/character.html)()
    )

## Arguments

result
    

A `<summarised_result>` object.

x
    

Column or estimate name that is used as x variable.

y
    

Column or estimate name that is used as y variable.

width
    

Bar width, as in `geom_col()` of the `ggplot2` package.

just
    

Adjustment for column placement, as in `geom_col()` of the `ggplot2` package.

facet
    

Variables to facet by, a formula can be provided to specify which variables should be used as rows and which ones as columns.

colour
    

Columns to use to determine the colours.

style
    

Which style to apply to the plot, options are: "default", "darwin" and NULL (default ggplot style). Customised styles can be achieved by modifying the returned ggplot object.

label
    

Character vector with the columns to display interactively in `plotly`.

## Value

A plot object.

## Examples
    
    
    result <- [mockSummarisedResult](mockSummarisedResult.html)() |> dplyr::[filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "age")
    
    barPlot(
      result = result,
      x = "cohort_name",
      y = "mean",
      facet = [c](https://rdrr.io/r/base/c.html)("age_group", "sex"),
      colour = "sex")
    ![](barPlot-1.png)
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/LICENSE.html

Skip to contents

[visOmopResults](index.html) 1.2.0

  * [Reference](reference/index.html)
  * Articles
    * [Tables](articles/a01_tables.html)
    * [Plots](articles/a02_plots.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](logo.png)

# Apache License

Source: [`LICENSE.md`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/LICENSE.md)

_Version 2.0, January 2004_ _<<http://www.apache.org/licenses/>>_

### Terms and Conditions for use, reproduction, and distribution

#### 1\. Definitions

“License” shall mean the terms and conditions for use, reproduction, and distribution as defined by Sections 1 through 9 of this document.

“Licensor” shall mean the copyright owner or entity authorized by the copyright owner that is granting the License.

“Legal Entity” shall mean the union of the acting entity and all other entities that control, are controlled by, or are under common control with that entity. For the purposes of this definition, “control” means **(i)** the power, direct or indirect, to cause the direction or management of such entity, whether by contract or otherwise, or **(ii)** ownership of fifty percent (50%) or more of the outstanding shares, or **(iii)** beneficial ownership of such entity.

“You” (or “Your”) shall mean an individual or Legal Entity exercising permissions granted by this License.

“Source” form shall mean the preferred form for making modifications, including but not limited to software source code, documentation source, and configuration files.

“Object” form shall mean any form resulting from mechanical transformation or translation of a Source form, including but not limited to compiled object code, generated documentation, and conversions to other media types.

“Work” shall mean the work of authorship, whether in Source or Object form, made available under the License, as indicated by a copyright notice that is included in or attached to the work (an example is provided in the Appendix below).

“Derivative Works” shall mean any work, whether in Source or Object form, that is based on (or derived from) the Work and for which the editorial revisions, annotations, elaborations, or other modifications represent, as a whole, an original work of authorship. For the purposes of this License, Derivative Works shall not include works that remain separable from, or merely link (or bind by name) to the interfaces of, the Work and Derivative Works thereof.

“Contribution” shall mean any work of authorship, including the original version of the Work and any modifications or additions to that Work or Derivative Works thereof, that is intentionally submitted to Licensor for inclusion in the Work by the copyright owner or by an individual or Legal Entity authorized to submit on behalf of the copyright owner. For the purposes of this definition, “submitted” means any form of electronic, verbal, or written communication sent to the Licensor or its representatives, including but not limited to communication on electronic mailing lists, source code control systems, and issue tracking systems that are managed by, or on behalf of, the Licensor for the purpose of discussing and improving the Work, but excluding communication that is conspicuously marked or otherwise designated in writing by the copyright owner as “Not a Contribution.”

“Contributor” shall mean Licensor and any individual or Legal Entity on behalf of whom a Contribution has been received by Licensor and subsequently incorporated within the Work.

#### 2\. Grant of Copyright License

Subject to the terms and conditions of this License, each Contributor hereby grants to You a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable copyright license to reproduce, prepare Derivative Works of, publicly display, publicly perform, sublicense, and distribute the Work and such Derivative Works in Source or Object form.

#### 3\. Grant of Patent License

Subject to the terms and conditions of this License, each Contributor hereby grants to You a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable (except as stated in this section) patent license to make, have made, use, offer to sell, sell, import, and otherwise transfer the Work, where such license applies only to those patent claims licensable by such Contributor that are necessarily infringed by their Contribution(s) alone or by combination of their Contribution(s) with the Work to which such Contribution(s) was submitted. If You institute patent litigation against any entity (including a cross-claim or counterclaim in a lawsuit) alleging that the Work or a Contribution incorporated within the Work constitutes direct or contributory patent infringement, then any patent licenses granted to You under this License for that Work shall terminate as of the date such litigation is filed.

#### 4\. Redistribution

You may reproduce and distribute copies of the Work or Derivative Works thereof in any medium, with or without modifications, and in Source or Object form, provided that You meet the following conditions:

  * **(a)** You must give any other recipients of the Work or Derivative Works a copy of this License; and
  * **(b)** You must cause any modified files to carry prominent notices stating that You changed the files; and
  * **(c)** You must retain, in the Source form of any Derivative Works that You distribute, all copyright, patent, trademark, and attribution notices from the Source form of the Work, excluding those notices that do not pertain to any part of the Derivative Works; and
  * **(d)** If the Work includes a “NOTICE” text file as part of its distribution, then any Derivative Works that You distribute must include a readable copy of the attribution notices contained within such NOTICE file, excluding those notices that do not pertain to any part of the Derivative Works, in at least one of the following places: within a NOTICE text file distributed as part of the Derivative Works; within the Source form or documentation, if provided along with the Derivative Works; or, within a display generated by the Derivative Works, if and wherever such third-party notices normally appear. The contents of the NOTICE file are for informational purposes only and do not modify the License. You may add Your own attribution notices within Derivative Works that You distribute, alongside or as an addendum to the NOTICE text from the Work, provided that such additional attribution notices cannot be construed as modifying the License.



You may add Your own copyright statement to Your modifications and may provide additional or different license terms and conditions for use, reproduction, or distribution of Your modifications, or for any such Derivative Works as a whole, provided Your use, reproduction, and distribution of the Work otherwise complies with the conditions stated in this License.

#### 5\. Submission of Contributions

Unless You explicitly state otherwise, any Contribution intentionally submitted for inclusion in the Work by You to the Licensor shall be under the terms and conditions of this License, without any additional terms or conditions. Notwithstanding the above, nothing herein shall supersede or modify the terms of any separate license agreement you may have executed with Licensor regarding such Contributions.

#### 6\. Trademarks

This License does not grant permission to use the trade names, trademarks, service marks, or product names of the Licensor, except as required for reasonable and customary use in describing the origin of the Work and reproducing the content of the NOTICE file.

#### 7\. Disclaimer of Warranty

Unless required by applicable law or agreed to in writing, Licensor provides the Work (and each Contributor provides its Contributions) on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied, including, without limitation, any warranties or conditions of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A PARTICULAR PURPOSE. You are solely responsible for determining the appropriateness of using or redistributing the Work and assume any risks associated with Your exercise of permissions under this License.

#### 8\. Limitation of Liability

In no event and under no legal theory, whether in tort (including negligence), contract, or otherwise, unless required by applicable law (such as deliberate and grossly negligent acts) or agreed to in writing, shall any Contributor be liable to You for damages, including any direct, indirect, special, incidental, or consequential damages of any character arising as a result of this License or out of the use or inability to use the Work (including but not limited to damages for loss of goodwill, work stoppage, computer failure or malfunction, or any and all other commercial damages or losses), even if such Contributor has been advised of the possibility of such damages.

#### 9\. Accepting Warranty or Additional Liability

While redistributing the Work or Derivative Works thereof, You may choose to offer, and charge a fee for, acceptance of support, warranty, indemnity, or other liability obligations and/or rights consistent with this License. However, in accepting such obligations, You may act only on Your own behalf and on Your sole responsibility, not on behalf of any other Contributor, and only if You agree to indemnify, defend, and hold each Contributor harmless for any liability incurred by, or claims asserted against, such Contributor by reason of your accepting any such warranty or additional liability.

_END OF TERMS AND CONDITIONS_

### APPENDIX: How to apply the Apache License to your work

To apply the Apache License to your work, attach the following boilerplate notice, with the fields enclosed by brackets `[]` replaced with your own identifying information. (Don’t include the brackets!) The text should be enclosed in the appropriate comment syntax for the file format. We also recommend that a file or class name and description of purpose be included on the same “printed page” as the copyright notice for easier identification within third-party archives.
    
    
    Copyright [yyyy] [name of copyright owner]
    
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
      http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/authors.html

Skip to contents

[visOmopResults](index.html) 1.2.0

  * [Reference](reference/index.html)
  * Articles
    * [Tables](articles/a01_tables.html)
    * [Plots](articles/a02_plots.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](logo.png)

# Authors and Citation

## Authors

  * **Martí Català**. Author. [](https://orcid.org/0000-0003-3308-9905)

  * **Núria Mercadé-Besora**. Author, maintainer. [](https://orcid.org/0009-0006-7948-3747)

  * **Yuchen Guo**. Contributor. [](https://orcid.org/0000-0002-0847-4855)

  * **Elin Rowlands**. Contributor. [](https://orcid.org/0009-0007-6629-4661)

  * **Marta Alcalde-Herraiz**. Contributor. [](https://orcid.org/0009-0002-4405-1814)

  * **Edward Burn**. Contributor. [](https://orcid.org/0000-0002-9286-1128)




## Citation

Source: [`DESCRIPTION`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/DESCRIPTION)

Català M, Mercadé-Besora N (2025). _visOmopResults: Graphs and Tables for OMOP Results_. R package version 1.2.0, <https://darwin-eu.github.io/visOmopResults/>. 
    
    
    @Manual{,
      title = {visOmopResults: Graphs and Tables for OMOP Results},
      author = {Martí Català and Núria Mercadé-Besora},
      year = {2025},
      note = {R package version 1.2.0},
      url = {https://darwin-eu.github.io/visOmopResults/},
    }

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/formatEstimateName.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Formats estimate_name and estimate_value column

Source: [`R/formatEstimateName.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/formatEstimateName.R)

`formatEstimateName.Rd`

Formats estimate_name and estimate_value columns by changing the name of the estimate name and/or joining different estimates together in a single row.

## Usage
    
    
    formatEstimateName(
      result,
      estimateName = NULL,
      keepNotFormatted = TRUE,
      useFormatOrder = TRUE
    )

## Arguments

result
    

A `<summarised_result>`.

estimateName
    

Named list of estimate name's to join, sorted by computation order. Indicate estimate_name's between <...>.

keepNotFormatted
    

Whether to keep rows not formatted.

useFormatOrder
    

Whether to use the order in which estimate names appear in the estimateName (TRUE), or use the order in the input dataframe (FALSE).

## Value

A `<summarised_result>` object.

## Examples
    
    
    result <- [mockSummarisedResult](mockSummarisedResult.html)()
    result |>
      formatEstimateName(
        estimateName = [c](https://rdrr.io/r/base/c.html)(
          "N (%)" = "<count> (<percentage>%)", "N" = "<count>"
        ),
        keepNotFormatted = FALSE
      )
    #> # A tibble: 54 × 13
    #>    result_id cdm_name group_name  group_level strata_name       strata_level   
    #>        <int> <chr>    <chr>       <chr>       <chr>             <chr>          
    #>  1         1 mock     cohort_name cohort1     overall           overall        
    #>  2         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Male   
    #>  3         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Male  
    #>  4         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Female 
    #>  5         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Female
    #>  6         1 mock     cohort_name cohort1     sex               Male           
    #>  7         1 mock     cohort_name cohort1     sex               Female         
    #>  8         1 mock     cohort_name cohort1     age_group         <40            
    #>  9         1 mock     cohort_name cohort1     age_group         >=40           
    #> 10         1 mock     cohort_name cohort2     overall           overall        
    #> # ℹ 44 more rows
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/formatEstimateValue.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Formats the estimate_value column

Source: [`R/formatEstimateValue.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/formatEstimateValue.R)

`formatEstimateValue.Rd`

Formats the estimate_value column of `<summarised_result>` object by editing number of decimals, decimal and thousand/millions separator marks.

## Usage
    
    
    formatEstimateValue(
      result,
      decimals = [c](https://rdrr.io/r/base/c.html)(integer = 0, numeric = 2, percentage = 1, proportion = 3),
      decimalMark = ".",
      bigMark = ","
    )

## Arguments

result
    

A `<summarised_result>`.

decimals
    

Number of decimals per estimate type (integer, numeric, percentage, proportion), estimate name, or all estimate values (introduce the number of decimals).

decimalMark
    

Decimal separator mark.

bigMark
    

Thousand and millions separator mark.

## Value

A `<summarised_result>`.

## Examples
    
    
    result <- [mockSummarisedResult](mockSummarisedResult.html)()
    
    result |> formatEstimateValue(decimals = 1)
    #> # A tibble: 126 × 13
    #>    result_id cdm_name group_name  group_level strata_name       strata_level   
    #>        <int> <chr>    <chr>       <chr>       <chr>             <chr>          
    #>  1         1 mock     cohort_name cohort1     overall           overall        
    #>  2         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Male   
    #>  3         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Male  
    #>  4         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Female 
    #>  5         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Female
    #>  6         1 mock     cohort_name cohort1     sex               Male           
    #>  7         1 mock     cohort_name cohort1     sex               Female         
    #>  8         1 mock     cohort_name cohort1     age_group         <40            
    #>  9         1 mock     cohort_name cohort1     age_group         >=40           
    #> 10         1 mock     cohort_name cohort2     overall           overall        
    #> # ℹ 116 more rows
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    result |> formatEstimateValue(decimals = [c](https://rdrr.io/r/base/c.html)(integer = 0, numeric = 1))
    #> # A tibble: 126 × 13
    #>    result_id cdm_name group_name  group_level strata_name       strata_level   
    #>        <int> <chr>    <chr>       <chr>       <chr>             <chr>          
    #>  1         1 mock     cohort_name cohort1     overall           overall        
    #>  2         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Male   
    #>  3         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Male  
    #>  4         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Female 
    #>  5         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Female
    #>  6         1 mock     cohort_name cohort1     sex               Male           
    #>  7         1 mock     cohort_name cohort1     sex               Female         
    #>  8         1 mock     cohort_name cohort1     age_group         <40            
    #>  9         1 mock     cohort_name cohort1     age_group         >=40           
    #> 10         1 mock     cohort_name cohort2     overall           overall        
    #> # ℹ 116 more rows
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    result |>
      formatEstimateValue(decimals = [c](https://rdrr.io/r/base/c.html)(numeric = 1, count = 0))
    #> # A tibble: 126 × 13
    #>    result_id cdm_name group_name  group_level strata_name       strata_level   
    #>        <int> <chr>    <chr>       <chr>       <chr>             <chr>          
    #>  1         1 mock     cohort_name cohort1     overall           overall        
    #>  2         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Male   
    #>  3         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Male  
    #>  4         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Female 
    #>  5         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Female
    #>  6         1 mock     cohort_name cohort1     sex               Male           
    #>  7         1 mock     cohort_name cohort1     sex               Female         
    #>  8         1 mock     cohort_name cohort1     age_group         <40            
    #>  9         1 mock     cohort_name cohort1     age_group         >=40           
    #> 10         1 mock     cohort_name cohort2     overall           overall        
    #> # ℹ 116 more rows
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/formatHeader.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Create a header for gt and flextable objects

Source: [`R/formatHeader.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/formatHeader.R)

`formatHeader.Rd`

Pivots a `<summarised_result>` object based on the column names in header, generating specific column names for subsequent header formatting in formatTable function.

## Usage
    
    
    formatHeader(
      result,
      header,
      delim = "\n",
      includeHeaderName = TRUE,
      includeHeaderKey = TRUE
    )

## Arguments

result
    

A `<summarised_result>`.

header
    

Names of the variables to make headers.

delim
    

Delimiter to use to separate headers.

includeHeaderName
    

Whether to include the column name as header.

includeHeaderKey
    

Whether to include the header key (header, header_name, header_level) before each header type in the column names.

## Value

A tibble with rows pivotted into columns with key names for subsequent header formatting.

## Examples
    
    
    result <- [mockSummarisedResult](mockSummarisedResult.html)()
    
    result |>
      formatHeader(
        header = [c](https://rdrr.io/r/base/c.html)(
          "Study cohorts", "group_level", "Study strata", "strata_name",
          "strata_level"
        ),
        includeHeaderName = FALSE
      )
    #> # A tibble: 7 × 27
    #>   result_id cdm_name group_name  variable_name   variable_level estimate_name
    #>       <int> <chr>    <chr>       <chr>           <chr>          <chr>        
    #> 1         1 mock     cohort_name number subjects NA             count        
    #> 2         1 mock     cohort_name age             NA             mean         
    #> 3         1 mock     cohort_name age             NA             sd           
    #> 4         1 mock     cohort_name Medications     Amoxiciline    count        
    #> 5         1 mock     cohort_name Medications     Amoxiciline    percentage   
    #> 6         1 mock     cohort_name Medications     Ibuprofen      count        
    #> 7         1 mock     cohort_name Medications     Ibuprofen      percentage   
    #> # ℹ 21 more variables: estimate_type <chr>, additional_name <chr>,
    #> #   additional_level <chr>,
    #> #   `[header]Study cohorts\n[header_level]cohort1\n[header]Study strata\n[header_level]overall\n[header_level]overall` <chr>,
    #> #   `[header]Study cohorts\n[header_level]cohort1\n[header]Study strata\n[header_level]age_group &&& sex\n[header_level]<40 &&& Male` <chr>,
    #> #   `[header]Study cohorts\n[header_level]cohort1\n[header]Study strata\n[header_level]age_group &&& sex\n[header_level]>=40 &&& Male` <chr>,
    #> #   `[header]Study cohorts\n[header_level]cohort1\n[header]Study strata\n[header_level]age_group &&& sex\n[header_level]<40 &&& Female` <chr>,
    #> #   `[header]Study cohorts\n[header_level]cohort1\n[header]Study strata\n[header_level]age_group &&& sex\n[header_level]>=40 &&& Female` <chr>, …
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/formatMinCellCount.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# To indicate which was the minimum cell counts where estimates have been suppressed.

Source: [`R/formatEstimateValue.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/formatEstimateValue.R)

`formatMinCellCount.Rd`

To indicate which was the minimum cell counts where estimates have been suppressed.

## Usage
    
    
    formatMinCellCount(result)

## Arguments

result
    

A `<summarised_result>` object.

## Examples
    
    
    result <- [mockSummarisedResult](mockSummarisedResult.html)()
    result |> formatMinCellCount()
    #> # A tibble: 126 × 13
    #>    result_id cdm_name group_name  group_level strata_name       strata_level   
    #>        <int> <chr>    <chr>       <chr>       <chr>             <chr>          
    #>  1         1 mock     cohort_name cohort1     overall           overall        
    #>  2         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Male   
    #>  3         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Male  
    #>  4         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Female 
    #>  5         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Female
    #>  6         1 mock     cohort_name cohort1     sex               Male           
    #>  7         1 mock     cohort_name cohort1     sex               Female         
    #>  8         1 mock     cohort_name cohort1     age_group         <40            
    #>  9         1 mock     cohort_name cohort1     age_group         >=40           
    #> 10         1 mock     cohort_name cohort2     overall           overall        
    #> # ℹ 116 more rows
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/formatTable.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Creates a flextable or gt object from a dataframe

Source: [`R/formatTable.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/formatTable.R)

`formatTable.Rd`

Creates a flextable object from a dataframe using a delimiter to span the header, and allows to easily customise table style.

## Usage
    
    
    formatTable(
      x,
      type = "gt",
      delim = "\n",
      style = "default",
      na = "-",
      title = NULL,
      subtitle = NULL,
      caption = NULL,
      groupColumn = NULL,
      groupAsColumn = FALSE,
      groupOrder = NULL,
      merge = NULL
    )

## Arguments

x
    

A dataframe.

type
    

The desired format of the output table. See `[tableType()](tableType.html)` for allowed options. If "tibble", no formatting will be applied.

delim
    

Delimiter.

style
    

Named list that specifies how to style the different parts of the gt or flextable table generated. Accepted style entries are: title, subtitle, header, header_name, header_level, column_name, group_label, and body. Alternatively, use "default" to get visOmopResults style, or NULL for gt/flextable style. Keep in mind that styling code is different for gt and flextable. Additionally, "datatable" and "reactable" have their own style functions. To see style options for each table type use `[tableStyle()](tableStyle.html)`.

na
    

How to display missing values. Not used for "datatable" and "reactable".

title
    

Title of the table, or NULL for no title. Not used for "datatable".

subtitle
    

Subtitle of the table, or NULL for no subtitle. Not used for "datatable" and "reactable".

caption
    

Caption for the table, or NULL for no caption. Text in markdown formatting style (e.g. `*Your caption here*` for caption in italics). Not used for "reactable".

groupColumn
    

Specifies the columns to use for group labels. By default, the new group name will be a combination of the column names, joined by "_". To assign a custom group name, provide a named list such as: list(`newGroupName` = c("variable_name", "variable_level"))

groupAsColumn
    

Whether to display the group labels as a column (TRUE) or rows (FALSE). Not used for "datatable" and "reactable"

groupOrder
    

Order in which to display group labels. Not used for "datatable" and "reactable".

merge
    

Names of the columns to merge vertically when consecutive row cells have identical values. Alternatively, use "all_columns" to apply this merging to all columns, or use NULL to indicate no merging. Not used for "datatable" and "reactable".

## Value

A flextable object.

A flextable or gt object.

## Examples
    
    
    # Example 1
    [mockSummarisedResult](mockSummarisedResult.html)() |>
      [formatEstimateValue](formatEstimateValue.html)(decimals = [c](https://rdrr.io/r/base/c.html)(integer = 0, numeric = 1)) |>
      [formatHeader](formatHeader.html)(
        header = [c](https://rdrr.io/r/base/c.html)("Study strata", "strata_name", "strata_level"),
        includeHeaderName = FALSE
      ) |>
      formatTable(
        type = "flextable",
        style = "default",
        na = "--",
        title = "fxTable example",
        subtitle = NULL,
        caption = NULL,
        groupColumn = "group_level",
        groupAsColumn = TRUE,
        groupOrder = [c](https://rdrr.io/r/base/c.html)("cohort1", "cohort2"),
        merge = "all_columns"
      )
    
    
    fxTable example  
    ---  
    group_level| result_id| cdm_name| group_name| variable_name| variable_level| estimate_name| estimate_type| additional_name| additional_level| Study strata  
    overall| age_group &&& sex| sex| age_group  
    overall| <40 &&& Male| >=40 &&& Male| <40 &&& Female| >=40 &&& Female| Male| Female| <40| >=40  
    cohort1| 1| mock| cohort_name| number subjects| --| count| integer| overall| overall| 2,655,087| 3,721,239| 5,728,534| 9,082,078| 2,016,819| 8,983,897| 9,446,753| 6,607,978| 6,291,140  
    | | | age| --| mean| numeric| overall| overall| 38.0| 77.7| 93.5| 21.2| 65.2| 12.6| 26.7| 38.6| 1.3  
    | | | | | sd| numeric| overall| overall| 7.9| 1.1| 7.2| 4.1| 8.2| 6.5| 7.8| 5.5| 5.3  
    | | | Medications| Amoxiciline| count| integer| overall| overall| 7,068| 9,947| 31,627| 51,863| 66,201| 40,683| 91,288| 29,360| 45,907  
    | | | | | percentage| percentage| overall| overall| 34.668348915875| 33.3774930797517| 47.6351245073602| 89.2198335845023| 86.4339470630512| 38.9989543473348| 77.7320698834956| 96.0617997217923| 43.4659484773874  
    | | | | Ibuprofen| count| integer| overall| overall| 23,963| 5,893| 64,229| 87,627| 77,891| 79,731| 45,527| 41,008| 81,087  
    | | | | | percentage| percentage| overall| overall| 92.4074469832703| 59.876096714288| 97.6170694921166| 73.1792511884123| 35.6726912083104| 43.1473690550774| 14.8211560677737| 1.30775754805654| 71.5566066093743  
    cohort2| 1| mock| cohort_name| number subjects| --| count| integer| overall| overall| 617,863| 2,059,746| 1,765,568| 6,870,228| 3,841,037| 7,698,414| 4,976,992| 7,176,185| 9,919,061  
    | | | age| --| mean| numeric| overall| overall| 38.2| 87.0| 34.0| 48.2| 60.0| 49.4| 18.6| 82.7| 66.8  
    | | | | | sd| numeric| overall| overall| 7.9| 0.2| 4.8| 7.3| 6.9| 4.8| 8.6| 4.4| 2.4  
    | | | Medications| Amoxiciline| count| integer| overall| overall| 33,239| 65,087| 25,802| 47,855| 76,631| 8,425| 87,532| 33,907| 83,944  
    | | | | | percentage| percentage| overall| overall| 71.2514678714797| 39.9994368897751| 32.5352151878178| 75.7087148027495| 20.2692255144939| 71.1121222469956| 12.1691921027377| 24.5488513959572| 14.330437942408  
    | | | | Ibuprofen| count| integer| overall| overall| 60,493| 65,472| 35,320| 27,026| 99,268| 63,349| 21,321| 12,937| 47,812  
    | | | | | percentage| percentage| overall| overall| 10.3184235747904| 44.6284348610789| 64.0101045137271| 99.1838620044291| 49.5593577856198| 48.4349524369463| 17.3442334868014| 75.4820944508538| 45.3895489219576  
      
    
    # Example 2
    [mockSummarisedResult](mockSummarisedResult.html)() |>
      [formatEstimateValue](formatEstimateValue.html)(decimals = [c](https://rdrr.io/r/base/c.html)(integer = 0, numeric = 1)) |>
      [formatHeader](formatHeader.html)(header = [c](https://rdrr.io/r/base/c.html)("Study strata", "strata_name", "strata_level"),
                  includeHeaderName = FALSE) |>
      formatTable(
        type = "gt",
        style = [list](https://rdrr.io/r/base/list.html)("header" = [list](https://rdrr.io/r/base/list.html)(
          gt::[cell_fill](https://gt.rstudio.com/reference/cell_fill.html)(color = "#d9d9d9"),
          gt::[cell_text](https://gt.rstudio.com/reference/cell_text.html)(weight = "bold")),
          "header_level" = [list](https://rdrr.io/r/base/list.html)(gt::[cell_fill](https://gt.rstudio.com/reference/cell_fill.html)(color = "#e1e1e1"),
                                gt::[cell_text](https://gt.rstudio.com/reference/cell_text.html)(weight = "bold")),
          "column_name" = [list](https://rdrr.io/r/base/list.html)(gt::[cell_text](https://gt.rstudio.com/reference/cell_text.html)(weight = "bold")),
          "title" = [list](https://rdrr.io/r/base/list.html)(gt::[cell_text](https://gt.rstudio.com/reference/cell_text.html)(weight = "bold"),
                         gt::[cell_fill](https://gt.rstudio.com/reference/cell_fill.html)(color = "#c8c8c8")),
          "group_label" = gt::[cell_fill](https://gt.rstudio.com/reference/cell_fill.html)(color = "#e1e1e1")),
        na = "--",
        title = "gtTable example",
        subtitle = NULL,
        caption = NULL,
        groupColumn = "group_level",
        groupAsColumn = FALSE,
        groupOrder = [c](https://rdrr.io/r/base/c.html)("cohort1", "cohort2"),
        merge = "all_columns"
      )
    
    
    
    
      gtTable example
          
    ---  
    
          | 
            Study strata
          
          
    result_id
          | cdm_name
          | group_name
          | variable_name
          | variable_level
          | estimate_name
          | estimate_type
          | additional_name
          | additional_level
          | 
            overall
          
          | 
            age_group &&& sex
          
          | 
            sex
          
          | 
            age_group
          
          
    overall
          | <40 &&& Male
          | >=40 &&& Male
          | <40 &&& Female
          | >=40 &&& Female
          | Male
          | Female
          | <40
          | >=40
          
    cohort1
          
    1
    | mock
    | cohort_name
    | number subjects
    | --
    | count
    | integer
    | overall
    | overall
    | 2,655,087
    | 3,721,239
    | 5,728,534
    | 9,082,078
    | 2,016,819
    | 8,983,897
    | 9,446,753
    | 6,607,978
    | 6,291,140  
    
    | 
    | 
    | age
    | --
    | mean
    | numeric
    | overall
    | overall
    | 38.0
    | 77.7
    | 93.5
    | 21.2
    | 65.2
    | 12.6
    | 26.7
    | 38.6
    | 1.3  
    
    | 
    | 
    | 
    | 
    | sd
    | numeric
    | overall
    | overall
    | 7.9
    | 1.1
    | 7.2
    | 4.1
    | 8.2
    | 6.5
    | 7.8
    | 5.5
    | 5.3  
    
    | 
    | 
    | Medications
    | Amoxiciline
    | count
    | integer
    | overall
    | overall
    | 7,068
    | 9,947
    | 31,627
    | 51,863
    | 66,201
    | 40,683
    | 91,288
    | 29,360
    | 45,907  
    
    | 
    | 
    | 
    | 
    | percentage
    | percentage
    | overall
    | overall
    | 34.668348915875
    | 33.3774930797517
    | 47.6351245073602
    | 89.2198335845023
    | 86.4339470630512
    | 38.9989543473348
    | 77.7320698834956
    | 96.0617997217923
    | 43.4659484773874  
    
    | 
    | 
    | 
    | Ibuprofen
    | count
    | integer
    | overall
    | overall
    | 23,963
    | 5,893
    | 64,229
    | 87,627
    | 77,891
    | 79,731
    | 45,527
    | 41,008
    | 81,087  
    
    | 
    | 
    | 
    | 
    | percentage
    | percentage
    | overall
    | overall
    | 92.4074469832703
    | 59.876096714288
    | 97.6170694921166
    | 73.1792511884123
    | 35.6726912083104
    | 43.1473690550774
    | 14.8211560677737
    | 1.30775754805654
    | 71.5566066093743  
    cohort2
          
    1
    | mock
    | cohort_name
    | number subjects
    | --
    | count
    | integer
    | overall
    | overall
    | 617,863
    | 2,059,746
    | 1,765,568
    | 6,870,228
    | 3,841,037
    | 7,698,414
    | 4,976,992
    | 7,176,185
    | 9,919,061  
    
    | 
    | 
    | age
    | --
    | mean
    | numeric
    | overall
    | overall
    | 38.2
    | 87.0
    | 34.0
    | 48.2
    | 60.0
    | 49.4
    | 18.6
    | 82.7
    | 66.8  
    
    | 
    | 
    | 
    | 
    | sd
    | numeric
    | overall
    | overall
    | 7.9
    | 0.2
    | 4.8
    | 7.3
    | 6.9
    | 4.8
    | 8.6
    | 4.4
    | 2.4  
    
    | 
    | 
    | Medications
    | Amoxiciline
    | count
    | integer
    | overall
    | overall
    | 33,239
    | 65,087
    | 25,802
    | 47,855
    | 76,631
    | 8,425
    | 87,532
    | 33,907
    | 83,944  
    
    | 
    | 
    | 
    | 
    | percentage
    | percentage
    | overall
    | overall
    | 71.2514678714797
    | 39.9994368897751
    | 32.5352151878178
    | 75.7087148027495
    | 20.2692255144939
    | 71.1121222469956
    | 12.1691921027377
    | 24.5488513959572
    | 14.330437942408  
    
    | 
    | 
    | 
    | Ibuprofen
    | count
    | integer
    | overall
    | overall
    | 60,493
    | 65,472
    | 35,320
    | 27,026
    | 99,268
    | 63,349
    | 21,321
    | 12,937
    | 47,812  
    
    | 
    | 
    | 
    | 
    | percentage
    | percentage
    | overall
    | overall
    | 10.3184235747904
    | 44.6284348610789
    | 64.0101045137271
    | 99.1838620044291
    | 49.5593577856198
    | 48.4349524369463
    | 17.3442334868014
    | 75.4820944508538
    | 45.3895489219576  
      
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/emptyTable.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Returns an empty table

Source: [`R/visTable.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/visTable.R)

`emptyTable.Rd`

Returns an empty table

## Usage
    
    
    emptyTable(type = "gt")

## Arguments

type
    

The desired format of the output table. See `[tableType()](tableType.html)` for allowed options.

## Value

An empty table of the class specified in `type`

## Examples
    
    
    emptyTable(type = "flextable")
    
    
    Table has no data  
    ---  
      
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/setGlobalTableOptions.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Set format options for all subsequent tables

Source: [`R/helperFunctions.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/helperFunctions.R)

`setGlobalTableOptions.Rd`

Set format options for all subsequent tables unless state a different style in a specific function

## Usage
    
    
    setGlobalTableOptions(style = NULL, type = NULL)

## Arguments

style
    

Named list that specifies how to style the different parts of the gt or flextable table generated. Accepted style entries are: title, subtitle, header, header_name, header_level, column_name, group_label, and body. Alternatively, use "default" to get visOmopResults style, or NULL for gt/flextable style. Keep in mind that styling code is different for gt and flextable. Additionally, "datatable" and "reactable" have their own style functions. To see style options for each table type use `[tableStyle()](tableStyle.html)`.

type
    

The desired format of the output table. See `[tableType()](tableType.html)` for allowed options. If "tibble", no formatting will be applied.

## Examples
    
    
    setGlobalTableOptions(style = "darwin", type = "tinytable")
    result <- [mockSummarisedResult](mockSummarisedResult.html)()
    result |>
      [visOmopTable](visOmopTable.html)(
        estimateName = [c](https://rdrr.io/r/base/c.html)("N%" = "<count> (<percentage>)",
                         "N" = "<count>",
                         "Mean (SD)" = "<mean> (<sd>)"),
        header = [c](https://rdrr.io/r/base/c.html)("cohort_name"),
        rename = [c](https://rdrr.io/r/base/c.html)("Database name" = "cdm_name"),
        groupColumn = [strataColumns](https://darwin-eu.github.io/omopgenerics/reference/strataColumns.html)(result)
      )
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                                                                                | **Cohort name**                 |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> | **Database name** | **Variable name** | **Variable level** | **Estimate name** | **cohort1**    | **cohort2**    |
    #> +===================+===================+====================+===================+================+================+
    #> | **overall; overall**                                                                                             |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> | mock              | number subjects   | -                  | N                 | 2,655,087      | 617,863        |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   | age               | -                  | Mean (SD)         | 38.00 (7.94)   | 38.24 (7.89)   |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   | Medications       | Amoxiciline        | N%                | 7,068 (34.67)  | 33,239 (71.25) |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   |                   | Ibuprofen          | N%                | 23,963 (92.41) | 60,493 (10.32) |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> | **<40; Male**                                                                                                    |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> | mock              | number subjects   | -                  | N                 | 3,721,239      | 2,059,746      |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   | age               | -                  | Mean (SD)         | 77.74 (1.08)   | 86.97 (0.23)   |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   | Medications       | Amoxiciline        | N%                | 9,947 (33.38)  | 65,087 (40.00) |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   |                   | Ibuprofen          | N%                | 5,893 (59.88)  | 65,472 (44.63) |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> | **>=40; Male**                                                                                                   |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> | mock              | number subjects   | -                  | N                 | 5,728,534      | 1,765,568      |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   | age               | -                  | Mean (SD)         | 93.47 (7.24)   | 34.03 (4.77)   |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   | Medications       | Amoxiciline        | N%                | 31,627 (47.64) | 25,802 (32.54) |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   |                   | Ibuprofen          | N%                | 64,229 (97.62) | 35,320 (64.01) |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> | **<40; Female**                                                                                                  |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> | mock              | number subjects   | -                  | N                 | 9,082,078      | 6,870,228      |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   | age               | -                  | Mean (SD)         | 21.21 (4.11)   | 48.21 (7.32)   |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   | Medications       | Amoxiciline        | N%                | 51,863 (89.22) | 47,855 (75.71) |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   |                   | Ibuprofen          | N%                | 87,627 (73.18) | 27,026 (99.18) |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> | **>=40; Female**                                                                                                 |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> | mock              | number subjects   | -                  | N                 | 2,016,819      | 3,841,037      |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   | age               | -                  | Mean (SD)         | 65.17 (8.21)   | 59.96 (6.93)   |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   | Medications       | Amoxiciline        | N%                | 66,201 (86.43) | 76,631 (20.27) |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   |                   | Ibuprofen          | N%                | 77,891 (35.67) | 99,268 (49.56) |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> | **overall; Male**                                                                                                |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> | mock              | number subjects   | -                  | N                 | 8,983,897      | 7,698,414      |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   | age               | -                  | Mean (SD)         | 12.56 (6.47)   | 49.35 (4.78)   |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   | Medications       | Amoxiciline        | N%                | 40,683 (39.00) | 8,425 (71.11)  |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   |                   | Ibuprofen          | N%                | 79,731 (43.15) | 63,349 (48.43) |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> | **overall; Female**                                                                                              |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> | mock              | number subjects   | -                  | N                 | 9,446,753      | 4,976,992      |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   | age               | -                  | Mean (SD)         | 26.72 (7.83)   | 18.62 (8.61)   |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   | Medications       | Amoxiciline        | N%                | 91,288 (77.73) | 87,532 (12.17) |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   |                   | Ibuprofen          | N%                | 45,527 (14.82) | 21,321 (17.34) |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> | **<40; overall**                                                                                                 |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> | mock              | number subjects   | -                  | N                 | 6,607,978      | 7,176,185      |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   | age               | -                  | Mean (SD)         | 38.61 (5.53)   | 82.74 (4.38)   |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   | Medications       | Amoxiciline        | N%                | 29,360 (96.06) | 33,907 (24.55) |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   |                   | Ibuprofen          | N%                | 41,008 (1.31)  | 12,937 (75.48) |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> | **>=40; overall**                                                                                                |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> | mock              | number subjects   | -                  | N                 | 6,291,140      | 9,919,061      |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   | age               | -                  | Mean (SD)         | 1.34 (5.30)    | 66.85 (2.45)   |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   | Medications       | Amoxiciline        | N%                | 45,907 (43.47) | 83,944 (14.33) |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+
    #> |                   |                   | Ibuprofen          | N%                | 81,087 (71.56) | 47,812 (45.39) |
    #> +-------------------+-------------------+--------------------+-------------------+----------------+----------------+ 
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/tableColumns.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Columns for the table functions

Source: [`R/helperFunctions.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/helperFunctions.R)

`tableColumns.Rd`

Names of the columns that can be used in the input arguments for the table functions.

## Usage
    
    
    tableColumns(result)

## Arguments

result
    

A `<summarised_result>` object.

## Value

A character vector of supported columns for tables.

## Examples
    
    
    result <- [mockSummarisedResult](mockSummarisedResult.html)()
    tableColumns(result)
    #> [1] "cdm_name"       "cohort_name"    "age_group"      "sex"           
    #> [5] "variable_name"  "variable_level" "estimate_name" 
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/tableOptions.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Additional table formatting options for `visOmopTable()` and `visTable()`

Source: [`R/helperFunctions.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/helperFunctions.R)

`tableOptions.Rd`

This function provides a list of allowed inputs for the `.option` argument in `[visOmopTable()](visOmopTable.html)` and `[visTable()](visTable.html)`, and their corresponding default values.

## Usage
    
    
    tableOptions()

## Value

A named list of default options for table customisation.

## Examples
    
    
    tableOptions()
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
    #> 
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/tableStyle.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Supported predefined styles for formatted tables

Source: [`R/helperFunctions.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/helperFunctions.R)

`tableStyle.Rd`

Supported predefined styles for formatted tables

## Usage
    
    
    tableStyle(type = "gt", style = "default")

## Arguments

type
    

Character string specifying the formatted table class. See `[tableType()](tableType.html)` for supported classes. Default is "gt".

style
    

Supported predefined styles. Currently: "default" and "darwin".

## Value

A code expression for the selected style and table type.

## Examples
    
    
    tableStyle("gt")
    #> list(header = list(gt::cell_fill(color = "#c8c8c8"), gt::cell_text(weight = "bold", 
    #>     align = "center")), header_name = list(gt::cell_fill(color = "#d9d9d9"), 
    #>     gt::cell_text(weight = "bold", align = "center")), header_level = list(gt::cell_fill(color = "#e1e1e1"), 
    #>     gt::cell_text(weight = "bold", align = "center")), column_name = list(gt::cell_text(weight = "bold", 
    #>     align = "center")), group_label = list(gt::cell_fill(color = "#e9e9e9"), 
    #>     gt::cell_text(weight = "bold")), title = list(gt::cell_text(weight = "bold", 
    #>     size = 15, align = "center")), subtitle = list(gt::cell_text(weight = "bold", 
    #>     size = 12, align = "center")), body = list())
    tableStyle("flextable")
    #> list(header = list(cell = officer::fp_cell(background.color = "#c8c8c8"), 
    #>     text = officer::fp_text(bold = TRUE)), header_name = list(cell = officer::fp_cell(background.color = "#d9d9d9"), 
    #>     text = officer::fp_text(bold = TRUE)), header_level = list(cell = officer::fp_cell(background.color = "#e1e1e1"), 
    #>     text = officer::fp_text(bold = TRUE)), column_name = list(text = officer::fp_text(bold = TRUE), 
    #>     cell = officer::fp_cell(border = officer::fp_border(color = "gray"))), 
    #>     group_label = list(cell = officer::fp_cell(background.color = "#e9e9e9", 
    #>         border = officer::fp_border(color = "gray")), text = officer::fp_text(bold = TRUE)), 
    #>     title = list(text = officer::fp_text(bold = TRUE, font.size = 15), 
    #>         paragraph = officer::fp_par(text.align = "center"), cell = officer::fp_cell(border = officer::fp_border(color = "gray"))), 
    #>     subtitle = list(text = officer::fp_text(bold = TRUE, font.size = 12), 
    #>         paragraph = officer::fp_par(text.align = "center"), cell = officer::fp_cell(border = officer::fp_border(color = "gray"))), 
    #>     body = list(cell = officer::fp_cell(background.color = "transparent", 
    #>         border = officer::fp_border(color = "gray"))))
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/tableType.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Supported table classes

Source: [`R/helperFunctions.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/helperFunctions.R)

`tableType.Rd`

This function returns the supported table classes that can be used in the `type` argument of `[visOmopTable()](visOmopTable.html)`, `[visTable()](visTable.html)`, and `[formatTable()](formatTable.html)` functions.

## Usage
    
    
    tableType()

## Value

A character vector of supported table types.

## Examples
    
    
    tableType()
    #> [1] "gt"        "flextable" "tibble"    "datatable" "reactable" "tinytable"
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/boxPlot.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Create a box plot visualisation from a `<summarised_result>` object

Source: [`R/plot.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/plot.R)

`boxPlot.Rd`

Create a box plot visualisation from a `<summarised_result>` object

## Usage
    
    
    boxPlot(
      result,
      x,
      lower = "q25",
      middle = "median",
      upper = "q75",
      ymin = "min",
      ymax = "max",
      facet = NULL,
      colour = NULL,
      style = "default",
      label = [character](https://rdrr.io/r/base/character.html)()
    )

## Arguments

result
    

A `<summarised_result>` object.

x
    

Column or estimate name that is used as x variable.

lower
    

Estimate name for the lower quantile of the box.

middle
    

Estimate name for the middle line of the box.

upper
    

Estimate name for the upper quantile of the box.

ymin
    

Lower limit of error bars, if provided is plot using `geom_errorbar`.

ymax
    

Upper limit of error bars, if provided is plot using `geom_errorbar`.

facet
    

Variables to facet by, a formula can be provided to specify which variables should be used as rows and which ones as columns.

colour
    

Columns to use to determine the colours.

style
    

Which style to apply to the plot, options are: "default", "darwin" and NULL (default ggplot style). Customised styles can be achieved by modifying the returned ggplot object.

label
    

Character vector with the columns to display interactively in `plotly`.

## Value

A ggplot2 object.

## Examples
    
    
    dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(year = "2000", q25 = 25, median = 50, q75 = 75, min = 0, max = 100) |>
      boxPlot(x = "year")
    ![](boxPlot-1.png)
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/emptyPlot.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Returns an empty plot

Source: [`R/plot.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/plot.R)

`emptyPlot.Rd`

Returns an empty plot

## Usage
    
    
    emptyPlot(title = "No data to plot", subtitle = "")

## Arguments

title
    

Title to use in the empty plot.

subtitle
    

Subtitle to use in the empty plot.

## Value

An empty ggplot object

## Examples
    
    
    emptyPlot()
    ![](emptyPlot-1.png)
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/scatterPlot.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Create a scatter plot visualisation from a `<summarised_result>` object

Source: [`R/plot.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/plot.R)

`scatterPlot.Rd`

Create a scatter plot visualisation from a `<summarised_result>` object

## Usage
    
    
    scatterPlot(
      result,
      x,
      y,
      line,
      point,
      ribbon,
      ymin = NULL,
      ymax = NULL,
      facet = NULL,
      colour = NULL,
      style = "default",
      group = colour,
      label = [character](https://rdrr.io/r/base/character.html)()
    )

## Arguments

result
    

A `<summarised_result>` object.

x
    

Column or estimate name that is used as x variable.

y
    

Column or estimate name that is used as y variable.

line
    

Whether to plot a line using `geom_line`.

point
    

Whether to plot points using `geom_point`.

ribbon
    

Whether to plot a ribbon using `geom_ribbon`.

ymin
    

Lower limit of error bars, if provided is plot using `geom_errorbar`.

ymax
    

Upper limit of error bars, if provided is plot using `geom_errorbar`.

facet
    

Variables to facet by, a formula can be provided to specify which variables should be used as rows and which ones as columns.

colour
    

Columns to use to determine the colours.

style
    

Which style to apply to the plot, options are: "default", "darwin" and NULL (default ggplot style). Customised styles can be achieved by modifying the returned ggplot object.

group
    

Columns to use to determine the group.

label
    

Character vector with the columns to display interactively in `plotly`.

## Value

A plot object.

## Examples
    
    
    result <- [mockSummarisedResult](mockSummarisedResult.html)() |>
      dplyr::[filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "age")
    
    scatterPlot(
      result = result,
      x = "cohort_name",
      y = "mean",
      line = TRUE,
      point = TRUE,
      ribbon = FALSE,
      facet = age_group ~ sex)
    #> `geom_line()`: Each group consists of only one observation.
    #> ℹ Do you need to adjust the group aesthetic?
    #> `geom_line()`: Each group consists of only one observation.
    #> ℹ Do you need to adjust the group aesthetic?
    #> `geom_line()`: Each group consists of only one observation.
    #> ℹ Do you need to adjust the group aesthetic?
    #> `geom_line()`: Each group consists of only one observation.
    #> ℹ Do you need to adjust the group aesthetic?
    #> `geom_line()`: Each group consists of only one observation.
    #> ℹ Do you need to adjust the group aesthetic?
    #> `geom_line()`: Each group consists of only one observation.
    #> ℹ Do you need to adjust the group aesthetic?
    #> `geom_line()`: Each group consists of only one observation.
    #> ℹ Do you need to adjust the group aesthetic?
    #> `geom_line()`: Each group consists of only one observation.
    #> ℹ Do you need to adjust the group aesthetic?
    #> `geom_line()`: Each group consists of only one observation.
    #> ℹ Do you need to adjust the group aesthetic?
    ![](scatterPlot-1.png)
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/plotColumns.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Columns for the plot functions

Source: [`R/helperFunctions.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/helperFunctions.R)

`plotColumns.Rd`

Names of the columns that can be used in the input arguments for the plot functions.

## Usage
    
    
    plotColumns(result)

## Arguments

result
    

A `<summarised_result>` object.

## Value

A character vector of supported columns for plots.

## Examples
    
    
    result <- [mockSummarisedResult](mockSummarisedResult.html)()
    plotColumns(result)
    #>  [1] "cdm_name"       "cohort_name"    "age_group"      "sex"           
    #>  [5] "variable_name"  "variable_level" "count"          "mean"          
    #>  [9] "sd"             "percentage"    
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/setGlobalPlotOptions.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Set format options for all subsequent plots

Source: [`R/helperFunctions.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/helperFunctions.R)

`setGlobalPlotOptions.Rd`

Set format options for all subsequent plots unless state a different style in a specific function

## Usage
    
    
    setGlobalPlotOptions(style = NULL)

## Arguments

style
    

Which style to apply to the plot, options are: "default", "darwin" and NULL (default ggplot style). Customised styles can be achieved by modifying the returned ggplot object.

## Examples
    
    
    setGlobalPlotOptions(style = "darwin")
    
    result <- [mockSummarisedResult](mockSummarisedResult.html)() |>
      dplyr::[filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "age")
    
    [scatterPlot](scatterPlot.html)(
      result = result,
      x = "cohort_name",
      y = "mean",
      line = TRUE,
      point = TRUE,
      ribbon = FALSE,
      facet = age_group ~ sex)
    #> `geom_line()`: Each group consists of only one observation.
    #> ℹ Do you need to adjust the group aesthetic?
    #> `geom_line()`: Each group consists of only one observation.
    #> ℹ Do you need to adjust the group aesthetic?
    #> `geom_line()`: Each group consists of only one observation.
    #> ℹ Do you need to adjust the group aesthetic?
    #> `geom_line()`: Each group consists of only one observation.
    #> ℹ Do you need to adjust the group aesthetic?
    #> `geom_line()`: Each group consists of only one observation.
    #> ℹ Do you need to adjust the group aesthetic?
    #> `geom_line()`: Each group consists of only one observation.
    #> ℹ Do you need to adjust the group aesthetic?
    #> `geom_line()`: Each group consists of only one observation.
    #> ℹ Do you need to adjust the group aesthetic?
    #> `geom_line()`: Each group consists of only one observation.
    #> ℹ Do you need to adjust the group aesthetic?
    #> `geom_line()`: Each group consists of only one observation.
    #> ℹ Do you need to adjust the group aesthetic?
    ![](setGlobalPlotOptions-1.png)
    
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/themeDarwin.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Apply Darwin styling to a ggplot

Source: [`R/plottingThemes.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/plottingThemes.R)

`themeDarwin.Rd`

Apply Darwin styling to a ggplot

## Usage
    
    
    themeDarwin(fontsizeRef = 10)

## Arguments

fontsizeRef
    

An integer to use as reference when adjusting label fontsize.

## Examples
    
    
    result <- [mockSummarisedResult](mockSummarisedResult.html)() |> dplyr::[filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "age")
    
    [barPlot](barPlot.html)(
      result = result,
      x = "cohort_name",
      y = "mean",
      facet = [c](https://rdrr.io/r/base/c.html)("age_group", "sex"),
      colour = "sex") +
     themeDarwin()
    ![](themeDarwin-1.png)
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/customiseText.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# Apply styling to text or column names

Source: [`R/customiseText.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/customiseText.R)

`customiseText.Rd`

This function styles character vectors or column names in a data frame. The styling function can be customised, or you can provide specific replacements for certain values.

## Usage
    
    
    customiseText(
      x,
      fun = function(x) stringr::[str_to_sentence](https://stringr.tidyverse.org/reference/case.html)([gsub](https://rdrr.io/r/base/grep.html)("_", " ", x)),
      custom = NULL,
      keep = NULL
    )

## Arguments

x
    

A character vector to style text.

fun
    

A styling function to apply to text in `x`. The default function converts snake_case to sentence case.

custom
    

A named character vector indicating custom names for specific values in `x`. If NULL, the styling function in `fun` is applied to all values.

keep
    

Either a character vector of names to keep unchanged. If NULL, all names will be styled.

## Value

A character vector of styled text or a data frame with styled column names.

## Examples
    
    
    # Styling a character vector
    customiseText([c](https://rdrr.io/r/base/c.html)("some_column_name", "another_column"))
    #> [1] "Some column name" "Another column"  
    
    # Custom styling for specific values
    customiseText(x = [c](https://rdrr.io/r/base/c.html)("some_column", "another_column"),
              custom = [c](https://rdrr.io/r/base/c.html)("Custom Name" = "another_column"))
    #> [1] "Some column" "Custom Name"
    
    # Keeping specific values unchanged
    customiseText(x = [c](https://rdrr.io/r/base/c.html)("some_column", "another_column"), keep = "another_column")
    #> [1] "Some column"    "another_column"
    
    # Styling column names and variables in a data frame
    dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      some_column = [c](https://rdrr.io/r/base/c.html)("hi_there", "rename_me", "example", "to_keep"),
      another_column = 1:4,
      to_keep = "as_is"
    ) |>
      dplyr::[mutate](https://dplyr.tidyverse.org/reference/mutate.html)(
        "some_column" = customiseText(some_column, custom = [c](https://rdrr.io/r/base/c.html)("EXAMPLE" = "example"), keep = "to_keep")
      ) |>
      dplyr::[rename_with](https://dplyr.tidyverse.org/reference/rename.html)(.fn = ~ customiseText(.x, keep = "to_keep"))
    #> # A tibble: 4 × 3
    #>   `Some column` `Another column` to_keep
    #>   <chr>                    <int> <chr>  
    #> 1 Hi there                     1 as_is  
    #> 2 Rename me                    2 as_is  
    #> 3 EXAMPLE                      3 as_is  
    #> 4 to_keep                      4 as_is  
    

## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/visOmopResults/reference/visOmopResults-package.html

Skip to contents

[visOmopResults](../index.html) 1.2.0

  * [Reference](../reference/index.html)
  * Articles
    * [Tables](../articles/a01_tables.html)
    * [Plots](../articles/a02_plots.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/visOmopResults/)



![](../logo.png)

# visOmopResults: Graphs and Tables for OMOP Results

Source: [`R/visOmopResults-package.R`](https://github.com/darwin-eu/visOmopResults/blob/v1.2.0/R/visOmopResults-package.R)

`visOmopResults-package.Rd`

Provides methods to transform omop_result objects into formatted tables and figures, facilitating the visualisation of study results working with the Observational Medical Outcomes Partnership (OMOP) Common Data Model.

## See also

Useful links:

  * <https://darwin-eu.github.io/visOmopResults/>

  * <https://github.com/darwin-eu/visOmopResults>

  * Report bugs at <https://github.com/darwin-eu/visOmopResults/issues>




## Author

**Maintainer** : Núria Mercadé-Besora [nuria.mercadebesora@ndorms.ox.ac.uk](mailto:nuria.mercadebesora@ndorms.ox.ac.uk) ([ORCID](https://orcid.org/0009-0006-7948-3747))

Authors:

  * Martí Català [marti.catalasabate@ndorms.ox.ac.uk](mailto:marti.catalasabate@ndorms.ox.ac.uk) ([ORCID](https://orcid.org/0000-0003-3308-9905))




Other contributors:

  * Yuchen Guo [yuchen.guo@ndorms.ox.ac.uk](mailto:yuchen.guo@ndorms.ox.ac.uk) ([ORCID](https://orcid.org/0000-0002-0847-4855)) [contributor]

  * Elin Rowlands [elin.rowlands@ndorms.ox.ac.uk](mailto:elin.rowlands@ndorms.ox.ac.uk) ([ORCID](https://orcid.org/0009-0007-6629-4661)) [contributor]

  * Marta Alcalde-Herraiz [marta.alcaldeherraiz@ndorms.ox.ac.uk](mailto:marta.alcaldeherraiz@ndorms.ox.ac.uk) ([ORCID](https://orcid.org/0009-0002-4405-1814)) [contributor]

  * Edward Burn [edward.burn@ndorms.ox.ac.uk](mailto:edward.burn@ndorms.ox.ac.uk) ([ORCID](https://orcid.org/0000-0002-9286-1128)) [contributor]




## On this page

Developed by Martí Català, Núria Mercadé-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
