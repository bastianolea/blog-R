library(readxl)
library(dplyr)
library(janitor)

pobreza <- read_xlsx("datos/sae_ingresos_2024.xlsx")

# limpiar columnas
pobreza <- pobreza |>
  row_to_names(2) |>
  clean_names() |>
  rename(
    poblacion = numero_de_personas_segun_proyecciones_de_poblacion,
    pobreza_personas = numero_de_personas_en_situacion_de_pobreza_de_ingresos,
    pobreza_porcentaje = porcentaje_de_personas_en_situacion_de_pobreza_de_ingresos_2024,
    pobreza_porcentaje_inf = limite_inferior,
    pobreza_porcentaje_sup = limite_superior
  )

# convertir a numéricos
pobreza <- pobreza |>
  mutate(
    across(
      c(poblacion, starts_with("pobreza")),
      as.numeric
    )
  )

library(territorial)

# limpiar comunas
pobreza <- pobreza |>
  filter_out(is.na(nombre_comuna)) |>
  select(-region, -nombre_comuna) |>
  mutate(codigo_comuna = as.numeric(codigo)) |>
  select(-codigo) |>
  contextualizar(codigo_comuna)

pobreza |>
  readr::write_csv("datos/pobreza_ingresos_2024.csv")

# pobreza
#
#
# pobreza |>
#   select(1:6) |>
#   head(n = 10) |>
#   knitr::kable()
