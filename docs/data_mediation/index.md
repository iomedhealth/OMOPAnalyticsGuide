---
layout: default
title: Data Mediation
nav_order: 2
has_children: true
---
# Data Mediation

This process prepares clinical data for research. It is a
multi-phase process that ensures data integrity, regulatory compliance, and
scientific quality.

First, we prepare the data. This involves partnering with hospitals, getting ethical approval, and standardizing data from different sources. Next, we execute the data mediation. We define research goals, identify patient groups, select relevant data, and check data quality. We use AI techniques like Natural Language Processing (NLP) and Automated Terminology Mapping (ATM) to extract accurate and complete information.

The key stages of this process include:

## Mediation Request

Researchers initiate a request by developing a protocol, defining the required clinical variables (concept sets), and specifying the patient population (cohort). This ensures the study is scientifically valid and provides data holders with full transparency.

This stage includes:

*   **Establishing Institutional Partnerships and Ethical Compliance:** We build strong partnerships with hospitals, establishing formal agreements that define data access, ethical duties, and compliance with regulations like GDPR and HIPAA.
*   **Data Access and System Integration:** We access hospital data from various systems (EHRs, LIS, RIS, PMS) and use data extraction pipelines to retrieve both structured and unstructured data.
*   **Patient Data Privacy:** We protect patient privacy through a two-step anonymization process. First, we remove all personally identifiable information (PII) and assign a random, unique ID to each person. Second, we use Natural Language Processing (NLP) to anonymize clinical notes.

## Mediation Approval

Data holders review the request, secure necessary approvals from ethics committees, and finalize contractual agreements before granting access to the data. IOMED helps submit study plans to institutional review boards (IRBs) and ethics committees to ensure the research protects patient rights and privacy.

## Quality Assurance

We perform rigorous checks to validate the data against the original request. This includes automated verification and validation by clinical experts to ensure the dataset is accurate, complete, and clinically plausible.

Our comprehensive Quality Assurance (QA) framework includes:

*   **ETL Process:** We use the Extract, Transform, and Load (ETL) process to standardize data to the OMOP Common Data Model (CDM). This involves extracting raw data, transforming it for consistency, and loading it into a structured database.
*   **AI-Driven Terminology Mapping:** We use Automated Terminology Mapping (ATM) to map local hospital codes to standard OMOP `concept_ids`, ensuring consistent data across different sites.
*   **NLP-Enabled Extraction:** We use advanced NLP to extract clinically relevant information from unstructured text like doctor's notes and discharge summaries.
*   **Remote Source Data Verification (rSDV):** Medical experts compare AI-generated data with original medical records to ensure accuracy.
*   **False Negative Detection:** We use text similarity to find and correct cases where our system missed relevant medical information.

## Compliance and Delivery

After a final compliance check, the fully anonymized and standardized dataset is securely delivered to the researcher. The software is installed on the hospital's servers, so they always keep control of their data. All data is created and stored within the hospital's system and is anonymized on their servers.
