#' Color palettes for professional sports teams
#' 
#' @docType data
#' @format A data frame with one row for each professional team and five variables:
#' \describe{
#'  \item{name}{the name of the team}
#'  \item{league}{the league in which the team plays}
#'  \item{primary}{the team's primary color}
#'  \item{secondary}{the team's secondary color}
#'  \item{tertiary}{the team's tertiary color}
#'  \item{quaternary}{the team's quaternary color}
#'  \item{division}{the team's division}
#'  \item{logo}{URL to the team's logo, hosted by \url{http://www.sportslogos.net}}
#' }
#' 
#' @details The colors given are HTML hexidecimal values. See \code{\link[grDevices]{colors}}
#' for more information. 
#' 
#' @source \url{http://jim-nielsen.com/teamcolors/}, \url{http://www.sportslogos.net}, \url{https://teamcolorcodes.com/}
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
#' 
#' 
#' # Using ggplot2
#' if (require(ggplot2)) {
#'   ggplot(pythag, aes(x = wpct, y = exp_wpct, color = name, fill = name)) + 
#'     geom_abline(slope = 1, intercept = 0, linetype = 3) + 
#'     geom_point(shape = 21, size = 3) + 
#'     scale_fill_manual(values = pythag$primary, guide = FALSE) + 
#'     scale_color_manual(values = pythag$secondary, guide = FALSE) + 
#'     geom_text(aes(label = substr(name, 1, 3))) + 
#'     scale_x_continuous("Winning Percentage", limits = c(0.3, 0.7)) + 
#'     scale_y_continuous("Expected Winning Percentage", limits = c(0.3, 0.7)) + 
#'     coord_equal()
#'   }
#' }
#' 
"teamcolors"