---
title: Tema oscuro morado para RStudio
subtitle: Personaliza la apariencia de RStudio con una paleta morada y rosada
author: Bastián Olea Herrera
format: hugo-md
date: 2025-12-03
modified: 2026-09-02
tags:
  - curiosidades
excerpt: "¡Agrégale moradito a tu análisis de datos! Tema para RStudio enfocado en una paleta de colores morada y rosada, basado en el tema _base16 Default Dark_ de [`{rsthemes}`](https://github.com/gadenbuie/rsthemes?tab=readme-ov-file). Ahora actualizado para la última versión de RStudio."
links:
- icon: brush
  icon_pack: fas
  name: temas
  url: https://github.com/bastianolea/rstudio_purple_dark_theme
---

{{< imagen "rstudio.png" >}}


Tema para RStudio enfocado en una paleta de colores morada y rosada, basado en el tema _base16 Default Dark_ de [`{rsthemes}`](https://github.com/gadenbuie/rsthemes), el cual a su vez está basado en [base16](https://github.com/chriskempson/base16).

A diferencia de otros temas para RStudio, éste modifica prácticamente todos los aspectos de la aplicación, incluyendo los distintos paneles, ventanas, menús, y marcos de la ventana principal.

{{< imagen "tema_oscuro.png" "300px" >}}

También hay una versión en colores claros, que es una variación del tema _Tomorrow_ de RStudio, con una paleta morada y rosada para complementar con el tema morado oscuro.

{{< imagen "tema_claro.png" "300px" >}}

## Instalación

Este tema afecta muchos aspectos de RStudio que cambian con cada actualización, por lo que, idealmente, el tema requiere de una instalación por medio de un script que detecta tu versión de RStudio y adapta el tema a ella. 

1. [Clonar](https://bastianolea.rbind.io/blog/tutorial_github/#clonar-un-repositorio-código-de-r-en-github) en tu computadora [este repositorio](https://github.com/bastianolea/rstudio_purple_dark_theme/) usando Git o RStudio (_File_ > _New Project_ > _Version Control_)
2. Abrir el proyecto con RStudio
3. Ejecutar el script `aplicar.R` para crear los archivos `.rstheme` y, opcionalmente, aplicarlos a tu IDE:

```r
source("R/clases.R")
source("R/construir.R")

construir_tema("dark", instalar = TRUE)
```

Estos temas son generados a partir del script `aplicar.R` para que funcionen correctamente con la **última** versión de RStudio.

Si actualizaste RStudio o no tienes la última versión, clona este repositorio y ejecuta `aplicar.R` para generar y aplicar una versión del tema específica para tu versión de RStudio.

### Instalación simple

**Necesitas tener la [versión más reciente](https://docs.posit.co/ide/user/#rstudio-ide-oss-downloads) de RStudio.** 

[Descarga el tema oscuro](https://github.com/bastianolea/rstudio_purple_dark_theme/raw/refs/heads/main/basti-purple-dark.rstheme) `basti-purple-dark.rstheme` y/o [descarga el tema claro](https://github.com/bastianolea/rstudio_purple_dark_theme/raw/refs/heads/main/basti-purple-light.rstheme) `basti-purple-light.rstheme` desde
[este repositorio](https://github.com/bastianolea/rstudio_purple_dark_theme). 

En RStudio, abre _Global Options_ (`⌘;`) → _Appearance_ → botón _Add..._ y elige el archivo, y luego podrás aplicar el tema.

{{< relacionada "/blog/2025-01-12/" >}}

Si quieres configurar RStudio para que el tema cambie entre claro y oscuro de forma automática dependiendo de la hora del día, [sigue las instrucciones en este post!](/blog/2025-01-12/)

## Trasfondo

Para personalizar la apariencia de RStudio se usan temas, que son simplemente hojas CSS que afectan las clases asignadas a cada elemento de la app. Estas clases permiten personalizar bastantes aspectos de la IDE, pero no todos. El resto de la interfaz (bordes de paneles, barra de estado, panel de entorno, diálogos) no tienen clases, sino que RStudio las estiliza usando **clases ofuscadas**, y cuyo nombre cambia en cada versión (con nombres como `GFRCULXJX`). 

Por lo tanto, los temas que cambian aspectos profundos de la interfaz se echan a perder con cada actualización, porque cambian las clases ofuscadas. El código en el [repositorio](https://github.com/bastianolea/rstudio_purple_dark_theme) implementa scripts que revisan las clases ofuscadas y les asigna _nombres semánticos_; por ejemplo, la clase ofuscada `GCOP2I3BHW` se identifica como el elemento `ThemeResources.toolbarButton`, lo que permite personalizarlo. Más información en el [_readme_ del repositorio.](https://github.com/bastianolea/rstudio_purple_dark_theme)

## Actualizaciones
- **2026/09/01**: Actualización mayor para abarcar más elementos de RStudio. Debido a lo anterior, se recomienda ejecutar el script de instalación.
- **2026/04/22**: Tema actualizado para compatibilidad con la última versión de RStudio (2026.04.0)
- **2025/12/03**: Ahora más morado! 💜 y más rosado! 🩷 Celebrando la [actualización del tema para el código](/blog/2025-12-02/) de este blog.


## Recursos

- [Creador de temas de RStudio](https://benharrap.com/tools/rstudio-themer#theme=eyJuYW1lIjoiTXkgdGhlbWUiLCJzdGFydEZyb20iOiJEcmFjdWxhIiwiaXRhbGljQ29tbWVudHMiOmZhbHNlLCJib2xkS2V5d29yZHMiOmZhbHNlLCJ0ZXJtTWF0Y2giOnRydWUsImNvbG9ycyI6eyJmb3JlZ3JvdW5kIjoiI2Y4ZjhmMiIsImJhY2tncm91bmQiOiIjMjgyYTM2IiwiZ3V0dGVyQmciOiIjMjgyYTM2IiwiZ3V0dGVyRmciOiIjOTA5MTk0IiwiY3Vyc29yIjoiI2Y4ZjhmMCIsInNlbGVjdGlvbiI6IiM0NDQ3NWEiLCJzZWxlY3RlZFdvcmQiOiIjYTI5NzA5IiwiYnJhY2tldCI6IiM1NDU1NWIiLCJhY3RpdmVMaW5lIjoiIzQ0NDc1YSIsIm1hcmdpbiI6IiM0NDQ3NWEiLCJpbnZpc2libGUiOiIjNjI2NjgwIiwiaW5kZW50R3VpZGUiOiIjNDc0NzQ3IiwiY29tbWVudCI6IiM2MjcyYTQiLCJrZXl3b3JkIjoiI2JkOTNmOSIsIm9wZXJhdG9yIjoiI2ZmNzljNiIsInN0cmluZyI6IiNmMWZhOGMiLCJudW1iZXIiOiIjYmQ5M2Y5IiwiY29uc3RhbnQiOiIjYmQ5M2Y5IiwiZm5DYWxsIjoiIzUwZmE3YiIsImhlYWRpbmciOiIjZjhmOGYyIiwiaXRhbGljIjoiI2JkOTNmOSIsImJvbGQiOiIjYmQ5M2Y5IiwibGlua1VybCI6IiNmOGY4ZjIiLCJjaXRhdGlvbiI6IiNmOGY4ZjIiLCJpbmxpbmVDb2RlIjoiIzUwZmE3YiIsImNodW5rQmciOiIjM2QzZjQ5IiwiZmVuY2UiOiIjNTBmYTdiIiwieWFtbEtleSI6IiNmOGY4ZjIiLCJibG9ja3F1b3RlIjoiI2YxZmE4YyIsImxhdGV4RGVsaW0iOiIjZjFmYThjIiwibGF0ZXgiOiIjNTBmYTdiIiwiYW5zaTAiOiIjNGY0ZjRmIiwiYW5zaTEiOiIjZmY1NTU1IiwiYW5zaTIiOiIjNTBmYTdiIiwiYW5zaTMiOiIjZjFmYThjIiwiYW5zaTQiOiIjYmQ5M2Y5IiwiYW5zaTUiOiIjZmY3OWM2IiwiYW5zaTYiOiIjOGJlOWZkIiwiYW5zaTciOiIjYmJiYmJiIiwiYW5zaTgiOiIjNTU1NTU1IiwiYW5zaTkiOiIjZmY1NTU1IiwiYW5zaTEwIjoiIzUwZmE3YiIsImFuc2kxMSI6IiNmMWZhOGMiLCJhbnNpMTIiOiIjYmQ5M2Y5IiwiYW5zaTEzIjoiI2ZmNzljNiIsImFuc2kxNCI6IiM4YmU5ZmQiLCJhbnNpMTUiOiIjZmZmZmZmIiwicGFyZW4wIjoiI2JkOTNmOSIsInBhcmVuMSI6IiM1MGZhN2IiLCJwYXJlbjIiOiIjZjFmYThjIiwicGFyZW4zIjoiI2ZmNzljNiIsInBhcmVuNCI6IiM2MjcyYTQiLCJwYXJlbjUiOiIjYmQ5M2Y5IiwicGFyZW42IjoiIzUwZmE3YiIsInBhcmVuNyI6IiNmMWZhOGMiLCJwYXJlbjgiOiIjZmY3OWM2IiwicGFyZW45IjoiIzYyNzJhNCIsInBhcmVuMTAiOiIjYmQ5M2Y5IiwicGFyZW4xMSI6IiM1MGZhN2IiLCJwYXJlbjEyIjoiI2YxZmE4YyIsInBhcmVuMTMiOiIjZmY3OWM2IiwicGFyZW4xNCI6IiM2MjcyYTQiLCJwYXJlbjE1IjoiI2JkOTNmOSIsImRpdjAiOiIjYmQ5M2Y5IiwiZGl2MSI6IiM1MGZhN2IiLCJkaXYyIjoiI2YxZmE4YyIsImRpdjMiOiIjZmY3OWM2IiwiZGl2NCI6IiM2MjcyYTQiLCJkaXY1IjoiI2JkOTNmOSIsImRpdjYiOiIjNTBmYTdiIiwiZGl2NyI6IiNmMWZhOGMiLCJkaXY4IjoiI2ZmNzljNiIsImRpdjkiOiIjNjI3MmE0IiwiZGl2MTAiOiIjYmQ5M2Y5IiwiZGl2MTEiOiIjNTBmYTdiIiwiZGl2MTIiOiIjZjFmYThjIiwiZGl2MTMiOiIjZmY3OWM2IiwiZGl2MTQiOiIjNjI3MmE0IiwiZGl2MTUiOiIjYmQ5M2Y5IiwiaW5kZW50MCI6IiNlZDkwYTQiLCJpbmRlbnQxIjoiI2QzYTI2MyIsImluZGVudDIiOiIjOTliNjU3IiwiaW5kZW50MyI6IiMzM2MxOTIiLCJpbmRlbnQ0IjoiIzAwYmRjZSIsImluZGVudDUiOiIjOTRhOWViIiwiaW5kZW50NiI6IiNkYzkxZGIiLCJpbmRlbnQ3IjoiI2VkOTBhNCIsImluZGVudDgiOiIjZDNhMjYzIiwiaW5kZW50OSI6IiM5OWI2NTciLCJpbmRlbnQxMCI6IiMzM2MxOTIiLCJpbmRlbnQxMSI6IiMwMGJkY2UiLCJpbmRlbnQxMiI6IiM5NGE5ZWIiLCJpbmRlbnQxMyI6IiNkYzkxZGIiLCJpbmRlbnQxNCI6IiNlZDkwYTQiLCJpbmRlbnQxNSI6IiNkM2EyNjMiLCJ0ZXJtQmciOiIjMjgyYTM2IiwidGVybUZnIjoiI2Y4ZjhmMiIsInRlcm1TZWxlY3Rpb24iOiIjY2NjY2NjIn0sInNob3dNYXJnaW4iOnRydWUsImhpZ2hsaWdodExpbmUiOmZhbHNlLCJoaWdobGlnaHRXb3JkIjp0cnVlLCJsaW5lTnVtYmVycyI6dHJ1ZSwiaW52aXNpYmxlcyI6ZmFsc2UsImluZGVudEd1aWRlcyI6Im5vbmUiLCJmbkNhbGxzIjpmYWxzZSwiaGlnaGxpZ2h0Q2h1bmtzIjp0cnVlLCJyYWluYm93IjpmYWxzZSwicmFpbmJvd0RpdnMiOnRydWUsInBhcmVuQ291bnQiOjMsImRpdkNvdW50IjozLCJpbmRlbnRDb3VudCI6M30%3D) hecho por [Ben Harrap](https://benharrap.com)