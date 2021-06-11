get_attribs <- function(widget) widget$x$tag$attribs

test_that("rsc_card handles invalid/missing args", {
  # missing content param
  expect_error(rsc_card())

  # empty data frame
  expect_error(rsc_card(data.frame()))

  # requires "guid", "title" and "url"
  content <- data.frame(id = c("1", "2", "3"))
  expect_error(rsc_card(content))

  guid <- c(
    "991f16c5-dc7e-4403-89d0-c54d10968460",
    "4b5345cc-8dc5-46fa-80ed-1a389d80e21b",
    "100881c9-0162-4f3f-b973-6870085d48ff"
  )
  content <- cbind(content, guid)
  expect_error(rsc_card(content))

  title <- c("One", "Two", "Three")
  content <- cbind(content, title)
  expect_error(rsc_card(content))

  url <- c(
    "https://test.io/content/991f16c5-dc7e-4403-89d0-c54d10968460/",
    "https://test.io/content/4b5345cc-8dc5-46fa-80ed-1a389d80e21b/",
    "https://test.io/content/100881c9-0162-4f3f-b973-6870085d48ff/"
  )
  content <- cbind(content, url)

  # warnings for missing "owner_username", "description" and "updated_time"
  expect_warning(rsc_card(content))

  owner_username <- c("bob", "jerry", "adam")
  content <- cbind(content, owner_username)
  expect_warning(rsc_card(content))

  description <- c("Lorem ipsum", "solor sit", "amet")
  content <- cbind(content, description)
  expect_warning(rsc_card(content))

  updated_time <- c(
    "Sat Oct 03 2020",
    "Sun Jan 24 2021",
    "Fri Oct 30 2020"
  )
  content <- cbind(content, updated_time)
  expect_warning(
    rsc_card(content),
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
    rsc_card(content),
    "exceeds maximum"
  )
})

test_that("rsc_card container", {
  content <- data.frame(
    guid = c(
      "991f16c5-dc7e-4403-89d0-c54d10968460",
      "4b5345cc-8dc5-46fa-80ed-1a389d80e21b",
      "100881c9-0162-4f3f-b973-6870085d48ff"
    ),
    title = c("One", "Two", "Three"),
    url = c(
      "https://test.io/content/991f16c5-dc7e-4403-89d0-c54d10968460/",
      "https://test.io/content/4b5345cc-8dc5-46fa-80ed-1a389d80e21b/",
      "https://test.io/content/100881c9-0162-4f3f-b973-6870085d48ff/"
    ),
    title = c("One", "Two", "Three"),
    owner_username = c("bob", "jerry", "adam"),
    description = c("Lorem ipsum", "solor sit", "amet"),
    updated_time = c(
      "Sat Oct 03 2020",
      "Sun Jan 24 2021",
      "Fri Oct 30 2020"
    )
  )

  widget <- rsc_card(content)
  attrs <- get_attribs(widget)

  expect_equal(attrs$data$guid, content$guid)
  expect_equal(attrs$data$title, content$title)
  expect_equal(attrs$data$url, content$url)
})

test_that("rsccardOutput", {
  output <- rsccardOutput("myrsccardid")

  # HTML dependencies should be intact
  deps <- htmltools::htmlDependencies(output)
  expect_true(length(deps) > 0)

  # Output container should have data-reactable-output ID set
  expect_equal(output[[1]][[4]]$name, "div")
  expect_equal(output[[1]][[4]]$attribs$id, "myrsccardid")
  expect_equal(
    output[[1]][[4]]$attribs$class,
    "rsc_card html-widget html-widget-output"
  )
})
