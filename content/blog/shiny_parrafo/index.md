---
title: Párrafos interactivos en aplicaciones Shiny
subtitle: Combinando exploración de datos con comunicación de resultados
author: Bastián Olea Herrera
date: '2026-08-13'
slug: []
draft: true
categories:
  - Aplicaciones
tags:
  - shiny
  - apps
  - Chile
  - datos
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: file-code
    icon_pack: fas
    name: Código
    url: https://github.com/bastianolea/shiny_parrafo_interactivo
---


<script  src="index_files/libs/quarto-diagram/mermaid.min.js"></script>
<script  src="index_files/libs/quarto-diagram/mermaid-init.js"></script>
<link  href="index_files/libs/quarto-diagram/mermaid.css" rel="stylesheet" />

A veces, para explorar datos no se necesitan gráficos sofisticados, mapas o *dashboards* complejos. Se me ocurrió probar un formato distinto: un "párrafo interactivo", donde las variables de la oración se pueden cambiar con *inputs*, y las cifras del texto se actualizan automáticamente según lo que la persona elija.

La idea es combinar la exploración de datos con la comunicación de resultados: en vez de mostrar un gráfico y dejar que cada persona interprete lo que ve, el párrafo entrega directamente una lectura en palabras, pero deja que la persona explore distintos escenarios cambiando los controles.

El ejemplo que hice usa datos de pobreza comunal 2024 del Ministerio de Desarrollo Social y Familia. Se elige un territorio (Chile completo o una región), si se quiere ver porcentaje o cantidad de personas, y un umbral de pobreza, y el párrafo indica cuántas comunas superan ese umbral y a cuántas personas en situación de pobreza corresponde esa cifra.

<iframe src="https://www.linkedin.com/embed/feed/update/urn:li:ugcPost:7492986395066535936?compact=1" height="399" width="100%" frameborder="0" allowfullscreen title="Publicación integrada">
</iframe>

Algo que me pareció importante fue que las palabras se adaptaran gramaticalmente a lo que la persona va eligiendo: por ejemplo, si elige "la cantidad" en vez de "el porcentaje", el artículo que sigue más adelante en la oración también cambia ("el" umbral versus "las" personas). Y si elige ver una región en particular, la preposición correspondiente se ajusta a esa región (región "del" Maule, región "de" Los Lagos, etc.) gracias a la función `preposicion_region()` del paquete de R [`{territorial}`](../../../blog/territorial/), que armé justamente para facilitar este tipo de detalles al trabajar con nombres de comunas y regiones de Chile.

A continuación, reviso cómo armé la app, paso a paso, mostrando primero la interfaz y luego cómo se conecta todo en el servidor.

## Interfaz: armando el párrafo

### Paquetes y datos

Empiezo cargando los paquetes que necesito. Además de `{shiny}` y `{bslib}` para la interfaz, uso `{shinyjs}` para mostrar y ocultar elementos, `{scales}` para formatear números, y `{territorial}` para la concordancia gramatical de las regiones:

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

`number_options()` fija de una vez el formato de los números (punto para miles, coma para decimales) para toda la sesión, así no hay que repetirlo cada vez que formatee una cifra.

### Título y tema

La interfaz parte con lo básico: `page_fillable()`, un tema simple con `{bslib}`, y un CSS aparte que voy a usar más adelante para que los selectores se vean como parte del texto:

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

`useShinyjs()` habilita las funciones `show()` y `hide()` que voy a usar para hacer aparecer y desaparecer partes del párrafo dependiendo de las elecciones de la persona.

### Territorio: Chile o una región

El párrafo mismo es un solo `div()` con clase `parrafo`, que mezcla texto fijo con *inputs* y salidas. Empiezo con el primer selector, que elige entre "Chile" y "Región":

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

De aquí en adelante me voy a enfocar solo en el contenido del `div()`, porque el resto de la `ui` no vuelve a cambiar.

### Preposición y selector de región

