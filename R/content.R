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

  content.tbl <- tibble::tibble(
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

  # TODO: Temporary WILDLY INEFFICIENT loading of owners.  This is being replaced by eager-loading
  # additions to the v1 content API
  owners.df <- do.call(rbind, lapply(unique(content.tbl$owner_guid), function(guid) getOwner(connect, guid)))
  owners.tbl <- tibble::tibble(
    owner_guid = as.character(owners.df$guid),
    owner_username = as.character(owners.df$username),
    owner_first_name = as.character(owners.df$first_name),
    owner_last_name = as.character(owners.df$last_name)
  )

  content.tbl %>% dplyr::left_join(owners.tbl, by = c("owner_guid"))
}

getOwner <- function(connect, ownerGuid) {
  result <- connect$GET(glue::glue('/users/{ownerGuid}'))
  data.frame(jsonlite::fromJSON(result))
}
