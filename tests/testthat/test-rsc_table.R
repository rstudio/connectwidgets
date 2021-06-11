get_attribs <- function(widget) widget$x$tag$attribs

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
  content <- data.frame(
    id = rep("1", times = over_max_size),
    guid = rep("100881c9-0162-4f3f-b973-6870085d48ff", times = over_max_size),
    url = rep(
      "https://example.com/content/991f16c5-dc7e-4403-89d0-c54d10968460/",
      times = over_max_size
    ),
    title = rep("Test", times = over_max_size),
    name = rep("Test", times = over_max_size),
    description = rep("Lorem Ipsum", times = over_max_size),
    app_mode = rep("api", times = over_max_size),
    content_category = rep("", times = over_max_size),
    owner_guid = rep(
      "100881c9-0162-4f3f-b973-6870085d48ff",
      times = over_max_size
    ),
    owner_username = rep("bob", times = over_max_size),
    owner_first_name = rep("Bob", times = over_max_size),
    owner_last_name = rep("Smith", times = over_max_size),
    tags = rep(NA, times = over_max_size),
    created_time = rep("2021-05-05T10:00:00Z", times = over_max_size),
    updated_time = rep("2021-05-05T10:00:00Z", times = over_max_size)
  )

  expect_warning(
    rsc_table(content),
    "exceeds maximum"
  )
})
