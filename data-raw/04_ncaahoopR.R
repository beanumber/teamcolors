### Code to update teamcolors from the ncaa_colors dataset in ncaahoopR
library(tidyverse)
# remotes::install_github("lbenz730/ncaahoopR")

ncaa_colors <- ncaahoopR::ncaa_colors %>%
  mutate(
    league = "ncaa",
    name = gsub(" St\\.", " State", ncaa_name),
    name = gsub("St\\. ", "Saint", name),
    name = gsub("Ariz\\.$", "Arizona", name),
    name = gsub("Ala\\.$", "Alabama", name),
    name = gsub("Colo\\.$", "Colorado", name),
    name = gsub("Ill\\.$", "Illinois", name),
    name = gsub("Fla\\.", "Florida", name),
    name = gsub("Ky\\.$", "Kentucky", name),
    name = gsub("Miss\\.$", "Mississippi", name),
    name = gsub("Mich\\.$", "Michigan", name),
    name = gsub("Wash\\.$", "Washington", name),
    name = gsub("Caro\\.$", "Carolina", name),
    name = gsub("Ga\\.", "Georgia", name),
    name = gsub("La\\.", "Louisiana", name),
    name = gsub("Tenn\\.$", "Tennessee", name)
  ) %>%
  select(name, league,
    primary = primary_color,
    secondary = secondary_color,
    tertiary = tertiary_color,
    quaternary = color_4,
    division = conference
  ) %>%
  as_tibble()

ncaa_colors %>%
  filter(grepl("\\.", name))


# Standardize College Team names
library(rvest)

divI <- read_html("https://en.wikipedia.org/wiki/List_of_NCAA_Division_I_institutions") %>%
  html_nodes("table") %>%
  purrr::pluck(2) %>%
  html_table()

names(divI) <- divI[1, ]

divI <- divI %>%
  slice(-1) |>
  rename(
    School = `School Name`,
    Team = Teams
  ) |>
  mutate(
    name = gsub("\\[[A-Z] [0-9]+\\]$", "", School),
    name = gsub("\\[[a-z]\\]$", "", name),
    name = gsub("University of ", "", name),
    name = gsub(" University", "", name),
    Team = gsub("\\[[A-Z] [0-9]+\\]$", "", Team),
    # in case there are two footnotes!
    Team = gsub("\\[[A-Z] [0-9]+\\]$", "", Team),
    nickname = map_chr(stringr::str_split(Team, " and"), 1)
  )



x <- ncaa_colors %>%
  left_join(select(divI, name, nickname), by = c("name")) %>%
  mutate(name = ifelse(is.na(nickname), name, paste(name, nickname))) %>%
  select(-nickname)

write_csv(x, here::here("data-csv", "teamcolors_ncaa.csv"))
