#' Get Content Items
#'
#' Returns content items from the Connect server that are visible to the API key's user account
#'
#' @param connect A Connect object
#'
#' @return A tibble of content items
#'
#' @export
content <- function(connect) {
  results <- connect$GET("/content")

  df <- jsonlite::fromJSON(results, simplifyDataFrame = T)

  tibble::tibble(
    id = as.integer(df$id),
    guid = df$guid,
    owner_guid = df$owner_guid,
    app_mode = df$app_mode,
    content_category = df$content_category,
    name = df$name,
    title = df$title,
    description = df$description,
    url = df$content_url,
    created_time = as.POSIXct(strptime(df$created_time, "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")),
    updated_time = as.POSIXct(strptime(df$last_deployed_time, "%Y-%m-%dT%H:%M:%SZ", tz = "UTC"))
  )
}
