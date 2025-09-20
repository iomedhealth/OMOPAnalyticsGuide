# Unite one or more columns in additional_name-additional_level format — uniteAdditional • omopgenerics

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Unite one or more columns in additional_name-additional_level format

Source: [`R/unite.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/unite.R)

`uniteAdditional.Rd`

Unites targeted table columns into additional_name-additional_level columns.

## Usage
    
    
    uniteAdditional(
      x,
      cols = [character](https://rdrr.io/r/base/character.html)(0),
      keep = FALSE,
      ignore = [c](https://rdrr.io/r/base/c.html)(NA, "overall")
    )

## Arguments

x
    

Tibble or dataframe.

cols
    

Columns to aggregate.

keep
    

Whether to keep the original columns.

ignore
    

Level values to ignore.

## Value

A tibble with the new columns.

## Examples
    
    
    x <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      variable = "number subjects",
      value = [c](https://rdrr.io/r/base/c.html)(10, 15, 40, 78),
      sex = [c](https://rdrr.io/r/base/c.html)("Male", "Female", "Male", "Female"),
      age_group = [c](https://rdrr.io/r/base/c.html)("<40", ">40", ">40", "<40")
    )
    
    x |>
      uniteAdditional([c](https://rdrr.io/r/base/c.html)("sex", "age_group"))
    #> # A tibble: 4 × 4
    #>   variable        value additional_name   additional_level
    #>   <chr>           <dbl> <chr>             <chr>           
    #> 1 number subjects    10 sex &&& age_group Male &&& <40    
    #> 2 number subjects    15 sex &&& age_group Female &&& >40  
    #> 3 number subjects    40 sex &&& age_group Male &&& >40    
    #> 4 number subjects    78 sex &&& age_group Female &&& <40  
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
