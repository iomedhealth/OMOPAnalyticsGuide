---

layout: default
title: Introductory Guide
parent: Data Analysis
nav_order: 2

---

# Introductory Guide
{: .no_toc}


Welcome. If you have years of experience designing and running clinical studies, you are in the right place. Your expertise in protocols, patient populations, and clinical endpoints is the perfect foundation for the world of observational health research.

This guide is designed to bridge the gap between your deep clinical and statistical knowledge and a powerful new toolset for analyzing real-world data: the OMOP Common Data Model and the R programming language. We will introduce new concepts gradually, always connecting them back to the principles of high-quality clinical research you already know.

Think of this as a new, powerful extension of your existing toolkit—one that allows you to ask research questions at a scale and speed previously unimaginable.

1. TOC
{:toc}


## 1. The "Why" - Introducing the OMOP Common Data Model

In your work, you know the immense value of clean, structured, and standardized data, as is typical in clinical trials. However, the data generated during routine healthcare—from Electronic Health Records (EHRs), insurance claims, and patient registries—is often messy and stored in thousands of different formats across the globe. This fragmentation makes it incredibly difficult to conduct large-scale, reproducible research.

**This is the problem the OMOP Common Data Model (CDM) solves.**

OMOP is a universal standard, or a "common language," for structuring healthcare data. By transforming diverse datasets into this single, consistent format, OMOP allows us to:

1.  **Ask the Same Question Everywhere:** Run a single analysis script across multiple databases from different hospitals or countries and get comparable, meaningful results.
2.  **Ensure Transparency:** The entire process, from raw data to final result, is documented and clear.
3.  **Promote Reproducible Science:** Anyone can take the same analysis script and reproduce the results, a cornerstone of good scientific practice.

Regulatory bodies like the European Medicines Agency (EMA) are increasingly promoting the use of standardized, real-world data through initiatives like DARWIN EU. By learning to work with the OMOP CDM, you are aligning with the future of evidence generation.



## 2. The "What" - How OMOP Organizes Information

So, how does OMOP create this "common language"? The core mechanism is simple but powerful: the **`concept_id`**.

In the world of healthcare data, there are many different coding systems (terminologies) for the same clinical idea. A diagnosis of "Type 2 diabetes mellitus" might be coded as:

*   `E11.9` in ICD-10-CM
*   `44054006` in SNOMED-CT
*   `250.00` in ICD-9-CM

This creates a major barrier to analysis. The OMOP solution is to map all of these different codes to a single, standard **`concept_id`**.

| Original Code | Terminology | Clinical Idea | Standard OMOP Concept ID |
| : | : | : | : |
| `E11.9` | ICD-10-CM | Type 2 diabetes | **201826** |
| `44054006` | SNOMED-CT | Type 2 diabetes | **201826** |
| `250.00` | ICD-9-CM | Type 2 diabetes | **201826** |

**Analogy: A Universal Translator**

Think of `concept_ids` as a universal translator for clinical terms. While the source "languages" (SNOMED, ICD-10) are different, OMOP provides a single, standard identifier for every diagnosis, drug, procedure, and lab test. This meta-ontology is the engine that makes large-scale, standardized analysis possible.



## 3. The "Where" - Your study in the IOMED Data Space

Now, let's ground these abstract concepts in your specific, practical reality.

The IOMED Data Space provides you with a single, ready-to-analyze **`duckdb` file**. This is a self-contained, high-performance database file that requires no complex setup. Inside this file, you will find:

1.  **A complete OMOP CDM database:** All the patient data has been cleaned, standardized, and structured according to the OMOP model.
2.  **The cohort of patients that fulfill selection criterias:** This is the starting population for your study.

Crucially, you have already done the hard work of defining key clinical variables as **`concept_sets`**.

A **`concept_set`** is simply a pre-packaged, clinically validated list of all the `concept_id`s that represent a single clinical idea. For example, a `concept_set` for "Anticoagulants" would contain the standard `concept_id`s for warfarin, apixaban, rivaroxaban, and all other relevant medications.

