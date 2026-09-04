---
title: 'Datos en formato Parquet: tablas de datos optimizadas para rendimiento en R'
author: Bastián Olea Herrera
date: '2026-09-03'
draft: false
freeze: true
slug: []
categories: []
tags:
  - datos
  - optimización
format:
  hugo-md:
    output-file: index
    output-ext: md
execute:
  eval: false
  message: false
  warning: false
links:
  - icon: registered
    icon_pack: fas
    name: arrow
    url: https://arrow.apache.org/docs/r/
editor_options:
  chunk_output_type: console
excerpt: >-
  El formato Arrow Parquet, implementado en R mediante el paquete `{arrow}`, es
  un formato moderno diseñado para eficiencia y velocidad. Parquet es un formato
  que usa tecnologías modernas para ser más rápido de leer, más liviano,
  soportar grandes volúmenes de datos, y permitir operaciones eficientes sobre
  la información. En esta publicación realizaremos pruebas para confirmar que es
  la mejor opción!
---


Entre todos los formatos para almacenar datos que existen (Excel, CSV, etc.), recientemente hay uno que destaca. El formato Parquet, del proyecto [Apache Arrow](https://arrow.apache.org), implementado en R mediante [el paquete `{arrow}`](https://arrow.apache.org/docs/r/), es un formato moderno diseñado para eficiencia y velocidad.

A diferencia de otros formatos de datos diseñados para ser editables y visuales, como Excel, o diseñados para simplicidad y estandarización, como CSV y otros basados en texto, Parquet es un formato que usa tecnologías modernas para ser más rápido de leer, más liviano, soportar grandes volúmenes de datos, y permitir operaciones eficientes sobre la información.

Además, es un formato de datos *estándar*, en el sentido de que es posible de cargar desde casi cualquier software: C, Java, R, Python, Rust, Go, Swift y más.

Instala el paquete `{arrow}`:

``` r
install.packages("arrow")
```

Usarlo es muy simple: `read_parquet()` para leer datos formato Parquet, y `write_parquet()` para guardar tus datos en este formato.

## Comparación de velocidad

Para destacar las cualidades de Parquet, haremos una comparación con datos ficticios entre Excel, CSV y Parquet.

Con este código crearemos una tabla de 1 millón de filas (que no es mucho, pero lamentablemente se acerca al máximo de Excel), con 10 columnas con datos al azar.

``` r
library(arrow)
library(dplyr)

n <- 1000000 # 1 millón de filas

tabla <- tibble(
  id = 1:n,
  a = rnorm(n),
  b = rnorm(n),
  c = rnorm(n),
  d = rnorm(n),
  e = rnorm(n, mean = 100),
  f = rnorm(n, mean = 10, sd = 5),
  letras = sample(letters, size = n, replace = TRUE),
  animal = sample(c("gato", "rata", "pato"), size = n, replace = TRUE),
  fechas = sample(1980:2026, size = n, replace = TRUE)
)
```

### Prueba 1: escribir datos

La primera prueba será la velocidad para guardar datos en los tres formatos. Crearemos rutas a *archivos temporales* para no tener que definir rutas manuales. Los archivos temporales se guardan en un lugar invisible y se eliminan solitos después de terminar la sesión.

``` r
archivo_parquet <- tempfile(fileext = ".parquet")
archivo_csv <- tempfile(fileext = ".csv")
archivo_xlsx <- tempfile(fileext = ".xlsx")
```

Ahora ejecutaremos un *benchmark* con el [paquete `{bench}`](https://bench.r-lib.org) para comparar la velocidad de escritura de la tabla de 1 millón de filas:

``` r
bench::mark(
  "excel" = openxlsx2::write_xlsx(tabla, archivo_xlsx),
  "csv" = readr::write_csv(tabla, archivo_csv),
  "parquet" = arrow::write_parquet(tabla, archivo_parquet),
  check = FALSE,
  iterations = 10,
)
```

    expression      min   median `itr/sec` mem_alloc `gc/sec` n_itr  n_gc total_time
    <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl> <int> <dbl>   <bch:tm>
    1 excel         32.3s    35.9s    0.0282    1.81GB   0.0734    10    26      5.91m
    2 csv         279.2ms  312.2ms    0.748     8.81MB   0         10     0     13.37s
    3 parquet     297.7ms  314.4ms    1.56      5.51MB   0         10     0      6.41s

Recibimos los resultados de la comparación de desempeño. Escribir un Excel de 1 millón de filas demoró **32 segundos!** Mientras que el CSV y el Parquet tardaron 0.31 segundos ambos, aunque el Parquet usó menos menos memoria y tardó la mitad del tiempo total (6 segundos versus 13 segundos).

**🥇 Ganador en velocidad de escritura:** *empate entre CSV y Parquet!*

### Prueba 2: peso de los archivos

Otro factor importante al trabajar datos es el almacenamiento que utilizan. Distintos formatos usan distintas aproximaciones de compresión, lo que resulta en distintos pesos.

Comparemos el peso de los archivos creados en la prueba anterior:

``` r
library(cli)

peso_xlsx <- file.size(archivo_xlsx)/1024^2
peso_csv <- file.size(archivo_csv)/1024^2
peso_parquet <- file.size(archivo_parquet)/1024^2

cli_inform("Peso de archivo Excel: {round(peso_xlsx, 1)} Mb")
cli_inform("Peso de archivo CSV: {round(peso_csv, 1)} Mb")
cli_inform("Peso de archivo Parquet: {round(peso_parquet, 1)} Mb")
```

    Peso de archivo Excel: 97.4 Mb
    Peso de archivo CSV: 128.5 Mb
    Peso de archivo Parquet: 53.3 Mb

Nuevamente, Parquet produce mejores resultados, ya que usa tecnologías modernas de compresión centradas en datos columnares, y además produce archivos binarios, que si bien no son legibles por humanos (como sí lo es CSV, ya que es puro texto), tiene otros beneficios; en este caso, peso y velocidad.

``` r
diferencia <- file.size(archivo_parquet)/file.size(archivo_csv)
cli_alert_success("El archivo Parquet es un {round(diferencia*100, 1)}% más liviano que el CSV")
```

    ✔ El archivo Parquet es un 41.5% más liviano que el CSV

**🥇 Ganador en peso de archivos:** *Parquet!*

### Prueba 3: lectura de datos

Ahora viene la prueba definitiva: la carga de datos! Incluiremos otro contrincante más: la [lectura de CSVs con Arrow](../../../blog/2025-02-12/), que teóricamente es más rápida que otras implementaciones.

Realizamos el *benchmark* de lectura de datos:

``` r
bench::mark(
  "excel" = openxlsx2::read_xlsx(archivo_xlsx),
  "csv" = readr::read_csv(archivo_csv),
  "arrow_csv" = arrow::read_csv_arrow(archivo_csv),
  "arrow_parquet" = arrow::read_parquet(archivo_parquet),
  check = FALSE,
  iterations = 10,
)
```

    expression         min   median `itr/sec` mem_alloc `gc/sec` n_itr  n_gc total_time
    <bch:expr>    <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl> <int> <dbl>   <bch:tm>
    1 excel            19.2s    23.5s    0.0446    3.92GB    0.165    10    37      3.74m
    2 csv            467.2ms  500.5ms    1.76     77.99MB    0.176    10     1      5.67s
    3 arrow_csv      103.8ms    111ms    8.87     11.97MB    0        10     0      1.13s
    4 arrow_parquet   38.3ms   40.3ms   24.4        1.6MB    0        10     0   409.94ms

Aquí vemos diferencias gigantes! Cargar una tabla Excel de 1 millón de filas demoró en promedio **23 segundos**, mientras que leer los mismos datos en Parquet demoró **40.3 milisegundos!**

Esto significa que Parquet es **583.1 veces más rápido que Excel** y **12.4 veces más rápido que CSV**. Por otro lado, leer un CSV usando Arrow es 4.5 veces más rápido que con `{readr}`, aunque sigue siendo 2.7 veces más lento que usar Parquet.

**🥇 Ganador en lectura de datos:** *Parquet!*

La velocidad de carga de datos tiene implicancias gigantes en el desempeño de tus análisis de datos diarios, pero también cuando te enfrentes a grandes volúmenes de datos.

### Prueba 4: lectura de grandes volúmenes de datos

Repitamos el ejercicio con un dataframe de **30 millones de filas** y 10 columnas, lo que descalifica de inmediato a Excel. Así nos pondremos en casos de conjuntos de datos más difíciles de manejar.

Creamos los datos de prueba y los guardamos:

``` r
n <- 30000000 # 30 millones de filas

tabla2 <- tibble(
  id = 1:n,
  a = rnorm(n),
  b = rnorm(n),
  c = rnorm(n),
  d = rnorm(n),
  e = rnorm(n),
  f = rnorm(n),
  g = rnorm(n),
  h = rnorm(n),
  i = rnorm(n, mean = 100),
  j = rnorm(n, mean = 10)
)

# rutas
archivo_csv2 <- tempfile(fileext = ".csv")
archivo_parquet2 <- tempfile(fileext = ".parquet")

# escribir
readr::write_csv(tabla2, archivo_csv2)
arrow::write_parquet(tabla2, archivo_parquet2)
```

Revisemos el peso de los archivos resultantes:

``` r
library(cli)

peso_csv2 <- file.size(archivo_csv2)/1024^2
peso_parquet2 <- file.size(archivo_parquet2)/1024^2

cli_inform("Peso de archivo CSV: {round(peso_csv2, 1)} Mb")
cli_inform("Peso de archivo Parquet: {round(peso_parquet2, 1)} Mb")
```

    Peso de archivo CSV: 5789 Mb
    Peso de archivo Parquet: 2495.2 Mb

Nuevamente vemos que Parquet genera archivos más livianos. Ahora procedemos a hacer la **prueba de lectura** de estos archivos de 30 millones de filas:

``` r
bench::mark(
  "csv" = readr::read_csv(archivo_csv2),
  "arrow_csv" = arrow::read_csv_arrow(archivo_csv2),
  "arrow_parquet" = arrow::read_parquet(archivo_parquet2),
  check = FALSE,
  iterations = 4,
)
```

    expression         min   median `itr/sec` mem_alloc `gc/sec` n_itr  n_gc total_time
    <bch:expr>    <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl> <int> <dbl>   <bch:tm>
    1 csv             10.98s   11.59s    0.0861    2.46GB   0.0861     4     4      46.5s
    2 arrow_csv        4.55s    4.62s    0.207   118.82MB   0          4     0      19.3s
    3 arrow_parquet 787.16ms    1.55s    0.367      1.6MB   0          4     0      10.9s

Confirmamos que, incluso cargando una tabla de datos grande, leer un Parquet es **10 veces más rápido que CSV**, utilizando una fracción minúscula de la memoria necesaria. Un detalle es que Arrow usa todos los procesadores disponibles para cargar los datos:

{{< imagen "arrow_htop.png" "400px" >}}

## Funcionalidades de Arrow/Parquet

Pero además de ser veloz, usar Parquet trae otros beneficios!

### Carga parcial de columnas

Una característica útil es poder cargar datos seleccionando las columnas, dado que Parqeut almacena los datos por columna.

Para probarlo, carguemos el archivo de 30 millones de filas, primero completo y después solamente obteniendo las columnas `id` y `a`:

``` r
bench::mark(
  "completo" = arrow::read_parquet(archivo_parquet2),
  "columnas" = arrow::read_parquet(archivo_parquet2, col_select = c("id", "a")),
  check = FALSE
)
```

      expression      min median `itr/sec` mem_alloc `gc/sec` n_itr  n_gc total_time
      <bch:expr> <bch:tm> <bch:>     <dbl> <bch:byt>    <dbl> <int> <dbl>   <bch:tm>
    1 completo      974ms  974ms      1.03    7.96KB        0     1     0      974ms
    2 columnas      287ms  300ms      3.33   14.44KB        0     2     0      600ms

Al seleccionar solamente lo necesario, el tiempo de carga se reduce a un tercio!

### Cargar datos como *dataset*

Otra ventaja de usar datos Arrow es la función `open_dataset()`. Esta función permite *cargar* los datos como si fueran una **base de datos**. Esto significa que R no carga los datos en la memoria, sino que devuelve un *esquema* de los datos, sobre el cual usamor la sintaxis de `{dplyr}` para hacer **consultas** (*querys*) a los datos. Estas *querys* se procesan internamente por Arrow, directamente desde el disco duro.

Gracias a esta funcionalidad, el motor de base de datos de Arrow realiza el trabajo de obtención y procesamiento de los datos de manera más eficiente. El trabajo sólo se ejecuta cuando hacemos `collect()`, entregándonos solamente el resultado final, ahora sí como *dataframe*. Esto evita que conjuntos de datos grandes saturen la memoria de nuestro computador, posibilitando incluso **cargar archivos más grandes que la memoria RAM**.

``` r
bench::mark(
  "parquet" = arrow::read_parquet(archivo_parquet2) |> 
    summarize(
      across(
        everything(),
        mean)
    ),
  "dataset" = arrow::open_dataset(archivo_parquet2) |> 
    summarize(
      across(
        everything(),
        mean)
    ) |> 
    collect(),
  iterations = 10
)
```

    expression      min   median `itr/sec` mem_alloc `gc/sec` n_itr  n_gc total_time
    <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl> <int> <dbl>   <bch:tm>
    1 parquet       1.58s    2.23s     0.425    14.5KB    0        10     0     23.52s
    2 dataset    903.74ms    1.03s     0.921   488.4KB    0.230     8     2      8.68s

En la comparación, vemos que consultar y procesar los datos de 30 millones de filas como *dataset* es el doble de rápido que cargarlos directamente. Para más información, [consulta la documentación oficial](https://arrow.apache.org/docs/r/articles/dataset.html).

### Cargar archivos CSV con Arrow

Como vimos más arriba, Arrow también incluye una [función de lectura más rápida de archivos CSV](https://bastianolea.rbind.io/blog/2025-02-12/).

``` r
bench::mark(
  "csv" = readr::read_csv(archivo_csv),
  "arrow_csv" = arrow::read_csv_arrow(archivo_csv),
  check = FALSE,
  iterations = 20,
)
```

    expression         min   median `itr/sec` mem_alloc `gc/sec` n_itr  n_gc total_time
    <bch:expr>    <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl> <int> <dbl>   <bch:tm>
    1 csv            467.2ms  500.5ms    1.76     77.99MB    0.176    10     1      5.67s
    2 arrow_csv      103.8ms    111ms    8.87     11.97MB    0        10     0      1.13s

------------------------------------------------------------------------

En resumidas cuentas, recomiendo empezar a usar el formato Parquet para almacenar datos! Hará tu trabajo más eficiente

{{< etiqueta "optimización" >}}

## Referencias

- [Introducción oficial a Arrow para R](https://arrow.apache.org/docs/r/articles/arrow.html)
- [Larger-Than-Memory Data Workflows with Apache Arrow](https://arrow-user2022.netlify.app), tutorial realizado durante UseR! 2022
- [Capítulo de R para Ciencia de Datos sobre Arrow](https://r4ds.hadley.nz/arrow.html)
- Libro: [Apache Arrow R Cookbook](https://arrow.apache.org/cookbook/r/index.html)
- Tutorial: [Apache Arrow in R: Read Parquet Files & Run Fast In-Memory Analytics](https://r-statistics.co/Apache-Arrow-in-R.html)
