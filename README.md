
<!-- README.md is generated from README.Rmd. Please edit that file -->

# quad

<!-- badges: start -->
<!-- badges: end -->

The goal of quad is to provide a framework for fleshing out
raster-origin mesh geometry when needed.

## Installation

You can install the development version of quad from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("hypertidy/quad")
```

## Example

This is a basic example which shows you how to expand out the grid when
you really need to.

What is a grid? A *raster* is a six-number specification, *dimension*
and *extent*.

Let’s say we have set of raster data, a matrix in R with *ncols*,
*nrows* and an extent.

``` r
library(quad)

(dm <- dim(elev)[2:1])
#> [1] 360 180

qm <- quad:::qtest(dm)
```

That is the basis for building a partly expanded quadmesh, and it is
fast.

``` r
##previous we might have used anglr
system.time(anglr::as.mesh3d(elev))
#>    user  system elapsed 
#>  10.287   0.004  10.300

## what if it was much bigger
el <- elev[seq(1, nrow(elev), length.out = 3600), seq(1, ncol(elev), length.out = 1800)]
system.time(anglr::as.mesh3d(el))
#>    user  system elapsed 
#>   5.803   2.954   8.772


## when we use {quad} we have access to the intermediate steps

system.time({
  q <- quad:::qtest(c(3600, 1800))
  vb <- matrix(q, nrow = 4)
  vb[,1] <- scales::rescale(vb[,1], c(-180, 180))
  vb[,2] <- scales::rescale(vb[,2], c(-90, 90))
  
  ## ok still WIP but you see where we're going, anglr needed a 
  ## RasterLayer *object* just to get that extent scaling (!!!)
  ## this is faster and it scales to generic workflows   
})
#>    user  system elapsed 
#>   0.256   0.267   0.523
```

## Code of Conduct

Please note that the quad project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
