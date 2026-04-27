library(shiny)
library(bslib)

ui <- page_fluid(
  h1("Título"),
  p("Texto dentro de la app")
)

shinyApp(ui, server = \(){})
