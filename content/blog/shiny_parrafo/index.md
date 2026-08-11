---
title: Párrafos interactivos
author: Bastián Olea Herrera
date: '2026-08-11'
slug: []
draft: true
categories: []
tags:
  - shiny
format:
  hugo-md:
    output-file: index
    output-ext: md
---


A veces, para explorar los datos no se necesitan gráficos sofisticados, mapas o dashboards complejos. Acá hice un prototipo de un "párrafo interactivo", donde las variables en la oración pueden cambiarse, y las cifras reflejan los resultados automáticamente.
Además fíjense que las palabras se adaptan a su contexto: al género gramatical de las variables ("el" banco, "la" farmacia), y a las preposiciones de las regiones (región "del" Maule, región "de" Los Lagos) gracias a la función preposicion_region() del paquete de R {territorial}.
El resultado es siempre un párrafo coherente que combina los controles con los resultados!

<iframe src="https://www.linkedin.com/embed/feed/update/urn:li:ugcPost:7492986395066535936?compact=1" height="399" width="100%" frameborder="0" allowfullscreen title="Publicación integrada">
</iframe>
