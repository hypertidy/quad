
<!-- README.md is generated from README.Rmd. Please edit that file -->

# quad

<!-- badges: start -->

<a href="https://gitpod.io/#https://github.com/hypertidy/quad.git"> <img
    src="https://img.shields.io/badge/Contribute%20with-Gitpod-908a85?logo=gitpod"
    alt="Try with Gitpod"
  /> </a>
[![R-CMD-check](https://github.com/hypertidy/quad/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/hypertidy/quad/actions/workflows/R-CMD-check.yaml)
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

ib <- quad_index(dm)
vb <- quad_vert(dm)
str(ib)
#>  int [1:259200] 362 361 0 1 723 722 361 362 1084 1083 ...
str(vb)
#>  num [1:130682] 0 1 0.00278 1 0.00556 ...
```

That is the basis for building a partly expanded quadmesh, and it is
fast.

``` r
##previous we might have used anglr
system.time(anglr::as.mesh3d(elev))
#>    user  system elapsed 
#>   0.029   0.028   0.059

## what if it was much bigger
el <- elev[seq(1, nrow(elev), length.out = 3600), seq(1, ncol(elev), length.out = 1800)]
system.time(m3d <- anglr::as.mesh3d(el))
#>    user  system elapsed 
#>   6.336   2.052   8.390
str(m3d)
#> List of 6
#>  $ vb       : num [1:4, 1:6485401] 0 0 -3522 1 1 ...
#>  $ material :List of 1
#>   ..$ color: chr [1:6480000] "#F8D074" "#F8D074" "#F8D074" "#F8D074" ...
#>  $ normals  : NULL
#>  $ texcoords: NULL
#>  $ meshColor: chr "faces"
#>  $ ib       : int [1:4, 1:6480000] 1 2 3603 3602 2 3 3604 3603 3 4 ...
#>  - attr(*, "class")= chr [1:2] "mesh3d" "shape3d"

## when we use {quad} we have access to the intermediate steps

system.time({
  vb <- quad_vert(c(3600, 1800))
  vb <- rbind(matrix(vb, nrow = 2), z = 0.0, h = 1.0)
  vb[,1] <- scales::rescale(vb[,1], c(-180, 180))
  vb[,2] <- scales::rescale(vb[,2], c(-90, 90))

  ib <- matrix(quad_index(c(3600, 1800), ydown = TRUE), nrow = 4L)
  
  ## ok still WIP but you see where we're going, anglr needed a 
  ## RasterLayer *object* just to get that extent scaling (!!!), when
  ## we don't even need an array (it's just dim+extent)
  ## this is faster and it scales to generic workflows   
  
})
#>    user  system elapsed 
#>   0.470   0.462   0.931

str(vb)
#>  num [1:4, 1:6485401] -180 180 -180 180 -90 ...
#>  - attr(*, "dimnames")=List of 2
#>   ..$ : chr [1:4] "" "" "z" "h"
#>   ..$ : NULL
str(ib)
#>  int [1:4, 1:6480000] 3602 3601 0 1 7203 7202 3601 3602 10804 10803 ...
```

## TODO

-   [x] Mercury
-   [ ] ensure alignment of anglr and quad and control with ydown and
    comparison to rgl is sane and easy
-   [ ] provide flat, matrix, dataframe versions of each output (and
    compare with {geometries})
-   [ ] bridge to {textures} and other packages that are for specific
    outputs (mesh3d, and various 3D formats, and just plotting with
    vectorized grid.polygon)

## Code of Conduct

Please note that the quad project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
