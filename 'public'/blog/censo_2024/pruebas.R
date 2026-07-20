
# Cruzar hogares con personas


library(dplyr)
library(tidyr)
library(arrow)

# cargar ----
comunas <- readxl::read_xlsx("datos/diccionario_variables_censo2024.xlsx",
                             sheet = "codigos_territoriales") |> 
  select(comuna = 1, nombre_comuna = 3)

personas <- open_dataset("datos/personas_censo2024.parquet")

hogares <- open_dataset("datos/hogares_censo2024.parquet")


# personas: seleccionar columnas
personas_filt <- personas |>
  select(id_vivienda, id_hogar, comuna, parentesco,
         sexo, edad_quinquenal)

# hogares: seleccionar columnas
hogares_filt <- hogares |>
  select(id_vivienda, id_hogar, comuna, p12_tenencia_viv)

# cruzar ambas bases por hogar/vivienda/comuna
personas_hogares <- personas_filt |> 
  left_join(hogares_filt, 
            join_by(id_vivienda, id_hogar, comuna))
# resultado: base de personas con datos de la vivienda donde viven

# conteo ----
conteo <- personas_hogares |> 
  group_by(comuna, sexo, edad_quinquenal, parentesco, p12_tenencia_viv) |> 
  summarize(n = n()) |> 
  ungroup() |> 
  collect() # carga a memoria de los datos


# recodificación ----
conteo_recod <- conteo |> 
  mutate(parentesco = recode_values(
    parentesco,
    1 ~	"Jefe/a de hogar",
    2 ~	"Esposo/a o cónyuge",
    default = "Otros")) |> 
  mutate(sexo = recode_values(
    sexo, 
    1 ~ "Hombre", 
    2 ~ "Mujer")) |> 
  mutate(p12_tenencia_viv = recode_values(
    p12_tenencia_viv, 
    1 ~ "Propia pagada",
    2 ~ "Propia pagándose",
    3 ~ "Arrendada con contrato",
    4 ~ "Arrendada sin contrato",
    5 ~ "Cedida por trabajo o servicio",
    6 ~ "Cedida por familiar u otro",
    7 ~ "Usufructo: solo uso y goce",
    8 ~ "Ocupada de hecho",
    9 ~ "Propiedad en sucesión o litigio")) |> 
  mutate(propiedad = if_else(
    p12_tenencia_viv %in% c("Propia pagada", "Propia pagándose"), 
    "Propia", "No propia")) |> 
  mutate(mayor = case_when(sexo == "Hombre" & edad_quinquenal >= 65 ~ "Adulto mayor", 
                           sexo == "Mujer" & edad_quinquenal >= 60 ~ "Adulto mayor",
                           .default = "No adulto mayor")) |> 
  left_join(comunas, by = "comuna") |> 
  relocate(nombre_comuna, .before = comuna)


# resultados ----  


# porcentaje de viviendas de propiedad del jefe de hogar según edad
conteo_recod |> 
  filter(parentesco == "Jefe/a de hogar",
         propiedad == "Propia") |> 
  group_by(nombre_comuna, mayor, propiedad) |> 
  summarize(n = sum(n)) |> 
  ungroup() |> 
  pivot_wider(names_from = mayor, values_from = n,
              values_fill = 0) |> 
  group_by(nombre_comuna) |> 
  mutate(adulto_mayor_porcentaje = `Adulto mayor` / (`Adulto mayor` + `No adulto mayor`) * 100)
# de las viviendad que son propias, en algarrobo 53.7% son de jefatura de un adulto mayor


# porcentaje de viviendas de jefe de hogar adulto mayor que son propias
conteo_recod |> 
  filter(parentesco == "Jefe/a de hogar",
         mayor == "Adulto mayor") |> 
  group_by(nombre_comuna, mayor, propiedad) |> 
  summarize(n = sum(n)) |> 
  ungroup() |> 
  pivot_wider(names_from = propiedad, values_from = n,
              values_fill = 0) |> 
  group_by(nombre_comuna) |> 
  mutate(propiedad_porcentaje = `Propia` / (`No propia` + Propia) * 100)
# de las viviendas donde la jefatura de hogar es adulto mayor, en algarrobo 78% son propias


# jefes de hogar, porcentaje de viviendas propias de adultos mayores por sexo
conteo_recod |> 
  filter(parentesco == "Jefe/a de hogar",
         propiedad == "Propia",
         mayor == "Adulto mayor") |> 
  group_by(nombre_comuna, sexo, mayor, propiedad) |> 
  summarize(n = sum(n)) |> 
  ungroup() |> 
  pivot_wider(names_from = sexo, values_from = n) |> 
  group_by(nombre_comuna) |> 
  mutate(Hombre_porcentaje = Hombre / (Hombre + Mujer) * 100,
         Mujer_porcentaje = Mujer / (Hombre + Mujer) * 100)
# de las viviendas propias donde la jefatura de hogar es adulto mayor, en algarrobo 54.1% son hombres y 45.9% son mujeres


