---
title: Mapas y visualización de datos geoespaciales en R con `{sf}`
author: Bastián Olea Herrera
date: '2026-04-29'
modified: '2026-10-30'
freeze: true
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
  cache: false
  warning: false
knitr:
  opts_chunk: 
    dev.args:
      bg: transparent
excerpt: "R cuenta con un muy amplio ecosistema para trabajar con datos geoespaciales. Uno de los paquetes más importantes es `{sf}`, que permite manipular datos espaciales a partir del estándar _simple features_ (características simples). En esta guía iré recopilando los comandos básicos para manipular y visualizar datos geoespaciales en R. En la medida que voy aprendiendo más sobre hacer mapas, iré actualizando y complementando."
editor_options: 
  chunk_output_type: console
---

{{< imagen "mapa_rm_featured.png" >}}

R cuenta con un muy amplio [ecosistema](https://github.com/r-spatial/) de paquetes para datos geoespaciales. Uno de los [paquetes más importantes es `{sf}`](https://r-spatial.github.io/sf/), que permite manipular datos espaciales a partir del estándar _simple features_ (características simples), ampliamente utilizado en sistemas de información geográfica (SIG/GIS).

En esta guía iré guardando los comandos que uso frecuentemente para **manipular, transformar y visualizar datos geoespaciales** en R. En la medida que voy aprendiendo más sobre hacer mapitas, iré actualizando y complementando.

Lo inicial es instalar `{sf}`:


``` r
install.packages("sf")
```

Y cargarlo junto a `{dplyr}` para empezar a trabajar con datos geoespaciales.

``` r
library(sf)
library(dplyr)
```


**Nota:** para simplificar, en este tutorial voy a ocultar el código de los gráficos, pero siempre estará disponible bajo flechitas que despliegan el código, como la siguiente:

{{< detalles "**Ver código para los gráficos**" >}}


``` r
library(ggplot2)

theme_set(
  # tema de colores
  theme_grey(paper = "#EAD2FA",
             ink = "#553A74",
             accent = "#9069C0") +
    # tipografía
    theme(text = element_text(family = "Atkinson Hyperlegible")) +
    # fondo transparente para mapas
    theme(plot.background = element_rect(fill = "transparent", color = "transparent")) +
    # borrar líneas feas
    theme(axis.ticks = element_blank())
)
```
{{< /detalles >}}

<br>

{{< indice >}}

----


## Carga de mapas

Una de las fuentes principales de datos geoespaciales son los _shapefiles_. Pero también existen **paquetes de R que contienen información geoespacial**, para mayor conveniencia. Exploraremos ambas opciones a continuación.


### Cargar mapas de cualquier país

Si no tenemos o no queremos descargar _shapes_, podemos **cargar mapas de cualquier país directo en R** gracias a [`{rnaturalearth}`](http://ropensci.github.io/rnaturalearth/). Con este paquete obtenemos directamente mapas de cualquier país del mundo, incluyendo sus estados o regiones internos, sin necesidad de descargas.

Instala `{rnaturalearth}` si no lo tienes:


``` r
install.packages("rnaturalearth")
```

Puedes insertar el nombre de tu país para seguir con este tutorial usando ejemplos de tu territorio.


``` r
library(rnaturalearth)

pais <- ne_states("Argentina")
# pais <- ne_states("Mexico")
# pais <- ne_states("Colombia")

mapa <- pais |> 
  # seleccionar columnas
  select(pais = admin,
         region = name_es,
         geometry)

mapa
```

```
## Simple feature collection with 24 features and 2 fields
## Geometry type: MULTIPOLYGON
## Dimension:     XY
## Bounding box:  xmin: -73.57274 ymin: -55.05202 xmax: -53.66155 ymax: -21.78694
## Geodetic CRS:  WGS 84
## First 10 features:
##           pais     region                       geometry
## 1    Argentina Entre Ríos MULTIPOLYGON (((-58.20011 -...
## 12   Argentina      Salta MULTIPOLYGON (((-68.49647 -...
## 13   Argentina      Jujuy MULTIPOLYGON (((-67.25133 -...
## 741  Argentina    Formosa MULTIPOLYGON (((-62.34136 -...
## 746  Argentina   Misiones MULTIPOLYGON (((-54.66497 -...
## 749  Argentina      Chaco MULTIPOLYGON (((-58.35127 -...
## 750  Argentina Corrientes MULTIPOLYGON (((-58.6042 -2...
## 1318 Argentina  Catamarca MULTIPOLYGON (((-68.33776 -...
## 1320 Argentina   La Rioja MULTIPOLYGON (((-69.65405 -...
## 1321 Argentina   San Juan MULTIPOLYGON (((-69.95766 -...
```


### Cargar _shapes_

Un _shapefile_ es un formato de archivo común para datos geoespaciales, que en realidad consiste en una **carpeta** con archivos relacionados (`.shp`, `.shx`, `.dbf`, entre otros) que juntos representan la geometría y atributos de los objetos geográficos.

Teniendo la carpeta, basta con cargarla con la función `read_sf()`.

{{< detalles "**Ejemplo de descarga y carga de un _shapefile_ de Chile**" >}}

Para aprender, podemos descargar un _shape_ y usarlo para practicar. Si no tienes uno a mano, en el siguiente botón podemos bajar un _shapefile_ de Chile por regiones, que proviene de la [Mapoteca de la Biblioteca del Congreso Nacional](https://www.bcn.cl/siit/mapas_vectoriales).

{{< boton "Division regional: polígonos de las regiones de Chile" "https://www.bcn.cl/obtienearchivo?id=repositorio/10221/10398/2/Regiones.zip" "fas fa-map">}}

También puedes descargarlo directamente desde R con `download.file()` y luego `unzip()`, [como se indica en este post](/blog/mapa_chile_triple/#descargar-mapas).


Una vez descargado, descomprimimos el archivo y obtenemos una **carpeta**. Esta carpeta es nuestro _shapefile_, así que la guardamos dentro de nuestro [proyecto de RStudio](/blog/r_introduccion/proyectos/), idealmente dentro de una carpeta donde guardemos nuestros mapas. 


``` r
# descargar
download.file("https://www.bcn.cl/obtienearchivo?id=repositorio/10221/10398/2/Regiones.zip",
              "Regiones.zip")

# descomprimir
unzip("Regiones.zip", exdir = "shapes/Regiones")
```

En el siguiente ejemplo, guardamos el _shapefile_ en una carpeta `shapes`, y lo cargamos con `read_sf()`.






``` r
mapa <- read_sf("shapes/Regiones") |> 
  janitor::clean_names()

mapa
```


```
## Simple feature collection with 17 features and 7 fields
## Geometry type: GEOMETRY
## Dimension:     XY
## Bounding box:  xmin: -12183900 ymin: -7554306 xmax: -7393644 ymax: -1978920
## Projected CRS: WGS 84 / Pseudo-Mercator
## # A tibble: 17 × 8
##    objectid cir_sena codregion area_km    st_area_sh st_length region           
##  *    <dbl>    <int>     <int>   <dbl>         <dbl>     <dbl> <chr>            
##  1     1084        1        15  16867.  18868687744.   750530. Región de Arica …
##  2     1085        2         1  42285.  48306372203.  1213713. Región de Tarapa…
##  3     1086        3         2 126071. 150845155633   2516112. Región de Antofa…
##  4     1087       15        12 133053. 358131609833  90498304. Región de Magall…
##  5     1088       14        11 106703. 224274263072  41444811. Región de Aysén …
##  6     1089        4         3  75661.  96439063562.  2401741. Región de Atacama
##  7     1090        5         4  40576.  54980818749.  2065933. Región de Coquim…
##  8     1091        6         5  16323.  23014748571.  1679609. Región de Valpar…
##  9     1092        7        13  15392.  22252038246.  1064253. Región Metropoli…
## 10     1093       13        10  48408.  87718341940.  7874158. Región de Los La…
## 11     1094       12        14  18245.  31086613540.  1844423. Región de Los Rí…
## 12     1095       11         9  31838.  52215073344.  1501025. Región de La Ara…
## 13     1096       10         8  24022.  38176117509.  2097147. Región del Bío-B…
## 14     1097       10        16  13104.  20376298459.  1074094. Región de Ñuble  
## 15     1098        9         7  30322.  45969426092.  1388328. Región del Maule 
## 16     1099        8         6  16349.  24090278437.   984853. Región del Liber…
## 17     1100        0         0   3937.   9306245194.   388722. Zona sin demarcar
## # ℹ 1 more variable: geometry <GEOMETRY [m]>
```

{{< /detalles >}}

{{< aviso "Puedes seguir este tutorial independientemente del mapa que hayas cargado (el _shape_ de Chile, con `rnaturalearth`, u otro _shape_ que tú elijas); lo importante es que cargues un objeto `mapa` que tenga columna `geometry` y `region`." >}}

<!--
### Cargar geoJSON


### Cargar KMZ

``` r
unzip("~/Downloads/Mis lugares.kmz", exdir = "~/Downloads/Mis lugares")

sf::read_sf("~/Downloads/Mis lugares/doc.kml")
```

-->

<!--
IDEAS PARA LA SECCIÓN «Carga de mapas» (pendientes de evaluar):

- Cargar otros formatos con `read_sf()`: mostrar que la misma función sirve para GeoJSON (`.geojson`), GeoPackage (`.gpkg`), KML (`.kml`) y Parquet geoespacial. Un solo chunk con varios `read_sf()` y una frase sobre que `{sf}` detecta el formato por la extensión. Para KMZ, explicar que es un KML comprimido (el chunk comentado de arriba).
- Archivos con varias capas: `st_layers("archivo.gpkg")` para ver qué capas tiene un GeoPackage, y luego `read_sf("archivo.gpkg", layer = "comunas")`. Útil porque la cartografía de la BCN y de la SUBDERE a veces viene así.
- Guardar mapas: `st_write()`/`write_sf()` para exportar a `.gpkg` o `.geojson`, y `readr::write_rds()` como alternativa rápida cuando el mapa solo se va a volver a usar en R (es lo que hace el chunk `preprocesar`, pero no se explica). Mencionar que GeoPackage es preferible a shapefile porque es un solo archivo.
- Convertir una tabla común a `sf` y viceversa: `st_as_sf()` (ya aparece en «Poner un punto en un mapa») y `st_drop_geometry()` para volver a un data frame normal, por ejemplo para hacer cálculos o tablas sin arrastrar la geometría. Podría ir como aviso o detalle, enlazando a la sección de puntos.
- Mapas de Chile desde paquetes: `{chilemapas}` (comunas, regiones, provincias simplificadas) y `{territorial}` (/blog/territorial/), para quienes siguen el tutorial con Chile y no quieran descargar shapes. Enlazar a /blog/tutorial_mapa_chile/ y /blog/tutorial_mapa_chile_subdere/.
- Mapas del mundo con `{rnaturalearth}`: `ne_countries()` para países completos (se usa después en «Recortar un mapa» pero sin explicación) y el argumento `scale` (10, 50, 110) para controlar el nivel de detalle; mostrar la diferencia de tamaño/detalle entre escalas, lo que conecta con la sección de diagnóstico de geometrías.
- Qué hace `janitor::clean_names()` en el ejemplo del shape de Chile: una frase sobre que los shapefiles suelen venir con nombres de columnas en mayúsculas o truncados a 10 caracteres (limitación del formato `.dbf`).
-->

<!--
IDEAS PARA EL GLOSARIO (si se decide descomentar):
- **Geometría**: la forma de un objeto geográfico: punto, línea o polígono (y sus versiones múltiples: MULTIPOINT, MULTILINESTRING, MULTIPOLYGON).
- **Vértice**: cada una de las coordenadas que definen la forma de una línea o polígono.
- **CRS (sistema de referencia de coordenadas)**: la convención que indica cómo las coordenadas de un mapa se corresponden con lugares de la Tierra; define si las unidades son grados o metros.
- **Centroide**: punto central de un polígono.
- **Buffer**: zona alrededor de un objeto geográfico, a una distancia determinada.
- **Caja o _bounding box_**: rectángulo definido por las coordenadas mínimas y máximas que envuelve a un conjunto de geometrías.
- **Capa**: cada conjunto de datos geoespaciales que se superpone en un mapa (por ejemplo, un mapa de fondo y una capa de puntos encima).
-->

----

Como vemos, una vez que cargamos los datos geoespaciales obtenemos una **tabla con características especiales**. Arriba de la tabla vemos una descripción de las características del mapa, el tipo de geometrías, la caja o _bounding box_ que enmarca los polígonos, y el sistema de referencia de coordenadas del mapa.

En `{sf}` los datos geoespaciales además contienen una columna `geometry`, que contiene las geometrías (puntos, líneas o polígonos) que definen la forma y ubicación de los elementos geográficos. Vamos a trabajar con esta columna si queremos **modificar la geometría** de los elementos geoespaciales o calcular algo a partir de ellos. **Cada fila de la tabla representa un objeto geográfico** (una región, comuna, país, etc.) y las demás columnas son variables relacionadas al objeto geográfico (población, superficie, nombre, etc.)


<!--
## Glosario

- **Simple features**: estándar para representar datos geoespaciales en forma de tablas con una columna especial de geometría.
- **Shapefile**: formato de archivo común para datos geoespaciales, que en realidad consiste en varios archivos relacionados.
- **Polígono**: forma geométrica que representa áreas en un mapa.

-->

----


## Visualización básica de mapas

Para visualizar un mapa con `{sf}` usamos la geometría `geom_sf()` dentro de un gráfico de `{ggplot2}`. Esta función reconoce automáticamente la columna `geometry` del objeto espacial, y dibuja las formas geográficas correspondientes.


``` r
mapa |> 
  ggplot() +
  geom_sf(fill = "#9069C0", 
          color = "#EBD2FA",
          linewidth = 0.1)
```

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/mapa_basico-1.png" alt="" width="672" />

{{< aviso "Si necesitas aprender lo básico de `{ggplot2}` para visualización de datos, [revisa este completo tutorial](/blog/r_introduccion/tutorial_visualizacion_ggplot/)." >}}

<!--
IDEAS PARA LA SECCIÓN «Visualización básica de mapas» (pendientes de evaluar). Varias de estas cosas ya se usan en los gráficos del post pero nunca se explican, así que podrían ser acápites cortos aquí, cada uno con su mapa:

### Visualizar por capas
Explicar que cada `geom_sf()` es una capa, y que cuando hay más de una capa conviene dejar `ggplot()` vacío y entregar los datos en cada `geom_sf(data = ...)`. El orden de las capas importa: la última queda arriba. Es el patrón que se usa en todo el post (mapa de fondo + puntos), así que basta con hacerlo explícito una vez y enlazar desde las demás secciones.

### Mapa coroplético: colorear regiones según una variable
Es el uso más común de un mapa y el post no lo tiene. Agregar una variable a `mapa` (puede ser inventada con `runif()`, o la superficie con `st_area()`, o un `left_join()` con una tabla de datos por región) y mapearla a `fill` dentro de `aes()`. Mostrar `scale_fill_gradient()`/`scale_fill_viridis_c()` para variables continuas y `scale_fill_manual()` para categóricas. Explicar el `left_join()` entre tabla de datos y mapa como paso clave, ojo con que las claves coincidan (nombres de regiones con tildes, mayúsculas, etc.), enlazando a /blog/tutorial_mapa_chile/ y /blog/colores/. Aquí calza el chunk comentado de «Escala de colores para mapa de calor» (`scale_fill_gradient2()` con `midpoint`).

### Etiquetas de texto sobre un mapa
`geom_sf_text()` y `geom_sf_label()` ubican texto en el centroide de cada polígono automáticamente. Se usa en «Poner varios puntos» y en «Calcular centroide» pero sin explicación. Mostrar cómo etiquetar las regiones con `aes(label = region)`, y qué hacer cuando se superponen: `ggrepel::geom_text_repel(stat = "sf_coordinates")` (chunk comentado de «Texto con repel»), enlazando a /blog/ggrepel/. También `check_overlap = TRUE` como solución rápida.

### Hacer zoom en un mapa
`coord_sf(xlim, ylim)` acerca la vista sin modificar los datos, a diferencia de `st_crop()` que recorta las geometrías. Se usa en «Crear un cuadrado» sin explicar. Explicar la diferencia entre ambas opciones (cuándo conviene cada una) y enlazar a «Recortar un mapa». Mencionar `expand = FALSE` para que no quede margen.

### Limpiar el mapa: temas
`theme_void()` para sacar ejes, grilla y fondo cuando el mapa es la única información. Alternativa: dejar la grilla de coordenadas pero con `theme(panel.grid = ...)`. Mostrar antes y después con el mismo mapa.

### Minimapa o mapa de ubicación
Un mapa pequeño del país completo insertado en la esquina de un mapa regional, para dar contexto. Con `{patchwork}` usando `inset_element()`, o con `annotation_custom()`. Referencia: https://dominicroye.github.io/blog/inserted-map/. Conecta con «Recortar un mapa a partir de otro mapa» (ahí ya se tiene región + fondo) y con «Calcular caja» (dibujar el rectángulo de la caja sobre el minimapa para indicar dónde está el zoom, que es el chunk comentado de `annotate("rect")`).

### Mapas interactivos
Breve aviso al final de la sección: si se necesita un mapa interactivo (zoom, clic, tooltips), el mismo objeto `sf` sirve para `{mapgl}` (/blog/mapas_mapgl/) o `{leaflet}`. No desarrollar, solo enlazar.
-->


----


## Crear geometrías

A continuación veremos código para crear o generar elementos sobre una cartografía o mapa en R, tales como puntos y figuras.

### Poner un punto en un mapa

Si queremos poner puntos en posiciones específicas de un mapa, sólo necesitamos crear una tabla con las coordenadas de los puntos y convertir la tabla a `sf` con `st_as_sf()`. Al hacer esto, es necesario especificar el sistema de referencia de coordenadas (CRS) del mapa, para que los puntos se ubiquen correctamente. Hacemos esto extrayendo el CRS del mapa con `st_crs()` y aplicándolo a nuestra nueva tabla `sf`.


``` r
# definir coordenadas
coordenadas <- tibble(longitud = -70, 
                      latitud = -38)

# convertir tabla a sf
punto <- coordenadas |> 
  st_as_sf(coords = c("longitud", "latitud"), 
           crs = st_crs(mapa))
```


<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-9-1.png" alt="" width="672" />

{{< detalles "Ver código del gráfico">}}

``` r
ggplot() +
  # mapa de fondo
  geom_sf(data = mapa,
          fill = "#9069C0", color = "#EBD2FB",
          linewidth = 0.1) +
  # capa con el punto
  geom_sf(data = punto,
          color = "#402E5A",
          size = 3, alpha = .5)
```
{{< /detalles >}}



#### Poner varios puntos en un mapa

Si necesitamos agregar más de un punto, simplemente hacemos una tabla con todos los que necesitemos. Obviamente también podemos especificar otras columnas que podemos usar para etiquetar los puntos, especificar sus colores, y más.


``` r
coordenadas <- tribble(~nombre, ~lon, ~lat, ~n,
                       "A",  -69,  -38,  4,
                       "B",  -65,  -37,  6,
                       "C",  -61,  -36,  9)

puntos <- coordenadas |> 
  # convertir tabla a sf
  st_as_sf(coords = c("lon", "lat"), 
           crs = st_crs(mapa))
```

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-12-1.png" alt="" width="672" />
{{< detalles "Ver código del gráfico">}}

``` r
ggplot() +
  # mapa de fondo
  geom_sf(data = mapa,
          fill = "#9069C0", color = "#EBD2FB",
          linewidth = 0.1) +
  # capa con puntos
  geom_sf(data = puntos,
          aes(size = n),
          color = "#402E5A",
          alpha = .5) +
  # capa con textos
  geom_sf_label(data = puntos,
                aes(label = nombre),
                size = 3, vjust = -0.8,
                fontface = "bold") +
  # escala de tamaño
  scale_size(range = c(3, 6),
             breaks = scales::breaks_pretty(n = 3)) +
  guides(size = guide_legend(override.aes = list(color = "#9069C0", 
                                                 alpha = 1)))
```
{{< /detalles >}}

----


### Crear un círculo alrededor de un punto

Si queremos marcar en el mapa un **radio alrededor de una ubicación**, por ejemplo, todo lo que queda a 150 kilómetros de una ciudad, basta con crear un punto y agrandarlo con `st_buffer()`. Un punto más un _buffer_ es un círculo, cuyo radio definimos en el argumento `dist`. Si el mapa está en coordenadas geográficas (grados), como los de `{rnaturalearth}`, `{sf}` interpreta la distancia en **metros**, así que 150 kilómetros son `150000`.


``` r
coordenadas <- tibble(longitud = -64.2, latitud = -31.4)

punto <- coordenadas |> 
  # convertir tabla a sf
  st_as_sf(coords = c("longitud", "latitud"), 
           crs = st_crs(mapa))

circulo <- punto |> 
  st_buffer(dist = 150000) # radio en metros
```

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-15-1.png" alt="" width="672" />

{{< detalles "Ver código del gráfico">}}

``` r
ggplot() +
  # mapa de fondo
  geom_sf(data = mapa,
          fill = "#9069C0", color = "#EBD2FB",
          linewidth = 0.1, alpha = .7) +
  # capa con el círculo
  geom_sf(data = circulo,
          fill = NA, color = "#402E5A",
          linewidth = 0.5, alpha = .6) +
  # capa con el punto
  geom_sf(data = punto,
          color = "#402E5A", size = 1)
```
{{< /detalles >}}

El círculo resultante es un polígono `sf` como cualquier otro, así que después podemos usarlo para [recortar el mapa](#recortar-un-mapa), o como paso intermedio para crear otras figuras, como veremos a continuación. Más adelante [veremos el _buffer_ en detalle](#calcular-buffer) aplicado a polígonos completos.


----


### Crear un cuadrado

Para poner un cuadrado encima de una ubicación del mapa, primero creamos un punto, luego lo [expandimos con un _buffer_ para convertirlo en un círculo](#crear-un-círculo-alrededor-de-un-punto), calculamos [la caja que envuelve a dicho punto](#calcular-caja-de-un-polígono), y finalmente convertimos la caja en un polígono `sf`.


``` r
coordenadas <- tibble(longitud = -58, latitud = -38)

punto <- coordenadas |> 
  # convertir tabla a sf
  st_as_sf(coords = c("longitud", "latitud"), 
           crs = st_crs(mapa))

cuadrado <- punto |> 
  st_buffer(dist = 100000) |> # agrandar punto
  st_bbox() |> # crear caja al rededor
  st_as_sfc(crs = st_crs(mapa)) # convertir a sf
```


<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-18-1.png" alt="" width="672" />

{{< detalles "Ver código del gráfico">}}

``` r
ggplot() +
  # mapa de fondo
  geom_sf(data = mapa,
          fill = "#9069C0", color = "#EBD2FB",
          linewidth = 0.1, alpha = .7) +
  # capa con puntos
  geom_sf(data = cuadrado,
          fill = NA,
          linewidth = 0.8, 
          linejoin = "mitre", #linejoin = "round",
          color = "#402E5A") +
  coord_sf(xlim = c(-72, -56),
           ylim = c(-40, -30))
```
{{< /detalles >}}

Paso a paso, el proceso de crear el punto, agrandarlo, y formarlo en un cuadrado se vería así:

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-20-1.png" alt="" width="672" />

{{< detalles "Ver código del proceso y del gráfico">}}

``` r
punto_grande <- punto |> 
  st_buffer(dist = 100000, max_cells = 10000)

cuadrado <- punto_grande |> 
  st_bbox(crs = st_crs(mapa)) |> 
  st_as_sfc() |> 
  st_as_sf(crs = st_crs(mapa))

ggplot() +
  # mapa de fondo
  geom_sf(data = mapa,
          fill = "#9069C0", color = "#EBD2FB",
          linewidth = 0.1) +
  # capas 
  geom_sf(data = punto, 
          color = "#402E5A", size = 3) +
  geom_sf(data = punto_grande,
          fill = NA, color = "#402E5A", lwd = 0.7) +
  geom_sf(data = cuadrado,
          fill = NA, color = "#402E5A", lwd = 0.7) +
  # acercar mapa
  coord_sf(xlim = c(-61, -55),
           ylim = c(-40, -35.7))
```
{{< /detalles >}}


#### Crear un rectángulo a partir de puntos
Si tenemos varios puntos y necesitamos crear un rectángulo que los contenga a todos, podemos repetir lo anterior pero partiendo de varios puntos a la vez.


``` r
# tabla con coordenadas
coordenadas <- tribble(~nombre, ~lon, ~lat, ~n,
                       "A",  -69,  -38,  4,
                       "B",  -65,  -37,  6,
                       "C",  -61,  -36,  9)

# convertir coordenadas a puntos
puntos <- coordenadas |> 
  # convertir tabla a sf
  st_as_sf(coords = c("lon", "lat"), 
           crs = st_crs(mapa))

# convertir puntos a rectándulo
rectangulo <- puntos |> 
  st_buffer(dist = 80000) |> # ampliar
  st_bbox() |> 
  st_as_sfc(crs = st_crs(mapa))
```

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-23-1.png" alt="" width="672" />
{{< detalles "Ver código del gráfico">}}

``` r
ggplot() +
  # mapa de fondo
  geom_sf(data = mapa,
          fill = "#9069C0", color = "#EBD2FB",
          linewidth = 0.2, alpha = .7) +
  # capa con puntos
  geom_sf(data = puntos,
          alpha = .5) +
  geom_sf(data = rectangulo,
          fill = NA, color = "#402E5A", lwd = 0.7)
```
{{< /detalles >}}


----

### Crear un polígono a partir de coordenadas

Teniendo una tabla con un conjunto de coordenadas, podemos unirlas para formar un polígono. Es decir, **unir los puntos** para conformar una figura geométrica cerrada. Para ello, usamos `st_combine()` para combinar las coordenadas en un solo elemento, y luego `st_cast()` para convertir esos puntos combinados en un polígono.


``` r
coordenadas <- tribble(~nombre, ~lon, ~lat,
                       "A", -68,  -36,
                       "B", -64,  -31,
                       "C", -60,  -36)

# convertir tabla a sf
puntos <- coordenadas |> 
  st_as_sf(coords = c("lon", "lat"), 
           crs = st_crs(mapa))

poligono <- puntos |> 
  # combinar coordenadas en un solo elemento
  summarise(geometry = st_combine(geometry)) |> 
  # convertir puntos a polígono
  st_cast("POLYGON")
```

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/poligonos_1-1.png" alt="" width="672" />

{{< detalles "Ver código del gráfico" >}}

``` r
ggplot() +
  # mapa de fondo
  geom_sf(data = mapa,
          fill = "#9069C0", color = "#E0C7F0",
          linewidth = 0.2, alpha = 0.7) +
  # capa con puntos
  geom_sf(data = puntos,
          alpha = .6) +
  # capa con polígono
  geom_sf(data = poligono,
          fill = "#402E5A", color = "#402E5A",
          lwd = 0.7, alpha = 0.7)
```
{{< /detalles >}}


#### Crear varios polígonos a partir de coordenadas

Podemos realizar el mismo proceso anterior, pero agrupando los datos con `group_by()` para crear varios polígonos a la vez, de acuerdo a la variable de agrupación (en este caso, `tipo`). Entonces, cuando usemos `st_combine()`, se combinarán las coordenadas de cada grupo por separado, y luego `st_cast()` convertirá cada grupo de puntos combinados en un polígono distinto.


``` r
coordenadas <- tribble(~tipo,    ~lon, ~lat,
                       "Triángulo", -68,  -30,
                       "Triángulo", -64,  -25,
                       "Triángulo", -60,  -30,
                       "Cuadrado", -68,  -38,
                       "Cuadrado", -60,  -38,
                       "Cuadrado", -60,  -32,
                       "Cuadrado", -68,  -32)

# convertir tabla a sf
puntos <- coordenadas |> 
  st_as_sf(coords = c("lon", "lat"), 
           crs = st_crs(mapa))

poligono <- puntos |> 
  # combinar coordenadas en elementos únicos agrupados por una variable
  group_by(tipo) |> 
  summarise(geometry = st_combine(geometry)) |> 
  # convertir puntos a polígono
  st_cast("POLYGON")
```

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/poligonos_2-1.png" alt="" width="672" />

{{< detalles "Ver código del gráfico" >}}

``` r
ggplot() +
  # mapa de fondo
  geom_sf(data = mapa,
          fill = "#9069C0", color = "#E0C7F0",
          linewidth = 0.2, alpha = 0.7) +
  # capa con polígonos de color
  geom_sf(data = poligono,
          aes(fill = tipo, color = tipo),
          lwd = 0.6, alpha = .5) +
  # capa con puntos
  geom_sf(data = puntos,
          color = "#25054A",
          alpha = .5) +
  # escala de colores
  labs(fill = "Tipo", color = "Tipo") +
  theme(legend.key.spacing.y = unit(1, "mm"))
```
{{< /detalles >}}

<!--
IDEAS PARA LA SECCIÓN «Crear geometrías» (pendientes de evaluar):

### Crear una línea a partir de coordenadas
Mismo patrón que «Crear un polígono a partir de coordenadas» (`st_combine()` + `st_cast()`), pero con `st_cast("LINESTRING")`. Ejemplo: unir con una línea las ciudades A, B y C del ejemplo de puntos, como si fuera una ruta. Y con `group_by()` para varias líneas (una por ruta). Cierra el trío punto → línea → polígono, que ahora está incompleto.

### Crear un cuadrado a partir del centroide de un polígono
Es el chunk comentado «Desde el centroide de un polígono» del final. Variante de «Crear un cuadrado» donde el punto de partida no es una coordenada manual sino `st_centroid()` de una región: `filter(region == ...) |> st_centroid() |> st_buffer() |> st_bbox() |> st_as_sfc()`. Útil para hacer un recorte centrado en una región, enlazando a «Calcular centroide» y a «Recortar un mapa».

### Crear una grilla sobre un mapa
`st_make_grid()` genera una cuadrícula (o hexágonos con `square = FALSE`) que cubre el mapa; luego `st_intersection()` o `st_filter()` para quedarse solo con las celdas que tocan el territorio. Mostrar una grilla gruesa sobre Argentina (`cellsize` grande) para que se entienda, y enlazar a /blog/mapas_hexagonales/ donde está desarrollado en detalle. Depende de que exista la sección de intersección (ver ideas de «Operaciones sobre mapas»).

### Envolvente convexa de un conjunto de puntos
`st_convex_hull()` sobre puntos combinados con `st_union()` da el polígono más pequeño que los contiene a todos, alternativa «ajustada» al rectángulo de «Crear un rectángulo a partir de puntos». Comparar ambos en el mismo gráfico. Es un acápite breve, opcional.
-->

----


## Operaciones sobre geometrías

Las operaciones sobre geometrías permiten manipular y analizar las formas y ubicaciones de los objetos geográficos. A continuación veremos algunas operaciones comunes que se pueden realizar con el paquete `{sf}` en R.

### Calcular centroide

El centroide es el punto central de un polígono. Calcularlo sirve, por ejemplo, para ubicar una etiqueta de texto sobre un polígono, poner un punto sobre un territorio que crece con respecto a una variable, etc.


``` r
mapa_centroide <- mapa |> 
  select(region, geometry) |> 
  mutate(centroide = st_centroid(geometry))
```


```
##                   region                   centroide
## 1             Entre Ríos POINT (-59.20493 -32.03189)
## 12                 Salta POINT (-64.80661 -24.28824)
## 13                 Jujuy POINT (-65.77985 -23.31783)
## 741              Formosa POINT (-59.94839 -24.89604)
## 746             Misiones POINT (-54.65212 -26.86956)
## 749                Chaco POINT (-60.77109 -26.39039)
## 750           Corrientes POINT (-57.79471 -28.76018)
## 1318           Catamarca  POINT (-66.99006 -27.3092)
## 1320            La Rioja POINT (-67.21371 -29.66235)
## 1321            San Juan POINT (-68.88199 -30.82274)
## 1323             Mendoza POINT (-68.60826 -34.58944)
## 1328             Neuquén POINT (-70.11374 -38.62865)
## 1333              Chubut POINT (-68.51499 -43.78523)
## 1335           Río Negro POINT (-67.21765 -40.40738)
## 1337          Santa Cruz  POINT (-69.8981 -48.76187)
## 1339    Tierra del Fuego  POINT (-67.4401 -54.32625)
## 1726        Buenos Aires POINT (-60.54573 -36.66279)
## 1746        Buenos Aires POINT (-58.45093 -34.64272)
## 3852            Santa Fe POINT (-60.93513 -30.66904)
## 3853             Tucumán  POINT (-65.36557 -26.9491)
## 3854 Santiago del Estero  POINT (-63.2909 -27.71835)
## 3855            San Luis POINT (-66.03363 -33.74238)
## 3856            La Pampa POINT (-65.44562 -37.12691)
## 3857             Córdoba POINT (-63.76859 -32.07319)
```

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/mapa_centroide-1.png" alt="" width="672" />

{{< detalles "Ver código del gráfico" >}}

``` r
mapa_centroide |> 
  filter(region == mapa$region[3]) |> 
  ggplot() +
  # mapa
  geom_sf(fill = "#9069C0", 
          linewidth = NA) +
  # capa del punto
  geom_sf(
    aes(geometry = centroide),
    color = "#402E5A",
    size = 3, alpha = 1) +
  # texto bajo el punto
  geom_sf_text(
    aes(geometry = centroide),
    label = "centroide", size = 3,
    vjust = 2)
```
{{< /detalles >}}


----

### Extraer longitud y latitud
Para obtener las coordenadas (longitud y latitud) de un elemento espacial, necesitamos primero que sea un punto, porque un polígono es una figura compleja que no tiene solamente una latitud y una longitud. Si tenemos un polígono, [primero calculamos el centroide](#calcular-centroide), y luego extraemos las coordenadas con `st_coordinates()`. Como esta función retorna la longitud y latitud de cada punto al mismo tiempo, tenemos que pedirle que entregue la una o la otra usando corchetes.


``` r
mapa_centroide_coordenadas <- mapa_centroide |> 
  mutate(lon = st_coordinates(centroide)[,1],
         lat = st_coordinates(centroide)[,2])
```


```
##                   region       lon       lat
## 1             Entre Ríos -59.20493 -32.03189
## 12                 Salta -64.80661 -24.28824
## 13                 Jujuy -65.77985 -23.31783
## 741              Formosa -59.94839 -24.89604
## 746             Misiones -54.65212 -26.86956
## 749                Chaco -60.77109 -26.39039
## 750           Corrientes -57.79471 -28.76018
## 1318           Catamarca -66.99006 -27.30920
## 1320            La Rioja -67.21371 -29.66235
## 1321            San Juan -68.88199 -30.82274
## 1323             Mendoza -68.60826 -34.58944
## 1328             Neuquén -70.11374 -38.62865
## 1333              Chubut -68.51499 -43.78523
## 1335           Río Negro -67.21765 -40.40738
## 1337          Santa Cruz -69.89810 -48.76187
## 1339    Tierra del Fuego -67.44010 -54.32625
## 1726        Buenos Aires -60.54573 -36.66279
## 1746        Buenos Aires -58.45093 -34.64272
## 3852            Santa Fe -60.93513 -30.66904
## 3853             Tucumán -65.36557 -26.94910
## 3854 Santiago del Estero -63.29090 -27.71835
## 3855            San Luis -66.03363 -33.74238
## 3856            La Pampa -65.44562 -37.12691
## 3857             Córdoba -63.76859 -32.07319
```


<img src="/blog/mapas_sf/mapas_sf_files/figure-html/barras_latitud-1.png" alt="" width="672" />

{{< detalles "Ver código del gráfico" >}}

``` r
mapa_centroide_coordenadas |> 
  distinct(region, .keep_all = TRUE) |> 
  mutate(region = forcats::fct_reorder(region, lat)) |> # ordenar regiones
  ggplot() +
  aes(lat, region) +
  geom_col(width = 0.7, 
           fill = "#9069C0") +
  geom_text(aes(label = region),
            size = 3, hjust = -0.05, color = "#EAD2FA") +
  scale_y_discrete(labels = NULL) +
  labs(y = NULL, x = "Latitud")
```
{{< /detalles >}}


----


### Calcular buffer
Un _buffer_ es una zona alrededor de un objeto geográfico, definida por una distancia específica. Calcular un _buffer_ es útil para analizar áreas de influencia, proximidad a ciertos puntos o regiones, o para hacer modificiones sobre mapas con fines de visualización.

Con la función `st_buffer()` definimos el espacio en torno a un polígono, especificando en el argumento `dist` la **distancia** del _buffer_ en las unidades del sistema de coordenadas del mapa (por ejemplo, metros si el mapa está en UTM), y con `max_cells` podemos controlar la calidad del polígono resultante.


``` r
mapa_buffer <- mapa |> 
  # filtrar una región/polígono
  filter(region == mapa$region[3]) |> 
  # crear buffer
  mutate(buffer = st_buffer(geometry, 
                            dist = 20000,
                            max_cells = 10000))
```

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/mapa_buffer-1.png" alt="" width="672" />

{{< detalles "Ver código del gráfico" >}}

``` r
mapa_buffer |> 
  ggplot() +
  # capa de la región
  geom_sf(aes(geometry = geometry), 
          fill = "#9069C0", linewidth = NA) +
  # capa del buffer
  geom_sf(aes(geometry = buffer), 
          fill = "#9069C0", alpha = 0.5, linewidth = NA)
```
{{< /detalles >}}

----

### Calcular caja de un polígono

Con la función `st_bbox()` obtenemos las coordenadas de la caja que envuelve a un polígono o conjunto de polígonos. Esta caja está definida por las coordenadas mínimas y máximas en los ejes _x_ (longitud) e _y_ (latitud).


``` r
caja <- st_bbox(mapa)

caja
```

```
##      xmin      ymin      xmax      ymax 
## -73.57274 -55.05202 -53.66155 -21.78694
```



#### Convertir caja a polígono

Teniendo una caja con sus coordenadas, podemos convertirla a un polígono para aplicarlo sobre (o debajo de) un mapa.


``` r
rectangulo <- caja |> 
  st_as_sfc(crs = st_crs(mapa))
```

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-39-1.png" alt="" width="672" />

{{< detalles "Ver código del gráfico" >}}

``` r
ggplot() +
  # mapa de fondo
  geom_sf(data = mapa,
          fill = "#9069C0", color = "#EBD2FB",
          linewidth = 0.1) +
  # capa con la caja encima
  geom_sf(data = rectangulo,
          fill = "#9069C0", color = "#9069C0", 
          linewidth = 0.8, alpha = 0.4) +
  # tema
  theme(axis.text = element_blank(),
        panel.background = element_blank())
```
{{< /detalles >}}


----

### Mover puntos 
Cuando ya contamos con tabla con datos geoespaciales en puntos, a veces es necesario mover la posición de los puntos en un mapa, por ejemplo, para evitar que se sobrepongan etiquetas, para ajustar una coordenada incorrecta, o para mejorar la visualización. 

Los puntos pueden moverse al **modificar las coordenadas de la geometría**. En el caso de los puntos se las coordenadas son un vector de dos elementos (longitud y latitud), por lo que podemos sumar o restarle a la columna `geometry` para modificar la posición de cada punto.

Creemos una tabla con latitudes y longitudes, y convirtámosla a `sf` con `st_as_sf()`, [como vimos antes](#poner-un-punto-en-un-mapa):


``` r
puntos <- tribble(~nombre, ~lon,     ~lat,
                  "Hualqui", -8113368, -4434476,
                  "Coronel", -8136065, -4440419,
                  "Concepción", -8132714, -4414370,
                  "Lota", -8139383, -4451456,
                  "Penco", -8119934, -4402016,
                  "Talcahuano", -8139277, -4399701) |> 
  # convertir a tabla sf
  st_as_sf(coords = c("lon", "lat"), 
           crs = 3395)
```

Así se ven los puntitos por sí solos: 

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-42-1.png" alt="" width="672" />

Como estos puntos están en Chile, necesitamos un mapa de Chile de fondo. Lo obtenemos desde `{rnaturalearth}` con `ne_countries()`, que entrega el polígono completo de un país (a diferencia de `ne_states()`, que [usamos al inicio](#cargar-mapas-de-cualquier-país) para obtener sus regiones):


``` r
library(rnaturalearth)

chile <- ne_countries(country = "Chile", scale = 10) |> 
  select(pais = admin,
         geometry)
```

Ahora recortemos el mapa de Chile para enfocarnos en la zona donde están los puntos. [Creamos un _buffer_](#calcular-buffer) alrededor de los puntos para agrandarlos con `st_buffer()`, y luego [calculamos la caja que los contiene](#calcular-caja-de-un-polígono) con `st_bbox()` para usarla como recorte.


``` r
caja_puntos <- puntos|> 
  st_buffer(50000) |> # agrandar puntos
  st_bbox() # calcular caja que contiene a los puntos
```

Ahora que tenemos la caja, la usamos dentro de `st_crop()` para recortar el mapa, pero ojo, que ambas capas tienen que tener el mismo sistema de referencias de coordenadas (CRS), así que primero transformamos el mapa de Chile con `st_transform()` para que use el mismo sistema que la capa de puntos.


``` r
chile_recorte <- chile |> 
  # ajustar crs para que coincidan
  st_transform(crs = st_crs(puntos)) |>
  # recortar con la caja (bounding box)
  st_crop(caja_puntos)
```

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-46-1.png" alt="" width="672" />

{{< detalles "Ver código del gráfico" >}}

``` r
ggplot() +
  geom_sf(data = chile_recorte,
          fill = "#9069C0", color = "#E0C7F0", alpha = 0.5) +
  geom_sf(data = puntos,
          color = "#402E5A", size = 3, alpha = 0.7) +
  geom_sf_text(data = puntos, 
               aes(label = paste("  ", nombre)),
               color = "#402E5A", size = 3, hjust = 0, angle = -35)
```
{{< /detalles >}}

Imaginemos que queremos mover o modificar puntos específicos del mapa. Igual como haríamos con una tabla de datos, usamos `mutate()` para modificar la columna `geometry`, que contiene las coordenadas de cada punto, y le aplicamos una función para modificar sus valores condicionalmente, como `case_when()`. Así podemos modificar los puntos dependiendo de si coinciden con criterios basados en datos, en vez de hacerlo a mano.

Para este ejemplo, modificaremos puntos a partir de su valor en la variable `nombre`. Simplemente sumamos a las coordenadas de los puntos que queremos mover, recordando que como es un vector de dos elementos, sumamos un vector de dos elementos. Para moverlos horizontalmente (hacia el este), sumamos a la primera posición del vector (longitud, `c(7000, 0)`) y dejamos la segunda posición (latitud) en cero.

El problema es que, al hacer esto, convertimos las coordenadas en meros números, por lo que pierden atributos geométricos, lo que causa problemas. Para resolverlo, le sacamos también los atributos geométricos a los demás puntos que no se mueven (con `st_set_crs(NA)`), y después luego le reasignamos el sistema de coordenadas (CRS) original a toda la tabla con `st_set_crs()`.


``` r
puntos_movidos <- puntos |> 
  # modificar puntos condicionalmente
  mutate(geometry = case_when(nombre == "Hualqui" ~ geometry + c(7000, 0),
                              nombre ==  "Penco" ~ geometry + c(7000, 0),
                              .default = st_sfc(geometry) |> st_set_crs(NA))
  ) |> 
  st_set_crs(st_crs(puntos))
```

{{< detalles "Otra alternativa sería..." >}}

Otra alternativa al problema de perder las coordenadas al modificar los puntos es hacer lo contrario: volver a agregar las coordenadas a cada observación que se modifique agregándoles `st_set_crs(st_crs(mapa))`, y dejando las demás observaciones sin cambios.


``` r
puntos |> 
  mutate(geometry = case_when(
    nombre == "Hualqui" ~ st_sfc(geometry + c(7000, 0)) |> st_set_crs(st_crs(puntos)),
    nombre == "Tomé" ~ st_sfc(geometry + c(7000, 0)) |> st_set_crs(st_crs(puntos)),
    .default = geometry)
  )
```

Personalmente encuentro que la primera forma es más legible.

{{< /detalles>}}

Lo que sumemos o restemos a las coordenadas depende del sistema de coordenadas de cada mapa. En algunos va a haber que sumar números muy pequeños, pero en otros sistemas de coordenadas se usan números muy grandes.

En el gráfico vemos en color más tenue las posiciones originales de los puntos que fueron modificados.

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-50-1.png" alt="" width="672" />

{{< detalles "Ver código del gráfico" >}}


``` r
ggplot() +
  geom_sf(data = chile_recorte,
          fill = "#9069C0", color = "#E0C7F0", alpha = 0.5) +
  geom_sf(data = puntos,
          color = "#402E5A", size = 3, alpha = 0.2) +
  geom_sf(data = puntos_movidos,
          color = "#402E5A", size = 3, alpha = 0.7) +
  geom_sf_text(data = puntos_movidos, 
               aes(label = paste("  ", nombre)),
               color = "#402E5A", size = 3, hjust = 0, angle = -35)
```

{{< /detalles >}}

----


### Mover puntos aleatoriamente

Un problema común al visualizar puntos en un mapa es que, cuando muchos puntos tienen coordenadas iguales o muy parecidas, quedan **uno encima del otro**, y en el mapa parece que hubiera un solo punto. 

Una forma de resolverlo es mover cada punto un poquito al azar, para que se separen y se puedan ver todos. A esto se le llama _jitter_, y en `{sf}` lo hacemos con la función `st_jitter()`.

Creemos una tabla con cinco puntos, todos con coordenadas muy cercanas entre sí, y la convertimos a `sf` con `st_as_sf()`, [como vimos antes](#poner-un-punto-en-un-mapa):


``` r
puntos <- tribble(~id, ~lon,     ~lat,
                    1, -71.6200, -33.5900,
                    2, -71.6215, -33.5908,
                    3, -71.6188, -33.5891,
                    4, -71.6209, -33.5884,
                    5, -71.6193, -33.5916) |> 
  # convertir a tabla sf
  st_as_sf(coords = c("lon", "lat"), 
           crs = 4326)
```

Igual que en el ejemplo anterior, recortamos el mapa para enfocarnos en la zona de los puntos: [creamos un _buffer_](#calcular-buffer) de 6 kilómetros alrededor de los puntos, calculamos [la caja que lo contiene](#calcular-caja-de-un-polígono), y [recortamos el mapa](#recortar-un-mapa) de regiones con esa caja.


``` r
caja <- puntos |> 
  st_buffer(6000) |> # agrandar puntos
  st_bbox() # calcular caja que contiene a los puntos

chile_recorte <- chile |> 
  st_crop(caja)
```

Al visualizar los puntos sobre el mapa, vemos que los cinco puntos quedan amontonados uno encima del otro, y cuesta distinguir cuántos son:

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-54-1.png" alt="" width="672" />

{{< detalles "Ver código del gráfico" >}}

``` r
ggplot() +
  geom_sf(data = chile_recorte,
          fill = "#9069C0", color = "#E0C7F0", alpha = 0.5) +
  geom_sf(data = puntos,
          color = "#402E5A", size = 3, alpha = 0.6)
```
{{< /detalles >}}

Para separarlos, aplicamos `st_jitter()` a la tabla de puntos. El argumento `amount` define la distancia máxima que se puede mover cada punto: a cada coordenada se le suma un número aleatorio entre `-amount` y `amount`, por separado para la longitud y la latitud, así que cada punto se mueve en una dirección distinta.

Como el movimiento es aleatorio, usamos `set.seed()` antes de aplicarlo, para que el resultado sea siempre el mismo cada vez que ejecutemos el código.




``` r
puntos_dispersos <- puntos |> 
  st_jitter(amount = 0.01)
```

Al igual que cuando [movimos puntos manualmente](#mover-puntos-de-un-mapa), la cantidad que usemos en `amount` depende del sistema de coordenadas del mapa. En este caso las coordenadas están en grados (CRS 4326), así que `0.01` equivale aproximadamente a un kilómetro.

En el gráfico vemos en color más tenue las posiciones originales de los puntos, y en color más oscuro las nuevas posiciones aleatorias:

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-58-1.png" alt="" width="672" />

{{< detalles "Ver código del gráfico" >}}


``` r
ggplot() +
  geom_sf(data = chile_recorte,
          fill = "#9069C0", color = "#E0C7F0", alpha = 0.5) +
  geom_sf(data = puntos,
          color = "#402E5A", size = 4, alpha = 0.2) +
  geom_sf(data = puntos_dispersos,
          color = "#402E5A", size = 3, alpha = 0.8)
```

{{< /detalles >}}


----


### Unir polígonos

Para unir varios polígonos en uno sólo usamos `st_union()`. En este caso, pasaremos de 24 regiones de Argentina a 1 solo polígono cuya área es la combinación de los demás.


``` r
mapa_unido <- mapa |>
  summarize(
    geometry = st_union(geometry)
  )

mapa_unido
```

```
## Simple feature collection with 1 feature and 0 fields
## Geometry type: MULTIPOLYGON
## Dimension:     XY
## Bounding box:  xmin: -73.57274 ymin: -55.05202 xmax: -53.66155 ymax: -21.78694
## Geodetic CRS:  WGS 84
##                         geometry
## 1 MULTIPOLYGON (((-61.90941 -...
```

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-61-1.png" alt="" width="672" />

{{< detalles "Ver código del gráfico" >}}


``` r
ggplot() +
  # mapa unido
  geom_sf(data = mapa_unido,
          fill = "#9069C0", color = "#EBD2FB",
          linewidth = 0.1)
```

{{< /detalles >}}

<!--
IDEAS PARA LA SECCIÓN «Operaciones sobre geometrías» (pendientes de evaluar):

### Unir polígonos por grupos
Continuación natural de «Unir polígonos»: con `group_by()` antes de `summarize(geometry = st_union(geometry))` se obtiene un polígono por grupo. Ejemplo: crear una variable `zona` (norte/centro/sur según la latitud del centroide, que ya se calculó en «Extraer longitud y latitud») y unir las regiones de cada zona. Es exactamente lo que se hace en /blog/mapa_chile_macrozonas/, así que enlazar. Es el chunk comentado de «Operaciones agrupadas».

### Calcular superficie o área
`st_area()` devuelve el área de cada polígono con unidades (`units`), y con `units::set_units(km^2)` se convierte a kilómetros cuadrados. Mostrar la tabla de regiones ordenada por superficie y un gráfico de barras (como el de latitud). Advertir que el resultado depende del CRS: en coordenadas geográficas (grados) `{sf}` calcula sobre el elipsoide, lo que está bien, pero en un CRS proyectado el área puede estar distorsionada. Es el chunk comentado «Calcular superficie o área».

### Calcular distancias
`st_distance()` entre puntos (o entre centroides de regiones) devuelve una matriz de distancias con unidades. Ejemplo: distancia entre los centroides de dos regiones, o de cada región a la capital. También `st_length()` para la longitud de líneas (si se agrega la sección de crear líneas). Se podría usar para una tabla de «regiones más cercanas entre sí».

### Simplificar geometrías
Acápite corto que presente `st_simplify(dTolerance = ...)` y `rmapshaper::ms_simplify(keep = ...)` con un antes/después en una sola región, explicando que sirve para que los mapas pesen menos y se dibujen más rápido. Está desarrollado en /blog/simplificar_mapas/, así que aquí bastan dos párrafos y el enlace. Conecta con «Diagnóstico de geometrías» (el conteo de vértices es lo que justifica simplificar). Es el chunk comentado «Simplificar un polígono».

### Extraer líneas internas
`rmapshaper::ms_innerlines()` deja solo los límites entre polígonos (sin el borde exterior). Sirve para dibujar las fronteras internas de un país con un estilo distinto al contorno, o para superponer límites regionales sobre un mapa comunal. Mostrar el resultado sobre el mapa unido de la sección anterior. Es el chunk comentado «Extraer líneas internas de un polígono».

### Separar multipolígonos en polígonos
`st_cast("POLYGON")` sobre un MULTIPOLYGON separa las partes de una región que tiene islas o fragmentos (por ejemplo, Tierra del Fuego o cualquier región con costa fragmentada) en filas distintas. Útil para quedarse solo con la parte continental filtrando por área (`st_area()`), lo que es una alternativa a recortar con coordenadas. Enlazar a /blog/mapa_chile_triple/.

### Corregir geometrías inválidas
`st_is_valid()` para detectar y `st_make_valid()` para arreglar polígonos con errores (bordes que se cruzan, anillos mal cerrados), que aparecen seguido en shapes descargados y producen errores al hacer `st_union()`, `st_intersection()` o `st_buffer()`. Explicar el mensaje de error típico y que la solución es correr `st_make_valid()` justo después de cargar el mapa. Es el chunk comentado de «Correcciones».

### Sacar la geometría
`st_drop_geometry()` convierte el objeto `sf` en un data frame común. Se usa varias veces en el post (para mostrar tablas de centroides y coordenadas) pero no se explica. Explicar cuándo sirve: para hacer tablas, para unir con otras tablas sin arrastrar geometría, o porque algunas operaciones de `{dplyr}` son más lentas con la columna `geometry`.
-->

----


## Operaciones sobre mapas

Los siguientes temas aplican a objetos espaciales completos, como mapas qeu incluyan polígonos, puntos, líneas o más.

### Recortar un mapa

Para enfocar un mapa en una zona específica y eliminar el resto de los polígonos, usamos la función `st_crop()`, definiendo los límites del recorte con las coordenadas mínimas y máximas en los ejes _x_ (longitud) e _y_ (latitud).

Primero obtengamos un mapa de Chile desde `{rnaturalearth}`:


``` r
library(rnaturalearth)

chile <- ne_countries(country = "Chile", scale = 10) |> 
  select(pais = admin,
         region = name_es,
         geometry)
```

Ahora lo recortamos con `st_crop()`. Recomiendo hacerlo terminando el recorte con una visualización del mapa, para ver inmediatamente el resultado y así poder ir ajustando el recorte:


``` r
chile_recortado <- chile |> 
  st_crop(xmin = -78, ymax = -17,
          xmax = -65, ymin = -56) 
```

```
## Warning: attribute variables are assumed to be spatially constant throughout
## all geometries
```

En este caso, hacemos un recorte para obtener el territorio continental de Chile (excluyendo las islas Juan Fernández, Isla de Pascua y Antártica)

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-65-1.png" alt="" width="672" />

{{< detalles "Ver código del gráfico" >}}


``` r
mapa_completo <- chile |> 
  ggplot() +
  geom_sf(fill = "#9069C0", linewidth = 0)

mapa_recortado <- chile_recortado |> 
  ggplot() +
  geom_sf(fill = "#9069C0", linewidth = 0)

# poner los dos mapas lado a lado
library(patchwork)

mapa_completo + mapa_recortado
```

{{< /detalles >}}

También podemos hacer recortes que pasen por encima de los polígonos, eliminando la geografía que quede fuera del recorte. En este caso hacemos un recorte más cercano a la zona costera de Temuco y Valdivia:

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-67-1.png" alt="" width="672" />


#### Recortar un mapa a partir de otro mapa

También podemos filtrar mapas con `st_crop()` usando la caja que encierra a otro mapa. De este modo, si tenemos un mapa que es un subconjunto de otro mapa mayor (por ejemplo, una región contextualizada en un país), podemos usar la región para recortar el mapa del país y así incluir este último como capa de fondo.

Esto sirve, por ejemplo, cuando tenemos una región geográfica que queramos mostrar, pero queremos darle contexto geográfico incluyendo el territorio al rededor del mapa filtrado.

Empecemos obteniendo el mapa de un país, y luego filtrando alguna de sus regiones para usarlo como mapa de fondo:


``` r
library(rnaturalearth)

# obtener mapa por regiones
chile <- ne_states(country = "Chile") |> 
  select(pais = admin,
         region = name_es,
         geometry)

# filtrar algunas regiones
regiones <- chile |> 
  filter(region %in% c("O'Higgins", "Maule", "Ñuble", "Biobío", "La Araucanía", "Los Ríos"))
```

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-69-1.png" alt="" width="672" />


{{< detalles "Ver código del gráfico" >}}

``` r
# visualizar regiones
regiones |> 
  ggplot() +
  geom_sf(fill = "#9069C0", 
          color = "#DFC6EF",
          linewidth = 0.2, alpha = 0.8)
```
{{< /detalles >}}

Ahora filtremos la región principal que queremos mapear:


``` r
# filtrar región principal
region <- regiones |> 
  filter(region == "Ñuble")
```

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-72-1.png" alt="" width="672" />


{{< detalles "Ver código del gráfico" >}}

``` r
# visualizar regiones
regiones |> 
  ggplot() +
  geom_sf(fill = "#9069C0", 
          color = "#DFC6EF",
          linewidth = 0.2, alpha = 0.8)
```
{{< /detalles >}}

Podemos usar la caja del mapa principal (calculada con `st_bbox()`) para recortar el mapa de fondo:


``` r
# recortar ampa de fondo con caja de mapa principal
fondo_region <- regiones |> 
  st_crop(st_bbox(region)) # recortar en base a caja
```

```
## Warning: attribute variables are assumed to be spatially constant throughout
## all geometries
```

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-75-1.png" alt="" width="672" />

{{< detalles "Ver código del gráfico" >}}

``` r
# previsualizar mapa de fondo
fondo_region |> 
  ggplot() +
  geom_sf(fill = "#9069C0", 
          color = "#DFC6EF",
          linewidth = 0.2, alpha = 0.8)
```
{{< /detalles >}}

Obtenemos el mapa del país recortado a la caja del mapa regional. Luego podemos combinar ambos para una visualización de un mapa regional que tenga contexto de sus alrededores:

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-77-1.png" alt="" width="672" />

{{< detalles "Ver código del gráfico" >}}

``` r
ggplot() +
  # capa de fondo
  geom_sf(data = fondo_region, 
          fill = "#9069C0", color = "#DFC6EF", 
          alpha = 0.4) +
  # capa principal
  geom_sf(data = region, 
          fill = "#9069C0", color = "#DFC6EF", 
          linewidth = 0.2, alpha = 0.6)
```
{{< /detalles >}}

También podemos ampliar el recorte que hacemos del mapa de fondo **ampliando** la caja al [aplicarle un _buffer_](/blog/mapas_sf/#calcular-buffer) a la región con `st_buffer()`:


``` r
# con buffer sobre el mapa para ampliar recorte
fondo_region <- regiones |> 
  st_crop(region |> 
            st_buffer(60000) |> # ampliar mapa 
            st_bbox()) # calcular caja
```

```
## Warning: attribute variables are assumed to be spatially constant throughout
## all geometries
```

<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-80-1.png" alt="" width="672" />

{{< detalles "Ver código del gráfico" >}}

``` r
# previsualizar fondo
fondo_region |> 
  ggplot() +
  geom_sf(fill = "#9069C0", 
          color = "#DFC6EF",
          linewidth = 0.2, alpha = 0.8)
```
{{< /detalles >}}

Ahora combinamos ambas capas, mapa de fondo recortado, y mapa principal:
<img src="/blog/mapas_sf/mapas_sf_files/figure-html/unnamed-chunk-82-1.png" alt="" width="672" />


{{< detalles "Ver código del gráfico" >}}

``` r
# combinar fondo con mapa principal
ggplot() +
  # capa de fondo
  geom_sf(data = fondo_region, 
          fill = "#9069C0", color = "#DFC6EF", 
          alpha = 0.4) +
  # capa principal
  geom_sf(data = region, 
          fill = "#9069C0", color = "#DFC6EF", 
          linewidth = 0.2, alpha = 0.8)
```
{{< /detalles >}}

<!--
IDEAS PARA LA SECCIÓN «Operaciones sobre mapas» (pendientes de evaluar). Casi todas son operaciones entre dos capas, que es lo que más falta en el post:

### Sistemas de referencia de coordenadas (CRS)
Probablemente el acápite más necesario: el CRS aparece en todo el post (`st_crs()`, `st_transform()`, `crs = 4326`, `crs = 3395`, «las unidades dependen del sistema de coordenadas») pero nunca se explica. Propuesta: qué es un CRS en una frase, la diferencia entre coordenadas geográficas (grados, 4326, el que usan GPS y Google Maps) y proyectadas (metros, como UTM o 3395); `st_crs(mapa)` para consultar y `st_transform(mapa, crs = ...)` para convertir. Mostrar el mismo mapa de Argentina en dos proyecciones distintas lado a lado con `{patchwork}`, y una tabla chica con los códigos EPSG útiles (4326, 3857, UTM 19S = 32719, 5360 para Chile). Rematar con la regla práctica: antes de combinar dos capas, llevarlas al mismo CRS, y para buffers y distancias en metros usar un CRS proyectado. Son los chunks comentados de «Coordenadas».

### Intersección: recortar un mapa con otro polígono
`st_intersection(mapa, poligono)` se queda solo con la parte de `mapa` que cae dentro de `poligono`, respetando la forma de este (a diferencia de `st_crop()`, que siempre recorta con un rectángulo). Ejemplo: intersectar el mapa de regiones con el círculo del buffer, o con el triángulo de «Crear un polígono a partir de coordenadas». Advertir que puede dar el warning `attribute variables are assumed to be spatially constant`. Es el chunk comentado «Recortar un polígono con otro».

### Diferencia: usar un polígono para borrar parte de otro
`st_difference(mapa, poligono)` es la operación inversa: elimina de `mapa` lo que cae dentro de `poligono`. Mismo ejemplo que la intersección, mostrando ambas en el mismo gráfico para que se vea que son complementarias. Es el chunk comentado «Usar un polígono para eliminar partes de otro».

### Filtrar un mapa según otro (filtro espacial)
`st_filter(mapa, poligono)` devuelve las regiones completas que tocan al polígono, sin recortarlas. Útil para «todas las regiones que quedan a menos de 100 km de este punto» (punto + buffer + `st_filter()`). Explicar el argumento `.predicate` (`st_intersects` por defecto, `st_within`, `st_touches`) con una línea cada uno. También la versión con `st_intersects()` directo y `lengths() > 0`, que es lo que aparece en muchos tutoriales antiguos. Es el chunk comentado «Filter».

### Unión espacial (spatial join)
`st_join(puntos, mapa)` agrega a cada punto las columnas del polígono donde cae: es la forma de saber «en qué región está cada punto». Ejemplo: los puntos A, B, C del inicio, obteniendo la columna `region` de cada uno; luego `count(region)` para contar puntos por región. Es una de las operaciones más útiles en análisis social (asignar comuna a direcciones georreferenciadas), así que vale la pena desarrollarla con calma. Mencionar `left = FALSE` para descartar puntos que no caen en ningún polígono. Es el chunk comentado «Spatial join».

### Contar puntos dentro de polígonos
Continuación del spatial join, o directamente con `lengths(st_intersects(mapa, puntos))` para agregar una columna `n` al mapa con la cantidad de puntos que caen en cada región, y luego visualizarla como coroplético. Conecta con /blog/mapas_hexagonales/ (donde se cuentan puntos por hexágono).

### Rotar o reacomodar un mapa
Mencionar brevemente, enlazando: rotar Chile para dejarlo horizontal (/blog/mapa_chile_horizontal/) y separarlo en tres secciones (/blog/mapa_chile_triple/) son transformaciones afines sobre la geometría (`geometry * matriz` o `geometry + c(x, y)`), el mismo principio de «Mover puntos» aplicado a polígonos completos.
-->


----

## Diagnóstico de geometrías

Cuando trabajamos con mapas que contienen **muchos polígonos o geometrías muy detalladas**, es útil diagnosticar la complejidad antes de visualizarlos. Esto ayuda a anticipar problemas de rendimiento: un mapa con millones de vértices puede tardar mucho en renderizarse, consumir grandes cantidades de memoria, o incluso hacer colapsar la sesión de R.

### Información general

Para tener una idea rápida del tamaño y características del objeto `sf`, podemos revisar el número de geometrías, el espacio en memoria y el sistema de coordenadas:


``` r
# número de geometrías (filas)
nrow(mapa)

# tamaño en memoria
format(object.size(mapa), units = "MB")

# sistema de coordenadas
st_crs(mapa)$input
```

### Conteo de vértices

El número de vértices es el indicador más relevante para el rendimiento: cada vértice es un punto que define la forma de un polígono, y los visualizadores tienen que procesar todos ellos. Para contarlos usamos `st_coordinates()`, que devuelve las coordenadas individuales de cada geometría:


``` r
# contar vértices por polígono
vertices <- sapply(st_geometry(mapa), \(g) {
  tryCatch(nrow(st_coordinates(g)), error = \(e) NA)
})

# resumen
cat("Total de vértices:  ", format(sum(vertices, na.rm = TRUE), big.mark = "."), "\n")
cat("Mediana por polígono:", median(vertices, na.rm = TRUE), "\n")
cat("Máximo por polígono: ", max(vertices, na.rm = TRUE), "\n")
```

Un mapa con decenas de millones de vértices en total, o con algún polígono que tenga cientos de miles de vértices, es candidato a [simplificación](/blog/simplificar_mapas/) antes de visualizarlo de forma interactiva.

<!--
IDEAS PARA LA SECCIÓN «Diagnóstico de geometrías» (pendientes de evaluar):

- Ejecutar los chunks: ahora están con `eval: false`. Con el mapa de Argentina de `{rnaturalearth}` se podrían ejecutar y mostrar resultados reales, y comparar con el mismo país en `scale = 10` vs `scale = 110` para que se vea la diferencia de vértices.
- Tipos de geometría: `st_geometry_type(mapa)` para ver si cada fila es POLYGON o MULTIPOLYGON, y `table()` sobre eso. Sirve para entender por qué una región «es más de un polígono» (islas) y conecta con la idea de separar multipolígonos.
- Verificar validez: `st_is_valid(mapa)` y `sum(!st_is_valid(mapa))` como paso del diagnóstico, antes de la sección de `st_make_valid()` (ver ideas de «Operaciones sobre geometrías»).
- Revisar si el CRS está definido: `is.na(st_crs(mapa))` es un problema frecuente con shapes antiguos o CSV con coordenadas, y la solución es `st_set_crs()` (distinto de `st_transform()`: uno declara, el otro convierte). Conecta con la sección de CRS propuesta.
- Comparar mapas: `st_bbox()` y `st_crs()` de dos capas lado a lado para diagnosticar por qué no se superponen (CRS distintos, coordenadas invertidas lon/lat). Es el error más común de principiantes y una checklist corta ayudaría.
- Vértices por polígono con `{dplyr}`: versión con `mutate(vertices = mapview::npts(geometry, by_feature = TRUE))` o `lengths(st_coordinates())` por fila, que es más legible que el `sapply()` actual y permite ordenar las regiones por complejidad.
-->



<!--
======================================================================
IDEAS ORIGINALES (bloque antiguo). Estado revisado el 30/10/2026:

- Desde el centroide de un polígono → PARCIAL: «Crear un cuadrado» hace lo mismo desde un punto manual. Movido como idea a «Crear geometrías».
- Calcular superficie o área → PENDIENTE. Movido como idea a «Operaciones sobre geometrías».
- Recortar polígono a coordenadas → IMPLEMENTADA en «Recortar un mapa».
- Simplificar un polígono → PENDIENTE aquí, pero desarrollado en /blog/simplificar_mapas/ (enlazado). Idea de acápite breve en «Operaciones sobre geometrías».
- Extraer líneas internas → PENDIENTE. Movido a «Operaciones sobre geometrías».
- Correcciones (st_as_sf, st_make_valid, st_drop_geometry) → `st_as_sf()` se usa en «Poner un punto»; `st_drop_geometry()` se usa sin explicar; `st_make_valid()` PENDIENTE. Movidos a «Operaciones sobre geometrías».
- Operaciones agrupadas (group_by + st_union) → PARCIAL: «Unir polígonos» lo hace sin grupos. Movido a «Operaciones sobre geometrías».
- st_intersection, st_difference, st_union entre dos → PENDIENTES. Movidos a «Operaciones sobre mapas».
- Spatial join, Filter → PENDIENTES. Movidos a «Operaciones sobre mapas».
- Coordenadas (st_crs, st_transform) → PARCIAL: se usan en «Mover puntos» sin sección propia. Movido a «Operaciones sobre mapas» como acápite de CRS.
- Visualizar por capas → usado en todo el post, sin explicar. Movido a «Visualización básica».
- Texto (geom_sf_text) → usado sin explicar. Movido a «Visualización básica».
- Texto con repel → PENDIENTE. Movido a «Visualización básica» (enlazar /blog/ggrepel/).
- Hacer zoom (coord_sf) → usado en «Crear un cuadrado» sin explicar. Movido a «Visualización básica».
- Dibujar un cuadrado (annotate rect) → IMPLEMENTADA de otra forma en «Crear un cuadrado» y «Convertir caja a polígono». La variante con `annotate()` queda como parte de la idea de minimapa.
- Escala de colores para mapa de calor → PENDIENTE. Movido a la idea de mapa coroplético en «Visualización básica».
- Minimapa → PENDIENTE. Movido a «Visualización básica».

Se dejan abajo los chunks originales como referencia de código.
======================================================================

Desde el centroide de un polígono

``` r
mapa |> 
filter(region == "Región de Antofagasta") |>
st_centroid() |> 
st_buffer(dist = 8000) |> 
st_bbox() |> 
st_as_sfc() |>
st_as_sf()
```
-->

<!--
### Calcular superficie o área

``` r
mapa_region_comunas_areas |> 
st_union() |> 
st_area() |> 
units::set_units("km^2")
```



### Recortar polígono a coordenadas

``` r
st_crop(xmin = -74, ymin = -36, xmax = -65, ymax = -30) |> 
```


### Simplificar un polígono

``` r
https://bookdown.org/robinlovelace/geocompr/geometric-operations.html#simplification
st_simplify(dTolerance = 0.01)

rmapshaper::ms_simplify(geometry, keep = 0.8)) 
```


### Extraer líneas internas de un polígono

``` r
ms_innerlines() # deja solo las líneas interiores de un coso
```


## Correcciones

``` r
st_as_sf()
```



``` r
st_make_valid()
```


``` r
st_drop_geometry() 
```


----


## Operaciones agrupadas

### Unir polígonos

``` r
group_by() |> 
st_union()
```


## Operaciones entre geometrías

### Recortar un polígono con otro
https://bookdown.org/robinlovelace/geocompr/geometric-operations.html#clipping


``` r
st_intersection()
```

### Usar un polígono para eliminar partes de otro

``` r
st_difference()
```


### unir dos polígonos

``` r
st_union()
```

### Spatial join

### Filter

``` r
https://cengel.github.io/R-spatial/spatialops.html#topological-subsetting-select-polygons-by-location
```



## Coordenadas

### Extraer sistema de coordenadas

``` r
st_crs(comunas_region)
```

### Cambiar coordenadas

``` r
st_transform(crs = st_crs(comunas_region))
```


## Visualización

### Visualizar por capas

``` r
geom_sf()
```


### Texto

``` r
geom_sf_text(data = nombres_areas |> filter(clase_topo == "Comuna"), color = "red", fontface = "bold",
aes(label = nombre)) + 
```

### Texto con repel
https://github.com/slowkow/ggrepel/issues/111#issuecomment-416853013

``` r
ggrepel::geom_label_repel(data = comunas_region_conteo_urbanas,
aes(label = comuna, geometry = geometry),
stat = "sf_coordinates",
size = 2, box.padding = 0,
min.segment.length = unit(3, "mm"),
label.padding = 0.15, label.size = 0
) +
```


### Hacer zoom

``` r
#   coord_sf(xlim = c(-70.4, -70.2),
#            ylim = c(-18.7, -18.4),
```

### Dibujar un cuadrado

``` r
#   annotate("rect", fill = NA, color = "black", linewidth = 1,
#            xmin = bbox_area_met[1]-2000, xmax = bbox_area_met[2]+2000,
#            ymin = bbox_area_met[3]+2000, ymax = bbox_area_met[4]-2000)+
```

### Escala de colores para mapa de calor


``` r
scale_fill_gradient2(
low = color$bajo, mid = color$medio, high = color$alto,
midpoint = mean(comunas_region_conteo$n),
na.value = col_mix(color$fondo, color$principal, 0.1),
limits = c(0, NA)
# breaks = cortes
)
```


### Minimapa
https://dominicroye.github.io/blog/inserted-map/


-->

<!--
IDEAS TRANSVERSALES (sobre la estructura del post, no sobre una sección):

- Objetos que se pisan: `puntos`, `coordenadas`, `rectangulo`, `caja` y `chile_recorte` se redefinen varias veces a lo largo del post. Para un tutorial que la gente copia sección por sección está bien, pero conviene que cada sección vuelva a crear lo que usa (ya se hace casi siempre) y quizás un aviso al inicio diciendo que las secciones son independientes.
- Dependencia oculta (RESUELTA 30/10/2026): «Mover puntos» usaba `chile` sin definirlo (se definía recién en «Recortar un mapa»). Ahora se carga con `ne_countries()` dentro de «Mover puntos». «Recortar un mapa» lo vuelve a definir, lo que es redundante pero mantiene las secciones independientes.
- Orden de las secciones: «Operaciones sobre mapas» (recortar) se usa desde antes (en «Mover puntos» y «Mover puntos aleatoriamente» se enlaza a #recortar-un-mapa). Podría ir antes de «Operaciones sobre geometrías», o bien juntar ambas secciones bajo un solo título con subsecciones.
- Sección «Flujo típico» o «Receta»: un acápite al final que junte todo en un ejemplo corto de principio a fin: cargar mapa → revisar CRS → unir datos con `left_join()` → spatial join de puntos → coroplético con etiquetas. Serviría como cierre y como resumen para quienes ya conocen las piezas.
- Tabla resumen de funciones: al final, una tabla de dos columnas (función / para qué sirve) con todas las funciones de `{sf}` vistas en el post, a modo de apunte rápido. Complementa las hojas de apuntes de «Recursos».
- Enlaces a publicaciones derivadas: varias secciones tienen un post propio más detallado (simplificar, hexagonales, bivariados, triple, horizontal, macrozonas, mapgl). Revisar que cada sección correspondiente tenga su `relacionada` o enlace, para que este post funcione como índice del tema mapas en el blog.
- Datos reales en vez de inventados: en varias secciones los puntos son letras (A, B, C) con coordenadas arbitrarias. Podrían reemplazarse por ciudades reales de Argentina (capitales provinciales de `{rnaturalearth}` con `ne_download(type = "populated_places")`) sin cambiar el código, lo que haría los ejemplos más reconocibles y daría pie al spatial join.
-->


{{< relacionada "/blog/simplificar_mapas/" >}}


{{< etiqueta "mapas" >}}



## Recursos para aprender más

### Apuntes
<div style="display: flex; margin:auto;">
{{< imagen "sf_cheatsheet_1.jpeg" >}}
{{< imagen "sf_cheatsheet_2.jpeg" >}}
</div>

#### OpenStreetMap con R

[Revisa esta hoja de apuntes](https://zenodo.org/records/20842874) por Louis Laurian y Timothée Giraud.


### Libros

- [Drawing beautiful maps programmatically with R, sf and ggplot2](https://r-spatial.org/r/2018/10/25/ggplot2-sf.html)
- [Geocomputation with R](https://bookdown.org/robinlovelace/geocompr/)
- [Spatial Data Science With Applications in R](https://r-spatial.org/book/)
- [Using Spatial Data with R](https://cengel.github.io/R-spatial/)
- [Spatial Data Processing with R](https://jguelat.github.io/spatial-r/)
