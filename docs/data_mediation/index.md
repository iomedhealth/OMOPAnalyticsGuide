---
layout: default
title: Data Mediation
nav_order: 1
has_children: true
---
# Data Mediation

IOMED's data mediation process prepares clinical data for research. It is a multi-phase process that ensures data integrity, regulatory compliance, and scientific quality.

First, we prepare the data. This involves partnering with hospitals, getting ethical approval, and standardizing data from different sources. Next, we execute the data mediation. We define research goals, identify patient groups, select relevant data, and check data quality. We use AI techniques like Natural Language Processing (NLP) and Automated Terminology Mapping (ATM) to extract accurate and complete information.

## 1. Establishing Institutional Partnerships and Ethical Compliance

Our clinical research begins with strong partnerships with hospitals, which we call Data Holders. We are always expanding our network of hospitals to increase the amount and variety of clinical data available. This helps us conduct larger, more consistent research studies.

We establish formal agreements with hospitals that define data access, ethical duties, and compliance with regulations like GDPR and HIPAA. To protect patient data, we use encryption, monitor data access in real-time, and enforce strict role-based access. Our staff receives regular training on legal and ethical standards.

![](/assets/images/image13.png)

IOMED helps submit study plans to institutional review boards (IRBs) and ethics committees. These groups review our research to protect patient rights and privacy and to ensure scientific validity.

We work closely with hospital IT departments to implement these agreements. Our technical setup is designed to extract data efficiently without disrupting hospital workflows. We also train hospital staff on data governance, data-sharing policies, and privacy laws.

## 2. Data Access and System Integration

Accessing hospital data is a careful process to ensure high-quality databases. Hospitals use many different systems, such as Electronic Health Records (EHRs), Laboratory Information Systems (LIS), Radiology Information Systems (RIS), and Pharmacy Management Systems (PMS).

Because data is stored in different systems, it is often fragmented. To solve this, we audit the hospital's systems to check for data completeness and compatibility with the OMOP Common Data Model (CDM). The OMOP CDM is a standard format that allows us to combine and analyze health data from different sources.

![](/assets/images/image3.png)

