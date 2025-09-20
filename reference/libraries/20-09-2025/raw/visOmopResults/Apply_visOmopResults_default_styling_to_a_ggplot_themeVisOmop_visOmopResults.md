# Apply visOmopResults default styling to a ggplot — themeVisOmop • visOmopResults

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
