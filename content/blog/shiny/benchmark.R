library(dplyr)
library(arrow)
library(readxl)


setwd("content/blog/shiny")

datos <- read_xlsx("datos.xlsx")

datos |> readr::write_rds("datos.rds")
datos |> arrow::write_parquet("datos.parquet")

resultado <- bench::mark(
  check = FALSE,
  "excel" = readxl::read_xlsx("datos.xlsx"),
  "rds" = readr::read_rds("datos.rds"),
  "parquet" = arrow::read_parquet("datos.parquet")
)

resultado |>
  select(1:7) |>
  knitr::kable()
