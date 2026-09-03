---
title: Visualizando texto como nubes de palabras en R
author: Bastián Olea Herrera
date: '2025-07-05'
draft: false
format:
  hugo-md:
    output-file: index
    output-ext: md
slug: []
categories: []
tags:
  - visualización de datos
  - gráficos
  - ggplot2
  - análisis de texto
---


Una de las formas más intuitivas de visualizar datos de texto son las nubes de palabras. En las nubes de palabras seleccionamos un subconjunto de las palabras del texto que queremos analizar y las distribuimos en un gráfico, donde las palabras que aparecen más frecuentemente aparecen más grandes, y usualmente al centro. Sirven para ver rápidamente los conceptos clave de un documento o un corpus de documentos.

En este post veremos dos formas de crear nubes de palabras con R: con `{wordcloud2}` y con `{ggplot2}`. Para empezar, necesitamos una base de datos que tenga información de texto; por ejemplo, una base donde cada fila contenga una respuesta abierta de una encuesta, una reseña de un producto, un párrafo de un texto, un capítulo de un libro, o un libro completo.

Con el siguiente código descargaremos una base de datos con 10.000 documentos de texto, en este caso se trata de noticias de la prensa chilena. Los datos son obtenidos de [este repositorio de obtención automatizada de textos de noticias de prensa escrita chilena.](https://github.com/bastianolea/prensa_chile)

``` r
library(dplyr)
```

    Warning: package 'dplyr' was built under R version 4.4.3

``` r
# dirección web donde se encuentran los datos
url_datos <- "https://raw.githubusercontent.com/bastianolea/prensa_chile/refs/heads/main/prensa_datos_muestra.csv"

# lectura de los datos ubicados en internet
noticias <- readr::read_csv2(url_datos)

noticias |> select(titulo, cuerpo, fecha)
```

    # A tibble: 10,000 × 3
       titulo                                                      cuerpo fecha     
       <chr>                                                       <chr>  <date>    
     1 "Hombre de 66 años fue asesinado en plena vía pública en M… "El h… 2024-07-21
     2 "Revive el cuarto capítulo de Indecisos: Candidatos a alca… "Este… 2024-09-03
     3 "Menos personas circulando y miedo de los residentes: Así … "Poca… 2024-04-08
     4 "CEO de Walmart Chile sostiene que si la empresa no da “se… "Hace… 2024-12-22
     5 "Pdte. Boric entregó mensaje por la muerte de Piñera y rec… "El p… 2024-02-06
     6 "Encuentran dos cadáveres en un canal de regadío en Pirque" "Pers… 2024-07-13
     7 "Magisterio denuncia \"abandono de la educación pública\" … "Carl… 2024-02-21
     8 "“El día que la democracia triunfó sobre la dictadura”: Mi… "Los … 2024-10-05
     9 "Accidente de tránsito deja un fallecido y tres heridos en… "En h… 2024-12-22
    10 "Dos personas resultan baleadas tras intentar evitar asalt… "Aton… 2024-11-02
    # ℹ 9,990 more rows

En este conjunto de datos, los textos completos de los documentos vienen en la columna `cuerpo`:

``` r
noticias |> select(cuerpo)
```

    # A tibble: 10,000 × 1
       cuerpo                                                                       
       <chr>                                                                        
     1 "El hecho ocurrió en horas de la madrugada, cuando la víctima fue abordada p…
     2 "Este martes 3 de septiembre fue el cuarto capítulo de la nueva temporada de…
     3 "Pocas personas circulan en la toma \"Nuevo Amanecer\" de Cerrillos, luego d…
     4 "Hace unos días, Walmart Chile anunció un plan de inversión en Chile de US$1…
     5 "El presidente Gabriel Boric lamentó el fallecimiento del expresidente Sebas…
     6 "Personal del Grupo de Operaciones Policiales Especiales (GOPE) de Carabiner…
     7 "Carlos Rodríguez, presidente regional de los Profesores, aseguró que el Min…
     8 "Los ministros de Educación, Nicolás Cataldo, y del Interior, Carolina Tohá,…
     9 "En horas de la mañana de este domingo, ocurrió un lamentable accidente en l…
    10 "Aton / Imagen Referencial Dos personas resultaron heridas a bala en un inte…
    # ℹ 9,990 more rows

Usualmente los datos de texto van a venir de esta forma, con **todo el texto de cada documento dentro de una celda.** Para poder analizar los datos en este formato tenemos que *tokenizar* los textos: transformar la estructura de los datos para pasar desde filas que contienen documentos, párrafos u oraciones, a **filas que contienen palabras individuales**, una palabra por observación.

Usaremos la función `unnest_tokens` de [`{tidytext}`](https://www.tidytextmining.com/tidytext) para tokenizar y limpiar[^1] el texto:

``` r
library(tidytext)

palabras <- noticias |> 
  # tokenizar columna que contiene los documentos
  unnest_tokens(input = cuerpo, drop = FALSE,
                output = palabra, 
                token = "words",
                # limpieza mínima de texto
                to_lower = TRUE,
                strip_punct = TRUE,
                strip_numeric = TRUE) |> 
  # eliminar stopwords o palabras vacías
  filter(!palabra %in% stopwords::stopwords("spanish"))

palabras |> select(palabra, cuerpo)
```

    # A tibble: 1,817,901 × 2
       palabra   cuerpo                                                             
       <chr>     <chr>                                                              
     1 hecho     "El hecho ocurrió en horas de la madrugada, cuando la víctima fue …
     2 ocurrió   "El hecho ocurrió en horas de la madrugada, cuando la víctima fue …
     3 horas     "El hecho ocurrió en horas de la madrugada, cuando la víctima fue …
     4 madrugada "El hecho ocurrió en horas de la madrugada, cuando la víctima fue …
     5 víctima   "El hecho ocurrió en horas de la madrugada, cuando la víctima fue …
     6 abordada  "El hecho ocurrió en horas de la madrugada, cuando la víctima fue …
     7 grupo     "El hecho ocurrió en horas de la madrugada, cuando la víctima fue …
     8 sujetos   "El hecho ocurrió en horas de la madrugada, cuando la víctima fue …
     9 atacó     "El hecho ocurrió en horas de la madrugada, cuando la víctima fue …
    10 arma      "El hecho ocurrió en horas de la madrugada, cuando la víctima fue …
    # ℹ 1,817,891 more rows

Luego de tokenización, vemos que la columna que contiene el texto completo de los documentos está acompañada de una nueva variable que contiene **cada palabra por separado.** De esta forma puedes continuar analizando el documento con palabras individuales, pero teniendo como referencia al texto completo donde aparece cada palabra si es que lo necesitas.

A partir de la variable de palabras individuales, vamos a hacer un **conteo de las palabras más frecuentes**:

``` r
palabras_conteo <- palabras |> 
  count(palabra, sort = TRUE)

palabras_conteo
```

    # A tibble: 74,911 × 2
       palabra      n
       <chr>    <int>
     1 chile     7208
     2 años      5457
     3 según     5071
     4 parte     4952
     5 personas  4921
     6 si        4912
     7 región    4830
     8 ser       4656
     9 país      4628
    10 gobierno  4599
    # ℹ 74,901 more rows

Rápidamente podemos ver dos problemas: tenemos demasiadas palabras individuales (más de 80 mil), y tenemos palabras muy cortas, como la palabra `si`, así que haremos una pequeña limpieza:

``` r
palabras_conteo <- palabras_conteo |> 
  # largo mínimo de palabras
  filter(nchar(palabra) >= 3) |> 
  # sólo las palabras más frecuentes
  slice_max(n, n = 2000)
```

También podemos realizar una **búsqueda** dentro de las palabras y contar cuántas veces aparece cada una:

``` r
palabras_conteo |> 
  filter(palabra %in% c("guerra", "paz"))
```

    # A tibble: 2 × 2
      palabra     n
      <chr>   <int>
    1 guerra    398
    2 paz       267

------------------------------------------------------------------------

## Nube de palabras con `{wordcloud2}`

[`{wordcloud2}`](https://github.com/Lchiffon/wordcloud2) es un paquete muy sencillo de usar que permite visualizar datos de nubes de palabras con muy poca configuración.

Si no tienes el paquete instalado, puedes instalarlo con el siguiente código:

``` r
pak::pak("lchiffon/wordcloud2")
```

Para crear una nube de palabras con `{wordcloud2}` solo necesitas que la primera columna del dataframe contenga las palabras, y la segunda contenga el conteo de frecuencia de las palabras:

``` r
library(wordcloud2)

palabras_conteo |>
  # sólo palabras que aparezcan n veces
  filter(n > 1000) |> 
  wordcloud2(backgroundColor = "#EAD1FA",
             color = "#543A74")
```

<iframe src="/nube_1.html" width="100%" height="500px" style="border:none;"></iframe>

Usamos algunas de las opciones de personalización de `wordcloud2()` para obtener el resultado que necesitamos. Personalmente no me gusta mucho que las palabras aparezcan tan en ángulo, y prefiero que las palabras sean menos grandes para que se vea una mayor cantidad.

``` r
palabras_conteo |>
  filter(n > 1000) |> 
  wordcloud2(backgroundColor = "#EAD1FA",
             color = "#543A74",
             # personalización
             rotateRatio = 0.1, # rotación máxima
             gridSize = 8, # espaciado entre cada palabra
             size = 0.5, # tamaño del texto en general
             minSize = 11) # tamaño mínimo de las letras
```

<iframe src="/nube_2.html" width="100%" height="500px" style="border:none;"></iframe>
</iframe>

------------------------------------------------------------------------

## Nube de palabras con `{ggplot2}` y `{ggwordcloud}`

Otra forma de hacer nubes de palabras es agregando una geometría personalizada a `{ggplot2}`: `geom_text_wordcloud()` del paquete [`{ggwordcloud}`](https://lepennec.github.io/ggwordcloud/)

Instalar el paquete:

``` r
pak::pak("lepennec/ggwordcloud")
```

Configuramos un tema general para los gráficos, para que se vean bonitos aquí 🥰

``` r
library(ggplot2)
library(ggwordcloud)

# definir el tema para todos los gráficos
theme_set(
  theme_void() +
  theme(plot.background = element_rect(fill = "#EAD1FA", linewidth = 0))
)
```

Para crear la nube de palabras con `{ggplot2}`, solamente tenemos que especificar en la estética `aes()` la variable que contiene las palabras (`palabra`) y la variable que controla el tamaño de las mismas (`n`). Luego simplemente indicar que los datos van a visualizarse por medio de la geometría `geom_text_wordcloud()`, que se encargará de distribuir los textos en el área del gráfico.

``` r
palabras_conteo |> 
  filter(n > 2000) |> 
  ggplot() +
  aes(label = palabra, size = n) +
  geom_text_wordcloud(shape = "circle", 
                      color = "#543A74") +
  # definir rango de tamaños de las palabras
  scale_size_continuous(range = c(3, 20))
```

<img src="index.markdown_strict_files/figure-markdown_strict/unnamed-chunk-12-1.png" width="768" />

El beneficio de usar esta estrategia es que te entrega toda la flexibilidad de visualizar datos con `{ggplot2}`. Por ejemplo, podemos agregar un mapeo de la transparencia y el color para crear una nube donde las palabras menos frecuentes sean más transparentes y donde ciertas palabras claves tengan un color distinto:

``` r
palabras_conteo |> 
  filter(n > 2000) |> 
  mutate(clave = ifelse(palabra %in% c("gobierno", "presidente", "boric", "ministerio"),
                         "clave", "otras")) |> 
  ggplot() +
  aes(label = palabra, size = n, 
      alpha = n, 
      color = clave) +
  geom_text_wordcloud(shape = "circle", 
                      grid_size = 6) +
  # definir rango de tamaño de palabras
  scale_size_continuous(range = c(3, 15)) +
  # especificar colores de las palabras clave
  scale_color_manual(values = c("clave" = "#D93E98", "otras" = "#543A74")) +
  # definir el rango de la transparencia de palabras
  scale_alpha_continuous(range = c(0.4, 1))
```

<img src="index.markdown_strict_files/figure-markdown_strict/unnamed-chunk-13-1.png" width="768" />

También podemos crear una variable que destaques ciertas palabras específicas dentro de la nube:

``` r
palabras_conteo |> 
  filter(n > 1500) |> 
  # crear variable que destaque palabras específicas
  mutate(clave = ifelse(palabra %in% c("gobierno", "chile",
                                       "presidente", "boric", 
                                       "ministerio", "ministra", "interior",
                                       "partido",
                                       "público"),
                         "clave", "otras")) |> 
  ggplot() +
  aes(label = palabra, size = n, 
      # mapear transparencia a la variable con palabras clave
      alpha = clave) +
  geom_text_wordcloud(shape = "circle",
                      color = "#543A74",
                      rm_outside = TRUE) +
  # especificar rango de tamaños
  scale_size_continuous(range = c(3, 15)) +
  # especificar nivel de transparencia de las palabras clave y de las demás
  scale_alpha_manual(values = c("clave" = 1, "otras" = 0.3))
```

    Warning in wordcloud_boxes(data_points = points_valid_first, boxes = boxes, :
    Some words could not fit on page. They have been removed.

<img src="index.markdown_strict_files/figure-markdown_strict/unnamed-chunk-14-1.png" width="768" />

Con esta aproximación podemos crear visualizaciones más personalizadas y complejas a partir de datos de texto, sobre todo si tenemos variables adicionales que nos digan más información sobre las palabras que queremos graficar, cómo puede ser alguna otro criterio de prevalencia de palabras en los documentos, alguna clasificación de las palabras en tópicos o temas, una agrupación de los documentos de donde provienen las palabras, etc.

------------------------------------------------------------------------

{{< cursos >}}
{{< cafecito >}}

[^1]: La limpieza del texto es un paso clave en este tipo de análisis, que para simplificar esta guía, omitiremos. Es muy importante procesar los textos para poder eliminar palabras vacías, palabras mal escritas, remover símbolos, remover palabras irrelevantes, e incluso lematizar palabras para agrupar diferentes conjugaciones de una misma palabra en una sola.
