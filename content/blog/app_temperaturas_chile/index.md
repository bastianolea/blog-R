---
title: "App: Temperaturas extremas en Chile"
subtitle: Visualizador de datos sobre crisis climática
author: Bastián Olea Herrera
date: "2024-12-16"
categories:
  - Aplicaciones
tags:
  - aplicaciones
  - Chile
draft: false
excerpt: "Consulta datos históricos de temperaturas extremas en el país, desde 1970 hasta 2024, y visualiza los cambios históricos en las temperaturas producto de la crisis climática."

layout: single
links:
- icon: link
  icon_pack: fas
  name: aplicación
  url: https://bastianoleah.shinyapps.io/temperaturas_chile
- icon: github
  icon_pack: fab
  name: código
  url: https://github.com/bastianolea/temperaturas_chile
---

[Visualizador de datos de temperaturas extremas en el país.]((https://bastianoleah.shinyapps.io/temperaturas_chile/)) Permite consultar rápidamente datos históricos para obtener gráficos que revelan los cambios en temperaturas a través del tiempo en nuestro país. El objetivo es visibilizar los efectos del cambio climático por medio de los datos.

En esta plataforma puedes visualizar datos históricos sobre temperaturas extremas del país, cuyo objetivo es visibilizar los efectos del cambio climático por medio de los datos.

Los datos se obtienen desde el Portal de Datos Abiertos del Estado de Chile mediante web scrapping. El proyecto unifica todas las fuentes de datos separadas en una sola base de datos de temperaturas, los cuales son utilizados en la plataforma de visualización interactiva. 

Los datos son obtenidos desde fuentes oficiales, y abarcan aproximadamente desde 1970 a 2024.

Este repositorio obtiene datos desde el [Portal de Datos Abiertos del Estado de Chile](https://datos.gob.cl/dataset/?q=temperatura) mediante web scrapping, unifica todas las fuentes de datos separadas en una sola base de datos de temperaturas, y produce visualizaciones y una [plataforma de visualización interactiva.](https://bastianoleah.shinyapps.io/temperaturas_chile/)


[Accede al visualizador de datos por este enlace.](https://bastianoleah.shinyapps.io/temperaturas_chile/)

El producto principal de este código es una base de datos de temperaturas extremas en Chile, por estación meteorológica y por día, desde 1970 a 2024 [disponible convenientemente en un solo archivo `.csv`](https://github.com/bastianolea/temperaturas_chile/blob/main/datos/procesados/temperaturas_chile_unificadas.csv) (también disponible [en `.rds`](https://github.com/bastianolea/temperaturas_chile/blob/main/datos/procesados/temperaturas_chile_unificadas.rds) y [en formato `.parquet`](https://github.com/bastianolea/temperaturas_chile/blob/main/temperaturas_chile/temperaturas.parquet))

----

Este proyecto parte por dos razones: porque quería reutilizar los datos publicados en la plataforma de Datos Abiertos del Estado (muy recomendable, pero también requiere de muchas mejoras), y porque genuinamente tenía curiosidad sobre la evolución en las temperaturas que estamos viviendo. 

Me tardé solamente la tarde del domingo en hacer el scraping de datos, y parte del domingo y la mañana del lunes en hacer el dashboard. Desarrollar este tipo de proyectos con R es realmente rápido!

Lo otro que quería hacer eran estos gráficos radiales que muestran múltiples años en un anillo de meses. Nunca los había hecho! Quedan muy lindos y son muy fáciles de hacer con {ggplot2}.

Nunca había explorado ni visualizado datos de clima, así que acepto cualquier crítica️! 🥰 

<img style = "border-radius: 7px; width: 100%; max-width: 400px; 
display: block; margin: auto;"
src = "temperaturas_chile_a.jpeg">

<img style = "border-radius: 7px; width: 100%; max-width: 400px; 
display: block; margin: auto;"
src = "temperaturas_chile_b.jpeg">


## Obtención de los datos

Los datos son obtenidos de forma semi-automática usando técnicas de web scrapping con el paquete {RSelenium}. Esto debido a que el portal de datos abiertos no tiene una buena interfaz de usuario (no permite abrir resultados en nuevas pestañas, no permite copiar los enlaces de las fuentes de datos, y hay que actualizar las páginas entre 1 a 8 veces para que muestren los resultados). El script `obtener_temperaturas.R` simplifica tres tareas para obtener los datos: realizar una búsqueda y ampliar la cantidad de resultados mostrados en la página, entrar a cada uno de los enlaces del resultado de la búsqueda, y dentro de los conjuntos de datos, descargar todos los archivos con un solo comando. Esta ahorra muchísimo tiempo, considerando que los datos de temperatura vienen separados por semestre y año, lo que significa que hay que entrar a aproximadamente 16 conjuntos de datos distintos, y dentro de estos conjuntos de datos hay que descargar aproximadamente 6 archivos separados, mientras la plataforma dificulta abrir estos resultados por pestañas.

## Fuentes
- Datos de la Dirección General de Aeronáutica Civil subidos a la plataforma de [Datos Abiertos del Estado](https://datos.gob.cl/dataset/?q=temperatura)
- [Dirección Meteorológica de Chile](https://climatologia.meteochile.gob.cl)
