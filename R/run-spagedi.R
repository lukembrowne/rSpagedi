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
#' @param rest_reg \(TRUE/FALSE\) - Use restricted distance for calculating regression
#' @param max_regr_dist \(numeric)\ - Maximum distance to use for restricted regression, only used if \code{rest_reg} is set to \code{TRUE}
#' 
#' @return Does not return anything directly, but writes results of analysis to
#'  a tab-delimited text file at \code{output_name}. 
#'
#'
runSpagedi <- function(input_name, output_name, 
                       categories_present = TRUE, 
                       perm = FALSE, n_perm = 999,
                       rest_reg = FALSE, max_regr_dist = 160,
                       jackknife = FALSE,
                       ar = FALSE, min_ar = 140){
  
  if(n_perm < 40 | n_perm > 20000){ 
    stop("Number of permutations must be between 40 and 20000 ")}
  
  options <- 
    paste('"',
          input_name,"\n", 
        output_name, "\n", 
        # If file already exists, overwrite
        ifelse(file.exists(output_name), "e\n", ""), 
        "\n", # Basic information menu
        ifelse(categories_present, "1\n", ""), # Choose individuals analysis
        "1\n", # Choose Loiselle kinship coefficient
        
        if(perm & rest_reg & jackknife){ 
          # Permutation and restricted regression and jackknife
          paste("234\n0\n", max_regr_dist, "\n\n", n_perm, "\n", sep = "")
          
        } else if(perm & !rest_reg & jackknife){ 
          # Permutation and jacknife without restricted regression 
          paste("34\n\n", n_perm, "\n", sep = "")
          
        } else if(perm & !rest_reg & !jackknife){ 
          # Permutation without jackknife and restricted regression 
          paste("3\n\n", n_perm, "\n", sep = "")
          
        } else if(!perm & rest_reg & jackknife){ 
          # Restricted regression and jacknife without permutation
          paste("24\n0\n", max_regr_dist, "\n\n", sep = "")
        
        } else if(!perm & rest_reg & !jackknife){ 
          # Restricted regression without jackknife or permutation
          paste("2\n0\n", max_regr_dist, "\n\n", sep = "")

        } else if(!perm & !rest_reg & jackknife){ 
          # Jackknife without permutation or restricted regression
          "4\n"
        } else if(!perm & !rest_reg & !jackknife){
          # No permutation, restricted regression, or jackknife
          "\n"
        },
        
        #ifelse(rest_reg, paste("234\n0\n", max_regr_dist, "\n", sep = ""), "34\n"), 
        #"\n", # Permutation options
        #perm, "\n", # Number of permutations 
        ifelse(ar, paste("2\n", min_ar, "\n", sep = ""), "\n"), # Output options
        '"',
      
        sep = "")
  
  command <- paste("printf", options, "|", "spagedi")
  
  system(command)
}


