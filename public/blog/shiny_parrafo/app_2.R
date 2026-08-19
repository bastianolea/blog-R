library(shiny)
library(bslib)

ui <- page_fillable(
  h1("Párrafo interactivo"),

  card(
    # inicio del texto
    span("En"),

    # selector de territorio
    selectInput(
      "territorio",
      label = NULL,
      c("Chile" = "Chile", "región" = "Región", "comuna" = "Comuna")
    ),

    # preposición "la" solamente aparece si se elige "región" o "comuna"
    span("la", id = "preposicion_territorio") |> hidden(),

    # selector de regiones
    selectInput(
      "region",
      label = NULL,
      choices = NULL
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

server <- function(input, output, session) {}

shinyApp(ui, server)
