---
title: >-
  `{poblador}`: datos de población de Chile y funciones para agregar datos
  poblacionales fácilmente
subtitle: >-
  Complementa tablas de datos territoriales agregando población de distintos
  Censos y fuentes oficiales de manera automática
author: Bastián Olea Herrera
date: '2026-11-13'
slug: []
categories:
  - Paquetes
tags:
  - paquetes
  - datos
  - Chile
draft: false
format:
  hugo-md:
    output-file: index
    output-ext: md
execute:
  message: false
  warning: false
excerpt: >-
  Este paquete de R ofrece tablas de datos de población desde fuentes oficiales
  de Chile, como `censo_poblacion_2024`, así como funciones para simplificar el
  uso de estos datos como complemento a otros conjuntos de datos, como para
  agregar población oficial a una tabla de comunas o regiones con
  `agregar_poblacion()`, entre otras.
links:
  - icon: registered
    icon_pack: fas
    name: Sitio del paquete
    url: https://bastianolea.github.io/poblador/
  - icon: registered
    icon_pack: fas
    name: Funciones
    url: https://bastianolea.github.io/poblador/reference/index.html
---


<a href="https://bastianolea.github.io/poblador/"><img src="hex-featured.png" align="right" height="180" alt="poblador website" /></a>

Les presento mi nuevo paquete de R, `{poblador}`: una solución para complementar datos territoriales de Chile con cifras de población oficiales.

El paquete se basa en una serie de tablas de datos de población oficiales, preprocesados a nivel comunal, que puedes revisar con `poblador::catalogo()`.

Para cualquier tabla de datos con comunas o regiones de Chile, simplemente le aplicas `agregar_poblacion()` y listo, se crea la columna `poblacion` con los habitantes correspondientes a la proyección censal para el año actual. Si necesitas agregar la población del nuevo Censo 2024, `agregar_poblacion(base = censo_poblacion_2024)`.

También puedes obtener las cifras de población de territorios puntuales con `obtener_poblacion("Puente Alto")`, así de simple! Muy útil para reportes automatizados, redacción de textos parametrizados, o aplicaciones web.

Las funciones del paquete infieren automáticamente si tus datos son comunales, regionales o nacionales, y funcionan sobre nombres de territorios o sus códigos únicos (CUT), [gracias al paquete `{territorial}`.](/blog/territorial)

