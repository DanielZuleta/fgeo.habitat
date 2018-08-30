
<!-- README.md is generated from README.Rmd. Please edit that file -->

# <img src="https://i.imgur.com/vTLlhbp.png" align="right" height=88 /> Analize soils and tree-habitat associations

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/forestgeo/fgeo.habitat.svg?branch=master)](https://travis-ci.org/forestgeo/fgeo.habitat)
[![Coverage
status](https://coveralls.io/repos/github/forestgeo/fgeo.habitat/badge.svg)](https://coveralls.io/r/forestgeo/fgeo.habitat?branch=master)
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
library(fgeo.tool)
#> 
#> Attaching package: 'fgeo.tool'
#> The following object is masked from 'package:stats':
#> 
#>     filter
library(fgeo.habitat)

# Krige soil data
result <- krig(soil_fake, var = c("c", "p"), quiet = TRUE)
#> Gessing: plotdim = c(1000, 460)
head(to_df(result))
#>   var   x  y        z
#> 1   c  10 10 2.134696
#> 2   c  30 10 2.119651
#> 3   c  50 10 2.104591
#> 4   c  70 10 2.089517
#> 5   c  90 10 2.074427
#> 6   c 110 10 2.059322

tail(to_df(result))
#>      var   x   y        z
#> 2295   p 890 450 5.835048
#> 2296   p 910 450 5.826698
#> 2297   p 930 450 5.819219
#> 2298   p 950 450 5.812612
#> 2299   p 970 450 5.806876
#> 2300   p 990 450 5.802012
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
