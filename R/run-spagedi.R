
runSpagedi <- function(data_input, output_name, perm = 999){
  
  if(perm < 40 | perm > 20000){ 
    stop("Number of permutations must be between 40 and 20000 ")}
  
  input <- paste("./out/", data_input , sep = "")
  output <- output_name # Automatically adds './out/' path
  
  
  options <- 
    paste('"',
          input,"\n", 
        output, "\n", 
        ifelse(file.exists(paste("./out/", output, sep = "")), "e\n", ""), # If file already exists, overwrite
        "\n", # Basic information menu
        "1\n", # Choose individuals analysis
        "1\n", # Choose Loiselle kinship coefficient
        "3\n", # Make permutation tests
        "\n", # Permutation options
        perm, "\n", # Number of permutations 
        "\n", # Output options
        '"',
      
        sep = "")
  
  command <- paste("printf", options, "|", "spagedi")
  
  system(command)
  
}
