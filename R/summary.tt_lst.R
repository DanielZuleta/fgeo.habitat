
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
  tt_interpret(object)
}
