---
title: Crear variables nuevas con `dplyr::mutate()`
author: Bastián Olea Herrera
date: '2025-12-11'
format:
  hugo-md:
    output-file: index
    output-ext: md
weight: 8
draft: false
series: Introducción a R
slug: []
categories:
  - Tutoriales
tags:
  - dplyr
  - básico
excerpt: >-
  La función `mutate()` es una de las principales en R, ya que te permite crear
  variables nuevas o transformar variables existentes en un _data frame_. Este
  tutorial presenta ejemplos muy básicos del uso de esta función, y va avanzando
  a casos más reales de su uso.
execute:
  error: true
  eval: true
links:
  - icon: file-code
    icon_pack: fas
    name: Código scraping
    url: https://gist.github.com/bastianolea/00d7da36e85b76de1abf9ca37014cfe4
---


En esta ocasión veremos la función que nos permite **crear variables nuevas**, a partir de los aprendizajes sobre manipulación de datos que vimos [en tutoriales anteriores](../../../../blog/r_introduccion/dplyr_intro/).

Para **crear variables nuevas**, o **transformar variables existentes**, usaremos la función `mutate()`, que forma parte del paquete `{dplyr}`.

{{< imagen_tamaño "featured.png" "200px" >}}
{{< bajada "Esquema de la creación de una columna a partir de dos columnas existentes: la tercera columna es la suma de las dos anteriores" >}}

La función `mutate()` nos va a permitir crear nuevas variables, ya sea usando datos nuevos, alguna función que genera datos, modificando los datos de una columna existente, o realizando un cálculo a partir de una o más columnas de la tabla.

{{< aviso "Si necesitas aprender `{dplyr}` desde el principio, revisa el [tutorial de introducción a `{dplyr}`](/blog/r_introduccion/dplyr_intro/)." >}}

## Introducción

Vamos a empezar con ejemplos básicos y luego pasaremos a datos reales.

Lo primero que haremos será cargar el paquete `{dplyr}`:

``` r
# install.packages("dplyr")
library(dplyr)
```

### Crear nuevas columnas

Empezaremos con una tabla de datos de ejemplo, llamada creativamente `ejemplo`:

``` r
library(dplyr)

ejemplo <- tibble(números = 1:3)

ejemplo
```

    # A tibble: 3 × 1
      números
        <int>
    1       1
    2       2
    3       3

Podemos usar `mutate()` para crear una nueva variable o columna (¡son sinónimos! 🤓).

Para crear usar `mutate()`, aplicamos esta función a un *data frame* [conectando los datos a la función con un conector](../../../../blog/r_introduccion/conectores/) (`|>` o `%>%`).

{{< info "Un **conector** en R es un operador que nos permite _conectar_ datos (o el resultado de una operación) con la siguiente operación. Para más información, [revisa este tutorial](https://bastianolea.rbind.io/blog/r_introduccion/conectores/)" >}}

``` r
ejemplo |> 
  mutate(prueba = 1)
```

    # A tibble: 3 × 2
      números prueba
        <int>  <dbl>
    1       1      1
    2       2      1
    3       3      1

Creamos una **nueva columna** llamada `prueba`, que contiene el valor `1`. Como le dimos un sólo valor (`1`), el valor se repite en todas las filas.

*¿Qué hicimos?*

Para crear la variable `prueba`, dentro de `mutate()`:
1. Primero pusimos el **nombre** de la columna que queríamos crear (`prueba`),
2. Luego un **signo igual** (`=`), que indica que *ésto va a ser aquello*,
3. Finalmente el **valor** que queremos que contenga la nueva columna ( `1`).

Creemos otra columna, llamada `saludo`:

``` r
ejemplo |> 
  mutate(saludo = "hola")
```

    # A tibble: 3 × 2
      números saludo
        <int> <chr> 
    1       1 hola  
    2       2 hola  
    3       3 hola  

