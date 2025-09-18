---
layout: default
title: Analytics Workflow
nav_order: 2
parent: Data Analysis
---

# Core Analytics Workflow

## Purpose and Scope

This document explains the standard analytical pipeline used in the IOMED Data Space Platform R package ecosystem for conducting studies with OMOP Common Data Model (CDM) databases. The workflow covers the complete process from initial database connection through cohort construction to specialized epidemiological analyses.

For information about individual R packages, see [R Package Reference](../../docs/package_reference). For educational materials and presentations, see [Educational Materials](../../docs/educational_materials). For technical setup and deployment details, see [Development and Deployment](../../docs/development_and_deployment).

## Workflow Overview

The core analytics workflow follows a standardized five-phase pipeline that transforms raw OMOP CDM data into validated research results. Each phase builds upon the previous one and leverages specific R packages designed for interoperability.

## Phase 1: Database Connection and Exploration

The workflow begins by establishing a connection to an OMOP CDM database and performing initial exploration to understand the data characteristics.

Key functions in this phase include:
- `cdmFromCon()` - establishes the CDM reference with specified schemas and prefixes
- `summariseOmopSnapshot()` - provides database overview including vocabulary version and table sizes
- `summariseObservationPeriod()` - analyzes observation period coverage and duration
- `summariseClinicalRecords()` - examines record counts and data quality across clinical tables

## Phase 2: Concept and Population Definition

This phase involves defining the medical concepts of interest and constructing patient cohorts based on these concepts. The `CodelistGenerator` package provides systematic methods for identifying relevant medical concepts, while `CohortConstructor` transforms these concepts into patient cohorts.

Base cohort creation functions:
- `conceptCohort()` - creates cohorts based on clinical concepts
- `demographicsCohort()` - creates cohorts based on demographic criteria
- `measurementCohort()` - creates cohorts based on measurement values
- `deathCohort()` - creates cohorts based on death records

## Phase 3: Population Analysis

Once cohorts are defined, this phase characterizes the study populations through descriptive statistics and demographic analysis. The `CohortCharacteristics` package provides comprehensive population analysis capabilities.

## Phase 4: Specialized Studies

This phase applies domain-specific analytical methods for epidemiological and pharmacoepidemiological studies.

## Phase 5: Results and Validation

The final phase focuses on result validation, quality assessment, and output formatting for publication or further analysis.
