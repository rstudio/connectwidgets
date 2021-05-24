#' rscpages: Curate your content on RStudio Connect
#'
#' rscpages provides UI components to help publishers provide curated organization of content on RStudio Connect.
#'
#' @section Connection:
#' Set `CONNECT_SERVER` and `CONNECT_API_KEY` environment variables and [connect()].
#' Fetch a `tibble` listing server content with [content()].
#' Use the [by_owner()] and [by_tags()] filter helpers to narrow your search.
#'
#' @section Components:
#' Present your content with different components:
#' \itemize{
#' \item [rsccard()] for highlighting individual content items
#' \item [rscgrid()] for groups of cards
#' \item [rsctable()] for a tabular view
#' \item [rscsearch()] a text input for searching grids and tables
#' \item [rscfilter()] an input to filter grids or tables by owner, type, or tag
#' }
#'
#' @docType package
#' @name rscpages
"_PACKAGE"
