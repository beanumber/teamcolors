test_that("colors work", {
  expect_equal(ncol(teamcolors), 11)
  expect_gt(nrow(teamcolors), 400)
  expect_is(teamcolors, "tbl_df")
  
  expect_is(league_pal("nba"), "character")
  expect_is(names(league_pal("mlb")), "character")
  
  expect_is(team_pal("New York"), "character")
  expect_gt(sum(team_vec(which = 2) != team_vec(which = 1), na.rm = TRUE) / nrow(teamcolors), 0.89588)
  expect_error(team_vec(which = 13))
  
  expect_equal(class(scale_color_teams()), class(scale_color_discrete()))
  expect_equal(class(scale_fill_teams()), class(scale_fill_discrete()))
})
