# Database diagnostics • PhenotypeR

Skip to contents

[PhenotypeR](../index.html) 0.1.6

  * [Reference](../reference/index.html)
  * Articles
    * [Phenotype diagnostics](../articles/a01_PhenotypeDiagnostics.html)
    * [Shiny diagnostics](../articles/a02_ShinyDiagnostics.html)
    * [Database diagnostics](../articles/a03_DatabaseDiagnostics.html)
    * [Codelist diagnostics](../articles/a04_CodelistDiagnostics.html)
    * [Cohort diagnostics](../articles/a05_CohortDiagnostics.html)
    * [Population diagnostics](../articles/a07_PopulationDiagnostics.html)
    * [Phenotype expectations](../articles/phenotypeExpectations.html)


  * 


![](../logo.png)

# Database diagnostics

`a03_DatabaseDiagnostics.Rmd`

## Introduction

In this example we’re going to be using the Eunomia synthetic data.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([OmopSketch](https://OHDSI.github.io/OmopSketch/))
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                                    cdmName = "Eunomia Synpuf",
                                    cdmSchema   = "main",
                                    writeSchema = "main", 
                                    achillesSchema = "main")

## Database diagnostics

Although we may have created our study cohort, to inform analytic decisions and interpretation of results requires an understanding of the dataset from which it has been derived. The `[databaseDiagnostics()](../reference/databaseDiagnostics.html)` function will help us better understand a data source.

To run database diagnostics we just need to provide our cdm reference to the function.
    
    
    db_diagnostics <- [databaseDiagnostics](../reference/databaseDiagnostics.html)(cdm)

Database diagnostics builds on [OmopSketch](https://ohdsi.github.io/OmopSketch/index.html) package to perform the following analyses:

  * **Snapshot:** Summarises the meta data of a CDM object by using [summariseOmopSnapshot()](https://ohdsi.github.io/OmopSketch/reference/summariseOmopSnapshot.html)
  * **Observation periods:** Summarises the observation period table by using [summariseObservationPeriod()](https://ohdsi.github.io/OmopSketch/reference/summariseObservationPeriod.html). This will allow us to see if there are individuals with multiple, non-overlapping, observation periods and how long each observation period lasts on average.



The output is a summarised result object.

## Visualise the results

We can use [OmopSketch](https://ohdsi.github.io/OmopSketch/index.html) package functions to visualise the results obtained.

### Snapshot
    
    
    [tableOmopSnapshot](https://OHDSI.github.io/OmopSketch/reference/tableOmopSnapshot.html)(db_diagnostics)

Estimate |  Database name  
---|---  
Eunomia Synpuf  
General  
Snapshot date | 2025-07-22  
Person count | 1,000  
Vocabulary version | v5.0 06-AUG-21  
Observation period  
N | 1,048  
Start date | 2008-01-01  
End date | 2010-12-31  
Cdm  
Source name | Synpuf  
Version | v5.3.1  
Holder name | ohdsi  
Release date | 2018-03-15  
Description |   
Documentation reference |   
Source type | duckdb  
  
### Observation periods
    
    
    [tableObservationPeriod](https://OHDSI.github.io/OmopSketch/reference/tableObservationPeriod.html)(db_diagnostics)

Observation period ordinal | Variable name | Estimate name |  CDM name  
---|---|---|---  
Eunomia Synpuf  
all | Number records | N | 1,048  
| Number subjects | N | 1,000  
| Records per person | mean (sd) | 1.05 (0.21)  
|  | median [Q25 - Q75] | 1 [1 - 1]  
| Duration in days | mean (sd) | 979.71 (262.79)  
|  | median [Q25 - Q75] | 1,096 [1,096 - 1,096]  
| Days to next observation period | mean (sd) | 172.17 (108.35)  
|  | median [Q25 - Q75] | 138 [93 - 254]  
1st | Number subjects | N | 1,000  
| Duration in days | mean (sd) | 994.16 (257.95)  
|  | median [Q25 - Q75] | 1,096 [1,096 - 1,096]  
| Days to next observation period | mean (sd) | 172.17 (108.35)  
|  | median [Q25 - Q75] | 138 [93 - 254]  
2nd | Number subjects | N | 48  
| Duration in days | mean (sd) | 678.60 (164.50)  
|  | median [Q25 - Q75] | 730 [730 - 730]  
| Days to next observation period | mean (sd) | -  
|  | median [Q25 - Q75] | -  
  
## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
