# Run benchmark of CohortConstructor package — benchmarkCohortConstructor • CohortConstructor

Skip to contents

[CohortConstructor](../index.html) 0.5.0

  * [Reference](../reference/index.html)
  * Articles
    * [Introduction](../articles/a00_introduction.html)
    * [Building base cohorts](../articles/a01_building_base_cohorts.html)
    * [Applying cohort table requirements](../articles/a02_cohort_table_requirements.html)
    * [Applying demographic requirements to a cohort](../articles/a03_require_demographics.html)
    * [Applying requirements related to other cohorts, concept sets, or tables](../articles/a04_require_intersections.html)
    * [Updating cohort start and end dates](../articles/a05_update_cohort_start_end.html)
    * [Concatenating cohort records](../articles/a06_concatanate_cohorts.html)
    * [Filtering cohorts](../articles/a07_filter_cohorts.html)
    * [Splitting cohorts](../articles/a08_split_cohorts.html)
    * [Combining Cohorts](../articles/a09_combine_cohorts.html)
    * [Generating a matched cohort](../articles/a10_match_cohorts.html)
    * [CohortConstructor benchmarking results](../articles/a11_benchmark.html)
    * [Behind the scenes](../articles/a12_behind_the_scenes.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/OHDSI/CohortConstructor/)
  *     * Light
    * Dark
    * Auto



![](../logo.png)

# Run benchmark of CohortConstructor package

Source: [`R/benchmark.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/benchmark.R)

`benchmarkCohortConstructor.Rd`

Run benchmark of CohortConstructor cohort instantiation time compared to CIRCE from JSON. More information in the benchmarking vignette.

## Usage
    
    
    benchmarkCohortConstructor(
      cdm,
      runCIRCE = TRUE,
      runCohortConstructorDefinition = TRUE,
      runCohortConstructorDomain = TRUE,
      dropCohorts = TRUE
    )

## Arguments

cdm
    

A cdm reference.

runCIRCE
    

Whether to run cohorts from JSON definitions generated with Atlas.

runCohortConstructorDefinition
    

Whether to run the benchmark part where cohorts are created with CohortConstructor by definition (one by one, separately).

runCohortConstructorDomain
    

Whether to run the benchmark part where cohorts are created with CohortConstructor by domain (instantianting base cohort all together, as a set).

dropCohorts
    

Whether to drop cohorts created during benchmark.

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
