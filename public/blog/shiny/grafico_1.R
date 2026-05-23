library(dplyr)
library(readxl)
library(forcats)

datos <- read_xlsx("content/blog/shiny/datos.xlsx")

region_elegida = "Biobío"

datos_region <- datos |> 
  filter(region == region_elegida)

datos_region_grafico <- datos_region |> 
  slice_max(hogares, n = 6) |> 
  mutate(nombre = fct_reorder(nombre, hogares))

# datos_region |> 
#   ggplot() +
#   aes(hogares, area) +
#   geom_point()

library(ggplot2)


theme_set(
  theme_minimal(
    base_family = "Atkinson Hyperlegible",
    # paper = "#EAD2FA",
    # ink = "#553A74",
    # accent = "#6E3A98"
  ) +
    theme(
      axis.title.y = element_blank(),
      axis.text.y = element_text(face = "bold")
    )
)

datos_region_grafico |> 
  ggplot() +
  aes(hogares, nombre) +
  geom_col(width = 0.7) +
  geom_text(
    aes(label = hogares),
    hjust = 1.3, color = "white", fontface = "bold") +
  scale_x_continuous(expand = 0) 

ggsave(filename = "content/blog/shiny/grafico_1.jpg")
