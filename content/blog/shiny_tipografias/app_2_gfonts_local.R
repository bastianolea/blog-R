# Ejemplo 2: tipografía descargada localmente con gfonts
#
# Primero, ejecutar esto una sola vez para descargar la fuente:
# gfonts::setup_font("playfair-display", "content/blog/shiny_tipografias/www/")

library(shiny)
library(bslib)

ui <- page_fluid(
  gfonts::use_font("playfair-display", "www/css/playfair-display.css"),

  theme = bs_theme(
    base_font = "Playfair Display"
  ),

  h1("Título de la app"),
  p("Este texto usa la tipografía Playfair Display, descargada localmente."),
  p("No requiere conexión a internet para cargar la fuente."),

  selectInput(
    "animal",
    label = "Animalito",
    choices = c("Gatito", "Gallineta", "Ratita")
  ),

  sliderInput(
    "tamaño",
    label = "Tamaño",
    min = 16,
    max = 128,
    value = 48,
    ticks = FALSE
  ),

  htmlOutput("animales")
)

server <- function(input, output, session) {
  output$animales <- renderUI({
    emojis <- c("Gatito" = "🐈", "Gallineta" = "🐓", "Ratita" = "🐁")
    div(
      h3(em(input$animal)),
      div(
        emojis[input$animal],
        style = css(font_size = paste0(input$tamaño, "px"))
      )
    )
  })
}

shinyApp(ui, server)
