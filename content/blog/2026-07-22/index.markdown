---
title: "Mapa bivariado de porcentaje de adultos mayores versus viviendas propias en las comunas de Chile"
author: Bastián Olea Herrera
date: '2026-07-22'
slug: []
draft: true
tags:
  - mapas
  - visualización de datos
format:
  hugo-md:
    output-file: index
    output-ext: md
execute:
  message: false
  warning: false
knitr:
  opts_chunk:
    dev.args:
      bg: transparent
editor_options:
  chunk_output_type: inline
excerpt: "¿Cómo se distribuyen territorialmente el envejecimiento poblacional y la propiedad de viviendas en Chile? Un análisis con mapas bivariados de cuatro regiones del país que revela patrones y dinámicas territoriales distintas."
links:
  - icon: registered
    icon_pack: fas
    name: biscale
    url: https://chris-prener.github.io/biscale/
---

¿Dónde viven más adultos mayores que tienen vivienda propia? ¿En qué comunas conviven altos porcentajes de ambas características? Estas preguntas revelan patrones territoriales que un mapa convencional no puede mostrar.

Los **mapas bivariados** permiten visualizar simultáneamente dos variables usando una **paleta de colores en dos dimensiones**, donde cada combinación de colores expresa la relación conjunta entre ambas. En este análisis usamos esta herramienta para explorar cómo se distribuyen geográficamente el **envejecimiento poblacional** y la **propiedad de viviendas** en distintas regiones de Chile, según datos del [Censo de Población y Vivienda 2024](/blog/censo_2024/).

Veremos que cada región cuenta una historia territorial diferente, reflejando trayectorias demográficas y económicas distintas.

{{< relacionada "/blog/mapas_bivariados/" "Tutorial: Cómo crear mapas bivariados" >}}

## Preparar los datos

Para este ejemplo necesitamos dos indicadores por comuna: el porcentaje de adultos mayores y el de viviendas propias, ambos del Censo 2024. El procesamiento completo está en el tutorial detallado, aquí lo hacemos de forma resumida.


```
## Warning: package 'dplyr' was built under R version 4.4.3
```

```
## Warning: package 'arrow' was built under R version 4.4.3
```


``` r
library(dplyr)
library(readxl)
library(arrow)

# cargar diccionario de comunas
comunas <- readxl::read_xlsx("diccionario_variables_censo2024.xlsx",
                             sheet = "codigos_territoriales") |>
  select(comuna = 1, nombre_comuna = 3) |>
  filter(comuna > 999)

# cargar bases del Censo como base de datos (Arrow)
personas <- open_dataset("personas_censo2024.parquet")
hogares <- open_dataset("hogares_censo2024.parquet")
```


``` r
# cruzar personas y hogares, contar y traer a memoria
personas_hogares <- personas |>
  select(id_vivienda, id_hogar, comuna, sexo, edad_quinquenal) |>
  left_join(
    hogares |> select(id_vivienda, id_hogar, comuna, p12_tenencia_viv),
    join_by(id_vivienda, id_hogar, comuna)
  ) |>
  group_by(comuna, sexo, edad_quinquenal, p12_tenencia_viv) |>
  summarize(n = n()) |>
  ungroup() |>
  collect()

# recodificar variables y crear indicadores
conteo_recod <- personas_hogares |>
  mutate(
    sexo = recode_values(sexo, 1 ~ "Hombre", 2 ~ "Mujer"),
    p12_tenencia_viv = recode_values(
      p12_tenencia_viv,
      1 ~ "Propia pagada", 2 ~ "Propia pagándose",
      3 ~ "Arrendada con contrato", 4 ~ "Arrendada sin contrato",
      5 ~ "Cedida por trabajo o servicio", 6 ~ "Cedida por familiar u otro",
      7 ~ "Usufructo: solo uso y goce", 8 ~ "Ocupada de hecho",
      9 ~ "Propiedad en sucesión o litigio"
    ),
    propiedad = if_else(
      p12_tenencia_viv %in% c("Propia pagada", "Propia pagándose"),
      "Propia", "No propia"
    ),
    mayor = case_when(
      sexo == "Hombre" & edad_quinquenal >= 65 ~ "Adulto mayor",
      sexo == "Mujer" & edad_quinquenal >= 60 ~ "Adulto mayor",
      .default = "No adulto mayor"
    )
  ) |>
  left_join(comunas, by = "comuna")

# calcular porcentaje de adultos mayores por comuna
mayor_p <- conteo_recod |>
  group_by(nombre_comuna, comuna) |>
  count(mayor, wt = n) |>
  mutate(p = n / sum(n)) |>
  filter(mayor == "Adulto mayor") |>
  select(nombre_comuna, comuna, mayor_p = p) |> 
  ungroup()

# calcular porcentaje de viviendas propias por comuna
propia_p <- conteo_recod |>
  group_by(nombre_comuna, comuna) |>
  count(propiedad, wt = n) |>
  mutate(p = n / sum(n)) |>
  filter(propiedad == "Propia") |>
  select(comuna, propia_p = p) |> 
  ungroup()

# unir ambos indicadores
datos_censo <- left_join(
  mayor_p, propia_p, 
  join_by(nombre_comuna, comuna)
)
```

