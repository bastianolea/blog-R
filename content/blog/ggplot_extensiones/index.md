---
title: Extensiones recomendadas para mejorar tus gráficos de `{ggplot2}`
author: Bastián Olea Herrera
date: '2026-03-27'
slug: []
draft: false
categories: []
tags:
  - visualización de datos
  - ggplot2
  - consejos
format:
  hugo-md:
    output-file: index
    output-ext: md
excerpt: "Existen muchas extensiones para `{ggplot2}` desarrolladas por la comunidad, que le agregan nuevas funcionalidades, formas de visualizar datos, mejoras, paletas de colores y más. En esta publicación compartiré las extensiones de `{ggplot2}` que más uso y/o que recomiendo."
---

{{< aviso "Publicación en construcción! A medida que encuentre (y recuerde) más extensiones las iré listando aquí." >}}

{{< imagen_lateral "ggplot2_extensiones_featured.png" "300px" >}}

Una de las ventajas de usar `{ggplot2}` para visualización de datos en R es su **flexibilidad** y capacidad de **personalización**. Existen [muchas extensiones desarrolladas por la comunidad](https://exts.ggplot2.tidyverse.org) para agregar nuevas funcionalidades, formas de visualizar datos, mejoras, paletas de colores y más.

A continuación, compartiré acá enlaces a las extensiones de `{ggplot2}` que más uso y/o que recomiendo:

<!--
<div class="contenedor-extension">

<div class="contendor-imagen">
<img src="https://jbengler.github.io/tidyplots/logo.svg" class="imagen-extension">
</div>

<div>

<h3 class="titulo-extension"><a href="https://jbengler.github.io/tidyplots/">tidyplots</a></h3>

Paquete que simplifica la creación de gráficos atractivos y simples de hacer en R, basándose en `{ggplot2}`. Facilita mucho la generación de visualizaciones profesionales y estadísticas.
</div>

</div>
-->

## Extensiones generales

{{< extension 
  "tidyplots" 
  "https://jbengler.github.io/tidyplots/" 
  "https://jbengler.github.io/tidyplots/logo.svg" 
  "Paquete que simplifica la creación de gráficos atractivos y simples de hacer en R, basándose en `{ggplot2}`. Facilita mucho la generación de visualizaciones profesionales y estadísticas." >}}

{{< extension 
  "camcorder" 
  "https://thebioengineer.github.io/camcorder/" 
  "https://thebioengineer.github.io/camcorder/logo.png" 
  "Al activarlo, empieza a _grabar_ todos los pasos de las visualizaciones que hagas, de manera que al terminar la visualización puedes obtener una animación del proceso de su desarrollo. Muy entretenido para poder compartir videos de cómo hiciste un gráfico! [Tutorial de uso aquí.](/blog/camcorder/)" >}}

{{< extension 
  "ggview" 
  "https://github.com/idmn/ggview" 
  "https://raw.githubusercontent.com/idmn/ggview/refs/heads/master/man/figures/logo.svg" 
  "Permite poner la función `canvas()` al final de tus gráficos para delimitar el tamaño de los mismos, y que así el tamaño de la previsualización del gráfico no dependa de tu ventana. Sirve mucho para desarrollar las visualizaciones considerando el tamaño específico con el que vas a guardarlas. [Tutorial de uso aquí.](/blog/ggview/)" >}}

{{< extension 
  "patchwork"
  "https://patchwork.data-imaginist.com/"
  "https://patchwork.data-imaginist.com/logo.svg"
  "Con esta extensión se pueden unir y combinar múltiples gráficos de `{ggplot2}` tan sólo usando operadores como `+` y otros; es decir, simplemente sumando dos gráficos obtienes una visualización de gráficos combinados. Esto nos permitirá construir visualizaciones más densas, por medio de la combinación de gráficos en una sola visualización, y la inserción de gráficos dentro de otros. [Tutorial de uso aquí.](/blog/patchwork/)" >}}

{{< extension 
  "ggiraph"
  "https://davidgohel.github.io/ggiraph"
  "https://davidgohel.github.io/ggiraph/reference/figures/logo.png"
  "Este paquete agrega interactividad a los gráficos `{ggplot2}`. Esto significa que tus gráficos podrán mostrar información extra al pasar el cursor encima (_tooltips_), hacer que se destaquen u oculten elementos al pasar el cursor, hacer clic en elementos del gráfico para generar cambios en aplicaciones, y más. También es posible combinar la interactividad de dos o más gráficos, lo que permite crear visualizaciones más complejas. [Tutorial de uso aquí.](/blog/ggiraph/)" >}}
 
{{< extension
  "ggforce"
  "http://ggforce.data-imaginist.com"
  "https://ggforce.data-imaginist.com/logo.svg"
  "Agrega nuevas geometrías, estadísticas, y facetas a `{ggplot2}`. Algunas de sus funcionalidades son: ahcer cuadros o círculos que envuelvan tus datos, distintas marcas y flechas para anotaciones, envolver puntos con figuras, crear facetas que amplían tus gráficos, geometrías Voronoi, gráficos aluviales, y más." >}}

<!--
- https://ggfx.data-imaginist.com
- https://nrennie.rbind.io/blog/introducing-ggauto/
-->

## Geometrías nuevas o mejoradas


{{< extension 
  "ggrepel"
  "https://ggrepel.slowkow.com"
  "https://github.com/slowkow/ggrepel/raw/master/man/figures/logo.svg"
  "Este paquete agrega geometrías como `geom_text_repel()` que permiten que las etiquetas de texto en tus visualizaciones no se sobrepongan, haciendo que se muevan para mantenerlas visibles. Muy útil para gráficos de dispersión con demasiados textos." >}}
  
{{< extension 
  "ggtext"
  "https://github.com/wilkelab/ggtext/"
  "/ggplot2_empty_hex.png"
  "Este paquete agrega geometrías como `geom_richtext()` que permiten darle estilo personalizado a los textos de tus gráficos: agregar colores, negritas, itálicas, personalizar tamaños y espaciados, y más usando `HTML`." >}}

{{< extension
  "ggstream"
  "https://github.com/davidsjoberg/ggstream"
  "/ggplot2_empty_hex.png"
  "Agrega la geometría `geom_stream()` para crear gráficos de flujo o de corrientes, que muestran cómo cambian las proporciones de distintas categorías a lo largo del tiempo u otra variable. [Ejemplo de uso.](/blog/2025-07-28/)" >}}

  <!--
**Otras:**
- https://jurjoroa.github.io/ggpop/
- https://github.com/R-CoderDotCom/calendR
- https://yonicd.github.io/ggalt/articles/splines.html
- https://r-graph-gallery.com/web-bump-plot-with-highlights.html
- https://chop-cgtinformatics.github.io/ggswim/
- https://indrajeetpatil.github.io/ggstatsplot/index.html
-->

## Escalas y leyendas
{{< extension 
  "ggnewscale"
  "https://eliocamp.github.io/ggnewscale/"
  "https://eliocamp.github.io/ggnewscale/logo.png"
  "Permite agregar múltiples escalas de colores a un mismo gráfico, algo que a veces se requiere en visualizaciones complejas. Por ejemplo, si quieres usar una escala de colores para los puntos de un gráfico de dispersión y otra escala de colores para las líneas de tendencia." >}}

{{< extension
  "legendry"
  "https://teunbrand.github.io/teunbrand_blog/posts/2024-11-01-legendry-0-1-0/"
  "https://teunbrand.github.io/legendry/logo.png"
  "Expande las posibilidades de las leyendas y escalas de tus gráficos, agregando rangos encima de los ejes, varias guías simultáneas, corchetes que explican aspectos de los ejes, y más." >}}

<!--
## Paletas de colores
- https://nanx.me/ggsci/
- https://github.com/thomasp85/scico

## Mapas
- https://dieghernan.github.io/tidyterra/
-->

## Avanzadas

{{< extension
  "ggblend"
  "https://mjskay.github.io/ggblend/"
  "https://mjskay.github.io/ggblend/logo.svg"
  "Permite mezclar capas de tus gráficos usando distintos modos de mezcla, como multiplicar, superponer, oscurecer, aclarar, y más. Esto te permitirá crear visualizaciones con efectos visuales interesantes y resaltar ciertas partes de tus gráficos." >}}

## Más extensiones

Existen varias listas de extensiones de `{ggplot2}`:

- [Awesome `ggplot2`](https://github.com/erikgahner/awesome-ggplot2)
- [Lista oficial de extensiones](https://exts.ggplot2.tidyverse.org)
- [Galería interactiva de extensiones](https://companion.ggplot2-extended-book.com)
- [Libro _`ggplot2` extended_, de Antti Rask](https://ggplot2-extended-book.com)