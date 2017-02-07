#' Title
#'
#' @param x file name for character method
#' @param varname variable name
#'
#' @return Raster
#' @export
#'
qwad <- function(x, ...) {
  UseMethod("qwad")
}
#' @name qwad
#' @export
qwad.character <- function(x, varname) {
  nc <- ncdump::NetCDF(x)
  if (missing(varname)) varname <- first_md_grid(nc)
  r <- raster::brick(x, varname, stopIfNotEqualSpaced = FALSE)
  raster::setExtent(r, raster::extent(0, raster::nrow(r), 0, raster::ncol(r)))
} 
