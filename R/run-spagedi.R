
runSpagedi <- function(data_input, output_name){
  
  input <- paste("./out/", data_input , sep = "")
  output <- output_name # Automatically adds './out/' path
  
  
  options <- 
    paste('"',
          input,"\n", 
        output, "\n", 
        ifelse(file.exists(output), "e\n", ""), # If file already exists, overwrite
        "\n", # Basic information menu
        "1\n", # Choose individuals analysis
        "1\n", # Choose Loiselle kinship coefficient
        "3\n", # Make permutation tests
        "\n", # Permutation options
        "100\n", # Number of permutations 
        "\n", # Output options
        '"',
      
        sep = "")
  
  command <- paste("printf", options, "|", "spagedi")
  
  system(command)
  
}
