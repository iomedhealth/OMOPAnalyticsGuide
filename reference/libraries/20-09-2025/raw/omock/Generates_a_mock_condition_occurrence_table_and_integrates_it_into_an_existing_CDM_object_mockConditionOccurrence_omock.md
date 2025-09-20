# Generates a mock condition occurrence table and integrates it into an existing CDM object. — mockConditionOccurrence • omock

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

# Generates a mock condition occurrence table and integrates it into an existing CDM object.

Source: [`R/mockConditionOccurrence.R`](https://github.com/ohdsi/omock/blob/main/R/mockConditionOccurrence.R)

`mockConditionOccurrence.Rd`

This function simulates condition occurrences for individuals within a specified cohort. It helps create a realistic dataset by generating condition records for each person, based on the number of records specified per person.The generated data are aligned with the existing observation periods to ensure that all conditions are recorded within valid observation windows.

## Usage
    
    
    mockConditionOccurrence(cdm, recordPerson = 1, seed = NULL)

## Arguments

cdm
    

A `cdm_reference` object that should already include 'person', 'observation_period', and 'concept' tables.This object is the base CDM structure where the condition occurrence data will be added. It is essential that these tables are not empty as they provide the necessary context for generating condition data.

recordPerson
    

An integer specifying the expected number of condition records to generate per person.This parameter allows the simulation of varying frequencies of condition occurrences among individuals in the cohort, reflecting the variability seen in real-world medical data.

seed
    

An optional integer used to set the seed for random number generation, ensuring reproducibility of the generated data.If provided, it allows the function to produce the same results each time it is run with the same inputs.If 'NULL', the seed is not set, resulting in different outputs on each run.

## Value

Returns the modified `cdm` object with the new 'condition_occurrence' table added. This table includes the simulated condition data for each person, ensuring that each record is within the valid observation periods and linked to the correct individuals in the 'person' table.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    # Create a mock CDM reference and add condition occurrences
    cdm <- [mockCdmReference](mockCdmReference.html)() |>
      [mockPerson](mockPerson.html)() |>
      [mockObservationPeriod](mockObservationPeriod.html)() |>
      mockConditionOccurrence(recordPerson = 2)
    
    # View the generated condition occurrence data
    [print](https://rdrr.io/r/base/print.html)(cdm$condition_occurrence)
    #> # A tibble: 120 × 16
    #>    condition_concept_id person_id condition_start_date condition_end_date
    #>  *                <int>     <int> <date>               <date>            
    #>  1               194152         7 2009-08-10           2011-03-13        
    #>  2               194152         5 2003-08-02           2003-10-12        
    #>  3               194152         4 2004-07-07           2005-11-01        
    #>  4               194152         7 2006-04-14           2007-12-11        
    #>  5               194152        10 1985-01-27           1988-07-20        
    #>  6               194152         6 2009-02-13           2009-07-15        
    #>  7               194152         2 1975-08-05           1985-10-15        
    #>  8               194152         6 2008-10-13           2009-08-18        
    #>  9               194152         8 2019-11-22           2019-11-24        
    #> 10               194152         9 2014-06-19           2018-02-15        
    #> # ℹ 110 more rows
    #> # ℹ 12 more variables: condition_occurrence_id <int>,
    #> #   condition_type_concept_id <int>, condition_start_datetime <dttm>,
    #> #   condition_end_datetime <dttm>, condition_status_concept_id <int>,
    #> #   stop_reason <chr>, provider_id <int>, visit_occurrence_id <int>,
    #> #   visit_detail_id <int>, condition_source_value <chr>,
    #> #   condition_source_concept_id <int>, condition_status_source_value <chr>
    # }
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
