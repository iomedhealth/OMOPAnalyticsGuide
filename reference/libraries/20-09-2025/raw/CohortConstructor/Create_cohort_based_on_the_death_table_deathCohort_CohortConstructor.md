# Create cohort based on the death table — deathCohort • CohortConstructor

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

# Create cohort based on the death table

Source: [`R/deathCohort.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/deathCohort.R)

`deathCohort.Rd`

Create cohort based on the death table

## Usage
    
    
    deathCohort(cdm, name, subsetCohort = NULL, subsetCohortId = NULL)

## Arguments

cdm
    

A cdm reference.

name
    

Name of the new cohort table created in the cdm object.

subsetCohort
    

A character refering to a cohort table containing individuals for whom cohorts will be generated. Only individuals in this table will appear in the generated cohort.

subsetCohortId
    

Optional. Specifies cohort IDs from the `subsetCohort` table to include. If none are provided, all cohorts from the `subsetCohort` are included.

## Value

A cohort table with a death cohort in cdm

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(death = TRUE)
    
    # Generate a death cohort
    death_cohort <- deathCohort(cdm, name = "death_cohort")
    #> ℹ Applying cohort requirements.
    #> ✔ Cohort death_cohort created.
    death_cohort
    #> # Source:   table<death_cohort> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>    cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                   <int>      <int> <date>            <date>         
    #>  1                    1          7 2010-10-22        2010-10-22     
    #>  2                    1         10 2018-11-23        2018-11-23     
    #>  3                    1          3 2008-06-03        2008-06-03     
    #>  4                    1          6 2015-01-28        2015-01-28     
    #>  5                    1          5 2016-12-16        2016-12-16     
    #>  6                    1          9 2009-04-30        2009-04-30     
    #>  7                    1          1 2018-02-06        2018-02-06     
    #>  8                    1          4 2018-02-04        2018-02-04     
    #>  9                    1          8 2013-07-25        2013-07-25     
    #> 10                    1          2 2012-06-26        2012-06-26     
    
    # Create a death cohort for females aged over 50 years old.
    
    # Create a demographics cohort with age range and sex filters
    cdm$my_cohort <- [demographicsCohort](demographicsCohort.html)(cdm, "my_cohort", ageRange = [c](https://rdrr.io/r/base/c.html)(50,100), sex = "Female")
    #> ℹ Building new trimmed cohort
    #> Adding demographics information
    #> Creating initial cohort
    #> Trim sex
    #> Trim age
    #> ✔ Cohort trimmed
    
    # Generate a death cohort, restricted to individuals in 'my_cohort'
    death_cohort <- deathCohort(cdm, name = "death_cohort", subsetCohort = "my_cohort")
    #> ℹ Applying cohort requirements.
    #> ✔ Cohort death_cohort created.
    death_cohort |> [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)()
    #> # A tibble: 7 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1             10              10         1 Initial qualify…
    #> 2                    1             10              10         2 Record in obser…
    #> 3                    1             10              10         3 Not missing rec…
    #> 4                    1             10              10         4 Non-missing sex 
    #> 5                    1             10              10         5 Non-missing yea…
    #> 6                    1              4               4         6 In subset cohort
    #> 7                    1              4               4         7 First death rec…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
