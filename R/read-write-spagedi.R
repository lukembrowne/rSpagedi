
## Write a genalex dataframe to spagedi format
writeSpagedi <- function(df, file_name = "spagedi_format_out.txt", num_dist_int = -5){

sink(paste("./out/", file_name, sep = ""))
  # Begin first line
cat(attr(df, "n.samples"),     # First - number of samples
    attr(df, "n.pops"),        # Number of category / populations
    2,                         # Number of spatial dimensions
    attr(df, "n.loci"),        # Number of loci
    3,                         # Number of digits to code alleles
    attr(df, "ploidy"),        # Ploidy
    "\n",
    sep = "\t")        # End first line

  # Begin second line - Distance intervals
cat(num_dist_int, "\n")

  # Begin third line
cat("Field_number",            # Individual ID
    "Plot",                    # Category
    "UTM1",                    # X coord
    "UTM2",                    # Y coord
    attr(df, "locus.names"),
    "\n",
    sep = "\t")       # End third line
sink() # End header

  # Begin fourth line - DATA!
  df_to_write <- data.frame(Field_number = attr(df, "extra.columns")$Field_number,
                         Plot = df$Plot,
                         UTM1 = attr(df, "extra.columns")$UTM1,
                         UTM2 = attr(df, "extra.columns")$UTM2)

  ## Convert Ob03 to three alleles to be consistent across loci
  for(i in 1:nrow(df)){ # Could probably vectorize to make faster
    if(nchar(df[i, "Ob03"]) == 2){
      df[i, "Ob03"] <- paste("0", df[i, "Ob03"], sep = "")
    }
    if(nchar(df[i, "Ob03.2"]) == 2){
      df[i, "Ob03.2"] <- paste("0", df[i, "Ob03.2"], sep = "")
  }}

  ## Need to paste together allele calls

  df_collapsed <- data.frame(matrix(nrow = attr(df, "n.samples"), ncol = 11))
  colnames(df_collapsed) <- attr(df, "locus.names")
  
  y <- 3 # Loops through data on dataframe
  for(j in 1:attr(df, "n.loci")){
    
    df_collapsed[, j] <- paste0(df[, y], df[, y + 1])
     y <- y + 2    
  }

  out <- cbind(df_to_write, df_collapsed)

  write.table(out, paste("./out/", file_name, sep = ""), append = TRUE, 
              col.names = FALSE, quote = FALSE, sep = "\t", row.names = FALSE)
  
  cat("END", file = paste("./out/", file_name, sep = ""), append = TRUE )
}




## Read data summaries from text output of Spagedi
readSpagediTable <- function(path_to_out, type){
  # Type can be dist, perm, or kin
  out_lines <- readLines(path_to_out)
  
  if(type == "perm"){
    start <- grep("LOCATIONS, INDIVIDUALS and/or GENES PERMUTATION TESTS",
                  out_lines) + 3}
  
  if(type == "kin"){
    start <- grep("Genetic analyses at INDIVIDUAL level \\(175 individuals\\)",
                  out_lines) + 10}
  
  if(type == "dist"){
    start <- grep("Genetic analyses at INDIVIDUAL level \\(175 individuals\\)",
                  out_lines) + 1}
  
  # Find the last line of the table by looking for the next blank line
  end = min(which(out_lines[start:length(out_lines)] == "")) + start -2
  
  raw <- out_lines[start:end] 
  
  split <- strsplit(raw, split = "\t")
  
  maxcol <- max(sapply(split, length))
  
  tab <- data.frame(matrix(ncol = maxcol - 1, nrow = length(raw)))
  row.names(tab) <- sapply(split, "[[", 1)
  
  if(type == "dist"){labels  <- 1}
  if(type == "perm"){labels  <-  2}
  if(type == "kin"){labels <- 1}
  names(tab) <- split[[labels]][-1]
  
  # Pick out list elements to fill in with empty data to reach 12 columns
  fill_in <- which(sapply(split, length) < maxcol)
  
  for(x in fill_in){
    split[[x]][!(1:length(split[[2]]) %in% 1:length(split[[x]]))] <- NA
  }
  
  # Fill in columns with actual data
  for(j in 1:ncol(tab)){
    tab[, j] <- as.numeric(sapply(split, "[[", (j+1)))
  }
  
  if(type == "kin"){tab <- tab[-1, ]}
  if(type == "perm"){tab  <- tab[-c(1,2,3), ]}
  if(type == "dist"){tab <- tab[, -1]}
  
  return(tab)
}









