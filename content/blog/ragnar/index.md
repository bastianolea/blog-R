---
title: Aumenta el conocimiento especializado de inteligencias artificiales creando
  un sistema de RAG con R
author: Bastián Olea Herrera
date: '2026-05-28'
draft: true
tags:
  - inteligencia artificial
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: registered
    icon_pack: fas
    name: Ragnar
    url: https://ragnar.tidyverse.org
---


La _generación aumentada por recuperación_ o RAG, por sus siglas en inglés (_retrieval-augmented generation_) es un proceso por medio del cual puedes **aumentar o complementar el conocimiento de ua inteligencia artificial** para que pueda **responder preguntas basándose en tus propios documentos** sin necesidad de entrenar un modelo nuevo ni de requerir un modelo de lenguaje gigante y caro.

_**¿Para qué sirve el RAG?**_ Para que cualquier modelo de IA pueda informarse en uno o varios documentos que tú especifiques, y así tenga **conocimiento específico** de temáticas especializadas. De esta forma, los modelos dejan de depender en los conocimientos de su entrenamiento (que son generales y difusos) y se basan en el conocimiento que tú les proveas para responder. 

La idea principal del RAG es crear una base de conocimiento a partir de documentos, para que el modelo de lenguaje pueda buscar contenido y usarlo en sus respuestas. Si entregas los documentos apropiados a la IA, entonces la IA **dejará de inventar respuestas** a cosas que no sabe, dado que podrán recurrir a los documentos para informarse y responder.

En esta publicación veremos por qué es necesario usar RAG, cómo crear un sistema de RAG con tus propios documentos, y cómo entregarle el sistema a una IA para aumentar y mejorar sus conocimientos a la hora de responder.


## Ejemplo de las limitaciones de la IA

Los modelos de lenguaje saben muchas cosas, pero no lo saben todo. Y lamentablemente, por razones de diseño de los mismos modelos, su función es **responder incluso cuando no tienen idea de lo que hablan.**

Probemos el caso de uso de RAG preguntándole a una IA algo que probablemente no sepa.

Primero creamos un chat con R, [siguiendo los pasos de este tutorial.](/blog/ellmer/) Luego, pensemos en un una investigación o estudio que hayamos realizado, y preguntémosle:

```r
library(ellmer)

chat <- chat_anthropic()
```

Ahora preguntamos algo específico:

```r
chat$chat("¿Qué es el EBC? Responde brevemente")
```

<div class="texto-ia">

El **EBC** es una escala internacional que mide el **color de la 
cerveza** basándose en el color del grano de malta utilizado en su 
elaboración.

</div>

Nada que ver! 🙄 Preguntemos algo más general:

```r
chat$chat("¿Qué es el Estudio de Brechas Comunales? Responde brevemente")
```

El modelo piensa y responde:

<div class="texto-ia">

El Estudio de Brechas Comunales es una herramienta de análisis que identifica y mide las diferencias entre la situación actual de una comunidad y los estándares deseables en servicios básicos e infraestructura.

</div>

Eeem... OK? El modelo entrega una respuesta genérica a partir de los conceptos, pero **realmente no sabe** sobre lo que le estamos preguntando.

{{< relacionada "/blog/ellmer/" >}}


## Crear una base de conocimientos 

Lo principal en un sistema de generación aumentada por recuperación (RAG) son los documentos que constituyen su **base de conocimientos**. Estos documentos pueden ser informes, papers, apuntes, capítulos de libros, o cualquier tipo de texto. 

