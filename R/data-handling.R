


### Make a 'Spagedi' list that holds all the information we want to do analyses on

makeSpagediList <- function(path_to_out){
  
  ## Need to save kin, perm, and dist to a list / DF
  list <- list(perm = readSpagediTable(path_to_out, "perm"), 
               dist = readSpagediTable(path_to_out, "dist"),
               kin = readSpagediTable(path_to_out, "kin"))
  
  return(list)
  
}


## Calculate sp statistic

calcSp <- function(kin, row_name){
  return( ( - kin[row_name, "b-log(slope log dist)"]) / (1 - kin[row_name, 2]) )
}



#' Sum of vector elements.
#'
#' \code{sum} returns the sum of all the values present in its arguments.
#'
#' This is a generic function: methods can be defined for it directly
#' or via the \code{\link{Summary}} group generic. For this to work properly,
#' the arguments \code{...} should be unnamed, and dispatch is on the
#' first argument.
#'
#' @param ... Numeric, complex, or logical vectors.
#' @param na.rm A logical scalar. Should missing values (including NaN)
#'   be removed?
#' @return If all inputs are integer and logical, then the output
#'   will be an integer. If integer overflow
#'   \url{http://en.wikipedia.org/wiki/Integer_overflow} occurs, the output
#'   will be NA with a warning. Otherwise it will be a length-one numeric or
#'   complex vector.
#'
#'   Zero-length vectors have sum 0 by definition. See
#'   \url{http://en.wikipedia.org/wiki/Empty_sum} for more details.
#' @examples
#' sum(1:10)
#' sum(1:5, 6:10)
#' sum(F, F, F, T, T)
#'
#' sum(.Machine$integer.max, 1L)
#' sum(.Machine$integer.max, 1)
#'
#' \dontrun{
#' sum("a")
#' }
SpSummary <- function(SpagediList){
  kin <- SpagediList$kin
  mean <- calcSp(kin, "ALL LOCI")
  mean_jck <- calcSp(kin, "Mean")
  cat("\n\n")
  cat("Mean Sp across all loci       == ", mean, "\n")
  cat("-------\n")
  cat("Mean Sp across jacknifed loci == ", mean_jck, "\n")
  cat("-------\n")
      # Select rows that have individual loci
  loci_rows <- (grep("ALL LOCI", row.names(kin)) + 1):(grep("Jack", row.names(kin)) - 1)
  sp_loci <- calcSp(kin, loci_rows )
  names(sp_loci) <- row.names(kin)[loci_rows]
  cat("Sp by loci\n\n")
  return(sp_loci)
}








