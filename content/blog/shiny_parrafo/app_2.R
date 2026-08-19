library(shiny)
library(bslib)
library(shinyjs)

ui <- page_fillable(
  useShinyjs(),

  h1("Párrafo interactivo"),

  card(
    # inicio del texto
    span("En"),

    # preposición "la" para decir "la región"
    span("la", id = "preposicion_territorio") |> hidden(),

    # selector de territorio
    selectInput(
      "territorio",
      label = NULL,
      c("Chile", "región", "comuna")
    ),

    # # preposición "de" para decir "región de"
    span("de"),

    # selector de regiones
    selectInput(
      "region",
      label = NULL,
      choices = territorial::regiones()
    ) |>
      hidden(),

    # artículo de la variable
    span("el"),

    # selector de variable
    selectInput(
      "variable",
      label = NULL,
      c(
        "porcentaje" = "pobreza_porcentaje",
        "cantidad" = "pobreza_personas"
      )
    ),

    span("de personas que vive en situación de pobreza es de"),

    # cifra
    strong("cifra")
  )
)

server <- function(input, output, session) {
  #
  # mostrar/ocultar preposición y selector de regiones
  observe({
    if (input$territorio == "región") {
      show("preposicion_territorio")
      show("region")
    } else {
      hide("preposicion_territorio")
      hide("region")
    }
  })
}

shinyApp(ui, server)
