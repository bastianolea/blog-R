---
title: Limpiar planillas de Excel complejas en R con `{unpivotr}`
subtitle: >-
  Convertir planillas con múltiples encabezados, tablas dinámicas o pivotadas a
  _dataframes_
author: Bastián Olea Herrera
date: '2026-09-29'
slug: []
categories: []
format:
  hugo-md:
    output-file: index
    output-ext: md
draft: true
tags:
  - limpieza de datos
  - procesamiento de datos
  - Excel
execute:
  eval: false
  message: false
  warning: false
links:
  - icon: registered
    icon_pack: fas
    name: unpivotr
    url: https://nacnudus.github.io/unpivotr/
excerpt: >-
  Muchas planillas Excel presentan sus datos de forma no-rectangular; por
  ejemplo, con múltiples encabezados encima de las columnas, celdas combinadas
  que describen las variables bajo ellas, encabezados de variables en las filas,
  etc. El problema principal es que los datos no vienen rectangulares (con
  nombres de variables en la primera fila) ni se respetan los principios de los
  datos ordenados (_tidy data_). Esto vuelve muy difícil trabajar con estos
  datos, a menos que los des-pivotemos con `{unpivotr}`!
editor_options:
  chunk_output_type: console
---


Muchas planillas Excel presentan sus datos de forma no-rectangular; por ejemplo, con múltiples encabezados encima de las columnas, celdas combinadas que describen las variables bajo ellas, encabezados de variables en las filas, etc.

## Datos desordenados

Veamos un ejemplo de datos desordenados:

<table>
<thead>
<tr>
<th>
</th>
<th colspan="4">
2026
</th>
</tr>
<tr style="background-color: #a985c630;">
<th>
</th>
<th colspan="2">
Grupo A
</th>
<th colspan="2">
Grupo B
</th>
</tr>
<tr>
<th>
Variable
</th>
<th>
Variable 1
</th>
<th>
Variable 2
</th>
<th>
Variable 1
</th>
<th>
Variable 2
</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<strong>Observación 1</strong>
</td>
<td>
10
</td>
<td>
20
</td>
<td>
15
</td>
<td>
25
</td>
</tr>
<tr>
<td>
<strong>Observación 2</strong>
</td>
<td>
12
</td>
<td>
22
</td>
<td>
17
</td>
<td>
27
</td>
</tr>
</tbody>
</table>

La tabla anterior está **desordenada** porque tiene nombres de variables encima de nombres de variables, los datos sobre las observaciones no están en sus propias columnas, y hay datos escondidos como nombres de columnas (los años).

Si bien este tipo de *tablas pivotadas* muchas veces facilita la lectura y mejora la densidad de información, da muchos problemas para manipular y transformar los datos:

¿Cómo filtrarías los datos de la `Variable 1`, si sale en 2 columnas distintas, que ni siquiera son consecutivas? Luego, ¿cómo seleccionarías los valores del `Grupo B`, si los datos están en 2 columnas, una de ellas sin siquiera tener etiqueta encima? O peor, imagina que la tabla abarca varios años, ¿cómo identificas en qué columnas están los valores de cierto año, si cada año abarca 4 columnas?

Un dolor de cabeza! 🫠

Así serían los mismos datos, pero en **formato ordenado** o *tidy data*, donde cada variable es una columna y cada observación es una fila:

<table>
<thead>
<tr>
<th>
Año
</th>
<th>
Observación
</th>
<th>
Grupo
</th>
<th>
Variable
</th>
<th>
Valor
</th>
</tr>
</thead>
<tbody>
<tr>
<td>
2026
</td>
<td>
1
</td>
<td>
A
</td>
<td>
1
</td>
<td>
10
</td>
</tr>
<tr>
<td>
2026
</td>
<td>
1
</td>
<td>
A
</td>
<td>
2
</td>
<td>
20
</td>
</tr>
<tr>
<td>
2026
</td>
<td>
1
</td>
<td>
B
</td>
<td>
1
</td>
<td>
15
</td>
</tr>
<tr>
<td>
2026
</td>
<td>
1
</td>
<td>
B
</td>
<td>
2
</td>
<td>
25
</td>
</tr>
<tr>
<td>
2026
</td>
<td>
2
</td>
<td>
A
</td>
<td>
1
</td>
<td>
12
</td>
</tr>
<tr>
<td>
2026
</td>
<td>
2
</td>
<td>
A
</td>
<td>
2
</td>
<td>
22
</td>
</tr>
<tr>
<td>
2026
</td>
<td>
2
</td>
<td>
B
</td>
<td>
1
</td>
<td>
17
</td>
</tr>
<tr>
<td>
2026
</td>
<td>
2
</td>
<td>
B
</td>
<td>
2
</td>
<td>
27
</td>
</tr>
</tbody>
</table>

El paquete `{unpivotr}` fue diseñado para *despivotar* este tipo de tablas y volver a estructurar la información desestructurada en filas y columnas.

``` r
install.packages("unpivotr")
```

``` r
library(unpivotr)
```

En código, si importamos la tabla Excel desordenada anterior con `{readxl}`, se vería así:

``` r
library(dplyr)

desorden <- tibble(
  `...1` = c(NA, NA, "Variable", "Observación 1", "Observación 2"),
  `...2` = c(2026, "Grupo A", "Variable 1", 10, 12),
  `...3` = c(NA, "Grupo A", "Variable 2", 20, 22),
  `...4` = c(NA, "Grupo B", "Variable 1", 15, 17),
  `...5` = c(NA, "Grupo B", "Variable 2", 25, 27)
)

desorden
```

