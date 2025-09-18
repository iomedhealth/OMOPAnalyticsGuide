---
layout: default
title: Data Analysis
nav_order: 2
has_children: true
---
# Data Analysis

## Phase 02: Data Mediation Execution

Executing a Data Mediation using IOMED's infrastructure is a meticulous and multi-faceted process that transforms raw clinical data into scientifically rigorous findings. This phase encompasses protocol development, data selection, cohort identification, and rigorous validation mechanisms to ensure the reliability of results. AI-powered methodologies, including Natural Language Processing (NLP) and Automated Terminology Mapping (ATM), enhance the precision and completeness of extracted information. Each step is carefully designed to align with international research standards and regulatory requirements, ensuring that results are reproducible and clinically meaningful.

![](/assets/images/image8.png)

### 1. Development of Data Mediation Protocols

A rigorously structured Data Mediation protocol is the cornerstone of a scientifically valid research project. The protocol serves as a blueprint, outlining the objectives, methodology, analytical approach, and ethical considerations. The first step in protocol development involves defining the research question and establishing the hypothesis that the study seeks to address.

The protocol details inclusion and exclusion criteria for patient selection, ensuring a clearly defined cohort. Additionally, it specifies the data sources to be used, including structured electronic health records (EHRs) and unstructured clinical narratives. A key component of the protocol is the statistical analysis plan, which defines the methodologies for hypothesis testing, confounder adjustments, and risk stratification. This helps to delineate the dataset necessary for the Data Mediation.

Before data extraction can proceed, the protocol undergoes multiple levels of review, including Institutional Review Boards (IRBs) by the Data Holders and Ethics Committees (EC). These reviews play a critical role in ensuring that research methodologies align with ethical and regulatory standards while safeguarding patient privacy. However, they can significantly impact Data Mediation timelines, as approval processes often involve multiple iterations of document revisions, responses to ethical concerns, and additional data privacy assessments. Common challenges in obtaining approvals include varying regional regulatory requirements, institutional hesitancy regarding data sharing, and the necessity of providing extensive documentation on AI-driven data processing methodologies. Addressing these challenges proactively through clear communication with review boards, specific training in each Data Holder and robust compliance frameworks can help mitigate delays and streamline the approval process. These reviews ensure compliance with legal, ethical, and scientific standards while safeguarding patient privacy. Finally, the Data Mediation protocol is registered with appropriate regulatory bodies where applicable.

### 2. Defining of the data of interest for the Cohorts

A pivotal step in Data Mediation execution is defining the specific clinical variables and concepts that will be used to construct research cohorts and the delivery format. Concept sets are collections of standardized terms that correspond to medical conditions, procedures, laboratory results, and medications, all mapped to the OMOP Common Data Model (CDM).

To ensure robustness, concept sets undergo an extensive curation process, involving domain experts and clinical researchers who review and refine selections. The goal is to capture relevant patient attributes with high specificity and sensitivity while ensuring cross-Data Holder applicability. Advanced AI-assisted tools support this process by identifying synonyms, hierarchical relationships, and alternative coding systems used in various hospital environments.

![](/assets/images/image4.png)

Once finalized, the concept sets serve as the basis for extracting patient cohorts, ensuring uniform data representation across multiple participating Data Holders. This standardization facilitates comparative analyses, meta-analyses, and large-scale observational studies. Depending on the Data Mediation, validation by Key Opinion Leaders (KOLs) can ensure scientific rigor and clinical relevance.

![](/assets/images/image16.png)

**Table:** A description of the deliverable types available in the platform.

### 3. Patient Cohort Identification and Validation

Identifying patient cohorts is a critical phase, requiring precise query execution within the OMOP CDM framework. Predefined inclusion and exclusion criteria are translated into queries that extract relevant patient data from harmonized hospital databases.

After cohort extraction, a comprehensive validation process begins. Algorithms perform initial checks, detecting inconsistencies or anomalies in selected patients. Subsequently, clinician-led adjudication is conducted to verify that the retrieved patients meet the intended Data Mediation criteria. This validation phase is crucial for eliminating false positives and ensuring the fidelity of the cohort.

Beyond individual patient validation, statistical techniques are employed to assess overall cohort representativeness. Comparative analyses are conducted against known epidemiological benchmarks to verify that the Data Mediation population reflects the real-world clinical landscape. If discrepancies arise, iterative refinements are made to the cohort selection algorithm to optimize sensitivity and specificity.

### 4. Iterative AI Model Refinement and Performance Optimization

Given the dynamic nature of clinical data and evolving medical terminologies, AI models require continuous optimization to maintain high levels of accuracy. During Data Mediation execution, iterative AI model retraining is conducted using newly validated datasets, ensuring that algorithms remain robust and reflective of contemporary clinical practices.

