## LOCATIONS AND MASCOTS (by: pep)
## for: MLB, NBA, NCAA, NFL, and NHL (NOT: EPL or MLS)

## please run the ncaa_color_update script
## please run the logos.R script
## make sure to load rvest after tidyverse (purr)
library(tidyverse)
library(readr)
library(rvest) 


## Removing epl and mls leagues

teamcolors_without_epl_mls <- teamcolors %>%
  filter(league == "mlb" | league == "nba" |
           league == "nfl" | league == "nhl" |
           league == "ncaa")

## removing the weird X1 from the datasets
teamcolors_without_epl_mls <- teamcolors_without_epl_mls %>%
  select(-X1)


## this is a function that is called on in the name_location_mascot_function below
## the only thing that this function does is replaces all of the specificed strings to include an underscore
## this allows the main function to seperate the name of the team into location and mascot, using pluck 

nasty_gsub_function <- function(df){
  
  df <- mutate(df,    ## mlb, nfl, nba, nhl
               
               name = gsub("Golden State", "Golden_State", name),
               name = gsub("Green Bay", "Green_Bay", name),
               name = gsub("Kansas City", "Kansas_City", name),
               name = gsub("Los Angeles", "Los_Angeles", name),
               name = gsub("New England", "New_England", name),
               name = gsub("New Jersey", "New_Jersey", name),
               name = gsub("New Orleans", "New_Orleans", name),
               name = gsub("New York", "New_York", name),
               name = gsub("Oklahoma City", "Oklahoma_City", name),
               name = gsub("San Antonio", "San_Antonio", name),
               name = gsub("San Diego", "San_Diego", name),
               name = gsub("San Francisco", "San_Francisco", name),
               name = gsub("San Jose", "San_Jose", name),
               name = gsub("St. Louis", "St._Louis", name),
               name = gsub("Tampa Bay", "Tampa_Bay", name),
               
               ## ncaa (nasty part)
               
               name = gsub("Air Force", "Air_Force", name), 
               name = gsub("Appalachian State", "Appalachian_State", name),
               name = gsub("Arkansas State", "Arkansas_State", name),
               name = gsub("Arizona State", "Arizona_State", name),
               name = gsub("Ball State", "Ball_State", name),
               name = gsub("Boise State", "Boise_State", name),
               name = gsub("Boston College", "Boston_College", name),
               name = gsub("Bowling Green", "Bowling_Green", name), 
               name = gsub("Brigham Young", "Brigham_Young", name),
               name = gsub("Cal Poly", "Cal_Poly", name),
               name = gsub("Cal State Fullerton", "Cal_State_Fullerton", name),
               name = gsub("Central Michigan", "Central_Michigan", name),
               name = gsub("Chicago State", "Chicago_State", name),
               name = gsub("Cleveland State", "Cleveland_State", name), 
               name = gsub("Coastal Carolina", "Coastal_Carolina", name),
               name = gsub("Colorado State", "Colorado_State", name),
               name = gsub("CSU Bakersfield", "CSU_Bakersfield", name),
               name = gsub("Cal State Northridge", "Cal_State_Northridge", name),
               name = gsub("East Carolina", "East_Carolina", name),
               name = gsub("Eastern Michigan", "Eastern_Michigan", name), 
               name = gsub("Eastern Washington", "Eastern_Washington", name),
               name = gsub("Florida Gulf Coast", "Florida_Gulf_Coast", name),
               name = gsub("Florida Atlantic", "Florida_Atlantic", name),
               name = gsub("Florida State", "Florida_State", name),
               name = gsub("Fresno State", "Fresno_State", name),
               name = gsub("George Mason", "George_Mason", name),
               name = gsub("George Washington", "George_Washington", name), 
               name = gsub("Georgia Southern", "Georgia_Southern", name),
               name = gsub("Georgia State", "Georgia_State", name),
               name = gsub("Georgia Tech", "Georgia_Tech", name),
               name = gsub("Grand Canyon", "Grand_Canyon", name),
               name = gsub("Wisconsin-Green Bay", "Wisconsin-Green_Bay", name),
               name = gsub("Idaho State", "Idaho_State", name), 
               name = gsub("Illinois State", "Illinois_State", name),
               name = gsub("Indiana State", "Indiana_State", name),
               name = gsub("Iowa State", "Iowa_State", name),
               name = gsub("Jacksonville State", "Jacksonville_State", name),
               name = gsub("Kansas State", "Kansas_State", name),
               name = gsub("Kennesaw State", "Kennesaw_State", name), 
               name = gsub("Kent State", "Kent_State", name),
               name = gsub("La Salle", "La_Salle", name),
               name = gsub("Little Rock", "Little_Rock", name),
               name = gsub("Loyola Marymount", "Loyola_Marymount", name),
               name = gsub("Long Beach State", "Long_Beach_State", name),
               name = gsub("Louisiana Tech", "Louisiana_Tech", name),
               name = gsub("Miami (Ohio)", "Miami_(Ohio)", name), 
               name = gsub("Michigan State", "Michigan_State", name),
               name = gsub("Middle Tennessee", "Middle_Tennessee", name),
               name = gsub("Mississippi State", "Mississippi_State", name),
               name = gsub("Missouri State", "Missouri_State", name),
               name = gsub("Montana State", "Montana_State", name),
               name = gsub("North Carolina State", "North_Carolina_State", name),
               name = gsub("New Hampshire", "New_Hampshire", name),
               name = gsub("New Mexico State", "New_Mexico_State", name),
               name = gsub("New Mexico", "New_Mexico", name),
               name = gsub("North Alabama", "North_Alabama", name),
               name = gsub("North Carolina", "North_Carolina", name),
               name = gsub("North Dakota State", "North_Dakota_State", name),
               name = gsub("North Texas", "North_Texas", name), 
               name = gsub("Northern Arizona", "Northern_Arizona", name),
               name = gsub("Northern Colorado", "Northern_Colorado", name),
               name = gsub("Northern Illinois", "Northern_Illinois", name),
               name = gsub("Northern Kentucky", "Northern_Kentucky", name),
               name = gsub("Notre Dame", "Notre_Dame", name),
               name = gsub("Ohio State", "Ohio_State", name), 
               name = gsub("Oklahoma State", "Oklahoma_State", name),
               name = gsub("Old Dominion", "Old_Dominion", name),
               name = gsub("Oral Roberts", "Oral_Roberts", name),
               name = gsub("Oregon State", "Oregon_State", name),
               name = gsub("Penn State", "Penn_State", name),
               name = gsub("Portland State", "Portland_State", name), 
               name = gsub("Purdue Fort Wayne", "Purdue_Fort_Wayne", name),
               name = gsub("Rhode Island", "Rhode_Island", name),
               name = gsub("Sacramento State", "Sacramento_State", name),
               name = gsub("St. Joseph's", "St._Joseph's", name),
               name = gsub("Saint Louis", "Saint_Louis", name),
               name = gsub("Saint Marys", "Saint_Marys", name), 
               name = gsub("Saint Peter's", "Saint_Peter's", name),
               name = gsub("St. Bonaventure", "St._Bonaventure", name),
               name = gsub("St. John's", "St._John's", name),
               name = gsub("San Diego State", "San_Diego_State", name),
               name = gsub("San Diego", "San_Diego", name),
               name = gsub("San Francisco", "San_Francisco", name),
               name = gsub("San Jose State", "San_Jose_State", name), 
               name = gsub("Santa Clara", "Santa_Clara", name),
               name = gsub("Seton Hall", "Seton_Hall", name),
               name = gsub("South Alabama", "South_Alabama", name),
               name = gsub("South Carolina", "South_Carolina", name),
               name = gsub("South Dakota State", "South_Dakota_State", name),
               name = gsub("South Dakota", "South_Dakota", name),
               name = gsub("South Florida", "South_Florida", name), 
               name = gsub("Southern California", "Southern_California", name),
               name = gsub("Southern Illinois", "Southern_Illinois", name),
               name = gsub("Southern Miss", "Southern_Miss", name),
               name = gsub("Southern Utah", "Southern_Utah", name),
               name = gsub("Stony Brook", "Stony_Brook", name),
               name = gsub("Texas A&M", "Texas_A&M", name), 
               name = gsub("Texas State", "Texas_State", name),
               name = gsub("Texas Tech", "Texas_Tech", name),
               name = gsub("California Davis", "California_Davis", name),
               name = gsub("California Riverside", "California_Riverside", name),
               name = gsub("UMass Lowell", "UMass_Lowell", name),
               name = gsub("Northern Iowa", "Northern_Iowa", name), 
               name = gsub("USC Upstate", "USC_Upstate", name),
               name = gsub("Utah State", "Utah_State", name),
               name = gsub("Utah Valley", "Utah_Valley", name),
               name = gsub("Virginia Commonwealth", "Virginia_Commonwealth", name),
               name = gsub("Virginia Tech", "Virginia_Tech", name),
               name = gsub("Wake Forest", "Wake_Forest", name), 
               name = gsub("Washington State", "Washington_State", name),
               name = gsub("Weber State", "Weber_State", name),
               name = gsub("West Virginia", "West_Virginia", name),
               name = gsub("Western Illinois", "Western_Illinois", name),
               name = gsub("Western Kentucky", "Western_Kentucky", name),
               name = gsub("Western Michigan", "Western_Michigan", name), 
               name = gsub("Wichita State", "Wichita_State", name),
               name = gsub("Wright State", "Wright_State", name),
               name = gsub("Youngstown State", "Youngstown_State", name))
  
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
