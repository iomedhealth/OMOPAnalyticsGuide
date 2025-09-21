---

layout: default
title: Data Solutions
nav_order: 1
parent: Data Mediation

---

# Data Solutions

1. TOC
{:toc}


Once a Data Holder (e.g., a hospital) has its data standardized and ready for
research through the "Enablement" phase, the mediation process can begin. This
involves connecting Data Holders and Data Users through a secure platform that
manages the entire lifecycle of a data request. The platform offers several
distinct data solutions, each designed for a specific need and use case.

### Patient Count (PC)

Patient Count is a simple but powerful feasibility tool, directly analogous to running a **preliminary query against a clinical trial database to determine the number of eligible patients** for a potential study or a sub-analysis. It allows a Data User
to input specific inclusion and exclusion criteria (e.g., "female patients over
50, diagnosed with type 2 diabetes, prescribed metformin, with no history of
heart failure") and receive an aggregated number of patients who match these
criteria across the network.

* **What it Delivers:** An exact, aggregated number of matching patients.
* **Example:** A pharmaceutical company wants to launch a clinical trial for a
  new oncology drug. Before investing millions, they use Patient Count to
  quickly determine if there are enough eligible patients across the network to
  make recruitment viable. This provides a fast, data-backed "go/no-go"
  decision.

### Aggregated Patient Characterisation (APC)

This solution provides complex, aggregated data analysis and characterization
of a patient cohort across multiple hospitals. It allows users to understand
population-level statistics, trends, and patterns without ever accessing
individual patient records. The output is typically in the form of summary
tables, charts, and statistical analyses, similar to the **full set of descriptive statistics and characterization tables** generated for a study, going beyond just a single baseline demographics table.

The analysis can be executed in one of two secure ways:

* **Via an ATLAS instance:** Data Users can perform their analysis through a
  dedicated ATLAS instance that is configured to only allow for aggregated
  analytics. The system enforces privacy by setting limits (e.g., minimum
  cohort sizes) to ensure individual patient data is never exposed, and
  provides access to perform the analysis only in the individuals that comply
  with the selection criterias.
* **Via an R package:** Alternatively, the analysis can be run by executing a
  standardized and validated OHDSI (Observational
  Health Data Sciences and Informatics) analysis R package. This package follows a well-defined
  analysis pipeline, running the
  computation locally within the hospital's secure environment and returning
  only the final, aggregated results to the user.

The main result of this solution:

* **What it Delivers:** Anonymized, aggregated data tables and visualizations
  (e.g., mean age, distribution of comorbidities, common treatment pathways).
* **Example:** A public health organization wants to understand the real-world
  treatment patterns for patients with multiple sclerosis across different
  regions. They use this solution to get an aggregated view of the most common
  first-line and second-line therapies, patient demographics, and common
  comorbidities, helping them shape policy and clinical guidelines.

### Patient-Level Data (PLD)

This is one of the most in-depth solutions, providing a fully anonymized,
detailed, patient-specific dataset for a defined cohort. The most accurate analogy here is to receiving the **final, cleaned SDTM datasets** from a clinical trial. Like SDTM, the OMOP CDM is a standardized data model that organizes the source information into a consistent structure, but it is not yet an analysis-specific dataset. Further transformation is typically required to create analysis-ready variables. The data is exported
in the standardized OMOP format, making it ready for complex analysis,
statistical modeling, and evidence generation. The hospital retains full
control, approving the request before any data is exported.

* **What it Delivers:** A rich, longitudinal, anonymized dataset of individual
  patients.
* **Example:** A research institution is developing a predictive model to
  identify patients at high risk of developing kidney complications from
  diabetes. They request a patient-level dataset of diabetic patients,
  including their lab results, medications, diagnoses, and outcomes over five
  years. This deep data allows them to train and validate a robust algorithm
  for early diagnosis support.

### Patient Finder (PF)

The Patient Finder solution is specifically designed to accelerate clinical
trial recruitment. Data Users define the protocol criteria, and the system
identifies **a list of potentially eligible patients** within a hospital's
database. Crucially, `this list of patients is never shared with the data
user`. Instead, it is made available only to the hospital's principal
investigator or clinical staff, who can then review the patients' charts and
contact them about participating in the trial.

* **What it Delivers:** A secure, confidential list of eligible patient
  candidates, accessible only by authorized hospital personnel.
* **Example:** A CRO (Contract Research Organization) is struggling to recruit
  patients for a study on a specific hematologic malignancy. Using Patient
  Finder, they identify 40+ potential candidates at an existing site by
  searching through unstructured clinical notes—a source previously unavailable
  to them. The hospital's research team then uses this list to fast-track their
  recruitment efforts, saving significant time and money.

# Examples Across the Product Lifecycle

These data solutions can be applied across the entire lifecycle of a
therapeutic product, from early development to post-market surveillance.

| Phase | Common Use Cases | Primary Data Solution(s) Used |
| :---- | :---- | :---- |
| **Clinical Development** | Patient Identification & Recruitment, Retrospective Observational Studies | Patient Finder, Patient-Level Data, Patient Count |
| **Product Launch** | Disease Understanding, Mapping the Patient Journey, Population Profiling | Aggregated Patient Characterisation, Patient-Level Data |
| **Regulatory Approval** | Generating Real-World Evidence (RWE), Supporting Outcome-Based Agreements | Patient-Level Data, Aggregated Patient Characterisation |
| **Market Maturity** | Diagnosis Support, Health Economics and Outcomes Research (HEOR) | Aggregated Patient Characterisation, Patient-Level Data |


