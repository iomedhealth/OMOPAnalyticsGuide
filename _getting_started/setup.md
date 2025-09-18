---
layout: page
title: Setup
nav_order: 1
---

# Getting Started

This document provides step-by-step instructions for setting up and configuring the IOMED Data Space Platform development environment. It covers the installation of required software, project configuration, and initial usage of the R package ecosystem for OMOP CDM analysis.

For information about specific analytical workflows, see [Core Analytics Workflow](../core_workflow). For detailed package documentation, see [R Package Reference](../package_reference). For educational materials and presentations, see [Educational Materials](../educational_materials).

## Prerequisites and Installation Requirements

The IOMED Data Space Platform requires a specific development environment with R, RStudio, and supporting tools. The following software components must be installed in the correct order.

### Required Software Components

| Component | Minimum Version | Download Source |
| --- | --- | --- |
| R | 4.2+ | <https://cran.r-project.org/bin/windows/base/> |
| RStudio | Latest | <https://posit.co/download/rstudio-desktop/> |
| Rtools | Latest | <https://cran.r-project.org/bin/windows/Rtools/> |

## Project Configuration

After installing the required software, configure the RStudio project using the provided project file. The project configuration includes specific settings for code formatting, encoding, and development workflow.

### RStudio Project Setup

The repository includes a preconfigured RStudio project file with standardized settings. To open the project correctly:

1.  Double-click the `RealWorldEvidenceSummerSchool2025.Rproj` file
2.  Verify the project name appears in the RStudio title bar
3.  Confirm the Files pane shows the repository structure

## R Package Ecosystem Installation

The course utilizes a comprehensive ecosystem of R packages for OMOP CDM analysis. These packages must be installed before beginning any analytical work.

### Core Package Dependencies

Install all required packages using the `install.packages()` function.

## Mock Database Configuration

The course uses the Eunomia synthetic dataset for practical exercises. This mock database provides OMOP CDM-formatted data without requiring access to real patient information.

### Eunomia Dataset Setup

1.  Download the Eunomia dataset.
2.  Configure the environment variable.
3.  Add the dataset path to `.Renviron`:
    `EUNOMIA_DATA_FOLDER = "full_path_to_eunomia_zip_file"`

## Course Program Structure

The IOMED Data Space Platform follows a structured five-day program, with each day focusing on specific packages and analytical concepts.

### Daily Package Focus

| Day | Primary Packages | Focus Area |
| --- | --- | --- |
| Monday | `CDMConnector`, `OmopSketch`| Database connection and characterization |
| Tuesday | `CodelistGenerator`, `CohortConstructor`, `PhenotypeR`| Concept definition and cohort building |
| Wednesday | `CohortCharacteristics`, `IncidencePrevalence`| Population analysis and epidemiological measures |
| Thursday | `DrugUtilisation`, `CohortSurvival`| Specialized drug studies and survival analysis |

## Basic Analytics Workflow

The package ecosystem follows a standardized workflow for real-world evidence studies. This workflow begins with database connection and progresses through cohort definition to specialized analyses.

## Setup Verification

After completing the installation and configuration steps, verify the environment is correctly configured by running a test script. This verification ensures all packages are properly installed and the database connection works correctly.

### Verification Steps

The repository includes a verification script at `Analytics track/00_Setup/CodeToRun.R` that tests the complete setup. Successfully running this script confirms the environment is ready for course activities.

**Common Verification Checkpoints:**

| Component | Verification Method | Expected Result |
| --- | --- | --- |
| R Packages | `library()` calls| No error messages |
| Database Connection | `cdm_from_con()`| Valid CDM object |
| Eunomia Dataset | `mockCdmFromDataset()`| Data tables loaded |
| Cohort Functions | `conceptCohort()`| Cohort created successfully |

## Next Steps

Once the environment is configured and verified, proceed to explore the core analytics workflow and specific package functionalities:

1.  **Database Exploration**: Use `OmopSketch` to characterize your database structure
2.  **Concept Definition**: Create medical concept lists with `CodelistGenerator`
3.  **Cohort Building**: Define patient populations using `CohortConstructor`
4.  **Population Analysis**: Characterize cohorts with `CohortCharacteristics`
5.  **Specialized Studies**: Conduct domain-specific analyses with `DrugUtilisation`, `IncidencePrevalence`, or `CohortSurvival`
