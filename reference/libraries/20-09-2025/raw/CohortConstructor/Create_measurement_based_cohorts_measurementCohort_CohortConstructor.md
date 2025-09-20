# Create measurement-based cohorts — measurementCohort • CohortConstructor

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

# Create measurement-based cohorts

Source: [`R/measurementCohort.R`](https://github.com/OHDSI/CohortConstructor/blob/main/R/measurementCohort.R)

`measurementCohort.Rd`

`measurementCohort()` creates cohorts based on patient records contained in the measurement table. This function extends the `[conceptCohort()](conceptCohort.html)` as it allows for measurement values associated with the records to be specified.

  * If `valueAsConcept` and `valueAsNumber` are NULL then no requirements on of the values associated with measurement records and using `measurementCohort()` will lead to the same result as using `[conceptCohort()](conceptCohort.html)` (so long as all concepts are from the measurement domain).

  * If one of `valueAsConcept` and `valueAsNumber` is not NULL then records will be required to have values that satisfy the requirement specified.

  * If both `valueAsConcept` and `valueAsNumber` are not NULL, records will be required to have values that fulfill _either_ of the requirements




## Usage
    
    
    measurementCohort(
      cdm,
      conceptSet,
      name,
      valueAsConcept = NULL,
      valueAsNumber = NULL,
      table = [c](https://rdrr.io/r/base/c.html)("measurement", "observation"),
      useRecordsBeforeObservation = FALSE
    )

## Arguments

cdm
    

A cdm reference.

conceptSet
    

A conceptSet, which can either be a codelist or a conceptSetExpression.

name
    

Name of the new cohort table created in the cdm object.

valueAsConcept
    

A vector of cohort IDs used to filter measurements. Only measurements with these values in the `value_as_concept_id` column of the measurement table will be included. If NULL all entries independent of their value as concept will be considered.

valueAsNumber
    

A list indicating the range of values and the unit they correspond to, as follows: list("unit_concept_id" = c(rangeValue1, rangeValue2)). If no name is supplied in the list, no requirement on unit concept id will be applied. If NULL, all entries independent of their value as number will be included.

table
    

Name of OMOP tables to search for records of the concepts provided. Options are "measurement" and/or "observation".

useRecordsBeforeObservation
    

If FALSE, only records in observation will be used. If FALSE, records before the start of observation period will be considered, with cohort start date set to the start of their next observation period.

## Value

A cohort table

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    cdm <- [mockCohortConstructor](mockCohortConstructor.html)(con = NULL)
    cdm$concept <- cdm$concept |>
      dplyr::[union_all](https://dplyr.tidyverse.org/reference/setops.html)(
        dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          concept_id = [c](https://rdrr.io/r/base/c.html)(4326744, 4298393, 45770407, 8876, 4124457),
          concept_name = [c](https://rdrr.io/r/base/c.html)("Blood pressure", "Systemic blood pressure",
                           "Baseline blood pressure", "millimeter mercury column",
                           "Normal range"),
          domain_id = "Measurement",
          vocabulary_id = [c](https://rdrr.io/r/base/c.html)("SNOMED", "SNOMED", "SNOMED", "UCUM", "SNOMED"),
          standard_concept = "S",
          concept_class_id = [c](https://rdrr.io/r/base/c.html)("Observable Entity", "Observable Entity",
                               "Observable Entity", "Unit", "Qualifier Value"),
          concept_code = NA,
          valid_start_date = NA,
          valid_end_date = NA,
          invalid_reason = NA
        )
      )
    cdm$measurement <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      measurement_id = 1:4,
      person_id = [c](https://rdrr.io/r/base/c.html)(1, 1, 2, 3),
      measurement_concept_id = [c](https://rdrr.io/r/base/c.html)(4326744, 4298393, 4298393, 45770407),
      measurement_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2000-07-01", "2000-12-11", "2002-09-08",
      "2015-02-19")),
      measurement_type_concept_id = NA,
      value_as_number = [c](https://rdrr.io/r/base/c.html)(100, 125, NA, NA),
      value_as_concept_id = [c](https://rdrr.io/r/base/c.html)(0, 0, 0, 4124457),
      unit_concept_id = [c](https://rdrr.io/r/base/c.html)(8876, 8876, 0, 0)
    )
    cdm <- CDMConnector::[copyCdmTo](https://darwin-eu.github.io/CDMConnector/reference/copyCdmTo.html)(
      con = DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)()),
      cdm = cdm, schema = "main")
    
    cdm$cohort <- measurementCohort(
      cdm = cdm,
      name = "cohort",
      conceptSet = [list](https://rdrr.io/r/base/list.html)("normal_blood_pressure" = [c](https://rdrr.io/r/base/c.html)(4326744, 4298393, 45770407)),
      valueAsConcept = [c](https://rdrr.io/r/base/c.html)(4124457),
      valueAsNumber = [list](https://rdrr.io/r/base/list.html)("8876" = [c](https://rdrr.io/r/base/c.html)(70, 120)),
      useRecordsBeforeObservation = FALSE
    )
    #> Warning: ! `codelist` casted to integers.
    #> Warning: ✖ Domain observation (3 concepts) excluded because table observation is not
    #>   present in the cdm.
    #> ℹ Subsetting table measurement using 3 concepts with domain: measurement.
    #> ℹ Combining tables.
    #> ℹ Applying measurement requirements.
    #> ℹ Getting records in observation.
    #> ℹ Creating cohort attributes.
    #> ✔ Cohort cohort created.
    
    cdm$cohort
    #> # Source:   table<cohort> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <dbl> <date>            <date>         
    #> 1                    1          1 2000-07-01        2000-07-01     
    
    # You can also create multiple measurement cohorts, and include records
    # outside the observation period.
    
    cdm$cohort2 <- measurementCohort(
      cdm = cdm,
      name = "cohort2",
      conceptSet = [list](https://rdrr.io/r/base/list.html)("normal_blood_pressure" = [c](https://rdrr.io/r/base/c.html)(4326744, 4298393, 45770407),
                      "high_blood_pressure" = [c](https://rdrr.io/r/base/c.html)(4326744, 4298393, 45770407)),
      valueAsConcept = [c](https://rdrr.io/r/base/c.html)(4124457),
      valueAsNumber = [list](https://rdrr.io/r/base/list.html)("8876" = [c](https://rdrr.io/r/base/c.html)(70, 120),
                           "8876" = [c](https://rdrr.io/r/base/c.html)(121, 200)),
      useRecordsBeforeObservation = FALSE
    )
    #> Warning: ! `codelist` casted to integers.
    #> Warning: ✖ Domain observation (6 concepts) excluded because table observation is not
    #>   present in the cdm.
    #> ℹ Subsetting table measurement using 6 concepts with domain: measurement.
    #> ℹ Combining tables.
    #> ℹ Applying measurement requirements.
    #> ℹ Getting records in observation.
    #> ℹ Creating cohort attributes.
    #> ✔ Cohort cohort2 created.
    
    cdm$cohort2
    #> # Source:   table<cohort2> [?? x 4]
    #> # Database: DuckDB 1.3.3-dev231 [unknown@Linux 6.11.0-1018-azure:R 4.5.1/:memory:]
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <dbl> <date>            <date>         
    #> 1                    2          1 2000-12-11        2000-12-11     
    #> 2                    1          1 2000-07-01        2000-07-01     
    #> 3                    1          1 2000-12-11        2000-12-11     
    #> 4                    2          1 2000-07-01        2000-07-01     
    
    # }
    

## On this page

Developed by Edward Burn, Marti Catala, Nuria Mercade-Besora, Marta Alcalde-Herraiz, Mike Du, Yuchen Guo, Xihang Chen, Kim Lopez-Guell, Elin Rowlands.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
