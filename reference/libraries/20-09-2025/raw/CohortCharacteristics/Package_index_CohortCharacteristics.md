# Package index • CohortCharacteristics

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
