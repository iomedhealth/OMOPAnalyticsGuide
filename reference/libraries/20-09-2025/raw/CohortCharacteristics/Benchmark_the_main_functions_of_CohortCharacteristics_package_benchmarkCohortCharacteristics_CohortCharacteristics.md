# Benchmark the main functions of CohortCharacteristics package. — benchmarkCohortCharacteristics • CohortCharacteristics

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
