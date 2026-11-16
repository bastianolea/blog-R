---
title: Limpiar textos con símbolos, tildes o eñes en R
author: Bastián Olea Herrera
date: '2025-03-31'
modified: '2026-11-16'
slug: []
categories: []
format:
  hugo-md:
    output-file: index
    output-ext: md
tags:
  - consejos
  - texto
  - limpieza de datos
excerpt: >-
  Amamos el castellano, con sus tildes y eñes, y nos encanta que R no tenga
  problemas para usar estos símbolos en cualquier parte del lenguaje. Pero hay
  veces en las que necesitamos deshacernos de estos símbolos especiales. En este
  post te muestro varias opciones de limpieza de texto con R.
---


Amamos el castellano, con sus tildes y eñes, y nos encanta que R no tenga problemas para usar estos símbolos en cualquier parte del lenguaje. Pero hay veces en las que necesitamos deshacernos de estos símbolos especiales, como tildes, eñes, e incluso mayúsculas.

Por ejemplo:
- Si queremos dar nombres a carpetas (porque puede dar conflictos con otros sistemas operativos o para subir archivos a internet),
- Si queremos buscar coincidencias de texto con `stringr::str_detect()` y queremos aumentar probabilidades de coincidir al omitir variaciones de los caracteres,
- Si queremos hacer un `left_join()` entre dos bases de datos con formas distintas de guardar los datos (todos en mayúscula, todos sin tilde pero con eñes, etc.)

Hay muchas formas distintas de hacerlo, dependiendo de lo que necesitemos. El paquete `{stringr}` se enfoca en el procesamiento de texto y tiene varias funciones que nos pueden ayudar.

``` r
library(stringr)

texto <- "El rábido Mapache roñoso mordía al Pingüino"
```

## Reemplazar caracteres específicos

Una mejor opción sería reemplazar los caracteres problemáticos por otros. Por ejemplo, reemplazar letras con tilde por sus versiones sin tilde.

{{< icono "star" >}} **Opción recomendada!**

Para eso podemos usar `str_replace_all()`, que permite recibir un vector con las letras que queremos encontrar y un signo `=` con la letra que reemplazamos en cada caso:

``` r
str_replace_all(texto, c("Ñ"="Ñ", "Á"="A", "É"="E", "Í"="I", "Ó"="O", "Ú"="U", "Ü"="U",
                         "ñ"="ñ", "á"="a", "é"="e", "í"="i", "ó"="o", "ú"="u", "ü"="u" ))
```

    [1] "El rabido Mapache roñoso mordia al Pinguino"

La gracia de este método es que tú tienes el **control total** sobre los reemplazos. En este caso, reemplazamos caracteres con tilde por versiones sin tilde, incluyendo sus versiones en mayúsculas, pero mantenemos las eñes.

Una alternativa es con la función `chartr()`, que viene incluida en R base. Recibe dos textos de igual largo: cada letra del primer texto se reemplaza por la letra que está en la misma posición en el segundo texto. Así, la `Á` se reemplaza por `A`, la `É` por `E`, y así sucesivamente:

``` r
chartr("ÑÁÉÍÓÚÜñáéíóúü", 
       "NAEIOUUnaeiouu", 
       texto)
```

    [1] "El rabido Mapache ronoso mordia al Pinguino"

El resultado es el mismo, y seguimos teniendo control sobre qué letras se reemplazan, pero sin tener que escribir cada par de letras por separado. Como las eñes no están en la lista, se mantienen intactas.

## Eliminar caracteres específicos

Podemos usar `str_remove_all()` para eliminar todos los caracteres problemáticos, separándolos con el operador *o* (`|`):

``` r
str_remove_all(texto, "Ñ|Á|É|Í|Ó|Ú|Ü|ñ|á|é|í|ó|ú|ü")
```

    [1] "El rbido Mapache rooso morda al Pingino"

También se puede hacer al revés con [regex](/blog/stringr_texto/#expresiones-regulares), manteniendo solamente los caracteres que consideramos válidos, por ejemplo, sólo las letras sin tilde y los números:

``` r
str_remove_all(texto, "[^a-zA-Z0-9 ]")
```

    [1] "El rbido Mapache rooso morda al Pingino"

## Transliterar

El paquete para procesamiento de texto `{stringi}` (no confundir con `{stringr}`) cuenta con la función `stri_trans_general()`, que procesa texto para convertirlo o transliterarlo a otros sistemas de escritura. Para lo que necesitamos, podemos pedirle que translitere nuestro texto a ASCII (estándar de texto plano, *American Standard Code for Information Interchange*):

``` r
stringi::stri_trans_general(texto, "Latin-ASCII")  # transliterar, pero remueve eñes
```

    [1] "El rabido Mapache ronoso mordia al Pinguino"

Podemos especificar que mantenga las eñes así:

``` r
stringi::stri_trans_general(texto, "[^ñÑ] Latin-ASCII")
```

    [1] "El rabido Mapache roñoso mordia al Pinguino"

Otra opción podría ser la siguiente, que transforma los símbolos especiales por versiones de varios caracteres que simulan los originales:

``` r
iconv(texto, to = "ASCII//translit") # elimina tildes pero los reaplica como símbolos individuales
```

    [1] "El r'abido Mapache ro~noso mord'ia al Ping\"uino"

El resultado es extraño, pero puede ser que en ciertos casos nos sirva.

## Eliminar símbolos

El paquete `{textclean}` contiene varias funciones avanzadas para limpieza de texto. Una de ellas es `strip()`, que elimina todos los símbolos, pero preservando tildes.

``` r
texto_num <- "Hoy! Súper ricas **empanadas**, a sólo $1.000 pesos... Ñam ñam"
```

``` r
textclean::strip(texto_num)
```

    [1] "hoy súper ricas empanadas a sólo pesos ñam ñam"

El resultado es solamente texto, con tildes y con eñes, pero sin símbolos ni números. Esta función sí posee ciertas opciones para ajustar la limpieza; por ejemplo, no remover números, y dejar sólo símbolos específicos:

``` r
textclean::strip(
  texto_num, 
  digit.remove = FALSE, 
  char.keep = c("!", ".")
)
```

    [1] "hoy! súper ricas empanadas a sólo 1.000 pesos... ñam ñam"

Hay que tener en cuenta que `strip()` también convierte todo el texto a minúsculas por defecto, lo que se puede evitar con el argumento `lower.case = FALSE`.

También se puede usar [regex](/blog/stringr_texto/#expresiones-regulares) para eliminar todos los símbolos. La gracia de *regex* es la flexibilidad de poder seguir especificando los casos que queremos eliminar, en este ejemplo, eliminando toda la puntuación más el símbolo peso:

``` r
str_remove_all(texto_num, "[:punct:]|\\$")
```

    [1] "Hoy Súper ricas empanadas a sólo 1000 pesos Ñam ñam"

## Nombres seguros para web y programación

Uno de los usos más típicos es para nombrar archivos o carpetas, donde se recomienda evitar espacios, puntuaciones y símbolos. Podemos usar `{stringr}` para ésto:

``` r
nombre_original <- "Reporte final Área 11-2026"

nombre_limpio <- str_to_snake(nombre_original)

nombre_limpio <- chartr("ÑÁÉÍÓÚÜñáéíóúü", 
                 "NAEIOUUnaeiouu", 
                 nombre_limpio)
```

Pasamos de <code>Reporte final Área 11-2026</code> a <code>reporte_final_area_11_2026</code>.

{{< etiqueta "texto" >}}
{{< etiqueta "limpieza de datos" >}}
