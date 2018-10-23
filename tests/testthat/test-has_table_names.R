context("has_table_names")

tree <- fgeo.data::luquillo_tree6_1ha
stem <- fgeo.data::luquillo_stem6_1ha
vft <- fgeo.data::luquillo_vft_4quad
taxa <- fgeo.data::luquillo_taxa
spp <- fgeo.data::luquillo_species

test_that("returns TRUE with a tree table and FALSE with other tables", {
  expect_false(has_tree_names(stem))
  
  expect_true(has_tree_names(tree))
  expect_true(has_stem_names(stem))
  expect_true(has_vft_names(vft))
  expect_true(has_spp_names(spp))
  expect_true(has_taxa_names(taxa))
})
