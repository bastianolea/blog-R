---
title: "Posit Assistant, una IA para análisis de datos integrada en RStudio"
subtitle: "Reseña de mi experiencia con esta herramienta de inteligencia artificial especializada para análisis de datos"
author: Bastián Olea Herrera
date: '2026-06-13'
draft: false
slug: []
categories: []
tags:
  - blog
  - inteligencia artificial
  - consejos
  - básico
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: registered
    icon_pack: fas
    name: Posit Assistant
    url: https://posit-dev.github.io/assistant/
excerpt: "Recientemente Posit, la corporación detrás de RStudio y responsable de muchos de los paquetes que más usamos en el ecosistema de R, [anunció la integración oficial de inteligencia artificial en RStudio](https://posit.co/blog/introducing-ai-in-rstudio). Posit Assistant reside en la barra lateral de RStudio y sirve para hacer consultas a una IA relacionadas al análisis de datos, dentro del contexto del proyecto que estés realizando con R. "
---

Recientemente [Posit](https://posit.co), la ~~empresa~~ corporación de beneficio público detrás de RStudio, Positron, y responsable de [muchos de los paquetes que más usamos en el ecosistema de R](https://posit.co/products/open-source/rpackages), anunció la [integración oficial de inteligencia artificial en RStudio](https://posit.co/blog/introducing-ai-in-rstudio).

[**Posit Assistant**](https://posit-dev.github.io/assistant/) reside en la barra lateral de RStudio y sirve para hacer consultas a una IA relacionadas al análisis de datos, dentro del contexto del proyecto que estés realizando con R. 

{{< imagen "posit_assistant_rstudio.png" "500px" >}}
{{< bajada "En la parte superior de RStudio encuentras el botón Posit Assistant." >}}

Su potencial reside en que se **integra profundamente con R** y con tu trabajo: 

- Revisa los _scripts_ de tu proyecto para **entender** lo que estás haciendo
- Puede ver y manipular directamente los **datos** con los que estás trabajando
- Ejecuta código para **comprender** tus datos, hace **experimentos y pruebas** con código de R sobre tus datos, y explora visualmente tus datos
- Sabe qué archivo estás editando, y puede leerlo, buscar las partes que mencionas y editarlas o corregirlas (con tu permiso)
- Puede analizar lo que has hecho y **crear reportes**, escribir neuvos scripts, o sugerirte formas de avanzar

Las capacidades de Posit Assistant van mucho más allá que las de cualquier otro _harness_ de inteligencia artificial que he probado (como Claude Code), dado que puede **ejecutar código de R en tu misma sesión**. Si bien otras soluciones de IA también pueden ejecutar código, Posit Assistant accede a los datos que ya tienes cargados porque **comparte tu entorno de R**, y tiene la posibilidad de ejecutar código para **entender tus datos** y **experimentar** con ellos.

Posit Assistant funciona con modelos de Anthropic, así que puedes elegir entre Haiku, Sonnet, u Opus, o bien usar Gemma 4, que es mucho más económico.

{{< imagen "posit_assistant_featured.png" "340px" >}}
{{< bajada "Pantalla de inicio de Posit Assistant" >}}


### Mi experiencia 

Durante varias semanas he estado usando este servicio y mi veredicto es que es muy bueno! 💜

Me gusta que está diseñado para ser muy cuidadoso al proceder. Lo primero que hace Posit Assistant al activarlo en un proyecto es pedirte permiso para acceder a tus archivos.

{{< imagen "posit_assistant_14.png" "340px" >}}
{{< bajada "Pantalla de permiso al inciar una sesión con el asistente de IA" >}}

Esto le permite al asistente **leer tus archivos y navegar tu proyecto** para conocer su estructura. Luego, a medida que avanzas, el asistente va **pidiendo permisos** antes de hacer cambios, y es precavido en términos metodológicos antes de sugerir estrategias.

{{< imagen "posit_assistant_3.png" "340px" >}}
{{< bajada "Posit Assistant mostrando los cambios que realizó y pidiendo permiso para aplicarlos" >}}

También me gusta el **modo planificación** que te resume lo que va a hacer paso por paso, para que comprendas los cambios antes de aprobarlos y realizarlos (muy recomendado para mantener el control del proyecto). Luego de definir el plan, te lo presenta de manera ordenada para que puedas modificarlo o implementarlo.

{{< imagen "posit_assistant_15.png" "340px" >}}
{{< bajada "Modo de planificación de Posit Assistant ofreciendo guardar los pasos a seguir, modificarlos o implementarlos" >}}

Incluso fuera del modo de planificación, el asistente **sugiere** estrategias y te pide retroalimentación antes de implementarlas. No funciona a ciegas, sino que **trabaja junto a ti**, quien eres el/la experto/a.

{{< imagen "posit_assistant_9.png" "340px" >}}
{{< bajada "Posit Assistant planificando la generación de un reporte, preguntando primero si estás de acuerdo con su plan" >}}

Esto es súper importante a la hora de trabajar con inteligencia artificial y datos: a pesar de que la IA haga parte del trabajo, es tu responsabilidad **comprender lo que la IA está haciendo**, y **controlar el proceso** en todo momento.

Cuando empiezas a involucrar a Posit Assistant en tu proyecto, el asistente primero **revisa tu código, carpetas y archivos**, intentando entender para trabajar siempre dentro del contexto de tu trabajo.

{{< imagen "posit_assistant_4.png" "340px" >}}
{{< bajada "Posit Assistant leyendo archivos por su propia cuenta para entender tu proyecto" >}}

Es interesante ver cómo revisa la estructura de tus scripts y los va leyendo para entender, o busca términos dentro de ellos, o líneas específicas. Incluso a veces puede salir a buscar documentos que están fuera de tu proyecto de R (en otras carpetas de tu computadora), pero siempre avisando y pidiendo permiso.

Al momento de trabajar con datos, siempre se dedica a **explorar las variables** primero para tomar todas las precauciones:

{{< imagen "posit_assistant_6.png" "340px" >}}
{{< bajada "Posit Assistant explorando aspectos puntuales de los datos para poder tomar decisiones" >}}

Incluso, si detecta que le falta algo pero ve que está disponible en tu código o en tus directorios, puede llegar y cargarlo si cree que lo necesita:

{{< imagen "posit_assistant_2.png" "340px" >}}
{{< bajada "Posit Assistant cargando datos para explorarlos y tomar decisiones, explicando sus razones" >}}

No puedo dejar de destacar lo importante que es que la IA comparta tu entorno de R: significa que puede **acceder directamente a tus datos**, sin intermediarios, o sea que puedes decirle "mira el dataframe `blabla`", y luego actualizar los datos y decirle "revisa de nuevo porque cambié algo", e inmediatamente la IA va a ver los cambios en el código y continuar.

{{< imagen "posit_assistant_13.png" "340px" >}}
{{< bajada "Posit Assistant accediendo a objetos cargados en tu entorno de R" >}}

Además de la integración con el entorno estadístico de R, Posit Assistant también se integra estrechamente con tu IDE o entorno de desarrollo, RStudio, siendo capaz de saber qué script estás mirando o editando, e incluso **sabe del código que tienes seleccionado** para poder hacer preguntas sobre partes específicas de tus proyectos!

{{< imagen "posit_assistant_16.png" "340px" >}}
{{< bajada "Puedes pedirle a Posit Assistant cosas relacionadas al script que tengas abierto y lo reconocerá, o incluso si seleccionas código puedes preguntarle directamente sobre ese código y lo reconocerá" >}}

Todo lo anterior elimina todas las fricciones que existen al trabajar con IA, ya que literalmente **la IA trabaja a la par contigo en R.** Olvídate de copiar y pegar!

Cuando a IA ejecuta código, lo ejecuta en tu misma consola, agregando una etiqueta de IA en la parte superior derecha.

{{< imagen "posit_assistant_5.png" "340px" >}}
{{< bajada "RStudio aplica una etiqueta de IA en la esquina superior derecha del código ejecutado por el asistente" >}}

Naturamente, cuando se encuentra con errores, ya sea porque los datos cambiaron y no se dio cuenta, o porque le falta un paquete, el asistente se fija y puede recuperarse de los errores.

{{< imagen "posit_assistant_7.png" "340px" >}}
{{< bajada "Posit Assistant recuperándose de errores que pueden surgir cuando ejecuta código" >}}

Si al ejecutar código llega a un momento donde necesita tu feedback, tiene interfaces para hacerte consultas interactivas y luego continuar con tu input:

{{< imagen "posit_assistant_12.png" "340px" >}}
{{< bajada "Posit Assistant presentando alternativas por su propia cuenta para que el/la usuario/a decida" >}}

También aprecio que siempre puedes **cancelar una acción dándole indicaciones** para corregir el rumbo de lo que está haciendo:

{{< imagen "posit_assistant_8.png" "340px" >}}
{{< bajada "Posibilidad de rechazar una acción sugerida por Posit Assistant, y sugerir un rumbo distinto" >}}

Al terminar una sesión de trabajo, puedes **guardar o exportar la conversación**. Personalmente encuentro que esto es muy útil para ir manteniendo una documentación de sesiones pasadas que luego puedes volver a revisar, o copiar cosas desde ellas.

{{< imagen "posit_assistant_10.png" "340px" >}}
{{< bajada "Exportación de conversaciones como documentos HTML o Quarto para mantener registro de las decisiones tomadas" >}}

La implementación de Posit Assistant está llena de detalles que intentan mantener un cierto orden y responsabilidad en el trabajo del/la analista con la IA. Por ejemplo, cuando le pides que genere reportes de lo que han analizado, agrega elementos que indican que el contenido fue generado por IA y que tiene pendiente su revisión, para **explicitar la revisión humana del output de la IA** y así mantener responsabilidad y autoría cognitiva de sus outputs.

{{< imagen "posit_assistant_11.png" "340px" >}}
{{< bajada "Posit Assistant agregando elementos en los reportes que incentivan una responsabilidad sobre la autoría y la revisión de contenido generado con IA" >}}




### Privacidad 

Posit tiene un acuerdo con Anthropic para **mantener la privacidad de tus datos**, como indican en su [documentación](https://docs.posit.co/posit-ai/user/faq/#privacy-data-storage). Esta política de _cero retención de datos_ significa que los datos que envíes se descartan inmediatamente luego de ser usados para ofrecerte el servicio.

### Conclusiones

_**Para usuarixs principiantes:**_ es muy útil para poder avanzar cuando sentimos que nuestra falta de conocimientos nos bloquea, o para resolver problemas técnicos que nos distraen de nuestra tarea principal. Siempre está la tentación de que la guía haga todo sola, pero creo que es mejor usarla para que nos ayude a entender.

_**Para usuarixs intermedios/avanzados:**_ ayuda bastante poder consultar y recibir ayuda de manera inmediata y siempre contextualizada correctamente a lo que estás haciendo, así como poder encontrar solución a problemas que no se encuentran fácilmente en internet, y claro, tener la opción de poder realizar análisis, reportes y otros productos de forma mucho más rápida.

Recomiendo mucho probar esta herramienta. Me ha ayudado a destrabar ciertas situaciones, a explorar posibilidades más rápido, y a implementar cambios tediosos o de contenidos que no domino y que no me interesa dominar aún en el corto plazo (como la gestión de este blog, jaja). 

Pero no olvidar que la inteligencia artificial nunca es un reemplazo de nuestra intención y agencia, y que debemos usarla de manera responsable y complementaria a nuestro propio trabajo y aprendizaje.

{{< boton "Prueba Posit Assistant en RStudio" "https://posit-dev.github.io/assistant/" "fab fa-r-project" >}}

{{< etiqueta "inteligencia artificial" >}}

{{< cafecito >}}

{{< cursos >}}