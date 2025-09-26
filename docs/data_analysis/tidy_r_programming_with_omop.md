---
layout: default
title:  R Programming and OMOP
parent: Data Analysis
nav_order: 2
---

# Tidyverse and the OMOP CDM

This guide introduces a powerful and intuitive approach to working with OMOP CDM data using R and the **tidyverse**. The tidyverse is a collection of R packages designed for data science that share a common design philosophy, grammar, and data structures. By leveraging these tools, you can write clean, readable, and efficient code to perform complex analyses on large-scale observational health data.

## Who is this guide for?

This guide is written for anyone who wants to work with databases in a "tidyverse" style—a human-centered, consistent, and composable approach to data analysis.

-   **New to R?** We recommend complementing this guide with [*R for Data Science*](https://r4ds.had.co.nz/).
-   **New to databases?** Familiarize yourself with SQL basics through tutorials like [SQLBolt](https://sqlbolt.com/) or [SQLZoo](https://www.sqlzoo.net/wiki/SQL_Tutorial).
-   **New to the OMOP CDM?** This guide is best paired with [*The Book of OHDSI*](https://ohdsi.github.io/TheBookOfOhdsi/).

## How is this guide organized?

This guide is divided into two main parts:

1.  **General Principles for Working with Databases in R:** The first half focuses on the foundational concepts of using tidyverse-style code to build analytical pipelines. You will learn how to connect to a database, manipulate data, and prepare it for analysis without ever leaving the R environment.
2.  **Applying these Principles to the OMOP CDM:** The second half demonstrates how to apply these general principles specifically to the OMOP Common Data Model. We will explore a suite of specialized R packages that streamline common analytical tasks in observational health research.

## Getting Started: A Simple Analysis with `iris`

Before diving into the complexities of the OMop CDM, let's start with a simple example to understand the basic workflow. We will use the `iris` dataset, a classic and clean dataset containing measurements for three flower species.

### 1. Setting Up Your Environment

First, you need to install and load the necessary R packages.

```r
# Install packages if you don't have them already
install.packages("dplyr")
install.packages("dbplyr")
install.packages("ggplot2")
install.packages("DBI")
install.packages("duckdb")

# Load the libraries
library(dplyr)
library(dbplyr)
library(ggplot2)
library(DBI)
library(duckdb)
```

### 2. Inserting Data into a Database

Next, we will load the `iris` data into an in-memory `duckdb` database. This simulates a real-world scenario where your data resides in a database server.

```r
# Create an in-memory duckdb database
db <- dbConnect(drv = duckdb())

# Write the iris dataframe to a table named "iris" in the database
dbWriteTable(db, "iris", iris)

# You can see the tables in the database
dbListTables(db)
#> [1] "iris"
```

### 3. From R to SQL: The Power of `dbplyr`

Now that the data is in a database, we could query it using SQL. However, the magic of the `dbplyr` package is that it allows you to write familiar `dplyr` code, which it automatically translates into SQL for you.

First, create a reference to the `iris` table in the database.

```r
iris_db <- tbl(db, "iris")
```

This `iris_db` object is not the data itself, but a "lazy" reference to the database table. Now, you can use standard `dplyr` verbs on this object.

```r
# Get a summary of sepal length by species
iris_db |>
  group_by(Species) |>
  summarise(
    n = n(),
    mean_sepal_length = mean(Sepal.Length, na.rm = TRUE)
  )
```

When you run this code, `dbplyr` translates it into the following SQL query, sends it to the database, and returns the result.

```sql
<SQL>
SELECT
  "Species",
  COUNT(*) AS n,
  AVG("Sepal.Length") AS mean_sepal_length
FROM iris
GROUP BY "Species"
```

This allows you to perform complex data manipulations using intuitive R code, without needing to write complex, database-specific SQL.

### 4. Bringing Data into R for Visualization

While most data manipulation should happen in the database for efficiency, you will often need to bring the final, summarized data back into R for visualization or modeling. The `collect()` function does this.

Let's create a histogram of sepal length for each flower species.

```r
iris_db |>
  select("Species", "Sepal.Length") |>
  collect() |> # This brings the data from the database into an R dataframe
  ggplot(aes(x = `Sepal.Length`, fill = Species)) +
  geom_histogram(binwidth = 0.2, colour = "black") +
  facet_wrap(~Species, ncol = 1) +
  theme_bw()
```

This workflow—manipulating data in the database and collecting only the results—is the most efficient way to work with large datasets.

### 5. Disconnecting from the Database

When you are finished with your analysis, it is good practice to close the connection to the database.

```r
dbDisconnect(db)
```

## Core `dplyr` Verbs for Database Work

The tidyverse provides a consistent set of "verbs" for data manipulation that work seamlessly with databases through `dbplyr`.

| Purpose | Functions | Description |
| :--- | :--- | :--- |
| **Selecting rows** | `filter()`, `distinct()` | Select rows based on conditions. |
| **Ordering rows** | `arrange()` | Order rows by one or more columns. |
| **Column Transformation** | `mutate()`, `select()`, `rename()` | Create, modify, or select columns. |
| **Grouping** | `group_by()`, `ungroup()` | Group data for summarized calculations. |
| **Aggregation** | `summarise()`, `count()` | Calculate summary statistics. |
| **Joining Tables** | `inner_join()`, `left_join()`, etc. | Combine data from multiple tables. |

By mastering these verbs, you can construct powerful and readable data analysis pipelines that are executed directly in the database, ensuring scalability and performance.

## Applying Tidyverse Principles to the OMOP CDM

While the principles of `dbplyr` and `dplyr` are powerful for any database, the OHDSI and DARWIN EU communities have developed a suite of R packages that build on this foundation to provide a seamless experience for working with the OMOP CDM.

### The `CDMConnector` Package: Your Gateway to OMOP Data

The cornerstone of this ecosystem is the `CDMConnector` package. It allows you to create a `cdm` object, which is a special type of database connection that understands the structure of the OMOP CDM.

```r
library(CDMConnector)
library(duckdb)

# For this example, we'll use a mock dataset
cdm <- mockCdmReference()
```

The `cdm` object gives you easy access to all the OMOP tables as lazy tibbles, ready to be used with `dplyr`.

```r
# Access the person table
cdm$person
```

### `compute()` vs. `collect()`: Working in the Database

A key concept when working with database-backed data is the difference between `collect()` and `compute()`.

-   `collect()`: This function pulls data **out of the database** and into an R data frame in your computer's memory. You should only use this on small, aggregated result sets that you need for visualization or local modeling.
-   `compute()`: This function executes the query steps you've defined and saves the result as a **new table in the database**. This is essential for multi-step analyses, allowing you to build intermediate datasets without ever leaving the database, which is far more efficient.

### Defining Clinical Ideas with `CodelistGenerator`

In any clinical study, you work with concepts like "Type 2 Diabetes" or "Metformin", not abstract concept IDs. The `CodelistGenerator` package is used to gather all the relevant concept IDs for a clinical idea into a single object.

Let's create a codelist for Type 2 Diabetes.

```r
library(CodelistGenerator)

# Get all concepts for "Type 2 diabetes mellitus" and its descendants
diabetes_codes <- getDescendants(cdm, "Type 2 diabetes mellitus")
```

### A Realistic Cohort with `CohortConstructor`

Now, let's tackle a real-world problem: **creating a cohort of patients with a first-time diagnosis of Type 2 Diabetes.** This is where the power of the OHDSI tools becomes clear.

This task requires us to:
1.  Find all diabetes diagnoses in the `condition_occurrence` table using our `diabetes_codes`.
2.  For each person, identify their very first diagnosis date.
3.  Create a cohort table with the person ID, the index date (first diagnosis), and the cohort definition ID.

The `CohortConstructor` package streamlines this. Here's how you would do it:

```r
library(CohortConstructor)

cdm <- generateConceptCohortSet(
  cdm = cdm,
  name = "diabetes",
  conceptSet = list("type_2_diabetes" = diabetes_codes),
  end = "observation_period_end_date",
  limit = "first"
)
```
This single command performs all the necessary filtering, grouping, and joining on the database side to create a new cohort table, `cdm$diabetes`.

### Answering a Clinical Question: Joining Cohorts and Data

Now that we have our cohort, we can start asking questions. For example: **"What is the age and gender distribution of our new diabetes cohort?"**

This requires joining our `diabetes` cohort with the `person` table. Because both are tables within the `cdm` object, this is a straightforward `dplyr` join.

```r
diabetes_cohort <- cdm$diabetes
person_table <- cdm$person

cohort_demographics <- diabetes_cohort |>
  inner_join(person_table, by = c("subject_id" = "person_id")) |>
  select("subject_id", "cohort_start_date", "gender_concept_id", "year_of_birth") |>
  mutate(age_at_diagnosis = year(cohort_start_date) - year_of_birth) |>
  collect() # We collect here because the result is small and we want to analyze it in R

summary(cohort_demographics$age_at_diagnosis)
table(cohort_demographics$gender_concept_id)
```

This workflow—defining concepts, generating cohorts, and then using standard `dplyr` verbs to analyze the results—is the foundation of a powerful, scalable, and reproducible analysis pipeline in OHDSI.

