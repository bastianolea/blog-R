---
title: "Posit Assistant, un asistente de IA para análisis de datos integrado en RStudio"
subtitle: "Reseña de mi experiencia con esta herramienta de inteligencia artificial especializada para análisis de datos"
author: Bastián Olea Herrera
date: '2026-06-12'
draft: true
slug: []
categories: []
tags:
  - blog
  - inteligencia artificial
  - consejos
format:
  hugo-md:
    output-file: index
    output-ext: md
links:
  - icon: registered
    icon_pack: fas
    name: Posit Assistant
    url: https://posit-dev.github.io/assistant/
excerpt: "Recientemente Posit, la corporación detrás de RStudio y muchos de los paquetes que más usamos en el ecosistema de R, [anunció la integración oficial de inteligencia artificial en RStudio](https://posit.co/blog/introducing-ai-in-rstudio). Posit Assistant reside en la barra lateral de RStudio y sirve para hacer consultas a una IA relacionadas al análisis de datos, dentro del contexto del proyecto que estés realizando con R. "
---

Recientemente [Posit](https://posit.co), la ~~empresa~~ corporación de beneficio público detrás de RStudio, Positron, y [muchos de los paquetes que más usamos en el ecosistema de R](https://posit.co/products/open-source/rpackages), [anunció la integración oficial de inteligencia artificial en RStudio](https://posit.co/blog/introducing-ai-in-rstudio).

[**Posit Assistant**](https://posit-dev.github.io/assistant/) reside en la barra lateral de RStudio y sirve para hacer consultas a una IA relacionadas al análisis de datos, dentro del contexto del proyecto que estés realizando con R. 

{{< imagen "posit_assistant_rstudio.png" "600px" >}}

Su potencial reside en que se **integra estrechamente** con tu trabajo: 

- Puede revisar los _scripts_ de tu proyecto para entender mejor
- Puede ver directamente los datos que estás trabajando
- Ejecuta código para comprender tus datos, hace experimentos con código de R, y explora visualmente tus datos
- Sabe qué archivos tienes abiertos, cuál estás editando, modificarlos (con tu permiso) y/o escribir archivos nuevos

Las capacidades de Posit Assistant van mucho más allá que las de cualquier otro _harness_ de inteligencia artificial que he probado (como Claude Code), dado que puede **ejecutar código de R en tu misma sesión**. Si bien otras soluciones de IA también pueden ejecutar código, Posit Assistant accede a los datos que ya tienes cargados porque **comparte tu entorno de R**, y tiene la posibilidad de ejecutar código para **entender tus datos** y **experimentar** con ellos.

Posit Assistant funciona con modelos de Anthropic, así que puedes elegir entre Haiku, Sonnet, u Opus, o bien usar Gemma 4, que es mucho más económico.

{{< imagen "posit_assistant_featured.png" >}}
{{< bajada "Pantalla de inicio de Posit Assistant" >}}


### Mi experiencia 

Durante varias semanas he estado usando este servicio y mi veredicto es que es muy bueno!

Me gusta que está diseñado de tal forma que es muy cuidadoso al proceder. Lo primero que hace Posit Assistant al activarlo en un proyecto es pedirte permiso para acceder a tus archivos.

{{< imagen "posit_assistant_14.png" >}}
{{< bajada "Pantalla de permiso al inciar una sesión con el asistente de IA" >}}

Esto le permite al asistente **leer tus archivos y navegar tu proyecto** para conocer su estructura. Luego, a medida que avanzas, el asistente va pidiendo permisos antes de hacer cambios, y es precavido en términos metodológicos antes de sugerir estrategias.

{{< imagen "posit_assistant_3.png" >}}
{{< bajada "Posit Assistant mostrando los cambios que realizó y pidiendo permiso para aplicarlos" >}}

También me gusta el **modo planificación** que te resume lo que va a hacer paso por paso, para que comprendas los cambios antes de aprobarlos y realizarlos. Luego de definir el plan, te lo presenta de manera ordenada para que puedas modificarlo o implementarlo.

{{< imagen "posit_assistant_15.png" >}}
{{< bajada "Modo de planificación de Posit Assistant ofreciendo guardar los pasos a seguir, modificarlos o implementarlos" >}}

Incluso fuera del modo de planificación, el asistente **sugiere** estrategias y te pide retroalimentación antes de implementarlas. No funciona a ciegas, sino que funciona junto a ti como experto/a.

{{< imagen "posit_assistant_9.png" >}}
{{< bajada "Posit Assistant planificando la generación de un reporte, preguntando primero si estás de acuerdo con su plan" >}}

Esto es súper importante a la hora de trabajar con inteligencia artificial y datos: a pesar de que la IA haga parte del trabajo, es tu responsabilidad **comprender lo que la IA está haciendo**, y **controlar el proceso** en todo momento.

Cuando empiezas a involucrar a Posit Assistant en tu proyecto, el asistente primero revisa tu código, intentando entender para que lo que haga tenga consideración de toda la complejidad de tu trabajo.

{{< imagen "posit_assistant_4.png" >}}
{{< bajada "Posit Assistant leyendo archivos por su propia cuenta para entender tu proyecto" >}}

Es interesante ver cómo revisa la estructura de tus scripts y los va leyendo para entender, o busca términos dentro de ellos, o líneas específicas.

Al momento de trabajar con datos, siempre se dedica a explorarlos primero para tomar todas las precauciones:

{{< imagen "posit_assistant_6.png" >}}
{{< bajada "Posit Assistant explorando aspectos puntuales de los datos para poder tomar decisiones" >}}

Incluso, si detecta que le falta algo pero lo ve en tu código, puede llegar y cargarlo si cree que lo necesita:

{{< imagen "posit_assistant_2.png" >}}
{{< bajada "Posit Assistant cargando datos para explorarlos y tomar decisiones, explicando sus razones" >}}

No puedo dejar de destacar lo importante que es que la IA comparta tu entorno de R: significa que puede **acceder directamente a tus datos**, sin intermediarios, o sea que puedes luego actualizar los datos, decirle "revisa de nuevo porque cambié ésto", e inmediatamente la IA va a ver los cambios en los datos y continuar.

{{< imagen "posit_assistant_13.png" >}}
{{< bajada "Posit Assistant accediendo a objetos cargados en tu entorno de R" >}}

Esto elimina todas las fricciones que existen al trabajar con IA, ya que literalmente **la IA trabaja a la par contigo en R.**

Cuando a IA ejecuta código, lo ejecuta en tu misma consola, agregando una etiqueta de IA en la parte superior derecha.

{{< imagen "posit_assistant_5.png" >}}
{{< bajada "RStudio aplica una etiqueta de IA en la esquina superior derecha del código ejecutado por el asistente" >}}


Naturamente, cuando se encuentra con errores, ya sea porque los datos cambiaron y no se dio cuenta, o porque le falta un paquete, el asistente se fija y puede recuperarse de los errores.

{{< imagen "posit_assistant_7.png" >}}
{{< bajada "Posit Assistant recuperándose de errores que pueden surgir cuando ejecuta código" >}}

Si al ejecutar código llega a un momento donde necesita tu feedback, tiene interfaces para hacerte consultas interactivas y luego continuar con tu input:

{{< imagen "posit_assistant_12.png" >}}
{{< bajada "Posit Assistant presentando alternativas por su propia cuenta para que el/la usuario/a decida" >}}

También aprecio que siempre puedes **cancelar una acción dándole indicaciones** para corregir el rumbo de lo que está haciendo:

{{< imagen "posit_assistant_8.png" >}}
{{< bajada "Posibilidad de rechazar una acción sugerida por Posit Assistant, y sugerir un rumbo distinto" >}}

Al terminar una sesión de trabajo, puedes **guardar o exportar la conversación**. Personalmente encuentro que esto es muy útil para ir manteniendo una documentación de sesiones pasadas que luego puedes volver a revisar, o copiar cosas desde ellas.

{{< imagen "posit_assistant_10.png" >}}
{{< bajada "Exportación de conversaciones como documentos HTML o Quarto para mantener registro de las decisiones tomadas" >}}

La implementación de Posit Assistant está llena de detalles que intentan mantener un cierto orden y responsabilidad en el trabajo del/la analista con la IA. Por ejemplo, cuando le pides que genere reportes de lo que han analizado, agrega elementos que indican que el contenido fue generado por IA y que tiene pendiente su revisión, para **explicitar la revisión humana del output de la IA** y así mantener responsabilidad y autoría cognitiva de sus outputs.

{{< imagen "posit_assistant_11.png" >}}
{{< bajada "Posit Assistant agregando elementos en los reportes que incentivan una responsabilidad sobre la autoría y la revisión de contenido generado con IA" >}}




### Privacidad 

Posit tiene un acuerdo con Anthropic para **mantener la privacidad de tus datos**, como indican en su [documentación](https://docs.posit.co/posit-ai/user/faq/#privacy-data-storage). Esta política de _cero retención de datos_ significa que los datos que envíes se descartan inmediatamente luego de ser usados para ofrecerte el servicio.

### Conclusión

Recomiendo mucho probar esta herramienta. Me ha ayudado a des-trabar ciertas situaciones, a explorar posibilidades más rápido, y a implementar cambios tediosos o de contenidos que no domino y que no me interesa dominar aún en el corto plazo (como la gestión de este blog, jaja). Pero no olvidar que la inteligencia artificial nunca es un reemplazo de nuestra intención y agencia, y que debemos usarla de manera responsable y complementaria a nuestro propio trabajo y aprendizaje.

{{< boton "Prueba Posit Assistant en RStudio" "https://posit-dev.github.io/assistant/" "fab fa-r-project" >}}

{{< etiqueta "inteligencia artificial" >}}