
#' Interpret the output of `tt_test()`.
#'
#' @param object The output of [tt_test()], i.e. an S3 object of class tt_lst.
#' @param ... Other arguments passed to methods.
#' 
#' @seealso [tt_test()].
#' 
#' @author Daniel Zuleta.
#'
#' @return A dataframe.
#' @export
summary.tt_lst <- function(object, ...) {
  ttdf <- as.data.frame(do.call(rbind, object))
  
  habitats_n <- dim(ttdf)[2] / 6 
  out <- data.frame() 
  out_names <- NULL
  
  for (species in 1:dim(ttdf)[1]) {
    for (habitat in 1:habitats_n) {
      out[species, habitat] <- ifelse(
        ttdf[species, (habitat * 6) - 1] == 1 & (1 - (ttdf[species, habitat * 6])) < 0.05,
        "aggregated",
        ifelse(
          ttdf[species, (habitat * 6) - 1] == 1 &
            (1 - (ttdf[species, habitat * 6])) >= 0.05,
          "agg_nonsignificant",
          ifelse(
            ttdf[species, (habitat * 6) - 1] == -1 & (ttdf[species, habitat * 6]) < 0.05,
            "repelled",
            ifelse(
              ttdf[species, (habitat * 6) - 1] == -1 &
                (ttdf[species, habitat * 6]) >= 0.05,
              "rep_nonsignificant",
              "neutral"
            )
          )
        )
      )
    }
  }
  
  out <- data.frame(cbind(Species = row.names(ttdf), out))
  out[] <- lapply(out, as.character)
  
  out_names <- paste0("Habitat_", seq_len(habitats_n))
  names(out) <- c("Species", out_names)
  
  out
}
