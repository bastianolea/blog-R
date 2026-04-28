
#' Lista de publicaciones recientes
#'
#' Ejecutar para recibir una lista de los scripts más recientes en la carpeta de publicaciones del blog, y según el número que se entregue, el script se abre para editarlo.
#' @param modo Elige si mostrar archivos recientes según "creado" (creados recientemente) o "modificado" (editados recientemente)
#' @param cantidad Cantidad de scripts recientes a entregar
#'
#' @returns No retorna nada, sino que abre el script respectivo en RStudio.
#' @export
abrir_post_reciente <- function(modo = "creado", cantidad = 5) {
  # de todas las carpetas con posts, presentar las más recientes,
  # y abrir el archivo quarto o markdown de la carpeta elegida
  
  require(fs)
  require(dplyr)
  require(stringr)
  
  # obtener todas las carpetas del blog
  carpetas <- bind_rows(
    dir_info("content/blog", type = "directory"),
    dir_info("content/blog/r_introduccion/", type = "directory"),
    dir_info("content/clases/", type = "directory")
  )
  
  # filtrar las x más recientes según el modo que se elija
  if (modo == "creado") {
    recientes <- carpetas |> slice_max(birth_time, n = cantidad)
    
  } else if (modo == "modificado") {
    recientes <- carpetas |> slice_max(modification_time, n = cantidad)
  }
  
  # dar a elegir entre las 3
  eleccion <- menu(recientes$path, 
                   title = str_glue("Archivos {modo}s recientemente:"))
  
  # salir si se elige cero
  if (eleccion == 0) {
    stop("chaito")
  }
  
  # carpeta elegida
  elegido <- recientes$path[eleccion]
  
  # archivos dentro de la carpeta elegida
  archivos <- dir_info(elegido, regexp = "\\.qmd|\\.md") |> 
    pull(path)
  
  # revisar si uno de ellos es quarto
  hay_quarto <- str_detect(archivos, "\\.qmd")
  
  # si hay quarto, abrir ese, y si no, abrir markdown
  if (any(hay_quarto)) {
    archivo <- str_subset(archivos, "\\.qmd")[1]
  } else {
    archivo <- str_subset(archivos, "\\.md")[1]
  }
  
  # abrir archivo con RStudio
  rstudioapi::navigateToFile(archivo)
}
