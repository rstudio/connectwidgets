get_attribs <- function(widget) widget$x$tag$attribs

sample_content <- function(n) {
  tibble::tibble(
    id = rep("1", times = n),
    guid = rep("100881c9-0162-4f3f-b973-6870085d48ff", times = n),
    url = rep(
      "https://example.com/content/991f16c5-dc7e-4403-89d0-c54d10968460/",
      times = n
    ),
    title = rep("Test", times = n),
    name = rep("Test", times = n),
    description = rep("Lorem Ipsum", times = n),
    app_mode = rep("api", times = n),
    content_category = rep("", times = n),
    owner_guid = rep(
      "100881c9-0162-4f3f-b973-6870085d48ff",
      times = n
    ),
    owner_username = rep("bob", times = n),
    owner_first_name = rep("Bob", times = n),
    owner_last_name = rep("Smith", times = n),
    tags = rep(NA, times = n),
    created_time = rep("2021-05-05T10:00:00Z", times = n),
    updated_time = rep("2021-05-05T10:00:00Z", times = n)
  )
}

test_that("rsc_table handles invalid/missing args", {
  # missing content param
  expect_error(rsc_table())

  # not a data frame or crosstalk object
  expect_error(rsc_table("marshmallow"))

  # requires "guid" "url" "title" "name"
  # "app_mode" "owner_username" "updated_time"
  content <- data.frame(id = c("1", "2", "3"))
  expect_error(rsc_table(content))

  guid <- c(
    "991f16c5-dc7e-4403-89d0-c54d10968460",
    "4b5345cc-8dc5-46fa-80ed-1a389d80e21b",
    "100881c9-0162-4f3f-b973-6870085d48ff"
  )
  content <- cbind(content, guid)
  expect_error(rsc_table(content))

  title <- c("One", "Two", "Three")
  content <- cbind(content, title)
  expect_error(rsc_table(content))

  name <- c("One", "Two", "Three")
  content <- cbind(content, name)
  expect_error(rsc_table(content))

  url <- c(
    "https://connect.tester.net/content/991f16c5-dc7e-4403-89d0-c54d10968460/",
    "https://connect.tester.net/content/4b5345cc-8dc5-46fa-80ed-1a389d80e21b/",
    "https://connect.tester.net/content/100881c9-0162-4f3f-b973-6870085d48ff/"
  )
  content <- cbind(content, url)
  expect_error(rsc_table(content))

  app_mode <- c("api", "rmd-static", "shiny")
  content <- cbind(content, app_mode)
  expect_error(rsc_table(content))

  owner_username <- c("bob", "jerry", "adam")
  content <- cbind(content, owner_username)
  expect_error(rsc_table(content))

  updated_time <- c(
    as.Date("2020-10-03"),
    as.Date("2021-06-24"),
    as.Date("2020-10-30")
  )
  content <- cbind(content, updated_time)
  expect_error(rsc_table(content))

  # reactable complains if a specified column
  # to not be shown is not present
  content <- cbind(content, description = c("", "", ""))
  content <- cbind(content, content_category = c("", "", ""))
  content <- cbind(content, created_time = c("", "", ""))
  content <- cbind(content, owner_guid = c("", "", ""))
  content <- cbind(content, owner_first_name = c("", "", ""))
  content <- cbind(content, owner_last_name = c("", "", ""))
  content <- cbind(content, tags = c("", "", ""))
  expect_error(rsc_table(content), NA)
})

test_that("should warn on large content", {
  over_max_size <- 501
  content <- sample_content(over_max_size)
  expect_warning(
    rsc_table(content),
    "exceeds maximum"
  )
})

test_that("content_type_label should be appropriate (based on app mode and content category)", {
  test_cases <- tibble::tribble(
    ~app_mode, ~content_category, ~expected,
    "shiny", "", "Application",
    "rmd-shiny", "", "Document",
    "rmd-static", "", "Document",
    "static", "", "Document",
    "static", "plot", "Plot",
    "static", "pin", "Pin",
    "static", "site", "Site",
    "api", "", "API",
    "tensorflow-saved-model", "", "Model",
    "jupyter-static", "", "Document",
    "python-api", "", "API",
    "python-dash", "", "Application",
    "python-streamlit", "", "Application",
    "python-bokeh", "", "Application",
    "python-fastapi", "", "API",
    "quarto-shiny", "", "Document",
    "quarto-static", "", "Document",
    "quarto-static", "site", "Site",
    "python-shiny", "", "Application",
    "jupyter-voila", "", "Document",
    "bogus", "", "Other",
  )

  test_cases <- test_cases %>%
    dplyr::rowwise() %>%
    dplyr::mutate(actual = content_type_label(app_mode, content_category))

  expect_equal(test_cases$expected, test_cases$actual)
})

test_that("content_type_icon should be appropriate (based on app mode and content category)", {
  test_cases <- tibble::tribble(
    ~app_mode, ~content_category, ~expected,
    "shiny", "", "app",
    "rmd-shiny", "", "app_doc",
    "rmd-static", "", "rmd",
    "static", "", "rmd",
    "static", "plot", "plot",
    "static", "pin", "pin",
    "static", "site", "site",
    "api", "", "api",
    "tensorflow-saved-model", "", "tf",
    "jupyter-static", "", "jupyter",
    "python-api", "", "api",
    "python-dash", "", "app",
    "python-streamlit", "", "app",
    "python-bokeh", "", "app",
    "python-fastapi", "", "api",
    "quarto-shiny", "", "app_doc",
    "quarto-static", "", "rmd",
    "quarto-static", "site", "site",
    "python-shiny", "", "app",
    "jupyter-voila", "", "app_doc",
    "bogus", "", "rmd",
  )

  test_cases <- test_cases %>%
    dplyr::rowwise() %>%
    dplyr::mutate(actual = content_type_icon(app_mode, content_category))

  expect_equal(test_cases$expected, test_cases$actual)
})
