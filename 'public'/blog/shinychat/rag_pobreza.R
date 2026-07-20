library(ragnar)

store <- ragnar_store_create(
  location = "content/blog/shinychat/documentos.ragnar.duckdb",
  embed = NULL
)

metodologia <- read_as_markdown("content/blog/shinychat/estimaciones-sae-2024.pdf")

metodologia <- markdown_chunk(metodologia)

ragnar_store_insert(store, metodologia)

ragnar_store_build_index(store)
