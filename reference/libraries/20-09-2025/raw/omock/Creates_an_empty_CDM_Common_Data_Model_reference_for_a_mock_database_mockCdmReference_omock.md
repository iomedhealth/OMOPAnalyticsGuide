# Creates an empty CDM (Common Data Model) reference for a mock database. — mockCdmReference • omock

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

# Creates an empty CDM (Common Data Model) reference for a mock database.

Source: [`R/mockCdmReference.R`](https://github.com/ohdsi/omock/blob/main/R/mockCdmReference.R)

`mockCdmReference.Rd`

This function initializes an empty CDM reference with a specified name and populates it with mock vocabulary tables based on the provided vocabulary set. It is particularly useful for setting up a simulated environment for testing and development purposes within the OMOP CDM framework.

## Usage
    
    
    mockCdmReference(cdmName = "mock database", vocabularySet = "mock")

## Arguments

cdmName
    

A character string specifying the name of the CDM object to be created.This name can be used to identify the CDM object within a larger simulation or testing framework. Default is "mock database".

vocabularySet
    

A character string specifying the name of the vocabulary set to be used when creating the vocabulary tables for the CDM. Options are "mock" or "eunomia":

  * "mock": Provides a very small synthetic vocabulary subset, suitable for tests that do not require realistic vocabulary names or relationships.

  * "eunomia": Uses the vocabulary from the Eunomia test database, which contains real vocabularies available from ATHENA.




## Value

Returns a CDM object that is initially empty but includes mock vocabulary tables.The object structure is compliant with OMOP CDM standards, making it suitable for further population with mock data like person, visit, and observation records.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    # Create a new empty mock CDM reference
    cdm <- mockCdmReference()
    
    # Display the structure of the newly created CDM
    [print](https://rdrr.io/r/base/print.html)(cdm)
    #> 
    #> ── # OMOP CDM reference (local) of mock database ───────────────────────────────
    #> • omop tables: cdm_source, concept, concept_ancestor, concept_relationship,
    #> concept_synonym, drug_strength, observation_period, person, vocabulary
    #> • cohort tables: -
    #> • achilles tables: -
    #> • other tables: -
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
