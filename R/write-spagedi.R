
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







