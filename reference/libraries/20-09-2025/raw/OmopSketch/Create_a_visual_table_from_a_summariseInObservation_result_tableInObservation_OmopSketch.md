# Create a visual table from a summariseInObservation() result. — tableInObservation • OmopSketch

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

# Create a visual table from a summariseInObservation() result.

Source: [`R/tableInObservation.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/tableInObservation.R)

`tableInObservation.Rd`

Create a visual table from a summariseInObservation() result.

## Usage
    
    
    tableInObservation(result, type = "gt")

## Arguments

result
    

A summarised_result object.

type
    

Type of formatting output table. See `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)` for allowed options. Default is `"gt"`

## Value

A formatted table object with the summarised data.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockOmopSketch](mockOmopSketch.html)()
    
    result <- [summariseInObservation](summariseInObservation.html)(
      observationPeriod = cdm$observation_period,
      interval = "months",
      output = [c](https://rdrr.io/r/base/c.html)("person-days", "record"),
      ageGroup = [list](https://rdrr.io/r/base/list.html)("<=60" = [c](https://rdrr.io/r/base/c.html)(0, 60), ">60" = [c](https://rdrr.io/r/base/c.html)(61, Inf)),
      sex = TRUE
    )
    
    result |>
      tableInObservation()
    #> Warning: `tableInObservation()` was deprecated in OmopSketch 1.0.0.
    #> ℹ Please use `tableTrend()` instead.
    
    
    
    
      Variable name
          | Time interval
          | Sex
          | Age group
          | Estimate name
          | 
            Database name
          
          
    ---|---|---|---|---|---  
    mockOmopSketch
          
    episode; observation_period
          
    Records in observation
    | 1958-03-01 to 1958-03-31
    | overall
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 1958-03-01 to 1958-03-31
    | overall
    | overall
    | N (%)
    | 4 (0.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (0.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (0.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (0.00%)  
    Records in observation
    | 1958-04-01 to 1958-04-30
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1958-04-01 to 1958-04-30
    | overall
    | overall
    | N (%)
    | 51 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 51 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 51 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 51 (0.01%)  
    Records in observation
    | 1958-05-01 to 1958-05-31
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1958-05-01 to 1958-05-31
    | overall
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 62 (0.01%)  
    Records in observation
    | 1958-06-01 to 1958-06-30
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1958-06-01 to 1958-06-30
    | overall
    | overall
    | N (%)
    | 60 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 60 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 60 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 60 (0.01%)  
    Records in observation
    | 1958-07-01 to 1958-07-31
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1958-07-01 to 1958-07-31
    | overall
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 62 (0.01%)  
    Records in observation
    | 1958-08-01 to 1958-08-31
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1958-08-01 to 1958-08-31
    | overall
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 62 (0.01%)  
    Records in observation
    | 1958-09-01 to 1958-09-30
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1958-09-01 to 1958-09-30
    | overall
    | overall
    | N (%)
    | 60 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 60 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 60 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 60 (0.01%)  
    Records in observation
    | 1958-10-01 to 1958-10-31
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1958-10-01 to 1958-10-31
    | overall
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 62 (0.01%)  
    Records in observation
    | 1958-11-01 to 1958-11-30
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1958-11-01 to 1958-11-30
    | overall
    | overall
    | N (%)
    | 60 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 60 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 60 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 60 (0.01%)  
    Records in observation
    | 1958-12-01 to 1958-12-31
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1958-12-01 to 1958-12-31
    | overall
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 62 (0.01%)  
    Records in observation
    | 1959-01-01 to 1959-01-31
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1959-01-01 to 1959-01-31
    | overall
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 62 (0.01%)  
    Records in observation
    | 1959-02-01 to 1959-02-28
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1959-02-01 to 1959-02-28
    | overall
    | overall
    | N (%)
    | 56 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 56 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 56 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 56 (0.01%)  
    Records in observation
    | 1959-03-01 to 1959-03-31
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1959-03-01 to 1959-03-31
    | overall
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 62 (0.01%)  
    Records in observation
    | 1959-04-01 to 1959-04-30
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1959-04-01 to 1959-04-30
    | overall
    | overall
    | N (%)
    | 60 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 60 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 60 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 60 (0.01%)  
    Records in observation
    | 1959-05-01 to 1959-05-31
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1959-05-01 to 1959-05-31
    | overall
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 62 (0.01%)  
    Records in observation
    | 1959-06-01 to 1959-06-30
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1959-06-01 to 1959-06-30
    | overall
    | overall
    | N (%)
    | 60 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 60 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 60 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 60 (0.01%)  
    Records in observation
    | 1959-07-01 to 1959-07-31
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1959-07-01 to 1959-07-31
    | overall
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 62 (0.01%)  
    Records in observation
    | 1959-08-01 to 1959-08-31
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1959-08-01 to 1959-08-31
    | overall
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 62 (0.01%)  
    Records in observation
    | 1959-09-01 to 1959-09-30
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1959-09-01 to 1959-09-30
    | overall
    | overall
    | N (%)
    | 60 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 60 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 60 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 60 (0.01%)  
    Records in observation
    | 1959-10-01 to 1959-10-31
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1959-10-01 to 1959-10-31
    | overall
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 62 (0.01%)  
    Records in observation
    | 1959-11-01 to 1959-11-30
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1959-11-01 to 1959-11-30
    | overall
    | overall
    | N (%)
    | 60 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 60 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 60 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 60 (0.01%)  
    Records in observation
    | 1959-12-01 to 1959-12-31
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1959-12-01 to 1959-12-31
    | overall
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 62 (0.01%)  
    Records in observation
    | 1960-01-01 to 1960-01-31
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 1960-01-01 to 1960-01-31
    | overall
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 62 (0.01%)  
    Records in observation
    | 1960-02-01 to 1960-02-29
    | overall
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1960-02-01 to 1960-02-29
    | overall
    | overall
    | N (%)
    | 63 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 63 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 63 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 63 (0.01%)  
    Records in observation
    | 1960-03-01 to 1960-03-31
    | overall
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1960-03-01 to 1960-03-31
    | overall
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1960-04-01 to 1960-04-30
    | overall
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1960-04-01 to 1960-04-30
    | overall
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1960-05-01 to 1960-05-31
    | overall
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1960-05-01 to 1960-05-31
    | overall
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1960-06-01 to 1960-06-30
    | overall
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1960-06-01 to 1960-06-30
    | overall
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1960-07-01 to 1960-07-31
    | overall
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1960-07-01 to 1960-07-31
    | overall
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1960-08-01 to 1960-08-31
    | overall
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1960-08-01 to 1960-08-31
    | overall
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1960-09-01 to 1960-09-30
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 1960-09-01 to 1960-09-30
    | overall
    | overall
    | N (%)
    | 112 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 22 (0.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 112 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 22 (0.00%)  
    Records in observation
    | 1960-10-01 to 1960-10-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1960-10-01 to 1960-10-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1960-11-01 to 1960-11-30
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 1960-11-01 to 1960-11-30
    | overall
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1960-12-01 to 1960-12-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1960-12-01 to 1960-12-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1961-01-01 to 1961-01-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1961-01-01 to 1961-01-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1961-02-01 to 1961-02-28
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1961-02-01 to 1961-02-28
    | overall
    | overall
    | N (%)
    | 112 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 28 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 84 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 112 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 28 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 84 (0.02%)  
    Records in observation
    | 1961-03-01 to 1961-03-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 1961-03-01 to 1961-03-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 1961-04-01 to 1961-04-30
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 1961-04-01 to 1961-04-30
    | overall
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 30 (0.01%)  
    Records in observation
    | 1961-05-01 to 1961-05-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1961-05-01 to 1961-05-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1961-06-01 to 1961-06-30
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1961-06-01 to 1961-06-30
    | overall
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1961-07-01 to 1961-07-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 1961-07-01 to 1961-07-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 1961-08-01 to 1961-08-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1961-08-01 to 1961-08-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1961-09-01 to 1961-09-30
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1961-09-01 to 1961-09-30
    | overall
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1961-10-01 to 1961-10-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 1961-10-01 to 1961-10-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 1961-11-01 to 1961-11-30
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1961-11-01 to 1961-11-30
    | overall
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1961-12-01 to 1961-12-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 1961-12-01 to 1961-12-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 1962-01-01 to 1962-01-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 1962-01-01 to 1962-01-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 1962-02-01 to 1962-02-28
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1962-02-01 to 1962-02-28
    | overall
    | overall
    | N (%)
    | 112 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 28 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 84 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 112 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 28 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 84 (0.02%)  
    Records in observation
    | 1962-03-01 to 1962-03-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1962-03-01 to 1962-03-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1962-04-01 to 1962-04-30
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 1962-04-01 to 1962-04-30
    | overall
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 30 (0.01%)  
    Records in observation
    | 1962-05-01 to 1962-05-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 1962-05-01 to 1962-05-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 1962-06-01 to 1962-06-30
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1962-06-01 to 1962-06-30
    | overall
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1962-07-01 to 1962-07-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1962-07-01 to 1962-07-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1962-08-01 to 1962-08-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1962-08-01 to 1962-08-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1962-09-01 to 1962-09-30
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 1962-09-01 to 1962-09-30
    | overall
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1962-10-01 to 1962-10-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1962-10-01 to 1962-10-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1962-11-01 to 1962-11-30
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1962-11-01 to 1962-11-30
    | overall
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1962-12-01 to 1962-12-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1962-12-01 to 1962-12-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1963-01-01 to 1963-01-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 1963-01-01 to 1963-01-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 1963-02-01 to 1963-02-28
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1963-02-01 to 1963-02-28
    | overall
    | overall
    | N (%)
    | 112 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 28 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 84 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 112 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 28 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 84 (0.02%)  
    Records in observation
    | 1963-03-01 to 1963-03-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1963-03-01 to 1963-03-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1963-04-01 to 1963-04-30
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1963-04-01 to 1963-04-30
    | overall
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 30 (0.01%)  
    Records in observation
    | 1963-05-01 to 1963-05-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1963-05-01 to 1963-05-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1963-06-01 to 1963-06-30
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 1963-06-01 to 1963-06-30
    | overall
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1963-07-01 to 1963-07-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1963-07-01 to 1963-07-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1963-08-01 to 1963-08-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1963-08-01 to 1963-08-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1963-09-01 to 1963-09-30
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 1963-09-01 to 1963-09-30
    | overall
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 30 (0.01%)  
    Records in observation
    | 1963-10-01 to 1963-10-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 1963-10-01 to 1963-10-31
    | overall
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 1963-11-01 to 1963-11-30
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1963-11-01 to 1963-11-30
    | overall
    | overall
    | N (%)
    | 167 (0.03%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 77 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 167 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 77 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1963-12-01 to 1963-12-31
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1963-12-01 to 1963-12-31
    | overall
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1964-01-01 to 1964-01-31
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1964-01-01 to 1964-01-31
    | overall
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1964-02-01 to 1964-02-29
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1964-02-01 to 1964-02-29
    | overall
    | overall
    | N (%)
    | 174 (0.03%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 87 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 87 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 174 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 87 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 87 (0.02%)  
    Records in observation
    | 1964-03-01 to 1964-03-31
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1964-03-01 to 1964-03-31
    | overall
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1964-04-01 to 1964-04-30
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1964-04-01 to 1964-04-30
    | overall
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1964-05-01 to 1964-05-31
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1964-05-01 to 1964-05-31
    | overall
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1964-06-01 to 1964-06-30
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1964-06-01 to 1964-06-30
    | overall
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1964-07-01 to 1964-07-31
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1964-07-01 to 1964-07-31
    | overall
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1964-08-01 to 1964-08-31
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1964-08-01 to 1964-08-31
    | overall
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1964-09-01 to 1964-09-30
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1964-09-01 to 1964-09-30
    | overall
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1964-10-01 to 1964-10-31
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1964-10-01 to 1964-10-31
    | overall
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1964-11-01 to 1964-11-30
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1964-11-01 to 1964-11-30
    | overall
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1964-12-01 to 1964-12-31
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1964-12-01 to 1964-12-31
    | overall
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1965-01-01 to 1965-01-31
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1965-01-01 to 1965-01-31
    | overall
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1965-02-01 to 1965-02-28
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1965-02-01 to 1965-02-28
    | overall
    | overall
    | N (%)
    | 168 (0.03%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 84 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 84 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 168 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 84 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 84 (0.02%)  
    Records in observation
    | 1965-03-01 to 1965-03-31
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1965-03-01 to 1965-03-31
    | overall
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1965-04-01 to 1965-04-30
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1965-04-01 to 1965-04-30
    | overall
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1965-05-01 to 1965-05-31
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1965-05-01 to 1965-05-31
    | overall
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1965-06-01 to 1965-06-30
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1965-06-01 to 1965-06-30
    | overall
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1965-07-01 to 1965-07-31
    | overall
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1965-07-01 to 1965-07-31
    | overall
    | overall
    | N (%)
    | 198 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 105 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 198 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 105 (0.02%)  
    Records in observation
    | 1965-08-01 to 1965-08-31
    | overall
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1965-08-01 to 1965-08-31
    | overall
    | overall
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1965-09-01 to 1965-09-30
    | overall
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1965-09-01 to 1965-09-30
    | overall
    | overall
    | N (%)
    | 210 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 210 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1965-10-01 to 1965-10-31
    | overall
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1965-10-01 to 1965-10-31
    | overall
    | overall
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1965-11-01 to 1965-11-30
    | overall
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1965-11-01 to 1965-11-30
    | overall
    | overall
    | N (%)
    | 210 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 210 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1965-12-01 to 1965-12-31
    | overall
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1965-12-01 to 1965-12-31
    | overall
    | overall
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1966-01-01 to 1966-01-31
    | overall
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1966-01-01 to 1966-01-31
    | overall
    | overall
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1966-02-01 to 1966-02-28
    | overall
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1966-02-01 to 1966-02-28
    | overall
    | overall
    | N (%)
    | 196 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 112 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 84 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 196 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 84 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 112 (0.02%)  
    Records in observation
    | 1966-03-01 to 1966-03-31
    | overall
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1966-03-01 to 1966-03-31
    | overall
    | overall
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1966-04-01 to 1966-04-30
    | overall
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1966-04-01 to 1966-04-30
    | overall
    | overall
    | N (%)
    | 210 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 210 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1966-05-01 to 1966-05-31
    | overall
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1966-05-01 to 1966-05-31
    | overall
    | overall
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1966-06-01 to 1966-06-30
    | overall
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1966-06-01 to 1966-06-30
    | overall
    | overall
    | N (%)
    | 210 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 210 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1966-07-01 to 1966-07-31
    | overall
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1966-07-01 to 1966-07-31
    | overall
    | overall
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1966-08-01 to 1966-08-31
    | overall
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1966-08-01 to 1966-08-31
    | overall
    | overall
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1966-09-01 to 1966-09-30
    | overall
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1966-09-01 to 1966-09-30
    | overall
    | overall
    | N (%)
    | 210 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 210 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1966-10-01 to 1966-10-31
    | overall
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1966-10-01 to 1966-10-31
    | overall
    | overall
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1966-11-01 to 1966-11-30
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1966-11-01 to 1966-11-30
    | overall
    | overall
    | N (%)
    | 221 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 101 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 221 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 101 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1966-12-01 to 1966-12-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1966-12-01 to 1966-12-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1967-01-01 to 1967-01-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1967-01-01 to 1967-01-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1967-02-01 to 1967-02-28
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1967-02-01 to 1967-02-28
    | overall
    | overall
    | N (%)
    | 224 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 112 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 112 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 224 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 112 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 112 (0.02%)  
    Records in observation
    | 1967-03-01 to 1967-03-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1967-03-01 to 1967-03-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1967-04-01 to 1967-04-30
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1967-04-01 to 1967-04-30
    | overall
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1967-05-01 to 1967-05-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1967-05-01 to 1967-05-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1967-06-01 to 1967-06-30
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1967-06-01 to 1967-06-30
    | overall
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1967-07-01 to 1967-07-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1967-07-01 to 1967-07-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1967-08-01 to 1967-08-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1967-08-01 to 1967-08-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1967-09-01 to 1967-09-30
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1967-09-01 to 1967-09-30
    | overall
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1967-10-01 to 1967-10-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1967-10-01 to 1967-10-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1967-11-01 to 1967-11-30
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1967-11-01 to 1967-11-30
    | overall
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1967-12-01 to 1967-12-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1967-12-01 to 1967-12-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1968-01-01 to 1968-01-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1968-01-01 to 1968-01-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1968-02-01 to 1968-02-29
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1968-02-01 to 1968-02-29
    | overall
    | overall
    | N (%)
    | 232 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 116 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 116 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 232 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 116 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 116 (0.02%)  
    Records in observation
    | 1968-03-01 to 1968-03-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1968-03-01 to 1968-03-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1968-04-01 to 1968-04-30
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1968-04-01 to 1968-04-30
    | overall
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1968-05-01 to 1968-05-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1968-05-01 to 1968-05-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1968-06-01 to 1968-06-30
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1968-06-01 to 1968-06-30
    | overall
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1968-07-01 to 1968-07-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1968-07-01 to 1968-07-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1968-08-01 to 1968-08-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1968-08-01 to 1968-08-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1968-09-01 to 1968-09-30
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1968-09-01 to 1968-09-30
    | overall
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1968-10-01 to 1968-10-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1968-10-01 to 1968-10-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1968-11-01 to 1968-11-30
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1968-11-01 to 1968-11-30
    | overall
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1968-12-01 to 1968-12-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1968-12-01 to 1968-12-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1969-01-01 to 1969-01-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1969-01-01 to 1969-01-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1969-02-01 to 1969-02-28
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1969-02-01 to 1969-02-28
    | overall
    | overall
    | N (%)
    | 224 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 112 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 112 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 224 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 112 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 112 (0.02%)  
    Records in observation
    | 1969-03-01 to 1969-03-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1969-03-01 to 1969-03-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1969-04-01 to 1969-04-30
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1969-04-01 to 1969-04-30
    | overall
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1969-05-01 to 1969-05-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1969-05-01 to 1969-05-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1969-06-01 to 1969-06-30
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1969-06-01 to 1969-06-30
    | overall
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1969-07-01 to 1969-07-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1969-07-01 to 1969-07-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1969-08-01 to 1969-08-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1969-08-01 to 1969-08-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1969-09-01 to 1969-09-30
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1969-09-01 to 1969-09-30
    | overall
    | overall
    | N (%)
    | 261 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 141 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 261 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 141 (0.03%)  
    Records in observation
    | 1969-10-01 to 1969-10-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1969-10-01 to 1969-10-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1969-11-01 to 1969-11-30
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1969-11-01 to 1969-11-30
    | overall
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1969-12-01 to 1969-12-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1969-12-01 to 1969-12-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1970-01-01 to 1970-01-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1970-01-01 to 1970-01-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1970-02-01 to 1970-02-28
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1970-02-01 to 1970-02-28
    | overall
    | overall
    | N (%)
    | 252 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 112 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 140 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 252 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 140 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 112 (0.02%)  
    Records in observation
    | 1970-03-01 to 1970-03-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1970-03-01 to 1970-03-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1970-04-01 to 1970-04-30
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1970-04-01 to 1970-04-30
    | overall
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    Records in observation
    | 1970-05-01 to 1970-05-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1970-05-01 to 1970-05-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1970-06-01 to 1970-06-30
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1970-06-01 to 1970-06-30
    | overall
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    Records in observation
    | 1970-07-01 to 1970-07-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1970-07-01 to 1970-07-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1970-08-01 to 1970-08-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1970-08-01 to 1970-08-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1970-09-01 to 1970-09-30
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1970-09-01 to 1970-09-30
    | overall
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1970-10-01 to 1970-10-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1970-10-01 to 1970-10-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1970-11-01 to 1970-11-30
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1970-11-01 to 1970-11-30
    | overall
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    Records in observation
    | 1970-12-01 to 1970-12-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1970-12-01 to 1970-12-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1971-01-01 to 1971-01-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1971-01-01 to 1971-01-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1971-02-01 to 1971-02-28
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1971-02-01 to 1971-02-28
    | overall
    | overall
    | N (%)
    | 252 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 112 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 140 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 252 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 112 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 140 (0.03%)  
    Records in observation
    | 1971-03-01 to 1971-03-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1971-03-01 to 1971-03-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1971-04-01 to 1971-04-30
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1971-04-01 to 1971-04-30
    | overall
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    Records in observation
    | 1971-05-01 to 1971-05-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1971-05-01 to 1971-05-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1971-06-01 to 1971-06-30
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1971-06-01 to 1971-06-30
    | overall
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1971-07-01 to 1971-07-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1971-07-01 to 1971-07-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1971-08-01 to 1971-08-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1971-08-01 to 1971-08-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1971-09-01 to 1971-09-30
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1971-09-01 to 1971-09-30
    | overall
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    Records in observation
    | 1971-10-01 to 1971-10-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1971-10-01 to 1971-10-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1971-11-01 to 1971-11-30
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1971-11-01 to 1971-11-30
    | overall
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    Records in observation
    | 1971-12-01 to 1971-12-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1971-12-01 to 1971-12-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1972-01-01 to 1972-01-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1972-01-01 to 1972-01-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1972-02-01 to 1972-02-29
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1972-02-01 to 1972-02-29
    | overall
    | overall
    | N (%)
    | 261 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 116 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 145 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 261 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 116 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 145 (0.03%)  
    Records in observation
    | 1972-03-01 to 1972-03-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1972-03-01 to 1972-03-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1972-04-01 to 1972-04-30
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1972-04-01 to 1972-04-30
    | overall
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1972-05-01 to 1972-05-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1972-05-01 to 1972-05-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1972-06-01 to 1972-06-30
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1972-06-01 to 1972-06-30
    | overall
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1972-07-01 to 1972-07-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1972-07-01 to 1972-07-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1972-08-01 to 1972-08-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1972-08-01 to 1972-08-31
    | overall
    | overall
    | N (%)
    | 264 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 109 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 264 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 109 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1972-09-01 to 1972-09-30
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1972-09-01 to 1972-09-30
    | overall
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1972-10-01 to 1972-10-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1972-10-01 to 1972-10-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1972-11-01 to 1972-11-30
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1972-11-01 to 1972-11-30
    | overall
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    Records in observation
    | 1972-12-01 to 1972-12-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 1972-12-01 to 1972-12-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 1973-01-01 to 1973-01-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1973-01-01 to 1973-01-31
    | overall
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1973-02-01 to 1973-02-28
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1973-02-01 to 1973-02-28
    | overall
    | overall
    | N (%)
    | 224 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 84 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 140 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 224 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 84 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 140 (0.03%)  
    Records in observation
    | 1973-03-01 to 1973-03-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1973-03-01 to 1973-03-31
    | overall
    | overall
    | N (%)
    | 243 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 243 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    Records in observation
    | 1973-04-01 to 1973-04-30
    | overall
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1973-04-01 to 1973-04-30
    | overall
    | overall
    | N (%)
    | 210 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 210 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 1973-05-01 to 1973-05-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1973-05-01 to 1973-05-31
    | overall
    | overall
    | N (%)
    | 220 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 96 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 220 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 96 (0.02%)  
    Records in observation
    | 1973-06-01 to 1973-06-30
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1973-06-01 to 1973-06-30
    | overall
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 1973-07-01 to 1973-07-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1973-07-01 to 1973-07-31
    | overall
    | overall
    | N (%)
    | 249 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 125 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 249 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 125 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1973-08-01 to 1973-08-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 1973-08-01 to 1973-08-31
    | overall
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 1973-09-01 to 1973-09-30
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1973-09-01 to 1973-09-30
    | overall
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    Records in observation
    | 1973-10-01 to 1973-10-31
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1973-10-01 to 1973-10-31
    | overall
    | overall
    | N (%)
    | 280 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 125 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 280 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 125 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1973-11-01 to 1973-11-30
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1973-11-01 to 1973-11-30
    | overall
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    Records in observation
    | 1973-12-01 to 1973-12-31
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1973-12-01 to 1973-12-31
    | overall
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1974-01-01 to 1974-01-31
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1974-01-01 to 1974-01-31
    | overall
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1974-02-01 to 1974-02-28
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1974-02-01 to 1974-02-28
    | overall
    | overall
    | N (%)
    | 280 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 140 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 140 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 280 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 140 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 140 (0.03%)  
    Records in observation
    | 1974-03-01 to 1974-03-31
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1974-03-01 to 1974-03-31
    | overall
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1974-04-01 to 1974-04-30
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1974-04-01 to 1974-04-30
    | overall
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    Records in observation
    | 1974-05-01 to 1974-05-31
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1974-05-01 to 1974-05-31
    | overall
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1974-06-01 to 1974-06-30
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1974-06-01 to 1974-06-30
    | overall
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    Records in observation
    | 1974-07-01 to 1974-07-31
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1974-07-01 to 1974-07-31
    | overall
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1974-08-01 to 1974-08-31
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1974-08-01 to 1974-08-31
    | overall
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1974-09-01 to 1974-09-30
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1974-09-01 to 1974-09-30
    | overall
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 150 (0.03%)  
    Records in observation
    | 1974-10-01 to 1974-10-31
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1974-10-01 to 1974-10-31
    | overall
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1974-11-01 to 1974-11-30
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1974-11-01 to 1974-11-30
    | overall
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 150 (0.03%)  
    Records in observation
    | 1974-12-01 to 1974-12-31
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1974-12-01 to 1974-12-31
    | overall
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1975-01-01 to 1975-01-31
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1975-01-01 to 1975-01-31
    | overall
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1975-02-01 to 1975-02-28
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1975-02-01 to 1975-02-28
    | overall
    | overall
    | N (%)
    | 280 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 140 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 140 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 280 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 140 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 140 (0.03%)  
    Records in observation
    | 1975-03-01 to 1975-03-31
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1975-03-01 to 1975-03-31
    | overall
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1975-04-01 to 1975-04-30
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1975-04-01 to 1975-04-30
    | overall
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 150 (0.03%)  
    Records in observation
    | 1975-05-01 to 1975-05-31
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1975-05-01 to 1975-05-31
    | overall
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1975-06-01 to 1975-06-30
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1975-06-01 to 1975-06-30
    | overall
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    Records in observation
    | 1975-07-01 to 1975-07-31
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1975-07-01 to 1975-07-31
    | overall
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1975-08-01 to 1975-08-31
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1975-08-01 to 1975-08-31
    | overall
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1975-09-01 to 1975-09-30
    | overall
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1975-09-01 to 1975-09-30
    | overall
    | overall
    | N (%)
    | 314 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 164 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 314 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 164 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 150 (0.03%)  
    Records in observation
    | 1975-10-01 to 1975-10-31
    | overall
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1975-10-01 to 1975-10-31
    | overall
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1975-11-01 to 1975-11-30
    | overall
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1975-11-01 to 1975-11-30
    | overall
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 180 (0.04%)  
    Records in observation
    | 1975-12-01 to 1975-12-31
    | overall
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1975-12-01 to 1975-12-31
    | overall
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1976-01-01 to 1976-01-31
    | overall
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1976-01-01 to 1976-01-31
    | overall
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1976-02-01 to 1976-02-29
    | overall
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1976-02-01 to 1976-02-29
    | overall
    | overall
    | N (%)
    | 319 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 145 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 174 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 319 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 174 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 145 (0.03%)  
    Records in observation
    | 1976-03-01 to 1976-03-31
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1976-03-01 to 1976-03-31
    | overall
    | overall
    | N (%)
    | 363 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 177 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 363 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 177 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1976-04-01 to 1976-04-30
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1976-04-01 to 1976-04-30
    | overall
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 180 (0.04%)  
    Records in observation
    | 1976-05-01 to 1976-05-31
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1976-05-01 to 1976-05-31
    | overall
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1976-06-01 to 1976-06-30
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1976-06-01 to 1976-06-30
    | overall
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 180 (0.04%)  
    Records in observation
    | 1976-07-01 to 1976-07-31
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1976-07-01 to 1976-07-31
    | overall
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1976-08-01 to 1976-08-31
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1976-08-01 to 1976-08-31
    | overall
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1976-09-01 to 1976-09-30
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1976-09-01 to 1976-09-30
    | overall
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 180 (0.04%)  
    Records in observation
    | 1976-10-01 to 1976-10-31
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1976-10-01 to 1976-10-31
    | overall
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1976-11-01 to 1976-11-30
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1976-11-01 to 1976-11-30
    | overall
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 180 (0.04%)  
    Records in observation
    | 1976-12-01 to 1976-12-31
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1976-12-01 to 1976-12-31
    | overall
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1977-01-01 to 1977-01-31
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1977-01-01 to 1977-01-31
    | overall
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1977-02-01 to 1977-02-28
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1977-02-01 to 1977-02-28
    | overall
    | overall
    | N (%)
    | 336 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 168 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 168 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 336 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 168 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 168 (0.03%)  
    Records in observation
    | 1977-03-01 to 1977-03-31
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1977-03-01 to 1977-03-31
    | overall
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1977-04-01 to 1977-04-30
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1977-04-01 to 1977-04-30
    | overall
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 180 (0.04%)  
    Records in observation
    | 1977-05-01 to 1977-05-31
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1977-05-01 to 1977-05-31
    | overall
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1977-06-01 to 1977-06-30
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1977-06-01 to 1977-06-30
    | overall
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 180 (0.04%)  
    Records in observation
    | 1977-07-01 to 1977-07-31
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1977-07-01 to 1977-07-31
    | overall
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1977-08-01 to 1977-08-31
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1977-08-01 to 1977-08-31
    | overall
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1977-09-01 to 1977-09-30
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1977-09-01 to 1977-09-30
    | overall
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 180 (0.04%)  
    Records in observation
    | 1977-10-01 to 1977-10-31
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1977-10-01 to 1977-10-31
    | overall
    | overall
    | N (%)
    | 358 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 172 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 358 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 172 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1977-11-01 to 1977-11-30
    | overall
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1977-11-01 to 1977-11-30
    | overall
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 180 (0.04%)  
    Records in observation
    | 1977-12-01 to 1977-12-31
    | overall
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1977-12-01 to 1977-12-31
    | overall
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1978-01-01 to 1978-01-31
    | overall
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1978-01-01 to 1978-01-31
    | overall
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1978-02-01 to 1978-02-28
    | overall
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1978-02-01 to 1978-02-28
    | overall
    | overall
    | N (%)
    | 308 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 168 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 140 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 308 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 140 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 168 (0.03%)  
    Records in observation
    | 1978-03-01 to 1978-03-31
    | overall
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1978-03-01 to 1978-03-31
    | overall
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1978-04-01 to 1978-04-30
    | overall
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 1978-04-01 to 1978-04-30
    | overall
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    Records in observation
    | 1978-05-01 to 1978-05-31
    | overall
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1978-05-01 to 1978-05-31
    | overall
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    Records in observation
    | 1978-06-01 to 1978-06-30
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1978-06-01 to 1978-06-30
    | overall
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 161 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 161 (0.03%)  
    Records in observation
    | 1978-07-01 to 1978-07-31
    | overall
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1978-07-01 to 1978-07-31
    | overall
    | overall
    | N (%)
    | 398 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 212 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 398 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 212 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1978-08-01 to 1978-08-31
    | overall
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1978-08-01 to 1978-08-31
    | overall
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 217 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1978-09-01 to 1978-09-30
    | overall
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 7 (7.00%)  
    Person-days
    | 1978-09-01 to 1978-09-30
    | overall
    | overall
    | N (%)
    | 390 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 210 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 390 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 210 (0.04%)  
    Records in observation
    | 1978-10-01 to 1978-10-31
    | overall
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 7 (7.00%)  
    Person-days
    | 1978-10-01 to 1978-10-31
    | overall
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 217 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 217 (0.04%)  
    Records in observation
    | 1978-11-01 to 1978-11-30
    | overall
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 7 (7.00%)  
    Person-days
    | 1978-11-01 to 1978-11-30
    | overall
    | overall
    | N (%)
    | 390 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 210 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 390 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 210 (0.04%)  
    Records in observation
    | 1978-12-01 to 1978-12-31
    | overall
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 7 (7.00%)  
    Person-days
    | 1978-12-01 to 1978-12-31
    | overall
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 217 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 217 (0.04%)  
    Records in observation
    | 1979-01-01 to 1979-01-31
    | overall
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1979-01-01 to 1979-01-31
    | overall
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 217 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1979-02-01 to 1979-02-28
    | overall
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 7 (7.00%)  
    Person-days
    | 1979-02-01 to 1979-02-28
    | overall
    | overall
    | N (%)
    | 364 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 168 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 196 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 364 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 168 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 196 (0.04%)  
    Records in observation
    | 1979-03-01 to 1979-03-31
    | overall
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 8 (8.00%)  
    Person-days
    | 1979-03-01 to 1979-03-31
    | overall
    | overall
    | N (%)
    | 406 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 220 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 406 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 220 (0.04%)  
    Records in observation
    | 1979-04-01 to 1979-04-30
    | overall
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1979-04-01 to 1979-04-30
    | overall
    | overall
    | N (%)
    | 446 (0.09%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 266 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 446 (0.09%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 266 (0.05%)  
    Records in observation
    | 1979-05-01 to 1979-05-31
    | overall
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1979-05-01 to 1979-05-31
    | overall
    | overall
    | N (%)
    | 490 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 304 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 490 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 304 (0.06%)  
    Records in observation
    | 1979-06-01 to 1979-06-30
    | overall
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1979-06-01 to 1979-06-30
    | overall
    | overall
    | N (%)
    | 480 (0.09%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 480 (0.09%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 300 (0.06%)  
    Records in observation
    | 1979-07-01 to 1979-07-31
    | overall
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1979-07-01 to 1979-07-31
    | overall
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1979-08-01 to 1979-08-31
    | overall
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1979-08-01 to 1979-08-31
    | overall
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    Records in observation
    | 1979-09-01 to 1979-09-30
    | overall
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1979-09-01 to 1979-09-30
    | overall
    | overall
    | N (%)
    | 480 (0.09%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 480 (0.09%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 300 (0.06%)  
    Records in observation
    | 1979-10-01 to 1979-10-31
    | overall
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1979-10-01 to 1979-10-31
    | overall
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1979-11-01 to 1979-11-30
    | overall
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1979-11-01 to 1979-11-30
    | overall
    | overall
    | N (%)
    | 480 (0.09%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 480 (0.09%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 180 (0.04%)  
    Records in observation
    | 1979-12-01 to 1979-12-31
    | overall
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1979-12-01 to 1979-12-31
    | overall
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    Records in observation
    | 1980-01-01 to 1980-01-31
    | overall
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 1980-01-01 to 1980-01-31
    | overall
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 1980-02-01 to 1980-02-29
    | overall
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1980-02-01 to 1980-02-29
    | overall
    | overall
    | N (%)
    | 464 (0.09%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 290 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 174 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 464 (0.09%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 174 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 290 (0.06%)  
    Records in observation
    | 1980-03-01 to 1980-03-31
    | overall
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1980-03-01 to 1980-03-31
    | overall
    | overall
    | N (%)
    | 500 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 190 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 500 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 190 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    Records in observation
    | 1980-04-01 to 1980-04-30
    | overall
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 7 (7.00%)  
    Person-days
    | 1980-04-01 to 1980-04-30
    | overall
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 210 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 510 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 210 (0.04%)  
    Records in observation
    | 1980-05-01 to 1980-05-31
    | overall
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 7 (7.00%)  
    Person-days
    | 1980-05-01 to 1980-05-31
    | overall
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 217 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 217 (0.04%)  
    Records in observation
    | 1980-06-01 to 1980-06-30
    | overall
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1980-06-01 to 1980-06-30
    | overall
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 210 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 510 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 210 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 300 (0.06%)  
    Records in observation
    | 1980-07-01 to 1980-07-31
    | overall
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 7 (7.00%)  
    Person-days
    | 1980-07-01 to 1980-07-31
    | overall
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 217 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 217 (0.04%)  
    Records in observation
    | 1980-08-01 to 1980-08-31
    | overall
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 7 (7.00%)  
    Person-days
    | 1980-08-01 to 1980-08-31
    | overall
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 217 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 217 (0.04%)  
    Records in observation
    | 1980-09-01 to 1980-09-30
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    Person-days
    | 1980-09-01 to 1980-09-30
    | overall
    | overall
    | N (%)
    | 512 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 212 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 512 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 212 (0.04%)  
    Records in observation
    | 1980-10-01 to 1980-10-31
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1980-10-01 to 1980-10-31
    | overall
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    Records in observation
    | 1980-11-01 to 1980-11-30
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1980-11-01 to 1980-11-30
    | overall
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 540 (0.11%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 300 (0.06%)  
    Records in observation
    | 1980-12-01 to 1980-12-31
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    Person-days
    | 1980-12-01 to 1980-12-31
    | overall
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 248 (0.05%)  
    Records in observation
    | 1981-01-01 to 1981-01-31
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1981-01-01 to 1981-01-31
    | overall
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 248 (0.05%)  
    Records in observation
    | 1981-02-01 to 1981-02-28
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1981-02-01 to 1981-02-28
    | overall
    | overall
    | N (%)
    | 504 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 280 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 224 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 504 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 224 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 280 (0.05%)  
    Records in observation
    | 1981-03-01 to 1981-03-31
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1981-03-01 to 1981-03-31
    | overall
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    Records in observation
    | 1981-04-01 to 1981-04-30
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1981-04-01 to 1981-04-30
    | overall
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 540 (0.11%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 300 (0.06%)  
    Records in observation
    | 1981-05-01 to 1981-05-31
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    Person-days
    | 1981-05-01 to 1981-05-31
    | overall
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 248 (0.05%)  
    Records in observation
    | 1981-06-01 to 1981-06-30
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    Person-days
    | 1981-06-01 to 1981-06-30
    | overall
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 540 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 240 (0.05%)  
    Records in observation
    | 1981-07-01 to 1981-07-31
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    Person-days
    | 1981-07-01 to 1981-07-31
    | overall
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 248 (0.05%)  
    Records in observation
    | 1981-08-01 to 1981-08-31
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1981-08-01 to 1981-08-31
    | overall
    | overall
    | N (%)
    | 574 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 264 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 574 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 264 (0.05%)  
    Records in observation
    | 1981-09-01 to 1981-09-30
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1981-09-01 to 1981-09-30
    | overall
    | overall
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 270 (0.05%)  
    Records in observation
    | 1981-10-01 to 1981-10-31
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1981-10-01 to 1981-10-31
    | overall
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    Records in observation
    | 1981-11-01 to 1981-11-30
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1981-11-01 to 1981-11-30
    | overall
    | overall
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 300 (0.06%)  
    Records in observation
    | 1981-12-01 to 1981-12-31
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1981-12-01 to 1981-12-31
    | overall
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    Records in observation
    | 1982-01-01 to 1982-01-31
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1982-01-01 to 1982-01-31
    | overall
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    Records in observation
    | 1982-02-01 to 1982-02-28
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1982-02-01 to 1982-02-28
    | overall
    | overall
    | N (%)
    | 532 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 280 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 252 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 532 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 280 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 252 (0.05%)  
    Records in observation
    | 1982-03-01 to 1982-03-31
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1982-03-01 to 1982-03-31
    | overall
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    Records in observation
    | 1982-04-01 to 1982-04-30
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1982-04-01 to 1982-04-30
    | overall
    | overall
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 300 (0.06%)  
    Records in observation
    | 1982-05-01 to 1982-05-31
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1982-05-01 to 1982-05-31
    | overall
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    Records in observation
    | 1982-06-01 to 1982-06-30
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1982-06-01 to 1982-06-30
    | overall
    | overall
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 300 (0.06%)  
    Records in observation
    | 1982-07-01 to 1982-07-31
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1982-07-01 to 1982-07-31
    | overall
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    Records in observation
    | 1982-08-01 to 1982-08-31
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1982-08-01 to 1982-08-31
    | overall
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    Records in observation
    | 1982-09-01 to 1982-09-30
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1982-09-01 to 1982-09-30
    | overall
    | overall
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 270 (0.05%)  
    Records in observation
    | 1982-10-01 to 1982-10-31
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1982-10-01 to 1982-10-31
    | overall
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    Records in observation
    | 1982-11-01 to 1982-11-30
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1982-11-01 to 1982-11-30
    | overall
    | overall
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 270 (0.05%)  
    Records in observation
    | 1982-12-01 to 1982-12-31
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1982-12-01 to 1982-12-31
    | overall
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    Records in observation
    | 1983-01-01 to 1983-01-31
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1983-01-01 to 1983-01-31
    | overall
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    Records in observation
    | 1983-02-01 to 1983-02-28
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1983-02-01 to 1983-02-28
    | overall
    | overall
    | N (%)
    | 532 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 280 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 252 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 532 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 280 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 252 (0.05%)  
    Records in observation
    | 1983-03-01 to 1983-03-31
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1983-03-01 to 1983-03-31
    | overall
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 310 (0.06%)  
    Records in observation
    | 1983-04-01 to 1983-04-30
    | overall
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1983-04-01 to 1983-04-30
    | overall
    | overall
    | N (%)
    | 595 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 325 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 595 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 325 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 270 (0.05%)  
    Records in observation
    | 1983-05-01 to 1983-05-31
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1983-05-01 to 1983-05-31
    | overall
    | overall
    | N (%)
    | 644 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 303 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 644 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 303 (0.06%)  
    Records in observation
    | 1983-06-01 to 1983-06-30
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1983-06-01 to 1983-06-30
    | overall
    | overall
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 330 (0.06%)  
    Records in observation
    | 1983-07-01 to 1983-07-31
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1983-07-01 to 1983-07-31
    | overall
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1983-08-01 to 1983-08-31
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1983-08-01 to 1983-08-31
    | overall
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 310 (0.06%)  
    Records in observation
    | 1983-09-01 to 1983-09-30
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1983-09-01 to 1983-09-30
    | overall
    | overall
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 330 (0.06%)  
    Records in observation
    | 1983-10-01 to 1983-10-31
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1983-10-01 to 1983-10-31
    | overall
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1983-11-01 to 1983-11-30
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1983-11-01 to 1983-11-30
    | overall
    | overall
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 330 (0.06%)  
    Records in observation
    | 1983-12-01 to 1983-12-31
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1983-12-01 to 1983-12-31
    | overall
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 310 (0.06%)  
    Records in observation
    | 1984-01-01 to 1984-01-31
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1984-01-01 to 1984-01-31
    | overall
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 310 (0.06%)  
    Records in observation
    | 1984-02-01 to 1984-02-29
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1984-02-01 to 1984-02-29
    | overall
    | overall
    | N (%)
    | 609 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 319 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 290 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 609 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 319 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 290 (0.06%)  
    Records in observation
    | 1984-03-01 to 1984-03-31
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1984-03-01 to 1984-03-31
    | overall
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1984-04-01 to 1984-04-30
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1984-04-01 to 1984-04-30
    | overall
    | overall
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 330 (0.06%)  
    Records in observation
    | 1984-05-01 to 1984-05-31
    | overall
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1984-05-01 to 1984-05-31
    | overall
    | overall
    | N (%)
    | 680 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 370 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 680 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 370 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 310 (0.06%)  
    Records in observation
    | 1984-06-01 to 1984-06-30
    | overall
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1984-06-01 to 1984-06-30
    | overall
    | overall
    | N (%)
    | 686 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 326 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 686 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 326 (0.06%)  
    Records in observation
    | 1984-07-01 to 1984-07-31
    | overall
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 1984-07-01 to 1984-07-31
    | overall
    | overall
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 372 (0.07%)  
    Records in observation
    | 1984-08-01 to 1984-08-31
    | overall
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1984-08-01 to 1984-08-31
    | overall
    | overall
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1984-09-01 to 1984-09-30
    | overall
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1984-09-01 to 1984-09-30
    | overall
    | overall
    | N (%)
    | 690 (0.14%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 690 (0.14%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    Records in observation
    | 1984-10-01 to 1984-10-31
    | overall
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 1984-10-01 to 1984-10-31
    | overall
    | overall
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 372 (0.07%)  
    Records in observation
    | 1984-11-01 to 1984-11-30
    | overall
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1984-11-01 to 1984-11-30
    | overall
    | overall
    | N (%)
    | 664 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 304 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 664 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 304 (0.06%)  
    Records in observation
    | 1984-12-01 to 1984-12-31
    | overall
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 1984-12-01 to 1984-12-31
    | overall
    | overall
    | N (%)
    | 664 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 292 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 664 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 292 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 372 (0.07%)  
    Records in observation
    | 1985-01-01 to 1985-01-31
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1985-01-01 to 1985-01-31
    | overall
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    Records in observation
    | 1985-02-01 to 1985-02-28
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1985-02-01 to 1985-02-28
    | overall
    | overall
    | N (%)
    | 588 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 336 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 252 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 588 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 252 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 336 (0.07%)  
    Records in observation
    | 1985-03-01 to 1985-03-31
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1985-03-01 to 1985-03-31
    | overall
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    Records in observation
    | 1985-04-01 to 1985-04-30
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1985-04-01 to 1985-04-30
    | overall
    | overall
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 270 (0.05%)  
    Records in observation
    | 1985-05-01 to 1985-05-31
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 1985-05-01 to 1985-05-31
    | overall
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 372 (0.07%)  
    Records in observation
    | 1985-06-01 to 1985-06-30
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1985-06-01 to 1985-06-30
    | overall
    | overall
    | N (%)
    | 604 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 244 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 604 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 244 (0.05%)  
    Records in observation
    | 1985-07-01 to 1985-07-31
    | overall
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 1985-07-01 to 1985-07-31
    | overall
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 372 (0.07%)  
    Records in observation
    | 1985-08-01 to 1985-08-31
    | overall
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    Person-days
    | 1985-08-01 to 1985-08-31
    | overall
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 248 (0.05%)  
    Records in observation
    | 1985-09-01 to 1985-09-30
    | overall
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    Person-days
    | 1985-09-01 to 1985-09-30
    | overall
    | overall
    | N (%)
    | 600 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 600 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 240 (0.05%)  
    Records in observation
    | 1985-10-01 to 1985-10-31
    | overall
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 1985-10-01 to 1985-10-31
    | overall
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 248 (0.05%)  
    Records in observation
    | 1985-11-01 to 1985-11-30
    | overall
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 1985-11-01 to 1985-11-30
    | overall
    | overall
    | N (%)
    | 600 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 600 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 360 (0.07%)  
    Records in observation
    | 1985-12-01 to 1985-12-31
    | overall
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 1985-12-01 to 1985-12-31
    | overall
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 372 (0.07%)  
    Records in observation
    | 1986-01-01 to 1986-01-31
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1986-01-01 to 1986-01-31
    | overall
    | overall
    | N (%)
    | 626 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 254 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 626 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 254 (0.05%)  
    Records in observation
    | 1986-02-01 to 1986-02-28
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1986-02-01 to 1986-02-28
    | overall
    | overall
    | N (%)
    | 588 (0.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 336 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 252 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 588 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 336 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 252 (0.05%)  
    Records in observation
    | 1986-03-01 to 1986-03-31
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1986-03-01 to 1986-03-31
    | overall
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    Records in observation
    | 1986-04-01 to 1986-04-30
    | overall
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1986-04-01 to 1986-04-30
    | overall
    | overall
    | N (%)
    | 659 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 389 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 659 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 389 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 270 (0.05%)  
    Records in observation
    | 1986-05-01 to 1986-05-31
    | overall
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1986-05-01 to 1986-05-31
    | overall
    | overall
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    Records in observation
    | 1986-06-01 to 1986-06-30
    | overall
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1986-06-01 to 1986-06-30
    | overall
    | overall
    | N (%)
    | 660 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 390 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 660 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 390 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 270 (0.05%)  
    Records in observation
    | 1986-07-01 to 1986-07-31
    | overall
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1986-07-01 to 1986-07-31
    | overall
    | overall
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    Records in observation
    | 1986-08-01 to 1986-08-31
    | overall
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1986-08-01 to 1986-08-31
    | overall
    | overall
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    Records in observation
    | 1986-09-01 to 1986-09-30
    | overall
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1986-09-01 to 1986-09-30
    | overall
    | overall
    | N (%)
    | 660 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 390 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 660 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 390 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 270 (0.05%)  
    Records in observation
    | 1986-10-01 to 1986-10-31
    | overall
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 13 (13.00%)  
    Person-days
    | 1986-10-01 to 1986-10-31
    | overall
    | overall
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 403 (0.08%)  
    Records in observation
    | 1986-11-01 to 1986-11-30
    | overall
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 1986-11-01 to 1986-11-30
    | overall
    | overall
    | N (%)
    | 660 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 390 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 660 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 390 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 270 (0.05%)  
    Records in observation
    | 1986-12-01 to 1986-12-31
    | overall
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 13 (13.00%)  
    Person-days
    | 1986-12-01 to 1986-12-31
    | overall
    | overall
    | N (%)
    | 709 (0.14%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 306 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 709 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 306 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 403 (0.08%)  
    Records in observation
    | 1987-01-01 to 1987-01-31
    | overall
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 13 (13.00%)  
    Person-days
    | 1987-01-01 to 1987-01-31
    | overall
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 317 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 317 (0.06%)  
    Records in observation
    | 1987-02-01 to 1987-02-28
    | overall
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1987-02-01 to 1987-02-28
    | overall
    | overall
    | N (%)
    | 672 (0.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 364 (0.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 308 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 672 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 364 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 308 (0.06%)  
    Records in observation
    | 1987-03-01 to 1987-03-31
    | overall
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 13 (13.00%)  
    Person-days
    | 1987-03-01 to 1987-03-31
    | overall
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1987-04-01 to 1987-04-30
    | overall
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 13 (13.00%)  
    Person-days
    | 1987-04-01 to 1987-04-30
    | overall
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 390 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 390 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    Records in observation
    | 1987-05-01 to 1987-05-31
    | overall
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 13 (13.00%)  
    Person-days
    | 1987-05-01 to 1987-05-31
    | overall
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1987-06-01 to 1987-06-30
    | overall
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1987-06-01 to 1987-06-30
    | overall
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 390 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 390 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    Records in observation
    | 1987-07-01 to 1987-07-31
    | overall
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1987-07-01 to 1987-07-31
    | overall
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1987-08-01 to 1987-08-31
    | overall
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1987-08-01 to 1987-08-31
    | overall
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1987-09-01 to 1987-09-30
    | overall
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1987-09-01 to 1987-09-30
    | overall
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 390 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 390 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    Records in observation
    | 1987-10-01 to 1987-10-31
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1987-10-01 to 1987-10-31
    | overall
    | overall
    | N (%)
    | 763 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 422 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 763 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 422 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1987-11-01 to 1987-11-30
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1987-11-01 to 1987-11-30
    | overall
    | overall
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 420 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 420 (0.08%)  
    Records in observation
    | 1987-12-01 to 1987-12-31
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1987-12-01 to 1987-12-31
    | overall
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1988-01-01 to 1988-01-31
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1988-01-01 to 1988-01-31
    | overall
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 434 (0.08%)  
    Records in observation
    | 1988-02-01 to 1988-02-29
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1988-02-01 to 1988-02-29
    | overall
    | overall
    | N (%)
    | 725 (0.14%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 406 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 319 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 725 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 319 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 406 (0.08%)  
    Records in observation
    | 1988-03-01 to 1988-03-31
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1988-03-01 to 1988-03-31
    | overall
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1988-04-01 to 1988-04-30
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1988-04-01 to 1988-04-30
    | overall
    | overall
    | N (%)
    | 748 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 420 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 328 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 748 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 420 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 328 (0.06%)  
    Records in observation
    | 1988-05-01 to 1988-05-31
    | overall
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1988-05-01 to 1988-05-31
    | overall
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 310 (0.06%)  
    Records in observation
    | 1988-06-01 to 1988-06-30
    | overall
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 1988-06-01 to 1988-06-30
    | overall
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 420 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 420 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 300 (0.06%)  
    Records in observation
    | 1988-07-01 to 1988-07-31
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1988-07-01 to 1988-07-31
    | overall
    | overall
    | N (%)
    | 773 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 339 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 773 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 339 (0.07%)  
    Records in observation
    | 1988-08-01 to 1988-08-31
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1988-08-01 to 1988-08-31
    | overall
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1988-09-01 to 1988-09-30
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1988-09-01 to 1988-09-30
    | overall
    | overall
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 420 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 420 (0.08%)  
    Records in observation
    | 1988-10-01 to 1988-10-31
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1988-10-01 to 1988-10-31
    | overall
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 434 (0.08%)  
    Records in observation
    | 1988-11-01 to 1988-11-30
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1988-11-01 to 1988-11-30
    | overall
    | overall
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 420 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 420 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    Records in observation
    | 1988-12-01 to 1988-12-31
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1988-12-01 to 1988-12-31
    | overall
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1989-01-01 to 1989-01-31
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1989-01-01 to 1989-01-31
    | overall
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1989-02-01 to 1989-02-28
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1989-02-01 to 1989-02-28
    | overall
    | overall
    | N (%)
    | 700 (0.14%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 392 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 308 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 700 (0.14%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 392 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 308 (0.06%)  
    Records in observation
    | 1989-03-01 to 1989-03-31
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1989-03-01 to 1989-03-31
    | overall
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 434 (0.08%)  
    Records in observation
    | 1989-04-01 to 1989-04-30
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1989-04-01 to 1989-04-30
    | overall
    | overall
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 420 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 420 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    Records in observation
    | 1989-05-01 to 1989-05-31
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1989-05-01 to 1989-05-31
    | overall
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1989-06-01 to 1989-06-30
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1989-06-01 to 1989-06-30
    | overall
    | overall
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 420 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 420 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    Records in observation
    | 1989-07-01 to 1989-07-31
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1989-07-01 to 1989-07-31
    | overall
    | overall
    | N (%)
    | 771 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 337 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 771 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 337 (0.07%)  
    Records in observation
    | 1989-08-01 to 1989-08-31
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 15 (15.00%)  
    Person-days
    | 1989-08-01 to 1989-08-31
    | overall
    | overall
    | N (%)
    | 769 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 459 (0.09%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 769 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 459 (0.09%)  
    Records in observation
    | 1989-09-01 to 1989-09-30
    | overall
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 15 (15.00%)  
    Person-days
    | 1989-09-01 to 1989-09-30
    | overall
    | overall
    | N (%)
    | 767 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 450 (0.09%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 317 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 767 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 317 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 450 (0.09%)  
    Records in observation
    | 1989-10-01 to 1989-10-31
    | overall
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1989-10-01 to 1989-10-31
    | overall
    | overall
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 465 (0.09%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 465 (0.09%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1989-11-01 to 1989-11-30
    | overall
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 15 (15.00%)  
    Person-days
    | 1989-11-01 to 1989-11-30
    | overall
    | overall
    | N (%)
    | 780 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 450 (0.09%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 780 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 450 (0.09%)  
    Records in observation
    | 1989-12-01 to 1989-12-31
    | overall
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1989-12-01 to 1989-12-31
    | overall
    | overall
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 465 (0.09%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 465 (0.09%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1990-01-01 to 1990-01-31
    | overall
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 15 (15.00%)  
    Person-days
    | 1990-01-01 to 1990-01-31
    | overall
    | overall
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 465 (0.09%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 465 (0.09%)  
    Records in observation
    | 1990-02-01 to 1990-02-28
    | overall
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1990-02-01 to 1990-02-28
    | overall
    | overall
    | N (%)
    | 728 (0.14%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 420 (0.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 308 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 728 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 308 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 420 (0.08%)  
    Records in observation
    | 1990-03-01 to 1990-03-31
    | overall
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1990-03-01 to 1990-03-31
    | overall
    | overall
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 465 (0.09%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 465 (0.09%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1990-04-01 to 1990-04-30
    | overall
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1990-04-01 to 1990-04-30
    | overall
    | overall
    | N (%)
    | 780 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 450 (0.09%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 780 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 450 (0.09%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    Records in observation
    | 1990-05-01 to 1990-05-31
    | overall
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1990-05-01 to 1990-05-31
    | overall
    | overall
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 465 (0.09%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 465 (0.09%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1990-06-01 to 1990-06-30
    | overall
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 15 (15.00%)  
    Person-days
    | 1990-06-01 to 1990-06-30
    | overall
    | overall
    | N (%)
    | 780 (0.15%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 450 (0.09%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 780 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 450 (0.09%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    Records in observation
    | 1990-07-01 to 1990-07-31
    | overall
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 15 (15.00%)  
    Person-days
    | 1990-07-01 to 1990-07-31
    | overall
    | overall
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 465 (0.09%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 465 (0.09%)  
    Records in observation
    | 1990-08-01 to 1990-08-31
    | overall
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1990-08-01 to 1990-08-31
    | overall
    | overall
    | N (%)
    | 820 (0.16%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 479 (0.09%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 820 (0.16%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 479 (0.09%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1990-09-01 to 1990-09-30
    | overall
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 1990-09-01 to 1990-09-30
    | overall
    | overall
    | N (%)
    | 810 (0.16%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 480 (0.09%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 810 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 480 (0.09%)  
    Records in observation
    | 1990-10-01 to 1990-10-31
    | overall
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1990-10-01 to 1990-10-31
    | overall
    | overall
    | N (%)
    | 863 (0.17%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 522 (0.10%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 863 (0.17%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 522 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1990-11-01 to 1990-11-30
    | overall
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1990-11-01 to 1990-11-30
    | overall
    | overall
    | N (%)
    | 840 (0.16%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 840 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 510 (0.10%)  
    Records in observation
    | 1990-12-01 to 1990-12-31
    | overall
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 1990-12-01 to 1990-12-31
    | overall
    | overall
    | N (%)
    | 877 (0.17%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 350 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 877 (0.17%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 350 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 527 (0.10%)  
    Records in observation
    | 1991-01-01 to 1991-01-31
    | overall
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 1991-01-01 to 1991-01-31
    | overall
    | overall
    | N (%)
    | 899 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 899 (0.18%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 372 (0.07%)  
    Records in observation
    | 1991-02-01 to 1991-02-28
    | overall
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 1991-02-01 to 1991-02-28
    | overall
    | overall
    | N (%)
    | 812 (0.16%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 476 (0.09%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 336 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 812 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 336 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 476 (0.09%)  
    Records in observation
    | 1991-03-01 to 1991-03-31
    | overall
    | overall
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 1991-03-01 to 1991-03-31
    | overall
    | overall
    | N (%)
    | 905 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 533 (0.10%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 905 (0.18%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 533 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 372 (0.07%)  
    Records in observation
    | 1991-04-01 to 1991-04-30
    | overall
    | overall
    | N (%)
    | 31 (31.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 31 (31.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 19 (19.00%)  
    Person-days
    | 1991-04-01 to 1991-04-30
    | overall
    | overall
    | N (%)
    | 907 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 547 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 907 (0.18%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 547 (0.11%)  
    Records in observation
    | 1991-05-01 to 1991-05-31
    | overall
    | overall
    | N (%)
    | 31 (31.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 31 (31.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 1991-05-01 to 1991-05-31
    | overall
    | overall
    | N (%)
    | 939 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 350 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 939 (0.18%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 350 (0.07%)  
    Records in observation
    | 1991-06-01 to 1991-06-30
    | overall
    | overall
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 19 (19.00%)  
    Person-days
    | 1991-06-01 to 1991-06-30
    | overall
    | overall
    | N (%)
    | 900 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 900 (0.18%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 570 (0.11%)  
    Records in observation
    | 1991-07-01 to 1991-07-31
    | overall
    | overall
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 19 (19.00%)  
    Person-days
    | 1991-07-01 to 1991-07-31
    | overall
    | overall
    | N (%)
    | 930 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 930 (0.18%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 589 (0.12%)  
    Records in observation
    | 1991-08-01 to 1991-08-31
    | overall
    | overall
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1991-08-01 to 1991-08-31
    | overall
    | overall
    | N (%)
    | 930 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 930 (0.18%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1991-09-01 to 1991-09-30
    | overall
    | overall
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 19 (19.00%)  
    Person-days
    | 1991-09-01 to 1991-09-30
    | overall
    | overall
    | N (%)
    | 900 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 900 (0.18%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 570 (0.11%)  
    Records in observation
    | 1991-10-01 to 1991-10-31
    | overall
    | overall
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1991-10-01 to 1991-10-31
    | overall
    | overall
    | N (%)
    | 930 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 930 (0.18%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1991-11-01 to 1991-11-30
    | overall
    | overall
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1991-11-01 to 1991-11-30
    | overall
    | overall
    | N (%)
    | 893 (0.17%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 563 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 893 (0.17%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 563 (0.11%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    Records in observation
    | 1991-12-01 to 1991-12-31
    | overall
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 1991-12-01 to 1991-12-31
    | overall
    | overall
    | N (%)
    | 899 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 899 (0.18%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 558 (0.11%)  
    Records in observation
    | 1992-01-01 to 1992-01-31
    | overall
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 1992-01-01 to 1992-01-31
    | overall
    | overall
    | N (%)
    | 899 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 899 (0.18%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 558 (0.11%)  
    Records in observation
    | 1992-02-01 to 1992-02-29
    | overall
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1992-02-01 to 1992-02-29
    | overall
    | overall
    | N (%)
    | 841 (0.16%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 522 (0.10%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 319 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 841 (0.16%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 522 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 319 (0.06%)  
    Records in observation
    | 1992-03-01 to 1992-03-31
    | overall
    | overall
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1992-03-01 to 1992-03-31
    | overall
    | overall
    | N (%)
    | 913 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 572 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 913 (0.18%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 572 (0.11%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1992-04-01 to 1992-04-30
    | overall
    | overall
    | N (%)
    | 31 (31.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 31 (31.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 19 (19.00%)  
    Person-days
    | 1992-04-01 to 1992-04-30
    | overall
    | overall
    | N (%)
    | 921 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 351 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 921 (0.18%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 351 (0.07%)  
    Records in observation
    | 1992-05-01 to 1992-05-31
    | overall
    | overall
    | N (%)
    | 31 (31.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 31 (31.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 1992-05-01 to 1992-05-31
    | overall
    | overall
    | N (%)
    | 961 (0.19%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 961 (0.19%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 372 (0.07%)  
    Records in observation
    | 1992-06-01 to 1992-06-30
    | overall
    | overall
    | N (%)
    | 31 (31.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 31 (31.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 1992-06-01 to 1992-06-30
    | overall
    | overall
    | N (%)
    | 930 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 930 (0.18%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 360 (0.07%)  
    Records in observation
    | 1992-07-01 to 1992-07-31
    | overall
    | overall
    | N (%)
    | 31 (31.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 31 (31.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 19 (19.00%)  
    Person-days
    | 1992-07-01 to 1992-07-31
    | overall
    | overall
    | N (%)
    | 934 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 345 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 934 (0.18%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 345 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 589 (0.12%)  
    Records in observation
    | 1992-08-01 to 1992-08-31
    | overall
    | overall
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 1992-08-01 to 1992-08-31
    | overall
    | overall
    | N (%)
    | 930 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 930 (0.18%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 1992-09-01 to 1992-09-30
    | overall
    | overall
    | N (%)
    | 31 (31.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 31 (31.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 19 (19.00%)  
    Person-days
    | 1992-09-01 to 1992-09-30
    | overall
    | overall
    | N (%)
    | 929 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 359 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 929 (0.18%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 359 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 570 (0.11%)  
    Records in observation
    | 1992-10-01 to 1992-10-31
    | overall
    | overall
    | N (%)
    | 31 (31.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 31 (31.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 19 (19.00%)  
    Person-days
    | 1992-10-01 to 1992-10-31
    | overall
    | overall
    | N (%)
    | 961 (0.19%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 961 (0.19%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 589 (0.12%)  
    Records in observation
    | 1992-11-01 to 1992-11-30
    | overall
    | overall
    | N (%)
    | 32 (32.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 32 (32.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 1992-11-01 to 1992-11-30
    | overall
    | overall
    | N (%)
    | 937 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 577 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 937 (0.18%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 577 (0.11%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 360 (0.07%)  
    Records in observation
    | 1992-12-01 to 1992-12-31
    | overall
    | overall
    | N (%)
    | 33 (33.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 33 (33.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    Person-days
    | 1992-12-01 to 1992-12-31
    | overall
    | overall
    | N (%)
    | 1,002 (0.20%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,002 (0.20%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 630 (0.12%)  
    Records in observation
    | 1993-01-01 to 1993-01-31
    | overall
    | overall
    | N (%)
    | 33 (33.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 33 (33.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 1993-01-01 to 1993-01-31
    | overall
    | overall
    | N (%)
    | 1,023 (0.20%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,023 (0.20%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 372 (0.07%)  
    Records in observation
    | 1993-02-01 to 1993-02-28
    | overall
    | overall
    | N (%)
    | 33 (33.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 33 (33.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 1993-02-01 to 1993-02-28
    | overall
    | overall
    | N (%)
    | 924 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 588 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 336 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 924 (0.18%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 588 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 336 (0.07%)  
    Records in observation
    | 1993-03-01 to 1993-03-31
    | overall
    | overall
    | N (%)
    | 33 (33.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 33 (33.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 1993-03-01 to 1993-03-31
    | overall
    | overall
    | N (%)
    | 1,023 (0.20%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,023 (0.20%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 372 (0.07%)  
    Records in observation
    | 1993-04-01 to 1993-04-30
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 13 (13.00%)  
    Person-days
    | 1993-04-01 to 1993-04-30
    | overall
    | overall
    | N (%)
    | 1,003 (0.20%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 373 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,003 (0.20%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 373 (0.07%)  
    Records in observation
    | 1993-05-01 to 1993-05-31
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 13 (13.00%)  
    Person-days
    | 1993-05-01 to 1993-05-31
    | overall
    | overall
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 403 (0.08%)  
    Records in observation
    | 1993-06-01 to 1993-06-30
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    Person-days
    | 1993-06-01 to 1993-06-30
    | overall
    | overall
    | N (%)
    | 1,020 (0.20%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 390 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,020 (0.20%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 390 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 630 (0.12%)  
    Records in observation
    | 1993-07-01 to 1993-07-31
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 13 (13.00%)  
    Person-days
    | 1993-07-01 to 1993-07-31
    | overall
    | overall
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 403 (0.08%)  
    Records in observation
    | 1993-08-01 to 1993-08-31
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 13 (13.00%)  
    Person-days
    | 1993-08-01 to 1993-08-31
    | overall
    | overall
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 403 (0.08%)  
    Records in observation
    | 1993-09-01 to 1993-09-30
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 13 (13.00%)  
    Person-days
    | 1993-09-01 to 1993-09-30
    | overall
    | overall
    | N (%)
    | 1,020 (0.20%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 390 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,020 (0.20%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 390 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 630 (0.12%)  
    Records in observation
    | 1993-10-01 to 1993-10-31
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 13 (13.00%)  
    Person-days
    | 1993-10-01 to 1993-10-31
    | overall
    | overall
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 403 (0.08%)  
    Records in observation
    | 1993-11-01 to 1993-11-30
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1993-11-01 to 1993-11-30
    | overall
    | overall
    | N (%)
    | 1,037 (0.20%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 407 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,037 (0.20%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 407 (0.08%)  
    Records in observation
    | 1993-12-01 to 1993-12-31
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1993-12-01 to 1993-12-31
    | overall
    | overall
    | N (%)
    | 1,075 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 641 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,075 (0.21%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 641 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 434 (0.08%)  
    Records in observation
    | 1994-01-01 to 1994-01-31
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 1994-01-01 to 1994-01-31
    | overall
    | overall
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 620 (0.12%)  
    Records in observation
    | 1994-02-01 to 1994-02-28
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    Person-days
    | 1994-02-01 to 1994-02-28
    | overall
    | overall
    | N (%)
    | 962 (0.19%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 392 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 962 (0.19%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 392 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 570 (0.11%)  
    Records in observation
    | 1994-03-01 to 1994-03-31
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1994-03-01 to 1994-03-31
    | overall
    | overall
    | N (%)
    | 1,085 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,085 (0.21%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 434 (0.08%)  
    Records in observation
    | 1994-04-01 to 1994-04-30
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1994-04-01 to 1994-04-30
    | overall
    | overall
    | N (%)
    | 1,050 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 420 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,050 (0.21%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 420 (0.08%)  
    Records in observation
    | 1994-05-01 to 1994-05-31
    | overall
    | overall
    | N (%)
    | 36 (36.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 36 (36.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1994-05-01 to 1994-05-31
    | overall
    | overall
    | N (%)
    | 1,115 (0.22%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 681 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,115 (0.22%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 681 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 434 (0.08%)  
    Records in observation
    | 1994-06-01 to 1994-06-30
    | overall
    | overall
    | N (%)
    | 36 (36.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 36 (36.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1994-06-01 to 1994-06-30
    | overall
    | overall
    | N (%)
    | 1,080 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 660 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 420 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,080 (0.21%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 420 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 660 (0.13%)  
    Records in observation
    | 1994-07-01 to 1994-07-31
    | overall
    | overall
    | N (%)
    | 37 (37.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 37 (37.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 22 (22.00%)  
    Person-days
    | 1994-07-01 to 1994-07-31
    | overall
    | overall
    | N (%)
    | 1,111 (0.22%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 661 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 450 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,111 (0.22%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 450 (0.09%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 661 (0.13%)  
    Records in observation
    | 1994-08-01 to 1994-08-31
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    Person-days
    | 1994-08-01 to 1994-08-31
    | overall
    | overall
    | N (%)
    | 1,085 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,085 (0.21%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 651 (0.13%)  
    Records in observation
    | 1994-09-01 to 1994-09-30
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1994-09-01 to 1994-09-30
    | overall
    | overall
    | N (%)
    | 1,050 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 420 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,050 (0.21%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 420 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 630 (0.12%)  
    Records in observation
    | 1994-10-01 to 1994-10-31
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    Person-days
    | 1994-10-01 to 1994-10-31
    | overall
    | overall
    | N (%)
    | 1,085 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,085 (0.21%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 651 (0.13%)  
    Records in observation
    | 1994-11-01 to 1994-11-30
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1994-11-01 to 1994-11-30
    | overall
    | overall
    | N (%)
    | 1,050 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 420 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,050 (0.21%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 420 (0.08%)  
    Records in observation
    | 1994-12-01 to 1994-12-31
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1994-12-01 to 1994-12-31
    | overall
    | overall
    | N (%)
    | 1,085 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,085 (0.21%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 651 (0.13%)  
    Records in observation
    | 1995-01-01 to 1995-01-31
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1995-01-01 to 1995-01-31
    | overall
    | overall
    | N (%)
    | 1,085 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,085 (0.21%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 651 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 434 (0.08%)  
    Records in observation
    | 1995-02-01 to 1995-02-28
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    Person-days
    | 1995-02-01 to 1995-02-28
    | overall
    | overall
    | N (%)
    | 976 (0.19%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 584 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 392 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 976 (0.19%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 392 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 584 (0.11%)  
    Records in observation
    | 1995-03-01 to 1995-03-31
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1995-03-01 to 1995-03-31
    | overall
    | overall
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 434 (0.08%)  
    Records in observation
    | 1995-04-01 to 1995-04-30
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 1995-04-01 to 1995-04-30
    | overall
    | overall
    | N (%)
    | 1,020 (0.20%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 600 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 420 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,020 (0.20%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 600 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 420 (0.08%)  
    Records in observation
    | 1995-05-01 to 1995-05-31
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 1995-05-01 to 1995-05-31
    | overall
    | overall
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 620 (0.12%)  
    Records in observation
    | 1995-06-01 to 1995-06-30
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1995-06-01 to 1995-06-30
    | overall
    | overall
    | N (%)
    | 1,020 (0.20%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 600 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 420 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,020 (0.20%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 600 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 420 (0.08%)  
    Records in observation
    | 1995-07-01 to 1995-07-31
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 1995-07-01 to 1995-07-31
    | overall
    | overall
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 620 (0.12%)  
    Records in observation
    | 1995-08-01 to 1995-08-31
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1995-08-01 to 1995-08-31
    | overall
    | overall
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 434 (0.08%)  
    Records in observation
    | 1995-09-01 to 1995-09-30
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1995-09-01 to 1995-09-30
    | overall
    | overall
    | N (%)
    | 1,020 (0.20%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 600 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 420 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,020 (0.20%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 600 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 420 (0.08%)  
    Records in observation
    | 1995-10-01 to 1995-10-31
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 1995-10-01 to 1995-10-31
    | overall
    | overall
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 620 (0.12%)  
    Records in observation
    | 1995-11-01 to 1995-11-30
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 1995-11-01 to 1995-11-30
    | overall
    | overall
    | N (%)
    | 1,020 (0.20%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 600 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 420 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,020 (0.20%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 420 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 600 (0.12%)  
    Records in observation
    | 1995-12-01 to 1995-12-31
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1995-12-01 to 1995-12-31
    | overall
    | overall
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 434 (0.08%)  
    Records in observation
    | 1996-01-01 to 1996-01-31
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1996-01-01 to 1996-01-31
    | overall
    | overall
    | N (%)
    | 1,030 (0.20%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 410 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,030 (0.20%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 410 (0.08%)  
    Records in observation
    | 1996-02-01 to 1996-02-29
    | overall
    | overall
    | N (%)
    | 33 (33.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 33 (33.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 13 (13.00%)  
    Person-days
    | 1996-02-01 to 1996-02-29
    | overall
    | overall
    | N (%)
    | 957 (0.19%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 580 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 377 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 957 (0.19%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 580 (0.11%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 377 (0.07%)  
    Records in observation
    | 1996-03-01 to 1996-03-31
    | overall
    | overall
    | N (%)
    | 33 (33.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 33 (33.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 13 (13.00%)  
    Person-days
    | 1996-03-01 to 1996-03-31
    | overall
    | overall
    | N (%)
    | 1,023 (0.20%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,023 (0.20%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 403 (0.08%)  
    Records in observation
    | 1996-04-01 to 1996-04-30
    | overall
    | overall
    | N (%)
    | 33 (33.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 33 (33.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 13 (13.00%)  
    Person-days
    | 1996-04-01 to 1996-04-30
    | overall
    | overall
    | N (%)
    | 990 (0.19%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 600 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 390 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 990 (0.19%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 600 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 390 (0.08%)  
    Records in observation
    | 1996-05-01 to 1996-05-31
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 13 (13.00%)  
    Person-days
    | 1996-05-01 to 1996-05-31
    | overall
    | overall
    | N (%)
    | 1,031 (0.20%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 628 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,031 (0.20%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 628 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 403 (0.08%)  
    Records in observation
    | 1996-06-01 to 1996-06-30
    | overall
    | overall
    | N (%)
    | 37 (37.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 37 (37.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1996-06-01 to 1996-06-30
    | overall
    | overall
    | N (%)
    | 1,077 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 661 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 416 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,077 (0.21%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 661 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 416 (0.08%)  
    Records in observation
    | 1996-07-01 to 1996-07-31
    | overall
    | overall
    | N (%)
    | 37 (37.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 37 (37.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 1996-07-01 to 1996-07-31
    | overall
    | overall
    | N (%)
    | 1,147 (0.22%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,147 (0.22%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 434 (0.08%)  
    Records in observation
    | 1996-08-01 to 1996-08-31
    | overall
    | overall
    | N (%)
    | 38 (38.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 38 (38.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 15 (15.00%)  
    Person-days
    | 1996-08-01 to 1996-08-31
    | overall
    | overall
    | N (%)
    | 1,162 (0.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 449 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,162 (0.23%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 449 (0.09%)  
    Records in observation
    | 1996-09-01 to 1996-09-30
    | overall
    | overall
    | N (%)
    | 38 (38.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 38 (38.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 15 (15.00%)  
    Person-days
    | 1996-09-01 to 1996-09-30
    | overall
    | overall
    | N (%)
    | 1,140 (0.22%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 690 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 450 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,140 (0.22%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 690 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 450 (0.09%)  
    Records in observation
    | 1996-10-01 to 1996-10-31
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 1996-10-01 to 1996-10-31
    | overall
    | overall
    | N (%)
    | 1,208 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 717 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 491 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,208 (0.24%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 717 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 491 (0.10%)  
    Records in observation
    | 1996-11-01 to 1996-11-30
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 1996-11-01 to 1996-11-30
    | overall
    | overall
    | N (%)
    | 1,200 (0.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 480 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,200 (0.23%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 480 (0.09%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 720 (0.14%)  
    Records in observation
    | 1996-12-01 to 1996-12-31
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 1996-12-01 to 1996-12-31
    | overall
    | overall
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    Records in observation
    | 1997-01-01 to 1997-01-31
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 1997-01-01 to 1997-01-31
    | overall
    | overall
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    Records in observation
    | 1997-02-01 to 1997-02-28
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 1997-02-01 to 1997-02-28
    | overall
    | overall
    | N (%)
    | 1,120 (0.22%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 672 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 448 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,120 (0.22%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 448 (0.09%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 672 (0.13%)  
    Records in observation
    | 1997-03-01 to 1997-03-31
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 1997-03-01 to 1997-03-31
    | overall
    | overall
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    Records in observation
    | 1997-04-01 to 1997-04-30
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 1997-04-01 to 1997-04-30
    | overall
    | overall
    | N (%)
    | 1,200 (0.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 480 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,200 (0.23%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 480 (0.09%)  
    Records in observation
    | 1997-05-01 to 1997-05-31
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 1997-05-01 to 1997-05-31
    | overall
    | overall
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    Records in observation
    | 1997-06-01 to 1997-06-30
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 1997-06-01 to 1997-06-30
    | overall
    | overall
    | N (%)
    | 1,200 (0.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 480 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,200 (0.23%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 480 (0.09%)  
    Records in observation
    | 1997-07-01 to 1997-07-31
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 1997-07-01 to 1997-07-31
    | overall
    | overall
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    Records in observation
    | 1997-08-01 to 1997-08-31
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 1997-08-01 to 1997-08-31
    | overall
    | overall
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    Records in observation
    | 1997-09-01 to 1997-09-30
    | overall
    | overall
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 1997-09-01 to 1997-09-30
    | overall
    | overall
    | N (%)
    | 1,208 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 488 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,208 (0.24%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 488 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 720 (0.14%)  
    Records in observation
    | 1997-10-01 to 1997-10-31
    | overall
    | overall
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 1997-10-01 to 1997-10-31
    | overall
    | overall
    | N (%)
    | 1,271 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,271 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    Records in observation
    | 1997-11-01 to 1997-11-30
    | overall
    | overall
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 1997-11-01 to 1997-11-30
    | overall
    | overall
    | N (%)
    | 1,230 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,230 (0.24%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 510 (0.10%)  
    Records in observation
    | 1997-12-01 to 1997-12-31
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 1997-12-01 to 1997-12-31
    | overall
    | overall
    | N (%)
    | 1,287 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 543 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,287 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 543 (0.11%)  
    Records in observation
    | 1998-01-01 to 1998-01-31
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 1998-01-01 to 1998-01-31
    | overall
    | overall
    | N (%)
    | 1,302 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,302 (0.25%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    Records in observation
    | 1998-02-01 to 1998-02-28
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 1998-02-01 to 1998-02-28
    | overall
    | overall
    | N (%)
    | 1,176 (0.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 672 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 504 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,176 (0.23%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 672 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 504 (0.10%)  
    Records in observation
    | 1998-03-01 to 1998-03-31
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 1998-03-01 to 1998-03-31
    | overall
    | overall
    | N (%)
    | 1,302 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,302 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    Records in observation
    | 1998-04-01 to 1998-04-30
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 1998-04-01 to 1998-04-30
    | overall
    | overall
    | N (%)
    | 1,260 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,260 (0.25%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 540 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 720 (0.14%)  
    Records in observation
    | 1998-05-01 to 1998-05-31
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 1998-05-01 to 1998-05-31
    | overall
    | overall
    | N (%)
    | 1,302 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,302 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    Records in observation
    | 1998-06-01 to 1998-06-30
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 1998-06-01 to 1998-06-30
    | overall
    | overall
    | N (%)
    | 1,260 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,260 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 540 (0.11%)  
    Records in observation
    | 1998-07-01 to 1998-07-31
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 1998-07-01 to 1998-07-31
    | overall
    | overall
    | N (%)
    | 1,302 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,302 (0.25%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    Records in observation
    | 1998-08-01 to 1998-08-31
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 1998-08-01 to 1998-08-31
    | overall
    | overall
    | N (%)
    | 1,302 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,302 (0.25%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    Records in observation
    | 1998-09-01 to 1998-09-30
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 1998-09-01 to 1998-09-30
    | overall
    | overall
    | N (%)
    | 1,260 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,260 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 540 (0.11%)  
    Records in observation
    | 1998-10-01 to 1998-10-31
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 1998-10-01 to 1998-10-31
    | overall
    | overall
    | N (%)
    | 1,302 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,302 (0.25%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    Records in observation
    | 1998-11-01 to 1998-11-30
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 1998-11-01 to 1998-11-30
    | overall
    | overall
    | N (%)
    | 1,247 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 707 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,247 (0.24%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 707 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 540 (0.11%)  
    Records in observation
    | 1998-12-01 to 1998-12-31
    | overall
    | overall
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 1998-12-01 to 1998-12-31
    | overall
    | overall
    | N (%)
    | 1,256 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 543 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,256 (0.25%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 543 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 713 (0.14%)  
    Records in observation
    | 1999-01-01 to 1999-01-31
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 1999-01-01 to 1999-01-31
    | overall
    | overall
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    Records in observation
    | 1999-02-01 to 1999-02-28
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 1999-02-01 to 1999-02-28
    | overall
    | overall
    | N (%)
    | 1,120 (0.22%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 644 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 476 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,120 (0.22%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 644 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 476 (0.09%)  
    Records in observation
    | 1999-03-01 to 1999-03-31
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 1999-03-01 to 1999-03-31
    | overall
    | overall
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    Records in observation
    | 1999-04-01 to 1999-04-30
    | overall
    | overall
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 1999-04-01 to 1999-04-30
    | overall
    | overall
    | N (%)
    | 1,211 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 701 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,211 (0.24%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 701 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 510 (0.10%)  
    Records in observation
    | 1999-05-01 to 1999-05-31
    | overall
    | overall
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 1999-05-01 to 1999-05-31
    | overall
    | overall
    | N (%)
    | 1,271 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,271 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    Records in observation
    | 1999-06-01 to 1999-06-30
    | overall
    | overall
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 1999-06-01 to 1999-06-30
    | overall
    | overall
    | N (%)
    | 1,230 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,230 (0.24%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 510 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 720 (0.14%)  
    Records in observation
    | 1999-07-01 to 1999-07-31
    | overall
    | overall
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 1999-07-01 to 1999-07-31
    | overall
    | overall
    | N (%)
    | 1,271 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,271 (0.25%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    Records in observation
    | 1999-08-01 to 1999-08-31
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 1999-08-01 to 1999-08-31
    | overall
    | overall
    | N (%)
    | 1,291 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 547 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,291 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 547 (0.11%)  
    Records in observation
    | 1999-09-01 to 1999-09-30
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 1999-09-01 to 1999-09-30
    | overall
    | overall
    | N (%)
    | 1,231 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 511 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,231 (0.24%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 511 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 720 (0.14%)  
    Records in observation
    | 1999-10-01 to 1999-10-31
    | overall
    | overall
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 1999-10-01 to 1999-10-31
    | overall
    | overall
    | N (%)
    | 1,271 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,271 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    Records in observation
    | 1999-11-01 to 1999-11-30
    | overall
    | overall
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 1999-11-01 to 1999-11-30
    | overall
    | overall
    | N (%)
    | 1,230 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,230 (0.24%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 510 (0.10%)  
    Records in observation
    | 1999-12-01 to 1999-12-31
    | overall
    | overall
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 1999-12-01 to 1999-12-31
    | overall
    | overall
    | N (%)
    | 1,271 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,271 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    Records in observation
    | 2000-01-01 to 2000-01-31
    | overall
    | overall
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2000-01-01 to 2000-01-31
    | overall
    | overall
    | N (%)
    | 1,271 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,271 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    Records in observation
    | 2000-02-01 to 2000-02-29
    | overall
    | overall
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2000-02-01 to 2000-02-29
    | overall
    | overall
    | N (%)
    | 1,174 (0.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 696 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 478 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,174 (0.23%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 696 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 478 (0.09%)  
    Records in observation
    | 2000-03-01 to 2000-03-31
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 2000-03-01 to 2000-03-31
    | overall
    | overall
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    Records in observation
    | 2000-04-01 to 2000-04-30
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 2000-04-01 to 2000-04-30
    | overall
    | overall
    | N (%)
    | 1,200 (0.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 480 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,200 (0.23%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 480 (0.09%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 720 (0.14%)  
    Records in observation
    | 2000-05-01 to 2000-05-31
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 2000-05-01 to 2000-05-31
    | overall
    | overall
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    Records in observation
    | 2000-06-01 to 2000-06-30
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 2000-06-01 to 2000-06-30
    | overall
    | overall
    | N (%)
    | 1,189 (0.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 709 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 480 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,189 (0.23%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 480 (0.09%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 709 (0.14%)  
    Records in observation
    | 2000-07-01 to 2000-07-31
    | overall
    | overall
    | N (%)
    | 39 (39.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 39 (39.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    Person-days
    | 2000-07-01 to 2000-07-31
    | overall
    | overall
    | N (%)
    | 1,209 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,209 (0.24%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 713 (0.14%)  
    Records in observation
    | 2000-08-01 to 2000-08-31
    | overall
    | overall
    | N (%)
    | 39 (39.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 39 (39.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 2000-08-01 to 2000-08-31
    | overall
    | overall
    | N (%)
    | 1,209 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,209 (0.24%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    Records in observation
    | 2000-09-01 to 2000-09-30
    | overall
    | overall
    | N (%)
    | 39 (39.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 39 (39.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 2000-09-01 to 2000-09-30
    | overall
    | overall
    | N (%)
    | 1,170 (0.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 690 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 480 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,170 (0.23%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 690 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 480 (0.09%)  
    Records in observation
    | 2000-10-01 to 2000-10-31
    | overall
    | overall
    | N (%)
    | 39 (39.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 39 (39.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    Person-days
    | 2000-10-01 to 2000-10-31
    | overall
    | overall
    | N (%)
    | 1,209 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,209 (0.24%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 713 (0.14%)  
    Records in observation
    | 2000-11-01 to 2000-11-30
    | overall
    | overall
    | N (%)
    | 39 (39.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 39 (39.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 2000-11-01 to 2000-11-30
    | overall
    | overall
    | N (%)
    | 1,170 (0.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 690 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 480 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,170 (0.23%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 690 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 480 (0.09%)  
    Records in observation
    | 2000-12-01 to 2000-12-31
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 2000-12-01 to 2000-12-31
    | overall
    | overall
    | N (%)
    | 1,228 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 732 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,228 (0.24%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 732 (0.14%)  
    Records in observation
    | 2001-01-01 to 2001-01-31
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 2001-01-01 to 2001-01-31
    | overall
    | overall
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    Records in observation
    | 2001-02-01 to 2001-02-28
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 2001-02-01 to 2001-02-28
    | overall
    | overall
    | N (%)
    | 1,120 (0.22%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 672 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 448 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,120 (0.22%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 672 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 448 (0.09%)  
    Records in observation
    | 2001-03-01 to 2001-03-31
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 2001-03-01 to 2001-03-31
    | overall
    | overall
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    Records in observation
    | 2001-04-01 to 2001-04-30
    | overall
    | overall
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 2001-04-01 to 2001-04-30
    | overall
    | overall
    | N (%)
    | 1,204 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 724 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 480 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,204 (0.24%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 724 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 480 (0.09%)  
    Records in observation
    | 2001-05-01 to 2001-05-31
    | overall
    | overall
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    Person-days
    | 2001-05-01 to 2001-05-31
    | overall
    | overall
    | N (%)
    | 1,271 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,271 (0.25%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 775 (0.15%)  
    Records in observation
    | 2001-06-01 to 2001-06-30
    | overall
    | overall
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    Person-days
    | 2001-06-01 to 2001-06-30
    | overall
    | overall
    | N (%)
    | 1,230 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 480 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,230 (0.24%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 480 (0.09%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 750 (0.15%)  
    Records in observation
    | 2001-07-01 to 2001-07-31
    | overall
    | overall
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 2001-07-01 to 2001-07-31
    | overall
    | overall
    | N (%)
    | 1,271 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,271 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    Records in observation
    | 2001-08-01 to 2001-08-31
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2001-08-01 to 2001-08-31
    | overall
    | overall
    | N (%)
    | 1,278 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 503 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,278 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 503 (0.10%)  
    Records in observation
    | 2001-09-01 to 2001-09-30
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2001-09-01 to 2001-09-30
    | overall
    | overall
    | N (%)
    | 1,260 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,260 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 510 (0.10%)  
    Records in observation
    | 2001-10-01 to 2001-10-31
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    Person-days
    | 2001-10-01 to 2001-10-31
    | overall
    | overall
    | N (%)
    | 1,302 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,302 (0.25%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 775 (0.15%)  
    Records in observation
    | 2001-11-01 to 2001-11-30
    | overall
    | overall
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    Person-days
    | 2001-11-01 to 2001-11-30
    | overall
    | overall
    | N (%)
    | 1,277 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 767 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,277 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 767 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 510 (0.10%)  
    Records in observation
    | 2001-12-01 to 2001-12-31
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    Person-days
    | 2001-12-01 to 2001-12-31
    | overall
    | overall
    | N (%)
    | 1,362 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 804 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,362 (0.27%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 804 (0.16%)  
    Records in observation
    | 2002-01-01 to 2002-01-31
    | overall
    | overall
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    Person-days
    | 2002-01-01 to 2002-01-31
    | overall
    | overall
    | N (%)
    | 1,333 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,333 (0.26%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 775 (0.15%)  
    Records in observation
    | 2002-02-01 to 2002-02-28
    | overall
    | overall
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    Person-days
    | 2002-02-01 to 2002-02-28
    | overall
    | overall
    | N (%)
    | 1,204 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 700 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 504 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,204 (0.24%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 504 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 700 (0.14%)  
    Records in observation
    | 2002-03-01 to 2002-03-31
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    Person-days
    | 2002-03-01 to 2002-03-31
    | overall
    | overall
    | N (%)
    | 1,336 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 778 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,336 (0.26%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 778 (0.15%)  
    Records in observation
    | 2002-04-01 to 2002-04-30
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    Person-days
    | 2002-04-01 to 2002-04-30
    | overall
    | overall
    | N (%)
    | 1,311 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 771 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,311 (0.26%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 540 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 771 (0.15%)  
    Records in observation
    | 2002-05-01 to 2002-05-31
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2002-05-01 to 2002-05-31
    | overall
    | overall
    | N (%)
    | 1,341 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 789 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 552 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,341 (0.26%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 789 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 552 (0.11%)  
    Records in observation
    | 2002-06-01 to 2002-06-30
    | overall
    | overall
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    Person-days
    | 2002-06-01 to 2002-06-30
    | overall
    | overall
    | N (%)
    | 1,290 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 780 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,290 (0.25%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 510 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 780 (0.15%)  
    Records in observation
    | 2002-07-01 to 2002-07-31
    | overall
    | overall
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    Person-days
    | 2002-07-01 to 2002-07-31
    | overall
    | overall
    | N (%)
    | 1,333 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,333 (0.26%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 806 (0.16%)  
    Records in observation
    | 2002-08-01 to 2002-08-31
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 27 (27.00%)  
    Person-days
    | 2002-08-01 to 2002-08-31
    | overall
    | overall
    | N (%)
    | 1,367 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 815 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 552 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,367 (0.27%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 552 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 815 (0.16%)  
    Records in observation
    | 2002-09-01 to 2002-09-30
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2002-09-01 to 2002-09-30
    | overall
    | overall
    | N (%)
    | 1,350 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 810 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,350 (0.26%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 810 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 540 (0.11%)  
    Records in observation
    | 2002-10-01 to 2002-10-31
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2002-10-01 to 2002-10-31
    | overall
    | overall
    | N (%)
    | 1,395 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 837 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,395 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 837 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    Records in observation
    | 2002-11-01 to 2002-11-30
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2002-11-01 to 2002-11-30
    | overall
    | overall
    | N (%)
    | 1,375 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 835 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,375 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 835 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 540 (0.11%)  
    Records in observation
    | 2002-12-01 to 2002-12-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 28 (28.00%)  
    Person-days
    | 2002-12-01 to 2002-12-31
    | overall
    | overall
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 868 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 868 (0.17%)  
    Records in observation
    | 2003-01-01 to 2003-01-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 28 (28.00%)  
    Person-days
    | 2003-01-01 to 2003-01-31
    | overall
    | overall
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 868 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 868 (0.17%)  
    Records in observation
    | 2003-02-01 to 2003-02-28
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2003-02-01 to 2003-02-28
    | overall
    | overall
    | N (%)
    | 1,288 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 784 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 504 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,288 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 784 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 504 (0.10%)  
    Records in observation
    | 2003-03-01 to 2003-03-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 28 (28.00%)  
    Person-days
    | 2003-03-01 to 2003-03-31
    | overall
    | overall
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 868 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 868 (0.17%)  
    Records in observation
    | 2003-04-01 to 2003-04-30
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2003-04-01 to 2003-04-30
    | overall
    | overall
    | N (%)
    | 1,380 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 840 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,380 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 840 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 540 (0.11%)  
    Records in observation
    | 2003-05-01 to 2003-05-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2003-05-01 to 2003-05-31
    | overall
    | overall
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 868 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 868 (0.17%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    Records in observation
    | 2003-06-01 to 2003-06-30
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2003-06-01 to 2003-06-30
    | overall
    | overall
    | N (%)
    | 1,380 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 840 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,380 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 840 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 540 (0.11%)  
    Records in observation
    | 2003-07-01 to 2003-07-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 28 (28.00%)  
    Person-days
    | 2003-07-01 to 2003-07-31
    | overall
    | overall
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 868 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 868 (0.17%)  
    Records in observation
    | 2003-08-01 to 2003-08-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2003-08-01 to 2003-08-31
    | overall
    | overall
    | N (%)
    | 1,425 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 868 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 557 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,425 (0.28%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 868 (0.17%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 557 (0.11%)  
    Records in observation
    | 2003-09-01 to 2003-09-30
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 28 (28.00%)  
    Person-days
    | 2003-09-01 to 2003-09-30
    | overall
    | overall
    | N (%)
    | 1,350 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 840 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,350 (0.26%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 510 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 840 (0.16%)  
    Records in observation
    | 2003-10-01 to 2003-10-31
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2003-10-01 to 2003-10-31
    | overall
    | overall
    | N (%)
    | 1,395 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 868 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,395 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 868 (0.17%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    Records in observation
    | 2003-11-01 to 2003-11-30
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2003-11-01 to 2003-11-30
    | overall
    | overall
    | N (%)
    | 1,350 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 840 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,350 (0.26%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 840 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 510 (0.10%)  
    Records in observation
    | 2003-12-01 to 2003-12-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2003-12-01 to 2003-12-31
    | overall
    | overall
    | N (%)
    | 1,405 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 878 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,405 (0.27%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 878 (0.17%)  
    Records in observation
    | 2004-01-01 to 2004-01-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 29 (29.00%)  
    Person-days
    | 2004-01-01 to 2004-01-31
    | overall
    | overall
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 899 (0.18%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 899 (0.18%)  
    Records in observation
    | 2004-02-01 to 2004-02-29
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2004-02-01 to 2004-02-29
    | overall
    | overall
    | N (%)
    | 1,334 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 841 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 493 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,334 (0.26%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 841 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 493 (0.10%)  
    Records in observation
    | 2004-03-01 to 2004-03-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2004-03-01 to 2004-03-31
    | overall
    | overall
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 899 (0.18%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 899 (0.18%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    Records in observation
    | 2004-04-01 to 2004-04-30
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2004-04-01 to 2004-04-30
    | overall
    | overall
    | N (%)
    | 1,380 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 870 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,380 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 870 (0.17%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 510 (0.10%)  
    Records in observation
    | 2004-05-01 to 2004-05-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2004-05-01 to 2004-05-31
    | overall
    | overall
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 899 (0.18%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 899 (0.18%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    Records in observation
    | 2004-06-01 to 2004-06-30
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2004-06-01 to 2004-06-30
    | overall
    | overall
    | N (%)
    | 1,380 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 870 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,380 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 870 (0.17%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 510 (0.10%)  
    Records in observation
    | 2004-07-01 to 2004-07-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2004-07-01 to 2004-07-31
    | overall
    | overall
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 899 (0.18%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 899 (0.18%)  
    Records in observation
    | 2004-08-01 to 2004-08-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2004-08-01 to 2004-08-31
    | overall
    | overall
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 899 (0.18%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 899 (0.18%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    Records in observation
    | 2004-09-01 to 2004-09-30
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 29 (29.00%)  
    Person-days
    | 2004-09-01 to 2004-09-30
    | overall
    | overall
    | N (%)
    | 1,380 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 870 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,380 (0.27%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 510 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 870 (0.17%)  
    Records in observation
    | 2004-10-01 to 2004-10-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2004-10-01 to 2004-10-31
    | overall
    | overall
    | N (%)
    | 1,418 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 891 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,418 (0.28%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 891 (0.17%)  
    Records in observation
    | 2004-11-01 to 2004-11-30
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2004-11-01 to 2004-11-30
    | overall
    | overall
    | N (%)
    | 1,350 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 840 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,350 (0.26%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 840 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 510 (0.10%)  
    Records in observation
    | 2004-12-01 to 2004-12-31
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2004-12-01 to 2004-12-31
    | overall
    | overall
    | N (%)
    | 1,395 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 868 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,395 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 868 (0.17%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    Records in observation
    | 2005-01-01 to 2005-01-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2005-01-01 to 2005-01-31
    | overall
    | overall
    | N (%)
    | 1,401 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 847 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 554 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,401 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 847 (0.17%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 554 (0.11%)  
    Records in observation
    | 2005-02-01 to 2005-02-28
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2005-02-01 to 2005-02-28
    | overall
    | overall
    | N (%)
    | 1,260 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 756 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 504 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,260 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 756 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 504 (0.10%)  
    Records in observation
    | 2005-03-01 to 2005-03-31
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 27 (27.00%)  
    Person-days
    | 2005-03-01 to 2005-03-31
    | overall
    | overall
    | N (%)
    | 1,395 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 837 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,395 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 837 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    Records in observation
    | 2005-04-01 to 2005-04-30
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2005-04-01 to 2005-04-30
    | overall
    | overall
    | N (%)
    | 1,350 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 810 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,350 (0.26%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 810 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 540 (0.11%)  
    Records in observation
    | 2005-05-01 to 2005-05-31
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 27 (27.00%)  
    Person-days
    | 2005-05-01 to 2005-05-31
    | overall
    | overall
    | N (%)
    | 1,395 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 837 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,395 (0.27%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 837 (0.16%)  
    Records in observation
    | 2005-06-01 to 2005-06-30
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2005-06-01 to 2005-06-30
    | overall
    | overall
    | N (%)
    | 1,350 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 810 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,350 (0.26%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 540 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 810 (0.16%)  
    Records in observation
    | 2005-07-01 to 2005-07-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 19 (19.00%)  
    Person-days
    | 2005-07-01 to 2005-07-31
    | overall
    | overall
    | N (%)
    | 1,409 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 837 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 572 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,409 (0.28%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 837 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 572 (0.11%)  
    Records in observation
    | 2005-08-01 to 2005-08-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 19 (19.00%)  
    Person-days
    | 2005-08-01 to 2005-08-31
    | overall
    | overall
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 837 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 837 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 589 (0.12%)  
    Records in observation
    | 2005-09-01 to 2005-09-30
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 19 (19.00%)  
    Person-days
    | 2005-09-01 to 2005-09-30
    | overall
    | overall
    | N (%)
    | 1,366 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 810 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 556 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,366 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 810 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 556 (0.11%)  
    Records in observation
    | 2005-10-01 to 2005-10-31
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2005-10-01 to 2005-10-31
    | overall
    | overall
    | N (%)
    | 1,395 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 837 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,395 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 837 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    Records in observation
    | 2005-11-01 to 2005-11-30
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2005-11-01 to 2005-11-30
    | overall
    | overall
    | N (%)
    | 1,350 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 810 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,350 (0.26%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 810 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 540 (0.11%)  
    Records in observation
    | 2005-12-01 to 2005-12-31
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2005-12-01 to 2005-12-31
    | overall
    | overall
    | N (%)
    | 1,395 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 837 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,395 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 837 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    Records in observation
    | 2006-01-01 to 2006-01-31
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2006-01-01 to 2006-01-31
    | overall
    | overall
    | N (%)
    | 1,395 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 837 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,395 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 837 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    Records in observation
    | 2006-02-01 to 2006-02-28
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 27 (27.00%)  
    Person-days
    | 2006-02-01 to 2006-02-28
    | overall
    | overall
    | N (%)
    | 1,260 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 756 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 504 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,260 (0.25%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 504 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 756 (0.15%)  
    Records in observation
    | 2006-03-01 to 2006-03-31
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2006-03-01 to 2006-03-31
    | overall
    | overall
    | N (%)
    | 1,376 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 818 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,376 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 818 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    Records in observation
    | 2006-04-01 to 2006-04-30
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    Person-days
    | 2006-04-01 to 2006-04-30
    | overall
    | overall
    | N (%)
    | 1,320 (0.26%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 780 (0.15%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,320 (0.26%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 540 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 780 (0.15%)  
    Records in observation
    | 2006-05-01 to 2006-05-31
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2006-05-01 to 2006-05-31
    | overall
    | overall
    | N (%)
    | 1,364 (0.27%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 806 (0.16%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,364 (0.27%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 806 (0.16%)  
    Records in observation
    | 2006-06-01 to 2006-06-30
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2006-06-01 to 2006-06-30
    | overall
    | overall
    | N (%)
    | 1,320 (0.26%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 780 (0.15%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,320 (0.26%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 780 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 540 (0.11%)  
    Records in observation
    | 2006-07-01 to 2006-07-31
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2006-07-01 to 2006-07-31
    | overall
    | overall
    | N (%)
    | 1,364 (0.27%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 806 (0.16%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,364 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    Records in observation
    | 2006-08-01 to 2006-08-31
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2006-08-01 to 2006-08-31
    | overall
    | overall
    | N (%)
    | 1,364 (0.27%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 806 (0.16%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,364 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    Records in observation
    | 2006-09-01 to 2006-09-30
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2006-09-01 to 2006-09-30
    | overall
    | overall
    | N (%)
    | 1,320 (0.26%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 780 (0.15%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,320 (0.26%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 780 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 540 (0.11%)  
    Records in observation
    | 2006-10-01 to 2006-10-31
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    Person-days
    | 2006-10-01 to 2006-10-31
    | overall
    | overall
    | N (%)
    | 1,334 (0.26%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 776 (0.15%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,334 (0.26%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 776 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    Records in observation
    | 2006-11-01 to 2006-11-30
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    Person-days
    | 2006-11-01 to 2006-11-30
    | overall
    | overall
    | N (%)
    | 1,297 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 757 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,297 (0.25%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 540 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 757 (0.15%)  
    Records in observation
    | 2006-12-01 to 2006-12-31
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    Person-days
    | 2006-12-01 to 2006-12-31
    | overall
    | overall
    | N (%)
    | 1,357 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 799 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,357 (0.27%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 799 (0.16%)  
    Records in observation
    | 2007-01-01 to 2007-01-31
    | overall
    | overall
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    Person-days
    | 2007-01-01 to 2007-01-31
    | overall
    | overall
    | N (%)
    | 1,333 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,333 (0.26%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 558 (0.11%)  
    Records in observation
    | 2007-02-01 to 2007-02-28
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    Person-days
    | 2007-02-01 to 2007-02-28
    | overall
    | overall
    | N (%)
    | 1,227 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 700 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,227 (0.24%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 700 (0.14%)  
    Records in observation
    | 2007-03-01 to 2007-03-31
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 19 (19.00%)  
    Person-days
    | 2007-03-01 to 2007-03-31
    | overall
    | overall
    | N (%)
    | 1,364 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,364 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 589 (0.12%)  
    Records in observation
    | 2007-04-01 to 2007-04-30
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 2007-04-01 to 2007-04-30
    | overall
    | overall
    | N (%)
    | 1,324 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 574 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,324 (0.26%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 574 (0.11%)  
    Records in observation
    | 2007-05-01 to 2007-05-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 21 (21.00%)  
    Person-days
    | 2007-05-01 to 2007-05-31
    | overall
    | overall
    | N (%)
    | 1,412 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 637 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,412 (0.28%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 637 (0.12%)  
    Records in observation
    | 2007-06-01 to 2007-06-30
    | overall
    | overall
    | N (%)
    | 47 (47.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 47 (47.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 21 (21.00%)  
    Person-days
    | 2007-06-01 to 2007-06-30
    | overall
    | overall
    | N (%)
    | 1,388 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 758 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 630 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,388 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 758 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 630 (0.12%)  
    Records in observation
    | 2007-07-01 to 2007-07-31
    | overall
    | overall
    | N (%)
    | 47 (47.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 47 (47.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 21 (21.00%)  
    Person-days
    | 2007-07-01 to 2007-07-31
    | overall
    | overall
    | N (%)
    | 1,445 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 639 (0.13%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,445 (0.28%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 639 (0.13%)  
    Records in observation
    | 2007-08-01 to 2007-08-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 2007-08-01 to 2007-08-31
    | overall
    | overall
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 620 (0.12%)  
    Records in observation
    | 2007-09-01 to 2007-09-30
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 2007-09-01 to 2007-09-30
    | overall
    | overall
    | N (%)
    | 1,380 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 780 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 600 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,380 (0.27%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 600 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 780 (0.15%)  
    Records in observation
    | 2007-10-01 to 2007-10-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 2007-10-01 to 2007-10-31
    | overall
    | overall
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 620 (0.12%)  
    Records in observation
    | 2007-11-01 to 2007-11-30
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 2007-11-01 to 2007-11-30
    | overall
    | overall
    | N (%)
    | 1,380 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 780 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 600 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,380 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 780 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 600 (0.12%)  
    Records in observation
    | 2007-12-01 to 2007-12-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 2007-12-01 to 2007-12-31
    | overall
    | overall
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 620 (0.12%)  
    Records in observation
    | 2008-01-01 to 2008-01-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    Person-days
    | 2008-01-01 to 2008-01-31
    | overall
    | overall
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 806 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 806 (0.16%)  
    Records in observation
    | 2008-02-01 to 2008-02-29
    | overall
    | overall
    | N (%)
    | 47 (47.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 47 (47.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 26 (26.00%)  
    Person-days
    | 2008-02-01 to 2008-02-29
    | overall
    | overall
    | N (%)
    | 1,333 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 734 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 599 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,333 (0.26%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 599 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 734 (0.14%)  
    Records in observation
    | 2008-03-01 to 2008-03-31
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 21 (21.00%)  
    Person-days
    | 2008-03-01 to 2008-03-31
    | overall
    | overall
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 651 (0.13%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,426 (0.28%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 651 (0.13%)  
    Records in observation
    | 2008-04-01 to 2008-04-30
    | overall
    | overall
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 46 (46.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 21 (21.00%)  
    Person-days
    | 2008-04-01 to 2008-04-30
    | overall
    | overall
    | N (%)
    | 1,380 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 630 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,380 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 630 (0.12%)  
    Records in observation
    | 2008-05-01 to 2008-05-31
    | overall
    | overall
    | N (%)
    | 47 (47.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 47 (47.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    Person-days
    | 2008-05-01 to 2008-05-31
    | overall
    | overall
    | N (%)
    | 1,408 (0.28%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 633 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,408 (0.28%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 633 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 775 (0.15%)  
    Records in observation
    | 2008-06-01 to 2008-06-30
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 2008-06-01 to 2008-06-30
    | overall
    | overall
    | N (%)
    | 1,346 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 746 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 600 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,346 (0.26%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 746 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 600 (0.12%)  
    Records in observation
    | 2008-07-01 to 2008-07-31
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 2008-07-01 to 2008-07-31
    | overall
    | overall
    | N (%)
    | 1,364 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,364 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 620 (0.12%)  
    Records in observation
    | 2008-08-01 to 2008-08-31
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 2008-08-01 to 2008-08-31
    | overall
    | overall
    | N (%)
    | 1,364 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,364 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 620 (0.12%)  
    Records in observation
    | 2008-09-01 to 2008-09-30
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 2008-09-01 to 2008-09-30
    | overall
    | overall
    | N (%)
    | 1,320 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 600 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,320 (0.26%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 600 (0.12%)  
    Records in observation
    | 2008-10-01 to 2008-10-31
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 2008-10-01 to 2008-10-31
    | overall
    | overall
    | N (%)
    | 1,364 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,364 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 620 (0.12%)  
    Records in observation
    | 2008-11-01 to 2008-11-30
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 2008-11-01 to 2008-11-30
    | overall
    | overall
    | N (%)
    | 1,313 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 593 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,313 (0.26%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 593 (0.12%)  
    Records in observation
    | 2008-12-01 to 2008-12-31
    | overall
    | overall
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 2008-12-01 to 2008-12-31
    | overall
    | overall
    | N (%)
    | 1,333 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,333 (0.26%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    Records in observation
    | 2009-01-01 to 2009-01-31
    | overall
    | overall
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 19 (19.00%)  
    Person-days
    | 2009-01-01 to 2009-01-31
    | overall
    | overall
    | N (%)
    | 1,333 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,333 (0.26%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 589 (0.12%)  
    Records in observation
    | 2009-02-01 to 2009-02-28
    | overall
    | overall
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 2009-02-01 to 2009-02-28
    | overall
    | overall
    | N (%)
    | 1,204 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 672 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 532 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,204 (0.24%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 532 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 672 (0.13%)  
    Records in observation
    | 2009-03-01 to 2009-03-31
    | overall
    | overall
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 19 (19.00%)  
    Person-days
    | 2009-03-01 to 2009-03-31
    | overall
    | overall
    | N (%)
    | 1,333 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,333 (0.26%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 744 (0.15%)  
    Records in observation
    | 2009-04-01 to 2009-04-30
    | overall
    | overall
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 43 (43.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 2009-04-01 to 2009-04-30
    | overall
    | overall
    | N (%)
    | 1,290 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 570 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,290 (0.25%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 720 (0.14%)  
    Records in observation
    | 2009-05-01 to 2009-05-31
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    Person-days
    | 2009-05-01 to 2009-05-31
    | overall
    | overall
    | N (%)
    | 1,347 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 758 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,347 (0.26%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 758 (0.15%)  
    Records in observation
    | 2009-06-01 to 2009-06-30
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 2009-06-01 to 2009-06-30
    | overall
    | overall
    | N (%)
    | 1,316 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 596 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,316 (0.26%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 596 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 720 (0.14%)  
    Records in observation
    | 2009-07-01 to 2009-07-31
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 2009-07-01 to 2009-07-31
    | overall
    | overall
    | N (%)
    | 1,377 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 757 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,377 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 757 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 620 (0.12%)  
    Records in observation
    | 2009-08-01 to 2009-08-31
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 2009-08-01 to 2009-08-31
    | overall
    | overall
    | N (%)
    | 1,395 (0.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,395 (0.27%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 620 (0.12%)  
    Records in observation
    | 2009-09-01 to 2009-09-30
    | overall
    | overall
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 45 (45.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    Person-days
    | 2009-09-01 to 2009-09-30
    | overall
    | overall
    | N (%)
    | 1,324 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 574 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,324 (0.26%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 574 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 750 (0.15%)  
    Records in observation
    | 2009-10-01 to 2009-10-31
    | overall
    | overall
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 44 (44.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 19 (19.00%)  
    Person-days
    | 2009-10-01 to 2009-10-31
    | overall
    | overall
    | N (%)
    | 1,348 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 573 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,348 (0.26%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 573 (0.11%)  
    Records in observation
    | 2009-11-01 to 2009-11-30
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2009-11-01 to 2009-11-30
    | overall
    | overall
    | N (%)
    | 1,260 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,260 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 750 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 510 (0.10%)  
    Records in observation
    | 2009-12-01 to 2009-12-31
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    Person-days
    | 2009-12-01 to 2009-12-31
    | overall
    | overall
    | N (%)
    | 1,302 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,302 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    Records in observation
    | 2010-01-01 to 2010-01-31
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2010-01-01 to 2010-01-31
    | overall
    | overall
    | N (%)
    | 1,302 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,302 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 775 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    Records in observation
    | 2010-02-01 to 2010-02-28
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    Person-days
    | 2010-02-01 to 2010-02-28
    | overall
    | overall
    | N (%)
    | 1,176 (0.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 700 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 476 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,176 (0.23%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 476 (0.09%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 700 (0.14%)  
    Records in observation
    | 2010-03-01 to 2010-03-31
    | overall
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 42 (42.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2010-03-01 to 2010-03-31
    | overall
    | overall
    | N (%)
    | 1,291 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 764 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,291 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 764 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    Records in observation
    | 2010-04-01 to 2010-04-30
    | overall
    | overall
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2010-04-01 to 2010-04-30
    | overall
    | overall
    | N (%)
    | 1,230 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,230 (0.24%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 510 (0.10%)  
    Records in observation
    | 2010-05-01 to 2010-05-31
    | overall
    | overall
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 41 (41.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2010-05-01 to 2010-05-31
    | overall
    | overall
    | N (%)
    | 1,267 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 740 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,267 (0.25%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 740 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    Records in observation
    | 2010-06-01 to 2010-06-30
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    Person-days
    | 2010-06-01 to 2010-06-30
    | overall
    | overall
    | N (%)
    | 1,200 (0.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 690 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,200 (0.23%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 510 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 690 (0.14%)  
    Records in observation
    | 2010-07-01 to 2010-07-31
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2010-07-01 to 2010-07-31
    | overall
    | overall
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    Records in observation
    | 2010-08-01 to 2010-08-31
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    Person-days
    | 2010-08-01 to 2010-08-31
    | overall
    | overall
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 713 (0.14%)  
    Records in observation
    | 2010-09-01 to 2010-09-30
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    Person-days
    | 2010-09-01 to 2010-09-30
    | overall
    | overall
    | N (%)
    | 1,200 (0.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 690 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,200 (0.23%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 690 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 510 (0.10%)  
    Records in observation
    | 2010-10-01 to 2010-10-31
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    Person-days
    | 2010-10-01 to 2010-10-31
    | overall
    | overall
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,240 (0.24%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 713 (0.14%)  
    Records in observation
    | 2010-11-01 to 2010-11-30
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    Person-days
    | 2010-11-01 to 2010-11-30
    | overall
    | overall
    | N (%)
    | 1,189 (0.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 690 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 499 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,189 (0.23%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 499 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 690 (0.14%)  
    Records in observation
    | 2010-12-01 to 2010-12-31
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 2010-12-01 to 2010-12-31
    | overall
    | overall
    | N (%)
    | 1,237 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 741 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,237 (0.24%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 741 (0.15%)  
    Records in observation
    | 2011-01-01 to 2011-01-31
    | overall
    | overall
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 40 (40.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 24 (24.00%)  
    Person-days
    | 2011-01-01 to 2011-01-31
    | overall
    | overall
    | N (%)
    | 1,224 (0.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 728 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,224 (0.24%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 728 (0.14%)  
    Records in observation
    | 2011-02-01 to 2011-02-28
    | overall
    | overall
    | N (%)
    | 39 (39.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 39 (39.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 2011-02-01 to 2011-02-28
    | overall
    | overall
    | N (%)
    | 1,075 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 627 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 448 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,075 (0.21%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 627 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 448 (0.09%)  
    Records in observation
    | 2011-03-01 to 2011-03-31
    | overall
    | overall
    | N (%)
    | 38 (38.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 38 (38.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 2011-03-01 to 2011-03-31
    | overall
    | overall
    | N (%)
    | 1,178 (0.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,178 (0.23%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    Records in observation
    | 2011-04-01 to 2011-04-30
    | overall
    | overall
    | N (%)
    | 38 (38.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 38 (38.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 2011-04-01 to 2011-04-30
    | overall
    | overall
    | N (%)
    | 1,140 (0.22%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 660 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 480 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,140 (0.22%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 660 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 480 (0.09%)  
    Records in observation
    | 2011-05-01 to 2011-05-31
    | overall
    | overall
    | N (%)
    | 38 (38.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 38 (38.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 2011-05-01 to 2011-05-31
    | overall
    | overall
    | N (%)
    | 1,178 (0.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,178 (0.23%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 496 (0.10%)  
    Records in observation
    | 2011-06-01 to 2011-06-30
    | overall
    | overall
    | N (%)
    | 39 (39.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 39 (39.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2011-06-01 to 2011-06-30
    | overall
    | overall
    | N (%)
    | 1,164 (0.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 657 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 507 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,164 (0.23%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 657 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 507 (0.10%)  
    Records in observation
    | 2011-07-01 to 2011-07-31
    | overall
    | overall
    | N (%)
    | 38 (38.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 38 (38.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 21 (21.00%)  
    Person-days
    | 2011-07-01 to 2011-07-31
    | overall
    | overall
    | N (%)
    | 1,165 (0.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 639 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 526 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,165 (0.23%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 526 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 639 (0.13%)  
    Records in observation
    | 2011-08-01 to 2011-08-31
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 15 (15.00%)  
    Person-days
    | 2011-08-01 to 2011-08-31
    | overall
    | overall
    | N (%)
    | 1,085 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 465 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,085 (0.21%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 465 (0.09%)  
    Records in observation
    | 2011-09-01 to 2011-09-30
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 15 (15.00%)  
    Person-days
    | 2011-09-01 to 2011-09-30
    | overall
    | overall
    | N (%)
    | 1,050 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 600 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 450 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,050 (0.21%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 600 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 450 (0.09%)  
    Records in observation
    | 2011-10-01 to 2011-10-31
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 2011-10-01 to 2011-10-31
    | overall
    | overall
    | N (%)
    | 1,085 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 465 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,085 (0.21%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 465 (0.09%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 620 (0.12%)  
    Records in observation
    | 2011-11-01 to 2011-11-30
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 35 (35.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    Person-days
    | 2011-11-01 to 2011-11-30
    | overall
    | overall
    | N (%)
    | 1,048 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 600 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 448 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,048 (0.21%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 448 (0.09%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 600 (0.12%)  
    Records in observation
    | 2011-12-01 to 2011-12-31
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 2011-12-01 to 2011-12-31
    | overall
    | overall
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 434 (0.08%)  
    Records in observation
    | 2012-01-01 to 2012-01-31
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 2012-01-01 to 2012-01-31
    | overall
    | overall
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,054 (0.21%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 434 (0.08%)  
    Records in observation
    | 2012-02-01 to 2012-02-29
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 2012-02-01 to 2012-02-29
    | overall
    | overall
    | N (%)
    | 986 (0.19%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 580 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 406 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 986 (0.19%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 580 (0.11%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 406 (0.08%)  
    Records in observation
    | 2012-03-01 to 2012-03-31
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 34 (34.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 2012-03-01 to 2012-03-31
    | overall
    | overall
    | N (%)
    | 1,050 (0.21%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 616 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 434 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1,050 (0.21%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 616 (0.12%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 434 (0.08%)  
    Records in observation
    | 2012-04-01 to 2012-04-30
    | overall
    | overall
    | N (%)
    | 33 (33.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 33 (33.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 19 (19.00%)  
    Person-days
    | 2012-04-01 to 2012-04-30
    | overall
    | overall
    | N (%)
    | 969 (0.19%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 570 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 399 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 969 (0.19%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 399 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 570 (0.11%)  
    Records in observation
    | 2012-05-01 to 2012-05-31
    | overall
    | overall
    | N (%)
    | 31 (31.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 31 (31.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 2012-05-01 to 2012-05-31
    | overall
    | overall
    | N (%)
    | 958 (0.19%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 586 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 958 (0.19%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 586 (0.11%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 372 (0.07%)  
    Records in observation
    | 2012-06-01 to 2012-06-30
    | overall
    | overall
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 2012-06-01 to 2012-06-30
    | overall
    | overall
    | N (%)
    | 900 (0.18%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 900 (0.18%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 540 (0.11%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 360 (0.07%)  
    Records in observation
    | 2012-07-01 to 2012-07-31
    | overall
    | overall
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 18 (18.00%)  
    Person-days
    | 2012-07-01 to 2012-07-31
    | overall
    | overall
    | N (%)
    | 907 (0.18%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 535 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 907 (0.18%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 535 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 372 (0.07%)  
    Records in observation
    | 2012-08-01 to 2012-08-31
    | overall
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 2012-08-01 to 2012-08-31
    | overall
    | overall
    | N (%)
    | 899 (0.18%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 899 (0.18%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 372 (0.07%)  
    Records in observation
    | 2012-09-01 to 2012-09-30
    | overall
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 2012-09-01 to 2012-09-30
    | overall
    | overall
    | N (%)
    | 870 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 870 (0.17%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 510 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 360 (0.07%)  
    Records in observation
    | 2012-10-01 to 2012-10-31
    | overall
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 2012-10-01 to 2012-10-31
    | overall
    | overall
    | N (%)
    | 899 (0.18%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 899 (0.18%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 372 (0.07%)  
    Records in observation
    | 2012-11-01 to 2012-11-30
    | overall
    | overall
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 2012-11-01 to 2012-11-30
    | overall
    | overall
    | N (%)
    | 879 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 519 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 879 (0.17%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 519 (0.10%)  
    Records in observation
    | 2012-12-01 to 2012-12-31
    | overall
    | overall
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 2012-12-01 to 2012-12-31
    | overall
    | overall
    | N (%)
    | 930 (0.18%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 930 (0.18%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 372 (0.07%)  
    Records in observation
    | 2013-01-01 to 2013-01-31
    | overall
    | overall
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2013-01-01 to 2013-01-31
    | overall
    | overall
    | N (%)
    | 930 (0.18%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 899 (0.18%)  
    
    | 
    | 
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 2013-02-01 to 2013-02-28
    | overall
    | overall
    | N (%)
    | 30 (30.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2013-02-01 to 2013-02-28
    | overall
    | overall
    | N (%)
    | 824 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 320 (0.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 504 (0.10%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 28 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 796 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 320 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 476 (0.09%)  
    
    | 
    | 
    | >60
    | N (%)
    | 28 (0.01%)  
    Records in observation
    | 2013-03-01 to 2013-03-31
    | overall
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 28 (28.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2013-03-01 to 2013-03-31
    | overall
    | overall
    | N (%)
    | 899 (0.18%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 868 (0.17%)  
    
    | 
    | 
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 527 (0.10%)  
    Records in observation
    | 2013-04-01 to 2013-04-30
    | overall
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 2013-04-01 to 2013-04-30
    | overall
    | overall
    | N (%)
    | 870 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 840 (0.16%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 510 (0.10%)  
    
    | 
    | 
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    Records in observation
    | 2013-05-01 to 2013-05-31
    | overall
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2013-05-01 to 2013-05-31
    | overall
    | overall
    | N (%)
    | 877 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 319 (0.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 846 (0.17%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 319 (0.06%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 2013-06-01 to 2013-06-30
    | overall
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 17 (17.00%)  
    Person-days
    | 2013-06-01 to 2013-06-30
    | overall
    | overall
    | N (%)
    | 840 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 810 (0.16%)  
    
    | 
    | 
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 510 (0.10%)  
    Records in observation
    | 2013-07-01 to 2013-07-31
    | overall
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2013-07-01 to 2013-07-31
    | overall
    | overall
    | N (%)
    | 870 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 314 (0.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 556 (0.11%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 839 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 314 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 525 (0.10%)  
    
    | 
    | 
    | >60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 2013-08-01 to 2013-08-31
    | overall
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 16 (16.00%)  
    Person-days
    | 2013-08-01 to 2013-08-31
    | overall
    | overall
    | N (%)
    | 850 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 509 (0.10%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 819 (0.16%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 478 (0.09%)  
    Records in observation
    | 2013-09-01 to 2013-09-30
    | overall
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2013-09-01 to 2013-09-30
    | overall
    | overall
    | N (%)
    | 810 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 480 (0.09%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 780 (0.15%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 450 (0.09%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 30 (0.01%)  
    Records in observation
    | 2013-10-01 to 2013-10-31
    | overall
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 15 (15.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2013-10-01 to 2013-10-31
    | overall
    | overall
    | N (%)
    | 837 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 806 (0.16%)  
    
    | 
    | 
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 465 (0.09%)  
    
    | 
    | 
    | >60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 2013-11-01 to 2013-11-30
    | overall
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 15 (15.00%)  
    Person-days
    | 2013-11-01 to 2013-11-30
    | overall
    | overall
    | N (%)
    | 810 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 480 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 780 (0.15%)  
    
    | 
    | 
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 450 (0.09%)  
    Records in observation
    | 2013-12-01 to 2013-12-31
    | overall
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2013-12-01 to 2013-12-31
    | overall
    | overall
    | N (%)
    | 837 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 806 (0.16%)  
    
    | 
    | 
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 465 (0.09%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 2014-01-01 to 2014-01-31
    | overall
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 15 (15.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2014-01-01 to 2014-01-31
    | overall
    | overall
    | N (%)
    | 842 (0.16%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 346 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 811 (0.16%)  
    
    | 
    | 
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 465 (0.09%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 346 (0.07%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 2014-02-01 to 2014-02-28
    | overall
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 15 (15.00%)  
    Person-days
    | 2014-02-01 to 2014-02-28
    | overall
    | overall
    | N (%)
    | 784 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 336 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 448 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 756 (0.15%)  
    
    | 
    | 
    | >60
    | N (%)
    | 28 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 336 (0.07%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 28 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 420 (0.08%)  
    Records in observation
    | 2014-03-01 to 2014-03-31
    | overall
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 27 (27.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 15 (15.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2014-03-01 to 2014-03-31
    | overall
    | overall
    | N (%)
    | 856 (0.17%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 484 (0.09%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 825 (0.16%)  
    
    | 
    | 
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 453 (0.09%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 2014-04-01 to 2014-04-30
    | overall
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 26 (26.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 14 (14.00%)  
    Person-days
    | 2014-04-01 to 2014-04-30
    | overall
    | overall
    | N (%)
    | 790 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 430 (0.08%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 760 (0.15%)  
    
    | 
    | 
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 400 (0.08%)  
    Records in observation
    | 2014-05-01 to 2014-05-31
    | overall
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2014-05-01 to 2014-05-31
    | overall
    | overall
    | N (%)
    | 771 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 343 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 428 (0.08%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 740 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 343 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 397 (0.08%)  
    
    | 
    | 
    | >60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 2014-06-01 to 2014-06-30
    | overall
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2014-06-01 to 2014-06-30
    | overall
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 390 (0.08%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 690 (0.14%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 30 (0.01%)  
    Records in observation
    | 2014-07-01 to 2014-07-31
    | overall
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2014-07-01 to 2014-07-31
    | overall
    | overall
    | N (%)
    | 730 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 389 (0.08%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 17 (0.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 713 (0.14%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 17 (0.00%)  
    Records in observation
    | 2014-08-01 to 2014-08-31
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 2014-08-01 to 2014-08-31
    | overall
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 372 (0.07%)  
    Records in observation
    | 2014-09-01 to 2014-09-30
    | overall
    | overall
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 25 (25.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 2014-09-01 to 2014-09-30
    | overall
    | overall
    | N (%)
    | 735 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 375 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 735 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 375 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 360 (0.07%)  
    Records in observation
    | 2014-10-01 to 2014-10-31
    | overall
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 2014-10-01 to 2014-10-31
    | overall
    | overall
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 744 (0.15%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 372 (0.07%)  
    Records in observation
    | 2014-11-01 to 2014-11-30
    | overall
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 2014-11-01 to 2014-11-30
    | overall
    | overall
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 720 (0.14%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 360 (0.07%)  
    Records in observation
    | 2014-12-01 to 2014-12-31
    | overall
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 24 (24.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 2014-12-01 to 2014-12-31
    | overall
    | overall
    | N (%)
    | 707 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 358 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 349 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 707 (0.14%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 358 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 349 (0.07%)  
    Records in observation
    | 2015-01-01 to 2015-01-31
    | overall
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 2015-01-01 to 2015-01-31
    | overall
    | overall
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 2015-02-01 to 2015-02-28
    | overall
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 2015-02-01 to 2015-02-28
    | overall
    | overall
    | N (%)
    | 616 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 308 (0.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 308 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 616 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 308 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 308 (0.06%)  
    Records in observation
    | 2015-03-01 to 2015-03-31
    | overall
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 2015-03-01 to 2015-03-31
    | overall
    | overall
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 2015-04-01 to 2015-04-30
    | overall
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 2015-04-01 to 2015-04-30
    | overall
    | overall
    | N (%)
    | 660 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 660 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 330 (0.06%)  
    Records in observation
    | 2015-05-01 to 2015-05-31
    | overall
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 2015-05-01 to 2015-05-31
    | overall
    | overall
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 2015-06-01 to 2015-06-30
    | overall
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 2015-06-01 to 2015-06-30
    | overall
    | overall
    | N (%)
    | 686 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 356 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 686 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 356 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 330 (0.06%)  
    Records in observation
    | 2015-07-01 to 2015-07-31
    | overall
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 23 (23.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 12 (12.00%)  
    Person-days
    | 2015-07-01 to 2015-07-31
    | overall
    | overall
    | N (%)
    | 705 (0.14%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 364 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 705 (0.14%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 364 (0.07%)  
    Records in observation
    | 2015-08-01 to 2015-08-31
    | overall
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 2015-08-01 to 2015-08-31
    | overall
    | overall
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 682 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 2015-09-01 to 2015-09-30
    | overall
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 2015-09-01 to 2015-09-30
    | overall
    | overall
    | N (%)
    | 660 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 660 (0.13%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 330 (0.06%)  
    Records in observation
    | 2015-10-01 to 2015-10-31
    | overall
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 22 (22.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 2015-10-01 to 2015-10-31
    | overall
    | overall
    | N (%)
    | 662 (0.13%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 321 (0.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 662 (0.13%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 321 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 341 (0.07%)  
    Records in observation
    | 2015-11-01 to 2015-11-30
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 2015-11-01 to 2015-11-30
    | overall
    | overall
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 330 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 630 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 330 (0.06%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 300 (0.06%)  
    Records in observation
    | 2015-12-01 to 2015-12-31
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 21 (21.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    Person-days
    | 2015-12-01 to 2015-12-31
    | overall
    | overall
    | N (%)
    | 638 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 297 (0.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 638 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 297 (0.06%)  
    Records in observation
    | 2016-01-01 to 2016-01-31
    | overall
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 2016-01-01 to 2016-01-31
    | overall
    | overall
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 620 (0.12%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    Records in observation
    | 2016-02-01 to 2016-02-29
    | overall
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 20 (20.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 11 (11.00%)  
    Person-days
    | 2016-02-01 to 2016-02-29
    | overall
    | overall
    | N (%)
    | 578 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 261 (0.05%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 317 (0.06%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 578 (0.11%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 261 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 317 (0.06%)  
    Records in observation
    | 2016-03-01 to 2016-03-31
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 2016-03-01 to 2016-03-31
    | overall
    | overall
    | N (%)
    | 589 (0.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 310 (0.06%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | 
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    Records in observation
    | 2016-04-01 to 2016-04-30
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 9 (9.00%)  
    Person-days
    | 2016-04-01 to 2016-04-30
    | overall
    | overall
    | N (%)
    | 543 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 273 (0.05%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 513 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 243 (0.05%)  
    Records in observation
    | 2016-05-01 to 2016-05-31
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 2016-05-01 to 2016-05-31
    | overall
    | overall
    | N (%)
    | 549 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 44 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 505 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 226 (0.04%)  
    
    | 
    | 
    | >60
    | N (%)
    | 44 (0.01%)  
    Records in observation
    | 2016-06-01 to 2016-06-30
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 8 (8.00%)  
    Person-days
    | 2016-06-01 to 2016-06-30
    | overall
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 510 (0.10%)  
    
    | 
    | 
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 240 (0.05%)  
    Records in observation
    | 2016-07-01 to 2016-07-31
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 8 (8.00%)  
    Person-days
    | 2016-07-01 to 2016-07-31
    | overall
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 248 (0.05%)  
    Records in observation
    | 2016-08-01 to 2016-08-31
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 8 (8.00%)  
    Person-days
    | 2016-08-01 to 2016-08-31
    | overall
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | 
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 248 (0.05%)  
    Records in observation
    | 2016-09-01 to 2016-09-30
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 8 (8.00%)  
    Person-days
    | 2016-09-01 to 2016-09-30
    | overall
    | overall
    | N (%)
    | 540 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 510 (0.10%)  
    
    | 
    | 
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 240 (0.05%)  
    Records in observation
    | 2016-10-01 to 2016-10-31
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 8 (8.00%)  
    Person-days
    | 2016-10-01 to 2016-10-31
    | overall
    | overall
    | N (%)
    | 558 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 527 (0.10%)  
    
    | 
    | 
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 248 (0.05%)  
    Records in observation
    | 2016-11-01 to 2016-11-30
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 8 (8.00%)  
    Person-days
    | 2016-11-01 to 2016-11-30
    | overall
    | overall
    | N (%)
    | 560 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 290 (0.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 530 (0.10%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 290 (0.06%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 240 (0.05%)  
    Records in observation
    | 2016-12-01 to 2016-12-31
    | overall
    | overall
    | N (%)
    | 19 (19.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2016-12-01 to 2016-12-31
    | overall
    | overall
    | N (%)
    | 553 (0.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 274 (0.05%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 522 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 274 (0.05%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 2017-01-01 to 2017-01-31
    | overall
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 15 (15.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2017-01-01 to 2017-01-31
    | overall
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 217 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 465 (0.09%)  
    
    | 
    | 
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 217 (0.04%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 2017-02-01 to 2017-02-28
    | overall
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2017-02-01 to 2017-02-28
    | overall
    | overall
    | N (%)
    | 450 (0.09%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 252 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 198 (0.04%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 28 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 422 (0.08%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 198 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 224 (0.04%)  
    
    | 
    | 
    | >60
    | N (%)
    | 28 (0.01%)  
    Records in observation
    | 2017-03-01 to 2017-03-31
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 17 (17.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2017-03-01 to 2017-03-31
    | overall
    | overall
    | N (%)
    | 516 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 268 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 485 (0.09%)  
    
    | 
    | 
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 237 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 2017-04-01 to 2017-04-30
    | overall
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 8 (8.00%)  
    Person-days
    | 2017-04-01 to 2017-04-30
    | overall
    | overall
    | N (%)
    | 510 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 270 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 480 (0.09%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 240 (0.05%)  
    Records in observation
    | 2017-05-01 to 2017-05-31
    | overall
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2017-05-01 to 2017-05-31
    | overall
    | overall
    | N (%)
    | 527 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 279 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 2017-06-01 to 2017-06-30
    | overall
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 16 (16.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    Person-days
    | 2017-06-01 to 2017-06-30
    | overall
    | overall
    | N (%)
    | 488 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 458 (0.09%)  
    
    | 
    | 
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 218 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 240 (0.05%)  
    Records in observation
    | 2017-07-01 to 2017-07-31
    | overall
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 2017-07-01 to 2017-07-31
    | overall
    | overall
    | N (%)
    | 496 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 434 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 62 (0.01%)  
    Records in observation
    | 2017-08-01 to 2017-08-31
    | overall
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 2017-08-01 to 2017-08-31
    | overall
    | overall
    | N (%)
    | 486 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 238 (0.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 248 (0.05%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 424 (0.08%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 176 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 248 (0.05%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 62 (0.01%)  
    Records in observation
    | 2017-09-01 to 2017-09-30
    | overall
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 2017-09-01 to 2017-09-30
    | overall
    | overall
    | N (%)
    | 403 (0.08%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 223 (0.04%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 60 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 343 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 223 (0.04%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 60 (0.01%)  
    Records in observation
    | 2017-10-01 to 2017-10-31
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 2017-10-01 to 2017-10-31
    | overall
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | 
    | >60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 62 (0.01%)  
    Records in observation
    | 2017-11-01 to 2017-11-30
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 2017-11-01 to 2017-11-30
    | overall
    | overall
    | N (%)
    | 360 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 60 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 300 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 60 (0.01%)  
    Records in observation
    | 2017-12-01 to 2017-12-31
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 2017-12-01 to 2017-12-31
    | overall
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 2018-01-01 to 2018-01-31
    | overall
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 2018-01-01 to 2018-01-31
    | overall
    | overall
    | N (%)
    | 372 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 310 (0.06%)  
    
    | 
    | 
    | >60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 2018-02-01 to 2018-02-28
    | overall
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 2018-02-01 to 2018-02-28
    | overall
    | overall
    | N (%)
    | 333 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 165 (0.03%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 168 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 295 (0.06%)  
    
    | 
    | 
    | >60
    | N (%)
    | 38 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 168 (0.03%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 38 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 127 (0.02%)  
    Records in observation
    | 2018-03-01 to 2018-03-31
    | overall
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 2018-03-01 to 2018-03-31
    | overall
    | overall
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 341 (0.07%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 186 (0.04%)  
    Records in observation
    | 2018-04-01 to 2018-04-30
    | overall
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 11 (11.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 6 (6.00%)  
    Person-days
    | 2018-04-01 to 2018-04-30
    | overall
    | overall
    | N (%)
    | 325 (0.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 175 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 325 (0.06%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 175 (0.03%)  
    Records in observation
    | 2018-05-01 to 2018-05-31
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 10 (10.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 5 (5.00%)  
    Person-days
    | 2018-05-01 to 2018-05-31
    | overall
    | overall
    | N (%)
    | 277 (0.05%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 125 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 152 (0.03%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 277 (0.05%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 125 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 152 (0.03%)  
    Records in observation
    | 2018-06-01 to 2018-06-30
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 2018-06-01 to 2018-06-30
    | overall
    | overall
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 240 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 120 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 120 (0.02%)  
    Records in observation
    | 2018-07-01 to 2018-07-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 8 (8.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 2018-07-01 to 2018-07-31
    | overall
    | overall
    | N (%)
    | 247 (0.05%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 123 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 247 (0.05%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 123 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 124 (0.02%)  
    Records in observation
    | 2018-08-01 to 2018-08-31
    | overall
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 7 (7.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (4.00%)  
    Person-days
    | 2018-08-01 to 2018-08-31
    | overall
    | overall
    | N (%)
    | 188 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 105 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 83 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 188 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 83 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 105 (0.02%)  
    Records in observation
    | 2018-09-01 to 2018-09-30
    | overall
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 2018-09-01 to 2018-09-30
    | overall
    | overall
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 60 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 60 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 2018-10-01 to 2018-10-31
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 2018-10-01 to 2018-10-31
    | overall
    | overall
    | N (%)
    | 157 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 64 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 157 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 64 (0.01%)  
    Records in observation
    | 2018-11-01 to 2018-11-30
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 2018-11-01 to 2018-11-30
    | overall
    | overall
    | N (%)
    | 163 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 73 (0.01%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 90 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 163 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 73 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 2018-12-01 to 2018-12-31
    | overall
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 2018-12-01 to 2018-12-31
    | overall
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 2019-01-01 to 2019-01-31
    | overall
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 2019-01-01 to 2019-01-31
    | overall
    | overall
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 93 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 62 (0.01%)  
    Records in observation
    | 2019-02-01 to 2019-02-28
    | overall
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 2019-02-01 to 2019-02-28
    | overall
    | overall
    | N (%)
    | 140 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 56 (0.01%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 84 (0.02%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 140 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 84 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 56 (0.01%)  
    Records in observation
    | 2019-03-01 to 2019-03-31
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 2019-03-01 to 2019-03-31
    | overall
    | overall
    | N (%)
    | 161 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 99 (0.02%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 6 (0.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | >60
    | N (%)
    | 6 (0.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 93 (0.02%)  
    Records in observation
    | 2019-04-01 to 2019-04-30
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2019-04-01 to 2019-04-30
    | overall
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 60 (0.01%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 90 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 60 (0.01%)  
    
    | 
    | Male
    | >60
    | N (%)
    | 30 (0.01%)  
    Records in observation
    | 2019-05-01 to 2019-05-31
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2019-05-01 to 2019-05-31
    | overall
    | overall
    | N (%)
    | 186 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 124 (0.02%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 155 (0.03%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 93 (0.02%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Male
    | >60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 2019-06-01 to 2019-06-30
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 3 (3.00%)  
    Person-days
    | 2019-06-01 to 2019-06-30
    | overall
    | overall
    | N (%)
    | 180 (0.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 60 (0.01%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 120 (0.02%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 150 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 60 (0.01%)  
    
    | 
    | Male
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 90 (0.02%)  
    Records in observation
    | 2019-07-01 to 2019-07-31
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2019-07-01 to 2019-07-31
    | overall
    | overall
    | N (%)
    | 177 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 115 (0.02%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 146 (0.03%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 84 (0.02%)  
    
    | 
    | 
    | >60
    | N (%)
    | 31 (0.01%)  
    Records in observation
    | 2019-08-01 to 2019-08-31
    | overall
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Male
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 2 (2.00%)  
    Person-days
    | 2019-08-01 to 2019-08-31
    | overall
    | overall
    | N (%)
    | 142 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 80 (0.02%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 111 (0.02%)  
    
    | 
    | Male
    | >60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 62 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 49 (0.01%)  
    Records in observation
    | 2019-09-01 to 2019-09-30
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 3 (3.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Male
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2019-09-01 to 2019-09-30
    | overall
    | overall
    | N (%)
    | 94 (0.02%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 34 (0.01%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 60 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 64 (0.01%)  
    
    | 
    | 
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Male
    | >60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 34 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 30 (0.01%)  
    Records in observation
    | 2019-10-01 to 2019-10-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | >60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Male
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2019-10-01 to 2019-10-31
    | overall
    | overall
    | N (%)
    | 47 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (0.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 41 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 35 (0.01%)  
    
    | 
    | 
    | >60
    | N (%)
    | 12 (0.00%)  
    
    | 
    | Male
    | >60
    | N (%)
    | 10 (0.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 2 (0.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 31 (0.01%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 4 (0.00%)  
    Records in observation
    | 2019-11-01 to 2019-11-30
    | overall
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2019-11-01 to 2019-11-30
    | overall
    | overall
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 30 (0.01%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 30 (0.01%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 30 (0.01%)  
    Records in observation
    | 2019-12-01 to 2019-12-31
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2019-12-01 to 2019-12-31
    | overall
    | overall
    | N (%)
    | 6 (0.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (0.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 2 (0.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 6 (0.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 2 (0.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 4 (0.00%)  
    Records in observation
    | 2020-01-01 to 2020-01-31
    | overall
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 1 (1.00%)  
    Person-days
    | 2020-01-01 to 2020-01-31
    | overall
    | overall
    | N (%)
    | 1 (0.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1 (0.00%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 1 (0.00%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 1 (0.00%)  
    Records in observation
    | overall
    | overall
    | overall
    | N (%)
    | 100 (100.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 50 (50.00%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 50 (50.00%)  
    
    | 
    | overall
    | >60
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 98 (98.00%)  
    
    | 
    | Male
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | <=60
    | N (%)
    | 49 (49.00%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 49 (49.00%)  
    Person-days
    | overall
    | overall
    | overall
    | N (%)
    | 510,996 (100.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 294,854 (57.70%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 216,142 (42.30%)  
    
    | 
    | overall
    | <=60
    | N (%)
    | 510,795 (99.96%)  
    
    | 
    | 
    | >60
    | N (%)
    | 201 (0.04%)  
    
    | 
    | Male
    | <=60
    | N (%)
    | 215,943 (42.26%)  
    
    | 
    | Female
    | <=60
    | N (%)
    | 294,852 (57.70%)  
    
    | 
    | Male
    | >60
    | N (%)
    | 199 (0.04%)  
    
    | 
    | Female
    | >60
    | N (%)
    | 2 (0.00%)  
      
    
    PatientProfiles::[mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm)
    # }
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
