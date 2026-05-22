---
title: Creando una función para consultar datos en R
subtitle: Crea tu propia API para obtener cifras desde bases de datos más rápido
author: Bastián Olea Herrera
date: '2026-05-21'
draft: true
tags:
  - datos
  - chile
  - funciones
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: file-code
    icon_pack: fas
    name: Código
    url: https://github.com/bastianolea/censo_poblacion_consultar
excerpt: >-
  En R es muy fácil filtrar y seleccionar cualquier base de datos para obtener
  las cifras que quieras. Pero a veces necesitamos consultar muchas cifras, y
  repetir el código se vuelve engorroso. Veremos cómo crear una función que nos
  ayude a consultar datos de forma más eficiente y cómoda, lo que comúnmente se
  denomina como API de consulta de datos.
---


En este tutorial veremos cómo **crear una función** en R diseñada para consultar datos. Este puede ser el primer paso para crear una API, una [herramienta para entregarle a una inteligencia artificial](../../../blog/herramientas_llm/), o simplemente algo conveniente de hacer para consultar datos.

Como ejemplo, crearemos una función para consultar la población de comunas, regiones, provincias o país según resultados del Censo 2024, diseñada para [registrarla como herramienta para LLMs](../../../blog/herramientas_llm/) y así hacer que la IA pueda consultar datos de población censal.

------------------------------------------------------------------------

En R es muy fácil filtrar y seleccionar cualquier base de datos para obtener las cifras que quieras.

Basándonos en el [Censo 2024 de Chile](../../../blog/censo_2024/), si queremos (por ejemplo) saber la población de una comuna, cargamos el Censo, filtramos la comuna con `filter()`, luego agrupamos por comuna con `group_by()` y finalmente sumamos las observaciones con `summarize()` para obtener la población:

``` r
library(arrow)
censo <- open_dataset("~/Documents/Datos/Censo/2024/personas_censo2024.parquet")
```

``` r
library(arrow)

# cargar censo
censo <- open_dataset("personas_censo2024.parquet")
```

``` r
library(dplyr)

censo |> 
  filter(comuna == 13110) |> 
  group_by(comuna) |> 
  summarize(poblacion = n()) |> 
  collect()
```

    # A tibble: 1 × 2
      comuna poblacion
       <int>     <int>
    1  13110    374836

Así obtuvimos la población de La Florida (había que saberse o buscar el código único territorial eso sí).

Ahora, si queremos la población por **sexo**, cambiamos la agrupación para hacer el conteo de observaciones por comuna y sexo:

``` r
censo |> 
  filter(comuna == 13110) |> 
  group_by(comuna, sexo) |> 
  summarize(poblacion = n()) |> 
  collect()
```

    # A tibble: 2 × 3
    # Groups:   comuna [1]
      comuna  sexo poblacion
       <int> <int>     <int>
    1  13110     1    178461
    2  13110     2    196375

Luego, si quieres lo mismo pero para otra comuna, copias el código y cambias el filtro, y así.

{{< relacionada "/blog/censo_2024/" "Tutorial para trabajar con el Censo" >}}

