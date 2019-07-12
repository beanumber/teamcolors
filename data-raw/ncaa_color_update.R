### Code to update teamcolors from the ncaa_colors dataset in ncaahoopR
library(ncaahoopR)
library(teamcolors)
teamcolors <- mutate(ncaa_colors, 
       "league" = "ncaa",
       "logo" = NA) %>%
  select(ncaa_name, league, primary_color, secondary_color,
         tertiary_color, color_4, conference, logo) %>%
  rename("name" = ncaa_name,
         "primary" = primary_color,
         "secondary" = secondary_color,
         "tertiary" = tertiary_color,
         "quaternary" = color_4,
         "division" = conference) %>%
  bind_rows(filter(teamcolors, league != "ncaa")) %>%
  arrange(name)
save("teamcolors", file = "data/teamcolors.rda")
