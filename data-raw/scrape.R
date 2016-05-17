# get colors from teamcolors
# 

library(dplyr)

lgs <- c("mlb", "nba", "nfl", "nhl", "epl", "mls")

get_colors <- function(lg) {
  team_list <- paste0("https://raw.githubusercontent.com/teamcolors/teamcolors.github.io/master/src/scripts/data/leagues/", lg, ".json") %>%
    RCurl::getURL() %>%
    RJSONIO::fromJSON()
#  hex_from_list(team_list[[2]])
  out <- team_list %>%
    lapply(FUN = hex_from_list) %>%
    bind_rows() %>%
    mutate(sport = lg)
  return(out)
}

hex_from_list <- function(x) {
  out <- data.frame(name = as.character(x$name))
  if ("hex" %in% names(x$colors)) {
    hex <- x$colors$hex
  } else {
    message("No hex colors found...")
    rgb_df <- strsplit(x$colors$rgb, " ") %>%
      do.call(rbind, .) %>%
      as.data.frame()
    hex <- rgb(red = as.character(rgb_df$V1), green = as.character(rgb_df$V2), 
               blue = as.character(rgb_df$V3), maxColorValue = 255)
  }
  hex[!is.na(hex)] <- gsub("##", "#", paste0("#", hex))
  out$primary <- hex[1]
  out$secondary <- hex[2]
  out$tertiary <- hex[3]
  out$quaternary <- hex[4]
  return(out)
}

# get_colors("mlb")
# get_colors("nhl")
# get_colors("nfl")
# get_colors("nba")

teamcolors <- lapply(lgs, get_colors) %>%
  bind_rows()

# manual fixes
# Tigers
teamcolors <- teamcolors %>%
  mutate(secondary = ifelse(name == "Detroit Tigers", "#FF6600", secondary))

save(teamcolors, file = "data/teamcolors.rda", compress = "xz")



