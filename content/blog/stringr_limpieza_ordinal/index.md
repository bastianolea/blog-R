---
title: >-
  Recodificando variables ordinales cuando vienen sucias y/o desde respuestas
  abiertas
subtitle: Limpieza de datos de encuestas usando R
author: Bastián Olea Herrera
date: '2026-06-18'
slug: []
categories: []
tags:
  - limpieza de datos
  - texto
  - blog
format:
  hugo-md:
    output-file: index
    output-ext: md
editor_options:
  chunk_output_type: console
excerpt: >-
  Siguiendo un caso real de limpieza de datos de una encuesta, en esta
  publicación veremos estrategias para recodificar respuestas de texto abierto
  en variables categóricas u ordinales usando R para pasar de cientos de
  respuestas diferentes a tan sólo 5 categorías.
---


Las **variables ordinales** son aquellas cuyos valores tienen un orden definido, pero la diferencia entre estos valores puede ser variable. Por ejemplo: *bajo, medio* y *alto.*

En este caso me tocó enfrentarme a una encuesta con una variable ordinal que medía **velocidad de internet**, que es por naturaleza una variable contínua (números que representan la velocidad), pero que en este caso fue categorizada en intervalos (pasando del valor `36` a "Entre 20 y 50", por ejemplo) transformándola en una variable ordinal.

