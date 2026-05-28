library(ellmer)

chat <- chat_anthropic(model = "claude-haiku-4-5")

chat$chat("¿Qué es el Estudio de Brechas Comunales? Responde brevemente")

# > El Estudio de Brechas Comunales es una herramienta
# de análisis que identifica y mide las diferencias entre
# la situación actual de una comunidad y los estándares
# deseables en servicios básicos e infraestructura.
