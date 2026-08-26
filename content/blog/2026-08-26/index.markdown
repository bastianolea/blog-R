---
title: Categorizar una variable contínua con el método de cortes naturales Jenks
author: Bastián Olea Herrera
date: '2026-08-26'
freeze: true
tags:
  - procesamiento de datos
  - estadística
  - limpieza de datos
format:
  hugo-md:
    output-file: index
    output-ext: md
execute:
  message: false
  warning: false
---


```
## Loading required package: sysfonts
```

```
## Loading required package: showtextdb
```

El método de cortes naturales de Jenks se usa para categorizar variables contínuas en variables ordinales; es decir, pasar de una variable numérica a la cantidad de categorías discretas que necesitemos.

El método Jenks busca maximizar varianza entre clases, y minimizar varianza dentro de las clases. La gracia de Jenks es que resalta los saltos inherentes a los datos, y por lo tanto los cortes que ofrece suelen tener más sentido en datos continuos.

En R base se implementa con la función `classIntervals(..., style = "jenks")`, pero [el paquete `{BAMMtools}` ofrece](https://github.com/macroevolution/bammtools) una implementación en C mucho más eficiente: `getJenksBreaks()`.

Primero creemos datos de prueba, una distribucion de densidad _beta_:


``` r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

``` r
datos <- tibble(
  valores = rbeta(1000, 5, 2)
  )
```



Ahora mirémoslos en un gráfico simple:


``` r
library(ggplot2)

datos |> 
  ggplot() +
  aes(x = valores) +
  geom_histogram(bins = 200)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/distribucion_beta-1.png" alt="" width="672" />

Ahora usamos `getJenksBreaks()` para crear `n` _cortes_ en los datos, a partir de los cuales podremos crear `n-1` grupos o categorías. Probemos, como ejemplo, con 5 cortes:


``` r
library(BAMMtools)
```

```
## Loading required package: ape
```

```
## 
## Attaching package: 'ape'
```

```
## The following object is masked from 'package:dplyr':
## 
##     where
```

``` r
cortes <- getJenksBreaks(datos$valores, 5)

cortes
```

```
## [1] 0.1627187 0.4899364 0.6533508 0.8019855 0.9898908
```

Aplicamos los cortes a los datos con la función `cut()`, que _corta_ variables numéricas continuas en los puntos indicados; en este caso, los cortes obtenidos con el método Jenks:


``` r
datos_categoricos <- datos |> 
  mutate(
    categoria = cut(
      valores, # variable a cortar
      labels = 1:4, # nombres de los cortes resultantes
      breaks = cortes, # vector con los cortes
      include.lowest = T
    )
  )
```

Ahora visualicemos el resultado:


``` r
datos_categoricos |> 
  ggplot() +
  aes(x = valores, fill = categoria) +
  geom_histogram(bins = 200, alpha = 0.7) +
  scale_fill_discrete(palette = "Dark2")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/metodo_jenks-1.png" alt="" width="672" />

{{< etiqueta "limpieza-de-datos" >}}

{{< etiqueta "procesamiento-de-datos" >}}
