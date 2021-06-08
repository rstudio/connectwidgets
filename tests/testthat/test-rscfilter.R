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

  expect_equal(attrs$crosstalkKey, c(
    "991f16c5-dc7e-4403-89d0-c54d10968460",
    "4b5345cc-8dc5-46fa-80ed-1a389d80e21b",
    "100881c9-0162-4f3f-b973-6870085d48ff"
  ))
  expect_equal(attrs$crosstalkGroup, "profilterz")
})

test_that("rscfilterOutput", {
  output <- rscfilterOutput("myfilterid")

  # HTML dependencies should be intact
  deps <- htmltools::htmlDependencies(output)
  expect_true(length(deps) > 0)

  # Output container should have data-reactable-output ID set
  expect_equal(output[[1]][[4]]$name, "div")
  expect_equal(output[[1]][[4]]$attribs$id, "myfilterid")
  expect_equal(
    output[[1]][[4]]$attribs$class,
    "rsc_filter html-widget html-widget-output"
  )
})
