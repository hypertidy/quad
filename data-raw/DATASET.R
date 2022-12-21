## code to prepare `DATASET` dataset goes here

#remotes::install_github("hypertidy/whatarelief")
elev <- whatarelief::elevation(dimension = c(360, 180))


usethis::use_data(elev, compress = "xz")
