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
  "http://www.sportslogos.net/teams/list_by_league/35/NCAA_Division_I_u-z/NCAA_u-z/logos/", "//*[@id='team']"
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



## Renaming ncaa team color names, so that they match up with the join
## This is not the best way to do this, but it was important to keep the mascots in the team names

## Old name from teamcolors dataset                                      <- New name to match logos dataset

teamcolors$name[teamcolors$name == "Air Force"]                          <- "Air Force Falcons"
teamcolors$name[teamcolors$name == "Albany (NY)"]                        <- "Albany Great Danes"
teamcolors$name[teamcolors$name == "Bowling Green"]                      <- "Bowling Green Falcons"
teamcolors$name[teamcolors$name == "Buffalo"]                            <- "Buffalo Bulls"
teamcolors$name[teamcolors$name == "BYU"]                                <- "Brigham Young Cougars"
teamcolors$name[teamcolors$name == "Cal Poly"]                           <- "Cal Poly Mustangs"
teamcolors$name[teamcolors$name == "Cal State Fullerton"]                <- "Cal State Fullerton Titans"
teamcolors$name[teamcolors$name == "California"]                         <- "California Golden Bears"
teamcolors$name[teamcolors$name == "Canisius"]                           <- "Canisius Golden Griffins"
teamcolors$name[teamcolors$name == "Charlotte"]                          <- "Charlotte 49ers"
teamcolors$name[teamcolors$name == "Colorado"]                           <- "Colorado Buffaloes"
teamcolors$name[teamcolors$name == "CSU Bakersfield"]                    <- "CSU Bakersfield Roadrunners"
teamcolors$name[teamcolors$name == "CSUN"]                               <- "Cal State Northridge Matadors"
teamcolors$name[teamcolors$name == "Dartmouth"]                          <- "Dartmouth Big Green"
teamcolors$name[teamcolors$name == "Davidson"]                           <- "Davidson Wildcats"
teamcolors$name[teamcolors$name == "Detroit Mercy Titans"]               <- "Detroit Titans"
teamcolors$name[teamcolors$name == "FGCU"]                               <- "Florida Gulf Coast Eagles"
teamcolors$name[teamcolors$name == "FIU"]                                <- "FIU Panthers"
teamcolors$name[teamcolors$name == "Fresno State"]                       <- "Fresno State Bulldogs"
teamcolors$name[teamcolors$name == "Georgia Tech"]                       <- "Georgia Tech Yellow Jackets"
teamcolors$name[teamcolors$name == "Green Bay"]                          <- "Wisconsin-Green Bay Phoenix"
teamcolors$name[teamcolors$name == "Hawaii"]                             <- "Hawaii Warriors"
teamcolors$name[teamcolors$name == "Illinois"]                           <- "Illinois Fighting Illini"
teamcolors$name[teamcolors$name == "Iona"]                               <- "Iona Gaels"
teamcolors$name[teamcolors$name == "IUPUI"]                              <- "IUPUI Jaguars"
teamcolors$name[teamcolors$name == "Little Rock"]                        <- "Little Rock Trojans"
teamcolors$name[teamcolors$name == "LMU (CA)"]                           <- "Loyola Marymount Lions"
teamcolors$name[teamcolors$name == "Long Beach State"]                   <- "Long Beach State 49ers"
teamcolors$name[teamcolors$name == "Louisiana"]                          <- "Louisiana Ragin Cajuns"
teamcolors$name[teamcolors$name == "Louisiana-Monroe"]                   <- "Louisiana-Monroe Warhawks"
teamcolors$name[teamcolors$name == "Loyola Chicago Ramblers"]            <- "Loyola Ramblers"
teamcolors$name[teamcolors$name == "LSU"]                                <- "LSU Tigers"
teamcolors$name[teamcolors$name == "Manhattan"]                          <- "Manhattan Jaspers"
teamcolors$name[teamcolors$name == "Marist"]                             <- "Marist Red Foxes"
teamcolors$name[teamcolors$name == "Maryland"]                           <- "Maryland Terrapins"
teamcolors$name[teamcolors$name == "Massachusetts"]                      <- "Massachusetts Minutemen"
teamcolors$name[teamcolors$name == "Miami (FL)"]                         <- "Miami Hurricanes"
teamcolors$name[teamcolors$name == "Miami (OH)"]                         <- "Miami (Ohio) Redhawks"
teamcolors$name[teamcolors$name == "Middle Tennessee"]                   <- "Middle Tennessee Blue Raiders"
teamcolors$name[teamcolors$name == "Milwaukee"]                          <- "Wisconsin-Milwaukee Panthers"
teamcolors$name[teamcolors$name == "Navy"]                               <- "Navy Midshipmen"
teamcolors$name[teamcolors$name == "NC State"]                           <- "North Carolina State Wolfpack"
teamcolors$name[teamcolors$name == "Nebraska"]                           <- "Nebraska Cornhuskers"
teamcolors$name[teamcolors$name == "Nevada"]                             <- "Nevada Wolf Pack"
teamcolors$name[teamcolors$name == "NJIT"]                               <- "NJIT Highlanders"
teamcolors$name[teamcolors$name == "North Alabama"]                      <- "North Alabama Lions"
teamcolors$name[teamcolors$name == "North Carolina"]                     <- "North Carolina Tar Heels"
teamcolors$name[teamcolors$name == "North Florida Ospreys"]              <- "UNF Ospreys"
teamcolors$name[teamcolors$name == "Ohio State"]                         <- "Ohio State Buckeyes"
teamcolors$name[teamcolors$name == "Oklahoma State"]                     <- "Oklahoma State Cowboys"
teamcolors$name[teamcolors$name == "Ole Miss"]                           <- "Mississippi Rebels"
teamcolors$name[teamcolors$name == "Omaha"]                              <- "Nebraska-Omaha Mavericks"
teamcolors$name[teamcolors$name == "Pacific"]                            <- "Pacific Tigers"
teamcolors$name[teamcolors$name == "Penn"]                               <- "Penn Quakers"
teamcolors$name[teamcolors$name == "Penn State"]                         <- "Penn State Nittany Lions"
teamcolors$name[teamcolors$name == "Providence"]                         <- "Providence Friars"
teamcolors$name[teamcolors$name == "Sacramento State"]                   <- "Sacramento State Hornets"
teamcolors$name[teamcolors$name == "Saint Joseph's Hawks"]               <- "St. Joseph's Hawks"
teamcolors$name[teamcolors$name == "Saint Mary's (CA)"]                  <- "Saint Marys Gaels"
teamcolors$name[teamcolors$name == "SaintBonaventure"]                   <- "St. Bonaventure Bonnies"
teamcolors$name[teamcolors$name == "SaintJohn's (NY)"]                   <- "St. John's Red Storm"
teamcolors$name[teamcolors$name == "Seattle U"]                          <- "Seattle Redhawks"
teamcolors$name[teamcolors$name == "Siena"]                              <- "Siena Saints"
teamcolors$name[teamcolors$name == "Southern California Trojans[A 31]"]  <- "Southern California Trojans"
teamcolors$name[teamcolors$name == "Southern Illinois"]                  <- "Southern Illinois Salukis"
teamcolors$name[teamcolors$name == "Southern Mississippi Golden Eagles"] <- "Southern Miss Golden Eagles"
teamcolors$name[teamcolors$name == "TCU"]                                <- "TCU Horned Frogs"
teamcolors$name[teamcolors$name == "Texas"]                              <- "Texas Longhorns"
teamcolors$name[teamcolors$name == "UAB"]                                <- "UAB Blazers"
teamcolors$name[teamcolors$name == "UC Davis"]                           <- "California Davis Aggies"
teamcolors$name[teamcolors$name == "UC Irvine"]                          <- "California-Irvine Anteaters"
teamcolors$name[teamcolors$name == "UC Riverside"]                       <- "California Riverside Highlanders"
teamcolors$name[teamcolors$name == "UCLA"]                               <- "UCLA Bruins"
teamcolors$name[teamcolors$name == "UIC"]                                <- "Illinois-Chicago Flames"
teamcolors$name[teamcolors$name == "UMass Lowell"]                       <- "UMass Lowell River Hawks"
teamcolors$name[teamcolors$name == "UMBC"]                               <- "UMBC Retrievers"
teamcolors$name[teamcolors$name == "UMKC"]                               <- "UMKC Kangaroos"
teamcolors$name[teamcolors$name == "UNI"]                                <- "Northern Iowa Panthers"
teamcolors$name[teamcolors$name == "UNLV"]                               <- "UNLV Rebels"
teamcolors$name[teamcolors$name == "USC Upstate"]                        <- "USC Upstate Spartans"
teamcolors$name[teamcolors$name == "UT Arlington"]                       <- "Texas-Arlington Mavericks"
teamcolors$name[teamcolors$name == "UTEP"]                               <- "UTEP Miners"
teamcolors$name[teamcolors$name == "UTRGV"]                              <- "UTRGV Vaqueros"
teamcolors$name[teamcolors$name == "UTSA"]                               <- "Texas-SA Roadrunners"
teamcolors$name[teamcolors$name == "VCU"]                                <- "Virginia Commonwealth Rams"
teamcolors$name[teamcolors$name == "Wisconsin"]                          <- "Wisconsin Badgers"



# add logos
teamcolors <- teamcolors %>%
  select(-logo) %>%
  left_join(select(logos, name = team, logo = img), by = "name")


teamcolors %>%
  group_by(league) %>%
  summarize(num_teams = n(), num_logos = sum(!is.na(logo)))

save(teamcolors, file = "data/teamcolors.rda", compress = "xz")













