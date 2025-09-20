# Categorize a numeric variable — addCategories • PatientProfiles

Skip to contents

[PatientProfiles](../index.html) 1.4.2

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### PatientProfiles

    * [Adding patient demographics](../articles/demographics.html)
    * [Adding cohort intersections](../articles/cohort-intersect.html)
    * [Adding concept intersections](../articles/concept-intersect.html)
    * [Adding table intersections](../articles/table-intersect.html)
    * [Summarise result](../articles/summarise.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/PatientProfiles/)



![](../logo.png)

# Categorize a numeric variable

Source: [`R/addCategories.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/addCategories.R)

`addCategories.Rd`

Categorize a numeric variable

## Usage
    
    
    addCategories(
      x,
      variable,
      categories,
      missingCategoryValue = "None",
      overlap = FALSE,
      includeLowerBound = TRUE,
      includeUpperBound = TRUE,
      name = NULL
    )

## Arguments

x
    

Table with individuals in the cdm.

variable
    

Target variable that we want to categorize.

categories
    

List of lists of named categories with lower and upper limit.

missingCategoryValue
    

Value to assign to those individuals not in any named category. If NULL or NA, missing values will not be changed.

overlap
    

TRUE if the categories given overlap.

includeLowerBound
    

Whether to include the lower bound in the group.

includeUpperBound
    

Whether to include the upper bound in the group.

name
    

Name of the new table, if NULL a temporary table is returned.

## Value

The x table with the categorical variable added.

## Examples
    
    
    # \donttest{
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    
    result <- cdm$cohort1 |>
      [addAge](addAge.html)() |>
      addCategories(
        variable = "age",
        categories = [list](https://rdrr.io/r/base/list.html)("age_group" = [list](https://rdrr.io/r/base/list.html)(
          "0 to 39" = [c](https://rdrr.io/r/base/c.html)(0, 39), "40 to 79" = [c](https://rdrr.io/r/base/c.html)(40, 79), "80 to 150" = [c](https://rdrr.io/r/base/c.html)(80, 150)
        ))
      )
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
