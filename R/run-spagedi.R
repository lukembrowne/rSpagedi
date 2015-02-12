#' Execute SPAGeDi through R console.
#'
#' Calls SPAGeDi executable via system() function
#'
#' SPAGeDi must be installed on your system, and able to be run from the 
#'  Shell/Terminal. Function is currently configured to run a basic spatial
#'  autocorrelation analysis between individuals using the kinship coefficient
#'  of Loiselle et al. 1995, testing for significance, and jacknifing over loci.
#'
#' @param input_name \(string\) - Name of SPAGeDi formatted input data file. Must be in 
#'  working directory.
#' @param output_name \(string\) - Name of output file. Will overwrite if file 
#'  already exists, or create new file if it doesn't
#' @param perm Number of permutations. Default is 999
#' 
#' @return Does not return anything directly, but writes results of analysis to
#'  a tab-delimited text file at \code{output_name}. See \code{\link{readSpagediTable}}
#'  for how to parse this output.
#'
#' @examples
#' TODO
#'
runSpagedi <- function(input_name, output_name, perm = 999){
  
  if(perm < 40 | perm > 20000){ 
    stop("Number of permutations must be between 40 and 20000 ")}
  
  options <- 
    paste('"',
          input_name,"\n", 
        output_name, "\n", 
        # If file already exists, overwrite
        ifelse(file.exists(output_name), "e\n", ""), 
        "\n", # Basic information menu
        "1\n", # Choose individuals analysis
        "1\n", # Choose Loiselle kinship coefficient
        "34\n", # Make permutation tests and jacknife over loci
        "\n", # Permutation options
        perm, "\n", # Number of permutations 
        "\n", # Output options
        '"',
      
        sep = "")
  
  command <- paste("printf", options, "|", "spagedi")
  
  system(command)
}
