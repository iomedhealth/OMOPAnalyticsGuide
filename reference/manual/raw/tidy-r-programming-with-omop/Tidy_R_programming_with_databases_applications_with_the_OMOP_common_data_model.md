# Tidy R programming with databases: applications with the OMOP common data model

__

  1. [Preface](./index.html)

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

  * Preface
    * Is this book for me?
    * How is the book organised?
    * Citation
    * License
    * Code
    * renv



# Tidy R programming with databases: applications with the OMOP common data model

Authors

Edward Burn 

Adam Black 

Berta Raventós 

Yuchen Guo 

Mike Du 

Kim López-Güell 

Núria Mercadé-Besora 

Martí Català 

Published

September 11, 2025

# Preface

## Is this book for me?

We’ve written this book for anyone interested in a working with databases using a tidyverse style approach. That is, human centered, consistent, composable, and inclusive (see <https://design.tidyverse.org/unifying.html> for more details on these principles).

New to R? We recommend you compliment the book with [R for data science](https://r4ds.had.co.nz/)

New to databases? We recommend you take a look at some web tutorials on SQL, such as [SQLBolt](https://sqlbolt.com/) or [SQLZoo](https://www.sqlzoo.net/wiki/SQL_Tutorial)

New to the OMOP CDM? We’d recommend you pare this book with [The Book of OHDSI](https://ohdsi.github.io/TheBookOfOhdsi/)

## How is the book organised?

The book is divided into two parts. The first half of the book is focused on the general principles for working with databases from R. In these chapters you will see how you can use familiar tidyverse-style code to build up analytic pipelines that start with data held in a database and end with your analytic results. The second half of the book is focused on working with data in the OMOP Common Data Model (CDM) format, a widely used data format for health care data. In these chapters you will see how to work with this data format using the general principles from the first half of the book along with a set of R packages that have been built for the OMOP CDM.

## Citation

TO ADD

## License

[![Creative Commons License](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-nc-sa/4.0/)   
This work is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/). 

## Code

The source code for the book can be found at this [Github repository](https://github.com/oxford-pharmacoepi/Tidy-R-programming-with-OMOP)

## renv

This book is rendered using the following version of packages:
    
    
    Finding R package dependencies ... Done!

Package | Version | Link  
---|---|---  
CDMConnector | 2.1.1 | [🔗](https://darwin-eu.github.io/CDMConnector/)  
CodelistGenerator | 3.5.0 | [🔗](https://darwin-eu.github.io/CodelistGenerator/)  
CohortCharacteristics | 1.0.0 | [🔗](https://darwin-eu.github.io/CohortCharacteristics/)  
CohortConstructor | 0.5.0 | [🔗](https://ohdsi.github.io/CohortConstructor/)  
DBI | 1.2.3 | [🔗](https://dbi.r-dbi.org)  
Lahman | 13.0-0 | [🔗](https://cdalzell.github.io/Lahman/)  
PatientProfiles | 1.4.2 | [🔗](https://darwin-eu.github.io/PatientProfiles/)  
bit64 | 4.6.0-1 | [🔗](https://github.com/r-lib/bit64)  
cli | 3.6.5 | [🔗](https://cli.r-lib.org)  
clock | 0.7.3 | [🔗](https://clock.r-lib.org)  
dbplyr | 2.5.1 | [🔗](https://dbplyr.tidyverse.org/)  
dm | 1.0.12 | [🔗](https://dm.cynkra.com/)  
dplyr | 1.1.4 | [🔗](https://dplyr.tidyverse.org)  
duckdb | 1.3.3 | [🔗](https://r.duckdb.org/)  
ggplot2 | 3.5.2 | [🔗](https://ggplot2.tidyverse.org)  
here | 1.0.1 | [🔗](https://here.r-lib.org/)  
omock | 0.5.0 | [🔗](https://ohdsi.github.io/omock/)  
omopgenerics | 1.3.0 | [🔗](https://darwin-eu.github.io/omopgenerics/)  
palmerpenguins | 0.1.1 | [🔗](https://allisonhorst.github.io/palmerpenguins/)  
purrr | 1.1.0 | [🔗](https://purrr.tidyverse.org/)  
sloop | 1.0.1 | [🔗](https://github.com/r-lib/sloop)  
stringr | 1.5.2 | [🔗](https://stringr.tidyverse.org)  
tidyr | 1.3.1 | [🔗](https://tidyr.tidyverse.org)  
  
Note we only included the packages called explicitly in the book.

[ Getting started with working databases from R __](./intro.html)
