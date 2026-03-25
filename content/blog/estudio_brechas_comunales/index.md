---
title: 'Plataforma de visualización de resultados del Estudio de Brechas Comunales'
subtitle: "Medición de brechas de infraestructura y servicios a nivel comunal"
author: Bastián Olea Herrera
date: '2026-03-24'
slug: []
categories:
  - Tutoriales
  - Aplicaciones
tags:
  - chile
  - datos
  - apps
  - blog
  - Quarto
  - shiny
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: link
    icon_pack: fas
    name: Plataforma
    url: https://www.descentralizachile.cl/ebc/
excerpt: "Ya está disponible la plataforma de visualización de los resultados del Estudio de Brechas Comunales de la Subsecretaría de Desarrollo Regional y Administrativo (Subdere). Este proyecto fue desarrollado íntegramente en R, al igual que la plataforma interactiva.

Este estudio mide brechas en infraestructura y servicios a través de 59 indicadores de nivel comunal, tomando en consideración las diferencias territoriales de comunas urbanas, mixtas y rurales."
---

{{< imagen_tamaño "ebc_0.jpeg" "300px" >}}
{{< bajada "Inicio de la plataforma del EBC" >}}

{{< imagen_lateral "ebc_1.jpeg" "160px">}}


Ya está disponible la [plataforma de visualización](https://www.descentralizachile.cl/ebc/) de los resultados del **Estudio de Brechas Comunales** de la Subsecretaría de Desarrollo Regional y Administrativo (Subdere).

Este estudio mide **brechas en infraestructura y servicios** a través de **59 indicadores** de nivel **comunal**, tomando en consideración las **diferencias territoriales** de comunas urbanas, mixtas y rurales.

Trabajamos con **24 instituciones públicas** para obtener datos públicos de calidad y determinar en conjunto los umbrales que definen las situaciones de brecha o ausencia de brecha para cada indicador. 



Nos enorgullece poder hacer público un instrumento que aporta en la evaluación de la calidad de vida de las y los chilenos, aportando a una mejor planificación e inversión pública!


## Desarrollo del estudio

{{< imagen_lateral "ebc_2.jpeg" "160px" >}}

Todos los datos del estudio fueron procesados en R, y la [plataforma interactiva](https://www.descentralizachile.cl/ebc/) también fue desarrollada en R.

**Desarrollar este proyecto en R** significó un aumento de la velocidad de trabajo importante, pero también un enorme **ahorro de fondos públicos** al no necesitar licitar el estudio a una empresa externa.


### Plataforma interactiva
La **plataforma** fue desarrollada en Shiny _en no más de 2 semanas_, gracias a la facilidad de desarrollo que ofrece dicho paquete, y el hecho de que las visualizaciones y mapas ya habían sido programados en R para otros aspectos del estudio, por lo que fue cosa de tomar el código y pasarlo a la aplicación. La plataforma misma está alojada en un servidor de Subdere, dentro de un contenedor Docker.

### Gráficos y tablas

{{< imagen_lateral "ebc_3.jpeg" "160px" >}}

Todas las **visualizaciones de datos** del [informe de resultados del Estudio](https://proactiva.subdere.gov.cl/handle/123456789/679) también fueron desarrolladas en R, lo que entregó la conveniencia de poder ir actualizando y corrigiendo los datos sin que ésto signifique volver a hacer los gráficos. Esto significa que el proyecto pudo avanzar más rápido, dado que ante cualquier actualización de datos, los gráficos se regeneraban sin costo alguno de tiempo ni trabajo. Las **tablas y cuadros** del estudio también fueron hechas en R, con los mismos beneficios mencionados.

### Reportes
Al producir los resultados del estudio, resultaba crucial poder disponibilizar reportes breves de **resultados para cada comuna del país**. Este trabajo se optimizó generando los reportes con Quarto y R, lo que permitió diseñar un sólo reporte y programar la presentación de sus resultados, para luego **replicar automáticamente 345 reportes** sin tener que hacerlos a mano.

{{< imagen_alto "reporte_ebc_subdere.jpg" "340px" >}}
{{< bajada "Reporte comunal descargable" >}}

Pronto liberaremos el código del procesamiento de datos y de la plataforma!

