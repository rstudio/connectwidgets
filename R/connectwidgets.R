#' connectwidgets: Curate your content on RStudio Connect
#'
#' connectwidgets provides UI components to help publishers provide curated
#' organization of content on RStudio Connect.
#'
#' @section Connection:
#' Set `CONNECT_SERVER` and `CONNECT_API_KEY` environment variables and
#' [connect()]. Fetch a `tibble` listing server content with [content()]. Use
#' the [by_owner()] and [by_tags()] filter helpers to narrow your search.
#'
#' @section Components:
#' Present your content with different components:
#' \itemize{
#' \item [rsc_card()] for highlighting individual content items
#' \item [rsc_grid()] for groups of cards
#' \item [rsc_table()] for a tabular view
#' \item [rsc_search()] a text input for searching grids and tables
#' \item [rsc_filter()] an input to filter grids or tables
#' by owner, type, or tag
#' }
#'
#' @docType package
#' @name connectwidgets
"_PACKAGE"
