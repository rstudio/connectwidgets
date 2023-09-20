# connectwidgets 0.2.1

* Fixed broken grid view with bslib >= 0.4.x (#72)
* Development versions of Connect no longer generate warnings when using
  `connect` (#44)
* Add additional content type icons to rsc_table for Quarto, Voila, FastAPI, and
  Shiny for Python
* Fix content type labels and icons for sites and other (#46)

# connectwidgets 0.2.0

* Add support for htmlwidgets 1.6 (#79)
* Warn rather than err when the server version is not available. (#63)
* Update company and product name for rebranding to Posit (#76)

# connectwidgets 0.1.1

* Initial public release and CRAN submission of the {connectwidgets} R package
* `connect` and `content` functions for enumerating content from RStudio Connect
* `rsc_table`, `rsc_grid`, and `rsc_card` HTML widgets for displaying content
  items in an RMarkdown document
* `rsc_search` and `rsc_filter` HTML widgets for searching and filtering those
  content items
* `rsc_cols` utility function for displaying content in responsive columns
* Support for {bslib} including Bootswatch themes
