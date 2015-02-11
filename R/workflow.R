library(readGenalex)

source("./R/data-handling.R")
source("./R/read-write-spagedi.R")
source("./R/plot-spagedi.R")
source("./R/run-spagedi.R")

data <- readGenalex("./data/Genalex seedlings all 2 Feb 2015.txt")
data <- groupPopsGenalex(data)

beneath <- subsetGenalexPop(df = data, pop = "Beneath")
lek <- subsetGenalexPop(df = data, pop = "Lek")
beneath_seed <- subsetGenalexExtraCol(df = beneath, col_name = "Tissue",
                                      value = "Seed")
beneath_leaf <- subsetGenalexExtraCol(df = beneath, col_name = "Tissue",
                                      value = "Leaf")

## Separating maternal and paternal
mat <- separateMatPat(beneath)$mat
pat <- separateMatPat(beneath)$pat
writeSpagedi(mat, "mat.txt")
writeSpagedi(pat, "pat.txt")
runSpagedi(data_input = "mat.txt", output_name = "mat_out.txt")
runSpagedi(data_input = "pat.txt", output_name = "pat_out.txt")

mat_out <- makeSpagediList("./out/mat_out.txt")
pat_out <- makeSpagediList("./out/pat_out.txt")

plotAutoCor(mat_out)
plotAutoCor(pat_out)
calcSp(mat_out)
calcSp(pat_out)



writeSpagedi(df = beneath_seed, file_name = "beneath_seed.txt", num_dist_int = -5)
writeSpagedi(df = beneath_leaf, file_name = "beneath_leaf.txt", num_dist_int = -5)

runSpagedi(data_input = "beneath_leaf.txt", output_name = "leaf.txt")
runSpagedi(data_input = "beneath_seed.txt", output_name = "seed.txt")

seed <- makeSpagediList("./out/seed.txt")
leaf <- makeSpagediList("./out/leaf.txt")



## Need to make distance intervals custom in writeSpagedi

## General debugging, adding in unit and error checking throughout functions

## Code to calculate Sp statistic

## Get rid of intergroup clumping

## Add option to set number of permutations, make options more complex
