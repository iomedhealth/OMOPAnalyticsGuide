# Plots • visOmopResults

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
