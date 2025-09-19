---
layout: default
title: Data Enablement
nav_order: 1
has_children: false
---

# Preparing a Hospital for Research

The Data Space Platform prepares a Data Holder’s clinical data for secondary use in research. This process, called Data Enablement, enhances a hospital’s ability to participate in multicenter research, improve operations, and support clinical decision-making.

The enablement process is divided into three main phases:

1.  **Dimensioning:** Analysis and need understanding.
2.  **Deployment:** Go-to architecture for hospital organizations.
3.  **Readiness:** Ensuring data holders are prepared.

## 1. Dimensioning: Analysis and Need Understanding

The first step is to understand the hospital's existing data landscape. This involves a thorough analysis of three key areas:

### Data Sources

We identify all clinical systems that hold patient data, such as:

*   Electronic Health Records (EHRs)
*   Laboratory Information Systems (LIS)
*   Radiology Information Systems (RIS)
*   Prescription systems

We then analyze the content and format of these sources, which can range from relational databases to flat files, HL7, or FHIR.

### Data Codifications and unstructured sources

We analyze the coding systems used for structured data. We determine if the hospital uses standard systems like SNOMED CT, LOINC, or ICD-10, or if it uses internal, local codes. If non-standard codes are used, we can apply Natural Language Processing (NLP) to map them to the OMOP Common Data Model.

### Data Infrastructure

We analyze the location and governance of the hospital's data sources, whether they are on-premise, in the cloud, or on a third-party location.

## 2. Deployment and Core Processes

Once we have a clear understanding of the hospital's data landscape, we deploy our platform and begin the core data processing. Our architecture is adaptable to the specific requirements of each hospital, but the fundamental processes of extraction, transformation, and loading (ETL) remain the same.

### ELT Process: From Raw Data to OMOP CDM

The ELT (Extract, Load, Transform) process transforms raw data from various hospital systems into the standardized OMOP Common Data Model.

1.  **Extraction:** We extract data from the identified sources, including both structured data (e.g., lab results, diagnosis codes) and unstructured data (e.g., clinical notes).
2.  **Load:** The raw data is loaded into the Data Space environment within the hospital's secure infrastructure.
3.  **Transformation:** Once loaded, the transformation process begins. This is the most critical step, where we clean, standardize, and harmonize the data. This includes two key AI-driven processes:
    *   **Automated Terminology Mapping (ATM):** For structured data, our AI models map different coding systems—whether international standards or internal hospital codes—to a single, standard OMOP vocabulary. For example, different codes for "hemoglobin" from different systems will be mapped to the single correct OMOP concept for hemoglobin.
    *   **Natural Language Processing (NLP):** For unstructured text, our NLP models extract clinically relevant information. The models identify medical concepts (like diagnoses, medications, and symptoms), understand their context (e.g., negation, family history, current vs. past conditions), and map them to the appropriate OMOP concepts.

### Anonymization

Throughout the ETL process, we apply a robust, two-step anonymization process to protect patient privacy:

1.  **Identifier Removal:** We detect and hash personal identifier fields, such as names and ID numbers, and then remove or replace them.
2.  **Text Anonymization:** We use a combination of pattern matching and probabilistic models to identify and remove personal data from unstructured text, such as clinical notes.

![](/assets/images/anonymization.svg)

## 3. Readiness: Ensuring Data Holders are Prepared

Once the deployment and data processing pipelines are in place, we ensure the hospital is ready for data mediation. This involves four key areas of readiness:

### Technical Readiness

*   **Data Structuring & Normalization:** Data from all hospital sources is activated and normalized to the OMOP Common Data Model.

### AI Readiness

*   **Expansion of the Data Space:** Automated Terminology Mapping (ATM) and Natural Language Processing (NLP) are used to extract and normalize both structured and unstructured data.

### Mediation Readiness

*   **Hospital Approval Process:** A workflow is established for the hospital to approve research projects.
*   **Industry Engagement:** We facilitate engagement with industry stakeholders for multicenter research projects.
*   **Contract Management:** We manage the contractual agreements for data use.

### Compliance Readiness

*   **Master Services Agreement (MSA):** An MSA is established for the deployment and use of data.
*   **Data Anonymization:** We ensure that data is fully anonymized for data users and pseudonymized for data holders, in compliance with GDPR.
