---
layout: default
title: Population-Level Epidemiology
parent: Standardised Analytics
grand_parent: Data Analysis
nav_order: 1
---

# Population-Level Epidemiology Guide

## Introduction & Purpose

Population-Level Epidemiology studies are designed to answer the most fundamental questions in public health: how common is a disease within a population, and is its frequency changing over time? This methodology provides a high-level, panoramic view of a disease's burden on a community or healthcare system, which is essential for planning public health policies, allocating resources, and identifying emerging health trends.

The purpose is to quantify the frequency of health outcomes at a population level, typically by measuring:

*   **Incidence**: The rate of **new cases** of a disease in a population over a specific period. This helps us understand the risk of developing the disease.
*   **Prevalence**: The proportion of a population that **currently has a disease** at a specific point in time (point prevalence) or over a period (period prevalence). This helps us understand the overall burden of the disease.

## Study Design

The standard design for this analysis is a **population-level cohort study**. This involves taking the entire population captured within a database and following them over a defined period of calendar time to observe the occurrence of health outcomes.

### Participants

The study typically includes the **entire source population** available in the database who have a minimum period of data visibility (e.g., at least one year) before the study's start date. Key considerations for defining the participant group include:

*   **For Incidence Calculation**: To measure only *new* cases, individuals who have a history of the disease (prevalent cases) are excluded from the analysis. This "washout" period ensures that the cases being counted are genuinely new diagnoses.
*   **Subpopulations**: The analysis can be restricted to specific subpopulations of interest, for example, by limiting the study to people over a certain age or with a specific clinical history.

### Outcomes

The primary outcomes are the calculated rates of incidence and prevalence for the disease of interest. These are typically stratified by:

*   **Demographics**: Age groups and gender.
*   **Time**: Calendar year, month, or quarter to observe trends.

### Follow-up

The follow-up for the study begins at a pre-defined calendar date (the index date) and continues for a specified period (e.g., one year). This process is often repeated for multiple consecutive periods to generate trend data over several years.

### Analyses

The analytical approach is descriptive. The core calculations are:

*   **Incidence Rate**: The number of newly diagnosed people (the numerator) divided by the total person-time at risk in the population (the denominator).
*   **Prevalence**: The number of people with the diagnosis (both new and pre-existing) divided by the total number of people in the source population at a specific point in time or over a period.

## How to Implement This Study

*Code examples and step-by-step instructions will be added here.*
