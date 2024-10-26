library(fs)
library(purrr)
library(rvest)
library(xml2)


remove_ahnang <- function(filename) {
  html_file <- read_html(filename)

  # remove Anhang (appears in the German version as an extra text in the Content)
  extra_nodes <-
    html_file |>
    html_nodes(xpath = "//li[@class='sidebar-item sidebar-item-section' and contains(., 'Anhang')]")
  xml_remove(extra_nodes)


  # add language-selector class to the drop down
  language_btn <-
    html_file |>
    html_nodes(xpath = '//*[@id="languages-button"]')
  xml_attr(language_btn, "class") <- paste(c(xml_attr(language_btn, "class"), "language-selector"), collapse = " ")

  write_html(html_file, filename)
}

babelquarto::render_book()
purrr::walk(fs::dir_ls("_book/de", glob = "*de.html"), ~remove_ahnang(.))
purrr::walk(fs::dir_ls("_book/", glob = "*.html"), ~remove_ahnang(.))

