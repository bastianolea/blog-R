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