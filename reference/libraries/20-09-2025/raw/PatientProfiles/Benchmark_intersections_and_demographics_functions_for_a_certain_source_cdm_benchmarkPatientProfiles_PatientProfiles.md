# Benchmark intersections and demographics functions for a certain source (cdm). — benchmarkPatientProfiles • PatientProfiles

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

# Benchmark intersections and demographics functions for a certain source (cdm).

Source: [`R/benchmarkPatientProfiles.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/benchmarkPatientProfiles.R)

`benchmarkPatientProfiles.Rd`

Benchmark intersections and demographics functions for a certain source (cdm).

## Usage
    
    
    benchmarkPatientProfiles(cdm, n = 50000, iterations = 1)

## Arguments

cdm
    

A cdm_reference object.

n
    

Size of the synthetic cohorts used to benchmark.

iterations
    

Number of iterations to run the benchmark.

## Value

A summarise_result object with the summary statistics.

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
