teamcolors
================

an R package providing color palettes for pro sports teams

Courtesy of (<http://teamcolors.arc90.com/>)

Install
-------

``` r
devtools::install_github("beanumber/teamcolors")
```

Load
----

``` r
library(teamcolors)
head(teamcolors)
```

    ##                   name primary secondary tertiary quaternary sport
    ## 1 Arizona Diamondbacks #A71930   #000000  #E3D4AD       <NA>   mlb
    ## 2       Atlanta Braves #CE1141   #13274F     <NA>       <NA>   mlb
    ## 3    Baltimore Orioles #DF4601   #000000     <NA>       <NA>   mlb
    ## 4       Boston Red Sox #BD3039   #0D2B56     <NA>       <NA>   mlb
    ## 5         Chicago Cubs #CC3433   #0E3386     <NA>       <NA>   mlb
    ## 6    Chicago White Sox #000000   #C4CED4     <NA>       <NA>   mlb

Plot
----

``` r
library(Lahman)
library(dplyr)
pythag <- Teams %>%
  filter(yearID == 2014) %>%
  select(name, W, L, R, RA) %>%
  mutate(wpct = W / (W+L), exp_wpct = 1 / (1 + (RA/R)^2)) %>%
  # St. Louis Cardinals do not match
  left_join(teamcolors, by = "name")
with(pythag, plot(wpct, exp_wpct, bg = primary, col = secondary, pch = 21, cex = 3))
```

![](README_files/figure-markdown_github/unnamed-chunk-3-1.png)
