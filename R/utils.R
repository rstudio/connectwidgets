format_iso8601 <- function(str) {
  strptime(str, "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
}

#' Evaluates required columns for widget's input
#' @param widget Widget's name to identify errors thrown
#' @param colnames Column names provided from the widget content input
#' @param required List of required columns to look for in the widget's input
evaluate_widget_input <- function(widget, colnames, required) {
  for (col in required) {
    if (!any(colnames == col)) {
      msg <- sprintf(
        "%s requires a \"%s\" column but is not present.",
        widget,
        col
      )
      stop(msg)
    }
  }
}

#' Show warnings of expected columns for widget's input
#' @param widget Widget's name to identify warnings thrown
#' @param colnames Column names provided from the widget content input
#' @param expected List of expected columns to look for in the widget's input
warning_widget_input <- function(widget, colnames, expected) {
  for (col in expected) {
    if (!any(colnames == col)) {
      msg <- sprintf(
        "%s expects a \"%s\" column but is not present.",
        widget,
        col
      )
      warning(msg)
    }
  }
}
