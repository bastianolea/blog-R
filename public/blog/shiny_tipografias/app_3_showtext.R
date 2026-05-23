# Ejemplo 3: tipografía en gráficos ggplot2 con showtext + Google Fonts
library(shiny)
library(bslib)
library(ggplot2)
library(showtext)

font_add_google("Playfair Display", "playfair-display")
showtext_auto()
showtext_opts(dpi = 170)

ui <- page_fluid(
  theme = bs_theme(
    base_font = font_google("Playfair Display")
  ),

  h1("App con tipografía en gráficos"),
  p(
    "La tipografía Playfair Display se usa tanto en la interfaz como en el gráfico."
  ),

  sliderInput(
    "filtro",
    label = "Filtrar largo mínimo del sépalo",
    min = 4,
    max = 8,
    value = 5,
    step = 0.5
  ),

  plotOutput("grafico", width = 500, height = 350)
)

server <- function(input, output, session) {
  output$grafico <- renderPlot({
    datos <- iris[iris$Sepal.Length >= input$filtro, ]

    ggplot(datos, aes(Sepal.Length, Sepal.Width, color = Species)) +
      geom_point(size = 2.5) +
      labs(
        title = "Largo vs ancho del sépalo",
        x = "Largo del sépalo",
        y = "Ancho del sépalo"
      ) +
      theme_minimal(base_family = "playfair-display", base_size = 14) +
      theme(
        plot.title = element_text(face = "bold")
      )
  })
}

shinyApp(ui, server)
