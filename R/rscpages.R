#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
rscpages <- function(content, width = NULL, height = NULL, elementId = NULL) {

  # forward options using x
  x = list(
    content = content
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'rscpages',
    x,
    width = width,
    height = height,
    package = 'rscpages',
    elementId = elementId
  )
}

#' Shiny bindings for rscpages
#'
#' Output and render functions for using rscpages within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a rscpages
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name rscpages-shiny
#'
#' @export
rscpagesOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'rscpages', width, height, package = 'rscpages')
}

#' @rdname rscpages-shiny
#' @export
renderRscpages <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, rscpagesOutput, env, quoted = TRUE)
}
