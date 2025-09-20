# The cdm reference • omopgenerics

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
