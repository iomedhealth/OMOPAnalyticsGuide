# Create cohorts based on patient demographics — demographicsCohort • CohortConstructor

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

# Create cohorts based on patient demographics

Source: [`R/demographicsCohort.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/demographicsCohort.R)

`demographicsCohort.Rd`

`demographicsCohort()` creates a cohort table based on patient characteristics. If and when an individual satisfies all the criteria they enter the cohort. When they stop satisfying any of the criteria their cohort entry ends.

## Usage
    
    
    demographicsCohort(
      cdm,
      name,
      ageRange = NULL,
      sex = NULL,
      minPriorObservation = NULL,
      .softValidation = TRUE
    )

## Arguments

cdm
    

A cdm reference.

name
    

Name of the new cohort table created in the cdm object.

ageRange
    

A list of vectors specifying minimum and maximum age.

sex
    

Can be "Both", "Male" or "Female".

minPriorObservation
    

A minimum number of continuous prior observation days in the database.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

A cohort table

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)()
    
    cohort <-  cdm |>
        demographicsCohort(name = "cohort3", ageRange = [c](https://rdrr.io/r/base/c.html)(18,40), sex = "Male")
    #> ℹ Building new trimmed cohort
    #> Adding demographics information
    #> Creating initial cohort
    #> Trim sex
    #> Trim age
    #> ✔ Cohort trimmed
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cohort)
    #> # A tibble: 3 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1             10              10         1 Initial qualify…
    #> 2                    1              2               2         2 Sex requirement…
    #> 3                    1              1               1         3 Age requirement…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    
    # Can also create multiple demographic cohorts, and add minimum prior history requirements.
    
    cohort <- cdm |>
        demographicsCohort(name = "cohort4",
        ageRange = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 19),[c](https://rdrr.io/r/base/c.html)(20, 64),[c](https://rdrr.io/r/base/c.html)(65, 150)),
        sex = [c](https://rdrr.io/r/base/c.html)("Male", "Female", "Both"),
        minPriorObservation = 365)
    #> ℹ Building new trimmed cohort
    #> Adding demographics information
    #> Creating initial cohort
    #> Trim sex
    #> Trim age
    #> Trim prior observation
    #> ✔ Cohort trimmed
    
    [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)(cohort)
    #> # A tibble: 36 × 7
    #>    cohort_definition_id number_records number_subjects reason_id reason         
    #>                   <int>          <int>           <int>     <int> <chr>          
    #>  1                    1             10              10         1 Initial qualif…
    #>  2                    1             10              10         2 Sex requiremen…
    #>  3                    1              4               4         3 Age requiremen…
    #>  4                    1              3               3         4 Prior observat…
    #>  5                    2             10              10         1 Initial qualif…
    #>  6                    2              8               8         2 Sex requiremen…
    #>  7                    2              2               2         3 Age requiremen…
    #>  8                    2              1               1         4 Prior observat…
    #>  9                    3             10              10         1 Initial qualif…
    #> 10                    3              2               2         2 Sex requiremen…
    #> # ℹ 26 more rows
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
