#' Grid view for content
#'
#' Renders a grid view of the provided content items
#'
#' @param content A shared object from Connect's content
#' @param width,height Optionally specified width and height of the widget
#'
#' @export
rscgrid <- function(client, content, width = NULL, height = NULL) {
  if (!crosstalk::is.SharedData(content)) {
    ctalk_group <- digest::digest(toString(content), "md5")
    content <- crosstalk::SharedData$new(content, group = ctalk_group)
  }

  key <- content$key()
  group <- content$groupName()
  content <- content$origData()

  get_images <- function(row) {
    content_image_uri(client, row["guid"])
  }
  images <- apply(content, 1, get_images)

  component <- reactR::component(
    "GridView",
    list(
      data = content,
      images = images,
      crosstalkKey = key,
      crosstalkGroup = group
    )
  )

  # create widget
  htmlwidgets::createWidget(
    name = "rscgrid",
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
  htmlwidgets::shinyWidgetOutput(outputId, 'rscgrid', width, height, package = 'rscpages')
}

#' @rdname rscgrid-shiny
#' @export
renderRscgrid <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, rscgridOutput, env, quoted = TRUE)
}
# nolint end