Se trata de los datos de la *Encuesta de Realidad Tecnológica Municipal* levantada y publicada por el [Sistema Nacional de Información Municipal](https://www.sinim.gov.cl) (SINIM), que presenta datos de manera anual desde el año 2017.

El **problema** con estos datos fue que, al estar presentes en varias mediciones de una misma encuesta, venía codificada de manera distinta en cada año, incluso con datos en el peor escenario posible: *texto libre* que requiere ser recodificado en categorías.

En esta publicación iremos revisando estos datos del asco y limpiándolos hasta obtener una preciosa variable categórica ordinal a partir de texto limpio y desordenado.

Descarga los datos de prueba[^1] si quieres seguir este post:

{{< boton "Desacargar datos de prueba" "datos_internet.rds" "fas fa-file-download" >}}

Carguemos los datos:

``` r
library(dplyr)
library(readr)

datos <- readr::read_rds("datos_internet.rds")

head(datos)
```

    # A tibble: 6 × 5
        año codigo_comuna nombre_comuna variable         valor              
      <dbl>         <dbl> <chr>         <chr>            <chr>              
    1  2020          1101 Iquique       velocidad_bajada MAS DE 100         
    2  2021          1101 Iquique       velocidad_bajada Mas de 100 megabits
    3  2022          1101 Iquique       velocidad_bajada Más de 100 mb      
    4  2023          1101 Iquique       velocidad_bajada Más de 100         
    5  2024          1101 Iquique       velocidad_bajada Mas de 100         
    6  2025          1101 Iquique       velocidad_bajada Mas de 100         

En esta encuesta, la variable de *velocidad de internet* supuestamente tiene sus datos en intervalos, como "Entre 50 y 100 mb", pero en realidad los datos venían con valores tan disímiles como:

``` r
datos |> 
  distinct(valor) |> 
  slice_sample(n = 10)
```

    # A tibble: 10 × 1
       valor        
       <chr>        
     1 500          
     2 Menos de 100 
     3 93,68 mb     
     4 400          
     5 Menos 20 mb  
     6 150 mb       
     7 Menos De 10mb
     8 Mas der 100  
     9 83 mbps      
    10 10 MB        

Como vemos, son TODOS distintos. Hay 275 valores distintos en la variable! 😰

Por algún motivo, la encuesta preguntó con un campo abierto de texto, antes de estandarizar las posibilidades de respuesta en años más recientes, pero no sin cometer el pecado de mantener un "otros" de texto abierto en caso de que alguien qusiera ponerse creativo/a 🙄

Menciones honrosas a las personas que respondieron velocidades de internet como `1 gb` 🚀, `60mg` 💊, `36.18` ⏱️ y, por algún motivo, `luis antonio reyes espinoza` 👴🏼

Para estandarizar las respuestas de texto abierto, primero conté las más repetidas:

``` r
datos |> 
  count(valor, sort = TRUE)
```

    # A tibble: 275 × 2
       valor                          n
       <chr>                      <int>
     1 Mas de 100                  1023
     2 Entre 50 y menos de 100      560
     3 Más de 100                   405
     4 Más de 100 mb                256
     5 100                          150
     6 No recepcionado              149
     7 Entre 20 y menos de 50       143
     8 100 mb                       120
     9 Entre 50 y menos de 100 mb   105
    10 mas de 100                    70
    # ℹ 265 more rows

Vemos que hay variedad, pero también *cierto patrón.*

Luego, el primer paso de limpieza es cambiar todo a minúsculas con `str_to_lower()` (o a mayúsculas con `str_to_upper()`, pero me carga la gente gritona).

``` r
library(stringr)

# normalizar mayúsculas
datos_2 <- datos |> 
  mutate(valor = str_to_lower(valor))
```

``` r
datos_2 |> 
  count(valor, sort = TRUE)
```

    # A tibble: 217 × 2
       valor                          n
       <chr>                      <int>
     1 mas de 100                  1152
     2 entre 50 y menos de 100      653
     3 más de 100                   419
     4 más de 100 mb                258
     5 entre 20 y menos de 50       166
     6 100                          150
     7 no recepcionado              150
     8 100 mb                       126
     9 entre 50 y menos de 100 mb   109
    10 entre 50 y 100                70
    # ℹ 207 more rows

Con esto pasamos desde 275 a 217 formas diferentes de responder, o sea que habían 58 alternativas de respuesta que solamente se diferenciaban por sus mayúsculas.

Luego, haremos que solamente hayan respuestas que contengan algún número, porque sólo esas nos resultan relevantes para una variable de velocidad de internet.

Para dejar solamente **datos que incluyan números** usaremos `str_detect()` para detectar observaciones con el *regex* `\\d`, que representa a cualquier dígito (también serviría `[0-9]`).

Por ejemplo:

``` r
library(stringr)

valores <- c(1, 2, 3, "hola", "4 mapaches", NA)

str_detect(valores, "\\d")
```

    [1]  TRUE  TRUE  TRUE FALSE  TRUE    NA

Entonces, si un valor *no* contiene un número, convertiremos la observación en `NA` con `if_else()`.

``` r
if_else(
  str_detect(valores, "\\d"),
  true = valores,
  false = NA
)
```

    [1] "1"          "2"          "3"          NA           "4 mapaches"
    [6] NA          

Entonces, vamos así con la limpieza:

``` r
# dejar solamente observaciones con números
datos_3 <- datos_2 |>
  mutate(valor = if_else(
    str_detect(valor, "\\d"), 
    valor, 
    NA)
  )
```

``` r
datos_3 |> 
  count(valor, sort = TRUE)
```

    # A tibble: 215 × 2
       valor                          n
       <chr>                      <int>
     1 mas de 100                  1152
     2 entre 50 y menos de 100      653
     3 más de 100                   419
     4 más de 100 mb                258
     5 entre 20 y menos de 50       166
     6 <NA>                         153
     7 100                          150
     8 100 mb                       126
     9 entre 50 y menos de 100 mb   109
    10 entre 50 y 100                70
    # ℹ 205 more rows

Bajamos a 215 respuestas posibles! 👏🏼

Ahora viene la parte más cabezona, que es **detectar patrones** en los datos. Si nos fijamos, varias respuestas siguen el patrón *"entre `x` y menos de `x` mb"*. Podemos detectar este patrón con *regex*, donde en realidad nos interesan los números que indican: *"entre 10 y 20 mb"*, *"entre 50 y 100 mb"*, etcétera.

Para esto, usaremos nuevamente `str_detect()` y usaremos dos expresiones de *regex*:
- La expresión `.*`, que significa "cualquier cantidad de caracteres" o "cualquier cosa", que nos permitirá detectar dos números con cualquier cantidad de caracteres entre ellos.
- La expresión `\\b` que representa el borde de una palabra; es decir, ya sea un espacio que separa la palabra con otra, o el fin del texto, entre otras. De esta forma, si buscamos `50\\b` detectaremos `50 mapaches` pero no `500 mapaches`.

``` r
valores <- c(
  "50 gigabites",
  "entre 80 y 100",
  "entre 50 y menos de 100 mb",
  "entre 500 mb y menos de 1000 mb"
)

str_detect(valores, "50\\b.*100")
```

    [1] FALSE FALSE  TRUE FALSE

Pero además queremos que cada detección que hagamos nos permita **recodificar** los datos a una forma estandarizada. Para esto pondremos el `str_detect()` dentro de `case_when()`, función que nos permitirá recodificar para cada caso un valor distinto:

``` r
datos_4 <- datos_3 |> 
  mutate(valor = case_when(
    # mención de términos/cifras específicas
    str_detect(valor, "50\\b.*100") ~ "Entre 50 y menos de 100 mb",
    str_detect(valor, "20\\b.*50") ~  "Entre 20 y menos de 50 mb",
    str_detect(valor, "10\\b.*20") ~  "Entre 10 y menos de 20 mb",
    .default = valor)
  )
```

``` r
datos_4 |> 
  count(valor, sort = TRUE)
```

    # A tibble: 150 × 2
       valor                          n
       <chr>                      <int>
     1 mas de 100                  1152
     2 Entre 50 y menos de 100 mb   975
     3 más de 100                   419
     4 Entre 20 y menos de 50 mb    283
     5 más de 100 mb                258
     6 <NA>                         153
     7 100                          150
     8 100 mb                       126
     9 Entre 10 y menos de 20 mb    102
    10 menos de 10                   67
    # ℹ 140 more rows

Increíble, bajamos de 215 valores únicos a 150! 🎉

Es importante recordar poner `.default` al final del `case_when()` para que los textos no coincididos se mantengan sin cambios.

Usando la misma técnica podemos hacernos cargo de otros casos que mencionan números y que podemos adecuar a las categorías de respuesta estandarizadas:
- Los que mencionan *gigabits*, que evidentemente son mayores a 100 megabits.
- Los que dicen "más de 100", pero considerando la palabra con o sin tilde usando la expresión `(mas|más)`, que coincide con ambas formas, y junto a `.*` para abarcar casos que digan cualquier cosa entre el "más" y el "100"
- Los casos que dicen "menor a 10", considerando varias formas de escribirlo y el borde de la palabra con `\\b`.

``` r
datos_5 <- datos_4 |> 
  mutate(valor = case_when(
    # mención de términos/cifras específicas
    str_detect(valor, "gb") ~ "Más de 100 mb",
    str_detect(valor, "(mas|más).*100") ~ "Más de 100 mb",
    str_detect(valor, "(menos|menor).*10\\b") ~ "Menos de 10 mb",
    .default = valor)
  )

datos_5 |> 
  count(valor, sort = TRUE)
```

    # A tibble: 131 × 2
       valor                          n
       <chr>                      <int>
     1 Más de 100 mb               1864
     2 Entre 50 y menos de 100 mb   975
     3 Entre 20 y menos de 50 mb    283
     4 <NA>                         153
     5 100                          150
     6 100 mb                       126
     7 Entre 10 y menos de 20 mb    102
     8 Menos de 10 mb                90
     9 200 mb                        21
    10 200                           20
    # ℹ 121 more rows

Con estos casos puntuales resueltos, bajamos a 131 🏅

Si vemos los conteos, ahora van quedando casi puras formas de responder que simplemente entregan un número:

``` r
datos_5 |> 
  distinct(valor) |> 
  slice_sample(n = 10)
```

    # A tibble: 10 × 1
       valor                
       <chr>                
     1 100mbps 10 mbps      
     2 32                   
     3 80 mb                
     4 4 mb                 
     5 100/100              
     6 15 mb                
     7 mas 10               
     8 menor o igual que 100
     9 100 mb de subida     
    10 300                  

Para abarcar estos casos, usaremos un truquito de `regex` que ya vimos: la expresión *o* (`|`). Si queremos hacer que una búsqueda de texto con `str_detect()` coincida con varios números, hacemos esto:

``` r
valores <- c(1, 2, 3, 4, 5, 6)

str_detect(valores, "1|2|3|4|5")
```

    [1]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE

En el fondo le decimos *encuentra 1 o 2 o 3...* Entonces podemos **construir expresiones** que abarquen grandes cantidades de números, y usarlas para recodificar valores que en cualquier lugar del texto contengan esos números. Por ejemplo, para abarcar todos los valores entre 50 y 100:

``` r
paste(50:99, collapse = "|")
```

    [1] "50|51|52|53|54|55|56|57|58|59|60|61|62|63|64|65|66|67|68|69|70|71|72|73|74|75|76|77|78|79|80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|97|98|99"

Dios mío, qué eficiencia 🥹 Ahora es cosa de usar eso dentro de un `case_when()` para que cualquier observación que tenga ciertos números clasifique dentro de la categoría que le corresponda:

``` r
datos_6 <- datos_5 |> 
  mutate(valor = case_when(
    str_detect(valor, paste(100:999, collapse = "|")) ~ "Más de 100 mb",
    str_detect(valor, paste(050:099, collapse = "|")) ~ "Entre 50 y menos de 100 mb",
    str_detect(valor, paste(020:049, collapse = "|")) ~ "Entre 20 y menos de 50 mb",
    str_detect(valor, paste(010:019, collapse = "|")) ~ "Entre 10 y menos de 20 mb",
    str_detect(valor, paste(001:009, collapse = "|")) ~ "Menos de 10 mb",
    .default = valor)
  )
```

``` r
datos_6 |> 
  count(valor, sort = TRUE)
```

    # A tibble: 6 × 2
      valor                          n
      <chr>                      <int>
    1 Más de 100 mb               3317
    2 Entre 50 y menos de 100 mb   384
    3 Entre 20 y menos de 50 mb    167
    4 <NA>                         153
    5 Entre 10 y menos de 20 mb    115
    6 Menos de 10 mb                 4

Impresionanteeeeee lo logramos! 🔥 Bajamos de 131 a 6 posibilidades de respuesta!

Pero **ALTO!** Cometimos un error! 💀 Esta última estrategia va a aplicarse sobre las recodificaciones anteriores también! Si pisamos las recodificaciones anteriores podemos arruinarlo todo!

Para **dejar intactas las recodificaciones anteriores**, y que las siguientes sólo se apliquen a los valores aún no recodificados, podríamos haber ido paso a paso creando columnas nuevas (`valor_1`, `valor_2`, etc.) y después unirlas con `coalesce()`, o bien podemos aprovechar un principio importante de `case_when()`, que es que si usas múltiples condicionales, las observaciones recodificadas por una condición **se excluyen** de las siguientes condicionales; es decir, las que son cambiadas por un `str_detect()` no vuelven a cambiarse con las siguientes condicionales, aunque coincidan. Esto significa que, si unimos todos los `case_when()` en uno sólo, tendremos una recodificación correcta. Y para poder confirmarlo, recodificaremos a una variable nueva (`valor_recod`) que nos permita verificar, en vez de ir pisando la variable original (`valor`):

``` r
datos_recod <- datos |>
  # normalizar mayúsculas
  mutate(valor = str_to_lower(valor)) |>
  # solamente observaciones con números
  mutate(valor = if_else(str_detect(valor, "\\d"), valor, NA)) |>
  # caso a caso
  mutate(valor_recod = case_when(
    # mención de términos/cifras específicas
    str_detect(valor, "gb") ~ "Más de 100 mb",
    str_detect(valor, "(mas|más).*100") ~ "Más de 100 mb",
    str_detect(valor, ".*50\\b.*100") ~ "Entre 50 y menos de 100 mb",
    str_detect(valor, ".*20\\b.*50") ~  "Entre 20 y menos de 50 mb",
    str_detect(valor, ".*10\\b.*20") ~  "Entre 10 y menos de 20 mb",
    str_detect(valor, "(menos|menor).*10($| )") ~ "Menos de 10 mb",
    # mención de cifras intermedias
    str_detect(valor, paste(100:999, collapse = "|")) ~ "Más de 100 mb",
    str_detect(valor, paste(050:099, collapse = "|")) ~ "Entre 50 y menos de 100 mb",
    str_detect(valor, paste(020:049, collapse = "|")) ~ "Entre 20 y menos de 50 mb",
    str_detect(valor, paste(010:019, collapse = "|")) ~ "Entre 10 y menos de 20 mb",
    str_detect(valor, paste(001:009, collapse = "|")) ~ "Menos de 10 mb",
    .default = valor)
  )
```

``` r
datos_recod |> 
  count(valor_recod, sort = TRUE)
```

    # A tibble: 6 × 2
      valor_recod                    n
      <chr>                      <int>
    1 Más de 100 mb               2348
    2 Entre 50 y menos de 100 mb  1072
    3 Entre 20 y menos de 50 mb    346
    4 <NA>                         153
    5 Entre 10 y menos de 20 mb    129
    6 Menos de 10 mb                92

Estupendo, el resultado final y correcto pasó de los 275 valores posibles originales a tan solo 6 categorías bien escritas.

Confirmemos que las recodificaciones fueron correctas:

``` r
datos_recod |>
  filter(valor_recod == "Entre 50 y menos de 100 mb") |>
  count(valor_recod, valor, sort = TRUE) |>
  print(n = 10)
```

    # A tibble: 73 × 3
       valor_recod                valor                          n
       <chr>                      <chr>                      <int>
     1 Entre 50 y menos de 100 mb entre 50 y menos de 100      653
     2 Entre 50 y menos de 100 mb entre 50 y menos de 100 mb   109
     3 Entre 50 y menos de 100 mb entre 50 y 100                70
     4 Entre 50 y menos de 100 mb entre 50 y 100 mb             30
     5 Entre 50 y menos de 100 mb 50                            20
     6 Entre 50 y menos de 100 mb 50 mb                         17
     7 Entre 50 y menos de 100 mb 50 y menos de 100             14
     8 Entre 50 y menos de 100 mb 50-100                        14
     9 Entre 50 y menos de 100 mb 50 y 100                      12
    10 Entre 50 y menos de 100 mb entre 50 y menos 100           9
    # ℹ 63 more rows

``` r
datos_recod |>
  filter(valor_recod == "Entre 20 y menos de 50 mb") |>
  count(valor_recod, valor, sort = TRUE) |>
  print(n = 10)
```

    # A tibble: 42 × 3
       valor_recod               valor                         n
       <chr>                     <chr>                     <int>
     1 Entre 20 y menos de 50 mb entre 20 y menos de 50      166
     2 Entre 20 y menos de 50 mb entre 20 y menos de 50 mb    39
     3 Entre 20 y menos de 50 mb entre 20 y 50                21
     4 Entre 20 y menos de 50 mb 30                           16
     5 Entre 20 y menos de 50 mb 20                           10
     6 Entre 20 y menos de 50 mb 20 mb                        10
     7 Entre 20 y menos de 50 mb 30 mb                         9
     8 Entre 20 y menos de 50 mb 20 y 50                       8
     9 Entre 20 y menos de 50 mb 20 a 50 mb                    7
    10 Entre 20 y menos de 50 mb 20-50                         6
    # ℹ 32 more rows

Todo en orden! Espero que te haya servido esta experiencia de recodificación de datos sucios 🥰

{{< etiqueta "limpieza de datos" >}}

## Referencias

- [Sistema Nacional de Información Municipal, *Evolución y Tendencias*](https://www.sinim.gov.cl/CentroDescargas/EvolTend_elec.php)

{{< cafecito >}}

[^1]: Los datos originales de la encuesta de Realidad Tecnológica Municipal [están disponibles aquí.](https://www.sinim.gov.cl/CentroDescargas/EvolTend_elec.php)
