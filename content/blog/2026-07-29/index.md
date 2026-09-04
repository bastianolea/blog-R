---
title: "Probando visores de mapas interactivos en R con `{mapgl}`"
date: '2026-07-30'
tags:
  - mapas
  - Shiny
  - videos
links:
  - icon: registered
    icon_pack: fas
    name: mapgl
    url: https://walker-data.com/mapgl/
excerpt: "`{mapgl}` es un paquete de R para visualizar datos geográficos por medio de visores de mapas interactivos. En una tarde pude desarrollar un dashboard con Shiny para visualizar datos de Chile, con casi 100 variables de nivel comunal, un selector para acercarse a las regiones y comunas seleccionadas, y dos cuadros con información de los datos elegidos."
---

Vengo a comentar sobre [`{mapgl}`, un paquete de R](https://walker-data.com/mapgl/) estupendo para visualizar datos geográficos por medio de visores de mapas interactivos: [Mapbox](https://www.mapbox.com) y [MapLibre](https://maplibre.org).

{{< imagen "mapgl-shiny-featured.jpg" >}}

En una tarde pude [desarrollar un dashboard con Shiny](/blog/shiny/) para visualizar datos de Chile, con un selector de categorías de datos (cada una con una paleta de colores) y casi 100 variables de nivel comunal, un selector para acercarse a las regiones y comunas seleccionadas, y dos cuadros con información de los datos elegidos. 

<iframe src="https://www.linkedin.com/embed/feed/update/urn:li:ugcPost:7488247604263194624?compact=1" height="399" width="504" frameborder="0" allowfullscreen="" title="Publicación integrada"></iframe>

Tras el visor de mapas hay simplemente una base de datos Arrow, una tabla con polígonos comunales, y una tabla de metadatos. Las tres interactúan según las elecciones en la app, y actualizan el visor de mapas con los datos geográficos, el tooltip y la paleta de colores.

Gracias a este paquete desarrollado por [Kyle Walker](https://walker-data.com) es muchísimo más fácil y accesible aplicar visores de mapas interactivos y vectorizados a cualquier proyecto de R, con muy poca dificultad y costo cero! 

Pronto escribiré un [tutorial](/categories/tutoriales/), porque todavía estoy aprendiendo 🥰

{{< relacionada "/blog/mapas_mapgl/" >}}

{{< etiqueta "mapas" >}}