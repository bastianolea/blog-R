library(dplyr)

datos <- tribble(
  ~animal   , ~patas   , ~lindura , ~color    ,
  "mapache" , "4"      ,      100 , "gris"    ,
  "gato"    , "80"     ,       90 , "negro"   ,
  "pollo"   , "2"      , NA       , "plumas"  ,
  "rata"    , "cuatro" ,       90 , "#CCCCCC"
)

library(testthat)

test_that("suficientes columnas", expect_equal(ncol(datos), 4))

test_that("más de 2 columnas", expect_gt(ncol(datos), 2))

test_that("más de 2 filas", expect_true(nrow(datos) > 2))

test_that(
  "columnas mínimas presentes",
  expect_all_true(c("animal", "patas") %in% names(datos))
)

test_that("columnas tipo texto", expect_type(datos$animal, "character"))

test_that("columnas tipo numérico", expect_type(datos$patas, "numeric"))

test_that(
  "colores factibles",
  expect_in(datos$color, c("negro", "gris", "blanco", "amarillo", "café"))
)
