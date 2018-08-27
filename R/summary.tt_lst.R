
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
  
  # number of habitats
  habs <- dim(ttdf)[2] / 6 
  # interpretation output
  tt_interp <- data.frame() 
  tt_interp_names <- NULL
  
  # j is the species loop
  # i is the habitat loop
  for (j in 1:dim(ttdf)[1]) {
    #
    for (i in 1:habs) {
      tt_interp[j, i] <- ifelse(
        ttdf[j, (i * 6) - 1] == 1 & (1 - (ttdf[j, i * 6])) < 0.05,
        "aggregated",
        ifelse(
          ttdf[j, (i * 6) - 1] == 1 &
            (1 - (ttdf[j, i * 6])) >= 0.05,
          "agg_nonsignificant",
          ifelse(
            ttdf[j, (i * 6) - 1] == -1 & (ttdf[j, i * 6]) < 0.05,
            "repelled",
            ifelse(
              ttdf[j, (i * 6) - 1] == -1 &
                (ttdf[j, i * 6]) >= 0.05,
              "rep_nonsignificant",
              "neutral"
            )
          )
        )
      )
    }
  }
  
  for (h in 1:habs) {
    tt_interp_names[h] <- paste("Habitat_", h, sep = "")
  }
  
  tt_interp <- data.frame(cbind(Species = row.names(ttdf), tt_interp))
  names(tt_interp) <- c("Species", tt_interp_names)
  tt_interp
}
