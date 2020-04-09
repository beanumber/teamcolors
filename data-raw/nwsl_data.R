#code to create dataframe with NWSL data. 

library(dplyr)
library(usethis)

nwsl_data <- data.frame(
  name = c("North Carolina Courage", "Utah Royals FC", "Houston Dash",
           "Orlando Pride", "Chicago Red Stars", "Sky Blue FC", "OL Reign",
           "Portland Thorns FC", "Washington Spirit"),
  league = c("nwsl"),
  primary = c("#01426A", "#FFB81C", "#F4911E", "#623393", "#CF0A2C",
              "#A1DBE4", "#003893", "#981D1F", "#0A1E2C"),
  secondary = c("#B3A369", "#001E62", "#92C3F1", "#01A8DF", "#41B6E6",
                "#FCB47C", "#DC2828", "#000000", "#C2002F"),
  tertiary = c("#A50034", "#9D2235", "#231F20", "#FFFFFF", "#FFFFFF",
               "#193368", "#BE8C32", "#074129", "#BCBBB9"),
  quaternary = c("#C8C9C7", NA, NA, NA, NA, "#FFFFFF", NA, NA , NA)
)

teamcolors <- teamcolors %>%
  bind_rows(nwsl_data) %>%
  arrange(name) %>%
  as_tibble()

use_data(teamcolors, internal = FALSE, overwrite = TRUE)

