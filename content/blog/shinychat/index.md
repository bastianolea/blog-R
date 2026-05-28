---
title: Crea un chatbot interactivo con R y Shiny
author: Bastián Olea Herrera
date: '2026-05-20'
slug: []
draft: true
categories:
  - ''
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
---

Con R y los paquetes apropiados, en pocos minutos podrás crear un chat interactivo dentro de una aplicación Shiny, para poder chatear con un modelo de lenguaje (LLM) de tu elección.

_**¿Por qué crear un chatbot con R?**_ 

- Te entrega el control total para elegir el proveedor de la inteligencia artificial, o el _cerebro_ que usará el chatbot, así como cambiarlo cuando sea necesario
- Permite que [complementes al chatbot con herramientas](/blog/herramientas_llm/): funciones de R que hacen posible que el chatbot realice tareas especializadas
- Puedes incluir el chatbot en cualquier parte de tu aplicación Shiny, lo que te da libertad para crear interfaces adaptadas a tus necesidades

{{< info "Este tutorial es la base para poder crear chatbots, cuyo objetivo principal es [ser complementados por herramientas](/blog/herramientas_llm/) para que sean más útiles y personalizados que un chat de IA común y corriente." >}}

{{< relacionada "/blog/herramientas_llm/" >}}

{{< relacionada "/blog/ellmer/" >}}

https://posit-dev.github.io/shinychat/r/index.html


https://posit.co/blog/custom-chat-app

```r
install.packages("shinychat")
```

```r
library(shiny)
library(bslib)

ui <- page_fluid(
  h1("Aplicación vacía")
)

server <- function(input, output, session) {
}

shinyApp(ui, server)
```

{{< relacionada "/blog/shiny/" >}}


```r
library(shiny)
library(bslib)
library(ellmer)
library(shinychat)

ui <- page_fillable(
  chat_ui(
    id = "chat",
    messages = "**Hello!** How can I help you today?"
  ),
  fillable_mobile = TRUE
)

server <- function(input, output, session) {
  chat <- chat_openai(
      system_prompt = "Respond to the user as succinctly as possible."
    )

  observeEvent(input$chat_user_input, {
    stream <- chat$stream_async(input$chat_user_input)
    chat_append("chat", stream)
  })
}

shinyApp(ui, server)
```

{{< relacionada "/blog/herramientas_llm/" >}}

{{< relacionada "/blog/funcion_consultar_datos/" >}}

{{< etiqueta "inteligencia artificial" >}}

{{< cafecito >}}