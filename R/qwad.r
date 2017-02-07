#' Read a gridded variable from a data source. 
#'
#' Provide a `raster::brick` based on input data source
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
  qwad(nc, varname)
} 

#' @name qwad
#' @export
qwad.NetCDF <- function(x, varname) {
  if (missing(varname)) varname <- first_md_grid(nc)
  ## here we use the information stored about a file
  ## but choose the first one in the set, this needs more consideration
  ## once an object could treat multiple files as a single data source
  r <- raster::brick(x$file$filename[1L], varname, stopIfNotEqualSpaced = FALSE)
  raster::setExtent(r, raster::extent(0, raster::nrow(r), 0, raster::ncol(r)))
  
}


#' delete from qwad, keep in angstroms, replace with qwad::find_var_coords or similar
#' Extract coordinate arrays from ROMS. 
#' 
#' Returns a RasterStack of the given variable names. 
#'
#' @param x ROMS file name
#' @param spatial names of coordinate variables (e.g. lon_u, lat_u) 
#' @param ncdf default to NetCDF no matter what file name
#' @param transpose the extents (ROMS is FALSE, Access is TRUE)
#' @param ... unused
#'
#' @return RasterStack with two layers of the 2D-variables
#' @export 
#'
#' @examples
#' \dontrun{
#'   coord <- romscoord("roms.nc")
#' }
#' @importFrom raster stack
romscoords <- function(x, spatial = c("lon_u", "lat_u"), ncdf = TRUE,  transpose = FALSE, ... ) {
  l <- vector("list", length(spatial))
  for (i in seq_along(l)) l[[i]] <- raster(x, varname = spatial[i], ncdf = TRUE, ...)
  if (transpose) {
    l <- lapply(l, function(x) setExtent(x, extent(0, ncol(x), 0, nrow(x))))
  } else {
    l <- lapply(l, function(x) setExtent(x, extent(0, nrow(x), 0, ncol(x))))
  }
  raster::stack(l)
}
