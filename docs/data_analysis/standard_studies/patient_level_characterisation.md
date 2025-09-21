---
layout: default
title: Patient-Level Characterisation
parent: Standardised Analytics
grand_parent: Data Analysis
nav_order: 2
---

# Patient-Level Characterisation Guide

## Introduction & Purpose

A Patient-Level Characterisation study is the observational research equivalent of creating a "Table 1" in a clinical trial. Its primary purpose is to generate a detailed clinical and demographic profile of a specific group of patients (a cohort). This answers the fundamental question: "Who are these patients?"

This type of analysis is a cornerstone of transparent and reproducible research. By providing a comprehensive baseline description of the study population, it helps researchers and readers understand the context of the study, assess the generalisability of the findings, and identify potential sources of confounding or bias.

## Study Design

The design is a **descriptive cohort analysis**. It focuses on summarising the characteristics of one or more cohorts of patients at a specific point in time (the index date), or within a defined time window before it.

### Participants

The study includes one or more cohorts of interest. These cohorts are typically defined by a shared characteristic, such as:

*   A new diagnosis of a specific condition.
*   The initiation of a particular medication.
*   Undergoing a specific medical procedure.

A key requirement is that participants have a period of data visibility (e.g., one year) *before* their index date to allow for the assessment of baseline characteristics.

### Exposures / Covariates

In this context, there is no "exposure" in the comparative sense. Instead, the analysis focuses on summarising a wide range of patient **covariates** (characteristics) present at or before the index date. These can include:

*   **Demographics**: Age, gender, race, ethnicity.
*   **Clinical History**: All recorded medical conditions, often summarised into comorbidity scores like the Charlson Comorbidity Index.
*   **Medication History**: All prior medications the patients have used.
*   **Procedures**: A history of medical procedures.

### Outcomes

The "outcomes" of this study are the summary statistics for the covariates of interest. The analysis produces tables and visualisations that describe the distribution of these characteristics within the cohort. This can include:

*   **For categorical variables**: Frequencies and percentages (e.g., % of patients with a history of diabetes).
*   **For continuous variables**: Means, medians, and standard deviations (e.g., mean age of the cohort).

### Follow-up

There is typically no follow-up period *after* the index date in a pure characterisation study. The focus is entirely on the baseline period *before* the index date.

### Analyses

The analysis is descriptive and involves summarising the covariates. This can be done in two ways:

1.  **Large-Scale Characterisation**: An automated process that summarises thousands of clinical features from the database to provide an unbiased, data-driven overview of the cohort.
2.  **Pre-Specified Characterisation**: An analysis focused on a limited set of clinically important covariates that have been defined in advance by the researchers.

The results are typically presented in a summary table, often referred to as "Table 1," which provides a comprehensive snapshot of the cohort.

## How to Implement This Study

*Code examples and step-by-step instructions will be added here.*
