---
title: Crea un chatbot de inteligencia artificial con R
author: Bastián Olea Herrera
date: '2026-06-01'
slug: []
draft: false
categories:
  - "Tutoriales"
tags:
  - shiny
  - inteligencia artificial
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: registered
    icon_pack: fas
    name: shinychat
    url: https://posit-dev.github.io/shinychat/r/index.html
  - icon: file-lines
    icon_pack: fas
    name: consultar datos con IA
    url: /blog/herramientas_llm/
  - icon: file-lines
    icon_pack: fas
    name: consultar textos con IA
    url: /blog/rag_ragnar/
excerpt: "Este tutorial encuentras todo lo necesario para desarrollar tu propio chatbot con R, basándonos en una aplicación Shiny y en modelos de inteligencia artificial. El objetivo es crear un chat interactivo y mejorarlo con la capacidad de consultar datos, realizar cálculos y otras funcionalidades propias de R, y además aumentar su conocimiento y la precisión de sus respuestas al permitirle consultar documentos y textos para responder (RAG). En pocos minutos podrás potenciar la inteligencia artificial y crear un producto capaz de analizar tus propios datos y estudios!"
---

Con R y los paquetes apropiados, en pocos minutos podrás crear un chat interactivo de inteligencia artificial dentro de una aplicación Shiny, para poder chatear con un modelo de lenguaje (LLM) de tu elección.

El objetivo es poder crear un chat interactivo e ir mejorándolo con la capacidad de **consultar datos**, **realizar cálculos** y otras capacidades propias de R, y además aumentar su conocimiento y la precisión de sus respuestas al permitirle **consultar documentos y textos** para responder. 

{{< imagen "chatbot_6.png" "500px" >}}

_**¿Por qué crear un chatbot con R?**_ 

- Te entrega el control para **elegir el proveedor** de inteligencia artificial, o el _cerebro_ que usará el chatbot, así como cambiarlo cuando sea necesario
- **Aplicaciones:** Puedes incluir el chatbot en cualquier parte de una [aplicación Shiny](/tags/shiny/), lo que te da libertad para crear interfaces adaptadas a tus necesidades
- **Datos:** Permite [complementar al chatbot con herramientas](/blog/herramientas_llm/), funciones de R que hacen posible que el chatbot realice tareas especializadas, como **consultar bases de datos**
- **Conocimientos:** Hace posible [aumentar y afinar los conocimientos de la IA](/blog/rag_ragnar/) por medio de sistemas de _generación aumentada por recuperación_ o RAG, donde recopilas documentos y textos para guiar las respuestas de la IA

{{< info "Este tutorial es la base para poder crear chatbots, cuyo objetivo principal es [ser complementados por herramientas](/blog/herramientas_llm/) y [bases de conocimiento](/blog/rag_ragnar/) para que sean más útiles y personalizados que un chat de IA común y corriente." >}}



## Preparación

Crear un chatbot requiere de tres piezas principales: una **aplicación** donde introducir el chatbot, la funcionalidad de chat o **conversación**, y el **modelo de lenguaje** que será el motor de la conversación. 

Estas tres piezas corresponden a los tres paquetes de R que usaremos: `{shiny}` para la aplicación, `{shinychat}` para la conversación, y `{ellmer}` para el modelo de lenguaje.

Si aún no tienes configurado un modelo de lenguaje en R, [revisa este tutorial](/blog/ellmer/), donde explico cómo conectarte con el modelo de IA desde R.

{{< relacionada "/blog/ellmer/" "Contenidos mínimos" >}}

Empezamos instalando los paquetes necesarios:

```r
install.packages("ellmer")
install.packages("shiny")
install.packages("bslib")
install.packages("shinychat")
```

Ahora veremos paso a paso cómo empezar desde cero y llegar a un chatbot capaz de consultar datos y bases de conocimiento.


## Crear un chatbot con Shiny

