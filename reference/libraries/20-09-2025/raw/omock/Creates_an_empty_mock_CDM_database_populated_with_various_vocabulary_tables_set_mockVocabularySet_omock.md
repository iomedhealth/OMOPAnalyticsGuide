# Creates an empty mock CDM database populated with various vocabulary tables set. — mockVocabularySet • omock

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

# Creates an empty mock CDM database populated with various vocabulary tables set.

Source: [`R/mockVocabularySet.R`](https://github.com/ohdsi/omock/blob/main/R/mockVocabularySet.R)

`mockVocabularySet.Rd`

This function create specified vocabulary tables to a CDM object. It can either populate the tables with provided data frames or initialize empty tables if no data is provided. This is useful for setting up a testing environment with controlled vocabulary data.

## Usage
    
    
    mockVocabularySet(cdm = [mockCdmReference](mockCdmReference.html)(), vocabularySet = "GiBleed")

## Arguments

cdm
    

A `cdm_reference` object that serves as the base structure for adding vocabulary tables. This should be an existing or a newly created CDM object, typically initialized without any vocabulary tables.

vocabularySet
    

A character string that specifies a prefix or a set name used to initialize mock data tables. This allows for customization of the source data or structure names when generating vocabulary tables.

## Value

Returns the modified `cdm` object with the provided vocabulary set tables.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    # Create a mock CDM reference and populate it with mock vocabulary tables
    cdm <- [mockCdmReference](mockCdmReference.html)() |> mockVocabularySet(vocabularySet = "GiBleed")
    #> ℹ Reading GiBleed tables.
    
    # View the names of the tables added to the CDM
    [names](https://rdrr.io/r/base/names.html)(cdm)
    #> [1] "person"               "observation_period"   "cdm_source"          
    #> [4] "concept"              "vocabulary"           "concept_relationship"
    #> [7] "concept_synonym"      "concept_ancestor"     "drug_strength"       
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
