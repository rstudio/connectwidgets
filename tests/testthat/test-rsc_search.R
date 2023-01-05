get_attribs <- function(widget) widget$x$tag$attribs

content_sample <- data.frame(
  guid = c(
    "991f16c5-dc7e-4403-89d0-c54d10968460",
    "4b5345cc-8dc5-46fa-80ed-1a389d80e21b",
    "100881c9-0162-4f3f-b973-6870085d48ff"
  ),
  url = c(
    "https://connect.tester.net/content/991f16c5-dc7e-4403-89d0-c54d10968460/",
    "https://connect.tester.net/content/4b5345cc-8dc5-46fa-80ed-1a389d80e21b/",
    "https://connect.tester.net/content/100881c9-0162-4f3f-b973-6870085d48ff/"
  ),
  title = c("One", "Two", "Three")
)

test_that("rsc_search handles invalid/missing args", {
  # missing content param
  expect_error(rsc_search())

  # not a data frame or crosstalk object
  expect_error(rsc_search("marshmallow"))

  # warning for empty data
  expect_warning(rsc_search(data.frame()))

  expect_warning(
    rsc_search(content_sample),
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
    rsc_search(content),
    "exceeds maximum"
  )
})

test_that("rsc_search container", {
  widget <- rsc_search(content_sample)
  attrs <- get_attribs(widget)
  expect_equal(attrs$data$guid, content_sample$guid)
  expect_equal(attrs$data$url, content_sample$url)
  expect_equal(attrs$data$title, content_sample$title)
  expect_equal(length(attrs$crosstalkKey), 3)
  expect_true(length(attrs$crosstalkGroup) > 0)
})

test_that("rsc_search supports crosstalk", {
  sh <- crosstalk::SharedData$new(
    content_sample,
    key = ~guid,
    group = "searchpluzzz"
  )

  widget <- rsc_search(sh)
  attrs <- get_attribs(widget)

  expect_true("991f16c5-dc7e-4403-89d0-c54d10968460" %in% attrs$crosstalkKey)
  expect_true("4b5345cc-8dc5-46fa-80ed-1a389d80e21b" %in% attrs$crosstalkKey)
  expect_true("100881c9-0162-4f3f-b973-6870085d48ff" %in% attrs$crosstalkKey)
  expect_equal(attrs$crosstalkGroup, "searchpluzzz")
})

test_that("rscsearchOutput", {
  output <- rscsearchOutput("mysearch")

  # HTML dependencies should be intact
  deps <- htmltools::htmlDependencies(output)
  expect_true(length(deps) > 0)

  # Output container should have data-reactable-output ID set
  name <- output[[1]]$name
  id <- htmltools::tagGetAttribute(output[[1]], "id")
  cls <- htmltools::tagGetAttribute(output[[1]], "class")
  expect_equal(name, "div")
  expect_equal(id, "mysearch")
  expect_match(cls, "rsc_search html-widget html-widget-output")
})
