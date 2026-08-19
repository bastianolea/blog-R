library(shiny)
library(bslib)

ui <- page_fillable(
  h1("Párrafo interactivo"),

  card(
    p("Párrafo")
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)
