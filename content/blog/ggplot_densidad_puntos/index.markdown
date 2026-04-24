---
title: "Gráfico de densidad poblacional con puntos en `{ggplot2}`"
author: "Bastián Olea Herrera"
date: '2026-04-24'
draft: true
format:
  hugo-md:
    output-file: index
    output-ext: md
categories:
  - Tutoriales
tags:
  - visualización de datos
  - ggplot2
  - estadísticas
excerpt: "En este tutorial vamos a crear una visualización que representa la densidad poblacional de distintas ciudades usando círculos y puntos: cada círculo representa 1 km² de superficie, y cada punto dentro del círculo representa un número de habitantes. El resultado permite comparar de forma visual e intuitiva cuán densa es la población de distintos lugares."
---

Esta visualización representa la densidad poblacional de distintas ciudades usando un concepto simple pero poderoso: **cada círculo equivale a 1 km² de superficie**, y **cada punto dentro del círculo representa un número fijo de habitantes**. De esta forma, una ciudad muy densa tendrá su círculo repleto de puntos, mientras que una de baja densidad tendrá sólo unos pocos dispersos.


El gráfico muestra en simultáneo múltiples ciudades, lo que permite comparar de un solo vistazo cómo se distribuye la densidad de un lugar a otro. Es una forma mucho más intuitiva que comparar números, porque la cantidad de puntos es directamente proporcional a la densidad.

