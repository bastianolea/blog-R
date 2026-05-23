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
    glue("Aplicación Shiny para explorar 
         los datos de los {nrow(datos)} 
         campamentos registrados en Chile.")
  ),
  
  # párrafo markdown
  markdown("Los **campamentos** son definidos por el 
           [Minvu](https://www.minvu.gob.cl/catastro-campamentos-2022/) 
           como _Asentamientos de ocho o más viviendas precarias que 
           habitan en posesión irregular un terreno, con carencia de 
           servicios básicos, agrupadas y contiguas._"),
  
  selectInput(
    inputId = "region",
    label = "Explorar regiones",
    choices = sort(unique(datos$region))
    )
)

# servidor
server <- function(input, output) {}

# ejecutar la app
shinyApp(ui, server)