Si la persona elige "Región", necesito dos cosas más: la preposición "la" antes del selector de territorio (para que diga "en la Región"), y un segundo selector con las regiones, además de la preposición correspondiente a la región elegida ("de" Los Lagos, "del" Maule). Ambas partes parten **ocultas** con `hidden()`, porque solo se muestran cuando corresponde:

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

### Cantidad de comunas y variable

Sigue la cifra principal (cantidad de comunas, envuelta en `strong()` para destacarla) y el selector que elige si se compara por porcentaje o por cantidad de personas:

\`\`\`r {hl_lines=\["3-8", "10-19"\]}
div(
\# ...
"existen",

strong(
textOutput("parrafo_n_comunas", inline = TRUE),
"comunas"
),

"donde",

selectInput(
"parrafo_variable",
label = NULL,
c(
"el porcentaje" = "pobreza_porcentaje",
"la cantidad" = "pobreza_personas"
)
),

"de personas en situación de pobreza supera"
)


    {{< detalles "Código completo del div hasta ahora" >}}
    ```r
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

      selectInput(
        "parrafo_variable",
        label = NULL,
        c(
          "el porcentaje" = "pobreza_porcentaje",
          "la cantidad" = "pobreza_personas"
        )
      ),

      "de personas en situación de pobreza supera"
    )

{{< /detalles >}}

### Umbral y cifra final

Termino el párrafo con el umbral elegido (con su artículo correspondiente, "el" o "las") y la cantidad de personas que corresponde a ese filtro:

``` r
div(
  # ...
  "de personas en situación de pobreza supera",

  textOutput("parrafo_articulo_umbral", inline = TRUE),

  selectInput(
    "parrafo_umbral",
    label = NULL,
    choices = NULL
  ),

  ", lo que corresponde a aproximadamente",

  strong(
    textOutput("parrafo_n_personas", inline = TRUE),
    "personas"
  ),
  "en situación de pobreza."
)
```

