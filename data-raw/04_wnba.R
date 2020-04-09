###Code to add WNBA colors and logos
###colors from https://teamcolorcodes.com/category/wnba-team-color-codes/
###logos from http://www.sportslogos.net/teams/list_by_league/16/Womens_National_Basketball_Association/WNBA/logos

library(tidyverse)
library(teamcolors)

wnba_colors <- read_csv("data-raw/wnba_colors.csv") %>%
  select(name, league, primary, secondary,tertiary, quaternary, division)

teamcolors <- teamcolors %>%
  bind_rows(wnba_colors) %>%
  arrange(name) %>%
  as_tibble()

usethis::use_data(teamcolors, overwrite = TRUE)