Pero si necesitamos hacer esto muy seguido, de repente es mejor optimizarlo. [Como dijo Dios en la biblia](https://es.r4ds.hadley.nz/19-functions.html#cuándo-deberías-escribir-una-función):

> Deberías considerar escribir una función cuando has copiado y pegado un bloque de código más de dos veces.

<p style="text-align: right; margin-top: -6px; font-style: italic;">
Hadley Wickham
</p>

Alabado sea [Hadley](https://hadley.nz) 🙏🏼

## Funciones en R

[Crear una función](../../../blog/r_introduccion/r_intermedio/#crear-funciones) permite que ejecutemos un conjunto de operaciones de forma más simple, al **abstraer el código** en un único comando que es más rápido y cómodo de usar. Lo que antes eran varias líneas de código puede resumirse en una función como `filtrar_datos()` o similar.

Las funciones también nos ayudan a **reutilizar** el código al empaquetarlo en una forma más conveniente.

{{< relacionada "/blog/r_introduccion/r_intermedio/" "Aprende a hacer funciones" >}}

Creemos entonces una función que sirva para **ayudar a obtener cifras de una base de datos**. Usaremos como ejemplo el Censo, pero podrás usar estos principios para cualquier otra base de datos, siempre y cuando esté ordernadita.

Aprendiendo esto estarás a un paso de **crear tu propia API!**

## Datos

Los datos que usaremos son una versión de los resultados del Censo 2024 en **formato *tidy***. Esto quiere decir que cada columna representa una variable, y cada fila representa una observación.

{{< boton "Descargar datos" "censo_2024_tidy.csv" "fas fa-file-download" >}}
{{< info "Los datos vienen en CSV separado por punto y coma. Recuerda que este tipo de datos suelen abrirse en el navegador como texto, por lo que tienes que ponerle _Guardar como` para guardar el archivo." >}}

Carguemos los datos para explorarlos:

``` r
library(readr)

censo <- read_csv2("censo_2024_tidy.csv")
```

    ℹ Using "','" as decimal and "'.'" as grouping mark. Use `read_delim()` for more control.

    Rows: 23825 Columns: 10
    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: ";"
    chr (6): nivel, comuna, provincia, region, sexo, edad
    dbl (4): codigo_comuna, codigo_provincia, codigo_region, poblacion

    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

Si no quieres descargar los datos, puedes cargarlos directamente desde internet así:

``` r
library(readr)

censo <- read_csv2("https://github.com/bastianolea/censo_poblacion_consultar/raw/master/datos/censo_2024_tidy.csv")
```

Ahora miremos cómo vienen:

``` r
library(dplyr)

censo |> 
  select(-contains("codigo"))
```

| nivel  | comuna  | provincia | region   | sexo    | edad  | poblacion |
|:-------|:--------|:----------|:---------|:--------|:------|----------:|
| Comuna | Iquique | Iquique   | Tarapacá | Hombres | 0-4   |      5052 |
| Comuna | Iquique | Iquique   | Tarapacá | Hombres | 5-9   |      6565 |
| Comuna | Iquique | Iquique   | Tarapacá | Hombres | 10-14 |      7482 |
| Comuna | Iquique | Iquique   | Tarapacá | Hombres | 15-19 |      6664 |
| Comuna | Iquique | Iquique   | Tarapacá | Hombres | 20-24 |      6804 |
| Comuna | Iquique | Iquique   | Tarapacá | Hombres | 25-29 |      8211 |

Vemos que tenemos columnas que describen la unidad geográfica (`comuna`, `provincia`, `region`), tenemos dos variables sociodemográficas (`sexo` y `edad`) y finalmente la cantidad de `poblacion` que cumple los criterios anteriores.

Además tenemos la variable `nivel` que describe si los datos vienen por *Comuna, Provincia, Región* o *País.* Por ejemplo:

``` r
censo |> 
  select(-contains("codigo")) |> 
  filter(nivel == "Provincia")
```

| nivel     | comuna | provincia | region   | sexo    | edad  | poblacion |
|:----------|:-------|:----------|:---------|:--------|:------|----------:|
| Provincia | NA     | Iquique   | Tarapacá | Hombres | 0-4   |     10346 |
| Provincia | NA     | Iquique   | Tarapacá | Hombres | 5-9   |     13002 |
| Provincia | NA     | Iquique   | Tarapacá | Hombres | 10-14 |     14154 |
| Provincia | NA     | Iquique   | Tarapacá | Hombres | 15-19 |     12961 |
| Provincia | NA     | Iquique   | Tarapacá | Hombres | 20-24 |     13145 |
| Provincia | NA     | Iquique   | Tarapacá | Hombres | 25-29 |     14644 |

## Crear una función

Sería super conveniente tener una función llamada `consultar_censo()` a la que podamos simplemente pedirle cosas como `consultar_censo(region = "Maule")`, `consultar_censo(comuna = "Pirque")`, o bien cosas más complejas como `consultar_censo(comuna = "Cerrillos", sexo = "Mujeres", edad = "30-35")`.

Crearemos una función que vaya filtrando los datos dependiendo de lo que se pida en sus argumentos. De esta forma podremos aplicar **validaciones** de los filtros (si las regiones existen, si las edades son válidas, etc.) y personalizar cómo se entregan los resultados, entre otros beneficios.

Primero creamos la función:

``` r
consultar_censo <- function() {}
```

Dentro de los paréntesis de llave (`{}`) irá el código de la función.

### Argumentos

Dentro del paréntesis de `function()` van a ir los **argumentos** que entreguemos al usar la función (como el filtro de `edad` o `sexo`). Podemos solamente declararlos, o declararlos especificando su valor por defecto (el que tendrán si se dejan vacíos:

``` r
consultar_censo <- function(
  nivel = "País",
  edad = "Total",
  sexo = "Total",
  territorio = NA
) {
}
```

Cuando ejecutemos la función, los argumentos van a *pasar* hacia dentro como **objetos** que contienen el valor que el/la usuario/a les de. Por ejemplo, podemos hacer que la función diga lo que recibe:

``` r
consultar_censo <- function(
  nivel = "País",
  edad = "Total",
  sexo = "Total",
  territorio = NA
) {
  require(cli)
  
  cli_alert_info("datos de {territorio}
                 nivel: {nivel}
                 filtros:")
  cli_alert("edad: {edad}")
  cli_alert("sexo: {sexo}")
}
```

``` r
consultar_censo(territorio = "La Florida", sexo = "Hombres")
```

    Loading required package: cli

    ℹ datos de La Florida
    nivel: País
    filtros:

    → edad: Total

    → sexo: Hombres

{{< info "Aquí usamos funciones del paquete `{cli}` para crear mensajes más lindos y fáciles de usar que un caos hecho con `paste()`." >}}

### Filtros

Empecemos a hacer que la función filtre los datos. Para ello simplemente usamos los argumentos dentro de `filter()`.

Pero puede ser que en este paso enfrentemos un primer problemita: como las palabras no son infinitas, a veces puede ser que los **argumentos** de la función se llamen igual que las columnas del *dataframe* que queremos filtrar. Esto hará que, cuando intentemos filtrar, R se confunda 😵‍💫

*Ejemplo de la confusión:*

``` r
nivel <- "Provincia"

censo |> 
  filter(nivel == nivel)
```

    # A tibble: 23,825 × 10
       nivel  codigo_comuna comuna  codigo_provincia provincia codigo_region region 
       <chr>          <dbl> <chr>              <dbl> <chr>             <dbl> <chr>  
     1 Comuna          1101 Iquique               11 Iquique               1 Tarapa…
     2 Comuna          1101 Iquique               11 Iquique               1 Tarapa…
     3 Comuna          1101 Iquique               11 Iquique               1 Tarapa…
     4 Comuna          1101 Iquique               11 Iquique               1 Tarapa…
     5 Comuna          1101 Iquique               11 Iquique               1 Tarapa…
     6 Comuna          1101 Iquique               11 Iquique               1 Tarapa…
     7 Comuna          1101 Iquique               11 Iquique               1 Tarapa…
     8 Comuna          1101 Iquique               11 Iquique               1 Tarapa…
     9 Comuna          1101 Iquique               11 Iquique               1 Tarapa…
    10 Comuna          1101 Iquique               11 Iquique               1 Tarapa…
    # ℹ 23,815 more rows
    # ℹ 3 more variables: sexo <chr>, edad <chr>, poblacion <dbl>

{{< bajada "Resultado incorrecto! R intentó filtrar la columna `nivel` con sus propios valores" >}}

**R se confunde** porque tiene dos objetos que se llaman igual: un objeto en el *entorno*, y una columna dentro del contexto de la evaluación de `{dplyr}`.

Para solucionar la ambiguedad, podemos poner otros nombres a los argumentos (por ejemplo, anteponiéndoles un punto, onda `.nivel`), o bien, especificándole a `{dplyr}` los valores que vienen desde *afuera* del *dataframe*:

``` r
nivel <- "Provincia"

censo |> 
  filter(nivel == .env$nivel)
```

    # A tibble: 3,191 × 10
       nivel    codigo_comuna comuna codigo_provincia provincia codigo_region region
       <chr>            <dbl> <chr>             <dbl> <chr>             <dbl> <chr> 
     1 Provinc…            NA <NA>                 11 Iquique               1 Tarap…
     2 Provinc…            NA <NA>                 11 Iquique               1 Tarap…
     3 Provinc…            NA <NA>                 11 Iquique               1 Tarap…
     4 Provinc…            NA <NA>                 11 Iquique               1 Tarap…
     5 Provinc…            NA <NA>                 11 Iquique               1 Tarap…
     6 Provinc…            NA <NA>                 11 Iquique               1 Tarap…
     7 Provinc…            NA <NA>                 11 Iquique               1 Tarap…
     8 Provinc…            NA <NA>                 11 Iquique               1 Tarap…
     9 Provinc…            NA <NA>                 11 Iquique               1 Tarap…
    10 Provinc…            NA <NA>                 11 Iquique               1 Tarap…
    # ℹ 3,181 more rows
    # ℹ 3 more variables: sexo <chr>, edad <chr>, poblacion <dbl>

{{< bajada "Ahora sí!" >}}

Anteponiendo `.env$` al argumento, explicitamos que el objeto que estamos usando viene desde el *entorno* de la función, y no es una columna del dataframe. Inversamente, podemos explicitar también con `.data$` que nos referimos a una columna de un *dataframe* y no a un objeto del entorno.

``` r
consultar_censo <- function(
  nivel = "País",
  edad = "Total",
  sexo = "Total",
  territorio = NA
) {
  
  # filtros
  filtrado <- censo |>
    filter(
      nivel == .env$nivel,
      edad == .env$edad,
      sexo == .env$sexo
    )
  
  return(filtrado)
}
```

``` r
consultar_censo(nivel = "País",
                edad = "25-29",
                sexo = "Mujeres") |> 
  select(poblacion)
```

    # A tibble: 1 × 1
      poblacion
          <dbl>
    1    689840

### Validación

{{< relacionada "/blog/mapas_censo_2024/" >}}
{{< relacionada "/blog/herramientas_llm/" >}}
{{< etiqueta "datos" >}}
