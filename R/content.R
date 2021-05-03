#' Get Content Items
#'
#' Returns content items as a data frame from the Connect server. It will only
#' return content that is visible to the API key's user account.
#'
#' @param client A Client object (see `connect`)
#'
#' @return A data frame (tibble) of content items
#'
#'   \itemize{
#'     \item id - Auto-incrementing identifier for each content item (legacy)
#'     \item guid - Unique identifier for each content item (preferred)
#'     \item owner_guid - Unique identifier of the owner of the content item
#'     \item owner_username - Username of the owner of teh content item
#'     \item owner_first_name - First name of the owner of the content item
#'     \item owner_last_name - Last name of the owner of the content item
#'     \item app_mode - The type of the content item (examples: `shiny`,
#'           `rmd-static`, `static`, `python-dash`, etc.)
#'     \item content_category - For `static` app modes, the specific category
#'           of content (examples: `site`, `plot`, `pin`, etc.)
#'     \item name - The name of the content item as set at initial publishing
#'     \item title - The user-provided title of the content item
#'     \item description - The user-provided description of the content item
#'     \item url - The URL to the content item
#'     \item created_time - The timestamp at which the content item
#'           was created
#'     \item updated_time - The timestamp at which the content item
#'           was last updated
#'   }
#'
#' @export
content <- function(client) {
  results <- client$GET("/content")

  df <- jsonlite::fromJSON(results, simplifyDataFrame = T)

  content_tbl <- tibble::tibble(
    id = as.integer(df$id),
    guid = df$guid,
    owner_guid = df$owner_guid,
    name = df$name,
    title = df$title,
    description = df$description,
    app_mode = df$app_mode,
    content_category = df$content_category,
    url = df$content_url,
    created_time = as.POSIXct(format_iso8601(df$created_time)),
    updated_time = as.POSIXct(format_iso8601(df$last_deployed_time))
  )

  # TODO: Temporary WILDLY INEFFICIENT loading of owners.  This is being
  # replaced by eager-loading additions to the v1 content API
  owners_df <-
    do.call(rbind, lapply(unique(content_tbl$owner_guid), function(guid)
      get_owner(client, guid)))
  owners_tbl <- tibble::tibble(
    owner_guid = as.character(owners_df$guid),
    owner_username = as.character(owners_df$username),
    owner_first_name = as.character(owners_df$first_name),
    owner_last_name = as.character(owners_df$last_name)
  )

  content_tbl %>%
    dplyr::left_join(owners_tbl, by = c("owner_guid")) %>%
    dplyr::relocate(dplyr::starts_with("owner_"), .after = "description")
}

get_owner <- function(client, owner_guid) {
  result <- client$GET(glue::glue("/users/{owner_guid}"))
  data.frame(jsonlite::fromJSON(result))
}

format_iso8601 <- function(str) {
  strptime(str, "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
}
