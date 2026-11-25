---
title: Gráficos de puente en `{ggplot2}`
author: Bastián Olea Herrera
date: '2026-02-05'
slug: []
categories: []
tags:
  - visualización de datos
  - gráficos
format:
  hugo-md:
    output-file: index
    output-ext: md
execute:
  warning: false
excerpt: >-
  Me pidieron reproducir con R un gráfico de puente que habían hecho en Excel,
  para poder crear decenas de versiones del mismo gráfico a partir de datos
  distintos y/o actualizados. En este post veremos cómo hacer gráficos de puente
  con R, que son gráficos donde las barras representan el cambio de un valor
  original en el tiempo, o bien, la contribución de varias cifras a un valor
  final, en la forma de barras escalonadas.
---


Me pidieron reproducir con R un **gráfico de puente** que habían hecho en Excel, para poder crear decenas de versiones del mismo gráfico a partir de datos distintos y/o actualizados.

Éste era el gráfico original:

{{< imagen_tamaño "original.png" >}}
{{< bajada "El gráfico de puente original" >}}

Los **gráficos de puente** son gráficos donde las barras representan el cambio de un valor original en el tiempo, o bien, la contribución de varias cifras a un valor final, en la forma de barras escalonadas.

Nunca había hecho uno, y tampoco sabía cómo se llamaban como para buscar instrucciones, así que me puse a intentarlo!

Éstos son los datos originales:

``` r
datos <- tibble::tribble(
  ~valor,        ~factor, ~region,    
  0.267569260593819,       "produc",       1, 
  0.658155474611586, "merc laboral",       1, 
  0.124032556711811,        "innov",       1, 
  0.346384929903161,       "empres",       1, 
  0.197669772542558,          "gob",       1, 
  0.1331561948028,          "salud",       1, 
  1.18645838429506,         "segur",       1, 
  -0.25626249726395,     "cap ingr",       1, 
  0.0845792632225653,    "igualdad",       1, 
  0.58032570060242,       "ent viv",       1, 
  0.107679485231535,      "med amb",       1, 
  0.0248454494479557,     "cap nat",       1, 
  -0.110064921904146,     "cap hum",       1, 
  0.782311601326303,      "cap fis",       1,
)
```

Lo primero que hice fue **explorar visualmente** los datos:

``` r
library(ggplot2)

# definir un tema
theme_set(
  theme_classic(base_family = "Rubik", 
                base_size = 10,
                ink = "#2d4a6d")
)

# visualizar
datos |> 
  ggplot() +
  aes(factor, valor) +
  geom_col()
```

<img loading="lazy" src="index.markdown_strict_files/figure-markdown_strict/unnamed-chunk-2-1.png" width="768" />

Luego fui pensando qué características tenían que tener los datos para poder visualizarlos como en el gráfico original 🤔

## Procesamiento de datos

Lo primero que se necesita es ir **sumando los valores** consecutivamente, dado que el gráfico va visualizando un *puente* donde cada barra parte desde el alto de la anterior. Así que usamos la función `cumsum()` para ir sumando los valores de cada fila con los anteriores, de manera acumulativa:

``` r
library(dplyr)

datos <- datos |> 
  mutate(suma = cumsum(valor))

datos
```

    # A tibble: 14 × 4
         valor factor       region  suma
         <dbl> <chr>         <dbl> <dbl>
     1  0.268  produc            1 0.268
     2  0.658  merc laboral      1 0.926
     3  0.124  innov             1 1.05 
     4  0.346  empres            1 1.40 
     5  0.198  gob               1 1.59 
     6  0.133  salud             1 1.73 
     7  1.19   segur             1 2.91 
     8 -0.256  cap ingr          1 2.66 
     9  0.0846 igualdad          1 2.74 
    10  0.580  ent viv           1 3.32 
    11  0.108  med amb           1 3.43 
    12  0.0248 cap nat           1 3.45 
    13 -0.110  cap hum           1 3.34 
    14  0.782  cap fis           1 4.13 

