---
layout: default
title: Data Mediation
nav_order: 1
has_children: true
---
# Data Mediation

Executing a Data Mediation with IOMED follows a structured, multi-phase approach designed to ensure data integrity, regulatory compliance, and scientific rigor. The process begins with data preparation, which includes establishing partnerships with hospitals, securing ethical approvals, and integrating disparate data sources into a standardized format.

Following data preparation, the Data Mediation execution phase focuses on defining the research objectives, identifying relevant patient cohorts and the data of interest, and verifying data quality. Advanced Artificial Intelligence (AI) driven techniques, including Natural Language Processing (NLP) and Automated Terminology Mapping (ATM), enhance the accuracy and completeness of extracted information.

## 1. Establishing Institutional Partnerships and Ethical Compliance

The initiation of a clinical research Data Mediation leveraging IOMED's infrastructure relies on the establishment of strong institutional partnerships with Data Holders. This process is not static but rather an ongoing effort to expand IOMED's federated hospital network. By continuously integrating new Data Holder, we enhance the depth and breadth of available clinical data, improving research scalability, and ensuring consistency in data harmonization across multiple healthcare systems.

Negotiating these partnerships entails formal contractual agreements that define the scope of data access, ethical obligations, and regulatory compliance at both national and international levels. Compliance with major regulatory frameworks, such as the General Data Protection Regulation (GDPR) in the European Union and the Health Insurance Portability and Accountability Act (HIPAA) in the United States, is fundamental to securing patient confidentiality and safeguarding sensitive information. These regulations require periodic compliance reviews, security assessments, and the implementation of strict data access protocols. To ensure continuous adherence, IOMED employs encryption mechanisms, real-time monitoring of data access, and stringent role-based access control. Staff undergo regular training to stay updated on evolving legal and ethical standards, reinforcing a culture of compliance across all participating Data Holders.

![](/assets/images/image13.png)

IOMED also facilitates the submission of study protocols to institutional review boards (IRBs) and ethics committees, ensuring rigorous oversight of data utilization. These bodies play a critical role in evaluating the ethical implications of the Data Mediation, ensuring that patient rights and privacy are upheld while also scrutinizing the research design for scientific validity.

The operationalization of these agreements is underpinned by close collaboration between IOMED and hospital IT departments. A dedicated technical framework is deployed to ensure minimal disruption to clinical workflows while maximizing data extraction efficiency. Furthermore, dedicated training sessions are provided to healthcare personnel, equipping them with the knowledge necessary to uphold data governance principles, follow institutional data-sharing policies, and ensure alignment with privacy laws. As more Data Holders join IOMED's federated network, the interoperability of data improves, leading to more robust and scalable research opportunities.

### 2. Data Access and System Integration

Accessing hospital data requires a methodologically rigorous approach to ensure high-quality, representative databases. Data Holders operate a complex network of digital systems, each hosting a subset of relevant patient data. The primary repositories include Electronic Health Records (EHRs), which document the patient's clinical history; Laboratory Information Systems (LIS), which store diagnostic test results; Radiology Information Systems (RIS), which contain imaging data; and Pharmacy Management Systems (PMS), which track medication prescriptions and administration records.

Given the decentralized nature of hospital data storage, data fragmentation is an inherent challenge. To address this, a comprehensive audit of the available information systems is conducted to assess completeness, standardization, and compatibility with the OMOP Common Data Model (CDM), a standardized framework designed to facilitate the interoperability and analysis of real-world healthcare data across multiple Data Holders. Integrating disparate datasets into a singular, analyzable format requires the implementation of sophisticated data extraction pipelines. These pipelines are designed to retrieve structured clinical variables such as lab results, diagnosis codes, and prescription records while also capturing unstructured textual data such as physician notes and discharge summaries. The integration process is carefully managed to ensure it does not disrupt routine hospital operations, thereby maintaining the continuity of patient care.

![](/assets/images/image3.png)

To further bolster security, multi-layered encryption protocols are established, preventing unauthorized access to patient records. Rigorous access controls, including role-based authentication, are enforced to restrict data access solely to authorized personnel. A secure data transfer mechanism is utilized to prevent breaches, ensuring that data integrity is maintained throughout the extraction and integration process.

### 3. Patient Data Privacy

Ensuring patient data privacy is of utmost importance when processing sensitive health information for secondary use. Therefore, the IOMED platform follows stringent data protection protocols to safeguard patient privacy and comply with the GDPR, as well as applicable Spanish data protection regulations.

#### 3.1  Anonymization

The GDPR defines health data and clarifies that it covers "data concerning health" and treats them as a "special category" of personal data which is considered to be sensitive by its nature. In this sense, IOMED complies with the General Data Protection Regulation (GDPR) of the EU and the Spanish data protection regulations for the processing of these data. Moreover, all data that IOMED processes is always anonymized.

