
<!-- README.md is generated from README.Rmd. Please edit that file -->
qwad
====

WIP

rancid previously made useable versions of NetCDF metadata in tibble form

angstroms created tools to work with irregular grids in ROMS.

The rancid "ncdump" output is now in "ncdump"

The irregular grid tools will live in qwad.

angstroms will leverage ncdump and qwad.

See tabularaster for an independent model for organizing grids like these. A future version will try to merge these two ways of working.

Installation
------------

You can install qwad from github with:

``` r
# install.packages("devtools")
devtools::install_github("AustralianAntarcticDivision/qwad")
```

Example
-------

This is a basic example which shows you how to solve a common problem:

``` r
## basic example code
```

qwad
----

Qwad aims to make working with general grids as easy as possible and less *awkward*. Rather than deal explicitly with the complexity of grids directly, the approach simplifies this by:

-   maintaining the internal index of as the default *georeferencing*
-   providing tools to convert external data data (maps, transects, points, etc.) into the native internal index space of grids
-   providing tools to read arbitrary slices from the grids (either 2D or 3D) as Raster objects
-   providing tools to recover the original full coordinates as needed

In combination these allow extraction and query from general grids output very easily.

The ability to deal with time series across multiple files is still in development, though can be used simply now with standard loops.
