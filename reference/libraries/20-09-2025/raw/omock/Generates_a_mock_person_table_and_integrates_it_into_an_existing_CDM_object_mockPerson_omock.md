# Generates a mock person table and integrates it into an existing CDM object. — mockPerson • omock

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

# Generates a mock person table and integrates it into an existing CDM object.

Source: [`R/mockPerson.R`](https://github.com/ohdsi/omock/blob/main/R/mockPerson.R)

`mockPerson.Rd`

This function creates a mock person table with specified characteristics for each individual, including a randomly assigned date of birth within a given range and gender based on specified proportions. It populates the CDM object's person table with these entries, ensuring each record is uniquely identified.

## Usage
    
    
    mockPerson(
      cdm = [mockCdmReference](mockCdmReference.html)(),
      nPerson = 10,
      birthRange = [as.Date](https://rdrr.io/r/base/as.Date.html)([c](https://rdrr.io/r/base/c.html)("1950-01-01", "2000-12-31")),
      proportionFemale = 0.5,
      seed = NULL
    )

## Arguments

cdm
    

A `cdm_reference` object that serves as the base structure for adding the person table. This parameter should be an existing or newly created CDM object that does not yet contain a 'person' table.

nPerson
    

An integer specifying the number of mock persons to create in the person table. This defines the scale of the simulation and allows for the creation of datasets with varying sizes.

birthRange
    

A date range within which the birthdays of the mock persons will be randomly generated. This should be provided as a vector of two dates (`as.Date` format), specifying the start and end of the range.

proportionFemale
    

A numeric value between 0 and 1 indicating the proportion of the persons who are female. For example, a value of 0.5 means approximately 50% of the generated persons will be female. This helps simulate realistic demographic distributions.

seed
    

An optional integer used to set the seed for random number generation, ensuring reproducibility of the generated data. If provided, this seed allows the function to produce consistent results each time it is run with the same inputs. If 'NULL', the seed is not set, which can lead to different outputs on each run.

## Value

A modified `cdm` object with the new 'person' table added. This table includes simulated person data for each generated individual, with unique identifiers and demographic attributes.

## Examples
    
    
    # \donttest{
    [library](https://rdrr.io/r/base/library.html)([omock](https://ohdsi.github.io/omock/))
    cdm <- mockPerson(cdm = [mockCdmReference](mockCdmReference.html)(), nPerson = 10)
    
    # View the generated person data
    [print](https://rdrr.io/r/base/print.html)(cdm$person)
    #> # A tibble: 10 × 18
    #>    person_id gender_concept_id year_of_birth month_of_birth day_of_birth
    #>  *     <int>             <int>         <int>          <int>        <int>
    #>  1         1              8507          1990              8           19
    #>  2         2              8507          1958              5            8
    #>  3         3              8532          1997             10           14
    #>  4         4              8507          1984              6           22
    #>  5         5              8507          1997             11           18
    #>  6         6              8532          1972              9            1
    #>  7         7              8507          1958              1           31
    #>  8         8              8507          1970              2           21
    #>  9         9              8532          1965              9           17
    #> 10        10              8507          1999              6           26
    #> # ℹ 13 more variables: race_concept_id <int>, ethnicity_concept_id <int>,
    #> #   birth_datetime <dttm>, location_id <int>, provider_id <int>,
    #> #   care_site_id <int>, person_source_value <chr>, gender_source_value <chr>,
    #> #   gender_source_concept_id <int>, race_source_value <chr>,
    #> #   race_source_concept_id <int>, ethnicity_source_value <chr>,
    #> #   ethnicity_source_concept_id <int>
    # }
    
    

## On this page

Developed by Mike Du, Marti Catala, Edward Burn, Nuria Mercade-Besora, Xihang Chen.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
