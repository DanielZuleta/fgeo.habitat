
<!-- README.md is generated from README.Rmd. Please edit that file -->

# <img src="https://i.imgur.com/vTLlhbp.png" align="right" height=88 /> Analize soils and tree-habitat associations

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/forestgeo/fgeo.habitat.svg?branch=master)](https://travis-ci.org/forestgeo/fgeo.habitat)
[![Coverage
status](https://codecov.io/gh/forestgeo/fgeo.habitat/branch/master/graph/badge.svg)](https://codecov.io/github/forestgeo/fgeo.habitat?branch=master)
[![CRAN
status](http://www.r-pkg.org/badges/version/fgeo.habitat)](https://cran.r-project.org/package=fgeo.habitat)

## Installation

[Install all **fgeo** packages in one
step](https://forestgeo.github.io/fgeo/index.html#installation)

``` r
# install.packages("devtools")
devtools::install_github("forestgeo/fgeo.habitat")
```

For details on how to install packages from GitHub, see [this
article](https://goo.gl/dQKEeg).

## Example

``` r
library(fgeo.habitat)
library(fgeo.data)
library(fgeo.tool)
library(dplyr)
```

### Species-habitat associations

``` r
# Pick alive trees, of 10 mm or more
census <- filter(luquillo_tree6_random, status == "A", dbh >= 10)

# Pick sufficiently abundant species
pick <- filter(add_count(census, sp), n > 50)
species <- unique(pick$sp)

# Use your habitat data or create it from elevation data
habitat <- fgeo.tool::fgeo_habitat(luquillo_elevation, gridsize = 20, n = 4)

# A list or matrices
tt_lst <- tt_test(census, species, habitat)
#> Using `plotdim = c(320, 500)`. To change this value see `?tt_test()`.
#> Using `gridsize = 20`. To change this value see `?tt_test()`.
tt_lst
#> [[1]]
#>        N.Hab.1 Gr.Hab.1 Ls.Hab.1 Eq.Hab.1 Rep.Agg.Neut.1 Obs.Quantile.1
#> CASARB      29     1418      179        3              0        0.88625
#>        N.Hab.2 Gr.Hab.2 Ls.Hab.2 Eq.Hab.2 Rep.Agg.Neut.2 Obs.Quantile.2
#> CASARB      20      416     1182        2              0           0.26
#>        N.Hab.3 Gr.Hab.3 Ls.Hab.3 Eq.Hab.3 Rep.Agg.Neut.3 Obs.Quantile.3
#> CASARB      12      804      790        6              0         0.5025
#>        N.Hab.4 Gr.Hab.4 Ls.Hab.4 Eq.Hab.4 Rep.Agg.Neut.4 Obs.Quantile.4
#> CASARB       5      554     1040        6              0        0.34625
#> 
#> [[2]]
#>        N.Hab.1 Gr.Hab.1 Ls.Hab.1 Eq.Hab.1 Rep.Agg.Neut.1 Obs.Quantile.1
#> PREMON      91     1483      116        1              0       0.926875
#>        N.Hab.2 Gr.Hab.2 Ls.Hab.2 Eq.Hab.2 Rep.Agg.Neut.2 Obs.Quantile.2
#> PREMON      89     1142      455        3              0        0.71375
#>        N.Hab.3 Gr.Hab.3 Ls.Hab.3 Eq.Hab.3 Rep.Agg.Neut.3 Obs.Quantile.3
#> PREMON      40      409     1189        2              0       0.255625
#>        N.Hab.4 Gr.Hab.4 Ls.Hab.4 Eq.Hab.4 Rep.Agg.Neut.4 Obs.Quantile.4
#> PREMON      14       76     1523        1              0         0.0475
#> 
#> [[3]]
#>        N.Hab.1 Gr.Hab.1 Ls.Hab.1 Eq.Hab.1 Rep.Agg.Neut.1 Obs.Quantile.1
#> SLOBER      18      387     1212        1              0       0.241875
#>        N.Hab.2 Gr.Hab.2 Ls.Hab.2 Eq.Hab.2 Rep.Agg.Neut.2 Obs.Quantile.2
#> SLOBER      24      810      788        2              0        0.50625
#>        N.Hab.3 Gr.Hab.3 Ls.Hab.3 Eq.Hab.3 Rep.Agg.Neut.3 Obs.Quantile.3
#> SLOBER      17     1182      414        4              0        0.73875
#>        N.Hab.4 Gr.Hab.4 Ls.Hab.4 Eq.Hab.4 Rep.Agg.Neut.4 Obs.Quantile.4
#> SLOBER       7      912      680        8              0           0.57

# A simple summary to help you interpret the results
summary(tt_lst)
#>   Species Habitat_1 Habitat_2 Habitat_3 Habitat_4
#> 1  CASARB   neutral   neutral   neutral   neutral
#> 2  PREMON   neutral   neutral   neutral   neutral
#> 3  SLOBER   neutral   neutral   neutral   neutral

# A combined matrix
Reduce(rbind, tt_lst)
#>        N.Hab.1 Gr.Hab.1 Ls.Hab.1 Eq.Hab.1 Rep.Agg.Neut.1 Obs.Quantile.1
#> CASARB      29     1418      179        3              0       0.886250
#> PREMON      91     1483      116        1              0       0.926875
#> SLOBER      18      387     1212        1              0       0.241875
#>        N.Hab.2 Gr.Hab.2 Ls.Hab.2 Eq.Hab.2 Rep.Agg.Neut.2 Obs.Quantile.2
#> CASARB      20      416     1182        2              0        0.26000
#> PREMON      89     1142      455        3              0        0.71375
#> SLOBER      24      810      788        2              0        0.50625
#>        N.Hab.3 Gr.Hab.3 Ls.Hab.3 Eq.Hab.3 Rep.Agg.Neut.3 Obs.Quantile.3
#> CASARB      12      804      790        6              0       0.502500
#> PREMON      40      409     1189        2              0       0.255625
#> SLOBER      17     1182      414        4              0       0.738750
#>        N.Hab.4 Gr.Hab.4 Ls.Hab.4 Eq.Hab.4 Rep.Agg.Neut.4 Obs.Quantile.4
#> CASARB       5      554     1040        6              0        0.34625
#> PREMON      14       76     1523        1              0        0.04750
#> SLOBER       7      912      680        8              0        0.57000

# A dataframe
dfm <- to_df(tt_lst)

# Using dplyr to summarize results by species and distribution
summarize(group_by(dfm, sp, distribution), n = sum(stem_count))
#> # A tibble: 3 x 3
#> # Groups:   sp [?]
#>   sp     distribution     n
#>   <chr>  <chr>        <dbl>
#> 1 CASARB neutral         66
#> 2 PREMON neutral        234
#> 3 SLOBER neutral         66
```

### Krige soil data

Using custom parameters and multiple soil variable.

``` r
params <- list(
  model = "circular", range = 100, nugget = 1000, sill = 46000, kappa = 0.5
)

vars <- c("c", "p")
custom <- krig(soil_fake, vars, params = params, quiet = TRUE)
#> Gessing: plotdim = c(1000, 460)

# Showing only the first item of the resulting output
to_df(custom)
#> # A tibble: 2,300 x 4
#>    var       x     y     z
#>    <chr> <dbl> <dbl> <dbl>
#>  1 c        10    10  2.29
#>  2 c        30    10  2.31
#>  3 c        50    10  2.22
#>  4 c        70    10  2.04
#>  5 c        90    10  1.79
#>  6 c       110    10  1.54
#>  7 c       130    10  1.55
#>  8 c       150    10  1.64
#>  9 c       170    10  1.77
#> 10 c       190    10  1.89
#> # ... with 2,290 more rows
```

Using automated parameters.

``` r
result <- krig(soil_fake, var = "c", quiet = TRUE)
#> Gessing: plotdim = c(1000, 460)
summary(result)
#> var: c 
#> df
#> Classes 'tbl_df', 'tbl' and 'data.frame':    1150 obs. of  3 variables:
#>  $ x: num  10 30 50 70 90 110 130 150 170 190 ...
#>  $ y: num  10 10 10 10 10 10 10 10 10 10 ...
#>  $ z: num  2.13 2.12 2.1 2.09 2.07 ...
#> 
#> df.poly
#> Classes 'tbl_df', 'tbl' and 'data.frame':    1150 obs. of  3 variables:
#>  $ gx: num  10 30 50 70 90 110 130 150 170 190 ...
#>  $ gy: num  10 10 10 10 10 10 10 10 10 10 ...
#>  $ z : num  2.13 2.12 2.1 2.09 2.07 ...
#> 
#> lambda
#> 'numeric'
#>  num 1
#> 
#> vg
#> 'variogram'
#> List of 20
#>  $ u               : num [1:9] 60.9 86.5 103 122.7 146.1 ...
#>  $ v               : num [1:9] 0.284 0.422 0.882 0.543 0.211 ...
#>  $ n               : num [1:9] 7 9 10 10 18 19 36 34 38
#>  $ sd              : num [1:9] 0.414 0.48 0.633 0.501 0.405 ...
#>  $ bins.lim        : num [1:31] 1.00e-12 2.00 2.38 2.84 3.38 ...
#>  $ ind.bin         : logi [1:30] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ var.mark        : num 0.317
#>  $ beta.ols        : num 1.36e-09
#>  $ output.type     : chr "bin"
#>  $ max.dist        : num 320
#>  $ estimator.type  : chr "classical"
#>  $ n.data          : int 30
#>  $ lambda          : num 1
#>  $ trend           : chr "cte"
#>  $ pairs.min       : num 5
#>  $ nugget.tolerance: num 1e-12
#>  $ direction       : chr "omnidirectional"
#>  $ tolerance       : chr "none"
#>  $ uvec            : num [1:30] 1 2.19 2.61 3.11 3.7 ...
#>  $ call            : language variog(geodata = geodata, breaks = breaks, trend = trend, pairs.min = 5)
#> 
#> vm
#> 'variomodel', variofit'
#> List of 17
#>  $ nugget               : num 0.352
#>  $ cov.pars             : num [1:2] 0 160
#>  $ cov.model            : chr "exponential"
#>  $ kappa                : num 0.5
#>  $ value                : num 4.64
#>  $ trend                : chr "cte"
#>  $ beta.ols             : num 1.36e-09
#>  $ practicalRange       : num 480
#>  $ max.dist             : num 320
#>  $ minimisation.function: chr "optim"
#>  $ weights              : chr "npairs"
#>  $ method               : chr "WLS"
#>  $ fix.nugget           : logi FALSE
#>  $ fix.kappa            : logi TRUE
#>  $ lambda               : num 1
#>  $ message              : chr "optim convergence code: 0"
#>  $ call                 : language variofit(vario = vg, ini.cov.pars = c(initialVal, startRange), cov.model = varModels[i],      nugget = initialVal)
```

[Get started with
**fgeo**](https://forestgeo.github.io/fgeo/articles/fgeo.html)

## Information

  - [Getting help](SUPPORT.md).
  - [Contributing](CONTRIBUTING.md).
  - [Contributor Code of Conduct](CODE_OF_CONDUCT.md).

## Acknowledgements

Thanks to all partners of ForestGEO who shared their ideas and code.
Functions’ authors include Graham Zemunik, Sabrina Russo, Daniel Zuleta,
Matteo Detto, Kyle Harms, Gabriel Arellano.
