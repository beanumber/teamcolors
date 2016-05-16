#' Color palettes for professional sports teams
#' 
#' @docType data
#' @format A data frame with one row for each professional team and five variables:
#' \describe{
#'  \item{name}{the name of the team}
#'  \item{primary}{the team's primary color}
#'  \item{secondary}{the team's secondary color}
#'  \item{tertiary}{the team's tertiary color}
#'  \item{quaternary}{the team's quaternary color}
#'  \item{sport}{the league in which the team plays}
#' }
#' 
#' @details The colors given are HTML hexidecimal values. See \code{\link[grDevices]{colors}}
#' for more information. 
#' 
#' @source \url{https://github.com/teamcolors/teamcolors.github.io/tree/master/src/scripts/data/leagues}
#' 
#' @examples 
#' data(teamcolors)
#' 
#' if (require(Lahman) & require(dplyr)) {
#'   pythag <- Teams %>%
#'     filter(yearID == 2014) %>%
#'     select(name, W, L, R, RA) %>%
#'     mutate(wpct = W / (W+L), exp_wpct = 1 / (1 + (RA/R)^2)) %>%
#'     # St. Louis Cardinals do not match
#'     left_join(teamcolors, by = "name")
#'   with(pythag, plot(exp_wpct, wpct, bg = primary, col = secondary, pch = 21, cex = 3))
#' }
#' if (require(ggplot2)) {
#'   ggplot(data = pythag, aes(x = exp_wpct, y = wpct)) + 
#'     geom_point(shape = 21, size = 5, fill = pythag$primary, color = pythag$secondary) + 
#'     geom_text(aes(label = name), size = 3, nudge_y = -0.005) + 
#'     geom_abline(slope = 1, intercept = 0, lty = 3) + 
#'     coord_equal()
#' }
#' 
"teamcolors"