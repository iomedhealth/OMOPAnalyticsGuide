# Contributing to CodelistGenerator • CodelistGenerator

Skip to contents

[CodelistGenerator](index.html) 3.5.0

  * [Reference](reference/index.html)
  * Articles
    * [Getting the OMOP CDM vocabularies](articles/a01_GettingOmopCdmVocabularies.html)
    * [Exploring the OMOP CDM vocabulary tables](articles/a02_ExploreCDMvocabulary.html)
    * [Generate a candidate codelist](articles/a03_GenerateCandidateCodelist.html)
    * [Generating vocabulary based codelists for medications](articles/a04_GenerateVocabularyBasedCodelist.html)
    * [Generating vocabulary based codelists for conditions](articles/a04b_icd_codes.html)
    * [Extract codelists from JSON files](articles/a05_ExtractCodelistFromJSONfile.html)
    * [Compare, subset or stratify codelists](articles/a06_CreateSubsetsFromCodelist.html)
    * [Codelist diagnostics](articles/a07_RunCodelistDiagnostics.html)
  * [Changelog](news/index.html)




![](logo.png)

# Contributing to CodelistGenerator

## Filing issues

If you have found a bug, have a question, or want to suggest a new feature please open an issue. If reporting a bug, then a [reprex](https://reprex.tidyverse.org/) would be much appreciated.

## Contributing code or documentation

> This package has been developed as part of the DARWIN EU(R) project and is closed to external contributions.

Before contributing either documentation or code, please make sure to open an issue beforehand to identify what needs to be done and who will do it.

#### Documenting the package

Run the below to update and check package documentation:
    
    
    devtools::document() 
    devtools::run_examples()
    devtools::build_readme()
    devtools::build_vignettes()
    devtools::check_man()

Note that `devtools::check_man()` should not return any warnings. If your commit is limited to only package documentation, running the above should be sufficient (although running `devtools::check()` will always generally be a good idea before submitting a pull request.

#### Run tests

Before starting to contribute any code, first make sure the package tests are all passing. If not raise an issue before going any further (although please first make sure you have all the packages from imports and suggests installed). As you then contribute code, make sure that all the current tests and any you add continue to pass. All package tests can be run together with:
    
    
    devtools::test()

Code to add new functionality should be accompanied by tests. Code coverage can be checked using:
    
    
    # note, you may first have to detach the package
    # detach("package:CodelistGenerator", unload=TRUE)
    devtools::test_coverage()

#### Adhere to code style

Please adhere to the code style when adding any new code. Do not though restyle any code unrelated to your pull request as this will make code review more difficult.
    
    
    lintr::lint_package(".",
                        linters = lintr::linters_with_defaults(
                          lintr::object_name_linter(styles = "camelCase")
                        )
    )

#### Run check() before opening a pull request

Before opening any pull request please make sure to run:
    
    
    devtools::check() 

No warnings should be seen.

If the package is on CRAN or is close to being submitted to CRAN then please also run:
    
    
    rcmdcheck::rcmdcheck(args = [c](https://rdrr.io/r/base/c.html)("--no-manual", "--as-cran"))
    devtools::check_win_devel()

Also it can be worth checking spelling and any urls
    
    
    spelling::[spell_check_package](https://docs.ropensci.org/spelling//reference/spell_check_package.html)()
    urlchecker::url_check()

#### Precompute vignette data

The search results presented in the vignettes are precomputed against a database with a full vocabulary. If making changes that will affect these results, they should be recomputed. Note you may need to change the database connection details in this script.
    
    
    [source](https://rdrr.io/r/base/source.html)(here::here("extras", "precomputeVignetteData.R"))

## On this page

Developed by Edward Burn, Xihang Chen, Nuria Mercade-Besora.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
