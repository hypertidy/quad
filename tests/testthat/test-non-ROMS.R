context("non-ROMS")

test_that("Non-ROMS data can be readed", {
  qwad::qwad("../spatial-cuddles/BLUElink_sst/ocean_tse_sfc_2063_01.nc", "eta_t")
})