We use data extraction pipelines to get both structured data (like lab results and diagnosis codes) and unstructured data (like doctor's notes). We manage this process carefully to avoid disrupting hospital operations.

To keep data secure, we use multi-layer encryption and strict, role-based access controls. Secure data transfer methods protect data during extraction and integration.

## 3. Patient Data Privacy

Protecting patient data privacy is a top priority. Our platform follows strict data protection rules to protect patient privacy and comply with GDPR and Spanish data protection laws.

### 3.1 Anonymization

GDPR considers health data a "special category" of personal data that requires extra protection. IOMED complies with GDPR and Spanish data protection laws. All data we process is anonymized.

Before processing, we anonymize all hospital data. We remove patient identifiers like patient numbers and assign a random, unique ID to each person. We remove all personally identifiable information (PII), such as names, phone numbers, and addresses. Only the random ID remains in the OMOP CDM database.

We use Natural Language Processing (NLP) to anonymize clinical notes. NLP algorithms find and replace names, phone numbers, and other PII with random content. The result is a structured database that cannot be linked to individuals without significant effort.

![Picture 3](/assets/images/anonymization.svg)

The software is installed on the hospital's servers, so they always keep control of their data. All data is created and stored within the hospital's system and is anonymized on their servers.

### 3.2 Patient Information and Informed Consent

Using AI to collect data from many electronic health records makes it difficult to get informed consent from every individual. However, we apply strong data protection and anonymization measures. Because the data is fully anonymized, it is not considered personal data under the Code of Best Practices in Data Protection for Big Data Projects.

Spanish law requires informed consent for some observational studies. For studies that use health and personal data from medical records, informed consent is generally required, even if the data is later dissociated. However, an ethics committee can waive this requirement for studies of high scientific interest where getting consent is not feasible, or when there is legal authorization to use the data.

## 4. ETL Process: Standardizing Data to OMOP CDM

After extracting data, we structure it in the OMOP CDM format. The Extract, Transform, and Load (ETL) process is how we refine, harmonize, and map datasets to OMOP concepts.

-   **Extract:** We retrieve raw data from hospital systems.
-   **Transform:** We clean, standardize, and format the data for consistency. This includes aligning different medical terminologies with standard OMOP vocabularies.
-   **Load:** We integrate the transformed data into a structured OMOP database for analysis.

![](/assets/images/image15.png)

This process is essential for large-scale research because it allows us to combine clinical data from different hospitals.

Automating the ETL pipeline makes it more efficient and allows for real-time updates as new patient data becomes available. This keeps research findings current and reduces errors.

## 5. AI-Driven Terminology Mapping for Data Harmonization

A major challenge in clinical research is that hospitals use different medical terminologies. Automated Terminology Mapping (ATM) is an AI-powered process that solves this problem. It maps local hospital codes to standard OMOP `concept_ids`. This ensures consistent data and research results across different sites.

![](/assets/images/image1.png)

We use machine learning algorithms to find connections between different terminologies. The system learns and improves over time as it encounters new mappings.

Although the process is automated, expert clinicians review and validate the mappings to ensure accuracy. We use a hybrid model that combines AI automation with rule-based checks for high precision.

We keep a complete audit trail of all mapping decisions. This provides transparency and allows for review. The audit trail helps investigators trace data transformations, verify mappings, and is important for regulatory compliance.

## 6. NLP-Enabled Extraction of Clinical Narratives

A lot of valuable clinical data is in unstructured text like doctor's notes, radiology reports, and discharge summaries. This text contains important details about a patient's condition and treatment that are not found in structured data fields. Extracting this data is essential for thorough clinical research.

IOMED uses advanced Natural Language Processing (NLP) to extract clinically relevant information from text. Our NLP pipeline uses:

-   **Named Entity Recognition (NER)** to identify medical terms like diagnoses, medications, and symptoms.
-   **Deep learning models** to understand complex relationships in the text, such as the timing of events or treatment outcomes.

![](/assets/images/image7.png)

Once extracted, we map these clinical terms to OMOP `concept_ids` to integrate them into our structured database.

The accuracy of NLP-extracted data is continuously checked. Physicians review the extracted information to help improve the model's accuracy. We also track performance metrics like precision and recall to measure improvement.

Our NLP models can also detect negation. This means they can tell if a condition was present, absent, or just discussed as a possibility (e.g., in family history). This makes the extracted data more precise.

## 7. Quality Assurance

Ensuring data integrity and reliability is a top priority. We have a comprehensive Quality Assurance (QA) framework to check that our data meets OMOP CDM standards.

Medical experts perform Remote Source Data Verification (rSDV), comparing AI-generated data with original medical records. We also use statistical checks to assess data completeness, consistency, and plausibility. Any errors we find are used to improve our AI models.

![](/assets/images/image2.png)

A key part of our QA process is finding false negatives—cases where our system missed relevant medical information. We use text similarity to find documents that likely contain false negatives. The system identifies records where a medical term was successfully found. It then looks for similar documents where that term is missing. This helps us find documents that likely contain undetected terms.

![](/assets/images/image5.png)

Human annotators then review these high-probability cases to confirm if a term was missed. This feedback loop helps us continuously improve the AI model and reduce the false negative rate.

In addition to rSDV for AI-generated data, we have a general validation process to check the quality of each data point in a data order. Our Quality and Clinical teams define a set of quality checks for data conformance, completeness, and plausibility.

Our Quality Check System (QCS) automates these checks and records the results (pass or fail) to monitor data quality. A Quality Assurance specialist reviews the results. If there is an issue, they log it in our Incident Management Platform (IMP). The IMP tracks the problem and any actions taken to fix it.

This continuous validation process improves the reliability of our data and the credibility of research conducted on our platform.
