```
Rutuja ------------------------------------------------------------------
Attaching required data to run the test:
 ## plot data
 ggplot(subset(pick, sp %in% few_sp), aes(x = gx, y = gy)) +
 geom_raster(data = habitat2, aes(x, y, fill = habitats)) +
 geom_point(size = 0.25) +
 coord_fixed() +
 facet_wrap(~ sp) +
 labs(fill = "Habitat")
## try the test:
out <- tt_test(pick, few_sp, habitat2)
Get this error:
 Error in if (spprophab[i] > Torspprophab[i]) { :
     missing value where TRUE/FALSE needed
   In addition: Warning message:
     Values can't be compared:
   spprophab = NaN vs. Torspprophab = NaN
```
