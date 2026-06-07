---
title: Búsquedas de texto por ranking de relevancia con R usando el algoritmo BM25
author: Bastián Olea Herrera
date: '2026-06-06'
slug: []
draft: false
categories:
  - ''
tags:
  - texto
  - análisis de texto
  - limpieza de datos
format:
  hugo-md:
    output-file: index
    output-ext: md
editor_options: 
  chunk_output_type: console
excerpt: "Cuando tenemos datos que contienen mucho texto, usualmente necesitamos filtrar las observaciones dependiendo de si contienen o no uno o más términos. En este post vemos cómo buscar texto en R usando dos formas: la detección de texto, y un algoritmo de búsqueda por relevancia." 
links:
  - icon: link
    icon_pack: fas
    name: Buscador de mi blog
    url: https://bastianoleah.shinyapps.io/buscador/
  - icon: github
    icon_pack: fab
    name: Código del buscador
    url: https://github.com/bastianolea/blog_buscador
  - icon: r-project
    icon_pack: fab
    name: RBM25
    url: https://davzim.github.io/rbm25/
---

{{< info "Hice este post porque actualicé el [buscador de mi blog](/blog/buscador/) que puedes [usar aquí](https://bastianoleah.shinyapps.io/buscador/) para que ahora entregue mejores resultados, y lo mejor: ordenados por relevancia. Puedes ver su código [en este repositorio.](https://github.com/bastianolea/blog_buscador)" >}}

Cuando tenemos datos que contienen mucho texto, usualmente necesitamos filtrar las observaciones dependiendo de si contienen o no uno o más términos.

Para filtrar entre un conjunto de datos de texto podemos usar distintos métodos. Hagamos un vector de texto para usar como ejemplo:


``` r
textos <- c(
  "Construcción biblioteca y punto turístico, comuna de Salamanca",
  "Mejoramiento de multicancha y construcción de techumbre población Arboleda, Vicuña",
  "Construcción obras de iluminación fotovoltaicas sectores rurales y urbanos sin tendido eléctrico",
  "Construcción plaza Las Tazas, comuna de Canela",
  "Reposición sede club deportivo Victoria, localidad Los Choros, comuna La Higuera",
  "Construcción pista de patinaje artístico, comuna Los Vilos",
  "Construcción de arranques para el sector Saturno servicio sanitario rural de Gabriela Mistral",
  "Adquisición de terreno para proyecto habitacional comité de vivienda Chapilca N°2",
  "Mejoramiento servicio de agua potable ruta D-71, acceso poniente, Canela Baja",
  "Conservación señaléticas direccionales comuna de Paihuano",
  "Reposición sede social villa Los Mineros, Andacollo",
  "Asistencia técnica para desarrollo de proyectos diversas localidades comuna de La Higuera",
  "Construcción sistema de agua potable por acarreo sector Las Cruces, comuna de Punitaqui",
  "Mejoramiento multicancha Maestranza, Los Arrayanes, Coquimbo",
  "Fondo de fomento al equipamiento para la pesca artesanal, para los pescadores en caleta de Guayacán",
  "Construcción salón multiuso agrupación El Lirio de los Valles",
  "Mejoramiento multicancha Coyuntagua Sur, comuna de Illapel",
  "Construcción redes de saneamiento sanitario e instalaciones domiciliarias loteo Higuera Baja, La Higuera, Coquimbo",
  "Reposición de pavimentos aceras y calzadas, localidad de Chillepín, comuna de Salamanca",
  "Mejoramiento de aceras población Serena Uno, La Serena",
  "Construcción de sede comunitaria Ferro Unido Lambert",
  "Asistencia técnica para proyectos de saneamiento sanitario varios sectores de la comuna de Vicuña",
  "Iluminación cancha de fútbol, El Trapiche, comuna La Higuera",
  "Mejoramiento plaza de Ramadilla, comuna de Combarbalá",
  "Compra de terreno para cementerio municipal comuna de Coquimbo",
  "Construcción de veredas y luminarias solares localidades Samo Alto y La Aguada, comuna de Río Hurtado",
  "Mejoramiento sede social Villa Aurora, Las Compañías, comuna de La Serena",
  "Elaboración de estrategia energética local para la comuna de La Higuera",
  "Ampliación sede Quebrada del Jardín, La Serena",
  "Construcción sede comunitaria Arcos de Pinamar, La Serena"
)
```

