# Content from https://darwin-eu.github.io/CohortCharacteristics/


---

## Content from https://darwin-eu.github.io/CohortCharacteristics/

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

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/index.html

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

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/index.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Package index

### Summarise patient characteristic standard function

`[summariseCharacteristics()](summariseCharacteristics.html)`
    Summarise characteristics of cohorts in a cohort table

`[summariseCohortAttrition()](summariseCohortAttrition.html)`
    Summarise attrition associated with cohorts in a cohort table

`[summariseCohortCodelist()](summariseCohortCodelist.html)` experimental
    Summarise the cohort codelist attribute

`[summariseCohortCount()](summariseCohortCount.html)`
    Summarise counts for cohorts in a cohort table

`[summariseCohortOverlap()](summariseCohortOverlap.html)`
    Summarise overlap between cohorts in a cohort table

`[summariseCohortTiming()](summariseCohortTiming.html)`
    Summarise timing between entries into cohorts in a cohort table

`[summariseLargeScaleCharacteristics()](summariseLargeScaleCharacteristics.html)`
    This function is used to summarise the large scale characteristics of a cohort table

### Create visual tables from summarised objects

`[tableCharacteristics()](tableCharacteristics.html)` experimental
    Format a summarise_characteristics object into a visual table.

`[tableCohortAttrition()](tableCohortAttrition.html)` experimental
    Create a visual table from the output of summariseCohortAttrition.

`[tableCohortCodelist()](tableCohortCodelist.html)` experimental
    Create a visual table from `<summarised_result>` object from `[summariseCohortCodelist()](../reference/summariseCohortCodelist.html)`

`[tableCohortCount()](tableCohortCount.html)` experimental
    Format a summarise_characteristics object into a visual table.

`[tableCohortOverlap()](tableCohortOverlap.html)` experimental
    Format a summariseOverlapCohort result into a visual table.

`[tableCohortTiming()](tableCohortTiming.html)` experimental
    Format a summariseCohortTiming result into a visual table.

`[tableLargeScaleCharacteristics()](tableLargeScaleCharacteristics.html)`
    Explore and compare the large scale characteristics of cohorts

`[tableTopLargeScaleCharacteristics()](tableTopLargeScaleCharacteristics.html)`
    Visualise the top concepts per each cdm name, cohort, statification and window.

`[availableTableColumns()](availableTableColumns.html)`
    Available columns to use in `header`, `groupColumn` and `hide` arguments in table functions.

### Generate ggplot2 plots from summarised_result objects

Functions to generate plots (ggplot2) from summarised objects.

`[plotCharacteristics()](plotCharacteristics.html)` experimental
    Create a ggplot from the output of summariseCharacteristics.

`[plotCohortAttrition()](plotCohortAttrition.html)` experimental
    create a ggplot from the output of summariseLargeScaleCharacteristics.

`[plotCohortCount()](plotCohortCount.html)` experimental
    Plot the result of summariseCohortCount.

`[plotCohortOverlap()](plotCohortOverlap.html)` experimental
    Plot the result of summariseCohortOverlap.

`[plotCohortTiming()](plotCohortTiming.html)` experimental
    Plot summariseCohortTiming results.

`[plotComparedLargeScaleCharacteristics()](plotComparedLargeScaleCharacteristics.html)` experimental
    create a ggplot from the output of summariseLargeScaleCharacteristics.

`[plotLargeScaleCharacteristics()](plotLargeScaleCharacteristics.html)` experimental
    create a ggplot from the output of summariseLargeScaleCharacteristics.

`[availablePlotColumns()](availablePlotColumns.html)`
    Available columns to use in `facet` and `colour` arguments in plot functions.

### Benchmark

`[benchmarkCohortCharacteristics()](benchmarkCohortCharacteristics.html)`
    Benchmark the main functions of CohortCharacteristics package.

### Helper functions

`[mockCohortCharacteristics()](mockCohortCharacteristics.html)`
    It creates a mock database for testing CohortCharacteristics package

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/articles/summarise_cohort_entries.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Summarise cohort entries

Source: [`vignettes/articles/summarise_cohort_entries.Rmd`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/vignettes/articles/summarise_cohort_entries.Rmd)

`summarise_cohort_entries.Rmd`

## Introduction

In this example we’re going to summarise the characteristics of individuals with an ankle sprain, ankle fracture, forearm fracture, or a hip fracture using the Eunomia synthetic data.

We’ll begin by creating our study cohorts.
    
    
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con = con, cdmSchem = "main", writeSchema = "main", cdmName = "Eunomia"
    )
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      name = "injuries",
      conceptSet = [list](https://rdrr.io/r/base/list.html)(
        "ankle_sprain" = 81151,
        "ankle_fracture" = 4059173,
        "forearm_fracture" = 4278672,
        "hip_fracture" = 4230399
      ),
      end = "event_end_date",
      limit = "all"
    )

## Summarising cohort counts

We can first quickly summarise and present the overall counts of our cohorts.
    
    
    cohortCounts <- [summariseCohortCount](../reference/summariseCohortCount.html)(cdm$injuries)
    [tableCohortCount](../reference/tableCohortCount.html)(cohortCounts)

CDM name | Variable name | Estimate name |  Cohort name  
---|---|---|---  
ankle_sprain | ankle_fracture | forearm_fracture | hip_fracture  
Eunomia | Number records | N | 1,915 | 464 | 569 | 138  
| Number subjects | N | 1,357 | 427 | 510 | 132  
  
Moreover, we can also easily stratify these counts. For example, here we add age groups and then stratify our counts by t We can summarise the overall counts of our cohorts.
    
    
    cdm$injuries <- cdm$injuries |>
      [addAge](https://darwin-eu.github.io/PatientProfiles/reference/addAge.html)(
        ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 3), [c](https://rdrr.io/r/base/c.html)(4, 17), [c](https://rdrr.io/r/base/c.html)(18, Inf)),
        name = "injuries"
      )
    
    cohortCounts <- [summariseCohortCount](../reference/summariseCohortCount.html)(cdm[["injuries"]], strata = "age_group")
    [tableCohortCount](../reference/tableCohortCount.html)(cohortCounts)

CDM name | Age group | Variable name | Estimate name |  Cohort name  
---|---|---|---|---  
ankle_sprain | ankle_fracture | forearm_fracture | hip_fracture  
Eunomia | overall | Number records | N | 1,915 | 464 | 569 | 138  
|  | Number subjects | N | 1,357 | 427 | 510 | 132  
| 0 to 3 | Number records | N | 202 | 49 | 51 | 7  
|  | Number subjects | N | 196 | 49 | 51 | 7  
| 18 or above | Number records | N | 1,047 | 213 | 268 | 88  
|  | Number subjects | N | 847 | 204 | 249 | 83  
| 4 to 17 | Number records | N | 666 | 202 | 250 | 43  
|  | Number subjects | N | 597 | 195 | 239 | 43  
  
