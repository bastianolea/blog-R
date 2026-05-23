# global
library(shiny)
library(bslib)
library(readxl)
library(glue)
library(forcats)
library(ggplot2)

# cargar datos
datos <- read_excel("datos.xlsx")

# interfaz
ui <- page_sidebar(
  # contenido de la app que estará dentro de la barra lateral
  sidebar = sidebar(
    # selector de regiones
    selectInput(
      inputId = "region",
      label = "Explorar regiones",
      choices = sort(unique(datos$region))
    ),

    # selector de observaciones máximas
    sliderInput(
      inputId = "maximo",
      label = "Cantidad de resultados",
      min = 3,
      max = 15,
      value = 6,
      step = 1,
      width = "100%"
    )
  ),

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

  # # párrafo markdown
  # markdown(
  #   "Los **campamentos** son definidos por el
  #          [Minvu](https://www.minvu.gob.cl/catastro-campamentos-2022/)
  #          como _Asentamientos de ocho o más viviendas precarias que
  #          habitan en posesión irregular un terreno, con carencia de
  #          servicios básicos, agrupadas y contiguas._"
  # ),
  div(
    style = "margin: 6px; padding: 12px; padding-bottom: 0px; border-radius: 7px; background-color: #EDEDED;",
    markdown(
      "Los **campamentos** son definidos por el
             [Minvu](https://www.minvu.gob.cl/catastro-campamentos-2022/)
             como _Asentamientos de ocho o más viviendas precarias que
             habitan en posesión irregular un terreno, con carencia de
             servicios básicos, agrupadas y contiguas._"
    )
  ),

  # salida de texto de conteo de observaciones
  textOutput("casos_region"),

  # salida de gráfico
  plotOutput("grafico_barras_region"),
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

  # gráfico de barras
  output$grafico_barras_region <- renderPlot({
    # filtrar por región
    datos_region <- datos |>
      filter(region == input$region)

    # limitar cantidad de casos y ordenar
    datos_region_grafico <- datos_region |>
      slice_max(hogares, n = input$maximo) |>
      mutate(nombre = fct_reorder(nombre, hogares))

    # gráfico
    datos_region_grafico |>
      ggplot() +
      aes(hogares, nombre) +
      geom_col(width = 0.7) +
      geom_text(
        aes(label = hogares),
        hjust = 1.3,
        color = "white",
        fontface = "bold"
      ) +
      scale_x_continuous(expand = 0) +
      theme_minimal(base_family = "Arial", base_size = 13) +
      theme(
        axis.title.y = element_blank(),
        axis.text.y = element_text(face = "bold")
      )
  })
}

# ejecutar la app
shinyApp(ui, server)
