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
  primary = "#4C83B6",
  secondary = "#858585",
  dark = "#252525",
  light = "#EDF6FF",
  base_font = "Lato, sans-serif",
  heading_font = "Lato, sans-serif",

  # more complementary variables
  "font-size-base" = "1.2rem",
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

#' Verify if a theme is already set within document meta,
#' or within the user's code via bslib
get_current_theme <- function() {
  bslib_theme <- bslib::bs_current_theme()
  bootswatch_theme <- get_bootswatch_theme_name()
  if (!is.null(bslib_theme)) {
    return(bslib_theme)
  }
  if (!is.null(bootswatch_theme)) {
    print(bslib::bs_theme(bootswatch = bootswatch_theme))
    return(bslib::bs_theme(bootswatch = bootswatch_theme))
  }
  NULL
}

#' Generate the theme's bslib::bs_dependency to be used by a widget.
#'
#' @param widget_name The name of the widget (e.g: rscgrid)
#' @param theme The bslib theme to generate the CSS dependency
gen_theme_dependency <- function(widget_name, theme, default = FALSE) {
  version <- "0.1.0"
  widget_theme_file <- sprintf("%s.scss", widget_name)
  if (default) {
    dependency_name <- sprintf("%s-default-theme-%s", widget_name, version)
    scss_path <- system.file(package = "rscpages", "theming", "default", widget_theme_file)
  } else {
    dependency_name <- sprintf("%s-theme-%s", widget_name, version)
    scss_path <- system.file(package = "rscpages", "theming", widget_theme_file)
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
  theme <- get_current_theme()

  if (is.null(theme)) {
    # set default theme
    gen_theme_dependency(widget_name, default_theme, default = TRUE)
  } else {
    # use bootswatch or user provided theme
    # theme <- bslib::bs_theme_update(theme)
    gen_theme_dependency(widget_name, theme)
  }
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
  current_theme <- get_current_theme()
  if (is.null(current_theme)) {
    theme <- default_theme
  } else {
    theme <- current_theme
  }
  theme_vars <- bslib::bs_get_variables(theme, varnames = varnames)

  pageButtonStyle <- list(
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

  pageButtonCurrentStyle <- list(
    backgroundColor = theme_vars[["primary"]],
    border = "1px solid",
    borderColor = theme_vars[["primary"]],
    color = theme_vars[["white"]],
    "&:hover" = list(
      pointerEvents = "none"
    )
  )

  if (is.null(current_theme)) {
    pageButtonStyle["border"] = "none"
    pageButtonStyle["borderRadius"] = "16px"
    pageButtonStyle["height"] = "32px"
    pageButtonStyle["line-height"] = "32px"
    pageButtonStyle["marginLeft"] = "0"
    pageButtonStyle["marginRight"] = "5px"
    pageButtonStyle["minWidth"] = "32px"
    pageButtonStyle["padding"] = "0 0.8em"

    pageButtonCurrentStyle["backgroundColor"] = theme_vars[["primary"]]
    pageButtonCurrentStyle["color"] = theme_vars[["white"]]
    pageButtonCurrentStyle["border"] = "none"
  }

  reactable::reactableTheme(
    color = theme_vars[["body-color"]],
    backgroundColor = theme_vars[["body-bg"]],
    highlightColor = sprintf("%s09", theme_vars[["primary"]]),
    borderColor = theme_vars[["border-color"]],
    borderWidth = "1px",
    cellPadding = "16px 8px",
    style = list(
      boxShadow = "0px 0px 4px 2px rgba(0, 0, 0, 0.1)",
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
    pageButtonStyle = pageButtonStyle,
    pageButtonCurrentStyle = pageButtonCurrentStyle
  )
}
