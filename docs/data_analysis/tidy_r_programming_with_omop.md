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

## Bridging the Gap for Different Backgrounds

This guide is designed to be accessible to readers from various backgrounds. Here's how we address common challenges:

### For SAS Programmers (like David)

If you're coming from SAS, you might find the functional programming style of R unfamiliar. Here's a quick mapping of common SAS concepts to their R/dplyr equivalents:

| SAS Concept | R/dplyr Equivalent | Description |
|-------------|---------------------|-------------|
| `PROC SQL` | `dplyr` verbs like `filter()`, `select()`, `mutate()` | Querying and manipulating data |
| `DATA step` | `mutate()` or `transmute()` | Creating or modifying variables |
| `PROC SORT` | `arrange()` | Sorting data |
| `PROC SUMMARY` | `group_by()` + `summarise()` | Grouping and aggregating data |
| `PROC FREQ` | `count()` | Frequency tables |

Remember, in R, operations are chained using the pipe (`|>`) for readability, similar to how you might chain procedures in SAS.

### For Clinical Experts (like Montse)

If you're new to data analysis but have a strong clinical background, the OMOP CDM might seem overly complex at first. Think of it as a standardized "language" for health data:

- **Why separate tables?** Instead of one big spreadsheet, data is split into logical tables (e.g., `person` for demographics, `condition_occurrence` for diagnoses) to avoid repetition and ensure consistency.
- **What are concept IDs?** These are standardized codes for medical terms (e.g., "Type 2 Diabetes" might have ID 201826). They ensure everyone uses the same definitions, making research comparable.
- **Why vocabularies?** OMOP uses controlled vocabularies (like SNOMED or ICD) to map local codes to standard ones, reducing ambiguity.

This structure allows for powerful, scalable analyses across different healthcare systems.

### For Data Scientists New to Healthcare (like Martina)

If you're proficient in R but unfamiliar with clinical research, we'll explain the "why" behind the code. For example, when we create a "cohort" of patients, it's not just filtering data—it's defining a study population based on clinical criteria to answer specific research questions.

## Conceptual Flow of OMOP Analysis

Before diving in, here's a high-level flowchart of the typical OMOP analysis process:

```mermaid
flowchart TD
    A[Clinical Question] --> B[Generate Code Lists<br/>(CodelistGenerator)]
    B --> C[Define Cohort<br/>(CohortConstructor)]
    C --> D[Characterize Cohort<br/>(CohortCharacteristics)]
    D --> E[Analyze Outcomes<br/>(dplyr, visOmopResults)]
    E --> F[Generate Results & Reports]
```

This visual overview shows how clinical questions translate into technical steps, helping bridge the gap between domain experts and data analysts.

## How is this guide organized?

This guide is divided into two main parts:

1.  **General Principles for Working with Databases in R:** The first half focuses on the foundational concepts of using tidyverse-style code to build analytical pipelines. You will learn how to connect to a database, manipulate data, and prepare it for analysis without ever leaving the R environment.
2.  **Applying these Principles to the OMOP CDM:** The second half demonstrates how to apply these general principles specifically to the OMOP Common Data Model. We will explore a suite of specialized R packages that streamline common analytical tasks in observational health research.

## Detailed Chapters Overview

For a deeper dive, the underlying technical manual for this guide is structured into the following detailed chapters. While this page provides a high-level summary, the full manual offers comprehensive examples and technical explanations.

### Part 1: General Principles for Working with Databases in R

{% include rmd_output/tidy_r_programming_with_omop.md %}

#### **1. A first analysis using data in a database**

The `iris` dataset is a classic example in data science, collected by Edgar Anderson in 1935. It contains measurements of 150 iris flowers from three species: setosa, versicolor, and virginica. Each flower has four measurements: sepal length, sepal width, petal length, and petal width (all in centimeters). The goal is often to classify the species based on these measurements, making it a simple but effective dataset for demonstrating statistical and machine learning techniques.

### Setting Up Your Environment

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

### Inserting Data into a Database

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

### From R to SQL: The Power of `dbplyr`

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

### Bringing Data into R for Visualization

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

### Disconnecting from the Database

When you are finished with your analysis, it is good practice to close the connection to the database.

```r
dbDisconnect(db)
```

#### **2. Core verbs for analytic pipelines utilising a database**

To demonstrate working with multiple tables, we'll extend the `iris` example by creating related tables. We'll split the data into separate tables for species information and measurements, then show how to join them back together.

