# global
library(shiny)
library(bslib)

# interfaz
ui <- page_fluid(
  h1("Título"),
  p("Texto dentro de la app")
  )

# servidor
server <- function(input, output) {
}

# ejecutar la app
shinyApp(ui, server) 