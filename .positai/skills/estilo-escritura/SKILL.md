Mi nombre es Bastián Olea Herrera, estudié sociología, y soy de Chile.

El contenido de este blog son publicaciones y tutoriales sobre el lenguaje de programación R, orientados al análisis de datos aplicado a temáticas de ciencias sociales. 

Este sitio contiene todo tipo de recursos sobre programación con el lenguaje R aplicado al análisis de datos sociales. Comparto datos, proyectos, consejos y tutoriales para que otras personas puedan adentrarse en la programación con R. También busco compartir datos sociales sobre Chile de forma atractiva y accesible, por medio de aplicaciones interactivas y otros proyectos desarrollados en R, para que cualquier persona pueda explorar datos que le permitan responder sus inquietudes.

## Objetivos

El objetivo de este blog es:

- Ayudar a otras personas a aprender R aplicado al análisis de datos
- Mostrar algunos usos útiles o interesantes de R para el análisis de datos
- Documentar mis propios aprendizajes en R, para poder buscarlos en el futuro y referirlos

## Sobre las publicaciones
Existen varios tipos de publicaciones: las que están en carpetas con nombre de fecha son publicaciones más cortas sobre temas puntuales o curiosidades. Las que tienen carpeta con nombre desarrollan temáticas más en profundidad, y finalmente, las que tienen `categories` "Tutoriales" son explicaciones paso a paso para enseñar, usualmente desde cero, alguna temática en R.

Todas las publicaciones usan etiquetas (`tags` en el yaml). Todas las etiquetas se escriben en minúscula, menos "Chile", y con tildes correspondientes. Las más usadas, en orden de cantidad de publicaciones, son: Chile, Datos, Consejos, Visualización de datos, Blog, Gráficos, Shiny, Aplicaciones, ggplot2, Básico, Mapas, Limpieza de datos, Web scraping, Inteligencia artificial, Procesamiento de datos, Quarto, Curiosidades, Procesamiento de texto, dplyr, Optimización.


## Estilo de escritura
Las publicaciones son escritas en castellano chileno, en lenguaje levemente informal, usualmente sobre temas que se relacionan con Chile, con explicaciones que van al grano pero que buscan detallar cada paso del código, explicando antes de los bloques de código lo que se va a hacer, y después de los bloques de código observaciones sobre los resultados obtenidos, si es que corresponde. 

Cuando hablo de una temática en el blog, busco agregar la mayor cantidad de enlaces a publicaciones anteriores, para ayudar a usuarios/as a encontrar más contenido detallado sobre cada tema.

Escribo en lenguaje inclusivo siempre que sea posible: "personas" en vez de palabras con género, terminar palabras con "os/as", con @ o con x intercaladamente: por ejemplo, "programadoras/es" en vez de "programadores.

Uso emojis solamente cuando obtenemos un resultado al final de una publicación, o cuando estamos mostrando un ejemplo de algo confuso o mal hecho que luego queremos corregir. De lo contrario, no uso emojis dentro del texto de los posts.

Las palabras en inglés se ponen en itálicas.

Existen varios _shortcodes_ que uso constantemente para hacer más entretenidas y dinámicas las publicaciones, que puedes revisar en [references/shortcodes.md](references/shortcodes.md) de esta skill.


## Consideraciones sobre código
- Cuando en un chunk de código R se cargue `library(dplyr)`, agrega `#| message: false` y `#| warning: false` para omitir los mensajes del paquete. No quiero que en las publicaciones hayan mensajes irrelevantes que puedan confundir a las personas.
- Los paquetes los escribo así: `{dplyr}`
- Escribir nombres de variables, funciones y otros elementos de programación con eñe: nunca escribir `anio`, usar `año` (R no va a tener ningún problema con el símbolo).
- Si vas a crear chunks, agrega el label dentro del `{r etiqueta}` en vez de ponerlo dentro como `#| label: etiqueta`.
- Los comentarios siempre escríbelos en minúsculas


## Indicaciones para redacción de IA
- Trata de seguir mi estilo de escritura natural, casual, preciso. Si es necesario, busca dentro de la carpeta `content/blog/` archivos `.qmd` o `.md` que traten sobre temas similares y léelos para copiar mi forma de redacción.
- No usar artículos en títulos: en vez de decir "El problema", usa "Problemas". No decir "La leyenda bivariada", mejor di "Leyenda bivariada"
- No usar oraciones del tipo "no es x, es y"

### Ejemplos de mi redacción

Los siguientes son extractos de mi forma de escritura, que quiero que emules:

> El *left join* es una de las operaciones básicas del trabajo con datos, en el sentido de que realiza una operación sencilla que a la vez es muy útil. Sirve tanto para limpiar datos como para procesarlos y obtener nuevas relaciones entre ellos.

> Un *left join* realiza una unión o combinación entre dos tablas de datos a partir de una variable en común o *clave* (*key*). En otras palabras, un *left join* toma dos tablas que tienen datos distintos, pero que comparten una variable o columna en común, y usa esta variable en común para **unir las observaciones de ambas tablas**.

> Con R y los paquetes apropiados, en pocos minutos podrás crear un chat interactivo de inteligencia artificial dentro de una aplicación Shiny, para poder chatear con un modelo de lenguaje (LLM) de tu elección. El objetivo es poder crear un chat interactivo e ir mejorándolo con la capacidad de **consultar datos**, **realizar cálculos** y otras capacidades propias de R, y además aumentar su conocimiento y la precisión de sus respuestas al permitirle **consultar documentos y textos** para responder. 

> En la sección _server_ de la app, creamos el **output** que será la salida con lo que vamos a mostrar en la interfaz de la app. Aquí es donde podemos usar R normalmente para crear lo que queramos, pero dentro de ciertos _marcos_ que circunscriben el código de R a la lógica de una aplicación interactiva Shiny. Uno de estos _marcos_ para apps interactivas es que, a diferencia de un script normal donde podemos generar resultados (cifras, tablas, gráficos) en cualquier parte, en una app tenemos que **definir las salidas** de manera clara, con un nombre y una función apropiada para crear la salida, y luego **ubicar las salidas en algún lugar** de la interfaz de la aplicación.

> Chatear con modelos de lenguaje (LLM) o _IAs_ —como se les llama coloquialmente— puede tener muchos usos para el análisis de datos. Si bien siempre se puede usar IA desde las páginas/apps de los proveedores más populares, cuando analizamos datos es mejor **usar IA directamente desde R**. Así podemos **entregar datos** a la IA, aprovechar las capacidades de la IA para hacer funciones y desbloquear análisis complejos, **integrar IA** en nuestro procesamiento de datos, **mantener el control** de cómo y dónde se usa la IA en nuestro análisis, usar IA de manera **reproducible**, y usar directamente los resultados de la IA en nuestros flujos de trabajo.