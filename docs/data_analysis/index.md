---

layout: default
title: Data Analysis
nav_order: 3
has_children: true

---

# Executing an Observational Study
{: .no_toc }

Observational studies using real-world data (RWD) are essential for
understanding disease, treatment effectiveness, and patient outcomes in a
real-world setting. The OMOP Common Data Model (CDM) provides the global
standard for structuring this data, enabling transparent and reproducible
research across different healthcare databases.

To harness the power of the OMOP CDM, a suite of specialized R packages has
been developed. These packages provide a robust framework for every stage of an
observational study, from defining patient populations to generating final
results. Using this standardized toolkit ensures that research is not only
efficient but also adheres to the highest scientific standards, as promoted by
regulatory bodies like the European Medicines Agency (EMA) through initiatives
such as DARWIN EU.

This guide provides a practical, step-by-step framework for executing an
observational study using these tools. For a conceptual overview of how to map
common research questions to these packages, please see [Core Libraries for Observational Data Analysis](./core_libraries.md).


## Package Categories and Purposes

### Foundation Layer
These are the core packages that establish the connection to the database and
provide the basic infrastructure for all other operations.

| Library | Purpose |
| :--- | :--- |
| [**`omopgenerics`**](https://darwin-eu.github.io/omopgenerics/) | Provides a common set of classes and methods to ensure interoperability between different OHDSI packages. |
| [**`CDMConnector`**](https://darwin-eu.github.io/CDMConnector/) | Establishes and manages the connection to an OMOP CDM database, creating the `cdm` object. |
| [**`omock`**](https://ohdsi.github.io/omock/) | A utility for creating mock `cdm` objects for testing and development purposes. |

### Cohort Generation Layer
These packages are used to define and create the patient populations (cohorts)
that form the basis of any study.

| Library | Purpose |
| :--- | :--- |
| [**`CodelistGenerator`**](https://darwin-eu.github.io/CodelistGenerator/) | Creates codelists (sets of medical codes) from OMOP concept sets. |
| [**`CohortConstructor`**](https://ohdsi.github.io/CohortConstructor/) | Builds patient cohorts from codelists and other criteria, such as temporal windows or intersections with other cohorts. |

### Analysis Layer
This layer contains packages that perform specific types of epidemiological or
characterization analyses on the generated cohorts.

| Library | Purpose |
| :--- | :--- |
| [**`CohortCharacteristics`**](https://darwin-eu.github.io/CohortCharacteristics/) | Summarizes the baseline characteristics of a cohort, including demographics, comorbidities, and other features. |
| [**`IncidencePrevalence`**](https://darwin-eu.github.io/IncidencePrevalence/) | Calculates the incidence and prevalence of health outcomes within a study population. |
| [**`DrugUtilisation`**](https://darwin-eu.github.io/DrugUtilisation/) | Analyzes patterns of drug use, such as treatment pathways and adherence. |
| [**`CohortSurvival`**](https://darwin-eu-dev.github.io/CohortSurvival/) | Performs time-to-event (survival) analysis to estimate the risk of outcomes over time. |
| [**`PatientProfiles`**](https://darwin-eu.github.io/PatientProfiles/) | Adds detailed demographic and clinical features to patient cohorts for in-depth characterization. |
| [**`OmopSketch`**](https://ohdsi.github.io/OmopSketch/) | Provides a quick summary or "sketch" of the data in an OMOP CDM instance. |

### Validation Layer
This layer is focused on quality control and ensuring the clinical validity of
the cohort definitions.

| Library | Purpose |
| :--- | :--- |
| [**`PhenotypeR`**](https://ohdsi.github.io/PhenotypeR/) | Provides a comprehensive suite of diagnostics to evaluate and validate the quality of clinical phenotype definitions. |

### Visualization & Reporting Layer
These packages are used to generate the final outputs of a study, including
tables, figures, and interactive applications.

| Library | Purpose |
| :--- | :--- |
| [**`visOmopResults`**](https://darwin-eu.github.io/visOmopResults/) | Creates standardized visualizations and tables from the results of other OHDSI packages. |
| [**`ggplot2`**](https://ggplot2.tidyverse.org/) | A general-purpose and highly flexible plotting library used for creating custom visualizations. |

For a detailed, step-by-step guide on performing an observational study analysis, see [Performing an Analysis](./performing_analysis.md).
