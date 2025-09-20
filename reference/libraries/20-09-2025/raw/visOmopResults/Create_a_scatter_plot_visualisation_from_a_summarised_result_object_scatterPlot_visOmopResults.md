# Create a scatter plot visualisation from a <summarised_result> object — scatterPlot • visOmopResults

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
