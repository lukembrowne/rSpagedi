library(readGenalex)

source("./R/modify-genalex.R")
source("./R/write-spagedi.R")
source("./R/read-spagedi-output.R")

data <- readGenalex("./data/Genalex seedlings all 2 Feb 2015.txt")
data <- groupPopsGenalex(data)

seed <- subsetGenalexExtraCol(df = data, col_name = "Tissue", value = "Seed")
leaf <- subsetGenalexExtraCol(df = data, col_name = "Tissue", value = "Leaf")

beneath <- subsetGenalexPop(df = data, pop = "Beneath")
beneath_seed <- subsetGenalexExtraCol(df = beneath, col_name = "Tissue", value = "Seed")

writeSpagedi(df = seed, file_name = "seed_spagedi.txt", num_dist_int = -5)
writeSpagedi(df = leaf, file_name = "leaf_spagedi.txt", num_dist_int = -5)
writeSpagedi(df = beneath_seed, file_name = "beneath_seed.txt", num_dist_int = -5)

## Write function to run Spagedi through terminal in R for basic SGS analysis

## Need to make distance intervals custom in writeSpagedi

## Write function that plots autocorrelation plots from read-spagedi-output 

## Write function that pulls apart maternal and paternal genotypes

## General debugging, adding in unit and error checking throughout functions

## Code to calculate Sp statistic