# porcentaje de hogares por comuna que son propios
hogares_filt |> 
  group_by(comuna, p12_tenencia_viv) |> 
  summarize(n = n()) |> 
  ungroup() |> 
  collect() |> 
  mutate(p12_tenencia_viv = recode_values(
    p12_tenencia_viv, 
    1 ~ "Propia",
    2 ~ "Propia",
    default = "No propia")) |> 
  group_by(comuna, p12_tenencia_viv) |> 
  summarize(n = sum(n)) |> 
  pivot_wider(names_from = p12_tenencia_viv, values_from = n,
              values_fill = 0) |> 
  group_by(comuna) |> 
  mutate(propia_porcentaje = Propia / (Propia + `No propia`) * 100) |> 
  left_join(comunas, by = "comuna") |> 
  relocate(nombre_comuna, .before = comuna)
# en iquique, 41% de los hogares son propios



# porcentaje de hogares donde viven adultos mayores, según propiedad
hogares_adulto_mayor <- personas_filt |> 
  select(comuna, id_vivienda, id_hogar, comuna, edad_quinquenal, sexo) |>
  mutate(sexo = case_when(
    sexo == 1 ~ "Hombre", 
    sexo == 2 ~ "Mujer")) |> 
  mutate(mayor = case_when(sexo == "Hombre" & edad_quinquenal >= 65 ~ "Adulto mayor", 
                           sexo == "Mujer" & edad_quinquenal >= 60 ~ "Adulto mayor",
                           .default = "No adulto mayor")) |> 
  group_by(comuna, id_vivienda, id_hogar) |> 
  mutate(hogar_con_adulto_mayor = if_else(any(mayor == "Adulto mayor"), "Adulto mayor", "Sin adulto mayor")) |> 
  ungroup() |> 
  distinct(comuna, id_vivienda, id_hogar, hogar_con_adulto_mayor) |> 
  collect()

hogares_adulto_mayor_propiedad <- hogares_filt |> 
  left_join(hogares_adulto_mayor, by = c("id_vivienda", "id_hogar", "comuna")) |> 
  mutate(p12_tenencia_viv = case_when(
    p12_tenencia_viv == 1 ~ "Propia",
    p12_tenencia_viv == 2 ~ "Propia",
    .default = "No propia")) |> 
  group_by(comuna, hogar_con_adulto_mayor, p12_tenencia_viv) |> 
  summarize(n = n()) |> 
  ungroup() |> 
  collect() |> 
  arrange(comuna, hogar_con_adulto_mayor, p12_tenencia_viv) |>
  left_join(comunas, by = "comuna") |> 
  relocate(nombre_comuna, .before = comuna)

# porcentaje de hogares con presencia de adultos mayores según propiedad
hogares_adulto_mayor_propiedad |> 
  arrange(comuna, p12_tenencia_viv, hogar_con_adulto_mayor) |>
  group_by(comuna, p12_tenencia_viv) |> 
  mutate(porcentaje_adulto_mayor = n/sum(n)) |> 
  select(comuna, nombre_comuna, p12_tenencia_viv, hogar_con_adulto_mayor, porcentaje_adulto_mayor) |> 
  pivot_wider(names_from = hogar_con_adulto_mayor, values_from = porcentaje_adulto_mayor)
# en iquique, de los hogares propios, un 49.4% tiene adultos mayores

# porcentaje de propiedad de hogares según presencia de adultos mayores
hogares_adulto_mayor_propiedad |> 
  group_by(comuna, hogar_con_adulto_mayor) |> 
  mutate(porcentaje_propia = n/sum(n)) |> 
  select(comuna, nombre_comuna, hogar_con_adulto_mayor, p12_tenencia_viv, porcentaje_propia) |> 
  pivot_wider(names_from = p12_tenencia_viv, values_from = porcentaje_propia)
# en Iquique, ed los hogares con adultos mayores, un 67.0% son propios





# tablas ----

# hogares con o sin presencia de adultos mayores
tabla_hogares_presencia <- hogares_adulto_mayor_propiedad |> 
  pivot_wider(names_from = c(p12_tenencia_viv, hogar_con_adulto_mayor), 
              values_from = n, names_sep = "/",
              values_fill = 0) |> 
  filter(comuna != 12202)

# personas que viven en hogares con propiedad
tabla_personas <- conteo_recod |> 
  group_by(nombre_comuna, comuna, propiedad, mayor) |>
  summarize(n = sum(n)) |> 
  pivot_wider(names_from = c(propiedad, mayor), 
              values_from = n, names_sep = "/",
              values_fill = 0) |> 
  filter(comuna != 12202)

# personas que son jefes de hogar en hogares con equis propiedad
tabla_jefes_hogar <- conteo_recod |> 
  filter(parentesco == "Jefe/a de hogar") |>
  group_by(nombre_comuna, comuna, propiedad, mayor) |>
  summarize(n = sum(n)) |> 
  pivot_wider(names_from = c(propiedad, mayor), 
              values_from = n, names_sep = "/",
              values_fill = 0) |> 
  filter(comuna != 12202)

tabla_hogares_presencia
tabla_personas
tabla_jefes_hogar

# guardar en excel
writexl::write_xlsx(
  list("Hogares con o sin adultos mayores" = tabla_hogares_presencia,
       "Personas" = tabla_personas,
       "Personas jefatura de hogar" = tabla_jefes_hogar),
  path = "resultados/tablas_conteos.xlsx")
