---
title: 'Limpieza y recodificación de datos de texto en R con `{stringr}`'
author: Bastián Olea Herrera
date: '2025-06-08'
draft: false
format: 
  hugo-md:
    output-file: "index"
output-ext:  "md"
slug: []
categories:
  - tutoriales
tags:
  - limpieza de datos
  - texto
excerpt: Los datos que vienen como texto suelen necesitar una limpieza previa, y adicionalmente un procesamiento para poder aprovecharlos mejor. En este tutorial usamos el paquete `{stringr}` para limpiar y ordenar unos datos de texto.
editor_options: 
  chunk_output_type: inline
---

{{< indice >}}

[El paquete `{stringr}`](https://stringr.tidyverse.org/index.html) facilita todo tipo de trabajo que implique texto en R. 

En general, los datos que vienen como texto suelen necesitar una limpieza previa, y adicionalmente un procesamiento para poder aprovecharlos mejor.

Sigamos un ejemplo con una columna que viene con textos sobre compras en un servicio público:


``` r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

``` r
library(stringr) # para trabajar con textos

datos <- tibble(
  texto = c("Licitación pública N°3432",
            "Trato directo #3341",
            "Licitación privada 876",
            "LICITACION PUBLICA N3430",
            "Licitacion publica 3526 concluida",
            "licitación pública 2986 ok",
            "sin información")
)
```



|texto                             |
|:---------------------------------|
|Licitación pública N°3432         |
|Trato directo #3341               |
|Licitación privada 876            |
|LICITACION PUBLICA N3430          |
|Licitacion publica 3526 concluida |
|licitación pública 2986 ok        |
|sin información                   |

Como es de esperar, el texto viene _sucio_: escrito de distintas maneras, con y sin tildes, con y sin mayúsculas, etc.

### Crear variable a partir de la detección de texto

Una primera limpieza de los datos puede ser identificar si un texto específico está o no presente en la variable de texto sucio. Para ello podemos usar la función `str_detect()`, que retorna `TRUE` o `FALSE` si en el texto que se le entrega como primer argumento está presente el texto en su segundo argumento. Por ejemplo:



``` r
str_detect("un texto acá muy feo", "feo") # sí (TRUE)
```

```
## [1] TRUE
```

``` r
str_detect("un texto acá muy bonito", "feo") #no (FALSE)
```

```
## [1] FALSE
```

Aplicamos `str_detect()` dentro de un `mutate()` para crear una columna que indique la presencia de un texto a lo largo de la columna de texto:


``` r
datos |> 
  mutate(licitacion = str_detect(texto, "Licitación"))
```

```
## # A tibble: 7 × 2
##   texto                             licitacion
##   <chr>                             <lgl>     
## 1 Licitación pública N°3432         TRUE      
## 2 Trato directo #3341               FALSE     
## 3 Licitación privada 876            TRUE      
## 4 LICITACION PUBLICA N3430          FALSE     
## 5 Licitacion publica 3526 concluida FALSE     
## 6 licitación pública 2986 ok        FALSE     
## 7 sin información                   FALSE
```

Vemos que sólo entrega dos `TRUE`, siendo que en las filas 4, 5 y 6 también debería encontrar coincidencias. Esto se debe a que existen diferencias en las letras minúsculas y mayúsculas.


## Cambiar la capitalización de un texto
Un problema común con la limpieza de texto es encontrar **diferencias en las mayúsculas** de las palabras. `{stringr}` tiene varias funciones para ayudarnos a cambiar textos a mayúsculas, minúsculas, y más.


``` r
str_to_lower("HOLA, cómo estás?")
```

```
## [1] "hola, cómo estás?"
```

``` r
str_to_upper("hola, cómo estás?!")
```

```
## [1] "HOLA, CÓMO ESTÁS?!"
```

``` r
str_to_sentence("hola, cómo estás?")
```

```
## [1] "Hola, cómo estás?"
```

Pero a veces necesitamos corregir la capitalización de textos que en su interior contienen palabras que empiezan con mayúsculas, o siglas/acrónimos, en cuyo caso convertir a minúsculas o a oración arruinarían la gramática correcta.


``` r
# texto que no empieza con mayúscula
texto <- "mi nombre es Cecilia y trabajo en la ONU."

# agregar mayúscula inicial, pero se pierden las demás mayúsculas
str_to_sentence(texto)
```

```
## [1] "Mi nombre es cecilia y trabajo en la onu."
```

En estos casos podemos realizar un reemplazo de texto con `str_replace()` que solamente reemplace la primera letra del texto por su versión mayúscula, y deje las demás intactas:


``` r
# reemplazar sólo primera letra de la primera palabra
str_replace(texto, "^.", toupper)
```

```
## [1] "Mi nombre es Cecilia y trabajo en la ONU."
```

Aquí usamos una **expresión regular** (`^.`) para indicar que queremos reemplazar solamente la primera letra del texto (el símbolo `^` indica el inicio del texto, y `.` indica cualquier símbolo).

Volviendo al ejemplo de los datos, para corregir la detección de datos con `str_detect()` cuando hay diferencias de mayúsculas, primero convertimos el texto a minúsculas con `str_to_lower()`, y buscamos el término en minúsculas:


``` r
datos |> 
  mutate(licitacion = str_detect(str_to_lower(texto), "licitación"))
```

```
## # A tibble: 7 × 2
##   texto                             licitacion
##   <chr>                             <lgl>     
## 1 Licitación pública N°3432         TRUE      
## 2 Trato directo #3341               FALSE     
## 3 Licitación privada 876            TRUE      
## 4 LICITACION PUBLICA N3430          FALSE     
## 5 Licitacion publica 3526 concluida FALSE     
## 6 licitación pública 2986 ok        TRUE      
## 7 sin información                   FALSE
```

Obtenemos una coincidencia más! Pero siguen faltando dos casos (casos 4 y 5) que deberían retornar `TRUE`. En estos casos, el problema está con **diferencias en los tildes** de las palabras. Para solucionar esto, podemos hacer una búsqueda de texto usando _regex_. 



## Expresiones regulares

Las [expresiones regulares o _regex_](https://stringr.tidyverse.org/articles/regular-expressions.html) son formas de escribir patrones de búsqueda, y son soportadas por todas las funciones de `{stringr}`. Uno de estos patrones es el operador _o_ (`|`). El operador _o_ puede usarse para encontrar coincidencias con varias palabras distintas separadas con `|`:


``` r
str_detect(c("hola", "holo", "holi"), "hola|holi")
```

```
## [1]  TRUE FALSE  TRUE
```

En este ejemplo, se coincide con un `TRUE` tanto el texto `hola` como `holi`. Pero en este ejemplo ambas palabras son muy similares; 75% similares, para ser exactos 🤓☝🏼. Podemos poner entre paréntesis los caracteres específicos que varían, para que dentro de una misma palabra se acepten distintos caracteres:


``` r
str_detect(c("hola", "holo", "holi"), "hol(a|i)")
```

```
## [1]  TRUE FALSE  TRUE
```

De este modo, se coincide con la palabra `hol` seguida tanto de `a` como de `i`; es decir, `hola` y `holi`.

Finalmente, también podemos pedirle que coincida una palabra que dentro de ella tenga _cualquier_ caracter:


``` r
str_detect(c("hola", "holo", "holi"), "hol.")
```

```
## [1] TRUE TRUE TRUE
```

Siguiendo estos ejemplos para volver a nuestros datos, podemos coincidir texto con y sin tildes al mismo tiempo si usamos _regex_ para especificar que uno o varios caracteres pueden ser distintos; en este caso, la letra _o_ con y sin tilde:


``` r
datos |> 
  mutate(licitacion = str_detect(str_to_lower(texto), "licitaci(ó|o)n"))
```

```
## # A tibble: 7 × 2
##   texto                             licitacion
##   <chr>                             <lgl>     
## 1 Licitación pública N°3432         TRUE      
## 2 Trato directo #3341               FALSE     
## 3 Licitación privada 876            TRUE      
## 4 LICITACION PUBLICA N3430          TRUE      
## 5 Licitacion publica 3526 concluida TRUE      
## 6 licitación pública 2986 ok        TRUE      
## 7 sin información                   FALSE
```

Podemos usar el mismo código pero dentro de un `ifelse()` para que, en vez de `TRUE` y `FALSE`, retorne lo que queramos para las condicies verdadera y falsa:


``` r
datos |> 
  mutate(licitacion = ifelse(str_detect(str_to_lower(texto), "licitaci(ó|o)n"), 
                             yes = "Licitación",
                             no = "Otros"))
```

```
## # A tibble: 7 × 2
##   texto                             licitacion
##   <chr>                             <chr>     
## 1 Licitación pública N°3432         Licitación
## 2 Trato directo #3341               Otros     
## 3 Licitación privada 876            Licitación
## 4 LICITACION PUBLICA N3430          Licitación
## 5 Licitacion publica 3526 concluida Licitación
## 6 licitación pública 2986 ok        Licitación
## 7 sin información                   Otros
```

También podemos usar el operador `.*` de _regex_ para indicar cualquier cantidad de caracteres entre el texto antes y después del operador. Por ejemplo:


``` r
str_detect(c("hola", "hooooooola", "ho8787897la", "hola hola"), "ho.*la")
```

```
## [1] TRUE TRUE TRUE TRUE
```

En el ejemplo, `ho.*la` significa coincidir con un texto que tenga `ho`, cualquier texto, y luego `la`; por lo tanto, coincide con `hola`, `hooooooola`, `ho8787897la` y cualquier otra variación.

Podemos usar esto para hacer coincidencias más flexibles:


``` r
datos |> 
  mutate(tipo = case_when(str_detect(str_to_lower(texto), "lic.*privada") ~ "Licitación privada",
                          str_detect(str_to_lower(texto), "lic.*p.blica") ~ "Licitación pública",
                          str_detect(str_to_lower(texto), "trato.*directo|contra.*direct") ~ "Trato directo")
  )
```

```
## # A tibble: 7 × 2
##   texto                             tipo              
##   <chr>                             <chr>             
## 1 Licitación pública N°3432         Licitación pública
## 2 Trato directo #3341               Trato directo     
## 3 Licitación privada 876            Licitación privada
## 4 LICITACION PUBLICA N3430          Licitación pública
## 5 Licitacion publica 3526 concluida Licitación pública
## 6 licitación pública 2986 ok        Licitación pública
## 7 sin información                   <NA>
```

Si combinamos los aprendizajes hasta el momento, podemos crear una columna nueva que entregue distintos valores dependiendo del texto detectado, gracias a `case_when()`:


``` r
datos |> 
  # limpiar el texto de antemano
  mutate(texto_2 = str_to_lower(texto)) |> 
  # detectar licitaciones
  mutate(licitacion = str_detect(texto_2, "licitaci(ó|o)n")) |> 
  # detectar si son públicas, privadas, o de otro tipo
  mutate(tipo = case_when(
    # si son licitaciones, y si contiene "privada"
    licitacion & str_detect(texto_2, "privad(o|a)") ~ "Licitación privada",
    # si son licitaciones y si contiene "público"
    licitacion & str_detect(texto_2, "p(ú|u)blic(a|o)") ~ "Licitación pública",
    # otros valores
    str_detect(texto_2, "trato directo") ~ "Trato directo",
    # todos los demás que no coincidieron en las condiciones anteriores
    .default = "Otros"))
```

```
## # A tibble: 7 × 4
##   texto                             texto_2                     licitacion tipo 
##   <chr>                             <chr>                       <lgl>      <chr>
## 1 Licitación pública N°3432         licitación pública n°3432   TRUE       Lici…
## 2 Trato directo #3341               trato directo #3341         FALSE      Trat…
## 3 Licitación privada 876            licitación privada 876      TRUE       Lici…
## 4 LICITACION PUBLICA N3430          licitacion publica n3430    TRUE       Lici…
## 5 Licitacion publica 3526 concluida licitacion publica 3526 co… TRUE       Lici…
## 6 licitación pública 2986 ok        licitación pública 2986 ok  TRUE       Lici…
## 7 sin información                   sin información             FALSE      Otros
```



### Extraer caracteres desde un texto
Una última alternativa para limpiar estos datos sería _extraer_ texto específico desde la variable de texto. Es decir, encontrar un tipo de texto dentro de otro texto, y solamente dejar ese texto extraído. Por ejemplo: entre un texto extenso, extraer solamente una palabra específica, si es que existe, o extraer solamente los números que esténdentro del texto.

Para esto podemos usar la función `str_extract()` combinada con un operador _regex_ para extraer secuencias de números (`\\d+`):


``` r
datos |> 
  mutate(numero = str_extract(texto, "\\d+"))
```

```
## # A tibble: 7 × 2
##   texto                             numero
##   <chr>                             <chr> 
## 1 Licitación pública N°3432         3432  
## 2 Trato directo #3341               3341  
## 3 Licitación privada 876            876   
## 4 LICITACION PUBLICA N3430          3430  
## 5 Licitacion publica 3526 concluida 3526  
## 6 licitación pública 2986 ok        2986  
## 7 sin información                   <NA>
```

----

Para finalizar, unimos todas las técnicas que vimos en este ejemplo, para terminar con una tabla de datos mucho más útil que la que teníamos al inicio!


``` r
datos_limpios <- datos |> 
  # limpiar el texto de antemano
  mutate(texto_2 = str_to_lower(texto)) |> 
  # detectar licitaciones
  mutate(licitacion = ifelse(str_detect(str_to_lower(texto), "licitaci(ó|o)n"), 
                             yes = "Licitación",
                             no = "Otros")) |> 
  # detectar si son públicas, privadas, o de otro tipo
  mutate(tipo = case_when(
    # si son licitaciones, y si contiene "privada"
    licitacion == "Licitación" & str_detect(texto_2, "privad(o|a)") ~ "Licitación privada",
    # si son licitaciones y si contiene "público"
    licitacion == "Licitación" & str_detect(texto_2, "p(ú|u)blic(a|o)") ~ "Licitación pública",
    # otros valores
    licitacion == "Otros" & str_detect(texto_2, "trato directo") ~ "Trato directo",
    # todos los demás que no coincidieron en las condiciones anteriores
    .default = "Otros")) |> 
  # extraer números
  mutate(numero = str_extract(texto, "\\d+"),
         numero = as.numeric(numero)) |> # convertir números a numéricos
  # eliminar columnas innecesarias
  select(-contains("texto"))
```



|licitacion |tipo               | numero|
|:----------|:------------------|------:|
|Licitación |Licitación pública |   3432|
|Otros      |Trato directo      |   3341|
|Licitación |Licitación privada |    876|
|Licitación |Licitación pública |   3430|
|Licitación |Licitación pública |   3526|
|Licitación |Licitación pública |   2986|
|Otros      |Otros              |     NA|




{{< cafecito >}}
