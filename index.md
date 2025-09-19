---
layout: home
title: Home
nav_order: 0
---

# Health Data Space Platform

Clinical data generated during routine patient care is a primary source of
real-world evidence. However, its direct use in research is impeded by three
fundamental, widely recognized challenges:

1.  **Lack of Standardization:** Clinical data is captured in diverse,
    unstructured formats across different healthcare systems. This
    heterogeneity makes it impossible to aggregate and analyze the data at
    scale. A single condition, for instance, may be recorded using dozens of
    non-standard local terms.
2.  **Patient Privacy Requirements:** Health records contain sensitive personal
    information protected by stringent regulations like GDPR. Any use for
    research requires the removal of all identifiers—a complex and specialized
    process.
3.  **Operational Barriers:** Preparing data for research demands significant
    technical expertise, time, and resources, which are often beyond the scope
    of individual healthcare or research institutions.

IOMED provides the infrastructure and processes to bridge this gap, converting
raw clinical data into a standardized, privacy-compliant resource for
scientific investigation.

![](/assets/images/mediation.png)

### For Healthcare Institutions (Data Holders)

Our platform provides hospitals and other data custodians with the tools to
prepare their data for research while ensuring it never leaves their secure
environment. We enable institutions to:

*   **Standardize Clinical Data:** We process and map disparate data from
    electronic health records to the OMOP Common Data Model, a global standard
    for observational research. This creates a uniform
    structure, allowing for consistent interpretation and analysis. Advanced
    Artificial Intelligence (AI) driven techniques, including Natural Language
    Processing (NLP) and Automated Terminology Mapping (ATM), enhance the
    completeness of extracted information.
*   **Protect Patient Privacy:** Our system applies robust anonymization
    techniques to remove all personally identifiable information. This process
    ensures the resulting dataset complies with data protection regulations.
*   **Maintain Control and Compliance:** The entire data preparation process is
    auditable and governed by clear protocols, giving institutions full
    oversight and ensuring regulatory adherence.

### For Research Organizations (Data Users)

We provide researchers with a streamlined and compliant method to access the
specific data required for their work. Our platform allows them to:

*   **Define and Request Datasets:** Researchers can construct precise queries
    to define patient cohorts and specify the exact variables needed for their
    study, requesting access to a dataset tailored to
    their research question.
*   **Access Research-Ready Data:** We deliver fully anonymized, standardized,
    and quality-checked datasets. This allows research teams to proceed
    directly to analysis, confident that the data is
    reliable and has been sourced ethically and legally.
*   **Ensure Data Integrity:** We implement a multi-layered Quality Assurance
    framework with automated checks and expert validation to verify the
    accuracy, completeness, and plausibility of the data.


## Health Data Mediation

IOMED’s Health Data Mediation transforms raw clinical data into a standardized,
research-ready resource. Our structured approach ensures data integrity,
regulatory compliance, and scientific rigor. The process begins with data
preparation, where we establish partnerships with data holders, secure ethical
approvals, and integrate disparate data sources into a uniform format.

Following preparation, we execute the Data Mediation, which involves defining
research objectives, identifying patient cohorts, specifying the data of
interest, and verifying data quality. This ensures that the final dataset is
tailored to the specific research question and meets the highest standards of
quality and reliability. You can find a more detailed explanation in our [Data
Mediation documentation](./docs/data_mediation/index.md).

![](/assets/images/mediation.svg)

The key stages of this process include:

*   **Mediation Request:** Researchers initiate a request by developing a
    protocol, defining the required clinical variables (concept sets), and
    specifying the patient population (cohort). This ensures the study is
    scientifically valid and provides data holders with full transparency.

*   **Mediation Approval:** Data holders review the request, secure necessary
    approvals from ethics committees, and finalize contractual agreements
    before granting access to the data.

*   **Quality Assurance:** We perform rigorous checks to validate the data
    against the original request. This includes automated verification and
    validation by clinical experts to ensure the dataset is accurate, complete,
    and clinically plausible.

*   **Compliance and Delivery:** After a final compliance check, the fully
    anonymized and standardized dataset is securely delivered to the
    researcher.

## Health Data Analysis

The Health Data Analysis phase transforms raw clinical data into research-ready
datasets for scientific investigation. This process is governed by rigorous
protocols to ensure data quality, patient privacy, and regulatory compliance.
You can find a more detailed explanation in our [Data Analysis
documentation](./docs/data_analysis).

*   **Flexible Analysis Options**: We offer two models for data analysis.
    Researchers can receive the final, anonymized dataset, or for maximum
    security, the analysis can be executed within the data holder's
    infrastructure using R packages or Atlas and receive only aggregated
    results.

This documentation page serves as a comprehensive educational site for the Data
the Data Analysis process using the OHDSI R packages. This includes a
comprehensive introduction and tutorial to the R package ecosystem for
executing real-world evidence studies using the OMOP Common Data Model (CDM).

