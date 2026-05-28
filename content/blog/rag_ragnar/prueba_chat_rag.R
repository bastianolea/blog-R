library(ellmer)
library(ragnar)
library(readr)

# conectarse a la base de documentos/embeddings
store <- ragnar_store_connect("documentos.ragnar.duckdb", read_only = TRUE)

# iniciar chat con LLM
chat <- chat_anthropic(model = "claude-haiku-4-5")


# tool calling
ragnar_register_tool_retrieve(
  chat,
  store,
  top_k = 3,
  store_description = "Consulta de base de conocimientos sobre el 
                       Estudio de Brechas Comunales (EBC), que contiene 
                       la metodología, marco teórico e interpretación de 
                       resultados del estudio."
)

# volver a preguntar
chat$chat("¿Qué es el EBC? Responde brevemente")

# ◯ [tool call] search_store_001(text = c("qué es el Estudio de Brechas Comunales EBC", ...)
# ● #> [
#   #>  {
#   #>  "origin": "informe_estudio_brechas_comunales.md",
#   #>  "doc_id": 1,
#   #>  "chunk_id": 14,
#   #> …
# El **Estudio de Brechas Comunales (EBC)** es un instrumento que identifica y mide las
# **disparidades territoriales a nivel comunal** en la provisión de bienes, servicios e
# infraestructura pública en Chile.
#
# Su objetivo es diagnosticar dónde se concentran las mayores carencias en cada territorio,
# permitiendo a los gobiernos:
# - Priorizar inversiones públicas de manera más eficiente
# - Dirigir recursos hacia las comunas y grupos más afectados
# - Diseñar políticas públicas que respondan a necesidades específicas de cada territorio
#
# El estudio abarca múltiples ámbitos como educación, salud, transporte, servicios básicos (agua,
#                                                                                           electricidad, saneamiento), telecomunicaciones y otros, considerando las características
# particulares de las comunas urbanas, mixtas y rurales.

chat$chat("¿qué indicadores tienen relación a bicicletas?")
# ◯ [tool call] search_store_001(text = c("indicadores bicicletas movilidad activa", ...)
# ● #> [
#   #>  {
#   #>  "origin": "informe_estudio_brechas_comunales.md",
#   #>  "doc_id": 1,
#   #>  "chunk_id": 1,
#   #> …
# Según el EBC, los indicadores con relación a bicicletas se encuentran en el **ámbito de Ciclovías**
#   y son:
#
# 1. **Cicloinclusión** (red de ciclovías bien conectada y estratégicamente ubicada)
# - Mide la funcionalidad de la infraestructura ciclista
# - Evalúa si la red de ciclovías conecta orígenes y destinos relevantes
# - Índice entre 0 y 1
# - Fuente: Ministerio de Transportes y Telecomunicaciones (2024)
#
# 2. **Porcentaje de cobertura de la red de ciclovía sobre la red vial**
# - Mide la proporción de la red vial dedicada a ciclovías
# - Permite cuantificar la relevancia de la movilidad activa como alternativa sustentable
# - Expresado en porcentaje de la red vial
# - Fuente: SIEDU (2018)
#
# El **74,4% de las comunas presentan brechas en cicloinclusión**, lo que indica deficiencias
# significativas en infraestructura de ciclovías bien conectada.