Hagamos un [ayudamemorias de una aplicación Shiny mínima](/blog/shiny/#estructura-de-una-app-shiny), sin ningún chat todavía:

```r
library(shiny)
library(bslib)

ui <- page_fluid(
  h1("Mi chatbot")
)

server <- function(input, output, session) {
}

shinyApp(ui, server)
```

Tenemos la sección UI, con la **interfaz** de la aplicación, y una sección _server_, donde se hacen los cálculos de la aplicación.

Esto nos entregará una app mínima, que puedes probar con el botón _Run_ que aparecerá en RStudio o en tu IDE. 

En principio esta puede ser una app que ya hayas hecho, o puede ser el lienzo para que complementes tu chatbot con otros elementos de una aplicación normal.

{{< relacionada "/blog/shiny/" "Instrucciones detalladas" >}}

Ahora vamos a transformar la aplicación en un chatbot en tres pasos: agregar la **interfaz** del chat, configurar el **modelo** de lenguaje, y **conectar** ambas partes en [la sección _server_](/blog/shiny/#uniendo-_inputs_-y-datos-en-_server_) de la app.

{{< info "Veremos qué hace cada parte rápidamente, pero después de cada paso siempre estará el código completo para que copies y pegues." >}}

### Interfaz del chat

[El paquete `{shinychat}`](https://posit-dev.github.io/shinychat/r/index.html) nos entrega una **interfaz de conversación tipo chat**, con burbujitas de mensaje y todo, que simplemente se agrega a tu app con la función `chat_ui()`.

Se recomienda usar `page_fillable()` en la app para que ocupe toda la pantalla, y dentro ponemos `chat_ui()`.

Por ahora la app iría quedando así:

```r {hl_lines=["3-4" "6-12"]}
library(shiny)
library(bslib)
library(ellmer)
library(shinychat)

ui <- page_fillable(
  chat_ui(
    id = "chat",
    messages = "**¡Hola!** ¿En qué te puedo ayudar hoy?"
  ),
  fillable_mobile = TRUE
)

server <- function(input, output, session) {
}

shinyApp(ui, server)
```

Con esto creamos la parte visible del chat, pero falta el funcionamiento y el cerebro.

### Modelo de lenguaje para el chatbot

En la sección `server`, donde se realizan los cálculos de una app Shiny, **creamos el chat** que hará funcionar al chatbot.

Como vimos en el [tutorial de chats de IA en R](/blog/ellmer/#iniciar-una-conversación-con-la-ia), creamos el chat con la función `chat_anthropic()`, `chat_ollama()`, o el proveedor que te corresponda a ti. Este objeto representa la conversación completa con el modelo de lenguaje: guarda el historial de mensajes y se encarga de comunicarse con la API.

```r {hl_lines=["14-19"]}
library(shiny)
library(bslib)
library(ellmer)
library(shinychat)

ui <- page_fillable(
  chat_ui(
    id = "chat",
    messages = "**¡Hola!** ¿En qué te puedo ayudar hoy?"
  ),
  fillable_mobile = TRUE
)

server <- function(input, output, session) {

chat <- chat_anthropic(
    system_prompt = "Eres un chatbot respetuoso, útil y conciso."
  )
}

shinyApp(ui, server)
```

El argumento `system_prompt` son las **instrucciones** que le damos al modelo para **guiar su comportamiento**: el rol que debe cumplir, el tono que debe usar, explicaciones sobre su función principal, las formas apropiadas de responder, y sus restricciones.


### Conectar la interfaz con el modelo

Ahora falta el último paso: conectar el modelo de lenguaje creado con `chat_anthropic()` con el `chat_ui()` que pusimos en la interfaz de la app.

```r {hl_lines=["19-22"]}
library(shiny)
library(bslib)
library(ellmer)
library(shinychat)

ui <- page_fillable(
  chat_ui(
    id = "chat",
    messages = "**¡Hola!** ¿En qué te puedo ayudar hoy?"
  ),
  fillable_mobile = TRUE
)

server <- function(input, output, session) {
  chat <- chat_openai(
    system_prompt = "Eres un chatbot respetuoso, útil y conciso."
  )

  observeEvent(input$chat_user_input, {
    stream <- chat$stream_async(input$chat_user_input)
    chat_append("chat", stream)
  })
}

shinyApp(ui, server)
```

Siguiendo [lo que aprendimos en el tutorial de Shiny](/blog/shiny/#reactividad), el bloque `observeEvent()` se activará cada vez que se envíe un mensaje en la interfaz de `chat_ui()`. Dentro de él ocurren dos cosas:

1. La primera línea, `chat$stream_async(input$chat_user_input)`, manda el mensaje del usuario/a al modelo de lenguaje (el objeto `chat`), y obtiene la respuesta que emita la IA. 
2. La segunda línea, `chat_append("chat", stream)`, va añadiendo las burbujas de mensajitos a la interfaz del chat a medida que llega el texto. La app lo va recibiendo en tiempo real en vez de esperar la respuesta completa.

{{< detalles "**Código completo de la app con chatbot**" >}}

```r
library(shiny)
library(bslib)
library(ellmer)
library(shinychat)

ui <- page_fillable(
  chat_ui(
    id = "chat",
    messages = "**¡Hola!** ¿En qué te puedo ayudar hoy?"
  ),
  fillable_mobile = TRUE
)

server <- function(input, output, session) {
  chat <- chat_anthropic(
    system_prompt = "Eres un chatbot respetuoso, útil y conciso."
  )

  observeEvent(input$chat_user_input, {
    stream <- chat$stream_async(input$chat_user_input)
    chat_append("chat", stream)
  })
}

shinyApp(ui, server)
```

{{< /detalles >}}

Probemos el chatbot!

{{< imagen "chatbot_basico.png" "400px" >}}

Si [configuraste bien tu proveedor de IA](/blog/ellmer/#proveedores-de-modelos-de-lenguaje-en-la-nube), vas a poder conversar con tu modelo mediante la aplicación Shiny. 

Ahora pasamos a la gracia de todo esto: **potenciar el chatbot con herramientas** para que pueda acceder a datos, y darle una **base de conocimientos** con documentos específicos.


## Entregar herramientas al chatbot

Para ilustrar el desarrollo de un chatbot enfocado en datos con R, hagamos que queremos desarrollar un chatbot que pueda decirnos **cifras de la situación de pobreza en Chile**. 

Primero **pongamos a prueba el chatbot** que ya creamos, que no tiene ningún conocimiento específico (solamente el conocimiento propio del entrenamiento de la IA), y preguntémosle por un dato:

{{< imagen "chatbot_prueba_1.png" "400px" >}}

El modelo de lenguaje no supo responder! 🫤 

Cuando la IA no sabe responder, usualmente rellena con cualquier cosa, o se atreve a una estimación. En la mayoría de lso casos, **esto debería ser inaceptable.**


{{< detalles "**Ver código completo del chatbot hasta ahora**" >}}

Especificamos algunas cosas en el código: elejimos un modelo económico, Claude Haiku, definiendo `model = "claude-haiku-4-5"` dentro de `chat_anthropic()`, y además especifiquemos el _system prompt_: `"Eres un chatbot respetuoso, útil y conciso. Responde muy brevemente solamente lo que se te pregunta."` para que nos entregue menos cháchara.

```r
library(shiny)
library(bslib)
library(ellmer)
library(shinychat)

ui <- page_fillable(
  chat_ui(
    id = "chat",
    messages = "**¡Hola!** ¿En qué te puedo ayudar hoy?"
  ),
  fillable_mobile = TRUE
)

server <- function(input, output, session) {
  chat <- chat_anthropic(
    model = "claude-haiku-4-5",
    system_prompt = "Eres un chatbot respetuoso, útil y conciso. Responde muy brevemente solamente lo que se te pregunta, sin rodeos."
  )
  
  observeEvent(input$chat_user_input, {
    stream <- chat$stream_async(input$chat_user_input)
    chat_append("chat", stream)
  })
}

shinyApp(ui, server)
```

{{< /detalles >}}


### Descargar datos

Bajemos un conjunto de datos que nos pueden servir: las [estimaciones de pobreza comunal 2024](https://bidat.gob.cl/directorio/Pobreza%20comunal/estimaciones-de-pobreza-comunal-2024) calculadas por el Ministerio de Desarrollo Social de Chile.

{{< boton "Desacargar datos de pobreza" "https://bidat.gob.cl/url/69e5767156227" "fas fa-file-download" >}}

```r
pobreza <- read_xlsx("sae_ingresos_2024.xlsx")
```

Cargamos y limpiamos los datos hasta que obtenemos una tabla ordenada:

{{< detalles "**Ver código de la limpieza de datos**" >}}

```r
library(readxl)
library(dplyr)
library(janitor)

pobreza <- read_xlsx("sae_ingresos_2024.xlsx")

# limpiar columnas
pobreza <- pobreza |> 
  row_to_names(2) |> 
  clean_names() |> 
  rename(poblacion = numero_de_personas_segun_proyecciones_de_poblacion,
         pobreza_personas = numero_de_personas_en_situacion_de_pobreza_de_ingresos,
         pobreza_porcentaje = porcentaje_de_personas_en_situacion_de_pobreza_de_ingresos_2024,
         pobreza_porcentaje_inf = limite_inferior,
         pobreza_porcentaje_sup = limite_superior)

# convertir a numéricos
pobreza <- pobreza |> 
  mutate(
    across(
      c(poblacion, starts_with("pobreza")),
      as.numeric)
  )
```

{{< /detalles >}}


|nombre_comuna | poblacion| pobreza_personas| pobreza_porcentaje|
|:-------------|---------:|----------------:|------------------:|
|Iquique       |    232455|            37598|              0.161|
|Alto Hospicio |    144554|            38759|              0.268|
|Pozo Almonte  |     18811|             3968|              0.210|
|Camiña        |      1376|              600|              0.436|
|Colchane      |      1553|              791|              0.509|
|Huara         |      3111|             1240|              0.398|
|Pica          |      6313|             1980|              0.313|
|Antofagasta   |    445152|            69705|              0.156|
|Mejillones    |     15950|             2239|              0.140|
|Sierra Gorda  |      1807|              256|              0.141|





### Función de consulta de datos 

Ahora que tenemos los datos, hagamos una función muy breve que nos permita **filtrar la tabla de datos**, [siguiendo las instrucciones de este tutorial](/blog/funcion_consultar_datos/). 

El objetivo es crear una función sencilla que opere como una API para consultar datos, una especie de **herramienta** que resuelve una necesidad de información.

```r 
# crear la función de consulta de datos
consultar_pobreza <- function(comuna) {
  message("comuna elegida: ", comuna)
  
  pobreza |> 
    filter(nombre_comuna == comuna) |> 
    select(region, pobreza_personas, pobreza_porcentaje,
           pobreza_porcentaje_inf, pobreza_porcentaje_sup)
}
```

La función tiene un sólo argumento, con el cual se filtra la columna `nombre_comuna` para obtener cifras exactas de pobreza. 

Probemos la función de consulta de datos:

```r
consultar_pobreza("Maipú")
```

```
$ nombre_comuna          <chr> "Maipú"
$ region                 <chr> "Metropolitana"
$ pobreza_personas       <dbl> 70661.29
$ pobreza_porcentaje     <dbl> 0.1203846
$ pobreza_porcentaje_inf <dbl> 0.09052756
$ pobreza_porcentaje_sup <dbl> 0.1502416
```

Estupendo! La función nos sirve para que con un sólo argumento podamos filtrar los datos. 

{{< relacionada "/blog/funcion_consultar_datos/" "Instrucciones detalladas" >}}


### Registrar la herramienta 

Cualquier función de R que tengamos o que creemos podemos _pasársela_ al modelo de lenguaje. Para que el modelo la entienda, tenemos que **explicarle** la herramienta. De esta manera, **el modelo podrá usar funciones de R** cuando sean relevantes para responder las preguntas que le hagamos.

Para **enseñarle al modelo** cómo se usa la función, usamos `tool()` de `{ellmer}`, donde entregamos la función, agregamos una descripción general, y describimos también sus argumentos:

```r
herramienta <- tool(
  consultar_pobreza,
  description = "Función que entrega datos de la estimación de pobreza por ingresos 
  a nivel de cantidad de personas estimada y porcentaje de la población, basándose 
  en datos de la Encuesta de Caracterización Socioeconómica Nacional (Casen) 2024 
  del Ministerio de Desarrollo Social y Familia.",
  arguments = list(
    comuna = type_string(
      description = "Comuna de Chile que se desea consultar"
      )
  )
)
```

Esto es como hacer una especie de **documentación** de la función, pero enfocada en que los modelos de lenguaje sepan cómo y cuándo usar la función.

{{< relacionada "/blog/herramientas_llm/" >}}

Para agregar herramientas al chatbot, basta con registrarlas en el objeto `chat` de esta manera:

```r
chat$register_tool(herramienta)
```

Esta línea se agrega dentro de `server`, luego de crear el chat. Así, cuando se pregunte algo que active la herramienta, **el modelo la usará automáticamente**.


{{< detalles "**Ver código del chatbot con herramienta de consulta de datos**" >}}

```r
library(shiny)
library(bslib)
library(ellmer)
library(shinychat)

# código de limpieza de datos
source("pobreza.R")

ui <- page_fillable(
  chat_ui(
    id = "chat",
    messages = "**¡Hola!** ¿En qué te puedo ayudar hoy?"
  ),
  fillable_mobile = TRUE
)

server <- function(input, output, session) {
  
  # definir herramienta
  herramienta <- tool(
    consultar_pobreza,
    description = "Función que entrega datos de la estimación de pobreza por ingresos 
  a nivel de cantidad de personas estimada y porcentaje de la población, basándose 
  en datos de la Encuesta de Caracterización Socioeconómica Nacional (Casen) 2024 
  del Ministerio de Desarrollo Social y Familia.",
    arguments = list(
      comuna = type_string(
        description = "Comuna de Chile que se desea consultar"
      )
    )
  )
  
  # crear chat
  chat <- chat_anthropic(
    model = "claude-haiku-4-5",
    system_prompt = "Eres un chatbot respetuoso, útil y conciso. Responde muy brevemente solamente lo que se te pregunta, sin rodeos."
  )
  
  # entregar la herramienta al modelo
  chat$register_tool(herramienta)
  
  observeEvent(input$chat_user_input, {
    stream <- chat$stream_async(input$chat_user_input)
    chat_append("chat", stream)
  })
}

shinyApp(ui, server)
```

{{< /detalles >}}

Ahora volvamos a probar el chatbot preguntándole lo mismo:

{{< imagen "chatbot_prueba_2.png" "400px" >}}

Ahora responde correctamente! 🥳 

Si nos fijamos en la consola, vemos que el chatbot consultó correctamente la herramienta, y se basó en ella para responder:

{{< imagen "chatbot_prueba_3.png" "360px" >}}

{{< relacionada "/blog/herramientas_llm/" "Instrucciones detalladas" >}}



## Darle conocimientos especializados al chatbot

Por ahora el modelo **responde correctamente desde los datos**, pero si le preguntamos otras cosas, deja de responder bien:

{{< imagen "chatbot_prueba_4.png" "360px" >}}

Si bien la cifra es correcta, al preguntarle algo sobre la metodología de los datos, responde algo genérico para **omitir que no sabe realmente** de dónde viene la información.

Para hacer que el chatbot **maneje conocimientos complejos o especializados**, y que además responda preguntas **limitándose a documentos específicos**, podemos entregarle una herramienta para [_generación aumentada por recuperación_ o RAG](/blog/rag_ragnar/). Esto significa que el modelo accederá a informes, manuales, papers, o cualquier material relevante para tu caso de uso.

Entonces descarguemos la metodología correspondiente a los datos que estamos trabajando:

{{< boton "Desacargar metodología de estimación de pobreza" "https://bidat.gob.cl/url/69eb619acd328" "fas fa-file-download" >}}

Con el paquete `{ragnar}` podemos crear una base de conocimientos a partir de nuestros documentos y conectarla al chatbot, [como se detalla en este tutorial](/blog/rag_ragnar/).

Primero tenemos que crear una base de conocimientos:

```r
library(ragnar)

store <- ragnar_store_create(
  location = "documentos.ragnar.duckdb",
  embed = NULL
)
```

Ahora cargamos los documentos y los procesamos:

```r
metodologia <- read_as_markdown("content/blog/shinychat/estimaciones-sae-2024.pdf")

metodologia <- markdown_chunk(metodologia)
```

Finalmente los insertamos en la base y creamos el índice para que funcione:

```r
ragnar_store_insert(store, informe_secciones)

ragnar_store_build_index(store)
```

{{< relacionada "/blog/rag_ragnar/" "Instrucciones detalladas" >}}

Ahora, en el código de nuestro chatbot, agregamos la **conexión a la base de conocimientos** y luego, después de la creación del chat, ponemos el **registro de la herramienta de RAG**:

```r
# conectarse a la base de conocimientos
store <- ragnar_store_connect("documentos.ragnar.duckdb", read_only = TRUE)
```

```r
# registrar la herramienta de búsqueda en el modelo
ragnar_register_tool_retrieve(
  chat,
  store,
  store_description = "Base de conocimientos sobre el reglamento interno de la empresa"
)
```

{{< detalles "**Ver código completo del chatbot con RAG**" >}}

```r
library(shiny)
library(bslib)
library(ellmer)
library(shinychat)
library(ragnar)

source("pobreza.R")

ui <- page_fillable(
  chat_ui(
    id = "chat",
    messages = "**¡Hola!** ¿En qué te puedo ayudar hoy?"
  ),
  fillable_mobile = TRUE
)

server <- function(input, output, session) {
  
  # definir herramienta
  herramienta <- tool(
    consultar_pobreza,
    description = "Función que entrega datos de la estimación de pobreza por ingresos 
  a nivel de cantidad de personas estimada y porcentaje de la población, basándose 
  en datos de la Encuesta de Caracterización Socioeconómica Nacional (Casen) 2024 
  del Ministerio de Desarrollo Social y Familia.",
    arguments = list(
      comuna = type_string(
        description = "Comuna de Chile que se desea consultar"
      )
    )
  )
  
  # crear chat
  chat <- chat_anthropic(
    model = "claude-haiku-4-5",
    system_prompt = "Eres un chatbot respetuoso, útil y conciso. Responde muy brevemente solamente lo que se te pregunta, sin rodeos."
  )
  
  # entregar la herramienta al modelo
  chat$register_tool(herramienta)
  
  # conectarse a la base de conocimientos
  store <- ragnar_store_connect("documentos.ragnar.duckdb", read_only = TRUE)
  
  # registrar la herramienta de búsqueda en el modelo
  ragnar_register_tool_retrieve(
    chat,
    store,
    store_description = "Base de conocimientos sobre metodología 
    de cálculo de estimaciones de pobreza Casen 2024"
  )
  
  observeEvent(input$chat_user_input, {
    stream <- chat$stream_async(input$chat_user_input)
    chat_append("chat", stream)
  })
}

shinyApp(ui, server)
```
{{< /detalles >}}

Igual que con las herramientas, esto va en el `server` junto al objeto `chat`. Una vez registrada, la IA decidirá cuándo necesita **consultar los documentos** para responder mejor, y lo hará automáticamente.

Ahora volvemos a probar el chatbot con una pregunta compleja:

{{< imagen "chatbot_prueba_5.png" "400px" >}}

Ahora sí, en vez de chamullar una respuesta, el chatbot se basa en el documento entregado para dar una **respuesta precisa informada por el texto!**

----



Con estos tres elementos (el chatbot base, las [herramientas de consulta de datos](/blog/herramientas_llm/) y la [consulta de documentos con RAG](/blog/rag_ragnar/)), y sumándole un buen _system prompt_, puedes construir en nada de tiempo asistentes de IA útiles y confiables, adaptados completamente a tus datos y necesidades, sin depender de ninguna plataforma de chat externa. 

Estos asistentes puedes ponerlos en [tus aplicaciones Shiny](/blog/shiny/) y luego [publicar tus apps a internet](/blog/shiny/#publicar-la-aplicación-en-internet), o insertarlos/embeberlos en otros sitios web.

{{< imagen "chatbot_1.png" "500px" >}}

Personalmente he desarrollado varios chatbots que consultan datos complejos de estudios, y su funcionamiento es excelente, incluso con los modelos de inteligencia artificial más pequeños, porque la gracia es que **R apoya a la IA con datos e información para responder correctamente**, en vez de depender de modelos de IA gigantes que aspiran a saberlo todo (cosa que es imposible).

{{< imagen "chatbot_4.png" "500px" >}}


{{< etiqueta "inteligencia artificial" >}}

{{< cafecito >}}
