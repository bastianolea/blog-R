---
title: Rotar un mapa de Chile en R para que quede horizontal
author: Bastián Olea Herrera
format:
  hugo-md:
    output-file: "index"
    output-ext: "md"
date: '2025-03-04'
categories: ['Tutoriales']
freeze: true
tags:
  - mapas
  - visualización de datos
  - Chile
editor_options: 
  chunk_output_type: console
excerpt: Visualizar un mapa de Chile puede ser complicado debido a su largo. Muchas veces cuesta ubicar correctamente el mapa por el espacio vertical que requiere. Pero en ciertos casos puede ser conveniente visualizar a Chile _de lado_, para aprovechar el espacio horizontal. En esta guía veremos cómo rotar un mapa de Chile 90° hacia la izquierda en R para que quede acostado.
links:
  - icon: file-code
    icon_pack: fas
    name: Código
    url: https://gist.github.com/bastianolea/8e3dff701fb660ee7cb5091bd1195b5f
---

Visualizar un mapa de Chile puede ser complicado debido a su largo. Muchas veces cuesta ubicar correctamente el mapa por el espacio vertical que requiere. Pero en ciertos casos puede ser conveniente **visualizar a Chile _de lado_**, para aprovechar el espacio horizontal. 

En esta guía veremos cómo rotar un mapa de Chile 90° hacia la izquierda en R para que quede acostado 💤🌙

{{< aviso "Si necesitas aprender en profundidad la visualización de mapas con R, revisa mi [tutorial de mapas y datos espaciales con `{sf}`](/blog/mapas_sf/)." >}}

Primero cargamos los paquetes necesarios:


``` r
library(sf) # manejo de datos espaciales
library(chilemapas) # mapas de Chile
library(ggplot2) # visualización de datos
library(dplyr) # manejo de datos tabulares
library(readr) # cargar datos
```

