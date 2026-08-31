---
title: 'Tutorial: crea páginas web y blogs con R+Quarto, y publícalos online con GitHub Pages'
author: Bastián Olea Herrera
date: '2025-03-27'
draft: false
slug: []
categories:
  - tutoriales
tags:
  - quarto
  - shiny
  - git
  - GitHub
excerpt: En este tutorial veremos cuatro formas relativamente sencillas para crear nuestros propios espacios en internet con R para poder compartir nuestras creaciones y aprendizajes, de forma completamente gratuita. ¡En una tarde podrías tener tu propio sitio web para presentarte, para subir las cosas que has aprendido, o para destacar tu trabajo!
---

{{< indice >}}

En este tutorial veremos cuatro formas relativamente sencillas, y ordenadas de menor a mayor dificultad, para crear nuestros propios espacios en internet para compartir nuestras creaciones, aprendizajes y quiénes somos usando R, y de forma completamente gratuita. 

**En una tarde podrías tener tu propio sitio web para presentarte, para subir las cosas que has aprendido, o para destacar tu trabajo!**

{{< aviso "Si quieres aprender a crear [documentos Quarto](/tags/quarto) desde cero, [revisa este tutorial!](/blog/quarto_reportes)" >}}

Los contenidos son:

1. [Crear repositorios en GitGub](#crear-un-repositorio-en-github-para-compartir-código-yo-datos)
2. [Crear documentos Quarto](#documentos-quarto)
3. [Crear páginas estáticas a partir de documentos Quarto con GitHub Pages](#documento-quarto-en-github-pages)
4. [Crear sitios web con Quarto](#sitios-web-quarto-en-github-pages)
5. [Crear blogs con Quarto](#blogs-quarto-en-github-pages)
6. [Crear blogs con Hugo Apéro](#blog-hugo)

{{< imagen afiche-featured.jpg >}}


----

Lo más probable es que todas las cosas que hemos aprendido sobre R y análisis de datos fueron porque alguna persona linda y bondadosa compartió gratuita y abiertamente lo que sabía o lo que creó, para que los demás se beneficien. Uno de los aspectos más positivos de la comunidad de usuarixs de R es su disposición a compartir y ayudar a los demás 💕 ¿Por qué no devolver la mano? 🥰

Antes que nada, todas las opciones de este tutorial requieren que sepas usar GitHub, para poder subir tus proyectos de R a GitHub. Así que, para empezar, te resumiré las instrucciones necesarias para hacerlo. Encuentra [instrucciones más detalladas sobre usar git y GitHub con R en este tutorial.](https://bastianolea.rbind.io/blog/tutorial_github/)

## Crear un repositorio en GitHub para compartir código y/o datos

Quizás la forma más sencilla de poder compartir en internet tus trabajos, desarrollos, o aprendizajes en R, es **creando un repositorio de código abierto** en GitHub. En los reposos dormitorios, las personas dan a conocer el código que producen, ofreciéndoselo a los demás para que puedan reutilizarlos en sus propios proyectos, ya sean utilidades, análisis de datos, clases o tutoriales, o incluso conjuntos de datos y paquetes de R.

En este primer paso del tutorial, aprenderemos a crear un repositorio local `git` para tus proyectos de R, y luego subir este repositorio local a un repositorio remoto en GitHub para poder compartirlo y que otrxs puedan encontrarlo.

### Conectar R a GitHub
- [Tutorial más detallado sobre esto escrito por mi](https://bastianolea.rbind.io/blog/tutorial_github/)
- Libro tutorial para aprender a usar git con R: [https://happygitwithr.com](https://happygitwithr.com)

Para poder crear tus reposos remotos, primero tenemos que darle permiso a tu sesión de R para conectarse a tu cuenta de GitHub. 

GitHub es una plataforma online donde las personas pueden subir sus repositorios de Git, permitiendo a otros acceder a su código, y contribuir a los repositorios, entre muchas otras funcionalidades.

El primer paso es instalar `{usethis}`, un [paquete de R](https://usethis.r-lib.org/) que automatiza muchas tareas repetitivas que se hacen al configurar tus proyectos.

```r
install.packages("usethis")
```

Gracias a este paquete, los siguientes pasos se vuelven mucho más sencillos:

**1. Configurar nombre de usuario y correo**
Luego, tienes que registrar cuál es tu cuenta de GitHub.
```r
usethis::use_git_config(user.name = "Basti", user.email = "baolea@uc.cl")
```

**2. Crear un _token_ en GitHub para permitir el acceso de R a tu cuenta**
Es necesario hacer esto para permitir que tu computador pueda usar tu cuenta de GitHub. Se hace por medio de _tokens_ para no tener que escribir tu contraseña. Es una medida más segura para poder iniciar sesión en un servicio online, porque además siempre puedes revocar la autorización desde tu cuenta de GitHub.
```r
usethis::create_github_token()
```
Se abrirá una ventana de GitHub en la que podrás generar y copiar el _token_. Ejecuta la siguiente función, y cuando la consola te lo indique, pega el _token_ que copiaste:
```r
gitcreds::gitcreds_set()
```

**4. Confirmar que está funcionando bien:**
Con la siguientes función obtendremos una especie de diagnóstico sobre la conexión con nuestra cuenta, para confirmar que todo esté funcionando bien.
```r
usethis::git_sitrep()
```


### Crear un repositorio local
Luego de haber configurado tu cuenta, puedes empezar a crear repositorios en tus proyectos de R. Recuerda que en cada proyecto puede haber un solo repositorio.
```r
usethis::use_git()
```
Al ejecutar este comando, tu consola indicará cuáles son los archivos modificados, y preguntará si quieres hacer _commit_ de tus archivos. _Commit_ significa agregar los archivos modificados a la versión del proyecto que guardaremos/respaldaremos.

De esta forma, activaste el control de versiones de `git` en tu proyecto de RStudio, lo que significa que tienes un repositorio local.

### Subir el repositorio local a GitHub
Luego de tener el repositorio local, ahora toca subirlo como repositorio remoto a GitHub, para poder compartirlo con otrxs.

```r
usethis::use_github()
```

Con este comando se creará un repositorio remoto en tu cuenta de GitHub con el mismo nombre que el proyecto, y se abrirá una ventana de tu navegador con el repositorio subido. Este repositorio puedes enviárselo a otras personas, [y ellos pueden clonar el repositorio](https://bastianolea.rbind.io/blog/tutorial_github/#clonar-un-repositorio-código-de-r-en-github) en sus propias sesiones de R para poder ejecutar tu mismo código.


### Crear un archivo `readme.md`

Si tu proyecto/repositorio tiene un archivo `readme.md`, aparecerá en GitHub como descripción del código. Puedes usar este documento para explicar más detalles acerca de lo que se trata el repositorio, dar instrucciones, especificar el orden de ejecución de los scripts, indicar tus fuentes, etc.

```r
usethis::use_readme()
```

Con el solo hecho de tener un archivo `readme.md` en tu repositorio ya cuentas con una especie de sitio web donde puedes explayarte y compartir cosas más detalladas. Si bien no es la forma más atractiva de hacerlo, cumple con la función básica de poder compartir tus creaciones con el resto de la comunidad! 💜

Si necesitas más información acerca del uso de git y GitHub con R, revisa el tutorial: [**Crear un repositorio Git para tu proyecto de R y comparte tu código en GitHub**](https://bastianolea.rbind.io/blog/tutorial_github/)

---- 



## Documentos Quarto 

Los [documentos Quarto](https://quarto.org/docs/get-started/hello/rstudio.html) combinan la escritura normal con el código. La escritura, como los párrafos, títulos, y subtítulos se escriben usando la sintaxis [markdown](https://quarto.org/docs/authoring/markdown-basics.html), un lenguaje de marcado que nos permite traducir textos en `html` usando sencillos símbolos.

{{< aviso "Si necesitas una guía más detallada para aprender a crear [documentos Quarto](/tags/quarto) desde cero, incluyendo la inclusión de código en reportes, personalización y más, [revisa este tutorial!](/blog/quarto_reportes)" >}}

Los reportes de Quarto suelen ser en formato PDF o HTML, siendo HTML el formato más recomendado, porque además de ser más compatible, permite ciertos elementos de interacción en tu reporte, como índices, barras de menú, pestañas, selectores, enlaces, y más.

Para crear un documento Quarto, en el menú _File_ elige _New File_ y luego _Quarto Document_.

{{< imagen "img/quarto_1.png" >}}

Se abrirá un documento de ejemplo que puedes usar como base para tus propios documentos. En este caso, agregamos un _chunk_ con un gráfico sencillo, y presionamos el botón **Render** para generar el documento en `html`:

{{< imagen "img/quarto_2.png" >}}

Como vemos, obtenemos tres archivos en nuestro proyecto: el archivo `.qmd` que contiene el código que genera el documento, el documento _renderizado_ en formato `html`, y una carpeta que contiene recursos necesarios para visualizar el documento:
{{< imagen "img/quarto_3.png" >}}

El problema es que esta carpeta, que contiene cosas como imágenes (de los gráficos), estilos y scripts, dificultan la portabilidad del documento y la posibilidad de compartirlo con otros.

La buena noticia es que podemos generar un reporte Quarto **autocontenido**; es decir, que no se requieran archivos externos al documento `html`. Agregamos el siguiente código al _header_ del documento Quarto, en reemplazo del `format: html`:

```yaml
format: 
  html:
    embed-resources: true
```
Hay que tener cuidado de que se respeten los espacios en blanco para que funcione bien. Si eliminas el reporte en `html` y la carpta `_files` y le das _render_ nuevamente al documento Quarto, verás que ahora se genera solamente el reporte en `html`, listo para poder ser compartido!

----


## Documento Quarto en GitHub Pages

Si tenemos un reporte en formato `html`, el salto a generar una **página web estática** que puedas compartir con otras personas es muy sencillo de hacer. Para esto, podemos usar [GitHub Pages](https://pages.github.com) para hacer que nuestro documento Quarto se transforme en una página de internet que otras personas pueden visitar tan sólo con entrar al enlace.

Con un reporte publicado como página web en GitHub Pages, en vez de enviar un documento por correo o similares, podremos hacer que el documento esté disponible en una dirección web fija para que otras personas puedan verlo en línea. 

**Beneficios:**

-   No necesitas enviar tu reporte como un archivo adjunto
-   No es necesario preocuparse si tu reporte contiene cientos de gráficos o es muy pesado, ya que estará online
-   Si necesitas modificar o actualizar algo de tu reporte, puedes hacer los cambios y actualizar tu reporte cuando quieras
-   Las personas que tengan el enlace tendrán siempre la versión actualizada de tu reporte
-   La publicación de tu reporte es automática: subes los cambios a GitHub y tu reporte se actualizará en unos minutos
-   El alojamiento online de tu reporte es gratuito

Para hacer esto, necesitamos configurar primero el documento Quarto, subir nuestro documento Quarto a un repositorio de GitHub, y configurar el repositorio para que genere una página web estática a partir del documento. Todas estas instrucciones están detalladas [en esta guía oficial](https://quarto.org/docs/publishing/github-pages.html), pero a continuación te resumo lo principal.

La configuración del documento Quarto consiste revisar el nombre del archivo, y en agregar un archivo de configuración a nuestro proyecto que hará que se guarden los archivos necesarios en una sola carpeta.

Esto es importante, porque así GitHub Pages sabrá que éste es el documento específico que queremos que sea nuestra página web.

Revisemos el *nombre del documento Quarto**. Para que nuestro documento Quarto se publique como una página GitHub Pages, debe llamarse `index.qmd` (para que se genere un documento `index.html`), o bien, puede llamarse como queramos, pero agregando el siguiente código al header `yaml` del documento Quarto:

```yaml
format: 
  html:
    output-file: "index"
```
De este modo, el documento `html` resultante de nuestro documento Quarto se llamará `index.html`. 

El siguiente paso de configuración implica agregar un **archivo de configuración** al proyecto. En el panel de archivos (_File_) de RStudio, presionamos el botón _New File_ y creamos un archivo de texto en blanco, llamado `_quarto.yml`:

{{< imagen "img/quarto_4.png" >}}

En `_quarto.yml`, pegamos el siguiente código de configuración:

```yaml
project:
  output-dir: docs
```

Con esta configuración le estamos pidiendo Quarto que guarde los recursos que necesita dentro de una carpeta `docs`, que es lo que necesitamos para generar nuestra página web.

Si le damos _render_ al documento Quarto, se generará la carpeta `docs` con los recursos necesarios dentro. 

Otra configuración que debemos crear para GitHub Pages se hace mediante la creación de un archivo vacío. En el proyecto desde RStudio creamos un nuevo archivo que se llame `.nojekyll`, y que esté vacío. Este archivo es para decirle a GitHub Pages que no procese el sitio con Jekyll, porque del sitio nos encargamos nosotres.

{{< imagen "img/nojekyll.png" >}}

Ahora tenemos que subir estos cambios al repositorio remoto GitHub. En la pestaña _Terminal_ de RStudio (al lado de la consola) ejecutamos los tres siguientes comandos:

```bash
git add .
git commit -m "documento quarto en docs"
git push
```

Con el primer comando le pedimos que todos los archivos nuevos sean considerados para el _commit_, con el segundo creamos el _commit_ y le damos un mensaje, y con el tercero hacemos _push_ para subir los cambios al repositorio remoto.

Si vamos a GitHub debiesen estar nuestros nuevos archivos arriba. Ahora vamos a configurar GitHub para que genere una página web a partir del documento Quarto. Vamos a la seccion _Settings_:

{{< imagen "img/quarto_5.png" >}}

Dentro de _Settings_, en el menú izquierdo vamos a _Pages_. Dentro de _Pages_, tenemos que seleccionar la rama del repositorio que queremos usar (usualmente _main_ o _master_), y especificar que queremos apuntar a la carpeta `/docs`. Luego presionamos _Save_.

{{< imagen "img/quarto_6.png" >}}

Se tomará unos segundos o minutos en generar la página web, pero luego aparecerá el siguiente mensaje que te permitirá acceder al sitio:

{{< imagen "img/quarto_7.png" >}}

¡Listo! Ahora puedes compartir tu página con todo el mundo. El enlace será algo como `https://usuario.github.io/repositorio/`

Ojo que con este método sólo podremos publicar un documento Quarto por repositorio.

Puedes ver las instrucciones completas para este proceso [en esta guía oficial.](https://quarto.org/docs/publishing/github-pages.html)


----


## Sitios web Quarto en GitHub Pages

Otra opción que tenemos para construir sitios más completos, pero también basados en documentos Quarto, donde podamos combinar texto y código, es [crear un sitio web Quarto.](https://quarto.org/docs/websites/)

Con esta modalidad de documentos Quarto podemos crear un sitio web con múltiples secciones, enlaces, página de presentación, y más, que te puede servir como un espacio en Internet para presentarte y que otras personas te encuentren, y puedan conocer tu trabajo y trayectoria.


### Crear el sitio web Quarto

Al crear un nuevo proyecto desde RStudio podemos elegir la opción _Quarto Website_:

{{< imagen "img/website_1.png" >}}

Se abrirán una nueva sesión de R y veremos que nuestro proyecto ya viene con varios archivos dentro. Primero que nada, presionemos _Render_ para previsualizar lo que tenemos como base:

{{< imagen "img/website_2.png" >}} 

El proyecto ya viene con un sitio web funcional, que podemos explorar. Viene con dos páginas por defecto, `index.qmd` y `about.qmd`. Ambas puedes modificarlas a tu gusto con el contenido que desees. 

Estas páginas aparecen en la barra de navegación (arriba del sitio web, o en el lado izquierdo si la pantalla/ventana es pequeña), para que tus usuarios puedan acceder a ellas.


### Agregar páginas a tu sitio

Para agregar nuevas páginas al sitio, simplemente creamos nuevos documentos Quarto normalmente (_New File_, _Quarto Document_). Para hacer que sean agregados a la barra de navegación, entra al archivo de configuración de tu sitio, `_quarto.yml`. En este archivo, verás la configuración general de tu sitio:

```yaml
website:
  title: "tutorial_sitio_web_quarto"
  navbar:
    left:
      - href: index.qmd
        text: Home
      - about.qmd
```

Esa es la lista de páginas de tu sitio web. Al igual como sale hecho con la página `about.qmd`, si agregas ahí el nombre de un documento Quarto nuevo, será agregado a la barra de navegación. 

Estas páginas también pueden ser enlaces a cualquier otro sitio web. Por ejemplo, si quieres agregar un enlace a tu GitHub o a alguna red social, haz lo siguiente:

```yaml
website:
  title: "tutorial_sitio_web_quarto"
  navbar:
    left:
      - href: index.qmd
        text: Home
      - about.qmd
      - icon: github
        href: https://github.com/bastianolea
      - icon: linkedin
        href: https://www.linkedin.com/in/bastianolea/
```

Los enlaces aparecerán con los logos de las redes sociales que definas! Sólo recuerda que los enlaces tienen que empezar con `https://`.


### Cambiar temas
Dentro del mismo documento `_quarto.yml` puedes cambiar el tema de tu sitio web, para darle un toque más personalizado. Puedes [elegir entre 25 temas, que puedes conocer en esta guía.](https://quarto.org/docs/output-formats/html-themes.html#overview)

```yaml
format:
  html:
    theme: lux
    css: styles.css
    toc: true
```

La página `about.qmd` [también puede personalizarse](https://quarto.org/docs/websites/website-about.html#templates).


### Publicar el sitio en GitHub Pages

Para publicar el sitio en GitHub Pages tenemos que seguir las mismas [instrucciones para publicar en GitHub Pages](https://quarto.org/docs/publishing/github-pages.html) que seguimos en el paso anterior:

Primero, en el archivo de configuración `_quarto.yml` agregamos `output-dir: docs` debajo de `project:` y hacemos _Render_ al documento `index.qmd`.

También podemos ejecutar `quarto render` desde la pestaña de Terminal para reconstruir el sitio completo.

En el proyecto desde RStudio, creamos un nuevo archivo vacío que se llame `.nojekyll`, para decirle a GitHub Pages que no procese el sitio con Jekyll. Si no haces esto, cuando entres a un post del blog te aparecerá un error 404! 😨

Luego debemos hacer que nuestro proyecto sea un repositorio git (`usethis::use_git()`) y subir el repositorio a GitHub (`usethis::use_github()`), o si ya era un repositorio git y ya estaba en GitHub, hacer `git add.`, `git commit -m "actualizacion"`, y `git push` desde la pestaña Terminal.

Una vez que subimos nuestros cambios al repositorio remoto, vamos al repositorio en GitHub, _Settings_, _Pages_, y configuramos el repositorio para que genere la página desde `/docs`:

{{< imagen "img/quarto_6.png" >}}

Siguiendo estas instrucciones ya tendrás tu sitio web básico listo! ¡Y gratis! 🥳 Ahora sólo falta hacerlo crecer agregando páginas, enlaces, y toda la información que quieras.

{{< imagen "img/website_3.png" >}}



----



## Blog Quarto en GitHub Pages

Una tercera opción para presentarte al mundo por internet usando Quarto es [crear un blog Quarto.](https://quarto.org/docs/websites/website-blog.html)

Un blog funciona casi igual que un sitio web Quarto, con la diferencia de que el contenido está centrado en múltiples documentos Quarto que poseen más metadatos que le permiten agruparlos en categorías, en base a etiquetas, y ordenarlos por fechas. De este modo, tendrás un sitio web de presentación pero al que además podrás ir subiéndole contenido periódicamente para ir compartiendo las cosas que haces. 

Recordemos que todo lo que hemos aprendido sobre R ha sido gracias a personas que han querido compartir lo que saben, así que anímate a compartir lo que aprendes y lo que has creado!


### Crear un blog Quarto

Crear un nuevo proyecto desde RStudio, elegimos la opción _Quarto Blog_:

{{< imagen "img/blog_1.png" >}}

De la misma forma que cuando creamos el sitio web Quarto, el proyecto aparecerá con los archivos necesarios para tener un blog mínimo. Si presionamos _Render_ podremos provisionar nuestro blog:

{{< imagen "img/blog_2.png" >}}


### Agregar posts al blog Quarto

El funcionamiento del blog es idéntico al del sitio web, con la distinción de que la idea es ir agregando publicaciones.

Dentro de la carpeta `posts` veremos que se encuentran las dos publicaciones de ejemplo que vienen con el proyecto. Si abrimos una de ellas, veremos que en su encabezado posee los metadatos que caracterizan a cada publicación:

```yaml
---
title: "Mi primera publicación en mi blog Quarto"
author: "Bastián Olea"
date: "2025-03-28"
categories: [noticias, R, programación]
image: "image.jpg"
---
```

Entonces, para crear una nueva publicación, creamos una carpeta dentro de `posts` (el nombre de la carpeta será la dirección de la publicación), y dentro de la carpeta creamos un documento Quarto llamado `index.qmd` con un encabezado que contenga título, autor, fecha, y etiquetas. 

También podemos crear un post:

```r
quarto::new_blog_post(title = "Título")
```

Si presionamos _Render_ para generar el post, veremos que en la previsualiazción del blog aparecen los cambios!

{{< imagen "img/blog_3.png" >}}


### Subir el blog Quarto a GitHub Pages

Nuevamente, las instrucciones para hacer que nuestro blog aparezca GitHub Pages son las mismas:

1. En `_quarto.yml` agregamos `output-dir: docs` debajo de `project:`.
2. En el proyecto, creamos un nuevo archivo que se llame `.nojekyll`, vacío (para decirle a GitHub Pages que no procese el sitio con Jekyll)
3. En la pestaña de terminal ejecutamos `quarto render` para construir el sitio completo.
3. Creamos un repositorio git (`usethis::use_git()`) 
4. Subimos el repositorio a GitHub (`usethis::use_github()`)
4. En GitHub, entramos a _Settings_, luego a _Pages_, y configuramos el repositorio para que genere la página desde `/docs`


Siguiendo estas instrucciones ya tendrás tu sitio web básico listo! ¡Y gratis! 🥳 Ahora sólo falta hacerlo crecer agregando páginas, enlaces, y toda la información que quieras.

{{< imagen "img/website_3.png" >}}

Instrucciones para subir a GitHub:
https://quarto.org/docs/publishing/github-pages.html#render-to-docs

Instrucciones para subir a Netlify:
https://beamilz.com/posts/2022-06-05-creating-a-blog-with-quarto/en/#deploy-with-netlify


----


## Blog Hugo
Un blog Hugo es otra forma de crear un blog desde R, que también utiliza documentos Quarto, pero cuyo sistema de construcción es distinto. Al ser [creados con Hugo,](https://gohugo.io) resultan sitios mucho más personalizables, pero por lo mismo también pueden ser más complejos de mantener.

Como ejemplo, [mi propio sitio web](https://bastianolea.rbind.io) lo creé con Hugo, y [detallé parte del proceso en un post](https://bastianolea.rbind.io/blog/hugo_blog_nuevo/).

Las instrucciones de este proceso se escapan un poco al objetivo de esta guía, pero les dejo el siguiente enlace, que corresponde al [tutorial oficial para crear un blog Hugo con el tema Apéro,](https://hugo-apero-docs.netlify.app/) que detalla paso por paso todas las acciones que hay que hacer para construir un blog con Hugo, personalizarlo, y publicarlo usando Netlify.

{{< imagen "img/hugo_0.png" >}}

Cabe mencionar que el tutorial mismo está construido en un blog Hugo Apéro.

También recomiendo [este libro, _Create, Publish, and Analyze Personal Websites Using R and RStudio_](https://r4sites-book.netlify.app), que detalla todas las instrucciones de crear un sitio web con R y Hugo.

En resumidas cuentas, las instrucciones son:
- Crear un nuevo proyecto de R
- `install.packages("blogdown")`
- `blogdown::install_hugo()`
- Y ejecutar lo siguiente para crear tu blog Hugo Apéro:

```r
library(blogdown)
new_site(theme = "hugo-apero/hugo-apero", 
           format = "toml",
           sample = FALSE,
           empty_dirs = TRUE)
```

Luego ejecutas `blogdown::serve_site()` para previsualizar el blog creado.

{{< imagen "img/hugo_1.png" >}}

Para crear un post nuevo, tenemos una conveniente función que nos ayuda:
```r
# crear un post
blogdown::new_post(title = "Nubes aleatorias en ggplot", 
                   subdir = "blog/",
                   file = "blog/ggplot_nubes/index.md", # define el "slug", la dirección url del post
                   author = "Bastián Olea Herrera",
                   tags = c("ggplot2", "gráficos", "curiosidades"))
```


----


## Apps Shiny
Las aplicaciones Shiny son formas mucho más avanzadas y flexibles para poder compartir desarrollos en R con el mundo. Se trata de aplicaciones web completamente personalizables y que además son interactivas; significa que detrás de la aplicación web existe un proceso de R que está haciendo los cálculos para entregar resultados en tiempo real a sus usuarios.

Acá te dejo dos tutoriales para aprender a usar Shiny:

- [Tutorial Shiny](https://bastianolea.rbind.io/blog/shiny//)
- [Tutorial publicar en Shinyapps](https://bastianolea.rbind.io/blog/shiny/#publicar-la-aplicación-en-internet/)

Y [comparto también un sitio mío](https://bastianolea.github.io/shiny_apps/) (creado con Quarto y alojado en GitHub Pages) para mostrar aplicaciones Shiny qeu he creado.

----

## Recursos:

- [Tutorial Git con R](https://happygitwithr.com)
- [Tutorial GitHub Pages](https://quarto.org/docs/publishing/github-pages.html)
- [Tutorial Quarto](/blog/quarto_reportes/)
- [Tutorial sitios web Quarto](https://quarto.org/docs/websites/)
- [Temas Quarto](https://quarto.org/docs/output-formats/html-themes.html#overview)
- [Tutorial Blog Quarto](https://beamilz.com/posts/2022-06-05-creating-a-blog-with-quarto/en/)
- [Tutorial Quarto y Netlifly](https://jadeyryan.com/blog/2024-02-19_beginner-quarto-netlify/)


----

_Este contenido fue impartido en el marco de una charla abierta organizada por el [Grupo de Usuarios de R de Madrid](https://www.meetup.com/es-ES/grupo-de-usuarios-de-r-de-madrid/events/306917174/?eventOrigin=group_upcoming_events). ¡Muchas gracias por invitarme!_

{{< cafecito >}}
