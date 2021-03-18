#' Placeholder for the custom filtering htmlwidget
#'
#' <Add Description>
#'
#' @param content The tibble of content provided by rscpages::content()
#' @param width,height Optionally specified width and height of the widget
#' @param elementId Optional HTML id of the element
#'
#' @export
rscfilter <- function(content, width = NULL, height = NULL, elementId = NULL) {
  # forward options using x
  x = list(
    content = content
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'rscfilter',
    x,
    width = width,
    height = height,
    sizingPolicy = htmlwidgets::sizingPolicy(
      padding = 0,
      browser.fill = TRUE,
      knitr.figure = FALSE
    ),
    package = 'rscpages',
    elementId = elementId
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
  htmlwidgets::shinyWidgetOutput(outputId, 'rscfilter', width, height, package = 'rscpages')
}

#' @rdname rscfilter-shiny
#' @export
renderRscfilter <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, rscfilterOutput, env, quoted = TRUE)
}
