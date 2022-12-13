get_attribs <- function(widget) widget$x$tag$attribs

content_sample <- data.frame(
  guid = c(
    "991f16c5-dc7e-4403-89d0-c54d10968460",
    "4b5345cc-8dc5-46fa-80ed-1a389d80e21b",
    "100881c9-0162-4f3f-b973-6870085d48ff"
  ),
  owner_username = c("bob", "jerry", "adam"),
  app_mode = c("api", "rmd-static", "shiny"),
  tags = c("blue", "green", "pale yellow")
)

test_that("rsc_filter handles invalid/missing args", {
  # missing content param
  expect_error(rsc_filter())

  # not a data frame or crosstalk object
  expect_error(rsc_filter("marshmallow"))

  # warnings for missing "owner_username", "app_mode" and "tags"
  content <- data.frame(id = c("1", "2", "3"))
  expect_warning(rsc_filter(content))

  owner_username <- c("bob", "jerry", "adam")
  content <- cbind(content, owner_username)
  expect_warning(rsc_filter(content))

  app_mode <- c("api", "rmd-static", "shiny")
  content <- cbind(content, app_mode)
  expect_warning(rsc_filter(content))

  tags <- c("blue", "green", "pale yellow")
  content <- cbind(content, tags)
  expect_warning(
    rsc_filter(content),
    NA
  )
})

test_that("should warn on large content", {
  over_max_size <- 501
  content <- data.frame(
    guid = rep("100881c9-0162-4f3f-b973-6870085d48ff", times = over_max_size),
    title = rep("Test", times = over_max_size),
    url = rep(
      "https://example.com/content/991f16c5-dc7e-4403-89d0-c54d10968460/",
      times = over_max_size
    ),
    owner_username = rep("bob", times = over_max_size),
    description = rep("Lorem ipsum", times = over_max_size),
    updated_time = rep("Sat Oct 03 2020", times = over_max_size)
  )

  expect_warning(
    rsc_filter(content),
    "exceeds maximum"
  )
})

test_that("rsc_filter container", {
  widget <- rsc_filter(content_sample)
  attrs <- get_attribs(widget)
  expect_equal(attrs$data$guid, content_sample$guid)
  expect_equal(attrs$data$owner_username, content_sample$owner_username)
  expect_equal(attrs$data$app_mode, content_sample$app_mode)
  expect_equal(attrs$data$tags, content_sample$tags)
  expect_equal(length(attrs$crosstalkKey), 3)
  expect_true(length(attrs$crosstalkGroup) > 0)
})

test_that("rsc_filter supports crosstalk", {
  sh <- crosstalk::SharedData$new(
    content_sample,
    key = ~guid,
    group = "profilterz"
  )

  widget <- rsc_filter(sh)
  attrs <- get_attribs(widget)

  expect_true("991f16c5-dc7e-4403-89d0-c54d10968460" %in% attrs$crosstalkKey)
  expect_true("4b5345cc-8dc5-46fa-80ed-1a389d80e21b" %in% attrs$crosstalkKey)
  expect_true("100881c9-0162-4f3f-b973-6870085d48ff" %in% attrs$crosstalkKey)
  expect_equal(attrs$crosstalkGroup, "profilterz")
})

test_that("rscfilterOutput", {
  output <- rscfilterOutput("myfilterid")

  # HTML dependencies should be intact
  deps <- htmltools::htmlDependencies(output)
  expect_true(length(deps) > 0)

  # Output container should have data-reactable-output ID set
  name <- output[[1]]$name
  id <- htmltools::tagGetAttribute(output[[1]], "id")
  cls <- htmltools::tagGetAttribute(output[[1]], "class")
  expect_equal(name, "div")
  expect_equal(id, "myfilterid")
  expect_match(cls, "rsc_filter html-widget html-widget-output")
})
