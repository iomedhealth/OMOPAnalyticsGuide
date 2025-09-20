# Graphs and Tables for OMOP Results • visOmopResults

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
