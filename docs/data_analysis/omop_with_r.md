---
layout: default
title: Using OMOP with R
parent: Data Analysis
nav_order: 4
---

# Using OMOP with R
{: .no_toc}

This guide demonstrates how to apply R programming fundamentals to work with OMOP CDM data. Assuming you have basic R knowledge, we'll focus on OMOP-specific concepts and tools.

1. TOC
{:toc}

## 1. Creating a CDM Reference

```r
library(CDMConnector)
library(omock)
library(lubridate)
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

```r
cdm <- mockCdmReference()
```

This creates a `cdm` object with sample OMOP data.

### Exploring the CDM Object

```r
# List available tables
names(cdm)
```

The `cdm` object gives you easy access to all the OMOP tables as lazy tibbles, ready to be used with `dplyr`.

```r
# Access specific tables
cdm$person
```

### Verifying Connection

```r
# Count patients
cdm$person |> count() |> collect()
```

## 2. Exploring the OMOP CDM

### Basic Counts and Summaries

Start with overall statistics:

```r
# Total number of patients
cdm$person |> count() |> collect()
```

### Demographic Summary

Analyze patient demographics:

```r
demographics <- cdm$person |>
  summarise(
    total_patients = n(),
    avg_age = mean(year_of_birth, na.rm = TRUE),
    distinct_genders = n_distinct(gender_concept_id)
  ) |>
  collect()
```

## 3. Identifying Patient Characteristics

### Calculating Age at Observation Start

Join person and observation_period tables:

```r
age_at_observation <- cdm$observation_period |>
  inner_join(cdm$person, by = "person_id") |>
  group_by(person_id) |>
  summarise(
    first_observation = min(observation_period_start_date),
    birth_year = first(year_of_birth)
  ) |>
  mutate(age_at_observation = year(first_observation) - birth_year) |>
  collect()
```

### Using CohortCharacteristics for Standardized Summaries

Instead of manual joins, use the `CohortCharacteristics` package for standardized, reproducible summaries.

```r
library(CohortCharacteristics)

# First create a cohort
cdm <- generateConceptCohortSet(
  cdm = cdm,
  name = "diabetes",
  conceptSet = list("type_2_diabetes" = 201826),
  end = "observation_period_end_date",
  limit = "first"
)

# Summarize characteristics of the diabetes cohort
characteristics <- cdm$diabetes |>
  summariseCharacteristics(
    ageGroup = list(c(0, 17), c(18, 64), c(65, 999)),
    gender = TRUE,
    priorObservation = TRUE
  ) |>
  collect()
```

## 4. Adding Cohorts to the CDM

```r
library(CodelistGenerator)
library(CohortConstructor)
```

### Creating Codelists with CodelistGenerator

Define clinical concepts:

```r
# Get concepts for Gender
gender_codes <- getDescendants(cdm, 8507)  # MALE concept
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

## 5. Working with Cohorts

### Characterizing Cohort Members

Join cohort with person data:

```r
cohort_characteristics <- cdm$diabetes |>
  inner_join(cdm$person, by = c("subject_id" = "person_id")) |>
  summarise(
    total_patients = n(),
    avg_age = mean(2023 - year_of_birth, na.rm = TRUE),
    distinct_genders = n_distinct(gender_concept_id)
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

## 6. Bridging the Gap for Different Backgrounds

This guide is designed to be accessible to readers from various backgrounds. Here's how we address common challenges:

### For Data Scientists New to Healthcare (like Martina)

If you're proficient in R but unfamiliar with clinical research, we'll explain the "why" behind the code. For example, when we create a "cohort" of patients, it's not just filtering data—it's defining a study population based on clinical criteria to answer specific research questions.

Martina, a data scientist transitioning to healthcare analytics, often finds that the clinical context adds meaning to the technical work. When building cohorts, remember that each patient represents a real person with a medical history, and your analyses can directly impact healthcare decisions.

## 7. Glossary of Key Terms

- **Cohort:** A defined group of patients who meet specific inclusion/exclusion criteria for a study.
- **Concept ID:** A standardized numeric identifier for medical terms in the OMOP vocabulary.
- **Domain:** The category of a concept (e.g., Condition, Drug, Measurement).
- **Index Date:** The date that defines cohort entry (e.g., first diagnosis date).
- **Incidence:** The rate of new cases of a condition in a population over time.
- **Prevalence:** The proportion of a population with a condition at a specific point in time.
- **Vocabulary:** A controlled set of terms used to standardize medical concepts across different data sources.

## 8. Applying Tidyverse Principles to the OMOP CDM

While the principles of `dplyr` are powerful for any database, the OHDSI and DARWIN EU communities have developed a suite of R packages that build on this foundation to provide a seamless experience for working with the OMOP CDM.

### The `CDMConnector` Package: Your Gateway to OMOP Data

The cornerstone of this ecosystem is the `CDMConnector` package. It allows you to create a `cdm` object, which is a special type of database connection that understands the structure of the OMOP CDM.

```r
library(CDMConnector)
library(duckdb)

# For this example, we'll use a mock dataset
cdm <- mockCdmReference()
```

The `cdm` object simplifies OMOP analysis by providing a consistent interface to the complex CDM structure.

### `compute()` vs. `collect()`: Working in the Database

- `collect()`: Pulls data out of the database into R memory.
- `compute()`: Executes queries and saves results as new database tables for efficiency.

### Defining Clinical Ideas with `CodelistGenerator`

The `CodelistGenerator` package gathers relevant concept IDs for clinical ideas.

### A Realistic Cohort with `CohortConstructor`

Let's create a cohort of patients with first-time Type 2 Diabetes diagnosis.

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

This command performs complex filtering, grouping, and joining on the database side.

### Answering a Clinical Question: Joining Cohorts and Data

Now that we have our cohort, we can ask questions like: "What is the age and gender distribution of our new diabetes cohort?"

```r
diabetes_cohort <- cdm$diabetes
person_table <- cdm$person

cohort_demographics <- diabetes_cohort |>
  inner_join(person_table, by = c("subject_id" = "person_id")) |>
  select("subject_id", "cohort_start_date", "gender_concept_id", "year_of_birth") |>
  mutate(age_at_diagnosis = year(cohort_start_date) - year_of_birth) |>
  collect()

summary(cohort_demographics$age_at_diagnosis)
table(cohort_demographics$gender_concept_id)
```

This workflow—defining concepts, generating cohorts, and analyzing results—is the foundation of powerful, scalable analysis in OHDSI.