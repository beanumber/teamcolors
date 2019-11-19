globalVariables(c("league", "name"))

#' Color palettes
#' @param lg character vector for the league identifier
#' @param which Which set of colors do you want? Default is 1 for "primary"
#' @importFrom dplyr %>%
#' @seealso teamcolors
#' @export
#' @examples 
#' league_pal("mlb", 2)

league_pal <- function(lg, which = 1) {
  teams <- teamcolors::teamcolors %>%
    dplyr::filter(league == lg)
  out <- dplyr::pull(teams, which + 2)
  names(out) <- teams$name
  out
}

#' @rdname league_pal
#' @return For \code{*_pal()} functions, a named character vector of colors
#' @export

team_pal <- function(which = 1) {
  teams <- teamcolors::teamcolors
  out <- dplyr::pull(teams, which + 2)
  names(out) <- teams$name
  out
}

#' @rdname league_pal
#' @return For \code{scale_*_teams()} functions, a wrapper to \code{\link[ggplot2]{scale_color_manual}}
#' or  \code{\link[ggplot2]{scale_fill_manual}}
#' @export

scale_color_teams <- function(which = 1, ...) {
  ggplot2::scale_color_manual(..., values = team_pal(which = which))
}

#' @rdname league_pal
#' @export
#' @examples
#' if (require(Lahman) && require(dplyr) && require(ggplot2)) {
#'   pythag <- Teams %>%
#'     filter(yearID == 2016) %>%
#'     select(name, teamID, yearID, W, L, R, RA) %>%
#'     mutate(wpct = W / (W + L), exp_wpct = 1 / (1 + (RA/R)^2)) %>%
#'     left_join(teamcolors, by = "name")
#'     
#'   p <- ggplot(pythag, aes(x = wpct, y = exp_wpct, color = name, fill = name)) + 
#'     geom_abline(slope = 1, intercept = 0, linetype = 3) + 
#'     geom_point(shape = 21, size = 3) + 
#'     scale_x_continuous("Winning Percentage", limits = c(0.3, 0.7)) + 
#'     scale_y_continuous("Expected Winning Percentage", limits = c(0.3, 0.7)) + 
#'     labs(title = "Real and Pythagorean winning % by team",
#'     subtitle = paste(pythag$yearID[1], "MLB Season", sep = " "),
#'     caption = "Source: the Lahman baseball database. Using teamcolors R pckg") +
#'     coord_equal()
#'     
#'   p +
#'     scale_fill_teams(name = "Team") + 
#'     scale_color_teams(name = "Team")
#' }

scale_fill_teams <- function(which = 1, ...) {
  ggplot2::scale_fill_manual(..., values = team_pal(which = which))
}

#' @rdname league_pal
#' @import ggplot2
#' @importFrom dplyr filter
#' @param ... arguments passed to other functions
#' @export
#' @seealso \code{\link[scales]{show_col}}
#' @examples 
#' show_team_col()

show_team_col <- function(...) {
  x <- teamcolors::teamcolors %>%
    dplyr::filter(league != "ncaa") 
  if (length(list(...)) > 0) {
    x <- teamcolors::teamcolors %>%
      dplyr::filter(...)
  }
  
  ggplot(x, aes(x = name, color = name, fill = name)) + 
    geom_bar() +
    facet_wrap(~toupper(league), scales = "free_y") +
    coord_flip() + 
    scale_x_discrete(NULL) + 
    scale_y_continuous(NULL) + 
    scale_fill_teams() + 
    scale_color_teams(2) + 
    guides(color = FALSE, fill = FALSE) + 
    theme(axis.text.x = element_blank(), 
          axis.ticks.x = element_blank())
}

#' @rdname league_pal
#' @export
#' @examples 
#' show_ncaa_col()

show_ncaa_col <- function(...) {
  x <- teamcolors::teamcolors %>%
    dplyr::filter(league == "ncaa") 
  if (length(list(...)) > 0) {
    x <- teamcolors::teamcolors %>%
      dplyr::filter(...)
  }
  
  ggplot(x, aes(x = name, color = name, fill = name)) + 
    geom_bar() +
    facet_wrap(~division, scales = "free_y") +
    coord_flip() + 
    scale_x_discrete(NULL) + 
    scale_y_continuous(NULL) + 
    scale_fill_teams() + 
    scale_color_teams(2) + 
    guides(color = FALSE, fill = FALSE) + 
    theme(axis.text.x = element_blank(), 
          axis.ticks.x = element_blank())
}

#' Displays palettes for all teams for a specified sport
#' @import ggplot2
#' @importFrom dplyr filter
#' @importFrom dplyr case_when
#' @param sport character vector (basketball, soccer, football, hockey)
#' @param ... arguments passed to other functions
#' @export
#' @seealso \code{\link[scales]{show_col}}
#' @examples 
#' show_sport_col(sport = "soccer")
show_sport_col <- function(sport, ...){

  sport <- tolower(sport)


  if(sport == "basketball"){
    select_league <- c("nba", "wnba")
  } else if(sport == "soccer") {
    select_league <- c("epl", "mls", "nwsl")
  } else if(sport == "football"){
    select_league <- c("nfl")
  } else if(sport == "hockey"){
    select_league <- c("nhl")
  } else {
    stop("Invalid Sport")
  }
  
  x <- teamcolors::teamcolors %>%
    dplyr::filter(league %in% select_league) 
  if (length(list(...)) > 0) {
    x <- teamcolors::teamcolors %>%
      dplyr::filter(...)
  }
  
  ggplot(x, aes(x = name, color = name, fill = name)) + 
    geom_bar() +
    facet_wrap(~league, scales = "free_y") +
    coord_flip() + 
    scale_x_discrete(NULL) + 
    scale_y_continuous(NULL) + 
    scale_fill_teams() + 
    scale_color_teams(2) + 
    guides(color = FALSE, fill = FALSE) + 
    theme(axis.text.x = element_blank(), 
          axis.ticks.x = element_blank())
  
}

