---
title: Post sobre mi nuevo blog (este mismo)
author: Bastián Olea Herrera
format: hugo-md
date: 2024-11-07
tags:
  - quarto
  - blog
excerpt: "Post explicativo de cómo hice éste sitio web usando el tema Hugo Apéro. Describo los beneficios de Hugo, las dificultades que tuve para entender, y comentarios acerca de la importancia de tener un espacio web fuera de las grandes empresas que monopolizan la internet. La totalidad del código de este sitio web [está disponible en el repositorio `blog-r` en mi GitHub.](https://github.com/bastianolea/blog-r)"
links:
  - icon: github
    icon_pack: fab
    name: código
    url: https://github.com/bastianolea/blog-bastianolea-r
---

Éste es un post sobre este mismo blog. Quería compartir el proceso de creación del blog, porque me pareció interesante y entretenido.

Lo creé usando [Hugo](https://gohugo.io), un generador de sitios web estáticos de código abierto y gratuito. Hugo se puede usar a través de R usando `{blogdown}` y el tema [Hugo Apéro](https://hugo-apero.netlify.app), creado por [Alison Hill](https://www.apreshill.com), y así puedes crear páginas y publicaciones usando Quarto o RMarkdown. De ese modo resulta muy fácil integrar las cosas que hagas con R en tu sitio, compartiendo el código en los posts. 

La [guía para aprender a usar Hugo Apéro](https://hugo-apero-docs.netlify.app) y dejar tu blog operacional es muy amigable y sencilla de seguir! Lo recomiendo, solo me tomó una tarde. Tiene amplia documentación y recursos [en su repositorio.](https://github.com/hugo-apero/) También existe [el libro, _Create, Publish, and Analyze Personal Websites Using R and RStudio_](https://r4sites-book.netlify.app), que detalla todas las instrucciones de crear un sitio web con R y Hugo.

El sitio web se genera con `{blogdown}` dentro de un proyecto de R cada vez que hago un cambio en el código del sitio. Luego, cuando subo los cambios del sitio a GitHub, [Netlifly](https://www.netlify.com) detecta los cambios, reconstruye el sitio y lo re-publica en minutos. De esta forma, el proceso es de _despliegue continuo:_ cada cambio local que hago, al ser subido al [repositorio remoto,](https://github.com/bastianolea/blog-r) gatilla la reconstrucción del sitio y su actualización en la versión pública del sitio web. 

Si bien Netlify te da un dominio `.netlify.app`, opté por un dominio `.rbind.io` en [la página de Rbind](https://support.rbind.io/about/), una comunidad que engloba sitios y blogs sobre R bajo un mismo dominio. Además, `rbind.io` se ve más lindo que `netlify.app` 😌

La gracia de un sitio estático es que su contenido online no cambia, porque es un sitio web normal, y por lo tanto es liviano de cargar y debiese ser muy barato o gratis de hostear (no requiere de un servidor con capacidad computacional, como es el caso con las [aplicaciones Shiny](https://bastianolea.github.io/shiny_apps/)).

La totalidad del código de este sitio web [está disponible en el repositorio `blog-r` en mi GitHub.](https://github.com/bastianolea/blog-r)


## Sobre Hugo Apéro

Las [instrucciones de Hugo Apéro](https://hugo-apero-docs.netlify.app/start/) me parecieron fáciles de seguir, lo suficientemente sencillas para que cualquier persona sin experiencia en sitios web (yo) pueda seguirlas. Además, te presentan [ejemplos hermosos](https://hugo-apero-docs.netlify.app/project/) de otros blogs que usan el tema. 

_Lo bueno:_
- Muy simple de usar
- Resultados agradables y profesionales con nada de código
- Todo es 100% gratuito: el generador del sitio (Hugo), la IDE donde hago el sitio (RStudio), el lenguaje que uso para construir el sitio (R), el hosting (Netlify), y el dominio (Rbind).

_Lo malo_
- Poca flexibilidad
- No encuentro recursos para personalizar detalles
- Difícil de encontrar respuestas en internet

----

### Dificultades y soluciones
Algunas dificultades que tuve con el blog, y cómo las resolví:

#### Crear nuevas secciones
- El blog viene con secciones por defecto (_blog, talks, about, projects_), y me costó un poco entender [cómo crear nuevas o cambiarles el nombre](https://hugo-apero-docs.netlify.app/start/section-config/#renaming-sections) a las existentes.
- Luego entendí que las carpetas dentro de `content/` se vuelven en secciones si las llamas desde el archivo de configuración `config.yoml`, y que adquieren una apariencia por defecto, pero puedes camibiarla en el _front matter_ de cada una (el archivo `_index.md` dentro de `content/blog`, por ejemplo).

#### Carpeta static
- Carpeta con los elementos estáticos que se copian a public y que van a estar disponibles para el resto del sitio, como algunas imágenes

#### Carpeta public
- Al principio no entendía por qué tenía todo duplicado, pero luego entendí que `public` es una carpeta que se genera cada vez que actualizas el sitio, y su objetivo es ser literalmente el sitio al cual van a acceder las personas por su navegador web. Pero a esta carpeta sólo se le agregan cosas, no se eliminan, así que si subiste algo por error tienes que borrarlo manualmente de `public` (por ejemplo, yo subí una carpeta con 30 imágenes siendo que solo estaba usando una)
- Es seguro borrar todo el contenido de public, porque al guardar un cambio en tu sitio se re-escribe toda esta carpeta desde cero. Así evitas que queden recursos innecesarios en el sitio.

#### Redirects
- Las redirecciones sirven para que, luego de que consigas una nueva url para tu sitio `*.netlify.app`, puedas hacer que la gente que entre a la dirección `*.netlify.app` sea redireccionada automáticamente a tu nueva url. En mi caso, resirigí desde [bastianoleah.netlify.app](bastianoleah.netlify.app) a [https://bastianolea.rbind.io](https://bastianolea.rbind.io). El dominio que usé para este sitio, _rbind.io_, es un [servicio de la comunidad R](https://support.rbind.io/about/) de "unir" blogs y sitios webs de usuarios/as de R, y puedes pedir en su repositorio que te cedan un subdominio para que lo uses para tu blog.
- Es muy fácil [especificar redirecciones](https://yihui.org/en/2017/11/301-redirect/#another-application-redirect-netlify-com-to-your-own-domain) creando un archivo llamado `_redirects` en `static`: link original y redirección.
- Así evitas que los usuarios entren sin `https` a tu sitio, y que si entran a una url interna o antigua se les lleve a la url nueva.

#### Quarto documents para crear posts en tu blog
- Para crear un post a partir de un documento Quarto, solamente tienes que poner en el `yaml` del documento quarto `format: hugo-md`. De este modo, el documento se va a renderizar en formato markdown, y si se llama `index.md`, va a aparecer como un post.
- Usar Quarto te permite usar `{shiny}` para construir HTML para tu sitio (por ejemplo, usando `div()` y otras funciones de Shiny).
- En los chunks donde uses Shiny debes ponerles `#| output: asis` para que su resultado salga como HTML y se vea en el sitio.

#### Cambiar textos del formulario de contacto
- El [formulario de contacto](/contacto/) aparece en inglés por defecto, y con texto rellenado en los campos (malo para la usabilidad), pero se puede cambiar directamente, modificando el archivo `themes/hugo-apero/layouts/partials/shared/contact-form.html`.

#### Traducir elementos del sitio
- Hay varios elementos de texto del sitio que vienen por defecto en inglés, pero pueden ser traducidos si abres los archivos html y modificas `<p>El texto dentro de los tags</p>`. Los archivos están en `themes/hugo-apero/layouts/`.

#### Cambiar formatos de las fechas
- Hay que navegar los archivos del tema del sitio, en `themes/hugo-apero/layouts/`, y buscar los elementos que contienen la fecha así: `{{ .PublishDate.Format "January 2, 2006" }}`, y cambiarlos por el formato de fecha que prefieras, consideando que el día, mes y año deben ser los que salen en ese formato (2 de enero de 2006). Yo los dejé así: `{{ .PublishDate.Format "2/1/2006" }}`

#### Modificar el `css`
- En la carpeta `assets/scss/` puedes modificar los archivos `.scss` para alterar manualmente la apariencia de tu sitio. Personalmente cambié el archivo `assets/scss/_code.scss` para modificar la apariencia de los outputs de consola, para que tuvieran fondo oscuro y color distinto, con el siguiente código:
```css
.pre {
overflow-x: auto;
overflow-y: hidden;
overflow:   scroll;
background-color: #232137 !important;
color: #8A75A3 !important;
border: none !important;
border-radius: 6px !important;
font-weight: 200 !important;
font-size: 90% !important;
}
```

#### Crear un post nuevo
- Encontraba engorroso eso de crear un nuevo archivo `index.md` para cada post, porque tenía que copiar y pegar las etiquetas y código que van al inicio. Pero luego me di cuenta de que hay una función de `{blogdown}` que te crea posts nuevos:
```r
# crear un post
blogdown::new_post(title = "Nubes aleatorias en ggplot", 
subdir = "blog/",
file = "blog/ggplot_nubes/index.md", # define el "slug", la dirección url del post
author = "Bastián Olea Herrera",
tags = c("ggplot2", "gráficos", "curiosidades")
)
```

#### Hacer que se vean las etiquetas en el titular de cada post
- Si bien las etiquetas o tags de los posts aparecen al final de cada uno, yo quería que aparecieran debajo de la fecha, en el titular de cada publicación. [Siguiendo este tutorial,](https://www.jakewiesler.com/blog/hugo-taxonomies) encontré el archivo que hay que editar, y el código que era necesario agregar:

En el archivo `themes/hugo-apero/layouts/_default/single.html`, que controla el diseño de todos los blog posts, agregar:

```html
{{ with .Params.tags }}
<dl class="f6 lh-copy">
<em><dd class="fw5 ml0">Tags: {{ range . }} <a href="{{ "tags/" | absURL }}{{ . | urlize }}">{{ . }}</a> {{ end }}</dd></em>
</dl>
{{ end }}
```
Le agregué itálicas al texto y la palabra "Tags", pero puedes poner lo que quieras.

Ahora lo que quiero es hacer que en la página de tags, que se crea en `themes/hugo-apero/layouts/taxonomy/taxonomy.html` aparezca el conteo de posts por etiqueta, y se cambia en `themes/hugo-apero/layouts/partials/shared/summary.html`, pero no me resulta 😔

#### Hacer que se vean las etiquetas de cada post en la lista de posts del blog
- Lo mismo que en el paso anterior, solamente que en el archivo `themes/hugo-apero/layouts/partials/shared/summary.html`, que es el que controla los "resúmenes" de cada post que aparecen en la [lista de publicaciones del blog.](/blog/) En este caso le saqué la palabra "Tags".


#### Ordenar una serie de posts por peso, mientras el resto del blog se ordene por fecha
- Las publicaciones normales de mi blog se ordenan por fecha, con los más nuevos arriba, que es el orden por defecto. Pero en otras categorías del blog, como la serie de [posts introductorios a R](/blog/r_introduccion/), quiero que se ordenen por _peso_; es decir, por una forma de ordenamiento arbitraria dado que las distintas publicaciones tienen un orden de lectura desde lo más básico a lo más avanzado, independiente de la fecha de publicación. Recordemos que una serie de posts no es más que una carpeta en `content/blog` dentro de la cual hay más posts; en este caso, una carpeta llamada `r_introduccion` donde están todas las publicaciones dentro de dicha serie, junto a un _front matter_ que hace que todas esas publicaciones sean parte de la serie "Introducción a R".
- Lo primero es entender cómo se construyen las listas de publicaciones en Hugo. Los archivos dentro de la carpeta `themes/hugo-apero/layouts/` son los que definen la construcción de cada página del sitio. Entre ellas, en `themes/hugo-apero/layouts/blog/`, los archivos que empiezan con `list` define en la construcción de las listas de publicaciones. Cada lista usa un _layout_ predefinido para construirse. Por ejemplo, y por defecto, en `content/blog/_index.md` se define que el blog se construye con `layout: list-sidebar`; es decir, el archivo `themes/hugo-apero/layouts/list-sidebar.html` construye la lista de publicaciones del blog.
- Comprendiendo lo anterior, si quiero tener una lista de publicaciones distinta, como la serie de posts introductorios a R ordenados por peso y no por fecha, tengo que crear un nuevo _layout_ y definir el _front matter_ (`_index.md`) de esa serie de publicaciones para que use el nuevo _layout_.
- En este _layout_, definimos que las publicaciones se ordenen por peso cambiando la siguiente línea: `{{ $paginator := .Paginate (where .RegularPagesRecursive "Type" "blog").ByWeight }}`. Originalmente decía `.ByDate.Reverse`; es decir, por fecha con más nuevos arriba. En el _front matter_ de la serie de posts definimos que el _layout_ sea `layout: list-sidebar-weight`, para que use el ordenamiento distinto.
- Y listo, ahora tienes dos _layouts_ para construir páginas de listas de posts, una ordenada por fecha y otra por peso, entonces el blog se ordena por fecha, pero la serie de posts que necesites puede ordenarse por peso si especificas que use el layout distinto al por defecto.


#### Separar logos de redes sociales de los ítems del menu superior
- Encontraba que los logos de redes sociales estaban muy pegados a el menú de páginas superior del blog, porque cuando uno ponía el Mouse encima de un ítem, el subrayado del ítem se ponía encima de los logos de redes sociales. El archivo `themes/hugo-apero/layouts/partials/header.html` construye el _header_ de todo el sitio, así que bastó con agregar un poco de css antes de `{{ partial "shared/social-links.html" . }}` para darle un poco más de espacio al rededor de los iconos y que se viera mejor. 

#### Crear _shortcodes_
- Los _shortcodes_ son atajos que puedes usar para insertar elementos en las publicaciones de tu blog. Como me gusta que las imágenes aparezcan con esquinas redondeadas y centradas en la página, en vez de aplicar este estilo CSS a cada imagen manualmente, creé un _shortcode_ que simplemente entrega la etiqueta de imagen HTML con el estilo deseado, sin necesidad de escribir HTML.

El código en los posts queda así: `{{</* imagen "imagen.jpeg"*/>}}`, y funciona porque en la carpeta `layouts/shortcodes/` tengo un archivo HTML llamado igual que el _shortcode_ (`imagen.html`), que contiene el siguiente código:

```html
<img src="{{.Get 0}}" style="border-radius: 7px; width: 80%; max-width: 700px; display: block; margin: auto; margin-bottom: 8px; margin-top: 8px;">
```

Donde `{{.Get 0}}` es el lugar donde se entrega el texto que se pone en el _shortcode_ la ruta de la imagen). Entonces, crear _shortcodes_ te permite reutilizar código para construir tu sitio; en este caso, el código para dar estilo a las imágenes, o por ejemplo para poner botones bonitos en el sitio. Lo bueno es que si actualizo el shortcode, en todas las páginas que lo usé se actualiza también.


#### Columnas

Saqué unos shortcodes para hacer columnas en los posts de Hugo desde [este ejemplo](https://roneo.org/shortcodes/#responsive-columns), y las [instrucciones de instalación están acá](https://roneo.org/en/hugo-install-shortcode-collection/), que en realidad consisten en descargar el repo y copiar los archivos `html` a `layouts/shortcodes/`.

----

### Consejos
Mantengo un archivo `.R` en el inicio del blog, donde tengo todos los comandos que uso regularmente para el sitio:

```r
blogdown::serve_site() # previsualizar sitio
blogdown::stop_server() # detener previsualización
blogdown::stop_server(); blogdown::serve_site() # reiniciar previsualización

# crear un post nuevo
blogdown::new_post(title = "Nubes aleatorias en ggplot", 
subdir = "blog/",
file = "blog/ggplot_nubes/index.md",
author = "Bastián Olea Herrera",
tags = c("ggplot2", "gráficos", "curiosidades")
)

# convertir script a Quarto
convertr::r_to_qmd(
input_dir = "~/R/servel_votaciones/pruebas/genero_candidatos_LLM.R",
output_dir = "~/R/blog/blog-r/content/blog/genero_nombres_llm/codigo.qmd"
)

# ver sitio en github
usethis::browse_github()
```

----

### Pendientes
Igual me quedaron algunas cosas pendientes que no he sabido resolver 😞 
- Traducir los meses, no encontré cómo cambiarlo 🙁 

----

## Conclusiones

Quizás voy a escribir un tutorial más detallado sobre cómo hacer un blog.

Creo que es importante tener un espacio en la web que sea realmente propio, sobre todo considerando que vivimos una época en que casi la totalidad de nuestra presencia online está a merced de grandes empresas (Meta con Instagram y Facebook, Microsoft con LinkedIn, Google con todo lo demás), que además operan en esquemas de mercantilización de nuestros datos. Un sitio web personal perdurará las decisiones o quiebres de las empresas en las que actualmente confiamos, y además nos permite volver un poco a la antigua web, donde las personas eran las dueñas del contenido, sin tener que conectar todo a trackers y plataformas privadas.

