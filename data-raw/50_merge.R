###Code to add WNBA colors and logos
###colors from https://teamcolorcodes.com/category/wnba-team-color-codes/
###logos from http://www.sportslogos.net/teams/list_by_league/16/Womens_National_Basketball_Association/WNBA/logos

library(tidyverse)

teamcolors <- read_csv(here::here("data-csv", "teamcolors_bigfour.csv"))

divisions_bigfour <- read_csv(here::here("data-csv", "divisions_bigfour.csv"))

teamcolors <- teamcolors %>%
  left_join(
    select(divisions_bigfour, division, team), 
    by = c("name" = "team")
  )

# Manual MLS Division hack
teamcolors <- teamcolors %>%
  mutate(
    division = ifelse(name %in% c('Atlanta United FC', 'Chicago Fire', 'Columbus Crew', 'DC United', 'Montreal Impact', 'New England Revolution', 'New York City FC', 'New York Red Bulls', 'Orlando City SC', 'Philadelphia Union', 'Toronto FC'), "Eastern Conference", division),
    division = ifelse(name %in% c('Colorado Rapids', 'FC Dallas', 'Houston Dynamo', 'LA Galaxy', 'Los Angeles FC', 'Minnesota United FC', 'Portland Timbers', 'Real Salt Lake', 'San Jose Earthquakes', 'Seattle Sounders FC', 'Sporting Kansas City', 'Vancouver Whitecaps FC'), "Western Conference", division)
  )

## WNBA

teamcolors_wnba <- read_csv("data-csv/teamcolors_wnba.csv") %>%
  select(name, league, primary, secondary,tertiary, quaternary, division)

teamcolors_nwsl <- read_csv(here::here("data-csv", "teamcolors_nwsl.csv"))

teamcolors <- teamcolors %>%
  bind_rows(
    teamcolors_wnba, 
    teamcolors_nwsl
  ) %>%
  arrange(name) %>%
  as_tibble()

## NCAA

teamcolors_ncaa <- read_csv(here::here("data-csv", "teamcolors_ncaa.csv"))

teamcolors <- teamcolors %>%
  filter(league != "ncaa") %>%
  bind_rows(teamcolors_ncaa) %>%
  arrange(name) %>%
  as_tibble()




usethis::use_data(teamcolors, overwrite = TRUE)
