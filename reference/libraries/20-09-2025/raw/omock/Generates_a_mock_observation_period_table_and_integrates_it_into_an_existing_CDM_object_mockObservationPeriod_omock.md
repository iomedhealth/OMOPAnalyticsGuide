# Generates a mock observation period table and integrates it into an existing CDM object. — mockObservationPeriod • omock

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

# Generates a mock observation period table and integrates it into an existing CDM object.

Source: [`R/mockObservationPeriod.R`](https://github.com/ohdsi/omock/blob/main/R/mockObservationPeriod.R)

`mockObservationPeriod.Rd`

This function simulates observation periods for individuals based on their date of birth recorded in the 'person' table of the CDM object. It assigns random start and end dates for each observation period within a realistic timeframe up to a specified or default maximum date.

## Usage
    
    
    mockObservationPeriod(cdm, seed = NULL)

## Arguments

cdm
    

A `cdm_reference` object that must include a 'person' table with valid dates of birth. This object serves as the base CDM structure where the observation period data will be added. The function checks to ensure that the 'person' table is populated and uses the date of birth to generate observation periods.

seed
    

An optional integer used to set the seed for random number generation, ensuring reproducibility of the generated data. If provided, this seed allows the function to produce consistent results each time it is run with the same inputs. If 'NULL', the seed is not set, which can lead to different outputs on each run.

## Value

Returns the modified `cdm` object with the new 'observation_period' table added. This table includes the simulated observation periods for each person, ensuring that each record spans a realistic timeframe based on the person's date of birth.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    # Create a mock CDM reference and add observation periods
    cdm <- [mockCdmReference](mockCdmReference.html)() |>
      [mockPerson](mockPerson.html)(nPerson = 100) |>
      mockObservationPeriod()
    
    # View the generated observation period data
    [print](https://rdrr.io/r/base/print.html)(cdm$observation_period)
    #> # A tibble: 100 × 5
    #>    observation_period_id person_id observation_period_s…¹ observation_period_e…²
    #>  *                 <int>     <int> <date>                 <date>                
    #>  1                     1         1 2004-04-30             2019-03-17            
    #>  2                     2         2 2013-01-25             2014-09-22            
    #>  3                     3         3 1985-07-14             2014-08-12            
    #>  4                     4         4 1997-11-25             2009-02-10            
    #>  5                     5         5 1985-04-02             2007-08-04            
    #>  6                     6         6 1960-09-30             1965-02-23            
    #>  7                     7         7 2017-10-17             2018-12-02            
    #>  8                     8         8 2001-08-07             2016-10-19            
    #>  9                     9         9 2007-09-23             2009-12-12            
    #> 10                    10        10 1999-07-26             2010-01-13            
    #> # ℹ 90 more rows
    #> # ℹ abbreviated names: ¹​observation_period_start_date,
    #> #   ²​observation_period_end_date
    #> # ℹ 1 more variable: period_type_concept_id <int>
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
