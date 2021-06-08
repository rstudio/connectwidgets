test_that("evaluate_widget_input", {
  expect_error(
    evaluate_widget_input(
      "rscgrid",
      c("guid"),
      c("guid", "url", "title")
    ),
    "rscgrid requires a \"url\" column but is not present."
  )

  expect_error(
    evaluate_widget_input(
      "rscgrid",
      c("guid", "url"),
      c("guid", "url", "title")
    ),
    "rscgrid requires a \"title\" column but is not present."
  )

  expect_error(
    evaluate_widget_input(
      "rscgrid",
      c("guid", "url", "title", "name"),
      c("guid", "url", "title")
    ),
    NA
  )
})

test_that("warning_widget_input", {
  expect_warning(
    warning_widget_input(
      "rscgrid",
      c("guid"),
      c("updated_time")
    ),
    "rscgrid expects a \"updated_time\" column but is not present."
  )

  expect_warning(
    warning_widget_input(
      "rscgrid",
      c("guid", "url"),
      c("updated_time")
    ),
    "rscgrid expects a \"updated_time\" column but is not present."
  )

  expect_warning(
    warning_widget_input(
      "rscgrid",
      c("guid", "url", "updated_time"),
      c("updated_time")
    ),
    NA
  )
})
