---
title: Limpieza y validación de RUT en R
subtitle: >-
  Funciones de R para limpiar, validar y verificar el número de cédula de
  identidad Chilena
author: Bastián Olea Herrera
date: '2026-06-12'
slug: []
draft: false
categories: []
tags:
  - texto
  - procesamiento de datos
  - funciones
  - Chile
format:
  hugo-md:
    output-file: index
    output-ext: md
editor_options:
  chunk_output_type: console
excerpt: >-
  En Chile, los [RUT](https://es.wikipedia.org/wiki/Rol_Único_Nacional) son los
  números de identificación usados para ciudadanos y empresas. Tienen el formato
  `xxxxxxx-y`, donde `x` es el número o cuerpo, e `y` es el dígito verificador
  (número entre `0` y `9` o `K`). En esta publicación entrego algunas funciones
  para realizar operaciones comunes con los RUT en R, como validarlos, calcular
  el dígito verificador, y limpiar los RUT.
links:
  - icon: registered
    icon_pack: fas
    name: Paquete
    url: https://bastianolea.github.io/rutera/
---


En Chile, los [RUT](https://es.wikipedia.org/wiki/Rol_Único_Nacional) son los números de identificación usados para ciudadanos y empresas. Tienen el formato `xxxxxxx-y`, donde `x` es el número o cuerpo, e `y` es el dígito verificador (número entre `0` y `9` o `K`).

En esta publicación entrego algunas funciones para realizar operaciones comunes con los RUT en R, como validarlos, calcular el dígito verificador, y limpiar los RUT, y además entrego estas mismas soluciones en la forma de funciones de [mi paquete `{rutera}`](../../../blog/rutera/).

{{< relacionada "/blog/rutera/" >}}

## Calcular dígito verificador

El dígito verificador del RUT permite confirmar que se escribió correctamente usando el [algoritmo módulo 11](https://es.wikipedia.org/wiki/Código_de_control). En resumen, este algoritmo:

1.  Toma los dígitos previos al guión
2.  Multiplica cada dígito, de derecha a izquierda, por la secuencia cíclica `2, 3, 4, 5, 6, 7` y suma los resultados
3.  A esta suma se le calcula el módulo (resto de la división entera) de 11, y el resultado se le resta a 11
4.  El resultado de lo anterior es el dígito verificador; pero si el resultado es `11` o `10`, el dígito será `0` o `K`, respectivamente

El siguiente ejemplo muestra cómo calcular el dígito verificador de cualquier RUT sin dígito verificador:

``` r
library(stringr)
library(purrr)

rut_sin_digito <- 24324110

# separar números en dígitos
digitos_lista <- strsplit(as.character(rut_sin_digito), "")

digitos <- as.numeric(rut_sin_digito)

# secuencia cíclica de 2 a 7
pesos <- rep(2:7, length.out = length(digitos))

# sumar pesos invertidos con los dígitos
suma <- sum(digitos * rev(pesos))

# restar número 11 con el módulo 11 de la suma
digito <- 11 - (suma %% 11)

digito <- as.character(digito)

# casos especiales
digito <- ifelse(digito == "11", "0", digito)
digito <- ifelse(digito == "10", "K", digito)

print(digito)
```

    [1] "6"

Este cálculo está incluido en la función `calcular_digito()` de [mi paquete `{rutera}`](../../../blog/rutera/):

``` r
library(rutera)

calcular_digito(24324110)
```

    [1] "3"

``` r
calcular_digito(
  c(11111111, 
    1111111,
    8519622)
)
```

    [1] "1" "4" "7"

## Validar un RUT

Otra cosa que podemos necesitar hacer con los RUT es verificar si vienen en un formato determinado. En este caso, el formato apropiado será `xxxxxxxx-y`, y esta función verificará: que el RUT contiene un guión, que se sigue el formato `xxxxxxxx-y`, y que el dígito verificador que trae sea el correcto (usando la función `calcular_digito()`):

``` r
library(stringr)
library(cli)

rut <- "11111111-1"

rut <- as.character(rut)
rut <- toupper(rut)

# verificar formato esperado
confirmar_formato <- str_detect(rut, "^[0-9]+-[0-9K]$")

print(confirmar_formato)
```

    [1] TRUE

Luego se podría separar el RUT de su dígito verificador, y confirmar si es correcto usando la función `rutera::calcular_digito()`:

``` r
# validar dígito verificador
digito_verificador <- str_extract(rut, "[0-9K]$")
rut_sin_digito <- str_remove_all(rut, "\\-[0-9K]$")

calcular_digito(rut_sin_digito) == digito_verificador
```

    [1] TRUE

La validación de un RUT completa, incluyendo confirmación del dígito verificador, se puede hacer con la función `validar_rut()` de [mi paquete `{rutera}`](../../../blog/rutera/):

``` r
library(rutera)

validar_rut("17505116-3")
```

    [1] TRUE

``` r
validar_rut("23376940-1")
```

    [1] TRUE

``` r
validar_rut(c("23376940-1", "24444145-9"))
```

    [1] TRUE TRUE

``` r
validar_rut("11111111")
```

    ! RUT 11111111 no incluye guión

    [1] FALSE

``` r
validar_rut(c("hola", "11111111", "19413730-3"))
```

    ! RUT HOLA no incluye guión
    ! RUT 11111111 no incluye guión

    [1] FALSE FALSE  TRUE

## Limpiar RUT

La limpieza de un RUT, a grandes rasgos, consiste en eliminar todos los símbolos que no son numéricos, y luego re-armar la estructura del RUT bajo una estructura estandarizada.

``` r
library(stringr)

rut <- "24.444.145-9"

# eliminar puntos
str_remove_all(rut, "\\.")
```

    [1] "24444145-9"

``` r
# eliminar guiones
str_remove_all(rut, "-")
```

    [1] "24.444.1459"

``` r
# extraer sólo números
str_extract_all(rut, "\\d+", simplify = TRUE) |> 
  paste(collapse = "")
```

    [1] "244441459"

Con la función `limpiar_rut()` de [mi paquete `{rutera}`](../../../blog/rutera/) se realizan todos los pasos de limpieza y se retornan los RUT en formato `xxxxxxx-y`:

``` r
library(rutera)

rut_sucios <- c("24.444.145-9",
                "24444145 9",
                "24 444 145 9",
                "24,444,145,9",
                "2M4A4P4A4C1H4E59",
                "244441459",
                "hola hola")

limpiar_rut(rut_sucios)
```

    ! algunos RUT no tienen últimos dígitos

    ! algunos RUT vacíos luego de la limpieza

    [1] "24444145-9" "24444145-9" "24444145-9" "24444145-9" "24444145-9"
    [6] "24444145-9" NA          

## Paquete de R

{{< relacionada "/blog/rutera/" >}}

## Otros

- [Paquete de R `{clrutr}`, de Joshua Kunst](https://jkunst.com/clrutr/index.html)

{{< etiqueta "Chile" >}}
