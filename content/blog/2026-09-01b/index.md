---
title: Formatear fechas en español en R
author: Bastián Olea Herrera
date: '2026-09-01'
slug: []
categories: []
tags:
  - fechas
draft: false
format:
  hugo-md:
    output-file: index
    output-ext: md
execute:
  message: false
  warning: false
excerpt: >-
  Cuando trabajamos con fechas, a veces necesitamos formatear o redactar las
  fechas en español, para pasar de números a un texto que redacte la fecha. Para
  eso tenemos en R la función `format()`, de manera que el mes `03` pasa a ser
  _marzo_.
links:
  - icon: registered
    icon_pack: fas
    name: Lubridate
    url: https://lubridate.tidyverse.org
---


Cuando trabajamos con fechas, a veces necesitamos formatear o redactar las fechas en español, para pasar de números a un texto que redacte la fecha. Para eso tenemos en R la función `format()`.

Primero creemos una fecha con la función `today()` de `{lubridate}`:

``` r
library(lubridate)

fecha <- today()

fecha
```

    [1] "2026-09-01"

Obtenemos como resultado literalmente el dato que contiene la fecha, que en R (y en el mundo desarrollado) vienen siempre como `año-mes-día`.

Si queremos redactar esta información distinto, usamos `format()`. Por ejemplo, cambiemos de año/mes/día a día/mes/año:

``` r
format(fecha, "%d-%m-%Y")
```

    [1] "01-09-2026"

Así convertimos una fecha que viene en formato fecha a un texto (ojo, deja de ser una fecha!) redactado en `día-mes-año`. También podemos hacer cosas más personalizadas:

``` r
format(fecha, "día: %d, mes: %m, año: %Y")
```

    [1] "día: 01, mes: 09, año: 2026"

En los textos, `%d`, `%m` y `%Y` representan a los días, meses y años, respectivamente. Si cambiamos la `%Y` a `%y`, obtenemos el año en dos dígitos:

``` r
format(fecha, "%d del %m de %y")
```

    [1] "01 del 09 de 26"

## Redactar fechas como texto en castellano

Si queremos que los meses pasen a llamarse por sus nombres en lugar de sus números (`03` sería *marzo*), reemplazamos `%m` por `%B`:

``` r
format(fecha, "%d de %B de %Y")
```

    [1] "01 de September de 2026"

Pero, *oh my God*, el mes sale en inglés![^1]

Esto puede ser porque R o el sistema operativo está configurado en inglés. Podemos cambiar el idioma o *locale* de R con `Sys.setlocale("LC_TIME", "es_ES")`, pero esta es una configuración temporal que [no es reproducible](/tags/reproducibilidad/), porque afecta a todas las funciones que ejecutemos después, y el resultado dependerá de si alguien ejecutó o no eso antes. Pero usando el [paquete `{withr}`](https://withr.r-lib.org) podemos ejecutar código de R con una configuración temporal, para que no afecte el resto de la sesión ni el código futuro:

``` r
fecha_formateada <- withr::with_locale(
  c("LC_TIME" = "es_ES"),
  format(fecha, "%d de %B de %Y")
)
```

Ahora veamos el resultado:

``` r
fecha_formateada
```

    [1] "01 de septiembre de 2026"

Incluso podrías convertir un vector del 1 al 12 a los nombres de meses correspondientes:

``` r
meses <- 1:12

# convertir números de meses a fechas
fechas <- paste("2026", meses, "01", sep = "-") |> as_date()

# convertir fechas a meses en texto
meses_texto <- withr::with_locale(
  c("LC_TIME" = "es_ES"),
  format(fechas, format = "%B")
)

meses_texto
```

     [1] "enero"      "febrero"    "marzo"      "abril"      "mayo"      
     [6] "junio"      "julio"      "agosto"     "septiembre" "octubre"   
    [11] "noviembre"  "diciembre" 

{{< etiqueta "fechas" >}}

[^1]: Quizás en tu sistema salga en español, pero yo tengo configurado mi R en inglés, upsy!
