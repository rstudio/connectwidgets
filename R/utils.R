#' Arrange HTML elements or widgets in Bootstrap columns
#'
#' This helper function makes it easy to put HTML elements side by side. It can
#' be called directly from the console but is especially designed to work in an
#' R Markdown document. Warning: This will bring in all of Bootstrap!
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
#' bscols(
#'   div(style = css(width="100%", height="400px", background_color="red")),
#'   div(style = css(width="100%", height="400px", background_color="blue"))
#' )
#'
#' # Use NA to absorb remaining width
#' bscols(widths = c(2, NA, NA),
#'   div(style = css(width="100%", height="400px", background_color="red")),
#'   div(style = css(width="100%", height="400px", background_color="blue")),
#'   div(style = css(width="100%", height="400px", background_color="green"))
#' )
#'
#' # Recycling widths
#' bscols(widths = c(2, 4),
#'   div(style = css(width="100%", height="400px", background_color="red")),
#'   div(style = css(width="100%", height="400px", background_color="blue")),
#'   div(style = css(width="100%", height="400px", background_color="red")),
#'   div(style = css(width="100%", height="400px", background_color="blue"))
#' )
#' }
#' @export
bscols <- function(..., widths = NA, device = c("xs", "sm", "md", "lg")) {
  crosstalk::bscols(..., widths = widths, device = device)
}

format_iso8601 <- function(str) {
  strptime(str, "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
}
