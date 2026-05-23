library(shiny)
library(bslib)

ui <- page_fluid(
  theme = bs_theme(
    bg = "#EAD1FA",
    fg = "#553A74",
    primary = "#8557AB",
    base_font = font_google("Manrope"),
    heading_font = font_google("Domine")
  ),

  br(),
  h1("Título con Domine"),
  h3("Subtítulo con Domine"),
  p("Este texto usa la tipografía Manrope, cargada desde Google Fonts."),

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
