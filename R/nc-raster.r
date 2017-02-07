#' rename to qwaddata, but also see overlap with ncraster below
#' Extract a data layer from ROMS by name and slice. 
#' 
#' Maybe this replaced by rastergetslice??
#' Returns a single slice 2D layer
#'
#' (This was called angstroms::romsdata). 
#' @param x ROMS file name
#' @param varname name of ROMS variable 
#' @param slice index in w and t (depth and time), defaults to first encountered
#' @param transpose the extents (ROMS is FALSE, Access is TRUE)
#' @param ... unused
#' @param ncdf default to \code{TRUE}, set to \code{FALSE} to allow raster format detection brick
#'
#' @return RasterLayer
#' @export
#'
romsdata <- function (x, varname, slice = c(1, 1), ncdf = TRUE, transpose = FALSE, ...) 
{
  stopifnot(!missing(varname))
  x0 <- try(brick(x, level = slice[1L], varname = varname, ncdf = ncdf, ...), silent = TRUE)
  if (inherits(x0, "try-error")) {
    ## 
    stop(sprintf("%s is not multi-dimensional/interpretable as a RasterLayer, try extracting in raw form with rawdata()", varname))
    
  }
  x <- x0[[slice[2L]]]
  if (transpose) {
    e <- extent(0, ncol(x), 0, nrow(x)) 
  } else {
    e <- extent(0, nrow(x), 0, ncol(x))
  }
  setExtent(x, e)
}

#' Read an arbitrary 2D or 3D slice from NetCDF as a RasterBrick
#' 
#' (This was in angstroms::ncraster)
#' @param x ROMS file name
#' @param varname variable name
#' @param slice index, specified with NA for the index to read all steps
#' @importFrom dplyr %>% 
#' @export
ncraster <- function(x, varname, slice = NA) {
  nc <- ncdump::NetCDF(x)
  vd <- ## how is order controlled here?
    ncdump::vars(nc) %>% filter(name == varname) %>% 
    inner_join(nc$vardim, "id") %>% transmute(vid = id, id = dimids) %>% 
    inner_join(ncdump::dims(nc), "id")
  ## if slice is NA, we get all
  start <- ifelse(is.na(slice), 1, slice)
  count <- ifelse(is.na(slice), vd$len, 1)
  # print(start)
  #  print(count)
  a <- ncgetslice(x, varname, start, count)
  if (length(dim(a)) == 2) {
    a <- a[, ncol(a):1 ]
    a <- setExtent(raster(t(a)), extent(0, nrow(a), 0, ncol(a)))
  } else {
    a <- a[,ncol(a):1,]
    a <- setExtent(brick(a,  transpose = TRUE)  , extent(0, nrow(a), 0, ncol(a)))
  }
  a
}


