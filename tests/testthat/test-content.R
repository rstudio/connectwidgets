context("content")

content_response <- "
[{
  \"id\": \"1\",
  \"bundle_id\": \"1\",
  \"guid\": \"991f16c5-dc7e-4403-89d0-c54d10968460\",
  \"name\": \"One\",
  \"title\": \"One\",
  \"description\": \"Lorem ipsum\",
  \"app_mode\": \"rmd-static\",
  \"content_category\": \"\",
  \"url\": \"https://test.io/content/991f16c5-dc7e-4403-89d0-c54d10968460/\",
  \"owner\": {
    \"guid\": \"100881c9-0162-4f3f-b973-6870085d48ff\",
    \"username\": \"adam\",
    \"first_name\": \"adam\",
    \"last_name\": \"strator\"
  },
  \"tags\": [{ \"name\": [\"blue\"] }],
  \"created_time\": \"2020-10-10\",
  \"last_deployed_time\": \"2020-10-12\"
},{
  \"id\": \"2\",
  \"bundle_id\": \"2\",
  \"guid\": \"4b5345cc-8dc5-46fa-80ed-1a389d80e21b\",
  \"name\": \"Two\",
  \"title\": \"Two\",
  \"description\": \"Lorem ipsum\",
  \"app_mode\": \"rmd-static\",
  \"content_category\": \"\",
  \"url\": \"https://test.io/content/4b5345cc-8dc5-46fa-80ed-1a389d80e21b/\",
  \"owner\": {
    \"guid\": \"100881c9-0162-4f3f-b973-6870085d48ff\",
    \"username\": \"rick\",
    \"first_name\": \"rick\",
    \"last_name\": \"mcbrittleguns\"
  },
  \"tags\": [{ \"name\": [\"green\"] }],
  \"created_time\": \"2020-10-10\",
  \"last_deployed_time\": \"2020-10-12\"
},{
  \"id\": \"3\",
  \"bundle_id\": null,
  \"guid\": \"b77ec334-951a-4b3e-9d01-3c2cc486c65e\",
  \"name\": \"Three\",
  \"title\": \"Three\",
  \"description\": \"Lorem ipsum\",
  \"app_mode\": \"rmd-static\",
  \"content_category\": \"\",
  \"url\": \"https://test.io/content/b77ec334-951a-4b3e-9d01-3c2cc486c65e/\",
  \"owner\": {
    \"guid\": \"100881c9-0162-4f3f-b973-6870085d48ff\",
    \"username\": \"adam\",
    \"first_name\": \"adam\",
    \"last_name\": \"strator\"
  },
  \"tags\": [{ \"name\": [\"yellow\"] }],
  \"created_time\": \"2020-10-10\",
  \"last_deployed_time\": \"2020-10-12\"
}]
"

content_response_without_tags <- "
[{
  \"id\": \"1\",
  \"bundle_id\": \"1\",
  \"guid\": \"991f16c5-dc7e-4403-89d0-c54d10968460\",
  \"name\": \"One\",
  \"title\": \"One\",
  \"description\": \"Lorem ipsum\",
  \"app_mode\": \"rmd-static\",
  \"content_category\": \"\",
  \"url\": \"https://test.io/content/991f16c5-dc7e-4403-89d0-c54d10968460/\",
  \"owner\": {
    \"guid\": \"100881c9-0162-4f3f-b973-6870085d48ff\",
    \"username\": \"adam\",
    \"first_name\": \"adam\",
    \"last_name\": \"strator\"
  },
  \"created_time\": \"2020-10-10\",
  \"last_deployed_time\": \"2020-10-12\"
}]
"

get_client <- function() {
  local_server_stub()
  connect(server = "https://example.com", api_key = "fake-key")
}

test_that("content() ignores unpublished content by default", {
  client <- get_client()
  local_content_stub(jsonres = content_response)

  result <- content(client)
  expect_equal(result$id, c(1, 2))
  expect_equal(result$guid, c(
    "991f16c5-dc7e-4403-89d0-c54d10968460",
    "4b5345cc-8dc5-46fa-80ed-1a389d80e21b"
  ))
  expect_equal(result$name, c(
    "One",
    "Two"
  ))

  local_content_stub(jsonres = content_response)
  result <- content(client, unpublished = TRUE)
  expect_equal(result$id, c(1, 2, 3))
  expect_equal(result$guid, c(
    "991f16c5-dc7e-4403-89d0-c54d10968460",
    "4b5345cc-8dc5-46fa-80ed-1a389d80e21b",
    "b77ec334-951a-4b3e-9d01-3c2cc486c65e"
  ))
  expect_equal(result$name, c(
    "One",
    "Two",
    "Three"
  ))
})

test_that("content() should include tags", {
  client <- get_client()
  local_content_stub(jsonres = content_response)
  result <- content(client)
  expect_true("tags" %in% names(result))
})

test_that("content() should include tags without JSON tags", {
  client <- get_client()
  local_content_stub(jsonres = content_response_without_tags)
  result <- content(client)
  expect_true("tags" %in% names(result))
})