### Setting Up the Database with Multiple Tables

```r
# Create database
db <- dbConnect(duckdb())

# Split iris into two tables: species info and measurements
species_info <- iris |> select(Species) |> distinct() |> mutate(species_id = row_number())
measurements <- iris |> mutate(species_id = as.integer(Species))

# Write tables
dbWriteTable(db, "species_info", species_info)
dbWriteTable(db, "measurements", measurements)

# Create lazy references
species_db <- tbl(db, "species_info")
measurements_db <- tbl(db, "measurements")
```

### Selecting Rows: `filter()` and `distinct()`

Use `filter()` to select rows based on conditions. For example, to find measurements with sepal length > 5:

```r
measurements_db |>
  filter(Sepal.Length > 5) |>
  select(Species, Sepal.Length)
```

`distinct()` removes duplicate rows:

```r
measurements_db |>
  distinct(Species)
```

### Ordering Rows: `arrange()`

`arrange()` sorts rows by one or more columns:

```r
measurements_db |>
  arrange(desc(Sepal.Length)) |>
  select(Species, Sepal.Length)
```

### Column Transformation: `mutate()`, `select()`, `rename()`

`mutate()` creates or modifies columns:

```r
measurements_db |>
  mutate(
    sepal_ratio = Sepal.Length / Sepal.Width,
    is_large = Sepal.Length > 6
  ) |>
  select(Species, sepal_ratio, is_large)
```

`select()` chooses specific columns:

```r
measurements_db |>
  select(Species, Sepal.Length, Petal.Length)
```

`rename()` changes column names:

```r
measurements_db |>
  rename(sepal_length = Sepal.Length)
```

### Grouping and Aggregation: `group_by()`, `summarise()`, `count()`

`group_by()` groups data for calculations:

```r
measurements_db |>
  group_by(Species) |>
  summarise(
    avg_sepal = mean(Sepal.Length, na.rm = TRUE),
    count = n()
  )
```

`count()` is a shortcut for counting:

```r
measurements_db |>
  count(Species, sort = TRUE)
```

### Joining Tables

Joins combine data from multiple tables. For example, to join measurements with species info:

```r
measurements_db |>
  left_join(species_db, by = "Species") |>
  select(Species, species_id, Sepal.Length)
```

### Constructing a Tidy Analytic Dataset

Let's create a comprehensive dataset by joining tables and performing aggregations:

```r
analytic_dataset <- measurements_db |>
  group_by(Species) |>
  summarise(
    avg_sepal_length = mean(Sepal.Length, na.rm = TRUE),
    avg_petal_length = mean(Petal.Length, na.rm = TRUE),
    total_measurements = n()
  ) |>
  arrange(desc(avg_sepal_length))

# Collect for analysis
analytic_dataset |> collect()
```

This pipeline demonstrates how to build complex queries using `dplyr` verbs, with all operations pushed to the database for efficiency.

#### **3. Supported expressions for database queries**

### Data Type Conversions

R and SQL handle data types differently. `dbplyr` automatically converts many types, but understanding the mappings is important:

- Logical: `TRUE`/`FALSE` → `TRUE`/`FALSE` or `1`/`0`
- Character: Strings remain strings
- Numeric: Integers and doubles are preserved
- Dates: `Date` objects → `DATE`
- Datetimes: `POSIXct` → `TIMESTAMP`

### Logical Comparisons and Operators

Standard comparison operators work as expected:

```r
measurements_db |> filter(Sepal.Length > 5 & Petal.Length > 3)
# Translates to: WHERE "Sepal.Length" > 5 AND "Petal.Length" > 3
```

### Conditional Statements

`if_else()` and `case_when()` are supported:

```r
measurements_db |>
  mutate(
    size_category = case_when(
      Sepal.Length < 5 ~ "small",
      Sepal.Length <= 6 ~ "medium",
      TRUE ~ "large"
    )
  )
```

SQL translation:

```sql
CASE
  WHEN "Sepal.Length" < 5 THEN 'small'
  WHEN "Sepal.Length" <= 6 THEN 'medium'
  ELSE 'large'
END
```

### String Functions

Common string operations:

```r
species_db |>
  mutate(
    species_upper = toupper(Species),
    species_length = nchar(Species),
    species_substr = substr(Species, 1, 3)
  )
```

### Database-Specific Considerations

