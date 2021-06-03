#' Filter widget
#'
#' Filter content rows with owner, content type and tags,
#' expects the exact same frame passed to the view widget being filtered.
#'
#' @param content A data frame from Connect's content. Although optional,
#' expects an "owner_username", "app_mode" and "tags" columns.
#'
#' @export
rscfilter <- function(content) {
  if (missing(content) || !is.data.frame(content)) {
    stop("rscfilter() expects a data frame.")
  }

  cols <- colnames(content)
  warning_widget_input(
    "rscfilter()",
    cols,
    c("owner_username", "app_mode", "tags")
  )

  if (!crosstalk::is.SharedData(content)) {
    ctalk_group <- digest::digest(toString(content), "md5")
    content <- crosstalk::SharedData$new(content, group = ctalk_group)
  }

  key <- content$key()
  group <- content$groupName()
  content <- content$origData()

  component <- reactR::component(
    "Filter",
    list(
      data = content,
      crosstalkKey = key,
      crosstalkGroup = group
    )
  )

  dependencies <- crosstalk::crosstalkLibs()
  dependencies[["rscfilter-theme"]] <- resolve_theme_dependency("rscfilter")

  # create widget
  htmlwidgets::createWidget(
    name = "rscfilter",
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
widget_html.rscfilter <- function(id, style, class, ...) {
  htmltools::tagList(
    # Necessary for RStudio viewer version < 1.2
    reactR::html_dependency_corejs(),
    reactR::html_dependency_react(),
    reactR::html_dependency_reacttools(),
    htmltools::tags$div(id = id, class = class, style = style)
  )
}

#' Shiny bindings for rscfilter
#'
#' Output and render functions for using rscfilter within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a rscfilter
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name rscfilter-shiny
#'
#' @export
rscfilterOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'rscfilter', width, height, package = 'connectwidgets')
}

#' @rdname rscfilter-shiny
#' @export
renderRscfilter <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, rscfilterOutput, env, quoted = TRUE)
}
# nolint end
