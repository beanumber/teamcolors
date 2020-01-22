#' Xaringan themes
#' @param pattern regular expression matched to \code{name} 
#' variable from \code{teamcolors}
#' @param colors vector of colors to choose. Default is \code{c(1, 2)}
#' for primary and secondary colors.
#' @param ... arguments passed to \code{xaringanthemer} functions
#' @export
#' @seealso \code{\link[xaringanthemer]{mono_light}}

mono_light_team <- function(pattern, colors = c(1, 2), ...) {
  if (!requireNamespace("xaringanthemer", quietly = TRUE)) {
    stop("Package \"xaringanthemer\" needed for this function to work. Please install it.",
         call. = FALSE)
  }
  x <- team_filter(pattern)
  pal <- team_pal(pattern, colors)
  xaringanthemer::mono_light(
    base_color = pal[1],
    link_color = pal[2],
    title_slide_background_image = "none",
    background_image = x$logo,
    background_position = "97% 3%",
    background_size = "100px",
    ... = ...
  )
}

#' @rdname mono_light_team
#' @export
#' @seealso \code{\link[xaringanthemer]{mono_dark}}

mono_dark_team <- function(pattern, colors = c(1, 2), ...) {
  if (!requireNamespace("xaringanthemer", quietly = TRUE)) {
    stop("Package \"xaringanthemer\" needed for this function to work. Please install it.",
         call. = FALSE)
  }
  x <- team_filter(pattern)
  pal <- team_pal(pattern, colors)
  xaringanthemer::mono_dark(
    base_color = pal[1],
    link_color = pal[2],
    title_slide_background_image = "none",
    background_image = x$logo,
    background_position = "97% 3%",
    background_size = "100px",
    ... = ...
  )
}


#' @rdname mono_light_team
#' @export
#' @seealso \code{\link[xaringanthemer]{duo}}

duo_team <- function(pattern, colors = c(1, 2), ...) {
  if (!requireNamespace("xaringanthemer", quietly = TRUE)) {
    stop("Package \"xaringanthemer\" needed for this function to work. Please install it.",
         call. = FALSE)
  }
  x <- team_filter(pattern)
  pal <- team_pal(pattern, colors)
  xaringanthemer::duo(
    primary_color = pal[1],
    secondary_color = pal[2],
    title_slide_background_image = "none",
    background_image = x$logo,
    background_position = "97% 3%",
    background_size = "100px",
    ... = ...
  )
}


#' @rdname mono_light_team
#' @export
#' @seealso \code{\link[xaringanthemer]{duo_accent}}

duo_accent_team <- function(pattern, colors = c(1, 2), ...) {
  if (!requireNamespace("xaringanthemer", quietly = TRUE)) {
    stop("Package \"xaringanthemer\" needed for this function to work. Please install it.",
         call. = FALSE)
  }
  x <- team_filter(pattern)
  pal <- team_pal(pattern, colors)
  xaringanthemer::duo_accent(
    primary_color = pal[1],
    secondary_color = pal[2],
    title_slide_background_image = "none",
    background_image = x$logo,
    background_position = "97% 3%",
    background_size = "100px",
    ... = ...
  )
}


#' @rdname mono_light_team
#' @export
#' @seealso \code{\link[xaringanthemer]{duo_accent_inverse}}

duo_accent_inverse_team <- function(pattern, colors = c(1, 2), ...) {
  if (!requireNamespace("xaringanthemer", quietly = TRUE)) {
    stop("Package \"xaringanthemer\" needed for this function to work. Please install it.",
         call. = FALSE)
  }
  x <- team_filter(pattern)
  pal <- team_pal(pattern, colors)
  xaringanthemer::duo_accent_inverse(
    primary_color = pal[1],
    secondary_color = pal[2],
    title_slide_background_image = "none",
    background_image = x$logo,
    background_position = "97% 3%",
    background_size = "100px",
    ... = ...
  )
}


#' Embed logos
#' @export
#' @importFrom dplyr pull first
#' @examples 
#' img_team_logo("New York Mets", width = 64)

img_team_logo <- function(pattern, ...) {
  url <- teamcolors::teamcolors %>%
    filter(grepl(pattern, name)) %>%
    pull(logo) %>%
    first()
  htmltools::img(src = url, ...)
}

#' @rdname img_team_logo
#' @export
#' @examples 
#' img_teamcolors_hex(width = 64)

img_teamcolors_hex <- function(...) {
#  url <- system.file("teamcolors_hex.png", package = "teamcolors")
  url <- "https://raw.githubusercontent.com/beanumber/teamcolors/master/inst/teamcolors_hex.png"
  htmltools::img(src = url, ...)
}
