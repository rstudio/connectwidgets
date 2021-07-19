test_that("gen_theme_dependency()", {
  # It is possible to use the default theme
  result <- gen_theme_dependency(
    "rsc_filter",
    default_theme(),
    default_base = TRUE
  )
  expect_equal(result$name, "rsc_filter-default-theme-0.1.0")

  # Users can customize the default theme
  custom_theme <- bslib::bs_theme(
    bg = "#FFF",
    fg = "#22333B",
    primary = "#4f772d",
    secondary = "#577590",
    dark = "#252525",
    light = "#dce6d3",
    base_font = "Lato, sans-serif",
    heading_font = "Lato, sans-serif",
    "border-color" = "#E9F5DB",
    "gray-100" = "#f7fcf0",
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
  result <- gen_theme_dependency(
    "rsc_search",
    custom_theme,
    default_base = TRUE
  )
  expect_equal(result$name, "rsc_search-default-theme-0.1.0")

  # When bootswatch rules take over
  result <- gen_theme_dependency("rsc_search", custom_theme)
  expect_equal(result$name, "rsc_search-theme-0.1.0")
})

test_that("resolve_theme_dependency() for widgets", {
  result <- resolve_theme_dependency("rsc_grid")
  expect_equal(result$name, "rsc_grid-default-theme-0.1.0")
})