El `selectInput()` del umbral parte con `choices = NULL` a propósito: sus opciones dependen de si se eligió porcentaje o cantidad, así que se rellenan desde el servidor.

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

  selectInput(
    "parrafo_variable",
    label = NULL,
    c(
      "el porcentaje" = "pobreza_porcentaje",
      "la cantidad" = "pobreza_personas"
    )
  ),

  "de personas en situación de pobreza supera",

  textOutput("parrafo_articulo_umbral", inline = TRUE),

  selectInput(
    "parrafo_umbral",
    label = NULL,
    choices = NULL
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

Por último, afuera del párrafo, agrego un `checkboxInput()` y una `card()` oculta con la tabla de detalle:

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

    selectInput(
      "parrafo_variable",
      label = NULL,
      c(
        "el porcentaje" = "pobreza_porcentaje",
        "la cantidad" = "pobreza_personas"
      )
    ),

    "de personas en situación de pobreza supera",

    textOutput("parrafo_articulo_umbral", inline = TRUE),

    selectInput(
      "parrafo_umbral",
      label = NULL,
      choices = NULL
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

El servidor es donde ocurre toda la reactividad: qué se muestra u oculta, cómo se filtran los datos, y qué texto se calcula para cada salida. Voy a ir agregando una pieza a la vez, mostrando después de cada una un diagrama con las conexiones que se generan.

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

  classDef input fill:#e3f2fd,stroke:#1565c0
  classDef observer fill:#fff3e0,stroke:#ef6c00
  classDef output fill:#fce4ec,stroke:#c62828
</pre>

</figure>

### Concordancia del territorio

Cuando la persona elige "Región" en vez de "Chile", tengo que mostrar la preposición "la" y, además, el selector de región junto a su propia preposición. Son dos `observe()` porque son dos partes de la interfaz que reaccionan a la misma elección:

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

  classDef input fill:#e3f2fd,stroke:#1565c0
  classDef observer fill:#fff3e0,stroke:#ef6c00
  classDef output fill:#fce4ec,stroke:#c62828
</pre>

</figure>

### Preposición de la región elegida

Ahora que el selector de región es visible, necesito calcular qué preposición corresponde a la región que se eligió. Acá es donde entra `preposicion_region()` de `{territorial}`:

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
  region[&quot;input$parrafo_selector_region&quot;]:::input
  render[&quot;renderText:&lt;br&gt;preposicion_region()&quot;]:::observer
  output[&quot;parrafo_preposicion_region&quot;]:::output

  region --&gt; render --&gt; output

  classDef input fill:#e3f2fd,stroke:#1565c0
  classDef observer fill:#fff3e0,stroke:#ef6c00
  classDef output fill:#fce4ec,stroke:#c62828
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

### Umbral según la variable elegida

El selector de umbral parte vacío, así que cada vez que la persona cambia entre "el porcentaje" y "la cantidad", tengo que reemplazar sus opciones con `updateSelectInput()`: porcentajes si se trata de `pobreza_porcentaje`, o montos de personas si se trata de `pobreza_personas`:

``` r
server <- function(input, output, session) {
  # ...

  observeEvent(input$parrafo_variable, {
    if (input$parrafo_variable == "pobreza_porcentaje") {
      updateSelectInput(
        session,
        "parrafo_umbral",
        choices = c(
          "5%" = .05, "10%" = .10, "15%" = .15, "20%" = .20,
          "25%" = .25, "30%" = .30, "35%" = .35, "40%" = .40
        ),
        selected = .15
      )
    } else {
      updateSelectInput(
        session,
        "parrafo_umbral",
        choices = c(
          "1.000" = 1000, "5.000" = 5000, "10.000" = 10000,
          "25.000" = 25000, "50.000" = 50000, "75.000" = 75000
        ),
        selected = 5000
      )
    }
  })
}
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

  # actualizar opciones del umbral según la variable elegida
  observeEvent(input$parrafo_variable, {
    if (input$parrafo_variable == "pobreza_porcentaje") {
      updateSelectInput(
        session,
        "parrafo_umbral",
        choices = c(
          "5%" = .05, "10%" = .10, "15%" = .15, "20%" = .20,
          "25%" = .25, "30%" = .30, "35%" = .35, "40%" = .40
        ),
        selected = .15
      )
    } else {
      updateSelectInput(
        session,
        "parrafo_umbral",
        choices = c(
          "1.000" = 1000, "5.000" = 5000, "10.000" = 10000,
          "25.000" = 25000, "50.000" = 50000, "75.000" = 75000
        ),
        selected = 5000
      )
    }
  })
}
```

{{< /detalles >}}

### Artículo del umbral

De paso, el artículo que antecede al umbral también depende de la variable elegida ("el" 15%, pero "las" 5.000 personas):

``` r
server <- function(input, output, session) {
  # ...

  # artículo del umbral ("el" / "las")
  output$parrafo_articulo_umbral <- renderText({
    if (input$parrafo_variable == "pobreza_porcentaje") "el" else "las"
  })
}
```

<figure class=''>

<pre class="mermaid mermaid-js">graph LR
  variable[&quot;input$parrafo_variable&quot;]:::input
  obs[&quot;observeEvent:&lt;br&gt;actualizar choices&lt;br&gt;de umbral&quot;]:::observer
  render[&quot;renderText:&lt;br&gt;artículo&quot;]:::observer
  umbral[&quot;parrafo_umbral&lt;br&gt;(choices)&quot;]:::output
  articulo[&quot;parrafo_articulo_umbral&quot;]:::output

  variable --&gt; obs --&gt; umbral
  variable --&gt; render --&gt; articulo

  classDef input fill:#e3f2fd,stroke:#1565c0
  classDef observer fill:#fff3e0,stroke:#ef6c00
  classDef output fill:#fce4ec,stroke:#c62828
</pre>

</figure>

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

  observeEvent(input$parrafo_variable, {
    if (input$parrafo_variable == "pobreza_porcentaje") {
      updateSelectInput(
        session,
        "parrafo_umbral",
        choices = c(
          "5%" = .05, "10%" = .10, "15%" = .15, "20%" = .20,
          "25%" = .25, "30%" = .30, "35%" = .35, "40%" = .40
        ),
        selected = .15
      )
    } else {
      updateSelectInput(
        session,
        "parrafo_umbral",
        choices = c(
          "1.000" = 1000, "5.000" = 5000, "10.000" = 10000,
          "25.000" = 25000, "50.000" = 50000, "75.000" = 75000
        ),
        selected = 5000
      )
    }
  })

  # artículo del umbral ("el" / "las")
  output$parrafo_articulo_umbral <- renderText({
    if (input$parrafo_variable == "pobreza_porcentaje") "el" else "las"
  })
}
```

{{< /detalles >}}

### Filtrar los datos

Llegamos al reactivo central de la app: `comunas_filtradas()` toma los tres *inputs* (territorio, región, variable y umbral) y devuelve las comunas que cumplen la condición elegida. Todo lo demás se calcula a partir de este reactivo:

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

    # filtrar umbral en la columna
    datos |>
      filter(.data[[input$parrafo_variable]] > as.numeric(input$parrafo_umbral))
  })
}
```

Usar `.data[[input$parrafo_variable]]` es lo que permite filtrar dinámicamente por la columna `pobreza_porcentaje` o `pobreza_personas`, dependiendo de cuál haya elegido la persona, sin tener que escribir dos reactivos separados.

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

  observeEvent(input$parrafo_variable, {
    if (input$parrafo_variable == "pobreza_porcentaje") {
      updateSelectInput(
        session,
        "parrafo_umbral",
        choices = c(
          "5%" = .05, "10%" = .10, "15%" = .15, "20%" = .20,
          "25%" = .25, "30%" = .30, "35%" = .35, "40%" = .40
        ),
        selected = .15
      )
    } else {
      updateSelectInput(
        session,
        "parrafo_umbral",
        choices = c(
          "1.000" = 1000, "5.000" = 5000, "10.000" = 10000,
          "25.000" = 25000, "50.000" = 50000, "75.000" = 75000
        ),
        selected = 5000
      )
    }
  })

  output$parrafo_articulo_umbral <- renderText({
    if (input$parrafo_variable == "pobreza_porcentaje") "el" else "las"
  })

  # filtrar comunas según territorio, variable y umbral elegidos
  comunas_filtradas <- reactive({
    if (input$parrafo_territorio == "Chile") {
      datos <- pobreza
    } else if (input$parrafo_territorio == "Región") {
      datos <- pobreza |>
        filter(nombre_region == input$parrafo_selector_region)
    }

    datos |>
      filter(.data[[input$parrafo_variable]] > as.numeric(input$parrafo_umbral))
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
        select(nombre_region, nombre_comuna, poblacion,
               pobreza_porcentaje, pobreza_personas) |>
        arrange(desc(pobreza_porcentaje)) |>
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
  variable[&quot;input$parrafo_variable&quot;]:::input
  umbral[&quot;input$parrafo_umbral&quot;]:::input

  filtradas[&quot;comunas_filtradas()&lt;br&gt;reactive&quot;]:::reactive

  n_comunas[&quot;parrafo_n_comunas&quot;]:::output
  n_personas[&quot;parrafo_n_personas&quot;]:::output
  tabla[&quot;parrafo_tabla&quot;]:::output

  territorio --&gt; filtradas
  region --&gt; filtradas
  variable --&gt; filtradas
  umbral --&gt; filtradas

  filtradas --&gt; n_comunas
  filtradas --&gt; n_personas
  filtradas --&gt; tabla

  classDef input fill:#e3f2fd,stroke:#1565c0
  classDef reactive fill:#e8f5e9,stroke:#2e7d32
  classDef output fill:#fce4ec,stroke:#c62828
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

    selectInput(
      "parrafo_variable",
      label = NULL,
      c(
        "el porcentaje" = "pobreza_porcentaje",
        "la cantidad" = "pobreza_personas"
      )
    ),

    "de personas en situación de pobreza supera",

    textOutput("parrafo_articulo_umbral", inline = TRUE),

    selectInput(
      "parrafo_umbral",
      label = NULL,
      choices = NULL
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

  observeEvent(input$parrafo_variable, {
    if (input$parrafo_variable == "pobreza_porcentaje") {
      updateSelectInput(
        session,
        "parrafo_umbral",
        choices = c(
          "5%" = .05, "10%" = .10, "15%" = .15, "20%" = .20,
          "25%" = .25, "30%" = .30, "35%" = .35, "40%" = .40
        ),
        selected = .15
      )
    } else {
      updateSelectInput(
        session,
        "parrafo_umbral",
        choices = c(
          "1.000" = 1000, "5.000" = 5000, "10.000" = 10000,
          "25.000" = 25000, "50.000" = 50000, "75.000" = 75000
        ),
        selected = 5000
      )
    }
  })

  output$parrafo_articulo_umbral <- renderText({
    if (input$parrafo_variable == "pobreza_porcentaje") "el" else "las"
  })

  comunas_filtradas <- reactive({
    if (input$parrafo_territorio == "Chile") {
      datos <- pobreza
    } else if (input$parrafo_territorio == "Región") {
      datos <- pobreza |>
        filter(nombre_region == input$parrafo_selector_region)
    }

    datos |>
      filter(.data[[input$parrafo_variable]] > as.numeric(input$parrafo_umbral))
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
        select(nombre_region, nombre_comuna, poblacion,
               pobreza_porcentaje, pobreza_personas) |>
        arrange(desc(pobreza_porcentaje)) |>
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
  variable[&quot;input$parrafo_variable&quot;]:::input
  umbral[&quot;input$parrafo_umbral&quot;]:::input

  obs_territorio[&quot;observe: mostrar/ocultar&lt;br&gt;selector de región&lt;br&gt;+ preposición &#39;la&#39;&quot;]:::observer
  obs_variable[&quot;observeEvent: actualizar&lt;br&gt;choices de umbral&quot;]:::observer

  prep_region[&quot;parrafo_preposicion_region&quot;]:::output
  art_umbral[&quot;parrafo_articulo_umbral&quot;]:::output

  filtradas[&quot;comunas_filtradas()&lt;br&gt;reactive&quot;]:::reactive

  n_comunas[&quot;parrafo_n_comunas&quot;]:::output
  n_personas[&quot;parrafo_n_personas&quot;]:::output
  tabla[&quot;parrafo_tabla&quot;]:::output

  territorio --&gt; obs_territorio
  obs_territorio --&gt; prep_region
  region --&gt; prep_region
  obs_territorio --&gt; filtradas

  variable --&gt; obs_variable
  obs_variable --&gt; umbral
  variable --&gt; art_umbral
  variable --&gt; filtradas

  territorio --&gt; filtradas
  region --&gt; filtradas
  umbral --&gt; filtradas

  filtradas --&gt; n_comunas
  filtradas --&gt; n_personas
  filtradas --&gt; tabla

  classDef input fill:#e3f2fd,stroke:#1565c0
  classDef observer fill:#fff3e0,stroke:#ef6c00
  classDef reactive fill:#e8f5e9,stroke:#2e7d32
  classDef output fill:#fce4ec,stroke:#c62828
</pre>

</figure>

Los nodos azules son las elecciones de la persona, los naranjos son los `observe`/`observeEvent` que reaccionan a esas elecciones, el verde es el reactivo central que filtra los datos, y los rosados son las salidas que finalmente se ven en el párrafo.

El resultado es siempre un párrafo coherente que combina los controles con los resultados!

{{< relacionada "blog/territorial/" "Más sobre el paquete {territorial}" >}}
{{< etiqueta "shiny" "Más publicaciones sobre Shiny" >}}
{{< cafecito >}}
