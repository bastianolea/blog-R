---
title: Usar un modelo de lenguaje local (LLM) para analizar texto en R
author: Bastián Olea Herrera
format: hugo-md
date: 2024-10-29T00:00:00.000Z
categories:
  - Análisis de texto
tags:
  - análisis de texto
  - inteligencia artificial
lang: es
cache: false
freeze: true
excerpt: >-
  Procesa datos con IA directamente en R! El paquete `{mall}` permite aplicar un
  modelo de lenguaje (LLM) a tus datos para realizar tareas como resumir textos,
  realizar análisis de sentimiento, clasificación de textos, y más.
---


[El paquete `{mall}`](https://mlverse.github.io/mall/) facilita el uso de un LLM *(large language model)* o modelo de lenguaje de gran tamaño para analizar texto con IA en un *dataframe.* Esto significa que, para cualquier dataframe que tengamos, podemos aplicar un modelo de IA a una de sus columnas y recibir sus resultados en una columna nueva.

{{< info "Puedes encontrar instrucciones más detalladas sobre configurar el uso de IA en R [en esta publicación.](/blog/ellmer/)" >}}

Para poder hacer ésto, primero necesitamos tener un modelo LLM configurado en R. [Sigue las instrucciones en este tutorial](../../../blog/ellmer/) para lograrlo.

Luego, creamos un chat de IA con `{ellmer}` para que sea el motor o cerebro de `{mall}`:

``` r
library(ellmer)

chat <- chat_anthropic()
```

    Using model = "claude-sonnet-4-20250514".

Con eso hecho, ahora instruimos a `{mall}` para que use el chat que creamos:

``` r
library(mall)

mall::llm_use(chat)
```

    ── mall session object 

    Backend: ellmer
    LLM session: model:claude-sonnet-4-20250514
    R session:
    cache_folder:/var/folders/gt/vdp_nx_x3bq5wgnlr1nphkd1zbdps_/T//RtmpctdWlN/_mall_cache2a8611567960

Con el siguiente código vamos a descargar un *dataframe* que contiene texto de noticias de Chile, para usarlo como datos de prueba. Los datos provienen de mi [repositorio de web scraping y análisis de prensa de Chile.](https://github.com/bastianolea/prensa_chile)

``` r
# obtener datos de prensa
url <- "https://raw.githubusercontent.com/bastianolea/prensa_chile/refs/heads/main/prensa_datos_muestra.csv"

datos_prensa <- readr::read_csv2(url, show_col_types = FALSE)
```

    ℹ Using "','" as decimal and "'.'" as grouping mark. Use `read_delim()` for more control.

``` r
head(datos_prensa)
```

    # A tibble: 6 × 4
      titulo                                                cuerpo fuente fecha     
      <chr>                                                 <chr>  <chr>  <date>    
    1 Hombre de 66 años fue asesinado en plena vía pública… "El h… Coope… 2024-07-21
    2 Revive el cuarto capítulo de Indecisos: Candidatos a… "Este… Megan… 2024-09-03
    3 Menos personas circulando y miedo de los residentes:… "Poca… Megan… 2024-04-08
    4 CEO de Walmart Chile sostiene que si la empresa no d… "Hace… The C… 2024-12-22
    5 Pdte. Boric entregó mensaje por la muerte de Piñera … "El p… CNN C… 2024-02-06
    6 Encuentran dos cadáveres en un canal de regadío en P… "Pers… Publi… 2024-07-13

{{< relacionada "/blog/ellmer/" >}}

## Análisis de sentimiento

Probemos `{mall}` con 10 noticias al azar, pidiéndole al LLM que detecte el sentimiento de cada texto (si es positivo, neutro o negativo):

``` r
library(dplyr)

# extraer sentimiento de textos
datos_sentimiento <- datos_prensa |> 
  select(titulo) |> 
  slice(10:20) |> 
  llm_sentiment(titulo, 
                pred_name = "sentimiento",
                options = c("positivo", "neutro", "negativo"))

datos_sentimiento |> 
  relocate(sentimiento, .before = titulo)
```

    # A tibble: 11 × 2
       sentimiento titulo                                                           
       <chr>       <chr>                                                            
     1 negativo    "Dos personas resultan baleadas tras intentar evitar asalto en m…
     2 neutro      "Mujer de 54 años recibió trasplante de bomba cardíaca y riñón d…
     3 negativo    "Fiscalía investiga una segunda presunta agresión de Monsalve co…
     4 neutro      "Los RUT definitivos que reciben el premio de La Suerte en Chile…
     5 neutro      "Este domingo parte el Festival de Viña 2024: Revisa el orden y …
     6 positivo    "Danesa se coronó como Miss Universo 2024: Emilia Dides quedó en…
     7 neutro      "Hassler opta por tesis de Boric por sobre la del PC en Venezuel…
     8 negativo    "Carabinero de civil disparó a delincuente que estaba robando en…
     9 neutro      "Seguridad en días del 18’: Ex PDI llama a ser precavido y a evi…
    10 neutro      "¿Quién es Janet Yellen? La Secretaria del Tesoro de EEEUU que v…
    11 negativo    "Fijan audiencia para los detenidos por el homicidio del subofic…

## Resúmenes de texto

Otro uso es pedirle que genere resúmenes de textos. Para ello, usaremos la función `llm_summarize()` a la que le pedimos un máximo de palabras y le indicamos un *prompt* extra para mejorar las respuestas. El paquete aplicará dicha solicitud a cada una de las observaciones en la columna indicada, y retornará los resultados en una nueva columna llamada `resumen`:

``` r
# resumir textos
datos_resumidos <- datos_prensa |> 
  select(titulo, cuerpo) |> 
  slice(10:16) |> 
  llm_summarize(cuerpo, 
                max_words = 10, 
                additional_prompt = "resumir noticias de Chile en español",
                pred_name = "resumen") |> 
  select(resumen, titulo)

datos_resumidos
```

    # A tibble: 7 × 2
      resumen                                                                 titulo
      <chr>                                                                   <chr> 
    1 dos heridos bala intento asalto minimarket melipilla viernes noche      "Dos …
    2 mujer recibe segundo trasplante riñón cerdo genéticamente modificado h… "Muje…
    3 fiscalía investiga segunda denuncia agresión sexual contra monsalve se… "Fisc…
    4 sorteo polla chilena 90 aniversario premios millonarios ganadores diar… "Los …
    5 festival viña 2024 inicia domingo con alejandro sanz solidaridad incen… "Este…
    6 danesa victoria kjaer corona miss universo 2024 chile finalista         "Dane…
    7 hassler apoya posición de boric sobre venezuela, busca reelección       "Hass…

## Clasificación de texto

Finalmente, podemos usar IA para clasificar textos libres en categorías discretas, y de esta forma poder agrupar información desestructurada. Para esto, usamos la función `llm_classify()`, a la que le indicamos las categorías posibles para cada texto. En este caso, vamos a clasificar los textos en 3 categorías: "política", "economía" y "deportes". El LLM se encargará de asignar cada texto a una de estas categorías, y el resultado se guardará en una nueva columna llamada `categoria`:

``` r
datos_clasificados <- datos_prensa |> 
  select(titulo, cuerpo) |> 
  slice(10:16) |> 
  llm_classify(cuerpo, 
               labels = c("delincuencia", "política", "economía", 
                          "deportes", "cultura", "ciencias", 
                          "tecnología", "farándula"),
                additional_prompt = "Clasifica noticias de Chile en español en su temática principal",
                pred_name = "categoria") |> 
  select(categoria, titulo)
```

    [working] (0 + 0) -> 6 -> 1 | ■■■■■                             14%

    [working] (0 + 0) -> 0 -> 7 | ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  100%

``` r
datos_clasificados
```

    # A tibble: 7 × 2
      categoria    titulo                                                           
      <chr>        <chr>                                                            
    1 delincuencia "Dos personas resultan baleadas tras intentar evitar asalto en m…
    2 ciencias     "Mujer de 54 años recibió trasplante de bomba cardíaca y riñón d…
    3 delincuencia "Fiscalía investiga una segunda presunta agresión de Monsalve co…
    4 economía     "Los RUT definitivos que reciben el premio de La Suerte en Chile…
    5 cultura      "Este domingo parte el Festival de Viña 2024: Revisa el orden y …
    6 farándula    "Danesa se coronó como Miss Universo 2024: Emilia Dides quedó en…
    7 política     "Hassler opta por tesis de Boric por sobre la del PC en Venezuel…

{{< etiqueta "inteligencia artificial" >}}
{{< cafecito >}}
