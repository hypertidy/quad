qtest <- function(dimension, ydown = TRUE) {
  dimension <- as.integer(dimension)
  qtest_cpp(dimension[1], dimension[2], ydown)
}