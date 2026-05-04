---
title: Creando una función para consultar datos en R
author: Bastián Olea Herrera
date: '2026-05-02'
draft: true
tags:
  - datos
  - chile
  - funciones
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: file-code
    icon_pack: fas
    name: Código
    url: https://github.com/bastianolea/censo_poblacion_consultar
---

En R es muy fácil filtrar y seleccionar cualquier base de datos para obtener las cifras que quieras

Por ejemplo, si queremos saber la población de una comuna, cargamos el Censo 2024, filtramos la comuna con `filter()`, luego agrupamos por comuna con `group_by()` y finalmente sumamos las observaciones con `summarize()` para obtener la población:


``` r
library(arrow)
censo <- open_dataset("~/Documents/Datos/Censo/2024/personas_censo2024.parquet")
```


``` r
library(arrow)

# cargar censo
censo <- open_dataset("personas_censo2024.parquet")
```


``` r
library(dplyr)

censo |> 
  filter(comuna == 13110) |> 
  group_by(comuna) |> 
  summarize(poblacion = n()) |> 
  collect()
```

```
## # A tibble: 1 × 2
##   comuna poblacion
##    <int>     <int>
## 1  13110    374836
```

Así obtuvimos la población de La Florida (había que saberse o buscar el código único territorial eso sí).

Ahora, si queremos la población por **sexo**, cambiamos la agrupación para hacer el conteo de observaciones por comuna y sexo:


``` r
censo |> 
  filter(comuna == 13110) |> 
  group_by(comuna, sexo) |> 
  summarize(poblacion = n()) |> 
  collect()
```

```
## # A tibble: 2 × 3
## # Groups:   comuna [1]
##   comuna  sexo poblacion
##    <int> <int>     <int>
## 1  13110     2    196375
## 2  13110     1    178461
```

Luego, si quieres lo mismo pero para otra comuna, copias el código y cambias el filtro, y así.

{{< relacionada "/blog/censo_2024/" "Tutorial para trabajar con el Censo" >}}

Pero si necesitamos hacer esto muy seguido, de repente es mejor optimizarlo. [Como dijo Dios en la biblia](https://es.r4ds.hadley.nz/19-functions.html#cuándo-deberías-escribir-una-función): 

> Deberías considerar escribir una función cuando has copiado y pegado un bloque de código más de dos veces.

<p style="text-align: right; margin-top: -6px; font-style: italic;">Hadley Wickham</p>

Alabado sea [Hadley](https://hadley.nz) 🙏🏼

[Crear una función](/blog/r_introduccion/r_intermedio/#crear-funciones) permite que ejecutemos un conjunto de operaciones de forma más simple, al **abstraer el código** en un único comando que es más rápido y cómodo de usar.

Las funciones también nos ayudan a **reutilizar** el código al empaquetarlo en una forma más conveniente.

{{< relacionada "/blog/r_introduccion/r_intermedio/" "Aprende a hacer funciones" >}}




Función para consultar la población de comunas, regiones, provincias o país según resultados del Censo 2024.

Diseñada para registrarla como herramienta para LLMs y así hacer que la IA pueda consultar datos de población censal.



{{< relacionada "/blog/mapas_censo_2024/" >}}

{{< relacionada "/blog/herramientas_llm/" >}}

{{< etiqueta "datos" >}}


