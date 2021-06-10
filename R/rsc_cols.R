rsc_cols_dependency <- function() {
  htmltools::htmlDependency(
    name = "rsc_cols",
    version = "0.1.0",
    src = system.file(package = "connectwidgets", "base"),
    stylesheet = "rsc_cols.css",
  )
}

#' Arrange HTML elements or widgets in Bootstrap columns
#'
#' This helper function makes it easy to put HTML elements side by side. It can
#' be called directly from the console but is especially designed to work in an
#' R Markdown document. Note that this is ripped directly from
#' https://github.com/rstudio/crosstalk without the additional bootstrap
#' dependency (since it is already expected in connectwidgets)
#'
#' @param ... \code{htmltools} tag objects, lists, text, HTML widgets, or
#'   NULL. These arguments should be unnamed.
#' @param widths The number of columns that should be assigned to each of the
#'   \code{...} elements (the total number of columns available is always 12).
#'   The width vector will be recycled if there are more \code{...} arguments.
#'   \code{NA} columns will evenly split the remaining columns that are left
#'   after the widths are recycled and non-\code{NA} values are subtracted.
#' @param device The class of device which is targeted by these widths; with
#'   smaller screen sizes the layout will collapse to a one-column,
#'   top-to-bottom display instead. xs: never collapse, sm: collapse below
#'   768px, md: 992px, lg: 1200px.
#'
#' @return A \code{\link[htmltools]{browsable}} HTML element.
#'
#' @examples
#' \donttest{
#' library(htmltools)
#'
#' # If width is unspecified, equal widths will be used
#' rsc_cols(
#'   div(style = css(width="100%", height="400px", background_color="red")),
#'   div(style = css(width="100%", height="400px", background_color="blue"))
#' )
#'
#' # Use NA to absorb remaining width
#' rsc_cols(widths = c(2, NA, NA),
#'   div(style = css(width="100%", height="400px", background_color="red")),
#'   div(style = css(width="100%", height="400px", background_color="blue")),
#'   div(style = css(width="100%", height="400px", background_color="green"))
#' )
#'
#' # Recycling widths
#' rsc_cols(widths = c(2, 4),
#'   div(style = css(width="100%", height="400px", background_color="red")),
#'   div(style = css(width="100%", height="400px", background_color="blue")),
#'   div(style = css(width="100%", height="400px", background_color="red")),
#'   div(style = css(width="100%", height="400px", background_color="blue"))
#' )
#' }
#' @export
rsc_cols <- function(..., widths = NA, device = c("xs", "sm", "md", "lg")) {
  device <- match.arg(device)

  if (length(list(...)) == 0) {
    widths <- c()
  } else {
    if (length(widths) > length(list(...))) {
      warning("Too many widths provided to rsc_cols; truncating")
    }
    widths <- rep_len(widths, length(list(...)))

    if (any(is.na(widths))) {
      remaining <- 12 - sum(widths, na.rm = TRUE)
      stretch_cols <- length(which(is.na(widths)))
      stretch_width <- max(1, floor(remaining / stretch_cols))
      widths[is.na(widths)] <- stretch_width
    }

    if (sum(widths) > 12) {
      warning("Sum of bscol width units is greater than 12")
    }
  }

  ui <- htmltools::div(class = "container-fluid rsc-cols",
    htmltools::div(class = "row",
      unname(mapply(list(...), widths, FUN = function(el, width) {
        if (device == "xs") {
          htmltools::div(class = sprintf("col-%s", width), el)
        } else {
          htmltools::div(class = sprintf("col-%s-%s", device, width), el)
        }
      }, SIMPLIFY = FALSE))
    )
  )

  htmltools::browsable(
    htmltools::attachDependencies(ui, rsc_cols_dependency())
  )
}
