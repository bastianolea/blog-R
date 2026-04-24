---
title: Explorar datos del Censo de Población y Vivienda 2024 con R
author: Bastián Olea Herrera
date: '2026-04-08'
slug: []
draft: false
freeze: true
categories:
  - Tutoriales
tags:
  - datos
  - chile
  - procesamiento de datos
format:
  hugo-md:
    output-file: index
    output-ext: md
execute:
  warning: false
editor_options:
  chunk_output_type: console
excerpt: >-
  Una de las dificultades más frecuentes en el análisis de datos es poder
  acceder a datos censales, porque su tamaño suele ser muy grande para la
  mayoría de los computadores, o bien imposible de abrir con programas como
  Excel. En este tutorial veremos cómo cargar los datos del Censo 2024 de Chile
  con R, accediendo a bases de datos de millones de observaciones para calcular
  estadísticas poblacionales sin colapsar nuestros computadores.
---


<!---
https://bastianolea.rbind.io/blog/mapas_censo_2024/
--->

Una de las dificultades más frecuentes en el análisis de datos es poder acceder a datos censales. Los censos suelen ser bases de datos de **varios millones de observaciones**, lo que suele ser demasiado para la mayoría de los computadores, o bien algo imposible con programas como Excel.

En este tutorial veremos cómo cargar los datos del [Censo de Población y Vivienda 2024](https://censo2024.ine.gob.cl) con R para poder acceder a bases de datos de millones de observaciones sin colapsar nuestros computadores.

También veremos cómo **consultar información a nivel comunal** desde el censo, y a **cruzar las bases de personas y hogares**.

{{< indice >}}

## Descargar datos del Censo

Lo primero que haremos es **descargar** los datos del Censo, [disponibles en su sitio oficial.](https://censo2024.ine.gob.cl)

{{< boton "Resultados Censo 2024" "https://censo2024.ine.gob.cl/resultados/" "fas fa-file-download" >}}

En esta página se listan todos los archivos de resultados.

Vamos a descargar el archivo *Base de microdatos - Viviendas, hogares, personas Censo 2024 (parquet) -- zip, 377 MB*.

Este archivo viene comprimido, y dentro trae los datos en formato **Parquet**, que es un formato moderno y **optimizado para grandes volúmenes de datos.**

El Censo viene en tres niveles de información:
- **Viviendas**
- **Hogares**
- **Personas**

Partiremos cargando los datos de nivel personas, que es la base más grande de las tres, dado que tiene **una fila por cada habitante de Chile.**

## Cargar datos del Censo en R

Para cargar los datos en formato Parquet usaremos el [paquete de R `{arrow}`](https://arrow.apache.org/docs/r/), que necesitamos instalar con la siguiente línea:

``` r
install.packages("arrow")
```

Una vez instalado, **leemos el Censo como una base de datos** con la función `open_dataset()`.

{{< detalles "¿Qué significa cargar los datos como base de datos?" >}}

Normalmente los datos se cargan en la **memoria** del computador. Si los datos son muy grandes y no caben a la memoria, **el computador colapsa** o se niega a cargar los datos. Pero cuando trabajamos mediante **bases de datos**, los datos no se cargan en la memoria, sino que se representan en una **versión optimizada**, capaz de realizar **operaciones más eficientes** y de copiar los datos a la memoria **solamente cuando se necesiten**. Esto nos permite **trabajar con datos que normalmente no cabrían en nuestra memoria.**

{{< /detalles >}}

``` r
library(arrow) # para cargar datos .parquet

# cargar censo como base de datos
personas <- open_dataset("personas_censo2024.parquet")
```

Si intentamos ver los datos cargados, encontraremos que no tenemos un *dataframe* normal:

``` r
personas 
```

    FileSystemDataset with 1 Parquet file
    63 columns
    id_vivienda: int32
    id_hogar: int32
    id_persona: int32
    region: int32
    provincia: int32
    comuna: int32
    comuna_bajo_umbral: int32
    area: int32
    tipo_operativo: int32
    sexo: int32
    edad: int32
    edad_quinquenal: int32
    parentesco: int32
    p23_est_civil: int32
    p24_lug_resid5: int32
    p24_lug_resid5_esp: int32
    p25_lug_nacimiento: int32
    p25_lug_nacimiento_rec: int32
    p25_lug_nacimiento_esp: int32
    p26_llegada_periodo: int32
    ...
    43 more columns
    Use `schema()` to see entire schema

En lugar de eso, tenemos una base de datos que **representa** los datos del censo, pero que **no los carga** en la memoria.

Sin embargo, podemos usar todas las funciones de `{dplyr}` para trabajar con los datos como normalmente hacemos, solo que al terminar las operaciones podemos obtener una **previsualización** del resultado, o bien, podemos **cargar el resultado a la memoria** con la función `collect()`, tomando **precauciones** para no cargar casi 19 millones de filas por accidente.

``` r
library(dplyr)

personas |> 
  select(comuna, area, sexo, edad) |> # seleccionar columnas
  head() |> # cargar solamente las primeras filas
  collect() # traer a memoria
```

    # A tibble: 6 × 4
      comuna  area  sexo  edad
       <int> <int> <int> <int>
    1   5802     1     2    80
    2   5802     1     1    52
    3   5802     1     2    45
    4   5802     1     2     8
    5   4303     2     1    69
    6   4303     2     2    65

Para ver la estructura de la base de datos, usamos `glimpse()` de `{dplyr}`:

``` r
glimpse(personas)
```

{{< detalles "Ver la estructura de los datos" >}}

    FileSystemDataset with 1 Parquet file
    18,480,432 rows x 63 columns
    $ id_vivienda              <int32> 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 6, …
    $ id_hogar                 <int32> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    $ id_persona               <int32> 1, 2, 3, 4, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 1, …
    $ region                   <int32> 5, 5, 5, 5, 4, 4, 4, 11, 11, 11, 1, 1, 1, 8, …
    $ provincia                <int32> 58, 58, 58, 58, 43, 43, 43, 112, 112, 112, 11…
    $ comuna                   <int32> 5802, 5802, 5802, 5802, 4303, 4303, 4303, 112…
    $ comuna_bajo_umbral       <int32> 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 2, 2, 2, 2, 2, …
    $ area                     <int32> 1, 1, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, …
    $ tipo_operativo           <int32> 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, …
    $ sexo                     <int32> 2, 1, 2, 2, 1, 2, 1, 2, 1, 1, 1, 2, 1, 2, 1, …
    $ edad                     <int32> 80, 52, 45, 8, 69, 65, 58, -66, -66, -66, 73,…
    $ edad_quinquenal          <int32> 80, 50, 45, 5, 65, 65, 55, 30, 55, 5, 70, 70,…
    $ parentesco               <int32> 1, 11, 5, 12, 9, 7, 1, 1, 4, 5, 1, 2, 5, 1, 5…
    $ p23_est_civil            <int32> 6, 8, 8, NA, 1, 1, 8, 2, 2, NA, 1, 1, 8, 8, 8…
    $ p24_lug_resid5           <int32> 3, 2, 2, 2, 3, 3, 2, 3, 2, 3, 2, 2, 2, 2, 2, …
    $ p24_lug_resid5_esp       <int32> 13117, 5802, 5802, 5802, 4301, 4301, 4303, 10…
    $ p25_lug_nacimiento       <int32> 2, 2, 2, 1, 2, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, …
    $ p25_lug_nacimiento_rec   <int32> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    $ p25_lug_nacimiento_esp   <int32> 12101, 5101, 13120, 5802, 5109, 4303, 4303, -…
    $ p26_llegada_periodo      <int32> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ p27_nacionalidad         <int32> 1, 1, 1, 1, 1, 1, 1, -66, -66, -66, 1, 1, 1, …
    $ p27_nacionalidad_esp     <int32> 152, 152, 152, 152, 152, 152, 152, -66, -66, …
    $ p27_nacionalidad_rec     <int32> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    $ p28_autoid_pueblo        <int32> 2, 2, 2, 2, 2, 2, 2, 1, 2, 1, 2, 2, 2, 2, 2, …
    $ p28_pueblo_pert          <int32> NA, NA, NA, NA, NA, NA, NA, 1, NA, 1, NA, NA,…
    $ p29_afrodescendencia_rec <int32> 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, …
    $ p29_afrodescendencia     <int32> 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, …
    $ p30_lengua_indigena      <int32> 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, …
    $ p30_lengua_indigena_rec  <int32> 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, …
    $ p31_religion             <int32> 12, 12, 12, NA, 1, 1, 12, 2, 1, NA, 1, 1, 1, …
    $ p31_religion_rec         <int32> 2, 2, 2, NA, 1, 1, 2, 1, 1, NA, 1, 1, 1, 1, 1…
    $ p32a_dificultad_ver      <int32> 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, …
    $ p32b_dificultad_oir      <int32> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    $ p32c_dificultad_mover    <int32> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, …
    $ p32d_dificultad_cogni    <int32> 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, …
    $ p32e_dificultad_cuidado  <int32> 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, …
    $ p32f_dificultad_comunic  <int32> 1, 1, 1, 1, 1, 1, 1, 3, 1, 2, 1, 1, 1, 1, 1, …
    $ discapacidad             <int32> 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, …
    $ p33_edu_asiste           <int32> 2, 2, 2, 1, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, …
    $ asistencia_parv          <int32> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ asistencia_basica        <int32> NA, NA, NA, 1, NA, NA, NA, NA, NA, -66, NA, N…
    $ asistencia_media         <int32> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ asistencia_superior      <int32> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ p37_alfabet              <int32> 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, …
    $ escolaridad              <int32> 17, 14, 12, 2, 12, 12, 15, 8, 5, 3, 8, 8, 16,…
    $ cine11                   <int32> 9, 6, 6, 3, 6, 6, 6, 5, 3, 3, 5, 5, 6, 5, 5, …
    $ sit_fuerza_trabajo       <int32> 3, 1, 1, NA, 3, 3, 1, 1, 1, NA, 1, 3, 1, 3, 3…
    $ p40_cise_rec             <int32> NA, 1, 2, NA, NA, NA, 1, 2, 1, NA, 1, NA, 2, …
    $ depend_econ_deficit_hab  <int32> 1, 1, 1, 2, 1, 2, 1, 1, 1, 2, 1, 1, 1, 1, 2, …
    $ cod_ciuo                 <int32> NA, 7, 2, NA, NA, NA, 7, 5, 7, NA, 1, NA, 3, …
    $ cod_caenes              <string> NA, "F", "P", NA, NA, NA, "F", "I", "F", NA, …
    $ p44_lug_trab             <int32> NA, 5, 2, NA, NA, NA, 2, 1, 1, NA, 2, NA, 2, …
    $ p44_lug_trab_esp         <int32> NA, 998, 5802, NA, NA, NA, 4303, 11202, 11202…
    $ p45_medio_transporte     <int32> NA, 2, 3, NA, NA, NA, 2, NA, NA, NA, 1, NA, 2…
    $ p46a_tot_hijs_nac        <int32> 3, NA, 1, NA, NA, 3, NA, 2, NA, NA, NA, 3, NA…
    $ p46b_hijas_nac           <int32> 2, NA, 1, NA, NA, 0, NA, 1, NA, NA, NA, 0, NA…
    $ p46c_hijos_nac           <int32> 1, NA, 0, NA, NA, 3, NA, 1, NA, NA, NA, 3, NA…
    $ p47a_tot_hijs_sobrev     <int32> 3, NA, 1, NA, NA, 2, NA, 2, NA, NA, NA, 3, NA…
    $ p47b_hijas_sobrev        <int32> 2, NA, 1, NA, NA, -99, NA, 1, NA, NA, NA, 0, …
    $ p47c_hijos_sobrev        <int32> 1, NA, 0, NA, NA, -99, NA, 1, NA, NA, NA, 3, …
    $ p48_anio_nac_uh          <int32> 1978, NA, 2015, NA, NA, 1984, NA, 2014, NA, N…
    $ p48_mes_nac_uh           <int32> 7, NA, 9, NA, NA, 6, NA, 12, NA, NA, NA, 10, …
    $ div_genero               <int32> 2, 2, 2, NA, -66, -66, -66, -66, -66, NA, 2, …

{{< /detalles >}}

Vemos todos los **nombres** de las columnas, y el **tipo** de datos que contienen. Además, vemos que la base de datos tiene **más de 18 millones** de filas! Esto es algo que en la mayoría de computadores no podríamos cargar en la memoria, pero gracias a que lo cargamos como una base de datos con `{arrow}`, podemos trabajar con ella sin problemas.

## Diccionario de variables del Censo

Como vimos en el *output* anterior, los datos del Censo vienen con **valores codificados en números** . Para entender su significado, necesitamos consultar el **diccionario de variables** del Censo, que también está disponible en la página de resultados del Censo y se llama *Diccionario de variables microdatos Censo 2024 -- xlsx, 154 KB*, o presiona el siguiente botón:

{{< boton "Descargar diccionario de variables" "diccionario_variables_censo2024.xlsx" "fas fa-file-download" >}}

En esa planilla, la pestaña `tabla_personas` nos muestra las **etiquetas** de los valores que vienen en la base de datos. Por ejemplo, vemos que en la variable `sexo`, el valor `1` es *Hombre* y `2` es *Mujer*.

## Calcular resúmenes de datos censales

Para hacer un **conteo** de la cantidad de personas según cualquier variable del Censo, podemos usar `count()` y luego `collect()` para que la base de datos haga el cálculo y nos entregue el resultado:

``` r
personas |> 
  count(sexo) |> 
  collect()
```

    # A tibble: 2 × 2
       sexo       n
      <int>   <int>
    1     2 9513399
    2     1 8967033

{{< info "Revisa estos tutoriales sobre [resúmenes de datos](/blog/r_introduccion/dplyr_summarize/) y [estadísticos descriptivos](/blog/estadisticos_descriptivos/) para complementar esta sección del tutorial!" >}}

Podemos también **recodificar** el resultado del conteo con `case_when()`, para convertir los valores codificados en etiquetas legibles:

``` r
tabla_sexo <- personas |> 
  count(sexo) |> 
  mutate(sexo = case_when(
    sexo == 1 ~ "Hombre", 
    sexo == 2 ~ "Mujer")) |> 
  collect()

tabla_sexo
```

    # A tibble: 2 × 2
      sexo         n
      <chr>    <int>
    1 Mujer  9513399
    2 Hombre 8967033

<p class="titulo_tabla">
Población chilena por sexo, Censo 2024
</p>

|   sexo | población |
|-------:|:----------|
|  Mujer | 9.513.399 |
| Hombre | 8.967.033 |

La base de datos de Arrow puede realizar **cálculos mucho más eficientes y rápidos**, pero solamente puede realizar cálculos generales. Ésto es porque lo que hace `{arrow}` es *traducir* las funciones de `{dplyr}` en el lenguaje de la base de datos, lo que significa que el número de funciones soportadas es limitado, aunque amplio.

{{< detalles "¿Qué pasa si `{arrow}` no soporta una función?" >}}

Si `{arrow}` nos dice que alguna función no es soportada (*Expression not supported in Arrow*), tenemos que usar estas funciones *después* de cargar el resultado en la memoria con `collect()`.

Por ejemplo:

``` r
personas |> 
  count(sexo) |> 
  mutate(sexo = recode(sexo,
                       "1" = "Hombre", 
                       "2" = "Mujer")) |> 
  collect()
```

    Error in `recode()`:
    ! Expression not supported in Arrow
    → Call collect() first to pull data into R.

No funciona! Pero si ponemos el `collect()` antes, haremos que se carguen los resultados a nuestra memoria y podremos seguir normalmente:

``` r
personas |> 
  count(sexo) |> 
  collect() |> # cargar resultados antes de proseguir
  mutate(sexo = recode(sexo,
                       "1" = "Hombres", 
                       "2" = "Mujeres"))
```

    # A tibble: 2 × 2
      sexo          n
      <chr>     <int>
    1 Mujeres 9513399
    2 Hombres 8967033

Ahora sí!

{{< /detalles >}}

### Obtener población por región

Para obtener la población por región, nuevamente hacemos un conteo por la variable:

``` r
personas_region <- personas |> 
  count(region, name = "poblacion") |> 
  arrange(region) |>
  collect()

personas_region
```

    # A tibble: 16 × 2
       region poblacion
        <int>     <int>
     1      1    369806
     2      2    635416
     3      3    299180
     4      4    832864
     5      5   1896053
     6      6    987228
     7      7   1123008
     8      8   1613059
     9      9   1010423
    10     10    890284
    11     11    100745
    12     12    166537
    13     13   7400741
    14     14    398230
    15     15    244569
    16     16    512289

Otra alternativa sería hacer un [resumen de datos con `summarize()`](../../../blog/r_introduccion/dplyr_summarize/), donde agrupamos por la variable `region` y luego contamos las filas con `n()`:

``` r
personas_region <- personas |> 
  group_by(region) |> 
  summarize(poblacion = n()) |> 
  arrange(region) |>
  collect()
```

El resultado sería el mismo. Pero en ambos casos, recibimos las regiones en números! Para **recodificar** las regiones y ponerles sus nombres como corresponde, podemos [usar nuevamente el *Diccionario de variables*](#consultar-el-diccionario-de-variables-códigos-del-censo) para **obtener las regiones y sus nombres:**

``` r
library(readxl) # para cargar datos en Excel
library(janitor) # para limpiar datos

# cargar códigos territoriales
codigos_territoriales <- read_xlsx("diccionario_variables_censo2024.xlsx",
                                   sheet = "codigos_territoriales") |>
  clean_names() |> 
  rename(division = 2)
```

``` r
# limpiar regiones
regiones <- codigos_territoriales |> 
  filter(division == "Región") |> 
  select(region = codigo_territorial, nombre_region = territorio) |> 
  mutate(region = as.integer(region))
```

Luego de cargar la planilla Excel y limpiarla, obtenemos una tabla con las regiones y sus códigos territoriales:

``` r
regiones
```

    # A tibble: 16 × 2
       region nombre_region                            
        <int> <chr>                                    
     1      1 Tarapacá                                 
     2      2 Antofagasta                              
     3      3 Atacama                                  
     4      4 Coquimbo                                 
     5      5 Valparaíso                               
     6      6 Libertador General Bernardo O'Higgins    
     7      7 Maule                                    
     8      8 Biobío                                   
     9      9 La Araucanía                             
    10     10 Los Lagos                                
    11     11 Aysén del General Carlos Ibáñez del Campo
    12     12 Magallanes y de la Antártica Chilena     
    13     13 Metropolitana de Santiago                
    14     14 Los Ríos                                 
    15     15 Arica y Parinacota                       
    16     16 Ñuble                                    

Ahora, para obtener la población por región con sus nombres, usamos `left_join()` para **cruzar los datos** del conteo de población con la tabla de regiones:

``` r
tabla_region <- personas_region |> 
  left_join(regiones, join_by(region)) |> 
  select(nombre_region, poblacion) |>
  collect()

tabla_region
```

<p class="titulo_tabla">
Población chilena por región, Censo 2024
</p>

|                                    región | población |
|------------------------------------------:|:----------|
|                                  Tarapacá | 369.806   |
|                               Antofagasta | 635.416   |
|                                   Atacama | 299.180   |
|                                  Coquimbo | 832.864   |
|                                Valparaíso | 1.896.053 |
|     Libertador General Bernardo O'Higgins | 987.228   |
|                                     Maule | 1.123.008 |
|                                    Biobío | 1.613.059 |
|                              La Araucanía | 1.010.423 |
|                                 Los Lagos | 890.284   |
| Aysén del General Carlos Ibáñez del Campo | 100.745   |
|      Magallanes y de la Antártica Chilena | 166.537   |
|                 Metropolitana de Santiago | 7.400.741 |
|                                  Los Ríos | 398.230   |
|                        Arica y Parinacota | 244.569   |
|                                     Ñuble | 512.289   |

Obtuvimos una tabla de las regiones de Chile con su población censal!

{{< info "Si quieres aprender a usar `left_join()` para cruzar datos, [revisa este tutorial!](/blog/left_join/)" >}}

### Calcular población urbana y rural por región

Ahora vamos por un poco más de detalle. Calculemos la población del país por regiones, pero desagregando las regiones por sus **áreas urbanas o rurales**, para obtener una población con mayor detalle territorial.

Para esto, hacemos un conteo por las variables `region` y `area`, seguimos los pasos que ya vimos antes para agregar los nombres de regiones, y finalmente recodificamos la variable `area`:

``` r
personas_region_area <- personas |> 
  # contar población por región y área
  count(region, area, name = "poblacion") |> 
  # agregar nombres de comunas y regiones
  left_join(regiones, join_by(region)) |> 
  arrange(region, area) |> 
  select(nombre_region, area, poblacion) |> 
  # recodificar área
  mutate(area = case_when(
    area == 1 ~ "Urbana", 
    area == 2 ~ "Rural")) |> 
  # copiar a memoria
  collect()

personas_region_area
```

Obtenemos los datos con dos filas por cada región, con su población urbana y rural en distintas filas.

Para hacer estos datos **más legibles** podemos [transformar la estructura de los datos](../../../blog/r_introduccion/tidyr_pivotar/) para que los datos del área que están *hacia abajo* (formato largo) pasen a estar distribuidos en dos columnas: urbana y rural (formato ancho).

``` r
library(tidyr) # para transformar datos

tabla_region_area <- personas_region_area |> 
  pivot_wider(names_from = area, # nombres de las columnas
              values_from = poblacion) # valores de las columnas

tabla_region_area
```

<p class="titulo_tabla">
Población chilena por región y área, Censo 2024
</p>

|                                    región | Rural   | Urbana    |
|------------------------------------------:|:--------|:----------|
|                                  Tarapacá | 15.559  | 354.247   |
|                               Antofagasta | 15.399  | 620.017   |
|                                   Atacama | 31.728  | 267.452   |
|                                  Coquimbo | 165.110 | 667.754   |
|                                Valparaíso | 199.962 | 1.696.091 |
|     Libertador General Bernardo O'Higgins | 265.174 | 722.054   |
|                                     Maule | 321.382 | 801.626   |
|                                    Biobío | 215.358 | 1.397.701 |
|                              La Araucanía | 331.479 | 678.944   |
|                                 Los Lagos | 258.193 | 632.091   |
| Aysén del General Carlos Ibáñez del Campo | 23.180  | 77.565    |
|      Magallanes y de la Antártica Chilena | 11.779  | 154.758   |
|                 Metropolitana de Santiago | 280.498 | 7.120.243 |
|                                  Los Ríos | 129.620 | 268.610   |
|                        Arica y Parinacota | 23.397  | 221.172   |
|                                     Ñuble | 174.140 | 338.149   |

Ahora tenemos las regiones con su población en dos columnas según el área donde las personas habitan.

{{< info "Si quieres aprender a usar `pivot_wider()` y `pivot_longer()` para transformar datos o pivotar tablas, [revisa este tutorial!](/blog/r_introduccion/tidyr_pivotar/)" >}}

Podemos además calcular los **porcentajes** de estas poblaciones por región, y pivotar la tabla:

``` r
tabla_region_area_porcentaje <- personas_region_area |> 
  # calcular porcentajes
  group_by(nombre_region) |> 
  mutate(porcentaje = poblacion / sum(poblacion),
         porcentaje = round(porcentaje * 100, 1)) |>
  rename(población = poblacion) |> 
  ungroup() |> 
  # pivotar
  pivot_wider(names_from = area, 
              values_from = c(población, porcentaje), 
              names_glue = "{area} ({.value})", # nombrar columnas
              values_fill = 0)
```

<p class="titulo_tabla">
Población chilena por región y área, Censo 2024
</p>

| región | Rural (población) | Urbana (población) | Rural (porcentaje) | Urbana (porcentaje) |
|------------------------:|-----------:|-----------:|-----------:|------------:|
| Tarapacá | 15.559 | 354.247 | 4,2% | 95,8% |
| Antofagasta | 15.399 | 620.017 | 2,4% | 97,6% |
| Atacama | 31.728 | 267.452 | 10,6% | 89,4% |
| Coquimbo | 165.110 | 667.754 | 19,8% | 80,2% |
| Valparaíso | 199.962 | 1.696.091 | 10,5% | 89,5% |
| Libertador General Bernardo O'Higgins | 265.174 | 722.054 | 26,9% | 73,1% |
| Maule | 321.382 | 801.626 | 28,6% | 71,4% |
| Biobío | 215.358 | 1.397.701 | 13,4% | 86,6% |
| La Araucanía | 331.479 | 678.944 | 32,8% | 67,2% |
| Los Lagos | 258.193 | 632.091 | 29,0% | 71,0% |
| Aysén del General Carlos Ibáñez del Campo | 23.180 | 77.565 | 23,0% | 77,0% |
| Magallanes y de la Antártica Chilena | 11.779 | 154.758 | 7,1% | 92,9% |
| Metropolitana de Santiago | 280.498 | 7.120.243 | 3,8% | 96,2% |
| Los Ríos | 129.620 | 268.610 | 32,5% | 67,5% |
| Arica y Parinacota | 23.397 | 221.172 | 9,6% | 90,4% |
| Ñuble | 174.140 | 338.149 | 34,0% | 66,0% |

## Cruzar datos censales de población con datos por hogares

En el Censo, la base de **personas** tiene una fila por cada habitante, mientras que la base de **hogares** tiene una fila por cada hogar, y la de **vivienda** tiene una fila por cada vivienda. En una vivenda (la construcción física) pueden haber múltiples hogares (personas que conviven y comparten un mismo presupuesto para alimentación).

Estas bases tienen variables distintas debido a su distinta unidad de observación : las viviendas tienen `edad` o `sexo`, etc., los hogares comparten variables como su *fuente de energía para calefaccionar* y su *tenencia* (si la vivienda es propia, etc.), y las viviendas tienen características como su *materialidad* o *número de habitaciones*.

Para [cruzar](../../../blog/left_join/) estas bases, necesitamos usar las variables `id_vivienda` y `id_hogar`, que son las que permiten identificar a qué hogar y vivienda corresponde cada persona censada.

{{< info "Si necesitas aprender a cruzar bases de datos con R, revisa este tutorial sobre [left_join()](/blog/left_join/)." >}}

### Calcular cantidad de personas de tercera edad según propiedad de su hogar

Obtengamos ahora datos censales que requieren combinar dos niveles de información del Censo: nivel personas y nivel hogares. Queremos saber la cantidad de **personas adultas mayores**, según el **tipo de propiedad** de los hogares donde residen.

El dato de adultos mayores debe **crearse a partir del sexo y la edad**, que son variables presentes en la base de microdatos a nivel *personas*, mientras que el dato de la propiedad o tenencia de los hogares (`p12_tenencia_viv`) está en al base de nivel *hogares*.

Entonces necesitamos [cruzar las bases](../../../blog/left_join/) de personas y hogares, para **obtener una base de personas con información de su hogar**, y así poder contar a las y los adultos mayores según el tipo de propiedad del hogar donde viven.

#### Cargar datos

Primero cargamos ambas bases de datos:

``` r
library(dplyr)
library(arrow)

# cargar datos de nivel personas
personas <- open_dataset("personas_censo2024.parquet")

# cargar datos de nivel hogares
hogares <- open_dataset("hogares_censo2024.parquet")
```

Ahora seleccionamos las variables que nos interesan para el análisis:

``` r
personas_filtrado <- personas |>
  select(id_vivienda, id_hogar, # identificadores
         region, comuna, # variables territoriales
         sexo, edad_quinquenal) # variables sociodemográficas
```

``` r
hogares_filtrado <- hogares |>
  select(id_vivienda, id_hogar, # identificadores
         # region, comuna, # estas ya vienen en nivel personas
         p12_tenencia_viv) # variable de interés
```

#### Cruzar tablas

Luego, [cruzamos ambas bases](../../../blog/left_join/) a partir de las variables que identifican a cada persona con su hogar y vivienda, que son `id_vivienda`, y `id_hogar`:

``` r
# cruzar ambas bases por hogar/vivienda/comuna
personas_hogares <- left_join(personas_filtrado, 
                              hogares_filtrado, 
                              join_by(id_vivienda, 
                                      id_hogar))
```

Recordemos que seguimos procesando a nivel de **base de datos**, por lo que podemos hacer estos **cruces entre tablas de millones de filas** sin problemas.

Veamos una previsualización del resultado del cruce:

``` r
# primeras filas de la tabla
personas_hogares |> 
  head() |> 
  collect()
```

    # A tibble: 6 × 7
      id_vivienda id_hogar region comuna  sexo edad_quinquenal p12_tenencia_viv
            <int>    <int>  <int>  <int> <int>           <int>            <int>
    1           1        1      5   5802     2              80                4
    2           1        1      5   5802     1              50                4
    3           1        1      5   5802     2              45                4
    4           1        1      5   5802     2               5                4
    5           2        1      4   4303     1              65                9
    6           2        1      4   4303     2              65                9

``` r
# cantidad de observaciones en la tabla
personas_hogares |> 
  tally() |> 
  collect()
```

    # A tibble: 1 × 1
             n
         <int>
    1 18480432

#### Recodificar variables

Ahora **recodificamos** las variables para que sean legibles (basándonos en el *[diccionario](#consultar-el-diccionario-de-variables-códigos-del-censo)*), y creamos nuevas variables para identificar a los hogares de adultos mayores y el tipo de propiedad del hogar:

``` r
personas_hogares_recod <- personas_hogares |> 
  # recodificar variables
  mutate(sexo = case_when(
    sexo == 1 ~ "Hombre", 
    sexo == 2 ~ "Mujer")) |> 
  # crear variable simplificada
  mutate(propiedad = case_when(
    p12_tenencia_viv == 1 ~ "Propia", 
    p12_tenencia_viv == 2 ~ "Propia",
    .default = "No propia")) |> 
  # crear variable de adulto mayor
  mutate(adulto_mayor = case_when(
    sexo == "Hombre" & edad_quinquenal >= 65 ~ "Adulto mayor", 
    sexo == "Mujer" & edad_quinquenal >= 60 ~ "Adulto mayor",
    .default = "No adulto mayor"))
```

Nótese que para construir la variable `adulto_mayor` usamos el `sexo` y la `edad_quinquenal` para tomar en consideración las diferencias entre sexos en la tercera edad.

Finalmente agregamos los **nombres de regiones y comunas**, porque recordemos que vienen como códigos territoriales, igual como hicimos más arriba a partir del **[diccionario de variables](#consultar-el-diccionario-de-variables-códigos-del-censo)**:

``` r
codigos_territoriales <- read_xlsx("diccionario_variables_censo2024.xlsx",
                                   sheet = "codigos_territoriales") |>
  clean_names() |> 
  rename(division = 2)
```

Hacemos dos *dataframes*, uno para las regiones y otro para las comunas:

``` r
regiones <- codigos_territoriales |> 
  filter(division == "Región") |> 
  select(region = codigo_territorial, nombre_region = territorio) |> 
  mutate(region = as.integer(region))

regiones
```

    # A tibble: 16 × 2
       region nombre_region                            
        <int> <chr>                                    
     1      1 Tarapacá                                 
     2      2 Antofagasta                              
     3      3 Atacama                                  
     4      4 Coquimbo                                 
     5      5 Valparaíso                               
     6      6 Libertador General Bernardo O'Higgins    
     7      7 Maule                                    
     8      8 Biobío                                   
     9      9 La Araucanía                             
    10     10 Los Lagos                                
    11     11 Aysén del General Carlos Ibáñez del Campo
    12     12 Magallanes y de la Antártica Chilena     
    13     13 Metropolitana de Santiago                
    14     14 Los Ríos                                 
    15     15 Arica y Parinacota                       
    16     16 Ñuble                                    

``` r
comunas <- codigos_territoriales |> 
  filter(division == "Comuna") |> 
  select(comuna = codigo_territorial, nombre_comuna = territorio) |> 
  mutate(comuna = as.integer(comuna))

comunas
```

    # A tibble: 346 × 2
       comuna nombre_comuna
        <int> <chr>        
     1   1101 Iquique      
     2   1107 Alto Hospicio
     3   1401 Pozo Almonte 
     4   1402 Camiña       
     5   1403 Colchane     
     6   1404 Huara        
     7   1405 Pica         
     8   2101 Antofagasta  
     9   2102 Mejillones   
    10   2103 Sierra Gorda 
    # ℹ 336 more rows

Y ahora agregamos estas variables con los nombres a la base de datos mediante otro `left_join()`:

``` r
personas_hogares_comunas <- personas_hogares_recod |> 
  # cruzar tablas
  left_join(regiones, by = "region") |>
  left_join(comunas, by = "comuna") |> 
  # reordenar variables
  relocate(nombre_region, .before = region) |>
  relocate(nombre_comuna, .before = comuna)
```

Así vamos hasta ahora:

``` r
personas_hogares_comunas |> 
  head() |> 
  collect()
```

    # A tibble: 6 × 11
      id_vivienda id_hogar nombre_region           region nombre_comuna comuna sexo 
            <int>    <int> <chr>                    <int> <chr>          <int> <chr>
    1       13755        1 Libertador General Ber…      6 Rancagua        6101 Mujer
    2       13755        1 Libertador General Ber…      6 Rancagua        6101 Mujer
    3       13756        1 Metropolitana de Santi…     13 El Bosque      13105 Homb…
    4       13756        1 Metropolitana de Santi…     13 El Bosque      13105 Mujer
    5       13756        1 Metropolitana de Santi…     13 El Bosque      13105 Mujer
    6       13757        1 Metropolitana de Santi…     13 San Joaquín    13129 Mujer
    # ℹ 4 more variables: edad_quinquenal <int>, p12_tenencia_viv <int>,
    #   propiedad <chr>, adulto_mayor <chr>

Ya tenemos una tabla con datos censales a nivel de personas, pero además con variables asociadas a los hogares donde vive cada persona.

#### Explorar datos

Hasta ahora, con esta tabla podemos hacer un conteo de nuestra nueva variable de adultos mayores a nivel nacional:

``` r
personas_hogares_comunas |> 
  count(adulto_mayor) |> 
  collect()
```

    # A tibble: 2 × 2
      adulto_mayor           n
      <chr>              <int>
    1 No adulto mayor 15316446
    2 Adulto mayor     3163986

Podemos obtener el mismo conteo a nivel regional:

``` r
personas_hogares_comunas |> 
  count(nombre_region, adulto_mayor) |> 
  collect()
```

    # A tibble: 32 × 3
       nombre_region                             adulto_mayor          n
       <chr>                                     <chr>             <int>
     1 Valparaíso                                Adulto mayor     379279
     2 Valparaíso                                No adulto mayor 1516774
     3 Coquimbo                                  Adulto mayor     145007
     4 Coquimbo                                  No adulto mayor  687857
     5 Aysén del General Carlos Ibáñez del Campo No adulto mayor   85155
     6 Tarapacá                                  Adulto mayor      43959
     7 Tarapacá                                  No adulto mayor  325847
     8 Biobío                                    Adulto mayor     290340
     9 Metropolitana de Santiago                 No adulto mayor 6198954
    10 Biobío                                    No adulto mayor 1322719
    # ℹ 22 more rows

#### Calcular datos

Ahora introduzcamos las variables de nivel hogar. Calculemos los **adultos mayores según la tenencia del hogar donde residen,** entendida como la propiedad del hogar versus no propiedad (arriendo, cedida, etc.).

Para ello hacemos un conteo con `count()` de las personas adultas mayores y la propiedad de sus viviendas:

``` r
conteo_propiedad <- personas_hogares_comunas |> 
  count(adulto_mayor, propiedad) |> 
  collect()
```

Veamos el resultado calculando el porcentaje y formateando los datos:

``` r
tabla_propiedad <- conteo_propiedad |> 
  arrange(adulto_mayor) |> 
  # calcular porcentaje
  group_by(adulto_mayor) |>
  mutate(p = n / sum(n)) |>
  # dar formato a números
  mutate(n = label_number()(n),
         p = label_percent(accuracy = 0.1)(p))
```

<p class="titulo_tabla">
Cantidad y porcentaje de personas adultas mayores según propiedad del hogar
</p>

| adulto mayor    | propiedad |  cantidad | porcentaje |
|:----------------|:----------|----------:|-----------:|
| Adulto mayor    | No propia |   682.085 |      21,6% |
| Adulto mayor    | Propia    | 2.481.901 |      78,4% |
| No adulto mayor | No propia | 6.244.617 |      40,8% |
| No adulto mayor | Propia    | 9.071.829 |      59,2% |

Transformemos la tabla para hacer más legible y clara la información al distribuir las variables en columnas por medio de `pivot_wider()`:

``` r
tabla_propiedad_ancha <- conteo_propiedad |> 
  arrange(adulto_mayor) |>
  # calcular porcentaje
  group_by(adulto_mayor) |>
  mutate(p = n / sum(n)) |>
  rename(porcentaje = p,
         cantidad = n) |> 
  # pivotar a ancho
  pivot_wider(names_from = propiedad, 
              values_from = c(cantidad, porcentaje),
              names_glue = "{propiedad} ({.value})",
              values_fill = 0) |> 
  # dar formato a números
  mutate(across(contains("cantidad"), label_number()),
         across(contains("porcentaje"), label_percent()))
```

<p class="titulo_tabla">
Cantidad y porcentaje de personas adultas mayores según propiedad del hogar
</p>

| adulto mayor | No propia (cantidad) | Propia (cantidad) | No propia (porcentaje) | Propia (porcentaje) |
|:-----------|:---------------|:-------------|:----------------|:--------------|
| Adulto mayor | 682.085 | 2.481.901 | 22% | 78% |
| No adulto mayor | 6.244.617 | 9.071.829 | 41% | 59% |

Obtenemos un resultado interesante: dentro de la **población adulta mayor**, un **78% reside** en hogares de tipo de **tenencia propia**, mientras dentro de la población que no es adulta mayor, el porcentaje de personas que residen en hogares de tenencia propia es solo un **59%**.

Revisemos la misma información, pero a **nivel regional**:

``` r
conteo_propiedad_region <- personas_hogares_comunas |> 
  count(adulto_mayor, nombre_region, propiedad) |> 
  collect()

tabla_propiedad_region <- conteo_propiedad_region |> 
  # calcular porcentaje
  group_by(adulto_mayor, nombre_region) |>
  mutate(p = n / sum(n)) |>
  filter(propiedad == "Propia") |>
  arrange(-p) |>
  # dar formato a números
  mutate(p = label_percent()(p)) |> 
  select(-n) |> 
  # pivotar
  pivot_wider(names_from = adulto_mayor, 
              values_from = p)
```

<p class="titulo_tabla">
Porcentaje de la población que vive en viviendas propias (pagadas o pagándose) según grupos de edad
</p>

| región | propiedad | Adulto mayor | No adulto mayor |
|----------------------------------:|:--------:|:-----------:|:-------------:|
| La Araucanía | Propia | 83% | 67% |
| Los Lagos | Propia | 83% | 64% |
| Maule | Propia | 83% | 69% |
| Ñuble | Propia | 83% | 67% |
| Biobío | Propia | 82% | 66% |
| Aysén del General Carlos Ibáñez del Campo | Propia | 82% | 59% |
| Magallanes y de la Antártica Chilena | Propia | 82% | 59% |
| Coquimbo | Propia | 81% | 64% |
| Los Ríos | Propia | 81% | 62% |
| Libertador General Bernardo O'Higgins | Propia | 80% | 64% |
| Atacama | Propia | 80% | 63% |
| Metropolitana de Santiago | Propia | 76% | 55% |
| Valparaíso | Propia | 76% | 58% |
| Arica y Parinacota | Propia | 74% | 50% |
| Antofagasta | Propia | 73% | 47% |
| Tarapacá | Propia | 72% | 47% |

En todas las regiones del país, el porcentaje de personas adultas mayores que residen en hogares de tenencia propia es mayor que el mismo dato en personas no adultas mayores. En otras palabras, se podría plantear que la población adulta mayor es más propensa a vivir en hogares *propios pagados* o *propios pagándose* que la población no adulta mayor. Para asegurar ésto habría que aplicar pruebas estadísticas que están fuera del foco de este tutorial.

<!---

--->

## Mapas a partir de datos del Censo

En otro tutorial mostré [cómo visualizar los datos del Censo a nivel de manzana con R](../../../blog/mapas_censo_2024/), y también hice una pequeña [aplicación de muestra para visualizar variables del Censo en mapas](../../../blog/app_censo_mapas/) como una demostración de la simplicidad y potencia de R con un *backend* de Arrow.

{{< aviso "Tutorial en construcción! Pronto lo seguiré expandiendo." >}}
<!--


Mapa


::: {.cell}

```{.r .cell-code}
manzanas |> 
# filtrar
filter(COMUNA == "PUENTE ALTO") |> # comuna
# convertir
st_as_sf(crs = 4326) |> 
# graficar
ggplot() +
aes(fill = n_discapacidad) + # variable
geom_sf(color = "white", linewidth = 0.01) +
scale_fill_fermenter(palette = 3) +
theme_minimal(base_size = 10) +
theme(axis.text.x = element_text(angle = 90, vjust = .5)) +
guides(fill = guide_legend(title = "Población",
position = "top")) +
labs(title = "Población con discapacidad por manzana",
subtitle = "Comuna de Puente Alto",
caption = "Fuente: Censo 2024, INE")
```
:::



-->
{{< cafecito >}}
