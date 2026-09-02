---
title: Mapas interactivos para visualizar datos geoespaciales con `{mapgl}`
author: Bastián Olea Herrera
date: '2026-08-31'
freeze: false
draft: true
slug: []
categories:
  - tutoriales
tags:
  - mapas
  - visualización de datos
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: registered
    icon_pack: fas
    name: SF
    url: https://r-spatial.github.io/sf/
execute:
  eval: false
  message: false
  warning: false
knitr:
  opts_chunk:
    dev.args:
      bg: transparent
excerpt: ''
editor_options:
  chunk_output_type: console
---


~/Documents/Otros/blog-r/.posit/assistant/plans/2026-08-05-1400-plan.md

Vengo a comentar sobre [`{mapgl}`, un paquete de R](https://walker-data.com/mapgl/) estupendo para visualizar datos geográficos por medio de visores de mapas interactivos: [Mapbox](https://www.mapbox.com) y [MapLibre](https://maplibre.org).

{{< imagen "mapgl-shiny-featured.jpg" >}}

En una tarde pude [desarrollar un dashboard con Shiny](../../../blog/shiny/) para visualizar datos de Chile, con un selector de categorías de datos (cada una con una paleta de colores) y casi 100 variables de nivel comunal, un selector para acercarse a las regiones y comunas seleccionadas, y dos cuadros con información de los datos elegidos.

<iframe src="https://www.linkedin.com/embed/feed/update/urn:li:ugcPost:7488247604263194624?compact=1" height="399" width="504" frameborder="0" allowfullscreen title="Publicación integrada">
</iframe>

Tras el visor de mapas hay simplemente una base de datos Arrow, una tabla con polígonos comunales, y una tabla de metadatos. Las tres interactúan según las elecciones en la app, y actualizan el visor de mapas con los datos geográficos, el tooltip y la paleta de colores.

Gracias a este paquete desarrollado por [Kyle Walker](https://walker-data.com) es muchísimo más fácil y accesible aplicar visores de mapas interactivos y vectorizados a cualquier proyecto de R, con muy poca dificultad y costo cero!

Pronto escribiré un [tutorial](../../../categories/tutoriales/), porque todavía estoy aprendiendo 🥰

Aquí vemos 29.256 polígonos con las localidades de Chile, que en total suman más de 12 millones de vértices, pero que se visualizan sin problema! [El paquete de R `{pmtiles}`](https://github.com/walkerke/pmtiles) optimiza datos geográficos complejos para visualizarlos con mucha mejor velocidad 🚀🗺️

<iframe src="https://www.linkedin.com/embed/feed/update/urn:li:ugcPost:7490107856571183104?compact=1" height="399" width="504" frameborder="0" allowfullscreen title="Publicación integrada">
</iframe>

La gracia de PMTiles es que procesa datos geográficos para que al visualizarlos se carguen solamente los polígonos necesarios, y a un nivel de detalle optimizado! Si tu mapa es demasiado complejo y colapsa tu computador o no sirve para desplegarlo en producción, `{pmtiles}` te sirve!

Pero lo mejor es que esto es demasiado simple con R:

### Optimización y servidor de mapas con `{pmtiles}`

Se necesitan menos de 40 líneas para cargar las geometrías y datos en Parquet, luego optimizarlos con `{pmtiles}` y lanzar el servidor de mapas.

``` r
# crear pmtiles desde datos geográficos
library(arrow)
library(dplyr)
library(sf)
library(pmtiles)
library(mapgl)

# cargar mapa local en parquet
loc_aisladas <- read_parquet("datos/parquet/LOC_AIS_17.parquet") |>
  select(-geometry_bbox) |>
  st_as_sf() |>
  st_set_crs(5360)

# crear archivo PMTiles con geometrías optimizadas
pm_create(
  loc_aisladas,
  "datos/localidades.pmtiles",
  layer_name = "localidades",
  min_zoom = 2,
  max_zoom = 12,
  detect_shared_borders = TRUE,
  extend_zooms_if_still_dropping = TRUE,
  coalesce_densest_as_needed = TRUE,
  coalesce_smallest_as_needed = TRUE,
  coalesce_fraction_as_needed = TRUE,
  # drop_fraction_as_needed = TRUE,
  # drop_smallest_as_needed = TRUE,
  guess_maxzoom = TRUE,
  simplification = 7
)

# levantar servidor de mapas local
pm_stop_server()
pm_serve("datos/localidades.pmtiles", port = 8080)
```

### Visor de mapas con `{mapgl}`

- Menos de 40 líneas para hacer un \[visor de mapas interactivo con `{mapgl}`}(https://walker-data.com/mapgl/) que se alimenta del servidor de mapas para visualizar datos geográficos complejos (en los comentarios dejo ejemplos del código)

``` r
# mapa interactivo mapgl usando pmtiles
# escala de color basada en variable desde los datos

library(arrow)
library(pmtiles)
library(mapgl)

# cargar datos
loc_aisladas <- read_parquet(
  "datos/parquet/LOC_AIS_17.parquet",
  col_select = "HABITANTES"
)

pm_serve("datos/localidades.pmtiles", port = 8080)

escala <- interpolate_palette(
  data = loc_aisladas,
  column = "HABITANTES",
  method = "quantile",
  n = 6,
  colors = c("#fde0dd", "#fa9fb5", "#c51b8a"),
  na_color = "gray"
)

maplibre(center = c(-70.9, -33.5), minZoom = 4, maxZoom = 11) |>
  add_pmtiles_source(
    "localidades",
    url = "http://localhost:8080/localidades.pmtiles"
  ) |>
  add_fill_layer(
    id = "localidades-fill",
    source = "localidades",
    source_layer = "localidades",
    fill_color = escala$expression,
    fill_opacity = 0.7,
    # tooltips
    tooltip = concat(
      "<strong>",
      get_column("NOMBRE"),
      "</strong><br>",
      get_column("COM_NOM"),
      "<br>",
      "Habitantes: ",
      get_column("HABITANTES")
    ),
    tooltip_style = tooltip_style(
      background_color = "#FFFFFF",
      background_opacity = .6,
      border_radius = 8
    )
  ) |>
  add_continuous_legend(
    legend_title = "Habitantes",
    values = escala$breaks,
    colors = escala$colors,
    position = "bottom-left",
    style = legend_style(
      background_color = "#FFFFFF",
      background_opacity = .6,
      border_radius = 8,
      padding = 8,
      text_size = 9
    )
  )
```

Tanto `{pmtiles}` para servidores de mapas optimizados por teselas (tiles), como `{mapgl}` para visores de mapas interactivos, fueron desarrollados por [el gran Kyle Walker!](https://walker-data.com)

{{< etiqueta "mapas" >}}
{{< relacionada "mapas_sf" >}}

Mapa básico para previsualizar

Primero instalamos [`{mapgl}`](https://walker-data.com/mapgl/):

``` r
install.packages("mapgl")
```

Luego lo cargamos:

``` r
library(mapgl)
```

Y probamos su funcionamiento con un **mapa vacío** (prueba haciendo zoom o navegando el mapa con el cursor)

``` r
maplibre(center = c(-71.5, -33.0), 
         zoom = 3)
```

Ahora usemos `{mapgl}` con los datos censales. Podemos **repetir el proceso** de filtrado de la comuna o región que nos interese:

``` r
# filtrar y seleccionar
manzanas_comuna <- manzanas |> 
  filter(COMUNA == "VALPARAÍSO") |> 
  select(REGION, n_edad_60_mas, SHAPE)
```

Luego hacemos la misma conversión a `{sf}` para trabajar mejor con datos espaciales:

``` r
# convertir a sf
manzanas_comuna_sf <- manzanas_comuna |> 
  st_as_sf(crs = 4326)
```

Finalmente podemos **visualizar los datos en un mapa interactivo** con la función `maplibre_view()`, especificando la variable que queremos graficar en el mapa:

``` r
manzanas_comuna_sf |> 
  maplibre_view(column = "n_edad_60_mas")
```

¡Así de simple! 💜

Lo interesante es que `{mapgl}` también permite hacer cosas [mucho más increíbles](https://walker-data.com/mapgl/articles/layers-overview.html) usando [Mapbox](https://www.mapbox.com/), una plataforma de mapas de primer nivel que tiene muchas más opciones de personalización y estilos de mapas, incluyendo figuras tridimensionales, edificios, efectos visuales y más.

------------------------------------------------------------------------

Mapa con marcadores

``` r
maplibre(
  style = carto_style("dark-matter"),
  bounds = puntos,
  zoom = 13,
  minZoom = 7,
  maxZoom = 13,
  attributionControl = FALSE
) |> 
  add_markers(
    data = puntos_popup,
    
    color = "#DD2694",
    popup = "popup_html",
  )
```

Mapa con tooltip y leyenda

``` r
# mapa interactivo mapgl usando pmtiles
# escala de color basada en variable desde los datos

library(arrow)
library(pmtiles)
library(mapgl)

# cargar datos
loc_aisladas <- read_parquet(
  "datos/parquet/LOC_AIS_17.parquet",
  col_select = "HABITANTES"
)

pm_serve("datos/localidades.pmtiles", port = 8080)

escala <- interpolate_palette(
  data = loc_aisladas,
  column = "HABITANTES",
  method = "quantile",
  n = 6,
  colors = c("#fde0dd", "#fa9fb5", "#c51b8a"),
  na_color = "gray"
)

maplibre(center = c(-70.9, -33.5), minZoom = 4, maxZoom = 11) |>
  add_pmtiles_source(
    "localidades",
    url = "http://localhost:8080/localidades.pmtiles"
  ) |>
  add_fill_layer(
    id = "localidades-fill",
    source = "localidades",
    source_layer = "localidades",
    fill_color = escala$expression,
    fill_opacity = 0.7,
    # tooltips
    tooltip = concat(
      "<strong>",
      get_column("NOMBRE"),
      "</strong><br>",
      get_column("COM_NOM"),
      "<br>",
      "Habitantes: ",
      get_column("HABITANTES")
    ),
    tooltip_style = tooltip_style(
      background_color = "#FFFFFF",
      background_opacity = .6,
      border_radius = 8
    )
  ) |>
  add_continuous_legend(
    legend_title = "Habitantes",
    values = escala$breaks,
    colors = escala$colors,
    position = "bottom-left",
    style = legend_style(
      background_color = "#FFFFFF",
      background_opacity = .6,
      border_radius = 8,
      padding = 8,
      text_size = 9
    )
  )
```

{{< etiqueta "mapas" >}}
