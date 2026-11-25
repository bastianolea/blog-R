---
title: Temas de colores personalizados para tus gráficos {ggplot2}
author: Bastián Olea Herrera
date: '2026-01-22'
draft: false
freeze: true
format:
  hugo-md:
    output-file: index
    output-ext: md
slug: []
categories: []
tags:
  - visualización de datos
  - ggplot2
  - gráficos
links:
  - icon: github
    icon_pack: fab
    name: Código
    url: https://gist.github.com/bastianolea/23dee295aceb142fcd66ad29c21a51cb
excerpt: >-
  Darle un toque de color a tus gráficos en `{ggplot2}` produce visualizaciones
  con más personalidad y mayor impacto. En este post veremos cómo aplicar temas
  de colores a tus gráficos! Para ayudarte con eso también existe el paquete
  `{thematic}` para cambiar fácilmente los colores de fondo de tus gráficos.
---


Darle un toque de color a tus gráficos produce visualizaciones con **más personalidad** y **mayor impacto**. Pero cambiar el color de cada elemento puede parecer engorroso 😣

¡Pero es fácil! Veamos cómo se puede hacer [con las nuevas funcionalidades de `{ggplot2}` versión 4.0.](https://tidyverse.org/blog/2025/09/ggplot2-4-0-0/#theme-improvements)

Primero generemos datos al azar para crear una visualización de demostración:

``` r
library(dplyr)

# crear datos al azar
datos <- tibble(a = 1:10,
                b = rnorm(10, mean = 7, sd = 2)
                )
```

Ahora creemos un gráfico básico:

``` r
library(ggplot2)

grafico <- datos |> 
  ggplot() +
  aes(x = as.factor(a), y = b) +
  # capa de columnas
  geom_col(width = 0.5) +
  # capa de texto
  geom_text(aes(label = round(b, 0), y = b + 0.6), 
            size = 3, fontface = "bold")

grafico
```

<img loading="lazy" src="ggplot_temas.markdown_strict_files/figure-markdown_strict/unnamed-chunk-2-1.png" width="768" />

Agreguemos algunas capas extra para mejorar la apariencia de nuestro gráfico:

``` r
grafico <- grafico +
  # etiquetas de texto
  labs(title = "Gráfico de barras",
       subtitle = "Números al azar",
       x = "Eje horizontal", y = "Eje vertical",
       caption = "Fuente: de los deseos") +
  # ajuste del espaciado vertical
  scale_y_continuous(expand = expansion(c(0, 0.05))) +
  # detalles del tema
  theme(plot.title = element_text(face = "bold"),
        panel.grid.minor.y = element_line(linetype = 2, linewidth = .5),
        axis.ticks.x = element_blank())

grafico
```

<img loading="lazy" src="ggplot_temas.markdown_strict_files/figure-markdown_strict/unnamed-chunk-3-1.png" width="768" />

## Cambiar colores de los temas de `{ggplot2}`

Ahora, para cambiar los colores del gráfico, podemos usar una **función para aplicar un tema**, como `theme_classic()` o `theme_minimal()`, dentro de la cual podremos **definir los colores principales** del gráfico:

-   El color de **fondo** o *papel* (`paper`)
-   El color de los **elementos** o *tinta* (`ink`)
-   El color de **acento** (`accent`)

Probemos con `theme_classic()`:

``` r
grafico +
  theme_classic(paper = "#EAD2FA", 
                ink = "#553A74", 
                accent = "#9069C0")
```

<img loading="lazy" src="ggplot_temas.markdown_strict_files/figure-markdown_strict/unnamed-chunk-4-1.png" width="768" />

Tan solo con definir tres colores, obtenemos un gráfico con una apariencia mucho mejor! 💜

Intentemos ahora con `theme_minimal()`:

``` r
grafico +
  theme_minimal(paper = "#EAD2FA", 
                ink = "#553A74", 
                accent = "#9069C0")
```

<img loading="lazy" src="ggplot_temas.markdown_strict_files/figure-markdown_strict/unnamed-chunk-5-1.png" width="768" />

## Aplicar temas con `{thematic}`

Otra forma de aplicar temas de colores a tus gráficos es con el [paquete `{thematic}`](https://rstudio.github.io/thematic/).

La idea de `{thematic}` es que tenemos que *activar* la **función que aplica los temas** con `thematic_on()`, y en el momento que la activamos, definimos los **colores principales** de nuestro tema. Estos colores son de **fondo** (`bg`) y de **frente** (`fg`), que como su nombre lo indica, definen el color base del gráfico y el color de los elementos principales.

``` r
library(thematic)

thematic_on(fg = "#553A74",
            bg = "#EAD2FA")

grafico
```

<img loading="lazy" src="ggplot_temas.markdown_strict_files/figure-markdown_strict/unnamed-chunk-6-1.png" width="768" />

Solamente con definir dos colores con `thematic_on()` e imprimir el gráfico obtenemos el gráfico con el tema aplicado. Muy lindo 💜

La diferencia entre cambiar los temas con las funciones de `{ggplot2}` y con `{thematic}` es que `{thematic}` toma algunas decisiones extra para hacer más bonitos tus gráficos, como un color de fondo más tenue, entre otras.

Por otro lado, `{thematic}` tiene la ventaja de que [puede trabajar en conjunto con tus aplicaciones Shiny](https://bastianolea.rbind.io/blog/shiny_temas/#aplicar-el-tema-de-tu-app-shiny-a-tus-gráficos), de manera que el tema de tu app se aplique a tus gráficos automáticamente.

## Eligiendo temas de colores

Para encontrar pares de colores interesantes, recomiendo el sitio [Pigment](https://pigment.shapefactory.co), que genera pares de colores a los que puedes ajustar su saturación y su nivel de iluminación.

{{< imagen "pigment.png" >}}

Veamos algunos ejemplos de como queda el mismo gráfico con otros pares de colores:

``` r
thematic_on(fg = "#51BBAC",
            bg = "#2B5556")

grafico
```

<img loading="lazy" src="ggplot_temas.markdown_strict_files/figure-markdown_strict/unnamed-chunk-8-1.png" width="768" />

``` r
thematic_on(fg = "#7FBCC4",
            bg = "#473649")

grafico
```

<img loading="lazy" src="ggplot_temas.markdown_strict_files/figure-markdown_strict/unnamed-chunk-9-1.png" width="768" />

``` r
thematic_on(fg = "#6E6962",
            bg = "#C5BEB5")

grafico
```

<img loading="lazy" src="ggplot_temas.markdown_strict_files/figure-markdown_strict/unnamed-chunk-10-1.png" width="768" />

Para desactivar la aplicación del tema de colores, usa `thematic_off()` y volverás a la aburrida normalidad.

``` r
thematic_off()

grafico
```

<img loading="lazy" src="ggplot_temas.markdown_strict_files/figure-markdown_strict/unnamed-chunk-11-1.png" width="768" />

¡Así de simple! Claramente es una forma **básica y rápida** de personalizar la apariencia de las visualizaciones, pero el resultado suele ser positivo considerando el poquísimo esfuerzo necesario para lograrlo. Eficiencia, yey! 🥰

{{< cafecito >}}
{{< cursos >}}
