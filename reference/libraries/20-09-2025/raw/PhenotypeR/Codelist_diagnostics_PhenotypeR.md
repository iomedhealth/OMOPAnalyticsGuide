# Codelist diagnostics • PhenotypeR

Skip to contents

[PhenotypeR](../index.html) 0.1.6

  * [Reference](../reference/index.html)
  * Articles
    * [Phenotype diagnostics](../articles/a01_PhenotypeDiagnostics.html)
    * [Shiny diagnostics](../articles/a02_ShinyDiagnostics.html)
    * [Database diagnostics](../articles/a03_DatabaseDiagnostics.html)
    * [Codelist diagnostics](../articles/a04_CodelistDiagnostics.html)
    * [Cohort diagnostics](../articles/a05_CohortDiagnostics.html)
    * [Population diagnostics](../articles/a07_PopulationDiagnostics.html)
    * [Phenotype expectations](../articles/phenotypeExpectations.html)


  * 


![](../logo.png)

# Codelist diagnostics

`a04_CodelistDiagnostics.Rmd`

## Introduction

In this example we’re going to summarise the characteristics of individuals with an ankle sprain, ankle fracture, forearm fracture, a hip fracture and different measurements using the Eunomia synthetic data.

We’ll begin by creating our study cohorts.
    
    
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([CohortConstructor](https://ohdsi.github.io/CohortConstructor/))
    [library](https://rdrr.io/r/base/library.html)([CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/))
    [library](https://rdrr.io/r/base/library.html)([PhenotypeR](https://ohdsi.github.io/PhenotypeR/))
    [library](https://rdrr.io/r/base/library.html)(MeasurementDiagnostics)
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org))
    [library](https://rdrr.io/r/base/library.html)([ggplot2](https://ggplot2.tidyverse.org))
    
    con <- DBI::[dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)(duckdb::[duckdb](https://r.duckdb.org/reference/duckdb.html)(), 
                          CDMConnector::[eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)("synpuf-1k", "5.3"))
    cdm <- CDMConnector::[cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(con = con, 
                                    cdmName = "Eunomia Synpuf",
                                    cdmSchema   = "main",
                                    writeSchema = "main", 
                                    achillesSchema = "main")
    
    cdm$injuries <- [conceptCohort](https://ohdsi.github.io/CohortConstructor/reference/conceptCohort.html)(cdm = cdm,
      conceptSet = [list](https://rdrr.io/r/base/list.html)(
        "ankle_sprain" = 81151,
        "ankle_fracture" = 4059173,
        "forearm_fracture" = 4278672,
        "hip_fracture" = 4230399,
        "measurements_cohort" = [c](https://rdrr.io/r/base/c.html)(40660437L, 2617206L, 4034850L,  2617239L, 4098179L)
      ),
      name = "injuries")
    cdm$injuries |> 
      [glimpse](https://pillar.r-lib.org/reference/glimpse.html)()
    #> Rows: ??
    #> Columns: 4
    #> Database: DuckDB v1.3.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.1//tmp/RtmpsGR7XW/file234542b5c5e7.duckdb]
    #> $ cohort_definition_id <int> 5, 5, 5, 5, 5, 2, 2, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5…
    #> $ subject_id           <int> 592, 848, 481, 898, 1238, 480, 245, 278, 863, 828…
    #> $ cohort_start_date    <date> 2009-07-23, 2010-02-18, 2009-11-14, 2010-01-07, …
    #> $ cohort_end_date      <date> 2009-07-23, 2010-02-18, 2009-11-14, 2010-01-07, …

## Summarising code use

To get a good understanding of the codes we’ve used to define our cohorts we can use the `[codelistDiagnostics()](../reference/codelistDiagnostics.html)` function.
    
    
    code_diag <- [codelistDiagnostics](../reference/codelistDiagnostics.html)(cdm$injuries)

Codelist diagnostics builds on [CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/) and [MeasurementDiagnostics](https://ohdsi.github.io/MeasurementDiagnostics/) R packages to perform the following analyses:

  * **Achilles code use:** Which summarises the counts of our codes in our database based on achilles results using [summariseAchillesCodeUse()](https://darwin-eu.github.io/CodelistGenerator/reference/summariseAchillesCodeUse.html).
  * **Orphan code use:** Orphan codes refer to codes that we did not include in our cohort definition, but that have any relationship with the codes in our codelist. So, although many can be false positives, we may identify some codes that we may want to use in our cohort definitions. This analysis uses [summariseOrphanCodes()](https://darwin-eu.github.io/CodelistGenerator/reference/summariseOrphanCodes.html).
  * **Cohort code use:** Summarises the cohort code use in our cohort using [summariseCohortCodeUse()](https://darwin-eu.github.io/CodelistGenerator/reference/summariseCohortCodeUse.html).
  * **Measurement diagnostics:** If any of the concepts used in our codelist is a measurement, it summarises its code use using [summariseCohortMeasurementUse()](https://ohdsi.github.io/MeasurementDiagnostics/reference/summariseCohortMeasurementUse.html).



The output of a function is a summarised result table.

### Add codelist attribute

Some cohorts that may be created manually may not have the codelists recorded in the `cohort_codelist` attribute. The package has a utility function to record a codelist in a `cohort_table` object:
    
    
    [cohortCodelist](https://darwin-eu.github.io/omopgenerics/reference/cohortCodelist.html)(cdm$injuries, cohortId = 1)
    #> 
    #> - ankle_fracture (1 codes)
    cdm$injuries <- cdm$injuries |>
      [addCodelistAttribute](../reference/addCodelistAttribute.html)(codelist = [list](https://rdrr.io/r/base/list.html)(new_codelist = [c](https://rdrr.io/r/base/c.html)(1L, 2L)), cohortName = "ankle_fracture")
    [cohortCodelist](https://darwin-eu.github.io/omopgenerics/reference/cohortCodelist.html)(cdm$injuries, cohortId = 1)
    #> 
    #> - new_codelist (2 codes)

## Visualise the results

We will now use different functions to visualise the results generated by CohortDiagnostics. Notice that these functions are from [CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/) and [MeasurementDiagnostics](https://ohdsi.github.io/MeasurementDiagnostics/) R packages packages.

### Achilles code use
    
    
    [tableAchillesCodeUse](https://darwin-eu.github.io/CodelistGenerator/reference/tableAchillesCodeUse.html)(code_diag)

|  Database name  
---|---  
|  Eunomia Synpuf  
Codelist name | Domain ID | Standard concept name | Standard concept ID | Standard concept | Vocabulary ID |  Estimate name  
Record count | Person count  
ankle_sprain | condition | Sprain of ankle | 81151 | standard | SNOMED | 31 | 27  
measurements_cohort | measurement | Prostate cancer screening; prostate specific antigen test (psa) | 2617206 | standard | HCPCS | 146 | 124  
|  | Screening cytopathology, cervical or vaginal (any reporting system), collected in preservative fluid, automated thin layer preparation, with screening by automated system and manual rescreening under physician supervision | 2617239 | standard | HCPCS | 52 | 47  
|  | Laboratory test | 4034850 | standard | SNOMED | 101 | 95  
|  | Drug screen, qualitative; multiple drug classes by high complexity test method (e.g., immunoassay, enzyme assay), per patient encounter | 40660437 | standard | HCPCS | 45 | 26  
|  | Immunology laboratory test | 4098179 | standard | SNOMED | 20 | 20  
  
### Orphan code use
    
    
    [tableOrphanCodes](https://darwin-eu.github.io/CodelistGenerator/reference/tableOrphanCodes.html)(code_diag)

|  Database name  
---|---  
|  Eunomia Synpuf  
Codelist name | Domain ID | Standard concept name | Standard concept ID | Standard concept | Vocabulary ID |  Estimate name  
Record count | Person count  
ankle_fracture | condition | Open fracture of medial malleolus | 432749 | standard | SNOMED | 3 | 3  
|  | Open fracture of lateral malleolus | 437998 | standard | SNOMED | 3 | 3  
|  | Closed bimalleolar fracture | 438879 | standard | SNOMED | 9 | 7  
|  | Closed fracture of medial malleolus | 439162 | standard | SNOMED | 4 | 3  
|  | Open bimalleolar fracture | 441154 | standard | SNOMED | 1 | 1  
|  | Closed trimalleolar fracture | 441155 | standard | SNOMED | 5 | 4  
|  | Closed fracture of lateral malleolus | 441428 | standard | SNOMED | 21 | 12  
|  | Closed fracture of talus | 74777 | standard | SNOMED | 2 | 2  
|  | Closed fracture of ankle | 75095 | standard | SNOMED | 19 | 16  
|  | Open fracture of talus | 77131 | standard | SNOMED | 2 | 2  
|  | Open fracture of ankle | 78888 | standard | SNOMED | 5 | 4  
ankle_sprain | condition | Sprain of distal tibiofibular ligament | 73889 | standard | SNOMED | 4 | 4  
|  | Sprain of calcaneofibular ligament | 75667 | standard | SNOMED | 1 | 1  
|  | Sprain of deltoid ligament of ankle | 77707 | standard | SNOMED | 4 | 4  
forearm_fracture | condition | Closed fracture of shaft of bone of forearm | 4101989 | standard | SNOMED | 1 | 1  
|  | Open fracture of shaft of bone of forearm | 4195752 | standard | SNOMED | 2 | 2  
|  | Open fracture of neck of radius | 432744 | standard | SNOMED | 1 | 1  
|  | Open fracture of lower end of radius AND ulna | 432747 | standard | SNOMED | 1 | 1  
|  | Open fracture of proximal end of ulna | 433047 | standard | SNOMED | 2 | 2  
|  | Open fracture of shaft of ulna | 433333 | standard | SNOMED | 1 | 1  
|  | Open Colles' fracture | 434767 | standard | SNOMED | 2 | 2  
|  | Open fracture of upper end of forearm | 434771 | standard | SNOMED | 1 | 1  
|  | Closed fracture of distal end of ulna | 435374 | standard | SNOMED | 4 | 3  
|  | Closed fracture of radius AND ulna | 435380 | standard | SNOMED | 6 | 6  
|  | Closed Colles' fracture | 435950 | standard | SNOMED | 20 | 13  
|  | Closed fracture of proximal end of ulna | 436251 | standard | SNOMED | 1 | 1  
|  | Closed fracture of ulna | 436541 | standard | SNOMED | 1 | 1  
|  | Closed fracture of shaft of radius | 436826 | standard | SNOMED | 2 | 2  
|  | Closed fracture of neck of radius | 436837 | standard | SNOMED | 3 | 2  
|  | Closed fracture of distal end of radius | 437116 | standard | SNOMED | 48 | 33  
|  | Open fracture of lower end of forearm | 437122 | standard | SNOMED | 1 | 1  
|  | Open fracture of upper end of radius AND ulna | 437393 | standard | SNOMED | 1 | 1  
|  | Closed fracture of lower end of forearm | 437394 | standard | SNOMED | 4 | 3  
|  | Closed fracture of shaft of ulna | 437400 | standard | SNOMED | 1 | 1  
|  | Open fracture of ulna | 438576 | standard | SNOMED | 1 | 1  
|  | Closed fracture of radius | 439166 | standard | SNOMED | 11 | 7  
|  | Closed fracture of upper end of forearm | 439940 | standard | SNOMED | 4 | 3  
|  | Pathological fracture - forearm | 440511 | standard | SNOMED | 1 | 1  
|  | Closed fracture of lower end of radius AND ulna | 440538 | standard | SNOMED | 6 | 5  
|  | Closed fracture of upper end of radius AND ulna | 440544 | standard | SNOMED | 6 | 2  
|  | Open fracture of distal end of radius | 440546 | standard | SNOMED | 3 | 3  
|  | Open fracture of forearm | 440851 | standard | SNOMED | 1 | 1  
|  | Closed fracture of proximal end of radius | 441973 | standard | SNOMED | 3 | 3  
|  | Closed fracture of forearm | 441974 | standard | SNOMED | 1 | 1  
|  | Fracture of radius AND ulna | 442598 | standard | SNOMED | 1 | 1  
|  | Torus fracture of radius | 443428 | standard | SNOMED | 1 | 1  
|  | Closed fracture of olecranon process of ulna | 73036 | standard | SNOMED | 7 | 5  
|  | Closed fracture of head of radius | 73341 | standard | SNOMED | 6 | 4  
|  | Open fracture of coronoid process of ulna | 74192 | standard | SNOMED | 1 | 1  
|  | Open fracture of olecranon process of ulna | 74763 | standard | SNOMED | 4 | 4  
|  | Closed Monteggia's fracture | 79165 | standard | SNOMED | 1 | 1  
|  | Closed fracture of coronoid process of ulna | 79172 | standard | SNOMED | 2 | 2  
|  | Open Monteggia's fracture | 81148 | standard | SNOMED | 1 | 1  
hip_fracture | condition | Closed intertrochanteric fracture | 136834 | standard | SNOMED | 56 | 38  
|  | Closed fracture proximal femur, subtrochanteric | 4009610 | standard | SNOMED | 12 | 9  
|  | Closed fracture of neck of femur | 434500 | standard | SNOMED | 144 | 77  
|  | Closed fracture of base of neck of femur | 435956 | standard | SNOMED | 15 | 10  
|  | Closed fracture of midcervical section of femur | 436247 | standard | SNOMED | 16 | 14  
|  | Closed fracture of intracapsular section of femur | 437703 | standard | SNOMED | 8 | 7  
|  | Closed transcervical fracture of femur | 440556 | standard | SNOMED | 20 | 17  
|  | Closed fracture of acetabulum | 81696 | standard | SNOMED | 10 | 6  
measurements_cohort | procedure | Antibody screen, RBC, each serum technique | 2212937 | standard | CPT4 | 55 | 53  
|  | Antibody identification, RBC antibodies, each panel for each serum technique | 2212939 | standard | CPT4 | 1 | 1  
|  | Pathology consultation during surgery; cytologic examination (eg, touch prep, squash prep), initial site | 2213298 | standard | CPT4 | 3 | 3  
| measurement | Screening cytopathology, cervical or vaginal (any reporting system), collected in preservative fluid, automated thin layer preparation, requiring interpretation by physician | 2617226 | standard | HCPCS | 1 | 1  
|  | Screening cytopathology smears, cervical or vaginal, performed by automated system with manual rescreening | 2617241 | standard | HCPCS | 1 | 1  
|  | Wet mounts, including preparations of vaginal, cervical or skin specimens | 2720582 | standard | HCPCS | 1 | 1  
|  | Detection of parasite | 4047338 | standard | SNOMED | 3 | 3  
|  | Antenatal RhD antibody screening | 4060266 | standard | SNOMED | 8 | 8  
|  | Type 1 hypersensitivity skin test | 4091110 | standard | SNOMED | 3 | 3  
|  | Hematology screening test | 4198132 | standard | SNOMED | 20 | 20  
|  | Sickle cell disease screening test | 4199173 | standard | SNOMED | 9 | 9  
|  | Microscopic examination of cervical Papanicolaou smear | 4208622 | standard | SNOMED | 10 | 10  
|  | Genetic test | 4237017 | standard | SNOMED | 23 | 23  
|  | Blood group typing | 4258677 | standard | SNOMED | 14 | 14  
|  | Microscopic examination of vaginal Papanicolaou smear | 4258831 | standard | SNOMED | 22 | 22  
  
### Cohort code use
    
    
    [tableCohortCodeUse](https://darwin-eu.github.io/CodelistGenerator/reference/tableCohortCodeUse.html)(code_diag)

|  Database name  
---|---  
|  Eunomia Synpuf  
Cohort name | Codelist name | Standard concept name | Standard concept ID | Source concept name | Source concept ID | Source concept value | Domain ID |  Estimate name  
Person count | Record count  
ankle_sprain | ankle_sprain | Sprain of ankle | 81151 | Other sprains and strains of ankle | 44829371 | 84509 | condition | 6 | 6  
|  |  |  | Sprain of ankle, unspecified site | 44820150 | 84500 | condition | 23 | 25  
|  | overall | - | NA | NA | NA | NA | 27 | 31  
measurements_cohort | measurements_cohort | Drug screen, qualitative; multiple drug classes by high complexity test method (e.g., immunoassay, enzyme assay), per patient encounter | 40660437 | Drug screen, qualitative; multiple drug classes by high complexity test method (e.g., immunoassay, enzyme assay), per patient encounter | 40660437 | G0431 | measurement | 26 | 45  
|  | Immunology laboratory test | 4098179 | Antibody response examination | 44830850 | V7261 | measurement | 11 | 11  
|  |  |  | Other and unspecified nonspecific immunological findings | 44830461 | 79579 | measurement | 9 | 9  
|  | Laboratory test | 4034850 | Laboratory examination | 44836706 | V726 | measurement | 45 | 48  
|  |  |  | Laboratory examination ordered as part of a routine general medical examination | 44823881 | V7262 | measurement | 14 | 14  
|  |  |  | Laboratory examination, unspecified | 44835527 | V7260 | measurement | 16 | 16  
|  |  |  | Other laboratory examination | 44835528 | V7269 | measurement | 13 | 13  
|  |  |  | Pre-procedural laboratory examination | 44827407 | V7263 | measurement | 10 | 10  
|  | Prostate cancer screening; prostate specific antigen test (psa) | 2617206 | Prostate cancer screening; prostate specific antigen test (psa) | 2617206 | G0103 | measurement | 124 | 146  
|  | Screening cytopathology, cervical or vaginal (any reporting system), collected in preservative fluid, automated thin layer preparation, with screening by automated system and manual rescreening under physician supervision | 2617239 | Screening cytopathology, cervical or vaginal (any reporting system), collected in preservative fluid, automated thin layer preparation, with screening by automated system and manual rescreening under physician supervision | 2617239 | G0145 | measurement | 47 | 52  
|  | overall | - | NA | NA | NA | NA | 255 | 364  
  
### Measurement timings
    
    
    [tableMeasurementTimings](https://rdrr.io/pkg/MeasurementDiagnostics/man/tableMeasurementTimings.html)(code_diag)

CDM name | Cohort name | Variable name | Estimate name | Estimate value  
---|---|---|---|---  
measurements_cohort  
Eunomia Synpuf | measurements_cohort | Number records | N | 364  
|  | Number subjects | N | 255  
|  | Time | Median [Q25 - Q75] | 150.00 [19.00 - 356.00]  
|  |  | Range | 0.00 to 930.00  
|  | Measurements per subject | Median [Q25 - Q75] | 2.00 [1.00 - 2.00]  
|  |  | Range | 1.00 to 10.00  
      
    
    [plotMeasurementTimings](https://rdrr.io/pkg/MeasurementDiagnostics/man/plotMeasurementTimings.html)(code_diag)

![](a04_CodelistDiagnostics_files/figure-html/unnamed-chunk-9-1.png)

### Measurement value as concept
    
    
    [tableMeasurementValueAsConcept](https://rdrr.io/pkg/MeasurementDiagnostics/man/tableMeasurementValueAsConcept.html)(code_diag)

CDM name | Cohort name | Concept name | Concept ID | Domain ID | Variable name | Value as concept name | Value as concept ID | Estimate name | Estimate value  
---|---|---|---|---|---|---|---|---|---  
measurements_cohort  
Eunomia Synpuf | measurements_cohort | overall | overall | overall | Value as concept name | No matching concept | 0 | N (%) | 364 (100.00%)  
|  | Laboratory test | 4034850 | Measurement | Value as concept name | No matching concept | 0 | N (%) | 101 (100.00%)  
|  | Prostate cancer screening; prostate specific antigen test (psa) | 2617206 | Measurement | Value as concept name | No matching concept | 0 | N (%) | 146 (100.00%)  
|  | Drug screen, qualitative; multiple drug classes by high complexity test method (e.g., immunoassay, enzyme assay), per patient encounter | 40660437 | Measurement | Value as concept name | No matching concept | 0 | N (%) | 45 (100.00%)  
|  | Immunology laboratory test | 4098179 | Measurement | Value as concept name | No matching concept | 0 | N (%) | 20 (100.00%)  
|  | Screening cytopathology, cervical or vaginal (any reporting system), collected in preservative fluid, automated thin layer preparation, with screening by automated system and manual rescreening under physician supervision | 2617239 | Measurement | Value as concept name | No matching concept | 0 | N (%) | 52 (100.00%)  
      
    
    [plotMeasurementValueAsConcept](https://rdrr.io/pkg/MeasurementDiagnostics/man/plotMeasurementValueAsConcept.html)(code_diag)

![](a04_CodelistDiagnostics_files/figure-html/unnamed-chunk-11-1.png)

### Measurement value as numeric
    
    
    [tableMeasurementValueAsNumeric](https://rdrr.io/pkg/MeasurementDiagnostics/man/tableMeasurementValueAsNumeric.html)(code_diag)

CDM name | Cohort name | Concept name | Concept ID | Domain ID | Unit concept name | Unit concept ID | Estimate name | Estimate value  
---|---|---|---|---|---|---|---|---  
measurements_cohort  
Eunomia Synpuf | measurements_cohort | overall | overall | overall | No matching concept | 0 | N | 364  
|  |  |  |  |  |  | Median [Q25 - Q75] | -  
|  |  |  |  |  |  | Range | -  
|  |  |  |  |  |  | Missing value, N (%) | 364 (100.00%)  
|  | Prostate cancer screening; prostate specific antigen test (psa) | 2617206 | Measurement | No matching concept | 0 | N | 146  
|  |  |  |  |  |  | Median [Q25 - Q75] | -  
|  |  |  |  |  |  | Range | -  
|  |  |  |  |  |  | Missing value, N (%) | 146 (100.00%)  
|  | Laboratory test | 4034850 | Measurement | No matching concept | 0 | N | 101  
|  |  |  |  |  |  | Median [Q25 - Q75] | -  
|  |  |  |  |  |  | Range | -  
|  |  |  |  |  |  | Missing value, N (%) | 101 (100.00%)  
|  | Screening cytopathology, cervical or vaginal (any reporting system), collected in preservative fluid, automated thin layer preparation, with screening by automated system and manual rescreening under physician supervision | 2617239 | Measurement | No matching concept | 0 | N | 52  
|  |  |  |  |  |  | Median [Q25 - Q75] | -  
|  |  |  |  |  |  | Range | -  
|  |  |  |  |  |  | Missing value, N (%) | 52 (100.00%)  
|  | Drug screen, qualitative; multiple drug classes by high complexity test method (e.g., immunoassay, enzyme assay), per patient encounter | 40660437 | Measurement | No matching concept | 0 | N | 45  
|  |  |  |  |  |  | Median [Q25 - Q75] | -  
|  |  |  |  |  |  | Range | -  
|  |  |  |  |  |  | Missing value, N (%) | 45 (100.00%)  
|  | Immunology laboratory test | 4098179 | Measurement | No matching concept | 0 | N | 20  
|  |  |  |  |  |  | Median [Q25 - Q75] | -  
|  |  |  |  |  |  | Range | -  
|  |  |  |  |  |  | Missing value, N (%) | 20 (100.00%)  
      
    
    [plotMeasurementValueAsNumeric](https://rdrr.io/pkg/MeasurementDiagnostics/man/plotMeasurementValueAsNumeric.html)(code_diag)

![](a04_CodelistDiagnostics_files/figure-html/unnamed-chunk-13-1.png)

## On this page

Developed by Edward Burn, Marti Catala, Xihang Chen, Marta Alcalde-Herraiz, Albert Prats-Uribe.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.3.
