## LOCATIONS AND MASCOTS (by: pep)
## FOR: MLB, NBA, NCAA, NFL, and NHL (NOT: EPL or MLS)

## please run the ncaa_color_update script
## please run the logos.R script
## make sure to load rvest after tidyverse (purr)

library(tidyverse)
library(rvest) 


## Removing epl and mls leagues

teamcolors_without_epl_mls <- teamcolors %>%
  filter(league %in% c("mlb","nba","nfl","nhl","ncaa"))

## this is a function that is called on in the name_location_mascot_function below
## the only thing that this function does is replaces all of the specificed strings to include an underscore
## this allows the main function to seperate the name of the team into location and mascot, using pluck 

nasty_gsub_function <- function(df){
  
  df <- mutate(df,
               
               ## Taking care of the spaces after the first word of a name that has at least two words
               ## Don't use any state news, or it will replace underscores for the spaces of all colleges in that state
               
               name = gsub("^East ", "East_", name),
               name = gsub("^Eastern ", "Eastern_", name),
               name = gsub("^George ", "George_", name),
               name = gsub("^Long ", "Long_", name),
               name = gsub("^Los ", "Los_", name),
               name = gsub("^New ", "New_", name),
               name = gsub("^North ", "North_", name),
               name = gsub("^Northern ", "Northern_", name),
               name = gsub("^San ", "San_", name),
               name = gsub("^St. ", "St._", name),
               name = gsub("^Saint ", "Saint_", name),
               name = gsub("^South ", "South_", name),
               name = gsub("^Southern ", "Southern_", name),
               name = gsub("^West ", "West_", name),
               name = gsub("^Western ", "Western_", name),
               
               # Taking Care of the spaces before the second word of a name that has at least two words
               
               name = gsub(" Bay", "_Bay", name),
               name = gsub(" City", "_City", name),
               name = gsub(" College", "_College", name),
               name = gsub(" Fullerton", "_Fullerton", name),
               name = gsub(" Northridge", "_Northridge", name),
               name = gsub(" State", "_State", name),
               name = gsub(" Tech", "_Tech", name),
               
               # The rest that could'nt be covered with a group of other expressions
               
               name = gsub("Air Force", "Air_Force", name),
               name = gsub("Bowling Green", "Bowling_Green", name), 
               name = gsub("Brigham Young", "Brigham_Young", name),
               name = gsub("Cal Poly", "Cal_Poly", name),
               name = gsub("California Davis", "California_Davis", name),
               name = gsub("California Riverside", "California_Riverside", name),
               name = gsub("Central Michigan", "Central_Michigan", name),
               name = gsub("Coastal Carolina", "Coastal_Carolina", name),
               name = gsub("CSU Bakersfield", "CSU_Bakersfield", name),
               name = gsub("Florida Atlantic", "Florida_Atlantic", name),
               name = gsub("Florida Gulf Coast", "Florida_Gulf_Coast", name),
               name = gsub("Georgia Southern", "Georgia_Southern", name),
               name = gsub("Grand Canyon", "Grand_Canyon", name),
               name = gsub("La Salle", "La_Salle", name),
               name = gsub("Little Rock", "Little_Rock", name),
               name = gsub("Loyola Marymount", "Loyola_Marymount", name),
               name = gsub("Miami (Ohio)", "Miami_(Ohio)", name), 
               name = gsub("Middle Tennessee", "Middle_Tennessee", name),
               name = gsub("Notre Dame", "Notre_Dame", name),
               name = gsub("Old Dominion", "Old_Dominion", name),
               name = gsub("Oral Roberts", "Oral_Roberts", name),
               name = gsub("Purdue Fort Wayne", "Purdue_Fort_Wayne", name),
               name = gsub("Santa Clara", "Santa_Clara", name),
               name = gsub("Seton Hall", "Seton_Hall", name),
               name = gsub("Stony Brook", "Stony_Brook", name),
               name = gsub("Texas A&M", "Texas_A&M", name), 
               name = gsub("UMass Lowell", "UMass_Lowell", name),
               name = gsub("USC Upstate", "USC_Upstate", name),
               name = gsub("Utah Valley", "Utah_Valley", name),
               name = gsub("Virginia Commonwealth", "Virginia_Commonwealth", name),
               name = gsub("Wake Forest", "Wake_Forest", name))
  
  new_gsub_test <<- data.frame(df)
  
  return(df)
  
}


name_location_mascot_function <- function(df){
  
  ## the first assignment sends dataframe to the nasty gsub function, in order to keep this main function clean
  
  df <- nasty_gsub_function(df)
  
  ## the next assignment a new column, location_mascots, that splits the name of each team into two elements
  ## first element is the location of team, which doesn't contain any spaces in order to split the name into only two elements
  ## second element is the rest of the words (regardless of the number of spaces) from the name, and contains the mascot
  
  df <- mutate(df, locations_mascots = str_split(name, " ", 2))
  
  ## the next two assignments are pluck from the rvest package, NOT FROM PURR
  ## the first line plucks the first element from the location_mascot list, which contains the location of the team
  ## the second line plucks the second element from the location_mascot list, which contains the mascot of the team
  
  df <- mutate(df, location = pluck(locations_mascots, 1))
  df <- mutate(df, mascot = pluck(locations_mascots, 2))
  
  ## the next two assignments change the location and mascot from single element lists, back to characters, for readability and consistency
  
  df <- mutate(df, mascot = as.character(mascot))
  df <- mutate(df, location = as.character(location))
  
  ## the next assignment removes the underscores that the nasty gsub function provided, since they are no longer needed
  
  df <- mutate(df, name = gsub("_", " ", name),
               location = gsub("_", " ", location))
  
  ## the next assignment selects only the variables of interest
  ## variables of interest include: the original name provided, the newly created location, and newly created mascot 
  
  df <- select(df, name, location, mascot)
  
  ## the last assignment takes the dataframe within this function and assigns it to a dataframe that exists in the global environment
  ## the name_location_mascot dataframe is what will be used to add the location and mascot to the original teamcolors dataset 
  
  name_location_mascot <<- data.frame(df)
  
}

name_location_mascot_function(teamcolors_without_epl_mls)


## this full join adds the locations and mascots to the teamcolors dataset and reorganizes the columns

teamcolors_updated <- teamcolors %>%
  full_join(name_location_mascot, by = "name") %>%
  select("name", "league", "division", "location", "mascot", 
         "primary", "secondary", "tertiary", "quaternary", "logo")


## this saves the newly added columns to a new file
## didn't want to write over the original

save(teamcolors_updated, file = "data/teamcolors_updated.rda", compress = "xz")

## attempt to run R CMD check
