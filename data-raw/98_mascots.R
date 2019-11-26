## LOCATIONS AND MASCOTS (by: pep)
## FOR: MLB, NBA, NCAA, NFL, and NHL (NOT: EPL or MLS)

## please run the ncaa_color_update script
## please run the logos.R script
## make sure to load rvest after tidyverse (purr)

library(tidyverse)
library(rvest)

## this is a function that is called on in the name_location_mascot_function below
## the only thing that this function does is replaces all of the specificed strings to include an underscore
## this allows the main function to seperate the name of the team into location and mascot, using pluck

nasty_gsub_function <- function(x) {
    ## Taking care of the spaces after the first word of a name that has at least two words
    ## Don't use any state news, or it will replace underscores for the spaces of all colleges in that state
  x = gsub("^East ", "East_", x)
  x = gsub("^Eastern ", "Eastern_", x)
  x = gsub("^George ", "George_", x)
  x = gsub("^Long ", "Long_", x)
  x = gsub("^Los ", "Los_", x)
  x = gsub("^New ", "New_", x)
  x = gsub("^North ", "North_", x)
  x = gsub("^Northern ", "Northern_", x)
  x = gsub("^San ", "San_", x)
  x = gsub("^St. ", "St._", x)
  x = gsub("^Saint ", "Saint_", x)
  x = gsub("^South ", "South_", x)
  x = gsub("^Southern ", "Southern_", x)
  x = gsub("^West ", "West_", x)
  x = gsub("^Western ", "Western_", x)
  
  # Taking Care of the spaces before the second word of a name that has at least two words
  x = gsub(" Bay", "_Bay", x)
  x = gsub(" City", "_City", x)
  x = gsub(" College", "_College", x)
  x = gsub(" Fullerton", "_Fullerton", x)
  x = gsub(" Northridge", "_Northridge", x)
  x = gsub(" State", "_State", x)
  x = gsub(" Tech", "_Tech", x)
  
  # The rest that could'nt be covered with a group of other expressions
  x = gsub("Air Force", "Air_Force", x)
  x = gsub("Bowling Green", "Bowling_Green", x)
  x = gsub("Brigham Young", "Brigham_Young", x)
  x = gsub("Cal Poly", "Cal_Poly", x)
  x = gsub("California Davis", "California_Davis", x)
  x = gsub("California Riverside", "California_Riverside", x)
  x = gsub("Central Michigan", "Central_Michigan", x)
  x = gsub("Coastal Carolina", "Coastal_Carolina", x)
  x = gsub("CSU Bakersfield", "CSU_Bakersfield", x)
  x = gsub("Florida Atlantic", "Florida_Atlantic", x)
  x = gsub("Florida Gulf Coast", "Florida_Gulf_Coast", x)
  x = gsub("Georgia Southern", "Georgia_Southern", x)
  x = gsub("Grand Canyon", "Grand_Canyon", x)
  x = gsub("La Salle", "La_Salle", x)
  x = gsub("Little Rock", "Little_Rock", x)
  x = gsub("Loyola Marymount", "Loyola_Marymount", x)
  x = gsub("Miami (Ohio)", "Miami_(Ohio)", x)
  x = gsub("Middle Tennessee", "Middle_Tennessee", x)
  x = gsub("Notre Dame", "Notre_Dame", x)
  x = gsub("Old Dominion", "Old_Dominion", x)
  x = gsub("Oral Roberts", "Oral_Roberts", x)
  x = gsub("Purdue Fort Wayne", "Purdue_Fort_Wayne", x)
  x = gsub("Santa Clara", "Santa_Clara", x)
  x = gsub("Seton Hall", "Seton_Hall", x)
  x = gsub("Stony Brook", "Stony_Brook", x)
  x = gsub("Texas A&M", "Texas_A&M", x)
  x = gsub("UMass Lowell", "UMass_Lowell", x)
  x = gsub("USC Upstate", "USC_Upstate", x)
  x = gsub("Utah Valley", "Utah_Valley", x)
  x = gsub("Virginia Commonwealth", "Virginia_Commonwealth", x)
  x = gsub("Wake Forest", "Wake_Forest", x)

  return(x)
}


name_location_mascot_function <- function(data) {
  data %>%
    mutate(
      tmp_name = nasty_gsub_function(name), 
      tmp_parts = str_split(tmp_name, " ", 2),
      location = map_chr(tmp_parts, 1),
      mascot = map_chr(tmp_parts, 2, .default = NA),
      location = gsub("_", " ", location)
    ) %>% 
    select(-contains("tmp_"))
}

teamcolors <- name_location_mascot_function(teamcolors)

## this saves the newly added columns to a new file
## didn't want to write over the original

usethis::use_data(teamcolors, overwrite = TRUE)
