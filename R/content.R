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
  results <- client$GET("/content", query = list(include = "tags,owner"))

  df <- jsonlite::fromJSON(results, simplifyDataFrame = T)

  content_tbl <- tibble::tibble(
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

#' Arrange HTML elements or widgets in Bootstrap columns
#'
#' This helper function makes it easy to put HTML elements side by side. It can
#' be called directly from the console but is especially designed to work in an
#' R Markdown document. Warning: This will bring in all of Bootstrap!
#'
#' @param ... \code{htmltools} tag objects, lists, text, HTML widgets, or
#'   NULL. These arguments should be unnamed.
#' @param widths The number of columns that should be assigned to each of the
#'   \code{...} elements (the total number of columns available is always 12).
#'   The width vector will be recycled if there are more \code{...} arguments.
#'   \code{NA} columns will evenly split the remaining columns that are left
#'   after the widths are recycled and non-\code{NA} values are subtracted.
#' @param device The class of device which is targeted by these widths; with
#'   smaller screen sizes the layout will collapse to a one-column,
#'   top-to-bottom display instead. xs: never collapse, sm: collapse below
#'   768px, md: 992px, lg: 1200px.
#'
#' @return A \code{\link[htmltools]{browsable}} HTML element.
#'
#' @examples
#' \donttest{
#' library(htmltools)
#'
#' # If width is unspecified, equal widths will be used
#' bscols(
#'   div(style = css(width="100%", height="400px", background_color="red")),
#'   div(style = css(width="100%", height="400px", background_color="blue"))
#' )
#'
#' # Use NA to absorb remaining width
#' bscols(widths = c(2, NA, NA),
#'   div(style = css(width="100%", height="400px", background_color="red")),
#'   div(style = css(width="100%", height="400px", background_color="blue")),
#'   div(style = css(width="100%", height="400px", background_color="green"))
#' )
#'
#' # Recycling widths
#' bscols(widths = c(2, 4),
#'   div(style = css(width="100%", height="400px", background_color="red")),
#'   div(style = css(width="100%", height="400px", background_color="blue")),
#'   div(style = css(width="100%", height="400px", background_color="red")),
#'   div(style = css(width="100%", height="400px", background_color="blue"))
#' )
#' }
#' @export
bscols <- function(..., widths = NA, device = c("xs", "sm", "md", "lg")) {
  crosstalk::bscols(..., widths = widths, device = device)
}

format_iso8601 <- function(str) {
  strptime(str, "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
}
