#' Reactable table of the content
#'
#' Renders a reactable table of the provided content items
#'
#' @param content The tibble of content provided by connectwidgets::content()
#' Requires the columns "guid", "url", "title", "app_mode",
#' "owner_username" and "updated_time".
#'
#' @importFrom rlang .data
#'
#' @export
rsc_table <- function(content) {
  if (missing(content)) {
    stop(
      "rsc_table() expects a data frame or a crosstalk shared data object."
    )
  }

  if (!crosstalk::is.SharedData(content)) {
    if (!is.data.frame(content)) {
      stop(
        "rsc_table() expects a data frame or a crosstalk shared data object."
      )
    }
    ctalk_group <- digest::digest(toString(content), "md5")
    content <- crosstalk::SharedData$new(content, group = ctalk_group)
  }

  if (nrow(content$origData()) == 0) {
    warning("rsc_table() was called with an empty data frame.")
  } else {
    cols <- colnames(content$origData())
    evaluate_widget_input(
      "rsc_table()",
      cols,
      c("guid", "url", "title", "app_mode", "owner_username", "updated_time")
    )
    warning_large_content(content$origData())
  }

  reactable::reactable(
    content,
    searchable = FALSE,
    highlight = TRUE,
    showPageInfo = FALSE,
    rowStyle = list(cursor = "pointer"),
    onClick = reactable::JS("function(rowInfo, colInfo) {
      window.open(rowInfo.row.url, '_blank')
    }"),
    columns = list(
      id = reactable::colDef(show = FALSE),
      guid = reactable::colDef(show = FALSE),
      title = reactable::colDef(show = FALSE),
      description = reactable::colDef(show = FALSE),
      content_category = reactable::colDef(show = FALSE),
      url = reactable::colDef(show = FALSE),
      created_time = reactable::colDef(show = FALSE),
      owner_guid = reactable::colDef(show = FALSE),
      owner_first_name = reactable::colDef(show = FALSE),
      owner_last_name = reactable::colDef(show = FALSE),
      tags = reactable::colDef(show = FALSE),
      name = reactable::colDef(
        name = "Name",
        cell = function(value, index) {
          data <- content$data()
          title <- data$title[index]
          app_mode <- data$app_mode[index]
          content_category <- data$content_category[index]
          htmltools::tagList(
            htmltools::img(
              src = content_icons[[content_type_icon(app_mode, content_category)]],
              alt = app_mode,
              width = 24,
              height = 24,
              style = list(
                verticalAlign = "middle",
                marginRight = 10
              )
            ),
            htmltools::strong(ifelse(is.na(title), value, title))
          )
        }
      ),
      owner_username = reactable::colDef(
        name = "Owner",
        maxWidth = 175
      ),
      app_mode = reactable::colDef(
        name = "Type",
        cell = function(value, index) {
          data <- content$data()
          app_mode <- data$app_mode[index]
          content_category <- data$content_category[index]
          content_type_label(app_mode, content_category)
        },
        maxWidth = 175
      ),
      updated_time = reactable::colDef(
        name = "Updated",
        align = "right",
        cell = function(value) {
          strftime(value, format = "%b %d, %Y")
        },
        maxWidth = 175
      )
    ),
    language = reactable::reactableLang(
      searchPlaceholder = "Search",
      noData = "No content found",
      pagePrevious = "\u276e",
      pageNext = "\u276f"
    ),
    theme = rsc_table_sync_theme()
  )
}

content_type_icon <- function(app_mode, content_category) {
  switch(as.character(app_mode),
    "api" = "api",
    "shiny" = "app",
    "rmd-shiny" = "app_doc",
    "rmd-static" = switch(content_category,
      "site" = "site",
      "rmd"
    ),
    "jupyter-static" = "jupyter",
    "static" = switch(content_category,
      "plot" = "plot",
      "pin" = "pin",
      "site" = "site",
      "rmd"
    ),
    "tensorflow-saved-model" = "tf",
    "python-api" = "api",
    "python-dash" = "app",
    "python-streamlit" = "app",
    "python-bokeh" = "app",
    "python-fastapi" = "api",
    "quarto-shiny" = "app_doc",
    "quarto-static" = switch(content_category,
      "site" = "site",
      "rmd"
    ),
    "python-shiny" = "app",
    "jupyter-voila" = "app_doc",
    "rmd"
  )
}

content_type_label <- function(app_mode, content_category) {
  switch(as.character(app_mode),
    "api" = "API",
    "shiny" = "Application",
    "rmd-shiny" = "Document",
    "rmd-static" = switch(content_category,
      "site" = "Site",
      "Document"
    ),
    "jupyter-static" = "Document",
    "static" = switch(content_category,
      "plot" = "Plot",
      "pin" = "Pin",
      "site" = "Site",
      "Document"
    ),
    "tensorflow-saved-model" = "Model",
    "python-api" = "API",
    "python-dash" = "Application",
    "python-streamlit" = "Application",
    "python-bokeh" = "Application",
    "python-fastapi" = "API",
    "quarto-shiny" = "Document",
    "quarto-static" = switch(content_category,
      "site" = "Site",
      "Document"
    ),
    "python-shiny" = "Application",
    "jupyter-voila" = "Document",
    "Other"
  )
}
