# Logos

library(tidyverse)
library(rvest)

leagues <- tribble(
  ~url, ~xpath, 
  "http://www.sportslogos.net/teams/list_by_league/54/National_League/NL/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/53/National_League/AL/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/1/National_Hockey_League/NHL/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/7/National_Football_League/NFL/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/6/National_Basketball_Association/NBA/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/9/Major_League_Soccer/MLS/logos/", "//*[@id='team']",
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
         team = ifelse(team == "Columbus Crew SC", "Columbus Crew", team))

save(logos, file = "data/logos.rda", compress = "xz")
            