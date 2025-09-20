# Supported predefined styles for formatted tables — tableStyle • visOmopResults

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
