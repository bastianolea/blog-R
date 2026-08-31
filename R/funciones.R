#' Lista de publicaciones recientes
#'
#' Ejecutar para recibir una lista de los scripts más recientes en la carpeta de publicaciones del blog, y según el número que se entregue, el script se abre para editarlo.
#' @param modo Elige si mostrar archivos recientes según "creado" (creados recientemente) o "modificado" (editados recientemente)
#' @param cantidad Cantidad de scripts recientes a entregar
#'
#' @returns No retorna nada, sino que abre el script respectivo en RStudio.
#' @export
abrir_publicacion_reciente <- function(modo = "creado", cantidad = 5) {
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
    recientes <- carpetas |>
      slice_max(birth_time, n = cantidad) |>
      arrange(desc(birth_time))
  } else if (modo == "modificado") {
    recientes <- carpetas |>
      slice_max(modification_time, n = cantidad) |>
      arrange(desc(modification_time))
  }

  # dar a elegir entre las 3
  eleccion <- menu(
    recientes$path,
    title = str_glue("Archivos {modo}s recientemente:")
  )

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

  message(paste("abriendo", archivo))

  # abrir archivo con RStudio
  invisible(rstudioapi::navigateToFile(archivo))

  # navegar el panel Files a la carpeta de la nueva publicación
  rstudioapi::filesPaneNavigate(dirname(archivo))
}


#' Crear una nueva publicación
#'
#' Envoltorio de `blogdown::new_post()` que además crea automáticamente un
#' archivo `_quarto.yml` (vacío) en la carpeta de la publicación cuando esta
#' es un archivo `.qmd`. Esto es necesario para que el botón Render de
#' RStudio funcione sin errores con `quarto preview` (ver skill `hugo-blog`,
#' sección "quarto preview requiere _quarto.yml").
#'
#' @param ... Todos los argumentos se pasan directamente a `blogdown::new_post()`
#' (`title`, `file`, `author`, `tags`, `categories`, etc.)
#'
#' @returns La ruta del archivo creado (invisible).
#' @export
crear_publicacion <- function(...) {
  require(stringr)

  archivo <- blogdown::new_post(...)

  # si la publicación es un archivo quarto, crear su _quarto.yml
  if (str_detect(archivo, "\\.qmd$")) {
    carpeta <- dirname(archivo)
    ruta_yml <- file.path(carpeta, "_quarto.yml")

    if (!file.exists(ruta_yml)) {
      file.create(ruta_yml)
      message(
        "Se creó ",
        ruta_yml,
        " para que el botón Render funcione correctamente."
      )
    }
  }

  # navegar el panel Files a la carpeta de la nueva publicación
  rstudioapi::filesPaneNavigate(dirname(archivo))

  invisible(archivo)
}


#' Lista de borradores recientes
#'
#' Ejecutar para recibir una lista de los borradores más recientes en la carpeta de publicaciones del blog, y según el número que se entregue, el script se abre para editarlo.
#' @param cantidad Cantidad de borradores recientes a entregar
#'
#' @returns No retorna nada, sino que abre el script respectivo en RStudio.
#' @export
abrir_borradores <- function(cantidad = 5) {
  # ruta a documentos
  publicaciones <- fs::dir_ls(
    "content/blog/",
    recurse = TRUE,
    regexp = ".md$|.qmd$"
  ) |>
    stringr::str_subset(
      "rsconnect",
      negate = TRUE
    )

  # archivos[349]

  # filtrar los que son borrador
  borradores <- purrr::map(
    publicaciones,
    \(archivo) {
      # leer archivos de texto
      lineas <- readLines(archivo, warn = F)

      # unir primeras líneas
      texto <- paste(lineas[1:20], collapse = " ")

      # confirmar si es borrador
      es_borrador <- agrepl("draft: true", texto)

      # retornar ruta
      if (es_borrador) {
        return(archivo)
      } else {
        return(NULL)
      }
    }
  ) |>
    purrr::list_c()

  borradores

  # pasar a tabla
  tabla_borradores <- dplyr::tibble(archivo = borradores) |>
    dplyr::mutate(carpeta = fs::path_dir(archivo)) |>
    dplyr::mutate(fecha = fs::file_info(archivo)$modification_time)

  # priorizar qmd
  publicaciones_borradores <- tabla_borradores |>
    dplyr::mutate(
      orden = dplyr::case_when(
        stringr::str_detect(archivo, ".qmd$") ~ 1,
        stringr::str_detect(archivo, ".md$") ~ 2
      )
    ) |>
    dplyr::arrange(carpeta, orden) |>
    dplyr::distinct(carpeta, .keep_all = TRUE) |>
    dplyr::arrange(dplyr::desc(fecha))

  # dar a elegir entre las 3
  eleccion <- menu(
    publicaciones_borradores |>
      dplyr::slice_max(fecha, n = cantidad) |>
      dplyr::pull(carpeta),
    title = stringr::str_glue("Borradores recientes:")
  )

  elegido <- publicaciones_borradores |>
    dplyr::slice(eleccion)

  message(paste("abriendo", elegido$archivo))

  # abrir archivo con RStudio
  invisible(rstudioapi::navigateToFile(elegido$archivo))

  # navegar el panel Files a la carpeta de la nueva publicación
  rstudioapi::filesPaneNavigate(elegido$carpeta)
}