La idea original está inspirada en [este proyecto de visualización de densidad poblacional](https://www.behance.net/gallery/99114047/Population-Density).

## Paquetes

Para hacer esta visualización necesitamos algunos paquetes: `{ggforce}` para dibujar los círculos, `{ggtext}` para poner texto con formato rico en el gráfico, y `{glue}` para construir etiquetas de texto de forma dinámica. El resto son los paquetes habituales del tidyverse.


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
library(tidyr)
library(forcats)
library(ggplot2)
library(ggforce)   # geom_circle()
library(ggtext)    # geom_richtext()
library(glue)
library(scales)
```

{{< aviso "Si no tienes instalados `{ggforce}` o `{ggtext}`, puedes instalarlos con `install.packages(c('ggforce', 'ggtext'))`" >}}

## Los datos

Para este tutorial vamos a crear datos ficticios con ocho ciudades chilenas. Necesitamos dos columnas fundamentales para calcular la densidad: la **población** y la **superficie** (en km²).


``` r
datos <- tibble(
  nombre_comuna = c("Santiago", "Providencia", "Ñuñoa", "Maipú",
                    "Valparaíso", "Concepción", "Rancagua", "Castro"),
  poblacion     = c(180000, 120000, 160000, 320000,
                    140000, 180000, 90000, 30000),
  superficie    = c(18, 14, 20, 100,
                    60, 80, 90, 60)
)

datos
```

```
## # A tibble: 8 × 3
##   nombre_comuna poblacion superficie
##   <chr>             <dbl>      <dbl>
## 1 Santiago         180000         18
## 2 Providencia      120000         14
## 3 Ñuñoa            160000         20
## 4 Maipú            320000        100
## 5 Valparaíso       140000         60
## 6 Concepción       180000         80
## 7 Rancagua          90000         90
## 8 Castro            30000         60
```

La **densidad poblacional** es simplemente la cantidad de habitantes dividida por la superficie:


``` r
datos <- datos |>
  mutate(densidad = poblacion / superficie)

datos
```

```
## # A tibble: 8 × 4
##   nombre_comuna poblacion superficie densidad
##   <chr>             <dbl>      <dbl>    <dbl>
## 1 Santiago         180000         18   10000 
## 2 Providencia      120000         14    8571.
## 3 Ñuñoa            160000         20    8000 
## 4 Maipú            320000        100    3200 
## 5 Valparaíso       140000         60    2333.
## 6 Concepción       180000         80    2250 
## 7 Rancagua          90000         90    1000 
## 8 Castro            30000         60     500
```

Ordenemos las ciudades de mayor a menor densidad, de paso, para que las facetas del gráfico queden bien organizadas:


``` r
datos <- datos |>
  mutate(nombre_comuna = fct_reorder(nombre_comuna, desc(densidad)))
```

## Paleta de colores

Una forma ordenada de manejar los colores del gráfico es definirlos todos en una lista al inicio del script. Así es fácil cambiar la paleta entera sin tener que buscar cada color dentro del código:


``` r
color <- list(
  texto      = "#075180",
  fondo      = "#E5F3FA",
  secundario = "#FBF7ED",
  detalle    = "#9BC6DE"
)
```

## La función `puntos()`

Aquí está la parte más interesante del tutorial. Para generar los puntos dentro de cada círculo, necesitamos **distribuir `n` puntos aleatoriamente dentro de un círculo de radio `r`**. Esto no es tan inmediato como parece: si simplemente generamos coordenadas aleatorias dentro de un cuadrado y descartamos los que quedan fuera del círculo, los puntos se van a concentrar en el centro. La solución correcta usa **coordenadas polares**:


``` r
puntos <- function(n, radio) {
  r  <- runif(n)              # distancia al centro (raíz cuadrada para distribución uniforme)
  th <- runif(n, 0, 2 * pi)  # ángulo aleatorio entre 0 y 360°

  data.frame(
    x = radio * sqrt(r) * cos(th),
    y = radio * sqrt(r) * sin(th)
  ) |> list()
}
```

El truco está en usar `sqrt(r)` en vez de `r` directamente. Si no hiciéramos eso, los puntos se acumularían hacia el centro porque el área de un círculo crece con el cuadrado del radio. Al tomar la raíz cuadrada, compensamos ese efecto y logramos que los puntos se distribuyan **uniformemente** por toda el área del círculo.

Podemos ver cómo funciona la función generando 200 puntos dentro de un círculo de radio 1:


``` r
set.seed(42)
puntos(200, radio = 1)[[1]] |>
  ggplot(aes(x, y)) +
  geom_point(size = 0.8, alpha = 0.6, color = color$texto) +
  coord_fixed() +
  theme_void()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-7-1.png" width="672" />

Perfecto: los puntos quedan distribuidos de forma homogénea por todo el interior del círculo.

## Preparar los datos para el gráfico

Ahora que tenemos la función, la idea es aplicarla a cada fila de nuestro dataset. Para eso usamos `rowwise()`, que hace que cada operación siguiente se aplique fila por fila en vez de a toda la columna a la vez.

Primero definimos algunos parámetros:


``` r
radio       <- 0.7   # radio del círculo en el gráfico
unidad_tasa <- 100   # cuántos habitantes representa cada punto
```

Con `unidad_tasa = 100`, cada punto equivale a 100 habitantes. Una ciudad de densidad 10.000 hab/km² tendrá 100 puntos en su círculo; una de 500 hab/km² tendrá solo 5.

Ahora calculamos cuántos puntos corresponden a cada ciudad y generamos sus coordenadas:


``` r
set.seed(123)

puntos_datos <- datos |>
  mutate(
    dens = ceiling(densidad / unidad_tasa)  # cantidad de puntos por comuna
  ) |>
  rowwise() |>
  mutate(points = puntos(dens, radio)) |>   # generar coordenadas para cada fila
  unnest(points)                             # expandir la lista en filas

puntos_datos
```

```
## # A tibble: 360 × 7
##    nombre_comuna poblacion superficie densidad  dens      x       y
##    <fct>             <dbl>      <dbl>    <dbl> <dbl>  <dbl>   <dbl>
##  1 Santiago         180000         18    10000   100 -0.304 -0.221 
##  2 Santiago         180000         18    10000   100 -0.309  0.539 
##  3 Santiago         180000         18    10000   100 -0.447  0.0320
##  4 Santiago         180000         18    10000   100  0.631 -0.186 
##  5 Santiago         180000         18    10000   100 -0.675  0.0728
##  6 Santiago         180000         18    10000   100  0.115 -0.0950
##  7 Santiago         180000         18    10000   100  0.437 -0.260 
##  8 Santiago         180000         18    10000   100 -0.513 -0.417 
##  9 Santiago         180000         18    10000   100 -0.440  0.277 
## 10 Santiago         180000         18    10000   100  0.285  0.378 
## # ℹ 350 more rows
```

El `rowwise()` hace que `puntos()` se ejecute una vez por cada ciudad, generando las coordenadas `x` e `y` de sus puntos. El `unnest()` expande esa columna de listas en filas individuales, resultando en un data frame donde cada fila es un punto del gráfico.

## El gráfico

### Paso 1: El círculo de fondo

La base del gráfico es un círculo dibujado con `geom_circle()` del paquete `{ggforce}`. Este `geom` dibuja círculos especificando el centro (`x0`, `y0`) y el radio (`r`):


``` r
ggplot() +
  geom_circle(
    data = puntos_datos |> distinct(nombre_comuna),
    aes(x0 = 0, y0 = 0, r = radio + 0.04),
    linewidth = .5, fill = color$secundario, color = color$detalle
  ) +
  coord_fixed() +
  facet_wrap(~nombre_comuna)
```

```
## Warning in geom_circle(data = distinct(puntos_datos, nombre_comuna), aes(x0 = 0, : All aesthetics have length 1, but the data has 8 rows.
## ℹ Please consider using `annotate()` or provide this layer with data containing
##   a single row.
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-10-1.png" width="672" />

Nótese que le pasamos `distinct(nombre_comuna)` como datos del círculo, porque queremos **un solo círculo por ciudad** (no uno por cada punto). El radio es ligeramente más grande que el de los puntos (`radio + 0.04`) para que actúe como borde visual.

### Paso 2: Los puntos de densidad

Agregamos los puntos sobre el círculo. Cada punto representa `unidad_tasa` habitantes:


``` r
ggplot() +
  geom_circle(
    data = puntos_datos |> distinct(nombre_comuna),
    aes(x0 = 0, y0 = 0, r = radio + 0.04),
    linewidth = .5, fill = color$secundario, color = color$detalle
  ) +
  geom_point(
    data = puntos_datos,
    aes(x = x, y = y),
    size = 0.7, alpha = 0.6, color = color$texto
  ) +
  coord_fixed() +
  facet_wrap(~nombre_comuna)
```

```
## Warning in geom_circle(data = distinct(puntos_datos, nombre_comuna), aes(x0 = 0, : All aesthetics have length 1, but the data has 8 rows.
## ℹ Please consider using `annotate()` or provide this layer with data containing
##   a single row.
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-11-1.png" width="672" />

Ya se puede ver el efecto: las ciudades con más densidad tienen el círculo más lleno de puntos. Santiago tiene el círculo repleto, mientras que Castro tiene apenas unos pocos puntos dispersos.

### Paso 3: Etiquetas de texto

Ahora agregamos las etiquetas con el nombre de la ciudad y la densidad. Usamos `geom_richtext()` de `{ggtext}` porque nos permite combinar texto con **formato HTML** dentro del gráfico: negritas, distintos tamaños, y más.

El texto va **sobre** el círculo, en la posición `y = radio + 0.09`:


``` r
# para mostrar con decimales si la densidad es baja, o sin decimales si es alta
densidad_decimales <- ifelse(any(puntos_datos$densidad < 10), 0.1, 1)

ggplot() +
  geom_circle(
    data = puntos_datos |> distinct(nombre_comuna),
    aes(x0 = 0, y0 = 0, r = radio + 0.04),
    linewidth = .5, fill = color$secundario, color = color$detalle
  ) +
  geom_point(
    data = puntos_datos,
    aes(x = x, y = y),
    size = 0.7, alpha = 0.6, color = color$texto
  ) +
  geom_richtext(
    data = puntos_datos |> distinct(nombre_comuna, densidad),
    aes(x = 0, y = radio + 0.09,
        label = glue("<b style='font-size: 11pt;'>{nombre_comuna}</b><br>
                     <span style='font-size: 8pt;'>{label_number(accuracy = densidad_decimales)(densidad)} hab/km²</span>")),
    label.padding = unit(0, "pt"), label.margin = unit(0, "pt"), label.size = unit(0, "pt"),
    size = 3, vjust = 0, fill = NA, color = color$texto
  ) +
  coord_fixed(clip = "off") +
  facet_wrap(~nombre_comuna)
```

```
## Warning in geom_circle(data = distinct(puntos_datos, nombre_comuna), aes(x0 = 0, : All aesthetics have length 1, but the data has 8 rows.
## ℹ Please consider using `annotate()` or provide this layer with data containing
##   a single row.
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-12-1.png" width="672" />

El argumento `clip = "off"` en `coord_fixed()` es importante: sin él, el texto que sobresale del panel quedaría cortado.

### Paso 4: Texto inferior

Agregamos también el texto inferior con la superficie y la población total de cada ciudad, con `geom_text()`:


``` r
ggplot() +
  geom_circle(
    data = puntos_datos |> distinct(nombre_comuna),
    aes(x0 = 0, y0 = 0, r = radio + 0.04),
    linewidth = .5, fill = color$secundario, color = color$detalle
  ) +
  geom_point(
    data = puntos_datos,
    aes(x = x, y = y),
    size = 0.7, alpha = 0.6, color = color$texto
  ) +
  geom_richtext(
    data = puntos_datos |> distinct(nombre_comuna, densidad),
    aes(x = 0, y = radio + 0.09,
        label = glue("<b style='font-size: 11pt;'>{nombre_comuna}</b><br>
                     <span style='font-size: 8pt;'>{label_number(accuracy = densidad_decimales)(densidad)} hab/km²</span>")),
    label.padding = unit(0, "pt"), label.margin = unit(0, "pt"), label.size = unit(0, "pt"),
    size = 3, vjust = 0, fill = NA, color = color$texto
  ) +
  geom_text(
    data = puntos_datos |> distinct(nombre_comuna, densidad, poblacion, superficie),
    aes(x = 0, y = 0 - radio - 0.12,
        label = glue("{label_number(accuracy = 0.1, suffix = ' km²')(superficie)}, {label_number(big.mark = '.')(poblacion)} hab.")),
    size = 2.8, vjust = 1, color = color$detalle
  ) +
  coord_fixed(clip = "off") +
  facet_wrap(~nombre_comuna)
```

```
## Warning in geom_circle(data = distinct(puntos_datos, nombre_comuna), aes(x0 = 0, : All aesthetics have length 1, but the data has 8 rows.
## ℹ Please consider using `annotate()` or provide this layer with data containing
##   a single row.
```

```
## Warning in prettyNum(.Internal(format(x, trim, digits, nsmall, width, 3L, :
## 'big.mark' and 'decimal.mark' are both '.', which could be confusing
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-13-1.png" width="672" />

### Paso 5: Tema y estética final

Solo falta aplicar el tema visual: fondo de color, sin ejes, tipografía y espaciados. También ajustamos la escala vertical para que haya espacio suficiente arriba y abajo de cada círculo para las etiquetas.


``` r
ggplot() +
  # círculo de fondo
  geom_circle(
    data = puntos_datos |> distinct(nombre_comuna),
    aes(x0 = 0, y0 = 0, r = radio + 0.04),
    linewidth = .5, fill = color$secundario, color = color$detalle
  ) +
  # puntos de densidad
  geom_point(
    data = puntos_datos,
    aes(x = x, y = y),
    size = 0.7, alpha = 0.6, color = color$texto
  ) +
  # texto superior: nombre de la ciudad y densidad
  geom_richtext(
    data = puntos_datos |> distinct(nombre_comuna, densidad),
    aes(x = 0, y = radio + 0.09,
        label = glue("<b style='font-size: 11pt;'>{nombre_comuna}</b><br>
                     <span style='font-size: 8pt;'>{label_number(accuracy = densidad_decimales)(densidad)} hab/km²</span>")),
    label.padding = unit(0, "pt"), label.margin = unit(0, "pt"), label.size = unit(0, "pt"),
    size = 3, vjust = 0, fill = NA, color = color$texto
  ) +
  # texto inferior: superficie y población total
  geom_text(
    data = puntos_datos |> distinct(nombre_comuna, densidad, poblacion, superficie),
    aes(x = 0, y = 0 - radio - 0.12,
        label = glue("{label_number(accuracy = 0.1, suffix = ' km²')(superficie)}, {label_number(big.mark = '.')(poblacion)} hab.")),
    size = 2.8, vjust = 1, color = color$detalle
  ) +
  # escala vertical con espacio para las etiquetas
  scale_y_continuous(expand = expansion(c(0.03, 0.12))) +
  # proporciones cuadradas y texto fuera del panel visible
  coord_fixed(clip = "off") +
  # una faceta por ciudad
  facet_wrap(~nombre_comuna) +
  # tema visual
  theme_void() +
  theme(
    plot.background  = element_rect(fill = color$fondo, color = NA),
    strip.text       = element_blank(),
    plot.title       = element_text(face = "bold"),
    plot.subtitle    = element_text(margin = margin(t = 5, b = 24)),
    plot.caption     = element_text(margin = margin(t = 12), color = color$detalle),
    panel.spacing.y  = unit(1.1, "cm"),
    panel.spacing.x  = unit(0.5, "cm"),
    plot.margin      = margin(10, 14, 10, 14)
  ) +
  labs(
    title    = "Densidad poblacional urbana",
    subtitle = glue("Los círculos representan 1 km² de superficie urbana.\nCada punto equivale a {unidad_tasa} habitantes."),
    caption  = "Datos ficticios de ejemplo"
  )
```

```
## Warning in geom_circle(data = distinct(puntos_datos, nombre_comuna), aes(x0 = 0, : All aesthetics have length 1, but the data has 8 rows.
## ℹ Please consider using `annotate()` or provide this layer with data containing
##   a single row.
```

```
## Warning in prettyNum(.Internal(format(x, trim, digits, nsmall, width, 3L, :
## 'big.mark' and 'decimal.mark' are both '.', which could be confusing
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-14-1.png" width="864" />

## El resultado

El gráfico permite comparar de un vistazo las densidades entre ciudades: Santiago y Providencia, con sus círculos repletos de puntos, contrastan radicalmente con Castro, donde apenas hay unos pocos puntos dispersos.

Combinando `{ggforce}` para los círculos, `{ggtext}` para las etiquetas con formato, y la función `puntos()` para distribuir los puntos uniformemente dentro del círculo, logramos una visualización que comunica la densidad de forma mucho más directa que una tabla o un gráfico de barras.

## ¿Y si quiero hacer esto con datos reales?

Si quieres aplicar esta técnica a datos reales, necesitarás:
- Una fuente de datos de **población** desagregada por unidad territorial (como el Censo)
- Una fuente de datos de **superficies**, idealmente sólo contando la zona urbana de cada territorio

Y si tienes muchas ciudades, puedes automatizar la generación del gráfico para distintos grupos usando `purrr::map()`:

{{< aviso "Revisa el tutorial [Generar múltiples gráficos automáticamente con R](/blog/ggplot_purrr/) para aprender a hacer esto." >}}

----

{{< cafecito >}}
{{< cursos >}}

