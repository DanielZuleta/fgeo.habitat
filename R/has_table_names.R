has_table_names <- function(template) {
  function(.data) {
    has_tree_names <- all(hasName(.data, names(template)))
    if (has_tree_names) TRUE else FALSE
  }
}

#' @export
has_tree_names <- has_table_names(fgeo.data::luquillo_tree6_1ha)
#' @export
has_stem_names <- has_table_names(fgeo.data::luquillo_stem6_1ha)
#' @export
has_vft_names <- has_table_names(fgeo.data::luquillo_vft_4quad)
#' @export
has_taxa_names <- has_table_names(fgeo.data::luquillo_taxa)
#' @export
has_spp_names <- has_table_names(fgeo.data::luquillo_species)
