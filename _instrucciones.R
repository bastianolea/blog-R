# previsualizar sitio
blogdown::serve_site()
blogdown::stop_server()
blogdown::build_site()


## posts ----

# editar el más reciente
abrir_post_reciente("creado", cantidad = 10)
abrir_post_reciente("modificado", cantidad = 10)


# crear un post normal
blogdown::new_post(
  title = "Palíndromos de Chile",
  file = paste0("blog/", lubridate::today(), "/index.qmd"),
  author = "Bastián Olea Herrera",
  tags = c("visualización de datos", "mapas")
)

# crear un post tutorial
blogdown::new_post(
  title = "Aumenta el conocimiento especializado de inteligencias artificiales creando un sistema de RAG con R",
  file = "blog/ragnar/index.md",
  author = "Bastián Olea Herrera",
  tags = c("inteligencia artificial"),
  categories = c("")
)

# draft: true
# format:
#   hugo-md:
#     output-file: "index"
#     output-ext: "md"

# links:
#   - icon: file-code
#     icon_pack: fas
#     name: Código
#     url: https://gist.github.com/bastianolea/8ea85fa8169b302d2144e05434668c89

## borradores ----
"content/blog/ggplot_densidad_puntos/index.qmd"
"content/blog/mapas_bivariados/index.qmd"
"content/blog/unpivotr/index.qmd"
"content/blog/posit_assistant/index.md"
# tutorial mapas: poner puntos a partir de tablas de datos en centroides
"content/blog/ggtext/index.qmd"
"content/blog/ggplot_numeros/index.qmd"
"content/blog/ggplot_ordenar/index.qmd" #unir estos dos en ggplot_ajustes o algo así
"content/blog/ggplot_sankey/index.qmd"
"content/blog/googledrive/index.qmd"


# ideas ----
# tip shiny actualizar css
# {futurize} https://www.jottr.org/2026/01/22/futurize-0.1.0/
# hacer que R te pregunte cosas
# mapas de chile con comunas pero sin líneas en la costa
# pildoritas en shiny y en ggiraph
# subir apps Shiny a posit connect
# tablas gt con flechitas
# datos de género en chile (mmeg, subcomisión, datos.gob, red chilena, ibg)
# How do I replace NA values with zeros in an R dataframe?
# https://www.linkedin.com/feed/update/urn:li:activity:7405241344316841984?utm_source=share&utm_medium=member_desktop&rcm=ACoAAB9if5MBe0keh4VrsmJOFbZxmIK9T9GSkYM
"content/blog/dt_tablas/index.qmd"
"content/blog/2025-07-06/index.qmd" # cargar y unir datos
"https://cran.r-project.org/web/packages/janitor/vignettes/tabyls.html" # plagiar
"https://github.com/rundel/livecode"
"content/blog/2025-07-01/index.qmd" # st_join

"content/blog/web_scraping_github_actions/github_actions_scraping.qmd"

# constantes
"content/blog/mapas_sf/mapas_sf.qmd"
"content/blog/git_comandos/index.md"
"content/blog/r_introduccion/recursos_r/index.md" # enlaces

# en construcción
"content/blog/mapas_sf/mapas_sf.qmd"

"content/blog/shiny_validacion/index.md"
"content/blog/tutorial_digitalocean/index.md"

# casi listos
"content/blog/shiny_tipografias/shiny_tipografias.qmd"


## shortcodes ----

# {{< indice >}}
# {{< cafecito >}}
# {{< cursos >}}
# {{< bajada "x" >}}
# {{< imagen "x" >}}
# {{< imagen_tamaño "x" "300px" >}}
# {{< video "x" >}}
# {{< aviso "x" >}}
# {{< info "x" >}}
# {{< detalles "Hola" >}} {{< /detalles >}}

# {{< boton "Buscador" "https://bastianoleah.shinyapps.io/buscador/" "fas fa-search" >}}
# {{< boton "Desacargar datos" "https://bastianoleah.shinyapps.io/buscador/" "fas fa-file-download" >}}
# {{< relacionada "blog/estudio_brechas_comunales/" >}}
# {{< etiqueta "apps" >}}
# {{< categoria "Tutoriales" "Más tutoriales de R" >}}
# {{< externo "Galería de apps Shiny"
#   "https://bastianolea.github.io/shiny_apps/"
#   "shiny_apps.png"
#   "Descripción"
#   "Página recomendada" >}}

# íconos
# <i class='fas fa-chalkboard-user'></i>
# <i class='fas fa-chalkboard-user' style='font-size: 200%'></i>

# destacar código
# ```r {hl_lines=["5-9"]}

## archivos ----
"content/blog/r_introduccion/recursos_r/index.md" # páginas
"assets/tema-morado-hex.scss" # tema
"config.toml" # configuración

"layouts/index.html" #index
"layouts/partials/shared/summary.html" # posts individuales en página de blog
"layouts/partials/shared/summary-thumbnail.html" # posts individuales en las páginas de cada tag
"layouts/blog/single-sidebar.html" # html de los post
"layouts/taxonomy/taxonomy.html" # html de la página de tags (/tags/)

"layouts/index.json" # genera el sitio en JSON para el buscador (el archivo queda en public como index.json)
"layouts/partials/shared/sidebar/sidebar-header.html" # sidebar del blog

"assets/custom.scss" # css del sitio
"static/css/syntax.css" # css del syntax higlight

"static/_redirects" # redirección de posts con cambio de nombre

## utilidades ----

# convertir script a Quarto
convertr::r_to_qmd(
  input_dir = "~/Documents/Clases R/Clases SpatialLab/Cursos/curso_intro/nivel_3-visualizaciones/clase_2.R",
  output_dir = "content/blog/tutorial_visualizacion_ggplot/clase_2.qmd"
)

# ver en github
usethis::browse_github()
