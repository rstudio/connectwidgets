#' Get Content Items
#'
#' Returns content items as a data frame from the Connect server. It will only
#' return content that is visible to the API key's user account.
#'
#' @param client A Client object (see `connect`)
#' @param unpublished A boolean value specifying whether to return content that
#'   has not successfully published
#'
#' @return A data frame (tibble) of content items
#'
#'   \itemize{
#'     \item id - Auto-incrementing identifier for each content item (legacy)
#'     \item guid - Unique identifier for each content item (preferred)
#'     \item app_mode - The type of the content item (examples: `shiny`,
#'           `rmd-static`, `static`, `python-dash`, etc.)
#'     \item content_category - For `static` app modes, the specific category
#'           of content (examples: `site`, `plot`, `pin`, etc.)
#'     \item name - The name of the content item as set at initial publishing
#'     \item title - The user-provided title of the content item
#'     \item description - The user-provided description of the content item
#'     \item url - The URL to the content item
#'     \item owner_guid - Unique identifier of the owner of the content item
#'     \item owner_username - Username of the owner of teh content item
#'     \item owner_first_name - First name of the owner of the content item
#'     \item owner_last_name - Last name of the owner of the content item
#'     \item tags - A data frame of the tags associated with the content item,
#'           with format: (id, name, parent_id, created_time, updated_time)
#'     \item created_time - The timestamp at which the content item
#'           was created
#'     \item updated_time - The timestamp at which the content item
#'           was last updated
#'   }
#'
#' @export
content <- function(client, unpublished = FALSE) {
  df <- client$content()

  if (!unpublished) {
    df <- df %>% dplyr::filter(!is.na(.data$bundle_id))
  }

  tibble::tibble(
    id = as.integer(df$id),
    guid = df$guid,
    name = df$name,
    title = df$title,
    description = df$description,
    app_mode = df$app_mode,
    content_category = df$content_category,
    url = df$content_url,
    owner_guid = df$owner$guid,
    owner_username = df$owner$username,
    owner_first_name = df$owner$first_name,
    owner_last_name = df$owner$last_name,
    tags = df$tags,
    created_time = as.POSIXct(format_iso8601(df$created_time)),
    updated_time = as.POSIXct(format_iso8601(df$last_deployed_time))
  )
}

#' Filter content by tag(s)
#'
#' Returns content items that have the specified tag(s) (by tag name)
#'
#' @param content Content data frame from `content(...)`
#' @param tagnames The name of the tag, or a list of names if multiple
#'
#' @return The filtered content data frame
#'
#' @export
by_tags <- function(content, tagnames) {
  tagnames <- as.list(tagnames)
  content %>% dplyr::filter(purrr::map_lgl(content$tags, function(x) {
    any(tagnames %in% x$name)
  }))
}

#' @rdname by_tags
#' @export
by_tag <- by_tags

#' Filter content by owner(s)
#'
#' Returns content items owned by the specified user(s) (by username)
#'
#' @param content Content data frame from `content(...)`
#' @param usernames The username of the owner, or a list of usernames if
#'   multiple
#'
#' @return The filtered content data frame
#'
#' @export
by_owners <- function(content, usernames) {
  usernames <- as.list(usernames)
  content %>% dplyr::filter(.data$owner_username %in% usernames)
}

#' @rdname by_owners
#' @export
by_owner <- by_owners
