library(readGenalex)

source("./R/data-handling.R")
source("./R/read-write-spagedi.R")
source("./R/plot-spagedi.R")
source("./R/run-spagedi.R")

data <- readGenalex("./data/Genalex seedlings all 2 Feb 2015.txt")
data <- groupPopsGenalex(data)

beneath <- subsetGenalexPop(df = data, pop = "Lek")
beneath_seed <- subsetGenalexExtraCol(df = beneath, col_name = "Tissue",
                                      value = "Seed")
beneath_leaf <- subsetGenalexExtraCol(df = beneath, col_name = "Tissue",
                                      value = "Leaf")

writeSpagedi(df = beneath_seed, file_name = "beneath_seed.txt", num_dist_int = -5)
writeSpagedi(df = beneath_leaf, file_name = "beneath_leaf.txt", num_dist_int = -5)

runSpagedi(data_input = "beneath_leaf.txt", output_name = "leaf.txt")
runSpagedi(data_input = "beneath_seed.txt", output_name = "seed.txt")

seed <- makeSpagediList("./out/seed.txt")
leaf <- makeSpagediList("./out/leaf.txt")

plotAutoCor(seed)
plotAutoCor(leaf)


## Write function to run Spagedi through terminal in R for basic SGS analysis

## Need to make distance intervals custom in writeSpagedi

## Write function that pulls apart maternal and paternal genotypes

## General debugging, adding in unit and error checking throughout functions

## Code to calculate Sp statistic

## Get rid of intergroup clumping