This is a critical accelerator for your research. You don't have to become an expert in OMOP terminologies; you can start immediately with clinically meaningful, pre-built variable definitions.



## 4. The "How" - Defining Variables in R

This is where you take your first practical step into the R programming environment. The logic and goals will be familiar, but the execution is different from traditional statistical software. Let's break down how this new process maps to the workflows you may be used to.

### The Goal. From Clinical Idea to Computable Variable

In any study, the first step is to translate a clinical idea (e.g., "diabetes") into a precise, computable definition.

-   **In SAS/SPSS:** You might receive a dataset (e.g., a CSV or SAS file) and a separate document defining the variables. To create a "diabetes" variable, you would typically write a script with a series of `IF/THEN` statements or `CASE WHEN` logic, manually listing all the ICD-9 or ICD-10 codes that define the condition. This process is effective but has limitations: the code lists are often stored in separate documents, can be prone to transcription errors, and are not easily reusable across studies.

-   **In the OMOP/R Ecosystem:** We make this process more robust, transparent, and reusable. Instead of manually listing codes in a script, we use a pre-defined, clinically validated `concept_set`. This object is a container for all the standard `concept_id`s for our variable of interest.

**Analogy: A Centralized, Version-Controlled Protocol**

Think of the `concept_set` approach as moving your variable definitions out of a static Word document and into a centralized, version-controlled library. The definition is created once, validated, and then simply referenced in any study that needs it. This is the direct equivalent of "defining a variable in a study protocol," but in a way that is machine-readable and directly tied to the analysis.

### Your First R Script. Connecting to Data and Defining a Variable

Here is a simple R script to get started. The comments explain each step and connect it to the concepts above.

```r
# Load the necessary libraries (think of these as specialized toolkits for OMOP data)
library(CDMConnector)
library(duckdb)

# --- Step 1: Connect to the Data ---
# In SAS/SPSS, you would typically open a file from a menu (e.g., File > Open > Data).
# In R, we do this programmatically by creating a connection to the database file.
db_file <- "omop_data.duckdb" # The name of your database file
con <- DBI::dbConnect(duckdb(), dbdir = db_file)

# --- Step 2: Create a Pointer to the OMOP Database ---
# This is a key difference. Instead of loading the entire dataset into your computer's memory,
# we create a 'cdm' object that is a lightweight pointer to the database tables.
# This allows us to work with massive datasets (billions of rows) efficiently.
cdmSchema <- "main"
cdm <- cdmFromCon(con, cdm_schema = cdmSchema, write_schema = "main")

# --- Step 3: Load a Standardized Variable Definition ---
# This is the core of the process. We are loading a pre-defined concept set for "Type 2 Diabetes".
# This function retrieves the list of all concept_ids that define our clinical idea.
diabetes_concept_set <- getCodelistFromConceptSet(
  id = 123, # This is an example ID for the concept set
  cdm = cdm,
  cdmSchema = cdmSchema
)

# You have now defined your 'diabetes' variable!
# The 'diabetes_concept_set' object now holds the complete, standardized definition
# for this clinical idea, ready to be used for analysis.
```



## 5. The Core Task - Creating Study Populations (Sub-Cohorts)

Now that you have defined a clinical variable (e.g., `diabetes_concept_set`), you can use it to identify and select patients. In this ecosystem, a group of patients selected for a study is called a **cohort**. Creating a new, more specific group from a larger one is called creating a **sub-cohort**.

This process is the direct equivalent of **applying inclusion and exclusion criteria** in a clinical trial. However, it's far more dynamic and powerful than the typical workflow in SAS or SPSS, especially when dealing with time.

### The Power of Temporal Windows

A critical aspect of any clinical study is understanding the timing of events. Did a diagnosis happen before a treatment? Did an outcome occur within a specific follow-up window?

-   **In SAS/SPSS:** Answering these questions often requires complex data manipulation. You would typically need to perform multiple `JOIN` or `MERGE` operations on different datasets, manually calculate date differences, and then apply filters. This process can be cumbersome, error-prone, and needs to be re-written for every new temporal question.

