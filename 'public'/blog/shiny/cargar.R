library(dplyr)
library(readxl)

datos <- read_xlsx("content/blog/shiny/datos.xlsx")


datos |> 
  filter(region == "Maule") |> 
  nrow()

