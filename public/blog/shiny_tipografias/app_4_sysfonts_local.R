# Ejemplo 4: tipografía en gráficos con archivos .ttf locales
#
# Primero, ejecutar esto una sola vez para descargar la fuente:
# gfonts::setup_font("manrope", "fonts/")
#
# Esto creará archivos .ttf dentro de fonts/fonts/
# Revisa los nombres exactos de los archivos descargados

library(shiny)
library(bslib)
library(ggplot2)
library(sysfonts)
library(showtext)

font_add(
  family = "Manrope",
  regular = "fonts/fonts/manrope-v20-latin-regular.ttf",
  bold = "fonts/fonts/manrope-v20-latin-800.ttf"
)

showtext_auto()
showtext_opts(dpi = 170)

ui <- page_fluid(
  gfonts::use_font("manrope", "www/css/manrope.css"),

  theme = bs_theme(
    base_font = "manrope"
  ),

  h1("App con tipografía local (UI + gráficos)"),
  p("Manrope se carga localmente tanto para la interfaz (gfonts) como para los gráficos (sysfonts)."),

  sliderInput("filtro", label = "Filtrar largo mínimo del sépalo",
              min = 4, max = 8, value = 5, step = 0.5),

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
      theme_minimal(base_family = "Manrope", base_size = 14) +
      theme(
        plot.title = element_text(face = "bold")
      )
  })
}

shinyApp(ui, server)
