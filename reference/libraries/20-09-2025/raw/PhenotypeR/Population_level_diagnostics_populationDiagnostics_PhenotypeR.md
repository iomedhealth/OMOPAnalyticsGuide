# Population-level diagnostics — populationDiagnostics • PhenotypeR

Skip to contents

[PhenotypeR](../index.html) 0.2.0

  * [Reference](../reference/index.html)
  * Articles
    * ###### Main functionality

    * [PhenotypeDiagnostics](../articles/PhenotypeDiagnostics.html)
    * [PhenotypeExpectations](../articles/PhenotypeExpectations.html)
    * [ShinyDiagnostics](../articles/ShinyDiagnostics.html)
    * * * *

    * ###### Individual functions

    * [DatabaseDiagnostics](../articles/DatabaseDiagnostics.html)
    * [CodelistDiagnostics](../articles/CodelistDiagnostics.html)
    * [CohortDiagnostics](../articles/CohortDiagnostics.html)
    * [PopulationDiagnostics](../articles/PopulationDiagnostics.html)
  * [PhenotypeR shiny App](https://dpa-pde-oxford.shinyapps.io/PhenotypeRShiny/)


  * [](https://github.com/OHDSI/PhenotypeR)



![](../logo.png)

# Population-level diagnostics

`populationDiagnostics.Rd`

phenotypeR diagnostics on the cohort of input with relation to a denomination population. Diagnostics include:

* Incidence * Prevalence

## Usage
    
    
    populationDiagnostics(
      cohort,
      populationSample = 1e+06,
      populationDateRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)(NA, NA))
    )

## Arguments

cohort
    

Cohort table in a cdm reference

populationSample
    

Number of people from the cdm to sample. If NULL no sampling will be performed. Sample will be within populationDateRange if specified.

populationDateRange
    

Two dates. The first indicating the earliest cohort start date and the second indicating the latest possible cohort end date. If NULL or the first date is set as missing, the earliest observation_start_date in the observation_period table will be used for the former. If NULL or the second date is set as missing, the latest observation_end_date in the observation_period table will be used for the latter.

## Value

A summarised result

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    #> 
    #> Attaching package: ‘dplyr’
    #> The following objects are masked from ‘package:stats’:
    #> 
    #>     filter, lag
    #> The following objects are masked from ‘package:base’:
    #> 
    #>     intersect, setdiff, setequal, union
    
    cdm <- [mockPhenotypeR](mockPhenotypeR.html)()
    
    dateStart <- cdm$my_cohort |>
      [summarise](https://dplyr.tidyverse.org/reference/summarise.html)(start = [min](https://rdrr.io/r/base/Extremes.html)(cohort_start_date, na.rm = TRUE)) |>
      [pull](https://dplyr.tidyverse.org/reference/pull.html)("start")
    dateEnd   <- cdm$my_cohort |>
      [summarise](https://dplyr.tidyverse.org/reference/summarise.html)(start = [max](https://rdrr.io/r/base/Extremes.html)(cohort_start_date, na.rm = TRUE)) |>
      [pull](https://dplyr.tidyverse.org/reference/pull.html)("start")
    
    result <- cdm$my_cohort |>
      populationDiagnostics(populationDateRange = [c](https://rdrr.io/r/base/c.html)(dateStart, dateEnd))
    #> • Creating denominator for incidence and prevalence
    #> • Sampling person table to 1e+06
    #> ℹ Creating denominator cohorts
    #> ✔ Cohorts created in 0 min and 5 sec
    #> • Estimating incidence
    #> ℹ Getting incidence for analysis 1 of 14
    #> ℹ Getting incidence for analysis 2 of 14
    #> ℹ Getting incidence for analysis 3 of 14
    #> ℹ Getting incidence for analysis 4 of 14
    #> ℹ Getting incidence for analysis 5 of 14
    #> ℹ Getting incidence for analysis 6 of 14
    #> ℹ Getting incidence for analysis 7 of 14
    #> ℹ Getting incidence for analysis 8 of 14
    #> ℹ Getting incidence for analysis 9 of 14
    #> ℹ Getting incidence for analysis 10 of 14
    #> ℹ Getting incidence for analysis 11 of 14
    #> ℹ Getting incidence for analysis 12 of 14
    #> ℹ Getting incidence for analysis 13 of 14
    #> ℹ Getting incidence for analysis 14 of 14
    #> ✔ Overall time taken: 0 mins and 13 secs
    #> • Estimating prevalence
    #> ℹ Getting prevalence for analysis 1 of 14
    #> ℹ Getting prevalence for analysis 2 of 14
    #> ℹ Getting prevalence for analysis 3 of 14
    #> ℹ Getting prevalence for analysis 4 of 14
    #> ℹ Getting prevalence for analysis 5 of 14
    #> ℹ Getting prevalence for analysis 6 of 14
    #> ℹ Getting prevalence for analysis 7 of 14
    #> ℹ Getting prevalence for analysis 8 of 14
    #> ℹ Getting prevalence for analysis 9 of 14
    #> ℹ Getting prevalence for analysis 10 of 14
    #> ℹ Getting prevalence for analysis 11 of 14
    #> ℹ Getting prevalence for analysis 12 of 14
    #> ℹ Getting prevalence for analysis 13 of 14
    #> ℹ Getting prevalence for analysis 14 of 14
    #> ✔ Time taken: 0 mins and 7 secs
    #> `populationDateStart`, `populationDateEnd`, and `populationSample` casted to
    #> character.
    
    CDMConnector::[cdmDisconnect](https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Nuria Mercade-Besora, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
