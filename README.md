### rSpagedi

*rSpagedi* is a package aimed at interfacing the population genetics program SPAGeDi (Spatial Pattern Analysis of Genetic Diversity) with R. The current version of rSpagedi focuses on running analyses of fine-scale spatial genetic structure (FS-SGS).

To find out more about SPAGeDi, please visit [the website](http://ebe.ulb.ac.be/ebe/SPAGeDi.html)

The main components of rSpagedi are:

1.  Running SPAGeDi analyses in R via the terminal
2.  Reading the output of SPAGeDi analyses into R
3.  Calculating the popular Sp statistic, which estimates the strength of FS-SGS
4.  Plotting spatial autocorrelation in relatedness

===============

To install rSpagedi, you must first make sure the package 'devtools' is installed. This will allow you to install rSpagedi directly from github

``` r

install.packages("devtools")

devtools::install_github("lukembrowne/rSpagedi")

library(rSpagedi)
```

An example that shows how to use the package to solve a simple problem.

An overview that describes the main components of the package. For more complex packages, this will point to vignettes for more details.
