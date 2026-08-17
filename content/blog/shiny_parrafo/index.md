---
title: Párrafos de texto con cifras interactivos en aplicaciones Shiny
subtitle: Combinando exploración de datos con comunicación de resultados
author: Bastián Olea Herrera
date: '2026-08-13'
slug: []
draft: true
categories:
  - Aplicaciones
tags:
  - shiny
  - texto
  - automatización
format:
  hugo-md:
    mermaid:
      theme: base
links:
  - icon: file-code
    icon_pack: fas
    name: Código
    url: https://github.com/bastianolea/shiny_parrafo_interactivo
  - icon: file
    icon_pack: fas
    name: datos
    url: https://github.com/bastianolea/pobreza_2024
---


<meta name="mermaid-theme" content="base"/>
<script  src="index_files/libs/quarto-diagram/mermaid.min.js"></script>
<script  src="index_files/libs/quarto-diagram/mermaid-init.js"></script>
<link  href="index_files/libs/quarto-diagram/mermaid.css" rel="stylesheet" />

A veces, para explorar datos no se necesitan gráficos sofisticados, mapas o *dashboards* complejos. Se me ocurrió probar un formato distinto: un "párrafo interactivo", también conocidos como [*filtros legibles* o *human readable filters*](https://www.appsilon.com/post/human-readable-filters), donde las variables de la oración se pueden cambiar con *inputs*, y las cifras del texto se actualizan automáticamente según lo que la persona elija.

La idea es combinar la **exploración** de datos con la **comunicación** de resultados: en vez de mostrar un gráfico y dejar que cada persona interprete lo que ve, el párrafo entrega directamente una lectura en palabras, pero deja que la persona explore distintos escenarios cambiando los controles.

<iframe src="https://www.linkedin.com/embed/feed/update/urn:li:ugcPost:7492986395066535936?compact=1" height="399" width="100%" frameborder="0" allowfullscreen title="Publicación integrada">
</iframe>

El ejemplo que voy a mostrar en esta publicación usa [datos de pobreza comunal 2024](https://bidat.gob.cl/details/ficha/dataset/base-de-datos-pobreza-comunal-2024) del Ministerio de Desarrollo Social y Familia, [procesados con R en este repositorio](https://github.com/bastianolea/pobreza_2024).

Primero veremos un ejemplo de [párrafos interactivos con R](../../../blog/redactar_texto/), y luego veremos cómo hacerlo en una [aplicación web interactiva Shiny.](../../../blog/shiny/)

## Párrafos de texto con cifras

Antes de hacer cualquier aplicación Shiny, **recomiendo probar la lógica** en un script normal de R. Así que intentemos hacer un párrafo de prueba.

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

{{< relacionada "blog/redactar_texto" >}}

## Interfaz: armando el párrafo

Se elige un territorio (Chile completo o una región), si se quiere ver porcentaje o cantidad de personas, y un umbral de pobreza, y el párrafo indica cuántas comunas superan ese umbral y a cuántas personas en situación de pobreza corresponde esa cifra. Puedes ver el [código completo del ejemplo en este repositorio.](https://github.com/bastianolea/shiny_parrafo_interactivo)

Algo que me pareció importante fue que las palabras se adaptaran gramaticalmente a lo que la persona va eligiendo: por ejemplo, si elige "la cantidad" en vez de "el porcentaje", el artículo que sigue más adelante en la oración también cambia ("el" umbral versus "las" personas). Y si elige ver una región en particular, la preposición correspondiente se ajusta a esa región (región "del" Maule, región "de" Los Lagos, etc.) gracias a la función `preposicion_region()` del paquete de R [`{territorial}`](../../../blog/territorial/), que armé justamente para facilitar este tipo de detalles al trabajar con nombres de comunas y regiones de Chile.

### Paquetes y datos

Empezamos cargando los paquetes que necesitamos. Además de `{shiny}` y `{bslib}` para la interfaz, usamos `{shinyjs}` para mostrar y ocultar elementos, `{scales}` para formatear números, y `{territorial}` para la concordancia gramatical de las regiones:

``` r
library(shiny)
library(shinyjs)
library(bslib)
library(dplyr)
library(scales)
library(territorial)

# cargar datos
pobreza <- readr::read_csv("datos/pobreza_ingresos_2024.csv")

# formato de números
number_options(big.mark = ".", decimal.mark = ",")
```

`number_options()` fija de una vez el formato de los números (punto para miles, coma para decimales) para toda la sesión, así no hay que repetirlo cada vez que formateemos una cifra.

### Título y tema

La interfaz parte con lo básico: `page_fillable()`, un tema simple con `{bslib}`, y un CSS aparte que vamos a usar más adelante para que los selectores se vean como parte del texto:

``` r
ui <- page_fillable(
  lang = "es",
  includeCSS("estilos.css"),
  useShinyjs(),
  
  theme = bs_theme(
    fg = "#0C2635",
    bg = "white",
    "line-height-base" = 1.3
  ),
  
  h1("Párrafo interactivo",
     style = "margin-bottom: -1rem;"),
  em("Bastián Olea Herrera")
)
```

`useShinyjs()` habilita las funciones `show()` y `hide()` que vamos a usar para hacer aparecer y desaparecer partes del párrafo dependiendo de las elecciones de la persona.

### Territorio: Chile o una región

El párrafo mismo es un solo `div()` con clase `parrafo`, que mezcla texto fijo con *inputs* y salidas. Empezamos con el primer selector, que elige entre "Chile" y "Región":

``` r
ui <- page_fillable(
  lang = "es",
  includeCSS("estilos.css"),
  useShinyjs(),
  
  theme = bs_theme(
    fg = "#0C2635",
    bg = "white",
    "line-height-base" = 1.3
  ),
  
  h1("Párrafo interactivo",
     style = "margin-bottom: -1rem;"),
  em("Bastián Olea Herrera"),
  
  div(
    class = "parrafo",
    
    "En",
    
    selectInput(
      "parrafo_territorio",
      label = NULL,
      c("Chile", "Región")
    )
  )
)
```

De aquí en adelante nos vamos a enfocar solo en el contenido del `div()`, porque el resto de la `ui` no vuelve a cambiar.

### Preposición y selector de región

Si la persona elige "Región", necesitamos dos cosas más: la preposición "la" antes del selector de territorio (para que diga "en la Región"), y un segundo selector con las regiones, además de la preposición correspondiente a la región elegida ("de" Los Lagos, "del" Maule). Ambas partes parten **ocultas** con `hidden()`, porque solo se muestran cuando corresponde:

\`\`\`r {hl_lines=\["4-6", "14-25"\]}
div(
class = "parrafo",

"En",

\# preposición "la" solamente aparece si se elige "Región"
span("la", id = "parrafo_preposicion_territorio") \|\> hidden(),

selectInput(
"parrafo_territorio",
label = NULL,
c("Chile", "Región")
),

\# preposición de la región depende de la región elegida
textOutput("parrafo_preposicion_region", inline = TRUE) \|\> hidden(),

\# selector de regiones
selectInput(
"parrafo_selector_region",
label = NULL,
choices = regiones()
) \|\>
hidden(),

"existen"
)


    `regiones()` es otra función de `{territorial}` que entrega el listado de las 16 regiones de Chile, ya ordenadas y con el nombre correcto para usar como opciones de un `selectInput()`.

    {{< detalles "Código completo del div hasta ahora" >}}

    ```r
    div(
      class = "parrafo",
      
      "En",
      
      # preposición "la" solamente aparece si se elige "Región"
      span("la", id = "parrafo_preposicion_territorio") |> hidden(),
      
      selectInput(
        "parrafo_territorio",
        label = NULL,
        c("Chile", "Región")
      ),
      
      # preposición de la región depende de la región elegida
      textOutput("parrafo_preposicion_region", inline = TRUE) |> hidden(),
      
      # selector de regiones
      selectInput(
        "parrafo_selector_region",
        label = NULL,
        choices = regiones()
      ) |>
        hidden(),
      
      "existen"
    )

{{< /detalles >}}

### Cantidad de comunas y umbral

Sigue la cifra principal (cantidad de comunas, envuelta en `strong()` para destacarla):

``` r
div(
# ...
"existen",

strong(
textOutput("parrafo_n_comunas", inline = TRUE),
"comunas"
),

"donde",

"de personas en situación de pobreza supera"
)
```

{{< detalles "Código completo del div hasta ahora" >}}

``` r
div(
class = "parrafo",

"En",

span("la", id = "parrafo_preposicion_territorio") |> hidden(),

selectInput(
"parrafo_territorio",
label = NULL,
c("Chile", "Región")
),

textOutput("parrafo_preposicion_region", inline = TRUE) |> hidden(),

selectInput(
"parrafo_selector_region",
label = NULL,
choices = regiones()
) |>
hidden(),

"existen",

strong(
textOutput("parrafo_n_comunas", inline = TRUE),
"comunas"
),

"donde",

"de personas en situación de pobreza supera"
)
```

{{< /detalles >}}

### Umbral y cifra final

Terminamos el párrafo con el umbral elegido, antepuesto por el artículo "las" (porque siempre se trata de personas), y la cantidad de personas que corresponde a ese filtro:

``` r
div(
# ...
"de personas en situación de pobreza supera",

"las",

selectInput(
"parrafo_umbral",
label = NULL,
choices = c(
"1.000" = 1000, "2.000" = 2000, "5.000" = 5000,
"10.000" = 10000, "25.000" = 25000, "50.000" = 50000
),
selected = 5000
),

", lo que corresponde a aproximadamente",

strong(
textOutput("parrafo_n_personas", inline = TRUE),
"personas"
),
"en situación de pobreza."
)
```

El `selectInput()` del umbral trae las opciones de cantidad de personas directamente, porque el umbral es siempre un número de personas en situación de pobreza.

{{< detalles "Código completo del div hasta ahora" >}}

``` r
div(
class = "parrafo",

"En",

span("la", id = "parrafo_preposicion_territorio") |> hidden(),

selectInput(
"parrafo_territorio",
label = NULL,
c("Chile", "Región")
),

textOutput("parrafo_preposicion_region", inline = TRUE) |> hidden(),

selectInput(
"parrafo_selector_region",
label = NULL,
choices = regiones()
) |>
hidden(),

"existen",

strong(
textOutput("parrafo_n_comunas", inline = TRUE),
"comunas"
),

"donde",

"de personas en situación de pobreza supera",

"las",

selectInput(
"parrafo_umbral",
label = NULL,
choices = c(
"1.000" = 1000, "2.000" = 2000, "5.000" = 5000,
"10.000" = 10000, "25.000" = 25000, "50.000" = 50000
),
selected = 5000
),

", lo que corresponde a aproximadamente",

strong(
textOutput("parrafo_n_personas", inline = TRUE),
"personas"
),
"en situación de pobreza."
)
```

{{< /detalles >}}

### Tabla opcional

Por último, afuera del párrafo, agregamos un `checkboxInput()` y una `card()` oculta con la tabla de detalle:

``` r
ui <- page_fillable(
# ...
div(
class = "parrafo",
# ...
),

checkboxInput("mostrar_tabla", "Mostrar tabla", value = FALSE),
card(
id = "tabla_card",
tableOutput("parrafo_tabla")
) |>
hidden()
)
```

{{< detalles "Código completo de la interfaz" >}}

``` r
ui <- page_fillable(
lang = "es",
includeCSS("estilos.css"),
useShinyjs(),

theme = bs_theme(
fg = "#0C2635",
bg = "white",
"line-height-base" = 1.3
),

h1("Párrafo interactivo",
style = "margin-bottom: -1rem;"),
em("Bastián Olea Herrera"),

div(
class = "parrafo",

"En",

span("la", id = "parrafo_preposicion_territorio") |> hidden(),

selectInput(
"parrafo_territorio",
label = NULL,
c("Chile", "Región")
),

textOutput("parrafo_preposicion_region", inline = TRUE) |> hidden(),

selectInput(
"parrafo_selector_region",
label = NULL,
choices = regiones()
) |>
hidden(),

"existen",

strong(
textOutput("parrafo_n_comunas", inline = TRUE),
"comunas"
),

"donde",

"de personas en situación de pobreza supera",

"las",

selectInput(
"parrafo_umbral",
label = NULL,
choices = c(
"1.000" = 1000, "2.000" = 2000, "5.000" = 5000,
"10.000" = 10000, "25.000" = 25000, "50.000" = 50000
),
selected = 5000
),

", lo que corresponde a aproximadamente",

strong(
textOutput("parrafo_n_personas", inline = TRUE),
"personas"
),
"en situación de pobreza."
),

checkboxInput("mostrar_tabla", "Mostrar tabla", value = FALSE),
card(
id = "tabla_card",
tableOutput("parrafo_tabla")
) |>
hidden()
)
```

{{< /detalles >}}

Con esto, la interfaz completa está lista. Ahora falta la parte más importante: conectar todos estos *inputs* y *outputs* en el servidor.

## Servidor: conectando inputs, renders y outputs

El servidor es donde ocurre toda la reactividad: qué se muestra u oculta, cómo se filtran los datos, y qué texto se calcula para cada salida. Vamos a ir agregando una pieza a la vez, mostrando después de cada una un diagrama con las conexiones que se generan.

### Mostrar y ocultar la tabla

Lo más simple: un `observeEvent()` que reacciona al *checkbox*, mostrando u ocultando la tarjeta con la tabla:

``` r
server <- function(input, output, session) {
# mostrar/ocultar tabla según checkbox
observeEvent(input$mostrar_tabla, {
if (input$mostrar_tabla) {
show("tabla_card")
} else {
hide("tabla_card")
}
})
}
```

<figure class=''>

<pre class="mermaid mermaid-js">graph LR
mostrar_tabla[&quot;input$mostrar_tabla&quot;]:::input
obs[&quot;observeEvent&quot;]:::observer
tabla_card[&quot;tabla_card&lt;br&gt;(show/hide)&quot;]:::output

mostrar_tabla --&gt; obs --&gt; tabla_card
</pre>

</figure>

### Concordancia del territorio

Cuando la persona elige "Región" en vez de "Chile", tenemos que mostrar la preposición "la" y, además, el selector de región junto a su propia preposición. Son dos `observe()` porque son dos partes de la interfaz que reaccionan a la misma elección:

``` r
server <- function(input, output, session) {
# mostrar/ocultar tabla según checkbox
observeEvent(input$mostrar_tabla, {
if (input$mostrar_tabla) {
show("tabla_card")
} else {
hide("tabla_card")
}
})

# artículo de territorio ("la")
observe({
if (input$parrafo_territorio == "Región") {
show("parrafo_preposicion_territorio")
} else {
hide("parrafo_preposicion_territorio")
}
})

# selector de regiones precedida por su preposición
observe({
if (input$parrafo_territorio == "Región") {
show("parrafo_selector_region")
show("parrafo_preposicion_region")
} else {
hide("parrafo_selector_region")
hide("parrafo_preposicion_region")
}
})
}
```

<figure class=''>

<pre class="mermaid mermaid-js">graph LR
territorio[&quot;input$parrafo_territorio&quot;]:::input
obs1[&quot;observe: preposición&lt;br&gt;de territorio&quot;]:::observer
obs2[&quot;observe: selector&lt;br&gt;y preposición de región&quot;]:::observer
prep_territorio[&quot;parrafo_preposicion_territorio&lt;br&gt;(show/hide)&quot;]:::output
selector_region[&quot;parrafo_selector_region&lt;br&gt;(show/hide)&quot;]:::output
prep_region[&quot;parrafo_preposicion_region&lt;br&gt;(show/hide)&quot;]:::output

territorio --&gt; obs1 --&gt; prep_territorio
territorio --&gt; obs2
obs2 --&gt; selector_region
obs2 --&gt; prep_region
</pre>

</figure>

### Preposición de la región elegida

Ahora que el selector de región es visible, necesitamos calcular qué preposición corresponde a la región que se eligió. Acá es donde entra `preposicion_region()` de `{territorial}`:

``` r
server <- function(input, output, session) {
# ...

# preposición de la región elegida
output$parrafo_preposicion_region <- renderText({
preposicion_region(input$parrafo_selector_region)
})
}
```

<figure class=''>

<pre class="mermaid mermaid-js">graph LR
region[&quot;input$parrafo_selector_region&quot;]
render[&quot;renderText:&lt;br&gt;preposicion_region()&quot;]
output[&quot;parrafo_preposicion_region&quot;]

region --&gt; render --&gt; output
</pre>

</figure>

{{< detalles "Código completo del servidor hasta ahora" >}}

``` r
server <- function(input, output, session) {
# mostrar/ocultar tabla según checkbox
observeEvent(input$mostrar_tabla, {
if (input$mostrar_tabla) {
show("tabla_card")
} else {
hide("tabla_card")
}
})

# artículo de territorio ("la")
observe({
if (input$parrafo_territorio == "Región") {
show("parrafo_preposicion_territorio")
} else {
hide("parrafo_preposicion_territorio")
}
})

# selector de regiones precedida por su preposición
observe({
if (input$parrafo_territorio == "Región") {
show("parrafo_selector_region")
show("parrafo_preposicion_region")
} else {
hide("parrafo_selector_region")
hide("parrafo_preposicion_region")
}
})

# preposición de la región elegida
output$parrafo_preposicion_region <- renderText({
preposicion_region(input$parrafo_selector_region)
})
}
```

{{< /detalles >}}

### Umbral de personas

Como el umbral es siempre una cantidad de personas, sus opciones quedan fijas en la interfaz: no hay que actualizarlas desde el servidor.

``` r
# selector del umbral, con sus opciones fijas de personas
selectInput(
"parrafo_umbral",
label = NULL,
choices = c(
"1.000" = 1000, "2.000" = 2000, "5.000" = 5000,
"10.000" = 10000, "25.000" = 25000, "50.000" = 50000
),
selected = 5000
)
```

{{< detalles "Código completo del servidor hasta ahora" >}}

``` r
server <- function(input, output, session) {
observeEvent(input$mostrar_tabla, {
if (input$mostrar_tabla) {
show("tabla_card")
} else {
hide("tabla_card")
}
})

observe({
if (input$parrafo_territorio == "Región") {
show("parrafo_preposicion_territorio")
} else {
hide("parrafo_preposicion_territorio")
}
})

observe({
if (input$parrafo_territorio == "Región") {
show("parrafo_selector_region")
show("parrafo_preposicion_region")
} else {
hide("parrafo_selector_region")
hide("parrafo_preposicion_region")
}
})

output$parrafo_preposicion_region <- renderText({
preposicion_region(input$parrafo_selector_region)
})
}
```

{{< /detalles >}}

### Artículo del umbral

El artículo "las" va escrito directamente en la interfaz, antes del selector del umbral, porque siempre nos referimos a personas.

``` r
# artículo "las" antepuesto al selector del umbral
"las"
```

Como el artículo es un texto fijo, no necesita ningún cálculo en el servidor: basta con escribirlo en la interfaz.

{{< detalles "Código completo del servidor hasta ahora" >}}

``` r
server <- function(input, output, session) {
observeEvent(input$mostrar_tabla, {
if (input$mostrar_tabla) {
show("tabla_card")
} else {
hide("tabla_card")
}
})

observe({
if (input$parrafo_territorio == "Región") {
show("parrafo_preposicion_territorio")
} else {
hide("parrafo_preposicion_territorio")
}
})

observe({
if (input$parrafo_territorio == "Región") {
show("parrafo_selector_region")
show("parrafo_preposicion_region")
} else {
hide("parrafo_selector_region")
hide("parrafo_preposicion_region")
}
})

output$parrafo_preposicion_region <- renderText({
preposicion_region(input$parrafo_selector_region)
})
}
```

{{< /detalles >}}

### Filtrar los datos

Llegamos al reactivo central de la app: `comunas_filtradas()` toma los tres *inputs* (territorio, región y umbral) y devuelve las comunas que cumplen la condición elegida. Todo lo demás se calcula a partir de este reactivo:

``` r
server <- function(input, output, session) {
# ...

comunas_filtradas <- reactive({
# filtrar por territorio
if (input$parrafo_territorio == "Chile") {
datos <- pobreza
} else if (input$parrafo_territorio == "Región") {
datos <- pobreza |>
filter(nombre_region == input$parrafo_selector_region)
}

# filtrar por umbral de personas
datos |>
filter(pobreza_personas > as.numeric(input$parrafo_umbral))
})
}
```

Usar `pobreza_personas` directamente permite comparar contra el umbral elegido y, como se trata de cantidades, sumar sin problema cuando el territorio elegido sea una región.

{{< detalles "Código completo del servidor hasta ahora" >}}

``` r
server <- function(input, output, session) {
observeEvent(input$mostrar_tabla, {
if (input$mostrar_tabla) {
show("tabla_card")
} else {
hide("tabla_card")
}
})

observe({
if (input$parrafo_territorio == "Región") {
show("parrafo_preposicion_territorio")
} else {
hide("parrafo_preposicion_territorio")
}
})

observe({
if (input$parrafo_territorio == "Región") {
show("parrafo_selector_region")
show("parrafo_preposicion_region")
} else {
hide("parrafo_selector_region")
hide("parrafo_preposicion_region")
}
})

output$parrafo_preposicion_region <- renderText({
preposicion_region(input$parrafo_selector_region)
})

# filtrar comunas según territorio y umbral elegidos
comunas_filtradas <- reactive({
if (input$parrafo_territorio == "Chile") {
datos <- pobreza
} else if (input$parrafo_territorio == "Región") {
datos <- pobreza |>
filter(nombre_region == input$parrafo_selector_region)
}

datos |>
filter(pobreza_personas > as.numeric(input$parrafo_umbral))
})
}
```

{{< /detalles >}}

### Cifras y tabla final

Con `comunas_filtradas()` ya definido, el resto es solo consumirlo: contar filas, sumar personas, y armar la tabla:

``` r
server <- function(input, output, session) {
# ...

output$parrafo_n_comunas <- renderText({
n <- nrow(comunas_filtradas())
label_number()(n)
})

output$parrafo_n_personas <- renderText({
personas <- comunas_filtradas() |>
summarize(total = sum(pobreza_personas)) |>
pull(total)

label_number()(personas)
})

output$parrafo_tabla <- renderTable(
{
comunas_filtradas() |>
select(nombre_region, nombre_comuna, poblacion, pobreza_personas) |>
arrange(desc(pobreza_personas)) |>
head(30)
},
digits = 0,
striped = TRUE,
spacing = "xs"
)
}
```

<figure class=''>

<pre class="mermaid mermaid-js">graph TD
territorio[&quot;input$parrafo_territorio&quot;]:::input
region[&quot;input$parrafo_selector_region&quot;]:::input
umbral[&quot;input$parrafo_umbral&quot;]:::input

filtradas[&quot;comunas_filtradas()&lt;br&gt;reactive&quot;]:::reactive

n_comunas[&quot;parrafo_n_comunas&quot;]:::output
n_personas[&quot;parrafo_n_personas&quot;]:::output
tabla[&quot;parrafo_tabla&quot;]:::output

territorio --&gt; filtradas
region --&gt; filtradas
umbral --&gt; filtradas

filtradas --&gt; n_comunas
filtradas --&gt; n_personas
filtradas --&gt; tabla
</pre>

</figure>

{{< detalles "Código completo de la app (interfaz + servidor)" >}}

``` r
library(shiny)
library(shinyjs)
library(bslib)
library(dplyr)
library(scales)
library(territorial)

pobreza <- readr::read_csv("datos/pobreza_ingresos_2024.csv")

number_options(big.mark = ".", decimal.mark = ",")

ui <- page_fillable(
lang = "es",
includeCSS("estilos.css"),
useShinyjs(),

theme = bs_theme(
fg = "#0C2635",
bg = "white",
"line-height-base" = 1.3
),

h1("Párrafo interactivo",
style = "margin-bottom: -1rem;"),
em("Bastián Olea Herrera"),

div(
class = "parrafo",

"En",

span("la", id = "parrafo_preposicion_territorio") |> hidden(),

selectInput(
"parrafo_territorio",
label = NULL,
c("Chile", "Región")
),

textOutput("parrafo_preposicion_region", inline = TRUE) |> hidden(),

selectInput(
"parrafo_selector_region",
label = NULL,
choices = regiones()
) |>
hidden(),

"existen",

strong(
textOutput("parrafo_n_comunas", inline = TRUE),
"comunas"
),

"donde",

"de personas en situación de pobreza supera",

"las",

selectInput(
"parrafo_umbral",
label = NULL,
choices = c(
"1.000" = 1000, "2.000" = 2000, "5.000" = 5000,
"10.000" = 10000, "25.000" = 25000, "50.000" = 50000
),
selected = 5000
),

", lo que corresponde a aproximadamente",

strong(
textOutput("parrafo_n_personas", inline = TRUE),
"personas"
),
"en situación de pobreza."
),

checkboxInput("mostrar_tabla", "Mostrar tabla", value = FALSE),
card(
id = "tabla_card",
tableOutput("parrafo_tabla")
) |>
hidden()
)

server <- function(input, output, session) {
observeEvent(input$mostrar_tabla, {
if (input$mostrar_tabla) {
show("tabla_card")
} else {
hide("tabla_card")
}
})

observe({
if (input$parrafo_territorio == "Región") {
show("parrafo_preposicion_territorio")
} else {
hide("parrafo_preposicion_territorio")
}
})

observe({
if (input$parrafo_territorio == "Región") {
show("parrafo_selector_region")
show("parrafo_preposicion_region")
} else {
hide("parrafo_selector_region")
hide("parrafo_preposicion_region")
}
})

output$parrafo_preposicion_region <- renderText({
preposicion_region(input$parrafo_selector_region)
})

comunas_filtradas <- reactive({
if (input$parrafo_territorio == "Chile") {
datos <- pobreza
} else if (input$parrafo_territorio == "Región") {
datos <- pobreza |>
filter(nombre_region == input$parrafo_selector_region)
}

datos |>
filter(pobreza_personas > as.numeric(input$parrafo_umbral))
})

output$parrafo_n_comunas <- renderText({
n <- nrow(comunas_filtradas())
label_number()(n)
})

output$parrafo_n_personas <- renderText({
personas <- comunas_filtradas() |>
summarize(total = sum(pobreza_personas)) |>
pull(total)

label_number()(personas)
})

output$parrafo_tabla <- renderTable(
{
comunas_filtradas() |>
select(nombre_region, nombre_comuna, poblacion, pobreza_personas) |>
arrange(desc(pobreza_personas)) |>
head(30)
},
digits = 0,
striped = TRUE,
spacing = "xs"
)
}

shinyApp(ui, server)
```

{{< /detalles >}}

### Todas las conexiones juntas

Uniendo todos los diagramas anteriores, así es como fluyen los *inputs* del párrafo hasta llegar a los *outputs* que se ven en pantalla:

<figure class=''>

<pre class="mermaid mermaid-js">graph TD
territorio[&quot;input$parrafo_territorio&quot;]:::input
region[&quot;input$parrafo_selector_region&quot;]:::input
umbral[&quot;input$parrafo_umbral&quot;]:::input

obs_territorio[&quot;observe: mostrar/ocultar&lt;br&gt;selector de región&lt;br&gt;+ preposición &#39;la&#39;&quot;]:::observer

prep_region[&quot;parrafo_preposicion_region&quot;]:::output

filtradas[&quot;comunas_filtradas()&lt;br&gt;reactive&quot;]:::reactive

n_comunas[&quot;parrafo_n_comunas&quot;]:::output
n_personas[&quot;parrafo_n_personas&quot;]:::output
tabla[&quot;parrafo_tabla&quot;]:::output

territorio --&gt; obs_territorio
obs_territorio --&gt; prep_region
region --&gt; prep_region
obs_territorio --&gt; filtradas

territorio --&gt; filtradas
region --&gt; filtradas
umbral --&gt; filtradas

filtradas --&gt; n_comunas
filtradas --&gt; n_personas
filtradas --&gt; tabla
</pre>

</figure>

Los nodos azules son las elecciones de la persona, los naranjos son los `observe`/`observeEvent` que reaccionan a esas elecciones, el verde es el reactivo central que filtra los datos, y los rosados son las salidas que finalmente se ven en el párrafo.

El resultado es siempre un párrafo coherente que combina los controles con los resultados!

{{< relacionada "blog/territorial/" "Más sobre el paquete {territorial}" >}}
{{< etiqueta "shiny" "Más publicaciones sobre Shiny" >}}
{{< cafecito >}}
