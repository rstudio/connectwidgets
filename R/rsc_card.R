#' Card view for content
#'
#' Renders a card view for the provided content
#'
#' @param content A data frame from Connect's content. Requires the
#' following columns "guid," "url", "title".
#' And, although optional, expects an "owner_username", "description"
#' and "updated_time" columns.
#'
#' @export
rsc_card <- function(content) {
  # content should have at least one row
  if (missing(content) || !is.data.frame(content) || nrow(content) == 0) {
    stop("rsc_card() expects a data frame with at least one record.")
  }

  cols <- colnames(content)
  evaluate_widget_input(
    "rsc_card()",
    cols,
    c("guid", "title", "url")
  )
  warning_widget_input(
    "rsc_card()",
    cols,
    c("owner_username", "description", "updated_time")
  )
  warning_large_content(content)

  component <- reactR::component(
    "CardView",
    list(
      data = content
    )
  )

  dependencies <- crosstalk::crosstalkLibs()
  dependencies[["rsc_card-theme"]] <- resolve_theme_dependency("rsc_card")

  # create widget
  htmlwidgets::createWidget(
    name = "rsc_card",
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
widget_html.rsc_card <- function(id, style, class, ...) {
  htmltools::tagList(
    # Necessary for RStudio viewer version < 1.2
    reactR::html_dependency_corejs(),
    reactR::html_dependency_react(),
    reactR::html_dependency_reacttools(),
    htmltools::tags$div(id = id, class = class, style = style)
  )
}

#' Shiny bindings for rsc_card
#'
#' Output and render functions for using rsc_card within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a rsc_card
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name rsc_card-shiny
#'
#' @export
rsccardOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'rsc_card', width, height, package = 'connectwidgets')
}

#' @rdname rsc_card-shiny
#' @export
renderRsccard <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, rsccardOutput, env, quoted = TRUE)
}
# nolint end
