Interpretation of `tt_test()` results
================
Daniel Zuleta

``` r
# Implementation ----------------------------------------------------------

# Create a data frame to interprete the output of `tt_test()`.
tt_interpretation <- function(ttOutput) {
  habs <- dim(ttOutput)[2] / 6 # number of habitats
  tt_interp <- data.frame() # interpretation output
  tt_interp_names <- NULL
  # j is the species loop
  # i is the habitat loop
  
  for (j in 1:dim(ttOutput)[1]) {
    #
    for (i in 1:habs) {
      tt_interp[j, i] <- ifelse(
        ttOutput[j, i * 5] == 1 & (1 - (ttOutput[j, i * 6])) < 0.05,
        "aggregated",
        ifelse(
          ttOutput[j, i * 5] == 1 &
            (1 - (ttOutput[j, i * 6])) >= 0.05,
          "agg_nonsignificant",
          ifelse(
            ttOutput[j, i * 5] == -1 & (ttOutput[j, i * 6]) < 0.05,
            "repelled",
            ifelse(
              ttOutput[j, i * 5] == -1 &
                (ttOutput[j, i * 6]) >= 0.05,
              "rep_nonsignificant",
              "neutral"
            )
          )
        )
      )
    }
  }
  
  for (h in 1:habs) {
    tt_interp_names[h] <- paste("Habitat_", h, sep = "")
  }
  
  tt_interp <- data.frame(cbind(Species = row.names(ttOutput), tt_interp))
  names(tt_interp) <- c("Species", tt_interp_names)
  return(tt_interp)
}


# Creating the input of tt_interpretation ---------------------------------

# Example from ?tt_test()

library(fgeo.habitat)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
# For easier data wranging
habitat <- luquillo_habitat
census <- luquillo_top3_sp

# Pick alive trees, of 10 mm or more
pick <- filter(census, status == "A", dbh >= 10)
# Pick sufficiently abundant trees
pick <- add_count(pick, sp)
pick <- filter(pick, n > 50)

species <- unique(pick$sp)

# Test any number of species (output a list of matrices)
tt_lst <- tt_test(census, species, habitat)

tt_lst
```

    ## [[1]]
    ##        N.Hab.1 Gr.Hab.1 Ls.Hab.1 Eq.Hab.1 Rep.Agg.Neut.1 Obs.Quantile.1
    ## CASARB      25     1489      109        2              0       0.930625
    ##        N.Hab.2 Gr.Hab.2 Ls.Hab.2 Eq.Hab.2 Rep.Agg.Neut.2 Obs.Quantile.2
    ## CASARB      12      168     1431        1              0          0.105
    ##        N.Hab.3 Gr.Hab.3 Ls.Hab.3 Eq.Hab.3 Rep.Agg.Neut.3 Obs.Quantile.3
    ## CASARB      14      567     1029        4              0       0.354375
    ##        N.Hab.4 Gr.Hab.4 Ls.Hab.4 Eq.Hab.4 Rep.Agg.Neut.4 Obs.Quantile.4
    ## CASARB      15      934      661        5              0        0.58375
    ## 
    ## [[2]]
    ##        N.Hab.1 Gr.Hab.1 Ls.Hab.1 Eq.Hab.1 Rep.Agg.Neut.1 Obs.Quantile.1
    ## PREMON      59      389     1208        3              0       0.243125
    ##        N.Hab.2 Gr.Hab.2 Ls.Hab.2 Eq.Hab.2 Rep.Agg.Neut.2 Obs.Quantile.2
    ## PREMON      75     1562       37        1              1        0.97625
    ##        N.Hab.3 Gr.Hab.3 Ls.Hab.3 Eq.Hab.3 Rep.Agg.Neut.3 Obs.Quantile.3
    ## PREMON      56      632      963        5              0          0.395
    ##        N.Hab.4 Gr.Hab.4 Ls.Hab.4 Eq.Hab.4 Rep.Agg.Neut.4 Obs.Quantile.4
    ## PREMON      44      222     1375        3              0        0.13875
    ## 
    ## [[3]]
    ##        N.Hab.1 Gr.Hab.1 Ls.Hab.1 Eq.Hab.1 Rep.Agg.Neut.1 Obs.Quantile.1
    ## SLOBER      14      492     1092       16              0         0.3075
    ##        N.Hab.2 Gr.Hab.2 Ls.Hab.2 Eq.Hab.2 Rep.Agg.Neut.2 Obs.Quantile.2
    ## SLOBER      16      473     1125        2              0       0.295625
    ##        N.Hab.3 Gr.Hab.3 Ls.Hab.3 Eq.Hab.3 Rep.Agg.Neut.3 Obs.Quantile.3
    ## SLOBER      19     1181      415        4              0       0.738125
    ##        N.Hab.4 Gr.Hab.4 Ls.Hab.4 Eq.Hab.4 Rep.Agg.Neut.4 Obs.Quantile.4
    ## SLOBER      17     1151      440        9              0       0.719375
    ## 
    ## attr(,"class")
    ## [1] "tt_lst" "list"

``` r
# Using tt_interpretation -------------------------------------------------

tt_interpretation(tt_lst)
```

    ## Error in 1:dim(ttOutput)[1]: argument of length 0
