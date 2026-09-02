---
title: Tema oscuro morado para RStudio
subtitle: Personaliza la apariencia de RStudio con una paleta morada y rosada
author: Bastián Olea Herrera
format: hugo-md
# date: 2025-12-03
# date: 2026-04-23
date: 2026-09-02
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

Este tema afecta muchos aspectos de RStudio que cambian con cada actualización, por lo que el tema requiere de una instalación por medio de un script que detecta tu versión de RStudio y adapta el tema a ella.

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
- **2026/09/01**: Actualización mayor. Debido a que el tema afecta todos los aspectos de la IDE, requiere de un script de instalación.
- **2026/04/22**: Tema actualizado para compatibilidad con la última versión de RStudio (2026.04.0)
- **2025/12/03**: Ahora más morado! 💜 y más rosado! 🩷 Celebrando la [actualización del tema para el código](/blog/2025-12-02/) de este blog.