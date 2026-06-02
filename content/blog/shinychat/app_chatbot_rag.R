library(shiny)
library(bslib)
library(ellmer)
library(shinychat)
library(ragnar)

# código de limpieza de datos
source("datos_pobreza.R")

# código de la función de consulta de datos
source("funcion_pobreza.R")

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