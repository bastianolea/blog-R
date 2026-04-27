---
title: 'Potencia las capacidades de la IA entregándole herramientas (_tool calling_) basadas en R'
subtitle: "Enseña a la IA a usar R para potenciar sus capacidades"
author: Bastián Olea Herrera
date: '2026-04-26'
tags:
  - inteligencia artificial
  - datos
format:
  hugo-md:
    output-file: index
    output-ext: md
excerpt: "_La inteligencia artificial no lo sabe todo._ Y lo que no sabe, lo inventa. Conociendo las limitaciones de la IA podemos hacer un mejor uso de ella. Por ejemplo, la IA no tiene acceso a datos, ni es buena para responder preguntas sobre cifras exactas. En esta publicación veremos cómo enseñar a la IA a usar herramientas de R para complementar sus respuestas, y así entregar información exacta en vez de alucinar respuestas."

---

_La inteligencia artificial no lo sabe todo._ Y lo que no sabe, **lo inventa**. Es demasiado importante **conocer las limitaciones** de las herramientas de inteligencia artificial para poder hacer buen uso de ellas.


Por ejemplo, la IA puede saber mucho sobre Chile, pero **no sabe** con exactitud _todos_ los datos de la población de todos sus territorios. Veamos un caso:

## Poniendo a prueba el conocimiento de la IA

Hagamos una consulta por un dato específico primero, y luego  sobre población chilena al modelo _Claude Haiku_ de Anthropic.

Como somos usuarixs de R hablaremos con la IA desde R. Tenemos que [tener configurado un modelo de inteligencia artificial (LLM) en R](/blog/ellmer/), y luego iniciamos el chat con la IA:

```r
library(ellmer)

# iniciar modelo
chat <- chat_anthropic(
  model = "claude-haiku-4-5"
)
```

{{< info "Aprende a interactuar con modelos de IA desde R [en este tutorial](/blog/ellmer/)" >}}

Con el modelo iniciado, le hacemos la pregunta:

```r
chat$chat("Cuál es la población de Curanilahue?")
```

El modelo responde:

> Curanilahue es una comuna ubicada en la región del Bío Bío, 
> en Chile. Según el **Censo de 2017**, su población era de 
> aproximadamente **25.000 habitantes**.

Esta información no es solo **desactualizada**, sino también **incorrecta** 😔

Esto es porque, por muchos billones de parámetros que tenga un modelo, **es imposible que lo sepa todo.** Muchas veces los mismos modelos recomiendan buscar información en las **fuentes oficiales**, como corresponde.

{{< relacionada "/blog/ellmer/" "Contenidos mínimos" >}}

**¿Qué pasa si pudiéramos entregarle los datos correctos al modelo de lenguaje?**

Esto es posible mediante el **uso de herramientas** (_tool calling_), que, como su nombre indica, es la capacidad de ciertos modelos de inteligencia artificial de poder recibir herramientas para poder usarlas cuando sean necesarias.

Esto significa que podemos **crear funciones de R y entregárselas a la inteligencia artificial** para que las use! 😮

### Herramienta: consultar datos del Censo desde R

