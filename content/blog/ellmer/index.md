---
title: Interactúa con modelos de lenguaje (LLM) y chatea con IAs en R
author: Bastián Olea Herrera
date: '2026-02-26'
slug: []
categories: []
tags:
  - inteligencia artificial
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: registered
    icon_pack: fas
    name: Ellmer
    url: https://ellmer.tidyverse.org/index.html
execute:
  eval: false
excerpt: "Chatear con modelos de lenguaje (LLM) o IAs puede tener muchos usos para el análisis de datos: generar código de R para tus análisis, visualizaciones o exploraciones de datos; interpretar datos que describan tus análisis o resultados; convertir texto en datos estructurados, como entrevistas, noticias o contenido web; hacerle consultas sobre tus datos y que te ayude a interpretar, y más. Usar IA directamente desde R ayuda a mantener una documentación de nuestro análisis, integrar IA en nuestro procesamiento de datos, usar IA de manera reproducible, y usar directamente los resultados de la IA en nuestros flujos de trabajo."
---


Chatear con modelos de lenguaje (LLM) o _IAs_ —como se les llama coloquialmente— puede tener muchos usos para el análisis de datos:
- [Usar IA para **generar código de R**](/blog/gander/) para tus análisis, visualizaciones o exploraciones de datos
- **[Interpretar datos por medio de textos explicativos](/blog/redactar_texto_llm/)** que describan tus análisis o resultados
- **[Convertir texto en datos estructurados](/blog/datos_estructurados_llm/)**, como entrevistas, noticias o contenido web
- **[Presentar tus datos a la IA para hacerle consultas](/blog/redactar_texto_llm/#configurar-el-modelo-para-interpretar-texto)** y que te ayude a interpretar tus datos

Todo esto puedes hacerlo desde tu navegador web, pero cuando analizamos datos puede ser más conveniente **usar IA directamente desde R**. Así podemos mantener una **documentación** de nuestro análisis, **integrar IA** en nuestro procesamiento de datos, usar IA de manera **reproducible**, y usar directamente los resultados de la IA en nuestros flujos de trabajo.

Veamos cómo se puede interactuar con LLMs directamente desde R! 🤖

**_¿Qué necesitaremos?_**
1. Tener acceso a un [proveedor de modelos de lenguaje](#proveedores-de-modelos-de-lenguaje), o usar [modelos de lenguaje locales](#modelos-de-lenguaje-locales)
2. [Instalar un paquete](#interactuar-con-ias-desde-r) para poder interactuar con modelos de lenguaje
3. [Configurar la _API key_](#configurar-el-uso-de-un-modelo-de-lenguaje-en-r) de tu proveedor de IA en R
4. [Iniciar una conversación con la IA](#iniciar-una-conversación-con-la-ia)

## Modelos de lenguaje

Para usar modelos de lenguaje o IA en R, necesitas tener acceso a un **proveedor** de IA en la nube, o bien, [instalar un **modelo local** de IA en tu computador.](#modelos-de-lenguaje-locales)

**Tienes que elegir** entre usar IA desde la nube o usar IA localmente, lo que depende de tus necesidades, tu presupuesto, y las capacidades de tu computador.

### Proveedores de modelos de lenguaje en la nube

{{< info "Si quieres usar un modelo local, [salta a esta sección](#modelos-de-lenguaje-locales)." >}}

Esta es la alternativa **más popular** para usar IA, ya que por medio de un pago puedes acceder a IA sin mayores complicaciones.

Algunos proveedores populares de IA son OpenAI (ChatGPT), Anthropic (Claude), Google (Gemini), GitHub Models, etc., quienes construyen grandes _data centers_ con miles de computadores para ejecutar sus modelos de lenguaje, para que puedas usarlos desde tu computador o celular.

Existen proveedores de IA que te permiten usar sus modelos _gratis_ mediante el navegador, pero nosotrxs queremos dar un uso más avanzado a la IA, y para eso necesitamos una _API key_ o **llave de API**. Estas _llaves_ nos permiten usar la IA en contextos distintos al típico chat, y suelen tener un costo asociado.

Necesitas una cuenta en un proveedor de IA que te pueda entregar una _API key_ para poder usarla en R. 

<!---
{{< info "Si ya tienes una cuenta y una llave de API, puedes [saltarte la siguiente sección y pasar a la subsiguiente.](#configurar-el-uso-de-un-modelo-de-lenguaje-en-r)" >}}
--->


#### Configurar tu proveedor de IA en R

<!---
{{< info "Este paso es solamente si usas modelos de lenguaje desde la nube por medio de proveedores como OpenAI o Anthropic. Si usas un modelo de lenguaje local, puedes saltarte este paso." >}}
--->

Vamos a poner la _API key_ de tu proveedor en una parte segura de R.

Para poder usar IA de proveedores en la nube necesitas tener una _llave_ que le dice al proveedor que vas a usar tu cuenta fuera de su plataforma (para que te cobren, obviamente 💸). Esto se hace mediante la _llave de API_.

Las llaves de API son un código secreto que te entrega tu proveedor de IA, y básicamente es una especie de **contraseña** que te permite usar tu cuenta fuera de su plataforma web. Esto significa que es una clave privada! Si alguien más la usa, podría resultar en cobros para ti! Por eso, tenemos que guardar la _API key_ de forma segura en un **archivo de Entorno**.


#### Editar tu archivo de _Entorno_

El archivo de Entorno es un script donde puedes **guardar secretos** que R puede leer, pero que no quedan guardados en tu código ni en tu proyecto, y por lo tanto quedan seguros. Este script contiene **variables** que se cargan cada vez que abrimos una sesión de R. 

El archivo de entorno sirve para guardar variables secretas en un archivo que está afuera de tu proyecto de R, y que aplica para todos tus proyectos y sesiones de R: perfecto para **guardar las _API keys_ en tu computadora de forma segura** y poder usarlas en todos tus proyectos.

Para **editar** el archivo de entorno:

```r
usethis::edit_r_environ()
```
Se abrirá el archivo `.Renviron`, donde podemos agregar  una línea con la _API key_. Por ejemplo, si usas Claude:

```r
ANTHROPIC_API_KEY=345345398475937434534539847593743453453984759374
```

Si tu proveedor es OpenAI (ChatGPT), el nombre de la variable es `OPENAI_API_KEY`, etc. Tienen que ir escritas con mayúscula, sin espacios, y sin comillas.

Una vez guardadas las credenciales, **reiniciamos la sesión de R** (menú _Session_ y luego _Restart R_) para que se lean las variables de entorno (siempre se leerán al iniciar R).

Con esta variable de entorno, el paquete `{ellmer}` tendrá permiso para usar tu modelo de IA. `{ellmer}` buscará automáticamente este valor para funcionar, y si no lo encuentra arrojará un error.

----


### Modelos de lenguaje locales

{{< info "Si solamente quieres usar un proveedor de IA como Claude, Gemini o ChatGPT, puedes saltarte esta sección y [pasar a la siguiente](#interactuar-con-ias-desde-r)." >}}

Si tu computador tiene una tarjeta de video lo suficientemente grande (más de 8GB de memoria de video), si quieres usar IA gratis, o si prefieres no usar modelos en la nube por privacidad, puedes **instalar un modelo de lenguaje local** en tu computadora.

Esto significa que descargas el modelo y tu propio computador lo ejecuta, a diferencia de usarlo en la nube por medio de un proveedor.

{{< detalles "_Más información sobre lo necesario para un modelo local_" >}}

Un modelo de lenguaje local solamente funcionará bien en un computador con más de 8GB de memoria de video (GPU), lo que deja fuera a la mayoría de los computadores. En general, todos los Mac con procesadores _Apple Silicon_ (M1, M2, M3, M4…) cumplen este requisito, ya que se caracterizan por compartir la memoria RAM con la memoria de GPU, a diferencia de otros computadores que tienen memoria RAM y memoria de GPU separadas.

{{< /detalles >}}

Un modelo de lenguaje local tiene algunos **beneficios**: 
- es gratis
- es totalmente privado
- no necesitas internet
- ¿ya mencioné que es gratis?

Pero también tiene **inconvenientes**:
- depende de las capacidades de tu computadora
- no es tan potente como los modelos en la nube
- exige muchísimo tu computador, lo que puede complicarse en computadores portátiles

Para instalar y ejecutar un modelo de lenguaje local, necesitamos:
1. Instalar Ollama
2. Hacer que R se comunique con Ollama
3. Instalar un modelo de lenguaje local

#### Instalar Ollama
Primero tienes que [instalar el software Ollama en tu equipo](https://ollama.com). Este programa permite que tu computador ejecute modelos de lenguaje locales.

{{< boton "Bajar Ollama" "https://ollama.com" "fas fa-circle-arrow-down" >}}

Una vez instalado, tienes que abrir Ollama en tu computador!

#### Usar Ollama desde R

Ahora queremos que R se comunique con Ollama para poder usar sus modelos de lenguaje. Instalamos el paquete `{ollamar}`:

```r
install.packages("ollamar")
```

Una vez instalado Ollama y `{ollamar}`, podemos instalar un modelo de lenguaje local. 

#### Modelos de lenguaje locales

Existen muchas alternativas de modelos, y entre ellos se diferencian principalmente por los **datos de entrenamiento** que se usaron para crearlos, y la **cantidad de parámetros** que tienen, que representan la cantidad de elementos aprendidos por el modelo, donde en general una mayor cantidad equivale a mejor capacidad para comprender textos, generar respuestas más precisas, y contar con mayor cononocimiento.

- El modelo [Llama 3.2](https://ollama.com/library/llama3.2) es pequeño y os moderadamente bueno para comprender textos complejos. Su versión de 3 billones de parámetros, `llama3.2:3b`, es liviana y potente.
- Si tu computador **no es muy poderoso**, existe la versión de Llama 3.1 con 1 billón de parámetros, `llama3.1:1b`, es más pequeño aún para tareas sencillas.
- Si tu computador tiene bastante memoria de video (más de 16GB), puedes instalar Llama 3.1, que tiene una versión de 8 billones de parámetros: `llama3.1:8b`

#### Instalar un modelo de lenguaje local desde R

Para instalar un modelo con `{ollamar}`, usamos el siguiente código en R: 

```r
library(ollamar)
pull("llama3.2:3b")
```

Ollama descargará e instalará el modelo en tu computador. Recuerda que es necesario tener la aplicación Ollama abierta en tu computadora, dado que ésta aplicación es la que le entrega el modelo de lenguaje a R.

Listo! Ahora tienes un modelo de lenguaje instalado localmente.

----

## Interactuar con IAs desde R

{{< info "Desde aquí en adelante los pasos son comunes tanto para modelos de lenguaje en la nube como locales" >}}

`{ellmer}` es un [paquete de R](https://ellmer.tidyverse.org/index.html) que **facilita la interacción con modelos de lenguaje** desde R, y se usa como el motor de muchos otros paquetes que usan IA.

Instalamos el paquete:

```r
install.packages("ellmer")
```

Ahora tenemos que pedirle a `{ellmer}` que use tu modelo de lenguaje elegido desde tu proveedor, ya sea un modelo local o un modelo en la nube. 

### Iniciar una conversación con la IA

Con tu modelo de lenguaje instalado localmente o con tu _API key_ configurada, ya puedes empezar a interactuar con la IA desde R!

En un script, cargamos `{ellmer}`:

```r
library(ellmer)
```

Ahora usaremos una función para **iniciar un chat**. Estas funciones empiezan con `chat_`, y dependen de tu proveedor:
- Si usas un proveedor de IA en la nube, usa las funciones `chat_openai()`, `chat_anthropic()`, `chat_gemini()`, `chat_github()` o la que te corresponda. 
- Si usar una IA local con Ollama, usa `chat_ollama()`.

Creemos un chat usando Claude de Anthropic:

```r
# crear sesión de chat
chat <- chat_anthropic()
```

```
Using model = "claude-sonnet-4-20250514".
```

Creamos un objeto `chat` que llevará nuestra conversación. 

Para **iniciar la conversación**, pasamos el texto de esta manera:

```r
# preguntar algo a la IA
chat$chat("¿Cuál es el animal más bonito del mundo? Finge que es el mapache y responde brevemente")
```

```
¡El animal más bonito del mundo es el mapache! 
Sus grandes ojos brillantes, sus suaves patas y su 
característica "máscara" hacen que sea adorable y cautivador.
```

Vemos que el modelo responde inmediatamente en la consola.

Podemos continuar la conversación usando el mismo objeto `chat` otra vez, por lo que la IA podrá responder teniendo en cuenta todo lo que se ha dicho antes:

```r
# continuar la conversación
chat$chat("Después del mapache, cuál sería el segundo animal más bonito del mundo? Obviamente son los gatos")
```

```
Después del mapache, los gatos son el segundo animal 
más bonito del mundo. Su elegancia, mirada misteriosa y 
su suave pelaje hacen que sean absolutamente encantadores.
```

Si ejecutamos el objeto `chat` por sí solo, veremos la conversación entera, un resumen de los _tokens_ usados, y una estimación del costo total:

```
<Chat OpenAI/gpt-4.1 turns=14 tokens=1524/284 $0.01>
── user [28] ────────────────────────────────────────────────────────────────────────────────────────
¿Cuál es el animal más bonito del mundo? Finge que es el mapache y responde brevemente
── assistant [38] ───────────────────────────────────────────────────────────────────────────────────
¡El animal más bonito del mundo es el mapache! Sus grandes ojos brillantes, sus suaves patas y su característica "máscara" hacen que sea adorable y cautivador.
── user [27] ────────────────────────────────────────────────────────────────────────────────────────
Después del mapache, cuál sería el segundo animal más bonito del mundo? Obviamente son los gatos
── assistant [40] ───────────────────────────────────────────────────────────────────────────────────
¡Por supuesto! Después del mapache, los gatos son el segundo animal más bonito del mundo. Su elegancia, mirada misteriosa y su suave pelaje hacen que sean absolutamente encantadores.
```

De esta forma podemos capturar las respuestas del chat en objetos de R y usarlos para los fines que deseemos:

```r
animal <- chat$chat("En una sola palabra: ¿cuál es la mascota más popular del mundo y que ronrronea?")
animal
```

```
Gato.
```

Otra forma de chatear con la IA en R es con un chat interactivo:

``` r
live_console(chat)
```

De este modo la consola de R se vuelve en un chat donde escribimos y obtenemos respuestas de inmediato.


{{< relacionada "/blog/herramientas_llm/" >}}

## Usos avanzados de modelos de lenguaje en R

Con esta configuración inicial, ahora puedes pasar a usar la IA con R de maneras más avanzadas, como tener asistentes, generar código, interpretar resultados, analizar datos y más!

- [Análisis de sentimiento de textos con R](/blog/analisis_sentimiento_llm/)
- [Resumir textos desde R](/blog/resumir_texto_llm/)
- [Análisis de datos en formato texto con `{mall}`](/blog/introduccion_llm_mall/)
- [Crear herramientas en R y hacer que la IA pueda usarlas para dar mejores respuestas](/blog/herramientas_llm/)
- [Extraer datos estructurados desde textos libres](/blog/datos_estructurados_llm/)
- [{gander}, un asistente de código](/blog/gander/) que escribe código de R y reemplaza código o comentarios con lo que le pidas
- [Asistente de IA directo en RStudio que tiene acceso a tus datos, paquetes cargados, y archivos](/blog/btw/)
- [Entregar datos a una IA para generar textos explicativos, resúmenes, o interpretaciones de tus datos](/blog/redactar_texto_llm/)

{{< etiqueta "inteligencia artificial" >}}

## Recursos
Para más paquetes y herramientas de modelos de lenguaje e IA en R, revisa [Large Language Model tools for R](https://luisdva.github.io/llmsr-book/), de Luis D. Verde Arregoitia.

