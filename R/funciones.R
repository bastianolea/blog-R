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

  require(fs) |> suppressPackageStartupMessages()
  require(dplyr) |> suppressPackageStartupMessages()
  require(stringr) |> suppressPackageStartupMessages()

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


#' Revisar enlaces rotos por la reescritura de rutas de Quarto
#'
#' Cuando un `.qmd` pertenece a un proyecto Quarto (existe un `_quarto.yml`
#' en su carpeta o en alguna carpeta ancestra), Quarto reescribe cualquier
#' enlace markdown que empiece con `/` (pensado como ruta absoluta del sitio
#' Hugo, ej. `/blog/mi-post/` o `/tags/mi-tag/`) quitándole la barra inicial
#' y agregándole `./`, sin calcular la distancia real hacia la raíz del
#' proyecto. El resultado es un enlace roto (ej. `./blog/mi-post/`) que en
#' el sitio final se resuelve de forma incorrecta y arroja 404 (ver skill
#' `hugo-blog`, sección sobre reescritura de rutas absolutas de Quarto).
#'
#' Esta función recorre todos los `.qmd` del blog, ubica el `index.md`
#' generado en la misma carpeta, y busca en él enlaces markdown cuyo
#' destino empiece con `./` (la firma de este problema), avisando en qué
#' archivos aparecen para poder corregirlos (normalmente reemplazando la
#' ruta por una relativa manual con suficientes `../`, ej.
#' `../../../blog/mi-post/`, o por una URL completa).
#'
#' @param carpeta Carpeta del blog a revisar. Por defecto `"content/blog"`.
#'
#' @returns Un tibble con columnas `qmd`, `md`, `linea` y `enlace` con cada
#' coincidencia encontrada (invisible). Si no se encuentra ningún problema,
#' no retorna nada (`NULL`) y solo despliega un mensaje.
#' @export
revisar_enlaces_qmd <- function(carpeta = "content/blog") {
  require(fs) |> suppressPackageStartupMessages()
  require(stringr) |> suppressPackageStartupMessages()
  require(dplyr) |> suppressPackageStartupMessages()
  require(purrr) |> suppressPackageStartupMessages()
  require(tidyr) |> suppressPackageStartupMessages()

  # ubicar todos los .qmd del blog (recursivo, para incluir r_introduccion/)
  publicaciones_qmd <- fs::dir_ls(
    carpeta,
    recurse = TRUE,
    regexp = "\\.qmd$"
  ) |>
    stringr::str_subset("rsconnect", negate = TRUE)

  # para cada .qmd, revisar el index.md generado en la misma carpeta
  resultado <- purrr::map(
    publicaciones_qmd,
    \(qmd) {
      md <- fs::path(fs::path_dir(qmd), "index.md")

      # si no existe el .md generado, no hay nada que revisar todavía
      if (!fs::file_exists(md)) {
        return(NULL)
      }

      lineas <- readLines(md, warn = FALSE)

      # firma del problema: un enlace markdown cuyo destino empieza con "./"
      # (originalmente era una ruta absoluta del sitio, ej. "/blog/...",
      # que Quarto reescribió quitando la barra inicial)
      coincidencias <- stringr::str_extract_all(
        lineas,
        "\\]\\(\\./[^)]*\\)"
      )

      hay_coincidencia <- purrr::map_lgl(coincidencias, \(x) length(x) > 0)

      if (!any(hay_coincidencia)) {
        return(NULL)
      }

      dplyr::tibble(
        qmd = qmd,
        md = md,
        linea = which(hay_coincidencia),
        enlace = purrr::map(coincidencias[hay_coincidencia], identity)
      ) |>
        tidyr::unnest(enlace)
    }
  ) |>
    purrr::list_rbind()

  # avisar el resultado
  if (nrow(resultado) == 0) {
    cli::cli_alert_success(
      "No se encontraron enlaces rotos por reescritura de rutas de Quarto"
    )
    return(invisible(NULL))
  }

  archivos_afectados <- dplyr::n_distinct(resultado$qmd)

  texto_enlaces <- cli::pluralize(
    "Se encontr{?ó/aron} {nrow(resultado)} enlace{?s} roto{?s}"
  )
  texto_publicaciones <- cli::pluralize(
    "en {archivos_afectados} publicaci{?ón/ones}:"
  )
  cli::cli_alert_warning(
    paste(texto_enlaces, texto_publicaciones)
  )

  resultado |>
    dplyr::group_by(qmd) |>
    dplyr::group_walk(\(datos, llave) {
      message("\n- ", llave$qmd)
    })

  invisible(resultado)
}

