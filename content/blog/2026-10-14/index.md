---
title: Plantilla de mapa interactivo de Chile con R, Shiny y MapGL
author: Bastián Olea Herrera
date: '2026-10-14'
slug: []
categories: []
tags:
  - mapas
  - Chile
  - shiny
  - videos
  - Aplicaciones
draft: false
format:
  hugo-md:
    output-file: index
    output-ext: md
execute:
  message: false
  warning: false
excerpt: >-
  Usando R, Shiny y MapGL es más fácil que nunca hacer apps web que presenten
  datos georeferenciados de manera precisa y personalizable! Para ayudarte,
  comparto este repositorio de una plantilla de app Shiny que presenta un mapa
  de Chile con un filtro de regiones y comunas para hacerles zoom a los
  territorios seleccionados.
links:
  - icon: file-code
    icon_pack: fas
    name: Código
    url: https://github.com/bastianolea/mapa_chile_mapgl
  - icon: link
    icon_pack: fas
    name: Aplicación
    url: https://bastianolea-mapa-chile-mapgl.share.connect.posit.cloud/
---


Usando R, Shiny y MapGL es más fácil que nunca hacer apps web que presenten datos georeferenciados de manera precisa y personalizable!

R para procesar datos, [Shiny para desarrollar aplicaciones web](./blog/shiny/), y [MapGL para visores de mapas interactivos.](./blog/mapas_mapgl/)

<iframe src="https://www.linkedin.com/embed/feed/update/urn:li:ugcPost:7516166687210151936?compact=1" height="420" width="80%" frameborder="0" allowfullscreen title="Publicación integrada" style="display: block; margin: 0 auto;">
</iframe>

Para ayudarte, comparto este repositorio de una *plantilla base* de app Shiny que presenta un mapa de Chile con un filtro de regiones y comunas para hacerles zoom a los territorios seleccionados.

{{< boton "Ver código" "https://github.com/bastianolea/mapa_chile_mapgl" "fab fa-github" >}}

Por medio de Shiny, la aplicación muestra dos selectores, de región y de comunas, actualizando este último para mostrar las comunas de la región seleccionada, y cualquier combinación de valores entre ambos hace que el mapa se acerque al territorio correspondiente.

{{< relacionada "/blog/shiny/" >}}

Esta aplicación usa el paquete MapGL para mostrar mapas interactivos altamente optimizados y personalizables. Con MapGL puedes presentar tus datos en polígonos, puntos, o cualquier información relacionada al territorio Chileno.

{{< boton "Probar aplicación" "https://bastianolea-mapa-chile-mapgl.share.connect.posit.cloud/" "fas fa-link" >}}
{{< relacionada "/blog/mapas_mapgl/" >}}

A partir de esta combinación de R, Shiny y MapGL podrías hacer que aparezcan datos al presionar comunas o regiones, que salgan tooltips al pasar por encima, filtrar los polígonos, sincronizar un mapa con gráficos o tablas, o lo que se te ocurra!

Si te sirve o usas el código para hacer algo, [me interesa que me cuentes!](./contacto/)

{{< etiqueta "mapas" >}}
{{< etiqueta "shiny" >}}
{{< cafecito >}}
