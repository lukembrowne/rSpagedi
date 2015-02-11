


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






