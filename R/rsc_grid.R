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
rsc_grid <- function(content) {
  if (missing(content)) {
    stop("rsc_grid() expects a data frame or a crosstalk shared data object.")
  }

  if (crosstalk::is.SharedData(content)) {
    key <- content$key()
    group <- content$groupName()
    content <- content$origData()
  } else {
    if (!is.data.frame(content)) {
      stop("rsc_grid() expects a data frame or a crosstalk shared data object.")
    }
    ctalk_group <- digest::digest(toString(content), "md5")
    shared <- crosstalk::SharedData$new(content, group = ctalk_group)
    key <- shared$key()
    group <- shared$groupName()
    content <- shared$origData()
  }

  if (nrow(content) == 0) {
    warning("rsc_grid() was called with an empty data frame.")
  } else {
    cols <- colnames(content)
    evaluate_widget_input(
      "rsc_grid()",
      cols,
      c("guid", "url", "title", "app_mode", "owner_username")
    )
    warning_widget_input(
      "rsc_grid()",
      cols,
      c("updated_time")
    )
    warning_large_content(content)
  }

  component <- reactR::component(
    "GridView",
    list(
      data = content,
      crosstalkKey = key,
      crosstalkGroup = group
    )
  )

  dependencies <- crosstalk::crosstalkLibs()
  dependencies[["rsc_grid-theme"]] <- resolve_theme_dependency("rsc_grid")

  # create widget
  htmlwidgets::createWidget(
    name = "rsc_grid",
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
widget_html.rsc_grid <- function(id, style, class, ...) {
  htmltools::tagList(
    # Necessary for RStudio viewer version < 1.2
    reactR::html_dependency_corejs(),
    reactR::html_dependency_react(),
    reactR::html_dependency_reacttools(),
    htmltools::tags$div(id = id, class = class, style = style)
  )
}

#' Shiny bindings for rsc_grid
#'
#' Output and render functions for using rsc_grid within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a rsc_grid
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name rsc_grid-shiny
#'
#' @export
rscgridOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'rsc_grid', width, height, package = 'connectwidgets')
}

#' @rdname rsc_grid-shiny
#' @export
renderRscgrid <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, rscgridOutput, env, quoted = TRUE)
}
# nolint end
