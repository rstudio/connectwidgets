#' Search widget
#'
#' Search for matching content name/title within the shared data object passed.
#' Expects the exact same frame passed to the view widget being filtered.
#'
#' @param content A shared object from Connect's content
#'
#' @export
rscsearch <- function(content) {
  if (missing(content) || !is.data.frame(content)) {
    stop("rscsearch() expects a data frame.")
  }

  if (nrow(content) == 0) {
    warning(
      "rscsearch() called with an empty data.frame. Nothing to search on."
    )
  }

  if (!crosstalk::is.SharedData(content)) {
    ctalk_group <- digest::digest(toString(content), "md5")
    content <- crosstalk::SharedData$new(content, group = ctalk_group)
  }

  key <- content$key()
  group <- content$groupName()
  content <- content$origData()

  component <- reactR::component(
    "Search",
    list(
      data = content,
      crosstalkKey = key,
      crosstalkGroup = group
    )
  )

  # create widget
  htmlwidgets::createWidget(
    name = "rscsearch",
    reactR::reactMarkup(component),
    width = "auto",
    height = "auto",
    package = "rscpages",
    dependencies = crosstalk::crosstalkLibs()
  )
}

# nolint start
#' Called by HTMLWidgets to produce the widget's root element.
#' @noRd
widget_html.rscsearch <- function(id, style, class, ...) {
  htmltools::tagList(
    # Necessary for RStudio viewer version < 1.2
    reactR::html_dependency_corejs(),
    reactR::html_dependency_react(),
    reactR::html_dependency_reacttools(),
    htmltools::tags$div(id = id, class = class, style = style)
  )
}

#' Shiny bindings for rscsearch
#'
#' Output and render functions for using rscsearch within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a rscsearch
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name rscsearch-shiny
#'
#' @export
rscsearchOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'rscsearch', width, height, package = 'rscpages')
}

#' @rdname rscsearch-shiny
#' @export
renderRscsearch <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, rscsearchOutput, env, quoted = TRUE)
}
# nolint end