Para crear un sistema de RAG en R, usaremos [el paquete `{ragnar}`.](https://ragnar.tidyverse.org)

Primero, creamos un _almacén_ de documentos, que es una base de datos donde se guardarán los textos que elijamos. 

```r
library(ragnar)

store <- ragnar_store_create(
  location = "documentos.ragnar.duckdb",
  embed = NULL
)
```

El almacén usa DuckDB como base de datos, y es la base desde la cual el sistema buscará documentos para responder.

{{< detalles "**Mejorar la capacidad de búsqueda de documentos con _text embeddings_**" >}}

Al crear el almacén de documentos, el argumento `embed` es clave, porque indica que queremos que los documentos se procesen por medio de _text embeddings_ (incrustaciones de texto), un método que **convierte el lenguaje en represetaciones numéricas.** Esto sirve para que la búsqueda de textos sea mucho mejor, dado que, en vez de buscar coincidencias directas de texto (`bici` = `bicicleta`), la **búsqueda semántica** puede realizar relaciones entre los significados de las palabras (`ciclismo` = `bicicleta`). Esto nos ayuda a que el sistema sea mucho más inteligente, pero al costo de que se requiere un procesamiento previo de los textos, y también un cómputo al momento de realizar cada búsqueda.

Para ésto [necesitas Ollama instalado en tu computador](/blog/ellmer/#modelos-de-lenguaje-locales), e instalar un modelo de inscrustaciones como `nomic-embed-text`:

```r
ollamar::pull("nomic-embed-text")
```

Luego usamos la función apropiada en el argumento `embed`:

```r
library(ragnar)

store <- ragnar_store_create(
  location = "documentos.ragnar.duckdb",
  embed = \(x) ragnar::embed_ollama(x, model = "nomic-embed-text")
)
```

{{< /detalles >}}



### Cargar documentos al _almacén_

Ya que tenemos el _almacén_, necesitamos llenarlo con documentos para obtener una base de conocimientos. Los documentos se introducen al almacenamiento con `read_as_markdown()`,y pueden estar en cualquier formato ya que serán convertidos a formato Markdown.

Esto significa que los documentos ideales para incluir serán documentos Markdown que hayamos **revisado y limpiado** previamente. El punto más importante aquí es que los documentos tengan una buena **estructura de títulos y subtítulos**:

```md
# Título del documento

## Capítulo 1

### Concepto 1

Bla bla bla

### Concepto 2

Ble ble ble
```

Cargamos el documento:

```
informe <- read_as_markdown("informe_estudio_brechas_comunales.md")
```

Ahora tenemos que dividir en secciones más pequeñas (_chunks_), para que el sistema pueda encontrar las partes más relevantes al momento de responder:

```r
informe_secciones <- markdown_chunk(informe)
```

Si el documento tiene una buena estructura de subtítulos, cada párrafo de texto se podrá clasificar mejor dentro de su contexto, ayudando a encontrar fragmentos de texto más apropiados.

Si vemos el documento en este paso, se trata de un _dataframe_ de grafmentos de texto acompañados de los subtítulos de contexto:

```
# @document@origin: informe_estudio_brechas_comunales.md
# A tibble:         295 × 4
start   end context                                                                         text
* <int> <int> <chr>                                                                           <chr>
1     1  1766 ""                                                                              "# E…
2   659  2541 "# ESTUDIO DE BRECHAS COMUNALES\n## RESUMEN DEL ESTUDIO"                        "Par…
3  1767  3212 "# ESTUDIO DE BRECHAS COMUNALES\n## RESUMEN DEL ESTUDIO"                        "Dur…
4  2542  3764 "# ESTUDIO DE BRECHAS COMUNALES\n## RESUMEN DEL ESTUDIO"                        "A p…
5  3213  4746 "# ESTUDIO DE BRECHAS COMUNALES\n## RESUMEN DEL ESTUDIO"                        "Ade…
6  3765  5782 "# ESTUDIO DE BRECHAS COMUNALES\n## RESUMEN DEL ESTUDIO"                        "Adi…
7  4747  6365 "# ESTUDIO DE BRECHAS COMUNALES\n## RESUMEN DEL ESTUDIO"                        "A p…
8  5783  7186 "# ESTUDIO DE BRECHAS COMUNALES\n## RESUMEN DEL ESTUDIO"                        "Por…
9  6366  8043 "# ESTUDIO DE BRECHAS COMUNALES\n## OBJETIVOS DEL ESTUDIO"                      "###…
10 7187  8927 "# ESTUDIO DE BRECHAS COMUNALES\n## BRECHAS Y DISPARIDADES TERRITORIALES A NIV… "No …
# ℹ 285 more rows
# ℹ Use `print(n = ...)` to see more rows
```

Si queremos incluir más documentos, se repiten los mismos pasos: `read_as_markdown()` y luego `markdown_chunk()`.

### Insertar documentos y construir índice

Con los documentos listos, ahora los insertamos en el almacén de documentos:

```r
ragnar_store_insert(store, informe_secciones)
```

Repetir por cada documento que tengamos. Una vez terminada la inserción de documentos, creamos el _índice_ de búsqueda para que la base de datos quede lista para usarse:

```r
ragnar_store_build_index(store)
```

Nuestra **base de conocimientos** está lista!

Si volvermos a añadir textos al índice, hay que repetir `ragnar_store_build_index()` para recalcular el índice.

### Probar la búsqueda

Podemos verificar que el sistema funciona correctamente haciendo una búsqueda en los documentos.

Primero nos **conectamos a la base de conocimientos**:

```r
store <- ragnar_store_connect("documentos.ragnar.duckdb", read_only = TRUE)
```

Ahora hacemos una búsqueda de texto para **recuperar** (_retrieve_) textos desde la base con `ragnar_retrieve()`:

```r
respuesta <- ragnar_retrieve(store, "indicador vías para bicicletas")

respuesta$text
```

```
[1] "#### Ciclovías
El desarrollo de sistemas de ciclovías en las ciudades genera numerosas 
externalidades positivas que contribuyen a mejorar la calidad de vida 
de los ciudadanos, promover la sostenibilidad urbana y construir 
ciudades más saludables..."

[2] "##### Origen y selección de indicadores:
El levantamiento de información y la selección de los indicadores 
incorporados en este estudio, están directamente relacionados a 
infraestructura y servicios..."
```

El sistema encontró correctamente los fragmentos relevantes sobre ciclovías. Esto significa que nuestro almacén de documentos está funcionando! Esta misma operación de pensar en algo, buscarlo en la base de conocimientos y leer el resultado, es lo que hará la IA para mejorar sus respuestas.


## Preguntar con RAG

Ahora que tenemos una base de conocimientos, podemos entregársela a un chat de IA para **conectar el modelo de lenguaje con nuestro almacén de documentos**. 

Primero que nada, necesitamos [crear un chat nuevo](/blog/ellmer/#iniciar-una-conversación-con-la-ia) en R:

```r
library(ellmer)

chat <- chat_anthropic(model = "claude-haiku-4-5")
```

En este punto, el modelo no sabe nada más allá de lo que se le haya entrenado. Ahora usamos `ragnar_register_tool_retrieve()` para que el modelo pueda **consultar los documentos automáticamente cuando lo necesite**:

```r
library(ragnar)

# conectarse a la base de conocimientos
store <- ragnar_store_connect("documentos.ragnar.duckdb", read_only = TRUE)

# registrar herramienta con el modelo de IA
ragnar_register_tool_retrieve(
  chat,
  store,
  top_k = 3,
  store_description = "Consulta de base de conocimientos sobre el 
                       Estudio de Brechas Comunales (EBC), que contiene 
                       la metodología, marco teórico e interpretación de 
                       resultados del estudio."
)
```

Esto que hicimos [se denomina _tool calling_,](/blog/herramientas_llm/) y es el acto de crear herramientas y ponerlas a disposición de modelos de IA. Con esto, el modelo tiene acceso a una _herramienta_ que le permite buscar en los documentos. Cuando le hagamos una pregunta, el modelo decidirá automáticamente si necesita consultar los documentos para responder.

Repitamos la misma pregunta de antes:

```r
chat$chat("¿Qué es el EBC? Responde brevemente")
```

Antes de responder, la consola muestra lo siguiente:
```
◯ [tool call] search_store_001(text = c("qué es el Estudio de Brechas Comunales EBC", ...)
● #> [
  #>  {
  #>  "origin": "informe_estudio_brechas_comunales.md",
  #>  "doc_id": 1,
  #>  "chunk_id": 14,
  #> …
```

Esto significa que la IA decidió que necesitaba usar RAG para responder! Inmediatamente después, el modelo responde:

<div class="texto-ia">

El **Estudio de Brechas Comunales (EBC)** es un instrumento que identifica y mide las **disparidades territoriales a nivel comunal** en la provisión de bienes, servicios e infraestructura pública en Chile.

Su objetivo es diagnosticar dónde se concentran las mayores carencias en cada territorio,
 permitiendo a los gobiernos:
 - Priorizar inversiones públicas de manera más eficiente
 - Dirigir recursos hacia las comunas y grupos más afectados
 - Diseñar políticas públicas que respondan a necesidades específicas de cada territorio

El estudio abarca múltiples ámbitos como educación, salud, transporte, servicios básicos (agua, electricidad, saneamiento), telecomunicaciones y otros, considerando las características particulares de las comunas urbanas, mixtas y rurales.

</div>

Ahora responde mucho mejor! 🥹 El modelo ahora conoce la sigla, y responde basándose en lo que se explica en el documento.

Podemos seguir haciendo preguntas más específicas, y el modelo seguirá consultando los documentos a medida que los necesite para informar sus respuestas:

```r
chat$chat("¿qué indicadores tienen relación a bicicletas?")
```

<div class="texto-ia">

Según el EBC, los indicadores con relación a bicicletas se encuentran en el ámbito de Ciclovías y son:

1. Cicloinclusión (red de ciclovías bien conectada y estratégicamente ubicada)
2. Porcentaje de cobertura de la red de ciclovía sobre la red vial

El 74,4% de las comunas presentan brechas en cicloinclusión, lo que indica deficiencias significativas en infraestructura de ciclovías bien conectada.

</div>

El modelo no sólo encontró los indicadores relevantes, sino que también incluyó un dato estadístico del estudio. Todo esto sin haber entrenado ningún modelo nuevo, y usando un modelo relativamente pequeño y económico.


## Conclusión

Con `{ragnar}` y `{ellmer}`, crear un sistema de RAG en R es re simple:

1. **Cargar documentos** con `read_as_markdown()` y dividirlos en fragmentos con `markdown_chunk()`
2. **Crear un almacén** con `ragnar_store_create()` e insertar los fragmentos con `ragnar_store_insert()`
3. **Conectar el almacén al chat** con `ragnar_register_tool_retrieve()`

De esta forma, cualquier modelo de lenguaje puede responder preguntas especializadas basándose en tus propios documentos, sin inventar respuestas.

{{< etiqueta "inteligencia artificial" >}}

{{< cafecito >}}

