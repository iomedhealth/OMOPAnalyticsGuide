# Create a visual table from a summariseRecordCount() result. — tableRecordCount • OmopSketch

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

# Create a visual table from a summariseRecordCount() result.

Source: [`R/tableRecordCount.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/tableRecordCount.R)

`tableRecordCount.Rd`

Create a visual table from a summariseRecordCount() result.

## Usage
    
    
    tableRecordCount(result, type = "gt")

## Arguments

result
    

A summarised_result object.

type
    

Type of formatting output table. See `[visOmopResults::tableType()](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)` for allowed options. Default is `"gt"`.

## Value

A formatted table object with the summarised data.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockOmopSketch](mockOmopSketch.html)()
    
    summarisedResult <- [summariseRecordCount](summariseRecordCount.html)(
      cdm = cdm,
      omopTableName = [c](https://rdrr.io/r/base/c.html)("condition_occurrence", "drug_exposure"),
      interval = "years",
      ageGroup = [list](https://rdrr.io/r/base/list.html)("<=20" = [c](https://rdrr.io/r/base/c.html)(0, 20), ">20" = [c](https://rdrr.io/r/base/c.html)(21, Inf)),
      sex = TRUE
    )
    
    tableRecordCount(result = summarisedResult)
    #> Warning: `tableRecordCount()` was deprecated in OmopSketch 1.0.0.
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
          
    episode; condition_occurrence
          
    Records in observation
    | 1951-01-01 to 1951-12-31
    | overall
    | overall
    | N (%)
    | 1 (0.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1 (0.01%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 1 (0.01%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 1 (0.01%)  
    
    | 1952-01-01 to 1952-12-31
    | overall
    | overall
    | N (%)
    | 4 (0.05%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4 (0.05%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 4 (0.05%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 4 (0.05%)  
    
    | 1953-01-01 to 1953-12-31
    | overall
    | overall
    | N (%)
    | 9 (0.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 9 (0.11%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 9 (0.11%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 9 (0.11%)  
    
    | 1954-01-01 to 1954-12-31
    | overall
    | overall
    | N (%)
    | 12 (0.14%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 12 (0.14%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 12 (0.14%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 12 (0.14%)  
    
    | 1955-01-01 to 1955-12-31
    | overall
    | overall
    | N (%)
    | 15 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 15 (0.18%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 15 (0.18%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 15 (0.18%)  
    
    | 1956-01-01 to 1956-12-31
    | overall
    | overall
    | N (%)
    | 21 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (0.25%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 21 (0.25%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 21 (0.25%)  
    
    | 1957-01-01 to 1957-12-31
    | overall
    | overall
    | N (%)
    | 21 (0.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (0.25%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 21 (0.25%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 21 (0.25%)  
    
    | 1958-01-01 to 1958-12-31
    | overall
    | overall
    | N (%)
    | 27 (0.32%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 27 (0.32%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 27 (0.32%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 27 (0.32%)  
    
    | 1959-01-01 to 1959-12-31
    | overall
    | overall
    | N (%)
    | 33 (0.39%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 32 (0.38%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (0.01%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 33 (0.39%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 1 (0.01%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 32 (0.38%)  
    
    | 1960-01-01 to 1960-12-31
    | overall
    | overall
    | N (%)
    | 49 (0.58%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 40 (0.48%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9 (0.11%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 49 (0.58%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 40 (0.48%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 9 (0.11%)  
    
    | 1961-01-01 to 1961-12-31
    | overall
    | overall
    | N (%)
    | 55 (0.65%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 41 (0.49%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 14 (0.17%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 55 (0.65%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 14 (0.17%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 41 (0.49%)  
    
    | 1962-01-01 to 1962-12-31
    | overall
    | overall
    | N (%)
    | 58 (0.69%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 42 (0.50%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 16 (0.19%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 58 (0.69%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 42 (0.50%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 16 (0.19%)  
    
    | 1963-01-01 to 1963-12-31
    | overall
    | overall
    | N (%)
    | 68 (0.81%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 48 (0.57%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 20 (0.24%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 68 (0.81%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 48 (0.57%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 20 (0.24%)  
    
    | 1964-01-01 to 1964-12-31
    | overall
    | overall
    | N (%)
    | 82 (0.98%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 59 (0.70%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 23 (0.27%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 82 (0.98%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 23 (0.27%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 59 (0.70%)  
    
    | 1965-01-01 to 1965-12-31
    | overall
    | overall
    | N (%)
    | 105 (1.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 76 (0.90%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 29 (0.35%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 105 (1.25%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 29 (0.35%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 76 (0.90%)  
    
    | 1966-01-01 to 1966-12-31
    | overall
    | overall
    | N (%)
    | 119 (1.42%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 85 (1.01%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 34 (0.40%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 119 (1.42%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 34 (0.40%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 85 (1.01%)  
    
    | 1967-01-01 to 1967-12-31
    | overall
    | overall
    | N (%)
    | 110 (1.31%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 34 (0.40%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 76 (0.90%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 110 (1.31%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 34 (0.40%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 76 (0.90%)  
    
    | 1968-01-01 to 1968-12-31
    | overall
    | overall
    | N (%)
    | 113 (1.35%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 37 (0.44%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 76 (0.90%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 113 (1.35%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 37 (0.44%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 76 (0.90%)  
    
    | 1969-01-01 to 1969-12-31
    | overall
    | overall
    | N (%)
    | 118 (1.40%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 37 (0.44%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 81 (0.96%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 118 (1.40%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 37 (0.44%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 81 (0.96%)  
    
    | 1970-01-01 to 1970-12-31
    | overall
    | overall
    | N (%)
    | 120 (1.43%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 88 (1.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 32 (0.38%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 120 (1.43%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 32 (0.38%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 88 (1.05%)  
    
    | 1971-01-01 to 1971-12-31
    | overall
    | overall
    | N (%)
    | 128 (1.52%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 93 (1.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 35 (0.42%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 128 (1.52%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 35 (0.42%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 93 (1.11%)  
    
    | 1972-01-01 to 1972-12-31
    | overall
    | overall
    | N (%)
    | 129 (1.54%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 100 (1.19%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 29 (0.35%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 128 (1.52%)  
    
    | 
    | 
    | >20
    | N (%)
    | 1 (0.01%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 99 (1.18%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 29 (0.35%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 1 (0.01%)  
    
    | 1973-01-01 to 1973-12-31
    | overall
    | overall
    | N (%)
    | 131 (1.56%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 106 (1.26%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 25 (0.30%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 34 (0.40%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 97 (1.15%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 25 (0.30%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 34 (0.40%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 72 (0.86%)  
    
    | 1974-01-01 to 1974-12-31
    | overall
    | overall
    | N (%)
    | 150 (1.79%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 124 (1.48%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 26 (0.31%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 115 (1.37%)  
    
    | 
    | 
    | >20
    | N (%)
    | 35 (0.42%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 26 (0.31%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 89 (1.06%)  
    
    | 
    | 
    | >20
    | N (%)
    | 35 (0.42%)  
    
    | 1975-01-01 to 1975-12-31
    | overall
    | overall
    | N (%)
    | 168 (2.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 144 (1.71%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 24 (0.29%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 61 (0.73%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 107 (1.27%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 61 (0.73%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 83 (0.99%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 24 (0.29%)  
    
    | 1976-01-01 to 1976-12-31
    | overall
    | overall
    | N (%)
    | 184 (2.19%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 4 (0.05%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 180 (2.14%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 83 (0.99%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 101 (1.20%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 83 (0.99%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 4 (0.05%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 97 (1.15%)  
    
    | 1977-01-01 to 1977-12-31
    | overall
    | overall
    | N (%)
    | 236 (2.81%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 15 (0.18%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 221 (2.63%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 142 (1.69%)  
    
    | 
    | 
    | >20
    | N (%)
    | 94 (1.12%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 15 (0.18%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 94 (1.12%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 127 (1.51%)  
    
    | 1978-01-01 to 1978-12-31
    | overall
    | overall
    | N (%)
    | 287 (3.42%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 22 (0.26%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 265 (3.15%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 147 (1.75%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 140 (1.67%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 118 (1.40%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 22 (0.26%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 147 (1.75%)  
    
    | 1979-01-01 to 1979-12-31
    | overall
    | overall
    | N (%)
    | 334 (3.98%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 25 (0.30%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 309 (3.68%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 167 (1.99%)  
    
    | 
    | 
    | >20
    | N (%)
    | 167 (1.99%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 142 (1.69%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 25 (0.30%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 167 (1.99%)  
    
    | 1980-01-01 to 1980-12-31
    | overall
    | overall
    | N (%)
    | 384 (4.57%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 27 (0.32%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 357 (4.25%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 213 (2.54%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 171 (2.04%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 27 (0.32%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 213 (2.54%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 144 (1.71%)  
    
    | 1981-01-01 to 1981-12-31
    | overall
    | overall
    | N (%)
    | 531 (6.32%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 34 (0.40%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 497 (5.92%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 237 (2.82%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 294 (3.50%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 237 (2.82%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 34 (0.40%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 260 (3.10%)  
    
    | 1982-01-01 to 1982-12-31
    | overall
    | overall
    | N (%)
    | 460 (5.48%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 415 (4.94%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 45 (0.54%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 223 (2.65%)  
    
    | 
    | 
    | >20
    | N (%)
    | 237 (2.82%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 180 (2.14%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 43 (0.51%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 235 (2.80%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 2 (0.02%)  
    
    | 1983-01-01 to 1983-12-31
    | overall
    | overall
    | N (%)
    | 573 (6.82%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 519 (6.18%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 54 (0.64%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 277 (3.30%)  
    
    | 
    | 
    | >20
    | N (%)
    | 296 (3.52%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 256 (3.05%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 14 (0.17%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 263 (3.13%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 40 (0.48%)  
    
    | 1984-01-01 to 1984-12-31
    | overall
    | overall
    | N (%)
    | 503 (5.99%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 442 (5.26%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 61 (0.73%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 323 (3.85%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 180 (2.14%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 159 (1.89%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 21 (0.25%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 283 (3.37%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 40 (0.48%)  
    
    | 1985-01-01 to 1985-12-31
    | overall
    | overall
    | N (%)
    | 473 (5.63%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 406 (4.83%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 67 (0.80%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 115 (1.37%)  
    
    | 
    | 
    | >20
    | N (%)
    | 358 (4.26%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 23 (0.27%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 314 (3.74%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 44 (0.52%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 92 (1.10%)  
    
    | 1986-01-01 to 1986-12-31
    | overall
    | overall
    | N (%)
    | 482 (5.74%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 80 (0.95%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 402 (4.79%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 107 (1.27%)  
    
    | 
    | 
    | >20
    | N (%)
    | 375 (4.46%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 31 (0.37%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 326 (3.88%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 49 (0.58%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 76 (0.90%)  
    
    | 1987-01-01 to 1987-12-31
    | overall
    | overall
    | N (%)
    | 500 (5.95%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 94 (1.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 406 (4.83%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 121 (1.44%)  
    
    | 
    | 
    | >20
    | N (%)
    | 379 (4.51%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 333 (3.96%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 46 (0.55%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 48 (0.57%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 73 (0.87%)  
    
    | 1988-01-01 to 1988-12-31
    | overall
    | overall
    | N (%)
    | 490 (5.83%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 107 (1.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 383 (4.56%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 382 (4.55%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 108 (1.29%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 58 (0.69%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 333 (3.96%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 49 (0.58%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 50 (0.60%)  
    
    | 1989-01-01 to 1989-12-31
    | overall
    | overall
    | N (%)
    | 497 (5.92%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 381 (4.54%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 116 (1.38%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 394 (4.69%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 103 (1.23%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 340 (4.05%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 54 (0.64%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 62 (0.74%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 41 (0.49%)  
    
    | 1990-01-01 to 1990-12-31
    | overall
    | overall
    | N (%)
    | 525 (6.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 389 (4.63%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 136 (1.62%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 84 (1.00%)  
    
    | 
    | 
    | >20
    | N (%)
    | 441 (5.25%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 92 (1.10%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 40 (0.48%)  
    
    | 
    | 
    | >20
    | N (%)
    | 349 (4.15%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 44 (0.52%)  
    
    | 1991-01-01 to 1991-12-31
    | overall
    | overall
    | N (%)
    | 589 (7.01%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 440 (5.24%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 149 (1.77%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 139 (1.65%)  
    
    | 
    | 
    | >20
    | N (%)
    | 450 (5.36%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 51 (0.61%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 88 (1.05%)  
    
    | 
    | 
    | >20
    | N (%)
    | 352 (4.19%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 98 (1.17%)  
    
    | 1992-01-01 to 1992-12-31
    | overall
    | overall
    | N (%)
    | 516 (6.14%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 354 (4.21%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 162 (1.93%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 75 (0.89%)  
    
    | 
    | 
    | >20
    | N (%)
    | 441 (5.25%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 101 (1.20%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 340 (4.05%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 61 (0.73%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 14 (0.17%)  
    
    | 1993-01-01 to 1993-12-31
    | overall
    | overall
    | N (%)
    | 506 (6.02%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 166 (1.98%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 340 (4.05%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 489 (5.82%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 17 (0.20%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 17 (0.20%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 340 (4.05%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 149 (1.77%)  
    
    | 1994-01-01 to 1994-12-31
    | overall
    | overall
    | N (%)
    | 496 (5.90%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 343 (4.08%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 153 (1.82%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 480 (5.71%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 16 (0.19%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 137 (1.63%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 343 (4.08%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 16 (0.19%)  
    
    | 1995-01-01 to 1995-12-31
    | overall
    | overall
    | N (%)
    | 458 (5.45%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 321 (3.82%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 137 (1.63%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 437 (5.20%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 21 (0.25%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 1 (0.01%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 117 (1.39%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 320 (3.81%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 20 (0.24%)  
    
    | 1996-01-01 to 1996-12-31
    | overall
    | overall
    | N (%)
    | 500 (5.95%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 141 (1.68%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 359 (4.27%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 58 (0.69%)  
    
    | 
    | 
    | >20
    | N (%)
    | 442 (5.26%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 24 (0.29%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 34 (0.40%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 117 (1.39%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 325 (3.87%)  
    
    | 1997-01-01 to 1997-12-31
    | overall
    | overall
    | N (%)
    | 581 (6.92%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 357 (4.25%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 224 (2.67%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 144 (1.71%)  
    
    | 
    | 
    | >20
    | N (%)
    | 437 (5.20%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 89 (1.06%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 302 (3.60%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 55 (0.65%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 135 (1.61%)  
    
    | 1998-01-01 to 1998-12-31
    | overall
    | overall
    | N (%)
    | 644 (7.67%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 385 (4.58%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 259 (3.08%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 209 (2.49%)  
    
    | 
    | 
    | >20
    | N (%)
    | 435 (5.18%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 143 (1.70%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 292 (3.48%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 93 (1.11%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 116 (1.38%)  
    
    | 1999-01-01 to 1999-12-31
    | overall
    | overall
    | N (%)
    | 671 (7.99%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 215 (2.56%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 456 (5.43%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 462 (5.50%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 209 (2.49%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 52 (0.62%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 157 (1.87%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 163 (1.94%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 299 (3.56%)  
    
    | 2000-01-01 to 2000-12-31
    | overall
    | overall
    | N (%)
    | 639 (7.61%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 257 (3.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 382 (4.55%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 491 (5.85%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 148 (1.76%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 57 (0.68%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 291 (3.46%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 200 (2.38%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 91 (1.08%)  
    
    | 2001-01-01 to 2001-12-31
    | overall
    | overall
    | N (%)
    | 664 (7.90%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 256 (3.05%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 408 (4.86%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 206 (2.45%)  
    
    | 
    | 
    | >20
    | N (%)
    | 458 (5.45%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 168 (2.00%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 118 (1.40%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 88 (1.05%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 290 (3.45%)  
    
    | 2002-01-01 to 2002-12-31
    | overall
    | overall
    | N (%)
    | 717 (8.54%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 308 (3.67%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 409 (4.87%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 186 (2.21%)  
    
    | 
    | 
    | >20
    | N (%)
    | 531 (6.32%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 110 (1.31%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 76 (0.90%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 299 (3.56%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 232 (2.76%)  
    
    | 2003-01-01 to 2003-12-31
    | overall
    | overall
    | N (%)
    | 766 (9.12%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 347 (4.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 419 (4.99%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 548 (6.52%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 218 (2.60%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 96 (1.14%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 122 (1.45%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 251 (2.99%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 297 (3.54%)  
    
    | 2004-01-01 to 2004-12-31
    | overall
    | overall
    | N (%)
    | 855 (10.18%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 414 (4.93%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 441 (5.25%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 636 (7.57%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 219 (2.61%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 125 (1.49%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 94 (1.12%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 289 (3.44%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 347 (4.13%)  
    
    | 2005-01-01 to 2005-12-31
    | overall
    | overall
    | N (%)
    | 948 (11.29%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 481 (5.73%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 467 (5.56%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 219 (2.61%)  
    
    | 
    | 
    | >20
    | N (%)
    | 729 (8.68%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 324 (3.86%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 62 (0.74%)  
    
    | 
    | 
    | >20
    | N (%)
    | 405 (4.82%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 157 (1.87%)  
    
    | 2006-01-01 to 2006-12-31
    | overall
    | overall
    | N (%)
    | 1,155 (13.75%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 581 (6.92%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 574 (6.83%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 310 (3.69%)  
    
    | 
    | 
    | >20
    | N (%)
    | 845 (10.06%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 358 (4.26%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 487 (5.80%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 223 (2.65%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 87 (1.04%)  
    
    | 2007-01-01 to 2007-12-31
    | overall
    | overall
    | N (%)
    | 1,294 (15.40%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 615 (7.32%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 679 (8.08%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 429 (5.11%)  
    
    | 
    | 
    | >20
    | N (%)
    | 865 (10.30%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 475 (5.65%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 289 (3.44%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 140 (1.67%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 390 (4.64%)  
    
    | 2008-01-01 to 2008-12-31
    | overall
    | overall
    | N (%)
    | 1,283 (15.27%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 710 (8.45%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 573 (6.82%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 848 (10.10%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 435 (5.18%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 406 (4.83%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 268 (3.19%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 167 (1.99%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 442 (5.26%)  
    
    | 2009-01-01 to 2009-12-31
    | overall
    | overall
    | N (%)
    | 1,171 (13.94%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 671 (7.99%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 500 (5.95%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 306 (3.64%)  
    
    | 
    | 
    | >20
    | N (%)
    | 865 (10.30%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 393 (4.68%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 472 (5.62%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 107 (1.27%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 199 (2.37%)  
    
    | 2010-01-01 to 2010-12-31
    | overall
    | overall
    | N (%)
    | 1,200 (14.29%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 551 (6.56%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 649 (7.73%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 286 (3.40%)  
    
    | 
    | 
    | >20
    | N (%)
    | 914 (10.88%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 448 (5.33%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 183 (2.18%)  
    
    | 
    | 
    | >20
    | N (%)
    | 466 (5.55%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 103 (1.23%)  
    
    | 2011-01-01 to 2011-12-31
    | overall
    | overall
    | N (%)
    | 1,247 (14.85%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 682 (8.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 565 (6.73%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 944 (11.24%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 303 (3.61%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 480 (5.71%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 101 (1.20%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 202 (2.40%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 464 (5.52%)  
    
    | 2012-01-01 to 2012-12-31
    | overall
    | overall
    | N (%)
    | 1,291 (15.37%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 767 (9.13%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 524 (6.24%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,013 (12.06%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 278 (3.31%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 225 (2.68%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 53 (0.63%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 542 (6.45%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 471 (5.61%)  
    
    | 2013-01-01 to 2013-12-31
    | overall
    | overall
    | N (%)
    | 1,226 (14.60%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 608 (7.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 618 (7.36%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 218 (2.60%)  
    
    | 
    | 
    | >20
    | N (%)
    | 1,008 (12.00%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 459 (5.46%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 549 (6.54%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 149 (1.77%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 69 (0.82%)  
    
    | 2014-01-01 to 2014-12-31
    | overall
    | overall
    | N (%)
    | 1,084 (12.90%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 511 (6.08%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 573 (6.82%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 857 (10.20%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 227 (2.70%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 400 (4.76%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 116 (1.38%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 111 (1.32%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 457 (5.44%)  
    
    | 2015-01-01 to 2015-12-31
    | overall
    | overall
    | N (%)
    | 933 (11.11%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 439 (5.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 494 (5.88%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 706 (8.40%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 227 (2.70%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 78 (0.93%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 345 (4.11%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 361 (4.30%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 149 (1.77%)  
    
    | 2016-01-01 to 2016-12-31
    | overall
    | overall
    | N (%)
    | 857 (10.20%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 390 (4.64%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 467 (5.56%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 215 (2.56%)  
    
    | 
    | 
    | >20
    | N (%)
    | 642 (7.64%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 330 (3.93%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 155 (1.85%)  
    
    | 
    | 
    | >20
    | N (%)
    | 312 (3.71%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 60 (0.71%)  
    
    | 2017-01-01 to 2017-12-31
    | overall
    | overall
    | N (%)
    | 826 (9.83%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 420 (5.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 406 (4.83%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 198 (2.36%)  
    
    | 
    | 
    | >20
    | N (%)
    | 628 (7.48%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 124 (1.48%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 74 (0.88%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 282 (3.36%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 346 (4.12%)  
    
    | 2018-01-01 to 2018-12-31
    | overall
    | overall
    | N (%)
    | 777 (9.25%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 476 (5.67%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 301 (3.58%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 656 (7.81%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 121 (1.44%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 60 (0.71%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 61 (0.73%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 416 (4.95%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 240 (2.86%)  
    
    | 2019-01-01 to 2019-12-31
    | overall
    | overall
    | N (%)
    | 718 (8.55%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 366 (4.36%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 352 (4.19%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 718 (8.55%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 366 (4.36%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 352 (4.19%)  
    
    | overall
    | overall
    | overall
    | N (%)
    | 8,400 (100.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 4,568 (54.38%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 3,832 (45.62%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 5,338 (63.55%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 3,062 (36.45%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 1,749 (20.82%)  
    
    | 
    | 
    | >20
    | N (%)
    | 2,819 (33.56%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 2,519 (29.99%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 1,313 (15.63%)  
    episode; drug_exposure
          
    Records in observation
    | 1951-01-01 to 1951-12-31
    | overall
    | overall
    | N (%)
    | 6 (0.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 6 (0.03%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 6 (0.03%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 6 (0.03%)  
    
    | 1952-01-01 to 1952-12-31
    | overall
    | overall
    | N (%)
    | 14 (0.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 14 (0.06%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 14 (0.06%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 14 (0.06%)  
    
    | 1953-01-01 to 1953-12-31
    | overall
    | overall
    | N (%)
    | 21 (0.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 21 (0.10%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 21 (0.10%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 21 (0.10%)  
    
    | 1954-01-01 to 1954-12-31
    | overall
    | overall
    | N (%)
    | 30 (0.14%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 30 (0.14%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 30 (0.14%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 30 (0.14%)  
    
    | 1955-01-01 to 1955-12-31
    | overall
    | overall
    | N (%)
    | 48 (0.22%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 48 (0.22%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 48 (0.22%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 48 (0.22%)  
    
    | 1956-01-01 to 1956-12-31
    | overall
    | overall
    | N (%)
    | 62 (0.29%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 62 (0.29%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 62 (0.29%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 62 (0.29%)  
    
    | 1957-01-01 to 1957-12-31
    | overall
    | overall
    | N (%)
    | 80 (0.37%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 80 (0.37%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 80 (0.37%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 80 (0.37%)  
    
    | 1958-01-01 to 1958-12-31
    | overall
    | overall
    | N (%)
    | 97 (0.45%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 97 (0.45%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 97 (0.45%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 97 (0.45%)  
    
    | 1959-01-01 to 1959-12-31
    | overall
    | overall
    | N (%)
    | 118 (0.55%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 117 (0.54%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1 (0.00%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 118 (0.55%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 1 (0.00%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 117 (0.54%)  
    
    | 1960-01-01 to 1960-12-31
    | overall
    | overall
    | N (%)
    | 135 (0.62%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 123 (0.57%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (0.06%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 135 (0.62%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 123 (0.57%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 12 (0.06%)  
    
    | 1961-01-01 to 1961-12-31
    | overall
    | overall
    | N (%)
    | 146 (0.68%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 127 (0.59%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 19 (0.09%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 146 (0.68%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 127 (0.59%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 19 (0.09%)  
    
    | 1962-01-01 to 1962-12-31
    | overall
    | overall
    | N (%)
    | 158 (0.73%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 130 (0.60%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 28 (0.13%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 158 (0.73%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 130 (0.60%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 28 (0.13%)  
    
    | 1963-01-01 to 1963-12-31
    | overall
    | overall
    | N (%)
    | 170 (0.79%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 132 (0.61%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 38 (0.18%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 170 (0.79%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 132 (0.61%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 38 (0.18%)  
    
    | 1964-01-01 to 1964-12-31
    | overall
    | overall
    | N (%)
    | 204 (0.94%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 151 (0.70%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 53 (0.25%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 204 (0.94%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 53 (0.25%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 151 (0.70%)  
    
    | 1965-01-01 to 1965-12-31
    | overall
    | overall
    | N (%)
    | 214 (0.99%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.69%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 64 (0.30%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 214 (0.99%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 64 (0.30%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 150 (0.69%)  
    
    | 1966-01-01 to 1966-12-31
    | overall
    | overall
    | N (%)
    | 225 (1.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 150 (0.69%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 75 (0.35%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 225 (1.04%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 75 (0.35%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 150 (0.69%)  
    
    | 1967-01-01 to 1967-12-31
    | overall
    | overall
    | N (%)
    | 227 (1.05%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 144 (0.67%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 83 (0.38%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 227 (1.05%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 144 (0.67%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 83 (0.38%)  
    
    | 1968-01-01 to 1968-12-31
    | overall
    | overall
    | N (%)
    | 222 (1.03%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 137 (0.63%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 85 (0.39%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 222 (1.03%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 85 (0.39%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 137 (0.63%)  
    
    | 1969-01-01 to 1969-12-31
    | overall
    | overall
    | N (%)
    | 241 (1.12%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 154 (0.71%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 87 (0.40%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 241 (1.12%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 87 (0.40%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 154 (0.71%)  
    
    | 1970-01-01 to 1970-12-31
    | overall
    | overall
    | N (%)
    | 259 (1.20%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 170 (0.79%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 89 (0.41%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 259 (1.20%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 89 (0.41%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 170 (0.79%)  
    
    | 1971-01-01 to 1971-12-31
    | overall
    | overall
    | N (%)
    | 275 (1.27%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 191 (0.88%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 84 (0.39%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 275 (1.27%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 84 (0.39%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 191 (0.88%)  
    
    | 1972-01-01 to 1972-12-31
    | overall
    | overall
    | N (%)
    | 292 (1.35%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 214 (0.99%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 78 (0.36%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 6 (0.03%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 286 (1.32%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 78 (0.36%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 208 (0.96%)  
    
    | 
    | 
    | >20
    | N (%)
    | 6 (0.03%)  
    
    | 1973-01-01 to 1973-12-31
    | overall
    | overall
    | N (%)
    | 315 (1.46%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 236 (1.09%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 79 (0.37%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 65 (0.30%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 250 (1.16%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 65 (0.30%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 79 (0.37%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 171 (0.79%)  
    
    | 1974-01-01 to 1974-12-31
    | overall
    | overall
    | N (%)
    | 335 (1.55%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 274 (1.27%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 61 (0.28%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 79 (0.37%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 256 (1.19%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 195 (0.90%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 61 (0.28%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 79 (0.37%)  
    
    | 1975-01-01 to 1975-12-31
    | overall
    | overall
    | N (%)
    | 358 (1.66%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 319 (1.48%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 39 (0.18%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 218 (1.01%)  
    
    | 
    | 
    | >20
    | N (%)
    | 140 (0.65%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 140 (0.65%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 179 (0.83%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 39 (0.18%)  
    
    | 1976-01-01 to 1976-12-31
    | overall
    | overall
    | N (%)
    | 398 (1.84%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 390 (1.81%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 8 (0.04%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 187 (0.87%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 211 (0.98%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 187 (0.87%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 8 (0.04%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 203 (0.94%)  
    
    | 1977-01-01 to 1977-12-31
    | overall
    | overall
    | N (%)
    | 511 (2.37%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 499 (2.31%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 12 (0.06%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 279 (1.29%)  
    
    | 
    | 
    | >20
    | N (%)
    | 232 (1.07%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 232 (1.07%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 12 (0.06%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 267 (1.24%)  
    
    | 1978-01-01 to 1978-12-31
    | overall
    | overall
    | N (%)
    | 646 (2.99%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 624 (2.89%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 22 (0.10%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 398 (1.84%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 248 (1.15%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 226 (1.05%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 22 (0.10%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 398 (1.84%)  
    
    | 1979-01-01 to 1979-12-31
    | overall
    | overall
    | N (%)
    | 761 (3.52%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 728 (3.37%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 33 (0.15%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 452 (2.09%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 309 (1.43%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 276 (1.28%)  
    
    | 
    | 
    | >20
    | N (%)
    | 452 (2.09%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 33 (0.15%)  
    
    | 1980-01-01 to 1980-12-31
    | overall
    | overall
    | N (%)
    | 878 (4.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 844 (3.91%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 34 (0.16%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 546 (2.53%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 332 (1.54%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 546 (2.53%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 34 (0.16%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 298 (1.38%)  
    
    | 1981-01-01 to 1981-12-31
    | overall
    | overall
    | N (%)
    | 1,266 (5.86%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,208 (5.59%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 58 (0.27%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 633 (2.93%)  
    
    | 
    | 
    | >20
    | N (%)
    | 633 (2.93%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 58 (0.27%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 633 (2.93%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 575 (2.66%)  
    
    | 1982-01-01 to 1982-12-31
    | overall
    | overall
    | N (%)
    | 1,115 (5.16%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,030 (4.77%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 85 (0.39%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 507 (2.35%)  
    
    | 
    | 
    | >20
    | N (%)
    | 608 (2.81%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 427 (1.98%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 80 (0.37%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 603 (2.79%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 5 (0.02%)  
    
    | 1983-01-01 to 1983-12-31
    | overall
    | overall
    | N (%)
    | 1,411 (6.53%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,302 (6.03%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 109 (0.50%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 694 (3.21%)  
    
    | 
    | 
    | >20
    | N (%)
    | 717 (3.32%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 660 (3.06%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 52 (0.24%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 642 (2.97%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 57 (0.26%)  
    
    | 1984-01-01 to 1984-12-31
    | overall
    | overall
    | N (%)
    | 1,296 (6.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,165 (5.39%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 131 (0.61%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 486 (2.25%)  
    
    | 
    | 
    | >20
    | N (%)
    | 810 (3.75%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 66 (0.31%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 420 (1.94%)  
    
    | 
    | 
    | >20
    | N (%)
    | 745 (3.45%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 65 (0.30%)  
    
    | 1985-01-01 to 1985-12-31
    | overall
    | overall
    | N (%)
    | 1,220 (5.65%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,065 (4.93%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 155 (0.72%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 893 (4.13%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 327 (1.51%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 822 (3.81%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 84 (0.39%)  
    
    | 
    | 
    | >20
    | N (%)
    | 71 (0.33%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 243 (1.12%)  
    
    | 1986-01-01 to 1986-12-31
    | overall
    | overall
    | N (%)
    | 1,237 (5.73%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,049 (4.86%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 188 (0.87%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 289 (1.34%)  
    
    | 
    | 
    | >20
    | N (%)
    | 948 (4.39%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 869 (4.02%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 109 (0.50%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 180 (0.83%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 79 (0.37%)  
    
    | 1987-01-01 to 1987-12-31
    | overall
    | overall
    | N (%)
    | 1,317 (6.10%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 238 (1.10%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,079 (5.00%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,003 (4.64%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 314 (1.45%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 918 (4.25%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 85 (0.39%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 153 (0.71%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 161 (0.75%)  
    
    | 1988-01-01 to 1988-12-31
    | overall
    | overall
    | N (%)
    | 1,310 (6.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 266 (1.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,044 (4.83%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,015 (4.70%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 295 (1.37%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 929 (4.30%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 180 (0.83%)  
    
    | 
    | 
    | >20
    | N (%)
    | 86 (0.40%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 115 (0.53%)  
    
    | 1989-01-01 to 1989-12-31
    | overall
    | overall
    | N (%)
    | 1,350 (6.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,047 (4.85%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 303 (1.40%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,070 (4.95%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 280 (1.30%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 964 (4.46%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 106 (0.49%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 83 (0.38%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 197 (0.91%)  
    
    | 1990-01-01 to 1990-12-31
    | overall
    | overall
    | N (%)
    | 1,416 (6.56%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,069 (4.95%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 347 (1.61%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 218 (1.01%)  
    
    | 
    | 
    | >20
    | N (%)
    | 1,198 (5.55%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 200 (0.93%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 71 (0.33%)  
    
    | 
    | 
    | >20
    | N (%)
    | 998 (4.62%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 147 (0.68%)  
    
    | 1991-01-01 to 1991-12-31
    | overall
    | overall
    | N (%)
    | 1,673 (7.75%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,277 (5.91%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 396 (1.83%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 444 (2.06%)  
    
    | 
    | 
    | >20
    | N (%)
    | 1,229 (5.69%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 279 (1.29%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 165 (0.76%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 998 (4.62%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 231 (1.07%)  
    
    | 1992-01-01 to 1992-12-31
    | overall
    | overall
    | N (%)
    | 1,475 (6.83%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,042 (4.82%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 433 (2.00%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,267 (5.87%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 208 (0.96%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 1,006 (4.66%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 261 (1.21%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 172 (0.80%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 36 (0.17%)  
    
    | 1993-01-01 to 1993-12-31
    | overall
    | overall
    | N (%)
    | 1,437 (6.65%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 998 (4.62%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 439 (2.03%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 54 (0.25%)  
    
    | 
    | 
    | >20
    | N (%)
    | 1,383 (6.40%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 54 (0.25%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 998 (4.62%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 385 (1.78%)  
    
    | 1994-01-01 to 1994-12-31
    | overall
    | overall
    | N (%)
    | 1,385 (6.41%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 984 (4.56%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 401 (1.86%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,325 (6.13%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 60 (0.28%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 341 (1.58%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 984 (4.56%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 60 (0.28%)  
    
    | 1995-01-01 to 1995-12-31
    | overall
    | overall
    | N (%)
    | 1,319 (6.11%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 944 (4.37%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 375 (1.74%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,238 (5.73%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 81 (0.38%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 300 (1.39%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 6 (0.03%)  
    
    | 
    | 
    | >20
    | N (%)
    | 938 (4.34%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 75 (0.35%)  
    
    | 1996-01-01 to 1996-12-31
    | overall
    | overall
    | N (%)
    | 1,401 (6.49%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,019 (4.72%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 382 (1.77%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,249 (5.78%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 152 (0.70%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 89 (0.41%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 63 (0.29%)  
    
    | 
    | 
    | >20
    | N (%)
    | 956 (4.43%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 293 (1.36%)  
    
    | 1997-01-01 to 1997-12-31
    | overall
    | overall
    | N (%)
    | 1,624 (7.52%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,054 (4.88%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 570 (2.64%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,217 (5.63%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 407 (1.88%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 911 (4.22%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 264 (1.22%)  
    
    | 
    | 
    | >20
    | N (%)
    | 306 (1.42%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 143 (0.66%)  
    
    | 1998-01-01 to 1998-12-31
    | overall
    | overall
    | N (%)
    | 1,684 (7.80%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,045 (4.84%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 639 (2.96%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,186 (5.49%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 498 (2.31%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 843 (3.90%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 343 (1.59%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 296 (1.37%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 202 (0.94%)  
    
    | 1999-01-01 to 1999-12-31
    | overall
    | overall
    | N (%)
    | 1,780 (8.24%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,222 (5.66%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 558 (2.58%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,244 (5.76%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 536 (2.48%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 382 (1.77%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 154 (0.71%)  
    
    | 
    | 
    | >20
    | N (%)
    | 404 (1.87%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 840 (3.89%)  
    
    | 2000-01-01 to 2000-12-31
    | overall
    | overall
    | N (%)
    | 1,727 (8.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,043 (4.83%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 684 (3.17%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,297 (6.00%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 430 (1.99%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 809 (3.75%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 196 (0.91%)  
    
    | 
    | 
    | >20
    | N (%)
    | 488 (2.26%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 234 (1.08%)  
    
    | 2001-01-01 to 2001-12-31
    | overall
    | overall
    | N (%)
    | 1,769 (8.19%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 712 (3.30%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,057 (4.89%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 567 (2.62%)  
    
    | 
    | 
    | >20
    | N (%)
    | 1,202 (5.56%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 282 (1.31%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 427 (1.98%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 285 (1.32%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 775 (3.59%)  
    
    | 2002-01-01 to 2002-12-31
    | overall
    | overall
    | N (%)
    | 1,823 (8.44%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 798 (3.69%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,025 (4.75%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,336 (6.19%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 487 (2.25%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 232 (1.07%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 255 (1.18%)  
    
    | 
    | 
    | >20
    | N (%)
    | 770 (3.56%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 566 (2.62%)  
    
    | 2003-01-01 to 2003-12-31
    | overall
    | overall
    | N (%)
    | 1,955 (9.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 894 (4.14%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,061 (4.91%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,415 (6.55%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 540 (2.50%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 298 (1.38%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 242 (1.12%)  
    
    | 
    | 
    | >20
    | N (%)
    | 652 (3.02%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 763 (3.53%)  
    
    | 2004-01-01 to 2004-12-31
    | overall
    | overall
    | N (%)
    | 2,210 (10.23%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1,042 (4.82%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,168 (5.41%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,633 (7.56%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 577 (2.67%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 269 (1.25%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 308 (1.43%)  
    
    | 
    | 
    | >20
    | N (%)
    | 734 (3.40%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 899 (4.16%)  
    
    | 2005-01-01 to 2005-12-31
    | overall
    | overall
    | N (%)
    | 2,408 (11.15%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1,190 (5.51%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,218 (5.64%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,833 (8.49%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 575 (2.66%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 804 (3.72%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 189 (0.88%)  
    
    | 
    | 
    | >20
    | N (%)
    | 1,029 (4.76%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 386 (1.79%)  
    
    | 2006-01-01 to 2006-12-31
    | overall
    | overall
    | N (%)
    | 2,931 (13.57%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1,435 (6.64%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,496 (6.93%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 767 (3.55%)  
    
    | 
    | 
    | >20
    | N (%)
    | 2,164 (10.02%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 917 (4.25%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 1,247 (5.77%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 518 (2.40%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 249 (1.15%)  
    
    | 2007-01-01 to 2007-12-31
    | overall
    | overall
    | N (%)
    | 3,426 (15.86%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1,737 (8.04%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,689 (7.82%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 1,080 (5.00%)  
    
    | 
    | 
    | >20
    | N (%)
    | 2,346 (10.86%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 695 (3.22%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 1,304 (6.04%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 385 (1.78%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 1,042 (4.82%)  
    
    | 2008-01-01 to 2008-12-31
    | overall
    | overall
    | N (%)
    | 3,345 (15.49%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,522 (7.05%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1,823 (8.44%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 2,236 (10.35%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 1,109 (5.13%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 686 (3.18%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 1,099 (5.09%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 423 (1.96%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 1,137 (5.26%)  
    
    | 2009-01-01 to 2009-12-31
    | overall
    | overall
    | N (%)
    | 3,078 (14.25%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,407 (6.51%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1,671 (7.74%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 2,300 (10.65%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 778 (3.60%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 1,190 (5.51%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 1,110 (5.14%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 297 (1.38%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 481 (2.23%)  
    
    | 2010-01-01 to 2010-12-31
    | overall
    | overall
    | N (%)
    | 3,215 (14.88%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,572 (7.28%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1,643 (7.61%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 769 (3.56%)  
    
    | 
    | 
    | >20
    | N (%)
    | 2,446 (11.32%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 1,254 (5.81%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 451 (2.09%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 318 (1.47%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 1,192 (5.52%)  
    
    | 2011-01-01 to 2011-12-31
    | overall
    | overall
    | N (%)
    | 3,289 (15.23%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,527 (7.07%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1,762 (8.16%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 2,473 (11.45%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 816 (3.78%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 1,223 (5.66%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 277 (1.28%)  
    
    | 
    | 
    | >20
    | N (%)
    | 1,250 (5.79%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 539 (2.50%)  
    
    | 2012-01-01 to 2012-12-31
    | overall
    | overall
    | N (%)
    | 3,375 (15.62%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,394 (6.45%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1,981 (9.17%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 2,577 (11.93%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 798 (3.69%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 618 (2.86%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 180 (0.83%)  
    
    | 
    | 
    | >20
    | N (%)
    | 1,214 (5.62%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 1,363 (6.31%)  
    
    | 2013-01-01 to 2013-12-31
    | overall
    | overall
    | N (%)
    | 3,220 (14.91%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,686 (7.81%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1,534 (7.10%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 641 (2.97%)  
    
    | 
    | 
    | >20
    | N (%)
    | 2,579 (11.94%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 1,468 (6.80%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 1,111 (5.14%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 423 (1.96%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 218 (1.01%)  
    
    | 2014-01-01 to 2014-12-31
    | overall
    | overall
    | N (%)
    | 2,605 (12.06%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1,227 (5.68%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,378 (6.38%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 559 (2.59%)  
    
    | 
    | 
    | >20
    | N (%)
    | 2,046 (9.47%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 941 (4.36%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 273 (1.26%)  
    
    | 
    | 
    | >20
    | N (%)
    | 1,105 (5.12%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 286 (1.32%)  
    
    | 2015-01-01 to 2015-12-31
    | overall
    | overall
    | N (%)
    | 2,354 (10.90%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,261 (5.84%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1,093 (5.06%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,793 (8.30%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 561 (2.60%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 904 (4.19%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 204 (0.94%)  
    
    | 
    | 
    | >20
    | N (%)
    | 889 (4.12%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 357 (1.65%)  
    
    | 2016-01-01 to 2016-12-31
    | overall
    | overall
    | N (%)
    | 2,208 (10.22%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,215 (5.62%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 993 (4.60%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,663 (7.70%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 545 (2.52%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 388 (1.80%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 836 (3.87%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 827 (3.83%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 157 (0.73%)  
    
    | 2017-01-01 to 2017-12-31
    | overall
    | overall
    | N (%)
    | 2,096 (9.70%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 1,043 (4.83%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1,053 (4.88%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 538 (2.49%)  
    
    | 
    | 
    | >20
    | N (%)
    | 1,558 (7.21%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 195 (0.90%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 343 (1.59%)  
    
    | 
    | 
    | >20
    | N (%)
    | 700 (3.24%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 858 (3.97%)  
    
    | 2018-01-01 to 2018-12-31
    | overall
    | overall
    | N (%)
    | 2,000 (9.26%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 1,262 (5.84%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 738 (3.42%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,694 (7.84%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 306 (1.42%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 136 (0.63%)  
    
    | 
    | Male
    | <=20
    | N (%)
    | 170 (0.79%)  
    
    | 
    | 
    | >20
    | N (%)
    | 1,092 (5.06%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 602 (2.79%)  
    
    | 2019-01-01 to 2019-12-31
    | overall
    | overall
    | N (%)
    | 1,740 (8.06%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 857 (3.97%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 883 (4.09%)  
    
    | 
    | overall
    | >20
    | N (%)
    | 1,740 (8.06%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 883 (4.09%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 857 (3.97%)  
    
    | overall
    | overall
    | overall
    | N (%)
    | 21,600 (100.00%)  
    
    | 
    | Female
    | overall
    | N (%)
    | 11,933 (55.25%)  
    
    | 
    | Male
    | overall
    | N (%)
    | 9,667 (44.75%)  
    
    | 
    | overall
    | <=20
    | N (%)
    | 7,738 (35.82%)  
    
    | 
    | 
    | >20
    | N (%)
    | 13,862 (64.18%)  
    
    | 
    | Female
    | <=20
    | N (%)
    | 4,394 (20.34%)  
    
    | 
    | Male
    | >20
    | N (%)
    | 6,323 (29.27%)  
    
    | 
    | 
    | <=20
    | N (%)
    | 3,344 (15.48%)  
    
    | 
    | Female
    | >20
    | N (%)
    | 7,539 (34.90%)  
      
    
    PatientProfiles::[mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