Con esto obtenemos los **valores superiores** de cada barra del gráfico.

Después necesitamos saber los **valores inferiores** de las barras, que en este tipo de gráfico aparecen **encima** de las barras anteriores. Para saber esto, tomamos la suma acumulada que calculamos antes y le restamos el valor de cada una de las barras; de esta forma obtenemos el valor acumulado *menos* el valor de la barra presente; es decir, su **base**:

``` r
datos <- datos |> 
  mutate(base = suma - valor)

datos
```

    # A tibble: 14 × 5
         valor factor       region  suma  base
         <dbl> <chr>         <dbl> <dbl> <dbl>
     1  0.268  produc            1 0.268 0    
     2  0.658  merc laboral      1 0.926 0.268
     3  0.124  innov             1 1.05  0.926
     4  0.346  empres            1 1.40  1.05 
     5  0.198  gob               1 1.59  1.40 
     6  0.133  salud             1 1.73  1.59 
     7  1.19   segur             1 2.91  1.73 
     8 -0.256  cap ingr          1 2.66  2.91 
     9  0.0846 igualdad          1 2.74  2.66 
    10  0.580  ent viv           1 3.32  2.74 
    11  0.108  med amb           1 3.43  3.32 
    12  0.0248 cap nat           1 3.45  3.43 
    13 -0.110  cap hum           1 3.34  3.45 
    14  0.782  cap fis           1 4.13  3.34 

Luego necesitamos algo simple: indicar si el valor de cada barra es **positivo o negativo**, así que usamos `ifelse()`:

``` r
datos <- datos |> 
  mutate(direcc = if_else(valor > 0,
                          "Positivo",
                          "Negativo"))

datos
```

    # A tibble: 14 × 6
         valor factor       region  suma  base direcc  
         <dbl> <chr>         <dbl> <dbl> <dbl> <chr>   
     1  0.268  produc            1 0.268 0     Positivo
     2  0.658  merc laboral      1 0.926 0.268 Positivo
     3  0.124  innov             1 1.05  0.926 Positivo
     4  0.346  empres            1 1.40  1.05  Positivo
     5  0.198  gob               1 1.59  1.40  Positivo
     6  0.133  salud             1 1.73  1.59  Positivo
     7  1.19   segur             1 2.91  1.73  Positivo
     8 -0.256  cap ingr          1 2.66  2.91  Negativo
     9  0.0846 igualdad          1 2.74  2.66  Positivo
    10  0.580  ent viv           1 3.32  2.74  Positivo
    11  0.108  med amb           1 3.43  3.32  Positivo
    12  0.0248 cap nat           1 3.45  3.43  Positivo
    13 -0.110  cap hum           1 3.34  3.45  Negativo
    14  0.782  cap fis           1 4.13  3.34  Positivo

Ahora falta el último detalle: el gráfico original tiene una barra al final que muestra el **total** o la suma acumulada de todas las barras, pero empezando desde abajo.

Como nuestro *dataframe* tiene una fila por cada barra, tendríamos que agregar una fila nueva al final con el valor total, y con la base en cero. Para ésto podemos usar la función `add_row()`, a la que le podemos entregar los valores de una fila nueva, pero no escribiéndolos a mano, sino basándonos en los datos:

``` r
datos <- datos |> 
  add_row(valor = sum(datos$valor),
          suma = sum(datos$valor),
          base = 0, 
          region = 1,
          factor = "total",
          direcc = "Variación")

tail(datos)
```

    # A tibble: 6 × 6
        valor factor  region  suma  base direcc   
        <dbl> <chr>    <dbl> <dbl> <dbl> <chr>    
    1  0.580  ent viv      1  3.32  2.74 Positivo 
    2  0.108  med amb      1  3.43  3.32 Positivo 
    3  0.0248 cap nat      1  3.45  3.43 Positivo 
    4 -0.110  cap hum      1  3.34  3.45 Negativo 
    5  0.782  cap fis      1  4.13  3.34 Positivo 
    6  4.13   total        1  4.13  0    Variación

