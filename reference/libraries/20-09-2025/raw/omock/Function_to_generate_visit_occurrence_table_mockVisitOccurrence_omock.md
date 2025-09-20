# Function to generate visit occurrence table — mockVisitOccurrence • omock

Skip to contents

[omock](../index.html) 0.5.0.9000

  * [Reference](../reference/index.html)
  * Articles
    * [Creating synthetic clinical tables](../articles/a01_Creating_synthetic_clinical_tables.html)
    * [Creating synthetic cohorts](../articles/a02_Creating_synthetic_cohorts.html)
    * [Creating synthetic vocabulary Tables with omock](../articles/a03_Creating_a_synthetic_vocabulary.html)
    * [Building a bespoke mock cdm](../articles/a04_Building_a_bespoke_mock_cdm.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/ohdsi/omock/)



![](../logo.png)

# Function to generate visit occurrence table

Source: [`R/mockVisitOccurrence.R`](https://github.com/ohdsi/omock/blob/main/R/mockVisitOccurrence.R)

`mockVisitOccurrence.Rd`

Function to generate visit occurrence table

## Usage
    
    
    mockVisitOccurrence(cdm, seed = NULL)

## Arguments

cdm
    

the CDM reference into which the mock visit occurrence table will be added

seed
    

A random seed to ensure reproducibility of the generated data.

## Value

A cdm reference with the visit_occurrence tables added

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
