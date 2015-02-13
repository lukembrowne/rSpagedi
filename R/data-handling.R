


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



# Calculate summary of Sp statistics - returns vector of sp by loci
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



extractDivParam <- function(spagediList, param){
  
  if(!is.character(param)) stop("Param argument must be character")
  
  if(param == "he") param <- "He (gene diversity corrected for sample size, Nei 1978)"
  if(param == "nae") param <- "NAe: Effective # alleles (Nielsen et al. 2003)"
 
  if(param == "ar"){
    ar_vec <- spagediList[['diversity']][, grep("AR", 
                                                names(spagediList[['diversity']]))]
    names(ar_vec) <- row.names(spagediList[['diversity']])
    return(ar_vec)
  }
  
  return(spagediList[['diversity']][param])
}


# Format diversity table into a data frame better formatted for data analysis
# Have to pass all the spagediLists as a list, and also names of groups
formatDiv <- function(out_as_list, group_names, param){ 
     
    # Number of groups
    num_groups <- length(out_as_list)
    
    # Data frame with columns as group names with values for diversity parameter
    div_df <- data.frame(NA)
    for(x in 1:num_groups){
      div_df <- cbind(div_df, extractDivParam(out_as_list[[x]], param))
    }
    
    # Clean up column names
    names(div_df) <- c("blank", group_names)
    row_names <- row.names(div_df)
    
    # Get rid of extra first column made my initializing df and using cbind
    div_df <- div_df[, -1]
    
    # If it's just one group, output as a named vector
    if(is.numeric(div_df)) names(div_df) <- row_names
    
    return(div_df)

}





