
library(tidyverse)

## Divisions

library(rvest)
x <- read_html("https://en.wikipedia.org/wiki/National_Basketball_Association") %>%
  html_nodes("table.wikitable") %>%
  purrr::pluck(1) %>%
  html_table(fill = TRUE) %>%
  janitor::clean_names() %>%
  filter(!grepl("Conference", division))

x <- read_html("https://en.wikipedia.org/wiki/Major_League_Baseball") %>%
  html_nodes("table.wikitable") %>%
  magrittr::extract2(1) %>%
  html_table(fill = TRUE) %>%
  filter(!grepl("Conference", Division))

scrape_teams <- function(url) {
  x <- read_html(url) %>%
    html_nodes("table.wikitable") %>%
    purrr::pluck(1) %>%
    html_table(fill = TRUE) %>%
    janitor::clean_names() %>%
    tibble::as_tibble()
  if (!"team" %in% names(x)) {
    x <- rename(x, team = club_66)
  }
  if (!"division" %in% names(x)) {
    x <- rename(x, division = division_66)
  }
  x %>%
    dplyr::select(division, team) %>%
    filter(!grepl("League|Conference|denotes", division))
}

locs <- tibble::tribble(
  ~url, ~xpath,
  "https://en.wikipedia.org/wiki/National_Basketball_Association", "/html/body/div[3]/div[3]/div[4]/div/table[3]", 
  "https://en.wikipedia.org/wiki/Major_League_Baseball", "/html/body/div[3]/div[3]/div[4]/div/table[3]", 
  "https://en.wikipedia.org/wiki/National_Football_League", "/html/body/div[3]/div[3]/div[4]/div/table[3]",
  "https://en.wikipedia.org/wiki/National_Hockey_League", "/html/body/div[3]/div[3]/div[4]/div/table[3]"
)

scrape_teams(locs$url[4])

x <- locs %>%
  mutate(divisions = map(url, scrape_teams))

# add AL/NL
x$divisions[[2]] <- x$divisions[[2]] %>%
  mutate(division = paste(rep(c("AL", "NL"), each = 15), division))

# add NFC/AFC
x$divisions[[3]] <- x$divisions[[3]] %>%
  mutate(division = paste(rep(c("AFC", "NFC"), each = 16), division))

y <- x %>%
  pull(divisions) %>%
  bind_rows() %>%
  mutate(
    team = str_remove_all(team, "\\*"), 
    team = str_remove_all(team, "†"),
    team = str_remove_all(team, "\\[.+\\]")
  )

write_csv(y, here::here("data-csv", "divisions_bigfour.csv"))




