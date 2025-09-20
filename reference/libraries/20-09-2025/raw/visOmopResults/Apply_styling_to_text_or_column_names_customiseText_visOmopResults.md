# Apply styling to text or column names — customiseText • visOmopResults

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
