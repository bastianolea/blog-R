---
title: 'Aplicación: Visualizador de densidad de población urbana en comunas de Chile'
author: Bastián Olea Herrera
date: '2026-04-23'
slug: []
categories:
  - Aplicaciones
tags:
  - Chile
  - gráficos
  - apps
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: link
    icon_pack: fas
    name: Aplicación
    url: https://bastianoleah.shinyapps.io/densidad_comunas/
  - icon: file-code
    icon_pack: fas
    name: Código
    url: https://github.com/bastianolea/densidad_poblacional_comunas
excerpt: "Aplicación simple para explorar de forma gráfica la densidad poblacional de las comunas de Chile, para los territorios urbanos. Desarrollada principalmente para poder personalizar un gráfico estático."
---

{{< imagen "app_densidad_comunas.png" >}}

Aplicación simple para explorar de forma gráfica la densidad poblacional de las comunas de Chile, para los territorios urbanos. 

Selecciona una región para ver las comunas más pobladas y sus densidades, y luego elige las comunas que necesites ver. También puedes poner _Todas_ en el selector de regiones para visualizar juntas comunas de cualquier región del país.

Los datos provienen del [Censo 2024](https://censo2024.ine.gob.cl) a nivel de personas, y las superficies urbanas se calculan desde la cartografía censal a nivel de manzanas.

{{< imagen "densidad_region_13.jpg" >}}

Esta aplicación fue desarrollada principalmente para poder personalizar un gráfico estático, debido a la alta cantidad de comentarios y consultas en la publicación de LinkedIn:

<div style="width: 100%; text-align: center;">
<iframe src="https://www.linkedin.com/embed/feed/update/urn:li:share:7449910130898313216?collapsed=1" height="668" width="100%" frameborder="0" allowfullscreen="" title="Publicación integrada"></iframe>
</div>

Para desarrollar la aplicación usé **Claude Code**, que aceleró bastante el proceso de desarrollo, y luego refiné el resultado manualmente. Pronto escribiré un post con mis experiencias con este tipo de herramientas de IA para programación!

{{< etiqueta "apps" >}}