library(dplyr)

# buscar por coincidencia exacta
datos |>
  filter(
    stringr::str_detect(textos, "agua|potable|rural")
  ) |>
  head(4)

# buscar con algoritmo de relevancia
datos |>
  mutate(
    puntaje = rbm25::bm25_score(
      textos,
      "agua potable rural"
    )
  ) |>
  arrange(-puntaje) |>
  head(4)
