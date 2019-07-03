globalVariables("league")

#' ggplot2 palettes
#' @param lg character vector for the league identifier
#' @param which Which set of colors do you want? Default is 1 for "primary"
#' @importFrom dplyr %>%
#' @seealso teamcolors
#' @export

league_palette <- function(lg, which = 1) {
  teams <- teamcolors::teamcolors %>%
    dplyr::filter(league == lg)
  colors <- teams[, which + 2] %>% 
    dplyr::pull()
  names(colors) <- teams$name
  colors
}