Finalmente ordenamos los valores del eje horiontal en el orden que vienen en el *dataframe*, para que no aparezcan por orden alfabético (el orden por defecto que le da `{ggplot2}` a las variables discretas que no están ordenadas)

``` r
datos <- datos |> 
  mutate(factor = forcats::fct_inorder(factor)) 
```

## Visualización

Ahora queda hacer la visualización. Volvemos a probar con las barras:

``` r
datos |> 
  ggplot() +
  aes(x = factor,
      y = valor, 
      fill = direcc) +
  geom_col() +
  guides(fill = guide_legend(position = "top"))
```

<img loading="lazy" src="index.markdown_strict_files/figure-markdown_strict/unnamed-chunk-8-1.png" width="768" />

Claramente no podemos usar columnas (`geom_col()`) porque necesitamos indicar el punto de partida de cada columna en el eje vertical.

Si bien se pueden hacer rectángulos con `{ggplot2}`, preferí usar **líneas** con la función `geom_segment()`, que recibe valores para *x* e *y*, pero también para el **final** de *x* y el final de *y*, permitiendo longitudes personalizadas. Al final, ¿qué es una columna, sino una línea gruesa? 🧠

``` r
datos |> 
  ggplot() +
  aes(x = factor,
      y = valor, 
      color = direcc) +
  geom_segment(
    aes(xend = factor,
        y = base,
        yend = suma)
  ) +
  guides(fill = guide_legend(position = "top"))
```

<img loading="lazy" src="index.markdown_strict_files/figure-markdown_strict/unnamed-chunk-9-1.png" width="768" />

¡Estamos cerca! Ahora engrosamos las líneas con el argumento `linewidth` dentro de `geom_segment()`, agregamos texto con `geom_text()` que se posicione según si es positivo o negativo, una escala de colores con `scale_color_manual()`, y algunos detalles en el tema.

El otro cambio principal es agregar **líneas horizontales** que conecten cada barra con la otra. Lamentablemente, creo que el largo de estas barras es específico a la cantidad de barras y el ancho del gráfico, entre otros factores, así que habrá que experimentar.

``` r
datos |> 
  ggplot() +
  aes(x = factor,
      y = valor, 
      color = direcc) +
  # barras con alto personalizado
  geom_segment(
    aes(xend = factor,
        y = base,
        yend = suma),
    linewidth = 12) +
  # líneas horizontales que conecten las barras
  geom_segment(
    aes(x = as.numeric(factor)-0.4,
        xend = ifelse(factor == "total",
                      as.numeric(factor)+0.4,
                      as.numeric(lead(factor))+0.4),
        y = suma-0.005, yend = suma-0.005),
    alpha = 0.5) +
  # textos encima o debajo de barras
  geom_text(aes(y = suma,
                label = round(valor, 1),
                nudge_y = ifelse(valor > 0, 0.1, -0.1)),
            size = 3,
            show.legend = F) +
  # espaciado vertical
  scale_y_continuous(expand = expansion(c(0, 0.1))) +
  # escala de colores
  scale_color_manual(values = c("Positivo" = "#2d4a6d",
                                "Negativo" = "#b52141",
                                "Variación" = "#668243")) +
  # leyenda
  guides(color = guide_legend(title = NULL, position = "top",
                              override.aes = list(linewidth = 6))) +
  # temas
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title = element_blank(),
        legend.key.width = unit(2, "mm"),
        panel.grid.major.y = element_line(linetype = "dashed", linewidth = 0.2, color = "grey80"))
```

<img loading="lazy" src="index.markdown_strict_files/figure-markdown_strict/grafico_puente_ggplot-1.png" width="1400" />

Listo! Quedó idéntico al original, y también más elegante, pero lo más importante: quedó **reproducible** y listo para empaquetarse en una función que te permita **crear cientos de estos mismos gráficos** con datos distintos o actualizados.
