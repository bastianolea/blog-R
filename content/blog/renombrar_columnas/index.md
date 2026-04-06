---
title: Limpiar nombres de columnas con R
author: Bastián Olea Herrera
date: '2026-04-06'
draft: true
slug: []
categories: []
tags:
  - limpieza de datos
format:
  hugo-md:
    output-file: index
    output-ext: md
---


``` r
library(tidyverse)

# Pasar todo a minúsculas
datos |> rename_with(tolower)

# Reemplazar espacios por guiones bajos
datos |> rename_with(~ str_replace_all(.x, " ", "_"))

# Solo en columnas numéricas
datos |> rename_with(~ paste0("num_", .x), where(is.numeric))

Súper útil cuando importás datos con nombres desprolijos (planillas de Excel, te estoy mirando a vos 👀).

rename_with() + funciones de {stringr} = nombres de columnas prolijos en una línea.
```

<iframe src="https://www.linkedin.com/embed/feed/update/urn:li:share:7440126432518770688?collapsed=1" height="262" width="504" frameborder="0" allowfullscreen title="Publicación integrada">
</iframe>