We can also apply minimum cell count suppression to our cohort counts. In this case we will obscure any counts below 10.
    
    
    cohortCounts <- cohortCounts |>
      [suppress](https://darwin-eu.github.io/omopgenerics/reference/suppress.html)(minCellCount = 10)
    [tableCohortCount](../reference/tableCohortCount.html)(cohortCounts)

CDM name | Age group | Variable name | Estimate name |  Cohort name  
---|---|---|---|---  
ankle_sprain | ankle_fracture | forearm_fracture | hip_fracture  
Eunomia | overall | Number records | N | 1,915 | 464 | 569 | 138  
|  | Number subjects | N | 1,357 | 427 | 510 | 132  
| 0 to 3 | Number records | N | 202 | 49 | 51 | <10  
|  | Number subjects | N | 196 | 49 | 51 | <10  
| 18 or above | Number records | N | 1,047 | 213 | 268 | 88  
|  | Number subjects | N | 847 | 204 | 249 | 83  
| 4 to 17 | Number records | N | 666 | 202 | 250 | 43  
|  | Number subjects | N | 597 | 195 | 239 | 43  
  
## Summarising cohort attrition

Say we specify two inclusion criteria. First, we keep only cohort entries after the year 2000. Second, we keep only cohort entries for those aged 18 or older. We can easily create plots summarising our cohort attrition.
    
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      name = "ankle_sprain",
      conceptSet = [list](https://rdrr.io/r/base/list.html)("ankle_sprain" = 81151),
      end = "event_end_date",
      limit = "all"
    )
    
    cdm$ankle_sprain <- cdm$ankle_sprain |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(year(cohort_start_date) >= 2000) |>
      [compute](https://dplyr.tidyverse.org/reference/compute.html)(temporary = FALSE, name = "ankle_sprain") |>
      [recordCohortAttrition](https://darwin-eu.github.io/omopgenerics/reference/recordCohortAttrition.html)("Restrict to cohort_start_date >= 2000")
    
    attritionSummary <- [summariseCohortAttrition](../reference/summariseCohortAttrition.html)(cdm$ankle_sprain)
    
    [plotCohortAttrition](../reference/plotCohortAttrition.html)(attritionSummary)
    
    
    cdm$ankle_sprain <- cdm$ankle_sprain |>
      [addAge](https://darwin-eu.github.io/PatientProfiles/reference/addAge.html)() |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(age >= 18) |>
      [compute](https://dplyr.tidyverse.org/reference/compute.html)(temporary = FALSE, name = "ankle_sprain") |>
      [recordCohortAttrition](https://darwin-eu.github.io/omopgenerics/reference/recordCohortAttrition.html)("Restrict to age >= 18")
    
    attritionSummary <- [summariseCohortAttrition](../reference/summariseCohortAttrition.html)(cdm$ankle_sprain)
    
    [plotCohortAttrition](../reference/plotCohortAttrition.html)(attritionSummary)

We could, of course, have applied these requirements the other way around.
    
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      name = "ankle_sprain",
      conceptSet = [list](https://rdrr.io/r/base/list.html)("ankle_sprain" = 81151),
      end = "event_end_date",
      limit = "all"
    )
    
    cdm$ankle_sprain <- cdm$ankle_sprain |>
      [addAge](https://darwin-eu.github.io/PatientProfiles/reference/addAge.html)() |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(age >= 18) |>
      [compute](https://dplyr.tidyverse.org/reference/compute.html)(temporary = FALSE, name = "ankle_sprain") |>
      [recordCohortAttrition](https://darwin-eu.github.io/omopgenerics/reference/recordCohortAttrition.html)("Restrict to age >= 18")
    
    cdm$ankle_sprain <- cdm$ankle_sprain |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(year(cohort_start_date) >= 2000) |>
      [compute](https://dplyr.tidyverse.org/reference/compute.html)(temporary = FALSE, name = "ankle_sprain") |>
      [recordCohortAttrition](https://darwin-eu.github.io/omopgenerics/reference/recordCohortAttrition.html)("Restrict to cohort_start_date >= 2000")
    
    attritionSummary <- [summariseCohortAttrition](../reference/summariseCohortAttrition.html)(cdm$ankle_sprain)
    
    [plotCohortAttrition](../reference/plotCohortAttrition.html)(attritionSummary)

As well as plotting cohort attrition, we can also create a table of our results.
    
    
    [tableCohortAttrition](../reference/tableCohortAttrition.html)(attritionSummary)

Reason |  Variable name  
---|---  
number_records | number_subjects | excluded_records | excluded_subjects  
Eunomia; ankle_sprain  
Initial qualifying events | 1,915 | 1,357 | 0 | 0  
Restrict to age >= 18 | 1,047 | 847 | 868 | 510  
Restrict to cohort_start_date >= 2000 | 454 | 420 | 593 | 427  
  
## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/articles/summarise_characteristics.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Summarise patient characteristics

Source: [`vignettes/summarise_characteristics.Rmd`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/vignettes/summarise_characteristics.Rmd)

`summarise_characteristics.Rmd`

## Introduction

In this example we’re going to summarise the characteristics of individuals with an ankle sprain, ankle fracture, forearm fracture, or a hip fracture using the Eunomia synthetic database.

We’ll begin by creating our condition study cohorts with the `generateConceptCohortSet` function from `CDMConnector`.
    
    
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con = con, cdmSchem = "main", writeSchema = "main", cdmName = "Eunomia"
    )
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      name = "injuries",
      conceptSet = [list](https://rdrr.io/r/base/list.html)(
        "ankle_sprain" = 81151,
        "ankle_fracture" = 4059173,
        "forearm_fracture" = 4278672,
        "hip_fracture" = 4230399
      ),
      end = "event_end_date",
      limit = "all"
    )
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$injuries)
    #> # A tibble: 4 × 6
    #>   cohort_definition_id cohort_name    limit prior_observation future_observation
    #>                  <int> <chr>          <chr>             <dbl>              <dbl>
    #> 1                    1 ankle_sprain   all                   0                  0
    #> 2                    2 ankle_fracture all                   0                  0
    #> 3                    3 forearm_fract… all                   0                  0
    #> 4                    4 hip_fracture   all                   0                  0
    #> # ℹ 1 more variable: end <chr>
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$injuries)
    #> # A tibble: 4 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1           1915            1357
    #> 2                    2            464             427
    #> 3                    3            569             510
    #> 4                    4            138             132

## Summarising study cohorts

Now we’ve created our cohorts, we can obtain a summary of the characteristics in the patients included in these cohorts. We’ll create two different age group in below example: under 50 and 50+.
    
    
    chars <- cdm$injuries |>
      [summariseCharacteristics](../reference/summariseCharacteristics.html)(ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 49), [c](https://rdrr.io/r/base/c.html)(50, Inf)))
    chars |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 192
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "Eunomia", "Eunomia", "Eunomia", "Eunomia", "Eunomia"…
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "ankle_sprain", "ankle_sprain", "ankle_sprain", "ankl…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Number records", "Number subjects", "Cohort start da…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "count", "count", "min", "q25", "median", "q75", "max…
    #> $ estimate_type    <chr> "integer", "integer", "date", "date", "date", "date",…
    #> $ estimate_value   <chr> "1915", "1357", "1912-02-25", "1968-06-15", "1982-11-…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…

Now we have generated the results, we can create a nice table in gt format to display the results using `tableCharacteristics` function.
    
    
    [tableCharacteristics](../reference/tableCharacteristics.html)(chars)

|  CDM name  
---|---  
|  Eunomia  
Variable name | Variable level | Estimate name |  Cohort name  
ankle_sprain | ankle_fracture | forearm_fracture | hip_fracture  
Number records | - | N | 1,915 | 464 | 569 | 138  
Number subjects | - | N | 1,357 | 427 | 510 | 132  
Cohort start date | - | Median [Q25 - Q75] | 1982-11-09 [1968-06-15 - 1999-04-13] | 1981-01-15 [1965-03-11 - 1997-08-03] | 1981-07-24 [1967-03-05 - 2000-12-16] | 1996-09-17 [1977-09-20 - 2010-06-22]  
|  | Range | 1912-02-25 to 2019-05-30 | 1911-09-07 to 2019-06-23 | 1917-08-16 to 2019-06-26 | 1927-12-14 to 2019-05-08  
Cohort end date | - | Median [Q25 - Q75] | 1982-12-10 [1968-07-06 - 1999-05-09] | 1981-02-28 [1965-04-11 - 1997-10-12] | 1981-08-23 [1967-04-10 - 2001-02-27] | 1996-11-16 [1977-12-04 - 2010-07-22]  
|  | Range | 1912-03-10 to 2019-05-30 | 1911-12-06 to 2019-06-24 | 1917-11-14 to 2019-06-26 | 1928-03-13 to 2019-06-07  
Age | - | Median [Q25 - Q75] | 21 [9 - 41] | 16 [9 - 43] | 17 [9 - 46] | 40 [13 - 66]  
|  | Mean (SD) | 26.63 (21.03) | 27.38 (24.70) | 28.69 (25.97) | 40.06 (28.82)  
|  | Range | 0 to 105 | 0 to 107 | 0 to 106 | 1 to 108  
Age group | 0 to 49 | N (%) | 1,587 (82.87%) | 367 (79.09%) | 440 (77.33%) | 87 (63.04%)  
| 50 or above | N (%) | 328 (17.13%) | 97 (20.91%) | 129 (22.67%) | 51 (36.96%)  
Sex | Female | N (%) | 954 (49.82%) | 238 (51.29%) | 286 (50.26%) | 74 (53.62%)  
| Male | N (%) | 961 (50.18%) | 226 (48.71%) | 283 (49.74%) | 64 (46.38%)  
Prior observation | - | Median [Q25 - Q75] | 7,833 [3,628 - 15,147] | 6,030 [3,360 - 16,032] | 6,289 [3,390 - 16,847] | 14,522 [4,801 - 24,401]  
|  | Mean (SD) | 9,918.17 (7,672.74) | 10,196.57 (9,011.31) | 10,670.43 (9,480.30) | 14,821.73 (10,521.89)  
|  | Range | 299 to 38,429 | 299 to 39,430 | 299 to 38,943 | 390 to 39,792  
Future observation | - | Median [Q25 - Q75] | 12,868 [6,860 - 18,078] | 13,748 [6,878 - 19,331] | 13,165 [5,988 - 18,548] | 7,798 [2,874 - 14,913]  
|  | Mean (SD) | 12,865.11 (7,543.50) | 13,470.92 (8,215.96) | 12,913.27 (7,929.17) | 9,167.33 (7,160.81)  
|  | Range | 0 to 38,403 | 1 to 39,051 | 0 to 36,654 | 0 to 29,045  
Days in cohort | - | Median [Q25 - Q75] | 22 [15 - 29] | 61 [31 - 91] | 61 [31 - 91] | 61 [31 - 91]  
|  | Mean (SD) | 25.02 (8.00) | 61.65 (25.38) | 62.16 (25.32) | 59.26 (24.79)  
|  | Range | 1 to 37 | 2 to 92 | 1 to 91 | 1 to 91  
  
We can also use the `plotCharacteristics` function to display the results in a plot. The `plotCharacteristics` function can only take in one variable. So you will need to filter the results to the variable you want to create a plot for beforehand.
    
    
    chars |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "Age") |>
      [plotCharacteristics](../reference/plotCharacteristics.html)(
        plotType = "boxplot",
        colour = "cohort_name",
        facet = [c](https://rdrr.io/r/base/c.html)("cdm_name")
      )

![](summarise_characteristics_files/figure-html/unnamed-chunk-5-1.png)

## Stratified summaries

We can also generate summaries that are stratified by some variable of interest. In this example we added an age group variable to our cohort table and then created the stratification for age group in our results.
    
    
    chars <- cdm$injuries |>
      [addAge](https://darwin-eu.github.io/PatientProfiles/reference/addAge.html)(ageGroup = [list](https://rdrr.io/r/base/list.html)(
        [c](https://rdrr.io/r/base/c.html)(0, 49),
        [c](https://rdrr.io/r/base/c.html)(50, Inf)
      )) |>
      [summariseCharacteristics](../reference/summariseCharacteristics.html)(strata = [list](https://rdrr.io/r/base/list.html)("age_group"))

Again we used the `tableCharacteristics` function to display the results in gt table format.
    
    
    [tableCharacteristics](../reference/tableCharacteristics.html)(chars,
      groupColumn = "age_group"
    )

|  CDM name  
---|---  
|  Eunomia  
Variable name | Variable level | Estimate name |  Cohort name  
ankle_sprain | ankle_fracture | forearm_fracture | hip_fracture  
overall  
Number records | - | N | 1,915 | 464 | 569 | 138  
Number subjects | - | N | 1,357 | 427 | 510 | 132  
Cohort start date | - | Median [Q25 - Q75] | 1982-11-09 [1968-06-15 - 1999-04-13] | 1981-01-15 [1965-03-11 - 1997-08-03] | 1981-07-24 [1967-03-05 - 2000-12-16] | 1996-09-17 [1977-09-20 - 2010-06-22]  
|  | Range | 1912-02-25 to 2019-05-30 | 1911-09-07 to 2019-06-23 | 1917-08-16 to 2019-06-26 | 1927-12-14 to 2019-05-08  
Cohort end date | - | Median [Q25 - Q75] | 1982-12-10 [1968-07-06 - 1999-05-09] | 1981-02-28 [1965-04-11 - 1997-10-12] | 1981-08-23 [1967-04-10 - 2001-02-27] | 1996-11-16 [1977-12-04 - 2010-07-22]  
|  | Range | 1912-03-10 to 2019-05-30 | 1911-12-06 to 2019-06-24 | 1917-11-14 to 2019-06-26 | 1928-03-13 to 2019-06-07  
Age | - | Median [Q25 - Q75] | 21 [9 - 41] | 16 [9 - 43] | 17 [9 - 46] | 40 [13 - 66]  
|  | Mean (SD) | 26.63 (21.03) | 27.38 (24.70) | 28.69 (25.97) | 40.06 (28.82)  
|  | Range | 0 to 105 | 0 to 107 | 0 to 106 | 1 to 108  
Sex | Female | N (%) | 954 (49.82%) | 238 (51.29%) | 286 (50.26%) | 74 (53.62%)  
| Male | N (%) | 961 (50.18%) | 226 (48.71%) | 283 (49.74%) | 64 (46.38%)  
Prior observation | - | Median [Q25 - Q75] | 7,833 [3,628 - 15,147] | 6,030 [3,360 - 16,032] | 6,289 [3,390 - 16,847] | 14,522 [4,801 - 24,401]  
|  | Mean (SD) | 9,918.17 (7,672.74) | 10,196.57 (9,011.31) | 10,670.43 (9,480.30) | 14,821.73 (10,521.89)  
|  | Range | 299 to 38,429 | 299 to 39,430 | 299 to 38,943 | 390 to 39,792  
Future observation | - | Median [Q25 - Q75] | 12,868 [6,860 - 18,078] | 13,748 [6,878 - 19,331] | 13,165 [5,988 - 18,548] | 7,798 [2,874 - 14,913]  
|  | Mean (SD) | 12,865.11 (7,543.50) | 13,470.92 (8,215.96) | 12,913.27 (7,929.17) | 9,167.33 (7,160.81)  
|  | Range | 0 to 38,403 | 1 to 39,051 | 0 to 36,654 | 0 to 29,045  
Days in cohort | - | Median [Q25 - Q75] | 22 [15 - 29] | 61 [31 - 91] | 61 [31 - 91] | 61 [31 - 91]  
|  | Mean (SD) | 25.02 (8.00) | 61.65 (25.38) | 62.16 (25.32) | 59.26 (24.79)  
|  | Range | 1 to 37 | 2 to 92 | 1 to 91 | 1 to 91  
0 to 49  
Number records | - | N | 1,587 | 367 | 440 | 87  
Number subjects | - | N | 1,211 | 341 | 411 | 86  
Cohort start date | - | Median [Q25 - Q75] | 1978-07-08 [1965-08-07 - 1992-05-07] | 1974-08-26 [1960-08-21 - 1988-07-30] | 1974-12-23 [1964-05-04 - 1988-03-09] | 1983-05-29 [1973-07-30 - 1997-03-20]  
|  | Range | 1912-02-25 to 2019-05-06 | 1911-09-07 to 2018-10-12 | 1917-08-16 to 2019-06-26 | 1927-12-14 to 2019-01-09  
Cohort end date | - | Median [Q25 - Q75] | 1978-08-05 [1965-09-01 - 1992-05-28] | 1974-10-25 [1960-10-20 - 1988-10-09] | 1975-02-06 [1964-06-11 - 1988-05-07] | 1983-08-27 [1973-08-29 - 1997-05-19]  
|  | Range | 1912-03-10 to 2019-05-06 | 1911-12-06 to 2018-11-11 | 1917-11-14 to 2019-06-26 | 1928-03-13 to 2019-04-09  
Age | - | Median [Q25 - Q75] | 16 [7 - 31] | 13 [7 - 25] | 13 [7 - 23] | 15 [9 - 34]  
|  | Mean (SD) | 19.32 (13.95) | 16.49 (12.90) | 16.48 (12.87) | 21.15 (15.27)  
|  | Range | 0 to 49 | 0 to 49 | 0 to 49 | 1 to 49  
Sex | Female | N (%) | 791 (49.84%) | 190 (51.77%) | 213 (48.41%) | 41 (47.13%)  
| Male | N (%) | 796 (50.16%) | 177 (48.23%) | 227 (51.59%) | 46 (52.87%)  
Prior observation | - | Median [Q25 - Q75] | 5,970 [2,910 - 11,512] | 4,941 [2,640 - 9,266] | 4,814 [2,662 - 8,680] | 5,838 [3,510 - 12,728]  
|  | Mean (SD) | 7,249.25 (5,084.37) | 6,221.68 (4,697.60) | 6,212.80 (4,686.12) | 7,920.29 (5,584.42)  
|  | Range | 299 to 18,243 | 299 to 18,105 | 299 to 18,158 | 390 to 18,086  
Future observation | - | Median [Q25 - Q75] | 14,582 [9,510 - 19,018] | 15,936 [10,900 - 20,859] | 15,833 [11,020 - 19,580] | 12,667 [7,957 - 16,282]  
|  | Mean (SD) | 14,564.63 (6,955.73) | 15,980.16 (7,193.49) | 15,495.41 (6,973.47) | 12,656.62 (6,557.62)  
|  | Range | 0 to 38,403 | 30 to 39,051 | 0 to 36,654 | 162 to 29,045  
Days in cohort | - | Median [Q25 - Q75] | 22 [15 - 29] | 61 [31 - 91] | 61 [31 - 91] | 61 [31 - 91]  
|  | Mean (SD) | 25.06 (7.88) | 61.01 (25.37) | 63.18 (25.35) | 63.41 (23.87)  
|  | Range | 1 to 37 | 31 to 91 | 1 to 91 | 31 to 91  
50 or above  
Number records | - | N | 328 | 97 | 129 | 51  
Number subjects | - | N | 292 | 93 | 116 | 48  
Cohort start date | - | Median [Q25 - Q75] | 2008-10-08 [1997-01-11 - 2014-03-06] | 2009-07-25 [1999-01-22 - 2015-04-07] | 2008-12-20 [2000-10-17 - 2014-09-23] | 2010-09-19 [2005-05-10 - 2016-01-10]  
|  | Range | 1961-02-11 to 2019-05-30 | 1970-06-04 to 2019-06-23 | 1961-07-16 to 2019-06-12 | 1982-01-17 to 2019-05-08  
Cohort end date | - | Median [Q25 - Q75] | 2008-10-30 [1997-02-13 - 2014-03-25] | 2009-09-23 [1999-04-22 - 2015-06-03] | 2009-01-19 [2000-12-09 - 2014-12-22] | 2010-10-19 [2005-06-24 - 2016-03-26]  
|  | Range | 1961-02-25 to 2019-05-30 | 1970-07-04 to 2019-06-24 | 1961-08-15 to 2019-06-13 | 1982-04-17 to 2019-06-07  
Age | - | Median [Q25 - Q75] | 59 [53 - 67] | 68 [60 - 75] | 69 [61 - 78] | 71 [62 - 82]  
|  | Mean (SD) | 62.00 (11.40) | 68.59 (11.77) | 70.33 (12.90) | 72.31 (13.84)  
|  | Range | 50 to 105 | 50 to 107 | 50 to 106 | 51 to 108  
Sex | Female | N (%) | 163 (49.70%) | 48 (49.48%) | 73 (56.59%) | 33 (64.71%)  
| Male | N (%) | 165 (50.30%) | 49 (50.52%) | 56 (43.41%) | 18 (35.29%)  
Prior observation | - | Median [Q25 - Q75] | 21,747 [19,421 - 24,795] | 25,114 [22,188 - 27,715] | 25,445 [22,496 - 28,815] | 25,964 [22,994 - 30,277]  
|  | Mean (SD) | 22,831.56 (4,167.50) | 25,235.61 (4,310.11) | 25,874.71 (4,714.82) | 26,594.78 (5,045.12)  
|  | Range | 18,264 to 38,429 | 18,354 to 39,430 | 18,379 to 38,943 | 18,899 to 39,792  
Future observation | - | Median [Q25 - Q75] | 3,494 [1,722 - 6,684] | 2,909 [1,173 - 5,608] | 3,335 [1,316 - 5,988] | 2,808 [914 - 4,672]  
|  | Mean (SD) | 4,642.15 (4,070.72) | 3,977.22 (3,624.08) | 4,105.97 (3,334.07) | 3,215.02 (3,035.15)  
|  | Range | 0 to 19,780 | 1 to 17,814 | 1 to 16,492 | 0 to 13,595  
Days in cohort | - | Median [Q25 - Q75] | 22 [15 - 29] | 61 [31 - 91] | 61 [31 - 91] | 61 [31 - 61]  
|  | Mean (SD) | 24.82 (8.58) | 64.10 (25.37) | 58.69 (25.01) | 52.18 (24.95)  
|  | Range | 1 to 36 | 2 to 92 | 2 to 91 | 1 to 91  
  
Then plotted age stratified prior observation time.
    
    
    chars |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "Prior observation") |>
      [plotCharacteristics](../reference/plotCharacteristics.html)(
        plotType = "boxplot",
        colour = "cohort_name",
        facet = [c](https://rdrr.io/r/base/c.html)("age_group")
      ) +
      [coord_flip](https://ggplot2.tidyverse.org/reference/coord_flip.html)()

![](summarise_characteristics_files/figure-html/unnamed-chunk-8-1.png)

## Summaries including presence in other cohorts

We explored whether patients had any exposure to a list of selected medications (acetaminophen, morphine, warfarin)
    
    
    medsCs <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(
      cdm = cdm,
      name = [c](https://rdrr.io/r/base/c.html)("acetaminophen", "morphine", "warfarin")
    )
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      name = "meds",
      conceptSet = medsCs,
      end = "event_end_date",
      limit = "all",
      overwrite = TRUE
    )

We can use the `intersects` arguement inside the function to get this information.
    
    
    chars <- cdm$injuries |>
      [summariseCharacteristics](../reference/summariseCharacteristics.html)(cohortIntersectFlag = [list](https://rdrr.io/r/base/list.html)(
        "Medications prior to index date" = [list](https://rdrr.io/r/base/list.html)(
          targetCohortTable = "meds",
          window = [c](https://rdrr.io/r/base/c.html)(-Inf, -1)
        ),
        "Medications on index date" = [list](https://rdrr.io/r/base/list.html)(
          targetCohortTable = "meds",
          window = [c](https://rdrr.io/r/base/c.html)(0, 0)
        )
      ))

To view the summary table
    
    
    [tableCharacteristics](../reference/tableCharacteristics.html)(chars)

|  CDM name  
---|---  
|  Eunomia  
Variable name | Variable level | Estimate name |  Cohort name  
ankle_sprain | ankle_fracture | forearm_fracture | hip_fracture  
Number records | - | N | 1,915 | 464 | 569 | 138  
Number subjects | - | N | 1,357 | 427 | 510 | 132  
Cohort start date | - | Median [Q25 - Q75] | 1982-11-09 [1968-06-15 - 1999-04-13] | 1981-01-15 [1965-03-11 - 1997-08-03] | 1981-07-24 [1967-03-05 - 2000-12-16] | 1996-09-17 [1977-09-20 - 2010-06-22]  
|  | Range | 1912-02-25 to 2019-05-30 | 1911-09-07 to 2019-06-23 | 1917-08-16 to 2019-06-26 | 1927-12-14 to 2019-05-08  
Cohort end date | - | Median [Q25 - Q75] | 1982-12-10 [1968-07-06 - 1999-05-09] | 1981-02-28 [1965-04-11 - 1997-10-12] | 1981-08-23 [1967-04-10 - 2001-02-27] | 1996-11-16 [1977-12-04 - 2010-07-22]  
|  | Range | 1912-03-10 to 2019-05-30 | 1911-12-06 to 2019-06-24 | 1917-11-14 to 2019-06-26 | 1928-03-13 to 2019-06-07  
Age | - | Median [Q25 - Q75] | 21 [9 - 41] | 16 [9 - 43] | 17 [9 - 46] | 40 [13 - 66]  
|  | Mean (SD) | 26.63 (21.03) | 27.38 (24.70) | 28.69 (25.97) | 40.06 (28.82)  
|  | Range | 0 to 105 | 0 to 107 | 0 to 106 | 1 to 108  
Sex | Female | N (%) | 954 (49.82%) | 238 (51.29%) | 286 (50.26%) | 74 (53.62%)  
| Male | N (%) | 961 (50.18%) | 226 (48.71%) | 283 (49.74%) | 64 (46.38%)  
Prior observation | - | Median [Q25 - Q75] | 7,833 [3,628 - 15,147] | 6,030 [3,360 - 16,032] | 6,289 [3,390 - 16,847] | 14,522 [4,801 - 24,401]  
|  | Mean (SD) | 9,918.17 (7,672.74) | 10,196.57 (9,011.31) | 10,670.43 (9,480.30) | 14,821.73 (10,521.89)  
|  | Range | 299 to 38,429 | 299 to 39,430 | 299 to 38,943 | 390 to 39,792  
Future observation | - | Median [Q25 - Q75] | 12,868 [6,860 - 18,078] | 13,748 [6,878 - 19,331] | 13,165 [5,988 - 18,548] | 7,798 [2,874 - 14,913]  
|  | Mean (SD) | 12,865.11 (7,543.50) | 13,470.92 (8,215.96) | 12,913.27 (7,929.17) | 9,167.33 (7,160.81)  
|  | Range | 0 to 38,403 | 1 to 39,051 | 0 to 36,654 | 0 to 29,045  
Days in cohort | - | Median [Q25 - Q75] | 22 [15 - 29] | 61 [31 - 91] | 61 [31 - 91] | 61 [31 - 91]  
|  | Mean (SD) | 25.02 (8.00) | 61.65 (25.38) | 62.16 (25.32) | 59.26 (24.79)  
|  | Range | 1 to 37 | 2 to 92 | 1 to 91 | 1 to 91  
Medications prior to index date | 11289 warfarin | N (%) | 12 (0.63%) | 8 (1.72%) | 11 (1.93%) | 4 (2.90%)  
| 7052 morphine | N (%) | 15 (0.78%) | 1 (0.22%) | 2 (0.35%) | 2 (1.45%)  
| 161 acetaminophen | N (%) | 1,530 (79.90%) | 357 (76.94%) | 447 (78.56%) | 119 (86.23%)  
Medications on index date | 161 acetaminophen | N (%) | 773 (40.37%) | 240 (51.72%) | 264 (46.40%) | 90 (65.22%)  
| 11289 warfarin | N (%) | 0 (0.00%) | 0 (0.00%) | 0 (0.00%) | 0 (0.00%)  
| 7052 morphine | N (%) | 0 (0.00%) | 0 (0.00%) | 0 (0.00%) | 0 (0.00%)  
  
To visualise the exposure of these drugs in a bar plot.
    
    
    plot_data <- chars |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(
        variable_name == "Medications prior to index date",
        estimate_name == "percentage"
      )
    
    plot_data |>
      [plotCharacteristics](../reference/plotCharacteristics.html)(
        plotType = "barplot",
        colour = "variable_level",
        facet = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name")
      ) +
      [scale_x_discrete](https://ggplot2.tidyverse.org/reference/scale_discrete.html)(limits = [rev](https://rdrr.io/r/base/rev.html)([sort](https://rdrr.io/r/base/sort.html)([unique](https://rdrr.io/r/base/unique.html)(plot_data$variable_level)))) +
      [coord_flip](https://ggplot2.tidyverse.org/reference/coord_flip.html)() +
      [ggtitle](https://ggplot2.tidyverse.org/reference/labs.html)("Medication use prior to index date")

![](summarise_characteristics_files/figure-html/unnamed-chunk-12-1.png)

## Summaries Using Concept Sets Directly

Instead of creating cohorts, we could have directly used our concept sets for medications when characterising our study cohorts.
    
    
    chars <- cdm$injuries |>
      [summariseCharacteristics](../reference/summariseCharacteristics.html)(conceptIntersectFlag = [list](https://rdrr.io/r/base/list.html)(
        "Medications prior to index date" = [list](https://rdrr.io/r/base/list.html)(
          conceptSet = medsCs,
          window = [c](https://rdrr.io/r/base/c.html)(-Inf, -1)
        ),
        "Medications on index date" = [list](https://rdrr.io/r/base/list.html)(
          conceptSet = medsCs,
          window = [c](https://rdrr.io/r/base/c.html)(0, 0)
        )
      ))

Although, like here, concept sets can lead to the same result as using cohorts it is important to note this will not always be the case. This is because the creation of cohorts will have involved the collapsing of overlapping records as well as imposing certain requirements, such as only including records that were observed during an an ongoing observation period. Meanwhile, when working with concept sets we will instead be working directly with record-level data.
    
    
    [tableCharacteristics](../reference/tableCharacteristics.html)(chars)

|  CDM name  
---|---  
|  Eunomia  
Variable name | Variable level | Estimate name |  Cohort name  
ankle_sprain | ankle_fracture | forearm_fracture | hip_fracture  
Number records | - | N | 1,915 | 464 | 569 | 138  
Number subjects | - | N | 1,357 | 427 | 510 | 132  
Cohort start date | - | Median [Q25 - Q75] | 1982-11-09 [1968-06-15 - 1999-04-13] | 1981-01-15 [1965-03-11 - 1997-08-03] | 1981-07-24 [1967-03-05 - 2000-12-16] | 1996-09-17 [1977-09-20 - 2010-06-22]  
|  | Range | 1912-02-25 to 2019-05-30 | 1911-09-07 to 2019-06-23 | 1917-08-16 to 2019-06-26 | 1927-12-14 to 2019-05-08  
Cohort end date | - | Median [Q25 - Q75] | 1982-12-10 [1968-07-06 - 1999-05-09] | 1981-02-28 [1965-04-11 - 1997-10-12] | 1981-08-23 [1967-04-10 - 2001-02-27] | 1996-11-16 [1977-12-04 - 2010-07-22]  
|  | Range | 1912-03-10 to 2019-05-30 | 1911-12-06 to 2019-06-24 | 1917-11-14 to 2019-06-26 | 1928-03-13 to 2019-06-07  
Age | - | Median [Q25 - Q75] | 21 [9 - 41] | 16 [9 - 43] | 17 [9 - 46] | 40 [13 - 66]  
|  | Mean (SD) | 26.63 (21.03) | 27.38 (24.70) | 28.69 (25.97) | 40.06 (28.82)  
|  | Range | 0 to 105 | 0 to 107 | 0 to 106 | 1 to 108  
Sex | Female | N (%) | 954 (49.82%) | 238 (51.29%) | 286 (50.26%) | 74 (53.62%)  
| Male | N (%) | 961 (50.18%) | 226 (48.71%) | 283 (49.74%) | 64 (46.38%)  
Prior observation | - | Median [Q25 - Q75] | 7,833 [3,628 - 15,147] | 6,030 [3,360 - 16,032] | 6,289 [3,390 - 16,847] | 14,522 [4,801 - 24,401]  
|  | Mean (SD) | 9,918.17 (7,672.74) | 10,196.57 (9,011.31) | 10,670.43 (9,480.30) | 14,821.73 (10,521.89)  
|  | Range | 299 to 38,429 | 299 to 39,430 | 299 to 38,943 | 390 to 39,792  
Future observation | - | Median [Q25 - Q75] | 12,868 [6,860 - 18,078] | 13,748 [6,878 - 19,331] | 13,165 [5,988 - 18,548] | 7,798 [2,874 - 14,913]  
|  | Mean (SD) | 12,865.11 (7,543.50) | 13,470.92 (8,215.96) | 12,913.27 (7,929.17) | 9,167.33 (7,160.81)  
|  | Range | 0 to 38,403 | 1 to 39,051 | 0 to 36,654 | 0 to 29,045  
Days in cohort | - | Median [Q25 - Q75] | 22 [15 - 29] | 61 [31 - 91] | 61 [31 - 91] | 61 [31 - 91]  
|  | Mean (SD) | 25.02 (8.00) | 61.65 (25.38) | 62.16 (25.32) | 59.26 (24.79)  
|  | Range | 1 to 37 | 2 to 92 | 1 to 91 | 1 to 91  
Medications prior to index date | 161 acetaminophen | N (%) | 1,530 (79.90%) | 357 (76.94%) | 447 (78.56%) | 119 (86.23%)  
| 11289 warfarin | N (%) | 12 (0.63%) | 8 (1.72%) | 11 (1.93%) | 4 (2.90%)  
| 7052 morphine | N (%) | 15 (0.78%) | 1 (0.22%) | 2 (0.35%) | 2 (1.45%)  
Medications on index date | 161 acetaminophen | N (%) | 773 (40.37%) | 240 (51.72%) | 264 (46.40%) | 90 (65.22%)  
| 11289 warfarin | N (%) | 0 (0.00%) | 0 (0.00%) | 0 (0.00%) | 0 (0.00%)  
| 7052 morphine | N (%) | 0 (0.00%) | 0 (0.00%) | 0 (0.00%) | 0 (0.00%)  
  
## Summaries using clinical tables

More generally, we can also include summaries of the patients’ presence in other clinical tables of the OMOP CDM. For example, here we add a count of visit occurrences
    
    
    chars <- cdm$injuries |>
      [summariseCharacteristics](../reference/summariseCharacteristics.html)(
        tableIntersectCount = [list](https://rdrr.io/r/base/list.html)(
          "Visits in the year prior" = [list](https://rdrr.io/r/base/list.html)(
            tableName = "visit_occurrence",
            window = [c](https://rdrr.io/r/base/c.html)(-365, -1)
          )
        ),
        tableIntersectFlag = [list](https://rdrr.io/r/base/list.html)(
          "Any drug exposure in the year prior" = [list](https://rdrr.io/r/base/list.html)(
            tableName = "drug_exposure",
            window = [c](https://rdrr.io/r/base/c.html)(-365, -1)
          ),
          "Any procedure in the year prior" = [list](https://rdrr.io/r/base/list.html)(
            tableName = "procedure_occurrence",
            window = [c](https://rdrr.io/r/base/c.html)(-365, -1)
          )
        )
      )
    
    
    [tableCharacteristics](../reference/tableCharacteristics.html)(chars)

|  CDM name  
---|---  
|  Eunomia  
Variable name | Variable level | Estimate name |  Cohort name  
ankle_sprain | ankle_fracture | forearm_fracture | hip_fracture  
Number records | - | N | 1,915 | 464 | 569 | 138  
Number subjects | - | N | 1,357 | 427 | 510 | 132  
Cohort start date | - | Median [Q25 - Q75] | 1982-11-09 [1968-06-15 - 1999-04-13] | 1981-01-15 [1965-03-11 - 1997-08-03] | 1981-07-24 [1967-03-05 - 2000-12-16] | 1996-09-17 [1977-09-20 - 2010-06-22]  
|  | Range | 1912-02-25 to 2019-05-30 | 1911-09-07 to 2019-06-23 | 1917-08-16 to 2019-06-26 | 1927-12-14 to 2019-05-08  
Cohort end date | - | Median [Q25 - Q75] | 1982-12-10 [1968-07-06 - 1999-05-09] | 1981-02-28 [1965-04-11 - 1997-10-12] | 1981-08-23 [1967-04-10 - 2001-02-27] | 1996-11-16 [1977-12-04 - 2010-07-22]  
|  | Range | 1912-03-10 to 2019-05-30 | 1911-12-06 to 2019-06-24 | 1917-11-14 to 2019-06-26 | 1928-03-13 to 2019-06-07  
Age | - | Median [Q25 - Q75] | 21 [9 - 41] | 16 [9 - 43] | 17 [9 - 46] | 40 [13 - 66]  
|  | Mean (SD) | 26.63 (21.03) | 27.38 (24.70) | 28.69 (25.97) | 40.06 (28.82)  
|  | Range | 0 to 105 | 0 to 107 | 0 to 106 | 1 to 108  
Sex | Female | N (%) | 954 (49.82%) | 238 (51.29%) | 286 (50.26%) | 74 (53.62%)  
| Male | N (%) | 961 (50.18%) | 226 (48.71%) | 283 (49.74%) | 64 (46.38%)  
Prior observation | - | Median [Q25 - Q75] | 7,833 [3,628 - 15,147] | 6,030 [3,360 - 16,032] | 6,289 [3,390 - 16,847] | 14,522 [4,801 - 24,401]  
|  | Mean (SD) | 9,918.17 (7,672.74) | 10,196.57 (9,011.31) | 10,670.43 (9,480.30) | 14,821.73 (10,521.89)  
|  | Range | 299 to 38,429 | 299 to 39,430 | 299 to 38,943 | 390 to 39,792  
Future observation | - | Median [Q25 - Q75] | 12,868 [6,860 - 18,078] | 13,748 [6,878 - 19,331] | 13,165 [5,988 - 18,548] | 7,798 [2,874 - 14,913]  
|  | Mean (SD) | 12,865.11 (7,543.50) | 13,470.92 (8,215.96) | 12,913.27 (7,929.17) | 9,167.33 (7,160.81)  
|  | Range | 0 to 38,403 | 1 to 39,051 | 0 to 36,654 | 0 to 29,045  
Days in cohort | - | Median [Q25 - Q75] | 22 [15 - 29] | 61 [31 - 91] | 61 [31 - 91] | 61 [31 - 91]  
|  | Mean (SD) | 25.02 (8.00) | 61.65 (25.38) | 62.16 (25.32) | 59.26 (24.79)  
|  | Range | 1 to 37 | 2 to 92 | 1 to 91 | 1 to 91  
Any drug exposure in the year prior | - | N (%) | 597 (31.17%) | 149 (32.11%) | 171 (30.05%) | 41 (29.71%)  
Any procedure in the year prior | - | N (%) | 123 (6.42%) | 26 (5.60%) | 37 (6.50%) | 15 (10.87%)  
Visits in the year prior | - | Median [Q25 - Q75] | 0.00 [0.00 - 0.00] | 0.00 [0.00 - 0.00] | 0.00 [0.00 - 0.00] | 0.00 [0.00 - 0.00]  
|  | Mean (SD) | 0.00 (0.06) | 0.00 (0.00) | 0.00 (0.00) | 0.00 (0.00)  
|  | Range | 0.00 to 1.00 | 0.00 to 0.00 | 0.00 to 0.00 | 0.00 to 0.00  
  
## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/articles/summarise_large_scale_characteristics.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Summarise large scale characteristics

Source: [`vignettes/summarise_large_scale_characteristics.Rmd`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/vignettes/summarise_large_scale_characteristics.Rmd)

`summarise_large_scale_characteristics.Rmd`

## Introduction

In the previous vignette we have seen how we can use the CohortCharacteristics package to summarise a set of pre-specified characteristics of a study cohort. These characteristics included patient demographics like age and sex, and also concept sets and cohorts that we defined. Another, often complimentary, way that we can approach characterising a study cohort is by simply summarising all clinical events we see for them in some window around their index date (cohort entry).

To show how large scale characterisation can work we’ll first create a first-ever ankle sprain study cohort using the Eunomia synthetic data.
    
    
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con = con, cdmSchem = "main", writeSchema = "main", cdmName = "Eunomia"
    )
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      name = "ankle_sprain",
      conceptSet = [list](https://rdrr.io/r/base/list.html)("ankle_sprain" = 81151),
      end = "event_end_date",
      limit = "first",
      overwrite = TRUE
    )

## Large scale characteristics of study cohorts

To summarise our cohort of individuals with an ankle sprain we will look at their records in three tables of the OMOP CDM (_condition_occurrence_ , _procedure_occurrence_ , and _drug_exposure_) over two time windows (any time prior to their index date, and on index date). For conditions and procedures we will identify whether someone had a new record starting in the time window. Meanwhile, for drug exposures we will consider whether they had a new or ongoing record in the period.

Lastly, but important to note, we are only going to only return results for concepts for which at least 10% of the study cohort had a record.
    
    
    lsc <- cdm$ankle_sprain |>
      [summariseLargeScaleCharacteristics](../reference/summariseLargeScaleCharacteristics.html)(
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-Inf, -1), [c](https://rdrr.io/r/base/c.html)(0, 0)),
        eventInWindow = [c](https://rdrr.io/r/base/c.html)(
          "condition_occurrence",
          "procedure_occurrence"
        ),
        episodeInWindow = "drug_exposure",
        minimumFrequency = 0.1
      )
    
    [tableLargeScaleCharacteristics](../reference/tableLargeScaleCharacteristics.html)(lsc)

As we can see we have identified numerous concepts for which at least 10% of our study population had a record. Often with larger cohorts and real patient-level data we will obtain many times more results when running large scale characterisation. One option we have to help summarise our results is to pick out the most frequent concepts. Here, for example, we select the top 5 concepts.
    
    
    [tableTopLargeScaleCharacteristics](../reference/tableTopLargeScaleCharacteristics.html)(lsc,
                                      topConcepts = 5)

|  Window  
---|---  
|  -inf to -1 |  0 to 0  
|  Table name  
|  condition_occurrence |  drug_exposure |  procedure_occurrence |  condition_occurrence |  drug_exposure  
Top |  Type  
event | episode | event | event | episode  
1 | Viral sinusitis (40481087)   
981 (72.3%) | poliovirus vaccine, inactivated (40213160)   
994 (73.2%) | Suture open wound (4125906)   
363 (26.8%) | Sprain of ankle (81151)   
1357 (100.0%) | Aspirin 81 MG Oral Tablet (19059056)   
470 (34.6%)  
2 | Otitis media (372328)   
909 (67.0%) | Aspirin 81 MG Oral Tablet (19059056)   
842 (62.0%) | Bone immobilization (4170947)   
356 (26.2%) | 

  * 
| Acetaminophen 325 MG Oral Tablet (1127433)   
330 (24.3%)  
3 | Acute viral pharyngitis (4112343)   
845 (62.3%) | Acetaminophen 325 MG Oral Tablet (1127433)   
737 (54.3%) | Sputum examination (4151422)   
282 (20.8%) | 

  * 
| Acetaminophen 160 MG Oral Tablet (1127078)   
199 (14.7%)  
4 | Acute bronchitis (260139)   
767 (56.5%) | Acetaminophen 160 MG Oral Tablet (1127078)   
559 (41.2%) | Plain chest X-ray (4163872)   
137 (10.1%) | 

  * 
| Ibuprofen 200 MG Oral Tablet (19078461)   
192 (14.2%)  
5 | Streptococcal sore throat (28060)   
499 (36.8%) | Amoxicillin 250 MG / Clavulanate 125 MG Oral Tablet (1713671)   
499 (36.8%) | Radiography of humerus (4047491)   
129 (9.5%) | 

  * 
| Naproxen sodium 220 MG Oral Tablet (1115171)   
120 (8.8%)  
  
## Stratified large scale characteristics

Like when summarising pre-specified patient characteristics, we can also get stratified results when summarising large scale characteristics. Here, for example, large scale characteristics are stratified by sex (which we add as an additional column to our cohort table using the PatientProfiles package).
    
    
    lsc <- cdm$ankle_sprain |>
      [addSex](https://darwin-eu.github.io/PatientProfiles/reference/addSex.html)() |>
      [summariseLargeScaleCharacteristics](../reference/summariseLargeScaleCharacteristics.html)(
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-Inf, -1), [c](https://rdrr.io/r/base/c.html)(0, 0)),
        strata = [list](https://rdrr.io/r/base/list.html)("sex"),
        eventInWindow = "drug_exposure",
        minimumFrequency = 0.1
      )
    
    [tableTopLargeScaleCharacteristics](../reference/tableTopLargeScaleCharacteristics.html)(lsc)

|  Sex  
---|---  
|  Female |  Male |  overall  
Top |  Window  
-inf to -1 | 0 to 0 | -inf to -1 | 0 to 0 | -inf to -1 | 0 to 0  
1 | poliovirus vaccine, inactivated (40213160)   
501 (73.3%) | Aspirin 81 MG Oral Tablet (19059056)   
245 (35.9%) | poliovirus vaccine, inactivated (40213160)   
493 (73.2%) | Aspirin 81 MG Oral Tablet (19059056)   
225 (33.4%) | poliovirus vaccine, inactivated (40213160)   
994 (73.2%) | Aspirin 81 MG Oral Tablet (19059056)   
470 (34.6%)  
2 | Aspirin 81 MG Oral Tablet (19059056)   
427 (62.5%) | Acetaminophen 325 MG Oral Tablet (1127433)   
165 (24.2%) | Aspirin 81 MG Oral Tablet (19059056)   
415 (61.6%) | Acetaminophen 325 MG Oral Tablet (1127433)   
165 (24.5%) | Aspirin 81 MG Oral Tablet (19059056)   
842 (62.0%) | Acetaminophen 325 MG Oral Tablet (1127433)   
330 (24.3%)  
3 | Acetaminophen 325 MG Oral Tablet (1127433)   
374 (54.8%) | Acetaminophen 160 MG Oral Tablet (1127078)   
97 (14.2%) | Acetaminophen 325 MG Oral Tablet (1127433)   
363 (53.9%) | Acetaminophen 160 MG Oral Tablet (1127078)   
102 (15.1%) | Acetaminophen 325 MG Oral Tablet (1127433)   
737 (54.3%) | Acetaminophen 160 MG Oral Tablet (1127078)   
199 (14.7%)  
4 | Acetaminophen 160 MG Oral Tablet (1127078)   
292 (42.8%) | Ibuprofen 200 MG Oral Tablet (19078461)   
93 (13.6%) | Acetaminophen 160 MG Oral Tablet (1127078)   
267 (39.6%) | Ibuprofen 200 MG Oral Tablet (19078461)   
99 (14.7%) | Acetaminophen 160 MG Oral Tablet (1127078)   
559 (41.2%) | Ibuprofen 200 MG Oral Tablet (19078461)   
192 (14.2%)  
5 | Penicillin V Potassium 250 MG Oral Tablet (19133873)   
256 (37.5%) | Naproxen sodium 220 MG Oral Tablet (1115171)   
62 (9.1%) | Amoxicillin 250 MG / Clavulanate 125 MG Oral Tablet (1713671)   
255 (37.8%) | Naproxen sodium 220 MG Oral Tablet (1115171)   
58 (8.6%) | Amoxicillin 250 MG / Clavulanate 125 MG Oral Tablet (1713671)   
499 (36.8%) | Naproxen sodium 220 MG Oral Tablet (1115171)   
120 (8.8%)  
6 | Amoxicillin 250 MG / Clavulanate 125 MG Oral Tablet (1713671)   
244 (35.7%) | Ibuprofen 100 MG Oral Tablet (19019979)   
21 (3.1%) | Penicillin V Potassium 250 MG Oral Tablet (19133873)   
235 (34.9%) | Ibuprofen 100 MG Oral Tablet (19019979)   
25 (3.7%) | Penicillin V Potassium 250 MG Oral Tablet (19133873)   
491 (36.2%) | Ibuprofen 100 MG Oral Tablet (19019979)   
46 (3.4%)  
7 | Penicillin G 375 MG/ML Injectable Solution (19006318)   
169 (24.7%) | 

  * 
| Penicillin G 375 MG/ML Injectable Solution (19006318)   
215 (31.9%) | 

  * 
| Penicillin G 375 MG/ML Injectable Solution (19006318)   
384 (28.3%) | 

  * 
  
8 | tetanus and diphtheria toxoids, adsorbed, preservative free, for adult use (40213227)   
151 (22.1%) | 

  * 
| Acetaminophen 21.7 MG/ML / Dextromethorphan Hydrobromide 1 MG/ML / doxylamine succinate 0.417 MG/ML Oral Solution (40229134)   
164 (24.3%) | 

  * 
| Acetaminophen 21.7 MG/ML / Dextromethorphan Hydrobromide 1 MG/ML / doxylamine succinate 0.417 MG/ML Oral Solution (40229134)   
296 (21.8%) | 

  * 
  
9 | {7 (Inert Ingredients 1 MG Oral Tablet) / 21 (Mestranol 0.05 MG / Norethindrone 1 MG Oral Tablet) } Pack [Norinyl 1+50 28 Day] (19128065)   
135 (19.8%) | 

  * 
| tetanus and diphtheria toxoids, adsorbed, preservative free, for adult use (40213227)   
137 (20.3%) | 

  * 
| tetanus and diphtheria toxoids, adsorbed, preservative free, for adult use (40213227)   
288 (21.2%) | 

  * 
  
10 | Acetaminophen 21.7 MG/ML / Dextromethorphan Hydrobromide 1 MG/ML / doxylamine succinate 0.417 MG/ML Oral Solution (40229134)   
132 (19.3%) | 

  * 
| Haemophilus influenzae type b vaccine, PRP-OMP conjugate (40213314)   
98 (14.5%) | 

  * 
| hepatitis B vaccine, adult dosage (40213306)   
226 (16.6%) | 

  * 
  
  
## Plot large scale characteristics

`plotLargeScaleCharacteristics` and `plotComparedLargeScaleCharacteristics` can be use to generate plot for visualising the large scale characteristics
    
    
    [plotLargeScaleCharacteristics](../reference/plotLargeScaleCharacteristics.html)(lsc)

![](summarise_large_scale_characteristics_files/figure-html/unnamed-chunk-6-1.png)

`plotComparedLargeScaleCharacteristics` allows you to compare the difference in prevalence of the large scale covariates between two window. The reference cohort and time window are set using the `reference` arguement inside the function.
    
    
    [plotComparedLargeScaleCharacteristics](../reference/plotComparedLargeScaleCharacteristics.html)(
      result = lsc,
      colour = "sex",
      reference = 'overall',
      facet = cohort_name ~ variable_level
    )

![](summarise_large_scale_characteristics_files/figure-html/unnamed-chunk-7-1.png)

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/articles/summarise_cohort_overlap.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Summarise cohort overlap

Source: [`vignettes/summarise_cohort_overlap.Rmd`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/vignettes/summarise_cohort_overlap.Rmd)

`summarise_cohort_overlap.Rmd`

When creating multiple cohorts we might be interested in the overlap between them. That is, how many individuals appear in multiple cohorts. CohortCharacteristics provides functions to generate such estimates and then summarise these estimates in tables and plots.

To see how this works let’s create a few medication cohorts with the Eunomia synthetic dataset.
    
    
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con = con, cdmSchem = "main", writeSchema = "main", cdmName = "Eunomia"
    )
    
    medsCs <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(
      cdm = cdm,
      name = [c](https://rdrr.io/r/base/c.html)(
        "acetaminophen",
        "morphine",
        "warfarin"
      )
    )
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      name = "meds",
      conceptSet = medsCs,
      end = "event_end_date",
      limit = "all",
      overwrite = TRUE
    )
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$meds)
    #> # A tibble: 3 × 6
    #>   cohort_definition_id cohort_name    limit prior_observation future_observation
    #>                  <int> <chr>          <chr>             <dbl>              <dbl>
    #> 1                    1 11289_warfarin all                   0                  0
    #> 2                    2 161_acetamino… all                   0                  0
    #> 3                    3 7052_morphine  all                   0                  0
    #> # ℹ 1 more variable: end <chr>
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$meds)
    #> # A tibble: 3 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1            137             137
    #> 2                    2          13908            2679
    #> 3                    3             35              35

Now we have our cohorts we can summarise the overlap between them.
    
    
    medsOverlap <- cdm$meds |>
      [summariseCohortOverlap](../reference/summariseCohortOverlap.html)()
    medsOverlap |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 36
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "Eunomia", "Eunomia", "Eunomia", "Eunomia", "Eunomia"…
    #> $ group_name       <chr> "cohort_name_reference &&& cohort_name_comparator", "…
    #> $ group_level      <chr> "11289_warfarin &&& 161_acetaminophen", "11289_warfar…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Only in reference cohort", "In both cohorts", "Only …
    #> $ variable_level   <chr> "Subjects", "Subjects", "Subjects", "Subjects", "Subj…
    #> $ estimate_name    <chr> "count", "count", "count", "count", "count", "count",…
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "1", "136", "2543", "131", "6", "29", "2543", "136", …
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…

We have table and plotting functions to help view our results. The `uniqueCombinations` can be use to include/exclude non unique combinations between the comparator and reference cohorts for the overlap.
    
    
    [tableCohortOverlap](../reference/tableCohortOverlap.html)(medsOverlap, uniqueCombinations = FALSE)

Cohort name reference | Cohort name comparator | Estimate name |  Variable name  
---|---|---|---  
Only in reference cohort | In both cohorts | Only in comparator cohort  
Eunomia  
11289_warfarin | 161_acetaminophen | N (%) | 1 (0.04%) | 136 (5.07%) | 2,543 (94.89%)  
| 7052_morphine | N (%) | 131 (78.92%) | 6 (3.61%) | 29 (17.47%)  
161_acetaminophen | 11289_warfarin | N (%) | 2,543 (94.89%) | 136 (5.07%) | 1 (0.04%)  
| 7052_morphine | N (%) | 2,644 (98.69%) | 35 (1.31%) | 0 (0.00%)  
7052_morphine | 11289_warfarin | N (%) | 29 (17.47%) | 6 (3.61%) | 131 (78.92%)  
| 161_acetaminophen | N (%) | 0 (0.00%) | 35 (1.31%) | 2,644 (98.69%)  
      
    
    [plotCohortOverlap](../reference/plotCohortOverlap.html)(medsOverlap, uniqueCombinations = FALSE)

![](summarise_cohort_overlap_files/figure-html/unnamed-chunk-5-1.png)

As well as generating these estimates for cohorts overall, we can also obtain stratified estimates. In this example we’ll add age groups to our cohort table, and then obtain estimates stratified by these groups.
    
    
    cdm$meds <- cdm$meds |>
      [addAge](https://darwin-eu.github.io/PatientProfiles/reference/addAge.html)(ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 49), [c](https://rdrr.io/r/base/c.html)(50, 150))) |>
      [compute](https://dplyr.tidyverse.org/reference/compute.html)(temporary = FALSE, name = "meds") |>
      [newCohortTable](https://darwin-eu.github.io/omopgenerics/reference/newCohortTable.html)()
    medsOverlap <- cdm$meds |>
      [summariseCohortOverlap](../reference/summariseCohortOverlap.html)(strata = [list](https://rdrr.io/r/base/list.html)("age_group"))

As with our overall results, we can quickly create tables and figures to view our stratified results.
    
    
    [tableCohortOverlap](../reference/tableCohortOverlap.html)(medsOverlap, uniqueCombinations = FALSE)

Cohort name reference | Cohort name comparator | Age group | Estimate name |  Variable name  
---|---|---|---|---  
Only in reference cohort | In both cohorts | Only in comparator cohort  
Eunomia  
11289_warfarin | 161_acetaminophen | overall | N (%) | 1 (0.04%) | 136 (5.07%) | 2,543 (94.89%)  
| 7052_morphine | overall | N (%) | 131 (78.92%) | 6 (3.61%) | 29 (17.47%)  
161_acetaminophen | 11289_warfarin | overall | N (%) | 2,543 (94.89%) | 136 (5.07%) | 1 (0.04%)  
| 7052_morphine | overall | N (%) | 2,644 (98.69%) | 35 (1.31%) | 0 (0.00%)  
7052_morphine | 11289_warfarin | overall | N (%) | 29 (17.47%) | 6 (3.61%) | 131 (78.92%)  
| 161_acetaminophen | overall | N (%) | 0 (0.00%) | 35 (1.31%) | 2,644 (98.69%)  
11289_warfarin | 161_acetaminophen | 0 to 49 | N (%) | 1 (0.04%) | 8 (0.30%) | 2,653 (99.66%)  
|  | 50 to 150 | N (%) | 26 (2.25%) | 102 (8.85%) | 1,025 (88.90%)  
| 7052_morphine | 0 to 49 | N (%) | 9 (26.47%) | 0 (0.00%) | 25 (73.53%)  
|  | 50 to 150 | N (%) | 122 (92.42%) | 6 (4.55%) | 4 (3.03%)  
161_acetaminophen | 11289_warfarin | 0 to 49 | N (%) | 2,653 (99.66%) | 8 (0.30%) | 1 (0.04%)  
|  | 50 to 150 | N (%) | 1,025 (88.90%) | 102 (8.85%) | 26 (2.25%)  
| 7052_morphine | 0 to 49 | N (%) | 2,636 (99.06%) | 25 (0.94%) | 0 (0.00%)  
|  | 50 to 150 | N (%) | 1,117 (99.11%) | 10 (0.89%) | 0 (0.00%)  
7052_morphine | 11289_warfarin | 0 to 49 | N (%) | 25 (73.53%) | 0 (0.00%) | 9 (26.47%)  
|  | 50 to 150 | N (%) | 4 (3.03%) | 6 (4.55%) | 122 (92.42%)  
| 161_acetaminophen | 0 to 49 | N (%) | 0 (0.00%) | 25 (0.94%) | 2,636 (99.06%)  
|  | 50 to 150 | N (%) | 0 (0.00%) | 10 (0.89%) | 1,117 (99.11%)  
      
    
    [plotCohortOverlap](../reference/plotCohortOverlap.html)(
      medsOverlap,
      facet = [c](https://rdrr.io/r/base/c.html)("age_group"),
      uniqueCombinations = TRUE
    )

![](summarise_cohort_overlap_files/figure-html/unnamed-chunk-8-1.png)

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/articles/summarise_cohort_timing.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Summarise cohort timing

Source: [`vignettes/summarise_cohort_timing.Rmd`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/vignettes/summarise_cohort_timing.Rmd)

`summarise_cohort_timing.Rmd`

We saw in the previous vignette how we can summarise the overlap between cohorts. In addition to this, we might also be interested in timings between cohorts. That is, the time between an individual entering one cohort and another. For this we can use the `[summariseCohortTiming()](../reference/summariseCohortTiming.html)`. In this example we’ll look at the time between entering cohorts for acetaminophen, morphine, and oxycodone using the Eunomia data.
    
    
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con = con, cdmSchem = "main", writeSchema = "main", cdmName = "Eunomia"
    )
    
    medsCs <- [getDrugIngredientCodes](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html)(
      cdm = cdm,
      name = [c](https://rdrr.io/r/base/c.html)(
        "acetaminophen",
        "morphine",
        "warfarin"
      )
    )
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      name = "meds",
      conceptSet = medsCs,
      end = "event_end_date",
      limit = "all",
      overwrite = TRUE
    )
    
    [settings](https://darwin-eu.github.io/omopgenerics/reference/settings.html)(cdm$meds)
    #> # A tibble: 3 × 6
    #>   cohort_definition_id cohort_name    limit prior_observation future_observation
    #>                  <int> <chr>          <chr>             <dbl>              <dbl>
    #> 1                    1 11289_warfarin all                   0                  0
    #> 2                    2 161_acetamino… all                   0                  0
    #> 3                    3 7052_morphine  all                   0                  0
    #> # ℹ 1 more variable: end <chr>
    [cohortCount](https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html)(cdm$meds)
    #> # A tibble: 3 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1            137             137
    #> 2                    2          13908            2679
    #> 3                    3             35              35

Now we have our cohorts we can summarise the timing between cohort entry. Note setting restrictToFirstEntry to TRUE will mean that we only consider timing between an individual’s first record in each cohort (i.e. their first exposure to each of the medications).
    
    
    medsTiming <- cdm$meds |>
      [summariseCohortTiming](../reference/summariseCohortTiming.html)(restrictToFirstEntry = TRUE)
    medsTiming |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 6,186
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "Eunomia", "Eunomia", "Eunomia", "Eunomia", "Eunomia"…
    #> $ group_name       <chr> "cohort_name_reference &&& cohort_name_comparator", "…
    #> $ group_level      <chr> "11289_warfarin &&& 161_acetaminophen", "11289_warfar…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "number records", "number subjects", "days_between_co…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, "density_001", "density_0…
    #> $ estimate_name    <chr> "count", "count", "min", "q25", "median", "q75", "max…
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "136", "136", "-33784", "-24462", "-19709", "-16926",…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…

As with cohort overlap, we have table and plotting functions to help view our results.
    
    
    [tableCohortTiming](../reference/tableCohortTiming.html)(medsTiming, timeScale = "years", uniqueCombinations = FALSE)

Cohort name reference | Cohort name comparator | Variable name | Estimate name | Estimate value  
---|---|---|---|---  
Eunomia  
11289_warfarin | 161_acetaminophen | number records | N | 136  
|  | number subjects | N | 136  
|  | years_between_cohort_entries | Median [Q25 - Q75] | -53.96 [-66.97 - -46.34]  
|  |  | Range | -92.50 to 3.03  
| 7052_morphine | number records | N | 6  
|  | number subjects | N | 6  
|  | years_between_cohort_entries | Median [Q25 - Q75] | -4.54 [-10.36 - 4.76]  
|  |  | Range | -18.99 to 9.24  
161_acetaminophen | 11289_warfarin | number records | N | 136  
|  | number subjects | N | 136  
|  | years_between_cohort_entries | Median [Q25 - Q75] | 53.96 [46.34 - 66.97]  
|  |  | Range | -3.03 to 92.50  
| 7052_morphine | number records | N | 35  
|  | number subjects | N | 35  
|  | years_between_cohort_entries | Median [Q25 - Q75] | 15.79 [5.02 - 33.51]  
|  |  | Range | -33.72 to 77.29  
7052_morphine | 11289_warfarin | number records | N | 6  
|  | number subjects | N | 6  
|  | years_between_cohort_entries | Median [Q25 - Q75] | 4.54 [-4.76 - 10.36]  
|  |  | Range | -9.24 to 18.99  
| 161_acetaminophen | number records | N | 35  
|  | number subjects | N | 35  
|  | years_between_cohort_entries | Median [Q25 - Q75] | -15.79 [-33.51 - -5.02]  
|  |  | Range | -77.29 to 33.72  
      
    
    [plotCohortTiming](../reference/plotCohortTiming.html)(
      medsTiming,
      plotType = "boxplot",
      timeScale = "years",
      uniqueCombinations = FALSE
    )

![](summarise_cohort_timing_files/figure-html/unnamed-chunk-5-1.png)

If we want to see an even more granular summary of cohort timings we can make a density plot instead of a box plot. Note, for this we’ll need to set density to include ‘density’ as one of the estimates.
    
    
    [plotCohortTiming](../reference/plotCohortTiming.html)(
      medsTiming,
      plotType = "densityplot",
      timeScale = "years",
      uniqueCombinations = FALSE
    )

![](summarise_cohort_timing_files/figure-html/unnamed-chunk-6-1.png)

As well as generating these estimates for cohorts overall, we can also obtain stratified estimates.
    
    
    cdm$meds <- cdm$meds |>
      [addAge](https://darwin-eu.github.io/PatientProfiles/reference/addAge.html)(ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 49), [c](https://rdrr.io/r/base/c.html)(50, 150))) |>
      [compute](https://dplyr.tidyverse.org/reference/compute.html)(temporary = FALSE, name = "meds") |>
      [newCohortTable](https://darwin-eu.github.io/omopgenerics/reference/newCohortTable.html)()
    medsTiming <- cdm$meds |>
      [summariseCohortTiming](../reference/summariseCohortTiming.html)(
        restrictToFirstEntry = TRUE,
        strata = [list](https://rdrr.io/r/base/list.html)("age_group"),
        density = TRUE
      )
    [tableCohortTiming](../reference/tableCohortTiming.html)(medsTiming, timeScale = "years")

Cohort name reference | Cohort name comparator | Variable name | Estimate name |  Age group  
---|---|---|---|---  
overall | 0 to 49 | 50 to 150  
Eunomia  
11289_warfarin | 161_acetaminophen | number records | N | 9 | 8 | 1  
|  | number subjects | N | 9 | 8 | 1  
|  | years_between_cohort_entries | Median [Q25 - Q75] | -43.77 [-46.35 - -32.09] | -44.88 [-46.44 - -33.29] | 2.12 [2.12 - 2.12]  
|  |  | Range | -48.89 to 2.12 | -48.89 to -29.03 | 2.12 to 2.12  
| 7052_morphine | number records | N | 6 | - | 6  
|  | number subjects | N | 6 | - | 6  
|  | years_between_cohort_entries | Median [Q25 - Q75] | -4.54 [-10.36 - 4.76] | - | -4.54 [-10.36 - 4.76]  
|  |  | Range | -18.99 to 9.24 | - | -18.99 to 9.24  
161_acetaminophen | 7052_morphine | number records | N | 26 | 25 | 1  
|  | number subjects | N | 26 | 25 | 1  
|  | years_between_cohort_entries | Median [Q25 - Q75] | 9.55 [0.85 - 28.56] | 9.05 [0.41 - 29.90] | 24.44 [24.44 - 24.44]  
|  |  | Range | -33.72 to 37.08 | -33.72 to 37.08 | 24.44 to 24.44  
      
    
    [plotCohortTiming](../reference/plotCohortTiming.html)(medsTiming,
      plotType = "boxplot",
      timeScale = "years",
      facet = "age_group",
      colour = "age_group",
      uniqueCombinations = TRUE
    )

![](summarise_cohort_timing_files/figure-html/unnamed-chunk-7-1.png)

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/news/index.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Changelog

Source: [`NEWS.md`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/NEWS.md)

## CohortCharacteristics 1.0.0

CRAN release: 2025-05-20

  * Stable release of the package



### New features

  * includeSource -> pair standard and source concepts in LSC by [@catalamarti](https://github.com/catalamarti) in [#329](https://github.com/darwin-eu/CohortCharacteristics/issues/329)
  * new function tableTopLargeScaleCharacteristics by [@catalamarti](https://github.com/catalamarti) in [#335](https://github.com/darwin-eu/CohortCharacteristics/issues/335)
  * refactor function tableLargeScaleCharacteristics by [@catalamarti](https://github.com/catalamarti) in [#335](https://github.com/darwin-eu/CohortCharacteristics/issues/335)
  * summariseCohortCodelist by [@catalamarti](https://github.com/catalamarti) in [#333](https://github.com/darwin-eu/CohortCharacteristics/issues/333)



### Minor fixes

  * fixes filter group by [@ilovemane](https://github.com/ilovemane) in [#313](https://github.com/darwin-eu/CohortCharacteristics/issues/313)
  * fixes tableintersect suppression problem by [@ilovemane](https://github.com/ilovemane) in [#311](https://github.com/darwin-eu/CohortCharacteristics/issues/311)
  * add .options for table functions by [@ilovemane](https://github.com/ilovemane) in [#319](https://github.com/darwin-eu/CohortCharacteristics/issues/319)
  * density plot for plotCharacteristics by [@ilovemane](https://github.com/ilovemane) in [#320](https://github.com/darwin-eu/CohortCharacteristics/issues/320)
  * use og functions instead of vor by [@catalamarti](https://github.com/catalamarti) in [#332](https://github.com/darwin-eu/CohortCharacteristics/issues/332)
  * improvement on vignettes. by [@ilovemane](https://github.com/ilovemane) in [#327](https://github.com/darwin-eu/CohortCharacteristics/issues/327)
  * Require-minimum-count-for-plot-timing by [@ilovemane](https://github.com/ilovemane) in [#318](https://github.com/darwin-eu/CohortCharacteristics/issues/318)
  * Fix suppressed count print by [@catalamarti](https://github.com/catalamarti) in [#334](https://github.com/darwin-eu/CohortCharacteristics/issues/334)



## CohortCharacteristics 0.5.1

CRAN release: 2025-03-27

  * Fix bug in plotCohortAttrition to not display NAs by [@martaalcalde](https://github.com/martaalcalde)
  * Throw error if cohort table is the input of plotCohortAttrition() by [@catalamarti](https://github.com/catalamarti)



## CohortCharacteristics 0.5.0

CRAN release: 2025-03-18

  * Update benchmarkCohortCharacteristics.R by [@cecicampanile](https://github.com/cecicampanile)
  * fix typo in tableLargeScaleCharacteristics by [@catalamarti](https://github.com/catalamarti)
  * fix typo in source_type by [@catalamarti](https://github.com/catalamarti)
  * `summariseCharacteristics` cohort by cohort by [@cecicampanile](https://github.com/cecicampanile)
  * Allow multiple cdm and cohorts in plotCohortAttrition + png format by [@catalamarti](https://github.com/catalamarti)
  * Stack bar in plotCohortOverlap by [@ilovemane](https://github.com/ilovemane)
  * variable_name as factor in plotCohortOverlap by [@catalamarti](https://github.com/catalamarti)
  * none -> unknown in summariseCharacteristics by [@catalamarti](https://github.com/catalamarti)
  * Add weights argument to `summariseCharacteristics` by [@catalamarti](https://github.com/catalamarti)
  * Use filterCohortId when needed by [@catalamarti](https://github.com/catalamarti)
  * Fix ’ character in plotCohortAttrition by [@catalamarti](https://github.com/catalamarti)
  * filter excludeCodes at the end by [@catalamarti](https://github.com/catalamarti)
  * use <minCellCount in tables by [@catalamarti](https://github.com/catalamarti)



## CohortCharacteristics 0.4.0

CRAN release: 2024-11-26

  * Update links darwin-eu-dev -> darwin-eu [@catalamarti](https://github.com/catalamarti)
  * Typo in plotCohortAttrition by [@martaalcalde](https://github.com/martaalcalde)
  * uniqueCombination parameter to work in a general way [@catalamarti](https://github.com/catalamarti)
  * minimum 5 days in x axis for density plots [@catalamarti](https://github.com/catalamarti)
  * improve documentation of minimumFrequency by [@catalamarti](https://github.com/catalamarti)
  * add show argument to plotCohortAttrition by [@catalamarti](https://github.com/catalamarti)
  * simplify code for overlap and fix edge case with 0 overlap by [@catalamarti](https://github.com/catalamarti)
  * arrange ageGroups by order that they are provided in summariseCharacteristics by [@catalamarti](https://github.com/catalamarti)
  * otherVariablesEstimates -> estimates in summariseCharacteristics by [@catalamarti](https://github.com/catalamarti)
  * add overlapBy argument to summariseCohortOverlap by [@catalamarti](https://github.com/catalamarti)
  * Compatibility with visOmopResults 0.5.0 and omopgenerics 0.4.0 by [@catalamarti](https://github.com/catalamarti)
  * add message if different pkg versions by [@catalamarti](https://github.com/catalamarti)
  * make sure settings are characters by [@catalamarti](https://github.com/catalamarti)
  * use requireEunomia and CDMConnector 1.6.0 by [@catalamarti](https://github.com/catalamarti)
  * add benchmark function by [@catalamarti](https://github.com/catalamarti)
  * Consistent documentation by [@catalamarti](https://github.com/catalamarti)
  * Use subjects only when overlapBy = “subject_id” by [@catalamarti](https://github.com/catalamarti)
  * add cohortId to LSC by [@catalamarti](https://github.com/catalamarti)



## CohortCharacteristics 0.3.0

CRAN release: 2024-10-01

  * **breaking change** Complete refactor of `table*` and `plot*` functions following visOmopResults 0.4.0 release.
  * `summarise*` functions output is always ordered in the same way.
  * Added a `NEWS.md` file to track changes to the package.



## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/mockCohortCharacteristics.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# It creates a mock database for testing CohortCharacteristics package

Source: [`R/reexports.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/reexports.R)

`mockCohortCharacteristics.Rd`

It creates a mock database for testing CohortCharacteristics package

## Usage
    
    
    mockCohortCharacteristics(
      con = NULL,
      writeSchema = NULL,
      numberIndividuals = 10,
      ...,
      seed = NULL
    )

## Arguments

con
    

A DBI connection to create the cdm mock object.

writeSchema
    

Name of an schema on the same connection with writing permissions.

numberIndividuals
    

Number of individuals to create in the cdm reference.

...
    

User self defined tables to put in cdm, it can input as many as the user want.

seed
    

A number to set the seed. If NULL seed is not used.

## Value

A mock cdm_reference object created following user's specifications.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    
    cdm <- mockCohortCharacteristics()
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortCount.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Summarise counts for cohorts in a cohort table

Source: [`R/summariseCohortCount.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/summariseCohortCount.R)

`summariseCohortCount.Rd`

Summarise counts for cohorts in a cohort table

## Usage
    
    
    summariseCohortCount(cohort, cohortId = NULL, strata = [list](https://rdrr.io/r/base/list.html)())

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

strata
    

A list of variables to stratify results. These variables must have been added as additional columns in the cohort table.

## Value

A summary of counts of the cohorts in the cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)()
    
    summariseCohortCount(cohort = cdm$cohort1) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> ℹ summarising data
    #> ℹ summarising cohort cohort_1
    #> ℹ summarising cohort cohort_2
    #> ℹ summarising cohort cohort_3
    #> ✔ summariseCharacteristics finished!
    #> Rows: 6
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1
    #> $ cdm_name         <chr> "PP_MOCK", "PP_MOCK", "PP_MOCK", "PP_MOCK", "PP_MOCK"…
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "cohort_1", "cohort_1", "cohort_2", "cohort_2", "coho…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Number records", "Number subjects", "Number records"…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA
    #> $ estimate_name    <chr> "count", "count", "count", "count", "count", "count"
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "3", "3", "4", "4", "3", "3"
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/tableCohortCount.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Format a summarise_characteristics object into a visual table.

Source: [`R/tableCohortCount.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/tableCohortCount.R)

`tableCohortCount.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    tableCohortCount(
      result,
      type = "gt",
      header = "cohort_name",
      groupColumn = [character](https://rdrr.io/r/base/character.html)(),
      hide = [c](https://rdrr.io/r/base/c.html)("variable_level", [settingsColumns](https://darwin-eu.github.io/omopgenerics/reference/settingsColumns.html)(result)),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A summarised_result object.

type
    

Type of table. Check supported types with `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)`.

header
    

Columns to use as header. See options with `availableTableColumns(result)`.

groupColumn
    

Columns to group by. See options with `availableTableColumns(result)`.

hide
    

Columns to hide from the visualisation. See options with `availableTableColumns(result)`.

.options
    

A named list with additional formatting options. `[visOmopResults::tableOptions()](https://darwin-eu.github.io/visOmopResults/reference/tableOptions.html)` shows allowed arguments and their default values.

## Value

A formatted table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)()
    
    result <- [summariseCohortCount](summariseCohortCount.html)(cdm$cohort1)
    #> ℹ summarising data
    #> ℹ summarising cohort cohort_1
    #> ℹ summarising cohort cohort_3
    #> ✔ summariseCharacteristics finished!
    
    tableCohortCount(result)
    
    
    
    
      CDM name
          | Variable name
          | Estimate name
          | 
            Cohort name
          
          
    ---|---|---|---  
    cohort_1
          | cohort_3
          
    PP_MOCK
    | Number records
    | N
    | 5
    | 5  
    
    | Number subjects
    | N
    | 5
    | 5  
      
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortCount.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Plot the result of summariseCohortCount.

Source: [`R/plotCohortCount.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/plotCohortCount.R)

`plotCohortCount.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    plotCohortCount(result, x = NULL, facet = [c](https://rdrr.io/r/base/c.html)("cdm_name"), colour = NULL)

## Arguments

result
    

A summarised_result object.

x
    

Variables to use in x axis.

facet
    

Columns to facet by. See options with `availablePlotColumns(result)`. Formula is also allowed to specify rows and columns.

colour
    

Columns to color by. See options with `availablePlotColumns(result)`.

## Value

A ggplot.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)(numberIndividuals = 100)
    
    counts <- cdm$cohort2 |>
      [addSex](https://darwin-eu.github.io/PatientProfiles/reference/addSex.html)() |>
      [addAge](https://darwin-eu.github.io/PatientProfiles/reference/addAge.html)(ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 29), [c](https://rdrr.io/r/base/c.html)(30, 59), [c](https://rdrr.io/r/base/c.html)(60, Inf))) |>
      [summariseCohortCount](summariseCohortCount.html)(strata = [list](https://rdrr.io/r/base/list.html)("age_group", "sex", [c](https://rdrr.io/r/base/c.html)("age_group", "sex"))) |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "Number subjects")
    #> ℹ summarising data
    #> ℹ summarising cohort cohort_1
    #> ℹ summarising cohort cohort_2
    #> ℹ summarising cohort cohort_3
    #> ✔ summariseCharacteristics finished!
    
    counts |>
      plotCohortCount(
        x = "sex",
        facet = cohort_name ~ age_group,
        colour = "sex"
      )
    ![](plotCohortCount-1.png)
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortAttrition.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Summarise attrition associated with cohorts in a cohort table

Source: [`R/summariseCohortAttrition.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/summariseCohortAttrition.R)

`summariseCohortAttrition.Rd`

Summarise attrition associated with cohorts in a cohort table

## Usage
    
    
    summariseCohortAttrition(cohort, cohortId = NULL)

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

## Value

A summary of the attrition for the cohorts in the cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)()
    
    summariseCohortAttrition(cohort = cdm$cohort1) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 12
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3
    #> $ cdm_name         <chr> "PP_MOCK", "PP_MOCK", "PP_MOCK", "PP_MOCK", "PP_MOCK"…
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "cohort_1", "cohort_1", "cohort_1", "cohort_1", "coho…
    #> $ strata_name      <chr> "reason", "reason", "reason", "reason", "reason", "re…
    #> $ strata_level     <chr> "Initial qualifying events", "Initial qualifying even…
    #> $ variable_name    <chr> "number_records", "number_subjects", "excluded_record…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    #> $ estimate_name    <chr> "count", "count", "count", "count", "count", "count",…
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "2", "2", "0", "0", "3", "3", "0", "0", "5", "5", "0"…
    #> $ additional_name  <chr> "reason_id", "reason_id", "reason_id", "reason_id", "…
    #> $ additional_level <chr> "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"…
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/tableCohortAttrition.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Create a visual table from the output of summariseCohortAttrition.

Source: [`R/tableCohortAttrition.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/tableCohortAttrition.R)

`tableCohortAttrition.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    tableCohortAttrition(
      result,
      type = "gt",
      header = "variable_name",
      groupColumn = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name"),
      hide = [c](https://rdrr.io/r/base/c.html)("variable_level", "reason_id", "estimate_name", [settingsColumns](https://darwin-eu.github.io/omopgenerics/reference/settingsColumns.html)(result)),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A summarised_result object.

type
    

Type of table. Check supported types with `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)`.

header
    

Columns to use as header. See options with `availableTableColumns(result)`.

groupColumn
    

Columns to group by. See options with `availableTableColumns(result)`.

hide
    

Columns to hide from the visualisation. See options with `availableTableColumns(result)`.

.options
    

A named list with additional formatting options. `[visOmopResults::tableOptions()](https://darwin-eu.github.io/visOmopResults/reference/tableOptions.html)` shows allowed arguments and their default values.

## Value

A formatted table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)()
    
    result <- [summariseCohortAttrition](summariseCohortAttrition.html)(cdm$cohort2)
    
    tableCohortAttrition(result)
    
    
    
    
      Reason
          | 
            Variable name
          
          
    ---|---  
    number_records
          | number_subjects
          | excluded_records
          | excluded_subjects
          
    PP_MOCK; cohort_1
          
    Initial qualifying events
    | 4
    | 4
    | 0
    | 0  
    PP_MOCK; cohort_2
          
    Initial qualifying events
    | 5
    | 5
    | 0
    | 0  
    PP_MOCK; cohort_3
          
    Initial qualifying events
    | 1
    | 1
    | 0
    | 0  
      
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortAttrition.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# create a ggplot from the output of summariseLargeScaleCharacteristics.

Source: [`R/plotCohortAttrition.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/plotCohortAttrition.R)

`plotCohortAttrition.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    plotCohortAttrition(
      result,
      show = [c](https://rdrr.io/r/base/c.html)("subjects", "records"),
      type = "htmlwidget",
      cohortId = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)()
    )

## Arguments

result
    

A summarised_result object.

show
    

Which variables to show in the attrition plot, it can be 'subjects', 'records' or both.

type
    

type of the output, it can either be: 'htmlwidget', 'png', or 'DiagrammeR'.

cohortId
    

deprecated.

## Value

A `grViz` visualisation.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    #> 
    #> Attaching package: ‘omopgenerics’
    #> The following object is masked from ‘package:stats’:
    #> 
    #>     filter
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)(numberIndividuals = 1000)
    
    cdm[["cohort1"]] <- cdm[["cohort1"]] |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(year(cohort_start_date) >= 2000) |>
      [recordCohortAttrition](https://darwin-eu.github.io/omopgenerics/reference/recordCohortAttrition.html)("Restrict to cohort_start_date >= 2000") |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(year(cohort_end_date) < 2020) |>
      [recordCohortAttrition](https://darwin-eu.github.io/omopgenerics/reference/recordCohortAttrition.html)("Restrict to cohort_end_date < 2020") |>
      [compute](https://dplyr.tidyverse.org/reference/compute.html)(temporary = FALSE, name = "cohort1")
    
    result <- [summariseCohortAttrition](summariseCohortAttrition.html)(cdm$cohort1)
    
    result |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(group_level == "cohort_2") |>
      plotCohortAttrition()
    
    
    
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCharacteristics.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Summarise characteristics of cohorts in a cohort table

Source: [`R/summariseCharacteristics.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/summariseCharacteristics.R)

`summariseCharacteristics.Rd`

Summarise characteristics of cohorts in a cohort table

## Usage
    
    
    summariseCharacteristics(
      cohort,
      cohortId = NULL,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      counts = TRUE,
      demographics = TRUE,
      ageGroup = NULL,
      tableIntersectFlag = [list](https://rdrr.io/r/base/list.html)(),
      tableIntersectCount = [list](https://rdrr.io/r/base/list.html)(),
      tableIntersectDate = [list](https://rdrr.io/r/base/list.html)(),
      tableIntersectDays = [list](https://rdrr.io/r/base/list.html)(),
      cohortIntersectFlag = [list](https://rdrr.io/r/base/list.html)(),
      cohortIntersectCount = [list](https://rdrr.io/r/base/list.html)(),
      cohortIntersectDate = [list](https://rdrr.io/r/base/list.html)(),
      cohortIntersectDays = [list](https://rdrr.io/r/base/list.html)(),
      conceptIntersectFlag = [list](https://rdrr.io/r/base/list.html)(),
      conceptIntersectCount = [list](https://rdrr.io/r/base/list.html)(),
      conceptIntersectDate = [list](https://rdrr.io/r/base/list.html)(),
      conceptIntersectDays = [list](https://rdrr.io/r/base/list.html)(),
      otherVariables = [character](https://rdrr.io/r/base/character.html)(),
      estimates = [list](https://rdrr.io/r/base/list.html)(),
      weights = NULL,
      otherVariablesEstimates = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)()
    )

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

strata
    

A list of variables to stratify results. These variables must have been added as additional columns in the cohort table.

counts
    

TRUE or FALSE. If TRUE, record and person counts will be produced.

demographics
    

TRUE or FALSE. If TRUE, patient demographics (cohort start date, cohort end date, age, sex, prior observation, and future observation will be summarised).

ageGroup
    

A list of age groups to stratify results by.

tableIntersectFlag
    

A list of arguments that uses PatientProfiles::addTableIntersectFlag() to add variables to summarise.

tableIntersectCount
    

A list of arguments that uses PatientProfiles::addTableIntersectCount() to add variables to summarise.

tableIntersectDate
    

A list of arguments that uses PatientProfiles::addTableIntersectDate() to add variables to summarise.

tableIntersectDays
    

A list of arguments that uses PatientProfiles::addTableIntersectDays() to add variables to summarise.

cohortIntersectFlag
    

A list of arguments that uses PatientProfiles::addCohortIntersectFlag() to add variables to summarise.

cohortIntersectCount
    

A list of arguments that uses PatientProfiles::addCohortIntersectCount() to add variables to summarise.

cohortIntersectDate
    

A list of arguments that uses PatientProfiles::addCohortIntersectDate() to add variables to summarise.

cohortIntersectDays
    

A list of arguments that uses PatientProfiles::addCohortIntersectDays() to add variables to summarise.

conceptIntersectFlag
    

A list of arguments that uses PatientProfiles::addConceptIntersectFlag() to add variables to summarise.

conceptIntersectCount
    

A list of arguments that uses PatientProfiles::addConceptIntersectCount() to add variables to summarise.

conceptIntersectDate
    

A list of arguments that uses PatientProfiles::addConceptIntersectDate() to add variables to summarise.

conceptIntersectDays
    

A list of arguments that uses PatientProfiles::addConceptIntersectDays() to add variables to summarise.

otherVariables
    

Other variables contained in cohort that you want to be summarised.

estimates
    

To modify the default estimates for a variable. By default: 'min', 'q25', 'median', 'q75', 'max' for "date", "numeric" and "integer" variables ("numeric" and "integer" also use 'mean' and 'sd' estimates). 'count' and 'percentage' for "categorical" and "binary". You have to provide them as a list: `list(age = c("median", "density"))`. You can also use 'date', 'numeric', 'integer', 'binary', 'categorical', 'demographics', 'intersect', 'other', 'table_intersect_count', ...

weights
    

Column in cohort that points to weights of each individual.

otherVariablesEstimates
    

deprecated.

## Value

A summary of the characteristics of the cohorts in the cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)()
    
    cdm$cohort1 |>
      [addSex](https://darwin-eu.github.io/PatientProfiles/reference/addSex.html)() |>
      [addAge](https://darwin-eu.github.io/PatientProfiles/reference/addAge.html)(
        ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 40), [c](https://rdrr.io/r/base/c.html)(41, 150))
      ) |>
      summariseCharacteristics(
        strata = [list](https://rdrr.io/r/base/list.html)("sex", "age_group"),
        cohortIntersectFlag = [list](https://rdrr.io/r/base/list.html)(
          "Cohort 2 Flag" = [list](https://rdrr.io/r/base/list.html)(
            targetCohortTable = "cohort2", window = [c](https://rdrr.io/r/base/c.html)(-365, 0)
          )
        ),
        cohortIntersectCount = [list](https://rdrr.io/r/base/list.html)(
          "Cohort 2 Count" = [list](https://rdrr.io/r/base/list.html)(
            targetCohortTable = "cohort2", window = [c](https://rdrr.io/r/base/c.html)(-365, 0)
          )
        )
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> ℹ adding demographics columns
    #> ℹ adding cohortIntersectFlag 1/1
    #> window names casted to snake_case:
    #> • `-365 to 0` -> `365_to_0`
    #> ℹ adding cohortIntersectCount 1/1
    #> window names casted to snake_case:
    #> • `-365 to 0` -> `365_to_0`
    #> ℹ summarising data
    #> ℹ summarising cohort cohort_1
    #> ℹ summarising cohort cohort_2
    #> ℹ summarising cohort cohort_3
    #> ✔ summariseCharacteristics finished!
    #> Rows: 840
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    #> $ cdm_name         <chr> "PP_MOCK", "PP_MOCK", "PP_MOCK", "PP_MOCK", "PP_MOCK"…
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "cohort_1", "cohort_1", "cohort_1", "cohort_1", "coho…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Number records", "Number subjects", "Cohort start da…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    #> $ estimate_name    <chr> "count", "count", "min", "q25", "median", "q75", "max…
    #> $ estimate_type    <chr> "integer", "integer", "date", "date", "date", "date",…
    #> $ estimate_value   <chr> "3", "3", "1941-02-23", "1960-11-23", "1980-08-22", "…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/tableCharacteristics.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Format a summarise_characteristics object into a visual table.

Source: [`R/tableCharacteristics.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/tableCharacteristics.R)

`tableCharacteristics.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    tableCharacteristics(
      result,
      type = "gt",
      header = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name"),
      groupColumn = [character](https://rdrr.io/r/base/character.html)(),
      hide = [c](https://rdrr.io/r/base/c.html)([additionalColumns](https://darwin-eu.github.io/omopgenerics/reference/additionalColumns.html)(result), [settingsColumns](https://darwin-eu.github.io/omopgenerics/reference/settingsColumns.html)(result)),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A summarised_result object.

type
    

Type of table. Check supported types with `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)`.

header
    

Columns to use as header. See options with `availableTableColumns(result)`.

groupColumn
    

Columns to group by. See options with `availableTableColumns(result)`.

hide
    

Columns to hide from the visualisation. See options with `availableTableColumns(result)`.

.options
    

A named list with additional formatting options. `[visOmopResults::tableOptions()](https://darwin-eu.github.io/visOmopResults/reference/tableOptions.html)` shows allowed arguments and their default values.

## Value

A formatted table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)()
    
    result <- [summariseCharacteristics](summariseCharacteristics.html)(cdm$cohort1)
    #> ℹ adding demographics columns
    #> ℹ summarising data
    #> ℹ summarising cohort cohort_1
    #> ℹ summarising cohort cohort_3
    #> ✔ summariseCharacteristics finished!
    
    tableCharacteristics(result)
    
    
    
    
      
          | 
            CDM name
          
          
    ---|---  
    
          | 
            PP_MOCK
          
          
    Variable name
          | Variable level
          | Estimate name
          | 
            Cohort name
          
          
    cohort_1
          | cohort_3
          
    Number records
    | -
    | N
    | 4
    | 6  
    Number subjects
    | -
    | N
    | 4
    | 6  
    Cohort start date
    | -
    | Median [Q25 - Q75]
    | 1965-10-09 [1954-06-28 - 1974-01-30]
    | 1939-05-27 [1920-10-18 - 1965-02-28]  
    
    | 
    | Range
    | 1935-04-26 to 1984-05-02
    | 1911-08-13 to 1979-06-02  
    Cohort end date
    | -
    | Median [Q25 - Q75]
    | 1967-10-04 [1957-02-14 - 1975-01-07]
    | 1942-07-08 [1927-02-12 - 1966-07-06]  
    
    | 
    | Range
    | 1937-08-11 to 1984-06-02
    | 1916-06-11 to 1980-06-06  
    Age
    | -
    | Median [Q25 - Q75]
    | 24 [15 - 28]
    | 13 [6 - 28]  
    
    | 
    | Mean (SD)
    | 20.25 (11.84)
    | 18.17 (15.89)  
    
    | 
    | Range
    | 4 to 30
    | 3 to 43  
    Sex
    | Female
    | N (%)
    | 1 (25.00%)
    | 3 (50.00%)  
    
    | Male
    | N (%)
    | 3 (75.00%)
    | 3 (50.00%)  
    Prior observation
    | -
    | Median [Q25 - Q75]
    | 8,864 [5,841 - 10,620]
    | 4,827 [2,644 - 10,284]  
    
    | 
    | Mean (SD)
    | 7,596.00 (4,343.80)
    | 6,828.33 (5,815.56)  
    
    | 
    | Range
    | 1,583 to 11,072
    | 1,320 to 15,977  
    Future observation
    | -
    | Median [Q25 - Q75]
    | 694 [435 - 1,141]
    | 3,946 [2,619 - 5,626]  
    
    | 
    | Mean (SD)
    | 881.50 (714.23)
    | 4,626.00 (3,087.41)  
    
    | 
    | Range
    | 260 to 1,878
    | 1,493 to 10,010  
    Days in cohort
    | -
    | Median [Q25 - Q75]
    | 643 [343 - 880]
    | 1,139 [551 - 1,620]  
    
    | 
    | Mean (SD)
    | 580.50 (433.92)
    | 1,231.83 (914.61)  
    
    | 
    | Range
    | 32 to 1,004
    | 263 to 2,714  
      
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/plotCharacteristics.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Create a ggplot from the output of summariseCharacteristics.

Source: [`R/plotCharacteristics.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/plotCharacteristics.R)

`plotCharacteristics.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    plotCharacteristics(
      result,
      plotType = "barplot",
      facet = NULL,
      colour = NULL,
      plotStyle = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)()
    )

## Arguments

result
    

A summarised_result object.

plotType
    

Either `barplot`, `scatterplot` or `boxplot`. If `barplot` or `scatterplot` subset to just one estimate.

facet
    

Columns to facet by. See options with `availablePlotColumns(result)`. Formula is also allowed to specify rows and columns.

colour
    

Columns to color by. See options with `availablePlotColumns(result)`.

plotStyle
    

deprecated.

## Value

A ggplot.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)()
    
    results <- [summariseCharacteristics](summariseCharacteristics.html)(
      cohort = cdm$cohort1,
      ageGroup = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 19), [c](https://rdrr.io/r/base/c.html)(20, 39), [c](https://rdrr.io/r/base/c.html)(40, 59), [c](https://rdrr.io/r/base/c.html)(60, 79), [c](https://rdrr.io/r/base/c.html)(80, 150)),
      tableIntersectCount = [list](https://rdrr.io/r/base/list.html)(
        tableName = "visit_occurrence", window = [c](https://rdrr.io/r/base/c.html)(-365, -1)
      ),
      cohortIntersectFlag = [list](https://rdrr.io/r/base/list.html)(
        targetCohortTable = "cohort2", window = [c](https://rdrr.io/r/base/c.html)(-365, -1)
      )
    )
    #> ℹ adding demographics columns
    #> ℹ adding tableIntersectCount 1/1
    #> window names casted to snake_case:
    #> • `-365 to -1` -> `365_to_1`
    #> ℹ adding cohortIntersectFlag 1/1
    #> window names casted to snake_case:
    #> • `-365 to -1` -> `365_to_1`
    #> ℹ summarising data
    #> ℹ summarising cohort cohort_1
    #> ℹ summarising cohort cohort_2
    #> ℹ summarising cohort cohort_3
    #> ✔ summariseCharacteristics finished!
    
    results |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(
        variable_name == "Cohort2 flag -365 to -1", estimate_name == "percentage"
      ) |>
      plotCharacteristics(
        plotType = "barplot",
        colour = "variable_level",
        facet = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name")
      )
    ![](plotCharacteristics-1.png)
    
    results |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "Age", estimate_name == "mean") |>
      plotCharacteristics(
        plotType = "scatterplot",
        facet = "cdm_name"
      )
    ![](plotCharacteristics-2.png)
    
    results |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(variable_name == "Age", group_level == "cohort_1") |>
      plotCharacteristics(
        plotType = "boxplot",
        facet = "cdm_name",
        colour = "cohort_name"
      )
    ![](plotCharacteristics-3.png)
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortTiming.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Summarise timing between entries into cohorts in a cohort table

Source: [`R/summariseCohortTiming.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/summariseCohortTiming.R)

`summariseCohortTiming.Rd`

Summarise timing between entries into cohorts in a cohort table

## Usage
    
    
    summariseCohortTiming(
      cohort,
      cohortId = NULL,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      restrictToFirstEntry = TRUE,
      estimates = [c](https://rdrr.io/r/base/c.html)("min", "q25", "median", "q75", "max", "density"),
      density = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)()
    )

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

strata
    

A list of variables to stratify results. These variables must have been added as additional columns in the cohort table.

restrictToFirstEntry
    

If TRUE only an individual's first entry per cohort will be considered. If FALSE all entries per individual will be considered.

estimates
    

Summary statistics to use when summarising timing.

density
    

deprecated.

## Value

A summary of timing between entries into cohorts in the cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)(numberIndividuals = 100)
    
    summariseCohortTiming(cdm$cohort2) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 0
    #> Columns: 13
    #> $ result_id        <int> 
    #> $ cdm_name         <chr> 
    #> $ group_name       <chr> 
    #> $ group_level      <chr> 
    #> $ strata_name      <chr> 
    #> $ strata_level     <chr> 
    #> $ variable_name    <chr> 
    #> $ variable_level   <chr> 
    #> $ estimate_name    <chr> 
    #> $ estimate_type    <chr> 
    #> $ estimate_value   <chr> 
    #> $ additional_name  <chr> 
    #> $ additional_level <chr> 
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/tableCohortTiming.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Format a summariseCohortTiming result into a visual table.

Source: [`R/tableCohortTiming.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/tableCohortTiming.R)

`tableCohortTiming.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    tableCohortTiming(
      result,
      timeScale = "days",
      uniqueCombinations = TRUE,
      type = "gt",
      header = [strataColumns](https://darwin-eu.github.io/omopgenerics/reference/strataColumns.html)(result),
      groupColumn = [c](https://rdrr.io/r/base/c.html)("cdm_name"),
      hide = [c](https://rdrr.io/r/base/c.html)("variable_level", [settingsColumns](https://darwin-eu.github.io/omopgenerics/reference/settingsColumns.html)(result)),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A summarised_result object.

timeScale
    

Time scale to show, it can be "days" or "years".

uniqueCombinations
    

Whether to restrict to unique reference and comparator comparisons.

type
    

Type of table. Check supported types with `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)`.

header
    

Columns to use as header. See options with `availableTableColumns(result)`.

groupColumn
    

Columns to group by. See options with `availableTableColumns(result)`.

hide
    

Columns to hide from the visualisation. See options with `availableTableColumns(result)`.

.options
    

A named list with additional formatting options. `[visOmopResults::tableOptions()](https://darwin-eu.github.io/visOmopResults/reference/tableOptions.html)` shows allowed arguments and their default values.

## Value

A formatted table.

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchem = "main", writeSchema = "main")
    
    cdm <- [generateIngredientCohortSet](https://darwin-eu.github.io/DrugUtilisation/reference/generateIngredientCohortSet.html)(
      cdm = cdm,
      name = "my_cohort",
      ingredient = [c](https://rdrr.io/r/base/c.html)("acetaminophen", "morphine", "warfarin")
    )
    
    timings <- [summariseCohortTiming](summariseCohortTiming.html)(cdm$my_cohort)
    
    tableCohortTiming(timings, timeScale = "years")
    
    [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    } # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortTiming.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Plot summariseCohortTiming results.

Source: [`R/plotCohortTiming.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/plotCohortTiming.R)

`plotCohortTiming.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    plotCohortTiming(
      result,
      plotType = "boxplot",
      timeScale = "days",
      uniqueCombinations = TRUE,
      facet = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name_reference"),
      colour = [c](https://rdrr.io/r/base/c.html)("cohort_name_comparator")
    )

## Arguments

result
    

A summarised_result object.

plotType
    

Type of desired formatted table, possibilities are "boxplot" and "densityplot".

timeScale
    

Time scale to show, it can be "days" or "years".

uniqueCombinations
    

Whether to restrict to unique reference and comparator comparisons.

facet
    

Columns to facet by. See options with `availablePlotColumns(result)`. Formula is also allowed to specify rows and columns.

colour
    

Columns to color by. See options with `availablePlotColumns(result)`.

## Value

A ggplot.

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchem = "main", writeSchema = "main")
    
    cdm <- [generateIngredientCohortSet](https://darwin-eu.github.io/DrugUtilisation/reference/generateIngredientCohortSet.html)(
      cdm = cdm,
      name = "my_cohort",
      ingredient = [c](https://rdrr.io/r/base/c.html)("acetaminophen", "morphine", "warfarin")
    )
    
    timings <- [summariseCohortTiming](summariseCohortTiming.html)(cdm$my_cohort)
    
    plotCohortTiming(
      timings,
      timeScale = "years",
      uniqueCombinations = FALSE,
      facet = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name_reference"),
      colour = [c](https://rdrr.io/r/base/c.html)("cohort_name_comparator")
    )
    
    plotCohortTiming(
      timings,
      plotType = "densityplot",
      timeScale = "years",
      uniqueCombinations = FALSE,
      facet = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name_reference"),
      colour = [c](https://rdrr.io/r/base/c.html)("cohort_name_comparator")
    )
    
    [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    } # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortOverlap.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Summarise overlap between cohorts in a cohort table

Source: [`R/summariseCohortOverlap.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/summariseCohortOverlap.R)

`summariseCohortOverlap.Rd`

Summarise overlap between cohorts in a cohort table

## Usage
    
    
    summariseCohortOverlap(
      cohort,
      cohortId = NULL,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      overlapBy = "subject_id"
    )

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

strata
    

A list of variables to stratify results. These variables must have been added as additional columns in the cohort table.

overlapBy
    

Columns in cohort to use as record identifiers.

## Value

A summary of overlap between cohorts in the cohort table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)()
    
    summariseCohortOverlap(cdm$cohort2) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 12
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    #> $ cdm_name         <chr> "PP_MOCK", "PP_MOCK", "PP_MOCK", "PP_MOCK", "PP_MOCK"…
    #> $ group_name       <chr> "cohort_name_reference &&& cohort_name_comparator", "…
    #> $ group_level      <chr> "cohort_1 &&& cohort_3", "cohort_1 &&& cohort_3", "co…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "Only in reference cohort", "In both cohorts", "Only …
    #> $ variable_level   <chr> "Subjects", "Subjects", "Subjects", "Subjects", "Subj…
    #> $ estimate_name    <chr> "count", "count", "count", "count", "count", "count",…
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "4", "0", "6", "6", "0", "4", "0", "40", "60", "0", "…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/tableCohortOverlap.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Format a summariseOverlapCohort result into a visual table.

Source: [`R/tableCohortOverlap.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/tableCohortOverlap.R)

`tableCohortOverlap.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    tableCohortOverlap(
      result,
      uniqueCombinations = TRUE,
      type = "gt",
      header = [c](https://rdrr.io/r/base/c.html)("variable_name"),
      groupColumn = [c](https://rdrr.io/r/base/c.html)("cdm_name"),
      hide = [c](https://rdrr.io/r/base/c.html)("variable_level", [settingsColumns](https://darwin-eu.github.io/omopgenerics/reference/settingsColumns.html)(result)),
      .options = [list](https://rdrr.io/r/base/list.html)()
    )

## Arguments

result
    

A summarised_result object.

uniqueCombinations
    

Whether to restrict to unique reference and comparator comparisons.

type
    

Type of table. Check supported types with `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)`.

header
    

Columns to use as header. See options with `availableTableColumns(result)`.

groupColumn
    

Columns to group by. See options with `availableTableColumns(result)`.

hide
    

Columns to hide from the visualisation. See options with `availableTableColumns(result)`.

.options
    

A named list with additional formatting options. `[visOmopResults::tableOptions()](https://darwin-eu.github.io/visOmopResults/reference/tableOptions.html)` shows allowed arguments and their default values.

## Value

A formatted table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)()
    
    overlap <- [summariseCohortOverlap](summariseCohortOverlap.html)(cdm$cohort2)
    
    tableCohortOverlap(overlap)
    #> `result_id` is not present in result.
    
    
    
    
      Cohort name reference
          | Cohort name comparator
          | Estimate name
          | 
            Variable name
          
          
    ---|---|---|---  
    Only in reference cohort
          | In both cohorts
          | Only in comparator cohort
          
    PP_MOCK
          
    cohort_1
    | cohort_3
    | N (%)
    | 6 (60.00%)
    | 0 (0.00%)
    | 4 (40.00%)  
      
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/plotCohortOverlap.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Plot the result of summariseCohortOverlap.

Source: [`R/plotCohortOverlap.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/plotCohortOverlap.R)

`plotCohortOverlap.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    plotCohortOverlap(
      result,
      uniqueCombinations = TRUE,
      facet = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name_reference"),
      colour = "variable_name",
      .options = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)()
    )

## Arguments

result
    

A summarised_result object.

uniqueCombinations
    

Whether to restrict to unique reference and comparator comparisons.

facet
    

Columns to facet by. See options with `availablePlotColumns(result)`. Formula is also allowed to specify rows and columns.

colour
    

Columns to color by. See options with `availablePlotColumns(result)`.

.options
    

deprecated.

## Value

A ggplot.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)()
    
    overlap <- [summariseCohortOverlap](summariseCohortOverlap.html)(cdm$cohort2)
    
    plotCohortOverlap(overlap, uniqueCombinations = FALSE)
    ![](plotCohortOverlap-1.png)
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/summariseLargeScaleCharacteristics.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# This function is used to summarise the large scale characteristics of a cohort table

Source: [`R/summariseLargeScaleCharacteristics.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/summariseLargeScaleCharacteristics.R)

`summariseLargeScaleCharacteristics.Rd`

This function is used to summarise the large scale characteristics of a cohort table

## Usage
    
    
    summariseLargeScaleCharacteristics(
      cohort,
      cohortId = NULL,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-Inf, -366), [c](https://rdrr.io/r/base/c.html)(-365, -31), [c](https://rdrr.io/r/base/c.html)(-30, -1), [c](https://rdrr.io/r/base/c.html)(0, 0), [c](https://rdrr.io/r/base/c.html)(1, 30), [c](https://rdrr.io/r/base/c.html)(31, 365),
        [c](https://rdrr.io/r/base/c.html)(366, Inf)),
      eventInWindow = NULL,
      episodeInWindow = NULL,
      indexDate = "cohort_start_date",
      censorDate = NULL,
      includeSource = FALSE,
      minimumFrequency = 0.005,
      excludedCodes = [c](https://rdrr.io/r/base/c.html)(0)
    )

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

strata
    

A list of variables to stratify results. These variables must have been added as additional columns in the cohort table.

window
    

Temporal windows that we want to characterize.

eventInWindow
    

Tables to characterise the events in the window. eventInWindow must be provided if episodeInWindow is not specified.

episodeInWindow
    

Tables to characterise the episodes in the window. episodeInWindow must be provided if eventInWindow is not specified.

indexDate
    

Variable in x that contains the date to compute the intersection.

censorDate
    

whether to censor overlap events at a specific date or a column date of x

includeSource
    

Whether to include source concepts.

minimumFrequency
    

Minimum frequency of codes to be reported. If a concept_id has a frequency smaller than `minimumFrequency` in a certain window that estimate will be eliminated from the result object.

excludedCodes
    

Codes excluded.

## Value

The output of this function is a `ResultSummary` containing the relevant information.

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchem = "main", writeSchema = "main")
    
    cdm <- [generateIngredientCohortSet](https://darwin-eu.github.io/DrugUtilisation/reference/generateIngredientCohortSet.html)(
      cdm = cdm, name = "my_cohort", ingredient = "acetaminophen"
    )
    
    cdm$my_cohort |>
      summariseLargeScaleCharacteristics(
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-365, -1), [c](https://rdrr.io/r/base/c.html)(1, 365)),
        eventInWindow = "condition_occurrence"
      ) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    
    [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    } # }
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/tableTopLargeScaleCharacteristics.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Visualise the top concepts per each cdm name, cohort, statification and window.

Source: [`R/tableLargeScaleCharacteristics.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/tableLargeScaleCharacteristics.R)

`tableTopLargeScaleCharacteristics.Rd`

Visualise the top concepts per each cdm name, cohort, statification and window.

## Usage
    
    
    tableTopLargeScaleCharacteristics(result, topConcepts = 10, type = "gt")

## Arguments

result
    

A summarised_result object.

topConcepts
    

Number of concepts to restrict the table.

type
    

Type of table, it can be any of the supported `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)` formats.

## Value

A formated table.

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, cdmSchema = "main", writeSchema = "main")
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      conceptSet = [list](https://rdrr.io/r/base/list.html)(viral_pharyngitis = 4112343),
      name = "my_cohort"
    )
    
    result <- [summariseLargeScaleCharacteristics](summariseLargeScaleCharacteristics.html)(
      cohort = cdm$my_cohort,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-Inf, -1), [c](https://rdrr.io/r/base/c.html)(0, 0), [c](https://rdrr.io/r/base/c.html)(1, Inf)),
      episodeInWindow = "drug_exposure"
    )
    
    tableTopLargeScaleCharacteristics(result)
    
    [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    } # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/plotLargeScaleCharacteristics.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# create a ggplot from the output of summariseLargeScaleCharacteristics.

Source: [`R/plotLargeScaleCharacteristics.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/plotLargeScaleCharacteristics.R)

`plotLargeScaleCharacteristics.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    plotLargeScaleCharacteristics(
      result,
      facet = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name"),
      colour = "variable_level"
    )

## Arguments

result
    

A summarised_result object.

facet
    

Columns to facet by. See options with `availablePlotColumns(result)`. Formula is also allowed to specify rows and columns.

colour
    

Columns to color by. See options with `availablePlotColumns(result)`.

## Value

A ggplot2 object.

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchem = "main", writeSchema = "main")
    
    cdm <- [generateIngredientCohortSet](https://darwin-eu.github.io/DrugUtilisation/reference/generateIngredientCohortSet.html)(
      cdm = cdm, name = "my_cohort", ingredient = "acetaminophen"
    )
    
    resultsLsc <- cdm$my_cohort |>
      [summariseLargeScaleCharacteristics](summariseLargeScaleCharacteristics.html)(
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-365, -1), [c](https://rdrr.io/r/base/c.html)(1, 365)),
        eventInWindow = "condition_occurrence"
      )
    
    resultsLsc |>
      plotLargeScaleCharacteristics(
        facet = [c](https://rdrr.io/r/base/c.html)("cdm_name", "cohort_name"),
        colour = "variable_level"
      )
    
    [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    } # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/plotComparedLargeScaleCharacteristics.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# create a ggplot from the output of summariseLargeScaleCharacteristics.

Source: [`R/plotComparedLargeScaleCharacteristics.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/plotComparedLargeScaleCharacteristics.R)

`plotComparedLargeScaleCharacteristics.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    plotComparedLargeScaleCharacteristics(
      result,
      colour,
      reference = NULL,
      facet = NULL,
      missings = 0
    )

## Arguments

result
    

A summarised_result object.

colour
    

Columns to color by. See options with `availablePlotColumns(result)`.

reference
    

A named character to set up the reference. It must be one of the levels of reference.

facet
    

Columns to facet by. See options with `availablePlotColumns(result)`. Formula is also allowed to specify rows and columns.

missings
    

Value to replace the missing value with. If NULL missing values will be eliminated.

## Value

A ggplot.

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([DrugUtilisation](https://darwin-eu.github.io/DrugUtilisation/))
    [library](https://rdrr.io/r/base/library.html)([plotly](https://plotly-r.com), warn.conflicts = FALSE)
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con, cdmSchem = "main", writeSchema = "main")
    
    cdm <- [generateIngredientCohortSet](https://darwin-eu.github.io/DrugUtilisation/reference/generateIngredientCohortSet.html)(
      cdm = cdm, name = "my_cohort", ingredient = "acetaminophen"
    )
    
    resultsLsc <- cdm$my_cohort |>
      [summariseLargeScaleCharacteristics](summariseLargeScaleCharacteristics.html)(
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-365, -1), [c](https://rdrr.io/r/base/c.html)(1, 365)),
        eventInWindow = "condition_occurrence"
      )
    
    resultsLsc |>
      plotComparedLargeScaleCharacteristics(
        colour = "variable_level",
        reference = "-365 to -1",
        missings = NULL
      ) |>
      [ggplotly](https://rdrr.io/pkg/plotly/man/ggplotly.html)()
    
    [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    } # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/LICENSE.html

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

# Apache License

Source: [`LICENSE.md`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/LICENSE.md)

_Version 2.0, January 2004_ _<<http://www.apache.org/licenses/>>_

### Terms and Conditions for use, reproduction, and distribution

#### 1\. Definitions

“License” shall mean the terms and conditions for use, reproduction, and distribution as defined by Sections 1 through 9 of this document.

“Licensor” shall mean the copyright owner or entity authorized by the copyright owner that is granting the License.

“Legal Entity” shall mean the union of the acting entity and all other entities that control, are controlled by, or are under common control with that entity. For the purposes of this definition, “control” means **(i)** the power, direct or indirect, to cause the direction or management of such entity, whether by contract or otherwise, or **(ii)** ownership of fifty percent (50%) or more of the outstanding shares, or **(iii)** beneficial ownership of such entity.

“You” (or “Your”) shall mean an individual or Legal Entity exercising permissions granted by this License.

“Source” form shall mean the preferred form for making modifications, including but not limited to software source code, documentation source, and configuration files.

“Object” form shall mean any form resulting from mechanical transformation or translation of a Source form, including but not limited to compiled object code, generated documentation, and conversions to other media types.

“Work” shall mean the work of authorship, whether in Source or Object form, made available under the License, as indicated by a copyright notice that is included in or attached to the work (an example is provided in the Appendix below).

“Derivative Works” shall mean any work, whether in Source or Object form, that is based on (or derived from) the Work and for which the editorial revisions, annotations, elaborations, or other modifications represent, as a whole, an original work of authorship. For the purposes of this License, Derivative Works shall not include works that remain separable from, or merely link (or bind by name) to the interfaces of, the Work and Derivative Works thereof.

“Contribution” shall mean any work of authorship, including the original version of the Work and any modifications or additions to that Work or Derivative Works thereof, that is intentionally submitted to Licensor for inclusion in the Work by the copyright owner or by an individual or Legal Entity authorized to submit on behalf of the copyright owner. For the purposes of this definition, “submitted” means any form of electronic, verbal, or written communication sent to the Licensor or its representatives, including but not limited to communication on electronic mailing lists, source code control systems, and issue tracking systems that are managed by, or on behalf of, the Licensor for the purpose of discussing and improving the Work, but excluding communication that is conspicuously marked or otherwise designated in writing by the copyright owner as “Not a Contribution.”

“Contributor” shall mean Licensor and any individual or Legal Entity on behalf of whom a Contribution has been received by Licensor and subsequently incorporated within the Work.

#### 2\. Grant of Copyright License

Subject to the terms and conditions of this License, each Contributor hereby grants to You a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable copyright license to reproduce, prepare Derivative Works of, publicly display, publicly perform, sublicense, and distribute the Work and such Derivative Works in Source or Object form.

#### 3\. Grant of Patent License

Subject to the terms and conditions of this License, each Contributor hereby grants to You a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable (except as stated in this section) patent license to make, have made, use, offer to sell, sell, import, and otherwise transfer the Work, where such license applies only to those patent claims licensable by such Contributor that are necessarily infringed by their Contribution(s) alone or by combination of their Contribution(s) with the Work to which such Contribution(s) was submitted. If You institute patent litigation against any entity (including a cross-claim or counterclaim in a lawsuit) alleging that the Work or a Contribution incorporated within the Work constitutes direct or contributory patent infringement, then any patent licenses granted to You under this License for that Work shall terminate as of the date such litigation is filed.

#### 4\. Redistribution

You may reproduce and distribute copies of the Work or Derivative Works thereof in any medium, with or without modifications, and in Source or Object form, provided that You meet the following conditions:

  * **(a)** You must give any other recipients of the Work or Derivative Works a copy of this License; and
  * **(b)** You must cause any modified files to carry prominent notices stating that You changed the files; and
  * **(c)** You must retain, in the Source form of any Derivative Works that You distribute, all copyright, patent, trademark, and attribution notices from the Source form of the Work, excluding those notices that do not pertain to any part of the Derivative Works; and
  * **(d)** If the Work includes a “NOTICE” text file as part of its distribution, then any Derivative Works that You distribute must include a readable copy of the attribution notices contained within such NOTICE file, excluding those notices that do not pertain to any part of the Derivative Works, in at least one of the following places: within a NOTICE text file distributed as part of the Derivative Works; within the Source form or documentation, if provided along with the Derivative Works; or, within a display generated by the Derivative Works, if and wherever such third-party notices normally appear. The contents of the NOTICE file are for informational purposes only and do not modify the License. You may add Your own attribution notices within Derivative Works that You distribute, alongside or as an addendum to the NOTICE text from the Work, provided that such additional attribution notices cannot be construed as modifying the License.



You may add Your own copyright statement to Your modifications and may provide additional or different license terms and conditions for use, reproduction, or distribution of Your modifications, or for any such Derivative Works as a whole, provided Your use, reproduction, and distribution of the Work otherwise complies with the conditions stated in this License.

#### 5\. Submission of Contributions

Unless You explicitly state otherwise, any Contribution intentionally submitted for inclusion in the Work by You to the Licensor shall be under the terms and conditions of this License, without any additional terms or conditions. Notwithstanding the above, nothing herein shall supersede or modify the terms of any separate license agreement you may have executed with Licensor regarding such Contributions.

#### 6\. Trademarks

This License does not grant permission to use the trade names, trademarks, service marks, or product names of the Licensor, except as required for reasonable and customary use in describing the origin of the Work and reproducing the content of the NOTICE file.

#### 7\. Disclaimer of Warranty

Unless required by applicable law or agreed to in writing, Licensor provides the Work (and each Contributor provides its Contributions) on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied, including, without limitation, any warranties or conditions of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A PARTICULAR PURPOSE. You are solely responsible for determining the appropriateness of using or redistributing the Work and assume any risks associated with Your exercise of permissions under this License.

#### 8\. Limitation of Liability

In no event and under no legal theory, whether in tort (including negligence), contract, or otherwise, unless required by applicable law (such as deliberate and grossly negligent acts) or agreed to in writing, shall any Contributor be liable to You for damages, including any direct, indirect, special, incidental, or consequential damages of any character arising as a result of this License or out of the use or inability to use the Work (including but not limited to damages for loss of goodwill, work stoppage, computer failure or malfunction, or any and all other commercial damages or losses), even if such Contributor has been advised of the possibility of such damages.

#### 9\. Accepting Warranty or Additional Liability

While redistributing the Work or Derivative Works thereof, You may choose to offer, and charge a fee for, acceptance of support, warranty, indemnity, or other liability obligations and/or rights consistent with this License. However, in accepting such obligations, You may act only on Your own behalf and on Your sole responsibility, not on behalf of any other Contributor, and only if You agree to indemnify, defend, and hold each Contributor harmless for any liability incurred by, or claims asserted against, such Contributor by reason of your accepting any such warranty or additional liability.

_END OF TERMS AND CONDITIONS_

### APPENDIX: How to apply the Apache License to your work

To apply the Apache License to your work, attach the following boilerplate notice, with the fields enclosed by brackets `[]` replaced with your own identifying information. (Don’t include the brackets!) The text should be enclosed in the appropriate comment syntax for the file format. We also recommend that a file or class name and description of purpose be included on the same “printed page” as the copyright notice for easier identification within third-party archives.
    
    
    Copyright [yyyy] [name of copyright owner]
    
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
      http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/CONTRIBUTING.html

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

# Contributing to CohortCharacteristics

Source: [`.github/CONTRIBUTING.md`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/.github/CONTRIBUTING.md)

## Filing issues

If you have found a bug, have a question, or want to suggest a new feature please open an issue. If reporting a bug, then a [reprex](https://reprex.tidyverse.org/) would be much appreciated. Before contributing either documentation or code, please make sure to open an issue beforehand to identify what needs to be done and who will do it.

### Documenting the package

Run the below to update and check package documentation:
    
    
    devtools::document() 
    devtools::run_examples()
    devtools::build_readme()
    devtools::build_vignettes()
    devtools::check_man()

Note that `devtools::check_man()` should not return any warnings. If your commit is limited to only package documentation, running the above should be sufficient (although running `devtools::check()` will always generally be a good idea before submitting a pull request.

### Run tests

Before starting to contribute any code, first make sure the package tests are all passing. If not raise an issue before going any further (although please first make sure you have all the packages from imports and suggests installed). As you then contribute code, make sure that all the current tests and any you add continue to pass. All package tests can be run together with:
    
    
    devtools::test()

Code to add new functionality should be accompanied by tests. Code coverage can be checked using:
    
    
    # note, you may first have to detach the package
    # detach("package:CohortCharacteristics", unload=TRUE)
    devtools::test_coverage()

### Adhere to code style

Please adhere to the code style when adding any new code. Do not though restyle any code unrelated to your pull request as this will make code review more difficult.
    
    
    lintr::lint_package(".",
                        linters = lintr::linters_with_defaults(
                          lintr::object_name_linter(styles = "camelCase")
                        )
    )

### Run check() before opening a pull request

Before opening any pull request please make sure to run:
    
    
    devtools::check() 

No warnings should be seen.

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/authors.html

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

# Authors and Citation

## Authors

  * **Marti Catala**. Author, maintainer. [](https://orcid.org/0000-0003-3308-9905)

  * **Yuchen Guo**. Author. [](https://orcid.org/0000-0002-0847-4855)

  * **Mike Du**. Contributor. [](https://orcid.org/0000-0002-9517-8834)

  * **Kim Lopez-Guell**. Author. [](https://orcid.org/0000-0002-8462-8668)

  * **Edward Burn**. Author. [](https://orcid.org/0000-0002-9286-1128)

  * **Nuria Mercade-Besora**. Author. [](https://orcid.org/0009-0006-7948-3747)

  * **Marta Alcalde**. Author. [](https://orcid.org/0009-0002-4405-1814)




## Citation

Source: [`DESCRIPTION`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/DESCRIPTION)

Catala M, Guo Y, Lopez-Guell K, Burn E, Mercade-Besora N, Alcalde M (2025). _CohortCharacteristics: Summarise and Visualise Characteristics of Patients in the OMOP CDM_. R package version 1.0.0, <https://darwin-eu.github.io/CohortCharacteristics/>. 
    
    
    @Manual{,
      title = {CohortCharacteristics: Summarise and Visualise Characteristics of Patients in the OMOP CDM},
      author = {Marti Catala and Yuchen Guo and Kim Lopez-Guell and Edward Burn and Nuria Mercade-Besora and Marta Alcalde},
      year = {2025},
      note = {R package version 1.0.0},
      url = {https://darwin-eu.github.io/CohortCharacteristics/},
    }

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/summariseCohortCodelist.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Summarise the cohort codelist attribute

Source: [`R/summariseCohortCodelist.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/summariseCohortCodelist.R)

`summariseCohortCodelist.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    summariseCohortCodelist(cohort, cohortId = NULL)

## Arguments

cohort
    

A cohort_table object.

cohortId
    

A cohort definition id to restrict by. If NULL, all cohorts will be included.

## Value

A summarised_result object with the exported cohort codelist information.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    #> Loading required package: DBI
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    dbName <- "GiBleed"
    [requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)(datasetName = dbName)
    #> ℹ `EUNOMIA_DATA_FOLDER` set to: /tmp/RtmpQYHaYw.
    #> 
    #> Download completed!
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(drv = [duckdb](https://r.duckdb.org/reference/duckdb.html)(dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)(datasetName = dbName)))
    #> Creating CDM database /tmp/RtmpQYHaYw/GiBleed_5.3.zip
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, cdmSchema = "main", writeSchema = "main")
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(cdm = cdm,
                                    conceptSet = [list](https://rdrr.io/r/base/list.html)(pharyngitis = 4112343L),
                                    name = "my_cohort")
    
    result <- summariseCohortCodelist(cdm$my_cohort)
    
    [glimpse](https://pillar.r-lib.org/reference/glimpse.html)(result)
    #> Rows: 1
    #> Columns: 13
    #> $ result_id        <int> 1
    #> $ cdm_name         <chr> "Synthea"
    #> $ group_name       <chr> "cohort_name"
    #> $ group_level      <chr> "pharyngitis"
    #> $ strata_name      <chr> "codelist_name &&& codelist_type"
    #> $ strata_level     <chr> "pharyngitis &&& index event"
    #> $ variable_name    <chr> "overall"
    #> $ variable_level   <chr> "overall"
    #> $ estimate_name    <chr> "concept_id"
    #> $ estimate_type    <chr> "integer"
    #> $ estimate_value   <chr> "4112343"
    #> $ additional_name  <chr> "concept_name"
    #> $ additional_level <chr> "Acute viral pharyngitis"
    
    [tidy](https://generics.r-lib.org/reference/tidy.html)(result)
    #> # A tibble: 1 × 8
    #>   cdm_name cohort_name codelist_name codelist_type variable_name variable_level
    #>   <chr>    <chr>       <chr>         <chr>         <chr>         <chr>         
    #> 1 Synthea  pharyngitis pharyngitis   index event   overall       overall       
    #> # ℹ 2 more variables: concept_name <chr>, concept_id <int>
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/tableCohortCodelist.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Create a visual table from `<summarised_result>` object from `summariseCohortCodelist()`

Source: [`R/summariseCohortCodelist.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/summariseCohortCodelist.R)

`tableCohortCodelist.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    tableCohortCodelist(result, type = "reactable")

## Arguments

result
    

A summarised_result object.

type
    

Type of table. Supported types: "gt", "flextable", "tibble", "datatable", "reactable".

## Value

A visual table with the results.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    dbName <- "GiBleed"
    [requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)(datasetName = dbName)
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(drv = [duckdb](https://r.duckdb.org/reference/duckdb.html)(dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)(datasetName = dbName)))
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, cdmSchema = "main", writeSchema = "main")
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(cdm = cdm,
                                    conceptSet = [list](https://rdrr.io/r/base/list.html)(pharyngitis = 4112343L),
                                    name = "my_cohort")
    
    result <- [summariseCohortCodelist](summariseCohortCodelist.html)(cdm$my_cohort)
    
    tableCohortCodelist(result)
    
    
    
    # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/tableLargeScaleCharacteristics.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Explore and compare the large scale characteristics of cohorts

Source: [`R/tableLargeScaleCharacteristics.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/tableLargeScaleCharacteristics.R)

`tableLargeScaleCharacteristics.Rd`

Explore and compare the large scale characteristics of cohorts

## Usage
    
    
    tableLargeScaleCharacteristics(
      result,
      compareBy = NULL,
      hide = [c](https://rdrr.io/r/base/c.html)("type"),
      smdReference = NULL,
      type = "reactable"
    )

## Arguments

result
    

A summarised_result object.

compareBy
    

A column to compare by it can be a choice between "cdm_name", "cohort_name", strata columns, "variable_level" (window) and "type". It can be left NULL for no comparison.

hide
    

Columns to hide.

smdReference
    

Level of reference for the Standardised Mean Differences (SMD), it has to be one of the values of `compareBy` column. If NULL no SMDs are displayed.

type
    

Type of table to generate, it can be either `DT` or `reactable`.

## Value

A visual table.

## Examples
    
    
    if (FALSE) { # \dontrun{
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, cdmSchema = "main", writeSchema = "main")
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      conceptSet = [list](https://rdrr.io/r/base/list.html)(viral_pharyngitis = 4112343),
      name = "my_cohort"
    )
    
    result <- [summariseLargeScaleCharacteristics](summariseLargeScaleCharacteristics.html)(
      cohort = cdm$my_cohort,
      window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-Inf, -1), [c](https://rdrr.io/r/base/c.html)(0, 0), [c](https://rdrr.io/r/base/c.html)(1, Inf)),
      episodeInWindow = "drug_exposure"
    )
    
    tableLargeScaleCharacteristics(result)
    
    tableLargeScaleCharacteristics(result,
                                   compareBy = "variable_level")
    
    tableLargeScaleCharacteristics(result,
                                   compareBy = "variable_level",
                                   smdReference = "-inf to -1")
    
    [cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm)
    } # }
    
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/availableTableColumns.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Available columns to use in `header`, `groupColumn` and `hide` arguments in table functions.

Source: [`R/table.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/table.R)

`availableTableColumns.Rd`

Available columns to use in `header`, `groupColumn` and `hide` arguments in table functions.

## Usage
    
    
    availableTableColumns(result)

## Arguments

result
    

A summarised_result object.

## Value

Character vector with the available columns.

## Examples
    
    
    {
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)()
    
    result <- [summariseCharacteristics](summariseCharacteristics.html)(cdm$cohort1)
    
    availableTableColumns(result)
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    }
    #> ℹ adding demographics columns
    #> ℹ summarising data
    #> ℹ summarising cohort cohort_1
    #> ℹ summarising cohort cohort_2
    #> ℹ summarising cohort cohort_3
    #> ✔ summariseCharacteristics finished!
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/availablePlotColumns.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Available columns to use in `facet` and `colour` arguments in plot functions.

Source: [`R/table.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/table.R)

`availablePlotColumns.Rd`

Available columns to use in `facet` and `colour` arguments in plot functions.

## Usage
    
    
    availablePlotColumns(result)

## Arguments

result
    

A summarised_result object.

## Value

Character vector with the available columns.

## Examples
    
    
    {
    cdm <- [mockCohortCharacteristics](mockCohortCharacteristics.html)()
    
    result <- [summariseCharacteristics](summariseCharacteristics.html)(cdm$cohort1)
    
    availablePlotColumns(result)
    
    [mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    }
    #> ℹ adding demographics columns
    #> ℹ summarising data
    #> ℹ summarising cohort cohort_1
    #> ℹ summarising cohort cohort_2
    #> ℹ summarising cohort cohort_3
    #> ✔ summariseCharacteristics finished!
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.

---

## Content from https://darwin-eu.github.io/CohortCharacteristics/reference/benchmarkCohortCharacteristics.html

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Benchmark the main functions of CohortCharacteristics package.

Source: [`R/benchmarkCohortCharacteristics.R`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/R/benchmarkCohortCharacteristics.R)

`benchmarkCohortCharacteristics.Rd`

Benchmark the main functions of CohortCharacteristics package.

## Usage
    
    
    benchmarkCohortCharacteristics(
      cohort,
      analysis = [c](https://rdrr.io/r/base/c.html)("count", "attrition", "characteristics", "overlap", "timing",
        "large scale characteristics")
    )

## Arguments

cohort
    

A cohort_table from a cdm_reference.

analysis
    

Set of analysis to perform, must be a subset of: "count", "attrition", "characteristics", "overlap", "timing" and "large scale characteristics".

## Value

A summarised_result object.

## Examples
    
    
    if (FALSE) { # \dontrun{
    CDMConnector::[requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)()
    con <- duckdb::dbConnect(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con = con, cdmSchema = "main", writeSchema = "main"
    )
    
    cdm <- CDMConnector::[generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      conceptSet = [list](https://rdrr.io/r/base/list.html)(sinusitis = 40481087, pharyngitis = 4112343),
      name = "my_cohort"
    )
    
    benchmarkCohortCharacteristics(cdm$my_cohort)
    
    } # }
    

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
