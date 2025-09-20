# Generate a formatted table from a <summarised_result> — visOmopTable • visOmopResults

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
