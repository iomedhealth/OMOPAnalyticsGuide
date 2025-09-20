# Create a visual table from a summariseTrend() result. — tableTrend • OmopSketch

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

# Create a visual table from a summariseTrend() result.

Source: [`R/tableTrend.R`](https://github.com/OHDSI/OmopSketch/blob/main/R/tableTrend.R)

`tableTrend.Rd`

Create a visual table from a summariseTrend() result.

## Usage
    
    
    tableTrend(result, type = "gt", style = "default")

## Arguments

result
    

A summarised_result object.

type
    

Type of formatting output table between `gt`, `datatable` and `reactable`. Default is `"gt"`.

style
    

Named list that specifies how to style the different parts of the gt or flextable table generated. Accepted style entries are: title, subtitle, header, header_name, header_level, column_name, group_label, and body. Alternatively, use "default" to get visOmopResults style, or NULL for gt/flextable style. Keep in mind that styling code is different for gt and flextable. Additionally, "datatable" and "reactable" have their own style functions. To see style options for each table type use `[visOmopResults::tableStyle()](https://darwin-eu.github.io/visOmopResults/reference/tableStyle.html)`

## Value

A formatted table object with the summarised data.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    
    cdm <- [mockOmopSketch](mockOmopSketch.html)()
    
    summarisedResult <- [summariseTrend](summariseTrend.html)(
      cdm = cdm,
      episode = "observation_period",
      event = [c](https://rdrr.io/r/base/c.html)("drug_exposure", "condition_occurrence"),
      interval = "years",
      ageGroup = [list](https://rdrr.io/r/base/list.html)("<=20" = [c](https://rdrr.io/r/base/c.html)(0, 20), ">20" = [c](https://rdrr.io/r/base/c.html)(21, Inf)),
      sex = TRUE
    )
    
    tableTrend(result = summarisedResult)
    
    
    
    
      Variable name
          | Time interval
          | Age group
          | Sex
          | Estimate name
          | 
            Database name
          
          
    ---|---|---|---|---|---  
    mockOmopSketch
          
    event; drug_exposure
          
    Records in observation
    | 1953-01-01 to 1953-12-31
    | overall
    | overall
    | N (%)
    | 3 (0.01%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 3 (0.01%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 3 (0.01%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 3 (0.01%)  
    
    | 1954-01-01 to 1954-12-31
    | overall
    | overall
    | N (%)
    | 7 (0.03%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 7 (0.03%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 7 (0.03%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 7 (0.03%)  
    
    | 1955-01-01 to 1955-12-31
    | overall
    | overall
    | N (%)
    | 13 (0.06%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 13 (0.06%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 5 (0.02%)  
    
    | 
    | 
    | Male
    | N (%)
    | 8 (0.04%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 5 (0.02%)  
    
    | 
    | 
    | Male
    | N (%)
    | 8 (0.04%)  
    
    | 1956-01-01 to 1956-12-31
    | overall
    | overall
    | N (%)
    | 12 (0.06%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 12 (0.06%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 6 (0.03%)  
    
    | 
    | 
    | Male
    | N (%)
    | 6 (0.03%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 6 (0.03%)  
    
    | 
    | 
    | Male
    | N (%)
    | 6 (0.03%)  
    
    | 1957-01-01 to 1957-12-31
    | overall
    | overall
    | N (%)
    | 8 (0.04%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 8 (0.04%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 4 (0.02%)  
    
    | 
    | 
    | Male
    | N (%)
    | 4 (0.02%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 4 (0.02%)  
    
    | 
    | 
    | Male
    | N (%)
    | 4 (0.02%)  
    
    | 1958-01-01 to 1958-12-31
    | overall
    | overall
    | N (%)
    | 21 (0.10%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 21 (0.10%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 12 (0.06%)  
    
    | 
    | 
    | Male
    | N (%)
    | 9 (0.04%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 12 (0.06%)  
    
    | 
    | 
    | Male
    | N (%)
    | 9 (0.04%)  
    
    | 1959-01-01 to 1959-12-31
    | overall
    | overall
    | N (%)
    | 13 (0.06%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 13 (0.06%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 7 (0.03%)  
    
    | 
    | 
    | Male
    | N (%)
    | 6 (0.03%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 7 (0.03%)  
    
    | 
    | 
    | Male
    | N (%)
    | 6 (0.03%)  
    
    | 1960-01-01 to 1960-12-31
    | overall
    | overall
    | N (%)
    | 26 (0.12%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 26 (0.12%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 17 (0.08%)  
    
    | 
    | 
    | Male
    | N (%)
    | 9 (0.04%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 17 (0.08%)  
    
    | 
    | 
    | Male
    | N (%)
    | 9 (0.04%)  
    
    | 1961-01-01 to 1961-12-31
    | overall
    | overall
    | N (%)
    | 42 (0.19%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 42 (0.19%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 4 (0.02%)  
    
    | 
    | 
    | Female
    | N (%)
    | 38 (0.18%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 4 (0.02%)  
    
    | 
    | 
    | Female
    | N (%)
    | 38 (0.18%)  
    
    | 1962-01-01 to 1962-12-31
    | overall
    | overall
    | N (%)
    | 29 (0.13%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 29 (0.13%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 20 (0.09%)  
    
    | 
    | 
    | Male
    | N (%)
    | 9 (0.04%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 20 (0.09%)  
    
    | 
    | 
    | Male
    | N (%)
    | 9 (0.04%)  
    
    | 1963-01-01 to 1963-12-31
    | overall
    | overall
    | N (%)
    | 42 (0.19%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 42 (0.19%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 23 (0.11%)  
    
    | 
    | 
    | Female
    | N (%)
    | 19 (0.09%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 23 (0.11%)  
    
    | 
    | 
    | Female
    | N (%)
    | 19 (0.09%)  
    
    | 1964-01-01 to 1964-12-31
    | overall
    | overall
    | N (%)
    | 48 (0.22%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 48 (0.22%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 21 (0.10%)  
    
    | 
    | 
    | Male
    | N (%)
    | 27 (0.12%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 21 (0.10%)  
    
    | 
    | 
    | Male
    | N (%)
    | 27 (0.12%)  
    
    | 1965-01-01 to 1965-12-31
    | overall
    | overall
    | N (%)
    | 47 (0.22%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 47 (0.22%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 25 (0.12%)  
    
    | 
    | 
    | Female
    | N (%)
    | 22 (0.10%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 25 (0.12%)  
    
    | 
    | 
    | Female
    | N (%)
    | 22 (0.10%)  
    
    | 1966-01-01 to 1966-12-31
    | overall
    | overall
    | N (%)
    | 58 (0.27%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 58 (0.27%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 22 (0.10%)  
    
    | 
    | 
    | Male
    | N (%)
    | 36 (0.17%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 22 (0.10%)  
    
    | 
    | 
    | Male
    | N (%)
    | 36 (0.17%)  
    
    | 1967-01-01 to 1967-12-31
    | overall
    | overall
    | N (%)
    | 61 (0.28%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 61 (0.28%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 36 (0.17%)  
    
    | 
    | 
    | Male
    | N (%)
    | 25 (0.12%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 36 (0.17%)  
    
    | 
    | 
    | Male
    | N (%)
    | 25 (0.12%)  
    
    | 1968-01-01 to 1968-12-31
    | overall
    | overall
    | N (%)
    | 69 (0.32%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 69 (0.32%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 28 (0.13%)  
    
    | 
    | 
    | Female
    | N (%)
    | 41 (0.19%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 28 (0.13%)  
    
    | 
    | 
    | Female
    | N (%)
    | 41 (0.19%)  
    
    | 1969-01-01 to 1969-12-31
    | overall
    | overall
    | N (%)
    | 77 (0.36%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 77 (0.36%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 51 (0.24%)  
    
    | 
    | 
    | Male
    | N (%)
    | 26 (0.12%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 51 (0.24%)  
    
    | 
    | 
    | Male
    | N (%)
    | 26 (0.12%)  
    
    | 1970-01-01 to 1970-12-31
    | overall
    | overall
    | N (%)
    | 101 (0.47%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 101 (0.47%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 30 (0.14%)  
    
    | 
    | 
    | Female
    | N (%)
    | 71 (0.33%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 30 (0.14%)  
    
    | 
    | 
    | Female
    | N (%)
    | 71 (0.33%)  
    
    | 1971-01-01 to 1971-12-31
    | overall
    | overall
    | N (%)
    | 71 (0.33%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 5 (0.02%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 66 (0.31%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 42 (0.19%)  
    
    | 
    | 
    | Male
    | N (%)
    | 29 (0.13%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 5 (0.02%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 42 (0.19%)  
    
    | 
    | 
    | Male
    | N (%)
    | 24 (0.11%)  
    
    | 1972-01-01 to 1972-12-31
    | overall
    | overall
    | N (%)
    | 214 (0.99%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 210 (0.97%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 4 (0.02%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 57 (0.26%)  
    
    | 
    | 
    | Female
    | N (%)
    | 157 (0.73%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 4 (0.02%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 53 (0.25%)  
    
    | 
    | 
    | Female
    | N (%)
    | 157 (0.73%)  
    
    | 1973-01-01 to 1973-12-31
    | overall
    | overall
    | N (%)
    | 270 (1.25%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 8 (0.04%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 262 (1.21%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 196 (0.91%)  
    
    | 
    | 
    | Male
    | N (%)
    | 74 (0.34%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 8 (0.04%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 196 (0.91%)  
    
    | 
    | 
    | Male
    | N (%)
    | 66 (0.31%)  
    
    | 1974-01-01 to 1974-12-31
    | overall
    | overall
    | N (%)
    | 117 (0.54%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 10 (0.05%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 107 (0.50%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 62 (0.29%)  
    
    | 
    | 
    | Male
    | N (%)
    | 55 (0.25%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 7 (0.03%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 59 (0.27%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 3 (0.01%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 48 (0.22%)  
    
    | 1975-01-01 to 1975-12-31
    | overall
    | overall
    | N (%)
    | 114 (0.53%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 101 (0.47%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 13 (0.06%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 51 (0.24%)  
    
    | 
    | 
    | Male
    | N (%)
    | 63 (0.29%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 49 (0.23%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 2 (0.01%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 52 (0.24%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 11 (0.05%)  
    
    | 1976-01-01 to 1976-12-31
    | overall
    | overall
    | N (%)
    | 93 (0.43%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 54 (0.25%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 39 (0.18%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 19 (0.09%)  
    
    | 
    | 
    | Female
    | N (%)
    | 74 (0.34%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 3 (0.01%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 16 (0.07%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 36 (0.17%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 38 (0.18%)  
    
    | 1977-01-01 to 1977-12-31
    | overall
    | overall
    | N (%)
    | 108 (0.50%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 55 (0.25%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 53 (0.25%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 24 (0.11%)  
    
    | 
    | 
    | Female
    | N (%)
    | 84 (0.39%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 20 (0.09%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 51 (0.24%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 33 (0.15%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 4 (0.02%)  
    
    | 1978-01-01 to 1978-12-31
    | overall
    | overall
    | N (%)
    | 102 (0.47%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 46 (0.21%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 56 (0.26%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 25 (0.12%)  
    
    | 
    | 
    | Female
    | N (%)
    | 77 (0.36%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 8 (0.04%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 17 (0.08%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 48 (0.22%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 29 (0.13%)  
    
    | 1979-01-01 to 1979-12-31
    | overall
    | overall
    | N (%)
    | 150 (0.69%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 82 (0.38%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 68 (0.31%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 72 (0.33%)  
    
    | 
    | 
    | Male
    | N (%)
    | 78 (0.36%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 18 (0.08%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 54 (0.25%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 64 (0.30%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 14 (0.06%)  
    
    | 1980-01-01 to 1980-12-31
    | overall
    | overall
    | N (%)
    | 242 (1.12%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 74 (0.34%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 168 (0.78%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 146 (0.68%)  
    
    | 
    | 
    | Male
    | N (%)
    | 96 (0.44%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 16 (0.07%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 88 (0.41%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 58 (0.27%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 80 (0.37%)  
    
    | 1981-01-01 to 1981-12-31
    | overall
    | overall
    | N (%)
    | 343 (1.59%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 261 (1.21%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 82 (0.38%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 92 (0.43%)  
    
    | 
    | 
    | Female
    | N (%)
    | 251 (1.16%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 12 (0.06%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 80 (0.37%)  
    
    | 
    | 
    | Female
    | N (%)
    | 181 (0.84%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 70 (0.32%)  
    
    | 1982-01-01 to 1982-12-31
    | overall
    | overall
    | N (%)
    | 411 (1.90%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 353 (1.63%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 58 (0.27%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 297 (1.38%)  
    
    | 
    | 
    | Male
    | N (%)
    | 114 (0.53%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 259 (1.20%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 38 (0.18%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 94 (0.44%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 20 (0.09%)  
    
    | 1983-01-01 to 1983-12-31
    | overall
    | overall
    | N (%)
    | 96 (0.44%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 53 (0.25%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 43 (0.20%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 43 (0.20%)  
    
    | 
    | 
    | Female
    | N (%)
    | 53 (0.25%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 15 (0.07%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 28 (0.13%)  
    
    | 
    | 
    | Female
    | N (%)
    | 25 (0.12%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 28 (0.13%)  
    
    | 1984-01-01 to 1984-12-31
    | overall
    | overall
    | N (%)
    | 138 (0.64%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 65 (0.30%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 73 (0.34%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 50 (0.23%)  
    
    | 
    | 
    | Female
    | N (%)
    | 88 (0.41%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 24 (0.11%)  
    
    | 
    | 
    | Female
    | N (%)
    | 49 (0.23%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 39 (0.18%)  
    
    | 
    | 
    | Male
    | N (%)
    | 26 (0.12%)  
    
    | 1985-01-01 to 1985-12-31
    | overall
    | overall
    | N (%)
    | 291 (1.35%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 218 (1.01%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 73 (0.34%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 74 (0.34%)  
    
    | 
    | 
    | Male
    | N (%)
    | 217 (1.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 183 (0.85%)  
    
    | 
    | 
    | Female
    | N (%)
    | 35 (0.16%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 39 (0.18%)  
    
    | 
    | 
    | Male
    | N (%)
    | 34 (0.16%)  
    
    | 1986-01-01 to 1986-12-31
    | overall
    | overall
    | N (%)
    | 197 (0.91%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 108 (0.50%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 89 (0.41%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 76 (0.35%)  
    
    | 
    | 
    | Male
    | N (%)
    | 121 (0.56%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 73 (0.34%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 41 (0.19%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 35 (0.16%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 48 (0.22%)  
    
    | 1987-01-01 to 1987-12-31
    | overall
    | overall
    | N (%)
    | 138 (0.64%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 91 (0.42%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 47 (0.22%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 57 (0.26%)  
    
    | 
    | 
    | Male
    | N (%)
    | 81 (0.38%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 32 (0.15%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 25 (0.12%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 59 (0.27%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 22 (0.10%)  
    
    | 1988-01-01 to 1988-12-31
    | overall
    | overall
    | N (%)
    | 186 (0.86%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 55 (0.25%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 131 (0.61%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 63 (0.29%)  
    
    | 
    | 
    | Male
    | N (%)
    | 123 (0.57%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 30 (0.14%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 38 (0.18%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 25 (0.12%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 93 (0.43%)  
    
    | 1989-01-01 to 1989-12-31
    | overall
    | overall
    | N (%)
    | 232 (1.07%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 149 (0.69%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 83 (0.38%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 80 (0.37%)  
    
    | 
    | 
    | Male
    | N (%)
    | 152 (0.70%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 39 (0.18%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 41 (0.19%)  
    
    | 
    | 
    | Male
    | N (%)
    | 108 (0.50%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 44 (0.20%)  
    
    | 1990-01-01 to 1990-12-31
    | overall
    | overall
    | N (%)
    | 276 (1.28%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 171 (0.79%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 105 (0.49%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 175 (0.81%)  
    
    | 
    | 
    | Female
    | N (%)
    | 101 (0.47%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 45 (0.21%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 130 (0.60%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 60 (0.28%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 41 (0.19%)  
    
    | 1991-01-01 to 1991-12-31
    | overall
    | overall
    | N (%)
    | 318 (1.47%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 136 (0.63%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 182 (0.84%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 194 (0.90%)  
    
    | 
    | 
    | Female
    | N (%)
    | 124 (0.57%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 124 (0.57%)  
    
    | 
    | 
    | Female
    | N (%)
    | 58 (0.27%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 66 (0.31%)  
    
    | 
    | 
    | Male
    | N (%)
    | 70 (0.32%)  
    
    | 1992-01-01 to 1992-12-31
    | overall
    | overall
    | N (%)
    | 529 (2.45%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 382 (1.77%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 147 (0.68%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 414 (1.92%)  
    
    | 
    | 
    | Female
    | N (%)
    | 115 (0.53%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 94 (0.44%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 320 (1.48%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 53 (0.25%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 62 (0.29%)  
    
    | 1993-01-01 to 1993-12-31
    | overall
    | overall
    | N (%)
    | 339 (1.57%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 129 (0.60%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 210 (0.97%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 147 (0.68%)  
    
    | 
    | 
    | Male
    | N (%)
    | 192 (0.89%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 67 (0.31%)  
    
    | 
    | 
    | Female
    | N (%)
    | 62 (0.29%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 85 (0.39%)  
    
    | 
    | 
    | Male
    | N (%)
    | 125 (0.58%)  
    
    | 1994-01-01 to 1994-12-31
    | overall
    | overall
    | N (%)
    | 351 (1.62%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 134 (0.62%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 217 (1.00%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 194 (0.90%)  
    
    | 
    | 
    | Female
    | N (%)
    | 157 (0.73%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 127 (0.59%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 67 (0.31%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 90 (0.42%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 67 (0.31%)  
    
    | 1995-01-01 to 1995-12-31
    | overall
    | overall
    | N (%)
    | 362 (1.68%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 168 (0.78%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 194 (0.90%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 155 (0.72%)  
    
    | 
    | 
    | Male
    | N (%)
    | 207 (0.96%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 102 (0.47%)  
    
    | 
    | 
    | Female
    | N (%)
    | 66 (0.31%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 89 (0.41%)  
    
    | 
    | 
    | Male
    | N (%)
    | 105 (0.49%)  
    
    | 1996-01-01 to 1996-12-31
    | overall
    | overall
    | N (%)
    | 433 (2.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 232 (1.07%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 201 (0.93%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 206 (0.95%)  
    
    | 
    | 
    | Male
    | N (%)
    | 227 (1.05%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 139 (0.64%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 113 (0.52%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 93 (0.43%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 88 (0.41%)  
    
    | 1997-01-01 to 1997-12-31
    | overall
    | overall
    | N (%)
    | 416 (1.93%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 249 (1.15%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 167 (0.77%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 183 (0.85%)  
    
    | 
    | 
    | Male
    | N (%)
    | 233 (1.08%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 164 (0.76%)  
    
    | 
    | 
    | Female
    | N (%)
    | 85 (0.39%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 98 (0.45%)  
    
    | 
    | 
    | Male
    | N (%)
    | 69 (0.32%)  
    
    | 1998-01-01 to 1998-12-31
    | overall
    | overall
    | N (%)
    | 479 (2.22%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 346 (1.60%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 133 (0.62%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 181 (0.84%)  
    
    | 
    | 
    | Male
    | N (%)
    | 298 (1.38%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 250 (1.16%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 85 (0.39%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 96 (0.44%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 48 (0.22%)  
    
    | 1999-01-01 to 1999-12-31
    | overall
    | overall
    | N (%)
    | 440 (2.04%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 288 (1.33%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 152 (0.70%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 273 (1.26%)  
    
    | 
    | 
    | Female
    | N (%)
    | 167 (0.77%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 55 (0.25%)  
    
    | 
    | 
    | Female
    | N (%)
    | 97 (0.45%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 70 (0.32%)  
    
    | 
    | 
    | Male
    | N (%)
    | 218 (1.01%)  
    
    | 2000-01-01 to 2000-12-31
    | overall
    | overall
    | N (%)
    | 517 (2.39%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 273 (1.26%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 244 (1.13%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 327 (1.51%)  
    
    | 
    | 
    | Female
    | N (%)
    | 190 (0.88%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 151 (0.70%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 176 (0.81%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 93 (0.43%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 97 (0.45%)  
    
    | 2001-01-01 to 2001-12-31
    | overall
    | overall
    | N (%)
    | 452 (2.09%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 239 (1.11%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 213 (0.99%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 196 (0.91%)  
    
    | 
    | 
    | Male
    | N (%)
    | 256 (1.19%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 150 (0.69%)  
    
    | 
    | 
    | Female
    | N (%)
    | 89 (0.41%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 107 (0.50%)  
    
    | 
    | 
    | Male
    | N (%)
    | 106 (0.49%)  
    
    | 2002-01-01 to 2002-12-31
    | overall
    | overall
    | N (%)
    | 404 (1.87%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 283 (1.31%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 121 (0.56%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 209 (0.97%)  
    
    | 
    | 
    | Female
    | N (%)
    | 195 (0.90%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 22 (0.10%)  
    
    | 
    | 
    | Female
    | N (%)
    | 99 (0.46%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 96 (0.44%)  
    
    | 
    | 
    | Male
    | N (%)
    | 187 (0.87%)  
    
    | 2003-01-01 to 2003-12-31
    | overall
    | overall
    | N (%)
    | 645 (2.99%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 189 (0.88%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 456 (2.11%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 230 (1.06%)  
    
    | 
    | 
    | Female
    | N (%)
    | 415 (1.92%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 186 (0.86%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 44 (0.20%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 270 (1.25%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 145 (0.67%)  
    
    | 2004-01-01 to 2004-12-31
    | overall
    | overall
    | N (%)
    | 532 (2.46%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 165 (0.76%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 367 (1.70%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 268 (1.24%)  
    
    | 
    | 
    | Male
    | N (%)
    | 264 (1.22%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 149 (0.69%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 119 (0.55%)  
    
    | 
    | 
    | Male
    | N (%)
    | 46 (0.21%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 218 (1.01%)  
    
    | 2005-01-01 to 2005-12-31
    | overall
    | overall
    | N (%)
    | 498 (2.31%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 340 (1.57%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 158 (0.73%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 187 (0.87%)  
    
    | 
    | 
    | Male
    | N (%)
    | 311 (1.44%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 251 (1.16%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 98 (0.45%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 89 (0.41%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 60 (0.28%)  
    
    | 2006-01-01 to 2006-12-31
    | overall
    | overall
    | N (%)
    | 668 (3.09%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 362 (1.68%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 306 (1.42%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 458 (2.12%)  
    
    | 
    | 
    | Female
    | N (%)
    | 210 (0.97%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 222 (1.03%)  
    
    | 
    | 
    | Female
    | N (%)
    | 84 (0.39%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 126 (0.58%)  
    
    | 
    | 
    | Male
    | N (%)
    | 236 (1.09%)  
    
    | 2007-01-01 to 2007-12-31
    | overall
    | overall
    | N (%)
    | 662 (3.06%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 402 (1.86%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 260 (1.20%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 388 (1.80%)  
    
    | 
    | 
    | Female
    | N (%)
    | 274 (1.27%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 141 (0.65%)  
    
    | 
    | 
    | Female
    | N (%)
    | 119 (0.55%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 155 (0.72%)  
    
    | 
    | 
    | Male
    | N (%)
    | 247 (1.14%)  
    
    | 2008-01-01 to 2008-12-31
    | overall
    | overall
    | N (%)
    | 596 (2.76%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 451 (2.09%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 145 (0.67%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 322 (1.49%)  
    
    | 
    | 
    | Male
    | N (%)
    | 274 (1.27%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 194 (0.90%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 65 (0.30%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 257 (1.19%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 80 (0.37%)  
    
    | 2009-01-01 to 2009-12-31
    | overall
    | overall
    | N (%)
    | 605 (2.80%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 140 (0.65%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 465 (2.15%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 316 (1.46%)  
    
    | 
    | 
    | Female
    | N (%)
    | 289 (1.34%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 238 (1.10%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 78 (0.36%)  
    
    | 
    | 
    | Female
    | N (%)
    | 62 (0.29%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 227 (1.05%)  
    
    | 2010-01-01 to 2010-12-31
    | overall
    | overall
    | N (%)
    | 796 (3.69%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 167 (0.77%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 629 (2.91%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 541 (2.50%)  
    
    | 
    | 
    | Female
    | N (%)
    | 255 (1.18%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 466 (2.16%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 75 (0.35%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 163 (0.75%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 92 (0.43%)  
    
    | 2011-01-01 to 2011-12-31
    | overall
    | overall
    | N (%)
    | 724 (3.35%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 162 (0.75%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 562 (2.60%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 386 (1.79%)  
    
    | 
    | 
    | Male
    | N (%)
    | 338 (1.56%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 93 (0.43%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 293 (1.36%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 69 (0.32%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 269 (1.25%)  
    
    | 2012-01-01 to 2012-12-31
    | overall
    | overall
    | N (%)
    | 590 (2.73%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 141 (0.65%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 449 (2.08%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 161 (0.75%)  
    
    | 
    | 
    | Male
    | N (%)
    | 429 (1.99%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 114 (0.53%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 47 (0.22%)  
    
    | 
    | 
    | Male
    | N (%)
    | 94 (0.44%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 335 (1.55%)  
    
    | 2013-01-01 to 2013-12-31
    | overall
    | overall
    | N (%)
    | 816 (3.78%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 237 (1.10%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 579 (2.68%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 636 (2.94%)  
    
    | 
    | 
    | Female
    | N (%)
    | 180 (0.83%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 439 (2.03%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 197 (0.91%)  
    
    | 
    | 
    | Female
    | N (%)
    | 40 (0.19%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 140 (0.65%)  
    
    | 2014-01-01 to 2014-12-31
    | overall
    | overall
    | N (%)
    | 820 (3.80%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 610 (2.82%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 210 (0.97%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 641 (2.97%)  
    
    | 
    | 
    | Female
    | N (%)
    | 179 (0.83%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 210 (0.97%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 179 (0.83%)  
    
    | 
    | 
    | Male
    | N (%)
    | 431 (2.00%)  
    
    | 2015-01-01 to 2015-12-31
    | overall
    | overall
    | N (%)
    | 978 (4.53%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 277 (1.28%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 701 (3.25%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 794 (3.68%)  
    
    | 
    | 
    | Female
    | N (%)
    | 184 (0.85%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 589 (2.73%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 205 (0.95%)  
    
    | 
    | 
    | Female
    | N (%)
    | 72 (0.33%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 112 (0.52%)  
    
    | 2016-01-01 to 2016-12-31
    | overall
    | overall
    | N (%)
    | 655 (3.03%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 137 (0.63%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 518 (2.40%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 490 (2.27%)  
    
    | 
    | 
    | Female
    | N (%)
    | 165 (0.76%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 357 (1.65%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 133 (0.62%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 161 (0.75%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 4 (0.02%)  
    
    | 2017-01-01 to 2017-12-31
    | overall
    | overall
    | N (%)
    | 1,052 (4.87%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 149 (0.69%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 903 (4.18%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 109 (0.50%)  
    
    | 
    | 
    | Male
    | N (%)
    | 943 (4.37%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 109 (0.50%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 149 (0.69%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 794 (3.68%)  
    
    | 2018-01-01 to 2018-12-31
    | overall
    | overall
    | N (%)
    | 736 (3.41%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 497 (2.30%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 239 (1.11%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 306 (1.42%)  
    
    | 
    | 
    | Male
    | N (%)
    | 430 (1.99%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 191 (0.88%)  
    
    | 
    | 
    | Female
    | N (%)
    | 306 (1.42%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 239 (1.11%)  
    
    | 2019-01-01 to 2019-12-31
    | overall
    | overall
    | N (%)
    | 721 (3.34%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 721 (3.34%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 451 (2.09%)  
    
    | 
    | 
    | Female
    | N (%)
    | 270 (1.25%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 451 (2.09%)  
    
    | 
    | 
    | Female
    | N (%)
    | 270 (1.25%)  
    
    | overall
    | overall
    | overall
    | N (%)
    | 21,600 (100.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 12,803 (59.27%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 8,797 (40.73%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 8,669 (40.13%)  
    
    | 
    | 
    | Male
    | N (%)
    | 12,931 (59.87%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 4,702 (21.77%)  
    
    | 
    | 
    | Male
    | N (%)
    | 8,101 (37.50%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 3,967 (18.37%)  
    
    | 
    | 
    | Male
    | N (%)
    | 4,830 (22.36%)  
    event; condition_occurrence
          
    Records in observation
    | 1953-01-01 to 1953-12-31
    | overall
    | overall
    | N (%)
    | 1 (0.01%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 1 (0.01%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 1 (0.01%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 1 (0.01%)  
    
    | 1954-01-01 to 1954-12-31
    | overall
    | overall
    | N (%)
    | 2 (0.02%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 2 (0.02%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 2 (0.02%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 2 (0.02%)  
    
    | 1955-01-01 to 1955-12-31
    | overall
    | overall
    | N (%)
    | 11 (0.13%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 11 (0.13%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 6 (0.07%)  
    
    | 
    | 
    | Male
    | N (%)
    | 5 (0.06%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 6 (0.07%)  
    
    | 
    | 
    | Male
    | N (%)
    | 5 (0.06%)  
    
    | 1956-01-01 to 1956-12-31
    | overall
    | overall
    | N (%)
    | 6 (0.07%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 6 (0.07%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 5 (0.06%)  
    
    | 
    | 
    | Female
    | N (%)
    | 1 (0.01%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 5 (0.06%)  
    
    | 
    | 
    | Female
    | N (%)
    | 1 (0.01%)  
    
    | 1957-01-01 to 1957-12-31
    | overall
    | overall
    | N (%)
    | 4 (0.05%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 4 (0.05%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 1 (0.01%)  
    
    | 
    | 
    | Female
    | N (%)
    | 3 (0.04%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 1 (0.01%)  
    
    | 
    | 
    | Female
    | N (%)
    | 3 (0.04%)  
    
    | 1958-01-01 to 1958-12-31
    | overall
    | overall
    | N (%)
    | 8 (0.10%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 8 (0.10%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 3 (0.04%)  
    
    | 
    | 
    | Female
    | N (%)
    | 5 (0.06%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 3 (0.04%)  
    
    | 
    | 
    | Female
    | N (%)
    | 5 (0.06%)  
    
    | 1959-01-01 to 1959-12-31
    | overall
    | overall
    | N (%)
    | 5 (0.06%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 5 (0.06%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 1 (0.01%)  
    
    | 
    | 
    | Female
    | N (%)
    | 4 (0.05%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 1 (0.01%)  
    
    | 
    | 
    | Female
    | N (%)
    | 4 (0.05%)  
    
    | 1960-01-01 to 1960-12-31
    | overall
    | overall
    | N (%)
    | 14 (0.17%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 14 (0.17%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 2 (0.02%)  
    
    | 
    | 
    | Female
    | N (%)
    | 12 (0.14%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 2 (0.02%)  
    
    | 
    | 
    | Female
    | N (%)
    | 12 (0.14%)  
    
    | 1961-01-01 to 1961-12-31
    | overall
    | overall
    | N (%)
    | 10 (0.12%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 10 (0.12%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 1 (0.01%)  
    
    | 
    | 
    | Female
    | N (%)
    | 9 (0.11%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 9 (0.11%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (0.01%)  
    
    | 1962-01-01 to 1962-12-31
    | overall
    | overall
    | N (%)
    | 13 (0.15%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 13 (0.15%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 4 (0.05%)  
    
    | 
    | 
    | Female
    | N (%)
    | 9 (0.11%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 4 (0.05%)  
    
    | 
    | 
    | Female
    | N (%)
    | 9 (0.11%)  
    
    | 1963-01-01 to 1963-12-31
    | overall
    | overall
    | N (%)
    | 21 (0.25%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 21 (0.25%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 11 (0.13%)  
    
    | 
    | 
    | Female
    | N (%)
    | 10 (0.12%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 10 (0.12%)  
    
    | 
    | 
    | Male
    | N (%)
    | 11 (0.13%)  
    
    | 1964-01-01 to 1964-12-31
    | overall
    | overall
    | N (%)
    | 20 (0.24%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 20 (0.24%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 10 (0.12%)  
    
    | 
    | 
    | Male
    | N (%)
    | 10 (0.12%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 10 (0.12%)  
    
    | 
    | 
    | Male
    | N (%)
    | 10 (0.12%)  
    
    | 1965-01-01 to 1965-12-31
    | overall
    | overall
    | N (%)
    | 24 (0.29%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 24 (0.29%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 12 (0.14%)  
    
    | 
    | 
    | Female
    | N (%)
    | 12 (0.14%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 12 (0.14%)  
    
    | 
    | 
    | Male
    | N (%)
    | 12 (0.14%)  
    
    | 1966-01-01 to 1966-12-31
    | overall
    | overall
    | N (%)
    | 28 (0.33%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 28 (0.33%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 11 (0.13%)  
    
    | 
    | 
    | Female
    | N (%)
    | 17 (0.20%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 11 (0.13%)  
    
    | 
    | 
    | Female
    | N (%)
    | 17 (0.20%)  
    
    | 1967-01-01 to 1967-12-31
    | overall
    | overall
    | N (%)
    | 32 (0.38%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 32 (0.38%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 14 (0.17%)  
    
    | 
    | 
    | Female
    | N (%)
    | 18 (0.21%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 14 (0.17%)  
    
    | 
    | 
    | Female
    | N (%)
    | 18 (0.21%)  
    
    | 1968-01-01 to 1968-12-31
    | overall
    | overall
    | N (%)
    | 33 (0.39%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 33 (0.39%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 20 (0.24%)  
    
    | 
    | 
    | Male
    | N (%)
    | 13 (0.15%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 13 (0.15%)  
    
    | 
    | 
    | Female
    | N (%)
    | 20 (0.24%)  
    
    | 1969-01-01 to 1969-12-31
    | overall
    | overall
    | N (%)
    | 25 (0.30%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 25 (0.30%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 10 (0.12%)  
    
    | 
    | 
    | Female
    | N (%)
    | 15 (0.18%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 10 (0.12%)  
    
    | 
    | 
    | Female
    | N (%)
    | 15 (0.18%)  
    
    | 1970-01-01 to 1970-12-31
    | overall
    | overall
    | N (%)
    | 29 (0.35%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 29 (0.35%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 8 (0.10%)  
    
    | 
    | 
    | Female
    | N (%)
    | 21 (0.25%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 21 (0.25%)  
    
    | 
    | 
    | Male
    | N (%)
    | 8 (0.10%)  
    
    | 1971-01-01 to 1971-12-31
    | overall
    | overall
    | N (%)
    | 32 (0.38%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 32 (0.38%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 9 (0.11%)  
    
    | 
    | 
    | Female
    | N (%)
    | 23 (0.27%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 9 (0.11%)  
    
    | 
    | 
    | Female
    | N (%)
    | 23 (0.27%)  
    
    | 1972-01-01 to 1972-12-31
    | overall
    | overall
    | N (%)
    | 86 (1.02%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 85 (1.01%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 1 (0.01%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 24 (0.29%)  
    
    | 
    | 
    | Female
    | N (%)
    | 62 (0.74%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 62 (0.74%)  
    
    | 
    | 
    | Male
    | N (%)
    | 23 (0.27%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 1 (0.01%)  
    
    | 1973-01-01 to 1973-12-31
    | overall
    | overall
    | N (%)
    | 113 (1.35%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 3 (0.04%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 110 (1.31%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 38 (0.45%)  
    
    | 
    | 
    | Female
    | N (%)
    | 75 (0.89%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 3 (0.04%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 35 (0.42%)  
    
    | 
    | 
    | Female
    | N (%)
    | 75 (0.89%)  
    
    | 1974-01-01 to 1974-12-31
    | overall
    | overall
    | N (%)
    | 45 (0.54%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 3 (0.04%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 42 (0.50%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 26 (0.31%)  
    
    | 
    | 
    | Female
    | N (%)
    | 19 (0.23%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 3 (0.04%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 23 (0.27%)  
    
    | 
    | 
    | Female
    | N (%)
    | 19 (0.23%)  
    
    | 1975-01-01 to 1975-12-31
    | overall
    | overall
    | N (%)
    | 41 (0.49%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 36 (0.43%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 5 (0.06%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 13 (0.15%)  
    
    | 
    | 
    | Male
    | N (%)
    | 28 (0.33%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 11 (0.13%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 2 (0.02%)  
    
    | 
    | 
    | Male
    | N (%)
    | 3 (0.04%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 25 (0.30%)  
    
    | 1976-01-01 to 1976-12-31
    | overall
    | overall
    | N (%)
    | 48 (0.57%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 25 (0.30%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 23 (0.27%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 12 (0.14%)  
    
    | 
    | 
    | Female
    | N (%)
    | 36 (0.43%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 21 (0.25%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 15 (0.18%)  
    
    | 
    | 
    | Male
    | N (%)
    | 10 (0.12%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 2 (0.02%)  
    
    | 1977-01-01 to 1977-12-31
    | overall
    | overall
    | N (%)
    | 48 (0.57%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 23 (0.27%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 25 (0.30%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 37 (0.44%)  
    
    | 
    | 
    | Male
    | N (%)
    | 11 (0.13%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 9 (0.11%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 2 (0.02%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 16 (0.19%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 21 (0.25%)  
    
    | 1978-01-01 to 1978-12-31
    | overall
    | overall
    | N (%)
    | 49 (0.58%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 29 (0.35%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 20 (0.24%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 15 (0.18%)  
    
    | 
    | 
    | Female
    | N (%)
    | 34 (0.40%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 18 (0.21%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 16 (0.19%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 11 (0.13%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 4 (0.05%)  
    
    | 1979-01-01 to 1979-12-31
    | overall
    | overall
    | N (%)
    | 61 (0.73%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 36 (0.43%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 25 (0.30%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 28 (0.33%)  
    
    | 
    | 
    | Male
    | N (%)
    | 33 (0.39%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 20 (0.24%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 8 (0.10%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 5 (0.06%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 28 (0.33%)  
    
    | 1980-01-01 to 1980-12-31
    | overall
    | overall
    | N (%)
    | 84 (1.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 27 (0.32%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 57 (0.68%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 31 (0.37%)  
    
    | 
    | 
    | Female
    | N (%)
    | 53 (0.63%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 3 (0.04%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 28 (0.33%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 24 (0.29%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 29 (0.35%)  
    
    | 1981-01-01 to 1981-12-31
    | overall
    | overall
    | N (%)
    | 108 (1.29%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 89 (1.06%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 19 (0.23%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 30 (0.36%)  
    
    | 
    | 
    | Female
    | N (%)
    | 78 (0.93%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 18 (0.21%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 60 (0.71%)  
    
    | 
    | 
    | Male
    | N (%)
    | 29 (0.35%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 1 (0.01%)  
    
    | 1982-01-01 to 1982-12-31
    | overall
    | overall
    | N (%)
    | 132 (1.57%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 108 (1.29%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 24 (0.29%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 106 (1.26%)  
    
    | 
    | 
    | Male
    | N (%)
    | 26 (0.31%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 87 (1.04%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 19 (0.23%)  
    
    | 
    | 
    | Male
    | N (%)
    | 5 (0.06%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 21 (0.25%)  
    
    | 1983-01-01 to 1983-12-31
    | overall
    | overall
    | N (%)
    | 31 (0.37%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 15 (0.18%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 16 (0.19%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 14 (0.17%)  
    
    | 
    | 
    | Female
    | N (%)
    | 17 (0.20%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 6 (0.07%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 11 (0.13%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 9 (0.11%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 5 (0.06%)  
    
    | 1984-01-01 to 1984-12-31
    | overall
    | overall
    | N (%)
    | 53 (0.63%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 19 (0.23%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 34 (0.40%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 30 (0.36%)  
    
    | 
    | 
    | Male
    | N (%)
    | 23 (0.27%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 15 (0.18%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 8 (0.10%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 19 (0.23%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 11 (0.13%)  
    
    | 1985-01-01 to 1985-12-31
    | overall
    | overall
    | N (%)
    | 132 (1.57%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 96 (1.14%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 36 (0.43%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 93 (1.11%)  
    
    | 
    | 
    | Female
    | N (%)
    | 39 (0.46%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 79 (0.94%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 14 (0.17%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 17 (0.20%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 22 (0.26%)  
    
    | 1986-01-01 to 1986-12-31
    | overall
    | overall
    | N (%)
    | 64 (0.76%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 35 (0.42%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 29 (0.35%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 40 (0.48%)  
    
    | 
    | 
    | Female
    | N (%)
    | 24 (0.29%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 22 (0.26%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 18 (0.21%)  
    
    | 
    | 
    | Female
    | N (%)
    | 11 (0.13%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 13 (0.15%)  
    
    | 1987-01-01 to 1987-12-31
    | overall
    | overall
    | N (%)
    | 47 (0.56%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 30 (0.36%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 17 (0.20%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 22 (0.26%)  
    
    | 
    | 
    | Male
    | N (%)
    | 25 (0.30%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 12 (0.14%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 10 (0.12%)  
    
    | 
    | 
    | Male
    | N (%)
    | 7 (0.08%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 18 (0.21%)  
    
    | 1988-01-01 to 1988-12-31
    | overall
    | overall
    | N (%)
    | 81 (0.96%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 29 (0.35%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 52 (0.62%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 46 (0.55%)  
    
    | 
    | 
    | Female
    | N (%)
    | 35 (0.42%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 8 (0.10%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 38 (0.45%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 21 (0.25%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 14 (0.17%)  
    
    | 1989-01-01 to 1989-12-31
    | overall
    | overall
    | N (%)
    | 87 (1.04%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 63 (0.75%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 24 (0.29%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 36 (0.43%)  
    
    | 
    | 
    | Male
    | N (%)
    | 51 (0.61%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 22 (0.26%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 14 (0.17%)  
    
    | 
    | 
    | Male
    | N (%)
    | 10 (0.12%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 41 (0.49%)  
    
    | 1990-01-01 to 1990-12-31
    | overall
    | overall
    | N (%)
    | 106 (1.26%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 65 (0.77%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 41 (0.49%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 66 (0.79%)  
    
    | 
    | 
    | Female
    | N (%)
    | 40 (0.48%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 19 (0.23%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 21 (0.25%)  
    
    | 
    | 
    | Male
    | N (%)
    | 44 (0.52%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 22 (0.26%)  
    
    | 1991-01-01 to 1991-12-31
    | overall
    | overall
    | N (%)
    | 98 (1.17%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 39 (0.46%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 59 (0.70%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 36 (0.43%)  
    
    | 
    | 
    | Male
    | N (%)
    | 62 (0.74%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 42 (0.50%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 20 (0.24%)  
    
    | 
    | 
    | Female
    | N (%)
    | 19 (0.23%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 17 (0.20%)  
    
    | 1992-01-01 to 1992-12-31
    | overall
    | overall
    | N (%)
    | 222 (2.64%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 144 (1.71%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 78 (0.93%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 160 (1.90%)  
    
    | 
    | 
    | Female
    | N (%)
    | 62 (0.74%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 35 (0.42%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 27 (0.32%)  
    
    | 
    | 
    | Male
    | N (%)
    | 117 (1.39%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 43 (0.51%)  
    
    | 1993-01-01 to 1993-12-31
    | overall
    | overall
    | N (%)
    | 137 (1.63%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 41 (0.49%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 96 (1.14%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 72 (0.86%)  
    
    | 
    | 
    | Female
    | N (%)
    | 65 (0.77%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 18 (0.21%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 54 (0.64%)  
    
    | 
    | 
    | Female
    | N (%)
    | 42 (0.50%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 23 (0.27%)  
    
    | 1994-01-01 to 1994-12-31
    | overall
    | overall
    | N (%)
    | 132 (1.57%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 60 (0.71%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 72 (0.86%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 59 (0.70%)  
    
    | 
    | 
    | Male
    | N (%)
    | 73 (0.87%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 40 (0.48%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 33 (0.39%)  
    
    | 
    | 
    | Female
    | N (%)
    | 27 (0.32%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 32 (0.38%)  
    
    | 1995-01-01 to 1995-12-31
    | overall
    | overall
    | N (%)
    | 162 (1.93%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 90 (1.07%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 72 (0.86%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 99 (1.18%)  
    
    | 
    | 
    | Female
    | N (%)
    | 63 (0.75%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 57 (0.68%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 42 (0.50%)  
    
    | 
    | 
    | Female
    | N (%)
    | 30 (0.36%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 33 (0.39%)  
    
    | 1996-01-01 to 1996-12-31
    | overall
    | overall
    | N (%)
    | 173 (2.06%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 93 (1.11%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 80 (0.95%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 100 (1.19%)  
    
    | 
    | 
    | Female
    | N (%)
    | 73 (0.87%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 62 (0.74%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 38 (0.45%)  
    
    | 
    | 
    | Female
    | N (%)
    | 42 (0.50%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 31 (0.37%)  
    
    | 1997-01-01 to 1997-12-31
    | overall
    | overall
    | N (%)
    | 153 (1.82%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 82 (0.98%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 71 (0.85%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 90 (1.07%)  
    
    | 
    | 
    | Female
    | N (%)
    | 63 (0.75%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 57 (0.68%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 33 (0.39%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 25 (0.30%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 38 (0.45%)  
    
    | 1998-01-01 to 1998-12-31
    | overall
    | overall
    | N (%)
    | 178 (2.12%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 129 (1.54%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 49 (0.58%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 105 (1.25%)  
    
    | 
    | 
    | Female
    | N (%)
    | 73 (0.87%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 89 (1.06%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 16 (0.19%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 40 (0.48%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 33 (0.39%)  
    
    | 1999-01-01 to 1999-12-31
    | overall
    | overall
    | N (%)
    | 186 (2.21%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 120 (1.43%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 66 (0.79%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 73 (0.87%)  
    
    | 
    | 
    | Male
    | N (%)
    | 113 (1.35%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 28 (0.33%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 85 (1.01%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 38 (0.45%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 35 (0.42%)  
    
    | 2000-01-01 to 2000-12-31
    | overall
    | overall
    | N (%)
    | 194 (2.31%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 108 (1.29%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 86 (1.02%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 117 (1.39%)  
    
    | 
    | 
    | Female
    | N (%)
    | 77 (0.92%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 40 (0.48%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 37 (0.44%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 68 (0.81%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 49 (0.58%)  
    
    | 2001-01-01 to 2001-12-31
    | overall
    | overall
    | N (%)
    | 148 (1.76%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 76 (0.90%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 72 (0.86%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 82 (0.98%)  
    
    | 
    | 
    | Female
    | N (%)
    | 66 (0.79%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 49 (0.58%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 33 (0.39%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 27 (0.32%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 39 (0.46%)  
    
    | 2002-01-01 to 2002-12-31
    | overall
    | overall
    | N (%)
    | 148 (1.76%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 91 (1.08%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 57 (0.68%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 76 (0.90%)  
    
    | 
    | 
    | Male
    | N (%)
    | 72 (0.86%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 14 (0.17%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 58 (0.69%)  
    
    | 
    | 
    | Female
    | N (%)
    | 33 (0.39%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 43 (0.51%)  
    
    | 2003-01-01 to 2003-12-31
    | overall
    | overall
    | N (%)
    | 256 (3.05%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 70 (0.83%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 186 (2.21%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 106 (1.26%)  
    
    | 
    | 
    | Female
    | N (%)
    | 150 (1.79%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 97 (1.15%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 53 (0.63%)  
    
    | 
    | 
    | Male
    | N (%)
    | 17 (0.20%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 89 (1.06%)  
    
    | 2004-01-01 to 2004-12-31
    | overall
    | overall
    | N (%)
    | 202 (2.40%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 56 (0.67%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 146 (1.74%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 104 (1.24%)  
    
    | 
    | 
    | Male
    | N (%)
    | 98 (1.17%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 64 (0.76%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 40 (0.48%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 82 (0.98%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 16 (0.19%)  
    
    | 2005-01-01 to 2005-12-31
    | overall
    | overall
    | N (%)
    | 197 (2.35%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 134 (1.60%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 63 (0.75%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 120 (1.43%)  
    
    | 
    | 
    | Female
    | N (%)
    | 77 (0.92%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 99 (1.18%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 21 (0.25%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 35 (0.42%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 42 (0.50%)  
    
    | 2006-01-01 to 2006-12-31
    | overall
    | overall
    | N (%)
    | 238 (2.83%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 130 (1.55%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 108 (1.29%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 68 (0.81%)  
    
    | 
    | 
    | Male
    | N (%)
    | 170 (2.02%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 77 (0.92%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 93 (1.11%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 31 (0.37%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 37 (0.44%)  
    
    | 2007-01-01 to 2007-12-31
    | overall
    | overall
    | N (%)
    | 244 (2.90%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 142 (1.69%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 102 (1.21%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 97 (1.15%)  
    
    | 
    | 
    | Male
    | N (%)
    | 147 (1.75%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 62 (0.74%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 85 (1.01%)  
    
    | 
    | 
    | Female
    | N (%)
    | 57 (0.68%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 40 (0.48%)  
    
    | 2008-01-01 to 2008-12-31
    | overall
    | overall
    | N (%)
    | 229 (2.73%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 172 (2.05%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 57 (0.68%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 115 (1.37%)  
    
    | 
    | 
    | Female
    | N (%)
    | 114 (1.36%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 84 (1.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 31 (0.37%)  
    
    | 
    | 
    | Female
    | N (%)
    | 26 (0.31%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 88 (1.05%)  
    
    | 2009-01-01 to 2009-12-31
    | overall
    | overall
    | N (%)
    | 268 (3.19%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 54 (0.64%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 214 (2.55%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 138 (1.64%)  
    
    | 
    | 
    | Female
    | N (%)
    | 130 (1.55%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 105 (1.25%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 25 (0.30%)  
    
    | 
    | 
    | Male
    | N (%)
    | 29 (0.35%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 109 (1.30%)  
    
    | 2010-01-01 to 2010-12-31
    | overall
    | overall
    | N (%)
    | 304 (3.62%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 52 (0.62%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 252 (3.00%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 214 (2.55%)  
    
    | 
    | 
    | Female
    | N (%)
    | 90 (1.07%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 57 (0.68%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 33 (0.39%)  
    
    | 
    | 
    | Male
    | N (%)
    | 19 (0.23%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 195 (2.32%)  
    
    | 2011-01-01 to 2011-12-31
    | overall
    | overall
    | N (%)
    | 287 (3.42%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 82 (0.98%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 205 (2.44%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 165 (1.96%)  
    
    | 
    | 
    | Male
    | N (%)
    | 122 (1.45%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 45 (0.54%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 120 (1.43%)  
    
    | 
    | 
    | Male
    | N (%)
    | 85 (1.01%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 37 (0.44%)  
    
    | 2012-01-01 to 2012-12-31
    | overall
    | overall
    | N (%)
    | 205 (2.44%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 60 (0.71%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 145 (1.73%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 58 (0.69%)  
    
    | 
    | 
    | Male
    | N (%)
    | 147 (1.75%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 33 (0.39%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 25 (0.30%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 112 (1.33%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 35 (0.42%)  
    
    | 2013-01-01 to 2013-12-31
    | overall
    | overall
    | N (%)
    | 289 (3.44%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 67 (0.80%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 222 (2.64%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 215 (2.56%)  
    
    | 
    | 
    | Female
    | N (%)
    | 74 (0.88%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 65 (0.77%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 9 (0.11%)  
    
    | 
    | 
    | Male
    | N (%)
    | 58 (0.69%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 157 (1.87%)  
    
    | 2014-01-01 to 2014-12-31
    | overall
    | overall
    | N (%)
    | 341 (4.06%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 242 (2.88%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 99 (1.18%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 68 (0.81%)  
    
    | 
    | 
    | Male
    | N (%)
    | 273 (3.25%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 99 (1.18%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 174 (2.07%)  
    
    | 
    | 
    | Female
    | N (%)
    | 68 (0.81%)  
    
    | 2015-01-01 to 2015-12-31
    | overall
    | overall
    | N (%)
    | 419 (4.99%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 107 (1.27%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 312 (3.71%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 349 (4.15%)  
    
    | 
    | 
    | Female
    | N (%)
    | 70 (0.83%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 22 (0.26%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 48 (0.57%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 85 (1.01%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 264 (3.14%)  
    
    | 2016-01-01 to 2016-12-31
    | overall
    | overall
    | N (%)
    | 256 (3.05%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 59 (0.70%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 197 (2.35%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 189 (2.25%)  
    
    | 
    | 
    | Female
    | N (%)
    | 67 (0.80%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 67 (0.80%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 59 (0.70%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 130 (1.55%)  
    
    | 2017-01-01 to 2017-12-31
    | overall
    | overall
    | N (%)
    | 422 (5.02%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 68 (0.81%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 354 (4.21%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 44 (0.52%)  
    
    | 
    | 
    | Male
    | N (%)
    | 378 (4.50%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 44 (0.52%)  
    
    | 
    | 
    | Male
    | N (%)
    | 310 (3.69%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 68 (0.81%)  
    
    | 2018-01-01 to 2018-12-31
    | overall
    | overall
    | N (%)
    | 277 (3.30%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 193 (2.30%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 84 (1.00%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 156 (1.86%)  
    
    | 
    | 
    | Female
    | N (%)
    | 121 (1.44%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 72 (0.86%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 84 (1.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 121 (1.44%)  
    
    | 2019-01-01 to 2019-12-31
    | overall
    | overall
    | N (%)
    | 301 (3.58%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 301 (3.58%)  
    
    | 
    | overall
    | Male
    | N (%)
    | 186 (2.21%)  
    
    | 
    | 
    | Female
    | N (%)
    | 115 (1.37%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 115 (1.37%)  
    
    | 
    | 
    | Male
    | N (%)
    | 186 (2.21%)  
    
    | overall
    | overall
    | overall
    | N (%)
    | 8,400 (100.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 4,982 (59.31%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 3,418 (40.69%)  
    
    | 
    | overall
    | Female
    | N (%)
    | 3,377 (40.20%)  
    
    | 
    | 
    | Male
    | N (%)
    | 5,023 (59.80%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 1,843 (21.94%)  
    
    | 
    | 
    | Male
    | N (%)
    | 3,139 (37.37%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 1,534 (18.26%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1,884 (22.43%)  
    episode; observation_period
          
    Records in observation
    | 1953-01-01 to 1953-12-31
    | overall
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 1954-01-01 to 1954-12-31
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 1 (1.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 1 (1.00%)  
    
    | 1955-01-01 to 1955-12-31
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 1 (1.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 1 (1.00%)  
    
    | 1956-01-01 to 1956-12-31
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 1 (1.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 1957-01-01 to 1957-12-31
    | overall
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 1 (1.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 1958-01-01 to 1958-12-31
    | overall
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 2 (2.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 2 (2.00%)  
    
    | 1959-01-01 to 1959-12-31
    | overall
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 2 (2.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 2 (2.00%)  
    
    | 1960-01-01 to 1960-12-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 3 (3.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 3 (3.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 1961-01-01 to 1961-12-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 3 (3.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 3 (3.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 1962-01-01 to 1962-12-31
    | overall
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 3 (3.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 3 (3.00%)  
    
    | 1963-01-01 to 1963-12-31
    | overall
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 3 (3.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 3 (3.00%)  
    
    | 1964-01-01 to 1964-12-31
    | overall
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 3 (3.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 3 (3.00%)  
    
    | 1965-01-01 to 1965-12-31
    | overall
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 3 (3.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 3 (3.00%)  
    
    | 1966-01-01 to 1966-12-31
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 4 (4.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 4 (4.00%)  
    
    | 1967-01-01 to 1967-12-31
    | overall
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 5 (5.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 5 (5.00%)  
    
    | 1968-01-01 to 1968-12-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 1969-01-01 to 1969-12-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 1970-01-01 to 1970-12-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 1971-01-01 to 1971-12-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 1972-01-01 to 1972-12-31
    | overall
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 3 (3.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 8 (8.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 8 (8.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 1973-01-01 to 1973-12-31
    | overall
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 3 (3.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 8 (8.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 8 (8.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 1974-01-01 to 1974-12-31
    | overall
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 7 (7.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 1 (1.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 7 (7.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 1975-01-01 to 1975-12-31
    | overall
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 1 (1.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 5 (5.00%)  
    
    | 1976-01-01 to 1976-12-31
    | overall
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 7 (7.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 3 (3.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 5 (5.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 1977-01-01 to 1977-12-31
    | overall
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 7 (7.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 4 (4.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 2 (2.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 3 (3.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 5 (5.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 1978-01-01 to 1978-12-31
    | overall
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 7 (7.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 4 (4.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 4 (4.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 3 (3.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 3 (3.00%)  
    
    | 1979-01-01 to 1979-12-31
    | overall
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 8 (8.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 6 (6.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 3 (3.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 5 (5.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 4 (4.00%)  
    
    | 1980-01-01 to 1980-12-31
    | overall
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 9 (9.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 7 (7.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 5 (5.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 5 (5.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 4 (4.00%)  
    
    | 1981-01-01 to 1981-12-31
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 11 (11.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 7 (7.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 5 (5.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 5 (5.00%)  
    
    | 1982-01-01 to 1982-12-31
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 11 (11.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 7 (7.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 5 (5.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 5 (5.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 1983-01-01 to 1983-12-31
    | overall
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 10 (10.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 6 (6.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 3 (3.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 4 (4.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 3 (3.00%)  
    
    | 1984-01-01 to 1984-12-31
    | overall
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 10 (10.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 7 (7.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 4 (4.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 4 (4.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 3 (3.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 1985-01-01 to 1985-12-31
    | overall
    | overall
    | N (%)
    | 20 (20.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 10 (10.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 10 (10.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 6 (6.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 4 (4.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 4 (4.00%)  
    
    | 1986-01-01 to 1986-12-31
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 10 (10.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 11 (11.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 6 (6.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 7 (7.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 4 (4.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 4 (4.00%)  
    
    | 1987-01-01 to 1987-12-31
    | overall
    | overall
    | N (%)
    | 21 (21.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 10 (10.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 11 (11.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 3 (3.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 4 (4.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 8 (8.00%)  
    
    | 1988-01-01 to 1988-12-31
    | overall
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 10 (10.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 14 (14.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 10 (10.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 4 (4.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 4 (4.00%)  
    
    | 1989-01-01 to 1989-12-31
    | overall
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 11 (11.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 15 (15.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 5 (5.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 7 (7.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 4 (4.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 10 (10.00%)  
    
    | 1990-01-01 to 1990-12-31
    | overall
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 11 (11.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 15 (15.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 4 (4.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 6 (6.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 9 (9.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 7 (7.00%)  
    
    | 1991-01-01 to 1991-12-31
    | overall
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 11 (11.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 15 (15.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 12 (12.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 4 (4.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 8 (8.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 7 (7.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 7 (7.00%)  
    
    | 1992-01-01 to 1992-12-31
    | overall
    | overall
    | N (%)
    | 31 (31.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 13 (13.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 18 (18.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 7 (7.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 7 (7.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 11 (11.00%)  
    
    | 1993-01-01 to 1993-12-31
    | overall
    | overall
    | N (%)
    | 30 (30.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 13 (13.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 17 (17.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 10 (10.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 7 (7.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 7 (7.00%)  
    
    | 1994-01-01 to 1994-12-31
    | overall
    | overall
    | N (%)
    | 32 (32.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 14 (14.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 18 (18.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 16 (16.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 8 (8.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 10 (10.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 8 (8.00%)  
    
    | 1995-01-01 to 1995-12-31
    | overall
    | overall
    | N (%)
    | 31 (31.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 14 (14.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 17 (17.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 17 (17.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 8 (8.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 5 (5.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 9 (9.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 9 (9.00%)  
    
    | 1996-01-01 to 1996-12-31
    | overall
    | overall
    | N (%)
    | 31 (31.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 14 (14.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 17 (17.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 5 (5.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 8 (8.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 9 (9.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 9 (9.00%)  
    
    | 1997-01-01 to 1997-12-31
    | overall
    | overall
    | N (%)
    | 31 (31.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 13 (13.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 18 (18.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 13 (13.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 8 (8.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 8 (8.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 5 (5.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 10 (10.00%)  
    
    | 1998-01-01 to 1998-12-31
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 15 (15.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 19 (19.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 14 (14.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 9 (9.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 5 (5.00%)  
    
    | 1999-01-01 to 1999-12-31
    | overall
    | overall
    | N (%)
    | 32 (32.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 14 (14.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 18 (18.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 5 (5.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 4 (4.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 9 (9.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 14 (14.00%)  
    
    | 2000-01-01 to 2000-12-31
    | overall
    | overall
    | N (%)
    | 33 (33.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 14 (14.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 19 (19.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 9 (9.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 6 (6.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 5 (5.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 13 (13.00%)  
    
    | 2001-01-01 to 2001-12-31
    | overall
    | overall
    | N (%)
    | 32 (32.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 14 (14.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 18 (18.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 5 (5.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 14 (14.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 9 (9.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 4 (4.00%)  
    
    | 2002-01-01 to 2002-12-31
    | overall
    | overall
    | N (%)
    | 30 (30.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 13 (13.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 17 (17.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 23 (23.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 5 (5.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 15 (15.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 8 (8.00%)  
    
    | 2003-01-01 to 2003-12-31
    | overall
    | overall
    | N (%)
    | 36 (36.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 17 (17.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 19 (19.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 10 (10.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 7 (7.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 3 (3.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 16 (16.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 10 (10.00%)  
    
    | 2004-01-01 to 2004-12-31
    | overall
    | overall
    | N (%)
    | 38 (38.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 16 (16.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 22 (22.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 4 (4.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 5 (5.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 12 (12.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 17 (17.00%)  
    
    | 2005-01-01 to 2005-12-31
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 13 (13.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 22 (22.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 17 (17.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 4 (4.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 9 (9.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 5 (5.00%)  
    
    | 2006-01-01 to 2006-12-31
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 14 (14.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 21 (21.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 10 (10.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 17 (17.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 4 (4.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 4 (4.00%)  
    
    | 2007-01-01 to 2007-12-31
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 14 (14.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 21 (21.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 9 (9.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 26 (26.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 5 (5.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 10 (10.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 16 (16.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 4 (4.00%)  
    
    | 2008-01-01 to 2008-12-31
    | overall
    | overall
    | N (%)
    | 34 (34.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 14 (14.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 20 (20.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 4 (4.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 11 (11.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 16 (16.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 3 (3.00%)  
    
    | 2009-01-01 to 2009-12-31
    | overall
    | overall
    | N (%)
    | 35 (35.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 13 (13.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 22 (22.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 18 (18.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 11 (11.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 4 (4.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 2 (2.00%)  
    
    | 2010-01-01 to 2010-12-31
    | overall
    | overall
    | N (%)
    | 37 (37.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 13 (13.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 24 (24.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 30 (30.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 10 (10.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 4 (4.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 20 (20.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 3 (3.00%)  
    
    | 2011-01-01 to 2011-12-31
    | overall
    | overall
    | N (%)
    | 38 (38.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 12 (12.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 26 (26.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 30 (30.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 8 (8.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 21 (21.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 3 (3.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 9 (9.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 5 (5.00%)  
    
    | 2012-01-01 to 2012-12-31
    | overall
    | overall
    | N (%)
    | 36 (36.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 12 (12.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 24 (24.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 7 (7.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 3 (3.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 4 (4.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 9 (9.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 20 (20.00%)  
    
    | 2013-01-01 to 2013-12-31
    | overall
    | overall
    | N (%)
    | 33 (33.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 25 (25.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 8 (8.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 27 (27.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 7 (7.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 20 (20.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 5 (5.00%)  
    
    | 2014-01-01 to 2014-12-31
    | overall
    | overall
    | N (%)
    | 29 (29.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 21 (21.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 8 (8.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 5 (5.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 24 (24.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 16 (16.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 8 (8.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 5 (5.00%)  
    
    | 2015-01-01 to 2015-12-31
    | overall
    | overall
    | N (%)
    | 28 (28.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 21 (21.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 7 (7.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 6 (6.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 5 (5.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 1 (1.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 16 (16.00%)  
    
    | 2016-01-01 to 2016-12-31
    | overall
    | overall
    | N (%)
    | 22 (22.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 17 (17.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 5 (5.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 4 (4.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 14 (14.00%)  
    
    | 
    | <=20
    | Female
    | N (%)
    | 1 (1.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 3 (3.00%)  
    
    | 
    | >20
    | Female
    | N (%)
    | 4 (4.00%)  
    
    | 2017-01-01 to 2017-12-31
    | overall
    | overall
    | N (%)
    | 18 (18.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 16 (16.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 2 (2.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 15 (15.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 3 (3.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 13 (13.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 2 (2.00%)  
    
    | 2018-01-01 to 2018-12-31
    | overall
    | overall
    | N (%)
    | 14 (14.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 12 (12.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 2 (2.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 11 (11.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 3 (3.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 3 (3.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 9 (9.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 2 (2.00%)  
    
    | 2019-01-01 to 2019-12-31
    | overall
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 2 (2.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 4 (4.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 6 (6.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 4 (4.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 2 (2.00%)  
    
    | overall
    | overall
    | overall
    | N (%)
    | 100 (100.00%)  
    
    | 
    | 
    | Male
    | N (%)
    | 60 (60.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 40 (40.00%)  
    
    | 
    | <=20
    | overall
    | N (%)
    | 58 (58.00%)  
    
    | 
    | >20
    | overall
    | N (%)
    | 42 (42.00%)  
    
    | 
    | <=20
    | Male
    | N (%)
    | 34 (34.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 24 (24.00%)  
    
    | 
    | >20
    | Male
    | N (%)
    | 26 (26.00%)  
    
    | 
    | 
    | Female
    | N (%)
    | 16 (16.00%)  
      
    
    PatientProfiles::[mockDisconnect](https://darwin-eu.github.io/PatientProfiles/reference/mockDisconnect.html)(cdm = cdm)
    # }
    

## On this page

Developed by Marta Alcalde-Herraiz, Kim Lopez-Guell, Elin Rowlands, Cecilia Campanile, Edward Burn, Martí Català.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
