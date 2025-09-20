# Contributing to CDMConnector • CDMConnector

Skip to contents

[CDMConnector](index.html) 2.2.0

  * [Reference](reference/index.html)
  * Articles
    * [Getting Started](articles/a01_getting-started.html)
    * [Working with cohorts](articles/a02_cohorts.html)
    * [CDMConnector and dbplyr](articles/a03_dbplyr.html)
    * [DBI connection examples](articles/a04_DBI_connection_examples.html)
    * [Using CDM attributes](articles/a06_using_cdm_attributes.html)
  * [Changelog](news/index.html)


  *   * [](https://github.com/darwin-eu/CDMConnector/)



![](logo.png)

# Contributing to CDMConnector

Source: [`.github/CONTRIBUTING.md`](https://github.com/darwin-eu/CDMConnector/blob/HEAD/.github/CONTRIBUTING.md)

## Filing issues

If you have found a bug, have a question, or want to suggest a new feature please open an issue. If reporting a bug, then a [reprex](https://reprex.tidyverse.org/) would be much appreciated.

## Contributing code or documentation

> This package has been developed as part of the DARWIN EU(R) project and is closed to external contributions.

Before contributing either documentation or code, please make sure to open an issue beforehand to identify what needs to be done and who will do it.

#### Documenting the package

Run the below to update and check package documentation:
    
    
    devtools::[document](https://devtools.r-lib.org/reference/document.html)() 
    devtools::[run_examples](https://devtools.r-lib.org/reference/run_examples.html)()
    devtools::[build_readme](https://devtools.r-lib.org/reference/build_rmd.html)()
    devtools::[build_vignettes](https://devtools.r-lib.org/reference/build_vignettes.html)()
    devtools::[check_man](https://devtools.r-lib.org/reference/check_man.html)()

Note that `[devtools::check_man()](https://devtools.r-lib.org/reference/check_man.html)` should not return any warnings. If your commit is limited to only package documentation, running the above should be sufficient (although running `[devtools::check()](https://devtools.r-lib.org/reference/check.html)` will always generally be a good idea before submitting a pull request.

#### Run tests

Before starting to contribute any code, first make sure the package tests are all passing. If not raise an issue before going any further (although please first make sure you have all the packages from imports and suggests installed). As you then contribute code, make sure that all the current tests and any you add continue to pass. All package tests can be run together with:
    
    
    devtools::[test](https://devtools.r-lib.org/reference/test.html)()

Code to add new functionality should be accompanied by tests. Code coverage can be checked using:
    
    
    # note, you may first have to detach the package
    # detach("package:IncidencePrevalence", unload=TRUE)
    devtools::[test_coverage](https://devtools.r-lib.org/reference/test.html)()

#### Adhere to code style

Please adhere to the code style when adding any new code. Do not though restyle any code unrelated to your pull request as this will make code review more difficult.
    
    
    lintr::[lint_package](https://lintr.r-lib.org/reference/lint.html)(".",
                        linters = lintr::[linters_with_defaults](https://lintr.r-lib.org/reference/linters_with_defaults.html)(
                          lintr::[object_name_linter](https://lintr.r-lib.org/reference/object_name_linter.html)(styles = "camelCase")
                        )
    )

#### Run check() before opening a pull request

Before opening any pull request please make sure to run:
    
    
    devtools::[check](https://devtools.r-lib.org/reference/check.html)() 

No warnings should be seen.

If the package is on CRAN or is close to being submitted to CRAN then please also run:
    
    
    rcmdcheck::[rcmdcheck](http://r-lib.github.io/rcmdcheck/reference/rcmdcheck.html)(args = [c](https://rdrr.io/r/base/c.html)("--no-manual", "--as-cran"))
    devtools::[check_win_devel](https://devtools.r-lib.org/reference/check_win.html)()

Also it can be worth checking spelling and any urls
    
    
    spelling::[spell_check_package](https://docs.ropensci.org/spelling//reference/spell_check_package.html)()
    urlchecker::[url_check](https://rdrr.io/pkg/urlchecker/man/url_check.html)()

## On this page

Developed by Adam Black, Artem Gorbachev, Edward Burn, Marti Catala Sabate, Ioanna Nika.

Site built with [pkgdown](https://pkgdown.r-lib.org/) 2.1.1.
