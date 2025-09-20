# Generates a mock procedure occurrence table and integrates it into an existing CDM object. — mockProcedureOccurrence • omock

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

# Generates a mock procedure occurrence table and integrates it into an existing CDM object.

Source: [`R/mockProcedureOccurrence.R`](https://github.com/ohdsi/omock/blob/main/R/mockProcedureOccurrence.R)

`mockProcedureOccurrence.Rd`

This function simulates condition occurrences for individuals within a specified cohort. It helps create a realistic dataset by generating condition records for each person, based on the number of records specified per person.The generated data are aligned with the existing observation periods to ensure that all conditions are recorded within valid observation windows.

## Usage
    
    
    mockProcedureOccurrence(cdm, recordPerson = 1, seed = NULL)

## Arguments

cdm
    

A `cdm_reference` object that should already include 'person', 'observation_period', and 'concept' tables.This object is the base CDM structure where the procedure occurrence data will be added. It is essential that these tables are not empty as they provide the necessary context for generating condition data.

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
      mockProcedureOccurrence(recordPerson = 2)
    
    # View the generated condition occurrence data
    [print](https://rdrr.io/r/base/print.html)(cdm$procedure_occurrence)
    #> # A tibble: 20 × 15
    #>    procedure_concept_id person_id procedure_date procedure_end_date
    #>  *                <int>     <int> <date>         <date>            
    #>  1              4012925         5 2010-05-09     2010-09-15        
    #>  2              4012925         2 2013-03-03     2013-09-06        
    #>  3              4012925         9 2008-04-12     2012-05-20        
    #>  4              4012925         1 1980-12-14     1982-01-26        
    #>  5              4012925         9 1999-11-21     2012-01-02        
    #>  6              4012925         5 2000-12-14     2006-12-26        
    #>  7              4012925        10 2011-11-08     2012-04-16        
    #>  8              4012925         2 2011-01-23     2014-08-23        
    #>  9              4012925         9 2003-05-01     2011-06-08        
    #> 10              4012925         6 2008-06-29     2011-04-27        
    #> 11              4012925         4 2014-12-15     2015-01-01        
    #> 12              4012925         5 2010-01-26     2010-06-09        
    #> 13              4012925         9 2007-06-28     2008-04-30        
    #> 14              4012925         5 2001-03-14     2001-03-30        
    #> 15              4012925         7 1998-12-29     2013-02-14        
    #> 16              4012925         4 2014-11-10     2014-12-21        
    #> 17              4012925         3 1966-10-24     1967-04-05        
    #> 18              4012925         7 2012-10-07     2017-07-12        
    #> 19              4012925         9 2000-08-21     2000-12-03        
    #> 20              4012925         6 2011-12-16     2012-02-23        
    #> # ℹ 11 more variables: procedure_occurrence_id <int>,
    #> #   procedure_type_concept_id <int>, procedure_datetime <dttm>,
    #> #   modifier_concept_id <int>, quantity <int>, provider_id <int>,
    #> #   visit_occurrence_id <int>, visit_detail_id <int>,
    #> #   procedure_source_value <chr>, procedure_source_concept_id <int>,
    #> #   modifier_source_value <chr>
    # }
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
