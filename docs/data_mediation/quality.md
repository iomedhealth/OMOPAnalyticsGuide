---
layout: default
title: Quality Assurance
nav_order: 3
parent: Data Mediation
---

# Quality Assurance Framework

Our Quality Assurance (QA) framework is a comprehensive system designed to ensure the accuracy, reliability, and consistency of the clinical data we provide. It combines physician-led review, statistical validation, and continuous monitoring of our AI models and the experts who train them.

The framework is built on three core pillars:

1.  **Verification:** Confirming the accuracy of AI-generated data against the original source.
2.  **Validation:** Assessing the overall quality and plausibility of the final dataset.

## 1. Verification

Verification is a physician-led process to ensure that the data extracted and normalized by our AI is correct before it is integrated into the OMOP CDM. This process is performed at different levels of granularity to ensure comprehensive accuracy:

*   **Instance-level Verification:** At the most detailed level, physicians verify individual data points as they appear in the clinical notes. For a specific concept, they confirm that the extraction is accurate and the context is correct.
*   **Patient-level Verification:** This is a broader check to confirm that a patient's overall profile, based on all the extracted data, is clinically coherent. This is particularly important for cohort-based studies, where physicians verify that a patient correctly belongs to a specific subcohort.

This multi-faceted approach ensures that our verification is robust, from the smallest data point to the overall patient profile. The core of this process involves several key steps:

### Remote Source Data Verification (rSDV)

Physicians perform rSDV on a significant sample of the data. They are presented with the original clinical text alongside the AI's output and must assess whether the AI's inference is accurate. This process evaluates:

*   **True Positives (TP):** Instances where the AI correctly identified and coded a piece of clinical information.
*   **False Positives (FP):** Instances where the AI incorrectly identified or coded information.

Each annotation is cross-verified by at least two physicians to ensure consistency.

![Remote Source Data Verification (rSDV)](/assets/images/rsdv.png)

### False Negative (FN) Detection

False negatives—relevant clinical information that the AI missed—are difficult to find by random sampling. To address this, we use a semantic similarity search internally develelped by us[^1]. The system identifies data points that have been correctly identified and then searches the entire dataset for similar, but previously unrecognized, instances. These potential false negatives are then sent for rSDV to confirm if they are true missed cases.

![Remote Source Data Verification (rSDV)](/assets/images/fn.png)

### Performance Metrics

We measure the effectiveness of our AI models using standard performance metrics derived from the verification process:

*   **Precision:** The proportion of AI-generated data that is correct.
*   **Recall:** The proportion of all relevant data that the AI successfully extracted.
*   **F1-Score:** The harmonic mean of Precision and Recall, providing a single measure of a model's accuracy.

![Verification metrics](/assets/images/verification.png)

### Annotator Evaluation: Monitoring Our Experts

The quality of our AI is directly related to the quality of the expert annotations used to train and verify it. We use a real-time algorithm to monitor the performance of our physician annotators.

*   **Inter-Annotator Agreement:** We use Fleiss' Kappa to measure the consistency of annotations among different physicians. Our annotators consistently achieve a Fleiss' Kappa of 0.81, indicating substantial agreement.
*   **Golden Annotators:** A group of our most experienced physicians, or "golden annotators," continuously annotate data samples. The performance of all other annotators is regularly compared against this benchmark to ensure they meet the required standards. Our annotators average a 91% agreement score with the golden annotators.
*   **Time per Task (TPT):** We monitor the time it takes for annotators to complete tasks to ensure efficiency and engagement. The average TPT is 48 seconds, which has remained stable over time.

## 2. Validation

Validation goes beyond individual data points to assess the quality of the entire dataset. We use a series of predefined checks based on the Kahn Framework for data quality assessment.

The key dimensions we assess are:

*   **Completeness:** We measure whether all necessary data elements are present. Our AI-driven process has been shown to increase the volume of unique data points by 40% and the diversity of clinical concepts by over 65%.
*   **Conformance:** We verify that data adheres to the expected format and structure of the OMOP CDM.
*   **Plausibility:** We check that the data is believable and logically consistent (e.g., no negative ages, logical event timelines).

In addition to these systematic checks, our clinical team performs a qualitative evaluation to ensure the final dataset is coherent and valid from a medical perspective.

![Validation](/assets/images/validation.png)

---

[^1]: Maria Quijada, Maria Vivó, Álvaro Abella-Bascarán, Paula Chocrón, and Gabriel de Maeztu. 2022. A Framework for False Negative Detection in NER/NEL. In Natural Language Processing and Information Systems: 27th International Conference on Applications of Natural Language to Information Systems, NLDB 2022, Valencia, Spain, June 15–17, 2022, Proceedings. Springer-Verlag, Berlin, Heidelberg, 323–330. [https://doi.org/10.1007/978-3-031-08473-7_30](https://doi.org/10.1007/978-3-031-08473-7_30)