-   **In the OMOP/R Ecosystem:** We can specify these temporal relationships directly and expressively when defining a cohort. This is done using a **window**, which is a defined time interval relative to an event.

Let's build on our previous example. We have our `diabetes_cohort`. Now, let's define a **target cohort**: patients with diabetes who are newly initiated on a specific treatment, say, "Metformin." The first prescription of Metformin will be our **index event**.

Then, we can define a **source cohort** (or control group) of patients with diabetes who have *not* been exposed to Metformin.

### Example. Defining Treatment and Control Cohorts

This example demonstrates how to build a "new user" cohort for a drug and apply temporal criteria.

```r
# Load the CohortConstructor library, our main tool for building cohorts
library(CohortConstructor)

# --- Step 1: Define our treatment variable ---
# Assume we have already loaded a concept set for "Metformin"
metformin_concept_set <- getCodelistFromConceptSet(id = 456, cdm = cdm, cdmSchema = cdmSchema)

# --- Step 2: Create a cohort of all Metformin users ---
cdm$metformin_users <- cdm |>
  conceptCohort(
    conceptSet = metformin_concept_set,
    name = "metformin_users"
  )

# --- Step 3: Define the Target Cohort (New Users of Metformin with Diabetes) ---
# Here, we apply our inclusion and exclusion criteria with temporal windows.
cdm$target_cohort <- cdm$metformin_users |>
  # Inclusion Criterion 1: Must have a diabetes diagnosis BEFORE or ON the day of the first Metformin prescription.
  # The window c(-Inf, 0) means from the beginning of their record up to and including day 0 (the index date).
  requireCohortIntersect(
    targetCohortTable = "diabetes_cohort",
    window = c(-Inf, 0)
  ) |>
  # Inclusion Criterion 2: Must be a "new user" of Metformin.
  # We require at least 365 days of observation history BEFORE the first prescription
  # with NO prior Metformin prescriptions in that window.
  requirePriorObservation(days = 365) |>
  requireCohortIntersect(
    targetCohortTable = "metformin_users",
    targetCohortId = 1, # Referring to the same Metformin cohort
    window = c(-365, -1), # Look in the window from 365 days before to 1 day before the index date
    count = 0 # The requirement is that we find ZERO metformin prescriptions in this window
  )

# --- Step 4: Define the Source/Control Cohort (Diabetes patients NOT on Metformin) ---
cdm$source_cohort <- cdm$diabetes_cohort |>
  # Exclusion Criterion: Must NOT have any Metformin prescription at any time.
  requireCohortIntersect(
    targetCohortTable = "metformin_users",
    window = c(-Inf, Inf), # Look across their entire record
    count = 0 # Find zero occurrences
  )
```

### What We've Accomplished

In this single, readable script, we have performed a series of complex operations that would be much more verbose in other systems:

1.  **Defined a Target Cohort:** We've identified new users of Metformin who have a prior diagnosis of diabetes. The logic is self-documenting and transparent.
2.  **Defined a Source Cohort:** We've created a potential control group of diabetes patients who are not treated with Metformin.
3.  **Embedded Temporal Logic:** The use of `window` arguments makes complex time-based inclusion/exclusion criteria explicit and easy to understand.

This structured, function-based approach allows you to rapidly define and redefine cohorts, test different study designs, and ensure your logic is applied consistently and correctly every time. It transforms the process of cohort definition from a manual data manipulation task into a core part of the reproducible scientific analysis.



## 6. The Payoff - Getting Results (Tables & Plots)

This is the "aha!" moment where the process yields the familiar, tangible outputs you are used to seeing. After defining your variables and constructing your study cohorts, the final step is to summarize their characteristics and visualize the results.

### The Goal. From Raw Data to Insightful Summaries

A cornerstone of any clinical study is **"Table 1,"** which describes the baseline characteristics of the study population. This table is essential for understanding the patient group, assessing potential confounders, and comparing treatment arms.

