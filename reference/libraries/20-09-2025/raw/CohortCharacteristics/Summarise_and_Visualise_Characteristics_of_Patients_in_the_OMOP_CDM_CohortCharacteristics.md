# Summarise and Visualise Characteristics of Patients in the OMOP CDM • CohortCharacteristics

Skip to contents

[CohortCharacteristics](index.html) 1.0.0

  * [Reference](reference/index.html)
  * Articles
    * [Summarise cohort entries](articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](articles/summarise_cohort_timing.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](logo.png)

# CohortCharacteristics 

[![CRAN status](https://www.r-pkg.org/badges/version/CohortCharacteristics)](https://CRAN.R-project.org/package=CohortCharacteristics) [![codecov.io](https://codecov.io/github/darwin-eu/CohortCharacteristics/coverage.svg?branch=main)](https://app.codecov.io/github/darwin-eu/CohortCharacteristics?branch=main) [![R-CMD-check](https://github.com/darwin-eu/CohortCharacteristics/workflows/R-CMD-check/badge.svg)](https://github.com/darwin-eu/CohortCharacteristics/actions) [![Lifecycle:Experimental](https://img.shields.io/badge/Lifecycle-Experimental-339999)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Package overview

CohortCharacteristics contains functions for summarising characteristics of cohorts of patients identified in an OMOP CDM dataset. Once a cohort table has been created, CohortCharacteristics provides a number of functions to help provide a summary of the characteristics of the individuals within the cohort.
    
    
    #> To cite package 'CohortCharacteristics' in publications use:
    #> 
    #>   Catala M, Guo Y, Lopez-Guell K, Burn E, Mercade-Besora N, Alcalde M
    #>   (????). _CohortCharacteristics: Summarise and Visualise
    #>   Characteristics of Patients in the OMOP CDM_. R package version
    #>   0.5.1, <https://darwin-eu.github.io/CohortCharacteristics/>.
    #> 
    #> A BibTeX entry for LaTeX users is
    #> 
    #>   @Manual{,
    #>     title = {CohortCharacteristics: Summarise and Visualise Characteristics of Patients in the OMOP CDM},
    #>     author = {Marti Catala and Yuchen Guo and Kim Lopez-Guell and Edward Burn and Nuria Mercade-Besora and Marta Alcalde},
    #>     note = {R package version 0.5.1},
    #>     url = {https://darwin-eu.github.io/CohortCharacteristics/},
    #>   }

## Package installation

You can install the latest version of CohortCharacteristics from CRAN:
    
    
    [install.packages](https://rdrr.io/r/utils/install.packages.html)("CohortCharacteristics")

Or install the development version from github:
    
    
    [install.packages](https://rdrr.io/r/utils/install.packages.html)("pak")
    pak::[pkg_install](https://pak.r-lib.org/reference/pkg_install.html)("darwin-eu/CohortCharacteristics")
    
    
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))

## Content

The package contain three types of functions:

  * **summarise** * type functions. These functions produce  standard output. See [omopgenerics](https://darwin-eu.github.io/omopgenerics/articles/summarised_result.html) for more information on this standardised output format. These functions are the ones that do the work in terms of extracting the necessary data from the cdm and summarising it.
  * **table** * type functions. These functions work with the output of the summarise ones. They will produce a table visualisation created using the [visOmopResults](https://cran.r-project.org/package=visOmopResults) package.
  * **plot** * type functions. These functions work with the output of the summarise ones. They will produce a plot visualisation created using the [visOmopResults](https://cran.r-project.org/package=visOmopResults) package.



## Examples

### Mock data

Although the package provides some simple mock data for testing (`[mockCohortCharacteristics()](reference/mockCohortCharacteristics.html)`), for these examples we will use the GiBleed dataset that can be downloaded using the CDMConnector package that will give us some more real results.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)()
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, cdmSchema = "main", writeSchema = "main")

Let’s create a simple cohort:
    
    
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    cdm <- [generateIngredientCohortSet](https://darwin-eu.github.io/DrugUtilisation/reference/generateIngredientCohortSet.html)(cdm = cdm, name = "my_cohort", ingredient = [c](https://rdrr.io/r/base/c.html)("warfarin", "acetaminophen"))

### Cohort counts

We can get counts using the function `[summariseCohortCount()](reference/summariseCohortCount.html)`:
    
    
    result <- [summariseCohortCount](reference/summariseCohortCount.html)(cdm$my_cohort)
    result |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 4
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1
    #> $ cdm_name         <chr> "Synthea", "Synthea", "Synthea", "Synthea"
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "acetaminophen", "acetaminophen", "warfarin", "warfar…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall"
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall"
    #> $ variable_name    <chr> "Number records", "Number subjects", "Number records"…
    #> $ variable_level   <chr> NA, NA, NA, NA
    #> $ estimate_name    <chr> "count", "count", "count", "count"
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer"
    #> $ estimate_value   <chr> "13907", "2679", "137", "137"
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall"
    #> $ additional_level <chr> "overall", "overall", "overall", "overall"

You can easily create a table using the associated table function, `[tableCohortCount()](reference/tableCohortCount.html)`:
    
    
    [tableCohortCount](reference/tableCohortCount.html)(result, type = "flextable")

![](reference/figures/README-unnamed-chunk-9-1.png)

We could create a simple plot with `[plotCohortCount()](reference/plotCohortCount.html)`:
    
    
    result |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "Number subjects") |>
      [plotCohortCount](reference/plotCohortCount.html)(x = "cohort_name", colour = "cohort_name")

![](reference/figures/README-unnamed-chunk-10-1.png)

All the other function work using the same dynamic, first `summarise`, then `plot`/`table`.

### Cohort attrition
    
    
    result <- [summariseCohortAttrition](reference/summariseCohortAttrition.html)(cdm$my_cohort)
    
    
    [tableCohortAttrition](reference/tableCohortAttrition.html)(result, type = "flextable")

![](reference/figures/README-unnamed-chunk-12-1.png)
    
    
    result |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(group_level == "161_acetaminophen") |>
      [plotCohortAttrition](reference/plotCohortAttrition.html)()

![](reference/figures/attrition.svg)

### Characteristics
    
    
    result <- [summariseCharacteristics](reference/summariseCharacteristics.html)(cdm$my_cohort)
    
    
    [tableCharacteristics](reference/tableCharacteristics.html)(result, type = "flextable")

![](reference/figures/README-unnamed-chunk-16-1.png)
    
    
    result |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "Age") |>
      [plotCharacteristics](reference/plotCharacteristics.html)(plotType = "boxplot", colour = "cohort_name")

![](reference/figures/README-unnamed-chunk-17-1.png)

### Timing between cohorts
    
    
    result <- [summariseCohortTiming](reference/summariseCohortTiming.html)(cdm$my_cohort)
    
    
    [tableCohortTiming](reference/tableCohortTiming.html)(result, type = "flextable")

![](reference/figures/README-unnamed-chunk-19-1.png)
    
    
    [plotCohortTiming](reference/plotCohortTiming.html)(
      result,
      uniqueCombinations = TRUE,
      facet = "cdm_name",
      colour = [c](https://rdrr.io/r/base/c.html)("cohort_name_reference", "cohort_name_comparator"),
      timeScale = "years"
    )

![](reference/figures/README-unnamed-chunk-20-1.png)
    
    
    [plotCohortTiming](reference/plotCohortTiming.html)(
      result,
      plotType = "densityplot",
      uniqueCombinations = FALSE,
      facet = "cdm_name",
      colour = [c](https://rdrr.io/r/base/c.html)("cohort_name_comparator"),
      timeScale = "years"
    )

![](reference/figures/README-unnamed-chunk-21-1.png)

### Overlap between cohort
    
    
    result <- [summariseCohortOverlap](reference/summariseCohortOverlap.html)(cdm$my_cohort)
    
    
    [tableCohortOverlap](reference/tableCohortOverlap.html)(result, type = "flextable")

![](reference/figures/README-unnamed-chunk-23-1.png)
    
    
    [plotCohortOverlap](reference/plotCohortOverlap.html)(result, uniqueCombinations = TRUE)

![](reference/figures/README-unnamed-chunk-24-1.png)

### Large scale characteristics
    
    
    result <- cdm$my_cohort |>
      [summariseLargeScaleCharacteristics](reference/summariseLargeScaleCharacteristics.html)(
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-90, -1), [c](https://rdrr.io/r/base/c.html)(0, 0), [c](https://rdrr.io/r/base/c.html)(1, 90)),
        eventInWindow = "condition_occurrence"
      )
    
    
    [tableTopLargeScaleCharacteristics](reference/tableTopLargeScaleCharacteristics.html)(result, type = "flextable")

![](reference/figures/README-unnamed-chunk-26-1.png)
    
    
    result |>
      omopgenerics::[filterGroup](https://darwin-eu.github.io/omopgenerics/reference/filterGroup.html)(cohort_name == "acetaminophen") |>
      [plotLargeScaleCharacteristics](reference/plotLargeScaleCharacteristics.html)()

![](reference/figures/README-unnamed-chunk-27-1.png)
    
    
    result |>
      omopgenerics::[filterGroup](https://darwin-eu.github.io/omopgenerics/reference/filterGroup.html)(cohort_name == "acetaminophen") |>
      [plotComparedLargeScaleCharacteristics](reference/plotComparedLargeScaleCharacteristics.html)(
        reference = "-90 to -1", colour = "variable_level"
      )

![](reference/figures/README-unnamed-chunk-28-1.png)

### Disconnect

Disconnect from your database using `[CDMConnector::cdmDisconnect()](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)` to close the connection or with `[mockDisconnect()](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)` to close connection and delete the created mock data:
    
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)

### Recommendations

Although it is technically possible, we do not recommend to pipe table or plot functions with the summarise ones. The main reason is that summarise functions take some time to run, a large scale characterisation in a big cdm object can take a few hours. If we pipe the output to a table/plot function we loose the summarise result object. In fact, some times we would send code around to be ran in others database and what we want to export is the summarised_result objects and not the table or plot which we would like to build after compiling results from different cdm objects.

**Not recommended** :
    
    
    cdm$my_cohort |>
      [summariseCharacteristics](reference/summariseCharacteristics.html)() |>
      [tableCharacteristics](reference/tableCharacteristics.html)()

**Recommended** :
    
    
    x <- [summariseCharacteristics](reference/summariseCharacteristics.html)(cdm$my_cohort)
    
    [tableCharacteristics](reference/tableCharacteristics.html)(x)

## Links

  * [View on CRAN](https://cloud.r-project.org/package=CohortCharacteristics)
  * [Browse source code](https://github.com/darwin-eu/CohortCharacteristics/)
  * [Report a bug](https://github.com/darwin-eu/CohortCharacteristics/issues)



## License

  * [Full license](LICENSE.html)
  * Apache License (>= 2)



## Community

  * [Contributing guide](CONTRIBUTING.html)



## Citation

  * [Citing CohortCharacteristics](authors.html#citation)



## Developers

  * Marti Catala   
Author, maintainer  [](https://orcid.org/0000-0003-3308-9905)
  * Yuchen Guo   
Author  [](https://orcid.org/0000-0002-0847-4855)
  * Kim Lopez-Guell   
Author  [](https://orcid.org/0000-0002-8462-8668)
  * Edward Burn   
Author  [](https://orcid.org/0000-0002-9286-1128)
  * Nuria Mercade-Besora   
Author  [](https://orcid.org/0009-0006-7948-3747)
  * Marta Alcalde   
Author  [](https://orcid.org/0009-0002-4405-1814)
  * [More about authors...](authors.html)



Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
