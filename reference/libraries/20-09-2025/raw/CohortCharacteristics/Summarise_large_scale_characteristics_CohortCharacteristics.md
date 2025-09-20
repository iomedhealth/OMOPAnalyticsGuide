# Summarise large scale characteristics • CohortCharacteristics

Skip to contents

[CohortCharacteristics](../index.html) 1.0.0

  * [Reference](../reference/index.html)
  * Articles
    * [Summarise cohort entries](../articles/summarise_cohort_entries.html)
    * [Summarise patient characteristics](../articles/summarise_characteristics.html)
    * [Summarise large scale characteristics](../articles/summarise_large_scale_characteristics.html)
    * [Summarise cohort overlap](../articles/summarise_cohort_overlap.html)
    * [Summarise cohort timing](../articles/summarise_cohort_timing.html)
  * [Changelog](../news/index.html)


  *   * [](https://github.com/darwin-eu/CohortCharacteristics/)



![](../logo.png)

# Summarise large scale characteristics

Source: [`vignettes/summarise_large_scale_characteristics.Rmd`](https://github.com/darwin-eu/CohortCharacteristics/blob/v1.0.0/vignettes/summarise_large_scale_characteristics.Rmd)

`summarise_large_scale_characteristics.Rmd`

## Introduction

In the previous vignette we have seen how we can use the CohortCharacteristics package to summarise a set of pre-specified characteristics of a study cohort. These characteristics included patient demographics like age and sex, and also concept sets and cohorts that we defined. Another, often complimentary, way that we can approach characterising a study cohort is by simply summarising all clinical events we see for them in some window around their index date (cohort entry).

To show how large scale characterisation can work we’ll first create a first-ever ankle sprain study cohort using the Eunomia synthetic data.
    
    
    [library](https://rdrr.io/r/base/library.html)([duckdb](https://r.duckdb.org/))
    [library](https://rdrr.io/r/base/library.html)([CDMConnector](https://darwin-eu.github.io/CDMConnector/))
    [library](https://rdrr.io/r/base/library.html)([dplyr](https://dplyr.tidyverse.org), warn.conflicts = FALSE)
    [library](https://rdrr.io/r/base/library.html)([PatientProfiles](https://darwin-eu.github.io/PatientProfiles/))
    [library](https://rdrr.io/r/base/library.html)([CohortCharacteristics](https://darwin-eu.github.io/CohortCharacteristics/))
    
    con <- [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)([duckdb](https://r.duckdb.org/reference/duckdb.html)(), dbdir = [eunomiaDir](https://darwin-eu.github.io/CDMConnector/reference/eunomiaDir.html)())
    cdm <- [cdmFromCon](https://darwin-eu.github.io/CDMConnector/reference/cdmFromCon.html)(
      con = con, cdmSchem = "main", writeSchema = "main", cdmName = "Eunomia"
    )
    
    cdm <- [generateConceptCohortSet](https://darwin-eu.github.io/CDMConnector/reference/generateConceptCohortSet.html)(
      cdm = cdm,
      name = "ankle_sprain",
      conceptSet = [list](https://rdrr.io/r/base/list.html)("ankle_sprain" = 81151),
      end = "event_end_date",
      limit = "first",
      overwrite = TRUE
    )

## Large scale characteristics of study cohorts

To summarise our cohort of individuals with an ankle sprain we will look at their records in three tables of the OMOP CDM (_condition_occurrence_ , _procedure_occurrence_ , and _drug_exposure_) over two time windows (any time prior to their index date, and on index date). For conditions and procedures we will identify whether someone had a new record starting in the time window. Meanwhile, for drug exposures we will consider whether they had a new or ongoing record in the period.

Lastly, but important to note, we are only going to only return results for concepts for which at least 10% of the study cohort had a record.
    
    
    lsc <- cdm$ankle_sprain |>
      [summariseLargeScaleCharacteristics](../reference/summariseLargeScaleCharacteristics.html)(
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-Inf, -1), [c](https://rdrr.io/r/base/c.html)(0, 0)),
        eventInWindow = [c](https://rdrr.io/r/base/c.html)(
          "condition_occurrence",
          "procedure_occurrence"
        ),
        episodeInWindow = "drug_exposure",
        minimumFrequency = 0.1
      )
    
    [tableLargeScaleCharacteristics](../reference/tableLargeScaleCharacteristics.html)(lsc)

As we can see we have identified numerous concepts for which at least 10% of our study population had a record. Often with larger cohorts and real patient-level data we will obtain many times more results when running large scale characterisation. One option we have to help summarise our results is to pick out the most frequent concepts. Here, for example, we select the top 5 concepts.
    
    
    [tableTopLargeScaleCharacteristics](../reference/tableTopLargeScaleCharacteristics.html)(lsc,
                                      topConcepts = 5)

|  Window  
---|---  
|  -inf to -1 |  0 to 0  
|  Table name  
|  condition_occurrence |  drug_exposure |  procedure_occurrence |  condition_occurrence |  drug_exposure  
Top |  Type  
event | episode | event | event | episode  
1 | Viral sinusitis (40481087)   
981 (72.3%) | poliovirus vaccine, inactivated (40213160)   
994 (73.2%) | Suture open wound (4125906)   
363 (26.8%) | Sprain of ankle (81151)   
1357 (100.0%) | Aspirin 81 MG Oral Tablet (19059056)   
470 (34.6%)  
2 | Otitis media (372328)   
909 (67.0%) | Aspirin 81 MG Oral Tablet (19059056)   
842 (62.0%) | Bone immobilization (4170947)   
356 (26.2%) | 

  * 
| Acetaminophen 325 MG Oral Tablet (1127433)   
330 (24.3%)  
3 | Acute viral pharyngitis (4112343)   
845 (62.3%) | Acetaminophen 325 MG Oral Tablet (1127433)   
737 (54.3%) | Sputum examination (4151422)   
282 (20.8%) | 

  * 
| Acetaminophen 160 MG Oral Tablet (1127078)   
199 (14.7%)  
4 | Acute bronchitis (260139)   
767 (56.5%) | Acetaminophen 160 MG Oral Tablet (1127078)   
559 (41.2%) | Plain chest X-ray (4163872)   
137 (10.1%) | 

  * 
| Ibuprofen 200 MG Oral Tablet (19078461)   
192 (14.2%)  
5 | Streptococcal sore throat (28060)   
499 (36.8%) | Amoxicillin 250 MG / Clavulanate 125 MG Oral Tablet (1713671)   
499 (36.8%) | Radiography of humerus (4047491)   
129 (9.5%) | 

  * 
| Naproxen sodium 220 MG Oral Tablet (1115171)   
120 (8.8%)  
  
## Stratified large scale characteristics

Like when summarising pre-specified patient characteristics, we can also get stratified results when summarising large scale characteristics. Here, for example, large scale characteristics are stratified by sex (which we add as an additional column to our cohort table using the PatientProfiles package).
    
    
    lsc <- cdm$ankle_sprain |>
      [addSex](https://darwin-eu.github.io/PatientProfiles/reference/addSex.html)() |>
      [summariseLargeScaleCharacteristics](../reference/summariseLargeScaleCharacteristics.html)(
        window = [list](https://rdrr.io/r/base/list.html)([c](https://rdrr.io/r/base/c.html)(-Inf, -1), [c](https://rdrr.io/r/base/c.html)(0, 0)),
        strata = [list](https://rdrr.io/r/base/list.html)("sex"),
        eventInWindow = "drug_exposure",
        minimumFrequency = 0.1
      )
    
    [tableTopLargeScaleCharacteristics](../reference/tableTopLargeScaleCharacteristics.html)(lsc)

|  Sex  
---|---  
|  Female |  Male |  overall  
Top |  Window  
-inf to -1 | 0 to 0 | -inf to -1 | 0 to 0 | -inf to -1 | 0 to 0  
1 | poliovirus vaccine, inactivated (40213160)   
501 (73.3%) | Aspirin 81 MG Oral Tablet (19059056)   
245 (35.9%) | poliovirus vaccine, inactivated (40213160)   
493 (73.2%) | Aspirin 81 MG Oral Tablet (19059056)   
225 (33.4%) | poliovirus vaccine, inactivated (40213160)   
994 (73.2%) | Aspirin 81 MG Oral Tablet (19059056)   
470 (34.6%)  
2 | Aspirin 81 MG Oral Tablet (19059056)   
427 (62.5%) | Acetaminophen 325 MG Oral Tablet (1127433)   
165 (24.2%) | Aspirin 81 MG Oral Tablet (19059056)   
415 (61.6%) | Acetaminophen 325 MG Oral Tablet (1127433)   
165 (24.5%) | Aspirin 81 MG Oral Tablet (19059056)   
842 (62.0%) | Acetaminophen 325 MG Oral Tablet (1127433)   
330 (24.3%)  
3 | Acetaminophen 325 MG Oral Tablet (1127433)   
374 (54.8%) | Acetaminophen 160 MG Oral Tablet (1127078)   
97 (14.2%) | Acetaminophen 325 MG Oral Tablet (1127433)   
363 (53.9%) | Acetaminophen 160 MG Oral Tablet (1127078)   
102 (15.1%) | Acetaminophen 325 MG Oral Tablet (1127433)   
737 (54.3%) | Acetaminophen 160 MG Oral Tablet (1127078)   
199 (14.7%)  
4 | Acetaminophen 160 MG Oral Tablet (1127078)   
292 (42.8%) | Ibuprofen 200 MG Oral Tablet (19078461)   
93 (13.6%) | Acetaminophen 160 MG Oral Tablet (1127078)   
267 (39.6%) | Ibuprofen 200 MG Oral Tablet (19078461)   
99 (14.7%) | Acetaminophen 160 MG Oral Tablet (1127078)   
559 (41.2%) | Ibuprofen 200 MG Oral Tablet (19078461)   
192 (14.2%)  
5 | Penicillin V Potassium 250 MG Oral Tablet (19133873)   
256 (37.5%) | Naproxen sodium 220 MG Oral Tablet (1115171)   
62 (9.1%) | Amoxicillin 250 MG / Clavulanate 125 MG Oral Tablet (1713671)   
255 (37.8%) | Naproxen sodium 220 MG Oral Tablet (1115171)   
58 (8.6%) | Amoxicillin 250 MG / Clavulanate 125 MG Oral Tablet (1713671)   
499 (36.8%) | Naproxen sodium 220 MG Oral Tablet (1115171)   
120 (8.8%)  
6 | Amoxicillin 250 MG / Clavulanate 125 MG Oral Tablet (1713671)   
244 (35.7%) | Ibuprofen 100 MG Oral Tablet (19019979)   
21 (3.1%) | Penicillin V Potassium 250 MG Oral Tablet (19133873)   
235 (34.9%) | Ibuprofen 100 MG Oral Tablet (19019979)   
25 (3.7%) | Penicillin V Potassium 250 MG Oral Tablet (19133873)   
491 (36.2%) | Ibuprofen 100 MG Oral Tablet (19019979)   
46 (3.4%)  
7 | Penicillin G 375 MG/ML Injectable Solution (19006318)   
169 (24.7%) | 

  * 
| Penicillin G 375 MG/ML Injectable Solution (19006318)   
215 (31.9%) | 

  * 
| Penicillin G 375 MG/ML Injectable Solution (19006318)   
384 (28.3%) | 

  * 
  
8 | tetanus and diphtheria toxoids, adsorbed, preservative free, for adult use (40213227)   
151 (22.1%) | 

  * 
| Acetaminophen 21.7 MG/ML / Dextromethorphan Hydrobromide 1 MG/ML / doxylamine succinate 0.417 MG/ML Oral Solution (40229134)   
164 (24.3%) | 

  * 
| Acetaminophen 21.7 MG/ML / Dextromethorphan Hydrobromide 1 MG/ML / doxylamine succinate 0.417 MG/ML Oral Solution (40229134)   
296 (21.8%) | 

  * 
  
9 | {7 (Inert Ingredients 1 MG Oral Tablet) / 21 (Mestranol 0.05 MG / Norethindrone 1 MG Oral Tablet) } Pack [Norinyl 1+50 28 Day] (19128065)   
135 (19.8%) | 

  * 
| tetanus and diphtheria toxoids, adsorbed, preservative free, for adult use (40213227)   
137 (20.3%) | 

  * 
| tetanus and diphtheria toxoids, adsorbed, preservative free, for adult use (40213227)   
288 (21.2%) | 

  * 
  
10 | Acetaminophen 21.7 MG/ML / Dextromethorphan Hydrobromide 1 MG/ML / doxylamine succinate 0.417 MG/ML Oral Solution (40229134)   
132 (19.3%) | 

  * 
| Haemophilus influenzae type b vaccine, PRP-OMP conjugate (40213314)   
98 (14.5%) | 

  * 
| hepatitis B vaccine, adult dosage (40213306)   
226 (16.6%) | 

  * 
  
  
## Plot large scale characteristics

`plotLargeScaleCharacteristics` and `plotComparedLargeScaleCharacteristics` can be use to generate plot for visualising the large scale characteristics
    
    
    [plotLargeScaleCharacteristics](../reference/plotLargeScaleCharacteristics.html)(lsc)

![](summarise_large_scale_characteristics_files/figure-html/unnamed-chunk-6-1.png)

`plotComparedLargeScaleCharacteristics` allows you to compare the difference in prevalence of the large scale covariates between two window. The reference cohort and time window are set using the `reference` arguement inside the function.
    
    
    [plotComparedLargeScaleCharacteristics](../reference/plotComparedLargeScaleCharacteristics.html)(
      result = lsc,
      colour = "sex",
      reference = 'overall',
      facet = cohort_name ~ variable_level
    )

![](summarise_large_scale_characteristics_files/figure-html/unnamed-chunk-7-1.png)

## On this page

Developed by Marti Catala, Yuchen Guo, Kim Lopez-Guell, Edward Burn, Nuria Mercade-Besora, Marta Alcalde.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.2.
