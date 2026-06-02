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

# consultar_pobreza("Maipú")