Como vemos, se trata de una abominación alejada de los ojos de Dios. Para enfrentarnos a estos horrores, lo primero es deconstruir la tabla a sus meras celdas con `as_cells()`. Esto transforma la tabla en una nueva tabla de **una fila por celda**, que describe las filas y columnas donde se ubica cada celda, que es muy poco legible, pero es lo que nos permitirá reconstruirla.

``` r
library(unpivotr)

celdas <- as_cells(desorden)

celdas
```

Ahora que tenemos una tabla tokenizada, procedemos a iluminar a esta bestia del abismo con la función `behead()`, o *decapitar* 🔪

Mirando la [tabla desordenada](#datos-desordenados), vemos que

``` r
celdas |> 
  behead("up", "año")

celdas |> 
  behead("up", "año") |> 
  behead("up", "grupo")

celdas |> 
  behead("up", "año") |> 
  behead("up", "grupo") |> 
  behead("up", "variable")

celdas |> 
  behead("up", "año") |> 
  behead("up", "grupo") |> 
  behead("up", "variable") |> 
  behead("left", "observacion")

tabla <- celdas |> 
  behead("up", "año") |> 
  behead("up", "grupo") |> 
  behead("up", "variable") |> 
  behead("left", "observacion")

tabla <- tabla |> 
  select(año, observacion, grupo, variable,
         valor = chr)

library(tidyr)
library(stringr)

tabla |> 
  fill(año, .direction = "down") |> 
  mutate(
    observacion = str_remove(observacion, "Observación "),
    grupo = str_remove(grupo, "Grupo "),
    variable = str_remove(variable, "Variable ")
  ) |> 
  arrange(observacion)
```

------------------------------------------------------------------------

http://datos.sinim.gov.cl/datos_municipales.php

``` r
pak::pak("nacnudus/unpivotr")
```

- Ingresos Municipales (Ingreso Total Percibido) (M\$) `IADM01`
- Ingresos por Fondo Común Municipal (M\$) `IADM40`
- Ingresos Propios Permanentes (IPP) (M\$) `IADM41`

``` r
# install.packages('openxlsx2')
library(openxlsx2)

datos <- read_xlsx("datos_municipales_20260903181833_Sin-Corrección-Monetaria.xlsx")
```

Esta planilla es un asco

Problemas:
- no tiene nombres de columnas
- primera fila contiene nombres de variables
- segunda fila también contiene nombres de variables (`CODIGO`, `MUNICIPIO`)
- segunda fila representa la variable `año` que aplica a las celdas de abajo
- valor vacío en primeras celdas de las dos primeras columnas

El problema es porque los datos vienen pivotados: no se respetan los principios de los datos ordenados (*tidy data*) así que tenemos variables en filas y columnas, y variables sobre otras variables en un encabezado.

Vamos a *despivotar*

El princpio es *descabezar* la tabla, indicando dónde están las variables (arriba? abajo? al lado?) para ir extrayéndolas paso a paso, y poniéndolas en columnas como dios manda.

|                          |         |         |         |         |     |
|--------------------------|---------|---------|---------|---------|-----|
| Valores en miles de ...¹ | ...2    | ...3    | ...4    | ...5    | ... |
| NA                       | NA      | IADM... | IADM... | IADM... | ... |
| CODIGO                   | MUNI... | 2024    | 2023    | 2022    | ... |
| 1101                     | IQUI... | 1260... | 1250... | 1253... | ... |
| 1107                     | ALTO... | 3539... | 2318... | 1972... | ... |
| 1401                     | POZO... | 18141   | 11617   | 6603    | ... |
| ...                      | ...     | ...     | ...     | ...     | ... |

``` r
library(unpivotr)

celdas <- datos |> 
  as_cells()

celdas
```

``` r
celdas |> 
  behead(direction = "up", name = "a") |> 
  behead(direction = "left", name = "codigo") |> 
  behead(direction = "left", name = "comuna") |> 
  behead(direction = "up", name = "año") |> 
  mutate(valor = as.integer(chr)) |> 
  select(-row, -col, -data_type, -chr)
```

## Otro ejemplo

Número de contribuyentes y montos de impuesto global complementario y único de segunda categoría (desagregado por región)
https://www.sii.cl/sobre_el_sii/estadisticas_de_personas_naturales.html

``` r
library(openxlsx2)
library(unpivotr)
library(tidyxl)

# cargar
datos <- wb_read("PUB_Region.xlsb")

celdas <- as_cells(datos)

# celdas <- tidyxl::xlsx_cells("datos/personas_tribut_n/PUB_Region.xlsx")

# despivotar
datos <- celdas |>
  filter(row > 5) |>
  behead("up", "categoria") |>
  behead("up", "variable") |>
  behead("left", "año") |>
  behead("left", "region") |>
  behead("left", "tramo") |>
  glimpse()

datos <- datos |>
  select(categoria:tramo, valor = chr)

datos |>
  distinct(categoria)

datos |>
  distinct(categoria, variable)

# ver el problema
datos |>
  filter(
    region == "Región de Coquimbo",
    tramo == "Tramo 1 - 0 a 13,5 UTA (Exento)",
    año == 2015
  )

# rellenar
datos_fill <- datos |>
  fill(categoria, .direction = "down")

datos_fill |>
  filter(
    region == "Región de Coquimbo",
    tramo == "Tramo 1 - 0 a 13,5 UTA (Exento)",
    año == 2015
  )


datos_wide <- datos_fill |>
  pivot_wider(
    names_from = variable,
    values_from = valor
  )

datos_wide |>
  filter(
    categoria == "Per. Naturales contribuyentes de 2a Cat.",
    region == "Región de Coquimbo",
    tramo == "Tramo 8 - Más de 150 UTA (Tasa 40%)",
    año == 2015
  ) |>
  glimpse()
```