## Preparar los mapas

Con los indicadores ya calculados, obtenemos el mapa de comunas y lo unimos con nuestros datos censales:


``` r
library(ggplot2)
library(sf)
```

```
## Warning: package 'sf' was built under R version 4.4.3
```

``` r
library(chilemapas)
library(biscale)
library(patchwork)

# Obtener mapa de comunas
mapa_comunas <- chilemapas::mapa_comunas |>
  mutate(codigo_comuna = as.numeric(codigo_comuna)) |>
  rename(comuna = codigo_comuna)

# Unir datos con el mapa
mapa_censo <- datos_censo |>
  left_join(mapa_comunas, by = "comuna")
```

Como los tres mapas bivariados tendrán la misma leyenda, la creamos de antemano, definiendo la paleta de colores y las dimensiones de clasificación para poder reutilizarlas al clasificar los datos.


``` r
paleta <- "DkBlue2"
dimensiones <- 3

leyenda_bivariada <- bi_legend(pal = paleta,
                               dim = dimensiones,
                               xlab = "Adultos mayores",
                               ylab = "Viviendas propias",
                               size = 8) +
  theme(plot.background = element_blank(),
        panel.background = element_blank(),
        panel.grid.major = element_blank())
```

Además, especificamos la apariencia de las visualizaciones definiendo el tema:


``` r
library(ggplot2)

theme_set(
  theme_void(
    base_family = "Atkinson Hyperlegible",
    paper = "#EAD1FA",
    ink = "#543A73",
    accent = "#9069C0"
  ) +
    # margen de mapas
    theme(plot.margin = unit(c(2, 2, 2, 2), "mm")) +
    # fondo transparente (paper de theme_void deja fondo opaco)
    theme(plot.background = element_rect(fill = "transparent", 
                                         color = "transparent")
          )
)
```


## Mapas bivariados 

### Región Metropolitana


``` r
library(patchwork)

mapa_rm <- mapa_censo |>
  filter(codigo_region == "13") |>
    # clasificar variables
  bi_class(x = mayor_p,
           y = propia_p,
           style = "quantile",
           dim = dimensiones) |>
  st_as_sf() |>
  # visualizar mapa
  ggplot() +
  aes(fill = bi_class) +
  geom_sf(show.legend = FALSE, linewidth = 0.1, color = "white") +
  bi_scale_fill(pal = paleta, dim = dimensiones) +
  theme_void(base_family = "sans")

mapa_rm +
  inset_element(leyenda_bivariada,
                left = 0, bottom = 0.7,
                right = 0.3, top = 1)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-1.png" alt="" width="576" />

El patrón territorial de la Región Metropolitana es el más homogéneo. Las comunas tienden a concentrarse en los tonos medios-oscuros: hay un **envejecimiento bastante generalizado** acompañado de **altos porcentajes de vivienda propia**. Pocas comunas caen en los extremos claros (bajo envejecimiento y baja propiedad).

Las comunas más azuladas (alto envejecimiento, baja propiedad) sugieren sectores con poblaciones adultas mayores pero menos acceso a vivienda propia, probablemente relacionado con rentas o arriendo. Los tonos más rojizos aparecen en comunas con menor proporción de adultos mayores pero más viviendas propias, típicamente en expansiones urbanas periféricas.

---

### Región de Valparaíso


``` r
mapa_valpo <- mapa_censo |>
  filter(codigo_region == "05") |>
  # clasificar variables
  bi_class(x = mayor_p,
           y = propia_p,
           style = "quantile",
           dim = dimensiones) |>
  st_as_sf() |>
  # visualizar mapa
  ggplot() +
  aes(fill = bi_class) +
  geom_sf(show.legend = FALSE, linewidth = 0.1, color = "white") +
  bi_scale_fill(pal = paleta, dim = dimensiones) +
  # excluir islas
  coord_sf(xlim = c(-72, -70),
           ylim = c(-32, -34)) +
  theme_void(base_family = "sans")

mapa_valpo +
  inset_element(leyenda_bivariada,
                left = 0.6, bottom = 0,
                right = 1, top = 0.4)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-1.png" alt="" width="576" />