While `dbplyr` aims for portability, some functions may behave differently:

- DuckDB: Full support for most R functions
- PostgreSQL: Excellent date/time support
- SQL Server: May require workarounds for some functions

Always test your queries on your target database system.

#### **4. Building analytic pipelines for a data model**

### Principles of Modular Pipelines

1. **Separation of Concerns**: Break down complex queries into smaller, focused steps
2. **Reusability**: Create functions for common operations
3. **Readability**: Use clear variable names and comments
4. **Efficiency**: Minimize data movement between database and R

### Example: Analyzing Iris Measurements

Building on the `iris` example, let's create a pipeline to analyze measurements by species:

```r
# Step 1: Filter and prepare data
iris_performance <- measurements_db |>
  filter(!is.na(Sepal.Length), !is.na(Petal.Length))

# Step 2: Calculate metrics
performance_metrics <- iris_performance |>
  mutate(
    sepal_petal_ratio = Sepal.Length / Petal.Length,
    is_large_flower = Sepal.Length > 6
  ) |>
  group_by(Species) |>
  summarise(
    total_flowers = n(),
    avg_sepal_petal_ratio = mean(sepal_petal_ratio, na.rm = TRUE),
    large_percentage = mean(is_large_flower, na.rm = TRUE) * 100
  )

# Step 3: Filter for significant groups
significant_species <- performance_metrics |>
  filter(total_flowers >= 40) |>
  arrange(desc(avg_sepal_petal_ratio))

# Collect results
results <- significant_species |> collect()
```

### Creating Reusable Functions

For repeated operations, create functions:

```r
calculate_ratios <- function(measurements_tbl) {
  measurements_tbl |>
    mutate(
      sepal_petal_ratio = Sepal.Length / Petal.Length,
      is_large = Sepal.Length > 6
    ) |>
    summarise(
      total = n(),
      avg_ratio = mean(sepal_petal_ratio, na.rm = TRUE),
      large_pct = mean(is_large, na.rm = TRUE)
    )
}

# Use the function
species_ratios <- measurements_db |>
  group_by(Species) |>
  calculate_ratios()
```

### Handling Complex Joins in Relational Models

In structured data models like OMOP, you'll often need to join multiple tables. Plan your joins carefully:

1. Identify the central table (e.g., `person` in OMOP)
2. Determine the join keys
3. Consider the join type (left, inner, etc.)
4. Chain joins logically

This approach ensures your pipelines are maintainable and efficient.

### Part 2: Applying these Principles to the OMOP CDM

#### **5. Creating a CDM reference**

### Installing Required Packages

```r
install.packages("CDMConnector")
install.packages("duckdb")
library(CDMConnector)
library(duckdb)
```

### Connecting to a Local OMOP Database

For a local DuckDB file:

```r
cdm <- cdmFromCon(
  con = dbConnect(duckdb(), "path/to/omop.db"),
  cdmSchema = "main",
  writeSchema = "main"
)
```

### Using Mock Data for Learning

For practice without a real database:

```r
cdm <- mockCdmReference()
```

This creates a `cdm` object with sample OMOP data.

### Exploring the CDM Object

The `cdm` object provides easy access to OMOP tables:

```r
# List available tables
names(cdm)

# Access specific tables
cdm$person
cdm$condition_occurrence
cdm$drug_exposure
```

### Understanding the CDM Structure

The `cdm` object knows the relationships between tables:

- `cdm$person`: Patient demographics
- `cdm$condition_occurrence`: Diagnoses
- `cdm$drug_exposure`: Medications
- `cdm$visit_occurrence`: Healthcare visits

### Verifying Connection

Check that your connection is working:

```r
# Count patients
cdm$person |> count() |> collect()

# Check table structure
cdm$person |> glimpse()
```

The `cdm` object simplifies OMOP analysis by providing a consistent interface to the complex CDM structure.

#### **6. Exploring the OMOP CDM**

### Basic Counts and Summaries

Start with overall statistics:

```r
# Total number of patients
cdm$person |> count() |> collect()

# Number of visits
cdm$visit_occurrence |> count() |> collect()

# Number of conditions
cdm$condition_occurrence |> count() |> collect()
```

### Demographic Summary

Analyze patient demographics:

```r
demographics <- cdm$person |>
  summarise(
    total_patients = n(),
    avg_age = mean(year_of_birth, na.rm = TRUE),
    gender_distribution = count(gender_concept_id)
  ) |>
  collect()
```

