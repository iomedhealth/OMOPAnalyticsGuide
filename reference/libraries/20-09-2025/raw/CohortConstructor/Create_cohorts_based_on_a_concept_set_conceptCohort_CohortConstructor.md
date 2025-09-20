# Create cohorts based on a concept set — conceptCohort • CohortConstructor

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

# Create cohorts based on a concept set

Source: [`R/conceptCohort.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/conceptCohort.R)

`conceptCohort.Rd`

`conceptCohort()` creates a cohort table from patient records from the clinical tables in the OMOP CDM.

The following tables are currently supported for creating concept cohorts:

  * condition_occurrence

  * device_exposure

  * drug_exposure

  * measurement

  * observation

  * procedure_occurrence

  * visit_occurrence




Cohort duration is based on record start and end (e.g. condition_start_date and condition_end_date for records coming from the condition_occurrence tables). So that the resulting table satisfies the requirements of an OMOP CDM cohort table:

  * Cohort entries will not overlap. Overlapping records will be combined based on the overlap argument.

  * Cohort entries will not go out of observation. If a record starts outside of an observation period it will be silently ignored. If a record ends outside of an observation period it will be trimmed so as to end at the preceding observation period end date.




## Usage
    
    
    conceptCohort(
      cdm,
      conceptSet,
      name,
      exit = "event_end_date",
      overlap = "merge",
      table = NULL,
      useRecordsBeforeObservation = FALSE,
      useSourceFields = FALSE,
      subsetCohort = NULL,
      subsetCohortId = NULL
    )

## Arguments

cdm
    

A cdm reference.

conceptSet
    

A conceptSet, which can either be a codelist or a conceptSetExpression.

name
    

Name of the new cohort table created in the cdm object.

exit
    

How the cohort end date is defined. Can be either "event_end_date" or "event_start_date".

overlap
    

How to deal with overlapping records. In all cases cohort start will be set as the earliest start date. If "merge", cohort end will be the latest end date. If "extend", cohort end date will be set by adding together the total days from each of the overlapping records.

table
    

Name of OMOP tables to search for records of the concepts provided. If NULL, each concept will be search at the assigned domain in the concept table.

useRecordsBeforeObservation
    

If FALSE, only records in observation will be used. If TRUE, records before the start of observation period will be considered, with cohort start date set as the start date of the individuals next observation period (as cohort records must be within observation).

useSourceFields
    

If TRUE, the source concept_id fields will also be used when identifying relevant clinical records. If FALSE, only the standard concept_id fields will be used.

subsetCohort
    

A character refering to a cohort table containing individuals for whom cohorts will be generated. Only individuals in this table will appear in the generated cohort.

subsetCohortId
    

Optional. Specifies cohort IDs from the `subsetCohort` table to include. If none are provided, all cohorts from the `subsetCohort` are included.

## Value

A cohort table

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(conditionOccurrence = TRUE, drugExposure = TRUE)
    
    cdm$cohort <- conceptCohort(cdm = cdm, conceptSet = [list](https://rdrr.io/r/base/list.html)(a = 444074), name = "cohort")
    #> Warning: ! `codelist` casted to integers.
    #> ℹ Subsetting table condition_occurrence using 1 concept with domain: condition.
    #> ℹ Combining tables.
    #> ℹ Creating cohort attributes.
    #> ℹ Applying cohort requirements.
    #> ℹ Merging overlapping records.
    #> ✔ Cohort cohort created.
    
    cdm$cohort |> [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)()
    #> # A tibble: 6 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1             10               5         1 Initial qualify…
    #> 2                    1             10               5         2 Record in obser…
    #> 3                    1             10               5         3 Record start <=…
    #> 4                    1             10               5         4 Non-missing sex 
    #> 5                    1             10               5         5 Non-missing yea…
    #> 6                    1              5               5         6 Merge overlappi…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    
    # Create a cohort based on a concept set. The cohort exit is set to the event start date.
    # If two records overlap, the cohort end date is set as the sum of the duration of
    # all overlapping records. Only individuals included in the existing `cohort` will be considered.
    
    conceptSet <- [list](https://rdrr.io/r/base/list.html)("nitrogen" = [c](https://rdrr.io/r/base/c.html)(35604434, 35604439),
    "potassium" = [c](https://rdrr.io/r/base/c.html)(40741270, 42899580, 44081436))
    
    cdm$study_cohort <- conceptCohort(cdm,
                                 conceptSet = conceptSet,
                                 name = "study_cohort",
                                 exit = "event_start_date",
                                 overlap = "extend",
                                 subsetCohort = "cohort"
    )
    #> Warning: ! `codelist` casted to integers.
    #> ℹ Subsetting table drug_exposure using 5 concepts with domain: drug.
    #> ℹ Combining tables.
    #> ℹ Creating cohort attributes.
    #> ℹ Applying cohort requirements.
    #> ℹ Adding overlapping records.
    #> ℹ Re-appplying cohort requirements.
    #> ✔ Cohort study_cohort created.
    
     cdm$study_cohort |> [attrition](https://darwin-eu.github.io/omopgenerics/reference/attrition.html)()
    #> # A tibble: 20 × 7
    #>    cohort_definition_id number_records number_subjects reason_id reason         
    #>                   <int>          <int>           <int>     <int> <chr>          
    #>  1                    1             10               5         1 Initial qualif…
    #>  2                    1             10               5         2 Record in obse…
    #>  3                    1             10               5         3 Record start <…
    #>  4                    1             10               5         4 Non-missing sex
    #>  5                    1             10               5         5 Non-missing ye…
    #>  6                    1             10               5         6 Add overlappin…
    #>  7                    1             10               5         7 Record in obse…
    #>  8                    1             10               5         8 Record start <…
    #>  9                    1             10               5         9 Non-missing sex
    #> 10                    1             10               5        10 Non-missing ye…
    #> 11                    2             17               5         1 Initial qualif…
    #> 12                    2             17               5         2 Record in obse…
    #> 13                    2             17               5         3 Record start <…
    #> 14                    2             17               5         4 Non-missing sex
    #> 15                    2             17               5         5 Non-missing ye…
    #> 16                    2             17               5         6 Add overlappin…
    #> 17                    2             17               5         7 Record in obse…
    #> 18                    2             17               5         8 Record start <…
    #> 19                    2             17               5         9 Non-missing sex
    #> 20                    2             17               5        10 Non-missing ye…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
