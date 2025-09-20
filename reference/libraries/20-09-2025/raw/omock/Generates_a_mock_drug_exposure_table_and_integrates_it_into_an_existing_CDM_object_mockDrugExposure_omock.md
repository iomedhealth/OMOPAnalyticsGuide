# Generates a mock drug exposure table and integrates it into an existing CDM object. — mockDrugExposure • omock

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

# Generates a mock drug exposure table and integrates it into an existing CDM object.

Source: [`R/mockDrugExposure.R`](https://github.com/ohdsi/omock/blob/main/R/mockDrugExposure.R)

`mockDrugExposure.Rd`

This function simulates drug exposure records for individuals within a specified cohort. It creates a realistic dataset by generating drug exposure records based on the specified number of records per person. Each drug exposure record is correctly associated with an individual within valid observation periods, ensuring the integrity of the data.

## Usage
    
    
    mockDrugExposure(cdm, recordPerson = 1, seed = NULL)

## Arguments

cdm
    

A `cdm_reference` object that must already include 'person' and 'observation_period' tables. This object serves as the base CDM structure where the drug exposure data will be added. The 'person' and 'observation_period' tables must be populated as they are necessary for generating accurate drug exposure records.

recordPerson
    

An integer specifying the expected number of drug exposure records to generate per person. This parameter allows for the simulation of varying drug usage frequencies among individuals in the cohort, reflecting real-world variability in medication administration.

seed
    

An optional integer used to set the seed for random number generation, ensuring reproducibility of the generated data. If provided, this seed enables the function to produce consistent results each time it is run with the same inputs. If 'NULL', the seed is not set, which can lead to different outputs on each run.

## Value

Returns the modified `cdm` object with the new 'drug_exposure' table added. This table includes the simulated drug exposure data for each person, ensuring that each record is correctly linked to individuals in the 'person' table and falls within valid observation periods.

## Examples
    
    
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    
    # Create a mock CDM reference and add drug exposure records
    cdm <- [mockCdmReference](mockCdmReference.html)() |>
      [mockPerson](mockPerson.html)() |>
      [mockObservationPeriod](mockObservationPeriod.html)() |>
      mockDrugExposure(recordPerson = 3)
    
    # View the generated drug exposure data
    [print](https://rdrr.io/r/base/print.html)(cdm$drug_exposure)
    #> # A tibble: 930 × 23
    #>    drug_concept_id person_id drug_exposure_start_date drug_exposure_end_date
    #>  *           <int>     <int> <date>                   <date>                
    #>  1         1361364         7 1984-05-20               1993-07-14            
    #>  2         1361364         5 2014-05-10               2016-10-19            
    #>  3         1361364         6 2008-08-31               2012-08-23            
    #>  4         1361364         8 1989-01-13               1989-07-15            
    #>  5         1361364         2 1988-09-14               2008-05-28            
    #>  6         1361364         1 2007-01-26               2007-02-26            
    #>  7         1361364         3 2019-10-11               2019-11-18            
    #>  8         1361364         1 2005-06-13               2006-12-10            
    #>  9         1361364         7 1983-03-31               1993-05-04            
    #> 10         1361364         7 1976-09-19               2001-08-10            
    #> # ℹ 920 more rows
    #> # ℹ 19 more variables: drug_exposure_id <int>, drug_type_concept_id <int>,
    #> #   drug_exposure_start_datetime <dttm>, drug_exposure_end_datetime <dttm>,
    #> #   verbatim_end_date <date>, stop_reason <chr>, refills <int>, quantity <dbl>,
    #> #   days_supply <int>, sig <chr>, route_concept_id <int>, lot_number <chr>,
    #> #   provider_id <int>, visit_occurrence_id <int>, visit_detail_id <int>,
    #> #   drug_source_value <chr>, drug_source_concept_id <int>, …
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
