library(readGenalex)
library(rSpagedi)
source('~/Dropbox/Papers, Posters, and Talks/In Prep/Oenocarpus PSA/Oeno psa/analysis/SGS maternal vs paternal/genalex-misc 12 Feb 2015.R')
setwd("~/Dropbox/Papers, Posters, and Talks/In Prep/Oenocarpus PSA/Oeno psa/analysis/SGS maternal vs paternal")

data <- readGenalex::readGenalex("./PSA GenAlex All 2 Feb 2015.txt")
data <- groupPopsGenalex(data)

  # Adding jitter to spatial data to break up grouping
attr(data, "extra.columns")$UTM1 <- jitter(as.numeric(attr(data, "extra.columns")$UTM1))
attr(data, "extra.columns")$UTM2 <- jitter(as.numeric(attr(data, "extra.columns")$UTM2))

beneath <- subsetGenalexPop(df = data, pop = "Random")

## Separating maternal and paternal
mat <- separateMatPat(beneath)$mat
pat <- separateMatPat(beneath)$pat
writeSpagediGenAlex(mat, "mat.txt", dist_int = -10)
writeSpagediGenAlex(pat, "pat.txt", dist_int = -10)

runSpagedi(input_name = "mat.txt", output_name = "mat_out.txt", perm = 100)
runSpagedi(input_name = "pat.txt", output_name = "pat_out.txt", perm = 100)


mat_out <- makeSpagediList("mat_out.txt")
pat_out <- makeSpagediList("pat_out.txt")

plotAutoCor(mat_out)
plotAutoCor(pat_out, overlay = TRUE, color = "darkgreen")

SpSummary(mat_out)
SpSummary(pat_out)

t.test(SpSummary(mat_out), SpSummary(pat_out), paired = T)


## General debugging, adding in unit and error checking throughout functions

# Integrate with hierfstat format so it's easy to calculate basic stats?

# Make readme for github

## Add documentation to each function - use cmd + shift + d to build documentation

# Providing example data is a little complicated because we can't actually load the data, only point to it's path