#' Corregir enlaces internos reescritos por Quarto en posts .qmd
#'
#' Contraparte de [revisar_enlaces_qmd()]. Al renderizar un `.qmd` a
#' `hugo-md`, Quarto interpreta los enlaces absolutos del sitio (`/blog/...`,
#' `/tags/...`) como relativos a la raíz del proyecto Quarto y los reescribe a
#' `./blog/...`, lo que en Hugo apunta a la página actual y produce 404 (ver
#' skill `hugo-blog`). Esta función recorre los `index.md` generados junto a
#' cada `.qmd` y les devuelve la barra inicial a los enlaces cuyo primer
#' segmento es una sección conocida del sitio.
#'
#' Solo se tocan enlaces a secciones del sitio, de modo que las figuras y
#' recursos del bundle del post (`./index_files/...`, `./datos.csv`, etc.)
#' quedan intactos como rutas relativas.
#'
#' Pensada para ejecutarse desde `R/build.R` (antes de que Hugo construya el
#' sitio), pero también puede llamarse manualmente tras renderizar.
#'
#' @param carpeta Carpeta del blog a revisar. Por defecto `"content/blog"`.
#' @param secciones Primeros segmentos de ruta que corresponden a secciones o
#'   taxonomías del sitio y cuyos enlaces absolutos deben preservarse.
#' @returns Un tibble (invisible) con columnas `qmd`, `md`, `linea` y `enlace`,
#'   una fila por cada enlace corregido (con el `./` original), agrupado por
#'   publicación en el mensaje. Si no hubo nada que corregir, retorna `NULL` y
#'   muestra un mensaje.
#' @export
corregir_enlaces_qmd <- function(
  carpeta = "content/blog",
  secciones = c(
    "blog",
    "tags",
    "categories",
    "series",
    "apps",
    "about",
    "clases",
    "tutoriales",
    "paquetes",
    "buscar",
    "form"
  )
) {
  require(fs) |> suppressPackageStartupMessages()
  require(stringr) |> suppressPackageStartupMessages()
  require(purrr) |> suppressPackageStartupMessages()
  require(dplyr) |> suppressPackageStartupMessages()
  require(tidyr) |> suppressPackageStartupMessages()

  # prefijo ']( ./seccion/' que Quarto reescribió desde '/seccion/' (para reemplazar)
  patron <- paste0("\\]\\(\\./(", paste(secciones, collapse = "|"), ")/")
  # enlace completo roto, para mostrarlo en el reporte
  patron_extraer <- paste0(
    "\\]\\(\\./(?:",
    paste(secciones, collapse = "|"),
    ")/[^)]*\\)"
  )

  publicaciones_qmd <- fs::dir_ls(
    carpeta,
    recurse = TRUE,
    regexp = "\\.qmd$"
  ) |>
    stringr::str_subset("rsconnect", negate = TRUE)

  resultado <- purrr::map(
    publicaciones_qmd,
    \(qmd) {
      md <- fs::path(fs::path_dir(qmd), "index.md")

      if (!fs::file_exists(md)) {
        return(NULL)
      }

      lineas <- readLines(md, warn = FALSE)
      corregidas <- stringr::str_replace_all(lineas, patron, "](/\\1/")

      if (all(lineas == corregidas)) {
        return(NULL)
      }

      writeLines(corregidas, md)

      # capturar los enlaces corregidos (con el ./ original) para el reporte
      coincidencias <- stringr::str_extract_all(lineas, patron_extraer)
      hay_coincidencia <- purrr::map_lgl(coincidencias, \(x) length(x) > 0)

      dplyr::tibble(
        qmd = qmd,
        md = md,
        linea = which(hay_coincidencia),
        enlace = coincidencias[hay_coincidencia]
      ) |>
        tidyr::unnest(enlace)
    }
  ) |>
    purrr::list_rbind()

  if (is.null(resultado) || nrow(resultado) == 0) {
    cli::cli_alert_success("No hubo enlaces reescritos que corregir")
    return(invisible(NULL))
  }

  archivos_afectados <- dplyr::n_distinct(resultado$qmd)

  texto_enlaces <- cli::pluralize(
    "Se corrigi{?ó/eron} {nrow(resultado)} enlace{?s}"
  )
  texto_publicaciones <- cli::pluralize(
    "en {archivos_afectados} publicaci{?ón/ones}:"
  )

  cli::cli_alert_success(
    paste(texto_enlaces, texto_publicaciones)
  )

  resultado |>
    dplyr::group_by(qmd) |>
    dplyr::group_walk(\(datos, llave) {
      message("\n- ", llave$qmd)
    })

  invisible(resultado)
}