<!----
Por ejemplo, en R base, la función `grep()` permite buscar un patrón entre un vector de texto.


``` r
grep(pattern = "plaza", 
     textos, 
     value = TRUE)
```

```
## [1] "Construcción plaza Las Tazas, comuna de Canela"       
## [2] "Mejoramiento plaza de Ramadilla, comuna de Combarbalá"
```
Con el argumento `value`, retorna los valores que coinciden con la búsqueda.
--->

## Búsqueda de texto con `{stringr}`

La función `str_detect()` del paquete `{stringr}` permite detectar los elementos donde aparece el texto:


``` r
library(stringr)

str_detect(textos, 
           "cancha")
```

```
##  [1] FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [13] FALSE  TRUE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE
## [25] FALSE FALSE FALSE FALSE FALSE FALSE
```

`str_detect()` retorna verdaderos y falsos, pero si metemos los datos en un _dataframe_ y la usamos en un `filter()` servirá para filtrar las observaciones.

Metamos el vector en una tabla de datos:


``` r
library(dplyr)

# crear tabla
datos <- tibble(textos)
```

Ahora podemos usar `str_detect()` para **filtrar** las observaciones que contienen una palabra o texto específicos:


``` r
datos |> 
  filter(
    str_detect(textos, "agua")
    )
```

```
## # A tibble: 3 × 1
##   textos                                                                        
##   <chr>                                                                         
## 1 Mejoramiento servicio de agua potable ruta D-71, acceso poniente, Canela Baja 
## 2 Construcción sistema de agua potable por acarreo sector Las Cruces, comuna de…
## 3 Mejoramiento multicancha Coyuntagua Sur, comuna de Illapel
```

Pero ¿qué pasa si buscamos un texto que no está exactamente entre los datos, o si hay varios textos similares pero no idénticos?


``` r
datos |> 
  filter(
    str_detect(textos, "agua potable rural")
    )
```

```
## # A tibble: 0 × 1
## # ℹ 1 variable: textos <chr>
```

No se encuentra nada, a pesar de existir textos que contienen esas palabras. Esto pasa porque `str_detect()` busca **coincidencias exactas** en el texto. 


### Búsqueda de texto con _regex_

Una alternativa es usar _regex_, expresiones regulares para búsquedas de texto. Son símbolos especiales que podemos usar al coincidir texto para configurar la forma en que se aplica. Por ejemplo, el término de búsqueda `eres (lindo|linda)` coincide tanto con `"eres lindo"` como con `"eres linda"`, o podría ser `eres lind(o|a|e)` para definir que la variedad está en una sola letra, e incluso podría ser `eres lind.`, donde el punto representa cualquier caracter posible (así que incluso coincidiría con `"eres lindx"`).

Volviendo al caso del ejemplo anterior, podríamos buscar las palabras `"agua potable rural"` separadas por el operador `|` para que se encuentre textos que contengan cualquiera de las tres palabras:


``` r
datos |> 
  filter(
    str_detect(textos, "agua|potable|rural")
    )
```

```
## # A tibble: 5 × 1
##   textos                                                                        
##   <chr>                                                                         
## 1 Construcción obras de iluminación fotovoltaicas sectores rurales y urbanos si…
## 2 Construcción de arranques para el sector Saturno servicio sanitario rural de …
## 3 Mejoramiento servicio de agua potable ruta D-71, acceso poniente, Canela Baja 
## 4 Construcción sistema de agua potable por acarreo sector Las Cruces, comuna de…
## 5 Mejoramiento multicancha Coyuntagua Sur, comuna de Illapel
```

Ahora sí se encuentran textos coincidentes!


## Búsqueda de texto por relevancia

Si necesitamos buscar o detectar texto y obtener las mejores coincidencias posibles, a pesar de que sean inexactas, podemos usar el **algoritmo de búsqueda Okapi BM25**, usado ampliamente por servicios de búsqueda de internet. 

