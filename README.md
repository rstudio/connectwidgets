rscpages: Curate your content on RStudio Connect
================

<!-- badges: start -->

<!-- badges: end -->

## Overview

You can use the `rscpages` package to curate your content on RStudio
Connect, helping to create organized groups of content within an
RMarkdown document or Shiny app.

## Installation

**Note:** This package has not been released to CRAN yet and must be
installed from GitHub

``` r
# Install the released version from CRAN:
install.packages("rscpages")
```

To install the latest development version, you can install from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("rstudio/rscpages")
```

## Usage

### Fetching Content from RStudio Connect

You can specify the RStudio Connect server and your API key using the
`connect` function provided by `rscpages`. All methods used for fetching
content require the returned client from `connect` as the first
argument, which naturally encourages the use of pipes.

``` r
library(rscpages)
library(magrittr)

all_content <- connect(server = 'rsconnect.example.com', api_key = 'abcdef123456789') %>% content()
```

Although you can provide `server` and `api_key` to the `connect(...)`
function directly for quickly getting started, it is recommended to use
environment variables in production. The environment variables
`CONNECT_SERVER` and `CONNECT_API_KEY` will be used automatically if
they are present. In your development environment, these can be
conveniently set in an `.Renviron` as outlined in this
[article](https://support.rstudio.com/hc/en-us/articles/360047157094-Managing-R-with-Rprofile-Renviron-Rprofile-site-Renviron-site-rsession-conf-and-repos-conf).
When deploying to RStudio Connect, these environment variables will be
automatically provided - no steps necessary\!

``` r
library(rscpages)

# You could also have provided these in an .Renviron, but setting here for the sake
# of example
Sys.setenv(CONNECT_SERVER = "rsconnect.example.com")
Sys.setenv(CONNECT_API_KEY = "abcdef1234567890")

all_content <- connect() %>% content()
```

The `content` method returns a data frame of the content visible to the
API key being used. You can further use
[dplyr](https://dplyr.tidyverse.org/) or built-in R functions to filter,
mutate, and arrange the data frame for your own purposes.

**Note About Permissions:** If you are using the API key of an
administrator, all content on the RStudio Connect server will be
available; however, if you are using a publisher API key, only the
content visible to that particular publisher will be available.

### Displaying the Content

Once you have fetched the content, you can display the content in a rich
table format using the provided `rscpages` function. This renders a
[reactable](https://glin.github.io/reactable/) table that includes
searching, sorting, paginating, and filtering.

``` r
library(rscpages)
library(magrittr)

all_content <- connect() %>% content()

rscpages(all_content)
```

<center>

<img src="man/figures/README-table-1.png" width="90%">

</center>

## Example

Create a *page* that shows the 10 most recently updated shiny apps on
your RStudio Connect server.

**NOTE**: Don’t forget to ensure that `CONNECT_SERVER` and
`CONNECT_API_KEY` are set\!

``` r
library(rscpages)
library(dplyr)
library(magrittr)

recent <- connect() %>% content()
recent %<>%
  filter(
    owner_username == 'brian',
    app_mode == 'shiny'
  ) %>%
  arrange(created_time) %>%
  top_n(10)

rscpages(recent)
```
