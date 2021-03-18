#' Class representing a Connect API client
#'
#' @name RStudioConnect
#'
#' @section Usage:
#' \preformatted{
#' client <- Connect$new(host = 'connect.example.com', apiKey = 'mysecretkey')
#' }
#'
#' @section Details:
#'
#' This class allows a user to interact with a Connect server via the Connect
#' API. Authentication is done by providing an API key.
#'
#' @importFrom utils capture.output
#'
#' @family R6 classes
#'
#' @export
Connect <- R6::R6Class(
  "Connect",
  public = list(
    server = NULL,
    api_key = NULL,

    initialize = function(server, api_key) {
      self$server <- server
      self$api_key <- api_key
    },

    print = function(...) {
      cat("RStudio Connect API Client: \n")
      cat("  Server: ", self$server, "\n", sep = "")
      cat("  API Key: ", paste0(strrep("*", 11), substr(self$api_key, nchar(self$api_key) - 3, nchar(self$api_key))), "\n", sep = "")
      invisible(self)
    },

    raise_error = function(res) {
      if (httr::http_error(res)) {
        err <- sprintf(
          "%s request failed with %s",
          res$request$url,
          httr::http_status(res)$message
        )
        message(capture.output(str(httr::content(res))))
        stop(err)
      }
    },

    add_auth = function() {
      httr::add_headers(Authorization = paste0("Key ", self$api_key))
    },

    GET = function(path, writer = httr::write_memory(), parser = "text") {
      url <- paste0(self$server, "/__api__/v1/", path)
      res <- httr::GET(
        url,
        self$add_auth(),
        writer
      )
      self$raise_error(res)
      httr::content(res, as = parser)
    }
  )
)

#' Create a connection to RStudio Connect
#'
#' Creates a connection to RStudio Connect using the server URL and an api key.
#'
#' @param server The server URL for accessing RStudio Connect. Defaults to environment
#'   variable CONNECT_SERVER
#' @param api_key The API key to authenticate with RStudio Connect. Defaults
#'   to environment variable CONNECT_API_KEY
#'
#' @return An RStudio Connect R6 object that can be passed along to methods
#'
#' @rdname connect
#' @export
connect <- function(
  server = Sys.getenv("CONNECT_SERVER", NA_character_),
  api_key = Sys.getenv("CONNECT_API_KEY", NA_character_)) {

  Connect$new(server = server, api_key = api_key)
}
