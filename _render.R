library(fs)
library(purrr)
library(rvest)
library(xml2)


remove_anhang <- function(filename) {
  html_file <- read_html(filename)

  extra_nodes <-
    html_file |>
    html_nodes(xpath = "//li[@class='sidebar-item sidebar-item-section' and contains(., 'Anhang')]")

  xml_remove(extra_nodes)

  write_html(html_file, filename)
}

babelquarto::render_book()
purrr::walk(fs::dir_ls("_book/de", glob = "*de.html"), ~remove_anhang(.))
