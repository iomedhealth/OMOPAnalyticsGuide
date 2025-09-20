# Filter a cohort according to cohort_definition_id column, the result is not computed into a table. only a query is added. Used usually as internal functions of other packages. — filterCohortId • PatientProfiles

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

# Filter a cohort according to cohort_definition_id column, the result is not computed into a table. only a query is added. Used usually as internal functions of other packages.

Source: [`R/filterCohortId.R`](https://github.com/darwin-eu/PatientProfiles/blob/v1.4.2/R/filterCohortId.R)

`filterCohortId.Rd`

Filter a cohort according to cohort_definition_id column, the result is not computed into a table. only a query is added. Used usually as internal functions of other packages.

## Usage
    
    
    filterCohortId(cohort, cohortId = NULL)

## Arguments

cohort
    

A `cohort_table` object.

cohortId
    

A vector with cohort ids.

## Value

A `cohort_table` object.

## On this page

Developed by Martí Català, Yuchen Guo, Mike Du, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
