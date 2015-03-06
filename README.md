### rSpagedi

*rSpagedi* is a package aimed at interfacing the population genetics program SPAGeDi (Spatial Pattern Analysis of Genetic Diversity) with R. The current version of rSpagedi focuses on running analyses of fine-scale spatial genetic structure (FS-SGS).

To find out more about SPAGeDi, please visit the [website.](http://ebe.ulb.ac.be/ebe/SPAGeDi.html)

The main components of rSpagedi are:

1.  Running SPAGeDi analyses in R via the terminal
2.  Reading the output of SPAGeDi analyses into R
3.  Calculating the popular Sp statistic, which estimates the strength of FS-SGS
4.  Creating spatial autocorrelation plots

===============

rSpagedi is very much still in development, and certainly contains many bugs. If you're interested in contributing, have any comments or suggestions, please get in touch via github or email - <lukembrowne@gmail.com>

===============

To install rSpagedi, you must first make sure the package 'devtools' is installed. This will allow you to install rSpagedi directly from github.

``` r

install.packages("devtools")

devtools::install_github("lukembrowne/rSpagedi")
```

=================

Here's an example of a typical workflow...

-   use runSpagedi() to run Spagedi through R
    -   Note that SPAGeDi must be installed on your system!
-   use makeSpagediList() to read back into R in the data file created by the Spagedi run
-   use SpSummary() to calculate Sp statistics
-   use plotAutoCor() to make an autorcorrelation plot

``` r

library(rSpagedi)


## Run SPAGeDi through R console with various options for analysis
# This reads in the SPAGeDi formatted data file located in your working directory, and
# then writes the SPAGeDi output file to your working directory
runSpagedi(input_name = "example_input_file.txt",
           output_name = "output_file.txt", 
           categories_present = TRUE, 
           perm = TRUE, n_perm = 100,
           rest_reg = TRUE, max_regr_dist = 160,
           jackknife = TRUE, 
           ar = FALSE, min_ar = 100)

## Read back in SPAGeDi into R
spagedi_output <- makeSpagediList(path_to_out = "output_file.txt")

## Calculate Sp Statistics
SpSummary(spagedi_output)
#> 
#> 
#> Mean Sp across all loci       ==  0.101427 
#> -------
#> Mean Sp across jacknifed loci ==  0.1011885 
#> -------
#> Sp by loci
#>       Ob03       Ob10       Ob19        Ob4       Ob16       Ob12 
#> 0.10549631 0.11325540 0.11171602 0.03014093 0.08078488 0.12538566 
#>       Ob22       Ob06       Ob07       Ob23       Ob11 
#> 0.10003766 0.13839420 0.13311573 0.15410320 0.04693298

## Create spatial autocorrelation plot
plotAutoCor(spagedi_output, max_dist = 200)
```

![](README-unnamed-chunk-3-1.png)

``` r
 
## Inspect individual elements of the SPAGeDi output
spagedi_output$perm
#>                               intra-individual            1            2
#> N valid permut                              NA  1.00000e+02  1.00000e+02
#> N different permut val                      NA  1.00000e+02  1.00000e+02
#> Obs val                                     NA  2.73738e-01 -1.79707e-02
#> Mean permut val                             NA  2.18513e-04  5.17256e-04
#> SD permut val                               NA  5.74291e-03  6.32670e-03
#> 95%CI-inf                                   NA -9.87585e-03 -1.22883e-02
#> 95%CI-sup                                   NA  1.28076e-02  1.34918e-02
#> P(1-sided test, H1: obs<exp)                NA  1.00000e+00  1.98000e-02
#> P(1-sided test, H1: obs>exp)                NA  0.00000e+00  9.90100e-01
#> P(2-sided test, H1: obs<>exp)               NA  0.00000e+00  2.97000e-02
#>                                          3            4            5
#> N valid permut                 1.00000e+02  1.00000e+02 100.00000000
#> N different permut val         1.00000e+02  1.00000e+02 100.00000000
#> Obs val                       -5.57203e-02 -8.06336e-02   0.02221520
#> Mean permut val                1.28546e-05  9.28854e-05   0.00111988
#> SD permut val                  5.27545e-03  5.11807e-03   0.00614183
#> 95%CI-inf                     -1.06233e-02 -9.32286e-03  -0.01460550
#> 95%CI-sup                      1.04801e-02  1.19482e-02   0.01267540
#> P(1-sided test, H1: obs<exp)   0.00000e+00  0.00000e+00   0.99010000
#> P(1-sided test, H1: obs>exp)   1.00000e+00  1.00000e+00   0.01980000
#> P(2-sided test, H1: obs<>exp)  0.00000e+00  0.00000e+00   0.02970000
#>                                          6            7            8
#> N valid permut                 1.00000e+02  1.00000e+02  1.00000e+02
#> N different permut val         1.00000e+02  1.00000e+02  1.00000e+02
#> Obs val                       -3.25178e-02  2.56284e-03 -5.94460e-02
#> Mean permut val               -8.05695e-05 -5.78508e-04  1.67623e-05
#> SD permut val                  5.48119e-03  4.56484e-03  5.52467e-03
#> 95%CI-inf                     -1.04472e-02 -1.03332e-02 -1.07910e-02
#> 95%CI-sup                      1.09628e-02  8.36323e-03  1.15632e-02
#> P(1-sided test, H1: obs<exp)   0.00000e+00  7.82200e-01  0.00000e+00
#> P(1-sided test, H1: obs>exp)   1.00000e+00  2.27700e-01  1.00000e+00
#> P(2-sided test, H1: obs<>exp)  0.00000e+00  4.45500e-01  0.00000e+00
#>                                          9           10   
#> N valid permut                 1.00000e+02  1.00000e+02 NA
#> N different permut val         1.00000e+02  1.00000e+02 NA
#> Obs val                       -2.95194e-02 -1.94838e-02 NA
#> Mean permut val               -6.12153e-04 -1.75292e-04 NA
#> SD permut val                  5.64243e-03  4.33910e-03 NA
#> 95%CI-inf                     -1.15710e-02 -8.16336e-03 NA
#> 95%CI-sup                      1.12479e-02  1.05194e-02 NA
#> P(1-sided test, H1: obs<exp)   0.00000e+00  0.00000e+00 NA
#> P(1-sided test, H1: obs>exp)   1.00000e+00  1.00000e+00 NA
#> P(2-sided test, H1: obs<>exp)  0.00000e+00  0.00000e+00 NA
#>                               structure(c("NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", 
#> N valid permut                                                                                NA
#> N different permut val                                                                        NA
#> Obs val                                                                                       NA
#> Mean permut val                                                                               NA
#> SD permut val                                                                                 NA
#> 95%CI-inf                                                                                     NA
#> 95%CI-sup                                                                                     NA
#> P(1-sided test, H1: obs<exp)                                                                  NA
#> P(1-sided test, H1: obs>exp)                                                                  NA
#> P(2-sided test, H1: obs<>exp)                                                                 NA
#>                               b-lin (slope linear dist)
#> N valid permut                              1.00000e+02
#> N different permut val                      1.00000e+02
#> Obs val                                    -2.73874e-03
#> Mean permut val                             2.32851e-06
#> SD permut val                               5.18635e-05
#> 95%CI-inf                                  -9.03546e-05
#> 95%CI-sup                                   1.17987e-04
#> P(1-sided test, H1: obs<exp)                0.00000e+00
#> P(1-sided test, H1: obs>exp)                1.00000e+00
#> P(2-sided test, H1: obs<>exp)               0.00000e+00
#>                               b-log (slope ln(dist))
#> N valid permut                           1.00000e+02
#> N different permut val                   1.00000e+02
#> Obs val                                 -7.36664e-02
#> Mean permut val                          1.60232e-04
#> SD permut val                            1.18585e-03
#> 95%CI-inf                               -1.98889e-03
#> 95%CI-sup                                2.94586e-03
#> P(1-sided test, H1: obs<exp)             0.00000e+00
#> P(1-sided test, H1: obs>exp)             1.00000e+00
#> P(2-sided test, H1: obs<>exp)            0.00000e+00
spagedi_output$dist
#>                           1         2         3         4         5
#> Dist classes         1.0000    2.0000    3.0000    4.0000    5.0000
#> Max distance        33.3808   86.8350  127.1727  178.4122  213.8676
#> Number of pairs   1522.0000 1523.0000 1522.0000 1523.0000 1522.0000
#> % partic           100.0000   75.4000   57.1000   70.9000   76.0000
#> CV partic            0.6100    0.8900    1.0000    1.1000    0.7700
#> Mean distance        9.3658   49.8009  110.5721  151.7471  193.5436
#> Mean ln(distance)   -0.1556    3.8617    4.6986    5.0164    5.2646
#>                           6         7         8         9        10
#> Dist classes         6.0000    7.0000    8.0000    9.0000   10.0000
#> Max distance       231.9222  269.5957  341.7606  483.8224  740.1426
#> Number of pairs   1523.0000 1522.0000 1523.0000 1522.0000 1523.0000
#> % partic            80.0000   61.7000   62.3000   90.3000   77.7000
#> CV partic            0.7500    1.0100    1.0000    1.0100    1.5600
#> Mean distance      222.4257  253.3511  313.8811  414.3249  571.0083
#> Mean ln(distance)    5.4043    5.5336    5.7473    6.0201    6.3389
spagedi_output$kin
#>                                   intra-individual (inbreeding coef)
#> ALL LOCI                                                          NA
#> Ob03                                                              NA
#> Ob10                                                              NA
#> Ob19                                                              NA
#> Ob4                                                               NA
#> Ob16                                                              NA
#> Ob12                                                              NA
#> Ob22                                                              NA
#> Ob06                                                              NA
#> Ob07                                                              NA
#> Ob23                                                              NA
#> Ob11                                                              NA
#> Jackknifed estimators (over loci)                                 NA
#> Mean                                                              NA
#> SE                                                                NA
#>                                        1       2       3       4       5
#> ALL LOCI                          0.2737 -0.0180 -0.0557 -0.0806  0.0222
#> Ob03                              0.2827 -0.0621 -0.0332 -0.0806 -0.0458
#> Ob10                              0.3144 -0.0473 -0.0317  0.0059 -0.0042
#> Ob19                              0.3091 -0.0460 -0.0388  0.0108 -0.0057
#> Ob4                               0.1201 -0.1006  0.0316 -0.0711  0.0832
#> Ob16                              0.2409  0.1529 -0.0847 -0.2331 -0.0487
#> Ob12                              0.2802 -0.0693 -0.1144  0.0381 -0.0486
#> Ob22                              0.3228 -0.0961 -0.0248 -0.0285 -0.0606
#> Ob06                              0.2935  0.1475 -0.1697 -0.3953  0.2192
#> Ob07                              0.3018 -0.0772 -0.0962 -0.0047  0.1020
#> Ob23                              0.3159  0.1161 -0.2087 -0.1753  0.0084
#> Ob11                              0.1316  0.0291  0.0509 -0.0722  0.0941
#> Jackknifed estimators (over loci)     NA      NA      NA      NA      NA
#> Mean                              0.2741 -0.0162 -0.0553 -0.0816  0.0199
#> SE                                0.0171  0.0261  0.0192  0.0362  0.0272
#>                                         6       7       8       9      10
#> ALL LOCI                          -0.0325  0.0026 -0.0594 -0.0295 -0.0195
#> Ob03                              -0.0407  0.0200 -0.0393 -0.0085  0.0067
#> Ob10                              -0.0710 -0.0377 -0.1083  0.0211 -0.0542
#> Ob19                              -0.0343 -0.0390 -0.1131  0.0160 -0.0579
#> Ob4                               -0.0413 -0.0138 -0.0011 -0.0423  0.0259
#> Ob16                               0.0207  0.0765  0.0098  0.0034 -0.1392
#> Ob12                              -0.1247  0.0218  0.0328  0.0061 -0.0142
#> Ob22                              -0.0084 -0.0029  0.0006 -0.1184  0.0148
#> Ob06                              -0.0955  0.0630 -0.0630  0.0627 -0.0309
#> Ob07                              -0.1240  0.0719 -0.1558 -0.0210  0.0163
#> Ob23                               0.1095 -0.2451  0.0406  0.0434 -0.0064
#> Ob11                               0.0286 -0.0166 -0.0445 -0.2180 -0.0084
#> Jackknifed estimators (over loci)      NA      NA      NA      NA      NA
#> Mean                              -0.0301  0.0040 -0.0622 -0.0294 -0.0190
#> SE                                 0.0192  0.0194  0.0217  0.0247  0.0138
#>                                   average 0-160 b-lin(slope linear dist)
#> ALL LOCI                            1e-04    NA             -0.002738740
#> Ob03                                0e+00    NA             -0.002578880
#> Ob10                                0e+00    NA             -0.002861170
#> Ob19                                0e+00    NA             -0.002813850
#> Ob4                                 0e+00    NA             -0.000761786
#> Ob16                                0e+00    NA             -0.003461280
#> Ob12                                0e+00    NA             -0.002480900
#> Ob22                                0e+00    NA             -0.002131970
#> Ob06                                0e+00    NA             -0.004637260
#> Ob07                                0e+00    NA             -0.002839150
#> Ob23                                0e+00    NA             -0.004995630
#> Ob11                                0e+00    NA             -0.001359880
#> Jackknifed estimators (over loci)      NA    NA                       NA
#> Mean                                1e-04    NA             -0.002748230
#> SE                                  1e-04    NA              0.000274098
#>                                   b-log(slope log dist)
#> ALL LOCI                                    -0.07366640
#> Ob03                                        -0.07567250
#> Ob10                                        -0.07764790
#> Ob19                                        -0.07718460
#> Ob4                                         -0.02652100
#> Ob16                                        -0.06132380
#> Ob12                                        -0.09025260
#> Ob22                                        -0.06774550
#> Ob06                                        -0.09777550
#> Ob07                                        -0.09294140
#> Ob23                                        -0.10542200
#> Ob11                                        -0.04075660
#> Jackknifed estimators (over loci)                    NA
#> Mean                                        -0.07345270
#> SE                                           0.00541105
spagedi_output$diversity
#>                    Sample size # missing genotypes (%)
#> Multilocus average         175             16.0 (9.1%)
#> Ob03                       175               13 (7.4%)
#> Ob10                       175               17 (9.7%)
#> Ob19                       175               15 (8.6%)
#> Ob4                        175               13 (7.4%)
#> Ob16                       175               11 (6.3%)
#> Ob12                       175              20 (11.4%)
#> Ob22                       175               14 (8.0%)
#> Ob06                       175              19 (10.9%)
#> Ob07                       175               14 (8.0%)
#> Ob23                       175               17 (9.7%)
#> Ob11                       175              23 (13.1%)
#>                    # incomplete genotypes (%) # of defined gene copies
#> Multilocus average                 0.0 (0.0%)                      159
#> Ob03                                 0 (0.0%)                      162
#> Ob10                                 0 (0.0%)                      158
#> Ob19                                 0 (0.0%)                      160
#> Ob4                                  0 (0.0%)                      162
#> Ob16                                 0 (0.0%)                      164
#> Ob12                                 0 (0.0%)                      155
#> Ob22                                 0 (0.0%)                      161
#> Ob06                                 0 (0.0%)                      156
#> Ob07                                 0 (0.0%)                      161
#> Ob23                                 0 (0.0%)                      158
#> Ob11                                 0 (0.0%)                      152
#>                    NA: # alleles
#> Multilocus average          5.36
#> Ob03                        7.00
#> Ob10                        7.00
#> Ob19                        7.00
#> Ob4                         3.00
#> Ob16                        3.00
#> Ob12                        5.00
#> Ob22                        9.00
#> Ob06                        3.00
#> Ob07                        7.00
#> Ob23                        4.00
#> Ob11                        4.00
#>                    NAe: Effective # alleles (Nielsen et al. 2003)
#> Multilocus average                                           3.13
#> Ob03                                                         4.81
#> Ob10                                                         4.42
#> Ob19                                                         4.54
#> Ob4                                                          1.43
#> Ob16                                                         1.50
#> Ob12                                                         1.24
#> Ob22                                                         6.33
#> Ob06                                                         2.07
#> Ob07                                                         4.39
#> Ob23                                                         1.55
#> Ob11                                                         2.09
#>                    AR(k=152): Allelic richness (expected number of alleles among 152 gene copies)
#> Multilocus average                                                                           5.35
#> Ob03                                                                                         6.94
#> Ob10                                                                                         7.00
#> Ob19                                                                                         7.00
#> Ob4                                                                                          3.00
#> Ob16                                                                                         3.00
#> Ob12                                                                                         4.96
#> Ob22                                                                                         8.94
#> Ob06                                                                                         3.00
#> Ob07                                                                                         7.00
#> Ob23                                                                                         4.00
#> Ob11                                                                                         4.00
#>                    He (gene diversity corrected for sample size, Nei 1978)
#> Multilocus average                                                  0.5619
#> Ob03                                                                0.7923
#> Ob10                                                                0.7738
#> Ob19                                                                0.7798
#> Ob4                                                                 0.3017
#> Ob16                                                                0.3349
#> Ob12                                                                0.1921
#> Ob22                                                                0.8422
#> Ob06                                                                0.5160
#> Ob07                                                                0.7721
#> Ob23                                                                0.3541
#> Ob11                                                                0.5222
```

=================