De esta forma podemos crear variables que contengan un único valor.

{{< info "Notamos que en el ejemplo anterior no existe la primera columna que creamos. Ésto es porque **nunca estamos sobreescribiendo ni editando los datos**, a menos que [hagamos una **asignación**](https://bastianolea.rbind.io/blog/r_introduccion/r_basico/#asignaciones) (`<-`) para guardar el resultado como un nuevo objeto." >}}

También podemos usar funciones para crear los valores que va a tener una columna. Por ejemplo, creemos una columna llamada `azar` que contenga números aleatorios entre `1` y `100`:

``` r
ejemplo |> 
  mutate(azar = sample(1:100, size =  3))
```

    # A tibble: 3 × 2
      números  azar
        <int> <int>
    1       1     5
    2       2    70
    3       3    98

En este ejemplo, los valores de la columna son definidos por la función que usamos.

### Modificar variables existentes

También podemos usar `mutate()` para modificar columnas que ya existen en el *data frame*. Esto se hace simplemente poniendo en `mutate()` como nombre de la columna que vamos a crear el **nombre de una columna existente** que queremos modificar.

Por ejemplo, cambiemos los valores de `números` por unos distintos:

``` r
ejemplo |> 
  mutate(números = 4:6)
```

    # A tibble: 3 × 1
      números
        <int>
    1       4
    2       5
    3       6

En este caso, **sobreescribimos** la columna con datos nuevos.

Volvamos a ver los datos originales:

``` r
ejemplo
```

    # A tibble: 3 × 1
      números
        <int>
    1       1
    2       2
    3       3

En vez de cambiar completamente los datos de una columna, podemos **editar una columna existente**, usando los valores de la misma columna y ejecutando alguna operación sobre ellos, para obtener una versión editada de la misma columna:

``` r
ejemplo |> 
  mutate(números = números * 100)
```

    # A tibble: 3 × 1
      números
        <dbl>
    1     100
    2     200
    3     300

En este ejemplo, **editamos** la columna `números`, que contenía los valores `1`, `2` y `3`, declarando que `números = números * 100`; es decir, la columna va a ser igual a ella misma pero multiplicada por `100`. Por eso ahora contiene los valores `100`, `200` y `300`, que son el resultado de multiplicar cada valor original por `100`.

### Crear una columna nueva en base a otra existente

Siguiendo el ejemplo anterior, podemos crear una nueva columna llamada `doble` que contenga el doble de los valores de la columna `números`:

``` r
ejemplo |> 
  mutate(doble = números * 2)
```

    # A tibble: 3 × 2
      números doble
        <int> <dbl>
    1       1     2
    2       2     4
    3       3     6

Así creamos una **nueva columna** basada en datos de una columna existente.

También podemos usar **funciones** para crear las variables nuevas:

``` r
ejemplo |> 
  mutate(doble = números * 2) |> 
  mutate(texto = paste(doble, "es el doble de", números))
```

    # A tibble: 3 × 3
      números doble texto             
        <int> <dbl> <chr>             
    1       1     2 2 es el doble de 1
    2       2     4 4 es el doble de 2
    3       3     6 6 es el doble de 3

Estas son las piezas básicas para trabajar con variables o columnas. ¡Ahora veámoslo con datos!

------------------------------------------------------------------------

## Ejemplo con datos

