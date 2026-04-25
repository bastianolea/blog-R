---
title: 'App: visualizador de mapas comunales del Censo 2024 por manzanas'
author: Bastián Olea Herrera
date: '2025-12-19'
slug: []
categories:
  - aplicaciones
tags:
  - apps
  - shiny
  - mapas
  - Chile
links:
- icon: link
  icon_pack: fas
  name: aplicación
  url: https://bastianoleah.shinyapps.io/censo_2024_mapas/
- icon: file-code
  icon_pack: fas
  name: código
  url: https://github.com/bastianolea/censo_2024_mapas
- icon: file-pen
  icon_pack: fas
  name: tutorial
  url: /blog/mapas_censo_2024
excerpt: "Continuando con la exploración de los datos georeferenciados del Censo 2024 por manzanas, en vez de ponerme a hacer mapas interesantes, hice una [aplicación](https://bastianoleah.shinyapps.io/censo_2024_mapas/) para visualizar mapas de cualquier variable del Censo en cualquier comuna del país, a nivel de manzana."
---

Continuando con la exploración de los datos georeferenciados del Censo 2024 por manzanas, en vez de ponerme a hacer mapas interesantes, hice una **[aplicación](https://bastianoleah.shinyapps.io/censo_2024_mapas/) para visualizar mapas** de cualquier variable del Censo en cualquier comuna del país, a nivel de manzana.

{{< imagen_tamaño "app_censo_mapas.jpg" "400px" >}}

{{< relacionada "blog/censo_2024" >}}

## Aplicación

Es una aplicación súper sencilla, que carga las **cartografías oficiales del Censo** en formato Arrow como una base de datos, a la cual por medio de _queries_ se le filtran región, comuna y la columna de variable elegida, para generar un mapa simple de una comuna dividida en manzanas censales 🍎 

{{< boton "App mapas Censo 2024" "https://bastianoleah.shinyapps.io/censo_2024_mapas/" "fas fa-link" >}}

Toda la app fue **hecha en R en menos de media hora** ⏱️ gracias a la conveniencia de `{dplyr}` para poder conectarse a los **datos cargados como [base de datos por Arrow](https://jthomasmock.github.io/bigger-data/#49)**, al [**tutorial de hacer mapas** del Censo 2024 con `{ggplot2}`](/blog/mapas_censo_2024), al [tutorial para poner **temas a las apps** Shiny](/blog/shiny_temas/) y al [tutorial para **temas de gráficos** `ggplot2`](/blog/ggplot_temas/).

En el fondo hice la app para aprender la carga de datos formato Arrow como base de datos, que es extremadamente fácil de hacer con R y `{dplyr}`, y me hizo pasar de cargar datos y filtrar en 1.1 segundos a tan sólo 0.1 segundos! 🚀 Si quieres que haga un tutorial de eso déjame un comentario o escríbeme 🤭

{{< info "Si quieres explorar más aplicaciones de datos sociales, revisa mi [portafolio de aplicaciones](https://bastianolea.github.io/shiny_apps/)" >}}

{{< relacionada "blog/mapas_censo_2024" >}}


## Resumen del código
Quiero destacar lo simple que es hacer aplicaciones como ésta con **[Shiny](/tags/shiny/)**.

El código de la app son apenas 200 líneas, donde prácticamente lo único que se hace es crear los botoncitos, cargar los datos, filtrarlos y generar el gráfico.

La carga de los datos con `{arrow}` se hace con `open_dataset()` para cargar como base de datos **sin leer todo el archivo ni traer los datos a la memoria**.

```r
# cargar datos
datos <- arrow::open_dataset("Cartografia_censo2024_Pais_Manzanas.parquet",
                             partitioning = c("COD_REGION", "CUT")
                             )
```

Luego simplemente con `{dplyr}` se hacen los filtros, que internamente se convierten a _queries_ SQL que van a cargar y obtener solamente los datos necesarios desde la base de datos:

```r
 datos_fitrados <- datos() |>
      # filtrar filas
      filter(COD_REGION == input$region,
             CUT == input$comuna) |>
      # seleccionar columnas
      select(all_of(input$variable), SHAPE) |> 
      # traer datos a memoria
      collect() |> 
      # convertir mapa
      st_as_sf(crs = 4326)
```

Finalmente los datos filtrados se visualizan como un mapa en `{ggplot2}`:

```r
datos_filtrados |> 
      ggplot() +
      aes(fill = !!sym(input$variable)) + # variable elegida
      geom_sf(color = "#181818", linewidth = 0.1) +
      # paleta de colores
      scale_fill_fermenter(palette = 13, na.value = "#181818") +
      # tema
      theme(axis.text.x = element_text(angle = 90, vjust = .5),
            axis.ticks = element_blank(),
            panel.background = element_blank(),
            panel.grid = element_line(color = "#333333"),
            axis.text = element_text(color = "#444444"),
            legend.text = element_text(color = "#666666")) +
      guides(fill = guide_legend(title = NULL,
                                 position = "top"))
```

{{< info "Si quieres aprender a hacer estos mismos mapas, revisa este [tutorial de mapas del Censo 2024]/blog/mapas_censo_2024), o revisa el [tutorial completo de mapas en R](/blog/mapas_sf/)" >}}


La gracia de Shiny es que puedes tomar cualquier código de R que harías normalmente, y ponerlo dentro de una app interactiva, para lo que solamente necesitas reemplazar los filtros, selecciones, y otros lugares donde escribirías cosas a mano por un `input$algo` que sería la selección hecha por la/él usuaria/o de la aplicación web.

{{< etiqueta "apps" >}}
