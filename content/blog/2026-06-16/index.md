---
title: 'Tipografías lindas para programar en R: Fira Code'
author: Bastián Olea Herrera
date: '2026-06-16'
slug: []
categories: []
tags:
  - consejos
  - blog
  - curiosidades
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: font
    icon_pack: fas
    name: Fira Code
    url: https://github.com/tonsky/FiraCode
excerpt: "Fira Code es una tipografía muy bonita para programar. Su característica principal es que usa las ligaduras, una característica de la tipografía que une dos o más caracteres en un solo símbolo adaptado, para mostrar los símbolos usados en programación de forma más atractiva. Mírala aquí y aprende a instalarla."
---

[Fira Code](https://github.com/tonsky/FiraCode) es una tipografía muy bonita para programar. Su característica principal es que usa las **ligaduras**, una característica de la tipografía que une dos o más caracteres en un solo símbolo adaptado, para mostrar los símbolos usados en programación de forma más atractiva.

{{< imagen "pruebas_firacode.png" "300px" >}}

Lo más destacable es que convierte el [símbolo del conector](/blog/r_introduccion/conectores/) o _pipe_ (`|>`) en un triangulito, y a la [flecha de asignación](/blog/r_introduccion/r_basico/#asignaciones) (`<-`) en una flecha de verdad.

Antes usaba la tipografía Menlo para programar, pero encuentro que Fira Code es más legible gracias a sus **serifas** (remates en las puntas de los caracteres), y además por los ajustes de variantes de símbolos, ajuste de la altura de los caracteres según sus adyacentes, y otros detalles que la hacen una tipografía monoespaciada muy legible.

{{< columnas >}}

_**Antes**_
{{< imagen_tamaño "rstudio_menlo.png" "100%" >}}
{{< bajada "Código de R con Menlo" >}}

{{< columna >}}

_**Después**_
{{< imagen_tamaño "rstudio_firacode.png" "100%" >}}
{{< bajada "Código de R con Fira Code" >}}

{{< fin_columnas >}}

Instala [Fira Code](https://github.com/tonsky/FiraCode) siguiendo estas [instrucciones de instalación](https://github.com/tonsky/FiraCode/wiki/Installing) y luego actívala en RStudio en _Global Options_ y luego _Appearance_.

{{< imagen "rstudio_change_font.png" >}}

También está disponible en [Google Fonts](https://fonts.google.com/specimen/Fira+Code).

Si te gustó el tema moradito oscuro que uso en RStudio, lo puedes encontrar acá:

{{< relacionada "/blog/tema_morado/" "Tema de RStudio" >}}

{{< etiqueta "consejos" "Más publicaciones" >}}