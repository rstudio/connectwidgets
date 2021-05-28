#' Principal (most used) theming variables
#'
#' bg
#' fg
#' primary
#' secondary
#' success
#' info
#' warning
#' danger
#' base_font
#' code_font
#' heading_font
#' font_scale
#'
#' Visit https://rstudio.github.io/bslib/articles/bs4-variables.html
#' to see the full list of theming variables available
#'

default_theme <- bslib::bs_theme(
  # principal variables in use by rscpages
  bg = "#FFF",
  fg = "#000",
  primary = "#346899",
  secondary = "#858585",
  dark = "#252525",
  light = "#EDF6FF",
  base_font = "Lato, sans-serif",
  heading_font = "Lato, sans-serif",

  # more complementary variables
  "font-size-base" = "1.44rem",
  "border-color" = "#F2F2F2",
  "gray-100" = "#F8F8F8",
  "gray-200" = "#F2F2F2",
  "gray-300" = "#ECECEC",
  "gray-400" = "#CDCDCD",
  "gray-500" = "#B0B0B0",
  "gray-600" = "#858585",
  "gray-700" = "#303030"
)

#' Get docmeta theme name (output: html_document: theme)
get_bootswatch_theme_name <- function() {
  theme_name <- tryCatch({
    rmarkdown::metadata$output$html_document$theme$bootswatch
  }, error = function(e) e)
  theme_in_meta <- !inherits(theme_name, "error") && !is.null(theme_name)
  if (theme_in_meta) {
    theme_name
  } else {
    NULL
  }
}

#' Get the current bootswatch theme if any
get_current_bootswatch_theme <- function() {
  bootswatch_theme <- get_bootswatch_theme_name()
  if (!is.null(bootswatch_theme)) {
    bslib::bs_theme(bootswatch = bootswatch_theme)
  } else {
    NULL
  }
}

#' Get the current user provided bslib theme if any
get_user_provided_theme <- function() {
  bslib_theme <- bslib::bs_current_theme()
  if (!is.null(bslib_theme)) {
    bslib_theme
  } else {
    NULL
  }
}

#' Generate the theme's bslib::bs_dependency to be used by a widget.
#'
#' @param widget_name The name of the widget (e.g: rscgrid)
#' @param theme The bslib theme to generate the CSS dependency
#' @param default_base Using the default theme or not
gen_theme_dependency <- function(widget_name, theme, default_base = FALSE) {
  version <- "0.1.0"
  widget_theme_file <- sprintf("%s.scss", widget_name)
  if (default_base) {
    dependency_name <- sprintf("%s-default-theme-%s", widget_name, version)
    scss_path <- system.file(
      package = "rscpages",
      "theming",
      "default",
      widget_theme_file
    )
  } else {
    dependency_name <- sprintf("%s-theme-%s", widget_name, version)
    scss_path <- system.file(
      package = "rscpages",
      "theming",
      widget_theme_file
    )
  }
  bslib::bs_dependency(
    input = sass::sass_file(scss_path),
    theme = theme,
    name = dependency_name,
    version = version,
    .sass_args = list(
      cache = FALSE
    )
  )
}

#' Resolve and get theme to be used by a widget. It could be the
#' default rscpages styling theme or one provided by the user.
#'
#' @param widget_name The name of the widget (e.g: rscgrid)
resolve_theme_dependency <- function(widget_name) {
  theme <- get_current_bootswatch_theme()
  if (!is.null(theme)) {
    # Use bootswatch theme
    return(gen_theme_dependency(widget_name, theme))
  }

  theme <- get_user_provided_theme()
  if (!is.null(theme)) {
    # Use user provided theme over the default rules
    return(gen_theme_dependency(widget_name, theme, default_base = TRUE))
  }

  gen_theme_dependency(widget_name, default_theme, default_base = TRUE)
}

#' Resolve reactable theme for rsctable
rsctable_sync_theme <- function() {
  varnames <- c(
    "body-bg",
    "body-color",
    "border-color",
    "border-radius",
    "font-family-base",
    "primary",
    "gray-100",
    "gray-300",
    "gray-500",
    "gray-700",
    "white",
    "light"
  )

  theme <- default_theme
  user_theme <- get_user_provided_theme()
  if (!is.null(user_theme)) {
    theme <- user_theme
  }

  bootswatch_theme <- get_current_bootswatch_theme()
  if (!is.null(bootswatch_theme)) {
    theme <- bootswatch_theme
  }

  theme_vars <- bslib::bs_get_variables(theme, varnames = varnames)

  page_btns_style <- list(
    background = theme_vars[["white"]],
    color = theme_vars[["primary"]],
    border = "1px solid",
    borderColor = theme_vars[["border-color"]],
    borderRadius = "0",
    padding = "0.5rem 0.75rem",
    lineHeight = "1.25em",
    marginLeft = "-1px",
    "&:hover" = list(
      background = theme_vars[["gray-300"]]
    ),
    "&[disabled]" = list(
      color = theme_vars[["gray-700"]],
      pointerEvents = "none"
    )
  )

  page_btns_current_style <- list(
    backgroundColor = theme_vars[["primary"]],
    border = "1px solid",
    borderColor = theme_vars[["primary"]],
    color = theme_vars[["white"]],
    "&:hover" = list(
      pointerEvents = "none"
    )
  )

  if (is.null(bootswatch_theme)) {
    page_btns_style["border"] <- "none"
    page_btns_style["borderRadius"] <- "16px"
    page_btns_style["height"] <- "32px"
    page_btns_style["line-height"] <- "32px"
    page_btns_style["marginLeft"] <- "0"
    page_btns_style["marginRight"] <- "5px"
    page_btns_style["minWidth"] <- "32px"
    page_btns_style["padding"] <- "0 0.8em"

    page_btns_current_style["backgroundColor"] <- theme_vars[["primary"]]
    page_btns_current_style["color"] <- theme_vars[["white"]]
    page_btns_current_style["border"] <- "none"
  }

  reactable::reactableTheme(
    color = theme_vars[["body-color"]],
    backgroundColor = theme_vars[["body-bg"]],
    highlightColor = sprintf("%s09", theme_vars[["primary"]]),
    borderColor = theme_vars[["border-color"]],
    borderWidth = "1px",
    cellPadding = "16px 8px",
    style = list(
      border = sprintf("1px solid %s", theme_vars[["border-color"]]),
      borderRadius = 3
    ),
    headerStyle = list(
      "&:first-child" = list(paddingLeft = 24),
      "&:last-child" = list(paddingRight = 24)
    ),
    cellStyle = list(
      "&:first-child" = list(paddingLeft = 24),
      "&:last-child" = list(paddingRight = 24)
    ),
    paginationStyle = list(
      flexDirection = "row-reverse",
      fontFamily = theme_vars[["font-family-base"]],
      padding = "24px 12px"
    ),
    pageButtonStyle = page_btns_style,
    pageButtonCurrentStyle = page_btns_current_style
  )
}