Obtenemos un mapa de Chile [gracias al paquete `{chilemapas}`](https://github.com/pachadotdev/chilemapas); en este caso un mapa del país por regiones:

``` r
# obtener mapa
mapa_region <- chilemapas::generar_regiones()

mapa_region
```

```
## Simple feature collection with 16 features and 1 field
## Geometry type: GEOMETRY
## Dimension:     XY
## Bounding box:  xmin: -109.4499 ymin: -56.52511 xmax: -66.41617 ymax: -17.49778
## Geodetic CRS:  SIRGAS 2000
## # A tibble: 16 × 2
##    codigo_region                                                        geometry
##    <chr>                                                          <GEOMETRY [°]>
##  1 01            POLYGON ((-69.93023 -21.4246, -69.92376 -21.42622, -69.91932 -…
##  2 02            MULTIPOLYGON (((-68.0676 -24.32856, -67.91698 -24.26902, -67.8…
##  3 03            MULTIPOLYGON (((-71.58497 -29.02456, -71.58844 -29.02838, -71.…
##  4 04            MULTIPOLYGON (((-70.54551 -31.30742, -70.53877 -31.30074, -70.…
##  5 05            MULTIPOLYGON (((-71.33832 -33.45237, -71.33763 -33.44836, -71.…
##  6 06            POLYGON ((-71.5477 -34.87458, -71.54211 -34.87581, -71.53566 -…
##  7 07            POLYGON ((-70.41724 -35.63022, -70.41108 -35.6302, -70.40146 -…
##  8 08            MULTIPOLYGON (((-73.53466 -36.97378, -73.53245 -36.97829, -73.…
##  9 09            MULTIPOLYGON (((-73.35306 -38.73343, -73.35396 -38.72799, -73.…
## 10 10            MULTIPOLYGON (((-73.1691 -41.87755, -73.16135 -41.87781, -73.1…
## 11 11            MULTIPOLYGON (((-75.41754 -48.73857, -75.43249 -48.74372, -75.…
## 12 12            MULTIPOLYGON (((-70.35563 -52.94478, -70.34688 -52.93971, -70.…
## 13 13            POLYGON ((-70.47405 -33.8624, -70.47327 -33.86269, -70.46068 -…
## 14 14            MULTIPOLYGON (((-73.39503 -39.88698, -73.39672 -39.89339, -73.…
## 15 15            POLYGON ((-69.07223 -19.02723, -69.06394 -19.02607, -69.04748 …
## 16 16            POLYGON ((-72.38553 -36.91169, -72.37685 -36.91617, -72.37034 …
```

``` r
# visualizar
mapa_region |> 
  ggplot(aes()) +
  geom_sf() +
  # recortar coordenadas horizontales
  coord_sf(xlim = c(-80, -62))
```

<img src="/blog/mapa_chile_horizontal/mapa_chile_horizontal_files/figure-html/unnamed-chunk-1-1.png" alt="" width="672" />

Cargamos algunos datos regionales para ponerle al mapa, sacados de mi proyecto de [visualización de datos económicos de Chile](https://bastianoleah.shinyapps.io/economia_chile/):

``` r
# obtener datos
datos <- read_csv2("https://github.com/bastianolea/economia_chile/raw/main/app/datos/pib_regional.csv")
# https://github.com/bastianolea/economia_chile

# limpiar datos
datos_2 <- datos |> 
  group_by(serie) |> 
  slice_max(año) |> 
  slice_max(mes) |> 
  select(nombre_region = serie, valor, año, trimestre, mes)

# crear tabla de regiones
regiones <- tribble(~codigo_region, ~nombre_region,
                    "01", "Región de Arica y Parinacota",
                    "02", "Región de Tarapacá",
                    "03", "Región de Antofagasta",
                    "04", "Región de Atacama",
                    "05", "Región de Coquimbo",
                    "06", "Región de Valparaíso",
                    "07", "Región Metropolitana de Santiago",
                    "08", "Región del Libertador General Bernardo OHiggins",
                    "09", "Región del Maule",
                    "10", "Región de Ñuble",
                    "11", "Región del Biobío",
                    "12", "Región de La Araucanía",
                    "13", "Región de Los Ríos",
                    "14", "Región de Los Lagos",
                    "15", "Región de Aysén del General Carlos Ibáñez del Campo",
                    "16", "Región de Magallanes y de la Antártica Chilena")
```

Ahora que tenemos los datos listos, los agregamos al mapa [usando un `left_join()`](/blog/left_join/):


``` r
# agregar regiones y datos al mapa
mapa_datos <- mapa_region |> 
  left_join(regiones, by = join_by(codigo_region)) |> 
  left_join(datos_2, by = join_by(nombre_region))
```

Finalmente, previsualizamos el mapa con los datos agregados:

``` r
# visualizar mapa con datos
mapa_datos |> 
  ggplot() +
  aes(fill = valor) +
  geom_sf(linewidth = 0) +
  coord_sf(xlim = c(-80, -62)) +
  scale_fill_distiller(type = "seq", palette = 12,
                       labels = scales::label_comma(big.mark = ".")) +
  theme_classic() +
  theme(axis.text = element_blank(),
        axis.line = element_blank(),
        axis.ticks = element_blank())
```

<img src="/blog/mapa_chile_horizontal/mapa_chile_horizontal_files/figure-html/unnamed-chunk-4-1.png" alt="" width="672" />

{{< relacionada "blog/mapa_chile_triple/" >}}

Ahora que tenemos un mapa de Chile con datos regionales, procedemos a **rotar el mapa**. Para esto, necesitamos una _matriz de rotación_, respecto de la cual no hay mucho que entender, salvo que nos permitirá multiplicar la geometría del mapa para obtener como resultado la misma geometría, pero rotada. El único detalle que hay que considerar es que es necesario **cambiar la proyección del mapa** para que la zona sur del país no se vea deformada.


``` r
# reprojectar a CRS EPSG:5361 para evitar deformación
mapa_proyectado <- st_transform(mapa_datos, 5361)

# matriz de rotación 90° izquierda
rotacion <- matrix(c(0, -1, 1, 0), 2, 2)

# aplicar rotación al mapa proyectado
mapa_rotado <- mapa_proyectado |> 
  mutate(geometry = geometry * rotacion)
```

Ahora visualizamos el **mapa reproyectado y rotado**:


``` r
mapa_rotado |> 
  ggplot() +
  aes(fill = valor) +
  geom_sf(linewidth = 0) +
  scale_y_continuous(labels = scales::label_number()) +
  coord_sf(ylim = c(800000, -100000)) +
  labs(title = "Mapa de Chile horizontal",
       subtitle = "A mimir") +
  scale_fill_distiller(type = "seq", palette = 12,
                       labels = scales::label_comma(big.mark = ".")) +
  guides(fill = guide_legend(position = "bottom")) +
  theme_classic() +
  theme(axis.text = element_blank(),
        axis.line = element_blank(),
        axis.ticks = element_blank())
```

<img src="/blog/mapa_chile_horizontal/mapa_chile_horizontal_files/figure-html/unnamed-chunk-6-1.png" alt="" width="672" />


Listo! Revisa el [código completo](https://gist.github.com/bastianolea/8e3dff701fb660ee7cb5091bd1195b5f) en el siguiente botón para poder copiarlo y pegarlo en tu proyecto:

{{< boton "Ver código completo" "https://gist.github.com/bastianolea/8e3dff701fb660ee7cb5091bd1195b5f" "fas fa-file-code" >}}

### Fuentes
- [DeepSeek DeepThink (R1)](https://chat.deepseek.com)
- https://gist.github.com/ryanpeek/99c6935ae51429761f5f73cf3b027da2
- https://r-spatial.github.io/sf/articles/sf3.html#affine-transformations
- https://en.wikipedia.org/wiki/Rotation_matrix

{{< etiqueta "mapas" >}}

{{< cafecito >}}

{{< cursos >}}
