test_that("evaluate_widget_input", {
  expect_error(
    evaluate_widget_input(
      "rsc_grid",
      c("guid"),
      c("guid", "url", "title")
    ),
    "rsc_grid requires a \"url\" column but is not present."
  )

  expect_error(
    evaluate_widget_input(
      "rsc_grid",
      c("guid", "url"),
      c("guid", "url", "title")
    ),
    "rsc_grid requires a \"title\" column but is not present."
  )

  expect_error(
    evaluate_widget_input(
      "rsc_grid",
      c("guid", "url", "title", "name"),
      c("guid", "url", "title")
    ),
    NA
  )
})

test_that("warning_widget_input", {
  expect_warning(
    warning_widget_input(
      "rsc_grid",
      c("guid"),
      c("updated_time")
    ),
    "rsc_grid expects a \"updated_time\" column but is not present."
  )

  expect_warning(
    warning_widget_input(
      "rsc_grid",
      c("guid", "url"),
      c("updated_time")
    ),
    "rsc_grid expects a \"updated_time\" column but is not present."
  )

  expect_warning(
    warning_widget_input(
      "rsc_grid",
      c("guid", "url", "updated_time"),
      c("updated_time")
    ),
    NA
  )
})
