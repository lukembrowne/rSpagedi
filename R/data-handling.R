


### Make a 'Spagedi' list that holds all the information we want to do analyses on

makeSpagediList <- function(path_to_out){
  
  ## Need to save kin, perm, and dist to a list / DF
  list <- list(perm = readSpagediTable(path_to_out, "perm"), 
               dist = readSpagediTable(path_to_out, "dist"),
               kin = readSpagediTable(path_to_out, "kin"))
  
  return(list)
  
}



### Update attributes of a GenAlex dataframe

updateAttributes <- function(df){
  df$Plot <- factor(df$Plot)
  attr(df, "n.samples") <- nrow(df) # N based on rows
  attr(df, "n.pops") <- length(levels(factor(df$Plot)))
  attr(df, "pop.labels") <- levels(factor(df$Plot))
  new_pop_sizes <- as.numeric( table(df$Plot))
  names(new_pop_sizes) <- levels(df$Plot)
  attr(df, "pop.sizes") <- new_pop_sizes
      # Update ploidy by counting # of columns after first two columns
  if(ncol(df) == (attr(df, "n.loci") + 2)) {
    attr(df, "ploidy") <- 1
    attr(df, "locus.columns") <- 3:ncol(df)
  }

  return(df)
}

## Subset based on info in extra columns
subsetGenalexExtraCol <- function(df, col_name, value){
  
  # Get row indices of subset
  sub_ind <- which(attr(df, "extra.columns")[col_name] == value)
  
  # Create new dataframe that carries over attributes
  new_df <- df[sub_ind, ]
  attr(new_df, "extra.columns") <- attr(df, "extra.columns")[sub_ind, ]
  
  new_df <- updateAttributes(new_df)
  return(new_df)
  
}

# Subset based on pop
subsetGenalexPop <- function(df, pop){
  
  # Get row indices of subset
  sub_ind <- which(df$Plot == pop)
  
  # Create new dataframe that carries over attributes
  new_df <- data[sub_ind, ]
  attr(new_df, "extra.columns") <- attr(data, "extra.columns")[sub_ind, ]
  
  new_df <- updateAttributes(new_df)
  return(new_df)
  
}

# Group populations
groupPopsGenalex <- function(df){
  
  df$Plot <- as.character(df$Plot)
  df$Plot[grep(pattern = "Random", x = df$Plot)] <- "Random"
  df$Plot[grep(pattern = "Lek", x = df$Plot)] <- "Lek"
  df$Plot[df$Plot != "Random" & df$Plot != "Lek"] <- "Beneath"
  df$Plot<- factor(df$Plot)  
  return(df)
}



## Separating maternal and paternal genotypes


separateMatPat <- function(genalex_df){


    # Subset into 2 genalex DF based on tissue type
    seed <- subsetGenalexExtraCol(df = genalex_df, col_name = "Tissue",
                                          value = "Seed")
    leaf <- subsetGenalexExtraCol(df = genalex_df, col_name = "Tissue",
                                          value = "Leaf")
    # initialize new dataframes that will hold paternal and maternal genotypes
    mat <- seed
    pat <- leaf

    # Require that field numbers align perfectly
    if(any(seed$Field_number != leaf$Field_number)) {
      stop("Field numbers don't match up between leaf and seed samples!")}
  
    # Loop through genotypes, choosing which alleles are paternal or maternal
    for(i in 1:nrow(seed)){ # Rows
      
      for(j in seq(3, ncol(seed), by = 2)){ # Every two columns
        
          # Save genotypes for each seed and leaf
        seed_gen <- seed[i, c(j, j + 1)]
        leaf_gen <- leaf[i, c(j, j + 1)]
        
          # If no genotypes match or there is missing data
        if(sum(!(leaf_gen %in% seed_gen)) == 2){
          mat[i, j] <- 0 # Set to missing data
          pat[i, j] <- 0 # Set to missing data
          if(0 %in% c(leaf_gen, seed_gen)) {warning("Missing Data!")
          } else{
          warning("Leaf and seed genotype mismatch!!")
          }
          next() # Jump to next individual if there's a mismatch
        }
        
        # If both alleles match - aka both homozygotes     
        if((sum(leaf_gen %in% seed_gen) == 2) & (sum(seed_gen %in% leaf_gen) == 2)){
          #print("both homozygotes")
          mat[i, j] <- leaf_gen[1]
          pat[i, j] <- leaf_gen[1]
          next()
        }
         
        # If one allele in seed matches 2 in leaf
        if((sum(leaf_gen %in% seed_gen) == 2) & (sum(seed_gen %in% leaf_gen) == 1)){
          #print('leaf homozygous, seed not')
          mat[i, j] <- leaf_gen[seed_gen %in% leaf_gen] # Switch order
          pat[i, j] <- leaf_gen[1] # Doesn't matter - just take either allele
        next()
        }
        
          # If there is one allele that matches
        if((sum(leaf_gen %in% seed_gen) == 1) & (sum(seed_gen %in% leaf_gen) == 1)){
         #print("one allele match")
         mat[i, j] <- leaf_gen[leaf_gen %in% seed_gen]
         pat[i, j] <- leaf_gen[!(leaf_gen %in% seed_gen)]
         next()
        } 
      } # j   
    } # i

  # Clean up maternal and paternal dataframes, taking out extra columns
  mat_out <- mat[, c(1,2, seq(3, ncol(seed), by = 2))]
  pat_out <- pat[, c(1,2, seq(3, ncol(seed), by = 2))]

  # Copy over attributes
  mat_names <- names(mat_out) # Could probably only use one line here
  pat_names <- names(pat_out)

  attributes(mat_out) <- attributes(mat)[-1] # Don't include names attr
  attributes(pat_out) <- attributes(pat)[-1] # Don't include names attr

  names(mat_out) <- mat_names
  names(pat_out) <- pat_names

  # Update attributes
  mat_out <- updateAttributes(mat_out)
  pat_out <- updateAttributes(pat_out)

return(list(mat = mat_out, pat = pat_out))

}


## Calculate sp statistic

calcSp <- function(SpagediList){
  kin <- SpagediList$kin
  all_loci <- (- kin[1, "b-log(slope log dist)"]) / (1 - kin[1, 2])
  return(all_loci) 
}







