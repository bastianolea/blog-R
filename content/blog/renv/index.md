---
title: Proyectos de R reproducibles y estables con `{renv}`
author: Bastián Olea Herrera
date: '2026-08-31'
draft: true
freeze: true
categories:
  - Tutoriales
tags:
  - consejos
  - avanzado
  - reproducibilidad
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: registered
    icon_pack: fas
    name: renv
    url: https://rstudio.github.io/renv/
---


Taller [proyectos reproducibles con renv](https://paocorrales.github.io/intro-renv/), impartido por [Pao Corrales](https://paocorrales.github.io) en el marco de [Research Software Latinoamérica (RSLA26)](https://rs-latam.org).

[proyectos de RStudio](https://r4ds.hadley.nz/workflow-scripts.html#projects)

``` r
install.packages("renv")
renv::init()
renv::status()
renv::snapshot()
renv::restore()
```

Inicializar

``` r
renv::init()
```

- `renv.lock`
- `renv/library`
- `.Rprofile`

Instalar paquetes
`renv::install()` -\> `renv::snapshot()`

Actualizar paquetes
`renv::update()`

Desactivar `renv`

`renv::deactivate()`

## Recursos

- [Introducción a `renv`](https://rstudio.github.io/renv/articles/renv.html)
- Taller [proyectos reproducibles con renv](https://paocorrales.github.io/intro-renv/), impartido por [Pao Corrales](https://paocorrales.github.io)
