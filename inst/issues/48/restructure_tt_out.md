Restructure tt\_test() output for easier manipulation
================

This document explores a new structure for the output of `tt_test()` for
easier manipulation and visualization.

Setup.

``` r
library(fgeo)
## -- Attaching packages ------------------------------------------- fgeo 0.0.0.9000 --
## v fgeo.abundance  0.0.0.9004     v fgeo.demography 0.0.0.9000
## v fgeo.base       0.0.0.9001     v fgeo.habitat    0.0.0.9006
## v fgeo.data       0.0.0.9002     v fgeo.map        0.0.0.9204
## v fgeo.abundance  0.0.0.9004     v fgeo.tool       0.0.0.9003
## 
```

Original output.

``` r
census <- filter(luquillo_top3_sp, status == "A", dbh >= 10)
habitat <- luquillo_habitat
species <- c("CASARB", "PREMON", "SLOBER")

tt_df <- to_df(tt_test(census, species, habitat))
tt_df
## # A tibble: 12 x 9
##    habitat sp    probability distribution stem_count Eq.Hab Gr.Hab Ls.Hab
##    <chr>   <chr>       <dbl> <chr>             <dbl>  <dbl>  <dbl>  <dbl>
##  1 1       CASA~      0.931  neutral              25      2   1489    109
##  2 1       PREM~      0.243  neutral              59      3    389   1208
##  3 1       SLOB~      0.308  neutral              14     16    492   1092
##  4 2       CASA~      0.105  neutral              12      1    168   1431
##  5 2       PREM~      0.0238 aggregated           75      1   1562     37
##  6 2       SLOB~      0.296  neutral              16      2    473   1125
##  7 3       CASA~      0.354  neutral              14      4    567   1029
##  8 3       PREM~      0.395  neutral              56      5    632    963
##  9 3       SLOB~      0.738  neutral              19      4   1181    415
## 10 4       CASA~      0.584  neutral              15      5    934    661
## 11 4       PREM~      0.139  neutral              44      3    222   1375
## 12 4       SLOB~      0.719  neutral              17      9   1151    440
## # ... with 1 more variable: Obs.Quantile <dbl>
```

This output is easy to visualize:

``` r
plot(tt_df)
```

![](restructure_tt_out_files/figure-gfm/plot-1.png)<!-- -->

This output is also easy to manipulate, for example, to count the number
of species in each `distribution`-category by `habitat`:

``` r
count(tt_df, habitat, distribution)
## # A tibble: 5 x 3
##   habitat distribution     n
##   <chr>   <chr>        <int>
## 1 1       neutral          3
## 2 2       aggregated       1
## 3 2       neutral          2
## 4 3       neutral          3
## 5 4       neutral          3
```

This does the same thing. It is more verbose but it may be eaiser to see
what’s going on.

``` r
tt_df %>% 
  group_by(habitat, distribution) %>% 
  summarise(n = n_distinct(sp))
## Warning in summarise_impl(.data, dots): hybrid evaluation forced for
## `n_distinct`. Please use dplyr::n_distinct() or library(dplyr) to remove
## this warning.
## # A tibble: 5 x 3
## # Groups:   habitat [?]
##   habitat distribution     n
##   <chr>   <chr>        <int>
## 1 1       neutral          3
## 2 2       aggregated       1
## 3 2       neutral          2
## 4 3       neutral          3
## 5 4       neutral          3
```

### Check

Confirm with Daniel that I’m calculating the probabilities correctly.
The comments in the next chunk of code come from the interpretation
section of `?tt_test()`.

``` r
probability <- select(tt_df, Obs.Quantile, distribution, probability)

# Note that to calculate the probability for repelled, it is the value given
filter(probability, distribution != "aggregated")
## # A tibble: 11 x 3
##    Obs.Quantile distribution probability
##           <dbl> <chr>              <dbl>
##  1        0.931 neutral            0.931
##  2        0.243 neutral            0.243
##  3        0.308 neutral            0.308
##  4        0.105 neutral            0.105
##  5        0.296 neutral            0.296
##  6        0.354 neutral            0.354
##  7        0.395 neutral            0.395
##  8        0.738 neutral            0.738
##  9        0.584 neutral            0.584
## 10        0.139 neutral            0.139
## 11        0.719 neutral            0.719

# ... but to calculate the probability for aggregated, it is 1- the value given
filter(probability, distribution == "aggregated")
## # A tibble: 1 x 3
##   Obs.Quantile distribution probability
##          <dbl> <chr>              <dbl>
## 1        0.976 aggregated        0.0238
```