En [este repositorio](https://github.com/bastianolea/censo_poblacion_consultar) creé una función de R llamada `consultar_censo()`, que permite obtener datos de población del Censo 2024 en distintos niveles territoriales (país, región, provincia, comuna), y en distintas desagregaciones (total, sexo, grupos de edad).

{{< externo "Repositorio censo_poblacion_consultar"
  "https://github.com/bastianolea/censo_poblacion_consultar"
  "censo_poblacion_consultar.png"
  "Código de R para procesar datos del Censo y obtener una función que entrega población a nivel país, región, provincia, comuna, y opcionalmente desagregada por sexo y edad."
  "Repositorio mencionado" >}}

Para poder usarla en tu sesión de R, clona el repositorio, o descarga el script `consultar_censo.R` y el archivo `censo.rds` y ponlos en tu proyecto de R.

La función se usa así:

```r
consultar_censo(
  nivel = "Comuna", 
  territorio = "Curanilahue")
```

```
→ datos a nivel comuna, Curanilahue
ℹ población censada: 31.119
[1] 31119
```

{{< info "Pronto escribiré una publicación profundizando sobre esta función!" >}}

La función `consultar_censo()` es útil para un ser humano, pero queremos que la IA pueda usarla también para que use esta información en sus respuestas.


## Entregarle herramientas a la IA

Para hacer que la IA use funciones de R, primero hay que tener una función, describírsela a la IA, y entregársela.

### Registrar una herramienta

Vamos a **registrar** la herramienta para que el modelo sepa de su existencia con la función `tool()` del [paquete `{ellmer}`.](/blog/ellmer) 

Dentro de `tool()` ponemos la función, una descripción de su uso, y también explicamos cómo se usa cada _argumento_ de la función, incluyendo los valores esperados. De esta forma, la inteligencia artificial aprenderá a usar la función correctamente.

Por ejemplo:

```r
herramienta_censo <- tool(
  consultar_censo,
  description = "Entrega la población a nivel de país, región, provincia o comuna, y según grupos de edad y/o sexo, a partir de datos del Censo 2024.",
  arguments = list(
    nivel = # explicar cómo se usa…
    …
    )
  )
```

{{< detalles "**Ver código completo** para registrar la función `consultar_censo()`" >}}

```r
# crear herramienta
herramienta_censo <- tool(
  consultar_censo,
  description = "Permite obtener la población según datos del Censo 2024 a nivel de país, región, provincia o comuna, y según grupos de edad y/o sexo",
  # explicar uso de argumentos
  arguments = list(
    nivel = type_enum(
      required = TRUE,
      values = c("País", "Región", "Provincia", "Comuna"),
      description = "Nivel de la información sobre población, desde País (el más general) a Comuna (el más específico)"
    ),
    edad = type_enum(
      required = FALSE,
      values = c("Total", "0 a 4", "5 a 9", "10 a 14", "15 a 19", "20 a 24", 
                 "25 a 29", "30 a 34", "35 a 39", "40 a 44", "45 a 49", "50 a 54", 
                 "55 a 59", "60 a 64", "65 a 69", "70 a 74", "75 a 79", "80 a 84", 
                 "85 o más"),
      description = "Grupos de edades para filtrar la población. Si se busca la población total, elegir 'Total'."
    ),
    sexo = type_enum(
      required = FALSE,
      values = c("Hombres", "Mujeres", "Total"),
      description = "Sexo para filtrar la población. Si se busca la población total, elegir 'Total'."
    ),
    territorio = type_string(
      required = FALSE,
      description = "Unidad territorial a filtrar si se elige un nivel distinto a 'País'. Corresponde al nombre de la región, provincia o comuna que se desea consultar"
    )
  )
)
```

Si bien puede parecer engorroso, también se puede usar IA para describir la función automáticamente usando `create_tool_def()`. Para más información, revisar la viñeta `vignette("tool-calling")`

{{< /detalles >}}

Una vez definida la herramienta, la podemos **registrar** en el modelo:

```r
chat$register_tool(herramienta_censo)
```

Ahora la IA sabe de la existencia de `consultar_censo()`, y en base a la descripción que le dimos, podrá usarla si lo considera necesario.

### Probando el uso de herramientas

Para hacer que la IA use la herramienta, simplemente le hacemos un _prompt_ donde la herramienta sea útil. En nuestro caso, simplemente repetimos el _prompt_ anterior:

```r
chat$chat("Cuál es la población de Curanilahue?")
```

```
◯ [tool call] consultar_censo(nivel = "Comuna", edad =
"Total", sexo = "Total", ...)
→ datos a nivel comuna, Curanilahue
ℹ población censada: 31.119
● #> 31119
```

> Según el **Censo 2024**, la población total de Curanilahue 
> es de **31.119 habitantes**.

En vez de citar información desactualizada o entregar estimaciones, la IA decidió usar la herramienta, y gracias a ella pudo entregar **información exacta** en base a **datos reales!**

También podemos hacer preguntas más específicas y la IA no va a tener ningún problema en usar la función, dado que se la explicamos bien 😌

```r
chat$chat("Cuál es la población femenina de Curanilahue?")
```

```
◯ [tool call] consultar_censo(nivel = "Comuna", edad =
"Total", sexo = "Mujeres", ...)
→ datos a nivel comuna, Curanilahue
→ sexo: Mujeres
ℹ población censada: 15.992
● #> 15992
```

> Según el Censo 2024, la población femenina de 
> Curanilahue es de 15.992 mujeres.

Increíble! 🤯 Gracias al uso de herramientas disminuimos al mínimo la **alucinación** de la IA; es decir, **evitamos que invente respuestas** al entregarle herramientas para responder mejor.

Ahora podemos hacer distintas preguntas que involucren población y la IA usará la herramienta las veces que la requiera. Pidámosle que compare las poblaciones de dos comunas:

```r
chat$chat("¿En qué comuna vive más gente: en Puente Alto o en Maipú?")
```

```
◯ [tool call] consultar_censo(nivel = "Comuna", edad =
"Total", sexo = "Total", ...)
→ datos a nivel comuna, Puente Alto
ℹ población censada: 568.086
● #> 568086
◯ [tool call] consultar_censo(nivel = "Comuna", edad =
"Total", sexo = "Total", ...)
→ datos a nivel comuna, Maipú
ℹ población censada: 503.635
● #> 503635
```

> Según el **Censo 2024**:

| Comuna | Población |
|---|---|
| **Puente Alto** | 568,086 |
| **Maipú** | 503,635 |

> En Puente Alto vive más gente que en 
> Maipú. Puente Alto tiene 64,451 habitantes más que Maipú.


Pero si seguimos preguntando cosas, podemos encontrarnos con **problemas** 😬 Preguntemos algo que haga que el modelo tenga que sumar datos:

```r
chat$chat("Cuál es la población masculina de Curanilahue mayor de 20 años?")
```

El modelo procede a usar la herramienta más de 10 veces para obtener los grupos de edad relevantes y luego sumarlos...

{{< detalles "Ver razonamiento completo" >}}

```
◯ [tool call] consultar_censo(nivel = "Comuna", edad = "15 a 19",
sexo = "Hombres", ...)
→ datos a nivel comuna, Curanilahue
→ grupo de edad: 15 a 19
→ sexo: Hombres
ℹ población censada: 1.019
● #> 1019
◯ [tool call] consultar_censo(nivel = "Comuna", edad = "20 a 24",
sexo = "Hombres", ...)
→ datos a nivel comuna, Curanilahue
→ grupo de edad: 20 a 24
→ sexo: Hombres
ℹ población censada: 991
● #> 991
◯ [tool call] consultar_censo(nivel = "Comuna", edad = "25 a 29",
sexo = "Hombres", ...)
→ datos a nivel comuna, Curanilahue
→ grupo de edad: 25 a 29
→ sexo: Hombres
ℹ población censada: 1.018
● #> 1018
◯ [tool call] consultar_censo(nivel = "Comuna", edad = "30 a 34",
sexo = "Hombres", ...)
→ datos a nivel comuna, Curanilahue
→ grupo de edad: 30 a 34
→ sexo: Hombres
ℹ población censada: 1.030
● #> 1030
◯ [tool call] consultar_censo(nivel = "Comuna", edad = "35 a 39",
sexo = "Hombres", ...)
→ datos a nivel comuna, Curanilahue
→ grupo de edad: 35 a 39
→ sexo: Hombres
ℹ población censada: 988
● #> 988
◯ [tool call] consultar_censo(nivel = "Comuna", edad = "40 a 44",
sexo = "Hombres", ...)
→ datos a nivel comuna, Curanilahue
→ grupo de edad: 40 a 44
→ sexo: Hombres
ℹ población censada: 917
● #> 917
◯ [tool call] consultar_censo(nivel = "Comuna", edad = "45 a 49",
sexo = "Hombres", ...)
→ datos a nivel comuna, Curanilahue
→ grupo de edad: 45 a 49
→ sexo: Hombres
ℹ población censada: 963
● #> 963
◯ [tool call] consultar_censo(nivel = "Comuna", edad = "50 a 54",
sexo = "Hombres", ...)
→ datos a nivel comuna, Curanilahue
→ grupo de edad: 50 a 54
→ sexo: Hombres
ℹ población censada: 985
● #> 985
◯ [tool call] consultar_censo(nivel = "Comuna", edad = "55 a 59",
sexo = "Hombres", ...)
→ datos a nivel comuna, Curanilahue
→ grupo de edad: 55 a 59
→ sexo: Hombres
ℹ población censada: 978
● #> 978
◯ [tool call] consultar_censo(nivel = "Comuna", edad = "60 a 64",
sexo = "Hombres", ...)
→ datos a nivel comuna, Curanilahue
→ grupo de edad: 60 a 64
→ sexo: Hombres
ℹ población censada: 1.005
● #> 1005
◯ [tool call] consultar_censo(nivel = "Comuna", edad = "65 a 69",
sexo = "Hombres", ...)
→ datos a nivel comuna, Curanilahue
→ grupo de edad: 65 a 69
→ sexo: Hombres
ℹ población censada: 815
● #> 815
◯ [tool call] consultar_censo(nivel = "Comuna", edad = "70 a 74",
sexo = "Hombres", ...)
→ datos a nivel comuna, Curanilahue
→ grupo de edad: 70 a 74
→ sexo: Hombres
ℹ población censada: 615
● #> 615
◯ [tool call] consultar_censo(nivel = "Comuna", edad = "75 a 79",
sexo = "Hombres", ...)
→ datos a nivel comuna, Curanilahue
→ grupo de edad: 75 a 79
→ sexo: Hombres
ℹ población censada: 375
● #> 375
◯ [tool call] consultar_censo(nivel = "Comuna", edad = "80 a 84",
sexo = "Hombres", ...)
→ datos a nivel comuna, Curanilahue
→ grupo de edad: 80 a 84
→ sexo: Hombres
ℹ población censada: 220
● #> 220
◯ [tool call] consultar_censo(nivel = "Comuna", edad = "85 o más",
sexo = "Hombres", ...)
→ datos a nivel comuna, Curanilahue
→ grupo de edad: 85 o más
→ sexo: Hombres
ℹ población censada: 172
● #> 172
```

{{< /detalles >}}


Finalmente la IA responde (ojo con la respuesta 👀)

> Según el Censo 2024, la población masculina de **Curanilahue 
mayor de 20 años** es de **10,092 habitantes**, distribuida de la 
siguiente manera:

<div class="cita-sin-saltos">

> 20 a 24 años: 991

> 25 a 29 años: 1,018

> 30 a 34 años: 1,030

> 35 a 39 años: 988

> 40 a 44 años: 917

> 45 a 49 años: 963

> 50 a 54 años: 985

> 55 a 59 años: 978

> 60 a 64 años: 1,005

> 65 a 69 años: 815

> 70 a 74 años: 615

> 75 a 79 años: 375

> 80 a 84 años: 220

> 85 o más años: 172

> **TOTAL:** **10,072**

</div>

Los datos que cita son correctos (gracias a la herramienta) pero… ¿te fijaste? **Se equivocó en la suma!** Arriba dio una cifra y después dio otra abajo, y ninguna de las dos es la suma correcta! 

{{< aviso "**Siempre** hay que revisar las respuestas que da la IA!" >}}

Esto pasa porque la IA es en realidad modelos de lenguaje (LLM), y **los modelos de lenguaje no hacen operaciones matemáticas**. Pueden predecir resultados cercanos a los esperados, pero no se garantiza que sean correctos al 100%... a menos que usen herramientas 🤔

Solucionemos esta falencia de la IA con **otra herramienta:**

Creamos una función sencilla que sume valores:
```r
# crear otra herramienta pasa sumar valores, porque los modelos de lenguaje no saben sumar
sumar <- function(valores) {
  sum(valores)
}
```

Luego la definimos para que el modelo la entienda:
```r
herramienta_suma <- tool(
  sumar,
  description = "Suma varios valores numéricos",
  # explicar uso de argumentos
  arguments = list(
    valores = type_array(type_integer(),
                         description = "Cifras a sumar")
  )
)
```

Finalmente se la entregamos al modelo:
```r
chat$register_tool(herramienta_suma)
```

Y ahora volvemos a hacerle el _prompt_ al modelo, esperando que se pegue la escurrida y use la herramienta:

```r
chat$chat("Cuál es la población masculina de Curanilahue mayor de 20 años?")
```

```
◯ [tool call] sumar(valores = c(991L, 1018L, 1030L, 988L, 917L,
963L, 985L, ...)
● #> 11072
```

> Según el Censo 2024, la población masculina de **Curanilahue 
> mayor de 20 años** es de **11,072 habitantes**.

Ahora sí 😉 La IA supo que necesitaba sumar los datos, así que esta vez recurrió a la herramienta y lo hizo bien.

----

Usar LLMs desde R tiene una potencialidad notable, con un ecosistema de paquetes maduro para implementar IA en el análisis de datos. Con lo que vimos en esta publicación se podría implementar un _chat bot_ manejado por R que pueda realizar consultas a datos complejos y entregar información exacta, o hacer que los modelos de IA realicen operaciones complejas de cualquier tipo. Hay muchísimas posibilidades!

{{< etiqueta "inteligencia artificial" >}}

{{< cafecito >}}