All hospital data, before being processed for any purpose, is anonymized by IOMED. The existing unique patient identifiers, such as the patient number, will be discarded and a random unique identifier will be assigned to each user. All the personally identifiable information (PII) such as names and surnames of the patient, as well as professional career, family or medical data, telephone numbers, references to places or addresses, email addresses, etc. are discarded and only the anonymized identifier of the person is available in the OMOP CDM database.

A second anonymization process is performed in the clinical notes using NLP, where multiple algorithms are used to identify character strings for names, surnames, telephone numbers, references to places or addresses, email addresses, etc. and replaced by random content generate.

The result is a structured database, which cannot be associated with unique individuals without additional information and inordinate effort, time and cost considering currently available technologies.

Each site will always maintain custody of the data since the software will be installed on its servers. All the data created is stored within the hospital and no data will ever be stored outside its system. The data will be accessible from the site's database and will be anonymized on its servers.

![Picture 3](/assets/images/image14.png)

#### 3.2  Patient information and informed consent

The AI using machine learning and NPL methodologies to collect data from EHRs enables a large population to be included in the study, which hampers obtaining the ICs. However, appropriate data protection measures in terms of data storage and anonymization of datasets will be applied (section 7.6.2). As the study data will be entirely anonymized to avoid subject identification, collected data will not be considered as personal according to the Code of Best Practices in Data Protection for Big Data Projects.

According to the Ministerial Order SAS/3470/2009, post-authorization observational studies that require the subject to be interviewed or those without a secure dissociation procedure that guarantees that the information used does not contain personal data, the subject informed consent will be required. Studies that do not need the patient to be interviewed but have access to their health and personal data (for example, medical history) generally require the patient's informed consent, despite the fact that collected information is dissociated. However, the ethics committee evaluating the study will assess the need and effort to obtain the informed consent in certain cases (studies with relevant scientific interest in which obtaining informed consent makes them unfeasible or with legal authorization for the management/transfer of personal data).

### 4. ETL Process: Standardizing Data to OMOP CDM

Once data has been successfully extracted, the next critical step involves structuring it into a standardized format compatible with OMOP CDM. The Extract, Transform, and Load (ETL) process is a widely used methodology in data management that ensures disparate datasets are refined, harmonized, and systematically mapped to OMOP concepts. ETL consists of three distinct steps: extraction, which involves retrieving raw data from multiple hospital systems; transformation, which involves cleaning, standardizing, and formatting the data to ensure consistency and interoperability; and loading, which integrates the transformed data into a structured database for efficient analysis. This process is crucial for facilitating large-scale, reproducible observational research, as it enables the seamless integration of real-world clinical data from different Data Holders.

The extraction phase involves retrieving structured data (e.g., vital signs, diagnostic tests, and procedural codes) and unstructured data (e.g., textual physician notes and imaging reports). Data transformation encompasses a series of cleaning procedures, including handling missing values, normalizing terminologies, and resolving inconsistencies. Terminology alignment is crucial at this stage, as different Data Holders may use institution-specific coding systems that require translation into OMOP-recognized vocabularies. The final loading phase involves securely storing the transformed data into an OMOP-compliant database, ensuring structured access to high-quality clinical information.

![](/assets/images/image15.png)

The automation of the ETL pipeline enhances efficiency, enabling real-time updates as new patient data becomes available. This ensures that research findings remain reflective of current clinical trends while reducing manual intervention, thereby minimizing errors and inconsistencies in the dataset.

### 5. AI-Driven Terminology Mapping for Data Harmonization

A major impediment to interoperability in clinical research is the inconsistency across different Data Holders of medical terminologies, unique identifiers for diseases, procedures or treatments among others. Automated Terminology Mapping (ATM), is an AI-driven process that standardizes disparate medical terminologies by aligning local hospital codes with globally recognized vocabularies, addressing this challenge by aligning local hospital coding systems with standardized OMOP concept_ids. This process facilitates seamless data integration across multiple sites, ensuring consistency in research outcomes.

![](/assets/images/image1.png)

Machine learning algorithms leverage probabilistic models and deep-learning techniques to establish correspondences between disparate terminologies. The iterative learning framework embedded in ATM ensures progressive refinement, allowing for real-time adjustments based on new mappings. Despite AI-driven automation, expert clinician validation remains indispensable, serving as a safeguard to verify mappings and address discrepancies. A hybrid model integrating AI automation with rule-based heuristics guarantees a high level of precision.

