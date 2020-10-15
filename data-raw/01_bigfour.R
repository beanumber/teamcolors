# get colors from teamcolors
# 

library(tidyverse)

df <- "https://raw.githubusercontent.com/jimniels/teamcolors/master/src/teams.json" %>%
  RCurl::getURL() %>%
  jsonlite::fromJSON(flatten = TRUE) %>%
  as_tibble() %>%
  mutate(
    colors.hex = ifelse(colors.hex == "NULL", NA, colors.hex), 
    colors.rgb = ifelse(colors.rgb == "NULL", NA, colors.rgb)
  )

rgb_to_hex <- function(x) {
  rgb_df <- str_split(x, " ") %>%
    do.call(rbind, .) %>%
    as.data.frame()
  rgb(red = as.character(rgb_df$V1), green = as.character(rgb_df$V2), 
      blue = as.character(rgb_df$V3), maxColorValue = 255)
}
rgb_to_hex(NA)

hex <- df %>%
  filter(!is.na(colors.hex)) %>%
  unnest(cols = colors.hex) %>%
  mutate(color_hex = paste0("#", colors.hex)) %>%
  select(name, league, color_hex)

rgb <- df %>%
  filter(!is.na(colors.rgb)) %>%
  unnest(cols = colors.rgb) %>%
  mutate(color_hex = rgb_to_hex(colors.rgb)) %>%
  select(name, league, color_hex)
  



team_colors <- hex %>%
  bind_rows(rgb) %>%
  mutate(color_hex = tolower(color_hex)) %>%
  distinct()

team_colors %>%
  group_by(name) %>%
  count() %>%
  arrange(desc(n))

teamcolors <- team_colors %>%
  group_by(name) %>%
  mutate(rank = row_number()) %>%
  filter(rank <= 4) %>%
  mutate(color_id = case_when(
    rank == 1 ~ "primary",
    rank == 2 ~ "secondary", 
    rank == 3 ~ "tertiary",
    rank == 4 ~ "quaternary"
  )) %>%
  select(-rank) %>%
  pivot_wider(names_from = color_id, values_from = color_hex) %>%
  select(name, league, primary, secondary, tertiary, quaternary)

##### manual fixes:

# Tigers
teamcolors <- teamcolors %>%
  mutate(secondary = ifelse(name == "Detroit Tigers", "#FF6600", secondary))
# Yankees
nyy <- which(teamcolors$name == "New York Yankees")
teamcolors$tertiary[nyy] <- teamcolors$primary[nyy]
teamcolors$primary[nyy] <- teamcolors$secondary[nyy]
teamcolors$secondary[nyy] <- "#FFFFFF"
# Dodgers
lad <- which(teamcolors$name == "Los Angeles Dodgers")
teamcolors$tertiary[lad] <- teamcolors$primary[lad]
teamcolors$primary[lad] <- teamcolors$secondary[lad]
teamcolors$secondary[nyy] <- "#FFFFFF"
# St. Louis
teamcolors <- teamcolors %>%
  ungroup() %>%
  mutate(name = gsub("St L", "St. L", name),
         # Angels
         name = gsub("Angels of Anaheim", "Angels", name))
# NY Jets
# https://teamcolorcodes.com/new-york-jets-color-codes/
teamcolors <- teamcolors %>%
  mutate(
    primary = ifelse(name == "New York Jets", "#125740", primary),
    secondary = ifelse(name == "New York Jets", "#000000", secondary),
    tertiary = ifelse(name == "New York Jets", "#FFFFFF", tertiary)
  )
# Washington Football Team
teamcolors <- teamcolors %>%
  mutate(name = ifelse(name == "Washington Redskins", "Washington Football Team", name))


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
    x <- rename(x, team = club_61)
  }
  if (!"division" %in% names(x)) {
    x <- rename(x, division = division_61)
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

teamcolors <- teamcolors %>%
  left_join(select(y, division, team), by = c("name" = "team"))

# Manual MLS Division hack
teamcolors <- teamcolors %>%
  mutate(
    division = ifelse(name %in% c('Atlanta United FC', 'Chicago Fire', 'Columbus Crew', 'DC United', 'Montreal Impact', 'New England Revolution', 'New York City FC', 'New York Red Bulls', 'Orlando City SC', 'Philadelphia Union', 'Toronto FC'), "Eastern Conference", division),
    division = ifelse(name %in% c('Colorado Rapids', 'FC Dallas', 'Houston Dynamo', 'LA Galaxy', 'Los Angeles FC', 'Minnesota United FC', 'Portland Timbers', 'Real Salt Lake', 'San Jose Earthquakes', 'Seattle Sounders FC', 'Sporting Kansas City', 'Vancouver Whitecaps FC'), "Western Conference", division)
  )

usethis::use_data(teamcolors, overwrite = TRUE)


