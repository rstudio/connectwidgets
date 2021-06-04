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
  # principal variables in use by connectwidgets
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
#' @param widget_name The name of the widget (e.g: rsc_grid)
#' @param theme The bslib theme to generate the CSS dependency
#' @param default_base Using the default theme or not
gen_theme_dependency <- function(widget_name, theme, default_base = FALSE) {
  version <- "0.1.0"
  widget_theme_file <- sprintf("%s.scss", widget_name)
  if (default_base) {
    dependency_name <- sprintf("%s-default-theme-%s", widget_name, version)
    scss_path <- system.file(
      package = "connectwidgets",
      "theming",
      "default",
      widget_theme_file
    )
  } else {
    dependency_name <- sprintf("%s-theme-%s", widget_name, version)
    scss_path <- system.file(
      package = "connectwidgets",
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
#' default connectwidgets styling theme or one provided by the user.
#'
#' @param widget_name The name of the widget (e.g: rsc_grid)
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

#' Resolve reactable theme for rsc_table
rsc_table_sync_theme <- function() {
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
  pagination_styles <- table_pagination_styles(theme_vars)

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
    pageButtonStyle = pagination_styles[["styles"]],
    pageButtonCurrentStyle = pagination_styles[["current_styles"]]
  )
}

# TODO: The following table pagination styles and overwrites are temporary
# and meant to be used only until we update reactable to
# get styles from bootswatch themes.

table_pagination_styles <- function(theme_vars = NULL) {
  theme_name <- get_bootswatch_theme_name()

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
    "&:disabled" = list(
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

  if (is.null(theme_name)) {
    page_btns_style["border"] <- "none"
    page_btns_style["borderRadius"] <- "16px"
    page_btns_style["fontSize"] <- "0.9em"
    page_btns_style["height"] <- "32px"
    page_btns_style["line-height"] <- "32px"
    page_btns_style["marginLeft"] <- "0"
    page_btns_style["marginRight"] <- "5px"
    page_btns_style["minWidth"] <- "32px"
    page_btns_style["padding"] <- "0 0.8em"
    page_btns_current_style["backgroundColor"] <- theme_vars[["primary"]]
    page_btns_current_style["border"] <- "none"

    return(
      list(
        styles = page_btns_style,
        current_styles = page_btns_current_style
      )
    )
  }

  if (theme_name == "lumen") {
    page_btns_style["background"] <- theme_vars[["gray-100"]]
    page_btns_style["borderTop"] <- "1px solid white"
    page_btns_style["borderBottomWidth"] <- "4px"
    page_btns_style["fontSize"] <- "0.9em"
    page_btns_style["fontWeight"] <- "bold"
    page_btns_style["color"] <- theme_vars[["gray-700"]]
    page_btns_style["vertical-align"] <- "bottom"
    page_btns_style[["&:first-child"]] <- list(
      borderRadius = "4px 0 0 4px"
    )
    page_btns_style[["&:last-child"]] <- list(
      borderRadius = "0 4px 4px 0"
    )
    page_btns_style[["&:hover"]] <- list(
      background = theme_vars[["gray-100"]],
      borderTopWidth = "2px",
      borderBottomWidth = "3px"
    )
    page_btns_current_style["borderBottom"] <- "4px solid #127ba3"
    page_btns_current_style[["&:hover"]] <- list(
      background = theme_vars[["primary"]],
      borderTop = "2px solid white",
      borderBottomWidth = "3px"
    )
  }

  if (theme_name == "cyborg") {
    page_btns_style["background"] <- "#5A5B5A";
    page_btns_style["border"] <- "none"
    page_btns_style["color"] <- "white"
    page_btns_style["padding"] <- "0.6rem 0.8rem"
    page_btns_style[["&:first-child"]] <- list(
      borderRadius = "4px 0 0 4px"
    )
    page_btns_style[["&:last-child"]] <- list(
      borderRadius = "0 4px 4px 0"
    )
    page_btns_style[["&:disabled"]] <- list(
      background = "#5A5B5A",
      pointerEvents = "none",
      margin = "0",
      color = "#555"
    )
    page_btns_style[["&:hover"]] <- list(
      background = theme_vars[["primary"]]
    )
    page_btns_current_style["border"] <- "none"
    page_btns_current_style[["&:hover"]] <- list(
      background = theme_vars[["primary"]]
    )
  }

  if (theme_name == "darkly") {
    page_btns_style["background"] <- "#00bc8c"
    page_btns_style["border"] <- "none"
    page_btns_style["color"] <- "white"
    page_btns_style[["&:disabled"]] <- list(
      pointerEvents = "none",
      background = "#05a57c",
      color = "white",
      opacity = "1"
    )
    page_btns_style[["&:first-child"]] <- list(
      borderRadius = "4px 0 0 4px"
    )
    page_btns_style[["&:last-child"]] <- list(
      borderRadius = "0 4px 4px 0"
    )
    page_btns_style[["&:hover"]] <- list(background = "#1ac398")
    page_btns_current_style["background"] <- "#1ac398"
    page_btns_current_style["border"] <- "none"
    page_btns_current_style[["&:hover"]] <- list(
      background = "#1ac398",
      color = "white"
    )
  }

  if (theme_name == "flatly") {
    page_btns_style["background"] <- "#18bc9c"
    page_btns_style["border"] <- "none"
    page_btns_style["color"] <- "white"
    page_btns_style[["&:disabled"]] <- list(
      pointerEvents = "none",
      backgroundColor = "#3be6c4",
      color = "white",
      opacity = "1"
    )
    page_btns_style[["&:first-child"]] <- list(
      borderRadius = "4px 0 0 4px"
    )
    page_btns_style[["&:last-child"]] <- list(
      borderRadius = "0 4px 4px 0"
    )
    page_btns_style[["&:hover"]] <- list(background = "#0f7864")
    page_btns_current_style["background"] <- "#0f7864"
    page_btns_current_style["border"] <- "none"
    page_btns_current_style[["&:hover"]] <- list(
      background = "#0f7864",
      color = "white"
    )
  }

  if (theme_name == "minty") {
    page_btns_style["background"] <- theme_vars[["primary"]]
    page_btns_style["border"] <- "none"
    page_btns_style["color"] <- "white"
    page_btns_style["padding"] <- "0.62rem 0.84rem"
    page_btns_style[["&:disabled"]] <- list(
      pointerEvents = "none",
      backgroundColor = "#cce8e0",
      color = "white",
      opacity = "1"
    )
    page_btns_style[["&:first-child"]] <- list(
      borderRadius = "4px 0 0 4px"
    )
    page_btns_style[["&:last-child"]] <- list(
      borderRadius = "0 4px 4px 0"
    )
    page_btns_style[["&:hover"]] <- list(background = "#f3969a")
    page_btns_current_style["background"] <- "#f3969a"
    page_btns_current_style["border"] <- "none"
    page_btns_current_style["fontWeight"] <- "400"
    page_btns_current_style[["&:hover"]] <- list(
      background = "#f3969a",
      color = "white"
    )
  }

  if (theme_name == "sandstone") {
    page_btns_style["background"] <- "#f8f5f0"
    page_btns_style["border"] <- sprintf(
      "1px solid %s",
      theme_vars[["gray-300"]]
    )
    page_btns_style["color"] <- "#8e8c84"
    page_btns_style["fontSize"] <- "0.84em"
    page_btns_style["fontWeight"] <- "500"
    page_btns_style[["&:disabled"]] <- list(
      pointerEvents = "none",
      color = theme_vars[["gray-300"]]
    )
    page_btns_style[["&:hover"]] <- list(
      background = "#f8f5f0"
    )
    page_btns_current_style["background"] <- theme_vars[["gray-300"]]
    page_btns_current_style["border"] <- sprintf(
      "1px solid %s",
      theme_vars[["gray-300"]]
    )
    page_btns_current_style["borderColor"] <- theme_vars[["gray-300"]]
    page_btns_current_style[["&:hover"]] <- list(
      background = theme_vars[["gray-300"]],
      color = "#8e8c84"
    )
  }

  if (theme_name == "slate") {
    btn_gradient <- "linear-gradient(#4a4d51, #272b30 60%, #222529)"
    press_gradient <- "linear-gradient(#202327, #212529 40%, #22252a)"

    page_btns_style["background"] <- btn_gradient
    page_btns_style["border"] <- "1px solid rgba(0,0,0,0.6)"
    page_btns_style["borderColor"] <- "rgba(0,0,0,0.6)"
    page_btns_style["color"] <- "white"
    page_btns_style[["&:disabled"]] <- list(
      pointerEvents = "none",
      color = "#7a8288"
    )
    page_btns_style[["&:hover"]] <- list(
      background = press_gradient
    )
    page_btns_style[["&:first-child"]] <- list(
      borderRadius = "3px 0 0 3px"
    )
    page_btns_style[["&:last-child"]] <- list(
      borderRadius = "0 3px 3px 0"
    )
    page_btns_current_style["background"] <- press_gradient
    page_btns_current_style["border"] <- "1px solid rgba(0,0,0,0.6)"
    page_btns_current_style["borderColor"] <- "rgba(0,0,0,0.6)"
    page_btns_current_style["fontWeight"] <- "400"
    page_btns_current_style[["&:hover"]] <- list(
      background = press_gradient,
      color = "white"
    )
  }

  if (theme_name == "superhero") {
    page_btns_style["background"] <- "#51616f"
    page_btns_style["border"] <- "none"
    page_btns_style["color"] <- "white"
    page_btns_style[["&:disabled"]] <- list(
      pointerEvents = "none",
      color = "rgba(255,255,255,0.4)",
      opacity = "1"
    )
    page_btns_style[["&:hover"]] <- list(
      background = "rgba(255,255,255,0.4)"
    )
    page_btns_current_style["border"] <- "none"
    page_btns_current_style[["&:hover"]] <- list(
      background = theme_vars[["primary"]],
      color = "white"
    )
  }

  if (theme_name == "yeti") {
    page_btns_style["border"] <- "none"
    page_btns_style["borderRadius"] <- "3px"
    page_btns_style["color"] <- "#888888"
    page_btns_style["fontWeight"] <- "300"
    page_btns_style["marginRight"] <- "3px"
    page_btns_style[["&:disabled"]] <- list(
      pointerEvents = "none",
      color = "#EEEEEE",
      opacity = "1"
    )
    page_btns_style[["&:hover"]] <- list(
      background = "#EEEEEE",
      color = theme_vars[["primary"]]
    )
    page_btns_current_style["border"] <- "none"
    page_btns_current_style[["&:hover"]] <- list(
      background = theme_vars[["primary"]],
      color = "white"
    )
  }

  if (theme_name == "lux") {
    page_btns_style["border"] <- "none"
    page_btns_style["padding"] <- "0.62rem 0.84rem"
    page_btns_current_style["border"] <- "none"
    page_btns_current_style[["&:hover"]] <- list(
      background = theme_vars[["primary"]]
    )
  }

  if (theme_name == "sketchy") {
    border_radius <- "425px 255px 25px 25px/25px 25px 5px 25px"
    page_btns_style["border"] <- sprintf(
      "2px solid %s",
      theme_vars[["primary"]]
    )
    page_btns_style["borderColor"] <- theme_vars[["primary"]]
    page_btns_style["borderRadius"] <- border_radius
    page_btns_style["fontWeight"] <- "bold"
    page_btns_style[["&:not(first-child)"]] <- list(
      marginLeft = "-2px"
    )
    page_btns_style[["&:disabled"]] <- list(
      pointerEvents = "none",
      color = "#CCCCCC",
      opacity = "1"
    )
    page_btns_style[["&:hover"]] <- list(
      background = theme_vars[["primary"]],
      color = "white"
    )
    page_btns_current_style["border"] <- sprintf(
      "2px solid %s",
      theme_vars[["primary"]]
    )
    page_btns_current_style["borderColor"] <- theme_vars[["primary"]]
    page_btns_current_style[["&:hover"]] <- list(
      background = theme_vars[["primary"]]
    )
  }

  if (theme_name == "cerulean") {
    page_btns_style[["&:first-child"]] <- list(
      borderRadius = "3px 0 0 3px"
    )
    page_btns_style[["&:last-child"]] <- list(
      borderRadius = "0 3px 3px 0"
    )
    page_btns_current_style[["&:hover"]] <- list(
      background = theme_vars[["primary"]],
      color = "white"
    )
  }

  list(
    styles = page_btns_style,
    current_styles = page_btns_current_style
  )
}
