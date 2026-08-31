---
title: Validación básica de datos con R
author: Bastián Olea Herrera
date: '2025-08-07'
slug: []
freeze: true
categories: []
format:
  hugo-md:
    output-file: index
    output-ext: md
tags:
  - procesamiento de datos
  - consejos
  - automatización
  - control de flujo
  - funciones
  - básico
excerpt: >-
  Si estás procesando muchos datos y/o datos que vienen de distintas fuentes con
  R, validarlos puede ayudarte a encontrar problemas antes de que sea tarde!
  ¿Qué es la validación de datos? Son las distintas pruebas que crearemos para
  confirmar que nuestros datos cumplen ciertos criterios. El objetivo es
  entregarnos la certeza de que nuestros datos son como esperamos luego de
  procesarlos. Para lograrlo, ponemos a prueba nuestros datos en distintos
  puntos de nuestros procesos de análisis de datos.
---


{{< indice >}}

Si estás procesando muchos datos y/o datos que vienen de distintas fuentes con R, validarlos puede ayudarte a encontrar problemas antes de que sea tarde! 😱

¿Qué es la validación de datos? Son las distintas pruebas que crearemos para **confirmar que nuestros datos cumplen ciertos criterios**. El objetivo es entregarnos la **certeza** de que nuestros datos son como esperamos luego de procesarlos. Para lograrlo, ponemos a prueba nuestros datos en distintos puntos de nuestros procesos de análisis de datos.

Por ejemplo: luego de cargar un conjunto de datos a R y realizar una limpieza básica, ¿realmente los datos quedaron como debían quedar?

-   ¿Tenemos datos perdidos en variables donde no esperamos que los hayan?
-   ¿La tabla tiene la cantidad de filas esperadas?
-   En una variable numérica, ¿existen observaciones que se salen del rango esperable? Como años en el futuro, edades imposibles, etc.
-   Las columnas que contienen números, ¿son realmente numéricas, o hay texto en algunas celdas escurridizas?
-   ¿Las variables categóricas o de texto están bien escritas, o vienen cosas repetidas en minúsculas y otras en mayúsculas?
-   ¿Una variable categórica contiene exactamente las categorías posibles, o tiene más o menos que las esperadas?

Éste tipo de revisiones las hacemos generalmente de forma manual mientras exploramos los datos. Pero la idea de la validación de datos es que **formalicemos estas pruebas** para poder **aplicarlas en distintos momentos, y a distintos conjuntos de datos.**

## Validación básica

En el fondo, una validación no es más que evaluar una expresión condicional para ver si se cumple o no se cumple. Creemos un conjunto de datos de prueba:

``` r
library(dplyr)

animales <- tribble(~animal,  ~patas, ~lindura,   ~color,
                    "mapache",     4,      100,   "gris",
                    "gato",       80,       90,  "negro",
                    "gallina",     2,       NA, "plumas")
```

Para validar los datos, puedes usar expresiones `if`s para crear **pruebas que revisan si tus resultados cumplen con criterios mínimos**, como contener ciertas columnas, que no hayan datos perdidos, o lo que necesites.

Creemos una expresión condicional para revisar si es que nuestra tabla de datos tiene **al menos una observación**:

``` r
# validar si el dataframe tiene filas
if (nrow(animales) > 0) {
  message("tabla con filas!")
} else {
  warning("tabla sin filas")
}
```

    tabla con filas!

Con este código confirmamos que los datos cumplen con este criterio mínimo. Si modificamos los datos y probamos de nuevo, la validación nos avisará que hay un problema con los datos:

