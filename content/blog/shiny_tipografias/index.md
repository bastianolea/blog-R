---
title: Usando tipografías personalizadas en aplicaciones Shiny
author: Bastián Olea Herrera
date: '2026-05-11'
draft: false
format:
  hugo-md:
    output-file: index
    output-ext: md
slug: []
categories: []
tags:
  - shiny
excerpt: "En este post aprenderás a personalizar las tipografías de tus aplicaciones Shiny. Veremos cómo cargar tipografías de Google Fonts y cómo descargarlas localmente para que funcionen sin conexión."
---

Las tipografías son el aspecto principal de la apariencia de una aplicación, [junto a su paleta de colores.](/blog/shiny_temas/). Elegir bien la tipografía de tu app puede hacer que tu app se vea más profesional y atractiva, y que se diferencie del resto.

{{< relacionada "/blog/shiny/" >}}

En este tutorial veremos cómo personalizar las tipografías de tus aplicaciones Shiny usando el [paquete `{bslib}`](https://rstudio.github.io/bslib/), y cómo descargarlas localmente para que funcionen sin necesidad de conectarse a servidores de Google.

{{< relacionada "/blog/shiny_temas/" >}}

## Tipografía general de la aplicación

La forma más sencilla de cambiar la tipografía de tu app Shiny es **al definir el tema** usando `bs_theme()` del paquete `{bslib}`, que ya vimos en el [tutorial de temas de colores.](/blog/shiny_temas/)

La función `font_google()` permite cargar cualquier tipografía desde [Google Fonts](https://fonts.google.com/) y aplicarla a toda la aplicación:

```r {hl_lines=["1-7"]}
library(shiny)
library(bslib)

ui <- page_fluid(
  theme = bs_theme(
    base_font = font_google("Manrope")
  ),
  
  h1("Título de la app"),
  p("Este texto usa la tipografía Manrope.")
)

server <- function(input, output, session) {
}

shinyApp(ui, server)
```

Con `base_font` definimos la tipografía principal que se usará en toda la aplicación, incluyendo párrafos, botones, selectores y otros elementos de la interfaz. También se puede definir por separado una **tipografía para titulares**, permitiendo usar un par tipográfico que le de aún más personalidad a tu app. Usualmente queda elegante usar tipografías con serifa para títulos, y sans-serif para textos generales:


```r {hl_lines=["5-8"]}
library(shiny)
library(bslib)

ui <- page_fluid(
  theme = bs_theme(
    base_font = font_google("Manrope"),
    heading_font = font_google("Domine")
  ),
  
  h1("Título de la app que usa Domine"),
  p("Este texto usa la tipografía Manrope.")
)

server <- function(input, output, session) {
}

shinyApp(ui, server)
```

{{< imagen "shiny_tipografia_featured.png" "400px" >}}

{{< info "Puedes explorar las tipografías disponibles en [fonts.google.com](https://fonts.google.com/)" >}}

### Tipografías con respaldo

Es buena práctica definir fuentes de respaldo (_fallback_), por si la tipografía de Google no se puede cargar. Puedes hacerlo con `font_collection()`:

```r
theme = bs_theme(
  base_font = font_collection(
    font_google("Manrope"), 
    "Helvetica", "Arial", "sans-serif"
  )
)
```

Si la fuente `Manrope` no carga por alguna razón, el navegador usará `Helvetica`, luego `Arial`, y finalmente cualquier fuente _sans-serif_ disponible.


## Tipografías descargadas localmente

Cuando usamos `font_google()`, la tipografía se carga desde servidores de Google cada vez que alguien abre la app. Esto puede resultar conveniente, pero es poco eficiente. Si descargamos las tipografías podemos hacer que la app se cargue más rápido, y a su vez hacemos que la app tenga un punto menos de fallo.

El paquete `{gfonts}` nos ayuda a descargar tipografías desde Google Fonts:

``` r
install.packages("gfonts")
```

Con `setup_font()` vamos a **descargar** los archivos de la tipografía a la carpeta `www/` de nuestra app:

``` r
gfonts::setup_font("manrope", "www/")
```

{{< info "La carpeta `www/` es una carpeta de las apps Shiny: todo lo que esté dentro estará accesible para el navegador, como las tipografías!" >}}

### Usar la tipografía descargada

Luego, en la interfaz de la app (UI), usamos `use_font()` para cargar el archivo CSS de la tipografía, y la aplicamos al tema con `bs_theme()`:

```r {hl_lines=["4-5", "7-9"]}
library(shiny)
library(bslib)

ui <- page_fluid(
  gfonts::use_font("manrope", "www/css/manrope.css"),
  
  theme = bs_theme(
    base_font = "manrope"
  ),
  
  h1("Título de la app"),
  p("Este texto usa la tipografía Manrope, descargada localmente.")
)

server <- function(input, output, session) {
}

shinyApp(ui, server)
```

De esta forma la tipografía se carga desde los archivos locales, sin depender de una conexión a internet!

{{< relacionada "/blog/ggplot_tipografias" >}}

{{< etiqueta "shiny" >}}

{{< cafecito >}}
{{< cursos >}}
