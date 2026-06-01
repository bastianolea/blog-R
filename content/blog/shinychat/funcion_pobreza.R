pobreza

consultar_pobreza <- function(comuna) {
  message("comuna elegida: ", comuna)
  
  pobreza |> 
    filter(nombre_comuna == comuna) |> 
    select(nombre_comuna, region, 
           pobreza_personas, pobreza_porcentaje,
           pobreza_porcentaje_inf, pobreza_porcentaje_sup) |> 
    glimpse()
}

consultar_pobreza("Maipú")



# registrar una función de R como herramienta para la IA
library(ellmer)

herramienta <- tool(
  consultar_pobreza,
  description = "Función que entrega datos de la estimación de pobreza por ingresos 
  a nivel de cantidad de personas estimada y porcentaje de la población, basándose 
  en datos de la Encuesta de Caracterización Socioeconómica Nacional (Casen) 2024 
  del Ministerio de Desarrollo Social y Familia.",
  arguments = list(
    comuna = type_string(
      description = "Comuna de Chile que se desea consultar"
      )
  )
)

# entregar la herramienta al modelo
chat$register_tool(herramienta)