# Adds mock concept data to a concept table within a Common Data Model (CDM) object. — mockConcepts • omock

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

# Adds mock concept data to a concept table within a Common Data Model (CDM) object.

Source: [`R/mockConcept.R`](https://github.com/ohdsi/omock/blob/main/R/mockConcept.R)

`mockConcepts.Rd`

This function inserts new concept entries into a specified domain within the concept table of a CDM object.It supports four domains: Condition, Drug, Measurement, and Observation. Existing entries with the same concept IDs will be overwritten, so caution should be used when adding data to prevent unintended data loss.

## Usage
    
    
    mockConcepts(cdm, conceptSet, domain = "Condition", seed = NULL)

## Arguments

cdm
    

A CDM object that represents a common data model containing at least a concept table.This object will be modified in-place to include the new or updated concept entries.

conceptSet
    

A numeric vector of concept IDs to be added or updated in the concept table.These IDs should be unique within the context of the provided domain to avoid unintended overwriting unless that is the intended effect.

domain
    

A character string specifying the domain of the concepts being added.Only accepts "Condition", "Drug", "Measurement", or "Observation". This defines under which category the concepts fall and affects which vocabulary is used for them.

seed
    

An optional integer value used to set the random seed for generating reproducible concept attributes like `vocabulary_id` and `concept_class_id`. Useful for testing or when consistent output is required.

## Value

Returns the modified CDM object with the updated concept table reflecting the newly added concepts.The function directly modifies the provided CDM object.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    
    # Create a mock CDM reference and add concepts in the 'Condition' domain
    cdm <- [mockCdmReference](mockCdmReference.html)() |> mockConcepts(
    conceptSet = [c](https://rdrr.io/r/base/c.html)(100, 200), domain = "Condition")
    
    # View the updated concept entries for the 'Condition' domain
    cdm$concept |> [filter](https://dplyr.tidyverse.org/reference/filter.html)(domain_id == "Condition")
    #> # A tibble: 21 × 10
    #>    concept_id concept_name              domain_id vocabulary_id concept_class_id
    #>         <dbl> <chr>                     <chr>     <chr>         <chr>           
    #>  1     194152 Renal agenesis and dysge… Condition SNOMED        Clinical Finding
    #>  2     444074 Victim of vehicular AND/… Condition SNOMED        Clinical Finding
    #>  3    4151660 Alkaline phosphatase bon… Condition SNOMED        Clinical Finding
    #>  4    4226696 Manic mood                Condition SNOMED        Clinical Finding
    #>  5    4304866 Elevated mood             Condition SNOMED        Clinical Finding
    #>  6   40475132 Arthropathies             Condition ICD10         ICD10 SubChapter
    #>  7   40475135 Other joint disorders     Condition ICD10         ICD10 SubChapter
    #>  8   45430573 Renal agenesis or dysgen… Condition Read          Read            
    #>  9   45511667 Manic mood                Condition Read          Read            
    #> 10   45533778 Other acquired deformiti… Condition ICD10         ICD10 Hierarchy 
    #> # ℹ 11 more rows
    #> # ℹ 5 more variables: standard_concept <chr>, concept_code <chr>,
    #> #   valid_start_date <date>, valid_end_date <date>, invalid_reason <chr>
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
