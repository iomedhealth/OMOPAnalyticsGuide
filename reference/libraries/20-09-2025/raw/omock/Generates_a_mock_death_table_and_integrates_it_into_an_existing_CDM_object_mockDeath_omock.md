# Generates a mock death table and integrates it into an existing CDM object. — mockDeath • omock

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

# Generates a mock death table and integrates it into an existing CDM object.

Source: [`R/mockDeath.R`](https://github.com/ohdsi/omock/blob/main/R/mockDeath.R)

`mockDeath.Rd`

This function simulates death records for individuals within a specified cohort. It creates a realistic dataset by generating death records according to the specified number of records per person. The function ensures that each death record is associated with a valid person within the observation period to maintain the integrity of the data.

## Usage
    
    
    mockDeath(cdm, recordPerson = 1, seed = NULL)

## Arguments

cdm
    

A `cdm_reference` object that must already include 'person' and 'observation_period' tables.This object is the base CDM structure where the death data will be added. It is essential that the 'person' and 'observation_period' tables are populated as they provide necessary context for generating death records.

recordPerson
    

An integer specifying the expected number of death records to generate per person. This parameter helps simulate varying frequencies of death occurrences among individuals in the cohort, reflecting the variability seen in real-world medical data. Typically, this would be set to 1 or 0, assuming most datasets would only record a single death date per individual if at all.

seed
    

An optional integer used to set the seed for random number generation, ensuring reproducibility of the generated data. If provided, it allows the function to produce the same results each time it is run with the same inputs. If 'NULL', the seed is not set, which can result in different outputs on each run.

## Value

Returns the modified `cdm` object with the new 'death' table added. This table includes the simulated death data for each person, ensuring that each record is linked correctly to individuals in the ' person' table and falls within valid observation periods.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    # Create a mock CDM reference and add death records
    cdm <- [mockCdmReference](mockCdmReference.html)() |>
      [mockPerson](mockPerson.html)() |>
      [mockObservationPeriod](mockObservationPeriod.html)() |>
      mockDeath(recordPerson = 1)
    
    # View the generated death data
    [print](https://rdrr.io/r/base/print.html)(cdm$death)
    #> # A tibble: 10 × 7
    #>    person_id death_date death_type_concept_id death_datetime
    #>  *     <int> <date>                     <int> <dttm>        
    #>  1         7 2010-08-24                     1 NA            
    #>  2         4 2010-09-28                     1 NA            
    #>  3        10 2019-01-23                     1 NA            
    #>  4         1 2014-05-20                     1 NA            
    #>  5         8 2019-03-20                     1 NA            
    #>  6         5 2005-05-24                     1 NA            
    #>  7         3 2017-10-02                     1 NA            
    #>  8         9 2000-11-26                     1 NA            
    #>  9         2 1998-05-22                     1 NA            
    #> 10         6 2010-11-10                     1 NA            
    #> # ℹ 3 more variables: cause_concept_id <int>, cause_source_value <chr>,
    #> #   cause_source_concept_id <int>
    # }
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
