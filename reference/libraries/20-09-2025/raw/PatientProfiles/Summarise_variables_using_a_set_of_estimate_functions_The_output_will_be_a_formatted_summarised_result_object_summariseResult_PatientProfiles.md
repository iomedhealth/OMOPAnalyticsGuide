# Summarise variables using a set of estimate functions. The output will be a formatted summarised_result object. — summariseResult • PatientProfiles

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

# Summarise variables using a set of estimate functions. The output will be a formatted summarised_result object.

Source: [`R/summariseResult.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/summariseResult.R)

`summariseResult.Rd`

Summarise variables using a set of estimate functions. The output will be a formatted summarised_result object.

## Usage
    
    
    summariseResult(
      table,
      group = [list](https://rdrr.io/r/base/list.html)(),
      includeOverallGroup = FALSE,
      strata = [list](https://rdrr.io/r/base/list.html)(),
      includeOverallStrata = TRUE,
      variables = NULL,
      estimates = [c](https://rdrr.io/r/base/c.html)("min", "q25", "median", "q75", "max", "count", "percentage"),
      counts = TRUE,
      weights = NULL
    )

## Arguments

table
    

Table with different records.

group
    

List of groups to be considered.

includeOverallGroup
    

TRUE or FALSE. If TRUE, results for an overall group will be reported when a list of groups has been specified.

strata
    

List of the stratifications within each group to be considered.

includeOverallStrata
    

TRUE or FALSE. If TRUE, results for an overall strata will be reported when a list of strata has been specified.

variables
    

Variables to summarise, it can be a list to point to different set of estimate names.

estimates
    

Estimates to obtain, it can be a list to point to different set of variables.

counts
    

Whether to compute number of records and number of subjects.

weights
    

Name of the column in the table that contains the weights to be used when measuring the estimates.

## Value

A summarised_result object with the summarised data of interest.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    cdm <- [mockPatientProfiles](mockPatientProfiles.html)()
    x <- cdm$cohort1 |>
      [addDemographics](addDemographics.html)() |>
      [collect](https://dplyr.tidyverse.org/reference/compute.html)()
    result <- summariseResult(x)
    #> ℹ The following estimates will be computed:
    #> • cohort_start_date: min, q25, median, q75, max
    #> • cohort_end_date: min, q25, median, q75, max
    #> • age: min, q25, median, q75, max
    #> • sex: count, percentage
    #> • prior_observation: min, q25, median, q75, max
    #> • future_observation: min, q25, median, q75, max
    #> ! Table is collected to memory as not all requested estimates are supported on
    #>   the database side
    #> → Start summary of data, at 2025-07-09 16:19:29.719281
    #> ✔ Summary finished, at 2025-07-09 16:19:29.836414
    [mockDisconnect](mockDisconnect.html)(cdm = cdm)
    # }
    
    

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
