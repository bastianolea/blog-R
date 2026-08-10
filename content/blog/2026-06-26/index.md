---
title: "Truco de RStudio: escribe en múltiples líneas al mismo tiempo"
author: Bastián Olea Herrera
date: '2026-07-22'
slug: []
draft: false
tags:
  - consejos
  - videos
excerpt: "Mi truco favorito de RStudio, que ayuda mucho a editar texto o código cuando se tienen que hacer varios cambios al mismo tiempo, o cuando se trabaja con un mismo patrón de texto en varias líneas de código. Siempre que hago esto en clases mis estudiantes me preguntan cómo lo hice!"
---

Uno de mis trucos favoritos para programar en RStudio es la funcionalidad de **edición multicursor**, que te permite tener varios cursores de texto para así poder escribir lo mismo en varios lugares o líneas a la vez! Ayuda mucho a editar texto o código cuando se tienen que hacer varios cambios al mismo tiempo, o cuando se trabaja con un mismo patrón de texto en varias líneas de código.

{{< video "rstudio_multicursor_0.mp4" "240px">}}

Para hacerlo, **mantén presionada** la siguiente combinación de teclas y **haz clic** en las líneas o posiciones del texto donde quieras poner cursores:

{{< imagen "rstudio_multicursor_mac.png" "200px" >}}
{{< bajada "Combinación de teclas para modo multicursor de RStudio en Mac" >}}

{{< imagen "rstudio_multicursor_win.png" "200px" >}}
{{< bajada "Combinación de teclas para modo multicursor de RStudio en Windows" >}}

También puedes seleccionar un punto en el texto y mantener esta combinación de teclas mientras presionas las flechas del teclado hacia arriba o hacia abajo para crear cursores hacia cada línea que te desplaces:

{{< video "rstudio_multicursor_5.mp4" "300px" >}}

Puedes potenciar mucho más este truco si aprendes las combinaciones de teclas para **navegar texto** con tu teclado:

{{< imagen "rstudio_lineend_mac.png" "420px" >}}
{{< bajada "Combinación de teclas para moverse al inicio o final de una línea en Mac" >}}

{{< imagen "rstudio_lineend_win.png" "240px" >}}
{{< bajada "Combinación de teclas para moverse al inicio o final de una línea en Windows" >}}


Mejor aún, si mezclas estas combinaciones de teclas con la tecla `shift` (⇧), puedes combinar el movimiento del cursor con selección de texto, incluso hacia arriba o hacia abajo para seleccionar entre líneas!

### Ejemplos

Si necesitas cambiar texto en varias secciones del código al mismo tiempo, presionas `control` + `option` y el inicio o final de cada palabra, y podrás escribir en múltiples líneas a la vez!
 
{{< video "rstudio_multicursor_4.mp4" >}}

En el ejemplo anterior, lo uso para cambiar una palabra que se usa en 5 lugares al mismo tiempo.

Si estás haciendo una misma acción varias veces, como cargar múltiples archivos, puedes hacer `control` + `option` al inicio o final de las líneas para editar todas las líneas al mismo tiempo, y luego mover los cursores de texto con el teclado para seleccionar texto, mover los cursores al inicio de la línea, y pegar el texto copiado para usarlo en otra cosa:

{{< video "rstudio_multicursor_1.mp4" >}}

En este caso usamos los nombres de los archivos para crear los nombres de los objetos que almacenarán los datos cargados.

En este otro ejemplo usaremos los múltiples cursores para cambiar un año que aparece en varias partes al mismo tiempo:

{{< video "rstudio_multicursor_2.mp4" >}}

La gracia de esta funcionalidad es que si tienes cursores de texto en varias líneas, puedes apretar `enter` y crear nuevas líneas de manera simultánea, permitiéndote escribir un mismo bloque de código varias veces!

{{< video "rstudio_multicursor_3.mp4" >}}

Si bien en varios casos esta funcionalidad puede reemplazarse por el _buscar y reemplazar_, sin duda es entretenido y te abre varias posibilidades más. Siempre que hago esto en clases mis estudiantes me preguntan cómo lo hice 🤭

{{< etiqueta "consejos" >}}