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
  bswatch_theme <- tryCatch({
    rmarkdown::metadata$output$html_document$theme
  }, error = function(e) e)
  theme_in_meta <- !inherits(bswatch_theme, "error") && !is.null(bswatch_theme)
  if (theme_in_meta) {
    bswatch_theme
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
    return(bslib::bs_theme(bootswatch = bootswatch_theme))
  }
  NULL
}

#' Generate the theme's bslib::bs_dependency to be used by a widget.
gen_theme_dependency <- function(widget_name, theme) {
  version <- "0.1.0"
  dependency_name <- sprintf("%s-theme-%s", widget_name, version)
  widget_theme_file <- sprintf("%s.scss", widget_name)
  scss_path <- system.file(package = "rscpages", "theming", widget_theme_file)
  bslib::bs_dependency(
    input = sass::sass_file(scss_path),
    theme = theme,
    name = dependency_name,
    version = version,
    cache_key_extra = version
  )
}

#' Resolve and get theme to be used by a widget. It could be the
#' default rscpages styling theme or one provided by the user.
resolve_theme_dependency <- function(widget_name) {
  theme <- get_current_theme()

  if (is.null(theme)) {
    # set default theme
    theme <- default_theme
  } else {
    # use bootswatch or user provided theme
    theme <- bslib::bs_theme_update(theme, "font-size-base" = "1.2rem")
  }

  gen_theme_dependency(widget_name, theme)
}
