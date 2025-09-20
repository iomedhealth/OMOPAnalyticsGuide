# Summarise concept use in patient-level data. Only concepts recorded during observation period are counted. — summariseConceptIdCounts • OmopSketch

Skip to contents

[OmopSketch](../index.html) 0.5.1

  * [Reference](../reference/index.html)
  * Articles
    * * * *

    * ###### Package functionalities

    * [Summarise clinical tables records](../articles/summarise_clinical_tables_records.html)
    * [Summarise concept id counts](../articles/summarise_concept_id_counts.html)
    * [Summarise observation period](../articles/summarise_observation_period.html)
    * [Characterisation of OMOP CDM](../articles/characterisation.html)
    * [Summarise missing data](../articles/missing_data.html)
    * [Summarise database characteristics](../articles/database_characteristics.html)
  * [Changelog](../news/index.html)
  * [Characterisation synthetic datasets](https://dpa-pde-oxford.shinyapps.io/OmopSketchCharacterisation/)


  *   * [](https://github.com/OHDSI/OmopSketch/)



![](../logo.png)

# Summarise concept use in patient-level data. Only concepts recorded during observation period are counted.

Source: [`R/summariseConceptIdCounts.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/summariseConceptIdCounts.R)

`summariseConceptIdCounts.Rd`

Summarise concept use in patient-level data. Only concepts recorded during observation period are counted.

## Usage
    
    
    summariseConceptIdCounts(
      cdm,
      omopTableName,
      countBy = "record",
      year = lifecycle::[deprecated](https://lifecycle.r-lib.org/reference/deprecated.html)(),
      interval = "overall",
      sex = FALSE,
      ageGroup = NULL,
      sample = NULL,
      dateRange = NULL
    )

## Arguments

cdm
    

A cdm object

omopTableName
    

A character vector of the names of the tables to summarise in the cdm object.

countBy
    

Either "record" for record-level counts or "person" for person-level counts

year
    

deprecated

interval
    

Time interval to stratify by. It can either be "years", "quarters", "months" or "overall".

sex
    

TRUE or FALSE. If TRUE code use will be summarised by sex.

ageGroup
    

A list of ageGroup vectors of length two. Code use will be thus summarised by age groups.

sample
    

An integer to sample the tables to only that number of records. If NULL no sample is done.

dateRange
    

A vector of two dates defining the desired study period. Only the `start_date` column of the OMOP table is checked to ensure it falls within this range. If `dateRange` is `NULL`, no restriction is applied.

## Value

A summarised_result object with results overall and, if specified, by strata.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    
    [requireEunomia](https://darwin-eu.github.io/CDMConnector/reference/requireEunomia.html)()
    #> ℹ `EUNOMIA_DATA_FOLDER` set to: /tmp/RtmpebncMJ.
    #> 
    #> Download completed!
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    #> Creating CDM database /tmp/RtmpebncMJ/GiBleed_5.3.zip
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, cdmSchema = "main", writeSchema = "main")
    
    summariseConceptIdCounts(
      cdm = cdm,
      omopTableName = "condition_occurrence",
      countBy = [c](https://rdrr.io/r/base/c.html)("record", "person"),
      sex = TRUE
    )
    #> # A tibble: 476 × 13
    #>    result_id cdm_name group_name group_level          strata_name strata_level
    #>        <int> <chr>    <chr>      <chr>                <chr>       <chr>       
    #>  1         1 Synthea  omop_table condition_occurrence overall     overall     
    #>  2         1 Synthea  omop_table condition_occurrence overall     overall     
    #>  3         1 Synthea  omop_table condition_occurrence overall     overall     
    #>  4         1 Synthea  omop_table condition_occurrence overall     overall     
    #>  5         1 Synthea  omop_table condition_occurrence overall     overall     
    #>  6         1 Synthea  omop_table condition_occurrence overall     overall     
    #>  7         1 Synthea  omop_table condition_occurrence overall     overall     
    #>  8         1 Synthea  omop_table condition_occurrence overall     overall     
    #>  9         1 Synthea  omop_table condition_occurrence overall     overall     
    #> 10         1 Synthea  omop_table condition_occurrence overall     overall     
    #> # ℹ 466 more rows
    #> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
    #> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
    #> #   additional_name <chr>, additional_level <chr>
    
    # }
    
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
