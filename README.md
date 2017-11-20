
<!-- README.md is generated from README.Rmd. Please edit that file -->
krig
====

The goal of krig is to krig soil data as per John et al. (2007).

Installation
------------

You can install krig from github with:

``` r
# To install from a private repo, use auth_token with a token
# from https://github.com/settings/tokens. You only need the
# repo scope. Best practice is to save your PAT in env var called
# GITHUB_PAT.
# install.packages("devtools")
devtools::install_github("forestgeo/krig", auth_token = "abc")
```

Example
-------

``` r
library(krig)

# Using a randomized data set; useful for examples but not for research.
df <- krig::soil_random

result <- GetKrigedSoil(df, var = "M3Al")
#> variog: computing omnidirectional variogram
#> variofit: covariance model used is exponential 
#> variofit: weights used: npairs 
#> variofit: minimisation function used: optim 
#> variofit: covariance model used is circular 
#> variofit: weights used: npairs 
#> variofit: minimisation function used: optim 
#> variofit: covariance model used is cauchy 
#> variofit: weights used: npairs 
#> variofit: minimisation function used: optim 
#> variofit: covariance model used is gaussian 
#> variofit: weights used: npairs 
#> variofit: minimisation function used: optim 
#> ksline: kriging location:  1 out of 1250 
#> ksline: kriging location:  101 out of 1250 
#> ksline: kriging location:  201 out of 1250 
#> ksline: kriging location:  301 out of 1250 
#> ksline: kriging location:  401 out of 1250 
#> ksline: kriging location:  501 out of 1250 
#> ksline: kriging location:  601 out of 1250 
#> ksline: kriging location:  701 out of 1250 
#> ksline: kriging location:  801 out of 1250 
#> ksline: kriging location:  901 out of 1250 
#> ksline: kriging location:  1001 out of 1250 
#> ksline: kriging location:  1101 out of 1250 
#> ksline: kriging location:  1201 out of 1250 
#> ksline: kriging location:  1250 out of 1250 
#> Kriging performed using global neighbourhood
lapply(result, head)
#> $df
#>     x  y        z
#> 1  10 10 824.5186
#> 2  30 10 825.5012
#> 3  50 10 826.4549
#> 4  70 10 827.3795
#> 5  90 10 828.2749
#> 6 110 10 829.1410
#> 
#> $df.poly
#>    gx gy        z
#> 1  10 10 824.9970
#> 2  30 10 825.9262
#> 3  50 10 826.8312
#> 4  70 10 827.7119
#> 5  90 10 828.5683
#> 6 110 10 829.4005
#> 
#> $lambda
#> [1] 1
#> 
#> $vg
#> $vg$u
#>  [1]  25.39513  30.25204  36.03784  42.93020  51.14075  60.92159  72.57304
#>  [8]  86.45288 102.98729 122.68395 146.14767 174.09890 207.39590 247.06106
#> [15] 294.31232
#> 
#> $vg$v
#>  [1] 52791.00 54636.41 65741.80 58003.72 49141.59 58165.96 40611.67
#>  [8] 56683.03 57253.77 56038.20 55323.08 57468.67 57094.51 57525.14
#> [15] 57029.48
#> 
#> $vg$n
#>  [1]    66  1110    73  1101    61  3215    56  4179  2115  5790  6424
#> [12]  8768 11157 17373 16571
#> 
#> $vg$sd
#>  [1] 64846.88 75752.81 89508.82 79156.84 63290.60 78722.09 56903.37
#>  [8] 77464.93 77752.94 76617.91 76455.77 76468.92 77257.41 77679.91
#> [15] 76192.99
#> 
#> $vg$bins.lim
#>  [1] 1.000000e-12 2.000000e+00 2.382507e+00 2.838169e+00 3.380978e+00
#>  [6] 4.027602e+00 4.797894e+00 5.715508e+00 6.808618e+00 8.110789e+00
#> [11] 9.662004e+00 1.150990e+01 1.371120e+01 1.633351e+01 1.945735e+01
#> [16] 2.317864e+01 2.761163e+01 3.289245e+01 3.918324e+01 4.667716e+01
#> [21] 5.560433e+01 6.623884e+01 7.890724e+01 9.399852e+01 1.119761e+02
#> [26] 1.333918e+02 1.589035e+02 1.892943e+02 2.254975e+02 2.686246e+02
#> [31] 3.200000e+02
#> 
#> $vg$ind.bin
#>  [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [12] FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
#> [23]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
#> 
#> 
#> $vm
#> $vm$nugget
#> [1] 56607
#> 
#> $vm$cov.pars
#> [1] 40008.481  1532.595
#> 
#> $vm$cov.model
#> [1] "cauchy"
#> 
#> $vm$kappa
#> [1] 0.5
#> 
#> $vm$value
#> [1] 63795822341
#> 
#> $vm$trend
#> [1] "cte"
```
