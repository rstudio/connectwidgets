#' Default reactable theme for rscpages table
#'
#' <Add Description>
#'
#' @export
rscpages_theme <- function() {
  search_icon <- function(fill = "none") {
    svg <- sprintf('<svg width="17" height="17" viewBox="0 0 17 17" fill="%s" xmlns="http://www.w3.org/2000/svg"><path d="M10.9792 9.91667H10.4196L10.2212 9.72542C10.9154 8.91792 11.3333 7.86958 11.3333 6.72917C11.3333 4.18625 9.27208 2.125 6.72917 2.125C4.18625 2.125 2.125 4.18625 2.125 6.72917C2.125 9.27208 4.18625 11.3333 6.72917 11.3333C7.86958 11.3333 8.91792 10.9154 9.72542 10.2212L9.91667 10.4196V10.9792L13.4583 14.5137L14.5137 13.4583L10.9792 9.91667ZM6.72917 9.91667C4.96542 9.91667 3.54167 8.49292 3.54167 6.72917C3.54167 4.96542 4.96542 3.54167 6.72917 3.54167C8.49292 3.54167 9.91667 4.96542 9.91667 6.72917C9.91667 8.49292 8.49292 9.91667 6.72917 9.91667Z" fill="#444444"/></svg>', fill) # nolint
    sprintf("url('data:image/svg+xml;base64,%s')", jsonlite::base64_enc(svg))
  }

  text_color <- "#444444"

  reactable::reactableTheme(
    color = text_color,
    backgroundColor = "#ffffff",
    highlightColor = "rgba(76, 131, 182, 0.05)",
    borderColor = "#f0f0f0",
    borderWidth = "1px",
    cellPadding = "16px 8px",
    style = list(
      boxShadow = "0px 0px 4px 2px rgba(0, 0, 0, 0.1)",
      borderRadius = 3
    ),
    headerStyle = list(
      "&:first-child" = list(paddingLeft = 24),
      "&:last-child" = list(paddingRight = 24)
    ),
    cellStyle = list(
      "&:first-child" = list(paddingLeft = 24),
      "&:last-child" = list(paddingRight = 24)
    ),
    searchInputStyle = list(
      alignSelf = "flex-start",
      margin = 24,
      paddingTop = 10,
      paddingRight = 10,
      paddingBottom = 10,
      paddingLeft = 36,
      width = 330,
      border = "1px solid #B0B0B0",
      borderRadius = "none",
      backgroundImage = search_icon(text_color),
      backgroundSize = 18,
      backgroundPosition = "left 10px center",
      backgroundRepeat = "no-repeat",
      "&:hover, &:focus" = list(backgroundImage = search_icon(text_color)),
      "::placeholder" = list(opacity = "0.7"),
      "&:hover::placeholder, &:focus::placeholder" = list(color = text_color)
    ),
    paginationStyle = list(
      flexDirection = "row-reverse",
      padding = "24px 12px"
    ),
    pageButtonStyle = list(
      borderRadius = "9999px"
    ),
    pageButtonCurrentStyle = list(
      backgroundColor = "#EDF6FF",
      color = "#5882B2"
    )
  )
}
