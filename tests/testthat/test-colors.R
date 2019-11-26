test_that("colors work", {
  expect_equal(ncol(teamcolors), 12)
  expect_is(teamcolors, "tbl_df")
  
  expect_is(team_pal(), "character")
  expect_gt(sum(team_pal(2) != team_pal(), na.rm = TRUE) / nrow(teamcolors), 0.89588)
  expect_error(team_pal(13), "between")
  
  expect_equal(class(scale_color_teams()), class(scale_color_discrete())) 
  expect_equal(class(scale_fill_teams()), class(scale_fill_discrete())) 
})
