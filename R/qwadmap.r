#' Remap an object to the space defined by coordinate arrays. 
#' 
#' Find the nearest-neighbour coordinates of `x` in the coordinate arrays of `coords`. 
#' 
#' The input `coords` is a assumed to be a 2-layer RasterStack or RasterBrick and
#' using `nabor::knn` the nearest matching position of the coordinates of `x` is found in the grid space of `coords`. The
#' motivating use-case is the curvilinear longitude and latitude arrays of ROMS model output, but the original ROMS-specific
#' code is being generalized (other models include CMIP5/6, Bluelink, etc.). 
#' 
#' Cropping is complicated more details . . .
#' @param x object to transform to the grid space, e.g. a \code{\link[sp]{Spatial}} object
#' @param coords qwadcoords RasterStack
#' @param crop logical, if \code{TRUE} crop x to the extent of the boundary of the values in coords
#' @param lonlat logical, if \code{TRUE} check for need to back-transform to longitude/latitude and do it
#' @param ... unused
#'
#' @return input object with coordinates transformed to space of the coords 
#' @export
qwadmap <- function(x, ...) {
  UseMethod("qwadmap")
}

#' @rdname qwadmap
#' @export
#' @importFrom spbabel sptable sp
#' @importFrom nabor knn
#' @importFrom raster intersect as.matrix projection
#' @importFrom sp CRS
qwadmap.SpatialPolygonsDataFrame <- function(x, coords, crop = FALSE, lonlat = TRUE, ...) {
  ## first get the intersection
  if (crop) {
  op <- options(warn = -1)
  x <- raster::intersect(x, tabularaster::boundary(coords))
  options(op)
  }
  ## do we need to invert projection?
  repro <- !raster::isLonLat(x)
  proj <- projection(x)
  tab <- spbabel::sptable(x)
  
  if (repro & !is.na(proj)) {
    llproj <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"
    xy <- proj4::ptransform(cbind(tab$x_, tab$y_, 0), src.proj = proj, dst.proj = llproj, silent = FALSE) * 180 / pi
    ## spbabel standard is attributes with underlines
    tab$x_ <- xy[,1]
    tab$y_ <- xy[,2]
    proj <- llproj
  }
  xy <- as.matrix(coords)
  kd <- nabor::knn(xy, raster::as.matrix(tab[, c("x_", "y_")]), k = 1, eps = 0)
  index <- expand.grid(x = seq(ncol(coords)), y = rev(seq(nrow(coords))))[kd$nn.idx, ]
 tab$x_ <- index$x
  tab$y_ <- index$y
  spbabel::sp(tab, attr_tab = as.data.frame(x), crs = NA_character_)
}

#' @rdname qwadmap
#' @export
qwadmap.SpatialLinesDataFrame <- qwadmap.SpatialPolygonsDataFrame

#' @rdname qwadmap
#' @export
qwadmap.SpatialPointsDataFrame <- qwadmap.SpatialPolygonsDataFrame

qwadmap.sf <- function(x, coords, crop = FALSE, lonlat = TRUE, ...) {
  spx <- try(as(x, "Spatial"), silent = FALSE)
  if (inherits(spx, "try-error")) {
    stop("qwad tried, but cannot convert this sf type yet, see details above ^^")
  }
  qwadmap(spx)
}




