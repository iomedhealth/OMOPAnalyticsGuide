# Content from https://darwin-eu.github.io/omopgenerics/


---

## Content from https://darwin-eu.github.io/omopgenerics/

Skip to contents

[omopgenerics](index.html) 1.3.1

  * [Reference](reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](articles/cdm_reference.html)
    * [Concept sets](articles/codelists.html)
    * [Cohort tables](articles/cohorts.html)
    * [A summarised result](articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](articles/suppression.html)
    * [Logging with omopgenerics](articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](articles/reexport.html)
    * [Expanding omopgenerics](articles/expanding_omopgenerics.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# omopgenerics

## Package overview

The omopgenerics package provides definitions of core classes and methods used by analytic pipelines that query the OMOP common data model.
    
    
    #> Warning in citation("omopgenerics"): no date field in DESCRIPTION file of
    #> package 'omopgenerics'
    #> Warning in citation("omopgenerics"): could not determine year for
    #> 'omopgenerics' from package DESCRIPTION file
    #> 
    #> To cite package 'omopgenerics' in publications use:
    #> 
    #>   Català M, Burn E (????). _omopgenerics: Methods and Classes for the
    #>   OMOP Common Data Model_. R package version 0.3.1.900,
    #>   <https://darwin-eu.github.io/omopgenerics/>.
    #> 
    #> A BibTeX entry for LaTeX users is
    #> 
    #>   @Manual{,
    #>     title = {omopgenerics: Methods and Classes for the OMOP Common Data Model},
    #>     author = {Martí Català and Edward Burn},
    #>     note = {R package version 0.3.1.900},
    #>     url = {https://darwin-eu.github.io/omopgenerics/},
    #>   }

If you find the package useful in supporting your research study, please consider citing this package.

## Installation

You can install the development version of OMOPGenerics from [GitHub](https://github.com/) with:
    
    
    [install.packages](https://rdrr.io/r/utils/install.packages.html)("pak")
    pak::[pkg_install](https://pak.r-lib.org/reference/pkg_install.html)("darwin-eu/omopgenerics")

And load it using the library command:
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))

## Core classes and methods

### CDM Reference

A cdm reference is a single R object that represents OMOP CDM data. The tables in the cdm reference may be in a database, but a cdm reference may also contain OMOP CDM tables that are in dataframes/tibbles or in arrow. In the latter case the cdm reference would typically be a subset of an original cdm reference that has been derived as part of a particular analysis.

omopgenerics contains the class definition of a cdm reference and a dataframe implementation. For creating a cdm reference using a database, see the CDMConnector package (<https://darwin-eu.github.io/CDMConnector/>).

A cdm object can contain four type of tables:

  * Standard tables:


    
    
    [omopTables](reference/omopTables.html)()
    #>  [1] "person"                "observation_period"    "visit_occurrence"     
    #>  [4] "visit_detail"          "condition_occurrence"  "drug_exposure"        
    #>  [7] "procedure_occurrence"  "device_exposure"       "measurement"          
    #> [10] "observation"           "death"                 "note"                 
    #> [13] "note_nlp"              "specimen"              "fact_relationship"    
    #> [16] "location"              "care_site"             "provider"             
    #> [19] "payer_plan_period"     "cost"                  "drug_era"             
    #> [22] "dose_era"              "condition_era"         "metadata"             
    #> [25] "cdm_source"            "concept"               "vocabulary"           
    #> [28] "domain"                "concept_class"         "concept_relationship" 
    #> [31] "relationship"          "concept_synonym"       "concept_ancestor"     
    #> [34] "source_to_concept_map" "drug_strength"         "cohort_definition"    
    #> [37] "attribute_definition"  "concept_recommended"

Each one of the tables has a required columns. For example, for the `person` table this are the required columns:
    
    
    [omopColumns](reference/omopColumns.html)(table = "person")
    #>  [1] "person_id"                   "gender_concept_id"          
    #>  [3] "year_of_birth"               "month_of_birth"             
    #>  [5] "day_of_birth"                "birth_datetime"             
    #>  [7] "race_concept_id"             "ethnicity_concept_id"       
    #>  [9] "location_id"                 "provider_id"                
    #> [11] "care_site_id"                "person_source_value"        
    #> [13] "gender_source_value"         "gender_source_concept_id"   
    #> [15] "race_source_value"           "race_source_concept_id"     
    #> [17] "ethnicity_source_value"      "ethnicity_source_concept_id"

  * Cohort tables We can see the cohort-related tables and their required columns.


    
    
    [cohortTables](reference/cohortTables.html)()
    #> [1] "cohort"           "cohort_set"       "cohort_attrition" "cohort_codelist"
    [cohortColumns](reference/cohortColumns.html)(table = "cohort")
    #> [1] "cohort_definition_id" "subject_id"           "cohort_start_date"   
    #> [4] "cohort_end_date"

In addition, cohorts are defined in terms of a `generatedCohortSet` class. For more details on this class definition see the corresponding vignette.

  * Achilles tables The Achilles R package generates descriptive statistics about the data contained in the OMOP CDM. Again, we can see the tables created and their required columns.


    
    
    [achillesTables](reference/achillesTables.html)()
    #> [1] "achilles_analysis"     "achilles_results"      "achilles_results_dist"
    [achillesColumns](reference/achillesColumns.html)(table = "achilles_results")
    #> [1] "analysis_id" "stratum_1"   "stratum_2"   "stratum_3"   "stratum_4"  
    #> [6] "stratum_5"   "count_value"

  * Other tables, these other tables can have any format.



Any table to be part of a cdm object has to fulfill 4 conditions:

  * All must share a common source.

  * The name of the tables must be lowercase.

  * The name of the column names of each table must be lowercase.

  * `person` and `observation_period` must be present.




### Concept set

A concept set can be represented as either a codelist or a concept set expression. A codelist is a named list, with each item of the list containing specific concept IDs.
    
    
    condition_codes <- [list](https://rdrr.io/r/base/list.html)("diabetes" = [c](https://rdrr.io/r/base/c.html)(201820, 4087682, 3655269),
                            "asthma" = 317009)
    condition_codes <- [newCodelist](reference/newCodelist.html)(condition_codes)
    #> Warning: ! `codelist` contains numeric values, they are casted to integers.
    
    condition_codes
    #> 
    #> ── 2 codelists ─────────────────────────────────────────────────────────────────
    #> 
    #> - asthma (1 codes)
    #> - diabetes (3 codes)

Meanwhile, a concept set expression provides a high-level definition of concepts that, when applied to a specific OMOP CDM vocabulary version (by making use of the concept hierarchies and relationships), will result in a codelist.
    
    
    condition_cs <- [list](https://rdrr.io/r/base/list.html)(
      "diabetes" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "concept_id" = [c](https://rdrr.io/r/base/c.html)(201820, 4087682),
        "excluded" = [c](https://rdrr.io/r/base/c.html)(FALSE, FALSE),
        "descendants" = [c](https://rdrr.io/r/base/c.html)(TRUE, FALSE),
        "mapped" = [c](https://rdrr.io/r/base/c.html)(FALSE, FALSE)
      ),
      "asthma" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "concept_id" = 317009,
        "excluded" = FALSE,
        "descendants" = FALSE,
        "mapped" = FALSE
      )
    )
    condition_cs <- [newConceptSetExpression](reference/newConceptSetExpression.html)(condition_cs)
    
    condition_cs
    #> 
    #> ── 2 conceptSetExpressions ─────────────────────────────────────────────────────
    #> 
    #> - asthma (1 concept criteria)
    #> - diabetes (2 concept criteria)

### A cohort table

A cohort is a set of persons who satisfy one or more inclusion criteria for a duration of time and, when defined, this table in a cdm reference has a cohort table class. Cohort tables are then associated with attributes such as settings and attrition.
    
    
    person <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = 1, person_id = 1,
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
      period_type_concept_id = 0
    )
    diabetes <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1, subject_id = 1,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-01"),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-10")
    )
    
    cdm <- [cdmFromTables](reference/cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = person,
        "observation_period" = observation_period,
        "diabetes" = diabetes
      ),
      cdmName = "example_cdm"
    )
    #> Warning: ! 5 column in person do not match expected column type:
    #> • `person_id` is numeric but expected integer
    #> • `gender_concept_id` is numeric but expected integer
    #> • `year_of_birth` is numeric but expected integer
    #> • `race_concept_id` is numeric but expected integer
    #> • `ethnicity_concept_id` is numeric but expected integer
    #> Warning: ! 3 column in observation_period do not match expected column type:
    #> • `observation_period_id` is numeric but expected integer
    #> • `person_id` is numeric but expected integer
    #> • `period_type_concept_id` is numeric but expected integer
    cdm$diabetes <- [newCohortTable](reference/newCohortTable.html)(cdm$diabetes)
    #> Warning: ! 2 column in diabetes do not match expected column type:
    #> • `cohort_definition_id` is numeric but expected integer
    #> • `subject_id` is numeric but expected integer
    
    cdm$diabetes
    #> # A tibble: 1 × 4
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <dbl>      <dbl> <date>            <date>         
    #> 1                    1          1 2020-01-01        2020-01-10
    [settings](reference/settings.html)(cdm$diabetes)
    #> # A tibble: 1 × 2
    #>   cohort_definition_id cohort_name
    #>                  <int> <chr>      
    #> 1                    1 cohort_1
    [attrition](reference/attrition.html)(cdm$diabetes)
    #> # A tibble: 1 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1              1               1         1 Initial qualify…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    [cohortCount](reference/cohortCount.html)(cdm$diabetes)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1              1               1

### Summarised result

A summarised result provides a standard format for the results of an analysis performed against data mapped to the OMOP CDM.

For example this format is used when we get a summary of the cdm as a whole
    
    
    [summary](https://rdrr.io/r/base/summary.html)(cdm) |> 
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 13
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    #> $ cdm_name         <chr> "example_cdm", "example_cdm", "example_cdm", "example…
    #> $ group_name       <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ group_level      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "snapshot_date", "person_count", "observation_period_…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    #> $ estimate_name    <chr> "value", "count", "count", "source_name", "version", …
    #> $ estimate_type    <chr> "date", "integer", "integer", "character", "character…
    #> $ estimate_value   <chr> "2024-11-01", "1", "1", "", NA, "5.3", "", "", "", ""…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…

and also when we summarise a cohort
    
    
    [summary](https://rdrr.io/r/base/summary.html)(cdm$diabetes) |> 
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 6
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 2, 2, 2, 2
    #> $ cdm_name         <chr> "example_cdm", "example_cdm", "example_cdm", "example…
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "cohort_1", "cohort_1", "cohort_1", "cohort_1", "coho…
    #> $ strata_name      <chr> "overall", "overall", "reason", "reason", "reason", "…
    #> $ strata_level     <chr> "overall", "overall", "Initial qualifying events", "I…
    #> $ variable_name    <chr> "number_records", "number_subjects", "number_records"…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA
    #> $ estimate_name    <chr> "count", "count", "count", "count", "count", "count"
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "1", "1", "1", "1", "0", "0"
    #> $ additional_name  <chr> "overall", "overall", "reason_id", "reason_id", "reas…
    #> $ additional_level <chr> "overall", "overall", "1", "1", "1", "1"

## Links

  * [View on CRAN](https://cloud.r-project.org/package=omopgenerics)
  * [Browse source code](https://github.com/darwin-eu/omopgenerics/)
  * [Report a bug](https://github.com/darwin-eu/omopgenerics/issues)



## License

  * [Full license](LICENSE.html)
  * Apache License (>= 2)



## Citation

  * [Citing omopgenerics](authors.html#citation)



## Developers

  * Martí Català   
Author, maintainer  [](https://orcid.org/0000-0003-3308-9905)
  * Edward Burn   
Author  [](https://orcid.org/0000-0002-9286-1128)
  * [More about authors...](authors.html)



## Dev status

  * [![Lifecycle:Experimental](https://img.shields.io/badge/Lifecycle-Experimental-339999)](https://lifecycle.r-lib.org/articles/stages.html)
  * [![R-CMD-check](https://github.com/darwin-eu/omopgenerics/workflows/R-CMD-check/badge.svg)](https://github.com/darwin-eu/omopgenerics/actions)
  * [![CRANstatus](https://www.r-pkg.org/badges/version/omopgenerics)](https://CRAN.R-project.org/package=omopgenerics)
  * [![Codecov test coverage](https://codecov.io/gh/darwin-eu/omopgenerics/branch/main/graph/badge.svg)](https://app.codecov.io/gh/darwin-eu/omopgenerics?branch=main)



Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/index.html

Skip to contents

[omopgenerics](index.html) 1.3.1

  * [Reference](reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](articles/cdm_reference.html)
    * [Concept sets](articles/codelists.html)
    * [Cohort tables](articles/cohorts.html)
    * [A summarised result](articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](articles/suppression.html)
    * [Logging with omopgenerics](articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](articles/reexport.html)
    * [Expanding omopgenerics](articles/expanding_omopgenerics.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# omopgenerics

## Package overview

The omopgenerics package provides definitions of core classes and methods used by analytic pipelines that query the OMOP common data model.
    
    
    #> Warning in citation("omopgenerics"): no date field in DESCRIPTION file of
    #> package 'omopgenerics'
    #> Warning in citation("omopgenerics"): could not determine year for
    #> 'omopgenerics' from package DESCRIPTION file
    #> 
    #> To cite package 'omopgenerics' in publications use:
    #> 
    #>   Català M, Burn E (????). _omopgenerics: Methods and Classes for the
    #>   OMOP Common Data Model_. R package version 0.3.1.900,
    #>   <https://darwin-eu.github.io/omopgenerics/>.
    #> 
    #> A BibTeX entry for LaTeX users is
    #> 
    #>   @Manual{,
    #>     title = {omopgenerics: Methods and Classes for the OMOP Common Data Model},
    #>     author = {Martí Català and Edward Burn},
    #>     note = {R package version 0.3.1.900},
    #>     url = {https://darwin-eu.github.io/omopgenerics/},
    #>   }

If you find the package useful in supporting your research study, please consider citing this package.

## Installation

You can install the development version of OMOPGenerics from [GitHub](https://github.com/) with:
    
    
    [install.packages](https://rdrr.io/r/utils/install.packages.html)("pak")
    pak::[pkg_install](https://pak.r-lib.org/reference/pkg_install.html)("darwin-eu/omopgenerics")

And load it using the library command:
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))

## Core classes and methods

### CDM Reference

A cdm reference is a single R object that represents OMOP CDM data. The tables in the cdm reference may be in a database, but a cdm reference may also contain OMOP CDM tables that are in dataframes/tibbles or in arrow. In the latter case the cdm reference would typically be a subset of an original cdm reference that has been derived as part of a particular analysis.

omopgenerics contains the class definition of a cdm reference and a dataframe implementation. For creating a cdm reference using a database, see the CDMConnector package (<https://darwin-eu.github.io/CDMConnector/>).

A cdm object can contain four type of tables:

  * Standard tables:


    
    
    [omopTables](reference/omopTables.html)()
    #>  [1] "person"                "observation_period"    "visit_occurrence"     
    #>  [4] "visit_detail"          "condition_occurrence"  "drug_exposure"        
    #>  [7] "procedure_occurrence"  "device_exposure"       "measurement"          
    #> [10] "observation"           "death"                 "note"                 
    #> [13] "note_nlp"              "specimen"              "fact_relationship"    
    #> [16] "location"              "care_site"             "provider"             
    #> [19] "payer_plan_period"     "cost"                  "drug_era"             
    #> [22] "dose_era"              "condition_era"         "metadata"             
    #> [25] "cdm_source"            "concept"               "vocabulary"           
    #> [28] "domain"                "concept_class"         "concept_relationship" 
    #> [31] "relationship"          "concept_synonym"       "concept_ancestor"     
    #> [34] "source_to_concept_map" "drug_strength"         "cohort_definition"    
    #> [37] "attribute_definition"  "concept_recommended"

Each one of the tables has a required columns. For example, for the `person` table this are the required columns:
    
    
    [omopColumns](reference/omopColumns.html)(table = "person")
    #>  [1] "person_id"                   "gender_concept_id"          
    #>  [3] "year_of_birth"               "month_of_birth"             
    #>  [5] "day_of_birth"                "birth_datetime"             
    #>  [7] "race_concept_id"             "ethnicity_concept_id"       
    #>  [9] "location_id"                 "provider_id"                
    #> [11] "care_site_id"                "person_source_value"        
    #> [13] "gender_source_value"         "gender_source_concept_id"   
    #> [15] "race_source_value"           "race_source_concept_id"     
    #> [17] "ethnicity_source_value"      "ethnicity_source_concept_id"

  * Cohort tables We can see the cohort-related tables and their required columns.


    
    
    [cohortTables](reference/cohortTables.html)()
    #> [1] "cohort"           "cohort_set"       "cohort_attrition" "cohort_codelist"
    [cohortColumns](reference/cohortColumns.html)(table = "cohort")
    #> [1] "cohort_definition_id" "subject_id"           "cohort_start_date"   
    #> [4] "cohort_end_date"

In addition, cohorts are defined in terms of a `generatedCohortSet` class. For more details on this class definition see the corresponding vignette.

  * Achilles tables The Achilles R package generates descriptive statistics about the data contained in the OMOP CDM. Again, we can see the tables created and their required columns.


    
    
    [achillesTables](reference/achillesTables.html)()
    #> [1] "achilles_analysis"     "achilles_results"      "achilles_results_dist"
    [achillesColumns](reference/achillesColumns.html)(table = "achilles_results")
    #> [1] "analysis_id" "stratum_1"   "stratum_2"   "stratum_3"   "stratum_4"  
    #> [6] "stratum_5"   "count_value"

  * Other tables, these other tables can have any format.



Any table to be part of a cdm object has to fulfill 4 conditions:

  * All must share a common source.

  * The name of the tables must be lowercase.

  * The name of the column names of each table must be lowercase.

  * `person` and `observation_period` must be present.




### Concept set

A concept set can be represented as either a codelist or a concept set expression. A codelist is a named list, with each item of the list containing specific concept IDs.
    
    
    condition_codes <- [list](https://rdrr.io/r/base/list.html)("diabetes" = [c](https://rdrr.io/r/base/c.html)(201820, 4087682, 3655269),
                            "asthma" = 317009)
    condition_codes <- [newCodelist](reference/newCodelist.html)(condition_codes)
    #> Warning: ! `codelist` contains numeric values, they are casted to integers.
    
    condition_codes
    #> 
    #> ── 2 codelists ─────────────────────────────────────────────────────────────────
    #> 
    #> - asthma (1 codes)
    #> - diabetes (3 codes)

Meanwhile, a concept set expression provides a high-level definition of concepts that, when applied to a specific OMOP CDM vocabulary version (by making use of the concept hierarchies and relationships), will result in a codelist.
    
    
    condition_cs <- [list](https://rdrr.io/r/base/list.html)(
      "diabetes" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "concept_id" = [c](https://rdrr.io/r/base/c.html)(201820, 4087682),
        "excluded" = [c](https://rdrr.io/r/base/c.html)(FALSE, FALSE),
        "descendants" = [c](https://rdrr.io/r/base/c.html)(TRUE, FALSE),
        "mapped" = [c](https://rdrr.io/r/base/c.html)(FALSE, FALSE)
      ),
      "asthma" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "concept_id" = 317009,
        "excluded" = FALSE,
        "descendants" = FALSE,
        "mapped" = FALSE
      )
    )
    condition_cs <- [newConceptSetExpression](reference/newConceptSetExpression.html)(condition_cs)
    
    condition_cs
    #> 
    #> ── 2 conceptSetExpressions ─────────────────────────────────────────────────────
    #> 
    #> - asthma (1 concept criteria)
    #> - diabetes (2 concept criteria)

### A cohort table

A cohort is a set of persons who satisfy one or more inclusion criteria for a duration of time and, when defined, this table in a cdm reference has a cohort table class. Cohort tables are then associated with attributes such as settings and attrition.
    
    
    person <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = 1, person_id = 1,
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
      period_type_concept_id = 0
    )
    diabetes <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1, subject_id = 1,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-01"),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-10")
    )
    
    cdm <- [cdmFromTables](reference/cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = person,
        "observation_period" = observation_period,
        "diabetes" = diabetes
      ),
      cdmName = "example_cdm"
    )
    #> Warning: ! 5 column in person do not match expected column type:
    #> • `person_id` is numeric but expected integer
    #> • `gender_concept_id` is numeric but expected integer
    #> • `year_of_birth` is numeric but expected integer
    #> • `race_concept_id` is numeric but expected integer
    #> • `ethnicity_concept_id` is numeric but expected integer
    #> Warning: ! 3 column in observation_period do not match expected column type:
    #> • `observation_period_id` is numeric but expected integer
    #> • `person_id` is numeric but expected integer
    #> • `period_type_concept_id` is numeric but expected integer
    cdm$diabetes <- [newCohortTable](reference/newCohortTable.html)(cdm$diabetes)
    #> Warning: ! 2 column in diabetes do not match expected column type:
    #> • `cohort_definition_id` is numeric but expected integer
    #> • `subject_id` is numeric but expected integer
    
    cdm$diabetes
    #> # A tibble: 1 × 4
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <dbl>      <dbl> <date>            <date>         
    #> 1                    1          1 2020-01-01        2020-01-10
    [settings](reference/settings.html)(cdm$diabetes)
    #> # A tibble: 1 × 2
    #>   cohort_definition_id cohort_name
    #>                  <int> <chr>      
    #> 1                    1 cohort_1
    [attrition](reference/attrition.html)(cdm$diabetes)
    #> # A tibble: 1 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1              1               1         1 Initial qualify…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    [cohortCount](reference/cohortCount.html)(cdm$diabetes)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1              1               1

### Summarised result

A summarised result provides a standard format for the results of an analysis performed against data mapped to the OMOP CDM.

For example this format is used when we get a summary of the cdm as a whole
    
    
    [summary](https://rdrr.io/r/base/summary.html)(cdm) |> 
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 13
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    #> $ cdm_name         <chr> "example_cdm", "example_cdm", "example_cdm", "example…
    #> $ group_name       <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ group_level      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "snapshot_date", "person_count", "observation_period_…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    #> $ estimate_name    <chr> "value", "count", "count", "source_name", "version", …
    #> $ estimate_type    <chr> "date", "integer", "integer", "character", "character…
    #> $ estimate_value   <chr> "2024-11-01", "1", "1", "", NA, "5.3", "", "", "", ""…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…

and also when we summarise a cohort
    
    
    [summary](https://rdrr.io/r/base/summary.html)(cdm$diabetes) |> 
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 6
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 2, 2, 2, 2
    #> $ cdm_name         <chr> "example_cdm", "example_cdm", "example_cdm", "example…
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "cohort_1", "cohort_1", "cohort_1", "cohort_1", "coho…
    #> $ strata_name      <chr> "overall", "overall", "reason", "reason", "reason", "…
    #> $ strata_level     <chr> "overall", "overall", "Initial qualifying events", "I…
    #> $ variable_name    <chr> "number_records", "number_subjects", "number_records"…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA
    #> $ estimate_name    <chr> "count", "count", "count", "count", "count", "count"
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "1", "1", "1", "1", "0", "0"
    #> $ additional_name  <chr> "overall", "overall", "reason_id", "reason_id", "reas…
    #> $ additional_level <chr> "overall", "overall", "1", "1", "1", "1"

## Links

  * [View on CRAN](https://cloud.r-project.org/package=omopgenerics)
  * [Browse source code](https://github.com/darwin-eu/omopgenerics/)
  * [Report a bug](https://github.com/darwin-eu/omopgenerics/issues)



## License

  * [Full license](LICENSE.html)
  * Apache License (>= 2)



## Citation

  * [Citing omopgenerics](authors.html#citation)



## Developers

  * Martí Català   
Author, maintainer  [](https://orcid.org/0000-0003-3308-9905)
  * Edward Burn   
Author  [](https://orcid.org/0000-0002-9286-1128)
  * [More about authors...](authors.html)



## Dev status

  * [![Lifecycle:Experimental](https://img.shields.io/badge/Lifecycle-Experimental-339999)](https://lifecycle.r-lib.org/articles/stages.html)
  * [![R-CMD-check](https://github.com/darwin-eu/omopgenerics/workflows/R-CMD-check/badge.svg)](https://github.com/darwin-eu/omopgenerics/actions)
  * [![CRANstatus](https://www.r-pkg.org/badges/version/omopgenerics)](https://CRAN.R-project.org/package=omopgenerics)
  * [![Codecov test coverage](https://codecov.io/gh/darwin-eu/omopgenerics/branch/main/graph/badge.svg)](https://app.codecov.io/gh/darwin-eu/omopgenerics?branch=main)



Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/index.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Package index

### Methods

General methods deffined by omopgenerics

`[attrition()](attrition.html)`
    Get attrition from an object.

`[bind()](bind.html)`
    Bind two or more objects of the same class.

`[settings()](settings.html)`
    Get settings from an object.

`[suppress()](suppress.html)`
    Function to suppress counts in result objects

### Create new objects

To create new omopgenerics S3 classes objects

`[newAchillesTable()](newAchillesTable.html)`
    Create an achilles table from a cdm_table.

`[newCdmReference()](newCdmReference.html)`
    `cdm_reference` objects constructor

`[newCdmSource()](newCdmSource.html)`
    Create a cdm source object.

`[newCdmTable()](newCdmTable.html)`
    Create an cdm table.

`[newCodelist()](newCodelist.html)`
    'codelist' object constructor

`[newCodelistWithDetails()](newCodelistWithDetails.html)`
    'codelist' object constructor

`[newCohortTable()](newCohortTable.html)`
    `cohort_table` objects constructor.

`[newConceptSetExpression()](newConceptSetExpression.html)`
    'concept_set_expression' object constructor

`[newLocalSource()](newLocalSource.html)`
    A new local source for the cdm

`[newOmopTable()](newOmopTable.html)`
    Create an omop table from a cdm table.

`[newSummarisedResult()](newSummarisedResult.html)`
    'summarised_results' object constructor

### Creates empty objects

To create empty omopgenerics S3 classes objects

`[emptyAchillesTable()](emptyAchillesTable.html)`
    Create an empty achilles table

`[emptyCdmReference()](emptyCdmReference.html)`
    Create an empty cdm_reference

`[emptyCodelist()](emptyCodelist.html)`
    Empty `codelist` object.

`[emptyCodelistWithDetails()](emptyCodelistWithDetails.html)`
    Empty `codelist` object.

`[emptyCohortTable()](emptyCohortTable.html)`
    Create an empty cohort_table object

`[emptyConceptSetExpression()](emptyConceptSetExpression.html)`
    Empty `concept_set_expression` object.

`[emptyOmopTable()](emptyOmopTable.html)`
    Create an empty omop table

`[emptySummarisedResult()](emptySummarisedResult.html)`
    Empty `summarised_result` object.

### cdm_reference utility functions

Utility functions for cdm_reference objects

`[cdmClasses()](cdmClasses.html)`
    Separate the cdm tables in classes

`[cdmDisconnect()](cdmDisconnect.html)`
    Disconnect from a cdm object.

`[cdmFromTables()](cdmFromTables.html)`
    Create a cdm object from local tables

`[cdmName()](cdmName.html)`
    Get the name of a cdm_reference associated object

`[cdmReference()](cdmReference.html)`
    Get the `cdm_reference` of a `cdm_table`.

`[cdmSelect()](cdmSelect.html)`
    Restrict the cdm object to a subset of tables.

`[cdmSource()](cdmSource.html)`
    Get the cdmSource of an object.

`[cdmSourceType()](cdmSourceType.html)` deprecated
    Get the source type of a cdm_reference object.

`[cdmTableFromSource()](cdmTableFromSource.html)`
    This is an internal developer focused function that creates a cdm_table from a table that shares the source but it is not a cdm_table. Please use insertTable if you want to insert a table to a cdm_reference object.

`[cdmVersion()](cdmVersion.html)`
    Get the version of an object.

`[listSourceTables()](listSourceTables.html)`
    List tables that can be accessed though a cdm object.

`[dropSourceTable()](dropSourceTable.html)`
    Drop a table from a cdm object.

`[insertTable()](insertTable.html)`
    Insert a table to a cdm object.

`[readSourceTable()](readSourceTable.html)`
    Read a table from the cdm_source and add it to to the cdm.

`[insertCdmTo()](insertCdmTo.html)`
    Insert a cdm_reference object to a different source.

`[getPersonIdentifier()](getPersonIdentifier.html)`
    Get the column name with the person identifier from a table (either subject_id or person_id), it will throw an error if it contains both or neither.

`[`$`(_< cdm_reference>_)](cash-.cdm_reference.html)`
    Subset a cdm reference object.

`[`$<-`(_< cdm_reference>_)](cash-set-.cdm_reference.html)`
    Assign an table to a cdm reference.

`[collect(_< cdm_reference>_)](collect.cdm_reference.html)`
    Retrieves the cdm reference into a local cdm.

`[print(_< cdm_reference>_)](print.cdm_reference.html)`
    Print a CDM reference object

`[`[[`(_< cdm_reference>_)](sub-sub-.cdm_reference.html)`
    Subset a cdm reference object.

`[`[[<-`(_< cdm_reference>_)](sub-subset-.cdm_reference.html)`
    Assign a table to a cdm reference.

`[summary(_< cdm_reference>_)](summary.cdm_reference.html)`
    Summary a cdm reference

`[summary(_< cdm_source>_)](summary.cdm_source.html)`
    Summarise a `cdm_source` object

### cdm_table utility functions

Utility functions for cdm_table objects

`[tableName()](tableName.html)`
    Get the table name of a `cdm_table`.

`[tableSource()](tableSource.html)`
    Get the table source of a `cdm_table`.

`[numberRecords()](numberRecords.html)`
    Count the number of records that a `cdm_table` has.

`[numberSubjects()](numberSubjects.html)`
    Count the number of subjects that a `cdm_table` has.

`[compute(_< cdm_table>_)](compute.cdm_table.html)`
    Store results in a table.

### omop_table utility functions

Utility functions for omop_table objects

`[omopColumns()](omopColumns.html)`
    Required columns that the standard tables in the OMOP Common Data Model must have.

`[omopDataFolder()](omopDataFolder.html)`
    Check or set the OMOP_DATA_FOLDER where the OMOP related data is stored.

`[omopTableFields()](omopTableFields.html)`
    Return a table of omop cdm fields informations

`[omopTables()](omopTables.html)`
    Standard tables that a cdm reference can contain in the OMOP Common Data Model.

### achilles_table utility functions

Utility functions for achilles_table objects

`[achillesColumns()](achillesColumns.html)`
    Required columns for each of the achilles result tables

`[achillesTables()](achillesTables.html)`
    Names of the tables that contain the results of achilles analyses

### cohort_table utility functions

Utility functions for cohort_table objects

`[cohortCodelist()](cohortCodelist.html)`
    Get codelist from a cohort_table object.

`[cohortColumns()](cohortColumns.html)`
    Required columns for a generated cohort set.

`[cohortCount()](cohortCount.html)`
    Get cohort counts from a cohort_table object.

`[cohortTables()](cohortTables.html)`
    Cohort tables that a cdm reference can contain in the OMOP Common Data Model.

`[getCohortId()](getCohortId.html)`
    Get the cohort definition id of a certain name

`[getCohortName()](getCohortName.html)`
    Get the cohort name of a certain cohort definition id

`[recordCohortAttrition()](recordCohortAttrition.html)`
    Update cohort attrition.

`[attrition(_< cohort_table>_)](attrition.cohort_table.html)`
    Get cohort attrition from a cohort_table object.

`[bind(_< cohort_table>_)](bind.cohort_table.html)`
    Bind two or more cohort tables

`[collect(_< cohort_table>_)](collect.cohort_table.html)`
    To collect a `cohort_table` object.

`[settings(_< cohort_table>_)](settings.cohort_table.html)`
    Get cohort settings from a cohort_table object.

`[summary(_< cohort_table>_)](summary.cohort_table.html)`
    Summary a generated cohort set

### summarised_result utility functions

Utility functions for summarised_result objects

`[transformToSummarisedResult()](transformToSummarisedResult.html)`
    Create a <summarised_result> object from a data.frame, given a set of specifications.

`[exportSummarisedResult()](exportSummarisedResult.html)`
    Export a summarised_result object to a csv file.

`[importSummarisedResult()](importSummarisedResult.html)`
    Import a set of summarised results.

`[estimateTypeChoices()](estimateTypeChoices.html)`
    Choices that can be present in `estimate_type` column.

`[resultColumns()](resultColumns.html)`
    Required columns that the result tables must have.

`[resultPackageVersion()](resultPackageVersion.html)`
    Check if different packages version are used for summarise_results object

`[isResultSuppressed()](isResultSuppressed.html)`
    To check whether an object is already suppressed to a certain min cell count.

`[bind(_< summarised_result>_)](bind.summarised_result.html)`
    Bind two or summarised_result objects

`[settings(_< summarised_result>_)](settings.summarised_result.html)`
    Get settings from a summarised_result object.

`[summary(_< summarised_result>_)](summary.summarised_result.html)`
    Summary a summarised_result

`[suppress(_< summarised_result>_)](suppress.summarised_result.html)`
    Function to suppress counts in result objects

`[tidy(_< summarised_result>_)](tidy.summarised_result.html)` experimental
    Turn a `<summarised_result>` object into a tidy tibble

`[filterAdditional()](filterAdditional.html)`
    Filter the additional_name-additional_level pair in a summarised_result

`[filterGroup()](filterGroup.html)`
    Filter the group_name-group_level pair in a summarised_result

`[filterSettings()](filterSettings.html)`
    Filter a `<summarised_result>` using the settings

`[filterStrata()](filterStrata.html)`
    Filter the strata_name-strata_level pair in a summarised_result

`[splitAdditional()](splitAdditional.html)`
    Split additional_name and additional_level columns

`[splitAll()](splitAll.html)`
    Split all pairs name-level into columns.

`[splitGroup()](splitGroup.html)`
    Split group_name and group_level columns

`[splitStrata()](splitStrata.html)`
    Split strata_name and strata_level columns

`[uniteAdditional()](uniteAdditional.html)`
    Unite one or more columns in additional_name-additional_level format

`[uniteGroup()](uniteGroup.html)`
    Unite one or more columns in group_name-group_level format

`[uniteStrata()](uniteStrata.html)`
    Unite one or more columns in strata_name-strata_level format

`[strataColumns()](strataColumns.html)`
    Identify variables in strata_name column

`[additionalColumns()](additionalColumns.html)`
    Identify variables in additional_name column

`[groupColumns()](groupColumns.html)`
    Identify variables in group_name column

`[settingsColumns()](settingsColumns.html)`
    Identify settings columns of a `<summarised_result>`

`[tidyColumns()](tidyColumns.html)`
    Identify tidy columns of a `<summarised_result>`

`[pivotEstimates()](pivotEstimates.html)`
    Set estimates as columns

`[addSettings()](addSettings.html)`
    Add settings columns to a `<summarised_result>` object

### codelist utility functions

Utility functions for codelist objects

`[exportCodelist()](exportCodelist.html)`
    Export a codelist object.

`[exportConceptSetExpression()](exportConceptSetExpression.html)`
    Export a concept set expression.

`[importCodelist()](importCodelist.html)`
    Import a codelist.

`[importConceptSetExpression()](importConceptSetExpression.html)`
    Import a concept set expression.

`[print(_< codelist>_)](print.codelist.html)`
    Print a codelist

`[print(_< codelist_with_details>_)](print.codelist_with_details.html)`
    Print a codelist with details

`[print(_< conceptSetExpression>_)](print.conceptSetExpression.html)`
    Print a concept set expression

### Work with indexes

Methods and functions to work with indexes in database backends.

`[existingIndexes()](existingIndexes.html)` experimental
    Existing indexes in a cdm object

`[expectedIndexes()](expectedIndexes.html)` experimental
    Expected indexes in a cdm object

`[statusIndexes()](statusIndexes.html)` experimental
    Status of the indexes

`[createIndexes()](createIndexes.html)` experimental
    Create the missing indexes

`[createTableIndex()](createTableIndex.html)` experimental
    Create a table index

### Argument validation

To validate input arguments of the functions

`[validateAchillesTable()](validateAchillesTable.html)`
    Validate if a cdm_table is a valid achilles table.

`[validateAgeGroupArgument()](validateAgeGroupArgument.html)`
    Validate the ageGroup argument. It must be a list of two integerish numbers lower age and upper age, both of the must be greater or equal to 0 and lower age must be lower or equal to the upper age. If not named automatic names will be given in the output list.

`[validateCdmArgument()](validateCdmArgument.html)`
    Validate if an object in a valid cdm_reference.

`[validateCdmTable()](validateCdmTable.html)`
    Validate if a table is a valid cdm_table object.

`[validateCohortArgument()](validateCohortArgument.html)`
    Validate a cohort table input.

`[validateCohortIdArgument()](validateCohortIdArgument.html)`
    Validate cohortId argument. CohortId can either be a cohort_definition_id value, a cohort_name or a tidyselect expression referinc to cohort_names. If you want to support tidyselect expressions please use the function as: `validateCohortIdArgument({{cohortId}}, cohort)`.

`[validateColumn()](validateColumn.html)`
    Validate whether a variable points to a certain exiting column in a table.

`[validateConceptSetArgument()](validateConceptSetArgument.html)`
    Validate conceptSet argument. It can either be a list, a codelist, a concept set expression or a codelist with details. The output will always be a codelist.

`[validateNameArgument()](validateNameArgument.html)`
    Validate name argument. It must be a snake_case character vector. You can add the a cdm object to check `name` is not already used in that cdm.

`[validateNameLevel()](validateNameLevel.html)`
    Validate if two columns are valid Name-Level pair.

`[validateNameStyle()](validateNameStyle.html)`
    Validate `nameStyle` argument. If any of the element in `...` has length greater than 1 it must be contained in nameStyle. Note that snake case notation is used.

`[validateNewColumn()](validateNewColumn.html)`
    Validate a new column of a table

`[validateOmopTable()](validateOmopTable.html)`
    Validate an omop_table

`[validateResultArgument()](validateResultArgument.html)`
    Validate if a an object is a valid 'summarised_result' object.

`[validateStrataArgument()](validateStrataArgument.html)`
    To validate a strata list. It makes sure that elements are unique and point to columns in table.

`[validateWindowArgument()](validateWindowArgument.html)`
    Validate a window argument. It must be a list of two elements (window start and window end), both must be integerish and window start must be lower or equal than window end.

### General assertions

To assert that an object fulfills certain criteria

`[assertCharacter()](assertCharacter.html)`
    Assert that an object is a character and fulfill certain conditions.

`[assertChoice()](assertChoice.html)`
    Assert that an object is within a certain oprtions.

`[assertClass()](assertClass.html)`
    Assert that an object has a certain class.

`[assertDate()](assertDate.html)`
    Assert Date

`[assertList()](assertList.html)`
    Assert that an object is a list.

`[assertLogical()](assertLogical.html)`
    Assert that an object is a logical.

`[assertNumeric()](assertNumeric.html)`
    Assert that an object is a numeric.

`[assertTable()](assertTable.html)`
    Assert that an object is a table.

`[assertTrue()](assertTrue.html)`
    Assert that an expression is TRUE.

### Utility functions

`[insertFromSource()](insertFromSource.html)` deprecated
    Convert a table that is not a cdm_table but have the same original source to a cdm_table. This Table is not meant to be used to insert tables in the cdm, please use insertTable instead.

`[sourceType()](sourceType.html)`
    Get the source type of an object.

`[tmpPrefix()](tmpPrefix.html)`
    Create a temporary prefix for tables, that contains a unique prefix that starts with tmp.

`[uniqueId()](uniqueId.html)`
    Get a unique Identifier with a certain number of characters and a prefix.

`[uniqueTableName()](uniqueTableName.html)`
    Create a unique table name

`[isTableEmpty()](isTableEmpty.html)`
    Check if a table is empty or not

`[toSnakeCase()](toSnakeCase.html)`
    Convert a character vector to snake case

`[combineStrata()](combineStrata.html)`
    Provide all combinations of strata levels.

`[createLogFile()](createLogFile.html)`
    Create a log file

`[logMessage()](logMessage.html)`
    Log a message to a logFile

`[summariseLogFile()](summariseLogFile.html)`
    Summarise and extract the information of a log file into a `summarised_result` object.

### Deprecated

Deprecated function that will be eliminated in future releases of the package

`[checkCohortRequirements()](checkCohortRequirements.html)` deprecated
    Check whether a cohort table satisfies requirements

`[dropTable()](dropTable.html)` deprecated
    Drop a table from a cdm object. [![\[Deprecated\]](figures/lifecycle-deprecated.svg)](https://lifecycle.r-lib.org/articles/stages.html#deprecated)

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/articles/cdm_reference.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# The cdm reference

Source: [`vignettes/cdm_reference.Rmd`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/vignettes/cdm_reference.Rmd)

`cdm_reference.Rmd`

A cdm reference is a single R object that represents OMOP CDM data. The tables in the cdm reference may be in a database, but a cdm reference may also contain OMOP CDM tables that are in dataframes or tibbles, or in arrow. In the latter cases the cdm reference would typically be a subset of an original cdm reference that has been derived as part of a particular analysis.

omopgenerics provides a general class definition a cdm reference and a dataframe/ tibble implementation. For creating a cdm reference using a database, see the CDMConnector package (<https://darwin-eu.github.io/CDMConnector/>).

A cdm reference is a list of tables. These tables come in three types: standard OMOP CDM tables, cohort tables, and other auxiliary tables.

### 1) Standard OMOP CDM tables

There are multiple versions of the OMOP CDM. The list of tables included in version 5.3 are as follows.
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    #> 
    #> Attaching package: 'omopgenerics'
    #> The following object is masked from 'package:stats':
    #> 
    #>     filter
    [omopTables](../reference/omopTables.html)()
    #>  [1] "person"                "observation_period"    "visit_occurrence"     
    #>  [4] "visit_detail"          "condition_occurrence"  "drug_exposure"        
    #>  [7] "procedure_occurrence"  "device_exposure"       "measurement"          
    #> [10] "observation"           "death"                 "note"                 
    #> [13] "note_nlp"              "specimen"              "fact_relationship"    
    #> [16] "location"              "care_site"             "provider"             
    #> [19] "payer_plan_period"     "cost"                  "drug_era"             
    #> [22] "dose_era"              "condition_era"         "metadata"             
    #> [25] "cdm_source"            "concept"               "vocabulary"           
    #> [28] "domain"                "concept_class"         "concept_relationship" 
    #> [31] "relationship"          "concept_synonym"       "concept_ancestor"     
    #> [34] "source_to_concept_map" "drug_strength"         "cohort_definition"    
    #> [37] "attribute_definition"  "concept_recommended"

The standard OMOP tables have required fields. We can check the required column of the person table, for example, like so
    
    
    [omopColumns](../reference/omopColumns.html)(table = "person", version = "5.3")
    #>  [1] "person_id"                   "gender_concept_id"          
    #>  [3] "year_of_birth"               "month_of_birth"             
    #>  [5] "day_of_birth"                "birth_datetime"             
    #>  [7] "race_concept_id"             "ethnicity_concept_id"       
    #>  [9] "location_id"                 "provider_id"                
    #> [11] "care_site_id"                "person_source_value"        
    #> [13] "gender_source_value"         "gender_source_concept_id"   
    #> [15] "race_source_value"           "race_source_concept_id"     
    #> [17] "ethnicity_source_value"      "ethnicity_source_concept_id"
    
    
    [omopColumns](../reference/omopColumns.html)(table = "observation_period", version = "5.3")
    #> [1] "observation_period_id"         "person_id"                    
    #> [3] "observation_period_start_date" "observation_period_end_date"  
    #> [5] "period_type_concept_id"

### 2) Cohort tables

Studies using the OMOP CDM often create study-specific cohort tables. We also consider these as part of the cdm reference once created. Each cohort table is associated with a specific class of its own, a `generatedCohortSet`, which is described more in a subsequent vignette. As with the standard OMOP CDM tables, cohort tables are expected to contain a specific set of fields (with no restriction placed on whether they include additional fields or not).
    
    
    [cohortColumns](../reference/cohortColumns.html)(table = "cohort", version = "5.3")
    #> [1] "cohort_definition_id" "subject_id"           "cohort_start_date"   
    #> [4] "cohort_end_date"
    [cohortColumns](../reference/cohortColumns.html)(table = "cohort_set", version = "5.3")
    #> [1] "cohort_definition_id" "cohort_name"
    [cohortColumns](../reference/cohortColumns.html)(table = "cohort_attrition", version = "5.3")
    #> [1] "cohort_definition_id" "number_records"       "number_subjects"     
    #> [4] "reason_id"            "reason"               "excluded_records"    
    #> [7] "excluded_subjects"

### 3) Achilles result tables

The Achilles R package provides descriptive statistics on an OMOP CDM database. The results from Achilles are stored in tables in the database. The following tables are created with the given columns.
    
    
    [achillesTables](../reference/achillesTables.html)()
    #> [1] "achilles_analysis"     "achilles_results"      "achilles_results_dist"
    [achillesColumns](../reference/achillesColumns.html)("achilles_analysis")
    #> [1] "analysis_id"    "analysis_name"  "stratum_1_name" "stratum_2_name"
    #> [5] "stratum_3_name" "stratum_4_name" "stratum_5_name" "is_default"    
    #> [9] "category"
    [achillesColumns](../reference/achillesColumns.html)("achilles_results")
    #> [1] "analysis_id" "stratum_1"   "stratum_2"   "stratum_3"   "stratum_4"  
    #> [6] "stratum_5"   "count_value"
    [achillesColumns](../reference/achillesColumns.html)("achilles_results_dist")
    #>  [1] "analysis_id"  "stratum_1"    "stratum_2"    "stratum_3"    "stratum_4"   
    #>  [6] "stratum_5"    "count_value"  "min_value"    "max_value"    "avg_value"   
    #> [11] "stdev_value"  "median_value" "p10_value"    "p25_value"    "p75_value"   
    #> [16] "p90_value"

### 4) Other tables

Beyond the standard OMOP CDM tables and cohort tables, additional tables can be added to the cdm reference. These tables could, for example, be OMOP extension/ expansion tables or extra tables containing data required to perform a study but not normally included as part of the OMOP CDM. These tables could contain any set of fields.

## General rules for a cdm reference

Any table to be part of a cdm object has to fulfill the following conditions:

  * All tables must share a common source (that is, a mix of tables in the database and in-memory is not permitted).

  * The name of the tables must be lower snake_case.

  * The name of the column names of each table must be lower snake_case.

  * The `person` and `observation_period` tables must be present.

  * The cdm reference must have an attribute “cdmName” that gives the name associated with the data contained there within.




## Export metadata about the cdm reference

When the export method is applied to a cdm reference, metadata about that cdm will be written to a csv. The csv contains the following columns

Variable | Description | Datatype | Required  
---|---|---|---  
result_type | Always “Snapshot”. Identifies this result as a summary of a cdm reference. | Character | Yes  
cdm_name | The name of the data source. | Character | Yes  
cdm_source_name | Value of cdm source name taken from the cdm source table (if present in the cdm reference). | Character | No  
cdm_description | Value of cdm description taken from the cdm source table (if present in the cdm reference). | Character | No  
cdm_documentation_reference | Value of cdm documentation reference taken from the cdm source table (if present in the cdm reference). | Character | No  
cdm_version | The cdm version associated with the cdm reference. | Character | Yes  
cdm_holder | Value of cdm holder reference taken from the cdm source table (if present in the cdm reference). | Character | No  
cdm_release_date | Value of cdm release date taken from the cdm source table (if present in the cdm reference). | Date | No  
vocabulary_version | Version of the vocabulary being used taken from the concept table (if present in the cdm reference). | Character | No  
person_count | Number of records in the person table. | Integer | Yes  
observation_period_count | Number of records in the observation period table. | Integer | Yes  
earliest_observation_period_start_date | Earliest date in the observation period start date field from the observation period table. | Date | Yes  
latest_observation_period_end_date | Latest date in the observation period start date field from the observation period table. | Date | Yes  
snapshot_date | Date at which this snapshot was created. | Date | Yes  
  
## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/articles/codelists.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Concept sets

Source: [`vignettes/codelists.Rmd`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/vignettes/codelists.Rmd)

`codelists.Rmd`
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))

## Codelist

A concept set can be represented as either a codelist or a concept set expression. A codelist is a named list, with each item of the list containing specific concept IDs.
    
    
    condition_codes <- [list](https://rdrr.io/r/base/list.html)(
      "diabetes" = [c](https://rdrr.io/r/base/c.html)(201820, 4087682, 3655269),
      "asthma" = 317009
    )
    condition_codes <- [newCodelist](../reference/newCodelist.html)(condition_codes)
    #> Warning: ! `codelist` casted to integers.
    
    condition_codes
    #> 
    #> - asthma (1 codes)
    #> - diabetes (3 codes)

A codelist must be named
    
    
    condition_codes <- [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(201820, 4087682, 3655269))
    [newCodelist](../reference/newCodelist.html)(condition_codes)
    #> Error in `newCodelist()`:
    #> ✖ `codelist` must be named.
    #> ! `codelist` must be a list with objects of class numeric, integer, and
    #>   integer64; it can not contain NA; it has to be named; it can not be NULL.

And a codelist cannot have missing values
    
    
    condition_codes <- [list](https://rdrr.io/r/base/list.html)(
      "diabetes" = [c](https://rdrr.io/r/base/c.html)(201820, NA, 3655269),
      "asthma" = 317009
    )
    [newCodelist](../reference/newCodelist.html)(condition_codes)
    #> Warning: ! `codelist` casted to integers.
    #> Error in `validateCodelist()`:
    #> ✖ 1 codelist contain NA: `diabetes`.

## Concept set expression

A concept set expression provides a high-level definition of concepts that, when applied to a specific OMOP CDM vocabulary version (by making use of the concept hierarchies and relationships), will result in a codelist.
    
    
    condition_cs <- [list](https://rdrr.io/r/base/list.html)(
      "diabetes" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "concept_id" = [c](https://rdrr.io/r/base/c.html)(201820, 4087682),
        "excluded" = [c](https://rdrr.io/r/base/c.html)(FALSE, FALSE),
        "descendants" = [c](https://rdrr.io/r/base/c.html)(TRUE, FALSE),
        "mapped" = [c](https://rdrr.io/r/base/c.html)(FALSE, FALSE)
      ),
      "asthma" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "concept_id" = 317009,
        "excluded" = FALSE,
        "descendants" = FALSE,
        "mapped" = FALSE
      )
    )
    condition_cs <- [newConceptSetExpression](../reference/newConceptSetExpression.html)(condition_cs)
    
    condition_cs
    #> 
    #> - asthma (1 concept criteria)
    #> - diabetes (2 concept criteria)

As with a codelist, a concept set expression must be a named list and cannot have missing elements.
    
    
    condition_cs <- [list](https://rdrr.io/r/base/list.html)(
      dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "concept_id" = [c](https://rdrr.io/r/base/c.html)(201820, NA),
        "excluded" = [c](https://rdrr.io/r/base/c.html)(FALSE, FALSE),
        "descendants" = [c](https://rdrr.io/r/base/c.html)(TRUE, FALSE),
        "mapped" = [c](https://rdrr.io/r/base/c.html)(FALSE, FALSE)
      )
    )
    [newConceptSetExpression](../reference/newConceptSetExpression.html)(condition_cs)
    #> Error in `newConceptSetExpression()`:
    #> ✖ `x` must be named.
    #> ! `x` must be a list with objects of class tbl; it can not contain NA; it has
    #>   to be named; it can not be NULL.
    
    
    condition_cs <- [list](https://rdrr.io/r/base/list.html)(
      "diabetes" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "concept_id" = [c](https://rdrr.io/r/base/c.html)(201820, NA),
        "excluded" = [c](https://rdrr.io/r/base/c.html)(FALSE, FALSE),
        "descendants" = [c](https://rdrr.io/r/base/c.html)(TRUE, FALSE),
        "mapped" = [c](https://rdrr.io/r/base/c.html)(FALSE, FALSE)
      ),
      "asthma" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "concept_id" = 317009,
        "excluded" = FALSE,
        "descendants" = FALSE,
        "mapped" = FALSE
      )
    )
    [newConceptSetExpression](../reference/newConceptSetExpression.html)(condition_cs)
    #> Error in `newConceptSetExpression()`:
    #> ✖ `x[[i]]$concept_id` contains NA in position 2.
    #> ! `x[[i]]$concept_id` must be an integerish numeric; it can not contain NA; it
    #>   can not be NULL.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/articles/cohorts.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Cohort tables

Source: [`vignettes/cohorts.Rmd`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/vignettes/cohorts.Rmd)

`cohorts.Rmd`

## Cohort table

A cohort is a **set of people that fulfill a certain set of criteria for a period of time**.

In omopgenerics we defined the `cohort_table` class that allows us to represent individuals in a cohort.

A `cohort_table` is created using the `[newCohortTable()](../reference/newCohortTable.html)` function that is defined by:

  * A cohort table.

  * A cohort set.

  * A cohort attrition.




Let’s start by creating a cdm reference with just two people.
    
    
    person <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = [c](https://rdrr.io/r/base/c.html)(1, 2),
      gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = [c](https://rdrr.io/r/base/c.html)(1, 2), person_id = [c](https://rdrr.io/r/base/c.html)(1, 2),
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2021-12-31"),
      period_type_concept_id = 0
    )
    cdm <- [cdmFromTables](../reference/cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = person,
        "observation_period" = observation_period
      ),
      cdmName = "example_cdm"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 3 casted column in observation_period as do not match expected column type:
    #> • `observation_period_id` from numeric to integer
    #> • `person_id` from numeric to integer
    #> • `period_type_concept_id` from numeric to integer
    cdm
    #> 
    #> ── # OMOP CDM reference (local) of example_cdm ─────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -

Now let’s say one of these people have a clinical event of interest, we can include them in a cohort table which can then be used as part of an analysis.
    
    
    cohort <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1, subject_id = 1,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-01"),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-10")
    )
    cdm <- [insertTable](../reference/insertTable.html)(cdm = cdm, name = "cohort", table = cohort)
    cdm$cohort <- [newCohortTable](../reference/newCohortTable.html)(cdm$cohort)
    #> Warning: ! 2 casted column in cohort as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> • `subject_id` from numeric to integer

The cohort table will be associated with settings and attrition. As we didn’t specify these in newCohortTable() above they will have been automatically populated. You can access the cohort set of a cohort table using the function `[settings()](../reference/settings.html)`
    
    
    [settings](../reference/settings.html)(cdm$cohort)
    #> # A tibble: 1 × 2
    #>   cohort_definition_id cohort_name
    #>                  <int> <chr>      
    #> 1                    1 cohort_1

Meanwhile, you can access the cohort attrition of a cohort table using the function `[attrition()](../reference/attrition.html)`
    
    
    [attrition](../reference/attrition.html)(cdm$cohort)
    #> # A tibble: 1 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1              1               1         1 Initial qualify…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>

Cohort attrition table is also used to compute the number of counts that each cohort (ie from the last row of the attrition). It can be seen with the function `[cohortCount()](../reference/cohortCount.html)`.
    
    
    [cohortCount](../reference/cohortCount.html)(cdm$cohort)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1              1               1

Note that because the cohort count is taken from the last row of attrition, if we make changes to a cohort we should then update attrition as we go. We can do this
    
    
    cdm$cohort <- cdm$cohort |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(cohort_start_date == [as.Date](https://rdrr.io/r/base/as.Date.html)("2019-01-01")) |>
      [compute](https://dplyr.tidyverse.org/reference/compute.html)(name = "cohort", temporary = FALSE) |>
      [recordCohortAttrition](../reference/recordCohortAttrition.html)("Require cohort start January 1st 2019")
    [attrition](../reference/attrition.html)(cdm$cohort)
    #> # A tibble: 2 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1              1               1         1 Initial qualify…
    #> 2                    1              0               0         2 Require cohort …
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    [cohortCount](../reference/cohortCount.html)(cdm$cohort)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1              0               0

An additional, optional, attribute keeps track of the concepts used to create the cohort. In this example we do not have a codelist associated with our cohort.
    
    
    [cohortCodelist](../reference/cohortCodelist.html)(cdm$cohort, cohortId = 1, type = "index event")
    #> Warning: The `type` argument of `cohortCodelist()` is deprecated as of omopgenerics
    #> 1.2.0.
    #> ℹ Please use the `codelistType` argument instead.
    #> This warning is displayed once every 8 hours.
    #> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
    #> generated.
    #> Warning: No codelists found for the specified cohorts
    #> 
    #> ── 0 codelists ─────────────────────────────────────────────────────────────────

We could though associate our cohort with a codelist
    
    
    cdm$cohort <- [newCohortTable](../reference/newCohortTable.html)(cdm$cohort,
      cohortCodelistRef = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        cohort_definition_id = [c](https://rdrr.io/r/base/c.html)(1, 1),
        codelist_name = [c](https://rdrr.io/r/base/c.html)("disease X", "disease X"),
        concept_id = [c](https://rdrr.io/r/base/c.html)(101, 102),
        type = "index event"
      )
    )
    [cohortCodelist](../reference/cohortCodelist.html)(cdm$cohort, cohortId = 1, type = "index event")
    #> Warning: ! `codelist` casted to integers.
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - disease X (2 codes)

Each one of the elements that define a cohort table have to fulfill certain criteria.

### Cohort Set

A cohort set must be a table with:

  * Lower case column names.

  * At least cohort_definition_id, cohort_name columns (`cohortColumns("cohort_set")`).

  * `cohort_name` it must contain unique cohort names (currently they are cased to snake case).

  * `cohort_definition_id` it must contain unique cohort ids, all the ids present in table must be present in the cohort set and the same ids must be present in cohort attrition.




### Cohort Attrition

A cohort attrition must be a table with:

  * Lower case column names.

  * At least cohort_definition_id, number_records, number_subjects, reason_id, reason, excluded_records, excluded_subjects columns (`cohortColumns("cohort_attrition")`).

  * `cohort_definition_id` it must contain cohort ids, all the ids present in table must be present in the cohort attrition and the same ids must be present in cohort set.

  * There must exist unique pairs of `cohort_definition_id` and `reason_id`.




### Cohort Codelist

A cohort codelist must be a table with:

  * Lower case column names.

  * At least cohort_definition_id, codelist_name, concept_id, codelist_type columns (`cohortColumns("cohort_codelist")`).

  * `cohort_definition_id` it must contain cohort ids, all the ids present in table must be present in the cohort attrition and the same ids must be present in cohort set.

  * `type` must be one of “index event”, “inclusion criteria”, and “exit criteria”




### Cohort Table

A cohort table must be a table with:

  * It comes from a cdm_reference (extracted via `cdm$cohort`).

  * It has the same source than this cdm_reference.

  * Lower case column names.

  * At least cohort_definition_id, subject_id, cohort_start_date, cohort_end_date columns (`cohortColumns("cohort")`).

  * There is no record with `NA` value in the required columns.

  * There is no record with `cohort_start_date` after `cohort_end_date`.

  * There is no overlap between records. A person can be in a cohort several times (several records with the same subject_id). But it can’t enter (cohort_start_date) the cohort again before leaving it (cohort_end_date). So an individual can’t be simultaneously more than once in the same cohort. This rule is applied at the cohort_definition_id level, so records with different cohort_definition_id can overlap.

  * All the time between cohort_start_date and cohort_end_date (both included) the individual must be in observation.




## Combining generated cohort sets

You can bind two cohort tables using the method `[bind()](../reference/bind.html)`. You can combine several cohort tables using this method. The only constrain is that cohort names must be unique across the different cohort tables. You have to provide a name for the new cohort table.
    
    
    asthma <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1, subject_id = 1,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-01"),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-10")
    )
    cdm <- [insertTable](../reference/insertTable.html)(cdm, name = "asthma", table = asthma)
    cdm$asthma <- [newCohortTable](../reference/newCohortTable.html)(cdm$asthma,
      cohortSetRef = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        cohort_definition_id = 1,
        cohort_name = "asthma"
      )
    )
    #> Warning: ! 2 casted column in asthma as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> • `subject_id` from numeric to integer
    
    copd <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1, subject_id = 2,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-01"),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-10")
    )
    cdm <- [insertTable](../reference/insertTable.html)(cdm, name = "copd", table = copd)
    cdm$copd <- [newCohortTable](../reference/newCohortTable.html)(cdm$copd,
      cohortSetRef = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        cohort_definition_id = 1,
        cohort_name = "copd"
      )
    )
    #> Warning: ! 2 casted column in copd as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> • `subject_id` from numeric to integer
    
    cdm <- [bind](../reference/bind.html)(cdm$asthma,
      cdm$copd,
      name = "exposures"
    )
    cdm$exposures
    #> # A tibble: 2 × 4
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #> *                <int>      <int> <date>            <date>         
    #> 1                    1          1 2020-01-01        2020-01-10     
    #> 2                    2          2 2020-01-01        2020-01-10
    
    [settings](../reference/settings.html)(cdm$exposures)
    #> # A tibble: 2 × 2
    #>   cohort_definition_id cohort_name
    #>                  <int> <chr>      
    #> 1                    1 asthma     
    #> 2                    2 copd
    [attrition](../reference/attrition.html)(cdm$exposures)
    #> # A tibble: 2 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1              1               1         1 Initial qualify…
    #> 2                    2              1               1         1 Initial qualify…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    [cohortCount](../reference/cohortCount.html)(cdm$exposures)
    #> # A tibble: 2 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1              1               1
    #> 2                    2              1               1

## Export metadata about a cohort table

You can export the metadata of a `cohort_table` using the function: `[summary()](https://rdrr.io/r/base/summary.html)`:
    
    
    [summary](https://rdrr.io/r/base/summary.html)(cdm$exposures) |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> `cohort_definition_id` casted to character.
    #> `cohort_definition_id` casted to character.
    #> Rows: 12
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4
    #> $ cdm_name         <chr> "example_cdm", "example_cdm", "example_cdm", "example…
    #> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
    #> $ group_level      <chr> "asthma", "asthma", "copd", "copd", "asthma", "asthma…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "reason",…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "Initial …
    #> $ variable_name    <chr> "number_records", "number_subjects", "number_records"…
    #> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    #> $ estimate_name    <chr> "count", "count", "count", "count", "count", "count",…
    #> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
    #> $ estimate_value   <chr> "1", "1", "1", "1", "1", "1", "0", "0", "1", "1", "0"…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "reason_i…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "1", "1",…

This will provide a `summarised_result` object with the metadata of the cohort (cohort set, cohort counts and cohort attrition).

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/articles/summarised_result.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# A summarised result

Source: [`vignettes/summarised_result.Rmd`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/vignettes/summarised_result.Rmd)

`summarised_result.Rmd`

## Introduction

A summarised result is a table that contains aggregated summary statistics (result set with no patient-level data). The summarised result object consist in 2 objects: **results table** and **settings table**.

#### Results table

This table consist in 13 columns:

  * `result_id` (1), it is used to identify a group of results with a common settings (see settings below).
  * `cdm_name` (2), it is used to identify the name of the cdm object used to obtain those results.
  * `group_name` (3) - `group_level` (4), these columns work together as a _name-level_ pair. A _name-level_ pair are two columns that work together to summarise information of multiple other columns. The _name_ column contains the column names separated by `&&&` and the _level_ column contains the column values separated by `&&&`. Elements in the _name_ column must be snake_case. Usually group aggregation is used to show high level aggregations: e.g. cohort name or codelist name.
  * `strata_name` (5) - `strata_level` (6), these columns work together as a _name-level_ pair. Usually strata aggregation is used to show stratifications of the results: e.g. age groups or sex.
  * `variable_name` (7), name of the variable of interest.
  * `variable_level` (8), level of the variable of interest, it is usually a subclass of the variable_name.
  * `estimate_name` (9), name of the estimate.
  * `estimate_type` (10), type of the value displayed, the supported types are: numeric, integer, date, character, proportion, percentage, logical.
  * `estimate_value` (11), value of interest.
  * `additional_name` (12) - `additional_level` (13), these columns work together as a _name-level_ pair. Usually additional aggregation is used to include the aggregations that did not fit in the group/strata definition.



The following table summarises the requirements of each column in the summarised_result format:

Column name | Column type | is NA allowed? | Requirements  
---|---|---|---  
result_id | integer | No | NA  
cdm_name | character | No | NA  
group_name | character | No | name1  
group_level | character | No | level1  
strata_name | character | No | name2  
strata_level | character | No | level2  
variable_name | character | No | NA  
variable_level | character | Yes | NA  
estimate_name | character | No | snake_case  
estimate_type | character | No | estimateTypeChoices()  
estimate_value | character | No | NA  
additional_name | character | No | name3  
additional_level | character | No | level3  
  
#### Settings

The settings table provides one row per `result_id` with the settings used to generate those results, there is no limit of columns and parameters to be provided per result_id. But there is at least 3 values that should be provided:

  * `resut_type` (1): it identifies the type of result provided. We would usually use the name of the function that generated that set of result in snake_case. Example if the function that generates the summarised result is named _summariseMyCustomData_ and then the used result_type would be: _summarise_my_custom_data_.
  * `package_name` (2): name of the package that generated the result type.
  * `package_version` (3): version of the package that generated the result type.



All those columns are required to be characters, but this restriction does not apply to other extra columns.

#### newSummarisedResult

The `[newSummarisedResult()](../reference/newSummarisedResult.html)` function can be used to create __objects, the inputs of this function are: the summarised_result table that must fulfill the conditions specified above; and the settings argument. The settings argument can be NULL or do not contain all the required columns and they will be populated by default (a warning will appear). Let’s see a very simple example:
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      result_id = 1L,
      cdm_name = "my_cdm",
      group_name = "cohort_name",
      group_level = "cohort1",
      strata_name = "sex",
      strata_level = "male",
      variable_name = "Age group",
      variable_level = "10 to 50",
      estimate_name = "count",
      estimate_type = "numeric",
      estimate_value = "5",
      additional_name = "overall",
      additional_level = "overall"
    )
    
    result <- [newSummarisedResult](../reference/newSummarisedResult.html)(x)
    result |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1
    #> Columns: 13
    #> $ result_id        <int> 1
    #> $ cdm_name         <chr> "my_cdm"
    #> $ group_name       <chr> "cohort_name"
    #> $ group_level      <chr> "cohort1"
    #> $ strata_name      <chr> "sex"
    #> $ strata_level     <chr> "male"
    #> $ variable_name    <chr> "Age group"
    #> $ variable_level   <chr> "10 to 50"
    #> $ estimate_name    <chr> "count"
    #> $ estimate_type    <chr> "numeric"
    #> $ estimate_value   <chr> "5"
    #> $ additional_name  <chr> "overall"
    #> $ additional_level <chr> "overall"
    [settings](../reference/settings.html)(result)
    #> # A tibble: 1 × 8
    #>   result_id result_type package_name package_version group     strata additional
    #>       <int> <chr>       <chr>        <chr>           <chr>     <chr>  <chr>     
    #> 1         1 ""          ""           ""              cohort_n… sex    ""        
    #> # ℹ 1 more variable: min_cell_count <chr>

We can also associate settings with our results. These will typically be used to explain how the result was created.
    
    
    result <- [newSummarisedResult](../reference/newSummarisedResult.html)(
      x = x,
      settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        result_id = 1L,
        package_name = "PatientProfiles",
        study = "my_characterisation_study"
      )
    )
    
    result |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 1
    #> Columns: 13
    #> $ result_id        <int> 1
    #> $ cdm_name         <chr> "my_cdm"
    #> $ group_name       <chr> "cohort_name"
    #> $ group_level      <chr> "cohort1"
    #> $ strata_name      <chr> "sex"
    #> $ strata_level     <chr> "male"
    #> $ variable_name    <chr> "Age group"
    #> $ variable_level   <chr> "10 to 50"
    #> $ estimate_name    <chr> "count"
    #> $ estimate_type    <chr> "numeric"
    #> $ estimate_value   <chr> "5"
    #> $ additional_name  <chr> "overall"
    #> $ additional_level <chr> "overall"
    [settings](../reference/settings.html)(result)
    #> # A tibble: 1 × 9
    #>   result_id result_type package_name    package_version group  strata additional
    #>       <int> <chr>       <chr>           <chr>           <chr>  <chr>  <chr>     
    #> 1         1 ""          PatientProfiles ""              cohor… sex    ""        
    #> # ℹ 2 more variables: min_cell_count <chr>, study <chr>

## Combining summarised results

Multiple summarised results objects can be combined using the bind function. Result id will be assigned for each set of results with the same settings. So if two groups of results have the same settings althought being in different objects they will be merged into a single one.
    
    
    result1 <- [newSummarisedResult](../reference/newSummarisedResult.html)(
      x = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        result_id = 1L,
        cdm_name = "my_cdm",
        group_name = "cohort_name",
        group_level = "cohort1",
        strata_name = "sex",
        strata_level = "male",
        variable_name = "Age group",
        variable_level = "10 to 50",
        estimate_name = "count",
        estimate_type = "numeric",
        estimate_value = "5",
        additional_name = "overall",
        additional_level = "overall"
      ),
      settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        result_id = 1L,
        package_name = "PatientProfiles",
        package_version = "1.0.0",
        study = "my_characterisation_study",
        result_type = "stratified_by_age_group"
      )
    )
    
    result2 <- [newSummarisedResult](../reference/newSummarisedResult.html)(
      x = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        result_id = 1L,
        cdm_name = "my_cdm",
        group_name = "overall",
        group_level = "overall",
        strata_name = "overall",
        strata_level = "overall",
        variable_name = "overall",
        variable_level = "overall",
        estimate_name = "count",
        estimate_type = "numeric",
        estimate_value = "55",
        additional_name = "overall",
        additional_level = "overall"
      ),
      settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        result_id = 1L,
        package_name = "PatientProfiles",
        package_version = "1.0.0",
        study = "my_characterisation_study",
        result_type = "overall_analysis"
      )
    )

Now we have our results we can combine them using bind. Because the two sets of results contain the same result ID, when the results are combined this will be automatically updated.
    
    
    result <- [bind](../reference/bind.html)(result1, result2)
    result |>
      dplyr::[glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 2
    #> Columns: 13
    #> $ result_id        <int> 1, 2
    #> $ cdm_name         <chr> "my_cdm", "my_cdm"
    #> $ group_name       <chr> "cohort_name", "overall"
    #> $ group_level      <chr> "cohort1", "overall"
    #> $ strata_name      <chr> "sex", "overall"
    #> $ strata_level     <chr> "male", "overall"
    #> $ variable_name    <chr> "Age group", "overall"
    #> $ variable_level   <chr> "10 to 50", "overall"
    #> $ estimate_name    <chr> "count", "count"
    #> $ estimate_type    <chr> "numeric", "numeric"
    #> $ estimate_value   <chr> "5", "55"
    #> $ additional_name  <chr> "overall", "overall"
    #> $ additional_level <chr> "overall", "overall"
    [settings](../reference/settings.html)(result)
    #> # A tibble: 2 × 9
    #>   result_id result_type     package_name package_version group strata additional
    #>       <int> <chr>           <chr>        <chr>           <chr> <chr>  <chr>     
    #> 1         1 stratified_by_… PatientProf… 1.0.0           "coh… "sex"  ""        
    #> 2         2 overall_analys… PatientProf… 1.0.0           ""    ""     ""        
    #> # ℹ 2 more variables: min_cell_count <chr>, study <chr>

## Minimum cell count suppression

We have an entire vignette explaining how the summarised_result object is suppressed: [`vignette("suppression", "omopgenerics")`](https://darwin-eu.github.io/omopgenerics/articles/suppression.html).

## Export and import summarised results

The summarised_result object can be exported and imported as a .csv file with the following functions:

  * **importSummarisedResult()**

  * **exportSummarisedResult()**




Note that exportSummarisedResult also suppresses the results.
    
    
    x <- [tempdir](https://rdrr.io/r/base/tempfile.html)()
    files <- [list.files](https://rdrr.io/r/base/list.files.html)(x)
    
    [exportSummarisedResult](../reference/exportSummarisedResult.html)(result, path = x, fileName = "result.csv")
    [setdiff](https://generics.r-lib.org/reference/setops.html)([list.files](https://rdrr.io/r/base/list.files.html)(x), files)
    #> [1] "result.csv"

Note that the settings are included in the csv file:
    
    
    #> "result_id","cdm_name","group_name","group_level","strata_name","strata_level","variable_name","variable_level","estimate_name","estimate_type","estimate_value","additional_name","additional_level" "1","my_cdm","cohort_name","cohort1","sex","male","Age group","10 to 50","count","numeric","5","overall","overall" "2","my_cdm","overall","overall","overall","overall","overall","overall","count","numeric","55","overall","overall" "1",NA,"overall","overall","overall","overall","settings",NA,"result_type","character","stratified_by_age_group","overall","overall" "1",NA,"overall","overall","overall","overall","settings",NA,"package_name","character","PatientProfiles","overall","overall" "1",NA,"overall","overall","overall","overall","settings",NA,"package_version","character","1.0.0","overall","overall" "1",NA,"overall","overall","overall","overall","settings",NA,"group","character","cohort_name","overall","overall" "1",NA,"overall","overall","overall","overall","settings",NA,"strata","character","sex","overall","overall" "1",NA,"overall","overall","overall","overall","settings",NA,"additional","character","","overall","overall" "1",NA,"overall","overall","overall","overall","settings",NA,"min_cell_count","character","5","overall","overall" "1",NA,"overall","overall","overall","overall","settings",NA,"study","character","my_characterisation_study","overall","overall" "2",NA,"overall","overall","overall","overall","settings",NA,"result_type","character","overall_analysis","overall","overall" "2",NA,"overall","overall","overall","overall","settings",NA,"package_name","character","PatientProfiles","overall","overall" "2",NA,"overall","overall","overall","overall","settings",NA,"package_version","character","1.0.0","overall","overall" "2",NA,"overall","overall","overall","overall","settings",NA,"group","character","","overall","overall" "2",NA,"overall","overall","overall","overall","settings",NA,"strata","character","","overall","overall" "2",NA,"overall","overall","overall","overall","settings",NA,"additional","character","","overall","overall" "2",NA,"overall","overall","overall","overall","settings",NA,"min_cell_count","character","5","overall","overall" "2",NA,"overall","overall","overall","overall","settings",NA,"study","character","my_characterisation_study","overall","overall"

You can later import the results back with `[importSummarisedResult()](../reference/importSummarisedResult.html)`:
    
    
    res <- [importSummarisedResult](../reference/importSummarisedResult.html)(path = [file.path](https://rdrr.io/r/base/file.path.html)(x, "result.csv"))
    [class](https://rdrr.io/r/base/class.html)(res)
    #> [1] "summarised_result" "omop_result"       "tbl_df"           
    #> [4] "tbl"               "data.frame"
    res |>
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 2
    #> Columns: 13
    #> $ result_id        <int> 1, 2
    #> $ cdm_name         <chr> "my_cdm", "my_cdm"
    #> $ group_name       <chr> "cohort_name", "overall"
    #> $ group_level      <chr> "cohort1", "overall"
    #> $ strata_name      <chr> "sex", "overall"
    #> $ strata_level     <chr> "male", "overall"
    #> $ variable_name    <chr> "Age group", "overall"
    #> $ variable_level   <chr> "10 to 50", "overall"
    #> $ estimate_name    <chr> "count", "count"
    #> $ estimate_type    <chr> "numeric", "numeric"
    #> $ estimate_value   <chr> "5", "55"
    #> $ additional_name  <chr> "overall", "overall"
    #> $ additional_level <chr> "overall", "overall"
    res |>
      [settings](../reference/settings.html)()
    #> # A tibble: 2 × 9
    #>   result_id result_type     package_name package_version group strata additional
    #>       <int> <chr>           <chr>        <chr>           <chr> <chr>  <chr>     
    #> 1         1 stratified_by_… PatientProf… 1.0.0           "coh… "sex"  ""        
    #> 2         2 overall_analys… PatientProf… 1.0.0           ""    ""     ""        
    #> # ℹ 2 more variables: min_cell_count <chr>, study <chr>

## Tidy a `<summarised_result>`

### Tidy method

`ompgenerics` defines the method tidy for `<summarised_result>` object, what this function does is to:

#### 1\. Split _group_ , _strata_ , and _additional_ pairs into separate columns:

The `<summarised_result>` object has the following pair columns: group_name-group_level, strata_name-strata_level, and additional_name-additional_level. These pairs use the `&&&` separator to combine multiple fields, for example if you want to combine cohort_name and age_group in group_name-group_level pair: `group_name = "cohort_name &&& age_group"` and `group_level = "my_cohort &&& <40"`. By default if no aggregation is produced in group_name-group_level pair: `group_name = "overall"` and `group_level = "overall"`.

**ORIGINAL FORMAT:**

group_name | group_level  
---|---  
cohort_name | acetaminophen  
cohort_name &&& sex | acetaminophen &&& Female  
sex &&& age_group | Male &&& <40  
  
The tidy format puts each one of the values as a columns. Making it easier to manipulate but at the same time the output is not standardised anymore as each `<summarised_result>` object will have a different number and names of columns. Missing values will be filled with the “overall” label.

**TIDY FORMAT:**

cohort_name | sex | age_group  
---|---|---  
acetaminophen | overall | overall  
acetaminophen | Female | overall  
overall | Male | <40  
  
#### 2\. Add settings of the `<summarised_result>` object as columns:

Each `<summarised_result>` object has a setting attribute that relates the ‘result_id’ column with each different set of settings. The columns ‘result_type’, ‘package_name’ and ‘package_version’ are always present in settings, but then we may have some extra parameters depending how the object was created. So in the `<summarised_result>` format we need to use these `[settings()](../reference/settings.html)` functions to see those variables:

**ORIGINAL FORMAT:**

`settings`:

result_id | my_setting | package_name  
---|---|---  
1 | TRUE | omopgenerics  
2 | FALSE | omopgenerics  
  
`<summarised_result>`:

result_id | cdm_name |  | additional_name  
---|---|---|---  
1 | omop | ... | overall  
... | ... | ... | ...  
2 | omop | ... | overall  
... | ... | ... | ...  
  
But in the tidy format we add the settings as columns, making that their value is repeated multiple times (there is only one row per result_id in settings, whereas there can be multiple rows in the `<summarised_result>` object). The column ‘result_id’ is eliminated as it does not provide information anymore. Again we loose on standardisation (multiple different settings), but we gain in flexibility:

**TIDY FORMAT:**

cdm_name |  | additional_name | my_setting | package_name  
---|---|---|---|---  
omop | ... | overall | TRUE | omopgenerics  
... | ... | ... | ... | ...  
omop | ... | overall | FALSE | omopgenerics  
... | ... | ... | ... | ...  
  
#### 3\. Pivot estimates as columns:

In the `<summarised_result>` format estimates are displayed in 3 columns:

  * ‘estimate_name’ indicates the name of the estimate.
  * ‘estimate_type’ indicates the type of the estimate (as all of them will be casted to character). Possible values are: _numeric, integer, date, character, proportion, percentage, logical_.
  * ‘estimate_value’ value of the estimate as `<character>`.



**ORIGINAL FORMAT:**

variable_name | estimate_name | estimate_type | estimate_value  
---|---|---|---  
number individuals | count | integer | 100  
age | mean | numeric | 50.3  
age | sd | numeric | 20.7  
  
In the tidy format we pivot the estimates, creating a new column for each one of the ‘estimate_name’ values. The columns will be casted to ‘estimate_type’. If there are multiple estimate_type(s) for same estimate_name they won’t be casted and they will be displayed as character (a warning will be thrown). Missing data are populated with NAs.

**TIDY FORMAT:**

variable_name | count | mean | sd  
---|---|---|---  
number individuals | 100 | NA | NA  
age | NA | 50.3 | 20.7  
  
#### Example

Let’s see a simple example with some toy data:
    
    
    result |>
      [tidy](https://generics.r-lib.org/reference/tidy.html)()
    #> # A tibble: 2 × 7
    #>   cdm_name cohort_name sex     variable_name variable_level count study         
    #>   <chr>    <chr>       <chr>   <chr>         <chr>          <dbl> <chr>         
    #> 1 my_cdm   cohort1     male    Age group     10 to 50           5 my_characteri…
    #> 2 my_cdm   overall     overall overall       overall           55 my_characteri…

### Split

The functions split are provided independent:

  * `[splitGroup()](../reference/splitGroup.html)` only splits the pair group_name-group_level columns.
  * `[splitStrata()](../reference/splitStrata.html)` only splits the pair strata_name-strata_level columns.
  * `[splitAdditional()](../reference/splitAdditional.html)` only splits the pair additional_name-additional_level columns.



There is also the function: - `[splitAll()](../reference/splitAll.html)` that splits any pair x_name-x_level that is found on the data.
    
    
    [splitAll](../reference/splitAll.html)(result)
    #> # A tibble: 2 × 9
    #>   result_id cdm_name cohort_name sex     variable_name variable_level
    #>       <int> <chr>    <chr>       <chr>   <chr>         <chr>         
    #> 1         1 my_cdm   cohort1     male    Age group     10 to 50      
    #> 2         2 my_cdm   overall     overall overall       overall       
    #> # ℹ 3 more variables: estimate_name <chr>, estimate_type <chr>,
    #> #   estimate_value <chr>

### Pivot estimates

`[pivotEstimates()](../reference/pivotEstimates.html)` can be used to pivot the variables that we are interested in.

The argument `pivotEstimatesBy` specifies which are the variables that we want to use to pivot by, there are four options:

  * `NULL/character()` to not pivot anything.
  * `c("estimate_name")` to pivot only estimate_name.
  * `c("variable_level", "estimate_name")` to pivot estimate_name and variable_level.
  * `c("variable_name", "variable_level", "estimate_name")` to pivot estimate_name, variable_level and variable_name.



Note that `variable_level` can contain NA values, these will be ignored on the naming part.
    
    
    [pivotEstimates](../reference/pivotEstimates.html)(
      result,
      pivotEstimatesBy = [c](https://rdrr.io/r/base/c.html)("variable_name", "variable_level", "estimate_name")
    )
    #> # A tibble: 2 × 10
    #>   result_id cdm_name group_name  group_level strata_name strata_level
    #>       <int> <chr>    <chr>       <chr>       <chr>       <chr>       
    #> 1         1 my_cdm   cohort_name cohort1     sex         male        
    #> 2         2 my_cdm   overall     overall     overall     overall     
    #> # ℹ 4 more variables: additional_name <chr>, additional_level <chr>,
    #> #   `Age group_10 to 50_count` <dbl>, overall_overall_count <dbl>

### Add settings

`[addSettings()](../reference/addSettings.html)` is used to add the settings that we want as new columns to our `<summarised_result>` object.

The `settingsColumn` argument is used to choose which are the settings we want to add.
    
    
    [addSettings](../reference/addSettings.html)(
      result,
      settingsColumn = "result_type"
    )
    #> # A tibble: 2 × 14
    #>   result_id cdm_name group_name  group_level strata_name strata_level
    #>       <int> <chr>    <chr>       <chr>       <chr>       <chr>       
    #> 1         1 my_cdm   cohort_name cohort1     sex         male        
    #> 2         2 my_cdm   overall     overall     overall     overall     
    #> # ℹ 8 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>, result_type <chr>

### Filter

Dealing with an `<summarised_result>` object can be difficult to handle specially when we are trying to filter. For example, difficult tasks would be to filter to a certain result_type or when there are many strata joined together filter only one of the variables. On the other hand it exists the `tidy` format that makes it easy to filter, but then you loose the `<summarised_result>` object.

**omopgenerics** package contains some functionalities that helps on this process:

  * `filterSettings` to filter the `<summarised_result>` object using the `[settings()](../reference/settings.html)` attribute.
  * `filterGroup` to filter the `<summarised_result>` object using the group_name-group_level tidy columns.
  * `filterStrata` to filter the `<summarised_result>` object using the strata_name-starta_level tidy columns.
  * `filterAdditional` to filter the `<summarised_result>` object using the additional_name-additional_level tidy columns.



For instance, let’s filter `result` so it only has results for males:
    
    
    result |>
      [filterStrata](../reference/filterStrata.html)(sex == "male")
    #> # A tibble: 1 × 13
    #>   result_id cdm_name group_name  group_level strata_name strata_level
    #>       <int> <chr>    <chr>       <chr>       <chr>       <chr>       
    #> 1         1 my_cdm   cohort_name cohort1     sex         male        
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>

Now let’s see an example using the information on settings to filter the result. In this case, we only one results of the “overall_analysis”, since this information is in the result_type column in settings, we procees as follows:
    
    
    result |>
      [filterSettings](../reference/filterSettings.html)(result_type == "overall_analysis")
    #> # A tibble: 1 × 13
    #>   result_id cdm_name group_name group_level strata_name strata_level
    #>       <int> <chr>    <chr>      <chr>       <chr>       <chr>       
    #> 1         2 my_cdm   overall    overall     overall     overall     
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>

## Utility functions for `<summarised_result>`

### Column retrieval functions

Working with `<summarised_result>` objects often involves managing columns for **settings** , **grouping** , **strata** , and **additional** levels. These retrieval functions help you identify and manage columns:

  * `[settingsColumns()](../reference/settingsColumns.html)` gives you the setting names that are available in a `<summarised_result>` object.
  * `[groupColumns()](../reference/groupColumns.html)` gives you the new columns that will be generated when splitting group_name-group_level pair into different columns.
  * `[strataColumns()](../reference/strataColumns.html)` gives you the new columns that will be generated when splitting strata_name-strata_level pair into different columns.
  * `[additionalColumns()](../reference/additionalColumns.html)` gives you the new columns that will be generated when splitting additional_name-additional_level pair into different columns.
  * `[tidyColumns()](../reference/tidyColumns.html)` gives you the columns that will have the object if you tidy it (`tidy(result)`). This function in very useful to know which are the columns that can be included in **plot** and **table** functions.



Let’s see the different values with out example result data:
    
    
    [settingsColumns](../reference/settingsColumns.html)(result)
    #> [1] "study"
    [groupColumns](../reference/groupColumns.html)(result)
    #> [1] "cohort_name"
    [strataColumns](../reference/strataColumns.html)(result)
    #> [1] "sex"
    [additionalColumns](../reference/additionalColumns.html)(result)
    #> character(0)
    [tidyColumns](../reference/tidyColumns.html)(result)
    #> [1] "cdm_name"       "cohort_name"    "sex"            "variable_name" 
    #> [5] "variable_level" "count"          "study"

### Unite functions

The unite functions serve as the complementary tools to the split functions, allowing you to generate name-level pair columns from targeted columns within a `<dataframe>`.

There are three `unite` functions that allow to create group, strata, and additional name-level columns from specified sets of columns:

  * `[uniteAdditional()](../reference/uniteAdditional.html)`

  * `[uniteGroup()](../reference/uniteGroup.html)`

  * `[uniteStrata()](../reference/uniteStrata.html)`




#### Example

For example, to create group_name and group_level columns from a tibble, you can use:
    
    
    # Create and show mock data
    data <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      denominator_cohort_name = [c](https://rdrr.io/r/base/c.html)("general_population", "older_than_60", "younger_than_60"),
      outcome_cohort_name = [c](https://rdrr.io/r/base/c.html)("stroke", "stroke", "stroke")
    )
    [head](https://rdrr.io/r/utils/head.html)(data)
    #> # A tibble: 3 × 2
    #>   denominator_cohort_name outcome_cohort_name
    #>   <chr>                   <chr>              
    #> 1 general_population      stroke             
    #> 2 older_than_60           stroke             
    #> 3 younger_than_60         stroke
    
    # Unite into group name-level columns
    data |>
      [uniteGroup](../reference/uniteGroup.html)(cols = [c](https://rdrr.io/r/base/c.html)("denominator_cohort_name", "outcome_cohort_name"))
    #> # A tibble: 3 × 2
    #>   group_name                                      group_level                  
    #>   <chr>                                           <chr>                        
    #> 1 denominator_cohort_name &&& outcome_cohort_name general_population &&& stroke
    #> 2 denominator_cohort_name &&& outcome_cohort_name older_than_60 &&& stroke     
    #> 3 denominator_cohort_name &&& outcome_cohort_name younger_than_60 &&& stroke

These functions can be helpful when creating your own `<summarised_result>`.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/articles/suppression.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Suppression of a summarised_result obejct

Source: [`vignettes/suppression.Rmd`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/vignettes/suppression.Rmd)

`suppression.Rmd`

## Minimum cell count suppression

Minimum cell count suppression is very important in studies as it is essential step to ensure no reidentification. The min cell count suppression can vary source to source, but in general a minimum cell count of 5 is fixed. In this vignette we explain how the suppression process works for `summarised_result` objects.

### How suppression works

In general a record is suppressed if 3 conditions are met:

  1. The `estimate_name` field contains the word ‘count’ (e.g ‘count’, ‘outcome_count’, ‘count_of_individuals’, …).
  2. The `estimate_type` field is either _numeric_ or _integer_.
  3. The `estimate_value` numeric value is smaller than _minCellCount_ and bigger than 0.



This simple rule determines the suppression at record level. The suppressed record is not removed from the results, instead the `estimate_value` field is populated as ‘<{minCellCount}’.

Once one record is suppressed this can trigger suppression of other _linked_ estimates. This suppression is done at different level and affects different rows of the result object:

  * **Suppression at group level** : if in the suppressed estimate the field `variable_name` is populated with the word “number records” or “number subjects” (it is not case sensitive) then the whole group of records will be suppressed. Note a group of records is a set of rows with the same: `result_id`, `cdm_name`, `group_name`, `group_level`, `strata_name`, `strata_level`, `additional_name`, `additional_level`. This level of suppression is for example to suppress all the demographics of a cohort of individuals that has less than the minimum amount of records required. For developers note that creating a row with `variable_name` = “number records/subjects” can have a big impact on the suppression, but at the same point it gives you the ability to link a group of estimates and suppress all of them at the same point.

  * **Suppression at variable_name level** : if in the suppressed estimate the field `estimate_name` is populated with either “count”, “denominator_count”, “outcome_count”, “record_count” or “subject_count” then the suppression is done at the variable level, meaning that all the estimates with the same: `result_id`, `cdm_name`, `group_name`, `group_level`, `strata_name`, `strata_level`, `additional_name`, `additional_level` and `variable_name` will be suppressed. This level of suppression is for example to suppress the statistics associated with an outcome count for example, but not do not affect the different outcomes for example. For developers use one of this key words to link the estimates at the variable level.

  * **Suppression of percentages** : if an estimate is suppressed any estimate in the same level (same `result_id`, `cdm_name`, `group_name`, `group_level`, `strata_name`, `strata_level`, `additional_name`, `additional_level`, `variable_name` and `variable_level`) with the same estimate name but changing ‘count’ for ‘percentage’ (e.g. ‘event_count’ -> ‘event_percentage’) will be suppressed.




Note that linked estimate records will be suppressed as ‘-’.

You can view the source code for minimum cell suppression [here](https://github.com/darwin-eu/omopgenerics/blob/main/R/methodSuppress.R).

### Suppressing a summarised_result object

Once we have a summarised result, we can suppress the object based on a desired minimum cell count value using the [`suppress()`](https://darwin-eu.github.io/omopgenerics/reference/suppress.html) function.
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    result <- [newSummarisedResult](../reference/newSummarisedResult.html)(
      x = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        result_id = 1L,
        cdm_name = "my_cdm",
        group_name = "cohort_name",
        group_level = "cohort1",
        strata_name = "sex",
        strata_level = "male",
        variable_name = "Age group",
        variable_level = "10 to 50",
        estimate_name = "count",
        estimate_type = "numeric",
        estimate_value = "5",
        additional_name = "overall",
        additional_level = "overall"
      ),
      settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        result_id = 1L,
        package_name = "PatientProfiles",
        package_version = "1.0.0",
        study = "my_characterisation_study",
        result_type = "stratified_by_age_group"
      )
    )
    
    suppressedResult <- [suppress](../reference/suppress.html)(result = result, minCellCount = 7)

### Is a summarised_result object suppressed?

The minCellCount suppression is recorded in the settings of the object:
    
    
    [glimpse](https://pillar.r-lib.org/reference/glimpse.html)([settings](../reference/settings.html)(result))
    #> Rows: 1
    #> Columns: 9
    #> $ result_id       <int> 1
    #> $ result_type     <chr> "stratified_by_age_group"
    #> $ package_name    <chr> "PatientProfiles"
    #> $ package_version <chr> "1.0.0"
    #> $ group           <chr> "cohort_name"
    #> $ strata          <chr> "sex"
    #> $ additional      <chr> ""
    #> $ min_cell_count  <chr> "0"
    #> $ study           <chr> "my_characterisation_study"
    [glimpse](https://pillar.r-lib.org/reference/glimpse.html)([settings](../reference/settings.html)(suppressedResult))
    #> Rows: 1
    #> Columns: 9
    #> $ result_id       <int> 1
    #> $ result_type     <chr> "stratified_by_age_group"
    #> $ package_name    <chr> "PatientProfiles"
    #> $ package_version <chr> "1.0.0"
    #> $ group           <chr> "cohort_name"
    #> $ strata          <chr> "sex"
    #> $ additional      <chr> ""
    #> $ min_cell_count  <chr> "7"
    #> $ study           <chr> "my_characterisation_study"

As a result object can be partially suppressed (e.g. binding an object that has already been suppressed with another one that is not suppressed) and settings of results objects can be long we also have a utility function to check if an object has been suppressed or not, [`isResultSuppressed()`](https://darwin-eu.github.io/omopgenerics/reference/isResultSuppressed.html):
    
    
    [isResultSuppressed](../reference/isResultSuppressed.html)(result = result, minCellCount = 5)
    #> Warning: ✖ 1 set (1 row) not suppressed.
    #> [1] FALSE
    [isResultSuppressed](../reference/isResultSuppressed.html)(result = suppressedResult, minCellCount = 5)
    #> Warning: ! 1 set (1 row) suppressed with minCellCount > 5.
    #> [1] FALSE
    [isResultSuppressed](../reference/isResultSuppressed.html)(result = suppressedResult, minCellCount = 7)
    #> ✔ The <summarised_result> is suppressed with
    #> minCellCount = 7.
    #> [1] TRUE
    [isResultSuppressed](../reference/isResultSuppressed.html)(result = suppressedResult, minCellCount = 10)
    #> Warning: ✖ 1 set (1 row) suppressed with minCellCount < 10.
    #> [1] FALSE

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/articles/logging.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Logging with omopgenerics

Source: [`vignettes/logging.Rmd`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/vignettes/logging.Rmd)

`logging.Rmd`

## Logging

Logging is a common practice in studies, specially when sharing code. Logging can be useful to check timings or record error messages. There exist multiple packages in R that allow you to record these log messages. For example the `logger` package is quite useful.

### Logging with omopgenerics

`omopgenerics` does not want to replace any of these packages, we just provide simple functionality to log messages. In the future we might consider building this on top of one of the existing log packages, but for the moment we have these three simple functions:

  * `[createLogFile()](../reference/createLogFile.html)` It is used to create the log file.
  * `[logMessage()](../reference/logMessage.html)` It is used to record the messages that we want in the log file, note those messages will also be displayed in the console. If `logFile` does not exist the message is only displayed in the console.
  * `[summariseLogFile()](../reference/summariseLogFile.html)` It is used to read the log file and format it into a `summarised_result` object.



### Example

Let’s see a simple example of logging with omopgenerics:
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/), warn.conflicts = FALSE)
    
    # create the log file
    [createLogFile](../reference/createLogFile.html)(logFile = [tempfile](https://rdrr.io/r/base/tempfile.html)(pattern = "log_{date}_{time}"))
    #> ℹ Creating log file: /tmp/RtmpXsLQf9/log_2025_09_19_11_04_4327ae49b1949c.txt.
    #> [2025-09-19 11:04:43] - Log file created
    
    # study
    [logMessage](../reference/logMessage.html)("Generating random numbers")
    #> [2025-09-19 11:04:43] - Generating random numbers
    x <- [runif](https://rdrr.io/r/stats/Uniform.html)(1e6)
    
    [logMessage](../reference/logMessage.html)("Calculating the sum")
    #> [2025-09-19 11:04:43] - Calculating the sum
    result <- [sum](https://rdrr.io/r/base/sum.html)(x)
    
    # export logger to a `summarised_result`
    log <- [summariseLogFile](../reference/summariseLogFile.html)()
    #> [2025-09-19 11:04:43] - Exporting log file
    
    # content of the log file
    [readLines](https://rdrr.io/r/base/readLines.html)([getOption](https://rdrr.io/r/base/options.html)("omopgenerics.logFile")) |>
      [cat](https://rdrr.io/r/base/cat.html)(sep = "\n")
    #> [2025-09-19 11:04:43] - Log file created
    #> [2025-09-19 11:04:43] - Generating random numbers
    #> [2025-09-19 11:04:43] - Calculating the sum
    #> [2025-09-19 11:04:43] - Exporting log file
    
    # `summarised_result` object
    log
    #> # A tibble: 4 × 13
    #>   result_id cdm_name group_name group_level strata_name strata_level
    #>       <int> <chr>    <chr>      <chr>       <chr>       <chr>       
    #> 1         1 unknown  overall    overall     log_id      1           
    #> 2         1 unknown  overall    overall     log_id      2           
    #> 3         1 unknown  overall    overall     log_id      3           
    #> 4         1 unknown  overall    overall     log_id      4           
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    # `summarised_result` object settings
    [settings](../reference/settings.html)(log)
    #> # A tibble: 1 × 8
    #>   result_id result_type     package_name package_version group strata additional
    #>       <int> <chr>           <chr>        <chr>           <chr> <chr>  <chr>     
    #> 1         1 summarise_log_… omopgenerics 1.3.1           ""    log_id ""        
    #> # ℹ 1 more variable: min_cell_count <chr>
    
    # tidy version of the `summarised_result`
    [tidy](https://generics.r-lib.org/reference/tidy.html)(log)
    #> # A tibble: 4 × 5
    #>   cdm_name log_id variable_name             variable_level date_time          
    #>   <chr>    <chr>  <chr>                     <chr>          <chr>              
    #> 1 unknown  1      Log file created          NA             2025-09-19 11:04:43
    #> 2 unknown  2      Generating random numbers NA             2025-09-19 11:04:43
    #> 3 unknown  3      Calculating the sum       NA             2025-09-19 11:04:43
    #> 4 unknown  4      Exporting log file        NA             2025-09-19 11:04:43

Note that if the logFile is not created the `[logMessage()](../reference/logMessage.html)` function only displays the message in the console.

###  `exportSummarisedResult`

The `[exportSummarisedResult()](../reference/exportSummarisedResult.html)` exports by default the logger if there is one. See example code:
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([tidyr](https://tidyr.tidyverse.org), warn.conflicts = FALSE)
    
    # create the log file
    [createLogFile](../reference/createLogFile.html)(logFile = [tempfile](https://rdrr.io/r/base/tempfile.html)(pattern = "log_{date}_{time}"))
    #> ℹ Creating log file: /tmp/RtmpXsLQf9/log_2025_09_19_11_04_4427ae3d57aa1a.txt.
    #> [2025-09-19 11:04:44] - Log file created
    
    # start analysis
    [logMessage](../reference/logMessage.html)("Deffining toy data")
    #> [2025-09-19 11:04:44] - Deffining toy data
    n <- 1e5
    x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(person_id = [seq_len](https://rdrr.io/r/base/seq.html)(n), age = [rnorm](https://rdrr.io/r/stats/Normal.html)(n = n, mean = 55, sd = 20))
    
    [logMessage](../reference/logMessage.html)("Summarise toy data")
    #> [2025-09-19 11:04:44] - Summarise toy data
    res <- x |>
      [summarise](https://dplyr.tidyverse.org/reference/summarise.html)(
        `number subjects_count` = [n](https://dplyr.tidyverse.org/reference/context.html)(),
        `age_mean` = [mean](https://rdrr.io/r/base/mean.html)(age),
        `age_sd` = [sd](https://rdrr.io/r/stats/sd.html)(age),
        `age_median` = [median](https://rdrr.io/r/stats/median.html)(age),
        `age_q25` = [quantile](https://rdrr.io/r/stats/quantile.html)(age, 0.25),
        `age_q75` = [quantile](https://rdrr.io/r/stats/quantile.html)(age, 0.75)
      ) |>
      [pivot_longer](https://tidyr.tidyverse.org/reference/pivot_longer.html)(
        cols = [everything](https://tidyselect.r-lib.org/reference/everything.html)(), 
        names_to = [c](https://rdrr.io/r/base/c.html)("variable_name", "estimate_name"), 
        names_sep = "_",
        values_to = "estimate_value"
      ) |>
      [mutate](https://dplyr.tidyverse.org/reference/mutate.html)(
        result_id = 1L,
        cdm_name = "mock data",
        variable_level = NA_character_,
        estimate_type = [if_else](https://dplyr.tidyverse.org/reference/if_else.html)(estimate_name == "count", "integer", "numeric"),
        estimate_value = [as.character](https://rdrr.io/r/base/character.html)(estimate_value)
      ) |>
      [uniteGroup](../reference/uniteGroup.html)() |>
      [uniteStrata](../reference/uniteStrata.html)() |>
      [uniteAdditional](../reference/uniteAdditional.html)() |>
      [newSummarisedResult](../reference/newSummarisedResult.html)()
    #> `result_type`, `package_name`, and `package_version` added to
    #> settings.
    
    # res is a summarised_result object that we can export using the `exportSummarisedResult`
    tempDir <- [tempdir](https://rdrr.io/r/base/tempfile.html)()
    [exportSummarisedResult](../reference/exportSummarisedResult.html)(res, path = tempDir)
    #> [2025-09-19 11:04:44] - Exporting log file

`[exportSummarisedResult()](../reference/exportSummarisedResult.html)` also exported the log file, let’s see it. Let’s start importing the exported `summarised_result` object:
    
    
    result <- [importSummarisedResult](../reference/importSummarisedResult.html)(tempDir)
    #> Reading file: /tmp/RtmpXsLQf9/results_mock data_2025_09_19.csv.
    #> Converting to summarised_result:
    #> /tmp/RtmpXsLQf9/results_mock data_2025_09_19.csv.

We can see that the log file is exported see `result_type = "summarise_log_file"`:
    
    
    result |>
      [settings](../reference/settings.html)() |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 2
    #> Columns: 8
    #> $ result_id       <int> 1, 2
    #> $ result_type     <chr> "", "summarise_log_file"
    #> $ package_name    <chr> "", "omopgenerics"
    #> $ package_version <chr> "", "1.3.1"
    #> $ group           <chr> "", ""
    #> $ strata          <chr> "", "log_id"
    #> $ additional      <chr> "", ""
    #> $ min_cell_count  <chr> "5", "5"

The easiest way to explore the log is using the `[tidy()](https://generics.r-lib.org/reference/tidy.html)` version:
    
    
    result |>
      [filterSettings](../reference/filterSettings.html)(result_type == "summarise_log_file") |>
      [tidy](https://generics.r-lib.org/reference/tidy.html)()
    #> # A tibble: 4 × 5
    #>   cdm_name  log_id variable_name      variable_level date_time          
    #>   <chr>     <chr>  <chr>              <chr>          <chr>              
    #> 1 mock data 1      Log file created   NA             2025-09-19 11:04:44
    #> 2 mock data 2      Deffining toy data NA             2025-09-19 11:04:44
    #> 3 mock data 3      Summarise toy data NA             2025-09-19 11:04:44
    #> 4 mock data 4      Exporting log file NA             2025-09-19 11:04:44

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/articles/reexport.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Re-exporting functions from omopgnerics

Source: [`vignettes/reexport.Rmd`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/vignettes/reexport.Rmd)

`reexport.Rmd`

## Introduction

**omopgenerics** is a package that is meant to be invisible for the user and it should be only developer focused package. This means that the typical user of the omopverse packages should never need to import directly it. This means that the functions needed to be used by the user they need to be reexported in other packages.

## Methods

If a package defined an implementation for a desired method (attrition, settings, …), this function should be reexported there.

## CDM reference

If a package has a function to create a `cdm_reference` object, this package should re-export several functions.

  1. To access the `cdm_reference` attributes:


  * `[cdmSource()](../reference/cdmSource.html)`

  * `[cdmVersion()](../reference/cdmVersion.html)`

  * `[cdmName()](../reference/cdmName.html)`



  2. To access the `cdm_table` attributes:


  * `[tableSource()](../reference/tableSource.html)`

  * `[tableName()](../reference/tableName.html)`

  * `[cdmReference()](../reference/cdmReference.html)`



  3. To insert and drop tables using the cdm object:


  * `[insertTable()](../reference/insertTable.html)`

  * `[dropSourceTable()](../reference/dropSourceTable.html)`

  * `listSourceTable()`

  * `[readSourceTable()](../reference/readSourceTable.html)`



  4. Helpers to create appropriate cdm tables:


  * `[omopColumns()](../reference/omopColumns.html)`

  * `[omopTables()](../reference/omopTables.html)`

  * `[cohortColumns()](../reference/cohortColumns.html)`

  * `[cohortTables()](../reference/cohortTables.html)`

  * `[achillesColumns()](../reference/achillesColumns.html)`

  * `[achillesTables()](../reference/achillesTables.html)`




## Cohorts

If a package has a function to create a `cohort_table` object, this package should re-export the following functions:

  * `[settings()](../reference/settings.html)`

  * `[attrition()](../reference/attrition.html)`

  * `[cohortCount()](../reference/cohortCount.html)`

  * `[cohortCodelist()](../reference/cohortCodelist.html)`

  * `[bind()](../reference/bind.html)`




## Summarised result

If a package has a function to create an `summarised_result` object, this package should re-export the following functions:

  * `[suppress()](../reference/suppress.html)`

  * `[bind()](../reference/bind.html)`

  * `[settings()](../reference/settings.html)`

  * `[exportSummarisedResult()](../reference/exportSummarisedResult.html)`

  * `[importSummarisedResult()](../reference/importSummarisedResult.html)`

  * `[groupColumns()](../reference/groupColumns.html)`

  * `[strataColumns()](../reference/strataColumns.html)`

  * `[additionalColumns()](../reference/additionalColumns.html)`




## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/articles/expanding_omopgenerics.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Expanding omopgenerics

Source: [`vignettes/expanding_omopgenerics.Rmd`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/vignettes/expanding_omopgenerics.Rmd)

`expanding_omopgenerics.Rmd`

## Introduction

**omopgenerics** defines an `ecosystem` of methods and classes particularly the __class that can be expanded. Currently there are two packages that define cdm sources:

  * [omopgenerics](https://darwin-eu.github.io/omopgenerics/) defines the __source that defines the implementation of a ‘local’ (in memory) cdm source.
  * [CDMConnector](https://darwin-eu.github.io/CDMConnector/) defines the __source that defines a general implementation for _DBI_ connections.



In this vignette we explain how to expand the **omopgenerics** ecosystem defining more sources.

## The source object

First we need to define a function to create our source object: the source object must be an object (usually a list) that contains several attributes that will be used in the methods to fulfill their purpose. Finally we have to assign a class to our source and validate it with `[omopgenerics::newCdmSource()](../reference/newCdmSource.html)`. The function has an argument to assign a `sourceType` that must be a character vector that identifies the name of the source. This is what will be retrieved by the `[omopgenerics::sourceType()](../reference/sourceType.html)` function and it will be useful to identify how the source of the cdm_reference has been created.

Example how the creation of a new source would look like:
    
    
    myCustomSource <- function(argument1, argument2, ...) {
      # pre calculation and validation of arguments
      ...
      
      # create the source object
      obj <- [list](https://rdrr.io/r/base/list.html)(x = x, y = y, ...) # this way you would access the attributes like: obj$x
      # or
      obj <- [structure](https://rdrr.io/r/base/structure.html)(.Data = [list](https://rdrr.io/r/base/list.html)(), x = x, y = y, ...) # this you would access the attributes like: attr(obj, "x")
        
      # assign class
      [class](https://rdrr.io/r/base/class.html)(obj) <- "my_custom_source"
      
      # validation
      omopgenerics::[newCdmSource](../reference/newCdmSource.html)(src = obj, sourceType = "my_custom_type")
    }

If the first function that we create is `myCustomSource()` the validation with `[omopgenerics::newCdmSource()](../reference/newCdmSource.html)` will fail as inside the _methods_ are checked to be defined and work properly.

## Methods

You will need to write 4 to 7 methods for your new `<my_custom_source>`:

  * `insertTable` **required** To insert local data into your source.
  * `compute` **required** To compute a ‘query’ into a table in your source.
  * `listSourceTables` **required** To list the data present into your source.
  * `dropSourceTable` **required** To drop a table from your source.
  * `readSourceTable` **recommended** To read a table from your source.
  * `insertCdmTo` **recommended** To insert a cdm into your source.
  * `summary` **recommended** To summarise and report the properties of your source.



###  `insertTable`

**Purpose** : To insert a local table into your source object.

**Arguments** :

  * `cdm` The cdm argument will be your source object created with `myCustomSource()` function.
  * `name` The name to identify that table in your source.
  * `table` A local `<tibble>` to insert in your source.
  * `overwrite` (by default TRUE), whether to overwrite if the table exists in the database.
  * `temporary` (by default FALSE), whether the table must be temporary.



**Output** : The output of a insertTable must be a `cdm_table` so your function must at the end validate it with `omopgenerics::newCdmTable().`

Sketch of how the function should look like:
    
    
    #' @export
    #' @importFrom omopgenerics insertTable
    insertTable.my_custom_source <- function(cdm, name, table, overwrite, temporary) {
      # code to insert the table into your source
      x <- "...." # it must be a reference to your table
      
      # validate output
      omopgenerics::[newCdmTable](../reference/newCdmTable.html)(table = x, src = cdm, name = name)
    }

###  `listSourceTables`

**Purpose** : To list tables that are present in the source.

**Arguments** :

  * `cdm` The cdm argument will be your source object created with `myCustomSource()` function.



**Output** : A character vector with the names of tables present in source, empty identifiers `""` will be eliminated by `omopgenerics`.

Sketch of how the function should look like:
    
    
    #' @export
    #' @importFrom omopgenerics listSourceTables
    listSourceTables.my_custom_source <- function(cdm) {
      # code to list the tables present in source (cdm)
      x <- "...."
      
      [return](https://rdrr.io/r/base/function.html)(x)
    }

###  `readSourceTable`

**Purpose** : To read tables that are present in the source.

**Arguments** :

  * `cdm` The cdm argument will be your source object created with `myCustomSource()` function.
  * `name` Name to identify the table in your source.



**Output** : The output of a readSourceTable must be a `cdm_table` so your function must at the end validate it with `omopgenerics::newCdmTable().`

Sketch of how the function should look like:
    
    
    #' @export
    #' @importFrom omopgenerics readSourceTable
    readSourceTable.my_custom_source <- function(cdm, name) {
      # code to read the table 'name' from source.
      x <- "...."
      
      # validate as cdm_table
      omopgenerics::[newCdmTable](../reference/newCdmTable.html)(table = x, src = cdm, name = name)
    }

###  `dropSourceTable`

**Purpose** : To drop a table from your source.

**Arguments** :

  * `cdm` The cdm argument will be your source object created with `myCustomSource()` function.
  * `name` Name identifier for the table that you want to drop.



**Output** : The output is ignored, would recommend to return the source.

Sketch of how the function should look like:
    
    
    #' @export
    #' @importFrom omopgenerics dropSourceTable
    dropSourceTable.my_custom_source <- function(cdm, name) {
      # code to drop the table `name` present in source (cdm)
      
      [return](https://rdrr.io/r/base/function.html)([invisible](https://rdrr.io/r/base/invisible.html)(cdm))
    }

###  `insertCdmTo`

**Purpose** : To insert a cdm to your source.

**Arguments** :

  * `cdm` A cdm reference from a different source. Recommend to collect each table before inserting.
  * `to` The ‘to’ argument will be your source object created with `myCustomSource()` function.



**Output** : The output should be the cdm reference object inserted in your `to` source.

Sketch of how the function should look like:
    
    
    #' @export
    #' @importFrom omopgenerics dropSourceTable
    insertCdmTo.my_custom_source <- function(cdm, to) {
      # example of how it can look like:
      tables <- [names](https://rdrr.io/r/base/names.html)(cdm) |>
        rlang::[set_names](https://rlang.r-lib.org/reference/set_names.html)() |>
        purrr::[map](https://purrr.tidyverse.org/reference/map.html)(\(x) omopgenerics::[insertTable](../reference/insertTable.html)(cdm = to, name = x, table = dplyr::[as_tibble](https://tibble.tidyverse.org/reference/as_tibble.html)(cdm[[x]])))
      
      omopgenerics::[newCdmReference](../reference/newCdmReference.html)(
        tables = tables, 
        cdmName = omopgenerics::[cdmName](../reference/cdmName.html)(x = cdm), 
        cdmVersion = omopgenerics::[cdmVersion](../reference/cdmVersion.html)(x = cdm)
      )
    }

The content of the function can vary depending of your source.

###  `summary`

**Purpose** : To summarise the metadata of your source object.

**Arguments** :

  * `object` The ‘object’ argument will be your source object created with `myCustomSource()` function.
  * `...` For consistency.



**Output** : A named list of metadata of the source, each element must be a string of length 1.

Sketch of how the function should look like:
    
    
    #' @export
    summary.my_custom_source <- function(object, ...) {
      # extract metadata
      metadata1 <- "..."
      metadata2 <- "..."
      metadata3 <- "..."
      
      [list](https://rdrr.io/r/base/list.html)(metadata1 = metadata1, metadata2 = metadata2, metadata3 = metadata3)
    }

###  `compute`

This function works slightly different to the rest the input it will be a query instead of the source object.

**Purpose** : To compute a table into a permanent placeholder in your source.

**Arguments** :

  * `x` Query to compute.
  * `name` The name to identify the resultant table in your source.
  * `temporary` (by default FALSE), whether the table must be temporary.
  * `overwrite` (by default TRUE), whether to overwrite if the table exists in the database.
  * `...` For consistency.



**Output** : The output of a compute must be a reference to your table in your source data, it will be converted later to a cdm_table (but you do not have to worry about that).

Sketch of how the function should look like:
    
    
    #' @export
    #' @importFrom dplyr compute
    compute.my_custom_source <- function(x, name, overwrite, temporary, ...) {
      # code to compute the table into your source
      x <- "...." # it must be a reference to your table
      [return](https://rdrr.io/r/base/function.html)(x)
    }

## The cdm reference object

Finally every `<cdm_source>` class object would also need a function to create a __to do that you just have to read all the tables that you want to include in your cdm object.**tables** must be a list of __with the same source.
    
    
    cdmFromMyCustomSource <- function(argument1, argument2, ...) {
      # read and prepare the cdm tables
      ...
      
      # return the cdm object
      omopgenerics::[newCdmReference](../reference/newCdmReference.html)(
        tables = tables, # list of cdm and achilles standard tables
        cdmName = "...", # usually provided as input, but also you might want to search in the cdm_source
        cdmVersion = "..." # either "5.3" or "5.4"
      )
    }

If you want to add __to your object do it after the initial cdm creation like:
    
    
    # read from source 
    cdm <- [readSourceTable](../reference/readSourceTable.html)(cdm = cdm, name = "my_cohort")
    
    # or insert from local
    cdm <- [insertTable](../reference/insertTable.html)(cdm = cdm, name = "my_cohort", table = localCohort)
    cdm$my_cohort <- cdm$my_cohort |>
      [newCohortTable](../reference/newCohortTable.html)(
        cohortSetRef = cohort_set, # table with the settings of the cohort_table
        cohortAttritionRef = cohort_attrition, # table with the attrition of the cohort_table
        cohortCodelistRef = cohort_codelist # table with the codelists of the cohort_table
      )

This step can be included in your cdm object creation if you wish:
    
    
    cdmFromMyCustomSource <- function(argument1, argument2, ..., cohortTables) {
      # read and prepare the cdm tables
      ...
      
      # return the cdm object
      cdm <- omopgenerics::[newCdmReference](../reference/newCdmReference.html)(
        tables = tables, # list of cdm and achilles standard tables
        cdmName = "...", # usually provided as input, but also you might want to search in the cdm_source
        cdmVersion = "..." # either "5.3" or "5.4"
      )
      
      # read cohort tables
      [readSourceTable](../reference/readSourceTable.html)(cdm = cdm, name = cohortTables)
    }

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/news/index.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Changelog

Source: [`NEWS.md`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/NEWS.md)

## omopgenerics 1.3.1

CRAN release: 2025-09-18

  * The time a query takes to copute is included in log file by [@edward-burn](https://github.com/edward-burn) in [#737](https://github.com/darwin-eu/omopgenerics/issues/737)
  * Create emptyConceptSetExpression function by [@edward-burn](https://github.com/edward-burn) [#735](https://github.com/darwin-eu/omopgenerics/issues/735)
  * Empty codelist has class codelist by [@edward-burn](https://github.com/edward-burn) in [#734](https://github.com/darwin-eu/omopgenerics/issues/734)
  * Correct typo for condition_era_id by [@catalamarti](https://github.com/catalamarti) in [#727](https://github.com/darwin-eu/omopgenerics/issues/727)
  * Add … argument to insertTable by [@catalamarti](https://github.com/catalamarti) in [#725](https://github.com/darwin-eu/omopgenerics/issues/725)
  * observation_period and person are no longer required in the cdm object [@catalamarti](https://github.com/catalamarti) [#746](https://github.com/darwin-eu/omopgenerics/issues/746)
  * Create function `[omopDataFolder()](../reference/omopDataFolder.html)` for the management of OMOP related data [@catalamarti](https://github.com/catalamarti) [#747](https://github.com/darwin-eu/omopgenerics/issues/747)
  * Remove `tictoc` from suggests and use base R by [@catalamarti](https://github.com/catalamarti) [#748](https://github.com/darwin-eu/omopgenerics/issues/748)
  * Support end and start date for table payer_plan_period by [@catalamarti](https://github.com/catalamarti) [#749](https://github.com/darwin-eu/omopgenerics/issues/749)
  * validate cohortId in recordCohortAttrition by [@catalamarti](https://github.com/catalamarti) [#750](https://github.com/darwin-eu/omopgenerics/issues/750)
  * Add separate vignette for suppression by [@catalamarti](https://github.com/catalamarti) [#751](https://github.com/darwin-eu/omopgenerics/issues/751)
  * Depend on dbplyr 2.5.1 to be able to use the new translations of clock by [@catalamarti](https://github.com/catalamarti) [#754](https://github.com/darwin-eu/omopgenerics/issues/754)
  * Add methods to support local datasets by [@catalamarti](https://github.com/catalamarti) in [#757](https://github.com/darwin-eu/omopgenerics/issues/757)
  * Cast columns for local cdms by [@catalamarti](https://github.com/catalamarti) [#758](https://github.com/darwin-eu/omopgenerics/issues/758)



## omopgenerics 1.3.0

CRAN release: 2025-07-15

  * write method fro summary.cdm_source by [@catalamarti](https://github.com/catalamarti) in [#719](https://github.com/darwin-eu/omopgenerics/issues/719) [#720](https://github.com/darwin-eu/omopgenerics/issues/720)
  * Add query id in logging files by [@catalamarti](https://github.com/catalamarti) in [#716](https://github.com/darwin-eu/omopgenerics/issues/716)
  * Expanding omopgenerics vignette by [@catalamarti](https://github.com/catalamarti) in [#721](https://github.com/darwin-eu/omopgenerics/issues/721)
  * Indexes experimental functions by [@catalamarti](https://github.com/catalamarti) in [#722](https://github.com/darwin-eu/omopgenerics/issues/722) [#723](https://github.com/darwin-eu/omopgenerics/issues/723) [#724](https://github.com/darwin-eu/omopgenerics/issues/724)



## omopgenerics 1.2.0

CRAN release: 2025-05-19

  * Remove NA in estimates in transformToSummarisedResult by [@catalamarti](https://github.com/catalamarti) in [#702](https://github.com/darwin-eu/omopgenerics/issues/702)
  * Create logging functions by [@catalamarti](https://github.com/catalamarti) in [#700](https://github.com/darwin-eu/omopgenerics/issues/700)
  * Allow strata to be a character by [@catalamarti](https://github.com/catalamarti) in [#703](https://github.com/darwin-eu/omopgenerics/issues/703)
  * Remove settings that are NA after filterSettings by [@catalamarti](https://github.com/catalamarti) in [#704](https://github.com/darwin-eu/omopgenerics/issues/704)
  * `validateWindowArgument` force snake_case names by [@catalamarti](https://github.com/catalamarti) in [#711](https://github.com/darwin-eu/omopgenerics/issues/711)
  * Keep cohort_table class after collect by [@catalamarti](https://github.com/catalamarti) in [#710](https://github.com/darwin-eu/omopgenerics/issues/710)
  * `[dplyr::as_tibble](https://tibble.tidyverse.org/reference/as_tibble.html)` for codelist by [@catalamarti](https://github.com/catalamarti) in [#712](https://github.com/darwin-eu/omopgenerics/issues/712)
  * `type` -> `codelist_type` by [@catalamarti](https://github.com/catalamarti) in [#709](https://github.com/darwin-eu/omopgenerics/issues/709)



## omopgenerics 1.1.1

CRAN release: 2025-03-16

  * more general validation for cohorts by [@edward-burn](https://github.com/edward-burn) in [#692](https://github.com/darwin-eu/omopgenerics/issues/692)
  * change `grepl` to `[stringr::str_detect](https://stringr.tidyverse.org/reference/str_detect.html)` by [@catalamarti](https://github.com/catalamarti) in [#689](https://github.com/darwin-eu/omopgenerics/issues/689)
  * allow `[readr::guess_encoding](https://readr.tidyverse.org/reference/encoding.html)` to fail and default configuration by [@catalamarti](https://github.com/catalamarti) in [#685](https://github.com/darwin-eu/omopgenerics/issues/685)
  * keep codelist class when subsetting by [@catalamarti](https://github.com/catalamarti) in [#693](https://github.com/darwin-eu/omopgenerics/issues/693)
  * export summarised_results always as utf8 by [@catalamarti](https://github.com/catalamarti) in [#690](https://github.com/darwin-eu/omopgenerics/issues/690)
  * add option checkPermanentTable to `validateCohortArgument` by [@catalamarti](https://github.com/catalamarti) in [#694](https://github.com/darwin-eu/omopgenerics/issues/694)



## omopgenerics 1.1.0

CRAN release: 2025-02-25

  * more general cdm validation checks by [@edward-burn](https://github.com/edward-burn) in [#674](https://github.com/darwin-eu/omopgenerics/issues/674)
  * typo in validateConceptSet by [@catalamarti](https://github.com/catalamarti) in [#673](https://github.com/darwin-eu/omopgenerics/issues/673)
  * fix call argument by [@catalamarti](https://github.com/catalamarti) in [#677](https://github.com/darwin-eu/omopgenerics/issues/677)
  * fix tempdir(“…”) by [@catalamarti](https://github.com/catalamarti) in [#679](https://github.com/darwin-eu/omopgenerics/issues/679)
  * new function transformToSummarisedResult by [@catalamarti](https://github.com/catalamarti) in [#676](https://github.com/darwin-eu/omopgenerics/issues/676)



## omopgenerics 1.0.0

CRAN release: 2025-02-14

  * Stable release of the package.
  * Added a `NEWS.md` file to track changes to the package.



## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/omopTables.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Standard tables that a cdm reference can contain in the OMOP Common Data Model.

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`omopTables.Rd`

Standard tables that a cdm reference can contain in the OMOP Common Data Model.

## Usage
    
    
    omopTables(version = "5.3")

## Arguments

version
    

Version of the OMOP Common Data Model.

## Value

Standard tables

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    omopTables()
    #>  [1] "person"                "observation_period"    "visit_occurrence"     
    #>  [4] "visit_detail"          "condition_occurrence"  "drug_exposure"        
    #>  [7] "procedure_occurrence"  "device_exposure"       "measurement"          
    #> [10] "observation"           "death"                 "note"                 
    #> [13] "note_nlp"              "specimen"              "fact_relationship"    
    #> [16] "location"              "care_site"             "provider"             
    #> [19] "payer_plan_period"     "cost"                  "drug_era"             
    #> [22] "dose_era"              "condition_era"         "metadata"             
    #> [25] "cdm_source"            "concept"               "vocabulary"           
    #> [28] "domain"                "concept_class"         "concept_relationship" 
    #> [31] "relationship"          "concept_synonym"       "concept_ancestor"     
    #> [34] "source_to_concept_map" "drug_strength"         "cohort_definition"    
    #> [37] "attribute_definition"  "concept_recommended"  
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/omopColumns.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Required columns that the standard tables in the OMOP Common Data Model must have.

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`omopColumns.Rd`

Required columns that the standard tables in the OMOP Common Data Model must have.

## Usage
    
    
    omopColumns(
      table,
      field = NULL,
      version = "5.3",
      onlyRequired = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)()
    )

## Arguments

table
    

Table to see required columns.

field
    

Name of the specific field.

version
    

Version of the OMOP Common Data Model.

onlyRequired
    

deprecated

## Value

Character vector with the column names

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    omopColumns("person")
    #>  [1] "person_id"                   "gender_concept_id"          
    #>  [3] "year_of_birth"               "month_of_birth"             
    #>  [5] "day_of_birth"                "birth_datetime"             
    #>  [7] "race_concept_id"             "ethnicity_concept_id"       
    #>  [9] "location_id"                 "provider_id"                
    #> [11] "care_site_id"                "person_source_value"        
    #> [13] "gender_source_value"         "gender_source_concept_id"   
    #> [15] "race_source_value"           "race_source_concept_id"     
    #> [17] "ethnicity_source_value"      "ethnicity_source_concept_id"
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/cohortTables.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Cohort tables that a cdm reference can contain in the OMOP Common Data Model.

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`cohortTables.Rd`

Cohort tables that a cdm reference can contain in the OMOP Common Data Model.

## Usage
    
    
    cohortTables(version = "5.3")

## Arguments

version
    

Version of the OMOP Common Data Model.

## Value

cohort tables

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    cohortTables()
    #> [1] "cohort"           "cohort_set"       "cohort_attrition" "cohort_codelist" 
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/cohortColumns.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Required columns for a generated cohort set.

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`cohortColumns.Rd`

Required columns for a generated cohort set.

## Usage
    
    
    cohortColumns(table, version = "5.3")

## Arguments

table
    

Either `cohort`, `cohort_set` or `cohort_attrition`

version
    

Version of the OMOP Common Data Model.

## Value

Character vector with the column names

Required columns

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    cohortColumns("cohort")
    #> [1] "cohort_definition_id" "subject_id"           "cohort_start_date"   
    #> [4] "cohort_end_date"     
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/achillesTables.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Names of the tables that contain the results of achilles analyses

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`achillesTables.Rd`

Names of the tables that contain the results of achilles analyses

## Usage
    
    
    achillesTables(version = "5.3")

## Arguments

version
    

Version of the OMOP Common Data Model.

## Value

Names of the tables that are contain the results from the achilles analyses

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    achillesTables()
    #> [1] "achilles_analysis"     "achilles_results"      "achilles_results_dist"
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/achillesColumns.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Required columns for each of the achilles result tables

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`achillesColumns.Rd`

Required columns for each of the achilles result tables

## Usage
    
    
    achillesColumns(table, version = "5.3", onlyRequired = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)())

## Arguments

table
    

Table for which to see the required columns. One of "achilles_analysis", "achilles_results", or "achilles_results_dist".

version
    

Version of the OMOP Common Data Model.

onlyRequired
    

deprecated.

## Value

Character vector with the column names

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    achillesColumns("achilles_analysis")
    #> [1] "analysis_id"    "analysis_name"  "stratum_1_name" "stratum_2_name"
    #> [5] "stratum_3_name" "stratum_4_name" "stratum_5_name" "is_default"    
    #> [9] "category"      
    achillesColumns("achilles_results")
    #> [1] "analysis_id" "stratum_1"   "stratum_2"   "stratum_3"   "stratum_4"  
    #> [6] "stratum_5"   "count_value"
    achillesColumns("achilles_results_dist")
    #>  [1] "analysis_id"  "stratum_1"    "stratum_2"    "stratum_3"    "stratum_4"   
    #>  [6] "stratum_5"    "count_value"  "min_value"    "max_value"    "avg_value"   
    #> [11] "stdev_value"  "median_value" "p10_value"    "p25_value"    "p75_value"   
    #> [16] "p90_value"   
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/newCodelist.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# 'codelist' object constructor

Source: [`R/classCodelist.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCodelist.R)

`newCodelist.Rd`

'codelist' object constructor

## Usage
    
    
    newCodelist(x)

## Arguments

x
    

A named list where each element contains a vector of concept IDs.

## Value

A codelist object.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/newConceptSetExpression.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# 'concept_set_expression' object constructor

Source: [`R/classConceptSetExpression.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classConceptSetExpression.R)

`newConceptSetExpression.Rd`

'concept_set_expression' object constructor

## Usage
    
    
    newConceptSetExpression(x)

## Arguments

x
    

a named list of tibbles, each of which containing concept set definitions

## Value

A concept_set_expression

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/cdmFromTables.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Create a cdm object from local tables

Source: [`R/cdmFromTables.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/cdmFromTables.R)

`cdmFromTables.Rd`

Create a cdm object from local tables

## Usage
    
    
    cdmFromTables(tables, cdmName, cohortTables = [list](https://rdrr.io/r/base/list.html)(), cdmVersion = NULL)

## Arguments

tables
    

List of tables to be part of the cdm object.

cdmName
    

Name of the cdm object.

cohortTables
    

List of tables that contains cohort, cohort_set and cohort_attrition can be provided as attributes.

cdmVersion
    

Version of the cdm_reference

## Value

A `cdm_reference` object.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    person <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = 1, person_id = 1,
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
      period_type_concept_id = 0
    )
    cdm <- cdmFromTables(
      tables = [list](https://rdrr.io/r/base/list.html)("person" = person, "observation_period" = observation_period),
      cdmName = "test"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 3 casted column in observation_period as do not match expected column type:
    #> • `observation_period_id` from numeric to integer
    #> • `person_id` from numeric to integer
    #> • `period_type_concept_id` from numeric to integer
    # }
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/newCohortTable.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# `cohort_table` objects constructor.

Source: [`R/classCohortTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCohortTable.R)

`newCohortTable.Rd`

`cohort_table` objects constructor.

## Usage
    
    
    newCohortTable(
      table,
      cohortSetRef = [attr](https://rdrr.io/r/base/attr.html)(table, "cohort_set"),
      cohortAttritionRef = [attr](https://rdrr.io/r/base/attr.html)(table, "cohort_attrition"),
      cohortCodelistRef = [attr](https://rdrr.io/r/base/attr.html)(table, "cohort_codelist"),
      .softValidation = FALSE
    )

## Arguments

table
    

cdm_table object with at least: cohort_definition_id, subject_id, cohort_start_date, cohort_end_date.

cohortSetRef
    

Table with at least: cohort_definition_id, cohort_name

cohortAttritionRef
    

Table with at least: cohort_definition_id, number_subjects, number_records, reason_id, reason, excluded_subjects, excluded_records.

cohortCodelistRef
    

Table with at least: cohort_definition_id, codelist_name, concept_id and codelist_type.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE four additional checks will be performed: 1) a check that cohort end date is not before cohort start date, 2) a check that there are no missing values in required columns, 3) a check that cohort duration is all within observation period, and 4) that there are no overlapping cohort entries

## Value

A cohort_table object

## Examples
    
    
    person <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = 1, person_id = 1,
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
      period_type_concept_id = 0
    )
    cohort1 <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1, subject_id = 1,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-01"),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-10")
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = person,
        "observation_period" = observation_period,
        "cohort1" = cohort1
      ),
      cdmName = "test"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 3 casted column in observation_period as do not match expected column type:
    #> • `observation_period_id` from numeric to integer
    #> • `person_id` from numeric to integer
    #> • `period_type_concept_id` from numeric to integer
    cdm
    #> 
    #> ── # OMOP CDM reference (local) of test ────────────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: cohort1
    cdm$cohort1 <- newCohortTable(table = cdm$cohort1)
    #> Warning: ! 2 casted column in cohort1 as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> • `subject_id` from numeric to integer
    cdm
    #> 
    #> ── # OMOP CDM reference (local) of test ────────────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: cohort1
    #> • achilles tables: -
    #> • other tables: -
    [settings](settings.html)(cdm$cohort1)
    #> # A tibble: 1 × 2
    #>   cohort_definition_id cohort_name
    #>                  <int> <chr>      
    #> 1                    1 cohort_1   
    [attrition](attrition.html)(cdm$cohort1)
    #> # A tibble: 1 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1              1               1         1 Initial qualify…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    [cohortCount](cohortCount.html)(cdm$cohort1)
    #> # A tibble: 1 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1              1               1
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/settings.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get settings from an object.

Source: [`R/methodSettings.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodSettings.R)

`settings.Rd`

Get settings from an object.

## Usage
    
    
    settings(x)

## Arguments

x
    

Object

## Value

A table with the settings of the object.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/attrition.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get attrition from an object.

Source: [`R/methodAttrition.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodAttrition.R)

`attrition.Rd`

Get attrition from an object.

## Usage
    
    
    attrition(x)

## Arguments

x
    

An object for which to get an attrition summary.

## Value

A table with the attrition.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/cohortCount.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get cohort counts from a cohort_table object.

Source: [`R/cohortCount.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/cohortCount.R)

`cohortCount.Rd`

Get cohort counts from a cohort_table object.

## Usage
    
    
    cohortCount(cohort)

## Arguments

cohort
    

A cohort_table object.

## Value

A table with the counts.

## Examples
    
    
     # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    person <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = 1, person_id = 1,
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
      period_type_concept_id = 0
    )
    cohort <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = [c](https://rdrr.io/r/base/c.html)(1, 1, 1, 2),
      subject_id = 1,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)(
        "2020-01-01", "2021-01-01", "2022-01-01", "2022-01-01"
      )),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)(
        "2020-01-01", "2021-01-01", "2022-01-01", "2022-01-01"
      )),
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)("person" = person, "observation_period" = observation_period),
      cdmName = "my_example_cdm",
      cohortTables = [list](https://rdrr.io/r/base/list.html)("cohort1" = cohort)
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 3 casted column in observation_period as do not match expected column type:
    #> • `observation_period_id` from numeric to integer
    #> • `person_id` from numeric to integer
    #> • `period_type_concept_id` from numeric to integer
    #> Warning: ! 2 casted column in cohort1 as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> • `subject_id` from numeric to integer
    
    cohortCount(cdm$cohort1)
    #> # A tibble: 2 × 3
    #>   cohort_definition_id number_records number_subjects
    #>                  <int>          <int>           <int>
    #> 1                    1              3               1
    #> 2                    2              1               1
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/LICENSE.html

Skip to contents

[omopgenerics](index.html) 1.3.1

  * [Reference](reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](articles/cdm_reference.html)
    * [Concept sets](articles/codelists.html)
    * [Cohort tables](articles/cohorts.html)
    * [A summarised result](articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](articles/suppression.html)
    * [Logging with omopgenerics](articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](articles/reexport.html)
    * [Expanding omopgenerics](articles/expanding_omopgenerics.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Apache License

Source: [`LICENSE.md`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/LICENSE.md)

_Version 2.0, January 2004_ _<<http://www.apache.org/licenses/>>_

### Terms and Conditions for use, reproduction, and distribution

#### 1\. Definitions

“License” shall mean the terms and conditions for use, reproduction, and distribution as defined by Sections 1 through 9 of this document.

“Licensor” shall mean the copyright owner or entity authorized by the copyright owner that is granting the License.

“Legal Entity” shall mean the union of the acting entity and all other entities that control, are controlled by, or are under common control with that entity. For the purposes of this definition, “control” means **(i)** the power, direct or indirect, to cause the direction or management of such entity, whether by contract or otherwise, or **(ii)** ownership of fifty percent (50%) or more of the outstanding shares, or **(iii)** beneficial ownership of such entity.

“You” (or “Your”) shall mean an individual or Legal Entity exercising permissions granted by this License.

“Source” form shall mean the preferred form for making modifications, including but not limited to software source code, documentation source, and configuration files.

“Object” form shall mean any form resulting from mechanical transformation or translation of a Source form, including but not limited to compiled object code, generated documentation, and conversions to other media types.

“Work” shall mean the work of authorship, whether in Source or Object form, made available under the License, as indicated by a copyright notice that is included in or attached to the work (an example is provided in the Appendix below).

“Derivative Works” shall mean any work, whether in Source or Object form, that is based on (or derived from) the Work and for which the editorial revisions, annotations, elaborations, or other modifications represent, as a whole, an original work of authorship. For the purposes of this License, Derivative Works shall not include works that remain separable from, or merely link (or bind by name) to the interfaces of, the Work and Derivative Works thereof.

“Contribution” shall mean any work of authorship, including the original version of the Work and any modifications or additions to that Work or Derivative Works thereof, that is intentionally submitted to Licensor for inclusion in the Work by the copyright owner or by an individual or Legal Entity authorized to submit on behalf of the copyright owner. For the purposes of this definition, “submitted” means any form of electronic, verbal, or written communication sent to the Licensor or its representatives, including but not limited to communication on electronic mailing lists, source code control systems, and issue tracking systems that are managed by, or on behalf of, the Licensor for the purpose of discussing and improving the Work, but excluding communication that is conspicuously marked or otherwise designated in writing by the copyright owner as “Not a Contribution.”

“Contributor” shall mean Licensor and any individual or Legal Entity on behalf of whom a Contribution has been received by Licensor and subsequently incorporated within the Work.

#### 2\. Grant of Copyright License

Subject to the terms and conditions of this License, each Contributor hereby grants to You a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable copyright license to reproduce, prepare Derivative Works of, publicly display, publicly perform, sublicense, and distribute the Work and such Derivative Works in Source or Object form.

#### 3\. Grant of Patent License

Subject to the terms and conditions of this License, each Contributor hereby grants to You a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable (except as stated in this section) patent license to make, have made, use, offer to sell, sell, import, and otherwise transfer the Work, where such license applies only to those patent claims licensable by such Contributor that are necessarily infringed by their Contribution(s) alone or by combination of their Contribution(s) with the Work to which such Contribution(s) was submitted. If You institute patent litigation against any entity (including a cross-claim or counterclaim in a lawsuit) alleging that the Work or a Contribution incorporated within the Work constitutes direct or contributory patent infringement, then any patent licenses granted to You under this License for that Work shall terminate as of the date such litigation is filed.

#### 4\. Redistribution

You may reproduce and distribute copies of the Work or Derivative Works thereof in any medium, with or without modifications, and in Source or Object form, provided that You meet the following conditions:

  * **(a)** You must give any other recipients of the Work or Derivative Works a copy of this License; and
  * **(b)** You must cause any modified files to carry prominent notices stating that You changed the files; and
  * **(c)** You must retain, in the Source form of any Derivative Works that You distribute, all copyright, patent, trademark, and attribution notices from the Source form of the Work, excluding those notices that do not pertain to any part of the Derivative Works; and
  * **(d)** If the Work includes a “NOTICE” text file as part of its distribution, then any Derivative Works that You distribute must include a readable copy of the attribution notices contained within such NOTICE file, excluding those notices that do not pertain to any part of the Derivative Works, in at least one of the following places: within a NOTICE text file distributed as part of the Derivative Works; within the Source form or documentation, if provided along with the Derivative Works; or, within a display generated by the Derivative Works, if and wherever such third-party notices normally appear. The contents of the NOTICE file are for informational purposes only and do not modify the License. You may add Your own attribution notices within Derivative Works that You distribute, alongside or as an addendum to the NOTICE text from the Work, provided that such additional attribution notices cannot be construed as modifying the License.



You may add Your own copyright statement to Your modifications and may provide additional or different license terms and conditions for use, reproduction, or distribution of Your modifications, or for any such Derivative Works as a whole, provided Your use, reproduction, and distribution of the Work otherwise complies with the conditions stated in this License.

#### 5\. Submission of Contributions

Unless You explicitly state otherwise, any Contribution intentionally submitted for inclusion in the Work by You to the Licensor shall be under the terms and conditions of this License, without any additional terms or conditions. Notwithstanding the above, nothing herein shall supersede or modify the terms of any separate license agreement you may have executed with Licensor regarding such Contributions.

#### 6\. Trademarks

This License does not grant permission to use the trade names, trademarks, service marks, or product names of the Licensor, except as required for reasonable and customary use in describing the origin of the Work and reproducing the content of the NOTICE file.

#### 7\. Disclaimer of Warranty

Unless required by applicable law or agreed to in writing, Licensor provides the Work (and each Contributor provides its Contributions) on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied, including, without limitation, any warranties or conditions of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A PARTICULAR PURPOSE. You are solely responsible for determining the appropriateness of using or redistributing the Work and assume any risks associated with Your exercise of permissions under this License.

#### 8\. Limitation of Liability

In no event and under no legal theory, whether in tort (including negligence), contract, or otherwise, unless required by applicable law (such as deliberate and grossly negligent acts) or agreed to in writing, shall any Contributor be liable to You for damages, including any direct, indirect, special, incidental, or consequential damages of any character arising as a result of this License or out of the use or inability to use the Work (including but not limited to damages for loss of goodwill, work stoppage, computer failure or malfunction, or any and all other commercial damages or losses), even if such Contributor has been advised of the possibility of such damages.

#### 9\. Accepting Warranty or Additional Liability

While redistributing the Work or Derivative Works thereof, You may choose to offer, and charge a fee for, acceptance of support, warranty, indemnity, or other liability obligations and/or rights consistent with this License. However, in accepting such obligations, You may act only on Your own behalf and on Your sole responsibility, not on behalf of any other Contributor, and only if You agree to indemnify, defend, and hold each Contributor harmless for any liability incurred by, or claims asserted against, such Contributor by reason of your accepting any such warranty or additional liability.

_END OF TERMS AND CONDITIONS_

### APPENDIX: How to apply the Apache License to your work

To apply the Apache License to your work, attach the following boilerplate notice, with the fields enclosed by brackets `[]` replaced with your own identifying information. (Don’t include the brackets!) The text should be enclosed in the appropriate comment syntax for the file format. We also recommend that a file or class name and description of purpose be included on the same “printed page” as the copyright notice for easier identification within third-party archives.
    
    
    Copyright [yyyy] [name of copyright owner]
    
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
      http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/authors.html

Skip to contents

[omopgenerics](index.html) 1.3.1

  * [Reference](reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](articles/cdm_reference.html)
    * [Concept sets](articles/codelists.html)
    * [Cohort tables](articles/cohorts.html)
    * [A summarised result](articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](articles/suppression.html)
    * [Logging with omopgenerics](articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](articles/reexport.html)
    * [Expanding omopgenerics](articles/expanding_omopgenerics.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Authors and Citation

## Authors

  * **Martí Català**. Author, maintainer. [](https://orcid.org/0000-0003-3308-9905)

  * **Edward Burn**. Author. [](https://orcid.org/0000-0002-9286-1128)

  * **Mike Du**. Contributor. [](https://orcid.org/0000-0002-9517-8834)

  * **Yuchen Guo**. Contributor. [](https://orcid.org/0000-0002-0847-4855)

  * **Adam Black**. Contributor. [](https://orcid.org/0000-0001-5576-8701)

  * **Marta Alcalde-Herraiz**. Contributor. [](https://orcid.org/0009-0002-4405-1814)




## Citation

Source: [`DESCRIPTION`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/DESCRIPTION)

Català M, Burn E (2025). _omopgenerics: Methods and Classes for the OMOP Common Data Model_. R package version 1.3.1, <https://darwin-eu.github.io/omopgenerics/>. 
    
    
    @Manual{,
      title = {omopgenerics: Methods and Classes for the OMOP Common Data Model},
      author = {Martí Català and Edward Burn},
      year = {2025},
      note = {R package version 1.3.1},
      url = {https://darwin-eu.github.io/omopgenerics/},
    }

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/bind.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Bind two or more objects of the same class.

Source: [`R/methodBind.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodBind.R)

`bind.Rd`

Bind two or more objects of the same class.

## Usage
    
    
    bind(...)

## Arguments

...
    

Objects to bind.

## Value

New object.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/suppress.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Function to suppress counts in result objects

Source: [`R/methodSuppress.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodSuppress.R)

`suppress.Rd`

Function to suppress counts in result objects

## Usage
    
    
    suppress(result, minCellCount = 5)

## Arguments

result
    

Result object

minCellCount
    

Minimum count of records to report results.

## Value

Table with suppressed counts

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/newAchillesTable.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Create an achilles table from a cdm_table.

Source: [`R/classAchillesTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classAchillesTable.R)

`newAchillesTable.Rd`

Create an achilles table from a cdm_table.

## Usage
    
    
    newAchillesTable(table, version = "5.3", cast = FALSE)

## Arguments

table
    

A cdm_table.

version
    

version of the cdm.

cast
    

Whether to cast columns to the correct type.

## Value

An achilles_table object

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/newCdmReference.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# `cdm_reference` objects constructor

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`newCdmReference.Rd`

`cdm_reference` objects constructor

## Usage
    
    
    newCdmReference(tables, cdmName, cdmVersion = NULL, .softValidation = FALSE)

## Arguments

tables
    

List of tables that are part of the OMOP Common Data Model reference.

cdmName
    

Name of the cdm object.

cdmVersion
    

Version of the cdm. Supported versions 5.3 and 5.4.

.softValidation
    

Whether to perform a soft validation of consistency. If set to FALSE, non overlapping observation periods are ensured.

## Value

A `cdm_reference` object.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdmTables <- [list](https://rdrr.io/r/base/list.html)(
      "person" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
        race_concept_id = 0, ethnicity_concept_id = 0
      ) |>
        [newCdmTable](newCdmTable.html)([newLocalSource](newLocalSource.html)(), "person"),
      "observation_period" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        observation_period_id = 1, person_id = 1,
        observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
        observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
        period_type_concept_id = 0
      ) |>
        [newCdmTable](newCdmTable.html)([newLocalSource](newLocalSource.html)(), "observation_period")
    )
    cdm <- newCdmReference(tables = cdmTables, cdmName = "mock")
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 3 casted column in observation_period as do not match expected column type:
    #> • `observation_period_id` from numeric to integer
    #> • `person_id` from numeric to integer
    #> • `period_type_concept_id` from numeric to integer
    
    cdm
    #> 
    #> ── # OMOP CDM reference (local) of mock ────────────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/newCdmSource.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Create a cdm source object.

Source: [`R/classCdmSource.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmSource.R)

`newCdmSource.Rd`

Create a cdm source object.

## Usage
    
    
    newCdmSource(src, sourceType)

## Arguments

src
    

Source to a cdm object.

sourceType
    

Type of the source object.

## Value

A validated cdm source object.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/newCdmTable.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Create an cdm table.

Source: [`R/classCdmTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmTable.R)

`newCdmTable.Rd`

Create an cdm table.

## Usage
    
    
    newCdmTable(table, src, name)

## Arguments

table
    

A table that is part of a cdm.

src
    

The source of the table.

name
    

The name of the table.

## Value

A cdm_table object

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/newCodelistWithDetails.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# 'codelist' object constructor

Source: [`R/classCodelistWithDetails.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCodelistWithDetails.R)

`newCodelistWithDetails.Rd`

'codelist' object constructor

## Usage
    
    
    newCodelistWithDetails(x)

## Arguments

x
    

A named list where each element contains a tibble with the column concept_id

## Value

A codelist object.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/newLocalSource.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# A new local source for the cdm

Source: [`R/cdmFromTables.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/cdmFromTables.R)

`newLocalSource.Rd`

A new local source for the cdm

## Usage
    
    
    newLocalSource()

## Value

A list in the format of a cdm source

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    newLocalSource()
    #> This is a local cdm source
    # }
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/newOmopTable.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Create an omop table from a cdm table.

Source: [`R/classOmopTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classOmopTable.R)

`newOmopTable.Rd`

Create an omop table from a cdm table.

## Usage
    
    
    newOmopTable(table, version = "5.3", cast = FALSE)

## Arguments

table
    

A cdm_table.

version
    

version of the cdm.

cast
    

Whether to cast columns to the correct type.

## Value

An omop_table object

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/newSummarisedResult.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# 'summarised_results' object constructor

Source: [`R/classSummarisedResult.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classSummarisedResult.R)

`newSummarisedResult.Rd`

'summarised_results' object constructor

## Usage
    
    
    newSummarisedResult(x, settings = [attr](https://rdrr.io/r/base/attr.html)(x, "settings"))

## Arguments

x
    

Table.

settings
    

Settings for the summarised_result object.

## Value

A `summarised_result` object

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      "result_id" = 1L,
      "cdm_name" = "cprd",
      "group_name" = "cohort_name",
      "group_level" = "acetaminophen",
      "strata_name" = "sex &&& age_group",
      "strata_level" = [c](https://rdrr.io/r/base/c.html)("male &&& <40", "male &&& >=40"),
      "variable_name" = "number_subjects",
      "variable_level" = NA_character_,
      "estimate_name" = "count",
      "estimate_type" = "integer",
      "estimate_value" = [c](https://rdrr.io/r/base/c.html)("5", "15"),
      "additional_name" = "overall",
      "additional_level" = "overall"
    ) |>
      newSummarisedResult()
    #> `result_type`, `package_name`, and `package_version` added to settings.
    
    x
    #> # A tibble: 2 × 13
    #>   result_id cdm_name group_name  group_level   strata_name       strata_level 
    #>       <int> <chr>    <chr>       <chr>         <chr>             <chr>        
    #> 1         1 cprd     cohort_name acetaminophen sex &&& age_group male &&& <40 
    #> 2         1 cprd     cohort_name acetaminophen sex &&& age_group male &&& >=40
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    [settings](settings.html)(x)
    #> # A tibble: 1 × 8
    #>   result_id result_type package_name package_version group     strata additional
    #>       <int> <chr>       <chr>        <chr>           <chr>     <chr>  <chr>     
    #> 1         1 ""          ""           ""              cohort_n… sex &… ""        
    #> # ℹ 1 more variable: min_cell_count <chr>
    [summary](https://rdrr.io/r/base/summary.html)(x)
    #> A summarised_result object with 2 rows, 1 different result_id, 1 different cdm
    #> names, and 7 settings.
    #> CDM names: cprd.
    #> Settings: result_type, package_name, package_version, group, strata,
    #> additional, and min_cell_count.
    
    x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      "result_id" = 1L,
      "cdm_name" = "cprd",
      "group_name" = "cohort_name",
      "group_level" = "acetaminophen",
      "strata_name" = "sex &&& age_group",
      "strata_level" = [c](https://rdrr.io/r/base/c.html)("male &&& <40", "male &&& >=40"),
      "variable_name" = "number_subjects",
      "variable_level" = NA_character_,
      "estimate_name" = "count",
      "estimate_type" = "integer",
      "estimate_value" = [c](https://rdrr.io/r/base/c.html)("5", "15"),
      "additional_name" = "overall",
      "additional_level" = "overall"
    ) |>
      newSummarisedResult(settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        result_id = 1L, result_type = "custom_summary", mock = TRUE, value = 5
      ))
    #> `package_name` and `package_version` added to settings.
    #> `mock` and `value` casted to character.
    
    x
    #> # A tibble: 2 × 13
    #>   result_id cdm_name group_name  group_level   strata_name       strata_level 
    #>       <int> <chr>    <chr>       <chr>         <chr>             <chr>        
    #> 1         1 cprd     cohort_name acetaminophen sex &&& age_group male &&& <40 
    #> 2         1 cprd     cohort_name acetaminophen sex &&& age_group male &&& >=40
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    [settings](settings.html)(x)
    #> # A tibble: 1 × 10
    #>   result_id result_type    package_name package_version group  strata additional
    #>       <int> <chr>          <chr>        <chr>           <chr>  <chr>  <chr>     
    #> 1         1 custom_summary ""           ""              cohor… sex &… ""        
    #> # ℹ 3 more variables: min_cell_count <chr>, mock <chr>, value <chr>
    [summary](https://rdrr.io/r/base/summary.html)(x)
    #> A summarised_result object with 2 rows, 1 different result_id, 1 different cdm
    #> names, and 9 settings.
    #> CDM names: cprd.
    #> Settings: result_type, package_name, package_version, group, strata,
    #> additional, min_cell_count, mock, and value.
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/emptyAchillesTable.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Create an empty achilles table

Source: [`R/classAchillesTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classAchillesTable.R)

`emptyAchillesTable.Rd`

Create an empty achilles table

## Usage
    
    
    emptyAchillesTable(cdm, name)

## Arguments

cdm
    

A cdm_reference to create the table.

name
    

Name of the table to create.

## Value

The cdm_reference with an achilles empty table

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    cdm <- [emptyCdmReference](emptyCdmReference.html)("my_example_cdm")
    emptyAchillesTable(cdm = cdm, name = "achilles_results")
    #> 
    #> ── # OMOP CDM reference (local) of my_example_cdm ──────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: -
    #> • achilles tables: achilles_results
    #> • other tables: -
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/emptyCdmReference.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Create an empty cdm_reference

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`emptyCdmReference.Rd`

Create an empty cdm_reference

## Usage
    
    
    emptyCdmReference(cdmName, cdmVersion = NULL)

## Arguments

cdmName
    

Name of the cdm_reference

cdmVersion
    

Version of the cdm_reference

## Value

An empty cdm_reference

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    emptyCdmReference(cdmName = "my_example_cdm")
    #> 
    #> ── # OMOP CDM reference (local) of my_example_cdm ──────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/emptyCodelist.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Empty `codelist` object.

Source: [`R/classCodelist.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCodelist.R)

`emptyCodelist.Rd`

Empty `codelist` object.

## Usage
    
    
    emptyCodelist()

## Value

An empty codelist object.

## Examples
    
    
    emptyCodelist()
    #> 
    #> ── 0 codelists ─────────────────────────────────────────────────────────────────
    #> 
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/emptyCodelistWithDetails.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Empty `codelist` object.

Source: [`R/classCodelistWithDetails.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCodelistWithDetails.R)

`emptyCodelistWithDetails.Rd`

Empty `codelist` object.

## Usage
    
    
    emptyCodelistWithDetails()

## Value

An empty codelist object.

## Examples
    
    
    emptyCodelistWithDetails()
    #> 
    #> ── 0 codelists with details ────────────────────────────────────────────────────
    #> 
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/emptyCohortTable.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Create an empty cohort_table object

Source: [`R/classCohortTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCohortTable.R)

`emptyCohortTable.Rd`

Create an empty cohort_table object

## Usage
    
    
    emptyCohortTable(cdm, name, overwrite = TRUE)

## Arguments

cdm
    

A cdm_reference to create the table.

name
    

Name of the table to create.

overwrite
    

Whether to overwrite an existent table.

## Value

The cdm_reference with an empty cohort table

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    person <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = 1, person_id = 1,
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
      period_type_concept_id = 0
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)("person" = person, "observation_period" = observation_period),
      cdmName = "test"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 3 casted column in observation_period as do not match expected column type:
    #> • `observation_period_id` from numeric to integer
    #> • `person_id` from numeric to integer
    #> • `period_type_concept_id` from numeric to integer
    
    cdm <- emptyCohortTable(cdm, "my_empty_cohort")
    
    cdm
    #> 
    #> ── # OMOP CDM reference (local) of test ────────────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: my_empty_cohort
    #> • achilles tables: -
    #> • other tables: -
    cdm$my_empty_cohort
    #> # A tibble: 0 × 4
    #> # ℹ 4 variables: cohort_definition_id <int>, subject_id <int>,
    #> #   cohort_start_date <date>, cohort_end_date <date>
    [settings](settings.html)(cdm$my_empty_cohort)
    #> # A tibble: 0 × 2
    #> # ℹ 2 variables: cohort_definition_id <int>, cohort_name <chr>
    [attrition](attrition.html)(cdm$my_empty_cohort)
    #> # A tibble: 0 × 7
    #> # ℹ 7 variables: cohort_definition_id <int>, number_records <int>,
    #> #   number_subjects <int>, reason_id <int>, reason <chr>,
    #> #   excluded_records <int>, excluded_subjects <int>
    [cohortCount](cohortCount.html)(cdm$my_empty_cohort)
    #> # A tibble: 0 × 3
    #> # ℹ 3 variables: cohort_definition_id <int>, number_records <int>,
    #> #   number_subjects <int>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/emptyConceptSetExpression.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Empty `concept_set_expression` object.

Source: [`R/classConceptSetExpression.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classConceptSetExpression.R)

`emptyConceptSetExpression.Rd`

Empty `concept_set_expression` object.

## Usage
    
    
    emptyConceptSetExpression()

## Value

An empty concept_set_expression object.

## Examples
    
    
    emptyConceptSetExpression()
    #> 
    #> ── 0 concept set expressions ───────────────────────────────────────────────────
    #> 
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/emptyOmopTable.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Create an empty omop table

Source: [`R/classOmopTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classOmopTable.R)

`emptyOmopTable.Rd`

Create an empty omop table

## Usage
    
    
    emptyOmopTable(cdm, name)

## Arguments

cdm
    

A cdm_reference to create the table.

name
    

Name of the table to create.

## Value

The cdm_reference with an empty cohort table

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    person <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = 1, person_id = 1,
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
      period_type_concept_id = 0
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)("person" = person, "observation_period" = observation_period),
      cdmName = "test"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 3 casted column in observation_period as do not match expected column type:
    #> • `observation_period_id` from numeric to integer
    #> • `person_id` from numeric to integer
    #> • `period_type_concept_id` from numeric to integer
    
    cdm <- emptyOmopTable(cdm, "drug_exposure")
    
    cdm$drug_exposure
    #> # A tibble: 0 × 23
    #> # ℹ 23 variables: drug_exposure_id <int>, person_id <int>,
    #> #   drug_concept_id <int>, drug_exposure_start_date <date>,
    #> #   drug_exposure_start_datetime <date>, drug_exposure_end_date <date>,
    #> #   drug_exposure_end_datetime <date>, verbatim_end_date <date>,
    #> #   drug_type_concept_id <int>, stop_reason <chr>, refills <int>,
    #> #   quantity <dbl>, days_supply <int>, sig <chr>, route_concept_id <int>,
    #> #   lot_number <chr>, provider_id <int>, visit_occurrence_id <int>, …
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/emptySummarisedResult.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Empty `summarised_result` object.

Source: [`R/classSummarisedResult.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classSummarisedResult.R)

`emptySummarisedResult.Rd`

Empty `summarised_result` object.

## Usage
    
    
    emptySummarisedResult(settings = NULL)

## Arguments

settings
    

Tibble/data.frame with the settings of the empty summarised_result. It has to contain at least `result_id` column.

## Value

An empty `summarised_result` object.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    emptySummarisedResult()
    #> # A tibble: 0 × 13
    #> # ℹ 13 variables: result_id <int>, cdm_name <chr>, group_name <chr>,
    #> #   group_level <chr>, strata_name <chr>, strata_level <chr>,
    #> #   variable_name <chr>, variable_level <chr>, estimate_name <chr>,
    #> #   estimate_type <chr>, estimate_value <chr>, additional_name <chr>,
    #> #   additional_level <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/cdmClasses.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Separate the cdm tables in classes

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`cdmClasses.Rd`

Separate the cdm tables in classes

## Usage
    
    
    cdmClasses(cdm)

## Arguments

cdm
    

A cdm_reference object.

## Value

A list of table names, the name of the list indicates the class.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/cdmDisconnect.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Disconnect from a cdm object.

Source: [`R/methodCdmDisconnect.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodCdmDisconnect.R)

`cdmDisconnect.Rd`

Disconnect from a cdm object.

## Usage
    
    
    cdmDisconnect(cdm, ...)

## Arguments

cdm
    

A cdm reference or the source of a cdm reference.

...
    

Used for consistency.

## Value

TRUE if process wass successful. library(omopgenerics) library(dplyr, warn.conflicts = FALSE)

person <\- tibble( person_id = 1, gender_concept_id = 0, year_of_birth = 1990, race_concept_id = 0, ethnicity_concept_id = 0 ) observation_period <\- tibble( observation_period_id = 1, person_id = 1, observation_period_start_date = as.Date("2000-01-01"), observation_period_end_date = as.Date("2023-12-31"), period_type_concept_id = 0 ) cdm <\- cdmFromTables( tables = list("person" = person, "observation_period" = observation_period), cdmName = "mock" )

cdmDisconnect(cdm)

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/cdmName.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get the name of a cdm_reference associated object

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`cdmName.Rd`

Get the name of a cdm_reference associated object

## Usage
    
    
    cdmName(x)

## Arguments

x
    

A cdm_reference or cdm_table object.

## Value

Name of the cdm_reference.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          person_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), gender_concept_id = 0, year_of_birth = 1990,
          race_concept_id = 0, ethnicity_concept_id = 0
        ),
        "observation_period" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          observation_period_id = 1:3, person_id = 1:3,
          observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
          observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
          period_type_concept_id = 0
        )
      ),
      cdmName = "mock"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in observation_period as do not match expected column type:
    #> • `period_type_concept_id` from numeric to integer
    
    cdmName(cdm)
    #> [1] "mock"
    
    cdmName(cdm$person)
    #> [1] "mock"
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/cdmReference.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get the `cdm_reference` of a `cdm_table`.

Source: [`R/classCdmTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmTable.R)

`cdmReference.Rd`

Get the `cdm_reference` of a `cdm_table`.

## Usage
    
    
    cdmReference(table)

## Arguments

table
    

A cdm_table.

## Value

A cdm_reference.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          person_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), gender_concept_id = 0, year_of_birth = 1990,
          race_concept_id = 0, ethnicity_concept_id = 0
        ),
        "observation_period" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          observation_period_id = 1:3, person_id = 1:3,
          observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
          observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
          period_type_concept_id = 0
        )
      ),
      cdmName = "mock"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in observation_period as do not match expected column type:
    #> • `period_type_concept_id` from numeric to integer
    
    cdmReference(cdm$person)
    #> 
    #> ── # OMOP CDM reference (local) of mock ────────────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/cdmSelect.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Restrict the cdm object to a subset of tables.

Source: [`R/cdmSelect.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/cdmSelect.R)

`cdmSelect.Rd`

Restrict the cdm object to a subset of tables.

## Usage
    
    
    cdmSelect(cdm, ...)

## Arguments

cdm
    

A cdm_reference object.

...
    

Selection of tables to use, it supports tidyselect expressions.

## Value

A cdm_reference with only the specified tables.

## Examples
    
    
    cdm <- [emptyCdmReference](emptyCdmReference.html)("my cdm")
    cdm
    #> 
    #> ── # OMOP CDM reference (local) of my cdm ──────────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    
    cdm |>
      cdmSelect("person")
    #> 
    #> ── # OMOP CDM reference (local) of my cdm ──────────────────────────────────────
    #> • omop tables: person
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/cdmSource.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get the cdmSource of an object.

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`cdmSource.Rd`

Get the cdmSource of an object.

## Usage
    
    
    cdmSource(x, cdm = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)())

## Arguments

x
    

Object to obtain the cdmSource.

cdm
    

Deprecated, use x please.

## Value

A cdm_source object.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          person_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), gender_concept_id = 0, year_of_birth = 1990,
          race_concept_id = 0, ethnicity_concept_id = 0
        ),
        "observation_period" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          observation_period_id = 1:3, person_id = 1:3,
          observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
          observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
          period_type_concept_id = 0
        )
      ),
      cdmName = "mock"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in observation_period as do not match expected column type:
    #> • `period_type_concept_id` from numeric to integer
    
    cdmSource(cdm)
    #> This is a local cdm source
    cdmSource(cdm$person)
    #> This is a local cdm source
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/cdmSourceType.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get the source type of a cdm_reference object.

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`cdmSourceType.Rd`

[![\[Deprecated\]](figures/lifecycle-deprecated.svg)](https://lifecycle.r-lib.org/articles/stages.html#deprecated)

## Usage
    
    
    cdmSourceType(cdm)

## Arguments

cdm
    

A cdm_reference object.

## Value

A character vector with the type of source of the cdm_reference object.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          person_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), gender_concept_id = 0, year_of_birth = 1990,
          race_concept_id = 0, ethnicity_concept_id = 0
        ),
        "observation_period" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          observation_period_id = 1:3, person_id = 1:3,
          observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
          observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
          period_type_concept_id = 0
        )
      ),
      cdmName = "mock"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in observation_period as do not match expected column type:
    #> • `period_type_concept_id` from numeric to integer
    
    cdmSourceType(cdm)
    #> Warning: `cdmSourceType()` was deprecated in omopgenerics 0.3.0.
    #> ℹ Please use `sourceType()` instead.
    #> [1] "local"
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/cdmTableFromSource.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# This is an internal developer focused function that creates a cdm_table from a table that shares the source but it is not a cdm_table. Please use insertTable if you want to insert a table to a cdm_reference object.

Source: [`R/methodCdmTableFromSource.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodCdmTableFromSource.R)

`cdmTableFromSource.Rd`

This is an internal developer focused function that creates a cdm_table from a table that shares the source but it is not a cdm_table. Please use insertTable if you want to insert a table to a cdm_reference object.

## Usage
    
    
    cdmTableFromSource(src, value)

## Arguments

src
    

A cdm_source object.

value
    

A table that shares source with the cdm_reference object.

## Value

A cdm_table.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/cdmVersion.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get the version of an object.

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`cdmVersion.Rd`

Get the version of an object.

## Usage
    
    
    cdmVersion(x)

## Arguments

x
    

Object to know the cdm version of an object.

## Value

A character vector indicating the cdm version.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          person_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), gender_concept_id = 0, year_of_birth = 1990,
          race_concept_id = 0, ethnicity_concept_id = 0
        ),
        "observation_period" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          observation_period_id = 1:3, person_id = 1:3,
          observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
          observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
          period_type_concept_id = 0
        )
      ),
      cdmName = "mock"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in observation_period as do not match expected column type:
    #> • `period_type_concept_id` from numeric to integer
    
    cdmVersion(cdm)
    #> [1] "5.3"
    cdmVersion(cdm$person)
    #> [1] "5.3"
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/listSourceTables.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# List tables that can be accessed though a cdm object.

Source: [`R/methodListSourceTables.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodListSourceTables.R)

`listSourceTables.Rd`

List tables that can be accessed though a cdm object.

## Usage
    
    
    listSourceTables(cdm)

## Arguments

cdm
    

A cdm reference or the source of a cdm reference.

## Value

A character vector with the names of tables.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/dropSourceTable.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Drop a table from a cdm object.

Source: [`R/methodDropSourceTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodDropSourceTable.R)

`dropSourceTable.Rd`

Drop a table from a cdm object.

## Usage
    
    
    dropSourceTable(cdm, name)

## Arguments

cdm
    

A cdm reference.

name
    

Name(s) of the table(s) to insert. Tidyselect statements are supported.

## Value

The table in the cdm reference.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/insertTable.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Insert a table to a cdm object.

Source: [`R/methodInsertTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodInsertTable.R)

`insertTable.Rd`

Insert a table to a cdm object.

## Usage
    
    
    insertTable(cdm, name, table, overwrite = TRUE, temporary = FALSE, ...)

## Arguments

cdm
    

A cdm reference or the source of a cdm reference.

name
    

Name of the table to insert.

table
    

Table to insert to the cdm.

overwrite
    

Whether to overwrite an existent table.

temporary
    

Whether to create a temporary table.

...
    

For compatibility.

## Value

The cdm reference. library(omopgenerics) library(dplyr, warn.conflicts = FALSE)

person <\- tibble( person_id = 1, gender_concept_id = 0, year_of_birth = 1990, race_concept_id = 0, ethnicity_concept_id = 0 ) observation_period <\- tibble( observation_period_id = 1, person_id = 1, observation_period_start_date = as.Date("2000-01-01"), observation_period_end_date = as.Date("2023-12-31"), period_type_concept_id = 0 ) cdm <\- cdmFromTables( tables = list("person" = person, "observation_period" = observation_period), cdmName = "my_example_cdm" )

x <\- tibble(a = 1)

cdm <\- insertTable(cdm = cdm, name = "new_table", table = x)

cdm$new_table

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/readSourceTable.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Read a table from the cdm_source and add it to to the cdm.

Source: [`R/methodReadSourceTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodReadSourceTable.R)

`readSourceTable.Rd`

Read a table from the cdm_source and add it to to the cdm.

## Usage
    
    
    readSourceTable(cdm, name)

## Arguments

cdm
    

A cdm reference.

name
    

Name of a table to read in the cdm_source space.

## Value

A cdm_reference with new table.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/insertCdmTo.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Insert a cdm_reference object to a different source.

Source: [`R/methodInsertCdmTo.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodInsertCdmTo.R)

`insertCdmTo.Rd`

Insert a cdm_reference object to a different source.

## Usage
    
    
    insertCdmTo(cdm, to)

## Arguments

cdm
    

A cdm_reference, if not local it will be collected into memory.

to
    

A cdm_source or another cdm_reference, with a valid cdm_source.

## Value

The first cdm_reference object inserted to the source.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/getPersonIdentifier.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get the column name with the person identifier from a table (either subject_id or person_id), it will throw an error if it contains both or neither.

Source: [`R/utilities.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/utilities.R)

`getPersonIdentifier.Rd`

Get the column name with the person identifier from a table (either subject_id or person_id), it will throw an error if it contains both or neither.

## Usage
    
    
    getPersonIdentifier(x, call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)())

## Arguments

x
    

A table.

call
    

A call argument passed to cli functions.

## Value

Person identifier column.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/cash-.cdm_reference.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Subset a cdm reference object.

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`cash-.cdm_reference.Rd`

Subset a cdm reference object.

## Usage
    
    
    # S3 method for class 'cdm_reference'
    x$name

## Arguments

x
    

A cdm reference.

name
    

The name of the table to extract from the cdm object.

## Value

A single cdm table reference

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          person_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), gender_concept_id = 0, year_of_birth = 1990,
          race_concept_id = 0, ethnicity_concept_id = 0
        ),
        "observation_period" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          observation_period_id = 1:3, person_id = 1:3,
          observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
          observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
          period_type_concept_id = 0
        )
      ),
      cdmName = "mock"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in observation_period as do not match expected column type:
    #> • `period_type_concept_id` from numeric to integer
    
    cdm$person
    #> # A tibble: 3 × 5
    #>   person_id gender_concept_id year_of_birth race_concept_id ethnicity_concept_id
    #>       <int>             <int>         <int>           <int>                <int>
    #> 1         1                 0          1990               0                    0
    #> 2         2                 0          1990               0                    0
    #> 3         3                 0          1990               0                    0
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/cash-set-.cdm_reference.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Assign an table to a cdm reference.

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`cash-set-.cdm_reference.Rd`

Assign an table to a cdm reference.

## Usage
    
    
    # S3 method for class 'cdm_reference'
    cdm$name <- value

## Arguments

cdm
    

A cdm reference.

name
    

Name where to assign the new table.

value
    

Table with the same source than the cdm object.

## Value

The cdm reference.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          person_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), gender_concept_id = 0, year_of_birth = 1990,
          race_concept_id = 0, ethnicity_concept_id = 0
        ),
        "observation_period" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          observation_period_id = 1:3, person_id = 1:3,
          observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
          observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
          period_type_concept_id = 0
        )
      ),
      cdmName = "mock"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in observation_period as do not match expected column type:
    #> • `period_type_concept_id` from numeric to integer
    
    cdm$person
    #> # A tibble: 3 × 5
    #>   person_id gender_concept_id year_of_birth race_concept_id ethnicity_concept_id
    #>       <int>             <int>         <int>           <int>                <int>
    #> 1         1                 0          1990               0                    0
    #> 2         2                 0          1990               0                    0
    #> 3         3                 0          1990               0                    0
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/collect.cdm_reference.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Retrieves the cdm reference into a local cdm.

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`collect.cdm_reference.Rd`

Retrieves the cdm reference into a local cdm.

## Usage
    
    
    # S3 method for class 'cdm_reference'
    [collect](https://dplyr.tidyverse.org/reference/compute.html)(x, ...)

## Arguments

x
    

A cdm_reference object.

...
    

For compatibility only, not used.

## Value

A local cdm_reference.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          person_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), gender_concept_id = 0, year_of_birth = 1990,
          race_concept_id = 0, ethnicity_concept_id = 0
        ),
        "observation_period" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          observation_period_id = 1:3, person_id = 1:3,
          observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
          observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
          period_type_concept_id = 0
        )
      ),
      cdmName = "mock"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in observation_period as do not match expected column type:
    #> • `period_type_concept_id` from numeric to integer
    
    [collect](https://dplyr.tidyverse.org/reference/compute.html)(cdm)
    #> 
    #> ── # OMOP CDM reference (local) of mock ────────────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/print.cdm_reference.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Print a CDM reference object

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`print.cdm_reference.Rd`

Print a CDM reference object

## Usage
    
    
    # S3 method for class 'cdm_reference'
    [print](https://rdrr.io/r/base/print.html)(x, ...)

## Arguments

x
    

A cdm_reference object

...
    

Included for compatibility with generic. Not used.

## Value

Invisibly returns the input

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          person_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), gender_concept_id = 0, year_of_birth = 1990,
          race_concept_id = 0, ethnicity_concept_id = 0
        ),
        "observation_period" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          observation_period_id = 1:3, person_id = 1:3,
          observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
          observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
          period_type_concept_id = 0
        )
      ),
      cdmName = "mock"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in observation_period as do not match expected column type:
    #> • `period_type_concept_id` from numeric to integer
    
    [print](https://rdrr.io/r/base/print.html)(cdm)
    #> 
    #> ── # OMOP CDM reference (local) of mock ────────────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/sub-sub-.cdm_reference.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Subset a cdm reference object.

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`sub-sub-.cdm_reference.Rd`

Subset a cdm reference object.

## Usage
    
    
    # S3 method for class 'cdm_reference'
    x[[name]]

## Arguments

x
    

A cdm reference

name
    

The name or index of the table to extract from the cdm object.

## Value

A single cdm table reference

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          person_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), gender_concept_id = 0, year_of_birth = 1990,
          race_concept_id = 0, ethnicity_concept_id = 0
        ),
        "observation_period" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          observation_period_id = 1:3, person_id = 1:3,
          observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
          observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
          period_type_concept_id = 0
        )
      ),
      cdmName = "mock"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in observation_period as do not match expected column type:
    #> • `period_type_concept_id` from numeric to integer
    
    cdm[["person"]]
    #> # A tibble: 3 × 5
    #>   person_id gender_concept_id year_of_birth race_concept_id ethnicity_concept_id
    #>       <int>             <int>         <int>           <int>                <int>
    #> 1         1                 0          1990               0                    0
    #> 2         2                 0          1990               0                    0
    #> 3         3                 0          1990               0                    0
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/sub-subset-.cdm_reference.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Assign a table to a cdm reference.

Source: [`R/classCdmReference.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmReference.R)

`sub-subset-.cdm_reference.Rd`

Assign a table to a cdm reference.

## Usage
    
    
    # S3 method for class 'cdm_reference'
    cdm[[name]] <- value

## Arguments

cdm
    

A cdm reference.

name
    

Name where to assign the new table.

value
    

Table with the same source than the cdm object.

## Value

The cdm reference.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/summary.cdm_reference.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Summary a cdm reference

Source: [`R/summary.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/summary.R)

`summary.cdm_reference.Rd`

Summary a cdm reference

## Usage
    
    
    # S3 method for class 'cdm_reference'
    [summary](https://rdrr.io/r/base/summary.html)(object, ...)

## Arguments

object
    

A cdm reference object.

...
    

For compatibility (not used).

## Value

A summarised_result object with a summary of the data contained in the cdm.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    person <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = 1, person_id = 1,
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
      period_type_concept_id = 0
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)("person" = person, "observation_period" = observation_period),
      cdmName = "test"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 3 casted column in observation_period as do not match expected column type:
    #> • `observation_period_id` from numeric to integer
    #> • `person_id` from numeric to integer
    #> • `period_type_concept_id` from numeric to integer
    
    [summary](https://rdrr.io/r/base/summary.html)(cdm)
    #> # A tibble: 13 × 13
    #>    result_id cdm_name group_name group_level strata_name strata_level
    #>        <int> <chr>    <chr>      <chr>       <chr>       <chr>       
    #>  1         1 test     overall    overall     overall     overall     
    #>  2         1 test     overall    overall     overall     overall     
    #>  3         1 test     overall    overall     overall     overall     
    #>  4         1 test     overall    overall     overall     overall     
    #>  5         1 test     overall    overall     overall     overall     
    #>  6         1 test     overall    overall     overall     overall     
    #>  7         1 test     overall    overall     overall     overall     
    #>  8         1 test     overall    overall     overall     overall     
    #>  9         1 test     overall    overall     overall     overall     
    #> 10         1 test     overall    overall     overall     overall     
    #> 11         1 test     overall    overall     overall     overall     
    #> 12         1 test     overall    overall     overall     overall     
    #> 13         1 test     overall    overall     overall     overall     
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/summary.cdm_source.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Summarise a `cdm_source` object

Source: [`R/summary.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/summary.R)

`summary.cdm_source.Rd`

Summarise a `cdm_source` object

## Usage
    
    
    # S3 method for class 'cdm_source'
    [summary](https://rdrr.io/r/base/summary.html)(object, ...)

## Arguments

object
    

A generated cohort set object.

...
    

For compatibility (not used).

## Value

A list of properties of the `cdm_source` object.

## Examples
    
    
    [summary](https://rdrr.io/r/base/summary.html)([newLocalSource](newLocalSource.html)())
    #> This is a local source created by omopgenerics package.
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/tableName.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get the table name of a `cdm_table`.

Source: [`R/classCdmTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmTable.R)

`tableName.Rd`

Get the table name of a `cdm_table`.

## Usage
    
    
    tableName(table)

## Arguments

table
    

A cdm_table.

## Value

A character with the name.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          person_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), gender_concept_id = 0, year_of_birth = 1990,
          race_concept_id = 0, ethnicity_concept_id = 0
        ),
        "observation_period" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          observation_period_id = 1:3, person_id = 1:3,
          observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
          observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
          period_type_concept_id = 0
        )
      ),
      cdmName = "mock"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in observation_period as do not match expected column type:
    #> • `period_type_concept_id` from numeric to integer
    
    tableName(cdm$person)
    #> [1] "person"
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/tableSource.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get the table source of a `cdm_table`.

Source: [`R/classCdmTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmTable.R)

`tableSource.Rd`

Get the table source of a `cdm_table`.

## Usage
    
    
    tableSource(table)

## Arguments

table
    

A cdm_table.

## Value

A cdm_source object.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          person_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), gender_concept_id = 0, year_of_birth = 1990,
          race_concept_id = 0, ethnicity_concept_id = 0
        ),
        "observation_period" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          observation_period_id = 1:3, person_id = 1:3,
          observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
          observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
          period_type_concept_id = 0
        )
      ),
      cdmName = "mock"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in observation_period as do not match expected column type:
    #> • `period_type_concept_id` from numeric to integer
    
    tableSource(cdm$person)
    #> This is a local cdm source
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/numberRecords.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Count the number of records that a `cdm_table` has.

Source: [`R/utilities.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/utilities.R)

`numberRecords.Rd`

Count the number of records that a `cdm_table` has.

## Usage
    
    
    numberRecords(x)

## Arguments

x
    

A cdm_table.

## Value

An integer with the number of records in the table.

## Examples
    
    
    person <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = 1, person_id = 1,
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
      period_type_concept_id = 0
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)("person" = person, "observation_period" = observation_period),
      cdmName = "test"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 3 casted column in observation_period as do not match expected column type:
    #> • `observation_period_id` from numeric to integer
    #> • `person_id` from numeric to integer
    #> • `period_type_concept_id` from numeric to integer
    
    numberRecords(cdm$observation_period)
    #> [1] 1
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/numberSubjects.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Count the number of subjects that a `cdm_table` has.

Source: [`R/utilities.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/utilities.R)

`numberSubjects.Rd`

Count the number of subjects that a `cdm_table` has.

## Usage
    
    
    numberSubjects(x)

## Arguments

x
    

A cdm_table.

## Value

An integer with the number of subjects in the table.

## Examples
    
    
    person <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = 1, person_id = 1,
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
      period_type_concept_id = 0
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)("person" = person, "observation_period" = observation_period),
      cdmName = "test"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 3 casted column in observation_period as do not match expected column type:
    #> • `observation_period_id` from numeric to integer
    #> • `person_id` from numeric to integer
    #> • `period_type_concept_id` from numeric to integer
    
    numberSubjects(cdm$observation_period)
    #> [1] 1
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/compute.cdm_table.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Store results in a table.

Source: [`R/compute.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/compute.R)

`compute.cdm_table.Rd`

Store results in a table.

## Usage
    
    
    # S3 method for class 'cdm_table'
    [compute](https://dplyr.tidyverse.org/reference/compute.html)(
      x,
      name = NULL,
      temporary = NULL,
      overwrite = TRUE,
      logPrefix = NULL,
      ...
    )

## Arguments

x
    

Table in the cdm.

name
    

Name to store the table with.

temporary
    

Whether to store table temporarily (TRUE) or permanently (FALSE).

overwrite
    

Whether to overwrite previously existing table with name same.

logPrefix
    

Prefix to use when saving a log file.

...
    

For compatibility (not used).

## Value

Reference to a table in the cdm

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/omopDataFolder.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Check or set the OMOP_DATA_FOLDER where the OMOP related data is stored.

Source: [`R/omopDataFolder.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/omopDataFolder.R)

`omopDataFolder.Rd`

Check or set the OMOP_DATA_FOLDER where the OMOP related data is stored.

## Usage
    
    
    omopDataFolder(path = NULL)

## Arguments

path
    

Path to a folder to store the OMOP related data. If NULL the current `OMOP_DATA_FOLDER` is returned.

## Value

The OMOP data folder.

## Examples
    
    
    # \donttest{
    omopDataFolder()
    #> [1] "/tmp/Rtmpmt8NbS/OMOP_DATA_FOLDER"
    omopDataFolder([file.path](https://rdrr.io/r/base/file.path.html)([tempdir](https://rdrr.io/r/base/tempfile.html)(), "OMOP_DATA"))
    #> ℹ Creating /tmp/Rtmpmt8NbS/OMOP_DATA.
    omopDataFolder()
    #> [1] "/tmp/Rtmpmt8NbS/OMOP_DATA"
    # }
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/omopTableFields.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Return a table of omop cdm fields informations

Source: [`R/utilities.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/utilities.R)

`omopTableFields.Rd`

Return a table of omop cdm fields informations

## Usage
    
    
    omopTableFields(cdmVersion = "5.3")

## Arguments

cdmVersion
    

cdm version of the omop cdm.

## Value

a tibble contain informations on all the different fields in omop cdm.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/cohortCodelist.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get codelist from a cohort_table object.

Source: [`R/cohortCodelist.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/cohortCodelist.R)

`cohortCodelist.Rd`

Get codelist from a cohort_table object.

## Usage
    
    
    cohortCodelist(
      cohortTable,
      cohortId,
      codelistType = [c](https://rdrr.io/r/base/c.html)("index event", "inclusion criteria", "exit criteria"),
      type = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)()
    )

## Arguments

cohortTable
    

A cohort_table object.

cohortId
    

A particular cohort definition id that is present in the cohort table.

codelistType
    

The reason for the codelist. Can be "index event", "inclusion criteria", or "exit criteria".

type
    

deprecated.

## Value

A table with the codelists used.

## Examples
    
    
     # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    person <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = 1, person_id = 1,
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
      period_type_concept_id = 0
    )
    cohort <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = [c](https://rdrr.io/r/base/c.html)(1, 1, 1, 2),
      subject_id = 1,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)(
        "2020-01-01", "2021-01-01", "2022-01-01", "2022-01-01"
      )),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)(
        "2020-01-01", "2021-01-01", "2022-01-01", "2022-01-01"
      ))
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)("person" = person, "observation_period" = observation_period),
      cdmName = "my_example_cdm",
      cohortTables = [list](https://rdrr.io/r/base/list.html)("cohort1" = cohort)
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 3 casted column in observation_period as do not match expected column type:
    #> • `observation_period_id` from numeric to integer
    #> • `person_id` from numeric to integer
    #> • `period_type_concept_id` from numeric to integer
    #> Warning: ! 2 casted column in cohort1 as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> • `subject_id` from numeric to integer
    cdm$cohort1 <- [newCohortTable](newCohortTable.html)(table = cdm$cohort1,
                                    cohortCodelistRef = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
                                    cohort_definition_id = [c](https://rdrr.io/r/base/c.html)(1,1,1,2,2),
                                    codelist_name =[c](https://rdrr.io/r/base/c.html)("disease X", "disease X", "disease X",
                                                     "disease Y", "disease Y"),
                                    concept_id = [c](https://rdrr.io/r/base/c.html)(1,2,3,4,5),
                                    codelist_type = "index event"
                                  ))
    cohortCodelist(cdm$cohort1, cohortId = 1, codelistType = "index event")
    #> Warning: ! `codelist` casted to integers.
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - disease X (3 codes)
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/getCohortId.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get the cohort definition id of a certain name

Source: [`R/utilities.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/utilities.R)

`getCohortId.Rd`

Get the cohort definition id of a certain name

## Usage
    
    
    getCohortId(cohort, cohortName = NULL)

## Arguments

cohort
    

A cohort_table object.

cohortName
    

Names of the cohort of interest. If NULL all cohort names are shown.

## Value

Cohort definition ids

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/getCohortName.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get the cohort name of a certain cohort definition id

Source: [`R/utilities.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/utilities.R)

`getCohortName.Rd`

Get the cohort name of a certain cohort definition id

## Usage
    
    
    getCohortName(cohort, cohortId = NULL)

## Arguments

cohort
    

A cohort_table object.

cohortId
    

Cohort definition id of interest. If NULL all cohort ids are shown.

## Value

Cohort names

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/recordCohortAttrition.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Update cohort attrition.

Source: [`R/recordCohortAttrition.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/recordCohortAttrition.R)

`recordCohortAttrition.Rd`

Update cohort attrition.

## Usage
    
    
    recordCohortAttrition(cohort, reason, cohortId = NULL)

## Arguments

cohort
    

A cohort_table object.

reason
    

A character string.

cohortId
    

Cohort definition id of the cohort to update attrition. If NULL all cohort_definition_id are updated.

## Value

cohort_table with updated attrition.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    person <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = 1, person_id = 1,
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
      period_type_concept_id = 0
    )
    cohort <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = [c](https://rdrr.io/r/base/c.html)(1, 1, 1, 2),
      subject_id = 1,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2020-01-01", "2021-01-01", "2022-01-01", "2022-01-01")),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2020-01-01", "2021-01-01", "2022-01-01", "2022-01-01")),
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)("person" = person, "observation_period" = observation_period),
      cdmName = "my_example_cdm",
      cohortTables = [list](https://rdrr.io/r/base/list.html)("cohort1" = cohort)
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 3 casted column in observation_period as do not match expected column type:
    #> • `observation_period_id` from numeric to integer
    #> • `person_id` from numeric to integer
    #> • `period_type_concept_id` from numeric to integer
    #> Warning: ! 2 casted column in cohort1 as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> • `subject_id` from numeric to integer
    
    cdm$cohort1
    #> # A tibble: 4 × 4
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1          1 2020-01-01        2020-01-01     
    #> 2                    1          1 2021-01-01        2021-01-01     
    #> 3                    1          1 2022-01-01        2022-01-01     
    #> 4                    2          1 2022-01-01        2022-01-01     
    [attrition](attrition.html)(cdm$cohort1)
    #> # A tibble: 2 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1              3               1         1 Initial qualify…
    #> 2                    2              1               1         1 Initial qualify…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    
    cdm$cohort1 <- cdm$cohort1 |>
      [group_by](https://dplyr.tidyverse.org/reference/group_by.html)(cohort_definition_id, subject_id) |>
      [filter](https://dplyr.tidyverse.org/reference/filter.html)(cohort_start_date == [min](https://rdrr.io/r/base/Extremes.html)(cohort_start_date)) |>
      [ungroup](https://dplyr.tidyverse.org/reference/group_by.html)() |>
      [compute](https://dplyr.tidyverse.org/reference/compute.html)(name = "cohort1", temporary = FALSE) |>
      recordCohortAttrition("Restrict to first observation")
    
    cdm$cohort1
    #> # A tibble: 2 × 4
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #> *                <int>      <int> <date>            <date>         
    #> 1                    1          1 2020-01-01        2020-01-01     
    #> 2                    2          1 2022-01-01        2022-01-01     
    [attrition](attrition.html)(cdm$cohort1)
    #> # A tibble: 4 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1              3               1         1 Initial qualify…
    #> 2                    1              1               1         2 Restrict to fir…
    #> 3                    2              1               1         1 Initial qualify…
    #> 4                    2              1               1         2 Restrict to fir…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/attrition.cohort_table.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get cohort attrition from a cohort_table object.

Source: [`R/methodAttrition.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodAttrition.R)

`attrition.cohort_table.Rd`

Get cohort attrition from a cohort_table object.

## Usage
    
    
    # S3 method for class 'cohort_table'
    [attrition](attrition.html)(x)

## Arguments

x
    

A cohort_table

## Value

A table with the attrition.

## Examples
    
    
     # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    person <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = 1, person_id = 1,
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
      period_type_concept_id = 0
    )
    cohort <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = [c](https://rdrr.io/r/base/c.html)(1, 1, 1, 2),
      subject_id = 1,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2020-01-01", "2021-01-01", "2022-01-01", "2022-01-01")),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("2020-01-01", "2021-01-01", "2022-01-01", "2022-01-01")),
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)("person" = person, "observation_period" = observation_period),
      cdmName = "my_example_cdm",
      cohortTables = [list](https://rdrr.io/r/base/list.html)("cohort1" = cohort)
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 3 casted column in observation_period as do not match expected column type:
    #> • `observation_period_id` from numeric to integer
    #> • `person_id` from numeric to integer
    #> • `period_type_concept_id` from numeric to integer
    #> Warning: ! 2 casted column in cohort1 as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> • `subject_id` from numeric to integer
    
    [attrition](attrition.html)(cdm$cohort1)
    #> # A tibble: 2 × 7
    #>   cohort_definition_id number_records number_subjects reason_id reason          
    #>                  <int>          <int>           <int>     <int> <chr>           
    #> 1                    1              3               1         1 Initial qualify…
    #> 2                    2              1               1         1 Initial qualify…
    #> # ℹ 2 more variables: excluded_records <int>, excluded_subjects <int>
    # }
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/bind.cohort_table.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Bind two or more cohort tables

Source: [`R/methodBind.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodBind.R)

`bind.cohort_table.Rd`

Bind two or more cohort tables

## Usage
    
    
    # S3 method for class 'cohort_table'
    [bind](bind.html)(..., name)

## Arguments

...
    

Generated cohort set objects to bind. At least two must be provided.

name
    

Name of the new generated cohort set.

## Value

The cdm object with a new generated cohort set containing all of the cohorts passed.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cohort1 <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1,
      subject_id = 1:3,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-01"),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-05")
    )
    cohort2 <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = [c](https://rdrr.io/r/base/c.html)(2, 2, 3, 3, 3),
      subject_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3, 1, 2),
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-01"),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-05")
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          person_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), gender_concept_id = 0, year_of_birth = 1990,
          race_concept_id = 0, ethnicity_concept_id = 0
        ),
        "observation_period" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          observation_period_id = 1:3, person_id = 1:3,
          observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
          observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
          period_type_concept_id = 0
        )
      ),
      cdmName = "mock",
      cohortTables = [list](https://rdrr.io/r/base/list.html)("cohort1" = cohort1, "cohort2" = cohort2)
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in observation_period as do not match expected column type:
    #> • `period_type_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in cohort1 as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> Warning: ! 2 casted column in cohort2 as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> • `subject_id` from numeric to integer
    
    cdm <- [bind](bind.html)(cdm$cohort1, cdm$cohort2, name = "cohort3")
    [settings](settings.html)(cdm$cohort3)
    #> # A tibble: 3 × 2
    #>   cohort_definition_id cohort_name
    #>                  <int> <chr>      
    #> 1                    1 cohort_1   
    #> 2                    2 cohort_2   
    #> 3                    3 cohort_3   
    cdm$cohort3
    #> # A tibble: 8 × 4
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #> *                <int>      <int> <date>            <date>         
    #> 1                    1          1 2010-01-01        2010-01-05     
    #> 2                    1          2 2010-01-01        2010-01-05     
    #> 3                    1          3 2010-01-01        2010-01-05     
    #> 4                    2          1 2010-01-01        2010-01-05     
    #> 5                    2          2 2010-01-01        2010-01-05     
    #> 6                    3          3 2010-01-01        2010-01-05     
    #> 7                    3          1 2010-01-01        2010-01-05     
    #> 8                    3          2 2010-01-01        2010-01-05     
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/collect.cohort_table.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# To collect a `cohort_table` object.

Source: [`R/classCohortTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCohortTable.R)

`collect.cohort_table.Rd`

To collect a `cohort_table` object.

## Usage
    
    
    # S3 method for class 'cohort_table'
    [collect](https://dplyr.tidyverse.org/reference/compute.html)(x, ...)

## Arguments

x
    

`cohort_table` object.

...
    

Not used (for compatibility).

## Value

A data frame with the `cohort_table`

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/settings.cohort_table.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get cohort settings from a cohort_table object.

Source: [`R/methodSettings.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodSettings.R)

`settings.cohort_table.Rd`

Get cohort settings from a cohort_table object.

## Usage
    
    
    # S3 method for class 'cohort_table'
    [settings](settings.html)(x)

## Arguments

x
    

A cohort_table object.

## Value

A table with the details of the cohort settings.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    person <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = 1, person_id = 1,
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
      period_type_concept_id = 0
    )
    cohort <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1,
      subject_id = 1,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-01"),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2012-01-01")
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)("person" = person, "observation_period" = observation_period),
      cdmName = "test",
      cohortTables = [list](https://rdrr.io/r/base/list.html)("my_cohort" = cohort)
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 3 casted column in observation_period as do not match expected column type:
    #> • `observation_period_id` from numeric to integer
    #> • `person_id` from numeric to integer
    #> • `period_type_concept_id` from numeric to integer
    #> Warning: ! 2 casted column in my_cohort as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> • `subject_id` from numeric to integer
    
    [settings](settings.html)(cdm$my_cohort)
    #> # A tibble: 1 × 2
    #>   cohort_definition_id cohort_name
    #>                  <int> <chr>      
    #> 1                    1 cohort_1   
    
    cdm$my_cohort <- cdm$my_cohort |>
      [newCohortTable](newCohortTable.html)(cohortSetRef = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        cohort_definition_id = 1, cohort_name = "new_name"
      ))
    
    [settings](settings.html)(cdm$my_cohort)
    #> # A tibble: 1 × 2
    #>   cohort_definition_id cohort_name
    #>                  <dbl> <chr>      
    #> 1                    1 new_name   
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/summary.cohort_table.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Summary a generated cohort set

Source: [`R/summary.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/summary.R)

`summary.cohort_table.Rd`

Summary a generated cohort set

## Usage
    
    
    # S3 method for class 'cohort_table'
    [summary](https://rdrr.io/r/base/summary.html)(object, ...)

## Arguments

object
    

A generated cohort set object.

...
    

For compatibility (not used).

## Value

A summarised_result object with a summary of a cohort_table.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    person <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = 1, person_id = 1,
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
      period_type_concept_id = 0
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)("person" = person, "observation_period" = observation_period),
      cdmName = "test",
      cohortTables = [list](https://rdrr.io/r/base/list.html)("cohort1" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        cohort_definition_id = 1,
        subject_id = 1,
        cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-01"),
        cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-05")
      ))
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 3 casted column in observation_period as do not match expected column type:
    #> • `observation_period_id` from numeric to integer
    #> • `person_id` from numeric to integer
    #> • `period_type_concept_id` from numeric to integer
    #> Warning: ! 2 casted column in cohort1 as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> • `subject_id` from numeric to integer
    
    [summary](https://rdrr.io/r/base/summary.html)(cdm$cohort1)
    #> `cohort_definition_id` casted to character.
    #> `cohort_definition_id` casted to character.
    #> # A tibble: 6 × 13
    #>   result_id cdm_name group_name  group_level strata_name strata_level           
    #>       <int> <chr>    <chr>       <chr>       <chr>       <chr>                  
    #> 1         1 test     cohort_name cohort_1    overall     overall                
    #> 2         1 test     cohort_name cohort_1    overall     overall                
    #> 3         2 test     cohort_name cohort_1    reason      Initial qualifying eve…
    #> 4         2 test     cohort_name cohort_1    reason      Initial qualifying eve…
    #> 5         2 test     cohort_name cohort_1    reason      Initial qualifying eve…
    #> 6         2 test     cohort_name cohort_1    reason      Initial qualifying eve…
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/transformToSummarisedResult.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Create a <summarised_result> object from a data.frame, given a set of specifications.

Source: [`R/classSummarisedResult.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classSummarisedResult.R)

`transformToSummarisedResult.Rd`

Create a <summarised_result> object from a data.frame, given a set of specifications.

## Usage
    
    
    transformToSummarisedResult(
      x,
      group = [character](https://rdrr.io/r/base/character.html)(),
      strata = [character](https://rdrr.io/r/base/character.html)(),
      additional = [character](https://rdrr.io/r/base/character.html)(),
      estimates = [character](https://rdrr.io/r/base/character.html)(),
      settings = [character](https://rdrr.io/r/base/character.html)()
    )

## Arguments

x
    

A data.frame.

group
    

Columns in x to be used in group_name-group_level formatting.

strata
    

Columns in x to be used in strata_name-strata_level formatting.

additional
    

Columns in x to be used in additional_name-additional_level formatting.

estimates
    

Columns in x to be formatted into: estimate_name-estimate_type-estimate_value.

settings
    

Columns in x thta form the settings of the <summarised_result> object.

## Value

A <summarised_result> object.

## Examples
    
    
    x <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_name = [c](https://rdrr.io/r/base/c.html)("cohort1", "cohort2"),
      variable_name = "age",
      mean = [c](https://rdrr.io/r/base/c.html)(50, 45.3),
      median = [c](https://rdrr.io/r/base/c.html)(55L, 44L)
    )
    
    transformToSummarisedResult(
      x = x,
      group = [c](https://rdrr.io/r/base/c.html)("cohort_name"),
      estimates = [c](https://rdrr.io/r/base/c.html)("mean", "median")
    )
    #> ℹ Column `cdm_name` created as 'unknown' as not present in x.
    #> ℹ Column `variable_level` created as 'overall' as not present in x.
    #> `result_type`, `package_name`, and `package_version` added to settings.
    #> # A tibble: 4 × 13
    #>   result_id cdm_name group_name  group_level strata_name strata_level
    #>       <int> <chr>    <chr>       <chr>       <chr>       <chr>       
    #> 1         1 unknown  cohort_name cohort1     overall     overall     
    #> 2         1 unknown  cohort_name cohort1     overall     overall     
    #> 3         1 unknown  cohort_name cohort2     overall     overall     
    #> 4         1 unknown  cohort_name cohort2     overall     overall     
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/exportSummarisedResult.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Export a summarised_result object to a csv file.

Source: [`R/exportSummarisedResult.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/exportSummarisedResult.R)

`exportSummarisedResult.Rd`

Export a summarised_result object to a csv file.

## Usage
    
    
    exportSummarisedResult(
      ...,
      minCellCount = 5,
      fileName = "results_{cdm_name}_{date}.csv",
      path = [getwd](https://rdrr.io/r/base/getwd.html)(),
      logFile = [getOption](https://rdrr.io/r/base/options.html)("omopgenerics.logFile")
    )

## Arguments

...
    

A set of summarised_result objects.

minCellCount
    

Minimum count for suppression purposes.

fileName
    

Name of the file that will be created. Use {cdm_name} to refer to the cdmName of the objects and {date} to add the export date.

path
    

Path where to create the csv file. It is ignored if fileName it is a full name with path included.

logFile
    

Path to the log file to export.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/importSummarisedResult.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Import a set of summarised results.

Source: [`R/importSummarisedResult.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/importSummarisedResult.R)

`importSummarisedResult.Rd`

Import a set of summarised results.

## Usage
    
    
    importSummarisedResult(path, recursive = FALSE, ...)

## Arguments

path
    

Path to directory with CSV files containing summarised results or to a specific CSV file with a summarised result.

recursive
    

If TRUE and path is a directory, search for files will recurse into directories

...
    

Passed to `[readr::read_csv](https://readr.tidyverse.org/reference/read_delim.html)`.

## Value

A summarised result

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/estimateTypeChoices.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Choices that can be present in `estimate_type` column.

Source: [`R/classSummarisedResult.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classSummarisedResult.R)

`estimateTypeChoices.Rd`

Choices that can be present in `estimate_type` column.

## Usage
    
    
    estimateTypeChoices()

## Value

A character vector with the options that can be present in `estimate_type` column in the summarised_result objects.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    estimateTypeChoices()
    #> [1] "numeric"    "integer"    "date"       "character"  "proportion"
    #> [6] "percentage" "logical"   
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/resultColumns.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Required columns that the result tables must have.

Source: [`R/classSummarisedResult.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classSummarisedResult.R)

`resultColumns.Rd`

Required columns that the result tables must have.

## Usage
    
    
    resultColumns(table = "summarised_result")

## Arguments

table
    

Table to see required columns.

## Value

Required columns

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    resultColumns()
    #>  [1] "result_id"        "cdm_name"         "group_name"       "group_level"     
    #>  [5] "strata_name"      "strata_level"     "variable_name"    "variable_level"  
    #>  [9] "estimate_name"    "estimate_type"    "estimate_value"   "additional_name" 
    #> [13] "additional_level"
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/resultPackageVersion.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Check if different packages version are used for summarise_results object

Source: [`R/utilities.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/utilities.R)

`resultPackageVersion.Rd`

Check if different packages version are used for summarise_results object

## Usage
    
    
    resultPackageVersion(result)

## Arguments

result
    

a summarised results object

## Value

a summarised results object

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/isResultSuppressed.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# To check whether an object is already suppressed to a certain min cell count.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`isResultSuppressed.Rd`

To check whether an object is already suppressed to a certain min cell count.

## Usage
    
    
    isResultSuppressed(result, minCellCount = 5)

## Arguments

result
    

The suppressed result to check

minCellCount
    

Minimum count of records used when suppressing

## Value

Warning or message with check result

## Examples
    
    
    x <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      "result_id" = 1L,
      "cdm_name" = "eunomia",
      "group_name" = "cohort_name",
      "group_level" = "my_cohort",
      "strata_name" = [c](https://rdrr.io/r/base/c.html)("sex", "sex &&& age_group", "sex &&& year"),
      "strata_level" = [c](https://rdrr.io/r/base/c.html)("Female", "Male &&& <40", "Female &&& 2010"),
      "variable_name" = "number subjects",
      "variable_level" = NA_character_,
      "estimate_name" = "count",
      "estimate_type" = "integer",
      "estimate_value" = [c](https://rdrr.io/r/base/c.html)("100", "44", "14"),
      "additional_name" = "overall",
      "additional_level" = "overall"
    ) |>
      [newSummarisedResult](newSummarisedResult.html)()
    #> `result_type`, `package_name`, and `package_version` added to settings.
    
    isResultSuppressed(x)
    #> Warning: ✖ 1 set (3 rows) not suppressed.
    #> [1] FALSE
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/bind.summarised_result.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Bind two or summarised_result objects

Source: [`R/methodBind.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodBind.R)

`bind.summarised_result.Rd`

Bind two or summarised_result objects

## Usage
    
    
    # S3 method for class 'summarised_result'
    [bind](bind.html)(...)

## Arguments

...
    

summarised_result objects

## Value

A summarised_result object the merged objects.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          person_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), gender_concept_id = 0, year_of_birth = 1990,
          race_concept_id = 0, ethnicity_concept_id = 0
        ),
        "observation_period" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          observation_period_id = 1:3, person_id = 1:3,
          observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
          observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
          period_type_concept_id = 0
        )
      ),
      cdmName = "mock",
      cohortTables = [list](https://rdrr.io/r/base/list.html)("cohort1" = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        cohort_definition_id = 1,
        subject_id = 1:3,
        cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-01"),
        cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-05")
      ))
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in observation_period as do not match expected column type:
    #> • `period_type_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in cohort1 as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    
    result1 <- [summary](https://rdrr.io/r/base/summary.html)(cdm)
    result2 <- [summary](https://rdrr.io/r/base/summary.html)(cdm$cohort1)
    #> `cohort_definition_id` casted to character.
    #> `cohort_definition_id` casted to character.
    
    mergedResult <- [bind](bind.html)(result1, result2)
    mergedResult
    #> # A tibble: 19 × 13
    #>    result_id cdm_name group_name  group_level strata_name strata_level          
    #>        <int> <chr>    <chr>       <chr>       <chr>       <chr>                 
    #>  1         1 mock     overall     overall     overall     overall               
    #>  2         1 mock     overall     overall     overall     overall               
    #>  3         1 mock     overall     overall     overall     overall               
    #>  4         1 mock     overall     overall     overall     overall               
    #>  5         1 mock     overall     overall     overall     overall               
    #>  6         1 mock     overall     overall     overall     overall               
    #>  7         1 mock     overall     overall     overall     overall               
    #>  8         1 mock     overall     overall     overall     overall               
    #>  9         1 mock     overall     overall     overall     overall               
    #> 10         1 mock     overall     overall     overall     overall               
    #> 11         1 mock     overall     overall     overall     overall               
    #> 12         1 mock     overall     overall     overall     overall               
    #> 13         1 mock     overall     overall     overall     overall               
    #> 14         2 mock     cohort_name cohort_1    overall     overall               
    #> 15         2 mock     cohort_name cohort_1    overall     overall               
    #> 16         3 mock     cohort_name cohort_1    reason      Initial qualifying ev…
    #> 17         3 mock     cohort_name cohort_1    reason      Initial qualifying ev…
    #> 18         3 mock     cohort_name cohort_1    reason      Initial qualifying ev…
    #> 19         3 mock     cohort_name cohort_1    reason      Initial qualifying ev…
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/settings.summarised_result.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get settings from a summarised_result object.

Source: [`R/methodSettings.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodSettings.R)

`settings.summarised_result.Rd`

Get settings from a summarised_result object.

## Usage
    
    
    # S3 method for class 'summarised_result'
    [settings](settings.html)(x)

## Arguments

x
    

A summarised_result object.

## Value

A table with the settings.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    person <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = 1, person_id = 1,
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
      period_type_concept_id = 0
    )
    cohort <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      cohort_definition_id = 1,
      subject_id = 1,
      cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2010-01-01"),
      cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2012-01-01")
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)("person" = person, "observation_period" = observation_period),
      cdmName = "test",
      cohortTables = [list](https://rdrr.io/r/base/list.html)("my_cohort" = cohort)
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 3 casted column in observation_period as do not match expected column type:
    #> • `observation_period_id` from numeric to integer
    #> • `person_id` from numeric to integer
    #> • `period_type_concept_id` from numeric to integer
    #> Warning: ! 2 casted column in my_cohort as do not match expected column type:
    #> • `cohort_definition_id` from numeric to integer
    #> • `subject_id` from numeric to integer
    
    result <- [summary](https://rdrr.io/r/base/summary.html)(cdm$my_cohort)
    #> `cohort_definition_id` casted to character.
    #> `cohort_definition_id` casted to character.
    
    [settings](settings.html)(result)
    #> # A tibble: 2 × 10
    #>   result_id result_type     package_name package_version group strata additional
    #>       <int> <chr>           <chr>        <chr>           <chr> <chr>  <chr>     
    #> 1         1 cohort_count    omopgenerics 1.3.1           coho… ""     ""        
    #> 2         2 cohort_attriti… omopgenerics 1.3.1           coho… "reas… "reason_i…
    #> # ℹ 3 more variables: min_cell_count <chr>, cohort_definition_id <chr>,
    #> #   table_name <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/summary.summarised_result.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Summary a summarised_result

Source: [`R/summary.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/summary.R)

`summary.summarised_result.Rd`

Summary a summarised_result

## Usage
    
    
    # S3 method for class 'summarised_result'
    [summary](https://rdrr.io/r/base/summary.html)(object, ...)

## Arguments

object
    

A summarised_result object.

...
    

For compatibility (not used).

## Value

A summary of the result_types contained in a summarised_result object.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    person <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      person_id = 1, gender_concept_id = 0, year_of_birth = 1990,
      race_concept_id = 0, ethnicity_concept_id = 0
    )
    observation_period <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      observation_period_id = 1, person_id = 1,
      observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
      observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
      period_type_concept_id = 0
    )
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)("person" = person, "observation_period" = observation_period),
      cdmName = "test"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 3 casted column in observation_period as do not match expected column type:
    #> • `observation_period_id` from numeric to integer
    #> • `person_id` from numeric to integer
    #> • `period_type_concept_id` from numeric to integer
    
    result <- [summary](https://rdrr.io/r/base/summary.html)(cdm)
    
    [summary](https://rdrr.io/r/base/summary.html)(result)
    #> A summarised_result object with 13 rows, 1 different result_id, 1 different cdm
    #> names, and 7 settings.
    #> CDM names: test.
    #> Settings: result_type, package_name, package_version, group, strata,
    #> additional, and min_cell_count.
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/suppress.summarised_result.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Function to suppress counts in result objects

Source: [`R/methodSuppress.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodSuppress.R)

`suppress.summarised_result.Rd`

Function to suppress counts in result objects

## Usage
    
    
    # S3 method for class 'summarised_result'
    [suppress](suppress.html)(result, minCellCount = 5)

## Arguments

result
    

summarised_result object.

minCellCount
    

Minimum count of records to report results.

## Value

summarised_result with suppressed counts.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    my_result <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      "result_id" = "1",
      "cdm_name" = "mock",
      "result_type" = "summarised_characteristics",
      "package_name" = "omopgenerics",
      "package_version" = [as.character](https://rdrr.io/r/base/character.html)(utils::[packageVersion](https://rdrr.io/r/utils/packageDescription.html)("omopgenerics")),
      "group_name" = "overall",
      "group_level" = "overall",
      "strata_name" = [c](https://rdrr.io/r/base/c.html)([rep](https://rdrr.io/r/base/rep.html)("overall", 6), [rep](https://rdrr.io/r/base/rep.html)("sex", 3)),
      "strata_level" = [c](https://rdrr.io/r/base/c.html)([rep](https://rdrr.io/r/base/rep.html)("overall", 6), "male", "female", "female"),
      "variable_name" = [c](https://rdrr.io/r/base/c.html)(
        "number records", "age_group", "age_group",
        "age_group", "age_group", "my_variable", "number records", "age_group",
        "age_group"
      ),
      "variable_level" = [c](https://rdrr.io/r/base/c.html)(
        NA, "<50", "<50", ">=50", ">=50", NA, NA,
        "<50", "<50"
      ),
      "estimate_name" = [c](https://rdrr.io/r/base/c.html)(
        "count", "count", "percentage", "count", "percentage",
        "random", "count", "count", "percentage"
      ),
      "estimate_type" = [c](https://rdrr.io/r/base/c.html)(
        "integer", "integer", "percentage", "integer",
        "percentage", "numeric", "integer", "integer", "percentage"
      ),
      "estimate_value" = [c](https://rdrr.io/r/base/c.html)("10", "5", "50", "3", "30", "1", "3", "12", "6"),
      "additional_name" = "overall",
      "additional_level" = "overall"
    )
    my_result <- [newSummarisedResult](newSummarisedResult.html)(my_result)
    #> ! `result_type`, `package_name`, and `package_version` moved to settings. This
    #>   is not recommended as settings should be explicitly provided.
    #> ℹ NOTE that this can cause problems with settings.
    my_result |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 9
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ group_level      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "number records", "age_group", "age_group", "age_grou…
    #> $ variable_level   <chr> NA, "<50", "<50", ">=50", ">=50", NA, NA, "<50", "<50"
    #> $ estimate_name    <chr> "count", "count", "percentage", "count", "percentage"…
    #> $ estimate_type    <chr> "integer", "integer", "percentage", "integer", "perce…
    #> $ estimate_value   <chr> "10", "5", "50", "3", "30", "1", "3", "12", "6"
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…
    my_result <- [suppress](suppress.html)(my_result, minCellCount = 5)
    my_result |> [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: 9
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1
    #> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
    #> $ group_name       <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ group_level      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ variable_name    <chr> "number records", "age_group", "age_group", "age_grou…
    #> $ variable_level   <chr> NA, "<50", "<50", ">=50", ">=50", NA, NA, "<50", "<50"
    #> $ estimate_name    <chr> "count", "count", "percentage", "count", "percentage"…
    #> $ estimate_type    <chr> "integer", "integer", "percentage", "integer", "perce…
    #> $ estimate_value   <chr> "10", "5", "50", "-", "-", "1", "-", "12", "6"
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
    #> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/tidy.summarised_result.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Turn a `<summarised_result>` object into a tidy tibble

Source: [`R/methodTidy.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodTidy.R)

`tidy.summarised_result.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental) Provides tools for obtaining a tidy version of a `<summarised_result>` object. This tidy version will include the settings as columns, `estimate_value` will be pivotted into columns using `estimate_name` as names, and group, strata, and additional will be splitted.

## Usage
    
    
    # S3 method for class 'summarised_result'
    [tidy](https://generics.r-lib.org/reference/tidy.html)(x, ...)

## Arguments

x
    

A `<summarised_result>`.

...
    

For compatibility (not used).

## Value

A tibble.

## Examples
    
    
    {
      [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
      [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
      x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "result_id" = [as.integer](https://rdrr.io/r/base/integer.html)([c](https://rdrr.io/r/base/c.html)(1, 2)),
        "cdm_name" = [c](https://rdrr.io/r/base/c.html)("cprd", "eunomia"),
        "group_name" = "cohort_name",
        "group_level" = "my_cohort",
        "strata_name" = "sex",
        "strata_level" = "male",
        "variable_name" = "Age group",
        "variable_level" = "10 to 50",
        "estimate_name" = "count",
        "estimate_type" = "numeric",
        "estimate_value" = "5",
        "additional_name" = "overall",
        "additional_level" = "overall"
      ) |>
        [newSummarisedResult](newSummarisedResult.html)(settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          "result_id" = [c](https://rdrr.io/r/base/c.html)(1, 2), "custom" = [c](https://rdrr.io/r/base/c.html)("A", "B")
        ))
    
      x
    
      x |> [tidy](https://generics.r-lib.org/reference/tidy.html)()
    }
    #> `result_type`, `package_name`, and `package_version` added to settings.
    #> # A tibble: 2 × 7
    #>   cdm_name cohort_name sex   variable_name variable_level count custom
    #>   <chr>    <chr>       <chr> <chr>         <chr>          <dbl> <chr> 
    #> 1 cprd     my_cohort   male  Age group     10 to 50           5 A     
    #> 2 eunomia  my_cohort   male  Age group     10 to 50           5 B     
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/filterAdditional.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Filter the additional_name-additional_level pair in a summarised_result

Source: [`R/filter.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/filter.R)

`filterAdditional.Rd`

Filter the additional_name-additional_level pair in a summarised_result

## Usage
    
    
    filterAdditional(result, ...)

## Arguments

result
    

A `<summarised_result>` object.

...
    

Expressions that return a logical value (`[additionalColumns()](additionalColumns.html)` are used to evaluate the expression), and are defined in terms of the variables in .data. If multiple expressions are included, they are combined with the & operator. Only rows for which all conditions evaluate to TRUE are kept.

## Value

A `<summarised_result>` object with only the rows that fulfill the required specified additional.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      "result_id" = 1L,
      "cdm_name" = "eunomia",
      "group_name" = "cohort_name",
      "group_level" = [c](https://rdrr.io/r/base/c.html)("cohort1", "cohort2", "cohort3"),
      "strata_name" = "sex",
      "strata_level" = "Female",
      "variable_name" = "number subjects",
      "variable_level" = NA_character_,
      "estimate_name" = "count",
      "estimate_type" = "integer",
      "estimate_value" = [c](https://rdrr.io/r/base/c.html)("100", "44", "14"),
      "additional_name" = [c](https://rdrr.io/r/base/c.html)("year", "time_step", "year &&& time_step"),
      "additional_level" = [c](https://rdrr.io/r/base/c.html)("2010", "4", "2015 &&& 5")
    ) |>
      [newSummarisedResult](newSummarisedResult.html)()
    #> `result_type`, `package_name`, and `package_version` added to settings.
    
    x |>
      filterAdditional(year == "2010")
    #> # A tibble: 1 × 13
    #>   result_id cdm_name group_name  group_level strata_name strata_level
    #>       <int> <chr>    <chr>       <chr>       <chr>       <chr>       
    #> 1         1 eunomia  cohort_name cohort1     sex         Female      
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/filterGroup.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Filter the group_name-group_level pair in a summarised_result

Source: [`R/filter.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/filter.R)

`filterGroup.Rd`

Filter the group_name-group_level pair in a summarised_result

## Usage
    
    
    filterGroup(result, ...)

## Arguments

result
    

A `<summarised_result>` object.

...
    

Expressions that return a logical value (`[groupColumns()](groupColumns.html)` are used to evaluate the expression), and are defined in terms of the variables in .data. If multiple expressions are included, they are combined with the & operator. Only rows for which all conditions evaluate to TRUE are kept.

## Value

A `<summarised_result>` object with only the rows that fulfill the required specified group.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      "result_id" = 1L,
      "cdm_name" = "eunomia",
      "group_name" = [c](https://rdrr.io/r/base/c.html)("cohort_name", "age_group &&& cohort_name", "age_group"),
      "group_level" = [c](https://rdrr.io/r/base/c.html)("my_cohort", ">40 &&& second_cohort", "<40"),
      "strata_name" = "sex",
      "strata_level" = "Female",
      "variable_name" = "number subjects",
      "variable_level" = NA_character_,
      "estimate_name" = "count",
      "estimate_type" = "integer",
      "estimate_value" = [c](https://rdrr.io/r/base/c.html)("100", "44", "14"),
      "additional_name" = "overall",
      "additional_level" = "overall"
    ) |>
      [newSummarisedResult](newSummarisedResult.html)()
    #> `result_type`, `package_name`, and `package_version` added to settings.
    
    x |>
      filterGroup(cohort_name == "second_cohort")
    #> # A tibble: 1 × 13
    #>   result_id cdm_name group_name             group_level strata_name strata_level
    #>       <int> <chr>    <chr>                  <chr>       <chr>       <chr>       
    #> 1         1 eunomia  age_group &&& cohort_… >40 &&& se… sex         Female      
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/filterSettings.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Filter a `<summarised_result>` using the settings

Source: [`R/filter.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/filter.R)

`filterSettings.Rd`

Filter a `<summarised_result>` using the settings

## Usage
    
    
    filterSettings(result, ...)

## Arguments

result
    

A `<summarised_result>` object.

...
    

Expressions that return a logical value (columns in settings are used to evaluate the expression), and are defined in terms of the variables in .data. If multiple expressions are included, they are combined with the & operator. Only rows for which all conditions evaluate to TRUE are kept.

## Value

A `<summarised_result>` object with only the result_id rows that fulfill the required specified settings.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      "result_id" = [as.integer](https://rdrr.io/r/base/integer.html)([c](https://rdrr.io/r/base/c.html)(1, 2)),
      "cdm_name" = [c](https://rdrr.io/r/base/c.html)("cprd", "eunomia"),
      "group_name" = "cohort_name",
      "group_level" = "my_cohort",
      "strata_name" = "sex",
      "strata_level" = "male",
      "variable_name" = "Age group",
      "variable_level" = "10 to 50",
      "estimate_name" = "count",
      "estimate_type" = "numeric",
      "estimate_value" = "5",
      "additional_name" = "overall",
      "additional_level" = "overall"
    ) |>
      [newSummarisedResult](newSummarisedResult.html)(settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "result_id" = [c](https://rdrr.io/r/base/c.html)(1, 2), "custom" = [c](https://rdrr.io/r/base/c.html)("A", "B")
      ))
    #> `result_type`, `package_name`, and `package_version` added to settings.
    
    x
    #> # A tibble: 2 × 13
    #>   result_id cdm_name group_name  group_level strata_name strata_level
    #>       <int> <chr>    <chr>       <chr>       <chr>       <chr>       
    #> 1         1 cprd     cohort_name my_cohort   sex         male        
    #> 2         2 eunomia  cohort_name my_cohort   sex         male        
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    x |> filterSettings(custom == "A")
    #> # A tibble: 1 × 13
    #>   result_id cdm_name group_name  group_level strata_name strata_level
    #>       <int> <chr>    <chr>       <chr>       <chr>       <chr>       
    #> 1         1 cprd     cohort_name my_cohort   sex         male        
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/filterStrata.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Filter the strata_name-strata_level pair in a summarised_result

Source: [`R/filter.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/filter.R)

`filterStrata.Rd`

Filter the strata_name-strata_level pair in a summarised_result

## Usage
    
    
    filterStrata(result, ...)

## Arguments

result
    

A `<summarised_result>` object.

...
    

Expressions that return a logical value (`[strataColumns()](strataColumns.html)` are used to evaluate the expression), and are defined in terms of the variables in .data. If multiple expressions are included, they are combined with the & operator. Only rows for which all conditions evaluate to TRUE are kept.

## Value

A `<summarised_result>` object with only the rows that fulfill the required specified strata.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
    x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      "result_id" = 1L,
      "cdm_name" = "eunomia",
      "group_name" = "cohort_name",
      "group_level" = "my_cohort",
      "strata_name" = [c](https://rdrr.io/r/base/c.html)("sex", "sex &&& age_group", "sex &&& year"),
      "strata_level" = [c](https://rdrr.io/r/base/c.html)("Female", "Male &&& <40", "Female &&& 2010"),
      "variable_name" = "number subjects",
      "variable_level" = NA_character_,
      "estimate_name" = "count",
      "estimate_type" = "integer",
      "estimate_value" = [c](https://rdrr.io/r/base/c.html)("100", "44", "14"),
      "additional_name" = "overall",
      "additional_level" = "overall"
    ) |>
      [newSummarisedResult](newSummarisedResult.html)()
    #> `result_type`, `package_name`, and `package_version` added to settings.
    
    x |>
      filterStrata(sex == "Female")
    #> # A tibble: 2 × 13
    #>   result_id cdm_name group_name  group_level strata_name  strata_level   
    #>       <int> <chr>    <chr>       <chr>       <chr>        <chr>          
    #> 1         1 eunomia  cohort_name my_cohort   sex          Female         
    #> 2         1 eunomia  cohort_name my_cohort   sex &&& year Female &&& 2010
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/splitAdditional.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Split additional_name and additional_level columns

Source: [`R/split.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/split.R)

`splitAdditional.Rd`

Pivots the input dataframe so the values of the column additional_name are transformed into columns that contain values from the additional_level column.

## Usage
    
    
    splitAdditional(result, keep = FALSE, fill = "overall")

## Arguments

result
    

A dataframe with at least the columns additional_name and additional_level.

keep
    

Whether to keep the original group_name and group_level columns.

fill
    

Optionally, a character that specifies what value should be filled in with when missing.

## Value

A dataframe.

## Examples
    
    
    {
      [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
      [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
      x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "result_id" = [as.integer](https://rdrr.io/r/base/integer.html)([c](https://rdrr.io/r/base/c.html)(1, 2)),
        "cdm_name" = [c](https://rdrr.io/r/base/c.html)("cprd", "eunomia"),
        "group_name" = "cohort_name",
        "group_level" = "my_cohort",
        "strata_name" = "sex",
        "strata_level" = "male",
        "variable_name" = "Age group",
        "variable_level" = "10 to 50",
        "estimate_name" = "count",
        "estimate_type" = "numeric",
        "estimate_value" = "5",
        "additional_name" = "overall",
        "additional_level" = "overall"
      ) |>
        [newSummarisedResult](newSummarisedResult.html)(settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          "result_id" = [c](https://rdrr.io/r/base/c.html)(1, 2), "custom" = [c](https://rdrr.io/r/base/c.html)("A", "B")
        ))
    
      x
    
      x |> splitAdditional()
    }
    #> `result_type`, `package_name`, and `package_version` added to settings.
    #> # A tibble: 2 × 11
    #>   result_id cdm_name group_name  group_level strata_name strata_level
    #>       <int> <chr>    <chr>       <chr>       <chr>       <chr>       
    #> 1         1 cprd     cohort_name my_cohort   sex         male        
    #> 2         2 eunomia  cohort_name my_cohort   sex         male        
    #> # ℹ 5 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/splitAll.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Split all pairs name-level into columns.

Source: [`R/split.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/split.R)

`splitAll.Rd`

Pivots the input dataframe so any pair name-level columns are transformed into columns (name) that contain values from the corresponding level.

## Usage
    
    
    splitAll(result, keep = FALSE, fill = "overall", exclude = "variable")

## Arguments

result
    

A data.frame.

keep
    

Whether to keep the original name-level columns.

fill
    

A character that specifies what value should be filled in when missing.

exclude
    

Name of a column pair to exclude.

## Value

A dataframe with group, strata and additional as columns.

## Examples
    
    
    {
      [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
      [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
      x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "result_id" = [as.integer](https://rdrr.io/r/base/integer.html)([c](https://rdrr.io/r/base/c.html)(1, 2)),
        "cdm_name" = [c](https://rdrr.io/r/base/c.html)("cprd", "eunomia"),
        "group_name" = "cohort_name",
        "group_level" = "my_cohort",
        "strata_name" = "sex",
        "strata_level" = "male",
        "variable_name" = "Age group",
        "variable_level" = "10 to 50",
        "estimate_name" = "count",
        "estimate_type" = "numeric",
        "estimate_value" = "5",
        "additional_name" = "overall",
        "additional_level" = "overall"
      ) |>
        [newSummarisedResult](newSummarisedResult.html)(settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          "result_id" = [c](https://rdrr.io/r/base/c.html)(1, 2), "custom" = [c](https://rdrr.io/r/base/c.html)("A", "B")
        ))
    
      x
    
      x |> splitAll()
    }
    #> `result_type`, `package_name`, and `package_version` added to settings.
    #> # A tibble: 2 × 9
    #>   result_id cdm_name cohort_name sex   variable_name variable_level
    #>       <int> <chr>    <chr>       <chr> <chr>         <chr>         
    #> 1         1 cprd     my_cohort   male  Age group     10 to 50      
    #> 2         2 eunomia  my_cohort   male  Age group     10 to 50      
    #> # ℹ 3 more variables: estimate_name <chr>, estimate_type <chr>,
    #> #   estimate_value <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/splitGroup.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Split group_name and group_level columns

Source: [`R/split.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/split.R)

`splitGroup.Rd`

Pivots the input dataframe so the values of the column group_name are transformed into columns that contain values from the group_level column.

## Usage
    
    
    splitGroup(result, keep = FALSE, fill = "overall")

## Arguments

result
    

A dataframe with at least the columns group_name and group_level.

keep
    

Whether to keep the original group_name and group_level columns.

fill
    

Optionally, a character that specifies what value should be filled in with when missing.

## Value

A dataframe.

## Examples
    
    
    {
      [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
      [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
      x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "result_id" = [as.integer](https://rdrr.io/r/base/integer.html)([c](https://rdrr.io/r/base/c.html)(1, 2)),
        "cdm_name" = [c](https://rdrr.io/r/base/c.html)("cprd", "eunomia"),
        "group_name" = "cohort_name",
        "group_level" = "my_cohort",
        "strata_name" = "sex",
        "strata_level" = "male",
        "variable_name" = "Age group",
        "variable_level" = "10 to 50",
        "estimate_name" = "count",
        "estimate_type" = "numeric",
        "estimate_value" = "5",
        "additional_name" = "overall",
        "additional_level" = "overall"
      ) |>
        [newSummarisedResult](newSummarisedResult.html)(settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          "result_id" = [c](https://rdrr.io/r/base/c.html)(1, 2), "custom" = [c](https://rdrr.io/r/base/c.html)("A", "B")
        ))
    
      x
    
      x |> splitGroup()
    }
    #> `result_type`, `package_name`, and `package_version` added to settings.
    #> # A tibble: 2 × 12
    #>   result_id cdm_name cohort_name strata_name strata_level variable_name
    #>       <int> <chr>    <chr>       <chr>       <chr>        <chr>        
    #> 1         1 cprd     my_cohort   sex         male         Age group    
    #> 2         2 eunomia  my_cohort   sex         male         Age group    
    #> # ℹ 6 more variables: variable_level <chr>, estimate_name <chr>,
    #> #   estimate_type <chr>, estimate_value <chr>, additional_name <chr>,
    #> #   additional_level <chr>
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/splitStrata.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Split strata_name and strata_level columns

Source: [`R/split.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/split.R)

`splitStrata.Rd`

Pivots the input dataframe so the values of the column strata_name are transformed into columns that contain values from the strata_level column.

## Usage
    
    
    splitStrata(result, keep = FALSE, fill = "overall")

## Arguments

result
    

A dataframe with at least the columns strata_name and strata_level.

keep
    

Whether to keep the original group_name and group_level columns.

fill
    

Optionally, a character that specifies what value should be filled in with when missing.

## Value

A dataframe.

## Examples
    
    
    {
      [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
      [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
      x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "result_id" = [as.integer](https://rdrr.io/r/base/integer.html)([c](https://rdrr.io/r/base/c.html)(1, 2)),
        "cdm_name" = [c](https://rdrr.io/r/base/c.html)("cprd", "eunomia"),
        "group_name" = "cohort_name",
        "group_level" = "my_cohort",
        "strata_name" = "sex",
        "strata_level" = "male",
        "variable_name" = "Age group",
        "variable_level" = "10 to 50",
        "estimate_name" = "count",
        "estimate_type" = "numeric",
        "estimate_value" = "5",
        "additional_name" = "overall",
        "additional_level" = "overall"
      ) |>
        [newSummarisedResult](newSummarisedResult.html)(settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          "result_id" = [c](https://rdrr.io/r/base/c.html)(1, 2), "custom" = [c](https://rdrr.io/r/base/c.html)("A", "B")
        ))
    
      x
    
      x |> splitStrata()
    }
    #> `result_type`, `package_name`, and `package_version` added to settings.
    #> # A tibble: 2 × 12
    #>   result_id cdm_name group_name  group_level sex   variable_name variable_level
    #>       <int> <chr>    <chr>       <chr>       <chr> <chr>         <chr>         
    #> 1         1 cprd     cohort_name my_cohort   male  Age group     10 to 50      
    #> 2         2 eunomia  cohort_name my_cohort   male  Age group     10 to 50      
    #> # ℹ 5 more variables: estimate_name <chr>, estimate_type <chr>,
    #> #   estimate_value <chr>, additional_name <chr>, additional_level <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/uniteAdditional.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Unite one or more columns in additional_name-additional_level format

Source: [`R/unite.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/unite.R)

`uniteAdditional.Rd`

Unites targeted table columns into additional_name-additional_level columns.

## Usage
    
    
    uniteAdditional(
      x,
      cols = [character](https://rdrr.io/r/base/character.html)(0),
      keep = FALSE,
      ignore = [c](https://rdrr.io/r/base/c.html)(NA, "overall")
    )

## Arguments

x
    

Tibble or dataframe.

cols
    

Columns to aggregate.

keep
    

Whether to keep the original columns.

ignore
    

Level values to ignore.

## Value

A tibble with the new columns.

## Examples
    
    
    x <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      variable = "number subjects",
      value = [c](https://rdrr.io/r/base/c.html)(10, 15, 40, 78),
      sex = [c](https://rdrr.io/r/base/c.html)("Male", "Female", "Male", "Female"),
      age_group = [c](https://rdrr.io/r/base/c.html)("<40", ">40", ">40", "<40")
    )
    
    x |>
      uniteAdditional([c](https://rdrr.io/r/base/c.html)("sex", "age_group"))
    #> # A tibble: 4 × 4
    #>   variable        value additional_name   additional_level
    #>   <chr>           <dbl> <chr>             <chr>           
    #> 1 number subjects    10 sex &&& age_group Male &&& <40    
    #> 2 number subjects    15 sex &&& age_group Female &&& >40  
    #> 3 number subjects    40 sex &&& age_group Male &&& >40    
    #> 4 number subjects    78 sex &&& age_group Female &&& <40  
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/uniteGroup.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Unite one or more columns in group_name-group_level format

Source: [`R/unite.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/unite.R)

`uniteGroup.Rd`

Unites targeted table columns into group_name-group_level columns.

## Usage
    
    
    uniteGroup(x, cols = [character](https://rdrr.io/r/base/character.html)(0), keep = FALSE, ignore = [c](https://rdrr.io/r/base/c.html)(NA, "overall"))

## Arguments

x
    

Tibble or dataframe.

cols
    

Columns to aggregate.

keep
    

Whether to keep the original columns.

ignore
    

Level values to ignore.

## Value

A tibble with the new columns.

## Examples
    
    
    x <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      variable = "number subjects",
      value = [c](https://rdrr.io/r/base/c.html)(10, 15, 40, 78),
      sex = [c](https://rdrr.io/r/base/c.html)("Male", "Female", "Male", "Female"),
      age_group = [c](https://rdrr.io/r/base/c.html)("<40", ">40", ">40", "<40")
    )
    
    x |>
      uniteGroup([c](https://rdrr.io/r/base/c.html)("sex", "age_group"))
    #> # A tibble: 4 × 4
    #>   variable        value group_name        group_level   
    #>   <chr>           <dbl> <chr>             <chr>         
    #> 1 number subjects    10 sex &&& age_group Male &&& <40  
    #> 2 number subjects    15 sex &&& age_group Female &&& >40
    #> 3 number subjects    40 sex &&& age_group Male &&& >40  
    #> 4 number subjects    78 sex &&& age_group Female &&& <40
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/uniteStrata.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Unite one or more columns in strata_name-strata_level format

Source: [`R/unite.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/unite.R)

`uniteStrata.Rd`

Unites targeted table columns into strata_name-strata_level columns.

## Usage
    
    
    uniteStrata(x, cols = [character](https://rdrr.io/r/base/character.html)(0), keep = FALSE, ignore = [c](https://rdrr.io/r/base/c.html)(NA, "overall"))

## Arguments

x
    

Tibble or dataframe.

cols
    

Columns to aggregate.

keep
    

Whether to keep the original columns.

ignore
    

Level values to ignore.

## Value

A tibble with the new columns.

## Examples
    
    
    x <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      variable = "number subjects",
      value = [c](https://rdrr.io/r/base/c.html)(10, 15, 40, 78),
      sex = [c](https://rdrr.io/r/base/c.html)("Male", "Female", "Male", "Female"),
      age_group = [c](https://rdrr.io/r/base/c.html)("<40", ">40", ">40", "<40")
    )
    
    x |>
      uniteStrata([c](https://rdrr.io/r/base/c.html)("sex", "age_group"))
    #> # A tibble: 4 × 4
    #>   variable        value strata_name       strata_level  
    #>   <chr>           <dbl> <chr>             <chr>         
    #> 1 number subjects    10 sex &&& age_group Male &&& <40  
    #> 2 number subjects    15 sex &&& age_group Female &&& >40
    #> 3 number subjects    40 sex &&& age_group Male &&& >40  
    #> 4 number subjects    78 sex &&& age_group Female &&& <40
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/strataColumns.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Identify variables in strata_name column

Source: [`R/columns.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/columns.R)

`strataColumns.Rd`

Identifies and returns the unique values in strata_name column.

## Usage
    
    
    strataColumns(result)

## Arguments

result
    

A tibble.

## Value

Unique values of the strata name column.

## Examples
    
    
    {
      [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
      [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
      x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "result_id" = [as.integer](https://rdrr.io/r/base/integer.html)([c](https://rdrr.io/r/base/c.html)(1, 2)),
        "cdm_name" = [c](https://rdrr.io/r/base/c.html)("cprd", "eunomia"),
        "group_name" = "cohort_name",
        "group_level" = "my_cohort",
        "strata_name" = "sex",
        "strata_level" = "male",
        "variable_name" = "Age group",
        "variable_level" = "10 to 50",
        "estimate_name" = "count",
        "estimate_type" = "numeric",
        "estimate_value" = "5",
        "additional_name" = "overall",
        "additional_level" = "overall"
      ) |>
        [newSummarisedResult](newSummarisedResult.html)(settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          "result_id" = [c](https://rdrr.io/r/base/c.html)(1, 2), "custom" = [c](https://rdrr.io/r/base/c.html)("A", "B")
        ))
    
      x
    
      x |> strataColumns()
    }
    #> `result_type`, `package_name`, and `package_version` added to settings.
    #> [1] "sex"
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/additionalColumns.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Identify variables in additional_name column

Source: [`R/columns.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/columns.R)

`additionalColumns.Rd`

Identifies and returns the unique values in additional_name column.

## Usage
    
    
    additionalColumns(result)

## Arguments

result
    

A tibble.

## Value

Unique values of the additional name column.

## Examples
    
    
    {
      [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
      [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
      x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "result_id" = [as.integer](https://rdrr.io/r/base/integer.html)([c](https://rdrr.io/r/base/c.html)(1, 2)),
        "cdm_name" = [c](https://rdrr.io/r/base/c.html)("cprd", "eunomia"),
        "group_name" = "cohort_name",
        "group_level" = "my_cohort",
        "strata_name" = "sex",
        "strata_level" = "male",
        "variable_name" = "Age group",
        "variable_level" = "10 to 50",
        "estimate_name" = "count",
        "estimate_type" = "numeric",
        "estimate_value" = "5",
        "additional_name" = "overall",
        "additional_level" = "overall"
      ) |>
        [newSummarisedResult](newSummarisedResult.html)(settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          "result_id" = [c](https://rdrr.io/r/base/c.html)(1, 2), "custom" = [c](https://rdrr.io/r/base/c.html)("A", "B")
        ))
    
      x
    
      x |> additionalColumns()
    }
    #> `result_type`, `package_name`, and `package_version` added to settings.
    #> character(0)
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/groupColumns.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Identify variables in group_name column

Source: [`R/columns.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/columns.R)

`groupColumns.Rd`

Identifies and returns the unique values in group_name column.

## Usage
    
    
    groupColumns(result)

## Arguments

result
    

A tibble.

## Value

Unique values of the group name column.

## Examples
    
    
    {
      [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
      [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
      x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "result_id" = [as.integer](https://rdrr.io/r/base/integer.html)([c](https://rdrr.io/r/base/c.html)(1, 2)),
        "cdm_name" = [c](https://rdrr.io/r/base/c.html)("cprd", "eunomia"),
        "group_name" = "cohort",
        "group_level" = "my_cohort",
        "strata_name" = "sex",
        "strata_level" = "male",
        "variable_name" = "Age group",
        "variable_level" = "10 to 50",
        "estimate_name" = "count",
        "estimate_type" = "numeric",
        "estimate_value" = "5",
        "additional_name" = "overall",
        "additional_level" = "overall"
      ) |>
        [newSummarisedResult](newSummarisedResult.html)(settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          "result_id" = [c](https://rdrr.io/r/base/c.html)(1, 2), "custom" = [c](https://rdrr.io/r/base/c.html)("A", "B")
        ))
    
      x
    
      x |> groupColumns()
    }
    #> `result_type`, `package_name`, and `package_version` added to settings.
    #> [1] "cohort"
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/settingsColumns.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Identify settings columns of a `<summarised_result>`

Source: [`R/columns.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/columns.R)

`settingsColumns.Rd`

Identifies and returns the columns of the settings table obtained by using `[settings()](settings.html)` in a `<summarised_result>` object.

## Usage
    
    
    settingsColumns(result, metadata = FALSE)

## Arguments

result
    

A `<summarised_result>`.

metadata
    

Whether to include metadata columns in settings or not.

## Value

Vector with names of the settings columns

## Examples
    
    
    {
      [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
      [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
      x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "result_id" = [as.integer](https://rdrr.io/r/base/integer.html)([c](https://rdrr.io/r/base/c.html)(1, 2)),
        "cdm_name" = [c](https://rdrr.io/r/base/c.html)("cprd", "eunomia"),
        "group_name" = "cohort_name",
        "group_level" = "my_cohort",
        "strata_name" = "sex",
        "strata_level" = "male",
        "variable_name" = "Age group",
        "variable_level" = "10 to 50",
        "estimate_name" = "count",
        "estimate_type" = "numeric",
        "estimate_value" = "5",
        "additional_name" = "overall",
        "additional_level" = "overall"
      ) |>
        [newSummarisedResult](newSummarisedResult.html)(settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          "result_id" = [c](https://rdrr.io/r/base/c.html)(1, 2), "custom" = [c](https://rdrr.io/r/base/c.html)("A", "B")
        ))
    
      x
    
      x |> settingsColumns()
    }
    #> `result_type`, `package_name`, and `package_version` added to settings.
    #> [1] "custom"
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/tidyColumns.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Identify tidy columns of a `<summarised_result>`

Source: [`R/columns.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/columns.R)

`tidyColumns.Rd`

Identifies and returns the columns that the tidy version of the `<summarised_result>` will have.

## Usage
    
    
    tidyColumns(result)

## Arguments

result
    

A `<summarised_result>`.

## Value

Table columns after applying `[tidy()](https://generics.r-lib.org/reference/tidy.html)` function to a `<summarised_result>`.

## Examples
    
    
    {
      [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
      [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
      x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "result_id" = [as.integer](https://rdrr.io/r/base/integer.html)([c](https://rdrr.io/r/base/c.html)(1, 2)),
        "cdm_name" = [c](https://rdrr.io/r/base/c.html)("cprd", "eunomia"),
        "group_name" = "cohort_name",
        "group_level" = "my_cohort",
        "strata_name" = "sex",
        "strata_level" = "male",
        "variable_name" = "Age group",
        "variable_level" = "10 to 50",
        "estimate_name" = "count",
        "estimate_type" = "numeric",
        "estimate_value" = "5",
        "additional_name" = "overall",
        "additional_level" = "overall"
      ) |>
        [newSummarisedResult](newSummarisedResult.html)(settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          "result_id" = [c](https://rdrr.io/r/base/c.html)(1, 2), "custom" = [c](https://rdrr.io/r/base/c.html)("A", "B")
        ))
    
      x
    
      x |> tidyColumns()
    }
    #> `result_type`, `package_name`, and `package_version` added to settings.
    #> [1] "cdm_name"       "cohort_name"    "sex"            "variable_name" 
    #> [5] "variable_level" "count"          "custom"        
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/pivotEstimates.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Set estimates as columns

Source: [`R/pivot.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/pivot.R)

`pivotEstimates.Rd`

Pivot the estimates as new columns in result table.

## Usage
    
    
    pivotEstimates(result, pivotEstimatesBy = "estimate_name", nameStyle = NULL)

## Arguments

result
    

A `<summarised_result>`.

pivotEstimatesBy
    

Names from which pivot wider the estimate values. If NULL the table will not be pivotted.

nameStyle
    

Name style (glue package specifications) to customise names when pivotting estimates. If NULL standard tidyr::pivot_wider formatting will be used.

## Value

A tibble.

## Examples
    
    
    {
      [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
      [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
      x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "result_id" = 1L,
        "cdm_name" = [c](https://rdrr.io/r/base/c.html)("cprd", "eunomia"),
        "group_name" = "cohort_name",
        "group_level" = "my_cohort",
        "strata_name" = "sex",
        "strata_level" = "male",
        "variable_name" = "Age group",
        "variable_level" = "10 to 50",
        "estimate_name" = "count",
        "estimate_type" = "numeric",
        "estimate_value" = "5",
        "additional_name" = "overall",
        "additional_level" = "overall"
      ) |>
        [newSummarisedResult](newSummarisedResult.html)()
    
      x |>
        pivotEstimates()
    }
    #> `result_type`, `package_name`, and `package_version` added to settings.
    #> # A tibble: 2 × 11
    #>   result_id cdm_name group_name  group_level strata_name strata_level
    #>       <int> <chr>    <chr>       <chr>       <chr>       <chr>       
    #> 1         1 cprd     cohort_name my_cohort   sex         male        
    #> 2         1 eunomia  cohort_name my_cohort   sex         male        
    #> # ℹ 5 more variables: variable_name <chr>, variable_level <chr>,
    #> #   additional_name <chr>, additional_level <chr>, count <dbl>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/addSettings.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Add settings columns to a `<summarised_result>` object

Source: [`R/addSettings.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/addSettings.R)

`addSettings.Rd`

Add settings columns to a `<summarised_result>` object

## Usage
    
    
    addSettings(result, settingsColumn = [settingsColumns](settingsColumns.html)(result))

## Arguments

result
    

A `<summarised_result>` object.

settingsColumn
    

Settings to be added as columns, by default `settingsColumns(result)` will be added. If NULL or empty character vector, no settings will be added.

## Value

A `<summarised_result>` object with the added setting columns.

## Examples
    
    
    {
      [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
      [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    
      x <- [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "result_id" = [as.integer](https://rdrr.io/r/base/integer.html)([c](https://rdrr.io/r/base/c.html)(1, 2)),
        "cdm_name" = [c](https://rdrr.io/r/base/c.html)("cprd", "eunomia"),
        "group_name" = "cohort_name",
        "group_level" = "my_cohort",
        "strata_name" = "sex",
        "strata_level" = "male",
        "variable_name" = "Age group",
        "variable_level" = "10 to 50",
        "estimate_name" = "count",
        "estimate_type" = "numeric",
        "estimate_value" = "5",
        "additional_name" = "overall",
        "additional_level" = "overall"
      ) |>
        [newSummarisedResult](newSummarisedResult.html)(settings = [tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          "result_id" = [c](https://rdrr.io/r/base/c.html)(1, 2), "custom" = [c](https://rdrr.io/r/base/c.html)("A", "B")
        ))
    
      x
    
      x |> addSettings()
    }
    #> 
    #> Attaching package: ‘dplyr’
    #> The following objects are masked from ‘package:stats’:
    #> 
    #>     filter, lag
    #> The following objects are masked from ‘package:base’:
    #> 
    #>     intersect, setdiff, setequal, union
    #> `result_type`, `package_name`, and `package_version` added to settings.
    #> # A tibble: 2 × 14
    #>   result_id cdm_name group_name  group_level strata_name strata_level
    #>       <int> <chr>    <chr>       <chr>       <chr>       <chr>       
    #> 1         1 cprd     cohort_name my_cohort   sex         male        
    #> 2         2 eunomia  cohort_name my_cohort   sex         male        
    #> # ℹ 8 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>, custom <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/exportCodelist.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Export a codelist object.

Source: [`R/exportCodelist.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/exportCodelist.R)

`exportCodelist.Rd`

Export a codelist object.

## Usage
    
    
    exportCodelist(x, path, type = "json")

## Arguments

x
    

A codelist

path
    

Path to where files will be created.

type
    

Type of files to export. Currently 'json' and 'csv' are supported.

## Value

Files with codelists

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/exportConceptSetExpression.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Export a concept set expression.

Source: [`R/exportConceptSetExpression.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/exportConceptSetExpression.R)

`exportConceptSetExpression.Rd`

Export a concept set expression.

## Usage
    
    
    exportConceptSetExpression(x, path, type = "json")

## Arguments

x
    

A concept set expression

path
    

Path to where files will be created.

type
    

Type of files to export. Currently 'json' and 'csv' are supported.

## Value

Files with concept set expressions

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/importCodelist.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Import a codelist.

Source: [`R/importCodelist.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/importCodelist.R)

`importCodelist.Rd`

Import a codelist.

## Usage
    
    
    importCodelist(path, type = "json")

## Arguments

path
    

Path to where files will be created.

type
    

Type of files to export. Currently 'json' and 'csv' are supported.

## Value

A codelist

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/importConceptSetExpression.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Import a concept set expression.

Source: [`R/importConceptSetExpression.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/importConceptSetExpression.R)

`importConceptSetExpression.Rd`

Import a concept set expression.

## Usage
    
    
    importConceptSetExpression(path, type = "json")

## Arguments

path
    

Path to where files will be created.

type
    

Type of files to export. Currently 'json' and 'csv' are supported.

## Value

A concept set expression

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/print.codelist.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Print a codelist

Source: [`R/classCodelist.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCodelist.R)

`print.codelist.Rd`

Print a codelist

## Usage
    
    
    # S3 method for class 'codelist'
    [print](https://rdrr.io/r/base/print.html)(x, ...)

## Arguments

x
    

A codelist

...
    

Included for compatibility with generic. Not used.

## Value

Invisibly returns the input

## Examples
    
    
    codes <- [list](https://rdrr.io/r/base/list.html)("disease X" = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), "disease Y" = [c](https://rdrr.io/r/base/c.html)(4, 5))
    codes <- [newCodelist](newCodelist.html)(codes)
    #> Warning: ! `codelist` casted to integers.
    [print](https://rdrr.io/r/base/print.html)(codes)
    #> 
    #> ── 2 codelists ─────────────────────────────────────────────────────────────────
    #> 
    #> - disease X (3 codes)
    #> - disease Y (2 codes)
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/print.codelist_with_details.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Print a codelist with details

Source: [`R/classCodelistWithDetails.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCodelistWithDetails.R)

`print.codelist_with_details.Rd`

Print a codelist with details

## Usage
    
    
    # S3 method for class 'codelist_with_details'
    [print](https://rdrr.io/r/base/print.html)(x, ...)

## Arguments

x
    

A codelist with details

...
    

Included for compatibility with generic. Not used.

## Value

Invisibly returns the input

## Examples
    
    
    codes <- [list](https://rdrr.io/r/base/list.html)("disease X" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      concept_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3),
      other = [c](https://rdrr.io/r/base/c.html)("a", "b", "c")
    ))
    codes <- [newCodelistWithDetails](newCodelistWithDetails.html)(codes)
    [print](https://rdrr.io/r/base/print.html)(codes)
    #> 
    #> ── 1 codelist with details ─────────────────────────────────────────────────────
    #> 
    #> - disease X (3 codes)
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/print.conceptSetExpression.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Print a concept set expression

Source: [`R/classConceptSetExpression.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classConceptSetExpression.R)

`print.conceptSetExpression.Rd`

Print a concept set expression

## Usage
    
    
    # S3 method for class 'conceptSetExpression'
    [print](https://rdrr.io/r/base/print.html)(x, ...)

## Arguments

x
    

A concept set expression

...
    

Included for compatibility with generic. Not used.

## Value

Invisibly returns the input

## Examples
    
    
    asthma_cs <- [list](https://rdrr.io/r/base/list.html)(
      "asthma_narrow" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "concept_id" = 1,
        "excluded" = FALSE,
        "descendants" = TRUE,
        "mapped" = FALSE
      ),
      "asthma_broad" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
        "concept_id" = [c](https://rdrr.io/r/base/c.html)(1, 2),
        "excluded" = FALSE,
        "descendants" = TRUE,
        "mapped" = FALSE
      )
    )
    asthma_cs <- [newConceptSetExpression](newConceptSetExpression.html)(asthma_cs)
    [print](https://rdrr.io/r/base/print.html)(asthma_cs)
    #> 
    #> ── 2 concept set expressions ───────────────────────────────────────────────────
    #> 
    #> - asthma_broad (2 concept criteria)
    #> - asthma_narrow (1 concept criteria)
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/existingIndexes.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Existing indexes in a cdm object

Source: [`R/indexes.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/indexes.R)

`existingIndexes.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    existingIndexes(cdm, name)

## Arguments

cdm
    

A cdm_reference object.

name
    

Name(s) of the cdm tables.

## Value

A tibble with 3 columns: `table_class` class of the table, `table_name` name of the table, and `existing_index` index definition.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/expectedIndexes.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Expected indexes in a cdm object

Source: [`R/indexes.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/indexes.R)

`expectedIndexes.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    expectedIndexes(cdm, name)

## Arguments

cdm
    

A cdm_reference object.

name
    

Name(s) of the cdm tables.

## Value

A tibble with 3 columns: `table_class` class of the table, `table_name` name of the table, and `expected_index` index definition.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/statusIndexes.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Status of the indexes

Source: [`R/indexes.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/indexes.R)

`statusIndexes.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    statusIndexes(cdm, name = NULL)

## Arguments

cdm
    

A cdm_reference object.

name
    

Name(s) of the cdm tables.

## Value

A tibble with 3 columns: `table_class` class of the table, `table_name` name of the table, `index` index definition, and `index_status` status of the index, either: 'missing', 'extra', 'present'.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/createIndexes.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Create the missing indexes

Source: [`R/indexes.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/indexes.R)

`createIndexes.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    createIndexes(cdm, name = NULL)

## Arguments

cdm
    

A cdm_reference object.

name
    

Name(s) of the cdm tables.

## Value

Whether the process was completed successfully.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/createTableIndex.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Create a table index

Source: [`R/indexes.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/indexes.R)

`createTableIndex.Rd`

[![\[Experimental\]](figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

## Usage
    
    
    createTableIndex(table, index)

## Arguments

table
    

A cdm_table object.

index
    

Index to be created.

## Value

Whether the index could be created

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/validateAchillesTable.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Validate if a cdm_table is a valid achilles table.

Source: [`R/classAchillesTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classAchillesTable.R)

`validateAchillesTable.Rd`

Validate if a cdm_table is a valid achilles table.

## Usage
    
    
    validateAchillesTable(
      table,
      version = NULL,
      cast = FALSE,
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

table
    

A cdm_table to validate.

version
    

The cdm vocabulary version.

cast
    

Whether to cast columns to required type.

call
    

Passed to cli call.

## Value

invisible achilles table

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/validateAgeGroupArgument.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Validate the ageGroup argument. It must be a list of two integerish numbers lower age and upper age, both of the must be greater or equal to 0 and lower age must be lower or equal to the upper age. If not named automatic names will be given in the output list.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateAgeGroupArgument.Rd`

Validate the ageGroup argument. It must be a list of two integerish numbers lower age and upper age, both of the must be greater or equal to 0 and lower age must be lower or equal to the upper age. If not named automatic names will be given in the output list.

## Usage
    
    
    validateAgeGroupArgument(
      ageGroup,
      multipleAgeGroup = TRUE,
      overlap = FALSE,
      null = TRUE,
      ageGroupName = "age_group",
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

ageGroup
    

age group in a list.

multipleAgeGroup
    

allow mutliple age group.

overlap
    

allow overlapping ageGroup.

null
    

null age group allowed true or false.

ageGroupName
    

Name of the default age group.

call
    

parent frame.

## Value

validate ageGroup

## Examples
    
    
    validateAgeGroupArgument([list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 39), [c](https://rdrr.io/r/base/c.html)(40, Inf)))
    #> $age_group
    #> $age_group$`0 to 39`
    #> [1]  0 39
    #> 
    #> $age_group$`40 or above`
    #> [1]  40 Inf
    #> 
    #> 
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/validateCdmArgument.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Validate if an object in a valid cdm_reference.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateCdmArgument.Rd`

Validate if an object in a valid cdm_reference.

## Usage
    
    
    validateCdmArgument(
      cdm,
      checkOverlapObservation = FALSE,
      checkStartBeforeEndObservation = FALSE,
      checkPlausibleObservationDates = FALSE,
      checkPerson = FALSE,
      requiredTables = [character](https://rdrr.io/r/base/character.html)(),
      validation = "error",
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

cdm
    

A cdm_reference object

checkOverlapObservation
    

TRUE to perform check on no overlap observation period

checkStartBeforeEndObservation
    

TRUE to perform check on correct observational start and end date

checkPlausibleObservationDates
    

TRUE to perform check that there are no implausible observation period start dates (before 1800-01-01) or end dates (after the current date)

checkPerson
    

TRUE to perform check on person id in all clinical table are in person table

requiredTables
    

Name of tables that are required to be part of the cdm_reference object.

validation
    

How to perform validation: "error", "warning".

call
    

A call argument to pass to cli functions.

## Value

A cdm_reference object

## Examples
    
    
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          person_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), gender_concept_id = 0, year_of_birth = 1990,
          race_concept_id = 0, ethnicity_concept_id = 0
        ),
        "observation_period" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          observation_period_id = 1:3, person_id = 1:3,
          observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
          observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
          period_type_concept_id = 0
        )
      ),
      cdmName = "mock"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in observation_period as do not match expected column type:
    #> • `period_type_concept_id` from numeric to integer
    
    validateCdmArgument(cdm)
    #> 
    #> ── # OMOP CDM reference (local) of mock ────────────────────────────────────────
    #> • omop tables: observation_period, person
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/validateCdmTable.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Validate if a table is a valid cdm_table object.

Source: [`R/classCdmTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmTable.R)

`validateCdmTable.Rd`

Validate if a table is a valid cdm_table object.

## Usage
    
    
    validateCdmTable(table, name = NULL, call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)())

## Arguments

table
    

Object to validate.

name
    

If we want to validate that the table has a specific name.

call
    

Call argument that will be passed to `cli`.

## Value

The table or an error message.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/validateCohortArgument.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Validate a cohort table input.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateCohortArgument.Rd`

Validate a cohort table input.

## Usage
    
    
    validateCohortArgument(
      cohort,
      checkEndAfterStart = FALSE,
      checkOverlappingEntries = FALSE,
      checkMissingValues = FALSE,
      checkInObservation = FALSE,
      checkAttributes = FALSE,
      checkPermanentTable = FALSE,
      dropExtraColumns = FALSE,
      validation = "error",
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

cohort
    

Object to be validated as a valid cohort input.

checkEndAfterStart
    

If TRUE a check that all cohort end dates come on or after cohort start date will be performed.

checkOverlappingEntries
    

If TRUE a check that no individuals have overlapping cohort entries will be performed.

checkMissingValues
    

If TRUE a check that there are no missing values in required fields will be performed.

checkInObservation
    

If TRUE a check that cohort entries are within the individuals observation periods will be performed.

checkAttributes
    

Whether to check if attributes are present and populated correctly.

checkPermanentTable
    

Whether to check if the table has to be a permanent table.

dropExtraColumns
    

Whether to drop extra columns that are not the required ones.

validation
    

How to perform validation: "error", "warning".

call
    

A call argument to pass to cli functions.

## Examples
    
    
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          person_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), gender_concept_id = 0, year_of_birth = 1990,
          race_concept_id = 0, ethnicity_concept_id = 0
        ),
        "observation_period" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          observation_period_id = 1:3, person_id = 1:3,
          observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
          observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
          period_type_concept_id = 0
        )
       ),
       cohortTables = [list](https://rdrr.io/r/base/list.html)(
        cohort = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          cohort_definition_id = 1L,
          subject_id = 1L,
          cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-01"),
          cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2021-02-10")
        )
      ),
      cdmName = "mock"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in observation_period as do not match expected column type:
    #> • `period_type_concept_id` from numeric to integer
    
    validateCohortArgument(cdm$cohort)
    #> # A tibble: 1 × 4
    #>   cohort_definition_id subject_id cohort_start_date cohort_end_date
    #>                  <int>      <int> <date>            <date>         
    #> 1                    1          1 2020-01-01        2021-02-10     
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/validateCohortIdArgument.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Validate cohortId argument. CohortId can either be a cohort_definition_id value, a cohort_name or a tidyselect expression referinc to cohort_names. If you want to support tidyselect expressions please use the function as: `validateCohortIdArgument({{cohortId}}, cohort)`.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateCohortIdArgument.Rd`

Validate cohortId argument. CohortId can either be a cohort_definition_id value, a cohort_name or a tidyselect expression referinc to cohort_names. If you want to support tidyselect expressions please use the function as: `validateCohortIdArgument({{cohortId}}, cohort)`.

## Usage
    
    
    validateCohortIdArgument(
      cohortId,
      cohort,
      null = TRUE,
      validation = "error",
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

cohortId
    

A cohortId vector to be validated.

cohort
    

A cohort_table object.

null
    

Whether `NULL` is accepted. If NULL all `cohortId` will be returned.

validation
    

How to perform validation: "error", "warning".

call
    

A call argument to pass to cli functions.

## Examples
    
    
    cdm <- [cdmFromTables](cdmFromTables.html)(
      tables = [list](https://rdrr.io/r/base/list.html)(
        "person" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          person_id = [c](https://rdrr.io/r/base/c.html)(1, 2, 3), gender_concept_id = 0, year_of_birth = 1990,
          race_concept_id = 0, ethnicity_concept_id = 0
        ),
        "observation_period" = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          observation_period_id = 1:3, person_id = 1:3,
          observation_period_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2000-01-01"),
          observation_period_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2023-12-31"),
          period_type_concept_id = 0
        )
       ),
       cohortTables = [list](https://rdrr.io/r/base/list.html)(
        cohort = dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
          cohort_definition_id = 1L,
          subject_id = 1L,
          cohort_start_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2020-01-01"),
          cohort_end_date = [as.Date](https://rdrr.io/r/base/as.Date.html)("2021-02-10")
        )
      ),
      cdmName = "mock"
    )
    #> Warning: ! 5 casted column in person as do not match expected column type:
    #> • `person_id` from numeric to integer
    #> • `gender_concept_id` from numeric to integer
    #> • `year_of_birth` from numeric to integer
    #> • `race_concept_id` from numeric to integer
    #> • `ethnicity_concept_id` from numeric to integer
    #> Warning: ! 1 casted column in observation_period as do not match expected column type:
    #> • `period_type_concept_id` from numeric to integer
    
    validateCohortIdArgument(NULL, cdm$cohort)
    #> [1] 1
    validateCohortIdArgument(1L, cdm$cohort)
    #> [1] 1
    validateCohortIdArgument(2L, cdm$cohort, validation = "warning")
    #> Warning: ! cohort definition id: 2 not defined in settings.
    #> Warning: ! cohortId is empty.
    #> integer(0)
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/validateColumn.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Validate whether a variable points to a certain exiting column in a table.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateColumn.Rd`

Validate whether a variable points to a certain exiting column in a table.

## Usage
    
    
    validateColumn(
      column,
      x,
      type = [c](https://rdrr.io/r/base/c.html)("character", "date", "logical", "numeric", "integer"),
      validation = "error",
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

column
    

Name of a column that you want to check that exist in `x` table.

x
    

Table to check if the column exist.

type
    

Type of the column.

validation
    

Whether to throw warning or error.

call
    

Passed to cli functions.

## Value

the validated name

## Examples
    
    
    x <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(a = 1, b = "xxx")
    
    validateColumn("a", x, validation = "warning")
    #> [1] "a"
    validateColumn("a", x, type = "character", validation = "warning")
    #> Warning: ! a type must be a choice of: `character`; but it is numeric.
    #> [1] "a"
    validateColumn("a", x, type = "numeric", validation = "warning")
    #> [1] "a"
    validateColumn("not_existing", x, type = "numeric", validation = "warning")
    #> Warning: ! not_existing column does not exist.
    #> [1] "not_existing"
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/validateConceptSetArgument.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Validate conceptSet argument. It can either be a list, a codelist, a concept set expression or a codelist with details. The output will always be a codelist.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateConceptSetArgument.Rd`

Validate conceptSet argument. It can either be a list, a codelist, a concept set expression or a codelist with details. The output will always be a codelist.

## Usage
    
    
    validateConceptSetArgument(
      conceptSet,
      cdm = NULL,
      validation = "error",
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

conceptSet
    

It can be either a named list of concepts or a codelist, codelist_with_details or concept_set_expression object.

cdm
    

A cdm_reference object, needed if a concept_set_expression is provided.

validation
    

How to perform validation: "error", "warning".

call
    

A call argument to pass to cli functions.

## Value

A codelist object.

## Examples
    
    
    conceptSet <- [list](https://rdrr.io/r/base/list.html)(disease_x = [c](https://rdrr.io/r/base/c.html)(1L, 2L))
    validateConceptSetArgument(conceptSet)
    #> 
    #> ── 1 codelist ──────────────────────────────────────────────────────────────────
    #> 
    #> - disease_x (2 codes)
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/validateNameArgument.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Validate name argument. It must be a snake_case character vector. You can add the a cdm object to check `name` is not already used in that cdm.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateNameArgument.Rd`

Validate name argument. It must be a snake_case character vector. You can add the a cdm object to check `name` is not already used in that cdm.

## Usage
    
    
    validateNameArgument(
      name,
      cdm = NULL,
      validation = "error",
      null = FALSE,
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

name
    

Name of a new table to be added to a cdm object.

cdm
    

A cdm_reference object. It will check if a table named name already exists in the cdm.

validation
    

How to perform validation: "error", "warning".

null
    

If TRUE, name can be NULL

call
    

A call argument to pass to cli functions.

## Examples
    
    
    # this is a validate name
    name <- "my_new_table"
    validateNameArgument(name)
    #> [1] "my_new_table"
    
    # this is not
    name <- "myTableNAME"
    validateNameArgument(name, validation = "warning")
    #> Warning: ! `name` was modified: myTableNAME -> my_table_name
    #> [1] "my_table_name"
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/validateNameLevel.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Validate if two columns are valid Name-Level pair.

Source: [`R/classSummarisedResult.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classSummarisedResult.R)

`validateNameLevel.Rd`

Validate if two columns are valid Name-Level pair.

## Usage
    
    
    validateNameLevel(
      x,
      prefix,
      sep = " &&& ",
      validation = "error",
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

x
    

A tibble.

prefix
    

Prefix for the name-level pair, e.g. 'strata' for strata_name-strata_level pair.

sep
    

Separation pattern.

validation
    

Either 'error', 'warning' or 'message'.

call
    

Will be used by cli to report errors.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/validateNameStyle.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Validate `nameStyle` argument. If any of the element in `...` has length greater than 1 it must be contained in nameStyle. Note that snake case notation is used.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateNameStyle.Rd`

Validate `nameStyle` argument. If any of the element in `...` has length greater than 1 it must be contained in nameStyle. Note that snake case notation is used.

## Usage
    
    
    validateNameStyle(nameStyle, ..., call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)())

## Arguments

nameStyle
    

A character vector. It must contain all the `...` elements in snake_case format and between `[{}](https://rdrr.io/r/base/Paren.html)`.

...
    

Elements to be included.

call
    

Passed to cli functions.

## Value

invisible nameStyle.

## Examples
    
    
    validateNameStyle(
      nameStyle = "hi_{cohort_name}",
      cohortName = [c](https://rdrr.io/r/base/c.html)("cohort1", "cohort2"),
      otherVariable = [c](https://rdrr.io/r/base/c.html)("only 1 value")
    )
    
    if (FALSE) { # \dontrun{
    validateNameStyle(
      nameStyle = "hi_{cohort_name}",
      cohortName = [c](https://rdrr.io/r/base/c.html)("cohort1", "cohort2"),
      otherVariable = [c](https://rdrr.io/r/base/c.html)("value1", "value2")
    )
    } # }
    validateNameStyle(
      nameStyle = "{other_variable}_hi_{cohort_name}",
      cohortName = [c](https://rdrr.io/r/base/c.html)("cohort1", "cohort2"),
      otherVariable = [c](https://rdrr.io/r/base/c.html)("value1", "value2")
    )
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/validateNewColumn.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Validate a new column of a table

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateNewColumn.Rd`

Validate a new column of a table

## Usage
    
    
    validateNewColumn(table, column, validation = "warning", call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)())

## Arguments

table
    

The table to check if the column already exists.

column
    

Character vector with the name(s) of the new column(s).

validation
    

Whether to throw warning or error.

call
    

Passed to cli functions.

## Value

table without conflicting columns.

## Examples
    
    
    x <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      column1 = [c](https://rdrr.io/r/base/c.html)(1L, 2L),
      column2 = [c](https://rdrr.io/r/base/c.html)("a", "b")
    )
    validateNewColumn(x, "not_exiting_column")
    #> # A tibble: 2 × 2
    #>   column1 column2
    #>     <int> <chr>  
    #> 1       1 a      
    #> 2       2 b      
    validateNewColumn(x, "column1")
    #> Warning: ! columns `column1` already exist in the table. They will be overwritten.
    #> # A tibble: 2 × 1
    #>   column2
    #>   <chr>  
    #> 1 a      
    #> 2 b      
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/validateOmopTable.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Validate an omop_table

Source: [`R/classOmopTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classOmopTable.R)

`validateOmopTable.Rd`

Validate an omop_table

## Usage
    
    
    validateOmopTable(
      omopTable,
      version = NULL,
      cast = FALSE,
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

omopTable
    

An omop_table to check.

version
    

The version of the cdm.

cast
    

Whether to cast columns to the correct type.

call
    

Call argument that will be passed to `cli` error message.

## Value

An omop_table object.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/validateResultArgument.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Validate if a an object is a valid 'summarised_result' object.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateResultArgument.Rd`

Validate if a an object is a valid 'summarised_result' object.

## Usage
    
    
    validateResultArgument(
      result,
      checkNoDuplicates = FALSE,
      checkNameLevel = FALSE,
      checkSuppression = FALSE,
      validation = "error",
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

result
    

summarised_result object to validate.

checkNoDuplicates
    

Whether there are not allowed duplicates in the result object.

checkNameLevel
    

Whether the name-level paired columns are can be correctly split.

checkSuppression
    

Whether the suppression in the result object is well defined.

validation
    

Only error is supported at the moment.

call
    

parent.frame

## Value

summarise result object

## Examples
    
    
    x <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(
      "result_id" = 1L,
      "cdm_name" = "eunomia",
      "group_name" = "cohort_name",
      "group_level" = "my_cohort",
      "strata_name" = [c](https://rdrr.io/r/base/c.html)("sex", "sex &&& age_group", "sex &&& year"),
      "strata_level" = [c](https://rdrr.io/r/base/c.html)("Female", "Male &&& <40", "Female &&& 2010"),
      "variable_name" = "number subjects",
      "variable_level" = NA_character_,
      "estimate_name" = "count",
      "estimate_type" = "integer",
      "estimate_value" = [c](https://rdrr.io/r/base/c.html)("100", "44", "14"),
      "additional_name" = "overall",
      "additional_level" = "overall"
    ) |>
      [newSummarisedResult](newSummarisedResult.html)()
    #> `result_type`, `package_name`, and `package_version` added to settings.
    
    validateResultArgument(x)
    #> # A tibble: 3 × 13
    #>   result_id cdm_name group_name  group_level strata_name       strata_level   
    #>       <int> <chr>    <chr>       <chr>       <chr>             <chr>          
    #> 1         1 eunomia  cohort_name my_cohort   sex               Female         
    #> 2         1 eunomia  cohort_name my_cohort   sex &&& age_group Male &&& <40   
    #> 3         1 eunomia  cohort_name my_cohort   sex &&& year      Female &&& 2010
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/validateStrataArgument.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# To validate a strata list. It makes sure that elements are unique and point to columns in table.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateStrataArgument.Rd`

To validate a strata list. It makes sure that elements are unique and point to columns in table.

## Usage
    
    
    validateStrataArgument(strata, table, call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)())

## Arguments

strata
    

A list of characters that point to columns in table.

table
    

A table with columns.

call
    

Passed to cli functions.

## Value

The same strata input or an error if the input is incorrect.

## Examples
    
    
    strata <- [list](https://rdrr.io/r/base/list.html)("age", "sex", [c](https://rdrr.io/r/base/c.html)("age", "sex"))
    x <- dplyr::[tibble](https://tibble.tidyverse.org/reference/tibble.html)(age = 30L, sex = "Female")
    
    validateStrataArgument(strata, x)
    #> [[1]]
    #> [1] "age"
    #> 
    #> [[2]]
    #> [1] "sex"
    #> 
    #> [[3]]
    #> [1] "age" "sex"
    #> 
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/validateWindowArgument.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Validate a window argument. It must be a list of two elements (window start and window end), both must be integerish and window start must be lower or equal than window end.

Source: [`R/validate.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/validate.R)

`validateWindowArgument.Rd`

Validate a window argument. It must be a list of two elements (window start and window end), both must be integerish and window start must be lower or equal than window end.

## Usage
    
    
    validateWindowArgument(window, snakeCase = TRUE, call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)())

## Arguments

window
    

time window

snakeCase
    

return default window name in snake case if TRUE

call
    

A call argument to pass to cli functions.

## Value

time window

## Examples
    
    
    validateWindowArgument([list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 15), [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)))
    #> $`0_to_15`
    #> [1]  0 15
    #> 
    #> $minf_to_inf
    #> [1] -Inf  Inf
    #> 
    validateWindowArgument([list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(0, 15), [c](https://rdrr.io/r/base/c.html)(-Inf, Inf)), snakeCase = FALSE)
    #> $`0 to 15`
    #> [1]  0 15
    #> 
    #> $`-inf to inf`
    #> [1] -Inf  Inf
    #> 
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/assertCharacter.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Assert that an object is a character and fulfill certain conditions.

Source: [`R/assert.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/assert.R)

`assertCharacter.Rd`

Assert that an object is a character and fulfill certain conditions.

## Usage
    
    
    assertCharacter(
      x,
      length = NULL,
      na = FALSE,
      null = FALSE,
      unique = FALSE,
      named = FALSE,
      minNumCharacter = 0,
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)(),
      msg = NULL
    )

## Arguments

x
    

Variable to check.

length
    

Required length. If `NULL` length is not checked.

na
    

Whether it can contain NA values.

null
    

Whether it can be NULL.

unique
    

Whether it has to contain unique elements.

named
    

Whether it has to be named.

minNumCharacter
    

Minimum number of characters that all elements must have.

call
    

Call argument that will be passed to `cli` error message.

msg
    

Custom error message.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/assertChoice.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Assert that an object is within a certain oprtions.

Source: [`R/assert.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/assert.R)

`assertChoice.Rd`

Assert that an object is within a certain oprtions.

## Usage
    
    
    assertChoice(
      x,
      choices,
      length = NULL,
      na = FALSE,
      null = FALSE,
      unique = FALSE,
      named = FALSE,
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)(),
      msg = NULL
    )

## Arguments

x
    

Variable to check.

choices
    

Options that x is allowed to be.

length
    

Required length. If `NULL` length is not checked.

na
    

Whether it can contain NA values.

null
    

Whether it can be NULL.

unique
    

Whether it has to contain unique elements.

named
    

Whether it has to be named.

call
    

Call argument that will be passed to `cli` error message.

msg
    

Custom error message.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/assertClass.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Assert that an object has a certain class.

Source: [`R/assert.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/assert.R)

`assertClass.Rd`

Assert that an object has a certain class.

## Usage
    
    
    assertClass(
      x,
      class,
      length = NULL,
      null = FALSE,
      all = FALSE,
      extra = TRUE,
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)(),
      msg = NULL
    )

## Arguments

x
    

To check.

class
    

Expected class or classes.

length
    

Required length. If `NULL` length is not checked.

null
    

Whether it can be NULL.

all
    

Whether it should have all the classes or only at least one of them.

extra
    

Whether the object can have extra classes.

call
    

Call argument that will be passed to `cli`.

msg
    

Custom error message.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/assertDate.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Assert Date

Source: [`R/assert.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/assert.R)

`assertDate.Rd`

Assert Date

## Usage
    
    
    assertDate(
      x,
      length = NULL,
      na = FALSE,
      null = FALSE,
      unique = FALSE,
      named = FALSE,
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)(),
      msg = NULL
    )

## Arguments

x
    

Expression to check.

length
    

Required length.

na
    

Whether it can contain NA values.

null
    

Whether it can be NULL.

unique
    

Whether it has to contain unique elements.

named
    

Whether it has to be named.

call
    

Call argument that will be passed to `cli` error message.

msg
    

Custom error message.

## Value

x

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/assertList.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Assert that an object is a list.

Source: [`R/assert.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/assert.R)

`assertList.Rd`

Assert that an object is a list.

## Usage
    
    
    assertList(
      x,
      length = NULL,
      na = FALSE,
      null = FALSE,
      unique = FALSE,
      named = FALSE,
      class = NULL,
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)(),
      msg = NULL
    )

## Arguments

x
    

Variable to check.

length
    

Required length. If `NULL` length is not checked.

na
    

Whether it can contain NA values.

null
    

Whether it can be NULL.

unique
    

Whether it has to contain unique elements.

named
    

Whether it has to be named.

class
    

Class that the elements must have.

call
    

Call argument that will be passed to `cli` error message.

msg
    

Custom error message.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/assertLogical.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Assert that an object is a logical.

Source: [`R/assert.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/assert.R)

`assertLogical.Rd`

Assert that an object is a logical.

## Usage
    
    
    assertLogical(
      x,
      length = NULL,
      na = FALSE,
      null = FALSE,
      named = FALSE,
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)(),
      msg = NULL
    )

## Arguments

x
    

Variable to check.

length
    

Required length. If `NULL` length is not checked.

na
    

Whether it can contain NA values.

null
    

Whether it can be NULL.

named
    

Whether it has to be named.

call
    

Call argument that will be passed to `cli` error message.

msg
    

Custom error message.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/assertNumeric.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Assert that an object is a numeric.

Source: [`R/assert.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/assert.R)

`assertNumeric.Rd`

Assert that an object is a numeric.

## Usage
    
    
    assertNumeric(
      x,
      integerish = FALSE,
      min = -Inf,
      max = Inf,
      length = NULL,
      na = FALSE,
      null = FALSE,
      unique = FALSE,
      named = FALSE,
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)(),
      msg = NULL
    )

## Arguments

x
    

Variable to check.

integerish
    

Whether it has to be an integer

min
    

Minimum value that the object can be.

max
    

Maximum value that the object can be.

length
    

Required length. If `NULL` length is not checked.

na
    

Whether it can contain NA values.

null
    

Whether it can be NULL.

unique
    

Whether it has to contain unique elements.

named
    

Whether it has to be named.

call
    

Call argument that will be passed to `cli` error message.

msg
    

Custom error message.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/assertTable.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Assert that an object is a table.

Source: [`R/assert.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/assert.R)

`assertTable.Rd`

Assert that an object is a table.

## Usage
    
    
    assertTable(
      x,
      class = NULL,
      numberColumns = NULL,
      numberRows = NULL,
      columns = [character](https://rdrr.io/r/base/character.html)(),
      allowExtraColumns = TRUE,
      null = FALSE,
      unique = FALSE,
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)(),
      msg = NULL
    )

## Arguments

x
    

Variable to check.

class
    

A class that the table must have: "tbl", "data.fram", "tbl_sql", ...

numberColumns
    

Number of columns that it has to contain.

numberRows
    

Number of rows that it has to contain.

columns
    

Name of the columns required.

allowExtraColumns
    

Whether extra columns are allowed.

null
    

Whether it can be NULL.

unique
    

Whether it has to contain unique rows.

call
    

Call argument that will be passed to `cli` error message.

msg
    

Custom error message.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/assertTrue.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Assert that an expression is TRUE.

Source: [`R/assert.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/assert.R)

`assertTrue.Rd`

Assert that an expression is TRUE.

## Usage
    
    
    assertTrue(x, null = FALSE, call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)(), msg = NULL)

## Arguments

x
    

Expression to check.

null
    

Whether it can be NULL.

call
    

Call argument that will be passed to `cli` error message.

msg
    

Custom error message.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/insertFromSource.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Convert a table that is not a cdm_table but have the same original source to a cdm_table. This Table is not meant to be used to insert tables in the cdm, please use insertTable instead.

Source: [`R/methodInsertFromSource.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodInsertFromSource.R)

`insertFromSource.Rd`

[![\[Deprecated\]](figures/lifecycle-deprecated.svg)](https://lifecycle.r-lib.org/articles/stages.html#deprecated)

## Usage
    
    
    insertFromSource(cdm, value)

## Arguments

cdm
    

A cdm_reference object.

value
    

A table that shares source with the cdm_reference object.

## Value

A table in the cdm_reference environment

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/sourceType.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get the source type of an object.

Source: [`R/classCdmSource.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCdmSource.R)

`sourceType.Rd`

Get the source type of an object.

## Usage
    
    
    sourceType(x)

## Arguments

x
    

Object to know the source type.

## Value

A character vector that defines the type of cdm_source.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/tmpPrefix.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Create a temporary prefix for tables, that contains a unique prefix that starts with tmp.

Source: [`R/compute.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/compute.R)

`tmpPrefix.Rd`

Create a temporary prefix for tables, that contains a unique prefix that starts with tmp.

## Usage
    
    
    tmpPrefix()

## Value

A temporary prefix.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    tmpPrefix()
    #> [1] "tmp_002_"
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/uniqueId.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Get a unique Identifier with a certain number of characters and a prefix.

Source: [`R/utilities.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/utilities.R)

`uniqueId.Rd`

Get a unique Identifier with a certain number of characters and a prefix.

## Usage
    
    
    uniqueId(n = 1, exclude = [character](https://rdrr.io/r/base/character.html)(), nChar = 3, prefix = "id_")

## Arguments

n
    

Number of identifiers.

exclude
    

Columns to exclude.

nChar
    

Number of characters.

prefix
    

A prefix for the identifiers.

## Value

A character vector with n unique identifiers.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/uniqueTableName.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Create a unique table name

Source: [`R/compute.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/compute.R)

`uniqueTableName.Rd`

Create a unique table name

## Usage
    
    
    uniqueTableName(prefix = "")

## Arguments

prefix
    

Prefix for the table names.

## Value

A string that can be used as a dbplyr temp table name

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omopgenerics](https://darwin-eu.github.io/omopgenerics/))
    uniqueTableName()
    #> [1] "og_002_1758279866"
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/isTableEmpty.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Check if a table is empty or not

Source: [`R/utilities.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/utilities.R)

`isTableEmpty.Rd`

Check if a table is empty or not

## Usage
    
    
    isTableEmpty(table)

## Arguments

table
    

a table

## Value

Boolean to indicate if a cdm_table is empty (TRUE or FALSE).

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/toSnakeCase.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Convert a character vector to snake case

Source: [`R/utilities.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/utilities.R)

`toSnakeCase.Rd`

Convert a character vector to snake case

## Usage
    
    
    toSnakeCase(x)

## Arguments

x
    

Character vector to convert

## Value

A snake_case vector

## Examples
    
    
    toSnakeCase("myVariable")
    #> [1] "my_variable"
    
    toSnakeCase([c](https://rdrr.io/r/base/c.html)("cohort1", "Cohort22b"))
    #> [1] "cohort1"   "cohort22b"
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/combineStrata.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Provide all combinations of strata levels.

Source: [`R/combineStrata.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/combineStrata.R)

`combineStrata.Rd`

Provide all combinations of strata levels.

## Usage
    
    
    combineStrata(levels, overall = FALSE)

## Arguments

levels
    

Vector of all strata levels to combine.

overall
    

Whether to provide an empty element `[character()](https://rdrr.io/r/base/character.html)`.

## Value

A vector of all combinations of strata.

## Examples
    
    
    combineStrata([character](https://rdrr.io/r/base/character.html)())
    #> list()
    combineStrata([character](https://rdrr.io/r/base/character.html)(), overall = TRUE)
    #> [[1]]
    #> character(0)
    #> 
    combineStrata([c](https://rdrr.io/r/base/c.html)("age", "sex"), overall = TRUE)
    #> [[1]]
    #> character(0)
    #> 
    #> [[2]]
    #> [1] "age"
    #> 
    #> [[3]]
    #> [1] "sex"
    #> 
    #> [[4]]
    #> [1] "age" "sex"
    #> 
    combineStrata([c](https://rdrr.io/r/base/c.html)("age", "sex", "year"))
    #> [[1]]
    #> [1] "age"
    #> 
    #> [[2]]
    #> [1] "sex"
    #> 
    #> [[3]]
    #> [1] "year"
    #> 
    #> [[4]]
    #> [1] "age" "sex"
    #> 
    #> [[5]]
    #> [1] "age"  "year"
    #> 
    #> [[6]]
    #> [1] "sex"  "year"
    #> 
    #> [[7]]
    #> [1] "age"  "sex"  "year"
    #> 
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/createLogFile.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Create a log file

Source: [`R/logger.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/logger.R)

`createLogFile.Rd`

Create a log file

## Usage
    
    
    createLogFile(logFile = here::[here](https://here.r-lib.org/reference/here.html)("log_{date}_{time}"))

## Arguments

logFile
    

File path to write logging messages. You can use '{date}' and '{time}' to add the date and time in the log file name.

## Value

Invisible TRUE if logger was created correctly.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    logFile <- [tempfile](https://rdrr.io/r/base/tempfile.html)(pattern = "log_{date}_{time}", fileext = ".txt")
    createLogFile(logFile = logFile)
    #> ℹ Creating log file: /tmp/Rtmpmt8NbS/log_2025_09_19_11_04_021d9dba8cfa4.txt.
    #> [2025-09-19 11:04:02] - Log file created
    
    [logMessage](logMessage.html)("Starting analysis")
    #> [2025-09-19 11:04:02] - Starting analysis
    1 + 1
    #> [1] 2
    [logMessage](logMessage.html)("Analysis finished")
    #> [2025-09-19 11:04:02] - Analysis finished
    
    res <- [summariseLogFile](summariseLogFile.html)()
    #> [2025-09-19 11:04:02] - Exporting log file
    
    [glimpse](https://pillar.r-lib.org/reference/glimpse.html)(res)
    #> Rows: 4
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1
    #> $ cdm_name         <chr> "unknown", "unknown", "unknown", "unknown"
    #> $ group_name       <chr> "overall", "overall", "overall", "overall"
    #> $ group_level      <chr> "overall", "overall", "overall", "overall"
    #> $ strata_name      <chr> "log_id", "log_id", "log_id", "log_id"
    #> $ strata_level     <chr> "1", "2", "3", "4"
    #> $ variable_name    <chr> "Log file created", "Starting analysis", "Analysis fi…
    #> $ variable_level   <chr> NA, NA, NA, NA
    #> $ estimate_name    <chr> "date_time", "date_time", "date_time", "date_time"
    #> $ estimate_type    <chr> "character", "character", "character", "character"
    #> $ estimate_value   <chr> "2025-09-19 11:04:02", "2025-09-19 11:04:02", "2025-0…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall"
    #> $ additional_level <chr> "overall", "overall", "overall", "overall"
    
    [tidy](https://generics.r-lib.org/reference/tidy.html)(res)
    #> # A tibble: 4 × 5
    #>   cdm_name log_id variable_name      variable_level date_time          
    #>   <chr>    <chr>  <chr>              <chr>          <chr>              
    #> 1 unknown  1      Log file created   NA             2025-09-19 11:04:02
    #> 2 unknown  2      Starting analysis  NA             2025-09-19 11:04:02
    #> 3 unknown  3      Analysis finished  NA             2025-09-19 11:04:02
    #> 4 unknown  4      Exporting log file NA             2025-09-19 11:04:02
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/logMessage.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Log a message to a logFile

Source: [`R/logger.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/logger.R)

`logMessage.Rd`

The message is written to the logFile and displayed in the console, if `logFile` does not exist the message is only displayed in the console.

## Usage
    
    
    logMessage(
      message = "Start logging file",
      logFile = [getOption](https://rdrr.io/r/base/options.html)("omopgenerics.logFile")
    )

## Arguments

message
    

Message to log.

logFile
    

File path to write logging messages. Create a logFile with `[createLogFile()](createLogFile.html)`.

## Value

Invisible TRUE if the logging message is written to a log file.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    logFile <- [tempfile](https://rdrr.io/r/base/tempfile.html)(pattern = "log_{date}_{time}", fileext = ".txt")
    [createLogFile](createLogFile.html)(logFile = logFile)
    #> ! Overwriting current log file
    #> ℹ Creating log file: /tmp/Rtmpmt8NbS/log_2025_09_19_11_04_101d9d758f4f55.txt.
    #> [2025-09-19 11:04:10] - Log file created
    
    logMessage("Starting analysis")
    #> [2025-09-19 11:04:10] - Starting analysis
    1 + 1
    #> [1] 2
    logMessage("Analysis finished")
    #> [2025-09-19 11:04:10] - Analysis finished
    
    res <- [summariseLogFile](summariseLogFile.html)()
    #> [2025-09-19 11:04:10] - Exporting log file
    
    [glimpse](https://pillar.r-lib.org/reference/glimpse.html)(res)
    #> Rows: 4
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1
    #> $ cdm_name         <chr> "unknown", "unknown", "unknown", "unknown"
    #> $ group_name       <chr> "overall", "overall", "overall", "overall"
    #> $ group_level      <chr> "overall", "overall", "overall", "overall"
    #> $ strata_name      <chr> "log_id", "log_id", "log_id", "log_id"
    #> $ strata_level     <chr> "1", "2", "3", "4"
    #> $ variable_name    <chr> "Log file created", "Starting analysis", "Analysis fi…
    #> $ variable_level   <chr> NA, NA, NA, NA
    #> $ estimate_name    <chr> "date_time", "date_time", "date_time", "date_time"
    #> $ estimate_type    <chr> "character", "character", "character", "character"
    #> $ estimate_value   <chr> "2025-09-19 11:04:10", "2025-09-19 11:04:10", "2025-0…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall"
    #> $ additional_level <chr> "overall", "overall", "overall", "overall"
    
    [tidy](https://generics.r-lib.org/reference/tidy.html)(res)
    #> # A tibble: 4 × 5
    #>   cdm_name log_id variable_name      variable_level date_time          
    #>   <chr>    <chr>  <chr>              <chr>          <chr>              
    #> 1 unknown  1      Log file created   NA             2025-09-19 11:04:10
    #> 2 unknown  2      Starting analysis  NA             2025-09-19 11:04:10
    #> 3 unknown  3      Analysis finished  NA             2025-09-19 11:04:10
    #> 4 unknown  4      Exporting log file NA             2025-09-19 11:04:10
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/summariseLogFile.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Summarise and extract the information of a log file into a `summarised_result` object.

Source: [`R/logger.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/logger.R)

`summariseLogFile.Rd`

Summarise and extract the information of a log file into a `summarised_result` object.

## Usage
    
    
    summariseLogFile(
      logFile = [getOption](https://rdrr.io/r/base/options.html)("omopgenerics.logFile"),
      cdmName = "unknown"
    )

## Arguments

logFile
    

File path to the log file to summarise. Create a logFile with `[createLogFile()](createLogFile.html)`.

cdmName
    

Name of the cdm for the `summarise_result` object.

## Value

A `summarise_result` with the information of the log file.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    logFile <- [tempfile](https://rdrr.io/r/base/tempfile.html)(pattern = "log_{date}_{time}", fileext = ".txt")
    [createLogFile](createLogFile.html)(logFile = logFile)
    #> ! Overwriting current log file
    #> ℹ Creating log file: /tmp/Rtmpmt8NbS/log_2025_09_19_11_04_211d9d65d639cc.txt.
    #> [2025-09-19 11:04:21] - Log file created
    
    [logMessage](logMessage.html)("Starting analysis")
    #> [2025-09-19 11:04:21] - Starting analysis
    1 + 1
    #> [1] 2
    [logMessage](logMessage.html)("Analysis finished")
    #> [2025-09-19 11:04:21] - Analysis finished
    
    res <- summariseLogFile()
    #> [2025-09-19 11:04:21] - Exporting log file
    
    [glimpse](https://pillar.r-lib.org/reference/glimpse.html)(res)
    #> Rows: 4
    #> Columns: 13
    #> $ result_id        <int> 1, 1, 1, 1
    #> $ cdm_name         <chr> "unknown", "unknown", "unknown", "unknown"
    #> $ group_name       <chr> "overall", "overall", "overall", "overall"
    #> $ group_level      <chr> "overall", "overall", "overall", "overall"
    #> $ strata_name      <chr> "log_id", "log_id", "log_id", "log_id"
    #> $ strata_level     <chr> "1", "2", "3", "4"
    #> $ variable_name    <chr> "Log file created", "Starting analysis", "Analysis fi…
    #> $ variable_level   <chr> NA, NA, NA, NA
    #> $ estimate_name    <chr> "date_time", "date_time", "date_time", "date_time"
    #> $ estimate_type    <chr> "character", "character", "character", "character"
    #> $ estimate_value   <chr> "2025-09-19 11:04:21", "2025-09-19 11:04:21", "2025-0…
    #> $ additional_name  <chr> "overall", "overall", "overall", "overall"
    #> $ additional_level <chr> "overall", "overall", "overall", "overall"
    
    [tidy](https://generics.r-lib.org/reference/tidy.html)(res)
    #> # A tibble: 4 × 5
    #>   cdm_name log_id variable_name      variable_level date_time          
    #>   <chr>    <chr>  <chr>              <chr>          <chr>              
    #> 1 unknown  1      Log file created   NA             2025-09-19 11:04:21
    #> 2 unknown  2      Starting analysis  NA             2025-09-19 11:04:21
    #> 3 unknown  3      Analysis finished  NA             2025-09-19 11:04:21
    #> 4 unknown  4      Exporting log file NA             2025-09-19 11:04:21
    
    

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/checkCohortRequirements.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Check whether a cohort table satisfies requirements

Source: [`R/classCohortTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/classCohortTable.R)

`checkCohortRequirements.Rd`

[![\[Deprecated\]](figures/lifecycle-deprecated.svg)](https://lifecycle.r-lib.org/articles/stages.html#deprecated)

## Usage
    
    
    checkCohortRequirements(
      cohort,
      checkEndAfterStart = TRUE,
      checkOverlappingEntries = TRUE,
      checkMissingValues = TRUE,
      checkInObservation = TRUE,
      type = "error",
      call = [parent.frame](https://rdrr.io/r/base/sys.parent.html)()
    )

## Arguments

cohort
    

`cohort_table` object.

checkEndAfterStart
    

If TRUE a check that all cohort end dates come on or after cohort start date will be performed.

checkOverlappingEntries
    

If TRUE a check that no individuals have overlapping cohort entries will be performed.

checkMissingValues
    

If TRUE a check that there are no missing values in required fields will be performed.

checkInObservation
    

If TRUE a check that cohort entries are within the individuals observation periods will be performed.

type
    

Can be either "error" or "warning". If "error" any check failure will result in an error, whereas if "warning" any check failure will result in a warning.

call
    

The call for which to return the error message.

## Value

An error will be returned if any of the selected checks fail.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.

---

## Content from https://darwin-eu.github.io/omopgenerics/reference/dropTable.html

Skip to contents

[omopgenerics](../index.html) 1.3.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Classes

    * [The cdm reference](../articles/cdm_reference.html)
    * [Concept sets](../articles/codelists.html)
    * [Cohort tables](../articles/cohorts.html)
    * [A summarised result](../articles/summarised_result.html)
    * * * *

    * ###### OMOP Studies

    * [Suppression of a summarised_result obejct](../articles/suppression.html)
    * [Logging with omopgenerics](../articles/logging.html)
    * * * *

    * ###### Principles

    * [Re-exporting functions from omopgnerics](../articles/reexport.html)
    * [Expanding omopgenerics](../articles/expanding_omopgenerics.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/omopgenerics/)



# Drop a table from a cdm object. [![\[Deprecated\]](figures/lifecycle-deprecated.svg)](https://lifecycle.r-lib.org/articles/stages.html#deprecated)

Source: [`R/methodDropTable.R`](https://github.com/darwin-eu/omopgenerics/blob/v1.3.1/R/methodDropTable.R)

`dropTable.Rd`

Drop a table from a cdm object. [![\[Deprecated\]](figures/lifecycle-deprecated.svg)](https://lifecycle.r-lib.org/articles/stages.html#deprecated)

## Usage
    
    
    dropTable(cdm, name)

## Arguments

cdm
    

A cdm reference.

name
    

Name(s) of the table(s) to drop Tidyselect statements are supported.

## Value

The cdm reference.

## On this page

Developed by Martí Català, Edward Burn.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
