#' Torus Translation Test to determine habitat associations of tree species.
#'
#' Determine habitat-species associations with code developed by Sabrina Russo,
#' Daniel Zuleta, Matteo Detto, and Kyle Harms.
#' 
#' You should only try to determine the habitat association for sufficiently
#' abundant species. In a 50-ha plot, a minimum abundance of 50 trees/species
#' has been used. Also, you should use data of individual trees (i.e. a tree
#' table, and not a stem table with potentially multiple stems per tree. This
#' test only makes sense at the population level. We are interested in knowing
#' whether or not individuals of a species are aggregated on a habitat. Multiple
#' stems of an individual do not represent population level processes but
#' individual level processes.
#'
#' @param census A dataframe; a ForestGEO _tree_ table (see details).
#' @param sp Character sting giving any number of species-names.
#' @param habitat Object giving the habitat designation for each
#'   plot partition defined by `gridsize`. See [`fgeo_habitat()`].
#' @param plotdim,gridsize Plot dimensions and gridsize. If `NULL` (default)
#'   they will be guessed, and a message will inform you of the chosen values. 
#'   If the guess is wrong, you should provide the correct values manually (and
#'   check that your habitat data is correct).
#'
#' @seealso [summary.tt_lst()], [to_df()], [fgeo_habitat()].
#'
#' @author Sabrina Russo, Daniel Zuleta, Matteo Detto, and Kyle Harms.
#'
#' @section Acknowledgments:
#' Nestor Engone Obiang, David Kenfack, Jennifer Baltzer, and Rutuja
#' Chitra-Tarak provided feedback. Daniel Zuleta provided guidance.
#'
#' @return A list of matrices. You can summarize the output with [summary()] and
#'   convert it to a dataframe with [to_df()]. You can also view the
#'   result with `View(your-result)`, and reduce it from a list of matrices to a
#'   single matix with `Reduce(rbind, your-result)`. See examples.
#'
#' @section Interpretation of Output:
#' * `N.Hab.1`: Count of stems of the focal species in habitat 1.
#' * `Gr.Hab.1`: Count of instances the observed relative density of the focal
#' species on habitat 1 was greater than the relative density based on the TT
#' habitat map.
#' * `Ls.Hab.1`: Count of instances the observed relative density of the focal
#' species on habitat 1 was less than the relative density based on the TT
#' habitat map.
#' * `Eq.Hab.1`: Count of instances the observed relative density of the focal
#' species on habitat 1 was equal to the relative density based on the TT
#' habitat map.
#' The sum of the `Gr.Hab.x`, `Ls.Hab.x`, and `Eq.Hab.x` columns for one habitat
#' equals the number of 20 x20 quads in the plot.
#' The `Rep.Agg.Neut` columns for each habitat indicate whether the species is
#' significantly repelled (-1), aggregated (1), or neutrally distributed (0) on
#' the habitat in question.
#' 
#' The probabilities associated with the test for whether these patterns are
#' statistically significant are in the `Obs.Quantile` columns for each habitat.
#' Note that to calculate the probability for repelled, it is the value given,
#' but to calculate the probability for aggregated, it is 1 - the value given.
#' 
#' Values of the `Obs.Quantile` < 0.025 means that the species is repelled from
#' that habitat, while values of the `Obs.Quantile` > 0.975 means that the
#' species is aggregated on that habitat.
#' 
#' @export
#'
#' @examples
#' library(dplyr)
#' library(fgeo.data)
#' 
#' # Pick alive trees, of 10 mm or more
#' census <- filter(luquillo_tree6_random, status == "A", dbh >= 10)
#' 
#' # Pick sufficiently abundant species
#' pick <- filter(add_count(census, sp), n > 50)
#' species <- unique(pick$sp)
#' 
#' # Use your habitat data or create it from elevation data
#' habitat <- fgeo.tool::fgeo_habitat(luquillo_elevation, gridsize = 20, n = 4)
#' 
#' # A list or matrices
#' tt_lst <- tt_test(census, species, habitat)
#' tt_lst
#' 
#' # A simple summary to help you interpret the results
#' summary(tt_lst)
#' 
#' # A combined matrix
#' Reduce(rbind, tt_lst)
#' 
#' # A dataframe
#' dfm <- to_df(tt_lst)
#' 
#' # Using dplyr to summarize results by species and distribution
#' summarize(group_by(dfm, sp, distribution), n = sum(stem_count))
tt_test <- function(census, sp, habitat, plotdim = NULL, gridsize = NULL) {
  stopifnot(is.data.frame(habitat))
  if (!inherits(habitat, "fgeo_habitat")) {
    warn(glue("
      `habitat` isn't of class 'fgeo_habitat'. This commonly causes errors. 
      See ?fgeo.tool::fgeo_habitat().
    "))
  }

  plotdim <- plotdim %||% fgeo.tool::extract_plotdim(habitat)
  gridsize <- gridsize %||% fgeo.tool::extract_gridsize(habitat)
  inform_gridsize_plotdim(gridsize, plotdim)

  habitat <- sanitize_habitat_names_if_necessary(habitat)
  check_tt_test(census, sp, habitat, plotdim, gridsize)

  abundance <- abund_index(census, plotdim, gridsize)
  out <- lapply(
    X = sp,
    FUN = torusonesp.all,
    allabund20 = abundance,
    hab.index20 = habitat,
    plotdim = plotdim,
    gridsize = gridsize
  )
  new_tt_lst(out)
}

torusonesp.all <- function(species, hab.index20, allabund20, plotdim, gridsize) {
  # Calculates no. of x-axis quadrats of plot. (x is the long axis of plot in
  # the case of Pasoh)
  plotdimqx <- plotdim[1] / gridsize
  # Calculates no. of y-axis quadrats of plot.
  plotdimqy <- plotdim[2] / gridsize
  # Determines tot. no. of habitat types.
  num.habs <- length(unique(hab.index20$habitats))

  GrLsEq <- matrix(0, 1, num.habs * 6) # Creates empty matrix for output.
  rownames(GrLsEq) <- species # Names single row of output matrix.


  for (i in 1:num.habs) # Creates names for columns of output matrix.
  {
    if (i == 1) {
      cols <- c(paste("N.Hab.", i, sep = ""), paste("Gr.Hab.", i, sep = ""), paste("Ls.Hab.", i, sep = ""), paste("Eq.Hab.", i, sep = ""), paste("Rep.Agg.Neut.", i, sep = ""), paste("Obs.Quantile.", i, sep = ""))
    }
    if (i > 1) {
      cols <- c(cols, paste("N.Hab.", i, sep = ""), paste("Gr.Hab.", i, sep = ""), paste("Ls.Hab.", i, sep = ""), paste("Eq.Hab.", i, sep = ""), paste("Rep.Agg.Neut.", i, sep = ""), paste("Obs.Quantile.", i, sep = ""))
    }
  }
  colnames(GrLsEq) <- cols # Names columns of output matrix.


  # CALCULATIONS FOR OBSERVED RELATIVE DENSITIES ON THE TRUE HABITAT MAP

  # pulls out the abundance by quad data for the focal species
  allabund20.sp <- allabund20[which(rownames(allabund20) == species), ] 
  # Fills a matrix, with no. rows = plotdimqy (dim 2) and no. columns =
  # plotdimqx (dim 1), with the indiv. counts per quadrat of one species.
  spmat <- matrix(as.numeric(allabund20.sp), nrow = plotdimqy, plotdimqx, byrow = F) 
  # calculates total number of stems in each quad for all species and puts in matrix
  totmat <- matrix(apply(allabund20, MARGIN = 2, FUN = "sum"), plotdimqy, plotdimqx, byrow = F) 
  
  # fills matrix with habitat types, oriented in the same way as the species and
  # total matrices above
  habmat <- matrix(hab.index20$habitats, nrow = plotdimqy, ncol = plotdimqx, byrow = F) 

  spstcnthab <- numeric() # Creates empty vector for stem counts per sp. per habitat.
  totstcnthab <- numeric() # Creates empty vector for tot. stem counts per habitat.

  for (i in 1:num.habs)
  {
    totstcnthab[i] <- sum(totmat[habmat == i]) # Determines tot. no. stems per habitat of the true map.
    spstcnthab[i] <- sum(spmat[habmat == i]) # Determines tot. no. stems for focal sp. per habitat of the true map.
  }

  spprophab <- spstcnthab / totstcnthab # Calculates observed relative stem density of focal sp. per habitat of the true map.

  # CALCULATIONS FOR RELATIVE DENSITIES ON THE TORUS-BASED HABITAT MAPS
  habmat.template <- habmat

  for (j in 1:4) {
    # apply rotations and mirrors
    # if j==1 do nothing

    if (j == 2) habmat <- apply(habmat.template, 2, rev)
    if (j == 3) habmat <- t(apply(habmat.template, 1, rev))
    if (j == 4) habmat <- t(apply(apply(habmat.template, 2, rev), 1, rev))


    # CALCULATIONS FOR RELATIVE DENSITIES ON THE TORUS-BASED HABITAT MAPS

    for (x in 0:(plotdimqx - 1)) # Opens "for loop" through all 20-m translations along x-axis.
    {
      for (y in 0:(plotdimqy - 1)) # Opens "for loop" through all 20-m translations along y-axis.
      {
        newhab <- matrix(0, plotdimqy, plotdimqx) # Creates empty matrix of quadrats' habitat designations.


        # The following "if" statements create the x,y torus-translation of the habitat map.

        if (y == 0 & x == 0) {
          newhab <- habmat
        }

        if (y == 0 & x > 0) {
          newhab <- habmat[c(1:plotdimqy), c((plotdimqx - x + 1):plotdimqx, 1:(plotdimqx - x))]
        }

        if (x == 0 & y > 0) {
          newhab <- habmat[c((plotdimqy - y + 1):plotdimqy, 1:(plotdimqy - y)), c(1:plotdimqx)]
        }

        if (x > 0 & y > 0) {
          newhab <- habmat[c((plotdimqy - y + 1):plotdimqy, 1:(plotdimqy - y)), c((plotdimqx - x + 1):plotdimqx, 1:(plotdimqx - x))]
        }


        Torspstcnthab <- numeric() # Creates empty vector for stem counts per sp. per habitat in torus-based maps.
        Tortotstcnthab <- numeric() # Creates empty vector for tot. stem counts per habitat in torus-based maps.

        for (i in 1:num.habs)
        {
          Tortotstcnthab[i] <- sum(totmat[newhab == i]) # Determines tot. no. stems per habitat of the focal torus-based map.
          Torspstcnthab[i] <- sum(spmat[newhab == i]) # Determines tot. no. stems for focal sp. per habitat of the focal torus-based map.
        }

        Torspprophab <- Torspstcnthab / Tortotstcnthab # Calculates relative stem density of focal sp. per habitat of the focal torus-based map.

        for (i in 1:num.habs)
        {
          if (is.na(spprophab[i] > Torspprophab[i])) {
            warn_invalid_comparison(spprophab[i], Torspprophab[i])
          }
          if (spprophab[i] > Torspprophab[i]) { # If rel. dens. of focal sp. in focal habitat of true map is greater than rel. dens. of focal sp. in focal habitat of torus-based map, then add one to "greater than" count.
            GrLsEq[1, (6 * i) - 4] <- GrLsEq[1, (6 * i) - 4] + 1
          }

          if (spprophab[i] < Torspprophab[i]) { # If rel. dens. of focal sp. in focal habitat of true map is less than rel. dens. of focal sp. in focal habitat of torus-based map, then add one to "less than" count.
            GrLsEq[1, (6 * i) - 3] <- GrLsEq[1, (6 * i) - 3] + 1
          }

          if (spprophab[i] == Torspprophab[i]) { # If rel. dens. of focal sp. in focal habitat of true map is equal to rel. dens. of focal sp. in focal habitat of torus-based map, then add one to "equal to" count.
            GrLsEq[1, (6 * i) - 2] <- GrLsEq[1, (6 * i) - 2] + 1
          }
        }
      } # Closes "for loop" through all 20-m translations along x-axis.
    } # Closes "for loop" through all 20-m translations along y-axis.
  } # Closes for loop through mirrors and rotations (j)


  for (i in 1:num.habs)
  {
    GrLsEq[1, (6 * i) - 5] <- spstcnthab[i] # add counts of No. stems in each habitat

    if (GrLsEq[1, (6 * i) - 4] / (4 * (plotdimqx * plotdimqy)) <= 0.025) GrLsEq[1, (6 * i) - 1] <- -1 # if rel.dens. of sp in true map is greater than rel. dens. in torus map less than 2.5% of the time, then repelled
    if (GrLsEq[1, (6 * i) - 4] / (4 * (plotdimqx * plotdimqy)) >= 0.975) GrLsEq[1, (6 * i) - 1] <- 1 # if rel.dens. of sp in true map is greater than rel. dens. in torus map more than 97.5% of the time, then aggregated
    if ((GrLsEq[1, (6 * i) - 4] / (4 * (plotdimqx * plotdimqy)) < 0.975) & (GrLsEq[1, (6 * i) - 4] / (4 * (plotdimqx * plotdimqy)) > 0.025)) GrLsEq[1, (6 * i) - 1] <- 0 # otherwise it's neutral (not different from random dist)

    GrLsEq[1, (6 * i)] <- GrLsEq[1, (6 * i) - 4] / (4 * (plotdimqx * plotdimqy)) # quantile in the TT distribtution of relative densities of the true relative density
  }

  return(GrLsEq)
}

sanitize_habitat_names_if_necessary <- function(habitat) {
  tryCatch(
    fgeo.base::check_crucial_names(habitat, c("x", "y")),
    error = function(e) rename_to_xy(habitat)
  )
}

inform_gridsize_plotdim <- function(gridsize, plotdim) {
  hint <- "To change this value see `?tt_test()`."
  inform(glue("Using `plotdim = c({commas(plotdim)})`. {hint}"))
  inform(glue("Using `gridsize = {gridsize}`. {hint}"))
}

rename_to_xy <- function(x) {
  .x <- x
  .x <- fgeo.tool::nms_try_rename(.x, want = "x", try = "gx")
  .x <- fgeo.tool::nms_try_rename(.x, want = "y", try = "gy")
  .x
}

check_tt_test <- function(census, sp, habitat, plotdim, gridsize) {
  stopifnot(
    is.data.frame(census),
    is.numeric(plotdim),
    length(plotdim) == 2,
    is.numeric(gridsize),
    length(gridsize) == 1
  )
  
  has_tree_names <- 
    !fgeo.base::has_table_names(fgeo.data::luquillo_tree6_1ha)(census)
  msg <- "Is `census` a tree table (not a stem table)? See `?tt_test()`."
  if (has_tree_names) warn(msg)
  
  common_gridsize <- gridsize %in% c(5, 10, 20)
  if (!common_gridsize) {
    rlang::warn(paste("Uncommon `gridsize`:", gridsize, "\nIs this expected?"))
  }

  if (!any(is.character(sp) || is.factor(sp))) {
    msg <- paste0(
      "`sp` must be of class character or factor but is of class ",
      class(sp), "."
    )
    rlang::abort(msg)
  }

  valid_sp <- sp %in% unique(census$sp)
  if (!all(valid_sp)) {
    msg <- paste0(
      "All `sp` must be present in `census`.\n",
      "Odd: ", commas(sp[!valid_sp])
    )
    abort(msg)
  }
}

#' Warns that a comparison is invalid. Results from a division `NaN = 0/0`
#' @noRd
warn_invalid_comparison <- function(spp, torus) {
  msg <- "Values can't be compared:\n"
  value <- paste0(
    "spprophab = ", spp, " vs. ",
    "Torspprophab = ", torus, "\n"
  )
  rlang::warn(paste0(msg, value))
}

new_tt_lst <- function(.x) {
  stopifnot(is.list(.x))
  structure(.x, class = c("tt_lst", class(.x)))
}

#' @keywords internal
#' @export
#' @noRd
print.tt_lst <- function(x, ...) {
  print(unclass(x))
  invisible(x)
}