A comprehensive audit trail of mapping decisions is maintained to enhance transparency and facilitate retrospective evaluations. These audit trails are securely logged and accessible to authorized personnel for regulatory compliance reviews and quality assurance assessments. They enable investigators to trace data transformations, verify mappings, and resolve discrepancies efficiently. Additionally, audit trails play a critical role in external regulatory audits and retrospective data evaluations, ensuring that study methodologies remain reproducible and verifiable. This is particularly valuable when refining terminology mappings based on evolving medical standards or novel research findings.

### 6. NLP-Enabled Extraction of Clinical Narratives

A significant portion of valuable clinical data is embedded within unstructured text, such as physician notes, radiology reports, discharge summaries, and pathology narratives. Unlike structured electronic health records (EHRs) that capture predefined clinical variables, unstructured narratives often contain nuanced insights about a patient's condition, treatment progress, and physician assessments. Extracting and structuring this data is critical for comprehensive clinical research and real-world evidence generation.

To achieve this, IOMED employs advanced Natural Language Processing (NLP) techniques designed to interpret and extract clinically relevant information from textual data sources. The NLP pipeline incorporates Named Entity Recognition (NER), which identifies key medical terms, including diagnoses, medications, procedures, and symptoms. Additionally, contextual embeddings and deep learning models enhance the recognition of complex relationships within the text, allowing for the differentiation of disease mentions, temporal associations, and treatment outcomes.

![](/assets/images/image7.png)

Once extracted, these clinical entities are mapped to OMOP concept_ids, ensuring compatibility with standardized medical terminologies and facilitating seamless integration into structured databases. The accuracy and reliability of NLP-extracted data are continuously assessed through rigorous validation processes. Physician oversight plays a crucial role in reviewing the extracted information, helping refine model accuracy and reducing false positives or misinterpretations. Moreover, precision-recall metrics are systematically evaluated to improve performance over time.

Beyond entity recognition, NLP models also facilitate further  analysis such as negation detection, identifying whether a specific condition or symptom was affirmed, referred to the patient (family history), or discussed as a possibility or conditionally. This capability enhances the specificity of the extracted insights, ensuring that clinical data is accurately categorized.

### 7. Quality Assurance

Ensuring the integrity and reliability of extracted data is paramount. A comprehensive Quality Assurance (QA) framework is implemented to validate compliance with OMOP CDM standards. Remote Source Data Verification (rSDV) is performed by medical experts, who cross-check AI-generated data with original medical records. Statistical assessments evaluate dataset completeness, logical consistency, and clinical plausibility. Any discrepancies identified during validation are fed into an iterative optimization loop, enhancing AI model performance over time.

![](/assets/images/image2.png)

A critical component of the QA framework is false negative detection, which focuses on identifying instances where clinically relevant entities were not captured by the system. False negatives pose a significant challenge in Named Entity Recognition (NER) and Named Entity Linking (NEL) systems, as they represent missed medical terms that are essential for research accuracy.

To address this, IOMED employs an advanced framework that utilizes text similarity search techniques to rank clinical documents based on their probability of containing false negatives. The system starts by identifying medical records where the NER/NEL model has successfully recognized a target medical entity. These identified records serve as a reference to locate similar documents that lack the detected entity, despite containing semantically comparable information. By leveraging shared medical concepts and contextual embeddings, the model efficiently surfaces documents that are likely to contain undetected entities.

![](/assets/images/image5.png)

Human annotators then review the high-probability false negative cases, verifying whether the target concept is indeed present but was not initially extracted. This process allows for continuous refinement of the AI model, systematically reducing the rate of false negatives over successive iterations. Furthermore, performance evaluation metrics, including recall, precision, and F1-score, are continuously monitored to quantify improvements and adjust detection thresholds accordingly.

By incorporating automated false negative detection into the QA pipeline, IOMED enhances the completeness and accuracy of its datasets, ensuring that research findings are robust and reflective of real-world clinical data.

In addition to the rSDV process focused on the AI-generated data, the QA framework is complemented by a general Validation procedure designed to assess  the quality of a Data Order by measuring the accuracy of each of its datapoints. Validation is achieved through the definition, implementation, execution and evaluation of a set of quality checks.

These checks are collaboratively defined by the Quality and Clinical teams to assess the data's conformance, completeness, and plausibility. The implementation and execution of the defined checks is done using the Quality Check System (QCS), which enables the parameterization and automated execution of all assigned checks to a Data Order for each iteration. The QCS records the outcome of each check (e.g., pass or fail), providing a means to monitor and evaluate data quality over time.

Following execution, a Quality Assurance specialist reviews the results to determine whether a quality incident should be raised. A quality incident refers to an unexpected or undesired event occurring within the system or related to the product. When identified, incidents are logged in the Incident Management Platform (IMP), which also tracks their diagnosis and any corrective or preventive actions taken.

This iterative validation process not only improves the reliability of extracted medical concepts but also strengthens the overall credibility of clinical studies conducted using IOMED's platform.
