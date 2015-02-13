


### Make a 'Spagedi' list that holds all the information we want to do analyses on

makeSpagediList <- function(path_to_out){
  
  ## Need to save kin, perm, and dist to a list / DF
  list <- list(perm = readSpagediTable(path_to_out, "perm"), 
               dist = readSpagediTable(path_to_out, "dist"),
               kin = readSpagediTable(path_to_out, "kin"),
               diversity = readSpagediTable(path_to_out, "diversity"))
  
  return(list)
  
}


## Calculate sp statistic

calcSp <- function(kin, row_name){
  return( ( - kin[row_name, "b-log(slope log dist)"]) / (1 - kin[row_name, 2]) )
}



# Calculate summary of Sp statistics
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








