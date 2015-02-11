library(readGenalex)

source("./R/modify-genalex.R")
source("./R/write-spagedi.R")

data <- readGenalex("./data/Genalex seedlings all 2 Feb 2015.txt")
data <- groupPopsGenalex(data)

seed <- subsetGenalexExtraCol(df = data, col_name = "Tissue", value = "Seed")
leaf <- subsetGenalexExtraCol(df = data, col_name = "Tissue", value = "Leaf")

beneath <- subsetGenalexPop(df = data, pop = "Beneath")
beneath_seed <- subsetGenalexExtraCol(df = beneath, col_name = "Tissue", value = "Seed")

writeSpagedi(df = seed, file_name = "seed_spagedi.txt", num_dist_int = -5)
writeSpagedi(df = leaf, file_name = "leaf_spagedi.txt", num_dist_int = -5)
writeSpagedi(df = beneath_seed, file_name = "beneath_seed.txt", num_dist_int = -5)