Más información, documentación y ejemplos con datos reales [en el sitio del paquete](https://bastianolea.github.io/poblador/)

{{< paquete "Paquete `{poblador}`"   "https://bastianolea.github.io/poblador/"   "hex-featured.png"   "Datos de población para Chile y funciones para agregar datos poblacionales fácilmente a otras tablas de datos." >}}

Este paquete ofrece tablas de datos de población desde fuentes oficiales de Chile, como `censo_poblacion_2024`, así como funciones para simplificar el uso de estos datos como complemento a otros conjuntos de datos, como para agregar población oficial a una tabla de comunas o regiones con `agregar_poblacion()`, entre otras.

El funcionamiento interno de este paquete depende bastante del [paquete `{territorial}`](https://bastianolea.github.io/territorial/), que entrega herramientas para trabajar con datos que representan comunas y regiones de Chile.

## Instalación

Instala el paquete a R desde [R-Universe](https://bastianolea.r-universe.dev/poblador):

``` r
install.packages('poblador', repos = c('https://bastianolea.r-universe.dev'))
```

También puedes instalar desde GitHub:

``` r
# install.packages("pak")
pak::pak("bastianolea/poblador")
```

Para que `{poblador}` funcione, necesitas [tener instalado `{territorial}`](https://bastianolea.github.io/territorial/#instalación). Si no lo tienes, instálalo con:

``` r
install.packages("territorial", repos = "https://bastianolea.r-universe.dev")
```

## Datos de población

Uno de los aspectos principales de `{poblador}` es que contiene bases de datos de población procesadas [a partir de las fuentes oficiales](https://github.com/bastianolea/poblador/tree/main/data-raw) a nivel comunal. Las principales son los últimos dos Censos de población (2017 y 2024), junto a las proyecciones de población oficiales (en base al Censo 2017).

La función `catalogo()` te muestra todas las fuentes de datos disponibles en el paquete, incluído el nombre que tienen para cargarlas en R, sus características y fuentes:

``` r
library(poblador)

catalogo()
```

{{< detalles "**Ver el catálogo de datos generado por `catalogo()`**" >}}

        ── Datos disponibles en poblador ───────────────────────────────────────────────

        ── Población a nivel comunal de Chile (2017) ──

        • Objeto: `censo_poblacion_2017`

        • Tabla de 346 y 8 columnas

        • Años: 2017

        • Cantidad de comunas únicas: 346

        • Fuente: Instituto Nacional de Estadísticas de Chile (INE),
        <https://www.ine.gob.cl/estadisticas-por-tema/demografia-y-poblacion/censo-de-poblacion-y-vivienda>

        ── Población censada a nivel comunal de Chile (2024) ──

        • Objeto: `censo_poblacion_2024`

        • Tabla de 346 y 8 columnas

        • Años: 2024

        • Cantidad de comunas únicas: 346

        • Fuente: Instituto Nacional de Estadísticas de Chile (INE),
        <https://censo2024.ine.gob.cl/resultados/>

        ── Proyecciones de población a nivel comunal de Chile (2002-2035), base Censo 2017 ──

        • Objeto: `censo_poblacion_proyeccion`

        • Tabla de 11764 y 8 columnas

        • Las proyecciones de población proporcionan una referencia del futuro tamaño y
        estructura por edades de una población, basados en un conjunto de supuestos
        sobre el comportamiento de los componentes demográficos fecundidad, mortalidad
        y migración. Son un insumo fundamental para la planificación y la toma de
        decisiones tanto para el sector público como el privado, dado que permiten
        anticipar demandas futuras e identificar desafíos que surgen como consecuencia
        de los cambios demográficos.

        • Años: entre 2002 y 2035

        • Cantidad de comunas únicas: 346

        • Fuente: Instituto Nacional de Estadísticas de Chile (INE),
        <https://www.ine.gob.cl/estadisticas-por-tema/demografia-y-poblacion/estimaciones-y-proyecciones-de-poblacion>

        ── Población en situación de pobreza por ingresos a nivel comunal (2024) ──

        • Objeto: `mideso_pobreza_ingresos`

        • Tabla de 345 y 8 columnas

        • Cifras de población en situación de pobreza, calculadas por el Ministerio de
        Desarrollo Social y Familia a partir de datos de la Encuesta de Caracterización
        Socioeconómica Nacional 2024 (Casen 2024), por medio de la aplicación de la
        metodología de áreas pequeñas o SAE.

        • Años: 2024

        • Cantidad de comunas únicas: 345

        • Fuente: Ministerio de Desarrollo Social y Familia (Mideso),
        <https://bidat.gob.cl/details/ficha/dataset/base-de-datos-pobreza-comunal-2024>

        ── Población en situación de pobreza multidimensional a nivel comunal (2024) ──

        • Objeto: `mideso_pobreza_multi`

        • Tabla de 345 y 8 columnas

        • Cifras de población en situación de pobreza, calculadas por el Ministerio de
        Desarrollo Social y Familia a partir de datos de la Encuesta de Caracterización
        Socioeconómica Nacional 2024 (Casen 2024), por medio de la aplicación de la
        metodología de áreas pequeñas o SAE. La medición de pobreza multidimensional se
        calcula a partir de 5 dimensiones, cada una con 4 indicadores: Educación,
        Salud, Trabajo y Seguridad Social, Vivienda y Entorno, y Redes y Cohesión
        Social.

        • Años: 2024

        • Cantidad de comunas únicas: 345

        • Fuente: Ministerio de Desarrollo Social y Familia (Mideso),
        <https://bidat.gob.cl/details/ficha/dataset/base-de-datos-pobreza-comunal-2024>

{{< /detalles >}}

Luego de consultar `catalogo()`, vemos que la tabla del Censo 2024 se llama `censo_poblacion_2024`, así que podemos explorarla:

``` r
library(dplyr)
```

``` r
censo_poblacion_2024 |> 
  head() |> 
  glimpse()
```

    Rows: 6
    Columns: 8
    $ codigo_region    <dbl> 1, 1, 1, 1, 1, 1
    $ nombre_region    <chr> "Tarapacá", "Tarapacá", "Tarapacá", "Tarapacá", "Tara…
    $ codigo_provincia <dbl> 11, 11, 14, 14, 14, 14
    $ nombre_provincia <chr> "Iquique", "Iquique", "Tamarugal", "Tamarugal", "Tama…
    $ codigo_comuna    <dbl> 1101, 1107, 1401, 1405, 1404, 1402
    $ nombre_comuna    <chr> "Iquique", "Alto Hospicio", "Pozo Almonte", "Pica", "…
    $ año              <dbl> 2024, 2024, 2024, 2024, 2024, 2024
    $ poblacion        <int> 199587, 142086, 16878, 6272, 2858, 1335

Puedes usar estas fuentes de datos para consularlas, [cruzarlas con otras tablas](https://bastianolea.rbind.io/blog/left_join/), o su uso principal, que es usarlas para alimentar a la función `agregar_poblacion()`, como veremos a continuación.

Todas las tablas de datos del paquete siguen esta estructura de
`codigo_region`, `nombre_region`, `codigo_comuna` y `nombre_comuna` (heredada del [paquete `{territorial}`](https://bastianolea.github.io/territorial/)), además de contener `año` y `poblacion`.

## Agregar población a tus datos

El fuerte de `{poblador}` es agregar datos de población a otras fuentes de datos con las que trabajes. La función `agregar_poblacion()` recibe una tabla de datos o *dataframe* y le agrega una columna `poblacion` con los datos oficiales de población.

Para probar `agregar_poblacion()`, creemos una tabla de datos de nivel **comunal** como ejemplo.

<details class="code-fold">
<summary>Ver código de tabla</summary>

``` r
library(dplyr)

comunas <- tibble::tribble(
  ~nombre_comuna, ~codigo_comuna,
  "La Florida",    13110,
  "Puente Alto",   13201,
  "La Pintana",    13112, 
  "San Joaquín",   13129
)

comunas
```

</details>

    # A tibble: 4 × 2
      nombre_comuna codigo_comuna
      <chr>                 <dbl>
    1 La Florida            13110
    2 Puente Alto           13201
    3 La Pintana            13112
    4 San Joaquín           13129

Ahora, a estos datos de ejemplo les agregamos la población que corresponde a cada fila:

``` r
library(poblador)

comunas |> 
  agregar_poblacion()
```

    # A tibble: 4 × 3
      nombre_comuna codigo_comuna poblacion
      <chr>                 <dbl>     <dbl>
    1 La Florida            13110    408195
    2 Puente Alto           13201    674064
    3 La Pintana            13112    188629
    4 San Joaquín           13129    102504

Así de simple! La tabla recibió una columna con la población oficial, descrita por el mensaje en la consola. La función detectó automáticamente que se trataba de datos comunales (por la presencia de las columnas `codigo_comuna` o `nombre_comuna`, y por defecto agregó la población del año actual.

Por defecto, la población se obtiene de las [proyecciones oficiales del INE](https://www.ine.gob.cl/estadisticas-por-tema/demografia-y-poblacion/estimaciones-y-proyecciones-de-poblacion) (ver `poblador::censo_poblacion_proyeccion`). Esto significa que puedes agregar datos de cualquier otro año, por ejemplo, del año 2020:

``` r
comunas |> 
  agregar_poblacion(
    nivel = "comunal",
    años = 2020)
```

    # A tibble: 4 × 3
      nombre_comuna codigo_comuna poblacion
      <chr>                 <dbl>     <dbl>
    1 La Florida            13110    402433
    2 Puente Alto           13201    645909
    3 La Pintana            13112    189335
    4 San Joaquín           13129    103485

### Datos regionales

Como vimos antes, las funciones de `{poblador}` detectan automáticamente el nivel de los datos. Probemos ahora con datos regionales, creando una nueva tabla de ejemplo.

<details class="code-fold">
<summary>Ver código de tabla</summary>

``` r
regiones <- tibble::tribble(
  ~nombre_region, ~codigo_region,
  "Maule",         7,
  "Ñuble",         16,
  "Biobío",        8,
  "La Araucanía",  9
)

regiones
```

</details>

    # A tibble: 4 × 2
      nombre_region codigo_region
      <chr>                 <dbl>
    1 Maule                     7
    2 Ñuble                    16
    3 Biobío                    8
    4 La Araucanía              9

A esta nueva tabla de datos le agregamos la población con `agregar_poblacion()`:

``` r
regiones |> 
  agregar_poblacion()
```

    # A tibble: 4 × 3
      nombre_region codigo_region poblacion
      <chr>                 <dbl>     <dbl>
    1 Maule                     7   1189907
    2 Ñuble                    16    525925
    3 Biobío                    8   1694602
    4 La Araucanía              9   1039468

Nuevamente el nivel territorial se asume automático.

## Población desde otras fuentes

El argumento `base` de `agregar_poblacion()` permite usar otras fuentes de datos de población, ya sean las incluídas en el paquete (ver `catalogo()`), o incluso tus propias tablas de población (que sigan las convenciones del paquete).

Probemos agregando a la tabla de regiones los datos de un Censo oficial específico, en este caso del Censo 2017 (disponible en el objeto `censo_poblacion_2017`):

``` r
regiones |> 
  agregar_poblacion(
    nivel = "regional",
    base = censo_poblacion_2017)
```

    # A tibble: 4 × 3
      nombre_region codigo_region poblacion
      <chr>                 <dbl>     <dbl>
    1 Maule                     7   1044950
    2 Ñuble                    16    480609
    3 Biobío                    8   1556805
    4 La Araucanía              9    957224

Como las tablas de datos usadas por `{poblador}` vienen en nivel comunal, al procesar datos regionales, `agregar_poblacion()` toma los datos comunales y los suma para obtener los regionales.

## Datos socioeconómicos

Entre las distintas bases de datos incluídas, el paquete incluye datos socioeconómicos, como las estimaciones de pobreza a nivel comunal en las tablas `mideso_pobreza_ingresos` y `mideso_pobreza_multi` (usa `poblador::catalogo()` para ver todas las bases).

Por ejemplo:

``` r
mideso_pobreza_ingresos
```

    # A tibble: 345 × 8
       codigo_region nombre_region codigo_provincia nombre_provincia codigo_comuna
               <dbl> <chr>                    <dbl> <chr>                    <dbl>
     1             1 Tarapacá                    11 Iquique                   1101
     2             1 Tarapacá                    11 Iquique                   1107
     3             1 Tarapacá                    14 Tamarugal                 1401
     4             1 Tarapacá                    14 Tamarugal                 1402
     5             1 Tarapacá                    14 Tamarugal                 1403
     6             1 Tarapacá                    14 Tamarugal                 1404
     7             1 Tarapacá                    14 Tamarugal                 1405
     8             2 Antofagasta                 21 Antofagasta               2101
     9             2 Antofagasta                 21 Antofagasta               2102
    10             2 Antofagasta                 21 Antofagasta               2103
    # ℹ 335 more rows
    # ℹ 3 more variables: nombre_comuna <chr>, año <dbl>, poblacion <dbl>

Creemos una tabla de comunas de ejemplo para probar los datos socioeconómicos.

<details class="code-fold">
<summary>Ver código de tabla</summary>

``` r
library(dplyr)

comunas <- tibble::tribble(
  ~nombre_comuna, ~codigo_comuna,
  "La Florida",   13110,
  "Puente Alto",  13201,
  "La Pintana",   13112,
  "Las Condes",   13114
)

comunas
```

</details>

    # A tibble: 4 × 2
      nombre_comuna codigo_comuna
      <chr>                 <dbl>
    1 La Florida            13110
    2 Puente Alto           13201
    3 La Pintana            13112
    4 Las Condes            13114

Para usar las bases de datos socioeconómicos, simplemente las agregamos al argumento `base` de `agregar_poblacion()` o de `obtener_poblacion()`:

``` r
comunas |> 
  agregar_poblacion(base = mideso_pobreza_ingresos)
```

    # A tibble: 4 × 3
      nombre_comuna codigo_comuna poblacion
      <chr>                 <dbl>     <dbl>
    1 La Florida            13110    48429.
    2 Puente Alto           13201    92515.
    3 La Pintana            13112    44008.
    4 Las Condes            13114     9558.

En este ejemplo agregamos la población comunal estimada de habitantes en situación de pobreza por ingresos, según la encuesta Casen.

Si usamos `agregar_poblacion()` consecutivamente, podemos agregar tanto la población comunal como la población en situación de pobreza, a partir de lo cual podemos calcular el **porcentaje de pobreza** en pocas líneas:

``` r
comunas |> 
  # agregar habitantes en 2024
  agregar_poblacion(
    base = censo_poblacion_2024) |> 
  # agregar población en situación de pobreza
  agregar_poblacion(
    base = mideso_pobreza_ingresos,
    nombre = "pobreza") |> 
  # calcular porcentaje
  mutate(porcentaje = (pobreza/poblacion)*100)
```

    # A tibble: 4 × 5
      nombre_comuna codigo_comuna poblacion pobreza porcentaje
      <chr>                 <dbl>     <int>   <dbl>      <dbl>
    1 La Florida            13110    374836  48429.      12.9 
    2 Puente Alto           13201    568086  92515.      16.3 
    3 La Pintana            13112    175421  44008.      25.1 
    4 Las Condes            13114    296134   9558.       3.23

## Obtener población de territorios

También se puede obtener la población de territorios específicos con `obtener_poblacion()`. Funciona casi idéntico a `agregar_poblacion()`, sólo que sobre vectores de datos como nombres o códigos territoriales.

De esta manera podemos obtener fácilmente la población de una o varias comunas (notando que la función infiere automáticamente que se trata de comunas):

``` r
obtener_poblacion("La Florida")
```

    [1] 408195

También podemos entregar [códigos únicos territoriales](https://bastianolea.github.io/territorial/articles/codigos_unicos_territoriales.html):

``` r
obtener_poblacion(c(13102, 13201))
```

    [1]  90328 674064

Esta forma de obtener datos de población sirve principalmente para [reportes Quarto](https://bastianolea.rbind.io/blog/quarto_reportes/) o [aplicaciones Shiny](https://bastianolea.rbind.io/blog/shiny/); por ejemplo, en la [redacción de un párrafo](https://bastianolea.rbind.io/blog/redactar_texto/) basado en datos:

``` r
comuna <- "Ñuñoa"

glue::glue("La comuna de {comuna} tiene una población de {obtener_poblacion(comuna)} habitantes.")
```

    La comuna de Ñuñoa tiene una población de 274180 habitantes.

Al igual que con `agregar_poblacion()`, al basarse por defecto en las proyecciones de población del INE se puede solicitar la proyección de población de cualquier territorio en un año específico:

``` r
obtener_poblacion("La Florida", años = 2030)
```

    [1] 409368

También puedes usar `obtener_poblacion()` dentro de `mutate()` al crear o modificar columnas de un *dataframe*:

<details class="code-fold">
<summary>Ver código de tabla</summary>

``` r
library(dplyr)

comunas <- territorial::territorios |>
  filter(codigo_region == 15) |>
  select(nombre_comuna, codigo_comuna)
```

</details>

``` r
comunas |>
  mutate(poblacion = obtener_poblacion(codigo_comuna, años = 2027))
```

    # A tibble: 4 × 3
      nombre_comuna codigo_comuna poblacion
      <chr>                 <dbl>     <dbl>
    1 Arica                 15101    262679
    2 Camarones             15102      1251
    3 Putre                 15201      2594
    4 General Lagos         15202       791

{{< cafecito >}}
