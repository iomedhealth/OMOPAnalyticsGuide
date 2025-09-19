---
layout: default
title: Setup
parent: Data Analysis
nav_order: 1
---

# Getting Started

This document provides step-by-step instructions for setting up and configuring the IOMED Data Space Platform development environment. It covers the installation of required software, project configuration, and initial usage of the R package ecosystem for OMOP CDM analysis.

For information about specific analytical workflows, see [Core Analytics Workflow](../../docs/core_workflow). For detailed package documentation, see [Package Reference](../../docs/data_analysis/package_reference). For educational materials and presentations, see [Educational Materials](../../docs/educational_materials).


## Project Configuration

After installing the required software, configure the RStudio project using the provided project file. The project configuration includes specific settings for code formatting, encoding, and development workflow.

### RStudio Project Setup

The repository includes a preconfigured RStudio project file with standardized settings. To open the project correctly:

1.  Double-click the `.Rproj` file
2.  Verify the project name appears in the RStudio title bar
3.  Confirm the Files pane shows the repository structure

## R Package Ecosystem Installation

The course utilizes a comprehensive ecosystem of R packages for OMOP CDM analysis. These packages must be installed before beginning any analytical work.

### Core Package Dependencies

Install all required packages using the `install.packages()` function.

## Mock Database Configuration

1.  Download the Eunomia dataset.
2.  Configure the environment variable.
3.  Add the dataset path to `.Renviron`:
    `EUNOMIA_DATA_FOLDER = "full_path_to_eunomia_zip_file"`


## Basic Analytics Workflow

The package ecosystem follows a standardized workflow for real-world evidence
studies. This workflow begins with database connection and progresses through
cohort definition to specialized analyses.

## Setup Verification

After completing the installation and configuration steps, verify the
environment is correctly configured by running a test script. This verification
ensures all packages are properly installed and the database connection works
correctly.

### Verification Steps


**Common Verification Checkpoints:**

| Component | Verification Method | Expected Result |
| --- | --- | --- |
| R Packages | `library()` calls| No error messages |
| Database Connection | `cdmFromCon()`| Valid CDM object |
| Eunomia Dataset | `mockCdmFromDataset()`| Data tables loaded |
| Cohort Functions | `conceptCohort()`| Cohort created successfully |

## Next Steps

Once the environment is configured and verified, proceed to explore the core analytics workflow and specific package functionalities:

1.  **Database Exploration**: Use [`OmopSketch`](https://darwin-eu.github.io/OmopSketch/) to characterize your database structure
2.  **Concept Definition**: Create medical concept lists with [`CodelistGenerator`](https://darwin-eu.github.io/CodelistGenerator/)
3.  **Cohort Building**: Define patient populations using [`CohortConstructor`](https://ohdsi.github.io/CohortConstructor/)
4.  **Population Analysis**: Characterize cohorts with [`CohortCharacteristics`](https://darwin-eu.github.io/CohortCharacteristics/)
5.  **Specialized Studies**: Conduct domain-specific analyses with [`DrugUtilisation`](https://darwin-eu.github.io/DrugUtilisation/), [`IncidencePrevalence`](https://darwin-eu.github.io/IncidencePrevalence/), or [`CohortSurvival`](https://darwin-eu-dev.github.io/CohortSurvival/)
