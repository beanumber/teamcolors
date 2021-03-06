% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/palettes.R
\name{league_pal}
\alias{league_pal}
\alias{team_filter}
\alias{team_vec}
\alias{team_pal}
\alias{scale_color_teams}
\alias{scale_fill_teams}
\alias{show_team_col}
\alias{show_ncaa_col}
\title{Color palettes for sports teams}
\usage{
league_pal(lg, which = 1)

team_filter(pattern = ".")

team_vec(pattern = ".", which = 1)

team_pal(pattern, colors = c(1, 2))

scale_color_teams(which = 1, ...)

scale_fill_teams(which = 1, ...)

show_team_col(...)

show_ncaa_col(...)
}
\arguments{
\item{lg}{character vector for the league identifier}

\item{which}{Which set of colors do you want? Default is 1 for "primary"}

\item{pattern}{regular expression matching team names passed to 
\code{\link[dplyr]{filter}}}

\item{colors}{A numeric vector of colors to return. Possible values are 
\code{1:4}}

\item{...}{arguments passed to other functions}
}
\value{
For \code{*_pal()} functions, a named character vector of colors

For \code{scale_*_teams()} functions, a wrapper to 
\code{\link[ggplot2]{scale_color_manual}}
or \code{\link[ggplot2]{scale_fill_manual}}
}
\description{
Color palettes for sports teams
}
\details{
Use \code{league_pal} to return a vector of colors for a spcefic
league.

Use \code{team_pal} to return a palette (named vector) of 
multiple colors for a specific team.
}
\examples{
league_pal("mlb", 2)
team_filter("New York")
team_vec("New York")
team_pal("Celtics")
team_pal("Lakers", 1:4)
team_pal("New York", 1:4)
if (require(Lahman) && require(dplyr) && require(ggplot2)) {
  pythag <- Teams \%>\%
    filter(yearID == 2016) \%>\%
    select(name, teamID, yearID, W, L, R, RA) \%>\%
    mutate(wpct = W / (W + L), exp_wpct = 1 / (1 + (RA/R)^2)) \%>\%
    left_join(teamcolors, by = "name")
    
  p <- ggplot(pythag, aes(x = wpct, y = exp_wpct, color = name, fill = name)) + 
    geom_abline(slope = 1, intercept = 0, linetype = 3) + 
    geom_point(shape = 21, size = 3) + 
    scale_x_continuous("Winning Percentage", limits = c(0.3, 0.7)) + 
    scale_y_continuous("Expected Winning Percentage", limits = c(0.3, 0.7)) + 
    labs(title = "Real and Pythagorean winning \% by team",
    subtitle = paste(pythag$yearID[1], "MLB Season", sep = " "),
    caption = "Source: the Lahman baseball database. Using teamcolors R pckg") +
    coord_equal()
    
  p +
    scale_fill_teams(name = "Team") + 
    scale_color_teams(name = "Team")
}
\dontrun{
show_team_col()
}
\dontrun{
show_ncaa_col()
}
}
\seealso{
teamcolors

\code{\link[scales]{show_col}}
}
