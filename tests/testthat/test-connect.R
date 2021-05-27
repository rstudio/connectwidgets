context("connect")

test_that("should require server (if no CONNECT_SERVER)", {
  expect_error(
    connect(api_key = "fake"),
    "valid server"
  )
})

test_that("should require api_key (if no CONNECT_API_KEY)", {
  expect_error(
    connect(server = "http://example.com"),
    "valid API key"
  )
})

test_that("should use CONNECT_SERVER by default", {
  withr::with_envvar(
    c(CONNECT_SERVER = "https://example.com"),
    expect_equal(
      connect(api_key = "fake")$server,
      "https://example.com"
    )
  )
})

test_that("should use CONNECT_API_KEY by default", {
  withr::with_envvar(
    c(CONNECT_API_KEY = "an-api-key"),
    expect_equal(
      connect(server = "https://example.com")$api_key,
      "an-api-key"
    )
  )
})

test_that("should require scheme for server", {
  expect_error(
    connect(server = "test.example.com", api_key = "fake"),
    "protocol"
  )

  expect_error(
    connect(server = "://test.example.com", api_key = "fake"),
    "protocol"
  )
})
