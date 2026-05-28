library(ragnar)

# setwd("~/Documents/Otros/blog-r/content/blog/ragnar")

# crear base de conocimiento
store <- ragnar_store_create(
  location = "documentos.ragnar.duckdb",
  embed = \(x) ragnar::embed_ollama(x, model = "nomic-embed-text")
)

# cargar los documentos y cortarlos en partes

# informe de entrega del proyecto
informe <- read_as_markdown("informe_estudio_brechas_comunales.md")

#' <ragnar::MarkdownDocument> chr "# ESTUDIO DE BRECHAS COMUNALES\n\n## PRESENTACIÓN DE LA AUTORIDAD SUBDERE\n\nEste informe se hace cargo del man"| __truncated__
#' @ origin: chr "informe_estudio_brechas_comunales.md"

informe_secciones <- markdown_chunk(informe)

# # @document@origin: informe_estudio_brechas_comunales.md
# # A tibble:         295 × 4
# start   end context                                                                         text
# * <int> <int> <chr>                                                                           <chr>
# 1     1  1766 ""                                                                              "# E…
# 2   659  2541 "# ESTUDIO DE BRECHAS COMUNALES\n## RESUMEN DEL ESTUDIO"                        "Par…
# 3  1767  3212 "# ESTUDIO DE BRECHAS COMUNALES\n## RESUMEN DEL ESTUDIO"                        "Dur…
# 4  2542  3764 "# ESTUDIO DE BRECHAS COMUNALES\n## RESUMEN DEL ESTUDIO"                        "A p…
# 5  3213  4746 "# ESTUDIO DE BRECHAS COMUNALES\n## RESUMEN DEL ESTUDIO"                        "Ade…
# 6  3765  5782 "# ESTUDIO DE BRECHAS COMUNALES\n## RESUMEN DEL ESTUDIO"                        "Adi…
# 7  4747  6365 "# ESTUDIO DE BRECHAS COMUNALES\n## RESUMEN DEL ESTUDIO"                        "A p…
# 8  5783  7186 "# ESTUDIO DE BRECHAS COMUNALES\n## RESUMEN DEL ESTUDIO"                        "Por…
# 9  6366  8043 "# ESTUDIO DE BRECHAS COMUNALES\n## OBJETIVOS DEL ESTUDIO"                      "###…
# 10  7187  8927 "# ESTUDIO DE BRECHAS COMUNALES\n## BRECHAS Y DISPARIDADES TERRITORIALES A NIV… "No …
# # ℹ 285 more rows
# # ℹ Use `print(n = ...)` to see more rows

# insertar en el almacenamiento de documentos
ragnar_store_insert(store, informe_secciones)

# construir índice
ragnar_store_build_index(store)

# probar búsqueda
respuesta <- ragnar_retrieve(store, "indicador vías para bicicletas")

respuesta$text

# [1] "#### Ciclovías\nEl desarrollo de sistemas de ciclovías en las ciudades
# genera numerosas externalidades positivas que contribuyen a mejorar la calidad
# de vida de los ciudadanos, promover la sostenibilidad urbana y construir ciudades
# más saludables. Tiene un impacto directo en la salud de los ciudadanos, promoviendo...

# [2] "##### Origen y selección de indicadores:\nEl levantamiento de información y la
# selección de los indicadores incorporados en este estudio, están directamente
# relacionados a infraestructura y servicios en base a los ámbitos definidos en el
# alcance y su identificación tiene como propósito permitir un análisis teórico-conceptual
# de brechas.\n\nDurante el proceso de levantamiento
