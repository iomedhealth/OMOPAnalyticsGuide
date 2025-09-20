# Set format options for all subsequent plots — setGlobalPlotOptions • visOmopResults

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
