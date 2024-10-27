library(dplyr)
library(kableExtra)
library(readxl)
library(stringr)

get_references <- function() {
  # translation strings
  hastag_suffix <- c("English" = "",
                     "German" = "-de")

  book_link_text <- c("English" = "Link within the book",
                      "German" = "Link innerhalb des Buches")

  doc_link_text <- c("English" = "Link to documentation",
                     "German" = "Link zur Dokumentation")


  # figure out language from suffix or its absence (English)
  filename <- fs::path_ext_remove(basename(knitr::current_input()))
  language <- "English"
  if (stringr::str_ends(filename, ".de")) {
    language <- "German"
  }


  # get references and pick the ones relevant for the language
  references <- readxl::read_xlsx("references.xlsx")
  references$Label <- references[[language]]
  references <-
    references |>
    select(Type, Label, Hashtag, URL) |>
    mutate(Hashtag = sprintf("[%s](#%s%s)", book_link_text[language], Hashtag, hastag_suffix[language]),
           URL = ifelse(is.na(URL), "", sprintf("[%s](%s)", doc_link_text[language], URL) ))
}

list_references <- function(references, type, capitilize) {
  references <-
    references |>
    filter(Type == type) |>
    select(-Type) |>
    arrange(tolower(Label))

  if (capitilize) { references$Label <- stringr::str_to_title(references$Label) }
  kable(references, col.names = NULL)
}
