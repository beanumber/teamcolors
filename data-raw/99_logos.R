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
  "http://www.sportslogos.net/teams/list_by_league/30/NCAA_Division_I_a-c/NCAA_a-c/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/31/NCAA_Division_I_d-h/NCAA_d-h/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/32/NCAA_Division_I_i-m/NCAA_i-m/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/33/NCAA_Division_I_n-r/NCAA_n-r/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/34/NCAA_Division_I_s-t/NCAA_s-t/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/35/NCAA_Division_I_u-z/NCAA_u-z/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/202/National_Womens_Soccer_League/NWSL/logos/", "//*[@id='team']",
  "http://www.sportslogos.net/teams/list_by_league/16/Womens_National_Basketball_Association/WNBA/logos/", "//*[@id='team']",  
  "http://www.sportslogos.net/teams/list_by_league/8/Canadian_Football_League/CFL/logos/", "//*[@id='team']",
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
         team = ifelse(team == "Seattle Reign FC", "Reign FC", team),
         team = ifelse(team == " Athletics", "Athletics", team))



## Renaming ncaa team color names, so that they match up with the join
## Created a tribble, in order to join the names later with the existing teamcolors dataset

unmatched_team_names <- tibble::tribble(
  ~name, ~sportslogos_name,
  "Air Force", "Air Force Falcons", 
  "Albany (NY)", "Albany Great Danes",
  "Bowling Green", "Bowling Green Falcons",
  "Buffalo", "Buffalo Bulls",
  "BYU", "Brigham Young Cougars",
  "Cal Poly", "Cal Poly Mustangs",
  "Cal State Fullerton", "Cal State Fullerton Titans",
  "California", "California Golden Bears",
  "Canisius", "Canisius Golden Griffins",
  "Charlotte", "Charlotte 49ers",
  "Colorado", "Colorado Buffaloes",
  "CSU Bakersfield", "CSU Bakersfield Roadrunners",
  "CSUN", "Cal State Northridge Matadors",
  "Dartmouth", "Dartmouth Big Green",
  "Davidson", "Davidson Wildcats",
  "Detroit Mercy Titans", "Detroit Titans",
  "FGCU", "Florida Gulf Coast Eagles",
  "FIU", "FIU Panthers",
  "Fresno State", "Fresno State Bulldogs",
  "Georgia Tech", "Georgia Tech Yellow Jackets",
  "Green Bay", "Wisconsin-Green Bay Phoenix",
  "Hawaii", "Hawaii Warriors",
  "Illinois", "Illinois Fighting Illini",
  "Iona", "Iona Gaels",
  "IUPUI", "IUPUI Jaguars",
  "Little Rock", "Little Rock Trojans",
  "LMU (CA)", "Loyola Marymount Lions",
  "Long Beach State", "Long Beach State 49ers",
  "Louisiana", "Louisiana Ragin Cajuns",
  "Louisiana-Monroe", "Louisiana-Monroe Warhawks",
  "Loyola Chicago Ramblers", "Loyola Ramblers",
  "LSU", "LSU Tigers",
  "Manhattan", "Manhattan Jaspers",
  "Marist", "Marist Red Foxes",
  "Maryland", "Maryland Terrapins",
  "Massachusetts", "Massachusetts Minutemen",
  "Miami (FL)", "Miami Hurricanes",
  "Miami (OH)", "Miami (Ohio) Redhawks",
  "Middle Tennessee", "Middle Tennessee Blue Raiders",
  "Milwaukee", "Wisconsin-Milwaukee Panthers",
  "Navy", "Navy Midshipmen",
  "NC State", "North Carolina State Wolfpack",
  "Nebraska", "Nebraska Cornhuskers",
  "Nevada", "Nevada Wolf Pack",
  "NJIT", "NJIT Highlanders",
  "North Alabama", "North Alabama Lions",
  "North Carolina","North Carolina Tar Heels",
  "North Florida Ospreys", "UNF Ospreys",
  "Ohio State", "Ohio State Buckeyes",
  "Oklahoma State", "Oklahoma State Cowboys",
  "Ole Miss", "Mississippi Rebels",
  "Omaha", "Nebraska-Omaha Mavericks",
  "Pacific", "Pacific Tigers",
  "Penn", "Penn Quakers",
  "Penn State", "Penn State Nittany Lions",
  "Providence", "Providence Friars",
  "Sacramento State", "Sacramento State Hornets",
  "Saint Joseph's Hawks", "St. Joseph's Hawks",
  "Saint Mary's (CA)", "Saint Marys Gaels",
  "SaintBonaventure", "St. Bonaventure Bonnies",
  "SaintJohn's (NY)", "St. John's Red Storm",
  "Seattle U", "Seattle Redhawks",
  "Siena", "Siena Saints",
  "Southern California Trojans", "Southern California Trojans",
  "Southern Illinois", "Southern Illinois Salukis",
  "Southern Mississippi Golden Eagles", "Southern Miss Golden Eagles",
  "TCU", "TCU Horned Frogs",
  "Texas", "Texas Longhorns",
  "UAB", "UAB Blazers",
  "UC Davis", "California Davis Aggies",
  "UC Irvine", "California-Irvine Anteaters",
  "UC Riverside", "California Riverside Highlanders",
  "UCLA", "UCLA Bruins",
  "UIC", "Illinois-Chicago Flames",
  "UMass Lowell", "UMass Lowell River Hawks",
  "UMBC", "UMBC Retrievers",
  "UMKC", "UMKC Kangaroos",
  "UNI", "Northern Iowa Panthers",
  "UNLV", "UNLV Rebels",
  "USC Upstate", "USC Upstate Spartans",
  "UT Arlington", "Texas-Arlington Mavericks",
  "UTEP", "UTEP Miners",
  "UTRGV", "UTRGV Vaqueros",
  "UTSA", "Texas-SA Roadrunners",
  "VCU", "Virginia Commonwealth Rams",
  "Wisconsin", "Wisconsin Badgers"
)


# joining teamcolors with the unmatched team names dataset, in order to get the names to match up

teamcolors <- teamcolors %>%
  left_join(unmatched_team_names, by = "name") %>%
  mutate(sportslogos_name = ifelse(is.na(sportslogos_name), name, sportslogos_name))


# add logos
teamcolors <- teamcolors %>%
  left_join(select(logos, sportslogos_name = team, logo = img), by = "sportslogos_name")

teamcolors %>%
  group_by(league) %>%
  summarize(num_teams = n(), num_logos = sum(!is.na(logo)))



# saving teamcolors to the data file
usethis::use_data(teamcolors, overwrite = TRUE)

