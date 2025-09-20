# Create a bar plot visualisation from a <summarised_result> object — barPlot • visOmopResults

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
