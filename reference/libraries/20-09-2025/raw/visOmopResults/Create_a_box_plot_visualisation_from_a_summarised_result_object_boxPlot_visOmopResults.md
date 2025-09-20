# Create a box plot visualisation from a <summarised_result> object — boxPlot • visOmopResults

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
