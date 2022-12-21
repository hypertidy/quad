#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @useDynLib quad, .registration = TRUE
## usethis namespace: end
NULL


#' Elevation data
#' 
#' An elevation data set of the world. 
#' 
#' A matrix of 360x180 with elevation values for the world on the extent
#' 'c(xmin = -180, xmax = 180, ymin = -90, ymax = 90)'. The data is in "raster-order", i.e. 
#' the order used by [rasterImage()]. See the  [ximage package](https://github.com/hypertidy/ximage) 
#' for convenient visualization. 
#' 
#' Data obtained from GEBCO 2021, see the 'data-raw/' folder for details. 
#' @name elev
#' @docType data
#' 
NULL