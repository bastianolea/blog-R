---
title: "Limpia planillas de Excel complejas en R con `{unpivotr}`"
subtitle: "Convertir planillas con múltiples encabezados, tablas dinámicas o pivotadas a _dataframes_"
author: Bastián Olea Herrera
date: '2026-09-03'
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
  message: false
  warning: false
links:
  - icon: registered
    icon_pack: fas
    name: unpivotr
    url: https://nacnudus.github.io/unpivotr/
---

http://datos.sinim.gov.cl/datos_municipales.php


``` r
pak::pak("nacnudus/unpivotr")
```

- Ingresos Municipales (Ingreso Total Percibido) (M$) `IADM01`
- Ingresos por Fondo Común Municipal (M$) `IADM40`
- Ingresos Propios Permanentes (IPP) (M$) `IADM41`


``` r
# install.packages('openxlsx2')
library(openxlsx2)

datos <- read_xlsx("datos_municipales_20260903181833_Sin-Corrección-Monetaria.xlsx")
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



|   |Valores en miles de pesos nominales (M$) de cada año. |NA            |NA                                                         |NA                                                         |NA                                                         |NA                                             |NA                                             |NA                                             |NA                                             |NA                                             |NA                                             |
|:--|:-----------------------------------------------------|:-------------|:----------------------------------------------------------|:----------------------------------------------------------|:----------------------------------------------------------|:----------------------------------------------|:----------------------------------------------|:----------------------------------------------|:----------------------------------------------|:----------------------------------------------|:----------------------------------------------|
|2  |NA                                                    |NA            |IADM01 (M$) Ingresos Municipales (Ingreso Total Percibido) |IADM01 (M$) Ingresos Municipales (Ingreso Total Percibido) |IADM01 (M$) Ingresos Municipales (Ingreso Total Percibido) |IADM40 (M$) Ingresos por Fondo Común Municipal |IADM40 (M$) Ingresos por Fondo Común Municipal |IADM40 (M$) Ingresos por Fondo Común Municipal |IADM41 (M$) Ingresos Propios Permanentes (IPP) |IADM41 (M$) Ingresos Propios Permanentes (IPP) |IADM41 (M$) Ingresos Propios Permanentes (IPP) |
|3  |CODIGO                                                |MUNICIPIO     |2025                                                       |2024                                                       |2023                                                       |2025                                           |2024                                           |2023                                           |2025                                           |2024                                           |2023                                           |
|4  |1101                                                  |IQUIQUE       |108892278                                                  |104723522                                                  |98449509                                                   |8560862                                        |7496937                                        |6305296                                        |46338019                                       |47463055                                       |44196409                                       |
|5  |1107                                                  |ALTO HOSPICIO |36876247                                                   |34424619                                                   |27951929                                                   |21540651                                       |19217898                                       |16489486                                       |8191230                                        |7784736                                        |6568706                                        |
|6  |1401                                                  |POZO ALMONTE  |20133051                                                   |22382992                                                   |17792283                                                   |5820144                                        |4170737                                        |3685890                                        |6802957                                        |7971392                                        |5644044                                        |
|7  |1402                                                  |CAMIÑA        |4606673                                                    |3522359                                                    |3098153                                                    |2992290                                        |2616271                                        |2416319                                        |37981                                          |142731                                         |90197                                          |


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


``` r
library(unpivotr)

celdas <- datos |> 
  as_cells()

celdas
```

```
## # A tibble: 3,817 × 4
##      row   col data_type chr   
##    <int> <int> <chr>     <chr> 
##  1     1     1 chr       <NA>  
##  2     2     1 chr       CODIGO
##  3     3     1 chr       1101  
##  4     4     1 chr       1107  
##  5     5     1 chr       1401  
##  6     6     1 chr       1402  
##  7     7     1 chr       1403  
##  8     8     1 chr       1404  
##  9     9     1 chr       1405  
## 10    10     1 chr       2101  
## # ℹ 3,807 more rows
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

```
## Warning: There was 1 warning in `mutate()`.
## ℹ In argument: `valor = as.integer(chr)`.
## Caused by warning:
## ! NAs introduced by coercion
```

```
## # A tibble: 3,105 × 5
##    a                                                  codigo comuna año    valor
##    <chr>                                              <chr>  <chr>  <chr>  <int>
##  1 IADM01 (M$) Ingresos Municipales (Ingreso Total P… 1101   IQUIQ… 2025  1.09e8
##  2 IADM01 (M$) Ingresos Municipales (Ingreso Total P… 1107   ALTO … 2025  3.69e7
##  3 IADM01 (M$) Ingresos Municipales (Ingreso Total P… 1401   POZO … 2025  2.01e7
##  4 IADM01 (M$) Ingresos Municipales (Ingreso Total P… 1402   CAMIÑA 2025  4.61e6
##  5 IADM01 (M$) Ingresos Municipales (Ingreso Total P… 1403   COLCH… 2025  4.08e6
##  6 IADM01 (M$) Ingresos Municipales (Ingreso Total P… 1404   HUARA  2025  7.52e6
##  7 IADM01 (M$) Ingresos Municipales (Ingreso Total P… 1405   PICA   2025  1.19e7
##  8 IADM01 (M$) Ingresos Municipales (Ingreso Total P… 2101   ANTOF… 2025  1.92e8
##  9 IADM01 (M$) Ingresos Municipales (Ingreso Total P… 2102   MEJIL… 2025  1.51e7
## 10 IADM01 (M$) Ingresos Municipales (Ingreso Total P… 2103   SIERR… 2025  1.36e7
## # ℹ 3,095 more rows
```


