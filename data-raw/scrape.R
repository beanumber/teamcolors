# get colors from teamcolors
# 

library(tidyverse)

######## OLD

# lgs <- c("mlb", "nba", "nfl", "nhl", "epl", "mls")
# 
# get_colors <- function(lg) {
#   team_list <- "https://raw.githubusercontent.com/jimniels/teamcolors/master/static/data/teams.json" %>%
#     RCurl::getURL() %>%
#     jsonlite::fromJSON(flatten = TRUE)
# #  hex_from_list(team_list[[2]])
#   out <- team_list %>%
#     lapply(FUN = hex_from_list) %>%
#     bind_rows() %>%
#     mutate(sport = lg)
#   return(out)
# }
# 
# hex_from_list <- function(x) {
#   out <- data.frame(name = as.character(x$name))
#   if ("hex" %in% names(x$colors)) {
#     hex <- x$colors$hex
#   } else {
#     message("No hex colors found...")
#     rgb_df <- strsplit(x$colors$rgb, " ") %>%
#       do.call(rbind, .) %>%
#       as.data.frame()
#     hex <- rgb(red = as.character(rgb_df$V1), green = as.character(rgb_df$V2), 
#                blue = as.character(rgb_df$V3), maxColorValue = 255)
#   }
#   hex[!is.na(hex)] <- gsub("##", "#", paste0("#", hex))
#   out$primary <- hex[1]
#   out$secondary <- hex[2]
#   out$tertiary <- hex[3]
#   out$quaternary <- hex[4]
#   return(out)
# }
# 
# # get_colors("mlb")
# # get_colors("nhl")
# # get_colors("nfl")
# # get_colors("nba")
# 
# teamcolors <- lapply(lgs, get_colors) %>%
#   bind_rows()

###########


### New

df <- "https://raw.githubusercontent.com/jimniels/teamcolors/master/static/data/teams.json" %>%
  RCurl::getURL() %>%
  jsonlite::fromJSON(flatten = TRUE) %>%
  as.tbl() %>%
  mutate(colors.hex = ifelse(colors.hex == "NULL", NA, colors.hex), 
         colors.rgb = ifelse(colors.rgb == "NULL", NA, colors.rgb))

rgb_to_hex <- function(x) {
  rgb_df <- strsplit(x, " ") %>%
    do.call(rbind, .) %>%
    as.data.frame()
  rgb(red = as.character(rgb_df$V1), green = as.character(rgb_df$V2), 
      blue = as.character(rgb_df$V3), maxColorValue = 255)
}
rgb_to_hex(NA)

hex <- df %>%
  filter(!is.na(colors.hex)) %>%
  unnest(color_hex = colors.hex) %>%
  mutate(color_hex = paste0("#", color_hex))

rgb <- df %>%
  filter(!is.na(colors.rgb)) %>%
  unnest(color_rgb = colors.rgb) %>%
  mutate(color_hex = rgb_to_hex(color_rgb))
  



team_colors <- hex %>%
  bind_rows(select(rgb, -color_rgb)) %>%
  mutate(color_hex = tolower(color_hex))
  distinct()

team_colors %>%
  group_by(name) %>%
  count() %>%
  arrange(desc(n))

teamcolors <- team_colors %>%
  group_by(name) %>%
  mutate(rank = row_number()) %>%
  filter(rank <= 4) %>%
  mutate(color_id = case_when(
    rank == 1 ~ "primary",
    rank == 2 ~ "secondary", 
    rank == 3 ~ "tertiary",
    rank == 4 ~ "quaternary"
  )) %>%
  select(-rank) %>%
  spread(key = color_id, value = color_hex) %>%
  select(name, league, primary, secondary, tertiary, quaternary)

##### manual fixes:

# Tigers
teamcolors <- teamcolors %>%
  mutate(secondary = ifelse(name == "Detroit Tigers", "#FF6600", secondary))
# Yankees
nyy <- which(teamcolors$name == "New York Yankees")
teamcolors$tertiary[nyy] <- teamcolors$primary[nyy]
teamcolors$primary[nyy] <- teamcolors$secondary[nyy]
teamcolors$secondary[nyy] <- "#FFFFFF"
# Dodgers
lad <- which(teamcolors$name == "Los Angeles Dodgers")
teamcolors$tertiary[lad] <- teamcolors$primary[lad]
teamcolors$primary[lad] <- teamcolors$secondary[lad]
teamcolors$secondary[nyy] <- "#FFFFFF"
# St. Louis
teamcolors <- teamcolors %>%
  ungroup() %>%
  mutate(name = gsub("St L", "St. L", name))

## Divisions

library(rvest)
library(tibble)
x <- read_html("https://en.wikipedia.org/wiki/National_Basketball_Association") %>%
  html_nodes("table") %>%
  html_nodes(xpath = "/html/body/div[3]/div[3]/div[4]/div/table[4]") %>%
  magrittr::extract2(1) %>%
  html_table(fill = TRUE) %>%
  filter(!grepl("Conference", Division))

x <- read_html("https://en.wikipedia.org/wiki/Major_League_Baseball") %>%
  html_nodes("table") %>%
  html_nodes(xpath = "/html/body/div[3]/div[3]/div[4]/div/table[3]") %>%
  magrittr::extract2(1) %>%
  html_table(fill = TRUE) %>%
  filter(!grepl("Conference", Division))

scrape_teams <- function(data) {
  x <- read_html(data$url) %>%
    html_nodes("table") %>%
    html_nodes(xpath = data$xpath) %>%
    magrittr::extract2(1) %>%
    html_table(fill = TRUE) %>%
    as.tbl()
  if (!"Team" %in% names(x)) {
    x <- rename(x, Team = `Club[55]`)
  }  
  if (!"Division" %in% names(x)) {
    x <- rename(x, Division = `Division[55]`)
  }
  x %>%
    dplyr::select(Division, Team)
}

locs <- tibble::tribble(
  ~url, ~xpath,
  "https://en.wikipedia.org/wiki/National_Basketball_Association", "/html/body/div[3]/div[3]/div[4]/div/table[4]", 
  "https://en.wikipedia.org/wiki/Major_League_Baseball", "/html/body/div[3]/div[3]/div[4]/div/table[3]", 
  "https://en.wikipedia.org/wiki/National_Football_League", "/html/body/div[3]/div[3]/div[4]/div/table[3]",
  "https://en.wikipedia.org/wiki/National_Hockey_League", "/html/body/div[3]/div[3]/div[4]/div/table[3]"
)

x <- locs %>%
  group_by(url) %>%
  do(scrape_teams(.)) %>%
  bind_rows() %>%
  filter(!grepl("League|Conference|denotes", x = Division)) %>%
  ungroup() %>%
  mutate(Team = gsub("\\*", "", x = Team), 
         Team = gsub("†", "", x = Team), 
         Division = ifelse(grepl("Baseball", url), paste("AL", Division), Division),
         Division = ifelse(grepl("Football", url), paste("AFC", Division), Division))
names(x) <- tolower(names(x))

# manual hacks
x$division[16:30] <- gsub("AL", "NL", x$division[16:30])
x$division[77:92] <- gsub("AFC", "NFC", x$division[77:92])

teamcolors <- teamcolors %>%
  left_join(select(x, division, team), by = c("name" = "team"))

save(teamcolors, file = "data/teamcolors.rda", compress = "xz")



