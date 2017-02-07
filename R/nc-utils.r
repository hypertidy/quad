
#' Find the name of the first multi-dimensional grid. 
#' 
#' The first variable name with the maximum number of dimensions is returned. 
#' Optionally a `maxdim` may be set to return the first no larged than that value. 
#'
#' @param x 
#' @param maxdim 
#' @param ... 
first_md_grid <- function(x, maxdim = Inf, ...) {
  UseMethod("first_md_grid")
}
first_md_grid.character <- function(x, maxdim = Inf, ...) {
  first_md_grid(ncdump::NetCDF(x))
}
first_md_grid.NetCDF <- function(x, maxdim = Inf, ...) {
  #return(x$variable)
  v <- x$variable %>% filter(ndims <= maxdim)%>% mutate(dmax = max(ndims)) %>% filter(ndims == dmax) %>% slice(1L)
  v$name[1L]
}


#'  NetCDF variable dimension
#'
#'
#' @param varname variable name
#' @param x file
#' @importFrom dplyr transmute
ncdim <- function(x, varname) {
  roms <- NetCDF(x)
  # ## still exploring neatest way to do this . . .
  vdim <- vars(roms) %>% 
    filter(name == varname) %>% 
    inner_join(roms$vardim, "id") %>% 
    dplyr::transmute(id = dimids) %>% 
    inner_join(dims(roms), "id") 
  vdim$len
}




#' Read the variable as is
#' @export
rawdata <- function(x, varname) {
  return(ncdf4::ncvar_get(ncdf4::nc_open(x), varname))
 }


#' @importFrom ncdf4 nc_open nc_close ncvar_get 
ncget <- function(x, varname) {
  nc <- ncdf4::nc_open(x)
  on.exit(ncdf4::nc_close(nc))
  ncdf4::ncvar_get(nc, varname)
}

ncgetslice <- function(x, varname, start, count) {
  con <- ncdf4::nc_open(x)
  on.exit(ncdf4::nc_close(con))
  ncdf4::ncvar_get(con, varname, start = start, count = count)
}

rastergetslice <- function(x, slice) {
  ## expect slice to be c(xindex, NA, NA) or c(NA, yindex, NA)
  ## all longitudes
  if (is.na(slice[1]))  x1 <-  setExtent(raster(getValuesBlock(x, row = slice[2], nrows = 1)), extent(0, ncol(x), 0, nlayers(x)))
  ## all latitudes
  if (is.na(slice[2]))  x1 <-  setExtent(raster(getValuesBlock(x, col = slice[1], ncols = 1, nrows = nrow(x))), extent(0, nrow(x), 0, nlayers(x)))
  x1
}






## worker functions for ROMS netcdf and R raster
mkget <- function(filename) {
  function(varname, start = NA, count = NA) {
    on.exit(nc_close(handle))
    handle <- nc_open(filename)
    ncvar_get(handle, varname, start, count)
  }
}

applyget <- function(vars) {
  a <- vector("list", length(vars))
  names(a) <- vars
  for (i in seq_along(vars)) a[[vars[i]]] <- getr(vars[i])
  a
}


setIndexExt <- function(x) {
  ex <- extent(1, ncol(x), 1, nrow(x))
  setExtent(x, ex)
}
nctor <- function(x) {
  if (length(dim(x)) == 2) {
    x <- flip(raster(t(x)), "y")
  } else {
    if (length(dim(x)) == 3) x <- flip(brick(x, transpose = TRUE), "y")
  } 
  setIndexExt(x)
}