A continuación, usaremos datos sobre países de América Latina, que fueron obtenidos desde tablas de Wikipedia por medio de [web scraping](../../../../blog/web_scraping/). Puedes revisar el [script con el código del scraping aquí](https://gist.github.com/bastianolea/00d7da36e85b76de1abf9ca37014cfe4).

Ejecutaremos el siguiente código para obtener una tabla llamada `datos` en nuestro entorno de R:

``` r
datos <- tribble(
  ~pais,       ~pobreza, ~esperanza, ~escolaridad,
  "Chile",         5,    81.17,      11.29,
  "Uruguay",       6,    78.14,      10.54,
  "Argentina",    11,    77.69,      11.18,
  "Costa Rica",   13,    80.8,        8.84,
  "Panamá",       13,    79.59,      10.83,
  "Bolivia",      15,    68.58,      10.02,
  "Paraguay",     20,    73.84,       8.93,
  "México",       22,    75.07,       9.35,
  "Brasil",       24,    75.85,       8.43,
  "El Salvador",  28,    72.1,        7.3
)
```

La tabla `datos` contiene información sobre porcentaje de pobreza, esperanza de vida promedio y años de escolaridad promedio en varios países de América Latina.

### Crear una variable nueva con `mutate()`

Usemos `mutate()` para crear una nueva columna llamada `escolaridad_redondeada`, que contenga los valores de la columna `escolaridad` redondeados al número entero más cercano:

``` r
datos |> 
  select(pais, escolaridad) |> 
  mutate(escolaridad_redondeada = round(escolaridad))
```

    # A tibble: 10 × 3
       pais        escolaridad escolaridad_redondeada
       <chr>             <dbl>                  <dbl>
     1 Chile             11.3                      11
     2 Uruguay           10.5                      11
     3 Argentina         11.2                      11
     4 Costa Rica         8.84                      9
     5 Panamá            10.8                      11
     6 Bolivia           10.0                      10
     7 Paraguay           8.93                      9
     8 México             9.35                      9
     9 Brasil             8.43                      8
    10 El Salvador        7.3                       7

En este caso aplicamos una función a una columna existente para obtener una columna nueva.

### Crear una variable condicional con `if_else()`

Podemos usar `mutate()` junto con la función `if_else()` para crear una nueva columna basada en condiciones. Por ejemplo, creemos una columna llamada `pobreza_nivel` que indique si el porcentaje de pobreza alto (es mayor al 10%) o bajo:

``` r
datos |> 
  select(pais, pobreza) |> 
  mutate(pobreza_nivel = if_else(pobreza >= 10, "Alto", "Bajo"))
```

    # A tibble: 10 × 3
       pais        pobreza pobreza_nivel
       <chr>         <dbl> <chr>        
     1 Chile             5 Bajo         
     2 Uruguay           6 Bajo         
     3 Argentina        11 Alto         
     4 Costa Rica       13 Alto         
     5 Panamá           13 Alto         
     6 Bolivia          15 Alto         
     7 Paraguay         20 Alto         
     8 México           22 Alto         
     9 Brasil           24 Alto         
    10 El Salvador      28 Alto         

{{< info "La función `if_else()` permite crear variables condicionales. La condición que se defina será evaluada para cada valor, y se aplicará el resultado que corresponda si la condición es _verdadera_ o _falsa_." >}}

### Crear una variable con múltiples condiciones usando `case_when()`

Podemos usar `mutate()` junto con la función `case_when()` para crear una nueva columna basada en múltiples condiciones. Por ejemplo, creemos una columna llamada `esperanza_nivel` que clasifique la esperanza de vida en "Alta", "Media" y "Baja":

``` r
datos |> 
  select(pais, esperanza) |> 
  mutate(esperanza_nivel = case_when(
    esperanza >= 80 ~ "Alta",
    esperanza >= 70 ~ "Media",
    esperanza <  70 ~ "Baja"
  ))
```

    # A tibble: 10 × 3
       pais        esperanza esperanza_nivel
       <chr>           <dbl> <chr>          
     1 Chile            81.2 Alta           
     2 Uruguay          78.1 Media          
     3 Argentina        77.7 Media          
     4 Costa Rica       80.8 Alta           
     5 Panamá           79.6 Media          
     6 Bolivia          68.6 Baja           
     7 Paraguay         73.8 Media          
     8 México           75.1 Media          
     9 Brasil           75.8 Media          
    10 El Salvador      72.1 Media          

En el ejemplo anterior usamos números arbitrarios para recodificar una variable contínua en una variable categórica. En un caso real, deberíamos analizar la distribución de los datos para definir los puntos de corte adecuados. Una forma muy rudimentaria de hacer ésto es usando desviaciones estándar:

``` r
datos |> 
  mutate(esperanza_nivel = case_when(
    esperanza >= mean(esperanza) + sd(esperanza) ~ "Alta",
    esperanza <= mean(esperanza) - sd(esperanza) ~ "Baja",
    TRUE ~ "Media"
  ))
```

    # A tibble: 10 × 5
       pais        pobreza esperanza escolaridad esperanza_nivel
       <chr>         <dbl>     <dbl>       <dbl> <chr>          
     1 Chile             5      81.2       11.3  Alta           
     2 Uruguay           6      78.1       10.5  Media          
     3 Argentina        11      77.7       11.2  Media          
     4 Costa Rica       13      80.8        8.84 Alta           
     5 Panamá           13      79.6       10.8  Media          
     6 Bolivia          15      68.6       10.0  Baja           
     7 Paraguay         20      73.8        8.93 Media          
     8 México           22      75.1        9.35 Media          
     9 Brasil           24      75.8        8.43 Media          
    10 El Salvador      28      72.1        7.3  Baja           

{{< info "La desviación estándar es una medida de dispersión que indica cuánto varían los datos respecto a su promedio. En este caso se usa para definir puntos de corte objetivos basados en la distribución de los datos." >}}

En este caso clasificamos la esperanza de vida en función de su distancia a la media, usando una desviación estándar como punto de corte: países que tengan valores que sean mayores al promedio más una desviación estándar serán *altos*, los que tengan valores menores al promedio menos una desviación estándar serán *bajos*, y el resto serán *medios*.

### Calcular variables por grupos con `group_by()`

Podemos usar `group_by()` para crear variables nuevas basadas en grupos dentro de los datos; es decir, cuyo cálculo se haga dentro de cada grupo definido.

Primero creemos un grupo:

``` r
datos_grupo <- datos |> 
  mutate(pobreza_nivel = if_else(pobreza >= 15, "Alto", "Bajo"))

datos_grupo
```

    # A tibble: 10 × 5
       pais        pobreza esperanza escolaridad pobreza_nivel
       <chr>         <dbl>     <dbl>       <dbl> <chr>        
     1 Chile             5      81.2       11.3  Bajo         
     2 Uruguay           6      78.1       10.5  Bajo         
     3 Argentina        11      77.7       11.2  Bajo         
     4 Costa Rica       13      80.8        8.84 Bajo         
     5 Panamá           13      79.6       10.8  Bajo         
     6 Bolivia          15      68.6       10.0  Alto         
     7 Paraguay         20      73.8        8.93 Alto         
     8 México           22      75.1        9.35 Alto         
     9 Brasil           24      75.8        8.43 Alto         
    10 El Salvador      28      72.1        7.3  Alto         

Ahora calculemos el promedio de esperanza de vida dentro de cada grupo de pobreza usando `group_by()` y `mutate()`:

``` r
datos_grupo |> 
  select(pais, pobreza_nivel, esperanza) |> 
  group_by(pobreza_nivel) |> 
  mutate(esperanza_promedio = mean(esperanza)) |> 
  mutate(esperanza_diferencia = esperanza - esperanza_promedio)
```

    # A tibble: 10 × 5
    # Groups:   pobreza_nivel [2]
       pais        pobreza_nivel esperanza esperanza_promedio esperanza_diferencia
       <chr>       <chr>             <dbl>              <dbl>                <dbl>
     1 Chile       Bajo               81.2               79.5                1.69 
     2 Uruguay     Bajo               78.1               79.5               -1.34 
     3 Argentina   Bajo               77.7               79.5               -1.79 
     4 Costa Rica  Bajo               80.8               79.5                1.32 
     5 Panamá      Bajo               79.6               79.5                0.112
     6 Bolivia     Alto               68.6               73.1               -4.51 
     7 Paraguay    Alto               73.8               73.1                0.752
     8 México      Alto               75.1               73.1                1.98 
     9 Brasil      Alto               75.8               73.1                2.76 
    10 El Salvador Alto               72.1               73.1               -0.988

En este ejemplo, primero agrupamos los datos por la variable `pobreza_nivel` usando `group_by()`, y luego usamos `mutate()` para crear una nueva columna llamada `esperanza_promedio`, que contiene el promedio de esperanza de vida dentro de cada grupo. Finalmente, creamos otra columna llamada `esperanza_diferencia`, que contiene la diferencia entre la esperanza de vida individual y el promedio del grupo.

De este modo obtuvimos una nueva variable que muestra la diferencia de cada país respecto al promedio de su grupo; una especie de indicador.

### Crear varias columnas al mismo tiempo con `across()`

Finalmente, podemos modificar o crear varias columnas nuevas al mismo tiempo usando `mutate()` junto con la función `across()`. Con `across()`, especificamos las variables que queremos afectar, y luego la fórmula que les vamos a aplicar.

Por ejemplo, podemos redondear todas las columnas al mismo tiempo:

``` r
datos |> 
  mutate(
    across(c(pobreza, esperanza, escolaridad), 
           ~round(.x)
    )
  )
```

    # A tibble: 10 × 4
       pais        pobreza esperanza escolaridad
       <chr>         <dbl>     <dbl>       <dbl>
     1 Chile             5        81          11
     2 Uruguay           6        78          11
     3 Argentina        11        78          11
     4 Costa Rica       13        81           9
     5 Panamá           13        80          11
     6 Bolivia          15        69          10
     7 Paraguay         20        74           9
     8 México           22        75           9
     9 Brasil           24        76           8
    10 El Salvador      28        72           7

La función que aplicamos se escribe con *colita de chancho* (`~`) para indicar que todas las variables especificadas van a ser afectadas por la misma función, representadas dentro de la función como `.x` 🐷

Incluso podemos hacerlo en menos código, al especificar que queremos afectar todas las columnas donde (`where`) sean numéricas (`is.numeric`):

``` r
datos |> 
  mutate(
    across(where(is.numeric), 
           ~round(.x)
    )
  )
```

    # A tibble: 10 × 4
       pais        pobreza esperanza escolaridad
       <chr>         <dbl>     <dbl>       <dbl>
     1 Chile             5        81          11
     2 Uruguay           6        78          11
     3 Argentina        11        78          11
     4 Costa Rica       13        81           9
     5 Panamá           13        80          11
     6 Bolivia          15        69          10
     7 Paraguay         20        74           9
     8 México           22        75           9
     9 Brasil           24        76           8
    10 El Salvador      28        72           7

Esto trae el beneficio de no tener que referirnos a las columnas por sus nombres!

Otro ejemplo sería aplicar una función que transforme todos los valores numéricos en texto, agregando una palabra antes del número:

``` r
datos |> 
  mutate(
    across(
      where(is.numeric), 
      ~paste("Valor:", .x)
    )
  )
```

    # A tibble: 10 × 4
       pais        pobreza   esperanza    escolaridad 
       <chr>       <chr>     <chr>        <chr>       
     1 Chile       Valor: 5  Valor: 81.17 Valor: 11.29
     2 Uruguay     Valor: 6  Valor: 78.14 Valor: 10.54
     3 Argentina   Valor: 11 Valor: 77.69 Valor: 11.18
     4 Costa Rica  Valor: 13 Valor: 80.8  Valor: 8.84 
     5 Panamá      Valor: 13 Valor: 79.59 Valor: 10.83
     6 Bolivia     Valor: 15 Valor: 68.58 Valor: 10.02
     7 Paraguay    Valor: 20 Valor: 73.84 Valor: 8.93 
     8 México      Valor: 22 Valor: 75.07 Valor: 9.35 
     9 Brasil      Valor: 24 Valor: 75.85 Valor: 8.43 
    10 El Salvador Valor: 28 Valor: 72.1  Valor: 7.3  

En este caso, el símbolo `.x` hace que el valor de cada observación se ponga en otro lugar de la función, en este caso al final de la función `paste()`.

Podemos combinar `mutate()` con uno o varios `mutate(across())` para crear o modificar varias columnas al mismo tiempo. Por ejemplo, podemos agregarle el signo de porcentaje a `pobreza`, luego redondear las columnas `esperanza` y `escolaridad`, y al final agregar un mismo texto a dos columnas:

``` r
datos |> 
  mutate(
    # redactar
    pobreza = paste(pobreza, "%", sep = ""),
    # redondear
    across(c(esperanza, escolaridad), ~round(.x, 0)),
    # redactar
    across(c(esperanza, escolaridad), ~paste(.x, "años"))
  )
```

    # A tibble: 10 × 4
       pais        pobreza esperanza escolaridad
       <chr>       <chr>   <chr>     <chr>      
     1 Chile       5%      81 años   11 años    
     2 Uruguay     6%      78 años   11 años    
     3 Argentina   11%     78 años   11 años    
     4 Costa Rica  13%     81 años   9 años     
     5 Panamá      13%     80 años   11 años    
     6 Bolivia     15%     69 años   10 años    
     7 Paraguay    20%     74 años   9 años     
     8 México      22%     75 años   9 años     
     9 Brasil      24%     76 años   8 años     
    10 El Salvador 28%     72 años   7 años     

En los casos de `across()` que hemos visto, las variable son editadas o modificadas, y por ende sobreescritas. Pero también podemos hacer que se creen variables nuevas! Pero, lógicamente, como estamos editando varias columnas a la vez, no podemos darles a todas un nombre distinto. En este caso, usamos el argumento `.names` dentro de `across()` para definir un patrón de nombres para las nuevas columnas:

``` r
datos |> 
  mutate(
    across(c(pobreza, esperanza, escolaridad), 
           ~round(.x),
           .names = "{.col}_redondeada"
    )
  )
```

    # A tibble: 10 × 7
       pais    pobreza esperanza escolaridad pobreza_redondeada esperanza_redondeada
       <chr>     <dbl>     <dbl>       <dbl>              <dbl>                <dbl>
     1 Chile         5      81.2       11.3                   5                   81
     2 Uruguay       6      78.1       10.5                   6                   78
     3 Argent…      11      77.7       11.2                  11                   78
     4 Costa …      13      80.8        8.84                 13                   81
     5 Panamá       13      79.6       10.8                  13                   80
     6 Bolivia      15      68.6       10.0                  15                   69
     7 Paragu…      20      73.8        8.93                 20                   74
     8 México       22      75.1        9.35                 22                   75
     9 Brasil       24      75.8        8.43                 24                   76
    10 El Sal…      28      72.1        7.3                  28                   72
    # ℹ 1 more variable: escolaridad_redondeada <dbl>

En este caso, usamos `{.col}` dentro de `.names` para indicar que el nombre de la nueva columna va a ser igual al nombre de la columna original (representada por `.col`), seguido del texto `_redondeada`. Esta sintaxis para crear textos [se llama *glue*](https://glue.tidyverse.org/articles/glue.html) y es muy útil para crear textos dinámicos en R.

------------------------------------------------------------------------

Estas son las herramientas básicas que necesitas para crear y modificar variables en R! Al final se trata de usar `mutate()` para crear algo nuevo o editar algo existente, usando valores nuevos, otras columnas, o funciones, y combinar estas herramientas para llevar a cabo lo que necesitemos, ya sea limpieza de datos o análisis de datos más complejos.

{{< cursos >}}
{{< cafecito >}}
