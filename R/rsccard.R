#' Card view for content
#'
#' Renders a card view for the provided content
#'
#' @param content Connect's content item
#'
#' @export
rsccard <- function(content) {
  component <- reactR::component(
    "CardView",
    list(
      data = content
    )
  )

  # create widget
  htmlwidgets::createWidget(
    name = "rsccard",
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
widget_html.rsccard <- function(id, style, class, ...) {
  htmltools::tagList(
    # Necessary for RStudio viewer version < 1.2
    reactR::html_dependency_corejs(),
    reactR::html_dependency_react(),
    reactR::html_dependency_reacttools(),
    htmltools::tags$div(id = id, class = class, style = style)
  )
}

#' Shiny bindings for rsccard
#'
#' Output and render functions for using rsccard within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a rsccard
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name rsccard-shiny
#'
#' @export
rsccardOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'rsccard', width, height, package = 'rscpages')
}

#' @rdname rsccard-shiny
#' @export
renderRsccard <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, rsccardOutput, env, quoted = TRUE)
}
# nolint end
