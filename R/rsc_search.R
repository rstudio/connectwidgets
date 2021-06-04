#' Search widget
#'
#' Search for matching content name/title within the shared data object passed.
#' Expects the exact same frame passed to the view widget being filtered.
#'
#' @param content A shared object from Connect's content
#'
#' @export
rsc_search <- function(content) {
  if (missing(content) || !is.data.frame(content)) {
    stop("rsc_search() expects a data frame.")
  }

  if (nrow(content) == 0) {
    warning(
      "rsc_search() called with an empty data.frame. Nothing to search on."
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

  dependencies <- crosstalk::crosstalkLibs()
  dependencies[["rsc_search-theme"]] <- resolve_theme_dependency("rsc_search")

  # create widget
  htmlwidgets::createWidget(
    name = "rsc_search",
    reactR::reactMarkup(component),
    width = "auto",
    height = "auto",
    package = "connectwidgets",
    dependencies = dependencies
  )
}

# nolint start
#' Called by HTMLWidgets to produce the widget's root element.
#' @noRd
widget_html.rsc_search <- function(id, style, class, ...) {
  htmltools::tagList(
    # Necessary for RStudio viewer version < 1.2
    reactR::html_dependency_corejs(),
    reactR::html_dependency_react(),
    reactR::html_dependency_reacttools(),
    htmltools::tags$div(id = id, class = class, style = style)
  )
}

#' Shiny bindings for rsc_search
#'
#' Output and render functions for using rsc_search within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a rsc_search
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name rsc_search-shiny
#'
#' @export
rsc_searchOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'rsc_search', width, height, package = 'connectwidgets')
}

#' @rdname rsc_search-shiny
#' @export
renderRsc_search <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, rsc_searchOutput, env, quoted = TRUE)
}
# nolint end
