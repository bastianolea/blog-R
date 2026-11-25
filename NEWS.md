## 2026/11/25

- Nuevo **botón de _copiar código_** en todos los bloques de código del sitio. Implementado [en este script](https://github.com/bastianolea/blog-R/tree/master/static/js/copiar-codigo.js) y se aplica a todas las páginas del blog al estar [en `baseof.html`](https://github.com/bastianolea/blog-R/tree/master/layouts/_default/baseof.html)
- Mejora en los degradados de las publicaciones similares al final de los post.
- Implementado _lazy loading_ en imágenes de publicaciones para cargas más rápidas del sitio.

## 2026/11/19

- **Contador de visitas** en las publicaciones más visitadas, obtenido desde GoatCounter.
- Nueva mini sección de **publicaciones más leídas** en la portada.
- Al final de cada publicación ahora aparecen **publicaciones similares**: se eligen según las etiquetas en común con la publicación actual (las etiquetas menos frecuentes pesan más) y según su cantidad de visitas.

## 2026/11/13

- Nueva **sección [Paquetes](/categories/paquetes/)** en el menú superior, con las publicaciones sobre paquetes de R que he desarrollado.

## 2026/10/14

- Las publicaciones que fueron actualizadas muestran su **fecha de actualización** junto a la fecha de publicación, y el listado del blog se ordena por fecha de modificación. Así puedo reflotar publicaciones mejoradas o actualizadas.

## 2026/10/13

- **Versión del sitio para IA**: el blog ahora genera un índice [`/llms.txt`](/llms.txt) con todas las publicaciones agrupadas por tema, y cada publicación tiene una versión en Markdown (`index.md`) sin estilos ni código innecesario. 
- **Botón _Copiar texto para IA_** debajo del índice de cada publicación, para copiar su contenido y pegarlo en un chat con IA.
- El [buscador](/buscar/) se trasladó a _Posit Connect Cloud_ para que funcione más rápido.

## 2026/10/12

- El menú _Temas_ ahora tiene un **menú desplegable** con las etiquetas más usadas.
- Los íconos de redes sociales muestran una descripción al pasar el cursor.
- Captcha en el formulario de [contacto](/contacto/) para frenar el _spam_.

## 2026/09/01

- Los listados de publicaciones muestran el subtítulo de cada publicación, con menos espaciado entre ellas.

## 2026/08/31

- Corrección automática de enlaces internos rotos en publicaciones escritas en Quarto, y revisión automática de enlaces después de construir el sitio.
- Mejoras en el estilo de la portada y de la lista de publicaciones.

## 2026/08/28

- Nueva [función `crear_publicacion()`](https://github.com/bastianolea/blog-R/blob/master/R/funciones.R) para crear publicaciones nuevas. Es un envoltorio de `blogdown::new_post()` que, si la publicación es un documento Quarto, crea el archivo `_quarto.yml` necesario para que funcione el botón _Render_ de RStudio, y abre la carpeta de la publicación en el panel de archivos.
- Nueva [función `abrir_borradores()`](https://github.com/bastianolea/blog-R/blob/master/R/funciones.R), que muestra una lista de los borradores modificados más recientemente y abre el que se elija, para poder resumir el trabajo en los pendientes.

## 2026/08/27

- Fechas en formato día/mes/año en todo el sitio, incluyendo las páginas de [clases](/clases/). Los eventos sin horario definido ya no muestran la hora.

## 2026/08/21

- El [buscador](/buscar/) se precarga en segundo plano al abrir cualquier página, para que cargue más rápido.

## 2026/08/07

- Los títulos de publicaciones con código (por ejemplo, `{paquete}`) ya no muestran símbolos de Markdown en buscadores ni en los enlaces entre publicaciones.
- Nuevo _shortcode_ para marcar pasos numerados en tutoriales.

## 2026/07/03

- Verificación del sitio en Google Search Console.

## 2026/06/20

- Optimización del índice de publicaciones que usa el [buscador](/buscar/).

## 2026/06/16

- Las [páginas de etiquetas](/tags/) ahora tienen descripciones de cada tema.

## 2026/06/12

- El sitio pasa a usar el dominio `bastianolea.rbind.io`.
- Mejoras de accesibilidad en textos secundarios.

## 2026/06/07

- El [buscador](/buscar/) ahora es una página dentro del blog, manteniendo el menú y el pie de página del sitio.
- Las publicaciones sin imagen usan el ancho completo en los listados.

## 2026/05/14

- El índice de la barra lateral de las publicaciones ahora tiene _scroll_ propio cuando es muy largo.

## 2026/04/28

- La [función `abrir_publicacion_reciente()`](https://github.com/bastianolea/blog-R/blob/master/R/funciones.R) permite elegir entre publicaciones creadas o modificadas recientemente (`modo = "creado"` o `"modificado"`) y la cantidad de opciones a mostrar, e incluye las carpetas del curso de introducción a R y de clases. Así puedo volver a trabajar en archivos recientes.

## 2026/04/25

- Nuevos _shortcodes_ para destacar publicaciones relacionadas, publicaciones de una etiqueta, y para invitar a [apoyar el blog con un cafecito](https://buymeacoffee.com/bastimapache).

## 2025/12/10

- Primeras funciones de R para trabajar en el blog, en [`R/funciones.R`](https://github.com/bastianolea/blog-R/tree/master/R/funciones.R): `abrir_post_reciente()` muestra las publicaciones modificadas más recientemente y abre el documento Quarto o Markdown de la que se elija.

## 2025/12/02

- Tema de colores personalizado para los bloques de código.
- El [buscador](/buscar/) incluye un resumen de cada publicación.

## 2025/11/30

- Barra lateral con índice en las publicaciones.

## 2025/11/15

- Nueva página de [código de conducta](/code-of-conduct/).

## 2025/11/11

- Primera versión del [buscador de publicaciones](/buscar/), una app Shiny que usa un índice en JSON generado por el blog.

## 2025/10/16

- Rediseño de la portada, la página del blog y las publicaciones, [con listas de etiquetas en la portada y en el blog](/blog/2025-10-16/).
- Página de [contacto](/contacto/) en castellano.
- Estadísticas de visitas con GoatCounter.

## 2024/11/03

- [Creación del blog](/blog/hugo_blog_nuevo/) con Hugo y el tema Hugo Apéro.
