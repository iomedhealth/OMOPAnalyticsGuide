# 9  Working with cohorts – Tidy R programming with databases: applications with the OMOP common data model

__

  1. [Working with the OMOP CDM from R](./omop.html)
  2. [9 Working with cohorts](./working_with_cohorts.html)

__

[Tidy R programming with databases: applications with the OMOP common data model](./)

  * [ Preface](./index.html)

  * [ Getting started with working databases from R](./intro.html) __

    * [ 1 A first analysis using data in a database](./working_with_databases_from_r.html)

    * [ 2 Core verbs for analytic pipelines utilising a database](./tidyverse_verbs.html)

    * [ 3 Supported expressions for database queries](./tidyverse_expressions.html)

    * [ 4 Building analytic pipelines for a data model](./dbplyr_packages.html)

  * [ Working with the OMOP CDM from R](./omop.html) __

    * [ 5 Creating a CDM reference](./cdm_reference.html)

    * [ 6 Exploring the OMOP CDM](./exploring_the_cdm.html)

    * [ 7 Identifying patient characteristics](./adding_features.html)

    * [ 8 Adding cohorts to the CDM](./creating_cohorts.html)

    * [ 9 Working with cohorts](./working_with_cohorts.html)




## Table of contents

  * 9.1 Cohort intersections
  * 9.2 Intersection between two cohorts
  * 9.3 Set up
    * 9.3.1 Flag
    * 9.3.2 Count
    * 9.3.3 Date and times
  * 9.4 Intersection between a cohort and tables with patient data
  * 10 Further reading



  1. [Working with the OMOP CDM from R](./omop.html)
  2. [9 Working with cohorts](./working_with_cohorts.html)



# 9 Working with cohorts

## 9.1 Cohort intersections

PatientProfiles::addCohortIntersect()

## 9.2 Intersection between two cohorts

## 9.3 Set up
    
    
    library(CDMConnector)
    library(dplyr)
    library(PatientProfiles)
    
    # For this example we will use GiBleed data set
    downloadEunomiaData(datasetName = "GiBleed")        
    db <- DBI::dbConnect(duckdb::duckdb(), eunomiaDir())
    
    cdm <- cdmFromCon(db, cdmSchema = "main", writeSchema = "main")
    
    # cdm <- cdm |> 
    #   generate_concept_cohort_set(concept_set = list("gi_bleed" = 192671), 
    #                             limit = "all", 
    #                             end = 30,
    #                             name = "gi_bleed",
    #                             overwrite = TRUE) |> 
    #   generate_concept_cohort_set(concept_set = list("acetaminophen" = c(1125315,
    #                                                               1127078,
    #                                                               1127433,
    #                                                               40229134,
    #                                                               40231925,
    #                                                               40162522,
    #                                                               19133768)), 
    #                               limit = "all", 
    #                             # end = "event_end_date",
    #                             name = "acetaminophen",
    #                             overwrite = TRUE)__

### 9.3.1 Flag
    
    
    # cdm$gi_bleed <- cdm$gi_bleed |> 
    #   addCohortIntersectFlag(targetCohortTable = "acetaminophen",
    #                          window = list(c(-Inf, -1), c(0,0), c(1, Inf)))
    # 
    # cdm$gi_bleed |> 
    #   summarise(acetaminophen_prior = sum(acetaminophen_minf_to_m1), 
    #             acetaminophen_index = sum(acetaminophen_0_to_0),
    #             acetaminophen_post = sum(acetaminophen_1_to_inf)) |> 
    #   collect()__

### 9.3.2 Count

### 9.3.3 Date and times

## 9.4 Intersection between a cohort and tables with patient data

# 10 Further reading

  * …



[ __ 8 Adding cohorts to the CDM ](./creating_cohorts.html)
