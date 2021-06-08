library(webmockr)
library(httr)

httr_mock()

local_server_stub <- function(
  status = 200,
  version = "1.9.0",
  env = parent.frame()
) {
  stub_request("get", "https://example.com/__api__/server_settings") %>%
    to_return(
      status = status,
      body = glue::glue(
        "{\"version\":\"{{version}}\"}", .open = "{{", .close = "}}"
      ),
      headers = list("content-type" = "application/json")
    )

  withr::defer({
    webmockr::stub_registry_clear()
  }, envir = env)
}

local_content_stub <- function(
  status = 200,
  version = "1.9.0",
  env = parent.frame(),
  jsonres = ""
) {
  stub_request(
    "get",
    "https://example.com/__api__/v1/content?include=tags%2Cowner"
  ) %>% to_return(
      status = status,
      body = glue::glue(jsonres, .open = "{{", .close = "}}"),
      headers = list(
        "content-type" = "application/json",
        "Authorization" = "Key fake-key"
      )
    )

  withr::defer({
    webmockr::stub_registry_clear()
  }, envir = env)
}