### Exploring Clinical Events

Examine condition occurrences:

```r
condition_summary <- cdm$condition_occurrence |>
  group_by(condition_concept_id) |>
  summarise(
    count = n(),
    unique_patients = n_distinct(person_id)
  ) |>
  arrange(desc(count)) |>
  collect()
```

Drug exposure patterns:

```r
drug_summary <- cdm$drug_exposure |>
  group_by(drug_concept_id) |>
  summarise(
    count = n(),
    avg_duration = mean(drug_exposure_end_date - drug_exposure_start_date, na.rm = TRUE)
  ) |>
  arrange(desc(count)) |>
  collect()
```

### Temporal Patterns

Analyze data over time:

```r
monthly_visits <- cdm$visit_occurrence |>
  mutate(month = floor_date(visit_start_date, "month")) |>
  group_by(month) |>
  summarise(visit_count = n()) |>
  collect()
```

This EDA provides insights into data quality, completeness, and patterns in your OMOP database.

#### **7. Identifying patient characteristics**

> **Why Patient Characteristics Matter:** In observational research, understanding patient characteristics (demographics, comorbidities, medication history) is crucial for confounding control and generalizability. These features help ensure study groups are comparable and results are interpretable.

### Calculating Age at Diagnosis

Join person and condition tables to find when patients were first diagnosed:

```r
age_at_diagnosis <- cdm$condition_occurrence |>
  inner_join(cdm$person, by = "person_id") |>
  filter(condition_concept_id == 201826) |>  # Type 2 diabetes concept
  group_by(person_id) |>
  summarise(
    first_diagnosis = min(condition_start_date),
    birth_year = first(year_of_birth)
  ) |>
  mutate(age_at_diagnosis = year(first_diagnosis) - birth_year) |>
  collect()
```

> **Clinical Insight:** Calculating age at first diagnosis helps identify incident cases (new diagnoses) versus prevalent cases (existing conditions), which is important for incidence studies.

### Identifying Comorbidities

Find patients with multiple conditions:

```r
comorbidities <- cdm$condition_occurrence |>
  filter(condition_concept_id %in% c(201826, 319835)) |>  # Diabetes and hypertension
  group_by(person_id) |>
  summarise(
    has_diabetes = any(condition_concept_id == 201826),
    has_hypertension = any(condition_concept_id == 319835),
    comorbidity_count = n_distinct(condition_concept_id)
  ) |>
  collect()
```

> **Clinical Insight:** Comorbidities affect treatment choices and outcomes. Identifying them helps control for confounding in comparative effectiveness studies.

### Using CohortCharacteristics for Standardized Summaries

Instead of manual joins, use the `CohortCharacteristics` package for standardized, reproducible summaries:

```r
install.packages("CohortCharacteristics")
library(CohortCharacteristics)

# Summarize characteristics of the diabetes cohort
characteristics <- cdm$diabetes |>
  summariseCharacteristics(
    ageGroup = list(c(0, 17), c(18, 64), c(65, 999)),
    gender = TRUE,
    priorObservation = TRUE
  ) |>
  collect()
```

> **Why CohortCharacteristics?** This package provides standardized summaries that are consistent across studies, making results more comparable and reducing errors.

### Creating a Patient Feature Dataset

Combine multiple characteristics:

```r
patient_features <- cdm$person |>
  left_join(
    cdm$condition_occurrence |>
      group_by(person_id) |>
      summarise(condition_count = n()),
    by = "person_id"
  ) |>
  left_join(
    cdm$drug_exposure |>
      group_by(person_id) |>
      summarise(drug_count = n()),
    by = "person_id"
  ) |>
  mutate(
    age = 2023 - year_of_birth,  # Assuming current year
    has_conditions = condition_count > 0,
    has_medications = drug_count > 0
  ) |>
  collect()
```

These techniques allow you to create rich feature sets for analysis or modeling.

#### **8. Adding cohorts to the CDM**

### Installing Cohort Packages

```r
install.packages("CodelistGenerator")
install.packages("CohortConstructor")
library(CodelistGenerator)
library(CohortConstructor)
```

### Creating Codelists with CodelistGenerator

Define clinical concepts:

```r
# Get concepts for Type 2 Diabetes
diabetes_codes <- getDescendants(cdm, "Type 2 diabetes mellitus")

# Get concepts for Metformin
metformin_codes <- getDescendants(cdm, "Metformin")
```

