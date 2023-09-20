## Test environments

* local: Ubuntu 23.04; R 4.2.2
* GH Actions:
  - windows-latest; release
  - macOS-latest; release
  - ubuntu-latest; release, devel
* devtools::check_win_devel()

## R CMD check results

There were no ERRORs or WARNINGs.

1 NOTE

* ❯ checking installed package size ... NOTE
     installed size is  5.0Mb
     sub-directories of 1Mb or more:
       htmlwidgets   3.9Mb

This is expected since we ship a number of browser assets (including .js.map files)

## revdevcheck

No reverse dependencies on CRAN
