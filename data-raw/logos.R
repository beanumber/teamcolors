# Logos

library(tidyverse)
library(rvest)
library(usethis)

leagues <- tribble(
  ~url, ~xpath, 
  "http://www.sportslogos.net/teams/list_by_league/54/National_League/NL/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/53/National_League/AL/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/1/National_Hockey_League/NHL/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/7/National_Football_League/NFL/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/6/National_Basketball_Association/NBA/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/9/Major_League_Soccer/MLS/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/30/NCAA_Division_I_a-c/NCAA_a-c/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/31/NCAA_Division_I_d-h/NCAA_d-h/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/32/NCAA_Division_I_i-m/NCAA_i-m/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/33/NCAA_Division_I_n-r/NCAA_n-r/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/34/NCAA_Division_I_s-t/NCAA_s-t/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/35/NCAA_Division_I_u-z/NCAA_u-z/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/202/National_Womens_Soccer_League/NWSL/logos/", "//*[@id='team']"
)


scrape_logos <- function(url, xpath) {
  
  div <- read_html(url) %>%
    html_nodes(xpath = xpath) 
  
  img <- div %>%
    html_nodes("img") %>%
    html_attr("src")
  
  team <- div %>%
    html_nodes("a") %>%
    html_attr("title") %>%
    gsub(" Logos", "", .) %>%
    na.omit()
  
  tibble::tibble(team, img)
}

logos <- leagues %>%
  mutate(logos = map2(url, xpath, scrape_logos)) %>%
  unnest() %>%
  mutate(team = gsub("  ", " ", team),
         team = ifelse(team == "D.C. United", "DC United", team), 
         team = ifelse(team == "Columbus Crew SC", "Columbus Crew", team),
         team  = ifelse(team == "Seattle Reign FC", "Reign FC", team))




# add logos
teamcolors <- teamcolors %>%
  select(-logo) %>%
  left_join(select(logos, name = team, logo = img), by = "name")


teamcolors %>%
  group_by(league) %>%
  summarize(num_teams = n(), num_logos = sum(!is.na(logo)))

use_data(teamcolors, internal = FALSE, compress = "xz", overwrite = TRUE)
