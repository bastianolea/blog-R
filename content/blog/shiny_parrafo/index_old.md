---
title: index_old
format: html
---


## Párrafos de texto con cifras

Antes de hacer cualquier aplicación Shiny, **recomiendo probar la lógica** en un script normal de R. Así que intentemos hacer un [párrafo de prueba a partir de cifras y pseudofiltros, como ya hemos visto antes](../../../blog/redactar_texto) en este blog.

Primero cargamos los datos de pobreza, [procesados en este repositorio](https://github.com/bastianolea/pobreza_2024), y que puedes [descargar en CSV en este enlace.](%22/blog/shiny_parrafo/datos/pobreza_ingresos_2024.csv)

``` r
library(dplyr)
library(readr)

pobreza <- read_csv("datos/pobreza_ingresos_2024.csv")

glimpse(pobreza)
```

    Rows: 345
    Columns: 13
    $ codigo_region                              <dbl> 1, 1, 1, 1, 1, 1, 1, 2, 2, …
    $ nombre_region                              <chr> "Tarapacá", "Tarapacá", "Ta…
    $ codigo_provincia                           <dbl> 11, 11, 14, 14, 14, 14, 14,…
    $ nombre_provincia                           <chr> "Iquique", "Iquique", "Tama…
    $ codigo_comuna                              <dbl> 1101, 1107, 1401, 1402, 140…
    $ nombre_comuna                              <chr> "Iquique", "Alto Hospicio",…
    $ poblacion                                  <dbl> 232455, 144554, 18811, 1376…
    $ pobreza_personas                           <dbl> 37598.53680, 38759.77379, 3…
    $ pobreza_porcentaje                         <dbl> 0.16174544, 0.26813353, 0.2…
    $ pobreza_porcentaje_inf                     <dbl> 0.14786508, 0.24479813, 0.1…
    $ pobreza_porcentaje_sup                     <dbl> 0.1756258, 0.2914689, 0.260…
    $ presencia_de_la_comuna_en_la_muestra_casen <chr> "Sí", "Sí", "Sí", "Sí", "Sí…
    $ tipo_de_estimacion_sae                     <chr> "Directa y Sintética (Fay-H…

Ahora hacemos un filtro de cualquier comuna de Chile:

``` r
pobreza_comuna <- pobreza |> 
  filter(nombre_comuna == "Puente Alto")

pobreza_comuna
```

    # A tibble: 1 × 13
      codigo_region nombre_region    codigo_provincia nombre_provincia codigo_comuna
              <dbl> <chr>                       <dbl> <chr>                    <dbl>
    1            13 Metropolitana d…              132 Cordillera               13201
    # ℹ 8 more variables: nombre_comuna <chr>, poblacion <dbl>,
    #   pobreza_personas <dbl>, pobreza_porcentaje <dbl>,
    #   pobreza_porcentaje_inf <dbl>, pobreza_porcentaje_sup <dbl>,
    #   presencia_de_la_comuna_en_la_muestra_casen <chr>,
    #   tipo_de_estimacion_sae <chr>

Usando el paquete `{glue}`, redactamos una frase de apertura usando los datos:

``` r
library(glue)

glue("En la comuna de {pobreza_comuna$nombre_comuna}...")
```

    En la comuna de Puente Alto...

Como el filtro retorna una fila, redactar el texto no tiene complicaciones.

Ahora sacamos la cifra del porcentaje de pobreza (`pobreza_porcentaje`) y la formateamos con `{scales}`:

``` r
library(scales)

porcentaje <- label_percent(accuracy = 1)(pobreza_comuna$pobreza_porcentaje)

glue("el porcentaje de pobreza es de {porcentaje}")
```

    el porcentaje de pobreza es de 14%

Finalmente, hacemos lo mismo con la cantidad de personas:

``` r
cantidad <- label_number(accuracy = 1, big.mark = ".", decimal.mark = ",")(pobreza_comuna$pobreza_personas)

glue("lo que equivale a {cantidad} personas")
```

    lo que equivale a 92.515 personas

Ahora, armemos el párrafo completo, para redondear el ejemplo:

``` r
glue("En la comuna de {pobreza_comuna$nombre_comuna}, el porcentaje de pobreza es de {porcentaje}, lo que equivale a {cantidad} personas.")
```

    En la comuna de Puente Alto, el porcentaje de pobreza es de 14%, lo que equivale a 92.515 personas.

Ahora pasemos a un ejemplo más complejo, acercándonos a nuestra idea de aplicación interactiva. Esta vez, se podrá elegir el nivel territorial (comuna o región), y a partir de esta elección, se elegirá un territorio al azar. Para esto, usaremos el paquete de R `{territorial}`, que incluye las funciones `comunas()` y `regiones()` para extraer los valores al azar usando `sample()`:

``` r
library(territorial)

# nivel <- "región"
nivel <- "comuna"

# elegir territorio al azar, ya sea comuna o región
if (nivel == "comuna") {
  territorio <- sample(comunas(), 1)
} else if (nivel == "región") {
  territorio <- sample(regiones(), 1)
}

territorio
```

    [1] "Molina"

Prueba el código anterior y verás que cada vez sale un territorio distinto! Recuerca cambiar el `nivel` para que salgan comunas o regiones.

Ahora nos enfrentamos a un desafío nuevo. En el caso anterior salió la comuna de Molina, pero si cambiamos `nivel`, sale una región. Tenemos que distinguir entre ambas para redactar correctamente el párrafo con la preposición `de` para las comunas, y la preposición que corresponda a la región que salga. Para esto [usamos la función `preposicion_region()`](https://bastianolea.github.io/territorial/reference/preposicion_region.html) del [paquete `{territorial}`.](https://bastianolea.github.io/territorial/)

``` r
# determinar preposición (comuna "de", región "de"/"del")
preposicion <- case_when(
  nivel == "comuna" ~ "de",
  nivel == "región" ~ territorial::preposicion_region(territorio)
)

# generar texto
glue("En la {nivel} {preposicion} {territorio}")
```

    En la comuna de Molina

Si ejecutas el código de arriba pero cambias `nivel` a `"región"`, obtendrás una región al azar, y `preposicion_region()` se encarga de anteponer la preposición correcta; por ejemplo:

``` r
preposicion_region("Maule")
```

    [1] "del"

``` r
preposicion_region("Ñuble")
```

    [1] "de"

Luego pasamos a los datos. Como podemos elegir entre comunas y regiones, la comuna se obtiene simplemente filtrando, y la región requiere de un filtro y luego una suma de todas las filas para obtener el total regional:

``` r
if (nivel == "comuna") {
  # filtrar si es comuna
  pobreza_filtro <- pobreza |> 
    filter(nombre_comuna == territorio)
  
} else if (nivel == "región") {
  # filtrar y sumar si es región
  pobreza_filtro <- pobreza |> 
    filter(nombre_region == territorio) |> 
    summarize(pobreza_personas = sum(pobreza_personas))
}

pobreza_filtro
```

    # A tibble: 1 × 13
      codigo_region nombre_region codigo_provincia nombre_provincia codigo_comuna
              <dbl> <chr>                    <dbl> <chr>                    <dbl>
    1             7 Maule                       73 Curicó                    7304
    # ℹ 8 more variables: nombre_comuna <chr>, poblacion <dbl>,
    #   pobreza_personas <dbl>, pobreza_porcentaje <dbl>,
    #   pobreza_porcentaje_inf <dbl>, pobreza_porcentaje_sup <dbl>,
    #   presencia_de_la_comuna_en_la_muestra_casen <chr>,
    #   tipo_de_estimacion_sae <chr>

Ahora, igual que antes, redactamos la cifra correspondiente:

``` r
cantidad <- label_number(accuracy = 1, big.mark = ".", decimal.mark = ",")(pobreza_filtro$pobreza_personas)

glue("la cantidad de personas en situación de pobreza es de ~{cantidad} habitantes")
```

    la cantidad de personas en situación de pobreza es de ~11.530 habitantes

Tenemos las partes necesarias! Ahora recapitulemos con el código completo:

``` r
library(territorial)

nivel <- "región"
# nivel <- "comuna"

# elegir territorio al azar, ya sea comuna o región
if (nivel == "comuna") {
  territorio <- sample(comunas(), 1)
  
} else if (nivel == "región") {
  territorio <- sample(regiones(), 1)
}

# determinar preposición (comuna "de", región "de"/"del")
preposicion <- case_when(
  nivel == "comuna" ~ "de",
  nivel == "región" ~ territorial::preposicion_region(territorio)
)

# filtrar territorio y sumar si es región
if (nivel == "comuna") {
  # filtrar si es comuna
  pobreza_filtro <- pobreza |> 
    filter(nombre_comuna == territorio)
  
} else if (nivel == "región") {
  # filtrar y sumar si es región
  pobreza_filtro <- pobreza |> 
    filter(nombre_region == territorio) |> 
    summarize(pobreza_personas = sum(pobreza_personas))
}

# si es comuna, agregarle la región donde se ubica
if (nivel == "comuna") {
  region <- ubicar_comunas(territorio)
  territorio <- glue("{territorio}, {redactar_region(region)}")
}

# formatear cantidad con separador de miles
cantidad <- label_number(accuracy = 1, big.mark = ".", decimal.mark = ",")(pobreza_filtro$pobreza_personas)

# generar texto
glue("En la {nivel} {preposicion} {territorio}, la cantidad de personas en situación de pobreza es de aproximadamente {cantidad} habitantes.")
```

    En la región de Arica y Parinacota, la cantidad de personas en situación de pobreza es de aproximadamente 56.146 habitantes.

Si lo ejecutamos de nuevo, obtenemos otro párrafo redactado:

    En la comuna de Navidad, Región del Libertador General Bernardo O'Higgins, la cantidad de personas en situación de pobreza es de aproximadamente. 1.535 habitantes.

    En la comuna de Hualqui, Región del Biobío, la cantidad de personas en situación de pobreza es de aproximadamente 6.085 habitantes.

Código como el anterior se podría usar para automatizar la redacción de un reporte, los textos de bajada de una tabla o de un gráfico, o para aplicaciones interactivas de exploración de datos!

{{< relacionada "/blog/redactar_texto" >}}
