# global
library(shiny)
library(bslib)
library(readxl)
library(glue)

# cargar datos
datos <- read_excel("datos.xlsx")

# interfaz
ui <- page_fillable(
  # título
  h1("Campamentos en Chile"),

  # párrafo
  p(
    glue(
      "Aplicación Shiny para explorar 
         los datos de los {nrow(datos)} 
         campamentos registrados en Chile."
    )
  ),

  # párrafo markdown
  markdown(
    "Los **campamentos** son definidos por el 
           [Minvu](https://www.minvu.gob.cl/catastro-campamentos-2022/) 
           como _Asentamientos de ocho o más viviendas precarias que 
           habitan en posesión irregular un terreno, con carencia de 
           servicios básicos, agrupadas y contiguas._"
  ),

  # selector de regiones
  selectInput(
    inputId = "region",
    label = "Explorar regiones",
    choices = sort(unique(datos$region))
  ),

  # salida de texto de conteo de observaciones
  textOutput("casos_region")
)

# servidor
server <- function(input, output) {
  # conteo de casos filtrados por región
  output$casos_region <- renderText({
    conteo <- datos |>
      filter(region == input$region) |>
      nrow()

    glue("{input$region} tiene registrados {conteo} casos.")
  })
}

# ejecutar la app
shinyApp(ui, server)