Valparaíso contrasta con la Metropolitana. Aquí encontramos **mayor dispersión territorial**: hay comunas con envejecimiento alto pero baja propiedad (litoral turístico y portuario, posiblemente con población flotante) y comunas con baja propiedad pero poco envejecimiento (zonas de expansión residencial). 

La distribución más polarizada sugiere una región en **transición demográfica desigual**, donde algunos sectores envejecen mientras otros reciben población más joven. La propiedad de viviendas también es menos generalizada que en la Metropolitana, reflejando dinámicas inmobiliarias y de acceso al suelo más complejas.

---

### Región de O'Higgins


``` r
# Clasificar región 6
mapa_ohiggins <- mapa_censo |>
  filter(codigo_region == "06") |>
    # clasificar variables
  bi_class(x = mayor_p,
           y = propia_p,
           style = "quantile",
           dim = dimensiones) |>
  st_as_sf() |>
  # visualizar mapa
  ggplot() +
  aes(fill = bi_class) +
  geom_sf(show.legend = FALSE, linewidth = 0.1, color = "white") +
  bi_scale_fill(pal = paleta, dim = dimensiones) +
  theme_void(base_family = "sans") +
  # agregar espacios abajo para ajustar la leyenda
  theme(plot.margin = unit(c(2, 2, 12, 2), "mm"),
        plot.caption = element_text(margin = margin(t = 20)))

mapa_ohiggins +
  inset_element(leyenda_bivariada,
                left = -0.05, bottom = -0.2,
                right = 0.2, top = 0.15)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" alt="" width="576" />

O'Higgins muestra un patrón más heterogéneo aún. Las comunas están distribuidas a lo largo de todo el rango de colores, indicando **mayor diversidad territorial**. Hay comunas con alto envejecimiento pero baja propiedad (centros urbanos antiguos), comunas con baja propiedad y bajo envejecimiento (nuevas expansiones), y sectores con ambas características altas (zonas consolidadas).

Este patrón refleja una región con **múltiples dinámicas simultáneas**: envejecimiento en ciertos territorios, rejuvenecimiento en otros, y acceso a vivienda propia muy desigual según localización. La ruralidad de la región también influye: comunas agrícolas pueden tener poblaciones más envejecidas pero menor acceso a vivienda formal propia.

---

### Región del Biobío


``` r
mapa_biobio <- mapa_censo |>
  filter(codigo_region == "08") |>
    # clasificar variables
  bi_class(x = mayor_p,
           y = propia_p,
           style = "quantile",
           dim = dimensiones) |> 
  st_as_sf() |>
  # visualizar mapa
  ggplot() +
  aes(fill = bi_class) +
  geom_sf(show.legend = FALSE, linewidth = 0.1, color = "white") +
  bi_scale_fill(pal = paleta, dim = dimensiones) +
  theme_void(base_family = "sans")

mapa_biobio +
  inset_element(leyenda_bivariada,
                left = 0.7, bottom = 0.71,
                right = 1, top = 1.)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-6-1.png" alt="" width="576" />

El Biobío presenta un patrón similar a O'Higgins: **diversidad territorial importante**. Sin embargo, hay una concentración notable en los tonos oscuros (alto envejecimiento + alta propiedad), especialmente en sectores más consolidados de Concepción y Talcahuano.

Las comunas más claras aparecen principalmente en la periferia urbana y zonas rurales, donde menor envejecimiento convive con menos acceso a vivienda propia. Esto sugiere que la propiedad de viviendas está fuertemente asociada a territorios antiguos y consolidados, mientras que la expansión urbana se caracteriza por arrendamiento y acceso más limitado.

---

## Análisis

Comparando las cuatro regiones, emergen varios patrones:

1. **Concentración metropolitana**: La Región Metropolitana es la más homogénea —envejecimiento y propiedad altos en casi todas partes. Esto refleja la consolidación urbana y demográfica de la capital.

2. **Heterogeneidad regional**: Las regiones fuera de la capital muestran mayor dispersión, con dinámicas territoriales más complejas y multidireccionales.

3. **Propiedad asociada a consolidación**: En todas las regiones, los porcentajes más altos de vivienda propia tienden a coincidir con zonas de menor crecimiento demográfico y mayor densidad histórica.

4. **Envejecimiento desigual**: El envejecimiento no es uniforme por región. Algunas áreas mantienen poblaciones más jóvenes mientras otras envejece rápidamente, reflejo de migraciones internas y ciclos económicos regionales.

{{< relacionada "/blog/mapas_bivariados/" "Tutorial: Cómo crear mapas bivariados" >}}
{{< relacionada "/blog/mapas_sf/" "Tutorial: Mapas con {sf}" >}}

{{< etiqueta "mapas" >}}