-   **In SAS/SPSS:** Creating a "Table 1" is a multi-step, manual process. You would typically run separate procedures (`PROC FREQ` for categorical variables, `PROC MEANS` for continuous) for each variable of interest. Then, you would need to copy the outputs, combine them in a spreadsheet, format them, and manually calculate percentages or standard deviations. This process is labor-intensive, prone to copy-paste errors, and must be repeated from scratch if the cohort definition changes.

-   **In the OMOP/R Ecosystem:** We automate this entire workflow. The tools are designed to understand the structure of your cohorts and can generate comprehensive summary tables and plots with just a few commands. The process is fast, reproducible, and directly linked to your live cohort definitions.

### Example. Generating "Table 1" and Plots for Our Cohorts

Let's use the `target_cohort` (new Metformin users with diabetes) and `source_cohort` (diabetes patients not on Metformin) that we created in the previous section. We want to compare their baseline characteristics.

```r
# Load the libraries for cohort characterization and visualization
library(CohortCharacteristics)
library(visOmopResults)
library(dplyr) # Also load dplyr for data manipulation

# --- Step 1: Combine the cohorts into a single table for comparison ---
# We add a 'cohort_name' column to distinguish between the two groups
# This is similar to having a 'TREATMENT_GROUP' column in a clinical trial dataset
cdm$comparison_cohort <- bind(
  cdm$target_cohort |> mutate(cohort_name = "Metformin Users"),
  cdm$source_cohort |> mutate(cohort_name = "Non-Metformin Users")
)

# --- Step 2: Generate a comprehensive summary of characteristics ---
# The 'summariseCharacteristics' function automatically calculates demographics,
# and can be extended to include comorbidities, medications, and more.
# We use 'group' to tell the function to calculate statistics separately for each cohort.
characteristics_summary <- summariseCharacteristics(
  cdm$comparison_cohort,
  group = list("cohort_name")
)

# --- Step 3: Create a Publication-Ready "Table 1" ---
# The 'tableCharacteristics' function takes the summary object and formats it
# into a polished, publication-ready table.
tableCharacteristics(characteristics_summary)

# --- Step 4: Visualize a Key Characteristic ---
# We can also easily plot the results. For example, let's visualize the age distribution.
plotCharacteristics(
  characteristics_summary,
  variable = "age_group",
  plotType = "barplot"
)
```

### What We've Accomplished

With just a few lines of code, we have achieved what would have taken hours of manual work in other systems:

1.  **Automated Summary:** The `summariseCharacteristics` function intelligently calculated counts and percentages for categorical variables (like sex and age group) for both of our cohorts simultaneously.
2.  **Instant Publication-Ready Table:** `tableCharacteristics` produced a formatted "Table 1" that is ready to be included in a report, comparing our two study groups side-by-side.
3.  **Reproducibility:** If we go back and change the definition of our cohorts (e.g., modify a time window), we simply re-run this script, and the table and plot will update automatically. There is no risk of manual transcription errors.

This streamlined process—from cohort definition to final output—not only saves a tremendous amount of time but also dramatically improves the transparency and reproducibility of your research.



## 7. The Path Forward - Performing Analysis

The steps we have walked through—defining variables, creating cohorts, and generating baseline characteristics—are the foundational activities of any observational study. They ensure you have the right population and have described it accurately.

From here, a whole ecosystem of specialized R packages is available to perform more advanced analyses, including:

*   [**`IncidencePrevalence`**](https://darwin-eu.github.io/IncidencePrevalence/): To calculate how often conditions occur.
*   [**`CohortSurvival`**](https://darwin-eu-dev.github.io/CohortSurvival/): To perform time-to-event (survival) analysis.
*   [**`DrugUtilisation`**](https://darwin-eu.github.io/DrugUtilisation/): To study patterns of medication use.

You now understand the complete workflow: from a clinical idea, to a standardized `concept_set`, to a study `cohort`, and finally to the tables and figures that will form the core of your research findings.

Welcome to the OMOP Community of RWE;