```r
install.packages("rbm25")
```

[El paquete `{rbm25}` de R](https://davzim.github.io/rbm25/) entrega la función `bm25_score()`, que a diferencia de una búsqueda por coincidencia de texto, entrega un **ranking de resultados**, el cual puedes usar para ordenar los resultados posibles según su **relevancia** al texto de búsqueda.


``` r
library(rbm25)

datos |> 
  mutate(
    puntaje = bm25_score(
      textos,
      query = "mejoramiento y construcción de sedes comunitarias",
      lang = "es"
    )
  ) |>
  arrange(desc(puntaje)) |> 
  select(puntaje, textos) |> 
  head(n = 6)
```

```
## # A tibble: 6 × 2
##   puntaje textos                                                                
##     <dbl> <chr>                                                                 
## 1    5.34 Construcción de sede comunitaria Ferro Unido Lambert                  
## 2    5.34 Construcción sede comunitaria Arcos de Pinamar, La Serena             
## 3    2.85 Mejoramiento sede social Villa Aurora, Las Compañías, comuna de La Se…
## 4    2.35 Mejoramiento de multicancha y construcción de techumbre población Arb…
## 5    1.78 Ampliación sede Quebrada del Jardín, La Serena                        
## 6    1.67 Reposición sede social villa Los Mineros, Andacollo
```

Obtenemos el puntaje en una columna, que luego usamos para ordenar los resultados por relevancia.

Pero antes de hacer una búsqueda de texto en serio, se recomienda realizar una **limpieza del texto**. Para limpiar texto, como mínimo necesitamos:

- Convertir a minúsculas con `str_to_lower()`
- Eliminar toda la puntuación usando _regex_ y `str_remove_all()`
- Eliminar las _stopwords_ o palabras vacías, que podemos obtener del paquete `{stopwords}`


Primero creamos el texto _regex_ para eliminar _stopwords_:


``` r
# install.packages("stopwords")
stopwords <- stopwords::stopwords(language = "es")
stopwords <- paste(stopwords, collapse = "|")
stopwords <- paste0("\\b(", stopwords , ")\\b")
```

{{< detalles "**Explicación de la limpieza de _stopwords_**" >}}

Para eliminar las _stopwords_ obtendremos un listado de palabras con la función `stopwords()` que luego eliminaremos con `str_remove()`. Uniremos las palabras con `paste()` para que queden|pegadas|así, separadas con el símbolo `|` que es el operador lógico _o_, para decir en _regex_ que queremos que se elimine la palabra 1 o la 2 o la 3; es decir, eliminar todas las que se encuentren. Finalmente, envolvemos las palabras en el regex `\\b`, que representa palabras completas (para que por borrar la palabra vacía `la` no se eliminen las letras `la` de la palabra `lavaloza`)

{{< /detalles >}}

Luego procedemos con la limpieza

``` r
datos_limpios <- datos |>
  mutate(
    texto_limpio = textos |>
      str_to_lower() |> # minúsculas
      str_remove_all("[[:punct:]]") |> # puntuación
      str_remove_all(stopwords) |> # palabras vacías
      str_squish() # eliminar espacios sobrantes
  )

datos_limpios |> 
  select(texto_limpio)
```

```
## # A tibble: 30 × 1
##    texto_limpio                                                                 
##    <chr>                                                                        
##  1 construcción biblioteca punto turístico comuna salamanca                     
##  2 mejoramiento multicancha construcción techumbre población arboleda vicuña    
##  3 construcción obras iluminación fotovoltaicas sectores rurales urbanos tendid…
##  4 construcción plaza tazas comuna canela                                       
##  5 reposición sede club deportivo victoria localidad choros comuna higuera      
##  6 construcción pista patinaje artístico comuna vilos                           
##  7 construcción arranques sector saturno servicio sanitario rural gabriela mist…
##  8 adquisición terreno proyecto habitacional comité vivienda chapilca n°2       
##  9 mejoramiento servicio agua potable ruta d71 acceso poniente canela baja      
## 10 conservación señaléticas direccionales comuna paihuano                       
## # ℹ 20 more rows
```

Ahora probemos nuevamente la búsqueda, pero esta vez sobre el texto limpio:


``` r
# búsqueda de texto
datos_limpios |>
  mutate(
    puntaje = bm25_score(
      texto_limpio,
      query = "mejoramiento y construcción de sedes comunitarias",
      lang = "es"
    )
  ) |>
  arrange(desc(puntaje)) |> 
  select(puntaje, texto_limpio) |> 
  head(n = 6)
```

```
## # A tibble: 6 × 2
##   puntaje texto_limpio                                                          
##     <dbl> <chr>                                                                 
## 1    5.33 construcción sede comunitaria ferro unido lambert                     
## 2    5.33 construcción sede comunitaria arcos pinamar serena                    
## 3    2.84 mejoramiento sede social villa aurora compañías comuna serena         
## 4    2.35 mejoramiento multicancha construcción techumbre población arboleda vi…
## 5    1.78 ampliación sede quebrada jardín serena                                
## 6    1.67 reposición sede social villa mineros andacollo
```

Los resultados casi no cambian, pero cuando realicemos búsquedas entre miles de textos, o con textos mucho más extensos, puede marcar la diferencia.

----

#### Bonus: benchmarks 

Tenemos muchísimas funciones en R para trabajar textos, y yo pensaba que las de R base iban a ser más rápidas/eficientes, pero hice un benchmark y me llevé una sorpresa:


``` r
library(dplyr)
library(stringr)
library(rbm25)

stopwords <- stopwords::stopwords(language = "es")

# benchmark entre dos limpiezas de texto
bench::mark(
  check = FALSE,
  iterations = 100,
  # limpieza de texto con R base
  "R base" = textos |>
    tolower() |>
    gsub(pattern = "[[:punct:]]", replacement = "") |>
    gsub(
      pattern = paste0("\\b(", paste(stopwords, collapse = "|"), ") *\\b"),
      replacement = ""
    ) |>
    trimws(),
  # limpieza de texto con {stringr}
  "stringr" = textos |>
    str_to_lower() |>
    str_remove_all("[[:punct:]]") |>
    str_remove_all(paste0("\\b(", paste(stopwords, collapse = "|"), ")\\b")) |>
    str_squish()
)
```

```
## # A tibble: 2 × 6
##   expression      min   median `itr/sec` mem_alloc `gc/sec`
##   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
## 1 R base       51.4ms     53ms      18.6   34.27KB      0  
## 2 stringr     617.1µs    662µs    1511.     5.12KB     15.3
```

Las funciones de `{stringr}` son muchísimo más rápidas que las de R base en este caso!

También pensaba que buscar con BM25 iba a ser mucho más lento que con `str_detect()`, y a su vez que ésta iba a ser más lenta que `grep()`, la función de R base, así que las puse a prueba:


``` r
bench::mark(
  check = FALSE,
  iterations = 100,
  "grep" = grep("plaza", textos),
  "str_detect" = str_detect(textos, "plaza"),
  "bm25" = bm25_score(textos, "plaza")
)
```

```
## # A tibble: 3 × 6
##   expression      min   median `itr/sec` mem_alloc `gc/sec`
##   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
## 1 grep         23.4µs  24.52µs    40515.   10.16KB      0  
## 2 str_detect   16.4µs  16.81µs    58797.      216B      0  
## 3 bm25          1.1ms   1.15ms      845.    5.78KB     17.2
```

Vemos que `{stringr}` es mucho más rápido que R base, y que efectivamente buscar con BM25 es lento, pero tampoco _tan_ lento.

En fin, hice todo esto porque actualicé el [buscador de mi blog](/blog/buscador/), que en sí mismo es una [aplicación Shiny](https://bastianoleah.shinyapps.io/buscador/), para que ahora busque con BM25 y así entregue mejores resultados, y lo mejor: ordenados por relevancia. Puedes ver su código [en este repositorio.](https://github.com/bastianolea/blog_buscador)

{{< etiqueta "texto" >}}
