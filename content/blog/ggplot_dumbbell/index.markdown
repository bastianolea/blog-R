---
title: "Gráficos de puntos comparativos o _dumbbell_ en `{ggplot2}`"
author: Bastián Olea Herrera
date: '2026-04-24'
slug: []
draft: false
categories:
  - Tutoriales
tags:
  - visualización de datos
  - ggplot2
  - gráficos
excerpt: "En este tutorial aprenderemos a crear gráficos de puntos comparativos o _dumbbell_ `{ggplot2}`, que permiten comparar un valor en dos momentos en el tiempo, usando datos reales de delincuencia en Chile para comparar tasas de delitos entre 2018 y 2024."
format:
  hugo-md:
    output-file: index
    output-ext: md
execute:
  message: false
  warning: false
editor_options: 
  chunk_output_type: console
---

Los **gráficos de puntos comparativos**, también conocidos como _dumbbell_ o de _mancuernas_, son un tipo de visualización que muestra cómo cambia un valor entre dos tiempos. Se conectan dos puntos por una línea, donde cada punto representa el valor en un año o tiempo distinto. Su objetivo es **comparar** el cambio del valor.

Si bien los gráficos de barras también permiten comparar valores, el gráfico _dumbell_ hace más explícita la comparación al eliminar otros elementos distractores y enfocar la atención en la distancia entre los puntos.

En este tutorial vamos a construir este tipo de gráfico usando datos reales de delincuencia en Chile para comparar la tasa de cuatro tipos de delitos entre 2018 y 2024. 


## Cargar datos