AI model retraining follows a structured pipeline: first, misclassified or uncertain data points are flagged for manual review by domain experts. These retraining cycles occur at regular intervals, typically aligned with major dataset updates or periodic performance evaluations. The benchmarks for determining model improvement include precision, recall, and F1-score metrics, which are continuously assessed against manually verified gold-standard datasets. Additionally, bias detection and mitigation assessments ensure that retraining enhances model fairness across different demographic and clinical subgroups. Once corrections are made, these verified datasets are fed back into the AI models to refine their classification accuracy. Additionally, bias assessments are conducted to ensure fairness across diverse patient populations, preventing systematic discrepancies based on demographic or socioeconomic factors.

![](/assets/images/image9.png)

Regular performance monitoring is implemented, with precision-recall metrics used to evaluate AI model reliability. The goal of continuous retraining is to iteratively improve the accuracy and generalizability of automated data extraction processes, enhancing the quality of downstream research outcomes. This retraining and validation process is independently performed at every site within the IOMED federated network, ensuring that any AI-driven data extraction is accurate and reliable across all participating Data Holders. By conducting site-specific evaluations, discrepancies due to Data Holders differences in documentation and coding practices can be identified and corrected, strengthening the overall robustness of extracted datasets.

### 5. Delivery of the Data Mediation and External Quality Assurance

Once validated, anonymized datasets are prepared for sharing with research collaborators, regulatory agencies, and scientific communities. Data sharing adheres to FAIR (Findable, Accessible, Interoperable, Reusable) principles, facilitating broader scientific engagement and secondary analyses by independent research groups.

In parallel, structured quality assurance reports are generated, detailing the Data Mediation's methodology, cohort selection criteria, data transformation processes, and AI validation techniques. These reports serve as comprehensive documentation of the research workflow, enhancing credibility and enabling future methodological refinements.

The final phase involves the data delivery and external peer review by the partner performing the analysis on the data. External peers, often Contract Research Organizations (CROs), play a crucial role in maintaining data quality by independently reviewing and validating extracted datasets. Within the IOMED Data Space Platform, these external partners can formally report data quality incidents if discrepancies, inconsistencies, or anomalies are detected during their analyses.

Each reported incident is logged into the Data Space Platform, where it undergoes structured investigation and resolution workflows. These processes adhere strictly to the ISO 9001-certified Quality Management System (QMS) established by IOMED, ensuring that all corrective actions follow standardized procedures, are traceable, and contribute to continuous quality improvement. Internal data validation teams systematically assess and prioritize reported issues, addressing them through iterative AI model refinements, clinician-led adjudications, or enhancements in terminology mapping.

Beyond external reviews, internal audits are also conducted to preemptively identify potential quality issues before data reaches external stakeholders. This dual-layered approach, combining internal validation with external quality assurance mechanisms, reinforces  the reliability and reproducibility of studies executed within IOMED's federated research network. By integrating ISO 9001-aligned quality management protocols, IOMED ensures that every dataset delivered meets the highest standards of accuracy and scientific rigor.

# Conclusion

The execution of a Data Mediation using IOMED's infrastructure represents a highly structured and rigorous process, combining advanced AI-driven methodologies with robust data governance and quality assurance frameworks. By establishing strong institutional partnerships, ensuring compliance with regulatory standards, and employing sophisticated data integration techniques, IOMED enhances the accessibility and interoperability of real-world healthcare data.

The Data Mediation execution phase further refines this process by leveraging Natural Language Processing (NLP) and Automated Terminology Mapping (ATM) to extract and standardize clinical concepts, ensuring that patient cohorts are precisely identified and validated. Continuous AI model retraining, coupled with independent site-specific evaluations, ensures that extracted data maintains the highest levels of accuracy and reliability across diverse healthcare settings.

Furthermore, IOMED's ISO 9001-certified Quality Management System (QMS) provides a structured framework for both internal and external data quality validation. The ability for external peers, such as Contract Research Organizations (CROs), to report and resolve data quality incidents within the Data Space Platform ensures that studies maintain scientific rigor and reproducibility. This dual-layered validation approach strengthens the integrity of research findings and contributes to the broader adoption of real-world data in clinical decision-making and policy development.

Through this comprehensive, multi-phase approach, IOMED facilitates high-quality, large-scale clinical research while continuously improving data accuracy and standardization. The integration of cutting-edge AI tools with stringent quality control measures underscores IOMED's commitment to advancing evidence-based medicine, fostering innovation in healthcare research, and ultimately improving patient outcomes.

![](/assets/images/image6.png)

![](/assets/images/image12.jpg)
![](/assets/images/image11.png)
