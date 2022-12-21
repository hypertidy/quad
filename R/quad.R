#' Title
#'
#' @param dimension 
#' @param ydown 
#'
#' @return
#' @export
#'
#' @examples
quad_index <- function(dimension, ydown = TRUE) {
  dimension <- as.integer(dimension)
  quad_index_cpp(dimension[1], dimension[2], ydown)
}

#' Title
#'
#' @param dimension 
#' @param ydown 
#' @param zh 
#'
#' @return
#' @export
#'
#' @examples
quad_vert <- function(dimension, ydown = TRUE, zh = FALSE) {
  dimension <- as.integer(dimension)
  ydown <- as.logical(ydown[1])
  zh <- as.logical(zh[1])
  if (anyNA(dimension)) stop("missing dimension value")
  if (is.na(zh)) zh <- FALSE
  if (is.na(ydown)) ydown <- TRUE
  quad_vert_cpp(dimension[1], dimension[2], ydown, zh)
}

