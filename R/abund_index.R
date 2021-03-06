#' Count rows by quadrat-index.
#'
#' Count rows by quadrat-index. This is a conservative wrapper around the
#' function `abundanceperquad()` of the CTFS R Package. Its output is always
#' abundance (not basal area nor agb) and includes all available rows. If you
#' want to exclude trees of some particular dbh range you need to do it before
#' using this function.
#'
#' This function is deprecated. Better alternatives to count rows by groups are
#' available in __fgeo.abundance__, __dplyr__ and __janitor__ (see `group_by()`
#' and `count()` in __dplyr__ and `tabyl()` in __janitor__). Those alternatives
#' are better tested and considerably faster.
#'
#' @param censdata A table of plot census data.
#' @param plotdim The x and y dimensions of the plot.
#' @param gridsize Side of the square quadrat.
#'
#' @return A dataframe where each quadrat-index is a column and each species
#' is a rowname.
#' 
#' @keywords internal
#'
#' @examples
#' cns <- fgeo.data::luquillo_tree6_random
#' pdm <- c(1000, 500)
#' gsz <- 20
#' abund_index(cns, pdm, gsz)
#' @noRd
abund_index <- function(censdata, plotdim, gridsize) {
  stopifnot(!missing(censdata), !missing(plotdim), !missing(gridsize))
  fgeo.ctfs::abundanceperquad2(
    censdata = censdata, plotdim = plotdim, gridsize = gridsize, mindbh = 0
  )$abund
}

