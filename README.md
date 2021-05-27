
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rscpages: Curate your content on RStudio Connect

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/rscpages)](https://CRAN.R-project.org/package=rscpages)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/rstudio/rscpages/workflows/R-CMD-check/badge.svg)](https://github.com/rstudio/rscpages/actions)
[![lint](https://github.com/rstudio/rscpages/actions/workflows/lint.yaml/badge.svg)](https://github.com/rstudio/rscpages/actions/workflows/lint.yaml)
<!-- badges: end -->

## Installation

This package has not been released to CRAN yet and must be installed
from GitHub:

``` r
# install.packages("remotes")
remotes::install_github("rstudio/rscpages")
```

## Example

Use the template:

``` r
rmarkdown::draft("example-page.Rmd", template = "rscpages", package = "rscpages")
```

You can also copy and knit the following example, or read on for more
details:

```` markdown
---
title: an example page
output: html_document
---

```{r setup, include=FALSE}
library(rscpages)
library(dplyr)

knitr::opts_chunk$set(echo = FALSE, message = FALSE, warning = FALSE)

client <- connect(
  # server  = Sys.getenv("CONNECT_SERVER"),
  # api_key = Sys.getenv("CONNECT_API_KEY")
  )

all_content <- client %>%
  content()

sample_content <- all_content %>%
  arrange(desc(updated_time)) %>%
  slice_head(prop = .3)
```

![](https://source.unsplash.com/1920x1080/?forest "A random forest.")

## Components

### card

```{r card}
sample_content %>%
  slice(1) %>%
  rsccard()
```

### grid

```{r grid}
sample_content %>%
  rscgrid()
```

### table

```{r table}
sample_content %>%
  rsctable()
```

### search & filter

```{r search-and-filter}
bscols(rscsearch(all_content), rscfilter(all_content), widths = c(2, 2))
rsctable(all_content)
```
````

### Setup

The client object:

-   Validates your API key with the RStudio Connect server
-   Ensures you are running a recent enough version of Connect

Use an `.Renviron` file to set the `CONNECT_SERVER` and
`CONNECT_API_KEY` environment variables. RStudio Connect will
[automatically
apply](https://docs.rstudio.com/connect/news/#rstudio-connect-188)
values for these at document run time, so there is no need to include
them in your code:

``` r
library(rscpages)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

knitr::opts_chunk$set(echo = FALSE, message = FALSE, warning = FALSE)

client <- connect(
  # server  = Sys.getenv("CONNECT_SERVER"),
  # api_key = Sys.getenv("CONNECT_API_KEY")
  )

all_content <- client %>%
  content()

glimpse(all_content)
#> Rows: 1,240
#> Columns: 15
#> $ id               <int> 4974, 4973, 3979, 4603, 4602, 4954, 4957, 4956, 4955,…
#> $ guid             <chr> "26c06977-8c70-4022-a034-abf17beab9f3", "50e7a85d-906…
#> $ name             <chr> "reticulated-shiny-app-py3-escalations", "rsc_sprint_…
#> $ title            <chr> "reticulated-shiny-app-py3-escalations", "RSC: Sprint…
#> $ description      <chr> "", "", "A table pin with 19469 rows and 10 columns."…
#> $ app_mode         <chr> "shiny", "static", "static", "static", "static", "rmd…
#> $ content_category <chr> "", "", "pin", "pin", "pin", "", "", "", "", "", "", …
#> $ url              <chr> "https://rsc.radixu.com/content/26c06977-8c70-4022-a0…
#> $ owner_guid       <chr> "fe07bf64-764e-4189-a1f8-0d56597d4c01", "6634098f-633…
#> $ owner_username   <chr> "toph", "chris", "brian", "kelly.obriant", "kelly.obr…
#> $ owner_first_name <chr> "Toph", "Chris", "Brian", "Kelly", "Kelly", "E. David…
#> $ owner_last_name  <chr> "Allen", "Tierney", "Smith", "@RStudio", "@RStudio", …
#> $ tags             <list> <NULL>, <NULL>, [<data.frame[2 x 5]>], [<data.frame[…
#> $ created_time     <dttm> 2021-05-27 17:28:30, 2021-05-27 15:44:26, 2020-04-03…
#> $ updated_time     <dttm> 2021-05-27 17:28:34, 2021-05-27 15:44:26, 2021-05-27…

sample_content <- all_content %>%
  arrange(desc(updated_time)) %>%
  slice_head(prop = .3)
```

#### `content()`

`content()` returns a data frame with the following columns:

-   `id` - Auto-incrementing identifier for each content item (legacy)
-   `guid` - Unique identifier for each content item (preferred)
-   `app_mode` - The type of the content item (examples: `shiny`,
    `rmd-static`, `static`, `python-dash`, etc.)
-   `content_category` - For `static` app modes, the specific category
    of content (examples: `site`, `plot`, `pin`, etc.)
-   `name` - The name of the content item as set at initial publishing
-   `title` - The user-provided title of the content item
-   `description` - The user-provided description of the content item
-   `url` - The URL to the content item
-   `owner_guid` - Unique identifier of the owner of the content item
-   `owner_username` - Username of the owner of the content item
-   `owner_first_name` - First name of the owner of the content item
-   `owner_last_name` - Last name of the owner of the content item
-   `tags` - A data frame of the tags associated with the content item,
    with the following columns: `id`, `name`, `parent_id`,
    `created_time`, `updated_time`.
-   `created_time` - The timestamp at which the content item was created
-   `updated_time` - The timestamp at which the content item was last
    updated

The data frame contains one row for each item visible to the requesting
user. For users in an “administrator” role, that will be all content
items.

#### Filtering Content

We provide helper functions to filter by both owners and tags.

-   `by_tags()` - Filters the data frame to only include content that
    has been tagged with the specified tag name(s). You can pass a
    single tag name or a vector of tag names. `by_tag` is provided as an
    alias for readability when using a single tag.

-   `by_owners()` - Filters the data frame to only include content with
    the specified owner(s) by username. You can pass a single username
    or a vector of usernames. `by_owner` is provided as an alias for
    readability when using a single username.

``` r
all_content %>% 
  by_tag("Audit Reports")
#> # A tibble: 6 x 15
#>      id guid  name  title description app_mode content_category url   owner_guid
#>   <int> <chr> <chr> <chr> <chr>       <chr>    <chr>            <chr> <chr>     
#> 1  4875 7cbd… Audi… Audi… Using the … rmd-sta… ""               http… 0fc96747-…
#> 2  4619 b191… tag-… Tag … List all t… rmd-sta… ""               http… 0fc96747-…
#> 3  4618 4348… acl-… Cont… Generate a… rmd-sta… ""               http… 0fc96747-…
#> 4  4597 6a8f… cont… Basi… List all c… rmd-sta… ""               http… 0fc96747-…
#> 5  4596 3f7a… vani… Vani… List all d… rmd-sta… ""               http… 0fc96747-…
#> 6  4595 5687… envi… R an… R and Pyth… rmd-sta… ""               http… 0fc96747-…
#> # … with 6 more variables: owner_username <chr>, owner_first_name <chr>,
#> #   owner_last_name <chr>, tags <list>, created_time <dttm>,
#> #   updated_time <dttm>
```

Since `all_content` is a `tibble()`, you can also manipulate it with
dplyr:

``` r
all_content %>% 
  filter(updated_time >= "2021-01-01") %>% 
  arrange(created_time)
#> # A tibble: 47 x 15
#>       id guid    name    title   description   app_mode content_category url    
#>    <int> <chr>   <chr>   <chr>   <chr>         <chr>    <chr>            <chr>  
#>  1  1890 be63ca… rmd     rmd4    "This rmd is… rmd-sta… ""               https:…
#>  2  3724 b5e57e… team-d… Team-d… ""            static   ""               https:…
#>  3  3979 ca22a1… github… <NA>    "A table pin… static   "pin"            https:…
#>  4  4364 9ffbbd… shiny-… shiny-… ""            shiny    ""               https:…
#>  5  4602 e21598… user-i… user-i… "Results pul… static   "pin"            https:…
#>  6  4603 e7c266… group-… group-… "Results pul… static   "pin"            https:…
#>  7  4630 f12eb8… top-5-… top-5-… ""            python-… ""               https:…
#>  8  4631 68c9b2… top-5-… top-5-… ""            python-… ""               https:…
#>  9  4650 ebdea3… reticu… reticu… ""            static   ""               https:…
#> 10  4651 321bba… rsc_sp… RSC: S… ""            static   ""               https:…
#> # … with 37 more rows, and 7 more variables: owner_guid <chr>,
#> #   owner_username <chr>, owner_first_name <chr>, owner_last_name <chr>,
#> #   tags <list>, created_time <dttm>, updated_time <dttm>
```

### Components

Once your content data are filtered, `rscpages` provides components for
displaying information about them. The title, description, and preview
image can be set [from the RStudio Connect
dashboard.](https://docs.rstudio.com/connect/user/content-settings/#content-metadata)
For content deployed to Connect where no image has been supplied, a
default image will be used.

*Note:* In many cases, you will only see default images until your
content is deployed.

#### card

Use a card to highlight an individual piece of content:

![a sample card](man/figures/README-card-1.png)

#### grid

Display multiple content items via a grid:

![a sample grid](man/figures/README-grid-1.png)

#### table

Provide a more detailed view with table:

![a sample table](man/figures/README-table-1.png)

#### search & filter

The search and filter components help viewers find the content they are
most interested in. You must pass the same content data frame to
`rscsearch()`, `rscfilter()`, and `rsctable()` or `rscgrid()` in order
for filter and search to work. You can also create your own
`crosstalk::SharedData()` object to pass to the components if you want
more control over searching and filtering. Read more at
`vignette("using-crosstalk")`.

![search and filter widgets](man/figures/README-search-filter-2.png)

Once you’re happy with the look of your page, Publish it to RStudio
Connect. Read more at `vignette("publishing")`.
