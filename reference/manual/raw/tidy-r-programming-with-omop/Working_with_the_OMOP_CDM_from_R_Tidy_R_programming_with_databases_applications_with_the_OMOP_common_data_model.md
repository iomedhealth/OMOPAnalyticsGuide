# Working with the OMOP CDM from R – Tidy R programming with databases: applications with the OMOP common data model

__

  1. [Working with the OMOP CDM from R](./omop.html)

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




# Working with the OMOP CDM from R

In this second half of the book we will see how we can work with data in the OMOP CDM format from R.

  * In [5 Creating a CDM reference](cdm_reference.html) we will see how to create a cdm_reference in R, a data model that contains references to the OMOP CDM tables and provides the foundation for analysis.

  * The OMOP CDM is a person-centric model, and the person and observation period tables are two key tables for any analysis. In ?sec-omop_person_obs_period we will see more on how these tables can be used as the starting point for identifying your study participants.

  * The OMOP CDM standarises the content of health care data via the OMOP CDM vocabulary tables, which provides a set of standard concepts to represent different clinical events. The vocabulary tables are described in ?sec-omop_vocabularies, with these tables playing a fundamental role when we identify the clinical events of interest for our study.

  * Clinical records associated with individuals are spread across various OMOP CDM tables, covering various domains. In ?sec-omop_clinical_tables we will see how these tables represent events and link back to the person and vocabulary tables.




[ __ 4 Building analytic pipelines for a data model ](./dbplyr_packages.html)

[ 5 Creating a CDM reference __](./cdm_reference.html)
