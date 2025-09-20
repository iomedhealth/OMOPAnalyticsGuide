# OMOP Analytics Workflow Documentation

A comprehensive documentation site introducing the analytics workflow for the
Observational Medical Outcomes Partnership (OMOP) Common Data Model.

## Overview

This repository contains educational materials and documentation for conducting
real-world evidence studies using the OMOP CDM format. The site introduces a
complete analytics ecosystem of R packages designed for observational health
data analysis.

## Libraries

| Library | URL |
|---------|-----|
| omopgenerics | https://darwin-eu.github.io/omopgenerics/ |
| CDMConnector | https://darwin-eu.github.io/CDMConnector/ |
| omock | [ohdsi.github.io][1] |
| CohortConstructor | [ohdsi.github.io][2] |
| CohortCharacteristics | https://darwin-eu.github.io/CohortCharacteristics/ |
| OmopSketch | [ohdsi.github.io][3] |
| PatientProfiles | https://darwin-eu.github.io/PatientProfiles/ |
| CodelistGenerator | https://darwin-eu.github.io/CodelistGenerator/ |
| DrugUtilisation | https://darwin-eu.github.io/DrugUtilisation/ |
| CohortSurvival | https://darwin-eu-dev.github.io/CohortSurvival/ |
| IncidencePrevalence | https://darwin-eu.github.io/IncidencePrevalence/ |
| PhenotypeR | [ohdsi.github.io][4] |
| visOmopResults | https://darwin-eu.github.io/visOmopResults/ |

[1]: https://ohdsi.github.io/omock/
[2]: https://ohdsi.github.io/CohortConstructor/
[3]: https://ohdsi.github.io/OmopSketch/
[4]: https://ohdsi.github.io/PhenotypeR/

## Publishing the Site

This Jekyll site is automatically built and deployed using GitHub Pages. To run the site locally for development:

1. **Install dependencies**: `bundle install`
2. **Build the site**: `bundle exec jekyll build`
3. **Run locally**: `bundle exec jekyll serve`

Changes pushed to the `main` branch will trigger a GitHub Actions workflow to publish the site.
