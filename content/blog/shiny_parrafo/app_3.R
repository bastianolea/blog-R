
# preposición de la región depende de la región elegida ("de"/"del"/"de la")
textOutput("total_preposicion_region", inline = TRUE) |> hidden(),

# selector de regiones
selectInput(
  "total_selector_region",
  label = NULL,
  choices = regiones()
) |>
  hidden(),

# preposición fija para comunas ("de")
span("de", id = "total_preposicion_comuna") |> hidden(),

# selector de comunas
selectInput(
  "total_selector_comuna",
  label = NULL,
  choices = sort(unique(pobreza$nombre_comuna))
) |>
  hidden(),

span(",", style = "margin-left: -3px;"),

### variable ----
# artículo dependiendo de la variable elegida ("el" / "la")
textOutput("total_articulo_variable", inline = TRUE),

# porcentaje/cantidad
selectInput(
  "total_variable",
  label = NULL,
  c(
    "porcentaje" = "pobreza_porcentaje",
    "cantidad" = "pobreza_personas"
  )
),

"de personas que vive en situación de pobreza es de",

### cifra ----
strong(textOutput("total_valor", inline = TRUE)),
"."
)
)

server <- function(input, output, session) {}

shinyApp(ui, server)
