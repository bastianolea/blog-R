---
title: Encuentra diferencias entre objetos de R con `waldo`
author: Bastián Olea Herrera
date: '2025-11-10'
draft: false
format:
  hugo-md:
    output-file: index
    output-ext: md
slug: []
categories: []
tags:
  - limpieza de datos
  - consejos
  - datos perdidos
links:
  - icon: registered
    icon_pack: fas
    name: Paquete
    url: https://waldo.r-lib.org
excerpt: >-
  `waldo` es un paquete de R para encontrar diferencias entre objetos y
  conjuntos de datos. Es muy útil para solucionarnos problemas comunes que
  generalmente intentamos resolver a mano (o a ojo, jaja). Aprende a usarlo con
  algunos ejemplos prácticos.
---


[`waldo` es un paquete de R](https://waldo.r-lib.org) para encontrar diferencias entre objetos y conjuntos de datos.

Creemos dos vectores de datos de ejemplo:

``` r
vector_a <- c("a", "b", "c", "d", "e")
vector_b <- c("a", "b", "c", "f")
```

Si los comparamos con la función `all.equal()` de R base obtenemos un resultado poco informativo:

``` r
# comparar con base
all.equal(vector_a, vector_b)
```

    [1] "Lengths (5, 4) differ (string compare on first 4)"
    [2] "1 string mismatch"                                

Básicamente nos dice "son distintos" 🤨

Pero si usamos `waldo::compare()`, obtenemos una comparación ordenada y clara de las diferencias:

``` r
# comparar con waldo
compare(vector_a, vector_b)
```

{{< imagen_tamaño "waldo_1.png" "200px" >}}

Se nos informa con color de las diferencias en los datos.

Probemos con otro ejemplo simple de vectores similares:

``` r
vector_c <- c("a", "b", "c", "d")
vector_d <- c("d", "b", "c", "a")

waldo::compare(vector_c, vector_d)
```

{{< imagen_tamaño "waldo_2.png" "200px" >}}

La comparación destaca las diferencias de posición entre ambos vectores.

Desordenemos y ensuciemos un dataframe con ayuda del [paquete `{messy}`, de Nicola Rennie,](https://nrennie.rbind.io/messy/) para compararlo con su versión original:

``` r
iris_b <- iris |> messy::messy()

compare(iris, iris_b)
```

{{< imagen_tamaño "waldo_4.png" "100%">}}

Las diferencias son tantas que indica que las variables son de tipo distinto, y muestra sus primeras observaciones.

Hagamos otra verión sucia de `iris` para comparar ambos dataframe sucios:

``` r
iris_c <- iris |> messy::messy()

compare(head(iris_b), head(iris_c))
```

{{< imagen_tamaño "waldo_5.png" "480px">}}

En este caso te muestra las filas de ambas tablas intercaladas, para que se vean las diferencias, y luego muestra las columnas con los primeros valores distintos.

Hagamos otro par de versiones sucias, pero ahora que sólo difieran en su cantidad de datos perdidos o *missing*:

``` r
iris_c <- iris |> messy::make_missing()
iris_d <- iris |> messy::make_missing()

compare(iris_c, iris_d)
```

{{< imagen_tamaño "waldo_6.png" "400px">}}

En este caso, va destacando las diferencias entre ambos dataframes, indicando con color sus cambios y la cantidad extra de cambios que hay.

Para terminar, veamos un ejemplo más práctico: acá hay dos tablas de datos con **muchas columnas**, todas con nombres levemente distintos. Es una situación que pasa mucho cuando nos encontramos con datos cuyas columnas son solamente ids de variables que luego hay que ir a buscar a un diccionario de datos, y que por lo tanto tienen nombres muy parecidos 😣

| var_ead32 | var_efe23 | var_eea31 | var_edr52 | var_ead30 | var_eae31 |
|----------:|----------:|----------:|----------:|----------:|----------:|
| 0.2715286 | 0.1210294 | 0.7176043 | 0.2076723 | 0.2694439 | 0.1075922 |

| var_ead32 | var_efe23 | var_eae31 | var_ede52 | var_ead30 | var_eae30 |
|----------:|----------:|----------:|----------:|----------:|----------:|
| 0.8332491 |  0.445706 | 0.4351733 | 0.4728819 | 0.3008599 | 0.1886466 |

Así a la rápida es casi imposible saber si las columnas son las mismas, o si no lo son, cuáles sobran y cuáles faltan! 😭

``` r
compare(tabla_a, tabla_b)
```

{{< imagen "waldo_3.png" "300px" >}}

Así podemos ver claramente que hay tres columnas distintas entre ambas tablas, y cuáles son, en vez de partirnos la cabeza y los ojos comparando nombres de columnas 🤓

{{< cafecito >}}
{{< etiqueta "consejos" >}}
{{< cursos >}}
