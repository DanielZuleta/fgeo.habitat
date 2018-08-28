context("data")

library(fgeo.habitat)
library(dplyr)

test_that("expected datasets", {
  expect <- sort(
    c(
      "luquillo_top3_sp",
      "soil_random",
      "soil_fake"
    )
  )
  actual <- sort(fgeo.base::find_datasets("fgeo.habitat"))
  expect_equal(expect, actual)
})
