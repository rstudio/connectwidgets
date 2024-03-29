% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rsc_table.R
\name{rsc_table}
\alias{rsc_table}
\title{Reactable table of the content}
\usage{
rsc_table(content)
}
\arguments{
\item{content}{The tibble of content provided by connectwidgets::content()
Requires the columns "guid", "url", "title", "app_mode",
"owner_username" and "updated_time".}
}
\description{
Renders a reactable table of the provided content items
}
