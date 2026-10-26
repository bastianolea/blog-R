---
title: Guía para programar en R con inteligencia artificial
subtitle: Compilación de herramientas y alternativas para potenciar el análisis de datos en R usando IA
author: Bastián Olea Herrera
date: '2026-10-13'
modified: '2026-10-26'
slug: []
categories:
  - Tutoriales
tags:
  - inteligencia artificial
  - consejos
draft: false
format:
  hugo-md:
    output-file: index
    output-ext: md
execute:
  message: false
  warning: false
excerpt: "Existen muchas formas de usar IA para programar en R, desde el simple autocompletado hasta asistentes que pueden leer, ejecutar y modificar código directamente en tu entorno de trabajo. En esta publicación veremos las principales herramientas de IA disponibles para potenciar el análisis de datos en R, junto con consejos para sacarles provecho basados en mi experiencia."
links:
  - icon: registered
    icon_pack: fas
    name: Posit Assistant
    url: https://assistant.posit.co
---

<!---
{{< info "A lo largo de este post usaremos el concepto 'IA' para referirnos a los _grandes modelos de lenguaje_ (LLM) o _inteligencia artificial generativa_, que son la forma más común de uso de IA hoy: ChatGPT, Claude, Gemini..." >}}
--->

## Introducción

Existen muchas formas de usar IA para programar en R, desde el simple [autocompletado de código](#herramientas-de-autocompletado) hasta [asistentes de IA](#integración-directa-con-r-posit-assistant) que pueden leer, ejecutar y modificar código directamente en tu entorno de trabajo. 

En esta publicación veremos las principales herramientas de IA disponibles para potenciar el análisis de datos en R, junto con consejos para sacarles provecho!

Como el mundo de la [inteligencia artificial](/tags/inteligencia-artificial/) está lleno de distintos productos y formas de usarla o integrarla en tus proyectos, para cada herramienta y consejo en esta guía agregaré **etiquetas** que te indican dónde se usan y su alcance:

### Formas de usar la IA

| <div style="width:140px">Leyenda</div> | Explicación |
|----------------------------------------|-------------|
| {{< tag "Chatbot" "message" >}}          | Herramientas o consejos que funcionan en los chatbots web de IA comunes: las versiones web de ChatGPT, Claude, DeepSeek, etc., donde el uso de la IA es _conversacional_ (preguntas y respuestas) |
| {{< tag "Arnés de IA" "laptop-code" >}} | Consejo o herramienta que funciona en un _harness_ que coordina a la IA, como Claude Code, Codex, Open Code, etc., que son softwares que coordinan agentes de IA con funcionalidades más potentes que un simple chatbot |

### Capacidades de la IA

| <div style="width:140px">Leyenda</div> | Explicación |
|----------------------------------------|-------------|
| {{< tag "Código" "code" >}}      | Herramientas que se usan para asistir la escritura de código en general, escribiendo o completando lo que le pidas, o lo que la IA piense que falta |
| {{< tag "Archivos" "file" >}}          | Herramientas que permiten que la IA acceda a tus archivos locales, ya sea para leerlos o escribirlos (modificarlos), usualmente pidiendo permiso antes (ten cuidado!) |
| {{< tag "Loop" "repeat" >}}            | La herramienta de IA revisará distintas posibilidades, repetirá sus intentos, y hará cambios y pruebas hasta lograr su objetivo; es decir, no se limita a responder, sino que se involucra más |
| {{< tag "Proyectos" "cube" >}} | El consejo o herramienta funciona dentro de un [proyecto de RStudio](/blog/r_introduccion/proyectos/) o carpetas de Positron, por lo que tiene acceso para leer o modificar a todos los scripts/archivos dentro del mismo, y así es capaz de comprender y hacer más cosas |
| {{< tag "Entorno de R" "fab fa-r-project" >}} | La IA podrá acceder a tu sesión de R y ejecutar código en ella, logrando una integración completa con tus proyectos; es decir, la IA puede saber lo que tienes cargado, explorar tus datos, revisar la documentación de tus paquetes instalados, usar tus funciones, cargar datos para ti, etc. |


### Acceso al servicio de IA

| <div style="width:140px">Leyenda</div> | Explicación |
|----------------------------------------|-------------|
| {{< tag "Llave de API" "key" >}} | La funcionalidad requiere de una [llave de API](/blog/ellmer/#proveedores-de-modelos-de-lenguaje-en-la-nube) para funcionar por medio de un pago por uso de IA, que debes configurar con `usethis::edit_r_environ()` |
| {{< tag "Posit AI Pass" "ticket" >}} | Puede requerir de una suscripción a [Posit AI Pass](https://posit.ai) para funcionar, un servicio para proveer a RStudio y Positron de múltiples proveedores de IA |
| {{< tag "IA local" "microchip" >}} | Puede funcionar con [inteligencia artificial local](/blog/ellmer/#modelos-de-lenguaje-locales) (que se ejecuta directamente en tu computador, sin depender de proveedores externos ni de internet) |

Vamos a ir de lo más simple/básico a lo más completo.

## Ideas generales al usar IA

{{< tag "Chatbot" "message" >}}


<i class='fas fa-robot icono-lateral'></i>

La IA está diseñada para responder con algo _estadísticamente similar a lo correcto_. En este sentido, uno de nuestros roles es aumentar esta probabilidad para que la IA nos de mejores resultados.

Al usar IA, te recomiendo:

- Escribir **_prompts_ extensos** que expliquen **qué quieres obtener**, cómo lo estás haciendo, y qué herramientas estás usando
- Entregarle **la mayor cantidad de contexto posible**: documentos, ejemplos, enlaces a información relacionada, como veremos adelante
- **Definir objetivos claros** que hagan que la respuesta se ajuste a tus necesidades: obtener una tabla de ciertas características, en informe dirigido a cierto público, etc.
- **Guiar a la IA** para que resuelva los problemas de manera directa, mencionando lenguajes (como R o Python), herramientas (paquetes del Tidyverse), _frameworks_ (como Shiny para hacer apps o Quarto para reportes o diapositivas), y estrategias (generar código legible, generar código mantenible, etc.)
- [**Planificar** el trabajo que hará la IA](#modo-planificación) para que los pasos sean claros, los medios usados sean apropiados, y los objetivos sean certeros

{{< info "**Prompt:** son los mensajes que hacemos llegar a la IA para obtener respuestas. Mientras más completo el mensaje, mejor será la respuesta." >}}

<i class='fas fa-file-lines icono-lateral'></i>

La calidad de lo que obtienes de la IA depende directamente de la calidad de lo que le entregas; es decir, la **calidad del contexto** con que la IA cuenta para responderte. Por eso recomiendo entregarle textos de apoyo, enlaces web, transcripciones de reuniones o conversaciones, documentos y todo tipo de material para generar mejores respuestas!

{{< info "**Contexto:** se le llama así a todo el contenido de texto que usa la IA para poder entregar sus respuestas; mientras más contexto relevante reciba, más fundamentadas serán sus respuestas." >}}

Al obtener respuestas de la IA, fijémonos en:

- **Revisar siempre** los resultados que entrega la IA, por más convincentes que parezcan!
- **Cuestionar las respuestas** de la IA para explorar posibilidades alternativas, sin quedarnos con la primera respuesta que nos de! Recuerda que, si le preguntas de nuevo, lo más probable es que te de una respuesta _distinta._



## Herramientas de autocompletado

{{< tag "RStudio" "registered" >}}
{{< tag "Código" "code" >}}
{{< tag "Posit AI Pass" "ticket" >}}

<i class='fas fa-laptop-code icono-lateral'></i>

La forma más básica de integrar IA en R es usarla para autocompletar; es decir, que a partir de lo que has escrito, sugiera cambios y nuevo código. 

RStudio y Positron integran esta capacidad con _Posit Next Edit Suggestion_, un sistema que usa IA para sugerir código directamente en tu IDE.

En RStudio puedes activarla en _Tools → Global Options → Assistant → Code Suggestions_

{{< cuadro "RStudio ofrece autocompletado de Posit AI Pass y de [GitHub Copilot](/blog/github_copilot/). En mi experiencia, el [autocompletado de GitHub Copilot](/blog/github_copilot/) es _infinitamente mejor_ que el de Posit." >}}

Revisa más información sobre [_Next Edit Suggestion_ aquí](https://positron.posit.co/assistant-completions.html#posit-ai-nes) o lee una [nota técnica sobre su funcionamiento](https://simonpcouch.com/blog/2026-03-06-nes/).


### Completado y corrección de código con [Gander](/blog/gander)

{{< tag "RStudio" "registered" >}}
{{< tag "Llave de API" "key" >}}
{{< tag "Código" "code" >}}
{{< tag "IA local" "microchip" >}}

Las sugerencias de autocompletado de más arriba aparecen automáticamente, pero también existen herramientas para invocar la ayuda de IA cuando y donde la necesites, por ejemplo con el [paquete de R `{gander}`](/blog/gander). 

Con Gander, al seleccionar texto e invocar un atajo de teclado se abre una ventana donde puedes pedirle a la IA que haga cambios, correcciones o mejoras.

En mi caso, tengo configurado [Gander](/blog/gander) con las teclas _comando + shift + G:_

{{< imagen "/blog/gander/gander_keys.png" "60%" >}}

Sin embargo, para usarlo necesitas [configurar una llave de API en R!](/blog/ellmer/#proveedores-de-modelos-de-lenguaje-en-la-nube)


## Dar contexto con _agents.md_

{{< tag "Arnés de IA" "laptop-code" >}}
{{< tag "Proyectos" "cube" >}}

Para guiar de manera general a la IA dentro de un proyecto de análisis de datos se recomienda crear un archivo `agents.md`.

El `agents.md` es un  [archivo Markdown](/blog/quarto_reportes/#markdown) donde van todas las indicaciones generales que necesitas que tu IA conozca. 

Los [arneses de IA](#integración-directa-con-r-posit-assistant) que pueden acceder a la carpeta de tu proyecto **detectan automáticamente** la presencia de `agents.md`, y lo leen apenas empieza la conversación. Así, la conversación inicia con un contexto general que guía el trabajo y mejora las respuestas.

<i class='fas fa-circle-info'></i> De esta forma no necesitas repetirle a la IA el contexto ni mismas las instrucciones de siempre.

Algunas recomendaciones sobre qué indicar en `agents.md`:

| Indicación | Ejemplo |
|------------|---------|
| Una **descripción** del proyecto y su nombre | _Exploración del Censo de Población y Vivienda 2024: análisis de estadísticas oficiales para explorar el fenómeno de envejecimiento poblacional..._ |
| Los **objetivos** del proyecto | _Esta es una [app Shiny](/blog/shiny/) para explorar datos en un mapa interactivo, orientado a especialistas en análisis territorial de la región de la Araucanía, Chile_ |
| Su **estructura** de archivos, scripts o archivos clave | _El script principal es `procesar.R`, los datos se guardan en la carpeta `resultados`_ |
| **Instrucciones** sobre cómo responder | _Explícame cada paso que hagas como si fuera un principiante en estadísticas... Eres un profesional de ciencias sociales computacionales, responde siempre con lenguaje formal y técnico_ |
| **Consejos** para guiar a la IA | _Usa solamente Tidyverse, privilegia código simple y legible, agrega comentarios breves antes de cada bloque_ |
| El **flujo de trabajo** a seguir | _Crea una carpeta por fuente de datos en `datos`, con un script de limpieza por cada una, y guarda los datos limpios en `resultados/datos/`_ |
| **Ejemplos** de cómo actuar | _[Valida los datos](/blog/2026-08-21/) en cada paso con `{pointblank}` así {inserte código}...El procedimiento para calcular el el índice debería ser {inserte fórmula}..._ |

Este documento va a ser leído por tu agente _antes de cada respuesta_, por lo que debe contener cosas que la IA **necesite saber** sobre su trabajo. Si el documento es demasiado extenso, podría hacerte consumir demasiados _tokens_ sin necesidad, y por consiguiente dinero/energía/uso de IA.

{{< cuadro "**Recomiendo usar `agents.md`** cuando tengamos proyectos medianos o grandes, que requieren contexto, conocimientos básicos o instrucciones específicas. Así la IA ya sabrá de qué se trata el proyecto, su temática, tus preferencias para programación y análisis, qué debe hacer y evitar, etc." >}}

## Modo _planificación_

{{< tag "Arnés de IA" "laptop-code" >}}
{{< tag "Loop" "repeat" >}}

La IA no siempre decide correctamente, muchas veces responde lo primero que se le ocurre sin reflexionar lo suficiente. Lo mejor es que la guíes con la elaboración de un plan.

<i class='fas fa-clipboard-list icono-lateral'></i>

El **modo planificación** está disponible en arneses de IA como [Posit Assistant](#integración-directa-con-r-posit-assistant), Claude Code y otros. Lo que hace es simplemente hacer que la IA reflexione sobre el objetivo que le des y elabore una secuencia de pasos con objetivos claros hacia un resultado final. Alternativamente, puedes pedirle o entregarle tú un plan enumerando las acciones que necesitas.

El modo planificación hace que la IA **piense antes de actuar**, generando una lista de contexto, objetivos, pasos a seguir y limitaciones. Esto es importante porque te da un momento para **revisar** el trabajo que hará la IA, y aplicar **correcciones** antes de que haga cualquier cosa.

En vez de simplemente pedir algo y que la IA lo haga, lo que hacemos es:

<div class="cuadros-verticales">

  <div class="cuadro-vertical">Describir el proyecto y sus objetivos</div>

  <div class="flecha">↓</div>
  
  <div class="cuadro-vertical-oscuro">La IA produce una planificación</div>
  
  <div class="flecha">↓</div>
  
  <div class="cuadro-vertical">Revisar planificación y modificar lo necesario</div>
  
  <div class="flecha">↓</div>
  
  <div class="cuadro-vertical-oscuro">Pedir a la IA que implemente/realice el plan</div>
  
</div>

Otro gran beneficio (cognitivo y psicológico) de usar la planificación es **comprender** con tu propia cabecita lo que hace la IA para no sentir que la IA trabaja sin que entendamos qué hizo o por qué lo hizo.

{{< cuadro "**Recomiendo el modo planificación** cuando necesites hacer algo complejo o extenso con IA, principalmente para tener _**control**_ e **incidencia** sobre el proceso, y también para que la IA no se descarrile haciendo cosas innecesarias o no solicitadas." >}}

## _Skills_ para habilidades e instrucciones específicas

{{< tag "Chatbot" "message" >}}
{{< tag "Código" "code" >}}
{{< tag "Arnés de IA" "laptop-code" >}}

<i class='fas fa-gear icono-lateral'></i>

La IA responde sólo en base a su conocimiento general, pero nosotr@s como especialistas sabemos dónde encontrar **conocimiento específico** que apunta directamente a lo que necesitamos. Por eso, lo mejor es entregarle a la IA el **contexto** para que sepa directamente **cómo se hacen las cosas** en vez de depender en su propio conocimiento y del azar. Para esto sirven las _skills_!

Las _skills_ son documentos de texto con instrucciones y contenido que el LLM puede leer cuando lo considere relevante, sirviendo como un repositorio de conocimiento extra controlado por ti. 

<div class="cuadros-verticales">

  <div class="cuadro-vertical">Provees de <em>skills</em> a tu IA</div>

  <div class="flecha">↓</div>
  
  <div class="cuadro-vertical">Le pides una tarea a la IA</div>
  
  <div class="flecha">↓</div>
  
  <div class="cuadro-vertical-oscuro">La IA detecta y lee la <em>skill</em> relevante</div>
  
  <div class="flecha">↓</div>
  
  <div class="cuadro-vertical-oscuro">La IA responde usando ese conocimiento</div>
  
</div>


Una razón de que existan las _skills_ es que **añadir contexto cuesta dinero**, entonces la gracia de las _skills_ es que el modelo solamente carga el contexto que necesita para cada tarea sin tener que leerse un libro enorme cada vez que lo invocas.

A continuación te dejo sitios donde puedes encontrar _skills_ para R:

- [Awesome R Stats Skills](https://github.com/christopherkenny/awesome-rstats-skills)
- [A collection of Claude Skills from Posit](https://github.com/posit-dev/skills)
- [Modern R Development Guide](https://github.com/jeremy-allen/claude-skills), originalmente un [archivo `agents.md` por Sarah Johnson](https://gist.github.com/sj-io/3828d64d0969f2a0f05297e59e6c15ad) separado en skills por Jeremy Allen
- [A Few Claude Skills for R Users](https://rworks.dev/posts/claude-skills-for-r-users/) por Isabella Velásquez

[Posit Assistant](#integración-directa-con-r-posit-assistant) viene con varias _skills_ de R instaladas!


#### Instalación de _skills_

<i class='fas fa-circle-arrow-down icono-lateral'></i>

Como las _skills_ son archivos de texto, simplemente hay que ponerlas en `.posit/assistant/skills/` dentro de una carpeta con el nombre de la _skill_.

También puedes instalar _skills_ a nivel de usuario en tu computador, para que estén disponibles en todas tus sesiones de R, instalándolas aquí: `~/.posit/assistant/skills/{nombre-de-la-skill}/SKILL.md`.

{{< cuadro "Por ejemplo, si quieres instalar [la _skill_ de `mirai`](https://github.com/posit-dev/skills/blob/main/r-lib/r-mirai/SKILL.md) para usar el paquete `{mirai}` para paralelizar la ejecución de R, tienes que descargar el archivo `SKILL.md` y ponerlo dentro de `.posit/assistant/skills/r-mirai/SKILL.md` en tu proyecto de R." >}}

#### Uso de _skills_

Simplemente pídele algo a tu IA relacionado a las _skills_ que tienes instaladas, o pídele explícitamente. Algunos _harness_ permiten ejecutar las skills directamente con un _slash_, por ejemplo `/quarto-authoring` para usar [la _skill_ de documentos Quarto](https://github.com/posit-dev/skills/tree/main/quarto/quarto-authoring).

En tu proyecto de R debería haber una carpeta invisible `.posit`, y dentro de ella la carpeta `assistant`. De
`.positai/skills/{skill-name}/SKILL.md`

Recuerda que cargar una _skill_ hace que entre en el contexto de tu IA, y por lo tanto significa un costo!

{{< cuadro "**Recomiendo usar _skills_** cuando necesitemos instrucciones específicas para ciertos procedimientos que la IA no maneja bien, o cuando hay un contexto extenso que sólo se necesita en ciertos momentos. Por ejemplo, _skills_ sobre paquetes de R avanzados y para metodologías o procedimientos estadísticos complejos." >}}

<!---
Para mantener este blog uso dos _skills_: una con mi [estilo personal de escritura](https://github.com/bastianolea/blog-R/blob/master/.posit/assistant/skills/estilo-escritura/SKILL.md) y otra que documenta [cómo funciona la estructura del blog](https://github.com/bastianolea/blog-R/blob/master/.posit/assistant/skills/hugo-blog/SKILL.md), que Posit Assistant consulta automáticamente cada vez que escribo o modifico una publicación.
--->



## Integración directa con R: _Posit Assistant_

{{< tag "Arnés de IA" "laptop-code" >}}
{{< tag "Proyectos" "cube" >}}

<p class="microtitulo"> Capacidades: </p>

{{< tag "Entorno de R" "fab fa-r-project" >}}
{{< tag "Código" "code" >}}
{{< tag "Archivos" "file" >}}
{{< tag "Loop" "repeat" >}}

<p class="microtitulo"> Acceso: </p>

{{< tag "Posit AI Pass" "ticket" >}}
{{< tag "IA local" "microchip" >}}
{{< tag "Llave de API" "key" >}}

[Posit Assistant](/blog/posit_assistant/) es un asistente de IA **integrado directamente** en RStudio o Positron, y es mi herramienta predilecta para apoyar mi trabajo en R con IA.

Su principal fortaleza es ser un _AI harness_ que tiene **acceso a tu consola y entorno de R**, lo que lo distingue de otras alternativas, ya que:

- La IA sabe qué archivo estás editando en tu IDE, y busca las partes que mencionas para editarlas o corregirlas
- La IA ve las carpetas y scripts de tu proyecto para **entender** lo que estás haciendo
- Puede **ver y manipular tus datos** directamente desde tu entorno de R
- La IA **ejecuta código de R** para comprender tus datos antes de actuar
- La IA entiende los errores que arroja R y realiza intentos hasta que todo funciona
- La IA puede **revisar la documentación** de los paquetes de R y de sus funciones, incluso para hacer cosas no documentadas

{{< imagen "posit_assistant_rstudio.png" >}}
{{< bajada "Ventana de RStudio con el panel de Posit Assistant al lado derecho" >}}

Se trata de un sistema **excelente** para consultas breves de código, corrección de problemas, para llevar a cabo análisis estadísticos completos, para escribir reportes de análisis de datos, para implementar cambios grandes, desarrollar aplicaciones, o lo que quieras. 

Posit Assistant tiene el beneficio de funcionar con **amplio contexto y herramientas optimizadas para R**, como consulta de documentación oficial de paquetes, principios de programación científica y reproducible, y mayor mesura al tratar temáticas de datos y estadísticas.

{{< relacionada "/blog/posit_assistant/" "Más información" >}}

{{< detalles "**¿Cómo acceder a Posit Assistant?**" >}}

Para usar Posit Assistant en principio se requiere de una suscripción a [Posit AI Pass](https://posit.ai), que cobra lo mismo que el acceso a cualquier proveedor de IA + un pequeño porcentaje extra para financiar sus operaciones. A cambio tienes la conveniencia de cambiar entre distintos modelos, simplicidad de configuración y apoyar el financiamiento del software libre.

También puedes hacer funcionar Posit Assistant con [múltiples proveedores](https://assistant.posit.co/docs/getting-started/providers/), no sólo [Posit AI Pass](https://posit.ai), así que puedes usar tus propias llaves de API e incluso modelos locales.

{{< /detalles >}}

Algunos usos que le puedes dar:

- Limpieza de datos, con un _modo_ específico para estas tareas 
- Redacción de reportes gracias a su capacidad de explorar y visualizar tus datos
- Escritura de documentación de proyectos complejos, incluyendo diagramas
- Implementación de tests unitarios para validar datos y funciones de paquetes de R

{{< cuadro "**Recomiendo Posit Assistant** porque ofrece capacidades avanzadas con mínima configuración, y con amplia seguridad en términos de privacidad de datos, responsabilidad en el análisis y solicitud de permisos." >}}



## Programación general con IA: _Claude Code_

{{< tag "Arnés de IA" "laptop-code" >}}
{{< tag "Llave de API" "key" >}}
{{< tag "Código" "code" >}}
{{< tag "Archivos" "file" >}}
{{< tag "loop" "repeat" >}}


<i class='fas fa-terminal icono-lateral'></i>

[Claude Code](https://claude.com/es/product/claude-code) (o Codex de OpenAI, Gemini CLI, Open Code, [Posit Assistant TUI](https://assistant.posit.co/downloads/tui/) u otras) es un software de línea de comandos (CLI) que instalas en tu computadora para dejar que la IA trabaje directamente sobre tus propios archivos, scripts y carpetas, usando comandos propios de tu computadora.

Esto habilita posibilidades avanzadas que también permite [Posit Assistant](#integración-directa-con-r-posit-assistant), pero mucho más amplias en el sentido de que puede ocupar otros lenguajes de programación y en general hacer _cualquier cosa_ sobre tu sistema. En este sentido habilita lo que muchos llaman _vibe coding_, la práctica de simplemente describir lo que quieres que se desarrolle sin que tengas que saber nada.

{{< aviso "Sólo recomiendo usarlo si sabes lo que estás haciendo!" >}} 

_Para usarlo necesitas de una llave de API._

## Permitir que la IA use R

{{< tag "Llave de API" "key" >}}
{{< tag "Entorno de R" "fab fa-r-project" >}}
{{< tag "Datos" "file" >}}
{{< tag "Herramientas" "wrench" >}}

Una última manera de usar IA en R es usarla directamente en el lenguaje de programación, o bien, que la IA use R!

[El paquete de R `{ellmer}`](/blog/ellmer/) facilita la integración de inteligencia artificial en funciones de R, por ejemplo para crear una función que clasifica textos, para redactar respuestas o salidas paraa tus funciones, y más. 

En princpio, cualquier cosa que una IA puede hacer podría ser integrada en una función de R y para aplicarla a tus datos de una manera más **controlada** y **reproducible**.

{{< relacionada "/blog/ellmer/" >}}

Uno de los usos principales es completar el ciclo **R → IA → R**, donde creamos una función en R que la IA puede usar, y luego usamos la IA para que use dicha función y nos entregue mejores respuestas. Por ejemplo, hacer una función de R que consulte datos para hacer que la IA pueda consultar datos, una función que realice un cálculo estadístico para que la IA calcule correctamente, etcétera.

{{< relacionada "/blog/herramientas_llm/" >}}

También se puede hacer que la IA use R para consultar grandes cuerpos de información (por medio de RAG), y así garantizar que las respuestas se ajusten a conocimiento validado y/o altamente específico, **disminuyendo las alucinaciones**.

{{< relacionada "/blog/rag_ragnar/" >}}

De esta manera podemos [programar _chatbots_](/blog/shinychat/) que combinan el conocimiento de la IA con cualquier capacidad que tenga R, incluso controlar aplicaciones Shiny, como en [CensoLab](https://santiagorusers.github.io/posts/2026-08-26/)!

{{< relacionada "/blog/shinychat/" >}}

## Recursos
- [Posit AI Pass](https://posit.ai), servicio de suscripción de Posit para integrar IA con RStudio y Positron
- [Modern R workflow](pos.it/modern-r-workflow), workshop impartido en [posit::conf(2026)](https://conf.posit.co/2026/)
- [Awesome R Stats Skills](https://github.com/christopherkenny/awesome-rstats-skills), extensa colección de _skills_ para R
- [Herramientas para usar modelos de lenguaje de gran escala (LLM) en R](https://luisdva.github.io/llmsr-book/es/index.es.html)

{{< etiqueta "inteligencia artificial" >}}

{{< cafecito >}}