### Generating Cohorts with CohortConstructor

Create a diabetes cohort:

```r
cdm <- generateConceptCohortSet(
  cdm = cdm,
  name = "diabetes",
  conceptSet = list("type_2_diabetes" = diabetes_codes),
  end = "observation_period_end_date",
  limit = "first"
)
```

Create a metformin user cohort:

```r
cdm <- generateConceptCohortSet(
  cdm = cdm,
  name = "metformin_users",
  conceptSet = list("metformin" = metformin_codes),
  end = "observation_period_end_date",
  limit = "first"
)
```

### Advanced Cohort Definitions

Combine multiple criteria:

```r
# Patients with diabetes who started metformin within 1 year of diagnosis
cdm <- generateCohortSet(
  cdm = cdm,
  name = "diabetes_metformin",
  cohortSet = data.frame(
    cohort_definition_id = 1,
    cohort_name = "Diabetes with Metformin",
    # Define cohort entry criteria here
  )
)
```

### Validating Cohorts

Check cohort characteristics:

```r
cohort_summary <- cdm$diabetes |>
  summarise(
    cohort_size = n(),
    avg_index_age = mean(year(cohort_start_date) - year_of_birth, na.rm = TRUE)
  ) |>
  collect()
```

These tools automate complex cohort creation, ensuring reproducibility and accuracy.

#### **9. Working with cohorts**

### Characterizing Cohort Members

Join cohort with person data:

```r
cohort_characteristics <- cdm$diabetes |>
  inner_join(cdm$person, by = c("subject_id" = "person_id")) |>
  summarise(
    total_patients = n(),
    avg_age = mean(2023 - year_of_birth, na.rm = TRUE),
    gender_distribution = count(gender_concept_id)
  ) |>
  collect()
```

### Comparing Cohorts

Compare diabetes cohort to general population:

```r
diabetes_vs_general <- bind_rows(
  cdm$diabetes |>
    inner_join(cdm$person, by = c("subject_id" = "person_id")) |>
    mutate(group = "diabetes"),
  cdm$person |>
    anti_join(cdm$diabetes, by = c("person_id" = "subject_id")) |>
    mutate(group = "general")
) |>
  group_by(group) |>
  summarise(avg_age = mean(2023 - year_of_birth, na.rm = TRUE)) |>
  collect()
```

### Analyzing Outcomes Over Time

Track outcomes after cohort entry:

```r
post_cohort_outcomes <- cdm$diabetes |>
  left_join(cdm$condition_occurrence, by = c("subject_id" = "person_id")) |>
  filter(condition_start_date >= cohort_start_date) |>
  group_by(subject_id) |>
  summarise(
    follow_up_conditions = n(),
    time_to_first_condition = min(condition_start_date - cohort_start_date, na.rm = TRUE)
  ) |>
  collect()
```

### Building Study Datasets

Create analysis-ready datasets:

```r
study_dataset <- cdm$diabetes |>
  left_join(cdm$person, by = c("subject_id" = "person_id")) |>
  left_join(
    cdm$condition_occurrence |>
      filter(condition_start_date <= cohort_start_date) |>
      group_by(person_id) |>
      summarise(pre_cohort_conditions = n()),
    by = c("subject_id" = "person_id")
  ) |>
  mutate(
    age_at_entry = year(cohort_start_date) - year_of_birth,
    has_comorbidities = pre_cohort_conditions > 0
  ) |>
  select(subject_id, cohort_start_date, age_at_entry, gender_concept_id, has_comorbidities) |>
  collect()
```
This workflow forms the foundation for comparative effectiveness research, population-level epidemiology, and patient-level prediction studies.

## Glossary of Key Terms

- **Cohort:** A defined group of patients who meet specific inclusion/exclusion criteria for a study.
- **Concept ID:** A standardized numeric identifier for medical terms in the OMOP vocabulary.
- **Domain:** The category of a concept (e.g., Condition, Drug, Measurement).
- **Index Date:** The date that defines cohort entry (e.g., first diagnosis date).
- **Incidence:** The rate of new cases of a condition in a population over time.
- **Prevalence:** The proportion of a population with a condition at a specific point in time.
- **Washout Period:** A time period before cohort entry to ensure patients are "new" to treatment or condition.
- **Vocabulary:** A controlled set of terms used to standardize medical concepts across different data sources.

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