``` r
# modificar el dataframe y ver si sigue cumpliendo
animales2 <- animales |> filter(patas == 0)

if (nrow(animales2) > 0) {
  message("tabla con filas!")
} else {
  warning("tabla sin filas :(")
}
```

    Warning: tabla sin filas :(

Siguiendo la misma idea, podemos crear otras validaciones para confirmar que los datos vienen como esperamos:

``` r
# revisar que no hayan datos perdidos en columna `lindura`
if (sum(is.na(animales$lindura)) == 0) {
  message("sin datos perdidos en variable `lindura`")
} else {
  stop("datos perdidos en variable `lindura`, ¿acaso demasiada lindura?")
}
```

    Error: datos perdidos en variable `lindura`, ¿acaso demasiada lindura?

``` r
# revisar que variable `patas` no tenga observaciones fuera del rango posible
if (all(between(animales$patas, 2, 8))) {
  message("cantidad de patas aceptable")
} else {
  stop("demasiadas patas!")
}
```

    Error: demasiadas patas!

``` r
# revisar que los valores de `colores` sean válidos
if (all(animales$color %in% c("verde", "negro", "café", "gris", "blanco"))) {
  message("colores aceptables")
} else {
  stop("variable colores tiene datos fuera de lo esperado")
}
```

    Error: variable colores tiene datos fuera de lo esperado

Al ejecutar esta validaciones obtenemos mensajes que nos indican el estado de los datos, o su calidad.

Dentro de las condicionales puedes agregar `warning()` o `message()` para recibir avisos en tu consola dependiendo de lo que se obtiene en cada prueba. También puedes usar `stop()` para que **detener la ejecución** si la validación sale negativa, en el caso de que sea muy importante de resolver el problema con los datos de manera inmediata en vez de continuar con el flujo de procesamiento.

Otra alternativa para crear validaciones es usar la función `stopifnot()`, a la que le entregamos una condición que esperamos que se cumpla, y si no se cumple, la ejecución se detiene:

``` r
stopifnot("valores perdidos" = is.na(animales$lindura))
```

    Error: valores perdidos

La diferencia es que con `stopifnot()` tenemos menos control sobre qué hacer cuando se cumple o no se cumple la condición, y solamente te avisa si es que no se cumple.

## Funciones de validación

El siguiente paso es reunir todas estas pruebas en una sola función, para que puedas reutilizarla en distintas versiones de la tabla, y en distintos conjuntos de datos.

Creamos una función con `function()`, donde el argumento `data` va a representar el conjunto de datos que pasemos a la función.

``` r
revisar <- function(data) {
  
  # prueba de filas
  if (nrow(data) > 0) {
    message("filas ok") 
  } else {
    warning("tabla sin filas")
  }
  
  # prueba de perdidos
  if (any(is.na(data$lindura))) {
    warning("datos perdidos")
  } else {
    message("sin datos perdidos")
  }
  
  # prueba de rangos
  if (all(between(data$patas, 2, 8))) {
    message("rango aceptable")
  } else {
    warning("datos fuera de rango")
  }
  
  # prueba de valores categóricos
  if (all(data$color %in% c("verde", "negro", "café", "rosado", "gris", "blanco"))) {
    message("valores esperados")
  } else {
    warning("valores inesperados")
  }
}
```

Ahora podemos aplicar la función a los datos para validarlos en cualquier momento:

``` r
revisar(animales)
```

    filas ok

    Warning in revisar(animales): datos perdidos

    Warning in revisar(animales): datos fuera de rango

    Warning in revisar(animales): valores inesperados

Podemos corregir los datos y volver a aplicar la validación para confirmar que ahora están correctos:

``` r
# corregir datos luego de las pruebas
animales_3 <- animales |> 
  filter(patas <= 8) |> 
  mutate(color = recode(color, "plumas" = "blanco")) |> 
  mutate(lindura = if_else(is.na(lindura), 0, lindura))

# validar
revisar(animales_3)
```

    filas ok

    sin datos perdidos

    rango aceptable

    valores esperados

Finalmente, podemos volver a aplicar la validación a un conjunto de datos actualizado o una versión distinta de una tabla con las mismas características:

``` r
animales_4 <- tribble(~animal,  ~patas, ~lindura,    ~color,
                      "perro",       4,       50,    "café",
                     "ratita",       3,       99,    "café",
                    "chancho",       4,       70,  "rosado",
                      "araña",       8,     -100,   "negro")

animales_4 |> revisar()
```

    filas ok

    sin datos perdidos

    rango aceptable

    valores esperados

``` r
animales_4 |> filter(lindura > 50) |> revisar()
```

    filas ok

    sin datos perdidos

    rango aceptable

    valores esperados

Estas pequeñas buenas prácticas te van a ayudar a reducir la incertidumbre en rutinas largas de procesamiento de datos!

## Validación avanzada

[El paquete de R `{pointblank}`](https://rstudio.github.io/pointblank/) se especializa en validación de datos, así que si requieres algo más avanzado para garantizar la calidad de tus datos y la estabilidad de tus procesos, [revisa este post con un tutorial!](../../../blog/validacion_datos/)
