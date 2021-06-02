context("connect")

test_that("should require server (if no CONNECT_SERVER)", {
  local_server_stub()
  expect_error(
    connect(api_key = "fake"),
    "valid server"
  )
})

test_that("should require api_key (if no CONNECT_API_KEY)", {
  local_server_stub()
  expect_error(
    connect(server = "http://example.com"),
    "valid API key"
  )
})

test_that("should use CONNECT_SERVER by default", {
  local_server_stub()
  withr::with_envvar(
    c(CONNECT_SERVER = "https://example.com"),
    expect_equal(
      connect(api_key = "fake")$server,
      "https://example.com"
    )
  )
})

test_that("should use CONNECT_API_KEY by default", {
  local_server_stub()
  withr::with_envvar(
    c(CONNECT_API_KEY = "an-api-key"),
    expect_equal(
      connect(server = "https://example.com")$api_key,
      "an-api-key"
    )
  )
})

test_that("should require scheme for server", {
  local_server_stub()
  expect_error(
    connect(server = "test.example.com", api_key = "fake"),
    "protocol"
  )

  expect_error(
    connect(server = "://test.example.com", api_key = "fake"),
    "protocol"
  )
})

test_that("should require valid server URL", {
  local_server_stub(status = 404)
  expect_error(
    connect(server = "https://example.com", api_key = "fake"),
    "Not Found"
  )
})

test_that("should require valid auth credentials", {
  local_server_stub(status = 401)
  expect_error(
    connect(server = "https://example.com", api_key = "fake"),
    "Unauthorized"
  )
})

test_that("should require minumum RStudio Connect server version", {
  local_server_stub(version = "1.8.0")
  expect_error(
    connect(server = "https://example.com", api_key = "fake"),
    "server version"
  )
})
