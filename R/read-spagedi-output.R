
out_lines <- readLines("./out/out.txt")


## Reads summary about distance intervals
readDistInt <- function(out_lines){
  
  start_dist = grep("Genetic analyses at INDIVIDUAL level \\(175 individuals\\)", out_lines) + 1
     
    dist_raw <- out_lines[start_dist:(start_dist + 6)]
    dist_split <- strsplit(dist_raw, split = "\t")
  
    dist <- data.frame(matrix(ncol = length(dist_split[[1]]) - 1, 
                              nrow = length(dist_raw)))
    row.names(dist) <- sapply(dist_split, "[[", 1)
    for(j in 1:ncol(dist)){
      dist[, j] <- sapply(dist_split, "[[", (j+1))
    }
  
  return(dist)
}

# Reads summary of kinship estimates across loci

readKinship <- function(out_lines){
  
  start_kin = grep("Genetic analyses at INDIVIDUAL level \\(175 individuals\\)",
                   out_lines) + 10 # Hopefully this is always 9 lines after the distance summary
    
    # Find the last line of the kin summary by looking for the next blank line
  end_kin = min(which(out_lines[start_kin:length(out_lines)] == "")) + start_kin -2
  
  kin_raw <- out_lines[start_kin:end_kin] 
  
  kin_split <- strsplit(kin_raw, split = "\t")
  
  kin <- data.frame(matrix(ncol = length(kin_split[[2]]) - 1, # Change to maxcol here
                            nrow = length(kin_raw)))
  row.names(kin) <- sapply(kin_split, "[[", 1)
  names(kin) <- kin_split[[1]][-1]
  
    # Pick out list elements to fill in with empty data to reach 12 columns
  fill_in <- which(sapply(kin_split,length) < length(kin_split[[2]]))
  
  for(x in fill_in){
    kin_split[[x]][!(1:length(kin_split[[2]]) %in% 1:length(kin_split[[x]]))] <- NA
  }
  
    # Fill in columns with actual data
  for(j in 1:ncol(kin)){
    kin[, j] <- as.numeric(sapply(kin_split, "[[", (j+1)))
  }
  
  kin <- kin[-1, ]
  
  return(kin)
}

## Read permutation summary
readSpagediTable <- function(out_lines, type){
  # Type can be dist, perm, or kin
  
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

readSpagediTable(out_lines = out_lines, type = "perm")





  