#' Grid view for content
#'
#' Renders a grid view of the provided content items
#'
#' @param content A data frame from Connect's content. Requires the
#' following columns "guid", "url", "title", "app_mode", "owner_username".
#' And, although optional, expects an "updated_time" column.
#'
#'
#' @export
rscgrid <- function(content) {
  if (missing(content) || !is.data.frame(content)) {
    stop("rscgrid() expects a data frame.")
  }

  if (nrow(content) == 0) {
    warning("rscgrid() was called with an empty data frame.")
  } else {
    cols <- colnames(content)
    evaluate_widget_input(
      "rscgrid()",
      cols,
      c("guid", "url", "title", "app_mode", "owner_username")
    )
    warning_widget_input(
      "rscgrid()",
      cols,
      c("updated_time")
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
    "GridView",
    list(
      data = content,
      crosstalkKey = key,
      crosstalkGroup = group
    )
  )

  dependencies <- crosstalk::crosstalkLibs()
  dependencies[["rscgrid-theme"]] <- resolve_theme_dependency("rscgrid")

  # create widget
  htmlwidgets::createWidget(
    name = "rscgrid",
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
widget_html.rscgrid <- function(id, style, class, ...) {
  htmltools::tagList(
    # Necessary for RStudio viewer version < 1.2
    reactR::html_dependency_corejs(),
    reactR::html_dependency_react(),
    reactR::html_dependency_reacttools(),
    htmltools::tags$div(id = id, class = class, style = style)
  )
}

#' Shiny bindings for rscgrid
#'
#' Output and render functions for using rscgrid within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a rscgrid
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name rscgrid-shiny
#'
#' @export
rscgridOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'rscgrid', width, height, package = 'connectwidgets')
}

#' @rdname rscgrid-shiny
#' @export
renderRscgrid <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, rscgridOutput, env, quoted = TRUE)
}
# nolint end
