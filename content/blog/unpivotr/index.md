---
title: "Limpia planillas de Excel complejas en R con `{unpivotr}`"
author: Bastián Olea Herrera
date: '2026-04-27'
slug: []
categories: []
format: hugo-md
draft: true
tags:
  - limpieza de datos
  - procesamiento de datos
  - Excel
links:
  - icon: registered
    icon_pack: fas
    name: unpivotr
    url: https://github.com/nacnudus/unpivotr
---





```r

library(readxl)

sinim <- read_xlsx("SINIM IMPUESTO TERRITORIAL_Sin-Corrección-Monetaria.xlsx")

sinim
```

Esta planilla es un asco

Problemas:
- no tiene nombres de columnas
- primera fila contiene nombres de variables
- segunda fila también contiene nombres de variables (`CODIGO`, `MUNICIPIO`)
- segunda fila representa la variable `año` que aplica a las celdas de abajo
- valor vacío en primeras celdas de las dos primeras columnas

El problema es porque los datos vienen pivotados: no se respetan los principios de los datos ordenados (_tidy data_) así que tenemos variables en filas y columnas, y variables sobre otras variables en un encabezado.

Vamos a _despivotar_

El princpio es _descabezar_ la tabla, indicando dónde están las variables (arriba? abajo? al lado?) para ir extrayéndolas paso a paso, y poniéndolas en columnas como dios manda.

|                        |       |       |       |       |     |
|------------------------|-------|-------|-------|-------|-----|
| Valores en miles de …¹ | ...2  | ...3  | ...4  | ...5  | ... |
| NA                     | NA    | IADM… | IADM… | IADM… | ... |
| CODIGO                 | MUNI… | 2024  | 2023  | 2022  | ... |
| 1101                   | IQUI… | 1260… | 1250… | 1253… | ... |
| 1107                   | ALTO… | 3539… | 2318… | 1972… | ... |
| 1401                   | POZO… | 18141 | 11617 | 6603  | ... |
| ...                    | ...   | ...   | ...   | ...   | ... |

```r
library(unpivotr)

sinim |> 
  as_cells() |> 
  behead(direction = "up", name = "a") |> 
  behead(direction = "left", name = "codigo") |> 
  behead(direction = "left", name = "comuna") |> 
  behead(direction = "up", name = "año") |> 
  mutate(valor = as.integer(chr)) |> 
  select(-row, -col, -data_type, -chr)

```

