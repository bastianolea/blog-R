---
title: Cargar datos del Censo de Población y Vivienda 2024 con R
author: Bastián Olea Herrera
date: '2026-04-08'
slug: []
draft: true
categories:
  - Tutoriales
tags:
  - datos
  - chile
format:
  hugo-md:
    output-file: index
    output-ext: md
execute:
  warning: false
---

<!---
https://bastianolea.rbind.io/blog/mapas_censo_2024/
--->

Una de las dificultades más frecuentes en el análisis de datos es poder acceder a datos censales. Los censos suelen ser bases de datos de **varios millones de observaciones**, lo que suele ser demasiado para la mayoría de los computadores, o bien algo imposible con programas como Excel.

En este tutorial veremos cómo cargar los datos del [Censo de Población y Vivienda 2024](https://censo2024.ine.gob.cl) con R para poder acceder a bases de datos de millones de observaciones sin colapsar nuestros computadores.

También veremos cómo **consultar información a nivel comunal** desde el censo, y a **cruzar las bases de personas y hogares**. 


## Descargar datos del Censo

Lo primero que haremos es **descargar** los datos del Censo, [disponibles en su sitio oficial.](https://censo2024.ine.gob.cl)

{{< boton "Resultados Censo 2024" "https://censo2024.ine.gob.cl/resultados/" "fas fa-file-download" >}}

En esta página se listan todos los archivos de resultados. 

Vamos a descargar el archivo _Base de microdatos - Viviendas, hogares, personas Censo 2024 (parquet) – zip, 377 MB_. 

Este archivo viene comprimido, y dentro trae los datos en formato **Parquet**, que es un formato moderno y **optimizado para grandes volúmenes de datos.**

El Censo viene en tres niveles de información:
- **Viviendas**
- **Hogares**
- **Personas**

Partiremos cargando los datos de nivel personas, que es la base más grande de las tres, dado que tiene **una fila por cada habitante de Chile.**


## Cargar datos del Censo

Para cargar los datos en formato Parquet usaremos el [paquete de R `{arrow}`](https://arrow.apache.org/docs/r/), que necesitamos instalar con la siguiente línea:

```r
install.packages("arrow")
```

Una vez instalado, **leemos el Censo como una base de datos** con la función `open_dataset()`.

{{< detalles "¿Qué significa cargar los datos como base de datos?" >}}

Normalmente los datos se cargan en la **memoria** del computador. Si los datos son muy grandes y no caben a la memoria, **el computador colapsa** o se niega a cargar los datos. Pero cuando trabajamos mediante **bases de datos**, los datos no se cargan en la memoria, sino que se representan en una **versión optimizada**, capaz de realizar **operaciones más eficientes** y de copiar los datos a la memoria **solamente cuando se necesiten**. Esto nos permite **trabajar con datos que normalmente no cabrían en nuestra memoria.**

{{< /detalles >}}

```r
library(arrow) # para cargar datos .parquet

# cargar censo como base de datos
personas <- open_dataset("personas_censo2024.parquet")
```


```
## Warning: package 'arrow' was built under R version 4.4.3
```

```
## 
## Attaching package: 'arrow'
```

```
## The following object is masked from 'package:utils':
## 
##     timestamp
```

Si intentamos ver los datos cargados, encontraremos que no tenemos un _dataframe_ normal:


``` r
personas 
```

```
## FileSystemDataset with 1 Parquet file
## 63 columns
## id_vivienda: int32
## id_hogar: int32
## id_persona: int32
## region: int32
## provincia: int32
## comuna: int32
## comuna_bajo_umbral: int32
## area: int32
## tipo_operativo: int32
## sexo: int32
## edad: int32
## edad_quinquenal: int32
## parentesco: int32
## p23_est_civil: int32
## p24_lug_resid5: int32
## p24_lug_resid5_esp: int32
## p25_lug_nacimiento: int32
## p25_lug_nacimiento_rec: int32
## p25_lug_nacimiento_esp: int32
## p26_llegada_periodo: int32
## ...
## 43 more columns
## Use `schema()` to see entire schema
```
En lugar de eso, tenemos una base de datos que **representa** los datos del censo, pero que **no los carga** en la memoria. 

Sin embargo, podemos usar todas las funciones de `{dplyr}` para trabajar con los datos como normalmente hacemos, solo que al terminar las operaciones podemos obtener una **previsualización** del resultado, o bien, podemos **cargar el resultado a la memoria** con la función `collect()`, tomando **precauciones** para no cargar casi 19 millones de filas por accidente.


``` r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

``` r
personas |> 
  select(comuna, area, sexo, edad) |> # seleccionar columnas
  head() |> # cargar solamente las primeras filas
  collect() # traer a memoria
```

```
## # A tibble: 6 × 4
##   comuna  area  sexo  edad
##    <int> <int> <int> <int>
## 1   5802     1     2    80
## 2   5802     1     1    52
## 3   5802     1     2    45
## 4   5802     1     2     8
## 5   4303     2     1    69
## 6   4303     2     2    65
```


Para ver la estructura de la base de datos, usamos `glimpse()` de `{dplyr}`:


``` r
glimpse(personas)
```

```
## FileSystemDataset with 1 Parquet file
## 18,480,432 rows x 63 columns
## $ id_vivienda              <int32> 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 6, …
## $ id_hogar                 <int32> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
## $ id_persona               <int32> 1, 2, 3, 4, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 1, …
## $ region                   <int32> 5, 5, 5, 5, 4, 4, 4, 11, 11, 11, 1, 1, 1, 8, …
## $ provincia                <int32> 58, 58, 58, 58, 43, 43, 43, 112, 112, 112, 11…
## $ comuna                   <int32> 5802, 5802, 5802, 5802, 4303, 4303, 4303, 112…
## $ comuna_bajo_umbral       <int32> 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 2, 2, 2, 2, 2, …
## $ area                     <int32> 1, 1, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, …
## $ tipo_operativo           <int32> 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, …
## $ sexo                     <int32> 2, 1, 2, 2, 1, 2, 1, 2, 1, 1, 1, 2, 1, 2, 1, …
## $ edad                     <int32> 80, 52, 45, 8, 69, 65, 58, -66, -66, -66, 73,…
## $ edad_quinquenal          <int32> 80, 50, 45, 5, 65, 65, 55, 30, 55, 5, 70, 70,…
## $ parentesco               <int32> 1, 11, 5, 12, 9, 7, 1, 1, 4, 5, 1, 2, 5, 1, 5…
## $ p23_est_civil            <int32> 6, 8, 8, NA, 1, 1, 8, 2, 2, NA, 1, 1, 8, 8, 8…
## $ p24_lug_resid5           <int32> 3, 2, 2, 2, 3, 3, 2, 3, 2, 3, 2, 2, 2, 2, 2, …
## $ p24_lug_resid5_esp       <int32> 13117, 5802, 5802, 5802, 4301, 4301, 4303, 10…
## $ p25_lug_nacimiento       <int32> 2, 2, 2, 1, 2, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, …
## $ p25_lug_nacimiento_rec   <int32> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
## $ p25_lug_nacimiento_esp   <int32> 12101, 5101, 13120, 5802, 5109, 4303, 4303, -…
## $ p26_llegada_periodo      <int32> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
## $ p27_nacionalidad         <int32> 1, 1, 1, 1, 1, 1, 1, -66, -66, -66, 1, 1, 1, …
## $ p27_nacionalidad_esp     <int32> 152, 152, 152, 152, 152, 152, 152, -66, -66, …
## $ p27_nacionalidad_rec     <int32> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
## $ p28_autoid_pueblo        <int32> 2, 2, 2, 2, 2, 2, 2, 1, 2, 1, 2, 2, 2, 2, 2, …
## $ p28_pueblo_pert          <int32> NA, NA, NA, NA, NA, NA, NA, 1, NA, 1, NA, NA,…
## $ p29_afrodescendencia_rec <int32> 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, …
## $ p29_afrodescendencia     <int32> 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, …
## $ p30_lengua_indigena      <int32> 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, …
## $ p30_lengua_indigena_rec  <int32> 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, …
## $ p31_religion             <int32> 12, 12, 12, NA, 1, 1, 12, 2, 1, NA, 1, 1, 1, …
## $ p31_religion_rec         <int32> 2, 2, 2, NA, 1, 1, 2, 1, 1, NA, 1, 1, 1, 1, 1…
## $ p32a_dificultad_ver      <int32> 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, …
## $ p32b_dificultad_oir      <int32> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
## $ p32c_dificultad_mover    <int32> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, …
## $ p32d_dificultad_cogni    <int32> 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, …
## $ p32e_dificultad_cuidado  <int32> 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, …
## $ p32f_dificultad_comunic  <int32> 1, 1, 1, 1, 1, 1, 1, 3, 1, 2, 1, 1, 1, 1, 1, …
## $ discapacidad             <int32> 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, …
## $ p33_edu_asiste           <int32> 2, 2, 2, 1, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, …
## $ asistencia_parv          <int32> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
## $ asistencia_basica        <int32> NA, NA, NA, 1, NA, NA, NA, NA, NA, -66, NA, N…
## $ asistencia_media         <int32> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
## $ asistencia_superior      <int32> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
## $ p37_alfabet              <int32> 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, …
## $ escolaridad              <int32> 17, 14, 12, 2, 12, 12, 15, 8, 5, 3, 8, 8, 16,…
## $ cine11                   <int32> 9, 6, 6, 3, 6, 6, 6, 5, 3, 3, 5, 5, 6, 5, 5, …
## $ sit_fuerza_trabajo       <int32> 3, 1, 1, NA, 3, 3, 1, 1, 1, NA, 1, 3, 1, 3, 3…
## $ p40_cise_rec             <int32> NA, 1, 2, NA, NA, NA, 1, 2, 1, NA, 1, NA, 2, …
## $ depend_econ_deficit_hab  <int32> 1, 1, 1, 2, 1, 2, 1, 1, 1, 2, 1, 1, 1, 1, 2, …
## $ cod_ciuo                 <int32> NA, 7, 2, NA, NA, NA, 7, 5, 7, NA, 1, NA, 3, …
## $ cod_caenes              <string> NA, "F", "P", NA, NA, NA, "F", "I", "F", NA, …
## $ p44_lug_trab             <int32> NA, 5, 2, NA, NA, NA, 2, 1, 1, NA, 2, NA, 2, …
## $ p44_lug_trab_esp         <int32> NA, 998, 5802, NA, NA, NA, 4303, 11202, 11202…
## $ p45_medio_transporte     <int32> NA, 2, 3, NA, NA, NA, 2, NA, NA, NA, 1, NA, 2…
## $ p46a_tot_hijs_nac        <int32> 3, NA, 1, NA, NA, 3, NA, 2, NA, NA, NA, 3, NA…
## $ p46b_hijas_nac           <int32> 2, NA, 1, NA, NA, 0, NA, 1, NA, NA, NA, 0, NA…
## $ p46c_hijos_nac           <int32> 1, NA, 0, NA, NA, 3, NA, 1, NA, NA, NA, 3, NA…
## $ p47a_tot_hijs_sobrev     <int32> 3, NA, 1, NA, NA, 2, NA, 2, NA, NA, NA, 3, NA…
## $ p47b_hijas_sobrev        <int32> 2, NA, 1, NA, NA, -99, NA, 1, NA, NA, NA, 0, …
## $ p47c_hijos_sobrev        <int32> 1, NA, 0, NA, NA, -99, NA, 1, NA, NA, NA, 3, …
## $ p48_anio_nac_uh          <int32> 1978, NA, 2015, NA, NA, 1984, NA, 2014, NA, N…
## $ p48_mes_nac_uh           <int32> 7, NA, 9, NA, NA, 6, NA, 12, NA, NA, NA, 10, …
## $ div_genero               <int32> 2, 2, 2, NA, -66, -66, -66, -66, -66, NA, 2, …
```

Vemos todos los **nombres** de las columnas, y el **tipo** de datos que contienen. Además, vemos que la base de datos tiene **más de 18 millones** de filas! Esto es algo que en la mayoría de computadores no podríamos cargar en la memoria, pero gracias a que lo cargamos como una base de datos con `{arrow}`, podemos trabajar con ella sin problemas.


## Consultar el diccionario de variables códigos del Censo

Como vimos en el _output_ anterior, los datos del Censo vienen con **valores codificados en números** . Para entender su significado, necesitamos consultar el **diccionario de variables** del Censo, que también está disponible en la página de resultados del Censo y se llama _Diccionario de variables microdatos Censo 2024 – xlsx, 154 KB_, o presiona el siguiente botón:

{{< boton "Descargar diccionario de variables" "diccionario_variables_censo2024.xlsx" "fas fa-file-download" >}}

En esa planilla, la pestaña `tabla_personas` nos muestra las **etiquetas** de los valores que vienen en la base de datos. Por ejemplo, vemos que en la variable `sexo`, el valor `1` es _Hombre_ y `2` es _Mujer_.


## Calcular resúmenes de datos censales

Para hacer un **conteo** de cualquier variable, podemos usar `count()` y luego `collect()` para que la base de datos haga el cálculo y nos entregue el resultado:


``` r
personas |> 
  count(sexo) |> 
  collect()
```

```
## # A tibble: 2 × 2
##    sexo       n
##   <int>   <int>
## 1     2 9513399
## 2     1 8967033
```
Podemos también **recodificar** el resultado del conteo con `case_when()`, para convertir los valores codificados en etiquetas legibles:


``` r
personas |> 
  count(sexo) |> 
  mutate(sexo = case_when(
    sexo == 1 ~ "Hombre", 
    sexo == 2 ~ "Mujer")) |> 
  collect()
```

```
## # A tibble: 2 × 2
##   sexo         n
##   <chr>    <int>
## 1 Mujer  9513399
## 2 Hombre 8967033
```

La base de datos de Arrow puede realizar **cálculos mucho más eficientes y rápidos**, pero solamente puede realizar cálculos generales. Ésto es porque lo que hace `{arrow}` es _traducir_ las funciones de `{dplyr}` en el lenguaje de la base de datos, lo que significa que el número de funciones soportadas es limitado, aunque amplio.

{{< detalles "¿Qué pasa si `{arrow}` no soporta una función?" >}}

Si `{arrow}` nos dice que alguna función no es soportada (_Expression not supported in Arrow_), tenemos que usar estas funciones _después_ de cargar el resultado en la memoria con `collect()`.

Por ejemplo:


``` r
personas |> 
  count(sexo) |> 
  mutate(sexo = recode(sexo,
    "1" = "Hombre", 
    "2" = "Mujer")) |> 
  collect()
```

```
## Error in `recode()`:
## ! Expression not supported in Arrow
## → Call collect() first to pull data into R.
```

No funciona!


``` r
personas |> 
  count(sexo) |> 
  collect() |> # cargar resultados antes de proseguir
  mutate(sexo = recode(sexo,
    "1" = "Hombre", 
    "2" = "Mujer"))
```

```
## # A tibble: 2 × 2
##   sexo         n
##   <chr>    <int>
## 1 Mujer  9513399
## 2 Hombre 8967033
```

Ahora sí!

{{< /detalles >}}

```r
# seleccionar columnas
personas_filt <- personas |>
select(id_vivienda, id_hogar, region, comuna, sexo, area)

glimpse(personas_filt)

library(janitor)
library(tidyr)

# agrupar datos para sumar población por comuna y área
# (procesamiento en base de datos)
personas_area <- personas_filt |> 
group_by(comuna, region, area) |> 
summarize(n = n()) |> 
ungroup() |> 
# agregar nombres de comunas y regiones
left_join(comunas, join_by(comuna)) |> 
left_join(regiones, join_by(region)) |> 
# copiar a memoria
collect() |> 
# recodificar área
mutate(area = recode_values(area, 
1 ~ "Urbana", 
2 ~ "Rural")) |> 
mutate(area = as.factor(area))

# generar tabla con población y porcentaje por comuna y área
tabla_area <- personas_area |> 
# calcular pocentaje
group_by(comuna) |> 
mutate(p = n / sum(n),
p = p * 100) |>
ungroup() |> 
# pivotar
pivot_wider(names_from = area, 
values_from = c(n, p), 
values_fill = 0) |> 
arrange(comuna) |> 
clean_names()

# guardar
writexl::write_xlsx(tabla_area, "tabla_comunas_area.xlsx")

```



``` r
# códigos territoriales ----

# cargar base de códigos territoriales
codigos_territoriales <- readxl::read_xlsx("diccionario_variables_censo2024.xlsx",
                                           sheet = "codigos_territoriales") |>
  clean_names() |> 
  rename(dpa = 2)

# filtrar códigos territoriales
comunas <- codigos_territoriales |> 
  filter(dpa == "Comuna") |> 
  select(comuna = 1, nombre_comuna = 3) |> 
  mutate(comuna = as.integer(comuna))

regiones <- codigos_territoriales |> 
  filter(dpa == "Región") |> 
  select(region = 1, nombre_region = 3) |> 
  mutate(region = as.integer(region))
```



Mapa


``` r
manzanas |> 
  # filtrar
  filter(COMUNA == "PUENTE ALTO") |> # comuna
  # convertir
  st_as_sf(crs = 4326) |> 
  # graficar
  ggplot() +
  aes(fill = n_discapacidad) + # variable
  geom_sf(color = "white", linewidth = 0.01) +
  scale_fill_fermenter(palette = 3) +
  theme_minimal(base_size = 10) +
  theme(axis.text.x = element_text(angle = 90, vjust = .5)) +
  guides(fill = guide_legend(title = "Población",
                             position = "top")) +
  labs(title = "Población con discapacidad por manzana",
       subtitle = "Comuna de Puente Alto",
       caption = "Fuente: Censo 2024, INE")
```


Cruzar hogares con personas

``` r
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
```