Los datos de delincuencia están disponibles en el [repositorio `delincuencia_chile`](https://github.com/bastianolea/delincuencia_chile), que procesa las cifras oficiales del [Centro de Estudios y Análisis del Delito (CEAD)](http://cead.spd.gov.cl/estadisticas-delictuales/). Puedes descargarlos en **formato Parquet** en el siguiente enlace:

{{< boton "Descargar dato de delincuencia" "https://github.com/bastianolea/delincuencia_chile/raw/main/datos_procesados/cead_delincuencia_chile.parquet" "fas fa-file-download" >}}

Cargamos los datos usando `read_parquet()` del paquete `{arrow}`:


``` r
library(arrow)
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

``` r
# cargar directamente desde internet
# delitos <- read_parquet("https://github.com/bastianolea/delincuencia_chile/raw/main/datos_procesados/cead_delincuencia_chile.parquet")

# cargar archivo descargado
delitos <- read_parquet("cead_delincuencia_chile.parquet")

head(delitos)
```

```
##    comuna cut_comuna   region cut_region      fecha                 delito
## 1 Iquique       1101 Tarapacá          1 2018-01-01             Homicidios
## 2 Iquique       1101 Tarapacá          1 2018-01-01             Femicidios
## 3 Iquique       1101 Tarapacá          1 2018-01-01            Violaciones
## 4 Iquique       1101 Tarapacá          1 2018-01-01        Abusos sexuales
## 5 Iquique       1101 Tarapacá          1 2018-01-01        Acosos sexuales
## 6 Iquique       1101 Tarapacá          1 2018-01-01 Otros delitos sexuales
##   delito_n
## 1        3
## 2        0
## 3        0
## 4       10
## 5        0
## 6        0
```


Los datos tienen una fila por cada tipo de delito, zona geográfica y período, con una columna `delito_n` que indica la cantidad de casos.


## Preparación de los datos

### Contar delitos por año

Los datos vienen desagregados por zona geográfica y período. Para este tutorial necesitamos totales a nivel nacional, así que **agrupamos** por año y tipo de delito con `group_by()` para sumar todos los registros por año. La columna `fecha` tiene la fecha con año, mes y día, pero necesitamos la fecha sólo en años, así que usamos la función `year()` de `{lubridate}` para extraer el año desde la columna de fecha, y luego `group_by()` seguido de `summarize()` para obtener el conteo total por cada combinación de año y delito.


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
library(lubridate)
```

```
## 
## Attaching package: 'lubridate'
```

```
## The following object is masked from 'package:arrow':
## 
##     duration
```

```
## The following objects are masked from 'package:base':
## 
##     date, intersect, setdiff, union
```

``` r
# contar delitos por año
delitos_conteo <- delitos |>
  mutate(año = year(fecha)) |> # convertir fechas a años
  group_by(año, delito) |>
  summarize(delitos = sum(delito_n)) |> # sumar delitos por año y tipo de delito
  mutate(delitos = as.integer(delitos)) |> 
  ungroup()
```

```
## `summarise()` has regrouped the output.
## ℹ Summaries were computed grouped by año and delito.
## ℹ Output is grouped by año.
## ℹ Use `summarise(.groups = "drop_last")` to silence this message.
## ℹ Use `summarise(.by = c(año, delito))` for per-operation grouping
##   (`?dplyr::dplyr_by`) instead.
```

Recordemos que el `ungroup()` al final es importante para evitar que el agrupamiento afecte las operaciones siguientes.

Revisemos cómo quedan los datos:


``` r
delitos_conteo |>
  filter(año == 2024) |>
  arrange(-delitos) |> 
  head()
```

```
## # A tibble: 6 × 3
##     año delito                                        delitos
##   <dbl> <fct>                                           <int>
## 1  2024 Amenazas                                       154037
## 2  2024 Violencia intrafamiliar                        141433
## 3  2024 Hurtos                                         124902
## 4  2024 Daños                                          123062
## 5  2024 Consumo de alcohol y drogas en la vía pública  104931
## 6  2024 Robos con violencia o intimidación              69545
```

### Seleccionar delitos y años

Seleccionamos los tipos de delito que nos interesan comparar, y los años que queremos comparar. 


``` r
delitos_filtro <- delitos_conteo |>
  # delitos seleccionados
  filter(delito %in% c("Delitos asociados a armas", 
                       "Robo por sorpresa", 
                       "Robo de vehículo motorizado",
                       "Hurtos",
                       "Robo en lugar habitado", 
                       "Robos con violencia o intimidación")) |>
  # años a comparar
  filter(año %in% c(2018, 2024))

delitos_filtro
```

```
## # A tibble: 12 × 3
##      año delito                             delitos
##    <dbl> <fct>                                <int>
##  1  2018 Delitos asociados a armas            17893
##  2  2018 Hurtos                              172014
##  3  2018 Robo de vehículo motorizado          24285
##  4  2018 Robo en lugar habitado               58431
##  5  2018 Robo por sorpresa                    34194
##  6  2018 Robos con violencia o intimidación   73538
##  7  2024 Delitos asociados a armas            29061
##  8  2024 Hurtos                              124902
##  9  2024 Robo de vehículo motorizado          28671
## 10  2024 Robo en lugar habitado               43436
## 11  2024 Robo por sorpresa                    40481
## 12  2024 Robos con violencia o intimidación   69545
```

### Calcular tasa de delitos por habitante

Si bien podemos comparar los delitos entre 2018 y 2024, sería **incorrecto** debido a que ignora las diferencias de población entre ambos años. De lo contrario, un delito que parece aumentar puede estar simplemente reflejando un aumento de habitantes. La solución es **calcular una tasa** que ajuste la cantidad de delitos a la población existente en cada año.

Para eso necesitamos datos de población para los años que filtremos. Podemos obtener la población año a año desde las [proyecciones de población del Instituto Nacional de Estadísticas.](https://www.ine.gob.cl/estadisticas-por-tema/demografia-y-poblacion/proyecciones-de-poblacion).

{{< boton "Descargar proyecciones de población" "estimaciones-y-proyecciones-de-población-1992-2070_base-2024_base-de-datos.xlsx" "fas fa-file-download" >}}

Cargamos los datos con `readxl::read_xlsx()` y luego limpiamos los nombres de columnas con `janitor::clean_names()`. Como los datos vienen por edad y fecha, agrupamos los datos y sumamos las poblaciones para obtener la población nacional en cada fecha:


``` r
library(readxl)
library(janitor)
```

```
## 
## Attaching package: 'janitor'
```

```
## The following objects are masked from 'package:stats':
## 
##     chisq.test, fisher.test
```

``` r
# cargar datos
poblacion <- read_xlsx("estimaciones-y-proyecciones-de-población-1992-2070_base-2024_base-de-datos.xlsx")

# colapsar cifras por años
poblacion_suma <- poblacion |>
  clean_names() |>
  filter(nivel == "PAÍS") |> 
  group_by(nivel, fecha) |>
  summarize(poblacion = sum(poblacion)) |>
  ungroup()
```

```
## `summarise()` has regrouped the output.
## ℹ Summaries were computed grouped by nivel and fecha.
## ℹ Output is grouped by nivel.
## ℹ Use `summarise(.groups = "drop_last")` to silence this message.
## ℹ Use `summarise(.by = c(nivel, fecha))` for per-operation grouping
##   (`?dplyr::dplyr_by`) instead.
```

Luego filtramos las fechas que necesitamos, y convertimos los valores a fecha y luego a años para que coincidan con los datos de delincuencia:


``` r
poblacion_filtro <- poblacion_suma |>
  filter(fecha %in% c("1/1/2018", "1/1/2024")) |> # filtrar fechas
  mutate(fecha = dmy(fecha), # convertir texto a fecha
         año = year(fecha)) |> # convertir fecha a años
  select(-nivel, -fecha)

poblacion_filtro
```

```
## # A tibble: 2 × 2
##   poblacion   año
##       <dbl> <dbl>
## 1  18600071  2018
## 2  19832867  2024
```
Con los datos de población listos, hacemos un `left_join` por año para **agregar** la población a la tabla de delitos. Como estamos uniendo por `año`, cada fila de delitos recibe automáticamente la población correspondiente a ese año.


``` r
# agregar población a cada año
delitos_poblacion <- delitos_filtro |>
  left_join(poblacion_filtro, 
            join_by(año))

delitos_poblacion
```

```
## # A tibble: 12 × 4
##      año delito                             delitos poblacion
##    <dbl> <fct>                                <int>     <dbl>
##  1  2018 Delitos asociados a armas            17893  18600071
##  2  2018 Hurtos                              172014  18600071
##  3  2018 Robo de vehículo motorizado          24285  18600071
##  4  2018 Robo en lugar habitado               58431  18600071
##  5  2018 Robo por sorpresa                    34194  18600071
##  6  2018 Robos con violencia o intimidación   73538  18600071
##  7  2024 Delitos asociados a armas            29061  19832867
##  8  2024 Hurtos                              124902  19832867
##  9  2024 Robo de vehículo motorizado          28671  19832867
## 10  2024 Robo en lugar habitado               43436  19832867
## 11  2024 Robo por sorpresa                    40481  19832867
## 12  2024 Robos con violencia o intimidación   69545  19832867
```

Ahora **calculamos la tasa**: dividimos el conteo de delitos por la población y multiplicamos por 1.000. Así, un valor de 3,5 significaría que ocurrieron 3,5 casos de ese tipo de delito por cada 1.000 habitantes en Chile.


``` r
# calcular tasa
delitos_tasa <- delitos_poblacion |>
  mutate(tasa = delitos / poblacion * 1000)

delitos_tasa
```

```
## # A tibble: 12 × 5
##      año delito                             delitos poblacion  tasa
##    <dbl> <fct>                                <int>     <dbl> <dbl>
##  1  2018 Delitos asociados a armas            17893  18600071 0.962
##  2  2018 Hurtos                              172014  18600071 9.25 
##  3  2018 Robo de vehículo motorizado          24285  18600071 1.31 
##  4  2018 Robo en lugar habitado               58431  18600071 3.14 
##  5  2018 Robo por sorpresa                    34194  18600071 1.84 
##  6  2018 Robos con violencia o intimidación   73538  18600071 3.95 
##  7  2024 Delitos asociados a armas            29061  19832867 1.47 
##  8  2024 Hurtos                              124902  19832867 6.30 
##  9  2024 Robo de vehículo motorizado          28671  19832867 1.45 
## 10  2024 Robo en lugar habitado               43436  19832867 2.19 
## 11  2024 Robo por sorpresa                    40481  19832867 2.04 
## 12  2024 Robos con violencia o intimidación   69545  19832867 3.51
```

### Clasificar la variación

Para poder colorear el gráfico según si cada delito subió, bajó o se mantuvo igual, necesitamos comparar la tasa de cada año elegido. La función `lag()` nos entrega el valor de la observación anterior a cada fila, por lo que nos sirve para hacer comparaciones y así **saber si un valor es mayor o menor al anterior**.

Ordenamos los datos por tipo de delito y año, de modo que dentro de cada delito, el año quede de menor a mayor. Este orden es fundamental para que `lag()` funcione correctamente. Luego agrupamos por delito y usamos `lag(tasa)` para obtener la **tasa del año anterior** en la fila del año siguiente. Con `case_when()` clasificamos cada observación en la variable `cambio` según si la tasa subió, bajó o se mantuvo igual. Las filas de 2018 quedan con `NA` en `cambio`, porque no hay un año anterior con el que comparar, así que procedemos a **rellenar** con el valor que sí tiene información dentro del mismo grupo usando `fill()` de `{tidyr}`. También calculamos la variable `tipo` para establecer la posición de cada valor: si es el mayor o el menor de los dos.


``` r
library(tidyr)

delitos_tasa_clasif <- delitos_tasa |>
  arrange(delito, año) |> 
  group_by(delito) |>
  # define si sube o baja respecto al año anterior
  mutate(cambio = case_when(tasa > lag(tasa) ~ "sube",
                            tasa < lag(tasa) ~ "baja",
                            tasa == lag(tasa) ~ "igual")
  ) |> 
  fill(cambio, .direction = "up") |> 
  # define si el valor es el mayor o el menor
  mutate(tipo = case_when(tasa == max(tasa) ~ "mayor",
                          tasa == min(tasa) ~ "menor")
  ) |> 
  ungroup()

delitos_tasa_clasif
```

```
## # A tibble: 12 × 7
##      año delito                             delitos poblacion  tasa cambio tipo 
##    <dbl> <fct>                                <int>     <dbl> <dbl> <chr>  <chr>
##  1  2018 Delitos asociados a armas            17893  18600071 0.962 sube   menor
##  2  2024 Delitos asociados a armas            29061  19832867 1.47  sube   mayor
##  3  2018 Hurtos                              172014  18600071 9.25  baja   mayor
##  4  2024 Hurtos                              124902  19832867 6.30  baja   menor
##  5  2018 Robo de vehículo motorizado          24285  18600071 1.31  sube   menor
##  6  2024 Robo de vehículo motorizado          28671  19832867 1.45  sube   mayor
##  7  2018 Robo en lugar habitado               58431  18600071 3.14  baja   mayor
##  8  2024 Robo en lugar habitado               43436  19832867 2.19  baja   menor
##  9  2018 Robo por sorpresa                    34194  18600071 1.84  sube   menor
## 10  2024 Robo por sorpresa                    40481  19832867 2.04  sube   mayor
## 11  2018 Robos con violencia o intimidación   73538  18600071 3.95  baja   mayor
## 12  2024 Robos con violencia o intimidación   69545  19832867 3.51  baja   menor
```

Al especificar `.direction = "up"` en `fill()`, la función propaga el valor de 2024 hacia arriba para rellenar el `NA` de 2018. Así ambas filas de cada delito quedan con la misma etiqueta de variación, que usaremos para colorear el gráfico.


## Visualización

### Gráfico de barras apiladas

La visualización más básica para comparar dos grupos es un gráfico de barras. Aquí mapeamos el año al `fill` para que cada año tenga un color, usando `as.factor(año)` para que `{ggplot2}` entienda los números como categorías discretas y no como variables continuas.

Agregando `position = position_dodge()` a `geom_col()` hacemos que las barras aparezcan una al lado de la otra. 




``` r
library(ggplot2)
library(scales)

delitos_tasa_clasif |>
  ggplot() +
  aes(x = delito, y = tasa, 
      fill = as.factor(año)) +
  geom_col(
    width = 0.7,
    position = position_dodge()
  )
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-11-1.png" width="672" />


``` r
delitos_tasa_clasif |>
  ggplot() +
  aes(x = delito, y = tasa, 
      fill = as.factor(año)) +
  # barras 
  geom_col(
    width = 0.7,
    color = "white", linewidth = 1.1,
    position = position_dodge() # lado a lado
  ) +
  # textos sobre las barras
  geom_text(
    aes(
      label = label_number(decimal.mark = ",")(tasa)
    ),
    color = "grey40", size = 3,
    position = position_dodge(width = 0.7),
    vjust = -0.4
  ) +
  # paleta de colores
  scale_fill_manual(values = c("2018" = "#06BB96", "2024" = "#F1856A")) +
  # expandir espacio vertical para etiqueta de texto
  scale_y_continuous(expand = expansion(c(0, 0.1))) +
  # cortar líneas de texto muy largas
  scale_x_discrete(labels = scales::label_wrap(20)) +
  # textos
  labs(fill = "Años", y = "Tasa de delitos por cada 1.000 habitantes", x = NULL,
       title = "Comparación de tasas de delitos",
       subtitle = "Estadísticas oficiales de delitos en Chile, 2018 y 2024",
       caption = "Fuente: Centro de Estudios y Análisis del Delito (CEAD)") +
  # temas
  theme_minimal(base_family = "Atkinson Hyperlegible") +
  theme(panel.grid.major.x = element_blank(),
        legend.position = "bottom",
        plot.title = element_text(face = "bold"),)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-12-1.png" width="672" />


### Gráfico _dumbbell_

Para hacer un gráfico de puntos comparados o _dumbell_ necesitamos expresar los valores como puntos en vez de barras, y unir los puntos con una línea.


``` r
delitos_tasa_clasif |>
  ggplot() +
  aes(y = delito, x = tasa, 
      color = as.factor(año)) +
  geom_line(
    aes(group = delito)
  ) +
  geom_point()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-13-1.png" width="672" />

El argumento `aes(group = delito)` en `geom_line()` le dice a `{ggplot2}` que dibuje una línea por cada tipo de delito, conectando sus dos puntos.

Ahora podemos aplicar más detalle a la visualización: 
- Paleta de colores con `scale_color_manual()`
- Textos al lado de cada punto con `geom_text()`, con su posición dependiendo de si cada cifra es la menor (a la izquierda) o menor (a la derecha)
- Aumentar la escala horizontal para dar espacio a los textos que agregamos, con `expansion()` dentro de `scale_x_continuous()` 


``` r
library(glue)

delitos_tasa_clasif |>
  ggplot() +
  aes(y = delito, x = tasa,
      color = as.factor(año)) +
  # línea que conecta puntos de delitos
  geom_line(
    aes(group = delito),
    color = "grey70",
    linewidth = 1,
    show.legend = FALSE
  ) +
  geom_point(size = 5) +
  # texto con tasas al lado de cada círculo
  geom_label(
    aes(
      label = label_number(decimal.mark = ",")(tasa),
      hjust = if_else(tipo == "menor", 1.4, -0.4)
    ),
    size = 3, linewidth = 0, show.legend = FALSE
  ) +
  # texto debajo del último año
  geom_text(
    data = ~filter(.x, año == max(año)),
    aes(label = glue("{cambio} en {año}")),
    vjust = 2.7, color = "grey60", size = 3,
    show.legend = FALSE
  ) +
  # paleta de colores
  scale_color_manual(values = c("2018" = "#06BB96", "2024" = "#F1856A")) +
  # expansión de eje horizontal
  scale_x_continuous(expand = expansion(c(0.2, 0.2))) +
  # cortar textos largos del eje vertical
  scale_y_discrete(labels = scales::label_wrap(23)) +
  # textos
  labs(y = NULL, x = "Tasa de delitos por cada 1.000 habitantes", color = "Años",
       title = "Comparación de tasas de delitos",
       subtitle = "Estadísticas oficiales de delitos en Chile, 2018 y 2024",
       caption = "Fuente: Centro de Estudios y Análisis del Delito (CEAD)") +
  # temas
  theme_classic(base_family = "Atkinson Hyperlegible") +
  theme(panel.grid.major = element_line(linewidth = .2, color = "grey90"),
        legend.position = "bottom",
        plot.title = element_text(face = "bold"),
        axis.text.y = element_text(face = "bold", color = "black", size = 10))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-14-1.png" width="672" />

Para cada tipo de delito, vemos que el punto de la izquierda es el menor valor y el de la derecha el mayor, mientras que la línea muestra la brecha. 

Puedes ver una versión de este mismo gráfico en mi [aplicación web de estadísticas de delincuencia en Chile](https://bastianoleah.shinyapps.io/delincuencia_chile/), donde puedes elegir interactivamente los años a comparar y los delitos:

{{< imagen "estadisticas_delitos_chile_featured.png" >}}

{{< cafecito >}}

{{< cursos >}}

