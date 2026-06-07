---
title: Limpiar nombres de columnas con R
author: Bastián Olea Herrera
date: '2026-04-06'
draft: true
slug: []
categories: []
tags:
  - limpieza de datos
  - consejos
  - básico
format:
  hugo-md:
    output-file: index
    output-ext: md
excerpt: >-
  Cuando importamos datos desde Excel u otras fuentes, los nombres de las
  columnas suelen venir con mayúsculas, espacios, tildes y otros caracteres que
  complican el trabajo en R. La función `rename_with()` de `{dplyr}` nos permite
  renombrar múltiples columnas a la vez aplicándoles cualquier función.
---


Cuando importamos datos desde Excel u otras fuentes, los nombres de las columnas suelen venir con todo tipo de problemas: mayúsculas mezcladas con minúsculas, espacios en blanco, tildes, caracteres especiales, y más.

No es que eso sea un problema en sí, sino que cuando procesamos datos necesitamos referirnos a las columnas frecuentemente, y si los nombres son largos y/o complicados, todo empeora.

Lo recomendado es que los nombres estén en minúscula, sin espacios, y sin símbolos especiales ni tildes.

Imaginemos que importamos una planilla con este aspecto:

``` r
library(dplyr)
```


    Attaching package: 'dplyr'

    The following objects are masked from 'package:stats':

        filter, lag

    The following objects are masked from 'package:base':

        intersect, setdiff, setequal, union

``` r
datos <- tibble::tribble(
  ~`Nombre Completo`, ~EDAD, ~`Fecha Nacimiento`, ~`Ingreso Mensual`, ~`años en empresa`,
  "Ana Contreras",    28,    "1996-03-14",        850000,              3,
  "Luis Pérez",       45,    "1979-08-22",        1200000,             12,
  "María López",      33,    "1991-11-05",        950000,              7
)

datos
```

    # A tibble: 3 × 5
      `Nombre Completo`  EDAD `Fecha Nacimiento` `Ingreso Mensual` `años en empresa`
      <chr>             <dbl> <chr>                          <dbl>             <dbl>
    1 Ana Contreras        28 1996-03-14                    850000                 3
    2 Luis Pérez           45 1979-08-22                   1200000                12
    3 María López          33 1991-11-05                    950000                 7

``` r
names(datos)
```

    [1] "Nombre Completo"  "EDAD"             "Fecha Nacimiento" "Ingreso Mensual" 
    [5] "años en empresa" 

Vemos que los nombres de columnas son **complicados** e **inconsistentes**.

## Limpiar nombres de columnas automáticamente

El mejor consejo para limpiar los nombres de las columnas es usar `clean_names()` del paquete `{janitor}`:

``` r
library(janitor)
```


    Attaching package: 'janitor'

    The following objects are masked from 'package:stats':

        chisq.test, fisher.test

``` r
datos |> clean_names()
```

    # A tibble: 3 × 5
      nombre_completo  edad fecha_nacimiento ingreso_mensual anos_en_empresa
      <chr>           <dbl> <chr>                      <dbl>           <dbl>
    1 Ana Contreras      28 1996-03-14                850000               3
    2 Luis Pérez         45 1979-08-22               1200000              12
    3 María López        33 1991-11-05                950000               7

Esta función milagrosa limpia automáticamente las columnas, y yo siempre la uso al iniciar cualquier limpieza de datos.

## Cambiar nombres de columnas manualmente

Naturalmente podemos renombrar las columnas a mano con `rename()`, donde ponemos el nombre nuevo y después el nombre original, o, para hacerlo más rápido, la posición de la columna que queremos renombrar:

``` r
datos |> 
  rename(nombre = 1,
         edad = 2,
         fecha = 3, 
         ingresos = 4,
         antiguedad = 5) |> 
  names()
```

    [1] "nombre"     "edad"       "fecha"      "ingresos"   "antiguedad"

Pero a veces necesitamos más control, y para eso está `rename_with()`

## Renombrar columnas

La función `rename_with()` de `{dplyr}` nos permite **renombrar múltiples columnas a la vez** aplicándoles cualquier función de transformación de texto.

### Cambiar nombres a minúsculas

Por ejemplo, podemos empezar la limpieza de columnas pasando todos los nombres a minúsculas con `tolower()`:

``` r
datos <- datos |> 
  rename_with(tolower)


names(datos)
```

    [1] "nombre completo"  "edad"             "fecha nacimiento" "ingreso mensual" 
    [5] "años en empresa" 

### Reemplazar espacios por guiones bajos

Los espacios en los nombres de columnas obligan a escribir el nombre entre comillas invertidas (`` `Nombre Completo` ``).

Para reemplazarlos por guiones bajos usamos `str_replace_all()` de `{stringr}`:

``` r
library(stringr)

datos <- datos |> 
  rename_with(tolower) |> 
  rename_with(
    ~str_replace_all(.x, " ", "_")
    )

names(datos)
```

    [1] "nombre_completo"  "edad"             "fecha_nacimiento" "ingreso_mensual" 
    [5] "años_en_empresa" 

El `~` al inicio indica que estamos aplicando la función a todas las columnas, representadas dentro de la función por el `.x`. En otras palabras, dijimos: a cada nombre de columna, reemplaza todos los espacios por guiones bajos.

## Aplicar transformaciones sólo a algunas columnas

`rename_with()` también acepta un segundo argumento para indicar a cuáles columnas se le aplica la transformación. Por ejemplo, podemos agregar el prefijo `"num_"` sólo a las columnas numéricas:

``` r
datos <- datos |> 
  rename_with(
    ~paste0("num_", .x), 
    where(is.numeric)
    )

names(datos)
```

    [1] "nombre_completo"     "num_edad"            "fecha_nacimiento"   
    [4] "num_ingreso_mensual" "num_años_en_empresa"

Con `where(is.numeric)` le decimos que la transformación sólo aplique a las columnas cuyo contenido sea numérico. Podríamos usar también `starts_with()`, `ends_with()`, `contains()` u otros selectores de columnas de `{dplyr}`.

------------------------------------------------------------------------

Gracias a [Pablo Tiscornia](https://www.linkedin.com/in/ptiscornia/) de [Estación R](https://estacion-r.com) por compartir este tip!

{{< etiqueta "limpieza de datos" >}}
